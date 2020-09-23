### ChromHMM analysis #####
# Packages
library(LOLA)
library(simpleCache)
library(GenomicRanges)
library(qvalue)

# Load Files
cat("\nReading DMRs\n")
DMRs <- readBed(file = "DMRs.bed")
Background <- readBed(file = "backgroundRegions.bed")
DMRs_List <- GRangesList(DMRs)

# chromHMM
cat("\nLoading Regions\n")
regionDB <- loadRegionDB(dbLocation = "/share/lasallelab/programs/LOLA/hg38", useCache = TRUE, limit = NULL, collections = "roadmap_epigenomics")
cat("\nRegions finished loading\n")

cat("\nRunning LOLA\n")
Results <- runLOLA(userSets = DMRs_List, userUniverse = Background, regionDB = regionDB, minOverlap = 1, cores=2, redefineUserSets = FALSE)
cat("\nLOLA Finished Running\n")

cat("\nPrinting Results\n")
writeCombinedEnrichment(combinedResults = Results, outFolder = "All_DMRs_roadmap_epigenomics", includeSplits=FALSE)

cat("\nDone!\n")
