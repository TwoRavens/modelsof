*One-regime model of price and occupancy rates (cluster radius 0.2 miles)

*price regression
reg ladr cluster1f f2 f4 lncluster lcclusterm varietydh sizes typef bwest2-ramad2 fittedsp42 lpopf lpcincomef gas lland lwage ldistmsaf ldistloc locf1 locf3-locf10 y2-y12, cluster(cl)

***occupance rate regression
reg locc100 cluster1f f2 f4 lncluster lcclusterm varietydh sizes typef bwest2-ramad2 fittedsp42 lpopf lpcincomef gas lland lwage ldistmsaf ldistloc locf1 locf3-locf10 y2-y12, cluster(cl)
