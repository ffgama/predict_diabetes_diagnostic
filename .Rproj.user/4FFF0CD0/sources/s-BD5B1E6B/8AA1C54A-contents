# Etapa de transformação
rm(list=ls())

# carga dos dados
load("data/load_data.RData")

# tamanho do dataset
dim(open_data)

# estrutura do dataset
str(open_data)

# verificando valores ausentes
sapply(open_data, function(x) sum(is.na(x)))

# resumo estatístico 
summary(open_data)

par(mfrow = c(2, 2))
# numero de gestacoes
box_gestacoes <- boxplot(open_data$num_gestacoes,  col = rgb(0.75,0.75,0.75))
title("Distribuição do número de gestações")

# concentracao de glicose
box_glicose <- boxplot(open_data$glicose,  col = rgb(0.75,0.75,0.75))
title("Distribuição da concentração de glicose")

# pressao arterial  diastolica
box_pressao_sanguinea <- boxplot(open_data$pressao_sanguinea ,  col = rgb(0.75,0.75,0.75))
title("Distribuição da pressão arterial")

# espessura da dobra da pele
box_grossura_pele <- boxplot(open_data$grossura_pele ,   col = rgb(0.75,0.75,0.75))
title("Distribuição da grossura da pele")

par(mfrow = c(2, 2))
# insulina
box_insulina <- boxplot(open_data$insulina ,  col = rgb(0.75,0.75,0.75))
title("Distribuição de insulina")

# indice de massa corporal 
box_bmi<- boxplot(open_data$bmi ,  col = rgb(0.75,0.75,0.75))
title("Distribuição de massa corporal")

# indice de historico de diabetes
box_indice_historico<- boxplot(open_data$indice_historico ,  col = rgb(0.75,0.75,0.75))
title("Distribuição de indice de histórico de diabetes")

# idade em anos
box_idade<- boxplot(open_data$idade ,  col = rgb(0.75,0.75,0.75))
title("Distribuição de idade")

par(mfrow = c(1,1))
# distancia de cook para descobrir possíveis outliers
# considera outras variáveis para decidir se uma instância é ou não um outlier

# checar a presença de outliers
# model_lm <- lm(classe ~ ., data=open_data)
# distance_cook <- cooks.distance(model_lm)
# 
# # plotar a distancia de cook
# plot(distance_cook, pch="*", cex=2, main="Distância de cook")  
# 
# # adicionar limiar (threshold)
# abline(h = 4*mean(distance_cook, na.rm=T), col="red")
# 
# # definir os rótulos
# text(x=1:length(distance_cook)+1, y=distance_cook, labels=ifelse(distance_cook>4*mean(distance_cook, na.rm=T),names(distance_cook),""), col="red")
# 
# # número de linhas influentes
# influential <- as.numeric(names(distance_cook)[(distance_cook > 4*mean(distance_cook, na.rm=T))])  
# 
# # observações influentes
# head(open_data[influential, ])  
# 
# # removendo 
# open_data <- open_data[-c(influential),]

# normalização
# open_data_scale <- scale(open_data[,-ncol(open_data)])
# open_data_transf <- data.frame(cbind(open_data_scale), classe = open_data[,ncol(open_data)])
# head(open_data_transf)

open_data_transf <- open_data[,-c(1)]

save(open_data_transf, file = "data/transforming_data.RData")