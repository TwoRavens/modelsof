
*** Replication file: Issue engagement in election campaigns: the impact of electoral incentives and organizational constraints (Thomas M. Meyer & Markus Wagner)

 
** default settings **
clear
version 11.0
set more off
set mem 512M, 
set scheme sj
set trace off
capture log close


** define directories **

* directory where data is saved
global DATADIR  " *ENTER PATH* " // e.g. "C:\Data"
* directory for graphs and tables
global GRAPHDIR " *ENTER PATH* " // e.g. "C:\Graphs"

** change to working directory **
cd "$DATADIR"


**************************************
*** Descriptives (Appendix C)
**************************************  
use press_releases_2008.dta, clear 

*** Info: Table C.1
tab party 
gen share_policy=1 if issue_id~=.
replace share_policy=0 if issue_id==.
tab share_policy
bysort party: sum share_policy
drop share_policy


*** Figure C.1
gen help_count=1 if issue_id~=.
bysort issue_id: egen no_releases=total(help_count)
replace no_releases=. if issue_id==.
bysort issue_id: gen issue_id_graph=_n
drop help_* 

hist no_releases if issue_id_graph==1 & issue_id~=., width(1) ///
	discrete freq ///
	graphregion(color(white)) ///	
	xsize(5) ///
	ysize(4) ///
	ylabel(0(10)40, nogrid) ///
	ytitle("Number of issues") ///
	xtitle("Number of party press releases",) ///
	text(3 156 "fighting" "inflation", size(small)) ///
	text(3 126 "reduction of" "value-added tax", size(small)) 

cd "$GRAPHDIR"
graph save "figC1.gph", replace	
cd "$DATADIR"


*** Figure C.2
bysort issue_id (party_id): gen helpvar=_n
gen helpid=_n in 1/5

forval i=1/5 {
   bysort issue_id party_id: gen helpvar2=_n
   * issue emphasis of rival parties
   gen helpvar3=1 if issue_id~=. & helpvar2==1 & party_id~=`i'
   bysort issue_id: egen total_rivals`i'=total(helpvar3)   
   *select those issues chosen by party i
   gen helpvar4=1 if issue_id~=. & helpvar2==1 & party_id==`i' 
   bysort issue_id: egen total_party`i'=total(helpvar4)
   
   gen total_parties`i'=total_rivals`i' if total_party`i'>0 & total_party`i'~=.
   drop helpvar2 helpvar3 helpvar4 
}   

forval i=0/4 {
   gen share`i'=.
   forval j=1/5 {
	  sum total_parties`j'      if total_parties`j'==`i' & helpvar==1 & issue_id~=.
      replace share`i'=r(N)     if `j'==_n
	}
}	

list share* in 1/5
preserve
drop if _n>5
graph bar (sum) share0 share1 share2 share3 share4 in 1/5, stack over(helpid, relabel(1 "SPÖ" 2 "ÖVP" 3 "FPÖ" 4 "BZÖ" 5 "Greens"))  bar(1, color(gs0)) bar(2, color(gs3)) bar(3, color(gs6)) bar(4, color(gs9)) bar(5, color(gs12)) ///
   graphregion(color(white)) ///
   ytitle(" Policy issues " " " , size(3)) ///
   ylabel(0(20)120,nogrid)  ///
   xsize(10)  ///
   ysize(6)  ///
   title(" ", size(4)) ///
   legend(label(1 "not shared") label(2 "one other competitor") label(3 "two other competitors") label(4 "three other competitors") label(5 "four other competitors") order(5 4 3 2 1)  col(1) ring(0) position(2))
   
cd "$GRAPHDIR"
graph save figC2.gph, replace
cd "$DATADIR"   
restore
drop   helpvar helpid total_rivals1- total_parties5 share*



******************************************************************
*** Dyad data: Regression analyses & simulation
******************************************************************

use dyad_data.dta, clear


*****************  
*** Figures 1 & 2
*****************  

* Figure 1: Issue engagement and ideological proximity
scatter share_engagement_dyad_area positiondiff_manifesto if id_dyad_area==1, ///
   msymbol(oh) ///
   mcolor(black) ///
   aspectratio(1) /// 
   graphregion(color(white)) ///
   xsize(4) ///
   ysize(4) ///
   ylabel(,nogrid) ///
   xtitle(" Policy distance ") ///
   ytitle("Issue engagement" "by party dyad/policyarea (in %)" " ") 

  cd "$GRAPHDIR"
graph save "fig1.gph", replace	
cd "$DATADIR"
 
   
 
* Figure 2: Issue engagement and party resources
gen party_comb2=1 if party_comb==1
replace party_comb2=2 if party_comb==2
replace party_comb2=3 if party_comb==5
replace party_comb2=4 if party_comb==3
replace party_comb2=5 if party_comb==4
replace party_comb2=6 if party_comb==6
replace party_comb2=7 if party_comb==7
replace party_comb2=8 if party_comb==8
replace party_comb2=9 if party_comb==9
replace party_comb2=10 if party_comb==10

label define combination2 1 "SPÖ-ÖVP" 2 "SPÖ-FPÖ" 3 "ÖVP-FPÖ" 4 "SPÖ-BZÖ" 5 "SPÖ-Greens"  6 "ÖVP-BZÖ" 7 "ÖVP-Greens"  8 "FPÖ-BZÖ" 9 "FPÖ-Greens"  10 "BZÖ-Greens" 
label values party_comb2 combination2
 
