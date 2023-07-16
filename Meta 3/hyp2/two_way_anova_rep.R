# Two Way ANOVA Repeated Measures

# Load libraries
library(tidyverse)
library(ggpubr)
library(rstatix)
library(nortest)

# Needed by Afex
library(afex)
library(emmeans)
library(performance)

# Multiple Imputation
library(mice)
library(mitml)

# Aligned Rank Transformation ANOVA
library(ARTool)

w <- 620
h <- 360

# Set Working Directory
setwd("/home/jekyll/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/Trabalho/hyp_1/two_way_anova_rep")


# Read data
df <- read.csv("new_results_paired.csv")

# Data Pre-processing
data <- df[df$vertices>=100&df$vertices<=250&df$probability==0.1, ]
data$seed <- factor(data$seed)
data$vertices <- factor(data$vertices)
data$probability <- factor(data$probability)
data$algorithm <- factor(data$algorithm)

# Apply Two Way ANOVA Repeated Measures Using base R
aov.out <- aov(time ~ vertices*algorithm + Error(seed/algorithm), data=data)

# Summary
summary(aov.out)

# Assumptions of Two-way ANOVA Repeated Measures
# Verify the Residuals' Normality
qqnorm(residuals(aov.out$seed))
qqline(residuals(aov.out$seed))

qqnorm(residuals(aov.out$`seed:algorithm`))
qqline(residuals(aov.out$`seed:algorithm`))


# Verify the Variance's Sphericity



# Two-way ANOVA Repeated Measures para a primeira Hipótese
aov_rm <- aov_car(time ~ vertices*algorithm + Error(seed/algorithm), data=data, fun_aggregate=mean, 
                  factorize=TRUE, na.rm=TRUE, include_aov=TRUE)#, anova_table=list(correction = "none", es = "none"))

aov_rm2 <- aov_ez(id="seed", dv="time", data=data, 
                  between=c("vertices"), within=c("algorithm"), fun_aggregate=mean, factorize=TRUE, na.rm=TRUE, print.formula=TRUE, include_aov=TRUE)

summary(aov_rm)

# Verifica a normalidade dos resíduos
r <- residuals(aov_rm, append=T)

png("residuals.png", width=w, height=h)
qqnorm(r$.residuals)
qqline(r$.residuals)
invisible(dev.off())

ad.test(r$.residuals)

# Verifica a sphericity da variância
test_sphericity(aov_rm)
check_sphericity(aov_rm)

# Three-way ANOVA Repeated Measures para a segunda hipótese
aov_rm2 <- aov_car(time ~ vertices*probability*algorithm + Error(seed/algorithm), data=data2, fun_aggregate=mean, 
                  factorize=TRUE, na.rm=TRUE, include_aov=TRUE)#, anova_table=list(correction = "none", es = "none"))
summary(aov_rm2)



m <- art(time ~ vertices*algorithm + Error(seed/algorithm), data=data)
summary(m)
anova(m)
vignette("art-contrasts")