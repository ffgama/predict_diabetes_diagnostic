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



#create a list of learners using algorithms you'd like to try out
lrns = list(
  makeLearner("classif.randomForest", id = "Random Forest", predict.type = "prob"),
  makeLearner("classif.rpart", id = "RPART", predict.type = "prob"),
  makeLearner("classif.xgboost", id = "xgBoost", predict.type = "prob"),
  makeLearner("classif.kknn", id = "KNN"),
  makeLearner("classif.lda", id = "LDA"),
  makeLearner("classif.ksvm", id = "SVM"),
  makeLearner("classif.PART", id = "PART"),
  makeLearner("classif.naiveBayes", id = "Naive Bayes"),
  makeLearner("classif.nnet", id = "Neural Net", predict.type = "prob")
)

rdesc = makeResampleDesc("CV", iters = 10, stratify = TRUE)

meas = list(acc, timetrain)

bmr <- benchmark(lrns, train_task, rdesc, meas, show.info = FALSE)

rf_perf <- round(bmr$results$data_train$`Random Forest`$aggr[[1]],2) * 100
rf_perf

library(dplyr)

performances <- getBMRAggrPerformances(bmr, as.df = TRUE) %>%
  select(ModelType = learner.id, Accuracy = acc.test.mean) %>%
  mutate(Accuracy = round(Accuracy, 4)) %>%
  arrange(desc(Accuracy))

first_three <- round(performances$Accuracy[1:3],2) * 100
first_three


#customize the text tables for consistency using HTML formatting
my_kable_styling <- function(dat, caption) {
  kable(dat, "html", escape = FALSE, caption = caption) %>%
    kable_styling(bootstrap_options = c( "condensed", "bordered"),
                  full_width = FALSE)
}

library(kableExtra)
performances %>%
  my_kable_styling("Validation Set Model Comparison")
