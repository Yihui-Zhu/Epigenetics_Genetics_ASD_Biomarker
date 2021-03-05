##### triangle heatmap: correlation matrix ###
library(ggdendro)
library(ggplot2)
library(reshape2)
library(grid)
library(scales)
library(plyr)
library(reshape)
library(ggbiplot)
library(ggplot2)
library(extrafont)

Meth_Diag_22q = read.csv("Meth_Diag_22q_smooth.csv", header=TRUE)
head(Meth_Diag_22q)

# http://www.sthda.com/english/wiki/ggplot2-quick-correlation-matrix-heatmap-r-software-and-data-visualization

mydata <- Meth_Diag_22q
cormat <- round(cor(mydata),2)
melted_cormat <- melt(cormat)

# Get lower triangle of the correlation matrix
get_lower_tri<-function(cormat){
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}
# Get upper triangle of the correlation matrix
get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}

upper_tri <- get_upper_tri(cormat)
upper_tri

# Melt the correlation matrix
library(reshape2)
melted_cormat <- melt(upper_tri, na.rm = TRUE)
melted_cormat[is.na(melted_cormat)] <- 0
# Heatmap
library(ggplot2)
ggplot(data = melted_cormat, aes(variable, X , fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1))+
  coord_fixed()

