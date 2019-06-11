args outcome add

quietly ivregress 2sls `outcome' (fr_strikes_mean=below) md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
quietly estat firststage 
mat fstat = r(singleresults)
local fs = fstat[1,4] 
local fstat : display %4.2f `fs'
quietly summ `outcome' if e(sample)==1 [aw=oweight20]
local mean : display %4.2f `r(mean)'
quietly outreg, tex varlabel nocons `add' se bdec(3) nostars summstat(N) summtitles("Obs") keep(fr_strikes_mean) addrows(Clusters, `e(N_clust)' \ "F stat", `fstat' \ Mean, `mean') nolegend
