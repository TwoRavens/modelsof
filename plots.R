#install.packages('RColorBrewer')
library('RColorBrewer')

data = read.csv('out/files_dist.csv', sep=',', row.names=1) 
data = as.matrix(data)
print(data)

png('out/files_dist.png')
barplot(data, col=brewer.pal(n=3, name='Set1'), border='white', font.axis=2, beside=T, legend=rownames(data), xlab='journal', font.lab=2)
dev.off()
