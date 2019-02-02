setwd("GitHub/predict_diabetes_diagnostic/")

# Etapa de criação do modelo
rm(list=ls())

# carga dos dados transformados
load("data/features_selection.RData")
head(data_select)

balanced_target <- ovun.sample(classe ~ ., data = data_select, method = "both",N = 680, seed = 1)$data
data_select <- balanced_target

############################# Preparando para a submissão ao Kaggle ############################# 

library(mlr)

set.seed(123)

# criando as tasks
train_task <- makeClassifTask(data = data_select, target = "classe")

# # normalizando as variáveis
# train_task <- normalizeFeatures(train_task, method = "standardize" )

# removendo features 
# train_task <- dropFeatures(task = train_task, features = c("grossura_pele"))

rf <- makeLearner("classif.randomForest", predict.type = "prob", par.vals = list(mtry = 3, ntree = 200, importance = TRUE,
                                                                                 cutoff = c(0.6,0.4)))
getParamSet("classif.randomForest")

# gridsearch (parametros de tuning)
parameters <- makeParamSet(
  makeIntegerParam("ntree",lower = 50, upper = 500),
  makeIntegerParam("mtry", lower = 2, upper = 8),
  makeIntegerParam("nodesize", lower = 5, upper = 50)
)

control_tune <- makeTuneControlRandom(maxit = 100L)
# cv
cv <- makeResampleDesc("CV",iters = 10L)

rf_tune <- tuneParams(learner = rf, resampling = cv, task = train_task, par.set = parameters, control = control_tune, show.info = TRUE)

# using hyperparameters
rf_tuning <- setHyperPars(rf, par.vals = rf_tune$x)

# configurando os parâmetros de tuning 
rf <- mlr::train(rf_tuning, train_task)

# realizar as predições no dataset de teste do kaggle
data_test <- read.csv("data/dataset_teste.csv", header = TRUE, sep = ",")

# data_test <- normalizeFeatures(data_test, method = "standardize")

# passando o conjunto de teste para o modelo 
predict_rf<-predict(rf$learner.model, data_test)
predict_rf

# adequando para o formato do kaggle
df_predictions <- data.frame(id = cbind(1:length(predict_rf),as.data.frame(predict_rf)))
colnames(df_predictions) <- c("id", "classe")
head(df_predictions)
tail(df_predictions)

# gravando a saida
write.csv(df_predictions,file="submissoes/df_predictions_6.csv", row.names=FALSE)
