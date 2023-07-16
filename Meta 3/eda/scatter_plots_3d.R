# Scatter Plots 3D

# Set Working Directory
setwd("~/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/r")

# Libraries
library(ggplot2, quietly=TRUE)
library(viridis, quietly=TRUE)
library(plotly, quietly=TRUE)
library(stringr, quietly=TRUE)

w <- 620
h <- 360

root_directory <- "Scatter_Plots_3D"

data <- read.csv("../results2.csv")
data_mean <- aggregate(time ~ algorithm + vertices + probability, data=data, FUN=mean)
data_mean$arcs <- data_mean$probability * ((data_mean$vertices * (data_mean$vertices - 1)) / 2)

algorithms <- unique(data$algorithm)
probabilities <- unique(data$probability)
vertices <- unique(data$vertices)
arcs <- unique(data$arcs)

directory <- "No_Mean"

plot_ly(data, x = ~vertices, y = ~probability, z = ~time, color = ~algorithm, colors = "viridis") %>% 
  add_markers() %>%
  layout(
    title = "Scatter Plot 3D",
    scene = list(
      xaxis = list(title = "Number of Vertices"),
      yaxis = list(title = "Probability"),
      zaxis = list(title = "Execution Time (s)")
    )
  )

plot_ly(data, x = ~vertices, y = ~arcs, z = ~time, color = ~algorithm, colors = "viridis") %>% 
  add_markers() %>%
  layout(
    title = "Scatter Plot 3D",
    scene = list(
      xaxis = list(title = "Number of Vertices"),
      yaxis = list(title = "Number of Arcs"),
      zaxis = list(title = "Execution Time (s)")
    )
  )

directory <- "Mean"

plot_ly(data_mean, x = ~vertices, y = ~probability, z = ~time, color = ~algorithm, colors = "viridis") %>% 
  add_markers() %>%
  layout(
    scene = list(
      title = "Scatter Plot 3D",
      xaxis = list(title = "Number of Vertices"),
      yaxis = list(title = "Probability"),
      zaxis = list(title = "Execution Time (s)")
    )
  )

plot_ly(data_mean, x = ~vertices, y = ~arcs, z = ~time, color = ~algorithm, colors = "viridis") %>% 
  add_markers() %>%
  layout(
    scene = list(
      title = "Scatter Plot 3D",
      xaxis = list(title = "Number of Vertices"),
      yaxis = list(title = "Number of Arcs"),
      zaxis = list(title = "Execution Time (s)")
    )
  )
