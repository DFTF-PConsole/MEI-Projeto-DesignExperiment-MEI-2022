# Polynomial Regression

# Set Working Directory
setwd("~/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/r")

# Libraries
library(ggplot2, quietly=TRUE)
library(stringr, quietly=TRUE)
library(viridis, quietly=TRUE)

w <- 620
h <- 360

root_directory <- "Teste"

data <- read.csv("../results2.csv")
data$mean_arcs <- data$probability * ((data$vertices * (data$vertices - 1)) / 2)

algorithms <- unique(data$algorithm)
vertices <- unique(data$vertices)
probabilities <- unique(data$probability)

directory <- "Vertices_Fixed"

for (vertice in vertices) {
  path <- paste(root_directory, directory, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  filename <- paste("box_plot_v_", vertice, ".png", sep="")
  
  png(paste(path, filename, sep="/"), width=w, height=h)
  
  df <- data[data$vertices==vertice,]
  
  p <- ggplot(df, aes(x=factor(probability), y=arcs, fill=factor(probability))) + 
    geom_boxplot() + scale_fill_viridis_d() +
    geom_line(inheret.aes=FALSE, aes(x=factor(probability), y=mean_arcs, group = 1), color = "red") +
    labs(title=paste("v=", vertice, sep=""), x="Probabilities", y="Number of Arcs")
  
  print(p)
  
  invisible(dev.off())
}

directory <- "Probabilities_Fixed"

for (probability in probabilities) {
  path <- paste(root_directory, directory, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  filename <- paste("box_plot_p_", probability, ".png", sep="")
  
  png(paste(path, filename, sep="/"), width=w, height=h)
  
  df <- data[data$probability==probability,]
  
  p <- ggplot(df, aes(x=factor(vertices), y=arcs, fill=factor(vertices))) + 
    geom_boxplot() + scale_fill_viridis_d() +
    geom_line(inheret.aes=FALSE, aes(x=factor(vertices), y=mean_arcs, group = 1), color = "red") +
    labs(title=paste("p=", probability, sep=""), x="Number of Vertices", y="Number of Arcs")
  
  print(p)
  
  invisible(dev.off())
}
