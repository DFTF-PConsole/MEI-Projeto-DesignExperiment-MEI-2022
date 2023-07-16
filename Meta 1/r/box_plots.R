# Box Plots

# Set Working Directory
setwd("~/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/r")

# Libraries
library(ggplot2, quietly=TRUE)
library(stringr, quietly=TRUE)
library(viridis, quietly=TRUE)

w <- 620
h <- 360

root_directory <- "Box_Plots"

data <- read.csv("../results2.csv")
data_mean <- aggregate(time ~ algorithm + vertices + probability, data=data, FUN=mean)
data_mean$arcs <- data_mean$probability * ((data_mean$vertices * (data_mean$vertices - 1)) / 2)

algorithms <- unique(data$algorithm)
probabilities <- unique(data$probability)
vertices <- unique(data$vertices)

directory <- "Vertices_Fixed"

for (algorithm in algorithms) {
  path <- paste(root_directory, directory, algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  for (vertice in vertices) {
    filename <- paste(algorithm, "_box_plot_v_", vertice, ".png", sep="")
    png(paste(path, filename, sep="/"), width=w, height=h)
    aux <- data[data$algorithm==algorithm&data$vertices==vertice, c("probability", "time")]
    
    p <- ggplot(aux, aes(x=factor(probability), y=time, fill=factor(probability))) + 
      geom_boxplot() + scale_fill_viridis_d() +
      labs(title=paste(algorithm, " when v=", vertice, sep=""), x="Probability", y="Execution Time (s)")
    
    print(p)
    invisible(dev.off())
  }
}


directory <- "Probabilities_Fixed"

for (algorithm in algorithms) {
  path <- paste(root_directory, directory, algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  for (probability in probabilities) {
    filename <- paste(algorithm, "_box_plot_p_", probability, ".png", sep="")
    png(paste(path, filename, sep="/"), width=w, height=h)
    aux <- data[data$algorithm==algorithm&data$probability==probability, c("vertices", "time")]
    
    p <- ggplot(aux, aes(x=factor(vertices), y=time, fill=factor(vertices))) + 
      geom_boxplot() + scale_fill_viridis_d() +
      labs(title=paste(algorithm, " when p=", probability, sep=""), x="Number of Vertices", y="Execution Time (s)")
    
    print(p)
    invisible(dev.off())
  }
}
