#install.packages('RColorBrewer')
library('RColorBrewer')

args = commandArgs(trailingOnly=T)

data = read.csv(sprintf('out/%s_dist.csv', args[1]), sep=',', row.names=1)
data = as.matrix(data)
print(data)

n = nrow(data)
if (n > 9) {
  col = brewer.pal(n=9, name='Set1')
  col = colorRampPalette(col)(n)
} else {
  col = brewer.pal(n=n, name='Set1')
}

horiz = length(args) == 2
if (horiz) {
  data = data[n:1,]
}

png(sprintf('out/%s_dist.png', args[1]), width=1024, height=768)
barplot(data, col=col, border='white', font.axis=2, beside=T, legend=rownames(data), font.lab=2, horiz=horiz)
dev.off()
