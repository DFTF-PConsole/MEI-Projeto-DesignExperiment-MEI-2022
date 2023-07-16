# Histograms

# Set Working Directory
setwd("~/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/r")

# Libraries
library(ggplot2)
library(stringr)
library(viridis)

w <- 620
h <- 360

root_directory <- "Histograms"

data <- read.csv("../results2.csv")
data_mean <- aggregate(time ~ algorithm + vertices + probability, data=data, FUN=mean)

algorithms <- unique(data$algorithm)
probabilities <- unique(data$probability)
vertices <- unique(data$vertices)
arcs <- unique(data$arcs)

parent_directory <- "No_Mean"

for (algorithm in algorithms) {
  path <- paste(root_directory, parent_directory, algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  for (vertice in vertices) {
    for (probability in probabilities) {
      filename <- paste(algorithm, "_histogram_v_", vertice, "_p_", probability, ".png", sep="")
      png(paste(path, filename, sep="/"), width=w, height=h)
      
      aux <- data[data$algorithm==algorithm&data$vertices==vertice&data$probability==probability, ]
      
      p <- ggplot(aux, aes(x=time)) + geom_histogram(aes(y=..density..)) +
        geom_vline(aes(xintercept=mean(time))) + geom_density(alpha=.2) + 
        labs(title=paste(algorithm, " when vertices=", vertice, " and probability=", probability, sep=""), x="Execution Time (s)", y="Count")
      
      print(p)
      invisible(dev.off())
    }
  }
}

path <- paste(root_directory, parent_directory, "All", sep="/")
if (!dir.exists(path)) {
  dir.create(path, recursive=TRUE)
}
for (vertice in vertices) {
  for (probability in probabilities) {
    filename <- paste("Histogram_v_", vertice, "_p_", probability, ".png", sep="")
    png(paste(path, filename, sep="/"), width=w, height=h)
    
    aux <- data[data$vertices==vertice&data$probability==probability, ]
    
    p <- ggplot(aux, aes(x=time, fill=factor(algorithm))) + 
      geom_histogram(position="identity", alpha=0.5) +
      scale_fill_viridis_d() +
      labs(title=paste("Vertices=", vertice, ", Probability=", probability, sep=""), x="Execution Time (s)", y="Count", fill="Algorithm")
    
    print(p)
    invisible(dev.off())
  }
}
