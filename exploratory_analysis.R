load("data/load_data.RData")

par(mfrow = c(2, 2))

# numero de gestacoes
box_gestacoes <- boxplot(open_data$num_gestacoes,  col = rgb(0.75,0.75,0.75))
title("Distribuição do número de gestações")

# concentracao de glicose
box_glicose <- boxplot(open_data$glicose,  col = rgb(0.75,0.75,0.75))
title("Distribuição da concentração de glicose")
open_data[open_data$glicose == 0,]$glicose <- NA

# pressao arterial  diastolica
box_pressao_sanguinea <- boxplot(open_data$pressao_sanguinea ,  col = rgb(0.75,0.75,0.75))
title("Distribuição da pressão arterial")
# pressão sanguinea igual a 0 não existe substituiremos pela mediana para não perder informação
open_data[open_data$pressao_sanguinea == 0,]$pressao_sanguinea <- NA

# espessura da dobra da pele
box_grossura_pele <- boxplot(open_data$grossura_pele ,   col = rgb(0.75,0.75,0.75))
title("Distribuição da grossura da pele")
open_data[open_data$grossura_pele == 0,]$grossura_pele <- NA

par(mfrow = c(2, 2))
# insulina
box_insulina <- boxplot(open_data$insulina ,  col = rgb(0.75,0.75,0.75))
title("Distribuição de insulina")
open_data[open_data$insulina == 0,]$insulina <- NA

# indice de massa corporal 
box_bmi<- boxplot(open_data$bmi ,  col = rgb(0.75,0.75,0.75))
title("Distribuição de massa corporal")
open_data[open_data$bmi == 0,]$bmi <- NA

# indice de historico de diabetes
box_indice_historico<- boxplot(open_data$indice_historico ,  col = rgb(0.75,0.75,0.75))
title("Distribuição de indice de histórico de diabetes")

# idade em anos
box_idade<- boxplot(open_data$idade ,  col = rgb(0.75,0.75,0.75))
title("Distribuição de idade")