scatter share_engagement_dyad party_comb2 if id_dyad==1, ///
   msymbol(oh) ///
   mcolor(black) ///
   aspectratio(1) /// 
   graphregion(color(white)) ///
   xsize(4) ///
   ysize(4) ///
   xline(1.5) ///
   xline(3.5) ///
   xline(7.5) ///
   xline(9.5) ///  
   text(50 0.8  "L - L", place(c) size(3) ) ///
   text(50 2.5  "L - M", place(c) size(3) ) ///
   text(50 5.5  "L - S", place(c) size(3) ) ///
   text(50 8.5    "M - S", place(c) size(3) ) ///
   text(50 10.25  "S - S", place(c) size(3) ) ///
   ylabel(0(10)50,nogrid) ///
   xscale(range(0.5 10.5)) ///
   xlabel(1(1)10, valuelabel angle(45) labsize(small)) ///
   xtitle(" ") ///
   ytitle("Issue engagement by party dyad (in %)" " ")
   
cd "$GRAPHDIR"
graph save "fig2.gph", replace	
cd "$DATADIR"

spearman share_engagement_dyad partyplayers if id_dyad==1
   

**************************** 
*** Regression analyses
**************************** 

* Explaining issue engagement between party pairs (logistic regression models) (Table 1)
logit      common  positiondiff_manifesto                                                             salienceprod_manifesto mention_rivals min_responsibility  mediaissue_print_share, cluster(clustervar)
est sto mod1
logit      common                          partyplayers1 partyplayers2 partyplayers4  partyplayers5   salienceprod_manifesto mention_rivals min_responsibility  mediaissue_print_share,  cluster(clustervar) 
est sto mod2
logit      common  positiondiff_manifesto  partyplayers1 partyplayers2 partyplayers4  partyplayers5   salienceprod_manifesto mention_rivals min_responsibility  mediaissue_print_share, cluster(clustervar)
est sto mod3

cd "$GRAPHDIR"
esttab mod1 mod2 mod3 using "Table 1.rtf", replace title(Issue engagement) order(positiondiff_manifesto partyplayers1 partyplayers2 partyplayers4 partyplayers5   salienceprod_manifesto mention_rivals min_responsibility mediaissue_print_share ) addnotes(" ")  label compress nostar scalar(ll bic) nogaps sfmt(3) obslast p mtitles("Model 1" "Model 2" "Model 3") 
cd "$DATADIR"



* alternative specification of the DV : negative binomial regression (Table D.1)
nbreg      common_count  positiondiff_manifesto                                                            salienceprod_manifesto mention_rivals min_responsibility  mediaissue_print_share, cluster(clustervar)
est sto mod1_count
nbreg      common_count                          partyplayers1 partyplayers2 partyplayers4  partyplayers5  salienceprod_manifesto mention_rivals min_responsibility  mediaissue_print_share,  cluster(clustervar) 
est sto mod2_count
nbreg      common_count  positiondiff_manifesto  partyplayers1 partyplayers2 partyplayers4  partyplayers5  salienceprod_manifesto mention_rivals min_responsibility  mediaissue_print_share, cluster(clustervar)
est sto mod3_count

cd "$GRAPHDIR"
esttab mod1_count mod2_count mod3_count using "Table D1.rtf", replace title(Issue engagement) order(positiondiff_manifesto partyplayers1 partyplayers2 partyplayers4 partyplayers5  salienceprod_manifesto mention_rivals  min_responsibility mediaissue_print_share) addnotes(" ")  label compress nostar scalar(ll bic) nogaps sfmt(3) obslast p mtitles("Model 1" "Model 2" "Model 3") 
cd "$DATADIR"


* alternative data structure: issue engagement per issue area (i.e. party dyads by policy areas) (Table D.2)
bysort party_comb policyarea: gen regress_option=1 if _n==1
bysort party_comb policyarea: egen mean_mention_rivals=mean(mention_rivals)
label var  mean_mention_rivals "Systemic salience"

regress      share_engagement_dyad_area  positiondiff_manifesto                                                            salienceprod_manifesto  mean_mention_rivals min_responsibility  mediaissue_print_share if regress_option==1, cluster(party_comb)
est sto mod1_reg
regress      share_engagement_dyad_area                         partyplayers1 partyplayers2 partyplayers4  partyplayers5   salienceprod_manifesto  mean_mention_rivals min_responsibility  mediaissue_print_share if regress_option==1, cluster(party_comb)
est sto mod2_reg
regress      share_engagement_dyad_area  positiondiff_manifesto partyplayers1 partyplayers2 partyplayers4  partyplayers5   salienceprod_manifesto  mean_mention_rivals min_responsibility  mediaissue_print_share if regress_option==1, cluster(party_comb)
est sto mod3_reg

cd "$GRAPHDIR"
esttab mod1_reg mod2_reg mod3_reg using "Table D2.rtf", replace title(Issue engagement) order(positiondiff_manifesto partyplayers1 partyplayers2 partyplayers4 partyplayers5   salienceprod_manifesto  mean_mention_rivals  min_responsibility  mediaissue_print_share) addnotes(" ")  label compress nostar scalar(r2_a rmse) nogaps sfmt(3) obslast p mtitles("Model 1" "Model 2" "Model 3") 
cd "$DATADIR"


