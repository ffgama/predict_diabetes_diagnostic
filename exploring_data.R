# Etapa de exploração
rm(list=ls())

# carga dos dados transformados
load("data/transforming_data.RData")
head(open_data_transf)

library(ggplot2)

# quem desenvolveu a doença normalmente um maior número de gestações
ggplot(open_data_transf, mapping = aes(x = classe, y = num_gestacoes, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# quem desenvolveu a doença normalmente apresenta um alto nível de glicose (entre 140 e 199 mg/DL)
ggplot(open_data_transf, mapping = aes(x = classe, y = glicose, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# existe pouca diferença entre a pressão sanguínea em pacientes com e sem diabetes. 
ggplot(open_data_transf, mapping = aes(x = classe, y = pressao_sanguinea, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# a pele dos pacientes com diabetes é um pouco mais espessa. A grossura de pele em um paciente chegou próximo a 100 (seria um outlier?)
ggplot(open_data_transf, mapping = aes(x = classe, y = grossura_pele, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# pessoas com diabetes apresentam um valor de insulina elevado (acima de 200 especialmente). Em alguns casos de pessoas não diagnosticados o valor de 
# insulina passou dos 200.
ggplot(open_data_transf, mapping = aes(x = classe, y = insulina, group = classe, fill = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# observar a distribuição através de um histograma
par(mfrow = c(2, 1))
hist(subset(open_data_transf, classe == 1)$insulina, labels = TRUE, col = "red", main = "Presença de diabetes")
hist(subset(open_data_transf, classe == 0)$insulina, labels = TRUE, col = "blue", main = "Ausência de diabetes")

# o bmi (indice de massa corporal) indica alto risco de diabetes. Alguns individuos estão com indice muito superior acima de 60,
# o que pode indicar um outlier.
ggplot(open_data_transf, mapping = aes(x = classe, y = bmi, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# parece que o histórico de diabetes é algo que contribui para o diagnóstico de diabetes.
ggplot(open_data_transf, mapping = aes(x = classe, y = indice_historico, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# a diabetes é diagnosticada normalmente em pacientes entre 20 e 70 anos. Portanto está mais distribuída entre jovens adultos
# até idosos
ggplot(open_data_transf, mapping = aes(x = classe, y = idade, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

hist(subset(open_data_transf, classe == 1)$idade, labels = TRUE, col = "red",  main = "Presença de diabetes")
hist(subset(open_data_transf, classe == 0)$idade, labels = TRUE, col = "blue", main = "Ausência de diabetes")

# resetar a divisão de plots
par(mfrow=c(1,1))