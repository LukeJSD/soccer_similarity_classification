# Load libraries
library(corrplot)
library(dplyr)
library(ggfortify)

info.features <- c("Rk", "Player", "id", "Nation", "Pos", "Squad", "Comp", "Age", "Born")

# Should try to make a model for each position, not all together
get_pca_model <- function(data) {
  # Correlation
  M <- cor(data[, !names(data) %in% info.features])
  #corrplot(M, method = 'color')
  
  # Start PCA https://www.datacamp.com/tutorial/pca-analysis-r
  stat.pca <- princomp(M)
  summary(stat.pca)
  stat.pca$loadings[, 1:2]
  #iris.pca.plot <- autoplot(stat.pca)
  #iris.pca.plot
  return(stat.pca)
}

get_pca_result <- function(data, stat.pca) {
  # plot highest Min players
  # top.players.df <- tail((data %>% arrange(Min)), n=100)
  # pca.set <- predict(stat.pca, top.players.df[, !names(data) %in% info.features])
  #plot(pca.set[,1:2], pch=19, col=factor(top.players.df$Pos))
  
  # Finalize dataframe
  pca.alldata <- predict(stat.pca, data[, !(names(data) %in% (info.features))])
  final <- data
  final$PCA1 <- pca.alldata[,1]
  final$PCA2 <- pca.alldata[,2]
  return(final)
}

# All Positions: 0.6183327 0.2352502
# FW: 0.5501841 0.2353811
# MF: 0.5228233 0.3169002
# DF: 0.4864077 0.3309657
get_position_model <- function(data, posStr) {
  posData <- data[grepl(posStr, data$Pos),]
  pca.pos <- get_pca_model(posData)
  return(pca.pos)
}

get_position_results <- function(data, pca.pos) {   #, posStr) {
  # unsure if the dataset should be all player or just the position
  # posData <- data[grepl(posStr, data$Pos),]
  posData <- data
  final.data.pos <- get_pca_result(posData, pca.pos)
  return(final.data.pos)
}