***********************************************************************************************************************************************************
*** effect sizes based on Table 1, Model 3
*** estimates based on Clarify (http://gking.harvard.edu/publications/clarify-software-interpreting-and-presenting-statistical-results)
***********************************************************************************************************************************************************

estsimp logit      common  partyplayers1 partyplayers2 partyplayers4  partyplayers5  positiondiff_manifesto   min_responsibility  mention_rivals  salienceprod_manifesto  mediaissue_print_share, cluster(clustervar)


************************************
*** H1: Effect of policy difference
sum positiondiff_manifesto if id_dyad_area==1, detail
tab positiondiff_manifesto party_comb if id_dyad_area==1
tab positiondiff_manifesto policyarea if party_comb==7 & id_dyad_area==1

setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto mean  min_responsibility  0 mention_rivals p50 salienceprod_manifesto mean  mediaissue_print_share mean 
simqi
setx partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto 0.53+0.44  min_responsibility  0 mention_rivals p50 salienceprod_manifesto mean  mediaissue_print_share mean 
simqi

* hypothetical example: (0.1) and (1.00)
setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto 0.1  min_responsibility  0 mention_rivals p50 salienceprod_manifesto mean  mediaissue_print_share mean 
simqi
setx partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto 1  min_responsibility  0 mention_rivals p50 salienceprod_manifesto mean  mediaissue_print_share mean 
simqi

* empirical example: ÖVP-Greens on EU (0.17) and civil liberties vs. law/order (1.48)
setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto 0.17  min_responsibility  0 mention_rivals p50 salienceprod_manifesto mean  mediaissue_print_share mean 
simqi
setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto 1.48  min_responsibility  0 mention_rivals p50 salienceprod_manifesto mean  mediaissue_print_share mean 
simqi
tab share_engagement_dyad_area policyarea if id_dyad_area==1 & party_comb==7


**********************************************
*** H2: Effect of resources (min -> max)
setx  partyplayers1 1 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto mean  min_responsibility  0 mention_rivals p50 salienceprod_manifesto mean  mediaissue_print_share mean 
simqi
setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 1  positiondiff_manifesto mean  min_responsibility  0 mention_rivals p50 salienceprod_manifesto mean  mediaissue_print_share mean 
simqi


**********************************************
*** Effects of control variables


*** manifesto salience
sum salienceprod_manifesto if id_dyad_area==1
tab salienceprod_manifesto party_comb if id_dyad_area==1
tab salienceprod_manifesto policyarea if party_comb==8 & id_dyad_area==1
tab salience_p1_manifesto salience_p2_manifesto if party_comb==8 & id_dyad_area==1 & policyarea==2
tab salience_p1_manifesto salience_p2_manifesto if party_comb==8 & id_dyad_area==1 & policyarea==16

setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto mean  min_responsibility  0 mention_rivals p50  salienceprod_manifesto mean  mediaissue_print_share mean 
simqi
setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto mean  min_responsibility  0 mention_rivals p50  salienceprod_manifesto .015816+.0208705  mediaissue_print_share mean 
simqi

* FPÖ/BZÖ - urban-rural (3 & 1 per cent) vs. economic issues (15*15)
setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto mean  min_responsibility  0 mention_rivals p50 salienceprod_manifesto 0.03*0.01  mediaissue_print_share mean 
simqi
setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto mean  min_responsibility  0 mention_rivals p50 salienceprod_manifesto 0.15*0.15 mediaissue_print_share mean 
simqi



*** systemic salience (1 modus and median by 1: 1->2)
sum mention_rivals
setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto mean  min_responsibility  0 mention_rivals 1 salienceprod_manifesto mean  mediaissue_print_share mean 
simqi
setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto mean  min_responsibility  0 mention_rivals 2 salienceprod_manifesto mean  mediaissue_print_share mean
simqi



*** ministerial responsibility effect
setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto mean  min_responsibility  0 mention_rivals p50 salienceprod_manifesto mean  mediaissue_print_share mean 
simqi
setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto mean  min_responsibility  1 mention_rivals p50 salienceprod_manifesto mean  mediaissue_print_share mean 
simqi


*** media effect
sum mediaissue_print_share if id_area==1

setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto mean  min_responsibility  0 mention_rivals p50 salienceprod_manifesto mean  mediaissue_print_share mean 
simqi
setx  partyplayers1 0 partyplayers2 0 partyplayers4  0 partyplayers5 0  positiondiff_manifesto mean  min_responsibility  0 mention_rivals p50 salienceprod_manifesto mean  mediaissue_print_share .0625+.0459608
simqi




********************************************************************************************************************************************
*** simulations/randomization testing - based on Table 1
*** see Erikson et al. 2014 - "Dyadic Analysis in International Relations: A Cautionary Tale" - doi:10.1093/pan/mpt051
********************************************************************************************************************************************

*** Note: Execution wil take several minutes


save sim_data.dta,replace


use sim_data.dta, clear

set matsize 1000
set seed 333

* set number of sims, retrieve info from regression models
local sim=1000
est restore mod1
matrix b1=e(b)
local max1=colsof(b1)
matrix Z_mod1= J(`sim',`max1',.)
est restore mod2
matrix b2=e(b)
local max2=colsof(b2)
matrix Z_mod2= J(`sim',`max2',.)
est restore mod3
matrix b3=e(b)
local max3=colsof(b3)
matrix Z_mod3= J(`sim',`max3',.)

* shuffle party dyads: random variation (1,2,3,4,5) -> (?,?,?,?,?)
gen idfrom=_n in 1/5
gen p1=1 if party_comb>=1 & party_comb<=4
replace p1=2 if party_comb>=5 & party_comb<=7
replace p1=3 if party_comb>=8 & party_comb<=9
replace p1=4 if party_comb==10

gen p2=2 if party_comb==1 
replace p2=3 if party_comb==2 | party_comb==5
replace p2=4 if party_comb==3 | party_comb==6 | party_comb==8
replace p2=5 if party_comb==4 | party_comb==7 | party_comb==9  | party_comb==10

* start simulations: in each run,...
*                                ...estimate regression models based on reshuffled party dyads
* 	                             ...retrieve z-values based on artificial, random DV                            
set more off
forval i=1/`sim' {
	sort idfrom
	gen random=uniform() in 1/5
	sort random
	gen idto`i'=_n in 1/5
	drop random*	
	sort idfrom

	gen p1_rand=.
	gen p2_rand=.

	forval j=1/5 {
		sum idto`i' if idfrom==`j'	
		replace p1_rand=r(mean) if p1==`j'
		replace p2_rand=r(mean) if p2==`j'	
	}	

	gen      party_comb_rand=1 if  (p1_rand==1 & p2_rand==2) | (p2_rand==1 & p1_rand==2)
	replace  party_comb_rand=2 if  (p1_rand==1 & p2_rand==3) | (p2_rand==1 & p1_rand==3)
	replace  party_comb_rand=3 if  (p1_rand==1 & p2_rand==4) | (p2_rand==1 & p1_rand==4)
	replace  party_comb_rand=4 if  (p1_rand==1 & p2_rand==5) | (p2_rand==1 & p1_rand==5)
	replace  party_comb_rand=5 if  (p1_rand==2 & p2_rand==3) | (p2_rand==2 & p1_rand==3)
	replace  party_comb_rand=6 if  (p1_rand==2 & p2_rand==4) | (p2_rand==2 & p1_rand==4)
	replace  party_comb_rand=7 if  (p1_rand==2 & p2_rand==5) | (p2_rand==2 & p1_rand==5)
	replace  party_comb_rand=8 if  (p1_rand==3 & p2_rand==4) | (p2_rand==3 & p1_rand==4)
	replace  party_comb_rand=9 if  (p1_rand==3 & p2_rand==5) | (p2_rand==3 & p1_rand==5)
	replace  party_comb_rand=10 if (p1_rand==4 & p2_rand==5) | (p2_rand==4 & p1_rand==5)
	
	* generate new dependent variable in the reshuffled, artificial data
	gen common_new=.			
	forval j=1/10 {
		bysort  issue_id: egen helpvar=mean(common) if party_comb== `j'
		bysort  issue_id: egen helpvar2=total(helpvar) 
		sum party_comb_rand if helpvar~=.		
		replace common_new=helpvar2 if party_comb==r(mean)
		drop helpvar*	
	}	
 
    * estimate regressio models using the reshuffled, artificial DV
	logit      common_new  positiondiff_manifesto                                                             salienceprod_manifesto  mention_rivals min_responsibility  mediaissue_print_share, cluster(clustervar)
	est sto mod1_new`i'
	logit      common_new                          partyplayers1 partyplayers2 partyplayers4  partyplayers5   salienceprod_manifesto  mention_rivals min_responsibility  mediaissue_print_share,  cluster(clustervar)
	est sto mod2_new`i'
	logit      common_new  positiondiff_manifesto  partyplayers1 partyplayers2 partyplayers4  partyplayers5   salienceprod_manifesto  mention_rivals min_responsibility  mediaissue_print_share, cluster(clustervar)
	est sto mod3_new`i'	

	* save z-values
	est restore mod1_new`i'
	matrix b1=e(b)
	matrix V1=vecdiag(e(V))
	local max1=colsof(b1)
	forval k=1/`max1' {
		matrix Z_mod1[`i',`k']=b1[1,`k']/sqrt(V1[1,`k'])
	}
	
	est restore mod2_new`i'
	matrix b2=e(b)
	matrix V2=vecdiag(e(V))
	local max2=colsof(b2)
	forval k=1/`max2' {
		matrix Z_mod2[`i',`k']=b2[1,`k']/sqrt(V2[1,`k'])
	}
	
	est restore mod3_new`i'
	matrix b3=e(b)
	matrix V3=vecdiag(e(V))
	local max3=colsof(b3)
	forval k=1/`max3' {
		matrix Z_mod3[`i',`k']=b3[1,`k']/sqrt(V3[1,`k'])
	}
	
	estimates drop mod1_new`i' mod2_new`i'	mod3_new`i'		
	drop p1_rand p2_rand party_comb_rand common_new
}

	
drop idfrom idto*

svmat Z_mod1,names(z_mod1_)
svmat Z_mod2,names(z_mod2_)
svmat Z_mod3,names(z_mod3_)

save sim_data_finished.dta, replace




*** compare z-values in simulated, random data with models 1-3 (Table 1)
	est restore mod1
	matrix b1=e(b)
	local max1=colsof(b1)
	matrix Z_mod1_orig= J(1,`max1',.)
	matrix p_mod1= J(1,`max1',.)

	matrix b1=e(b)
	matrix V1=vecdiag(e(V))
	forval k=1/`max1' {
		gen abs_z_mod1_`k'=abs(z_mod1_`k')
		matrix Z_mod1_orig[1,`k']=b1[1,`k']/sqrt(V1[1,`k'])
		sum  abs_z_mod1_`k' if abs_z_mod1_`k'>abs(Z_mod1_orig[1,`k'])
		matrix p_mod1[1,`k']=(r(N))/1000
		gen p_values_mod1_`k'=2*normal(-abs_z_mod1_`k')
	}
* Pr(test_stat(reshuffle)>test_stat(orig))
matrix list p_mod1	
drop  abs_z_mod1_* p_values_mod1_*
	
	
	est restore mod2
	matrix b2=e(b)	
	local max2=colsof(b2)
	matrix Z_mod2_orig= J(1,`max2',.)
	matrix p_mod2= J(1,`max2',.)
	
	matrix b2=e(b)
	matrix V2=vecdiag(e(V))
	forval k=1/`max2' {
		gen abs_z_mod2_`k'=abs(z_mod2_`k')
		matrix Z_mod2_orig[1,`k']=b2[1,`k']/sqrt(V2[1,`k'])
		sum  abs_z_mod2_`k' if abs_z_mod2_`k'>abs(Z_mod2_orig[1,`k'])
		matrix p_mod2[1,`k']=(r(N))/1000	
		gen p_values_mod2_`k'=2*normal(-abs_z_mod2_`k')		
	}
* Pr(test_stat(reshuffle)>test_stat(orig))
matrix list p_mod2	
drop  abs_z_mod2_* p_values_mod2_*


	est restore mod3
	matrix b3=e(b)		
	local max3=colsof(b3)
	matrix Z_mod3_orig= J(1,`max3',.)
	matrix p_mod3= J(1,`max3',.)
	
	matrix b3=e(b)
	matrix V3=vecdiag(e(V))
	forval k=1/`max3' {
		gen abs_z_mod3_`k'=abs(z_mod3_`k')
		matrix Z_mod3_orig[1,`k']=b3[1,`k']/sqrt(V3[1,`k'])
		sum  abs_z_mod3_`k' if abs_z_mod3_`k'>abs(Z_mod3_orig[1,`k'])
		matrix p_mod3[1,`k']=(r(N))/1000	
		gen p_values_mod3_`k'=2*normal(-abs_z_mod3_`k')		
	}
