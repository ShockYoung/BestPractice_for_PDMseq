args <- commandArgs(trailingOnly = TRUE)
print(args)

#source("http://bioconductor.org/biocLite.R")
#biocLite(c("Rsamtools", "GenomicAlignments", "BiocParallel", "futile.logger"))

library("XenofilteR")

#setting enviroment
bp.param <- SnowParam(workers = 1, type = "SOCK")

outputDIR <- args[1]
Human <- args[2]
Mouse <- args[3]

sample.list <- cbind(Human,Mouse)

#running XenofilteR
XenofilteR(sample.list, destination.folder = outputDIR, bp.param = bp.param)

