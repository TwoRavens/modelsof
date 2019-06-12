/**********************************************************
**Analysis.do                                            **
**Replicates all analysis in "The Birth of Pork"         **
**Last updated: 3/14/2018                                **
**********************************************************/
/*Make sure to change the path to the directory containing the program files, working data, and output subdirectories*/
cd "/Users/sanfordgordon/Dropbox/Research/Primary/Data/Gordon_Simpson/Birth_of_Pork/Replication/Replication Dataverse"
set more off
clear
graph close _all
set scheme plotplain /*Plot scheme from "blindschemes" package (Bischof 2016)*/

/************************************************************
**                        Figure 1.                        **
************************************************************/
clear
use "Working Data/all_appropriations_with_district_and_timing"
drop if cong == 47
collapse (sum) approp_amount*, by(year)
drop *_first
drop approp_amount_HAR approp_amount_RIV approp_amount_MAA

replace approp_amount_FAA=approp_amount_FAA/1000
format approp_amount_FAA %9.0gc
replace approp_amount_FAA = . if year<1818
replace approp_amount_LBB = approp_amount_LBB/1000
format approp_amount_LBB %9.0gc
replace approp_amount_PBS = approp_amount_PBS/1000
format approp_amount_PBS %9.0gc
replace approp_amount_PBS = . if year<1802
replace approp_amount_RIV_HAR = approp_amount_RIV_HAR/1000
format approp_amount_RIV_HAR %9.0gc
replace approp_amount_RIV_HAR = . if year < 1822
replace approp_amount_CRS = approp_amount_CRS/1000
format approp_amount_CRS %9.0gc
replace approp_amount_CRS = . if year<1806
gen miss=.

capture graph close _all

twoway (area approp_amount_LBB year, fcolor(gs8) lcolor(black) lwidth(vthin) lpattern(solid)), ///
	   ytitle("Lighthouses, Etc.",size(small) margin(0 0 0 0)) ylabel(0(500)2000, glcolor(gs12) glwidth(vthin) angle(0) labsize(small)) yscale(titlegap(2)) ///
	   xtitle("", size(small)) xlabel(1790(10)1880, nolabels ticks) xmtick(##10) yline(2000,lcolor(gs12) lwidth(vthin)) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) ysize(2) xsize(6) aspectratio(0.15, placement(east)) ///
       plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) name(LBB,replace)

twoway (area approp_amount_CRS year, fcolor(gs8) lcolor(black) lwidth(vthin) lpattern(solid)), ///
	   ytitle("Roads and Canals",size(small)  margin(0 0 0 0)) ylabel(0(250)1000, glcolor(gs12) glwidth(vthin) angle(0) labsize(small))  yscale(titlegap(2)) ///
	   xtitle("", size(small)) xlabel(1790(10)1880, nolabels ticks) xmtick(##10) yline(1000,lcolor(gs12) lwidth(vthin)) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) ysize(2) xsize(6) aspectratio(0.15, placement(east)) ///
       plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) name(CRS,replace)

twoway (area approp_amount_FAA year, fcolor(gs8) lcolor(black) lwidth(vthin) lpattern(solid)), ///
	   ytitle("Forts, Etc.",size(small) margin(0 0 0 0)) ylabel(0(1000)4000, glcolor(gs12) glwidth(vthin) angle(0) labsize(small))  yscale(titlegap(2)) ///
	   xtitle("", size(small)) xlabel(1790(10)1880, nolabels ticks) xmtick(##10) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) ysize(2) xsize(6) aspectratio(0.15, placement(east)) ///
       plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) name(FAA,replace)

twoway (area approp_amount_RIV_HAR year, fcolor(gs8) lcolor(black) lwidth(vthin) lpattern(solid)), ///
	   ytitle("Rivers and Harbors",size(small) margin(0 0 0 0)) ylabel(0(2500)10000, glcolor(gs12) glwidth(vthin) angle(0) labsize(small))  yscale(titlegap(*.1)) ///
	   xtitle("", size(small)) xlabel(1790(10)1880, nolabels ticks) xmtick(##10) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) ysize(2) xsize(6) aspectratio(0.15, placement(east)) ///
       plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) name(RHS,replace)   
	   
twoway (area approp_amount_PBS year, fcolor(gs8) lcolor(black) lwidth(vthin) lpattern(solid)), ///
	   ytitle("Public Buildings",size(small) margin(0 0 0 0)) ylabel(0(2500)10000, glcolor(gs12) glwidth(vthin) angle(0) labsize(small))  yscale(titlegap(*.1)) ///
	   xtitle("", size(large)) xlabel(1790(10)1880,  nolabel ticks) xmtick(##10) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) ysize(2) xsize(6) aspectratio(0.15, placement(east)) ///
       plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) name(PBS,replace)
