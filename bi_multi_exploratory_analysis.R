load("data/transforming_data.RData")

library(ggplot2)
library(gridExtra)

# num_gestacoes x classe
gestacoes_plot <- ggplot(open_data_transf, mapping = aes(x = classe, y = num_gestacoes, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# quem desenvolveu a doença normalmente apresenta um alto nível de glicose
glicose_plot <- ggplot(open_data_transf, mapping = aes(x = classe, y = glicose, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# existe pouca diferença entre a pressão sanguínea em pacientes com e sem diabetes. 
pressao_plot <- ggplot(open_data_transf, mapping = aes(x = classe, y = pressao_sanguinea, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# em geral a pele dos pacientes com diabetes é um pouco mais espessa.
gros_pele_plot <- ggplot(open_data_transf, mapping = aes(x = classe, y = grossura_pele, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

grid.arrange(gestacoes_plot, glicose_plot, pressao_plot, gros_pele_plot ,nrow=2, ncol = 2)

# pessoas diabeticas com valores mais altos de insulina
insulina_plot <- ggplot(open_data_transf, mapping = aes(x = classe, y = insulina, group = classe, fill = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# o bmi (indice de massa corporal) indica alto risco de diabetes. Pessoas diabéticas possuem um bmi superior em relação as que não foram 
# diagnosticadas com a doença
bmi_plot <- ggplot(open_data_transf, mapping = aes(x = classe, y = bmi, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# parece que o histórico de diabetes é algo que contribui para o diagnóstico de diabetes.
ind_historico_plot <- ggplot(open_data_transf, mapping = aes(x = classe, y = indice_historico, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

# a diabetes está mais distribuída entre os (jovens) adultos 
idade_plot <- ggplot(open_data_transf, mapping = aes(x = classe, y = idade, group = classe))+ 
  geom_boxplot(fill=c("#57A0D3","#C90D06"))+
  theme_minimal()

grid.arrange(insulina_plot, bmi_plot, ind_historico_plot, idade_plot ,nrow=2, ncol = 2)


# observando a distribuição de presença / ausência de diabetes por idade.  
hist(subset(open_data_transf, classe == 1)$idade, labels = TRUE, col = "red",  main = "Presença de diabetes")
hist(subset(open_data_transf, classe == 0)$idade, labels = TRUE, col = "blue", main = "Ausência de diabetes")

# Análise de correlação
library(corrplot)
corr_data <- cor(open_data_transf)
corrplot(corr_data, method="number")