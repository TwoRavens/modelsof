#install.packages(c('dplyr', 'RColorBrewer', 'tidyr'))
library(dplyr)
library(RColorBrewer)
library(tidyr)

args = commandArgs(trailingOnly=T)

df = read.csv(sprintf('out/%s.csv', args[1]), sep=',', row.names=NULL) %>%
    group_by(journal) %>%
    mutate(perc=prop.table(n) * 100) %>%
    select(-n) %>%
    spread(journal, perc, 0) %>%
    as.data.frame
data = data.matrix(df[,-1])
rownames(data) = df[,1]
data = t(data)
print(data)

n = nrow(data)
horiz = length(args) == 2
if (horiz) {
  data = data[n:1,]
}

png(sprintf('out/%s.png', args[1]), width=1600, height=1200)
barplot(data, col=brewer.pal(n=3, name='Set1'), border='white', las=1, beside=T, legend=rownames(data), horiz=T)
dev.off()
