clear
set more off

do firstclose .2 1 1

regress fr_forces_mean below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ fr_forces_mean if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons replace se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

regress fw_opday_dummy below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ fw_opday_dummy if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

regress fw_init below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ fw_init if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend


regress fr_opday_dummy below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ fw_opday_dummy if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

regress fr_init below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ fw_init if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

regress naval_attack below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ naval_attack if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

regress sh_pf_presence below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ sh_pf_presence if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

regress sh_rf_presence below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ sh_rf_presence if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

regress psdf_dummy below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ psdf_dummy if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

regress phh_psdf below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ phh_psdf if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

regress rdc_active below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons robust cluster(villageid)	
summ rdc_active if e(sample)==1
local mean : display %4.2f `r(mean)'
outreg, varlabel nocons merge se bdec(3) nostars summstat(N) summtitles("Obs") keep(below) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend

outreg using table2b, replay replace tex ctitles("", "Dependent variable is:"  \ "", "Immediate ($ t+1$)", "", "", "", \"","Friendly","US", "US", "SVN", "SVN", "Naval", "Regional", "Popular", "PSDF", "\% HH", "RD Cadre" \ "", "Forces", "Ops", "Attacks", "Ops", "Attacks", "Attacks", "Forces", "Forces", "Present", "PSDF", "Present" \ "",  "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)", "(8)", "(9)", "(10)", "(11)") multicol(1, 2, 11; 2, 2, 11) hlines(110001{0}1) plain fragment nocenter


