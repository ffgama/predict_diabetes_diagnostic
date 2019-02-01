# teste local do modelo

# Etapa de criação do modelo
rm(list=ls())

# carga dos dados transformados
load("data/features_selection.RData")
head(data_select)

library(ROSE)

# unbalanced target variable (proportion)
prop.table(table(data_select$classe))

# over and undersampling
balanced_target <- ovun.sample(classe ~ ., data = data_select, method = "over",N = 680, seed = 1)$data

data_select_pos <- balanced_target

prop.table(table(data_select_pos$classe))
