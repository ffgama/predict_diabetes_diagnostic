# kaggle competition: predicting diabetes in patients

open_data <- read.csv("data/dataset_treino.csv", header = TRUE, sep = ",")
head(open_data)

dim(open_data)

str(open_data)

sapply(open_data, function(x) sum(is.na(x)))

summary(open_data)

save(open_data, file = "data/load_data.RData")