# Load libraries
library(corrplot)
library(dplyr)
library(ggfortify)

source("C:/Users/luke/Personal_Projects/Soccer/Similarity/load_data.R")
source("C:/Users/luke/Personal_Projects/Soccer/Similarity/pca.R")

# Player comp
player_comp_fun <- function(final, base.player) {
  comp <- final[final$Player==base.player,]
  if (base.player=="Rodri") {
    print("Multiple players, default to Machester City")
    comp <- comp[comp$Squad=="Manchester City",]
  }
  distance <- c()
  for (r in 1:nrow(final)) {
    x <- (comp$PCA1-final$PCA1[r])**2
    y <- (comp$PCA2-final$PCA2[r])**2
    distance <- c(distance, sqrt(x+y))
    }
  final$comp <- distance
  position <- final[comp$Pos[1]==final$Pos,]   #grep(comp$Pos[1], final$Pos)>0,]
  if (grepl(",", comp$Pos[1])>0) {
    vec <- lapply(strsplit("MF,DF", ",")[[1]], function(p) {subset(final, Pos==p)})
    temp <- data.frame()
    for (d in vec) {
      temp <- rbind(temp, d)
    }
    position <- rbind(position, temp)
  }
  position$comp.percent <- 1-(position$comp/max(position$comp))
  position <- position %>% arrange(comp, desc(T))
  position.25 <- position[2:26,]
  ggplot(position.25, aes(x=1:25, y=comp.percent)) +
    scale_x_reverse() + 
    coord_flip() +
    xlab(base.player) + 
    ylab("Similarity %") +
    geom_col(alpha=1-(position.25$Age-min(position.25$Age)+1)/(max(position.25$Age)-15), col="Black") +   # fill="Blue"
    geom_text(aes(label=Player), y=0.33)
  #return(position.25)
}

data <- get_data("Big5")
pca <- get_pca_model(data)
data.final <- get_pca_result(data, pca)

pca.df <- get_position_model(data, "DF")
data.final.df <- get_position_results(data, pca.df)   #, "DF")

pca.mf <- get_position_model(data, "MF")
data.final.mf <- get_position_results(data, pca.mf)   #, "MF")

pca.fw <- get_position_model(data, "FW")
data.final.fw <- get_position_results(data, pca.fw)   #, "FW")