* Pr(test_stat(reshuffle)>test_stat(orig))
matrix list p_mod3		
drop  abs_z_mod3_* p_values_mod3_*




**************************************************************************************
*** simulations/randomization testing (see Erikson et al. 2014) - count data (Table D.1)
**************************************************************************************

use sim_data.dta, clear

set matsize 1000
set seed 333

* set number of sims, retrieve info from regression models
local sim=1000
est restore mod1_count
matrix b1=e(b)
local max1=colsof(b1)
matrix Z_mod1= J(`sim',`max1',.)
est restore mod2_count
matrix b2=e(b)
local max2=colsof(b2)
matrix Z_mod2= J(`sim',`max2',.)
est restore mod3_count
matrix b3=e(b)
local max3=colsof(b3)
matrix Z_mod3= J(`sim',`max3',.)

* shuffle party dyads: random variation (1,2,3,4,5) -> (?,?,?,?,?)
gen idfrom=_n in 1/5
gen p1=1 if party_comb>=1 & party_comb<=4
replace p1=2 if party_comb>=5 & party_comb<=7
replace p1=3 if party_comb>=8 & party_comb<=9
replace p1=4 if party_comb==10

gen p2=2 if party_comb==1 
replace p2=3 if party_comb==2 | party_comb==5
replace p2=4 if party_comb==3 | party_comb==6 | party_comb==8
replace p2=5 if party_comb==4 | party_comb==7 | party_comb==9  | party_comb==10

* start simulations: in each run,...
*                                ...estimate regression models based on reshuffled party dyads
* 	                             ...retrieve z-values based on artificial, random DV 
set more off
forval i=1/`sim' {
	sort idfrom
	gen random=uniform() in 1/5
	sort random
	gen idto`i'=_n in 1/5
	drop random*	
	sort idfrom

	gen p1_rand=.
	gen p2_rand=.

	forval j=1/5 {
		sum idto`i' if idfrom==`j'	
		replace p1_rand=r(mean) if p1==`j'
		replace p2_rand=r(mean) if p2==`j'	
	}	

	gen      party_comb_rand=1 if  (p1_rand==1 & p2_rand==2) | (p2_rand==1 & p1_rand==2)
	replace  party_comb_rand=2 if  (p1_rand==1 & p2_rand==3) | (p2_rand==1 & p1_rand==3)
	replace  party_comb_rand=3 if  (p1_rand==1 & p2_rand==4) | (p2_rand==1 & p1_rand==4)
	replace  party_comb_rand=4 if  (p1_rand==1 & p2_rand==5) | (p2_rand==1 & p1_rand==5)
	replace  party_comb_rand=5 if  (p1_rand==2 & p2_rand==3) | (p2_rand==2 & p1_rand==3)
	replace  party_comb_rand=6 if  (p1_rand==2 & p2_rand==4) | (p2_rand==2 & p1_rand==4)
	replace  party_comb_rand=7 if  (p1_rand==2 & p2_rand==5) | (p2_rand==2 & p1_rand==5)
	replace  party_comb_rand=8 if  (p1_rand==3 & p2_rand==4) | (p2_rand==3 & p1_rand==4)
	replace  party_comb_rand=9 if  (p1_rand==3 & p2_rand==5) | (p2_rand==3 & p1_rand==5)
	replace  party_comb_rand=10 if (p1_rand==4 & p2_rand==5) | (p2_rand==4 & p1_rand==5)
	
	* generate new dependent variable in the reshuffled, artificial data	
	gen common_count_new=.			
	forval j=1/10 {
		bysort  issue_id: egen helpvar=mean(common_count) if party_comb== `j'
		bysort  issue_id: egen helpvar2=total(helpvar) 
		sum party_comb_rand if helpvar~=.		
		replace common_count_new=helpvar2 if party_comb==r(mean)
		drop helpvar*	
	}	

	* estimate regressio models using the reshuffled, artificial DV
	nbreg      common_count_new  positiondiff_manifesto                                                            salienceprod_manifesto mention_rivals  min_responsibility  mediaissue_print_share, cluster(clustervar)
	est sto mod1_count_new`i'
	nbreg      common_count_new                         partyplayers1 partyplayers2 partyplayers4  partyplayers5   salienceprod_manifesto mention_rivals  min_responsibility  mediaissue_print_share,  cluster(clustervar)
	est sto mod2_count_new`i'
	nbreg      common_count_new  positiondiff_manifesto partyplayers1 partyplayers2 partyplayers4  partyplayers5   salienceprod_manifesto mention_rivals  min_responsibility  mediaissue_print_share, cluster(clustervar)
	est sto mod3_count_new`i'	
	
	* save z-values
	est restore mod1_count_new`i'
	matrix b1=e(b)
	matrix V1=vecdiag(e(V))
	local max1=colsof(b1)
	forval k=1/`max1' {
		matrix Z_mod1[`i',`k']=b1[1,`k']/sqrt(V1[1,`k'])
	}
	
	est restore mod2_count_new`i'
	matrix b2=e(b)
	matrix V2=vecdiag(e(V))
	local max2=colsof(b2)
	forval k=1/`max2' {
		matrix Z_mod2[`i',`k']=b2[1,`k']/sqrt(V2[1,`k'])
	}
	
	est restore mod3_count_new`i'
	matrix b3=e(b)
	matrix V3=vecdiag(e(V))
	local max3=colsof(b3)
	forval k=1/`max3' {
		matrix Z_mod3[`i',`k']=b3[1,`k']/sqrt(V3[1,`k'])
	}
	
	estimates drop mod1_count_new`i' mod2_count_new`i'	mod3_count_new`i'	
	rename common_count_new common_count_new`i'
	drop p1_rand p2_rand party_comb_rand 
}

	
drop idfrom idto*

svmat Z_mod1,names(z_mod1_count_)
svmat Z_mod2,names(z_mod2_count_)
svmat Z_mod3,names(z_mod3_count_)

save sim_data_finished_count.dta, replace




*** compare z-values in simulated, random data with models 1-3 (Table D.1)
	est restore mod1_count
	matrix b1=e(b)
	local max1=colsof(b1)
	matrix Z_mod1_orig= J(1,`max1',.)
	matrix p_mod1= J(1,`max1',.)

	matrix b1=e(b)
	matrix V1=vecdiag(e(V))
	forval k=1/`max1' {
		gen abs_z_mod1_count_`k'=abs(z_mod1_count_`k')
		matrix Z_mod1_orig[1,`k']=b1[1,`k']/sqrt(V1[1,`k'])
		sum  abs_z_mod1_count_`k' if abs_z_mod1_count_`k'>abs(Z_mod1_orig[1,`k'])
		matrix p_mod1[1,`k']=(r(N))/1000
		gen p_values_mod1_count_`k'=2*normal(-abs_z_mod1_count_`k')
	}
* Pr(test_stat(reshuffle)>test_stat(orig))
matrix list p_mod1
drop  abs_z_mod1_count_* p_values_mod1_count_*
	
	
	est restore mod2_count
	matrix b2=e(b)	
	local max2=colsof(b2)
	matrix Z_mod2_orig= J(1,`max2',.)
	matrix p_mod2= J(1,`max2',.)
	
	matrix b2=e(b)
	matrix V2=vecdiag(e(V))
	forval k=1/`max2' {
		gen abs_z_mod2_count_`k'=abs(z_mod2_count_`k')
		matrix Z_mod2_orig[1,`k']=b2[1,`k']/sqrt(V2[1,`k'])
		sum  abs_z_mod2_count_`k' if abs_z_mod2_count_`k'>abs(Z_mod2_orig[1,`k'])
		matrix p_mod2[1,`k']=(r(N))/1000	
		gen p_values_mod2_count_`k'=2*normal(-abs_z_mod2_count_`k')		
	}
