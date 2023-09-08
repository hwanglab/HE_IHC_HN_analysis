library(survival)
library(ranger)
library(ggplot2)
library(dplyr)
library(ggfortify)
library(survminer)
library(broom)
library(forestmodel)
#change the input csv file and marker list and name to save the file for LN and primary tumor
#change the marker list lso because for some of the markers in LN, the cox model is not converging
library(gtsummary)
library(magrittr)
library(tidyverse)

library(writexl)

#Use the following markers and csv for tumor 
df <- read.csv(file= 'all_markers_Tumor.csv')
region<-"Tumor"
marker_list<- c("CD163","CD20","CD3","CD4","CD45","CD8","ER.Alpha","ER.Beta","FoxP3","PD.L1","KRT.AE1AE3")

#use the following marker and csv for LN
# df <- read.csv(file = 'all_markers_LN.csv')
# marker_list<- c("CD163","CD20","CD3","CD4","CD8","ER.Alpha","FoxP3","PD.L1")
# region<-"LN"
head(df)
names(df)

df$CD163 <- factor(df$col_CD163_comb, 
                   levels=c("0","1","2","3"),
                   labels = c("IE","ID","IN CD163_low","IN CD163 high"))
df$CD20 <- factor(df$col_CD20_comb, 
                  levels=c("0","1","2","3"),
                  labels = c("IE","ID","IN CD20 low","IN CD20 high"))
df$CD3 <- factor(df$col_CD3_comb, 
                 levels=c("0","1","2","3"),
                 labels = c("IE","ID","IN CD3 low","IN CD3 high"))
df$CD4 <- factor(df$col_CD4_comb, 
                 levels=c("0","1","2","3"),
                 labels = c("IE","ID","IN CD4 low","IN CD4 high"))
df$CD45 <- factor(df$col_CD45_comb, 
                  levels=c("0","1","2","3"),
                  labels = c("IE","ID","IN CD45 low","IN CD45 high"))
df$CD8 <- factor(df$col_CD8_comb, 
                 levels=c("0","1","2","3"),
                 labels = c("IE","ID","IN CD8 low","IN CD8 high"))
df$ER.Alpha <- factor(df$col_ER.Alpha_comb, 
                      levels=c("0","1","2","3"),
                      labels = c("IE","ID","IN ER.Alpha low","IN ER.Alpha high"))
df$ER.Beta <- factor(df$col_ER.Beta_comb, 
                     levels=c("0","1","2","3"),
                     labels = c("IE","ID","IN ER.Beta low","IN ER.Beta high"))

df$FoxP3 <- factor(df$col_FoxP3_comb, 
                   levels=c("0","1","2","3"),
                   labels = c("IE","ID","IN FoxP3 low","IN FoxP3 high"))

df$PD.L1 <- factor(df$col_PD.L1_comb, 
                   levels=c("0","1","2","3"),
                   labels = c("IE","ID","IN PD.L1 low","IN PD.L1 high"))
df$KRT.AE1AE3 <- factor(df$col_KRT.AE1AE3_comb, 
                        levels=c("0","1","2","3"),
                        labels = c("IE","ID","IN KRT.AE1AE3 low","IN KRT.AE1AE3 high"))
#Dichotomize age and change data labels
df$sex <- factor(df$Male.Sex..1.Y., 
                     levels = c("0", "1"), 
                     labels = c("Female", "Male"))
df$pack <- factor(df$Pack.years..10..1.Y., 
                 levels = c("0", "1"), 
                 labels = c("<10", ">10"))
df$stage <- factor(df$AJCC.8th.Edition.Pathologic.Overall.Stage, 
                   levels = c("1","2","3"), 
                   labels = c("stage 1","stage 2","stage 3"))
df$ACE_score <- factor(df$Overall.ACE.27.Score, 
                   levels = c("0", "1","2","3"), 
                   labels = c("0", "1","2","3"))
df$treatment <- factor(df$Primary.Management, 
                       levels = c("1", "2","3"), 
                       labels = c("S", "S+R","S+R+C"))
head(df)


surv_object <- Surv(time = df$Years.to.Progression.or.Last.Follow.up, event = df$Case)
panels <- list(forest_panel(width = 0.005), 
               forest_panel(width = 0.1, display = variable, fontface = "bold", heading = "Variable"), 
               forest_panel(width = 0.1, display = if_else(reference,paste(level,"* "),level)), 
               forest_panel(width = 0.03, display=n, hjust = 1, heading = "N"), 
               forest_panel(width = 0.007, item = "vline", hjust = 0.1), 
               forest_panel(width = 0.65, item = "forest", hjust = 0.1, heading = "HR (95% CI)", linetype = "dashed", line_x = 0), 
               forest_panel(width = 0.007, item = "vline", hjust = 0.1), 
               forest_panel(width = 0.15, display = if_else(reference, " ", sprintf("%0.2f (%0.2f- %0.2f)", trans(estimate), trans(conf.low), trans(conf.high))), display_na = NA), 
               #### SEE BELOW FOR HEADER CHANGE TO P-VALUE
               forest_panel(width = 0.001, display = if_else(reference, "", if_else(p.value<0.01,format.pval(p.value, digits = 1, eps=0.001),format.pval(p.value,digits = 1,eps = 0.01))), display_na = NA, hjust = 1, heading = "p-val"),
               #forest_panel(width = 0.05, display = if_else(reference, "", format.pval(p.value, digits = 1, eps = 0.001)), display_na = NA, hjust = 1, heading = "p-value"), 
               ####
               forest_panel(width = 0.005))
# Fit a Cox proportional hazards model
#change the name for saving figures based on input 
for (i in 1:length(marker_list)){
  print(marker_list[i])
  fit.coxph <- coxph(as.formula(paste("surv_object~ sex + pack +stage + ACE_score +treatment +",marker_list[i])),
                   data = df) 
  tbl_regression(fit.coxph,exponentiate = TRUE) %>%
    gtsummary::as_tibble() %>% 
    writexl::write_xlsx(., paste0("tables/plot_", marker_list[i],"_",region,".xlsx"))

  temp_plot<-forest_model(fit.coxph,format_options = forest_model_format_options(colour = 'black',
                                                                                 color = NULL,
                                                                                 shape = 15,
                                                                                 text_size = 20,
                                                                                 point_size = 4,
                                                                                 banded = FALSE),panels,breaks = c(log(1,10)))
  ggsave(temp_plot, file=paste0("plots/plot_", marker_list[i],"_",region,".png"),height = 10,width = 14,dpi=500)
  dev.off()}



