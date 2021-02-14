#### Methylation Extraction ####
# Original getMeth function can be found at bsseq R package
# Adapt from https://github.com/ben-laufer/DMRichR#5-smoothed-individual-methylation-values 

library(dmrseq)
library(bsseq)
library(GenomicRanges)

load("bsseq.RData")
DMR <- GRanges(seqnames=DMR$seqnames, ranges=IRanges(start=DMR$start, end=DMR$end))
getSmooth <- function(bsseq = bsseq,
                      regions = regions,
                      out = out){
  print(glue::glue("Obtaining smoothed methylation values..."))
  smoothed <- data.frame(getMeth(BSseq = bsseq, regions = regions, type = "smooth", what = "perRegion"), check.names=FALSE)
  smoothed_table <- cbind(regions, smoothed)
  write.table(smoothed_table, out, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)
  return(smoothed_table)
}
meth_DMR <- getSmooth(bsseq = bs.filtered.bsseq,
                                   regions = DMR,
                                   out = "meth_DMR.txt")