capture graph close _all
	   twoway (scatter miss year), ytitle("",size(small) margin(0 0 0 0)) yscale(noline) ylabel(none, nolabels noticks nogrid) xtitle("") xscale(range(1787.5 1880) noline) /// 
	   xlabel(1790(10)1880, noticks nogrid labsize(small)) xscale(noline alt) graphregion(margin(zero) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
	   plotregion(margin(medium) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ysize(1) xsize(4) aspectratio( 0.108, placement(east)) name(axs,replace)
gr combine LBB CRS FAA RHS PBS axs, rows(6) ysize(5.5) ///
		   graphregion(margin(tiny)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(1 1 1 1))
graph export "Output/Figure 1.pdf", replace	

/************************************************************
**                        Table 1.                         **
************************************************************/
clear
insheet using "Source Data/input_for_analysis/input_forts_arsenals_armories.csv", comma names
count if real_auth!=.
local faa = r(N)
egen group = group(state subheading)
summ group
clear
insheet using "Source Data/input_for_analysis/input_rivers_and_bays.csv", comma names
count if amountofannualappropriation!=""
local riv = r(N)
egen group = group(riverorharbor)
summ group
clear
insheet using "Source Data/input_for_analysis/input_harbors.csv"
count if real_auth!=.
local har = r(N)
egen group = group(riverorharbor)
summ group
clear
insheet using "Source Data/input_for_analysis/input_lighthouses_beacons_buoys.csv"
count if real_auth!=.
local lbb = r(N)
egen group = group(state subheading object)
summ group
clear
insheet using "Source Data/input_for_analysis/input_public_buildings.csv"
count if approp_amount!=.
local pbs = r(N)
egen group = group(state city object)
summ group
clear
insheet using "Source Data/input_for_analysis/input_roads_and_canals.csv"
count if amountofannual!=""
local crs = r(N)
egen group = group(statemiscbridgesorcanals subheading)
summ group
clear
insheet using "Source Data/input_for_analysis/input_mints_and_assay_offices.csv"
count if real_auth!=.
local maa = r(N)
egen group = group(state subheading)
summ group
clear
disp `faa'+`riv'+`har'+`lbb'+`pbs'+`crs'+`maa'
clear

/************************************************************
**                        Table 2.                         **
/************************************************************/
**Main Regression Table                                    **
*************************************************************/
use "Working Data/working_data_for_regressions.dta", clear
/* We use areg instead of xtreg as the former reports the overall R-squared in a more easily interpretable way than the latter. 
Coefficients and standard errors are identical*/

#delimit;
areg ln_approp_amount after_member_election left_same_after left_other_after distance_to_median
     in_majority_party  democrat waysandmeans commerce military_affairs i.running_chron_session if districting_cycle==4, absorb(group_geo_id) robust ;
lincom left_same_after-after_member_election;
local coef1 = r(estimate);
local se1 = r(se);
lincom left_other_after-after_member_election;
local coef2 = r(estimate);
local se2 = r(se);
lincom left_other_after-left_same_after;
local coef3 = r(estimate);
local se3 = r(se);
outreg2   after_member_election left_same_after left_other_after distance_to_median 
	in_majority_party    democrat waysandmeans commerce military_affairs using Output/table2.tex, nocons drop(i.running_chron_session) tex(landscape) dec(3) label 
	addstat("  H0:Left (Same)-Returned=0",`coef1',"se1",`se1',"H0:Left (Other)-Returned=0",`coef2',"se2",`se2',"H0:Left (Other)-Left (Same)=0",`coef3',"se3",`se3') ctitle("1823-1832") replace;


#delimit;
areg ln_approp_amount   after_member_election left_same_after left_other_after distance_to_median
     in_majority_party    southern_whig democrat waysandmeans commerce military_affairs public_buildings i.running_chron_session if districting_cycle==5, absorb(group_geo_id) robust ;
lincom left_same_after-after_member_election;
local coef1 = r(estimate);
local se1 = r(se);
lincom left_other_after-after_member_election;
local coef2 = r(estimate);
local se2 = r(se);
lincom left_other_after-left_same_after;
local coef3 = r(estimate);
local se3 = r(se);
	 outreg2 ln_approp_amount   after_member_election left_same_after left_other_after previous_margin_before_or_during distance_to_median 
	in_majority_party distancetomedianxmajority   southern_whig democrat waysandmeans commerce military_affairs public_buildings using Output/table2.tex, nocons drop(i.running_chron_session) tex(landscape) dec(3) label
	addstat("  H0:Left (Same)-Returned=0",`coef1',"se1",`se1',"H0:Left (Other)-Returned=0",`coef2',"se2",`se2',"H0:Left (Other)-Left (Same)=0",`coef3',"se3",`se3') ctitle("1833-1842") append;

#delimit;
areg ln_approp_amount   after_member_election left_same_after left_other_after previous_margin_before_or_during distance_to_median
     in_majority_party    southern_whig democrat waysandmeans commerce military_affairs public_buildings  i.running_chron_session if districting_cycle==6, absorb(group_geo_id) robust ;
lincom left_same_after-after_member_election;
local coef1 = r(estimate);
local se1 = r(se);
lincom left_other_after-after_member_election;
local coef2 = r(estimate);
local se2 = r(se);
lincom left_other_after-left_same_after;
local coef3 = r(estimate);
local se3 = r(se);
 outreg2 ln_approp_amount   after_member_election left_same_after left_other_after previous_margin_before_or_during distance_to_median 
	in_majority_party    southern_whig democrat waysandmeans commerce military_affairs public_buildings  using Output/table2.tex, nocons drop(i.running_chron_session) tex(landscape) dec(3) label
	addstat("  H0:Left (Same)-Returned=0",`coef1',"se1",`se1',"H0:Left (Other)-Returned=0",`coef2',"se2",`se2',"H0:Left (Other)-Left (Same)=0",`coef3',"se3",`se3') ctitle("1843-1852") append;

#delimit;
areg ln_approp_amount   after_member_election left_same_after left_other_after previous_margin_before_or_during distance_to_median
     in_majority_party    southern_whig democrat waysandmeans commerce military_affairs public_buildings i.running_chron_session if districting_cycle==7, absorb(group_geo_id) robust ;
lincom left_same_after-after_member_election;
local coef1 = r(estimate);
local se1 = r(se);
lincom left_other_after-after_member_election;
local coef2 = r(estimate);
local se2 = r(se);
lincom left_other_after-left_same_after;
local coef3 = r(estimate);
local se3 = r(se);
	 outreg2 ln_approp_amount   after_member_election left_same_after left_other_after previous_margin_before_or_during distance_to_median 
	in_majority_party    southern_whig democrat waysandmeans commerce military_affairs public_buildings   using Output/table2.tex, nocons drop(i.running_chron_session) tex(landscape) dec(3) label
	addstat("  H0:Left (Same)-Returned=0",`coef1',"se1",`se1',"H0:Left (Other)-Returned=0",`coef2',"se2",`se2',"H0:Left (Other)-Left (Same)=0",`coef3',"se3",`se3') ctitle("1853-1862") append;

#delimit;
areg ln_approp_amount   after_member_election left_same_after left_other_after previous_margin_before_or_during distance_to_median
     in_majority_party    democrat waysandmeans commerce military_affairs public_buildings  appropriations i.running_chron_session if districting_cycle==8 & south ==0, absorb(group_geo_id) robust ;
lincom left_same_after-after_member_election;
local coef1 = r(estimate);
local se1 = r(se);
lincom left_other_after-after_member_election;
local coef2 = r(estimate);
local se2 = r(se);
lincom left_other_after-left_same_after;
local coef3 = r(estimate);
local se3 = r(se);
 outreg2 ln_approp_amount   after_member_election left_same_after left_other_after previous_margin_before_or_during distance_to_median 
	in_majority_party    democrat waysandmeans commerce military_affairs public_buildings  appropriations using Output/table2.tex,  nocons drop(i.running_chron_session) tex(landscape) dec(3) label
	addstat("  H0:Left (Same)-Returned=0",`coef1',"se1",`se1',"H0:Left (Other)-Returned=0",`coef2',"se2",`se2',"H0:Left (Other)-Left (Same)=0",`coef3',"se3",`se3') ctitle("1863-1872") append;
	 
#delimit;
areg ln_approp_amount   after_member_election left_same_after left_other_after previous_margin_before_or_during distance_to_median
     in_majority_party    democrat waysandmeans commerce military_affairs public_buildings  appropriations i.running_chron_session if districting_cycle==9, absorb(group_geo_id) robust ;	
lincom left_same_after-after_member_election;
local coef1 = r(estimate);
local se1 = r(se);
lincom left_other_after-after_member_election;
local coef2 = r(estimate);
local se2 = r(se);
lincom left_other_after-left_same_after;
local coef3 = r(estimate);
local se3 = r(se);
 outreg2 ln_approp_amount   after_member_election left_same_after left_other_after previous_margin_before_or_during distance_to_median 
	in_majority_party    democrat waysandmeans commerce military_affairs public_buildings  appropriations using Output/table2.tex, nocons drop(i.running_chron_session) tex(landscape) dec(3) label 
	addstat("  H0:Left (Same)-Returned=0",`coef1',"se1",`se1',"H0:Left (Other)-Returned=0",`coef2',"se2",`se2',"H0:Left (Other)-Left (Same)=0",`coef3',"se3",`se3') ctitle("1873-1882") append;
	 
/*Check explanatory power with no covariates*/
#delimit cr
areg ln_approp_amount i.running_chron_session if districting_cycle==4, absorb(group_geo_id)
areg ln_approp_amount i.running_chron_session if districting_cycle==5, absorb(group_geo_id)
areg ln_approp_amount i.running_chron_session if districting_cycle==6, absorb(group_geo_id)
areg ln_approp_amount i.running_chron_session if districting_cycle==7, absorb(group_geo_id)
areg ln_approp_amount i.running_chron_session if districting_cycle==8 & south == 0, absorb(group_geo_id)
areg ln_approp_amount i.running_chron_session if districting_cycle==9, absorb(group_geo_id)

areg ln_approp_amount if districting_cycle==4, absorb(group_geo_id)
areg ln_approp_amount if districting_cycle==5, absorb(group_geo_id)
areg ln_approp_amount  if districting_cycle==6, absorb(group_geo_id)
areg ln_approp_amount  if districting_cycle==7, absorb(group_geo_id)
areg ln_approp_amount  if districting_cycle==8 & south == 0, absorb(group_geo_id)
areg ln_approp_amount  if districting_cycle==9, absorb(group_geo_id)


/************************************************************
**                        Figure 3.                        **
************************************************************/
/*************************************************************
**Coalition Size by Session and Congress                    **
*************************************************************/
clear
use "Working Data/legislator_beneficiaries_by_session.dta" 
#delimit ;
twoway (bar frac real_chron, fcolor(black) lwidth(none) barwidth(.2)) if cong < 47, 
yline(0.5,lcolor(black) lpattern(dash))
/*y-axis options*/
ytitle("Proportion of All Seats", margin(zero) alignment(bottom)) 
yscale(titlegap(5) outergap(-3)) 
ylabel(-0(0.2)0.8, labsize(small) labgap(tiny)  angle(0)) 
/*x-axis options*/
xtitle("Congress", alignment(bottom)) 
xscale(noline titlegap(5) outergap(-3)) 
xlabel(5(10)45, labsize(small) labgap(small)) 
/*General*/
xsize(2.5) ysize(2.5) 
aspectratio(.7) 
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white))
name(gph1,replace);
graph export "output/Figure 3.pdf", as(pdf) replace;
#delimit cr

/************************************************************
**                        Figure 4.                        **
************************************************************/
/*************************************************************
**Support for Local Appropriations                          **
*************************************************************/
set more off
matrix got = J(21,3,.)
matrix anyotherstate = J(21,3,.)
matrix outstateadj = J(21,3,.)
matrix quadratic_binary = J(21,3,.)
matrix dwnom1 = J(21,3,.)
matrix dwnom2 = J(21,3,.)
matrix south = J(21,3,.)
matrix west = J(21,3,.)
matrix in_majority = J(21,3,.)
local billist = "19_105 21_249 21_262 23_205 24_457 25_326 27_764 29_601 30_175 31_412 31_426 33_406 35_340 36_234 41_588 43_148 43_397 44_66 45_326 46_267 46_376"
local n : word count `billist'
forval i = 1/`n' {
	local bill: word `i' of `billist'
	clear
	display "`bill'"
	use "Working Data/rollcalls/externalities_investigation/analysis_of_`bill'_par.dta" 
	summ vote if in_majority==0
	summ vote if in_majority == 1
	gen anyotherstate = stategot>got
	gen south = state_abbrev=="AL"|state_abbrev=="AR"|state_abbrev == "FL"|state_abbrev=="GA"|state_abbrev == "LA" | state_abbrev == "MS" | state_abbrev == "NC" | state_abbrev == "SC" | state_abbrev == "TN" | state_abbrev=="TX" | state_abbrev == "VA"
	gen west = state_abbrev == "CA"|state_abbrev == "IL" |state_abbrev =="IN" |state_abbrev =="IA" |state_abbrev =="KS" |state_abbrev =="MI" |state_abbrev =="MN" |state_abbrev =="MO" |state_abbrev =="NE" |state_abbrev =="OH" |state_abbrev =="OR" |state_abbrev =="WI"
	reg vote got anyotherstate linear_binary dwnom1 dwnom2 south west in_majority, robust
	test dwnom1, accum
	test dwnom2, accum
	matrix b = e(b)
	matrix V= e(V)
	matrix got[`i',1] =b[1,1]
	matrix got[`i',2] = b[1,1]-invt(e(N)-6,.975)*sqrt(V[1,1])
	matrix got[`i',3] = b[1,1]+invt(e(N)-6,.975)*sqrt(V[1,1])	
	
	matrix anyotherstate[`i',1] =b[1,2]
	matrix anyotherstate[`i',2] = b[1,2]-invt(e(N)-6,.975)*sqrt(V[2,2])
	matrix anyotherstate[`i',3] = b[1,2]+invt(e(N)-6,.975)*sqrt(V[2,2])	
	
	
	qui centile quadratic_binary, centile(25 75)
	matrix quadratic_binary[`i',1]=(r(c_2)-r(c_1))*b[1,3]
	matrix quadratic_binary[`i',2] = (r(c_2)-r(c_1))*(b[1,3]-invt(e(N)-7,.975)*sqrt(V[3,3]))
	matrix quadratic_binary[`i',3] = (r(c_2)-r(c_1))*(b[1,3]+invt(e(N)-7,.975)*sqrt(V[3,3]))
	
	matrix dwnom1[`i',1] = b[1,4]
	matrix dwnom1[`i',2] = b[1,4]-invt(e(N)-7,.975)*sqrt(V[4,4])
	matrix dwnom1[`i',3] = b[1,4]+invt(e(N)-7,.975)*sqrt(V[4,4])	

	matrix dwnom2[`i',1] = b[1,5]
	matrix dwnom2[`i',2] = b[1,5]-invt(e(N)-7,.975)*sqrt(V[5,5])
	matrix dwnom2[`i',3] = b[1,5]+invt(e(N)-7,.975)*sqrt(V[5,5])	

	matrix south[`i',1] = b[1,6]
	matrix south[`i',2] = b[1,6]-invt(e(N)-7,.975)*sqrt(V[6,6])
	matrix south[`i',3] = b[1,6]+invt(e(N)-7,.975)*sqrt(V[6,6])	

	matrix west[`i',1] = b[1,7]
	matrix west[`i',2] = b[1,7]-invt(e(N)-7,.975)*sqrt(V[7,7])
	matrix west[`i',3] = b[1,7]+invt(e(N)-7,.975)*sqrt(V[7,7])	

	
	matrix in_majority[`i',1] = b[1,8]
	matrix in_majority[`i',2] = b[1,8]-invt(e(N)-7,.975)*sqrt(V[8,8])
	matrix in_majority[`i',3] = b[1,8]+invt(e(N)-7,.975)*sqrt(V[8,8])	
}
set scheme plotplain
gen n = 22-_n in 1/21
svmat got
#delimit;
twoway (scatter n got1, msize(tiny)) (rspike got2 got3 n,  horizontal),
ylabel(
1 "1881 Rivers and Harbors"
2 "1880 Rivers and Harbors"
3 "1879 Rivers and Harbors"
4 "1876 Rivers and Harbors"
5 "1875 Rivers and Harbors"
6 "1874 Rivers and Harbors"
7 "1871 Rivers and Harbors"
8 "1860 Lighthouses"
9 "1859 Lighthouses"
10 "1854 Forts"
11 "1850 Lighthouses"
12 "1850 Forts"
13 "1848 Forts"
14 "1847 Lighthouses"
15 "1842 Forts"
16 "1838 Lighthouses"
17 "1837 Lighthouses"
18 "1834 Lighthouses"
19 "1831 Lighthouses"
20 "1831 Public Buildings"
21 "1827 Rivers and Harbors"
, angle(horizontal) labsize(vsmall)) xlabel(,labsize(small)) ytitle("") xtitle("") xline(0) legend(off) title("Local Project",size(small)) 
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) name(g1, replace) fysize(150) fxsize(40);
#delimit cr

svmat anyotherstate
#delimit;
twoway (scatter n anyotherstate1, msize(tiny) ) (rspike anyotherstate2 anyotherstate3 n,  horizontal),
ylabel(
1 " "
2 " "
3 " "
4 " "
5 " "
6 " "
7 " "
8 " "
9 " "
10 " "
11 " "
12 " "
13 " "
14 " "
15 " "
16 " "
17 " "
18 " "
19 " "
20 " "
21 " "
, angle(horizontal) labsize(tiny)) xline(0) legend(off)  title("Other in State",size(small)) name(g2a, replace)
xlabel(,labsize(small)) ytitle("") xtitle("")
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) fysize(150) fxsize(23.33);
#delimit cr

svmat quadratic_binary
#delimit;
twoway (scatter n quadratic_binary1, msize(tiny) ) (rspike quadratic_binary2 quadratic_binary3 n,  horizontal),
ylabel(
1 " "
2 " "
3 " "
4 " "
5 " "
6 " "
7 " "
8 " "
9 " "
10 " "
11 " "
12 " "
13 " "
14 " "
15 " "
16 " "
17 " "
18 " "
19 " "
20 " "
21 " "
, angle(horizontal) labsize(tiny)) xline(0) legend(off)  title("Spatial Extern.",size(small)) name(g3a, replace)
xlabel(,labsize(small)) ytitle("") xtitle("")
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) fysize(150) fxsize(23.33);
#delimit cr

svmat dwnom1
#delimit;
twoway (scatter n dwnom11, msize(tiny) ) (rspike dwnom12 dwnom13 n,  horizontal),
ylabel(
1 " "
2 " "
3 " "
4 " "
5 " "
6 " "
7 " "
8 " "
9 " "
10 " "
11 " "
12 " "
13 " "
14 " "
15 " "
16 " "
17 " "
18 " "
19 " "
20 " "
21 " "
, angle(horizontal) labsize(tiny)) xline(0) legend(off)  title("1st Dim. DW-Nom.",size(small)) name(g4a, replace)
xlabel(,labsize(small)) ytitle("") xtitle("")
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) fysize(150) fxsize(23.33);
;
#delimit cr

svmat dwnom2
#delimit;
twoway (scatter n dwnom21, msize(tiny) ) (rspike dwnom22 dwnom23 n,  horizontal),
ylabel(
1 "1881 Rivers and Harbors"
2 "1880 Rivers and Harbors"
3 "1879 Rivers and Harbors"
4 "1876 Rivers and Harbors"
5 "1875 Rivers and Harbors"
6 "1874 Rivers and Harbors"
7 "1871 Rivers and Harbors"
8 "1860 Lighthouses"
9 "1859 Lighthouses"
10 "1854 Forts"
11 "1850 Lighthouses"
12 "1850 Forts"
13 "1848 Forts"
14 "1847 Lighthouses"
15 "1842 Forts"
16 "1838 Lighthouses"
17 "1837 Lighthouses"
18 "1834 Lighthouses"
19 "1831 Lighthouses"
20 "1831 Public Buildings"
21 "1827 Rivers and Harbors"
, angle(horizontal) labsize(vsmall)) xline(0) legend(off) title("2nd Dim. DW-Nom.",size(small)) name(g5a, replace)
xlabel(,labsize(small)) ytitle("") xtitle("")
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) fysize(150) fxsize(40);
#delimit cr

svmat south
#delimit;
twoway (scatter n south1, msize(tiny) ) (rspike south2 south3 n,  horizontal),
ylabel(
1 " "
2 " "
3 " "
4 " "
5 " "
6 " "
7 " "
8 " "
9 " "
10 " "
11 " "
12 " "
13 " "
14 " "
15 " "
16 " "
17 " "
18 " "
19 " "
20 " "
21 " "
, angle(horizontal) labsize(tiny)) xline(0) legend(off)  title("South",size(small)) name(g6a, replace)
xlabel(,labsize(small)) ytitle("") xtitle("")
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) fysize(150) fxsize(23.33);
;
#delimit cr

svmat west
#delimit;
twoway (scatter n west1, msize(tiny) ) (rspike west2 west3 n,  horizontal),
ylabel(
1 " "
2 " "
3 " "
4 " "
5 " "
6 " "
7 " "
8 " "
9 " "
10 " "
11 " "
12 " "
13 " "
14 " "
15 " "
16 " "
17 " "
18 " "
19 " "
20 " "
21 " "
, angle(horizontal) labsize(tiny)) xline(0) legend(off)  title("West",size(small)) name(g8a, replace)
xlabel(,labsize(small)) ytitle("") xtitle("")
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) fysize(150) fxsize(23.33);
;
#delimit cr

svmat in_majority
#delimit;
twoway (scatter n in_majority1, msize(tiny) ) (rspike in_majority2 in_majority3 n,  horizontal),
ylabel(
1 " "
2 " "
3 " "
4 " "
5 " "
6 " "
7 " "
8 " "
9 " "
10 " "
11 " "
12 " "
13 " "
14 " "
15 " "
16 " "
17 " "
18 " "
19 " "
20 " "
21 " "
, angle(horizontal) labsize(tiny)) xline(0) legend(off) title("In Majority",size(small)) name(g7a, replace)
xlabel(,labsize(small)) ytitle("") xtitle("")
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) fysize(150) fxsize(23.33);
;
#delimit cr

#delimit ;
gr combine g1 g2a g3a g4a g5a g7a g6a g8a , rows(1) cols(4) 
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white));
graph export "Output/voting_regression.pdf", replace;
#delimit cr

/************************************************************
**                        Figures 5 and 6.                 **
************************************************************/
/*************************************************************
**Spatial Mapping and Ideological Fit                       **
*************************************************************/
/* Figure 5 */
/***********************************************************************************
**1. Lighthouses, Beacons, and Buoys											  **
***********************************************************************************/
matrix results = J(22,9,.)
/*Declare lists of congresses, roll calls numbers, slopes and intercepts from cutting lines (from voteview), vote dates and years*/
local clist = "21 23 24 25 29 31 35 36" 
local rclist = "262 205 457 326 601 426 340 234"
local slopelist = "5.972281621452681 3.355964357525847 1.8813096087925685 2.996825976733109 -13.70947141797793 -5.945238652628697 -4.521788726213743 -4.579732862714822"
local interceptlist = "1.9163859993886736 0.8533635527336257 0.4737584912182038 0.22677781837131766 -3.717273140314703 -1.7276215138521906 -0.9523084642757407 0.21099134571770928"
local edatelist = "-47055 -45840 -44863 -44372 -41211 -39906 -36828 -36353"
local yearlist = "1831 1834 1837 1838 1847 1850 1859 1860"
local n : word count `clist'
disp "`n'"

capture graph close _all
forval i = 1/`n' { 
	clear
	local c: word `i' of `clist'
	local rc: word `i' of `rclist'
	local edate: word `i' of `edatelist'
	local year: word `i' of `yearlist'
	disp "Congress `c' -- Rollcall `rc' -- authorization date `edate' -- year `year'"
	matrix results[`i',1] = `c'
	matrix results[`i',2] = `rc'
	matrix results[`i',7]=`year'
	/*Read in roll call data */
	use "Source Data/nominate/hc01113d21_PRES_PRE_DATES.dta"
	summ gmp if cong == `c' & rcnum == `rc'
	matrix results[`i',4]=max(0,r(mean))
	summ correct if cong == `c' & rcnum == `rc'
	matrix results[`i',6]=max(0,r(mean))
	replace gmp = 0.5 if gmp <0.5 & gmp !=0 /*This corresponds to a handful of GMPs in the 0.43 to 0.49 range*/
	centile gmp if cong == `c' & gmp >= 0.5 & gmp <=1
	matrix results[`i',8]=max(0,r(c_1))
	clear
	qui insheet using "Source Data/appropriations/by_congress/joined/approp_`c'withdistrict.csv"
	qui keep if approp_date == `edate' & substr(record_sg,1,3)=="LBB"
	gen chron10 = round(10*chron_session)
	tostring chron10, force replace
	gen chron_2 = substr(chron10,1,1)+"."+substr(chron10,2,1) if length(chron10)==2
	replace chron_2 = substr(chron10,1,2)+"."+substr(chron10,3,1) if length(chron10)==3
	drop chron_session chron10
	rename chron_2 chron_session
	/*Clean data (see assemble_spatially_joined_appropriations_data for comments)*/
	qui sort cong year state record
	qui replace statedist = "Maine" if state == "Maine" & congress == 16
	qui replace cd = 0 if state == "Maine" & congress == 16
	qui drop if state=="Maine" & chron_session == "16.1"
	qui drop if state == "Florida" & congress == 28
	qui drop if year>1860 & year < 1870 & (state == "Florida" | state == "Mississippi" | state == "South Carolina" |state == "North Carolina"|state == "Virginia"|state=="Georgia"|state =="Louisiana"|state=="Texas"|state=="Alabama")
	qui drop if congress == 17 & cd == 6 & state == "Tennessee"
	qui replace cd = 99 if state == "Georgia" & chron_session == "20.1" & cd == 1
	qui replace cd = 99 if state == "Georgia" & chron_session == "20.2" & cd == 1
	qui drop state
	qui rename statedist state
	qui replace cd = 1 if cd == 0
	qui rename congress cong
	/*Collapse to the state cd chron_session level*/
	qui collapse (sum) approp_amount* , by(chron_session state cd)
	qui drop if state =="."|state == "NA"|state ==""
	/*Join with legislator data*/
	qui joinby chron_session state cd using "Source Data/nominate/cleaned_dwnominate_with_biographical_by_session.dta", unmatched(both)
	gsort -_merge
	local cs = chron_session[1]
	keep if chron_session == "`cs'"
	qui replace approp_amount = 0 if _merge !=3 
	qui drop _merge
	qui compress
	qui save "working data/rollcalls/analysis_of_`year'_lbb.dta", replace
	qui clear
	/*Read in roll call vote data*/
	use "Source Data/nominate/hou`c'kh.dta"
	qui rename id idno
	qui keep idno V`rc'
	qui rename V`rc' vote
	qui joinby idno using "working data/rollcalls/analysis_of_`year'_lbb.dta", unmatched(both)
	qui gen got_something = approp_amount>0
	qui drop if vote == 0 | vote == 9
	qui replace vote = 0 if vote == 6
	qui replace vote = 1 if vote == 2 | vote == 3
	qui replace vote = 0 if vote == 4 | vote == 5
	local intercept: word `i' of `interceptlist'
	local slope: word `i' of `slopelist'
	local nplusone = _N+1
	local nplustwo = _N+2
	set obs `nplustwo'
	replace dwnom1 = (0.99-`intercept')/`slope' in `nplusone'
	replace dwnom1 = (-0.99-`intercept')/`slope' in `nplustwo'
	gen yvar = `intercept' + `slope'*dwnom1
	if `year'>=1850 {
		   twoway (line yvar dwnom1 if yvar > -1 & yvar < 1 &dwnom1>-1 &dwnom1<1, lcolor(black)) /*
		   */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 1, mcolor(black) msymbol(circle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 0, mcolor(white) msymbol(circle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount>0 & vote == 1 [aweight = approp_amount], msymbol(circle_hollow) mcolor(black)), /*
           */ ylabel(-1(0.5)1, nogrid nolabels) xlabel(-1(0.5)1, nogrid nolabels) ytitle("") xtitle("")/*
		   */ xline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) yline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) /*
   	       */ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) aspectratio(.67)/*
           */ plotregion(fcolor(gs14) lcolor(black) ifcolor(gs14) ilcolor(gs14)) legend(off) title("`year' Navigational",size(small)) name(gph_`year'_LBB, replace)
	} 
	else {
		   twoway (line yvar dwnom1 if yvar > -1 & yvar < 1 &dwnom1>-1 &dwnom1<1, lcolor(black)) /*
		   */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 1, mcolor(black) msymbol(circle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 0, mcolor(white) msymbol(circle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount>0 & vote == 1 [aweight = approp_amount], msymbol(circle_hollow) mcolor(black)) /*
           */ (scatter dwnom2 dwnom1 if approp_amount>0 & vote == 0 [aweight = approp_amount], msymbol(circle_hollow) mcolor(white)),  /*
	       */ ylabel(-1(0.5)1, nogrid nolabels) xlabel(-1(0.5)1, nogrid nolabels) ytitle("") xtitle("")/*
		   */ xline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) yline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) /*
   	       */ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) aspectratio(.67)/*
           */ plotregion(fcolor(gs14) lcolor(black) ifcolor(gs14) ilcolor(gs14)) legend(off) title("`year' Navigational",size(small)) name(gph_`year'_LBB, replace)
		}
	/*Compare PRE from "got something" model and ideological model*/
	*quietly {
		logit vote got_something
		estat classification
		local pcp = r(P_corr)
		predict p, p
		replace p = vote*ln(p)+(1-vote)*ln(1-p)
	*	}
	qui summ p
	matrix results[`i',3]=exp(r(mean))
	matrix results[`i',5]=`pcp'/100
	logit vote got_something dwnom1 dwnom2
}

/***********************************************************************************
**2. Rivers and Harbors             											  **
***********************************************************************************/
/*Declare lists of congresses, roll calls numbers, slopes and intercepts from cutting lines (from voteview), vote dates and years*/
local clist = "19 41 43 43 44 45 46 46"
local rclist = "105 588 148 397 66 326 267 376"
local edatelist = "-48517 -32445 -31237 -30984 -30454 -29523 -29054 -28792"
local yearlist = "1827 1871 1874 1875 1876 1879 1880 1881"
local slopelist = "3.970887010524391 -1.2687852153657462 -85.9290083519688 -2.339963454094277 18.850523199719653 -6.940419905351326 43.37762440844578 -1.0232670373274393"
local interceptlist = "1.515199080904549 -0.5494885733412354 -29.72821779790955 -1.117227720575677 12.989629319796748 -5.872960854153653 33.071036540953926 0.7983010236700171"
local n : word count `clist'
disp "`n'"
capture graph close _all
forval i = 1/`n' {
	clear
	local c: word `i' of `clist'
	local rc: word `i' of `rclist'
	local edate: word `i' of `edatelist'
	local year: word `i' of `yearlist'
	disp "Congress `c' -- Rollcall `rc' -- authorization date `edate' -- year `year'"
	matrix results[8+`i',1] = `c'
	matrix results[8+`i',2] = `rc'
	matrix results[8+`i',7]=`year'
	/*Read in roll call data */
	use "Source Data/nominate/hc01113d21_PRES_PRE_DATES.dta"
	summ gmp if cong == `c' & rcnum == `rc'
	matrix results[8+`i',4]=max(0,r(mean))
	summ correct if cong == `c' & rcnum == `rc'
	matrix results[8+`i',6]=max(0,r(mean))
	replace gmp = 0.5 if gmp <0.5 & gmp !=0 /*This corresponds to a handful of GMPs in the 0.43 to 0.49 range*/
	*summ gmp if cong == `c' & gmp >= 0.5 & gmp <=1
	*matrix results[8+`i',8]=max(0,r(mean))
	centile gmp if cong == `c' & gmp >= 0.5 & gmp <=1
	matrix results[8+`i',8]=max(0,r(c_1))
	*matrix results[8+`i',9]=max(0,r(sd))
	clear
	qui insheet using "Source Data/appropriations/by_congress/joined/approp_`c'withdistrict.csv"
	keep if approp_date == `edate' & (substr(record_sg,1,3)=="RIV"|substr(record_sg,1,3)=="HAR")
	gen chron10 = round(10*chron_session)
	tostring chron10, force replace
	gen chron_2 = substr(chron10,1,1)+"."+substr(chron10,2,1) if length(chron10)==2
	replace chron_2 = substr(chron10,1,2)+"."+substr(chron10,3,1) if length(chron10)==3
	drop chron_session chron10
	rename chron_2 chron_session
	/*Clean data (see assemble_spatially_joined_appropriations_data for comments)*/
	qui sort cong year state record
	qui replace statedist = "Maine" if state == "Maine" & congress == 16
	qui replace cd = 0 if state == "Maine" & congress == 16
	qui drop if state=="Maine" & chron_session == "16.1"
	qui drop if state == "Florida" & congress == 28
	qui drop if year>1860 & year < 1870 & (state == "Florida" | state == "Mississippi" | state == "South Carolina" |state == "North Carolina"|state == "Virginia"|state=="Georgia"|state =="Louisiana"|state=="Texas"|state=="Alabama")
	qui drop if congress == 17 & cd == 6 & state == "Tennessee"
	qui replace cd = 99 if state == "Georgia" & chron_session == "20.1" & cd == 1
	qui replace cd = 99 if state == "Georgia" & chron_session == "20.2" & cd == 1
	qui drop state
	qui rename statedist state
	qui replace cd = 1 if cd == 0
	qui rename congress cong
	/*Collapse to the state cd chron_session level*/
	qui collapse (sum) approp_amount* , by(chron_session state cd)
	qui drop if state =="."|state == "NA"|state ==""
	/*Join with legislator data*/
	qui joinby chron_session state cd using "Source Data/nominate/cleaned_dwnominate_with_biographical_by_session.dta", unmatched(both)
	gsort -_merge
	local cs = chron_session[1]
	keep if chron_session == "`cs'"
	qui replace approp_amount = 0 if _merge !=3 
	qui drop _merge
	qui compress
	save "working data/rollcalls/analysis_of_`year'_rh.dta", replace
	clear
	/*Read in roll call vote data*/
	use "Source Data/nominate/hou`c'kh.dta"
	rename id idno
	keep idno V`rc'
	rename V`rc' vote
	joinby idno using "working data/rollcalls/analysis_of_`year'_rh.dta", unmatched(both)
	qui gen got_something = approp_amount>0
	qui drop if vote == 0 | vote == 9
	qui replace vote = 0 if vote == 6
	qui replace vote = 1 if vote == 2 | vote == 3
	qui replace vote = 0 if vote == 4 | vote == 5
	local intercept: word `i' of `interceptlist'
	local slope: word `i' of `slopelist'
	local nplusone = _N+1
	local nplustwo = _N+2
	set obs `nplustwo'
	replace dwnom1 = (0.99-`intercept')/`slope' in `nplusone'
	replace dwnom1 = (-0.99-`intercept')/`slope' in `nplustwo'
	gen yvar = `intercept' + `slope'*dwnom1
	qui count if vote == 0 & got_something == 1
	if r(N) == 0 {
		   twoway (line yvar dwnom1 if yvar > -1 & yvar < 1&dwnom1>-1 &dwnom1<1, lcolor(black)) /*
		   */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 1, mcolor(black) msymbol(circle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 0, mcolor(white) msymbol(circle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount>0 & vote == 1 [aweight = approp_amount], msymbol(circle_hollow) mcolor(black)), /*
           */ ylabel(-1(0.5)1, nogrid nolabels) xlabel(-1(0.5)1, nogrid nolabels) ytitle("") xtitle("")/*
		   */ xline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) yline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) /*
   	       */ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) aspectratio(.67)/*
           */ plotregion(fcolor(gs14) lcolor(black) ifcolor(gs14) ilcolor(gs14)) legend(off) title("`year' Rivers & Harbors",size(small)) name(gph_`year'_rh, replace)
	} 
	else {
		   twoway (line yvar dwnom1 if yvar > -1 & yvar < 1&dwnom1>-1 &dwnom1<1, lcolor(black)) /*
		   */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 1, mcolor(black) msymbol(circle)) /*
		   */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 0, mcolor(white) msymbol(circle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount>0 & vote == 1 [aweight = approp_amount], msymbol(circle_hollow) mcolor(black)) /*
           */ (scatter dwnom2 dwnom1 if approp_amount>0 & vote == 0 [aweight = approp_amount], msymbol(circle_hollow) mcolor(white)),  /*
	       */ ylabel(-1(0.5)1, nogrid nolabels) xlabel(-1(0.5)1, nogrid nolabels) ytitle("") xtitle("")/*
		   */ xline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) yline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) /*
   	       */ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) aspectratio(.67)/*
           */ plotregion(fcolor(gs14) lcolor(black) ifcolor(gs14) ilcolor(gs14)) legend(off) title("`year' Rivers & Harbors",size(small)) name(gph_`year'_rh, replace)
	}
	/*Compare PRE from "got something" model and ideological model*/
	quietly {
		logit vote got_something
		estat classification
		local pcp = r(P_corr)
		predict p, p
		replace p = vote*ln(p)+(1-vote)*ln(1-p)
		}
	qui summ p
	matrix results[8+`i',3]=exp(r(mean))
	matrix results[8+`i',5]=`pcp'
	logit vote got_something dwnom1 dwnom2
}

/***********************************************************************************
**3. Public Buildings and Forts, Arsenals, and Armories							  **
***********************************************************************************/
/*Declare lists of congresses, roll calls numbers, slopes and intercepts from cutting lines (from voteview), vote dates and years*/
local clist = "21 27 30 31 33 46"
local rclist = "249 764 175 412 406 325"
local edatelist = "-47056 -42856 -40706 -39906 -38501 -28792"
local yearlist = "1831 1842 1848 1850 1854 1881"
local slopelist = "8.827727072595987 4.121307229225588 -2.838834346893533 -2.660863861476547 0.290504638351844 "
local interceptlist = "0.9284281614047907 0.7847623675842419 -0.5182851491213216 -0.7684674034996113 -0.22754912813314113"
local catlist = "Buildings Forts Forts Forts Forts Forts"

local n : word count `clist'
disp "`n'"
capture graph close _all
forval i = 1/`n' {
	clear
	local c: word `i' of `clist'
	local rc: word `i' of `rclist'
	local edate: word `i' of `edatelist'
	local year: word `i' of `yearlist'
	local cat: word `i' of `catlist'
	disp "Congress `c' -- Rollcall `rc' -- authorization date `edate' -- year `year'"
	matrix results[16+`i',1] = `c'
	matrix results[16+`i',2] = `rc'
	matrix results[16+`i',7]=`year'
	/*Read in roll call data */
	use "Source Data/nominate/hc01113d21_PRES_PRE_DATES.dta"
	summ gmp if cong == `c' & rcnum == `rc'
	matrix results[16+`i',4]=max(0,r(mean))
	summ correct if cong == `c' & rcnum == `rc'
	matrix results[16+`i',6]=max(0,r(mean))
	replace gmp = 0.5 if gmp <0.5 & gmp !=0 /*This corresponds to a handful of GMPs in the 0.43 to 0.49 range*/
	centile gmp if cong == `c' & gmp >= 0.5 & gmp <=1
	matrix results[16+`i',8]=max(0,r(c_1))
	clear
	qui insheet using "Source Data/appropriations/by_congress/joined/approp_`c'withdistrict.csv"
	keep if approp_date == `edate' & (substr(record_sg,1,3)=="PBS"|substr(record_sg,1,3)=="FAA")
	gen chron10 = round(10*chron_session)
	tostring chron10, force replace
	gen chron_2 = substr(chron10,1,1)+"."+substr(chron10,2,1) if length(chron10)==2
	replace chron_2 = substr(chron10,1,2)+"."+substr(chron10,3,1) if length(chron10)==3
	drop chron_session chron10
	rename chron_2 chron_session
	/*Clean data (see assemble_spatially_joined_appropriations_data for comments)*/
	qui sort cong year state record
	qui replace statedist = "Maine" if state == "Maine" & congress == 16
	qui replace cd = 0 if state == "Maine" & congress == 16
	qui drop if state=="Maine" & chron_session == "16.1"
	qui drop if state == "Florida" & congress == 28
	qui drop if year>1860 & year < 1870 & (state == "Florida" | state == "Mississippi" | state == "South Carolina" |state == "North Carolina"|state == "Virginia"|state=="Georgia"|state =="Louisiana"|state=="Texas"|state=="Alabama")
	qui drop if congress == 17 & cd == 6 & state == "Tennessee"
	qui replace cd = 99 if state == "Georgia" & chron_session == "20.1" & cd == 1
	qui replace cd = 99 if state == "Georgia" & chron_session == "20.2" & cd == 1
	qui drop state
	qui rename statedist state
	qui replace cd = 1 if cd == 0
	qui rename congress cong
	/*Collapse to the state cd chron_session level*/
	qui collapse (sum) approp_amount* , by(chron_session state cd)
	qui drop if state =="."|state == "NA"|state ==""
	/*Join with legislator data*/
	qui joinby chron_session state cd using "Source Data/nominate/cleaned_dwnominate_with_biographical_by_session.dta", unmatched(both)
	gsort -_merge
	local cs = chron_session[1]
	keep if chron_session == "`cs'"
	qui replace approp_amount = 0 if _merge !=3 
	qui drop _merge
	qui compress
	save "working data/rollcalls/analysis_of_`year'_pbs.dta", replace
	clear
	/*Read in roll call vote data*/
	use "Source Data/nominate/hou`c'kh.dta"
	rename id idno
	keep idno V`rc'
	rename V`rc' vote
	joinby idno using "working data/rollcalls/analysis_of_`year'_pbs.dta", unmatched(both)
	qui gen got_something = approp_amount>0
	qui drop if vote == 0 | vote == 9
	qui replace vote = 0 if vote == 6
	qui replace vote = 1 if vote == 2 | vote == 3
	qui replace vote = 0 if vote == 4 | vote == 5
	local weight = 0.3988
	if `i' < `n' {
	local intercept: word `i' of `interceptlist'
	local slope: word `i' of `slopelist'
	local nplusone = _N+1
	local nplustwo = _N+2
	set obs `nplustwo'
	replace dwnom1 = (0.99-`intercept')/`slope' in `nplusone'
	replace dwnom1 = (-0.99-`intercept')/`slope' in `nplustwo'
	gen yvar = `intercept' + `slope'*dwnom1
	}
	qui count if vote == 0 & got_something == 1
	if `i' == `n' {
		   twoway (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 1, mcolor(black) msymbol(cicle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 0, mcolor(white) msymbol(circle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount>0 & vote == 1 [aweight = approp_amount], msymbol(circle_hollow) mcolor(black)), /*
           */ ylabel(-1(0.5)1, nogrid nolabels) xlabel(-1(0.5)1, nogrid nolabels) ytitle("") xtitle("")/*
		   */ xline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) yline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) /*
   	       */ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) aspectratio(.67)/*
           */ plotregion(fcolor(gs14) lcolor(black) ifcolor(gs14) ilcolor(gs14)) legend(off) title("`year' `cat'",size(small)) name(gph_`year'_bf, replace)
	}
	else {
		if r(N) == 0 {
		   twoway (line yvar dwnom1 if yvar > -1 & yvar < 1&dwnom1>-1 &dwnom1<1, lcolor(black)) /*
		   */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 1, mcolor(black) msymbol(cicle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 0, mcolor(white) msymbol(circle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount>0 & vote == 1 [aweight = approp_amount], msymbol(circle_hollow) mcolor(black)), /*
           */ ylabel(-1(0.5)1, nogrid nolabels) xlabel(-1(0.5)1, nogrid nolabels) ytitle("") xtitle("")/*
		   */ xline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) yline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) /*
   	       */ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) aspectratio(.67)/*
           */ plotregion(fcolor(gs14) lcolor(black) ifcolor(gs14) ilcolor(gs14)) legend(off) title("`year' `cat'",size(small)) name(gph_`year'_bf, replace)
		} 
		else {
		   twoway (line yvar dwnom1 if yvar > -1 & yvar < 1&dwnom1>-1 &dwnom1<1, lcolor(black)) /*
		   */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 1, mcolor(black) msymbol(circle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount == 0 & vote == 0, mcolor(white) msymbol(cicle)) /*
	       */ (scatter dwnom2 dwnom1 if approp_amount>0 & vote == 1 [aweight = approp_amount], msymbol(circle_hollow) mcolor(black)) /*
           */ (scatter dwnom2 dwnom1 if approp_amount>0 & vote == 0 [aweight = approp_amount], msymbol(circle_hollow) mcolor(white)),  /*
	       */ ylabel(-1(0.5)1, nogrid nolabels) xlabel(-1(0.5)1, nogrid nolabels) ytitle("") xtitle("")/*
		   */ xline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) yline(-0.5 0 0.5,lcolor(white) lpattern(solid) lwidth(vthin)) /*
   	       */ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) aspectratio(.67)/*
           */ plotregion(fcolor(gs14) lcolor(black) ifcolor(gs14) ilcolor(gs14)) legend(off) title("`year' `cat'",size(small)) name(gph_`year'_bf, replace)
		}
	}
	/*Compare PRE from "got something" model and ideological model*/
	quietly {
		logit vote got_something
		estat classification
		local pcp = r(P_corr)
		predict p, p
		replace p = vote*ln(p)+(1-vote)*ln(1-p)
		}
	qui summ p
	matrix results[16+`i',3]=exp(r(mean))
	matrix results[16+`i',5]=`pcp'
}
capture graph close _all

graph combine gph_1827_rh gph_1831_LBB gph_1831_bf gph_1834_LBB gph_1837_LBB gph_1838_LBB gph_1842_bf  gph_1847_LBB gph_1848_bf gph_1850_LBB gph_1850_bf ///
gph_1854_bf gph_1859_LBB gph_1860_LBB gph_1871_rh gph_1874_rh gph_1875_rh gph_1876_rh gph_1879_rh gph_1880_rh gph_1881_rh gph_1881_bf, ///
imargin(small) xsize(10) ysize(7) scale(1) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) ///
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero))
graph export "Output/all_votes.pdf", replace

/*Figure 6*/
svmat results
rename results4 gmp
rename results7 year
rename results8 gmp_congress
gen ub = gmp_congress+results9
gen lb = gmp_congress-results9
gen pre_cat = "N" in 1/8
replace pre_cat = "R" in 9/16
replace pre_cat = "B" in 17
replace pre_cat = "F" in 18/22


gen F = gmp if pre_cat == "F"
gen N = gmp if pre_cat == "N"
gen R = gmp if pre_cat == "R"
gen B = gmp if pre_cat == "B"


twoway (scatter F year if gmp>0, msymbol(none) mlabel(pre_cat) mlabposition(0) mlabcolor(black)) ///
	   (scatter N year if gmp>0, msymbol(none) mlabel(pre_cat) mlabposition(0) mlabcolor(black)) ///	
       (scatter R year if gmp>0, msymbol(none) mlabel(pre_cat) mlabposition(0) mlabcolor(black)) ///
	   (scatter B year if gmp>0, msymbol(none) mlabel(pre_cat) mlabposition(0) mlabcolor(black)) ///
	   (lowess gmp year if gmp>0, lcolor(gray) lpattern(solid)) ///
	   (lowess gmp_congress year, lcolor(gray) lpattern(dash)) ///
	   (scatter gmp_congress year,mcolor(black) mfcolor(white) msymbol(circle_hollow)), ///
	   xlabel(1830(10)1880, ticks) xmtick(##10) ylabel(0.5(0.05).8) ytitle("Geometric Mean Probability") ///
	   xtitle("Year") legend(off) scheme(plotplain) name(gmp_scatter, replace)
graph export "Output/gmp.pdf", replace
clear 


/************************************************************
**                        Figure 7                         **
************************************************************/
/*************************************************************
**Ratchet Effect graphs                                     **
*************************************************************/
clear
use "Working Data/all_appropriations_with_district_and_timing.dta"
gen cat = substr(record_sg,1,3)
sort cat state subheading object cong
collapse (sum) approp_amount, by(cat state subheading cong)
sort cong cat state subheading 
egen group = group(cat state subheading)
sort group cong
qui by group: gen first_time = (_n==1)
gen recurrent = (first_time==0)
sort cong

gen new_approp = first_time*approp_amount

collapse (sum) new_approp* approp* first_time recurrent, by(cong)

gen frac_new_total = new_approp/approp_amount
gen discrete_frac = first_time/(first_time+recurrent)
rename cong congress

#delimit ;
twoway (line frac_new_total congress if cong<47, lcolor(black) lwidth(medium) sort)
(lowess frac_new_total congress if cong<47,lcolor(gray) lwidth(medium) sort),
/*y-axis options*/
ytitle("Fraction authorizations to new starts", margin(zero) alignment(bottom)) 
yscale(titlegap(5) outergap(-3)) 
ylabel(0(0.2)1, labsize(small) labgap(tiny) nogrid)
yline(0.2 .4 .6 .8, lcolor(gs12))
/*x-axis options*/
xtitle("Congress", alignment(bottom)) 
xscale(noline titlegap(5) outergap(-3)) 
xlabel(0(10)45, labsize(small) labgap(small)) 
/*General*/
xsize(3.5) ysize(2.5) 
aspectratio(1) 
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white))
name(gph1,replace) legend(off);
#delimit cr

#delimit ;
twoway (line discrete_frac congress if cong<47, lcolor(black) lwidth(medium) sort)
(lowess discrete_frac congress if cong<47,lcolor(gray) lwidth(medium) sort),
/*y-axis options*/
ytitle("Fraction new starts", margin(zero) alignment(bottom)) 
yscale(titlegap(5) outergap(-3)) 
ylabel(0(0.2)1, labsize(small) labgap(tiny) nogrid)
yline(0.2 .4 .6 .8, lcolor(gs12))
/*x-axis options*/
xtitle("Congress", alignment(bottom)) 
xscale(noline titlegap(5) outergap(-3)) 
xlabel(0(10)45, labsize(small) labgap(small)) 
/*General*/
xsize(3.5) ysize(2.5) 
aspectratio(1) 
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white))
name(gph2,replace) legend(off);

graph combine gph1 gph2, graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) lwidth(none)) 
plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white) lwidth(none))  name(gphcombo,replace);

graph export "output/fraction_new_starts.pdf", as(pdf) replace;



