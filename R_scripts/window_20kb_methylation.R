##### 20kb window methylation (Server) #####
library(BSgenome.Hsapiens.UCSC.hg38)
library(GenomicRanges)

tiles <- tileGenome(seqinfo(BSgenome.Hsapiens.UCSC.hg38), tilewidth=2e4,
                    cut.last.tile.in.chrom=TRUE)
genome_views <- Views(BSgenome.Hsapiens.UCSC.hg38, tiles)

windows = bsseq::getMeth(BSseq = bs.filtered.bsseq,
                         regions = tiles,
                         type = "smooth",
                         what = "perRegion")
write.csv(windows, "windows.csv")

## add location information
windows_loc = cbind(tiles, data.frame(windows))
write.csv(windows_loc, "windows_loc.csv")