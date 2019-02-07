load("data/transforming_data.RData")

library(caret)
#definir os parâmetros adicionais do algoritmo 
control_rfe <- rfeControl(functions = rfFuncs, method = "repeatedcv", number=10, repeats = 5, verbose = FALSE)

# rodar o algoritmo RFE para encontrar o melhor conjunto de features
run_rfe <- rfe(open_data_transf[,-ncol(open_data_transf)], open_data_transf[,ncol(open_data_transf)], sizes = c((1:ncol(open_data_transf)-1)), 
               rfeControl = control_rfe) 

# melhores features 
predictors(run_rfe)

# plotar 
plot(run_rfe, type=c("g", "o"))

data_select <- open_data_transf

save(data_select, file = "data/features_selection.RData")