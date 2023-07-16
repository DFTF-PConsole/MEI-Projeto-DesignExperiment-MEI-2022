# Grouped Box Plots

# Set Working Directory
setwd("~/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/r")

# Libraries
library(ggplot2)
library(stringr)
library(viridis, quietly=TRUE)

w <- 620
h <- 360

root_directory <- "Grouped_Box_Plots"

data <- read.csv("../results2.csv")
data_mean <- aggregate(time ~ algorithm + vertices + probability, data=data, FUN=mean)

algorithms <- unique(data$algorithm)
probabilities <- unique(data$probability)
vertices <- unique(data$vertices)
arcs <- unique(data$arcs)


parent_directory <- "No_Mean"
directory <- "Grouped_By_Vertices"

for (algorithm in algorithms) {
  path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  filename <- paste(algorithm, "grouped_box_plot_by_vertices.png", sep="_")
  png(paste(path, filename, sep="/"), width=w, height=h)
  aux <- data[data$algorithm==algorithm,]
  
  p <- ggplot(aux, aes(x=factor(vertices), y=time, fill=factor(probability))) +
    geom_boxplot(outlier.shape=NA) + scale_fill_viridis_d() +
    labs(title=algorithm, x="Number of Vertices", y="Execution Time (s)", fill="Probability")
  
  print(p)
  invisible(dev.off())
}


directory <- "Grouped_By_Probabilities"

for (algorithm in algorithms) {
  path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  filename <- paste(algorithm, "grouped_box_plot_by_probability.png", sep="_")
  png(paste(path, filename, sep="/"), width=w, height=h)
  aux <- data[data$algorithm==algorithm,]
  
  p <- ggplot(aux, aes(x=factor(probability), y=time, fill=factor(vertices))) +
    geom_boxplot(outlier.shape=NA) + scale_fill_viridis_d() +
    labs(title=algorithm, x="Probability", y="Execution Time (s)", fill="Number of Vertices")
  
  print(p)
  invisible(dev.off())
}


directory <- "Grouped_By_Algorithm"
subdirectory <- "Vertices_Fixed"

path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), subdirectory, sep="/")
if (!dir.exists(path)) {
  dir.create(path, recursive=TRUE)
}
for (vertice in vertices) {
  filename <- paste("Grouped_box_plot_by_algorithm_v_", vertice, ".png", sep="")
  png(paste(path, filename, sep="/"), width=w, height=h)
  aux <- data[data$vertices==vertice,]
  
  p <- ggplot(aux, aes(x=factor(probability), y=time, fill=factor(algorithm))) +
    geom_boxplot(outlier.shape=NA) + scale_fill_viridis_d() +
    labs(title=paste("Vertices=", vertice, sep=""), x="Probability", y="Execution Time (s)", fill="Algorithm")
  
  print(p)
  invisible(dev.off())
}


subdirectory <- "Probabilities_Fixed"

path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), subdirectory, sep="/")
if (!dir.exists(path)) {
  dir.create(path, recursive=TRUE)
}
for (probability in probabilities) {
  filename <- paste("Grouped_box_plot_by_algorithm_p_", probability, ".png", sep="")
  png(paste(path, filename, sep="/"), width=w, height=h)
  aux <- data[data$probability==probability,]
  
  p <- ggplot(aux, aes(x=factor(vertices), y=time, fill=factor(algorithm))) +
    geom_boxplot(outlier.shape=NA) + scale_fill_viridis_d() +
    labs(title=paste("Probability=", probability, sep=""), x="Number of Vertices", y="Execution Time (s)", fill="Algorithm")
  
  print(p)
  invisible(dev.off())
}

subdirectory <- "Vertices_Probabilities_Fixed"

path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), subdirectory, sep="/")
if (!dir.exists(path)) {
  dir.create(path, recursive=TRUE)
}
for (vertice in vertices) {
  for (probability in probabilities) {
    filename <- paste(paste("Grouped_box_plot_by_algorithm_v", vertice, sep="_"), "_p_", probability, ".png", sep="")
    png(paste(path, filename, sep="/"), width=w, height=h)
    aux <- data[data$vertices==vertice&data$probability==probability,]
    
    p <- ggplot(aux, aes(y=time, fill=factor(algorithm))) +
      geom_boxplot(outlier.shape=NA) + scale_fill_viridis_d() +
      labs(title=paste("Vertices=", vertice, ", Probability=", probability, sep=""), x="", y="Execution Time (s)", fill="Algorithm")
    
    print(p)
    invisible(dev.off())
  }
}
