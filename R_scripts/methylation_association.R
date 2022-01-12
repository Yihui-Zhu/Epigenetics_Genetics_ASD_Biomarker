### methylation association ####
library("readxl")
library(dplyr)
library(ggplot2)
library(tidyverse)

Discovery = read_excel("tables/Discovery_sample_info.xlsx", sheet = 1)

model1 = resid(lm(chr22q_block ~ birthweight + nRBC, data = Discovery))
model1 = as.data.frame(model1)
Discovery$chr22q_block_adj = model1$model1

wilcox.test(chr22q_block ~ Diagnosis, data=Discovery) 

pdf(file = "figure/Discovery_22q_block_boxplot.pdf", width = 4, height =4, family = "Helvetica")
myylabels <- c(expression(paste("22q13.33 Block % Methylation")))
myxlabels <- c(expression(paste("Diagnosis")))
ggplot(Discovery_22q_smooth_sample_summary, aes(x=Diagnosis, y=chr22q_block_adj, fill=Diagnosis)) + 
  geom_boxplot(position=position_dodge(0.8))+
  geom_dotplot(binaxis='y', stackdir='center', dotsize=0.8,
               position=position_dodge(0.8))+
  scale_fill_manual(values = c('darkturquoise',"brown2", "yellow")) +
  labs(y=myylabels,x=myxlabels) + 
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+ 
  scale_fill_discrete(guide=FALSE)+
  theme_bw(base_size = 12) +
  theme(legend.direction = 'vertical', legend.position = c(0.9, 0.75), panel.grid.major = element_blank(), 
        panel.border = element_rect(color = "black", size = 1.25), axis.ticks = element_line(size = 1.25), axis.title=element_text(size=12),
        legend.key = element_blank(), panel.grid.minor = element_blank(), legend.title = element_text(size=12), legend.key.size=unit(1.5, "line"),
        axis.text = element_text(color = "black", size=12), legend.background = element_blank(), legend.text=element_text(size=12))+
  scale_fill_manual(values=c('brown2',"darkturquoise"))+
  theme(legend.position = "none")
dev.off()




