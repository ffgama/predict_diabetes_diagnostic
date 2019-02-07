load("data/load_data.RData")

library(DMwR)
# removendo a classe e o id
open_data_transf <- open_data[,-c(1, ncol(open_data))]
open_data_transf <- knnImputation(open_data_transf, k = 8)

# incluindo a classe novamente
open_data_transf$classe <- open_data$classe

save(open_data_transf, file="data/transforming_data.RData")