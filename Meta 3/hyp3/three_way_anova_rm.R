# Three Way ANOVA Repeated Measures

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
setwd("/home/jekyll/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/Trabalho/hyp_2/three_way_anova_rm")

# Read data
df <- read.csv("new_results_paired.csv")

# Data Pre-processing
data <- df[df$probability>0.1, ]
data$seed <- factor(data$seed)
data$vertices <- factor(data$vertices)
data$probability <- factor(data$probability)
data$algorithm <- factor(data$algorithm)

# Two-way ANOVA Repeated Measures using aov_car
aov_rm <- aov_car(time ~ vertices*probability*algorithm + Error(seed/algorithm), data=data, fun_aggregate=mean, 
                  factorize=TRUE, na.rm=TRUE, include_aov=TRUE)#, anova_table=list(correction = "none", es = "none"))

# Summary of the Two-way ANOVA Repeated Measures
summary(aov_rm)

# Verifies Residuals' Normality
r <- residuals(aov_rm, append = T)
png("residuals.png", width=w, height=h)
qqnorm(r$.residuals)
qqline(r$.residuals)
invisible(dev.off())

# Shapiro-Wilk Normality Test
shapiro.test(r$.residuals)

# Anderson-Darling Normality Test
ad.test(r$.residuals)

# Verifies Variance's Sphericity
check_sphericity(aov_rm)


# Aligned Ranks Transform ANOVA
m <- art(time ~ vertices*algorithm + Error(seed/algorithm), data=data)
summary(m)
anova(m)
vignette("art-contrasts")
