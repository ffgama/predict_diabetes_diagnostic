load("data/features_selection.RData")

# tamanho dos dados para treino
size_sample <-  floor(0.7 * nrow(data_select))

# reproducibilidade
set.seed(123)
# particionamento aleatório
train_ind <- sample(seq_len(nrow(data_select)), size_sample)

# treino x teste
data_train <- data_select[train_ind, ]
data_test <- data_select[-train_ind, ]

library(mlr)
# criando as tasks
train_task <- makeClassifTask(data = data_select, target = "classe")

# # normalizando as variáveis
train_task <- normalizeFeatures(train_task, method = "standardize" )

# removendo a feature 
train_task <- dropFeatures(task = train_task,features = c("pressao_sanguinea"))


# construção do modelo
rf <- makeLearner("classif.randomForest", predict.type = "response", par.vals = list(mtry = 3, ntree = 200, 
                                                                                     importance = TRUE,
                                                                                     cutoff = c(0.61,0.39)))

# gridsearch (parametros de tuning)
parameters <- makeParamSet(
  makeIntegerParam("ntree",lower = 50, upper = 500),
  makeIntegerParam("mtry", lower = 2, upper = 8),
  makeIntegerParam("nodesize", lower = 10, upper = 50)
)

control_tune <- makeTuneControlRandom(maxit = 100L)
# cv
cv <- makeResampleDesc("CV",iters = 10L)

rf_tune <- tuneParams(learner = rf, resampling = cv, task = train_task, par.set = parameters, control = control_tune, show.info = TRUE)

# using hyperparameters
rf_tuning <- setHyperPars(rf, par.vals = rf_tune$x)

# configurando os parâmetros de tuning 
rf <- mlr::train(rf_tuning, train_task)

# realizar as predições a partir do dataset de teste 
data_test <- read.csv("data/dataset_teste.csv", header = TRUE, sep = ",")
# normalização
data_test <- normalizeFeatures(data_test, method = "standardize")

# passando o conjunto de teste para predição  
predict_rf<-predict(rf$learner.model, data_test)

# adequando para o formato do kaggle
df_predictions <- data.frame(id = cbind(1:length(predict_rf),as.data.frame(predict_rf)))
colnames(df_predictions) <- c("id", "classe")

# resultado
df_predictions