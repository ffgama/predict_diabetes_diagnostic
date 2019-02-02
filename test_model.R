# teste local do modelo

# Etapa de criação do modelo
rm(list=ls())

# carga dos dados transformados
load("data/features_selection.RData")
head(data_select)

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

# removendo features 
# train_task <- dropFeatures(task = train_task,features = c("grossura_pele"))

lda <- makeLearner("classif.lda", predict.type = "prob", method = "t", nu = 10)

getParamSet("classif.lda")

# gridsearch (parametros de tuning)
parameters <- makeParamSet(
  makeNumericLearnerParam("nu", lower = 2, upper = 40)
)

control_tune <- makeTuneControlRandom(maxit = 100L)

# cv
cv <- makeResampleDesc("CV",iters = 10L)

lda_tune <- tuneParams(learner = lda, resampling = cv, task = train_task, par.set = parameters, control = control_tune)

# using hyperparameters
lda_tuning <- setHyperPars(lda, par.vals = lda_tune$x)

# configurando os parâmetros de tuning 
lda <- mlr::train(lda_tuning, train_task)
getLearnerModel(lda)

# passando o conjunto de teste para o modelo 
predict_lda<-predict(lda, test_task)
predict_lda

df <- data.frame(predict_lda$data)
head(df)

## controlando o threshold
table(ifelse(df$prob.1 > .4, 1, 0))

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

roc.curve(df$truth, df$response, plotit = F)

