# teste local do modelo

# Etapa de criação do modelo
rm(list=ls())

# carga dos dados transformados
load("data/features_selection.RData")
head(data_select)

# library(ROSE)
# #
# # método de over e undersampling
# balanced_target <- ovun.sample(classe ~ ., data = data_select, method = "both",N = 680, seed = 1)$data
# data_select <- balanced_target


library(beepr)
library(mlr)

# tamanho dos dados para treino
size_sample <-  floor(0.7 * nrow(data_select))

set.seed(123)
# particionamento aleatório
train_ind <- sample(seq_len(nrow(data_select)), size_sample)

# training x test
data_train <- data_select[train_ind, ]
data_test <- data_select[-train_ind, ]

# criando as tasks
train_task <- makeClassifTask(data = data_train, target = "classe")
test_task <- makeClassifTask(data = data_test, target = "classe")

# # normalizando as variáveis
train_task <- normalizeFeatures(train_task, method = "standardize" )
test_task <- normalizeFeatures(test_task, method = "standardize")

im_feat <- generateFilterValuesData(train_task, method = c("information.gain","chi.squared"))
#plotFilterValues(im_feat,n.show = 20)

# removendo features 
# train_task <- dropFeatures(task = train_task,features = c("grossura_pele"))

g.gbm <- makeLearner("classif.gbm", predict.type = "prob")
getParamSet("classif.gbm")


# gridsearch (parametros de tuning)
gbm_par<- makeParamSet(
  makeDiscreteParam("distribution", values = "bernoulli"),
  makeIntegerParam("n.trees", lower = 100, upper = 1000), #number of trees
  makeIntegerParam("interaction.depth", lower = 2, upper = 10), #depth of tree
  makeIntegerParam("n.minobsinnode", lower = 10, upper = 80),
  makeNumericParam("shrinkage",lower = 0.01, upper = 1)
)

rancontrol <- makeTuneControlRandom(maxit = 50L)

set_cv <- makeResampleDesc("CV",iters = 10L)

tune_gbm <- tuneParams(learner = g.gbm, task = train_task,resampling = set_cv,measures = acc,par.set = gbm_par,control = rancontrol)


# using hyperparameters
final_gbm <- setHyperPars(learner = g.gbm, par.vals = tune_gbm$x)

# configurando os parâmetros de tuning 
to.gbm <- mlr::train(final_gbm, train_task)

# passando o conjunto de teste para o modelo 
pr.gbm <- predict(to.gbm, test_task)
pr.gbm

df <- data.frame(pr.gbm$data)

# definindo a classe positiva como 1 (com diabetes)
# avaliar os resultados
library(caret)
confusionMatrix(df$response, df$truth, positive = levels(df$truth)[2])

# avaliando onde o modelo está errando 
# df_error <- df[df$truth != df$response, ]
# df_error
# 
# # selecionar as instâncias que o modelo errou
# data_select_error <- data_select[df_error$id,]
# data_select_error

beep()






caret::roc.curve(df$truth, df$response, plotit = F)

