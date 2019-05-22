#install.packages(c('reshape', 'RColorBrewer'))
library(reshape)
library(RColorBrewer)

args = commandArgs(trailingOnly=T)
for (kind in c('commands', 'regressions')) { 
    all = NULL
    for (journal in args) {
        df = read.csv(sprintf('out/%s/%s.csv', journal, kind), sep=',')
        df$journal = journal
        if (!is.data.frame(all)) {
            all = df
        } else {
            all = rbind(all, df)
        } 

        sums = aggregate(df$count, list(year=df$year), sum)
        df$prop = df$count / sums$x[match(df$year, sums$year)]
        sums = aggregate(df$prop, list(command=df$command), sum)
        top = sums[order(-sums$x),][1:20,]
        sub = df[df$command %in% top$command,]
        data = cast(sub, year~command, sum)
        rownames(data) = data$year

        png(sprintf('out/%s/%s.png', journal, kind), width=1600, height=1200)
        par(mar=c(4, 7, 4, 4))
        barplot(as.matrix(data), col=brewer.pal(n=nrow(data), name='Set1'), border='white', beside=T, legend=rownames(data), las=T, horiz=T)
        dev.off()
    }

    df = subset(all, year == '2018') 
    sums = aggregate(df$count, list(journal=df$journal), sum)
    df$prop = df$count / sums$x[match(df$journal, sums$journal)]
    sums = aggregate(df$prop, list(command=df$command), sum)
    top = sums[order(-sums$x),][1:20,]
    sub = df[df$command %in% top$command,]
    data = cast(sub, journal~command, sum)
    rownames(data) = data$journal

    png(sprintf('out/%s.png', kind), width=1600, height=1200)
    par(mar=c(4, 7, 4, 4))
    barplot(as.matrix(data), col=brewer.pal(n=nrow(data), name='Set1'), border='white', beside=T, legend=rownames(data), las=T, horiz=T)
    dev.off()
}
