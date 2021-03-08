#### Cell Proliferation ####
library(ggplot2)
library(plyr)
library(ggsignif)

df = read.csv("Cell_counting.csv", header=TRUE)

# https://www.datanovia.com/en/lessons/ggplot-error-bars/
# http://www.sthda.com/english/wiki/ggplot2-error-bars-quick-start-guide-r-software-and-data-visualization

#### Standard error ####
# http://www.cookbook-r.com/Manipulating_data/Summarizing_data/
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}

# http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/
tgc <- summarySE(df, measurevar="Counts_M", groupvars=c("Hours","Treatment"))
tgc

pdf(file = "Cell_counting.pdf", width = 4, height = 4, family = "Helvetica")
ggplot(tgc, aes(x=Hours, y=Counts_M, colour=Treatment)) + 
  geom_errorbar(aes(ymin=Counts_M-se, ymax=Counts_M+se), colour="black", width=.1, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3, shape=21, fill="white") + # 21 is filled circle
  xlab("Time (Hours)") +
  ylab("Cell Number (Millions)") +
  scale_colour_hue(name="Treatment Type",    # Legend label, use darker colors
                   breaks=c("LOC", "WT"),
                   labels=c("LOC105373085", "Wide Type"),
                   l=40) +                    # Use darker colors, lightness=40
  expand_limits(y=0) +                        # Expand y range
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+ 
  scale_fill_discrete(guide=FALSE)+
  theme_bw(base_size = 12) +
  theme(legend.direction = 'vertical', legend.position = c(0.5, 0.8), panel.grid.major = element_blank(), 
        panel.border = element_rect(color = "black", size = 1.25), axis.ticks = element_line(size = 1.25), axis.title=element_text(size=12),
        legend.key = element_blank(), panel.grid.minor = element_blank(), legend.title = element_text(size=12), legend.key.size=unit(1.5, "line"),
        axis.text = element_text(color = "black", size=12), legend.background = element_blank(), legend.text=element_text(size=12))+
  annotate("text", x = 142, y = 8, label = "*") +
  annotate("text", x = 166, y = 14, label = "***")
dev.off()
