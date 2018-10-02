#! /usr/bin/env Rscript
suppressMessages(library("gplots"))
library("RColorBrewer")

args <- commandArgs(TRUE)
input <- args[1]
topx <- as.numeric(args[2])
output <- args[3]

ddsr <- read.csv(input, header=TRUE, sep=",")
ddsr <- ddsr[rev(order(abs(ddsr$log2FoldChange))) , ]
ddsrNoNA <- ddsr[ !is.na(ddsr$log2FoldChange) , ]
ddsrNoNA <- ddsrNoNA[ !is.na(ddsrNoNA$padj) , ]
ddsrNoNA <- ddsrNoNA[ ddsrNoNA$baseMean > 0.0 , ]
ddsrNoNAp05 <- ddsrNoNA[ ddsrNoNA$padj < 0.05 , ]

countx <- vector()
county <- vector()
for(i in 1:topx){
    logfc <- ddsrNoNAp05$log2FoldChange[i]
    fc <- 2**abs(logfc)
    j <- ddsrNoNAp05$baseMean[i]/(fc+1)
    if (logfc > 0){
        countx <- c(countx,log(j))
        county <- c(county,log(j*fc))
    } else {
        countx <- c(countx,log(j*fc))
        county <- c(county,log(j))
    }
}
ids <- ddsrNoNAp05$X[1:topx]

pdf(output)
hmcol <- colorRampPalette(brewer.pal(9, "GnBu"))(100)
m <- c(2,floor(max(nchar(as.character(ids)))/2.5))
heatmap.2(cbind(countx,county), col = hmcol, Rowv = TRUE, Colv = FALSE, scale = "none", dendrogram = "row", trace = "none", srtCol=0, labCol = c("A","A*"), margin=m, labRow = ids, cexRow = 0.6, cexCol = 1, key.title = NA, key.ylab = NA, key.xlab = "log2 normalized counts")
#, distfun=function(x) as.dist(1-cor(t(x))), hclustfun=function(x) hclust(x, method="average"))
graphics.off()
