# Load libraries
library(tidyverse)
library(ggpubr)
library(rstatix)
library(nortest)

# Needed by Afex
suppressMessages(suppressWarnings(library(afex)))
library(emmeans)
library(performance)

# Multiple Imputation
library(mice)
library(mitml)

# Load data
code1 <- read.csv('output_code1_maxcpu_300_k_30.csv')
code2 <- read.csv('output_code2_maxcpu_300_k_30.csv')

# Perform pre-processing (without removing missing data)
code1 <- code1[, c('n', 'p', 't')]
code2 <- code2[, c('n', 'p', 't')]
code1$n <- factor(code1$n)
code1$p <- factor(code1$p)
code2$n <- factor(code2$n)
code2$p <- factor(code2$p)
df1 <- data.frame(
  input = factor(1:nrow(code1)),
  code = factor(rep(1, nrow(code1)))
)
df2 <- data.frame(
  input = factor(1:nrow(code2)),
  code = factor(rep(2, nrow(code2)))
)
c1 <- cbind(df1, code1)
c2 <- cbind(df2, code2)
dados <- rbind(c1, c2)

# Apply three-way anova repeated measures

# aov.out <- aov(t ~ n*p*code + Error(input/code), data=dados)

aov_rm <- aov_car(t ~ n*p*code + Error(input/code), data=dados, fun_aggregate=mean, 
                  factorize=TRUE, na.rm=TRUE, include_aov=TRUE)#, anova_table=list(correction = "none", es = "none"))

#aov_rm2 <- aov_ez(id="input", dv="t", data=dados,obk.long, between=c("n", "p"), within=c("code"),
#               fun_aggregate=mean, factorize=TRUE, na.rm=TRUE, print.formula=TRUE)

print(aov_rm)
summary(aov_rm)

# Verify assumptions
# Verifica a normalidade dos resíduos
r <- residuals(aov_rm, append = T)
qqnorm(r$.residuals)
qqline(r$.residuals)
ad.test(r$.residuals)

# Verifica a sphericity da variância
test_sphericity(aov_rm)
check_sphericity(aov_rm)