* Pr(test_stat(reshuffle)>test_stat(orig))
matrix list p_mod2
drop  abs_z_mod2_count_* p_values_mod2_count_*


	est restore mod3_count
	matrix b3=e(b)		
	local max3=colsof(b3)
	matrix Z_mod3_orig= J(1,`max3',.)
	matrix p_mod3= J(1,`max3',.)
	
	matrix b3=e(b)
	matrix V3=vecdiag(e(V))
	forval k=1/`max3' {
		gen abs_z_mod3_count_`k'=abs(z_mod3_count_`k')
		matrix Z_mod3_orig[1,`k']=b3[1,`k']/sqrt(V3[1,`k'])
		sum  abs_z_mod3_count_`k' if abs_z_mod3_count_`k'>abs(Z_mod3_orig[1,`k'])
		matrix p_mod3[1,`k']=(r(N))/1000	
		gen p_values_mod3_count_`k'=2*normal(-abs_z_mod3_count_`k')		
	}
* Pr(test_stat(reshuffle)>test_stat(orig))
matrix list p_mod3
drop  abs_z_mod3_count_* p_values_mod3_count_*





*******************************************************************************************************************
*** simulations/randomization testing (see Erikson et al. 2014) - with linear regression data (Table D.2)
*******************************************************************************************************************

