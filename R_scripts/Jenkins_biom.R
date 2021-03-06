# Jenkins_biom.R
# Adapted from FIA_biomass.R
# Created by Sean DuBois 6/4/16


#Import tree names and codes
spp.codes <- read.csv('Conversion_tables/FIA_conversion_v02-SGD.csv', header=TRUE)
spp.codes.paleon <- spp.codes[,c('spcd', 'PalEON')]
spp.codes.paleon_nodups <- spp.codes.paleon[-which(duplicated(spp.codes.paleon$spcd)),]
tree.spp <- read.csv("Conversion_tables/plss.pft.conversion-SGD.csv", header=TRUE)

# Conversion factors
ac2ha   <- 0.404686   #conversion from 1 acre to hectares
# -----------------Calculate Jenkins biomass----------------
tree_data <- surv.current
tree_data2 <- merge(tree_data, spp.codes.paleon_nodups, by="spcd")
tree_data3 <- merge(tree_data2, tree.spp, by.x="PalEON", by.y="PLSS")

plt_cn <- unique(as.character(tree_data3$plt_cn))
spcd_unique <- unique(tree_data3$spcd)

calcbiomass <- function(beta1, beta2, dia, tpa){
  bm <- (exp(beta1 + beta2 * log(dia)))*tpa
  return(bm)
}

tree_data3$Jenkins_Biomass <- calcbiomass(tree_data3$biomass_b1, tree_data3$biomass_b2, tree_data3$dbh, tree_data3$tpa_unadj) * (1/(ac2ha*1000))
write.csv(tree_data3, 'data/output/biom_fia_jenk.csv')