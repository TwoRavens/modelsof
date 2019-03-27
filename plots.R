#install.packages('RColorBrewer')
library('RColorBrewer')

args = commandArgs(trailingOnly=T)

data = read.csv(sprintf('out/%s_dist.csv', args[1]), sep=',', row.names=1) 
data = as.matrix(data)
print(data)

png(sprintf('out/%s_dist.png', args[1]))
barplot(data, col=brewer.pal(n=3, name='Set1'), border='white', font.axis=2, beside=T, legend=rownames(data), xlab='journal', font.lab=2)
dev.off()
