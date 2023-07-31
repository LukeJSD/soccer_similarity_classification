# Soccer Similarity Classification
### Author: Luke Julian
### README Updated: 31/07/2023
## Summary
Classify soccer players based on their statistical profile.
### Data
Data was pulled from FBref. It includes all the players in the top 5 leagues in Europe. Goalkeepers and players that played less than 450 minutes were removed from the data set.  
Statistical categories are:
- Standard
- Defense
- GCA (Goal Creating Actions)
- Miscellaneous
- Passing
- Passing_types
- Possession
- Shooting
### PCA
When all categories of stats are merged into one dataset there usually ends up being between 90 and 150 unique features. All of these feature are used to create a PCA model. Because positions have such different responsibilities, creating a PCA for each of the three general outfield positions (defense, midfield, forward) allows for more detailed analysis. The values of the top 2 PCA components are assigned to every player. These 2 pca features typically explain between 75% and 85% of the variance among all the features.
### Similarity
Finding similarity between players can be useful in a number of ways. If a player leaves on a transfer, it is beneficial to replace them with a player that plays ina similar way. This helps reduce risk to a team's established tactical system. It can also help find cheap players that are similar to more expensive players. This can be useful in finding bargains and backups.  
The similarity between players is determined using the 2 pca features for each player. For a given benchmark player, the scaler value (cartesian distance between each player's pca features) is found from every player to the benchmark player. Ordering these values shows where the smaller the value is more similar to the benchmark and the larger the value is more different to the benchmark. To get a "percentage similar" between players, the inverse percent of the maximum value is recorded. For example, if a player's distance value is 1 and the furthest distance value is 10, the player is considered to be 90% similar to the benchmark player.
### Classification
Classification can be useful in a similar way to similarity, but is useful for players based on role rather than just 1 specific example. Players can be grouped in their position by various roles, such as no-nonsense centerbacks or ballplaying centerbacks, creative fullbacks that can invert or pacey wingbacks that deliver crosses, pivots that are also ball-winners or  creative midfielders that dictate tempo, targetmen or false-nines.  
Classification uses the same PCA features as the similarity component did.  K Means models use unsupervised learning to create groups/clusters from the unlabeled data provided.
## Libraries
- R
  - ggplot2/ggfortify
  - grid
  - tidyverse
## Files
### pca.R
### r_similar.R
### kmeans_grouping_players.R
## Notes
- https://fbref.com/en/
- Had to manually edit the names of some feature names in the data csv files so they wouldn't get dropped because they had the same name as a different statistic (ie Mid 3rd could mean middle 3rd passes or middle 3rd tackles).
- Everything would probably be more accurate if I converted everything to per90 stats and removed the play time features to reduce the influence volume has on the PCA.
- The optimization for the K Means model is currently not great. Right now just going off the plot of WSS values. Also not tweaking many parameters of the model.

