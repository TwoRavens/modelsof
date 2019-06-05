#install.packages(c('reshape', 'RColorBrewer'))
library(RColorBrewer)

args = commandArgs(trailingOnly=T)

data = read.csv(sprintf('out/%s.csv', args[1]), sep=',', row.names=1, check.names=FALSE)
data = as.matrix(data)
print(data)

png(sprintf('out/%s.png', args[1]), width=1024, height=768)
par(mar=c(4, 12, 4, 4))
barplot(data, col=brewer.pal(n=4, name='Set1'), border='white', font.axis=2, beside=T, legend=rownames(data), font.lab=2, horiz=T, las=T)
dev.off()
