# Etapa de seleção de features
rm(list=ls())

# carga dos dados transformados
load("data/transforming_data.RData")
head(open_data_transf)

library(caret)

# definir os parâmetros adicionais do algoritmo 
control_rfe <- rfeControl(functions = rfFuncs, method = "repeatedcv", number=10, repeats = 5, verbose = FALSE)

# rodar o algoritmo RFE para encontrar o melhor conjunto de features
run_rfe <- rfe(open_data_transf[,-ncol(open_data_transf)], open_data_transf[,ncol(open_data_transf)], sizes = c((1:ncol(open_data_transf)-1)), 
               rfeControl = control_rfe) 

print(run_rfe)

# melhores features 
predictors(run_rfe)

# plotar 
plot(run_rfe, type=c("g", "o"))

# utilizando randomForest para quantificar a importância das variáveis
library(randomForest)

model_rf <- randomForest(classe ~ ., data = open_data_transf, importance = TRUE, ntree = 200)
model_rf

# resultados
importance(model_rf)

# plotando (rank) as variaveis importantes
varImpPlot(model_rf)

# variáveis selecionadas
data_select <- open_data_transf[ with(open_data_transf, colnames(open_data_transf) )]

save(data_select, file = "data/features_selection.RData")
