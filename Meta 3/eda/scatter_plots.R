# 2D Scatter Plots

# Set Working Directory
setwd("~/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/r")

# Libraries
library(ggplot2)
library(stringr)
library(viridis)
 
w <- 620
h <- 360

root_directory <- "Scatter_Plots_2D"

data <- read.csv("../results2.csv")
data_mean <- aggregate(time ~ algorithm + vertices + probability, data=data, FUN=mean)

algorithms <- unique(data$algorithm)
probabilities <- unique(data$probability)
vertices <- unique(data$vertices)
arcs <- unique(data$arcs)

# Without Mean
parent_directory <- "No_Mean"

directory <- "Vertices_Fixed"

for (algorithm in algorithms) {
  path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  for (vertice in vertices) {
    filename <- paste(algorithm, paste(paste("scatter_plot", vertice, sep="_v_"), "png", sep="."), sep="_")
    png(paste(path, filename, sep="/"), width=w, height=h)
    aux <- data[data$algorithm==algorithm&data$vertices==vertice, c("probability", "time")]
    p <- ggplot(aux, aes(x=probability, y=time)) + geom_point() + 
      labs(title=paste(algorithm, paste("when vertices=", vertice, sep=""), sep=" "), x="Probability", y = "Execution Time (s)")
    print(p)
    invisible(dev.off())
  }
}


directory <- "Vertices_Fixed_Arcs"

for (algorithm in algorithms) {
  path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  for (vertice in vertices) {
    filename <- paste(algorithm, paste(paste("scatter_plot", vertice, sep="_v_"), "png", sep="."), sep="_")
    png(paste(path, filename, sep="/"), width=w, height=h)
    aux <- data[data$algorithm==algorithm&data$vertices==vertice, c("arcs", "time")]
    p <- ggplot(aux, aes(x=arcs, y=time)) + geom_point() + 
      labs(title=paste(algorithm, paste("when vertices=", vertice, sep=""), sep=" "), x="Number of Arcs", y = "Execution Time (s)")
    print(p)
    invisible(dev.off())
  }
}


directory <- "Probabilities_Fixed"

for (algorithm in algorithms) {
  path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  for (probability in probabilities) {
    filename <- paste(algorithm, paste(paste("scatter_plot", probability, sep="_p_"), "png", sep="."), sep="_")
    png(paste(path, filename, sep="/"), width=w, height=h)
    aux <- data[data$algorithm==algorithm&data$probability==probability, c("vertices", "time")]
    p <- ggplot(aux, aes(x=vertices, y=time)) + geom_point() + 
      labs(title=paste(algorithm, paste("when p=", probability, sep=""), sep=" "), x="Number of Vertices", y = "Execution Time (s)")
    print(p)
    invisible(dev.off())
  }
}


# Mean of the 30 instances
parent_directory <- "Mean"
directory <- "Vertices_Fixed"

for (algorithm in algorithms) {
  path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  for (vertice in vertices) {
    filename <- paste(algorithm, paste(paste("scatter_plot", vertice, sep="_v_"), "png", sep="."), sep="_")
    png(paste(path, filename, sep="/"), width=w, height=h)
    aux <- data_mean[data_mean$algorithm==algorithm&data_mean$vertices==vertice, c("probability", "time")]
    p <- ggplot(aux, aes(x=probability, y=time)) + geom_point() + 
      labs(title=paste(algorithm, paste("when vertices=", vertice, sep=""), sep=" "), x="Probability", y = "Execution Time (s)")
    print(p)
    invisible(dev.off())
  }
}


directory <- "Probabilities_Fixed"

for (algorithm in algorithms) {
  path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  for (probability in probabilities) {
    filename <- paste(algorithm, paste(paste("scatter_plot", probability, sep="_p_"), "png", sep="."), sep="_")
    png(paste(path, filename, sep="/"), width=w, height=h)
    aux <- data_mean[data_mean$algorithm==algorithm&data_mean$probability==probability, c("vertices", "time")]
    p <- ggplot(aux, aes(x=vertices, y=time)) + geom_point() + 
      labs(title=paste(algorithm, paste("when p=", probability, sep=""), sep=" "), x="Number of Vertices", y = "Execution Time (s)")
    print(p)
    invisible(dev.off())
  }
}

