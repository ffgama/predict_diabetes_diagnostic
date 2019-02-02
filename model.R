setwd("GitHub/predict_diabetes_diagnostic/")

# Etapa de criação do modelo
rm(list=ls())

# carga dos dados transformados
load("data/features_selection.RData")
head(data_select)

# balanced_target <- ovun.sample(classe ~ ., data = data_select, method = "both",N = 680, seed = 1)$data
# data_select <- balanced_target

############################# Preparando para a submissão ao Kaggle ############################# 

library(mlr)

set.seed(123)

# criando as tasks
train_task <- makeClassifTask(data = data_select, target = "classe")

# # normalizando as variáveis
train_task <- normalizeFeatures(train_task, method = "standardize" )

# removendo features 
# train_task <- dropFeatures(task = train_task, features = c("grossura_pele"))

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

# realizar as predições no dataset de teste do kaggle
data_test <- read.csv("data/dataset_teste.csv", header = TRUE, sep = ",")

data_test <- normalizeFeatures(data_test, method = "standardize")

# passando o conjunto de teste para o modelo 
predict_lda<-predict(lda$learner.model, data_test)
predict_lda

# adequando para o formato do kaggle
df_predictions <- data.frame(id = cbind(1:length(predict_lda$class),as.data.frame(predict_lda$class)))
colnames(df_predictions) <- c("id", "classe")
head(df_predictions)
tail(df_predictions)

# gravando a saida
write.csv(df_predictions,file="submissoes/df_predictions_7.csv", row.names=FALSE)
