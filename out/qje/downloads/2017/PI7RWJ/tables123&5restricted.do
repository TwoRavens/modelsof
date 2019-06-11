/*define global var*/
global demos "i.age i.educrec i.telephone i.incfamr68 i.marst i.metro"
global interactions "close_black_post_male close_black_post close_male_post i.black#i.male#i.state i.state#i.year i.black#i.male#i.year" 
global frcn_interactions "frcn_black_post_male frcn_black_post frcn_male_post i.black#i.male#i.state i.state#i.year i.black#i.male#i.year" 
global vet_interactions "close_black_post_nonvet close_black_post close_nonvet_post i.black#i.nonvet#i.year i.state#i.year i.black#i.nonvet#i.year" 

global drive "tempdrive" /*set drive*/
global maindata "main_data"

/* load data*/
use "$drive/data/$maindata", clear

/*open log file*/
log using "$drive/log/logfile.smcl", replace 

cd $drive/tables 
/*****************************************************************
*table 1: main results 
(1) visit 12
(2) any visit
(3) any hospital nights 
(4) number of nights 
******************************************************************/

reg visit12 $interactions $demos  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table1, keep(close_black_post_male close_black_post close_male_post  ) addtext(State-Black-Male State-Year Black-Male-Year FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters'))	title(Table 1: Quadruple)	excel replace 

reg anyvisit $interactions $demos  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table1, keep(close_black_post_male close_black_post close_male_post   ) addtext(Demographic Controls, YES, Number Clusters, e(`clusters'))		excel append

reg hospnghtd   $interactions  $demos [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table1, keep(close_black_post_male close_black_post close_male_post   ) addtext(Demographic Controls, YES, Number Clusters, e(`clusters'))	excel append

reg hospnited  $interactions $demos [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table1, keep(close_black_post_male close_black_post close_male_post  ) addtext(Demographic Controls, YES, Number Clusters, e(`clusters'))		excel append

/*****************************************************************
*saturated_table 2: robustness
(1) kids --- placebo 
(2) frcn
(3) frcn south 
(4) distance south 
(5) no controls
(6) add i.region#i.blackmale#i.post 

******************************************************************/
use "$drive/data/KIDSworking3.dta", clear
keep if age<=14
reg visit12 $interactions $demos  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table2, keep(close_black_post_male close_black_post close_male_post  ) addtext(State-Black-Male  State-Year Black-Male-Year  FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters')) ctitle(kids) title(Table 2: Robustness)	excel replace 

use "$drive/data/$maindata.dta", clear
reg visit12 $frcn_interactions $demos  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table2, keep(frcn_black_post_male frcn_black_post frcn_male_post ) addtext(State-Black-Male State-Year Black-Male-Year FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters'))  ctitle(migrants) excel append

reg visit12 $frcn_interactions $demos if region == 3  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table2, keep(frcn_black_post_male frcn_black_post frcn_male_post  ) addtext(State-Black-Male State-Year Black-Male-Year  FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters'))  ctitle(migrants-south only) excel append

reg visit12 $interactions $demos if region==3   [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table2, keep(close_black_post_male close_black_post close_male_post   ) addtext(State-Black-Male State-Year Black-Male-Year FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters'))  ctitle( distance-south only ) excel append

reg visit12 $interactions [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table2, keep(close_black_post_male close_black_post close_male_post   ) addtext(State-Black-Male State-Year Black-Male-Year  FE, YES, Demographic Controls, N0, Number Clusters, e(`clusters'))  ctitle( without demographics-ref 3 ) excel append

reg visit12 $demos  $interactions i.region#i.black#i.male#i.post  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table2, keep(close_black_post_male close_black_post close_male_post   ) addtext(State-Black-Male State-Year Black-Male-Year  FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters'))  ctitle( add regionblackmalepost -ref 3 ) excel append


/*****************************************************************
*saturated_table 3: heterogeneous effects
(1) married 
(2) not married 
(3) high income 
(4) low income 
(5) high education 
(6) low education 
(7) high black md
(8) low black md  
*******************************************************************/
reg visit12 $interactions $demos if married == 1  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table3, keep(close_black_post_male close_black_post close_male_post  ) addtext(State-Year Black-Male-Year FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters')) ctitle(Married) title(Table 3: Hetero Effects)	excel replace 

reg visit12 $interactions $demos if married == 0  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table3, keep(close_black_post_male close_black_post close_male_post  ) addtext(State-Year Black-Male-Year  FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters')) ctitle(Unmarried)	excel append 

	sum incfamr68 if male==1 & black==1, detail /*only one per household, so limit to male*/
	gen high_income=(incfamr68>r(p50))
	
reg visit12 $interactions $demos if high_income == 1  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table3, keep(close_black_post_male close_black_post close_male_post  ) addtext(State-Year Black-Male-Year FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters')) ctitle(High Income) excel append
	
reg visit12 $interactions $demos if high_income == 0  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table3, keep(close_black_post_male close_black_post close_male_post  ) addtext(State-Year Black-Male-Year FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters')) ctitle(Low Income) excel append

	gen Reduc = educrec2 
	replace Reduc = 0 if educrec2 == 98 | educrec2 == 99 
	sum Reduc if black==1 & male==1, detail /*only one per household, so limit to male*/
	gen high_ed=(Reduc>r(p50))
	drop Reduc 
	
reg visit12 $interactions $demos if high_ed == 1  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table3, keep(close_black_post_male close_black_post close_male_post  ) addtext(State-Year Black-Male-Year  FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters')) ctitle(High Education) excel append

reg visit12 $interactions $demos if high_ed == 0  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table3, keep(close_black_post_male close_black_post close_male_post  ) addtext(State-Year Black-Male-Year , YES, Demographic Controls, YES, Number Clusters, e(`clusters')) ctitle(Low Education) excel append

reg visit12 $interactions $demos if high_blackMD == 1  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table3, keep(close_black_post_male close_black_post close_male_post  ) addtext(State-Year Black-Male-Year FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters')) ctitle(High BlacMD) excel append

reg visit12 $interactions $demos if high_blackMD == 0  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table3, keep(close_black_post_male close_black_post close_male_post  ) addtext(State-Year Black-Male-Year  FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters')) ctitle(Low BlackMD) excel append


/************************************
*saturated_table 4: vets only more outcomes 
(1) visit 12
(2) any visit
(3) any hospital nights 
(4) number of nights 
***********************************/
use "$drive/data/VETSworking3.dta", clear
reg visit12 $vet_interactions $demos  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table4, keep( close_black_post_nonvet close_black_post close_nonvet_post ) addtext(State-NonVet-Black State-Year Nonvet-Male-Year  FE, YES, Demographic Controls, YES, Number Clusters, e(`clusters')) title(Veterans) ctitle(visit12) excel replace

reg anyvisit $vet_interactions $demos  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table4, keep( close_black_post_nonvet close_black_post close_nonvet_post ) ctitle(anyvisit) excel append 

reg hospnghtd  $vet_interactions $demos  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table4, keep( close_black_post_nonvet close_black_post close_nonvet_post ) ctitle(hospnghtd) excel append 

reg hospnited   $vet_interactions $demos  [pw=WEIGHT], vce(cluster state) 
local clusters=e(N_clust)
outreg2 using saturated_table4, keep( close_black_post_nonvet close_black_post close_nonvet_post ) ctitle(hospnumd) excel append 

log close 
