setwd("C:/Users/luke/Personal_Projects/Soccer/Similarity/")

source("C:/Users/luke/Personal_Projects/Soccer/Similarity/kmeans_grouping_players.R")

# Create models
km.models <- NULL
for (p in c("DF", "MF", "FW")) {
  km.models[[which(c("DF", "MF", "FW")==p)]] <- c(km.models, save.kmeans.plot(p))
  write.csv(get.pca.scores(p), paste(getwd(), paste(paste("Clusters", p, sep="/"), ".csv", sep="_pca_scores"), sep="/"))
}
# Add cluster to postion dataframes
fw <- get.data.w_cluster("FW", km.models[[3]])
mf <- get.data.w_cluster("MF", km.models[[2]])
df <- get.data.w_cluster("DF", km.models[[1]])
# Save each cluster separately
for (i in 1:3) {
  dtfrm <- list(df, mf, fw)[[i]]
  p <- c("DF", "MF", "FW")[i]
  for (c in unique(dtfrm$cluster)) {
    write.csv(
      dtfrm %>% filter(cluster==c) %>% select(Player,Squad,Nation,Starts,PCA1,PCA2,cluster),
      paste(getwd(), paste(paste(paste("Clusters", p, sep="/"), c, sep="/"), ".csv", sep="_cluster"), sep="/")
    )
  }
}

view.cluster.df(fw, 1)
