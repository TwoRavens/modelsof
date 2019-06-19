/*This file simulates earnings used to produce Figures 2 and 3 and Appendix 
Table 4 in Bitler, Gelbach, and Hoynes (2016) "Can Variation in Subgroups' 
Average Treatment Effects Explain Treatment Effect Heterogeneity? Evidence from 
a Social Experiment" */

clear
clear matrix
set mem 1800m
program drop _all
matrix drop _all

use data-final.dta, clear
keep if quarter >=1 & quarter<=7
cap gen fullsample = 1

local edvars   "gtehsged nohsged misshsged"
local ykidvars "ykidlt6 ykidge6 missykidlt6"
local whvars   "anyadcpq7 noadcpq7"
local ehvars   "anyernpq7 noernpq7"
local mhvars   "martogapt marnvr missmarnvr"
local nkvars   "kidctlt2 kidctge2 misskidctgt2"
local pq7evars  "ernpq7hi ernpq7lo vernpq70"
local npqevars "npqern0 npqernlo npqernhi"

egen ed   = group(`edvars')
egen ykid = group(`ykidvars')
egen eh = group(`ehvars')
egen wh = group(`whvars')
egen mh = group(`mhvars')
egen nk = group(`nkvars')
egen pq7e = group(`pq7evars')
egen npqe = group(`npqevars')

global list "pq7e npqe ed wh ykid mh"
global sglist "$list"
forvalues i=1/7 {
	local iplus1 = `i'+1
	local var1 : word `i' of $list

	forvalues j=`iplus1'/7 {
		local var2 : word `j' of $list
		*di "var1 var2 = '`var1' `var2''"
		egen `var1'_`var2' = group(``var1'vars' ``var2'vars')
		global sglist "$sglist `var1'_`var2'"
	}
}

**** Add in all at front
global sglist "$sglist"
di "$sglist"

*************************************************************
**** Next chunk of code to collapse really small cells    ***
*************************************************************
**** Filled in number of kids missing
**** pooled missing one and missing the other all together
capture tab mh_nk
capture recode mh_nk (2=1) (3=1) (4=2) (5=3) (6=4) (7=5)
capture tab mh_nk

** Fix small cell sizes with youngest kid and marriage
**** missmarnvr most likely missing ykid too
*** combine all with missmarnvr==1 (some of missykid)
capture tab ykid_mh
capture recode ykid_mh (2=1) (3=2) (4=3) (5=1) (6=4) (7=5)
capture tab ykid_mh

**** Fix small cells for ed_mh
**** collapse all missings
capture tab ed_mh
capture recode ed_mh (2=1) (3=1) (4=1) (7=1) (5=2) (6=3) (8=4) (9=5)
capture tab ed_mh

**** Fix small cells for npqe_ykid
**** collapse all missings for ykid
capture tab npqe_ykid
capture recode npqe_ykid (4=1) (7=1) (5=4) (6=5) (8=6) (9=7)
capture tab npqe_ykid
*************************************************************
**** End of code to collapse really small cells           ***
*************************************************************

de $sglist

*** Run sgnullsubsamplez-no-weight so can get synthetic graphs
foreach sg in pq7e npqe ed wh ykid mh {
	qui sgnullsubsampleznoweight ernq if quarter>=1 & quarter<=7, ///
	q(1/99) subgroups(`sg') saving(results/sgnullsubsample-no-bs-noweights-with-zeros-`sg', ///
	replace) timevar(quarter) bsreps(0) treatmnt(e) seed(845) idvar(id)
	}

**  Start by appending all output of sgnullsubsamplez-no-weight and reshaping
foreach sg in pq7e npqe ed wh ykid mh {
	if "`sg'" == "pq7e" {
		use results/sgnullsubsample-no-bs-noweights-with-zeros-`sg'_nt_nz, clear
		gen str5 nulltype="nt_nz" 
		gen str20 subgroup="`sg'"
		}
	else {
		append using results/sgnullsubsample-no-bs-noweights-with-zeros-`sg'_nt_nz
		replace nulltype="nt_nz" if nulltype==""
		}
	append using results/sgnullsubsample-no-bs-noweights-with-zeros-`sg'_t_nz
	replace  nulltype="t_nz"  if nulltype==""
	append using results/sgnullsubsample-no-bs-noweights-with-zeros-`sg'_t_z_wz
	replace  nulltype="t_z_wz"  if nulltype==""
	replace subgroup="`sg'" if subgroup==""
	}

** Identify group for null and subgroup
gen str30 ntsg=nulltype+" "+subgroup

** Reshape data
reshape long yhq0nz_ yhq1nz_ yhq0z_ yhq1z_ ytq1_nt_nz_ ytq1_nt_z_ ytq1_nt_z_wz_ ///
	ytq1_t_nz_ ytq1_t_z ytq1_t_z_wz_, i(ntsg) j(quantile)
rename yhq0nz_  yhq0nz
rename yhq0z_  yhq0z
rename yhq1nz_ yhq1nz
rename yhq1z_ yhq1z
rename ytq1_nt_nz_ ytq1_nt_nz
rename ytq1_nt_z_ ytq1_nt_z
rename ytq1_nt_z_wz_ ytq1_nt_z_wz
rename ytq1_t_nz_  ytq1_t_nz
rename ytq1_t_z_wz_  ytq1_t_z_wz

*** Create qtehats
*** Create qtehats
gen qtehatnz = yhq1nz-yhq0nz
label var qtehatnz "Sample QTE, all observations"

gen qtehatz = yhq1z-yhq0z
label var qtehatz "Sample QTE, earnings positive"

gen qte_nt_nz = ytq1_nt_nz-yhq0nz
label var qte_nt_nz "QTE, null 1, all observations"

gen qte_t_nz = ytq1_t_nz-yhq0nz
label var qte_t_nz "QTE, null 2, all obs"

gen qte_t_z_wz = ytq1_t_z_wz-yhq0nz
label var qte_t_z_wz "QTE, null 3, t_z, all obs"

*Label variables
label variable quantile "Percentile index"
sort quantile

local pq7etitl    "Earnings 7Q pre-RA"
local npqetitl 	  "# pre-RA Q with earnings"
local edtitl      "Education"
local whtitl      "Any welfare 7Q pre-RA"
local ykidtitl    "Age of youngest child"
local mhtitl      "Marital status"

** label with labels
for any pq7e_npqe pq7e_wpq7lev pq7e_ed pq7e_wh pq7e_ykid pq7e_mh npqe_wpq7lev ///
	npqe_ed npqe_wh npqe_ykid npqe_mh wpq7lev_ed wpq7lev_wh wpq7lev_ykid ///
	wpq7lev_mh ed_wh ed_ykid ed_mh wh_ykid wh_mh ykid_mh : local Xtitl "Xtitl"
	
save graphs/results-graphs-synthetic-real, replace
************************************************
****** Color versions of synthetic graphs ******
************************************************
* do color versions
** set scheme (s1 color, white )
set scheme s1color

********************************************************************************
***  Figure 2: Actual and simulated QTE, subgroups based on education (top)  ***
******** and earnings and welfare use before RA (bottom)  **********************
********************************************************************************

**Figure 2a Education: Time invariant
scatter qtehatnz qte_nt_nz quantile if quantile <= 98 & qte_nt_nz<. ///
	& subgroup=="ed" , sort connect(l l) lcolor(blue green) plotregion(style(none)) ///
	graphregion(fcolor(white) lstyle(none) ilstyle(none) lcolor(white) ilcolor(white)) ///
	legend(region(lstyle(none)) lcolor(white) label(1 "Actual") label(2 "Simulated")) ///
	lpattern(l - ) msymbol(i i i) saving(graphs/fig2a, replace) ///
	title("")  xlab(10 20 30 40 50 60 70 80 90) ylab(-800 -400 0 400 800 , ///
	angle(horizontal)) yline(0) 
	
	graph export graphs/fig2a.ps, replace
	graph export graphs/fig2a.eps, replace
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig2a.ps
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig2a.eps
	   !ps2pdf graphs/fig2a.ps graphs/fig2a.pdf

**Figure 2b: Education: Time varying
scatter qtehatnz qte_t_nz quantile if quantile <= 98 & qte_t_nz<. ///
	& subgroup=="ed" , sort connect(l l) lcolor(blue green) plotregion(style(none)) ///
	graphregion(fcolor(white) lstyle(none) ilstyle(none) lcolor(white) ilcolor(white)) ///
	legend(region(lstyle(none)) lcolor(white) label(1 "Actual") label(2 "Simulated")) ///
	lpattern(l - ) msymbol(i i i) saving(graphs/fig2b, replace) ///
	title("")  xlab(10 20 30 40 50 60 70 80 90) ylab(-800 -400 0 400 800 , ///
	angle(horizontal)) yline(0) 
	
	graph export graphs/fig2b.ps, replace
	graph export graphs/fig2b.eps, replace
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig2b.ps
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig2b.eps
	   !ps2pdf graphs/fig2a.ps graphs/fig2b.pdf

**Figure 2c: Earnings 7Q pre-RA: Time varying
scatter qtehatnz qte_t_nz quantile if quantile <= 98 & qte_t_nz<. ///
	& subgroup=="pq7e" , sort connect(l l) lcolor(blue green) plotregion(style(none)) ///
	graphregion(fcolor(white) lstyle(none) ilstyle(none) lcolor(white) ilcolor(white)) ///
	legend(region(lstyle(none)) lcolor(white) label(1 "Actual") label(2 "Simulated")) ///
	lpattern(l - ) msymbol(i i i) saving(graphs/fig2c, replace) ///
	title("")  xlab(10 20 30 40 50 60 70 80 90) ylab(-800 -400 0 400 800 , ///
	angle(horizontal)) yline(0)
	
	graph export graphs/fig2c.ps, replace
	graph export graphs/fig2c.eps, replace
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig2c.ps
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig2c.eps
	   !ps2pdf graphs/fig2c.ps graphs/fig2c.pdf

**Figure 2d: Any welfare 7Q pre-RA: Time varying
scatter qtehatnz qte_t_nz quantile if quantile <= 98 & qte_t_nz<. ///
	& subgroup=="wh" , sort connect(l l) lcolor(blue green) plotregion(style(none)) ///
	graphregion(fcolor(white) lstyle(none) ilstyle(none) lcolor(white) ilcolor(white)) ///
	legend(region(lstyle(none)) lcolor(white) label(1 "Actual") label(2 "Simulated")) ///
	lpattern(l - ) msymbol(i i i) saving(graphs/fig2d, replace) ///
	title("")  xlab(10 20 30 40 50 60 70 80 90) ylab(-800 -400 0 400 800 , ///
	angle(horizontal)) yline(0)
	
	graph export graphs/fig2d.ps, replace
	graph export graphs/fig2d.eps, replace
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig2d.ps
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig2d.eps
	   !ps2pdf graphs/fig2d.ps graphs/fig2d.pdf
		
	
********************************************************************************
*** Figure 3: Actual and simulated QTE with participation adjustment & time  ***
**********************  varying means, various subgroups  **********************
********************************************************************************

**Figure 3a Education
scatter qtehatnz qte_t_z_wz quantile if quantile <= 98 & qte_t_z_wz<. & subgroup=="ed" , ///
	sort connect(l l) lcolor(blue green) plotregion(style(none)) graphregion(fcolor(white) ///
	lstyle(none) ilstyle(none) lcolor(white) ilcolor(white)) legend(region(lstyle(none)) ///
	lcolor(white) label(1 "Actual") label(2 "Simulated")) lpattern(l - ) msymbol(i i i) ///
	saving(graphs/fig3a, replace) title("")  ///
	xlab(10 20 30 40 50 60 70 80 90) ylab(-800 -400 0 400 800 , angle(horizontal)) yline(0) 
	
	graph export graphs/fig3a.ps, replace
	graph export graphs/fig3a.eps, replace
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig3a.ps
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig3a.eps
	   !ps2pdf graphs/fig3a.ps graphs/fig3a.pdf

**Figure 3b: Earnings 7Q pre-RA
scatter qtehatnz qte_t_z_wz quantile if quantile <= 98 & qte_t_z_wz<. & subgroup=="pq7e" , ///
	sort connect(l l) lcolor(blue green) plotregion(style(none)) graphregion(fcolor(white) ///
	lstyle(none) ilstyle(none) lcolor(white) ilcolor(white)) legend(region(lstyle(none)) ///
	lcolor(white) label(1 "Actual") label(2 "Simulated")) lpattern(l - ) msymbol(i i i) ///
	saving(graphs/fig3b, replace) title("")  ///
	xlab(10 20 30 40 50 60 70 80 90) ylab(-800 -400 0 400 800 , angle(horizontal)) yline(0) 
	
	graph export graphs/fig3b.ps, replace
	graph export graphs/fig3b.eps, replace
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig3b.ps
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig3b.eps
	   !ps2pdf graphs/fig3b.ps graphs/fig3b.pdf

**Figure 3c: # pre-RA Q with earnings
scatter qtehatnz qte_t_z_wz quantile if quantile <= 98 & qte_t_z_wz<. & subgroup=="npqe" , ///
	sort connect(l l) lcolor(blue green) plotregion(style(none)) graphregion(fcolor(white) ///
	lstyle(none) ilstyle(none) lcolor(white) ilcolor(white)) legend(region(lstyle(none)) ///
	lcolor(white) label(1 "Actual") label(2 "Simulated")) lpattern(l - ) msymbol(i i i) ///
	saving(graphs/fig3c, replace) title("")  ///
	xlab(10 20 30 40 50 60 70 80 90) ylab(-800 -400 0 400 800 , angle(horizontal)) yline(0) 
	
	graph export graphs/fig3c.ps, replace
	graph export graphs/fig3c.eps, replace
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig3c.ps
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig3c.eps
	   !ps2pdf graphs/fig3c.ps graphs/fig3c.pdf

**Figure 3d: Any welfare 7Q pre-RA
scatter qtehatnz qte_t_z_wz quantile if quantile <= 98 & qte_t_z_wz<. & subgroup=="wh" , ///
	sort connect(l l) lcolor(blue green) plotregion(style(none)) graphregion(fcolor(white) ///
	lstyle(none) ilstyle(none) lcolor(white) ilcolor(white)) legend(region(lstyle(none)) ///
	lcolor(white) label(1 "Actual") label(2 "Simulated")) lpattern(l - ) msymbol(i i i) ///
	saving(graphs/fig3d, replace) title("")  ///
	xlab(10 20 30 40 50 60 70 80 90) ylab(-800 -400 0 400 800 , angle(horizontal)) yline(0) 
	
	graph export graphs/fig3d.ps, replace
	graph export graphs/fig3d.eps, replace
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig3d.ps
	   !perl -pi -e 's/w setlinewidth/w 3 mul setlinewidth/' graphs/fig3d.eps
	   !ps2pdf graphs/fig3d.ps graphs/fig3d.pdf
	
