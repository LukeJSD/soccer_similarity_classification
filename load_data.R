# Load libraries
library(corrplot)
library(dplyr)
library(ggfortify)

setwd("C:/Users/luke/Personal_Projects/Soccer/Similarity/")

info.features <- c("Rk", "Player", "id", "Nation", "Pos", "Squad", "Comp", "Age", "Born")

get_data <- function(league) {# Load data
  if (league=="Big5") {
    info.features <- c("Rk", "Player", "id", "Nation", "Pos", "Squad", "Comp", "Age", "Born")
  } else if (league=="MLS") {
    info.features <- c("Rk", "Player", "Nation", "Pos", "Squad", "Age", "Born")
  }
  stat.types <- c("standard", "defense", "gca", "misc", "passing", "passing_types", "possession", "shooting")
  stat.dfs <- c()
  for (i in seq_along(stat.types)) {
    n <- paste("C:/Users/luke/Personal_Projects/Soccer/Similarity/Data/", league, sep = "")
    n <- paste(n, stat.types[i], sep="/")
    n <- paste(n, ".csv", sep = "")
    new.df <- read.csv(n)
    new.df <- new.df[new.df$Rk!="Rk",]
    stat.dfs[[i]] <- new.df
  }
  
  # Combine data
  df = stat.dfs[[1]]
  for (x in 2:length(stat.types)) {
    cols = names(stat.dfs[[x]])[!(names(stat.dfs[[x]]) %in% names(df))]
    y = stat.dfs[[x]][,(names(stat.dfs[[x]])) %in% cols]
    df <- cbind(df, y)
  }
  # Set threshold
  df <- subset(df, Min>450)
  # Remove GK
  df <- subset(df, Pos!="GK")
  # Remove general info, non-statistical features
  info <- df[,info.features]
  df <- df[,!(names(df)) %in% c("matches", names(info))]
  
  # Ensure there are no repeated features
  temp_dataset <- data.frame(cols = names(df))
  regexes <- c()
  for (j in 1:length(stat.types)) {
    regexes <- c(regexes, paste(j, "$", sep = ""))
  }
  cols2d <- lapply(regexes, function(rx) {subset(temp_dataset, grepl(rx, cols))})
  cols1d <- c()
  for (ls in cols2d) {
    cols1d <- c(cols1d, ls$cols)
  }
  df <- df[,!(names(df)) %in% cols1d]
  # Drop rows with lots of na values
  info <- info[!is.na(df$Sh),]
  df <- df[!is.na(df$Sh),]
  # Replace logically na values with -0.1 (probably want better replacement)
  for (c in names(df)[colSums(is.na(df)) > 0]) {
    df[is.na(df[,c]),c] <- -0.1
  }
  # Ensure all data is numerical
  df <- df %>% select(where(is.numeric))
  
  # Make per 90
  minutes <- df$Min
  X90s <- df$X90s
  df <- df %>% select(!names(df)[grepl("90", names(df)) | "Min"==names(df)])
  df[,names(df)[!names(df) %in% c("MP", "Starts, Min")]] <- (df[,names(df)[!names(df) %in% c("MP", "Starts, Min")]]/minutes)*90
  df["X90s"] <- X90s
  
  # Normalize Data (might need different method)
  #df = scale(df)
  # Recombine dataframes
  data <- cbind(info, df)
  return(data)
}
