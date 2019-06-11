clear
set more off

**Immediate first stage
do firstclose .2 1 1
regress fr_strikes_mean below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ fr_strikes_mean if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons replace se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

***Immediate period t
do plac_fs0 .2 
regress fr_strikes_mean below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ fr_strikes_mean if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

*** Immediate period t-1
do plac_fs .2 1 1
regress fr_strikes_mean below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ fr_strikes_mean if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

***Immediate 1969 placebo 
do plac69 .2 1
regress fr_strikes_mean below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ fr_strikes_mean if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

***Cumulative first stage
do firstclose .2 1 12
regress fr_strikes_mean below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ fr_strikes_mean if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

***Cumulative pre-period placebo
do plac_fs .2 1 16
regress fr_strikes_mean below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ fr_strikes_mean if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

**Cumulative first stage, 1969 placebo
do plac69 .2 14
regress fr_strikes_mean below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ fr_strikes_mean if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend


outreg using table2, replay replace tex ctitles("", "Dependent Variable is Share Months Bomb/Artillery:" \ "", "$ t+1$", "$ t$", "$ t-1$", "$ t+1$", "Post", "Pre", "Post" \ "", "70-72", "70-72", "70-72", "69", "70-72", "70-72", "69" \ "",  "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)") multicol(1, 2, 7) hlines(11001{0}1) plain fragment nocenter