use sim_data.dta, clear
keep if  regress_option==1
set matsize 1000
set seed 333

* set number of sims, retrieve info from regression models
local sim=1000
est restore mod1_reg
matrix b1=e(b)
local max1=colsof(b1)
matrix T_mod1= J(`sim',`max1',.)
est restore mod2_reg
matrix b2=e(b)
local max2=colsof(b2)
matrix T_mod2= J(`sim',`max2',.)
est restore mod3_reg
matrix b3=e(b)
local max3=colsof(b3)
matrix T_mod3= J(`sim',`max3',.)

* shuffle party dyads: random variation (1,2,3,4,5) -> (?,?,?,?,?)
gen idfrom=_n in 1/5
gen p1=1 if party_comb>=1 & party_comb<=4
replace p1=2 if party_comb>=5 & party_comb<=7
replace p1=3 if party_comb>=8 & party_comb<=9
replace p1=4 if party_comb==10

gen p2=2 if party_comb==1 
replace p2=3 if party_comb==2 | party_comb==5
replace p2=4 if party_comb==3 | party_comb==6 | party_comb==8
replace p2=5 if party_comb==4 | party_comb==7 | party_comb==9  | party_comb==10

* start simulations: in each run,...
*                                ...estimate regression models based on reshuffled party dyads
* 	                             ...retrieve z-values based on artificial, random DV 
set more off
forval i=1/`sim' {
	sort idfrom
	gen random=uniform() in 1/5
	sort random
	gen idto`i'=_n in 1/5
	drop random*	
	sort idfrom

	gen p1_rand=.
	gen p2_rand=.

	forval j=1/5 {
		sum idto`i' if idfrom==`j'	
		replace p1_rand=r(mean) if p1==`j'
		replace p2_rand=r(mean) if p2==`j'	
	}	

	gen      party_comb_rand=1 if  (p1_rand==1 & p2_rand==2) | (p2_rand==1 & p1_rand==2)
	replace  party_comb_rand=2 if  (p1_rand==1 & p2_rand==3) | (p2_rand==1 & p1_rand==3)
	replace  party_comb_rand=3 if  (p1_rand==1 & p2_rand==4) | (p2_rand==1 & p1_rand==4)
	replace  party_comb_rand=4 if  (p1_rand==1 & p2_rand==5) | (p2_rand==1 & p1_rand==5)
	replace  party_comb_rand=5 if  (p1_rand==2 & p2_rand==3) | (p2_rand==2 & p1_rand==3)
	replace  party_comb_rand=6 if  (p1_rand==2 & p2_rand==4) | (p2_rand==2 & p1_rand==4)
	replace  party_comb_rand=7 if  (p1_rand==2 & p2_rand==5) | (p2_rand==2 & p1_rand==5)
	replace  party_comb_rand=8 if  (p1_rand==3 & p2_rand==4) | (p2_rand==3 & p1_rand==4)
	replace  party_comb_rand=9 if  (p1_rand==3 & p2_rand==5) | (p2_rand==3 & p1_rand==5)
	replace  party_comb_rand=10 if (p1_rand==4 & p2_rand==5) | (p2_rand==4 & p1_rand==5)

	* generate new dependent variable in the reshuffled, artificial data	
	gen share_engagement_dyad_area_new=.			
	forval j=1/10 {
		bysort  policyarea: egen helpvar=mean(share_engagement_dyad_area) if party_comb== `j'
		bysort  policyarea: egen helpvar2=total(helpvar) 
		sum party_comb_rand if helpvar~=.		
		replace share_engagement_dyad_area_new=helpvar2 if party_comb==r(mean)
		drop helpvar*	
	}	

	* estimate regressio models using the reshuffled, artificial DV
	regress      share_engagement_dyad_area_new  positiondiff_manifesto                                                            salienceprod_manifesto  mean_mention_rivals min_responsibility  mediaissue_print_share, cluster(party_comb)
	est sto mod1_reg_new`i'
	regress      share_engagement_dyad_area_new                         partyplayers1 partyplayers2 partyplayers4  partyplayers5   salienceprod_manifesto  mean_mention_rivals min_responsibility  mediaissue_print_share,  cluster(party_comb)
	est sto mod2_reg_new`i'
	regress      share_engagement_dyad_area_new  positiondiff_manifesto partyplayers1 partyplayers2 partyplayers4  partyplayers5   salienceprod_manifesto  mean_mention_rivals min_responsibility  mediaissue_print_share, cluster(party_comb)
	est sto mod3_reg_new`i'	
	
	* save t-values
	est restore mod1_reg_new`i'
	matrix b1=e(b)
	matrix V1=vecdiag(e(V))
	local max1=colsof(b1)
	forval k=1/`max1' {
		matrix T_mod1[`i',`k']=b1[1,`k']/sqrt(V1[1,`k'])
	}
	
	est restore mod2_reg_new`i'
	matrix b2=e(b)
	matrix V2=vecdiag(e(V))
	local max2=colsof(b2)
	forval k=1/`max2' {
		matrix T_mod2[`i',`k']=b2[1,`k']/sqrt(V2[1,`k'])
	}
	
	est restore mod3_reg_new`i'
	matrix b3=e(b)
	matrix V3=vecdiag(e(V))
	local max3=colsof(b3)
	forval k=1/`max3' {
		matrix T_mod3[`i',`k']=b3[1,`k']/sqrt(V3[1,`k'])
	}
	
	estimates drop mod1_reg_new`i' mod2_reg_new`i'	mod3_reg_new`i'	 	
	drop p1_rand p2_rand party_comb_rand share_engagement_dyad_area_new
}

	
drop idfrom idto*

svmat T_mod1,names(t_mod1_)
svmat T_mod2,names(t_mod2_)
svmat T_mod3,names(t_mod3_)

save sim_data_finished_reg.dta, replace




*** compare t-values in simulated, random data with models 1-3 (Table D.2)
	est restore mod1_reg
	matrix b1=e(b)
	local N1=e(N)
	local max1=colsof(b1)
	display `N1' `max1'
	matrix T_mod1_orig= J(1,`max1',.)
	matrix p_mod1= J(1,`max1',.)

	matrix b1=e(b)
	matrix V1=vecdiag(e(V))
	forval k=1/`max1' {
		gen abs_t_mod1_`k'=abs(t_mod1_`k')
		matrix T_mod1_orig[1,`k']=b1[1,`k']/sqrt(V1[1,`k'])
		sum  abs_t_mod1_`k' if abs_t_mod1_`k'>abs(T_mod1_orig[1,`k'])
		matrix p_mod1[1,`k']=(r(N))/1000
		gen p_values_mod1_`k'=2*ttail((`N1'-`max1'),abs_t_mod1_`k')
	}
* Pr(test_stat(reshuffle)>test_stat(orig))
matrix list p_mod1	
drop  abs_t_mod1_* p_values_mod1_*
	
	
	
	est restore mod2_reg
	matrix b2=e(b)	
	local N2=e(N)
	local max2=colsof(b2)
	matrix T_mod2_orig= J(1,`max2',.)
	matrix p_mod2= J(1,`max2',.)
	
	matrix b2=e(b)
	matrix V2=vecdiag(e(V))
	forval k=1/`max2' {
		gen abs_t_mod2_`k'=abs(t_mod2_`k')
		matrix T_mod2_orig[1,`k']=b2[1,`k']/sqrt(V2[1,`k'])
		sum  abs_t_mod2_`k' if abs_t_mod2_`k'>abs(T_mod2_orig[1,`k'])
		matrix p_mod2[1,`k']=(r(N))/1000	
		gen p_values_mod2_`k'=2*ttail((`N2'-`max2'),abs_t_mod2_`k')
	}
* Pr(test_stat(reshuffle)>test_stat(orig))
matrix list p_mod2	
drop  abs_t_mod2_* p_values_mod2_*


	est restore mod3_reg
	matrix b3=e(b)		
	local N3=e(N)	
	local max3=colsof(b3)
	matrix T_mod3_orig= J(1,`max3',.)
	matrix p_mod3= J(1,`max3',.)
	
	matrix b3=e(b)
	matrix V3=vecdiag(e(V))
	forval k=1/`max3' {
		gen abs_t_mod3_`k'=abs(t_mod3_`k')
		matrix T_mod3_orig[1,`k']=b3[1,`k']/sqrt(V3[1,`k'])
		sum  abs_t_mod3_`k' if abs_t_mod3_`k'>abs(T_mod3_orig[1,`k'])
		matrix p_mod3[1,`k']=(r(N))/1000	
		gen p_values_mod3_`k'=2*ttail((`N3'-`max3'),abs_t_mod3_`k')
	}
* Pr(test_stat(reshuffle)>test_stat(orig))
matrix list p_mod3		
drop  abs_t_mod3_* p_values_mod3_*


	
