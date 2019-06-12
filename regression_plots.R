#install.packages(c('reshape', 'RColorBrewer'))
library(reshape)
library(RColorBrewer)

args = commandArgs(trailingOnly=T)

all = NULL
for (journal in args) {
    f = sprintf('out/%s/regressions.csv', journal)
    if (file.exists(f)) {
        df = read.csv(f, sep=',')
        df$journal = journal
        if (!is.data.frame(all)) {
            all = df
        } else {
            all = rbind(all, df)
        } 
    }
}

df = subset(all, year == '2018') 
sums = aggregate(df$count, list(journal=df$journal), sum)
df$prop = df$count / sums$x[match(df$journal, sums$journal)]
data = cast(df, journal~command, sum)
rownames(data) = data$journal

png('out/regressions.png', width=1920, height=4320)
par(mar=c(4, 11, 4, 4))
barplot(as.matrix(data), col=brewer.pal(n=nrow(data), name='Set1'), border='white', beside=T, legend=rownames(data), las=T, horiz=T)
dev.off()
