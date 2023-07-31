library(ggfortify)

set.seed(123)

setwd("C:/Users/luke/Personal_Projects/Soccer/Similarity/")

source("C:/Users/luke/Personal_Projects/Soccer/Similarity/r_similar.R")

test.kmeans <- function(df, kmax=20) {
  wss <- c()
  for (k in 1:kmax) {
    km <- kmeans(df[,c("PCA1", "PCA2")], k)
    wss <- c(wss, km$tot.withinss)
  }
  plot(ggplot()+geom_line(aes(x=1:20, y=wss)))
}

get.kmeans.model <- function(df, k) {
  # k=5 # DF
  # k=5 # MF
  # k=7 # FW
  km <- kmeans(df[,c("PCA1", "PCA2")], k)
  return(km)
}

plot.kmeans <- function(df, km, position) {
  df["cluster"] <- km$cluster
  k.pos <- df[,c("PCA1", "PCA2")]
  k.pos["cluster"] <- km$cluster
  gplt <- ggplot(data=k.pos, 
                 aes(
                   x=PCA1, 
                   y=PCA2, 
                   color=factor(k.pos$cluster), 
                   fill=factor(k.pos$cluster)
                 )
  ) + 
    geom_point() +
    stat_ellipse(geom = "polygon", alpha=0.3) +
    labs(title=paste(position, length(km$size), sep = ", k = ")) +
    theme(
      legend.text = element_blank(),
      legend.position = "none"
    ) +
    annotate("text", label=1:length(km$size), x=km$centers[,"PCA1"], y=km$centers[,"PCA2"], color="black")
  plot(gplt)
}

view.cluster.df <- function(df, cluster_number){
  View(df %>% filter(cluster==cluster_number) %>% select(Player,Squad,Nation,Starts,PCA1,PCA2,cluster))
}

save.kmeans.plot <- function(pos) {
  if (pos=="MF") {
    data <- data.final.mf %>% filter(grepl(pos, Pos))
    k <- 5
  } else if (pos=="DF") {
    data <- data.final.df %>% filter(grepl(pos, Pos))
    k <- 5
  } else if (pos=="FW") {
    data <- data.final.fw %>% filter(grepl(pos, Pos))
    k <- 7
  }
  # test.kmeans(data)
  km.res <- get.kmeans.model(data, k)
  png(paste(getwd(), paste(paste("Clusters", pos, sep="/"), ".png", sep="_kmeans"), sep="/"))
  plot.kmeans(data, km.res, pos)
  dev.off()
}
get.pca.scores <- function(position) {
  if (position=="MF") {
    return(data.frame(pca.mf$scores[,1:2]) %>% arrange(desc(Comp.1)))
  } else if (position=="DF") {
    return(data.frame(pca.df$scores[,1:2]) %>% arrange(desc(Comp.1)))
  } else if (position=="FW") {
    return(data.frame(pca.fw$scores[,1:2]) %>% arrange(desc(Comp.1)))
  }
}

get.data.w_cluster <- function(pos) {
  if (pos=="MF") {
    data <- data.final.mf %>% filter(grepl(pos, Pos))
    k <- 5
  } else if (pos=="DF") {
    data <- data.final.df %>% filter(grepl(pos, Pos))
    k <- 5
  } else if (pos=="FW") {
    data <- data.final.fw %>% filter(grepl(pos, Pos))
    k <- 7
  }
  # test.kmeans(data)
  km.res <- get.kmeans.model(data, k)
  data["cluster"] <- km.res$cluster
  return(data)
}

for (p in c("DF", "MF", "FW")) {
  save.kmeans.plot(p)
  write.csv(get.pca.scores(p), paste(getwd(), paste(paste("Clusters", p, sep="/"), ".csv", sep="_pca_scores"), sep="/"))
}


