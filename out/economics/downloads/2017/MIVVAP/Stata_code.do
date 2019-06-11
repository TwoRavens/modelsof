//Evaluation of Hainaut - Objective 1 using DID methods           *//
/*******************************************************************/
*Code written in support of paper "Treatment-Effect Identification Without Parallel paths: An illustration in the case of Objective 1-Hainaut/Belgium, 1994-2006"


	//During the first phase (1994-1999), the sums injected in the province's economy by both the EU and Belgian authorities (due to mandatory national co-financing) 
	//were relatively high at 2.43 billion EUROS (1994 nominal), representing a bit less than 5% of the province’s GDP for each of the year ranging from 1994 to 1999.  
	//Priorities ascribed to Objective 1-Hainaut were i) the improvement of the competitiveness of enterprises (e.g.; R& D credits) (1/3 of the total), 
	//ii) the attractiveness of the region (e.g.   through cleaning up of old industrial sites) (1/4 of total), iii) prospects for tourism and research facilities (1/5 each) (IMF, 2003).  
	

cd "C:\Ytravail\Objective1\Stata_wk"

label drop _all 

use db, clear
describe

destring ins, replace
recast int year
describe year

label var year "Year of observation"              
label var ins  "Municipality code"              
label var com   "Municipality name"                 
       
label var meanc          "Taxable income per head (mean)"      //see bottom of code for exact definition [in French]
label var meancc          "Taxable income per head (mean)- smoothed" 
label var meanccx         "Taxable income per head (mean) - smoothed & deflated (CPI base 2010)" 
label var ipc 			"CPI base 100=2010"           
label var pop            "Population of the municipality"      

label var reg           "Region (V B W)"                    
label var prov           "Province code"                  
label var provn          "Province name"                  
label var arr           "Arrondissement(ie. county within prov)" 
label var icore         "Province's inner poverty core in 1993 (mean income<q1)"
label var operi          "Hainaut's immediate Walloon periphery"                
label var t              "Time 0=before 1994; 1 after 1994"                  
label var treat          "Hainaut=1; other provinces=0" 
label var treatw          "Hainaut=1; other walloon provinces=0" 
label var itr "Interaction time *treatment (rest of Belgium)"   
label var itrw "Interaction time *treatment (rest of Wallonia)"  
label define treatf 1 "Hainaut" 0 "Other prov" 
label values treat treatf  
label data "Hainaut: taxable income (mean) per head by municipality, 1977 to 2013"              

save inc, replace
describe 
tab2 prov provn
 list year ins meancc meanccx if _n<20


/*******************************************/
/*Descriptive statistics 		    */
/*******************************************/


use inc if treat==1, clear    /*Hainaut*/
collapse meancc_h=meanccx [fweight=pop], by(year) 
save inc_h, replace
br

use inc if prov==7, clear     /*Liege*/
collapse meancc_lie=meanccx [fweight=pop], by(year) 
save inc_lie, replace
br

use inc if reg=="W" & treat==0, clear  /*Rest of Wallonia*/
collapse meancc_row=meanccx [fweight=pop], by(year) 
save inc_row, replace
br

use inc if treat==0, clear  /*Rest of Belgium*/
collapse meancc_rob=meanccx [fweight=pop], by(year) 
save inc_rob, replace
br


use inc_h, clear
merge 1:1 year using inc_rob
drop _merge 
br
merge 1:1 year using inc_row
drop _merge 
br
merge 1:1 year using inc_lie
drop _merge
br
gen db=meancc_h-meancc_rob
gen dw=meancc_h-meancc_row
gen dl=meancc_h-meancc_lie
save inc_ro, replace
br

use inc_ro if year>1986, clear
graph twoway (line meancc_h year, lc(blue) lwidth(thick) msize(medium) xlabel(1987(5)2013) text(16000 1995 "Obj1", place(e) color(red)) ) || ///
			(line meancc_lie year, lc(gs10) xlabel(1987(5)2013) text(16000 2000 "Obj1" "Phasing out", place(e) color(red))) || ///
			(line meancc_row year, lc(purple) xlabel(1987(5)2013))   ///
			(line meancc_rob year, lc(red) xlabel(1987(5)2013)) ,  ///
xline(1994 1999 2006, lwidth(vvthin) lp(shortdash))  xtitle (Year) ytitle(Euro, height(6)) ///
legend(label(1 "Hainaut") label(2 "Liege") label(3 "Rest of Wallonia") label(4 "Rest of Belgium") bmargin(zero)) ///
title("Evolution of income per head (2010 euros)*") ///
/*note("(*)Plotted means are computed using municipal-level(per head) taxable income data, weighted by population sizes & deflated by CPI (1=2010)" "Source: Statistics Belgium, 2016")*/
graph save graph0a, replace

graph twoway (line dl year, lp(dash) lc(gs10) lwidth(medthick) msize(medium) ylabel(100(-200)-2000) xlabel(1987(5)2013) text(-500 1995 "Obj1", place(e) color(red)) ) || ///
				(line dw year, lp(dash) lwidth(medthick) lc(purple) xlabel(1987(5)2013)  text(-500 2000 "Obj1" "Phasing out", place(e) color(red)))  ///
				(line db year, lp(dash) lwidth(medthick) lc(red) xlabel(1987(5)2013)  ), ///
xline(1994 1999 2006, lwidth(vvthin) lp(shortdash)) yline(0, lwidth(vvthin) lc(ltblue) lp(solid))  xtitle (Year) ytitle(Euro, height(6)) ///
legend(label(1 "ref=Liege") label(2 "ref=rest of Wallonia") label(3 "ref=rest of Belgium") bmargin(zero)) ///
title("Evolution income per head handicap (2010 euros)*" ) ///
/*note("(*)Plotted means are computed using municipal-level(per head) taxable income data weighted by population sizes & deflated by CPI (1=2010)" "Source: Statistics Belgium, 2016")*/
graph save graph0b, replace

		//$$$ FIGURE 4
graph combine graph0a.gph graph0b.gph , title("Hainaut vs Liege, Wallonia & Belgium", size(small))  ///
note("(*)Plotted means are computed using municipal-level(per head) data" "weighted by population sizes & deflated by CPI (1=2010)" "Source: Statistics Belgium, 2016") ///
 iscale(.4) cols(2) rows(1) 
 

graph save graph0, replace


	// $$$$ TABLE 1 
use inc  if inlist(year, 1993), clear   
tabstat meancc, statistics(n) /*columns(statistics)*/ by(treat)
tabstat meancc if inlist(year, 1993) & reg=="W", statistics(n) columns(statistics) by(treat)
tabstat meancc if inlist(year, 1993) & inlist(prov,6,7), statistics(n) columns(statistics) by(treat)

/*******************************************/
/*Strategy 1 - canonical Diff in diff model*/
/*******************************************/

*1.1.Canonical model

use inc, clear
foreach x of numlist 2000/2007 {
eststo DD_l`x':reg meanccx t treat itr  [fweight=pop] if inlist(year, 1993,`x') & inlist(prov,6,7), robust //with municipality population as weight
 scalar drop _all
 estadd scalar Nobs= e(N_clust)
estadd scalar Rsq=e(r2)
estadd scalar DD1=_b[itr]
testnl _b[itr]=0
estadd scalar p_DD1= r(p)			  


use inc , clear
eststo DD_w`x': reg meanccx t treat itr   [fweight=pop] if inlist(year, 1993, `x') & reg=="W", robust //with municipality population as weight
 scalar drop _all
 estadd scalar Nobs= e(N)
estadd scalar Rsq=e(r2)
estadd scalar DD1=_b[itr]
testnl _b[itr]=0
estadd scalar p_DD1= r(p)

eststo DD_b`x': reg meanccx t treat itr   [fweight=pop] if inlist(year, 1993, `x'), robust //with municipality population as weight
 scalar drop _all
 estadd scalar Nobs= e(N)
estadd scalar Rsq=e(r2)
estadd scalar DD1=_b[itr]
testnl _b[itr]=0
estadd scalar p_DD1= r(p)				
}

		

////$$$ TABLE 2///
  esttab DD_l2000 DD_l2007 DD_w2000 DD_w2007  DD_b2000 DD_b2007  using "C:\Ytravail\Objective1\Results\DD", ///
  b(2) se(3) r2(4) stats(Rsq DD1 p_DD1, fmt(%9.2f %9.2f %9.3f))    replace rtf  ///
  title(Canonical DD[1] estimation)  eqlabels(none)      ///
  compress nonumbers mtitles("Liege 00" "Liege 07" "r.of Wall. 2000"  "r.of Wall. 2007" "r.of Bel. 00"  "r.of Bel. 07") ///
 addnote("Estimates obtained using Statistics Belgium municipal-level(per head) taxable income data" "weighted by population sizes & deflated by CPI (1=2010)")
 
 
 
/*Showing that the DD1 assumption is violated before 1994 (and already much less DD2, DD3)*/

local bw=.4
		*rest of Belgium
use inc if inrange(year, 1977, 2013) , clear
qui: collapse (mean) meanccx [fweight=pop], by(year treat)
qui: reshape wide meanccx, i(year)  j(treat) 
keep if inrange(year,1985, 1993)
br
graph twoway (line meanccx1 year ,   lp(solid) lc(blue) lwidth(medthick) msize(medium) /*ylabel(3500(2000)9500)*/ xlabel(1985(1)1993)  ytitle(level) ) ///
			(line meanccx0 year ,   lp(solid) lc(red) lwidth(medium)       ), ///
			xtitle (Year) ytitle(Euro, height(4)) ///
legend(label(1 "Hainaut") label(2 "Rest of Belgium") bmargin(zero)) ///
title("Income level- Hainaut vs rest of Belgium") 
graph save graph1b, replace

use inc if inrange(year, 1977, 2013) , clear
qui: collapse (mean) meanccx [fweight=pop], by(year treat)
qui: reshape wide meanccx, i(year)  j(treat) 
gen DD0=meanccx1-meanccx0
br
lowess DD0 year  , bw(`bw') gen(DD0s)
gen DD1=DD0[_n]- DD0[_n-1]
lowess DD1 year , bw(`bw') gen(DD1s)
gen DD2=DD0[_n]-( DD0[_n-1] + ((DD0[_n-1]-DD0[_n-2]) ) )
lowess DD2 year , bw(`bw') gen(DD2s)
gen DD3=DD0[_n]-( DD0[_n-1] + ((DD0[_n-1]-DD0[_n-2]) + ((DD0[_n-1]-DD0[_n-2])- (DD0[_n-2]-DD0[_n-3]) ) ) ) 
lowess DD3 year, gen(DD3s)

keep if inrange(year,1985,1993)
graph twoway  (line DD1s year,  lp(solid) lc(green) lwidth(medthick) ytitle(DDq)  xlabel(1985(1)1993) ) ///
			(line DD2s year,   lp(dash) lc(red) lwidth(thin)   ) ///
			(line DD3s year,   lp(dash) lc(black) lwidth(thin)  ), ///
			xtitle (Year) ytitle(Euro, height(4)) ///
yline(0, lc(black) lp(solid) ) ///
legend(label(1 "DD[1]") label(2 "DD[2]")  label(3 "DD[3]") bmargin(zero)) ///
title("Rest of Belgium=ref")
graph save graph2b, replace



	*rest of Wallonia
	local bw=.4
use inc if inrange(year, 1977, 2013) & reg=="W", clear
qui: collapse (mean) meanccx [fweight=pop], by(year treat)
qui: reshape wide meanccx, i(year)  j(treat) 
keep if inrange(year,1985, 1993)
br
graph twoway (line meanccx1 year ,   lp(solid) lc(blue) lwidth(medthick) /*ylabel(3500(2000)9500)*/ xlabel(1985(1)1993)  ytitle(level) ) ///
			(line meanccx0 year ,   lp(solid) lc(purple) lwidth(medium)       ), ///
			xtitle (Year) ytitle(Euro, height(4)) ///
legend(label(1 "Hainaut") label(2 "Rest of Wallonia") bmargin(zero)) ///
title("Income level- Hainaut vs rest of Wall.") 
graph save graph1w, replace

use inc if inrange(year, 1977, 2013) & reg=="W" , clear
qui: collapse (mean) meanccx [fweight=pop], by(year treat)
qui: reshape wide meanccx, i(year)  j(treat) 
gen DD0=meanccx1-meanccx0
lowess DD0 year  , bw(`bw') gen(DD0s)
gen DD1=DD0[_n]- DD0[_n-1]
lowess DD1 year , bw(`bw') gen(DD1s)
gen DD2=DD0[_n]-( DD0[_n-1] + ((DD0[_n-1]-DD0[_n-2]) ) )
lowess DD2 year , bw(`bw') gen(DD2s)
gen DD3=DD0[_n]-( DD0[_n-1] + ((DD0[_n-1]-DD0[_n-2]) + ((DD0[_n-1]-DD0[_n-2])- (DD0[_n-2]-DD0[_n-3]) ) ) ) 
lowess DD3 year, gen(DD3s)

keep if inrange(year,1985,1993)
graph twoway  (line DD1s year,  lp(solid) lc(green) lwidth(medthick) ytitle(DDq)  xlabel(1985(1)1993) ) ///
			(line DD2s year,   lp(dash) lc(red) lwidth(thin)   ) ///
			(line DD3s year,   lp(dash) lc(black) lwidth(thin)  ), ///
			xtitle (Year) ytitle(Euro, height(4)) ///
yline(0, lc(black) lp(solid) ) ///
legend(label(1 "DD[1]") label(2 "DD[2]")  label(3 "DD[3]") bmargin(zero)) ///
title("Rest of Wallonia=ref")
graph save graph2w, replace


	*Liege
	local bw=.4
use inc if inrange(year, 1977, 2013) & inlist(prov,6,7), clear
qui: collapse (mean) meanccx [fweight=pop], by(year treat)
qui: reshape wide meanccx, i(year)  j(treat) 
keep if inrange(year,1985, 1993)
br
graph twoway (line meanccx1 year ,   lp(solid) lc(blue) lwidth(medthick) /*ylabel(3500(2000)9500)*/ xlabel(1985(1)1993)  ytitle(level) ) ///
			(line meanccx0 year ,   lp(solid) lc(gs10) lwidth(medium)       ), ///
			xtitle (Year) ytitle(Euro, height(4)) ///
legend(label(1 "Hainaut") label(2 "Liege") bmargin(zero)) ///
title("Income level- Hainaut vs Liege") 
graph save graph1l, replace

use inc if inrange(year, 1977, 2013)  & inlist(prov,6,7) , clear
qui: collapse (mean) meanccx [fweight=pop], by(year treat)
qui: reshape wide meanccx, i(year)  j(treat) 
gen DD0=meanccx1-meanccx0
lowess DD0 year  , bw(`bw') gen(DD0s)
gen DD1=DD0[_n]- DD0[_n-1]
lowess DD1 year , bw(`bw') gen(DD1s)
gen DD2=DD0[_n]-( DD0[_n-1] + ((DD0[_n-1]-DD0[_n-2]) ) )
lowess DD2 year , bw(`bw') gen(DD2s)
gen DD3=DD0[_n]-( DD0[_n-1] + ((DD0[_n-1]-DD0[_n-2]) + ((DD0[_n-1]-DD0[_n-2])- (DD0[_n-2]-DD0[_n-3]) ) ) ) 
lowess DD3 year, gen(DD3s)

keep if inrange(year,1985,1993)
graph twoway  (line DD1s year,  lp(solid) lc(green) lwidth(medthick) ytitle(DDq)  xlabel(1985(1)1993) ) ///
			(line DD2s year,   lp(dash) lc(red) lwidth(thin)   ) ///
			(line DD3s year,   lp(dash) lc(black) lwidth(thin)  ), ///
			xtitle (Year) ytitle(Euro, height(4)) ///
yline(0, lc(black) lp(solid) ) ///
legend(label(1 "DD[1]") label(2 "DD[2]")  label(3 "DD[3]") bmargin(zero)) ///
title("Liege=ref")
graph save graph2l, replace

//$$$ FIGURE 5 ////
graph combine /*graph1l.gph graph1w.gph graph1b.gph*/  graph2l.gph graph2w.gph graph2b.gph,  ///
note("(*)Plotted means are computed using municipal-level(per head) data" "weighted by population sizes & deflated by CPI (1=2010)" "Source: Statistics Belgium, 2016") ///
 iscale(.4) cols(3) rows(1) ycommon
 

graph save graph1_2, replace



/***************************************************************************/
/*Strategy 2 -  DiDq (relaxing the common trend assumption)                 */
/****************************************************************************/

		/*DD1 vs DD2 */
		*Liege
foreach yf of numlist 1994/2013 {
use inc if inlist(prov,6,7) & year>1986,clear
qui: reg meanccx year##treat [fweight=pop] /*with municipality population as weight*/
local x="year#1.treat"
local s=`yf'-1993
local yb=1993-`s'
local t=1993
local t1=1992
local t2=1991
local t3=1990
local t4=1989
local t5=1988
local d1="(_b[`t'.`x'] - _b[`t1'.`x'])"
local d2="(_b[`t1'.`x']- _b[`t2'.`x'])"
local d3="(_b[`t2'.`x']- _b[`t3'.`x'])"
local d4="(_b[`t3'.`x']- _b[`t4'.`x'])"
local d5="(_b[`t4'.`x']- _b[`t5'.`x'])"
qui: lincom _b[`yf'.`x'] - _b[`t'.`x']
gen DD1_l=r(estimate)
gen DD1_ll = r(estimate) + invnorm(0.1)*r(se)
gen DD1_lu = r(estimate) + invnorm(0.9)*r(se)
qui: lincom  _b[`yf'.`x'] - (_b[`t'.`x'] + `s'*[`d1'+ `d2'+ `d3' +`d4']/4  )  /*s-periods ahead extrapolation of what is observed on average per year between t and t-3*/
gen DD2_l=r(estimate)
gen DD2_ll = r(estimate) + invnorm(0.1)*r(se)
gen DD2_lu = r(estimate) + invnorm(0.9)*r(se)
gen yyr=`yf'
keep yyr DD1_l DD1_lu DD1_ll DD2_l DD2_lu DD2_ll
keep if _n==1
save yr`yf',replace
}
br
  use yr1994, clear
  foreach w of numlist 1995/2013 {
     append using yr`w'
	 save yr_x_l, replace
     } 

br
	*rest of Wallonia
foreach yf of numlist 1994/2013 {
use inc if reg=="W" & year>1986,clear
qui: reg meanccx year##treat [fweight=pop] /*with municipality population as weight*/
local x="year#1.treat"
local s=`yf'-1993
local yb=1993-`s'
local t=1993
local t1=1992
local t2=1991
local t3=1990
local t4=1989
local t5=1988
local d1="(_b[`t'.`x'] - _b[`t1'.`x'])"
local d2="(_b[`t1'.`x']- _b[`t2'.`x'])"
local d3="(_b[`t2'.`x']- _b[`t3'.`x'])"
local d4="(_b[`t3'.`x']- _b[`t4'.`x'])"
local d5="(_b[`t4'.`x']- _b[`t5'.`x'])"
qui: lincom _b[`yf'.`x'] - _b[`t'.`x']
gen DD1_w=r(estimate)
gen DD1_wl = r(estimate) + invnorm(0.1)*r(se)
gen DD1_wu = r(estimate) + invnorm(0.9)*r(se)
qui: lincom  _b[`yf'.`x'] - (_b[`t'.`x'] + `s'*[`d1'+ `d2'+ `d3' +`d4']/4  )  /*s-periods ahead extrapolation of what is observed on average per year between t and t-3*/
gen DD2_w=r(estimate)
gen DD2_wl = r(estimate) + invnorm(0.1)*r(se)
gen DD2_wu = r(estimate) + invnorm(0.9)*r(se)
gen yyr=`yf'
keep yyr DD1_w DD1_wu DD1_wl DD2_w DD2_wu DD2_wl
keep if _n==1
save yr`yf',replace
}
  use yr1994, clear
  foreach w of numlist 1995/2013 {
     append using yr`w'
	 save yr_x_w, replace
     } 

br

	*rest of Belgium
foreach yf of numlist 1994/2013 {
use inc if year>1986,clear
qui: reg meanccx year##treat [fweight=pop] /*with municipality population as weight*/
local x="year#1.treat"
local s=`yf'-1993
local yb=1993-`s'
local t=1993
local t1=1992
local t2=1991
local t3=1990
local t4=1989
local t5=1988
local d1="(_b[`t'.`x'] - _b[`t1'.`x'])"
local d2="(_b[`t1'.`x']- _b[`t2'.`x'])"
local d3="(_b[`t2'.`x']- _b[`t3'.`x'])"
local d4="(_b[`t3'.`x']- _b[`t4'.`x'])"
local d5="(_b[`t4'.`x']- _b[`t5'.`x'])"
qui: lincom _b[`yf'.`x'] - _b[`t'.`x']
gen DD1_b=r(estimate)
gen DD1_bl = r(estimate) + invnorm(0.1)*r(se)
gen DD1_bu = r(estimate) + invnorm(0.9)*r(se)
qui: lincom  _b[`yf'.`x'] - (_b[`t'.`x'] + `s'*[`d1'+ `d2'+ `d3' +`d4']/4 )  /*s-periods ahead extrapolation of what is observed on average per year between t and t-3*/
gen DD2_b=r(estimate)
gen DD2_bl = r(estimate) + invnorm(0.1)*r(se)
gen DD2_bu = r(estimate) + invnorm(0.9)*r(se)
gen yyr=`yf'
keep yyr DD1_b DD1_bu DD1_bl DD2_b DD2_bu DD2_bl
keep if _n==1
save yr`yf',replace
}
  use yr1994, clear
  foreach w of numlist 1995/2013 {
     append using yr`w'
	 save yr_x_b, replace
     } 

br

*compute Belgian ref
use inc if year>1993, clear
collapse meanccx [fweight=pop], by(year) 
gen yyr=year
drop year
save inc_ref, replace
br
	*merge
use inc_ref, clear
sort yyr
use yr_x_l, clear
sort yyr
use yr_x_w, clear
sort yyr
use yr_x_b, clear
sort yyr

use yr_x_l, clear
merge 1:1 yyr using yr_x_w
drop _merge
merge 1:1 yyr using yr_x_b
drop _merge
merge 1:1 yyr using inc_ref
drop _merge
br

gen rDD1_l=DD1_l/meanccx
gen rDD1_ll=DD1_ll/meanccx
gen rDD1_lu=DD1_lu/meanccx
gen rDD2_l=DD2_l/meanccx
gen rDD2_ll=DD2_ll/meanccx
gen rDD2_lu=DD2_lu/meanccx
gen rDD1_b=DD1_b/meanccx
gen rDD1_bl=DD1_bl/meanccx
gen rDD1_bu=DD1_bu/meanccx
gen rDD2_b=DD2_b/meanccx
gen rDD2_bl=DD2_bl/meanccx
gen rDD2_bu=DD2_bu/meanccx
gen rDD1_w=DD1_w/meanccx
gen rDD1_wl=DD1_wl/meanccx
gen rDD1_wu=DD1_wu/meanccx
gen rDD2_w=DD2_w/meanccx
gen rDD2_wl=DD2_wl/meanccx
gen rDD2_wu=DD2_wu/meanccx

br

save yr_x_all, replace

///$$$ TABLE 3 /////
export excel "C:\Ytravail\Objective1\Results\Table3", firstrow(var) replace


use yr_x_all, clear
twoway (line DD1_l yyr,  xlabel(1994(2)2013) /*ylabel(-1200(200)200)*/ lc(blue) lwidth(tiny) text(2000 1995 "Obj1", place(e) color(red))) ||  ///
	(line DD1_ll yyr,  lp(dash) lc(blue) lwidth(vtiny) ) ||  ///
	(line DD1_lu yyr,  lp(dash) lc(blue) lwidth(vtiny) ) ||  ///
       (line DD2_l yyr, lc(red) lwidth(tiny) text(2000 2000 "Obj1- Phasing out", place(e) color(red)) ) ///
	   (line DD2_ll yyr, lp(dash) lc(red) lwidth(vtiny) ) ///
	   (line DD2_lu yyr, lp(dash) lc(red) lwidth(vtiny) ), ///
 yline(0) xline(1994 1999 2006, lwidth(vvthin) lp(shortdash)) xtitle("Year") ytitle("Euros",  height(4)) ///
  legend(order(1 4) label(1 "DD[1]") /*label(2 "DD1l") label(3 "DD1u")*/ label(4 "DD[2]") /*label(5 "DD2l") label(6 "DDu")*/ size(small))  ///
 title("Liege =ref" ) ///
 note("Estimates obtained using Statistics Belgium municipal-level taxable income data" "weighted by population sizes & deflated by CPI (1=2010)")
graph save Gr_hainaut_DD2l, replace 

twoway (line rDD1_l yyr,  xlabel(1994(2)2013) /*ylabel(-1200(200)200)*/ lc(blue) lwidth(tiny) text(.05 1995 "Obj1", place(e) color(red))) ||  ///
	(line rDD1_ll yyr,  lp(dash) lc(blue) lwidth(vtiny) ) ||  ///
	(line rDD1_lu yyr,  lp(dash) lc(blue) lwidth(vtiny) ) ||  ///
       (line rDD2_l yyr, lc(red) lwidth(tiny) text(.05 2000 "Obj1- Phasing out", place(e) color(red)) ) ///
	   (line rDD2_ll yyr, lp(dash) lc(red) lwidth(vtiny) ) ///
	   (line rDD2_lu yyr, lp(dash) lc(red) lwidth(vtiny) ), ///
 yline(0) xline(1994 1999 2006, lwidth(vvthin) lp(shortdash)) xtitle("Year") ytitle("%",  height(4)) ///
  legend(order(1 4) label(1 "DD[1]") /*label(2 "DD1l") label(3 "DD1u")*/ label(4 "DD[2]") /*label(5 "DD2l") label(6 "DDu")*/ size(small))  ///
 title("Liege =ref" ) ///
 note("Estimates obtained using Statistics Belgium municipal-level taxable income data" "weighted by population sizes & deflated by CPI (1=2010)")

 graph save Gr_hainaut_DD2lr, replace 


twoway (line DD1_w yyr,  xlabel(1994(2)2013) /*ylabel(-1200(200)200)*/ lc(blue) lwidth(tiny) text(2000 1995 "Obj1", place(e) color(red))) ||  ///
	(line DD1_wl yyr,  lp(dash) lc(blue) lwidth(vtiny) ) ||  ///
	(line DD1_wu yyr,  lp(dash) lc(blue) lwidth(vtiny) ) ||  ///
       (line DD2_w yyr, lc(red) lwidth(tiny) text(2000 2000 "Obj1- Phasing out", place(e) color(red)) ) ///
	   (line DD2_wl yyr, lp(dash) lc(red) lwidth(vtiny) ) ///
	   (line DD2_wu yyr, lp(dash) lc(red) lwidth(vtiny) ), ///
	   yline(0) xline(1994 1999 2006, lwidth(vvthin) lp(shortdash)) xtitle("Year") ytitle("Euros",  height(4)) ///
   legend(off) /* legend(label(1 "DD1") label(2 "DD1l") label(3 "DD1u") label(4 "DD2") label(5 "DD2l") label(6 "DD2u"))  */ ///
 title("r. of Wal. =ref") ///
 note("Estimates obtained using Statistics Belgium municipal-level taxable income data" "weighted by population sizes & deflated by CPI (1=2010)")
  
graph save Gr_hainaut_DD2w, replace 

twoway (line rDD1_w yyr,  xlabel(1994(2)2013) /*ylabel(-1200(200)200)*/ lc(blue) lwidth(tiny) text(.05 1995 "Obj1", place(e) color(red))) ||  ///
	(line rDD1_wl yyr,  lp(dash) lc(blue) lwidth(vtiny) ) ||  ///
	(line rDD1_wu yyr,  lp(dash) lc(blue) lwidth(vtiny) ) ||  ///
       (line rDD2_w yyr, lc(red) lwidth(tiny) text(.05 2000 "Obj1- Phasing out", place(e) color(red)) ) ///
	   (line rDD2_wl yyr, lp(dash) lc(red) lwidth(vtiny) ) ///
	   (line rDD2_wu yyr, lp(dash) lc(red) lwidth(vtiny) ), ///
	   yline(0) xline(1994 1999 2006, lwidth(vvthin) lp(shortdash)) xtitle("Year") ytitle("%",  height(4)) ///
   legend(off) /* legend(label(1 "DD1") label(2 "DD1l") label(3 "DD1u") label(4 "DD2") label(5 "DD2l") label(6 "DD2u"))  */ ///
 title("r. of Wal. =ref") ///
 note("Estimates obtained using Statistics Belgium municipal-level taxable income data" "weighted by population sizes & deflated by CPI (1=2010)")
  
graph save Gr_hainaut_DD2wr, replace 


twoway (line DD1_b yyr,  xlabel(1994(2)2013) /*ylabel(-1200(200)200)*/ lc(blue) lwidth(tiny) text(2000 1995 "Obj1", place(e) color(red))) ||  ///
	(line DD1_bl yyr,  lp(dash) lc(blue) lwidth(vvtiny) ) ||  ///
	(line DD1_bu yyr,  lp(dash) lc(blue) lwidth(vvtiny) ) ||  ///
       (line DD2_b yyr, lc(red) lwidth(tiny) text(2000 2000 "Obj1- Phasing out", place(e) color(red)) ) ///
	   (line DD2_bl yyr, lp(dash) lc(red) lwidth(vvtiny) ) ///
	   (line DD2_bu yyr, lp(dash) lc(red) lwidth(vvtiny) ), ///
	   yline(0) xline(1994 1999 2006, lwidth(vvthin) lp(shortdash)) xtitle("Year") ytitle("Euros",  height(4)) ///
   legend(off) /* legend(label(1 "DD1") label(2 "DD1l") label(3 "DD1u") label(4 "DD2") label(5 "DD2l") label(6 "DD2u"))  */ ///
 title("r. of Belgium=ref") ///
 note("Estimates obtained using Statistics Belgium municipal-level taxable income data" "weighted by population sizes & deflated by CPI (1=2010)")
  
graph save Gr_hainaut_DD2b, replace 

twoway (line rDD1_b yyr,  xlabel(1994(2)2013) /*ylabel(-1200(200)200)*/ lc(blue) lwidth(tiny) text(.05 1995 "Obj1", place(e) color(red))) ||  ///
	(line rDD1_bl yyr,  lp(dash) lc(blue) lwidth(vvtiny) ) ||  ///
	(line rDD1_bu yyr,  lp(dash) lc(blue) lwidth(vvtiny) ) ||  ///
       (line rDD2_b yyr, lc(red) lwidth(tiny) text(0.05 2000 "Obj1- Phasing out", place(e) color(red)) ) ///
	   (line rDD2_bl yyr, lp(dash) lc(red) lwidth(vvtiny) ) ///
	   (line rDD2_bu yyr, lp(dash) lc(red) lwidth(vvtiny) ), ///
	   yline(0) xline(1994 1999 2006, lwidth(vvthin) lp(shortdash)) xtitle("Year") ytitle("%",  height(4)) ///
   legend(off) /* legend(label(1 "DD1") label(2 "DD1l") label(3 "DD1u") label(4 "DD2") label(5 "DD2l") label(6 "DD2u"))  */ ///
 title("r. of Belgium=ref") ///
 note("Estimates obtained using Statistics Belgium municipal-level taxable income data" "weighted by population sizes & deflated by CPI (1=2010)")
  graph save Gr_hainaut_DD2br, replace 


grc1leg  Gr_hainaut_DD2l.gph  Gr_hainaut_DD2w.gph Gr_hainaut_DD2b.gph , iscale(.4) cols(3) rows(1)  legendfrom(Gr_hainaut_DD2l.gph) ///
title("Change in income level handicap", size(3))  ycommon ///
subtitle("DD[1] vs DD[2] estimates; t=1993 vs t+s=2000/2013", size(2))

graph save Gr_hainaut_DD2_all, replace

///$$$ FIGURE 6 ///
grc1leg  Gr_hainaut_DD2lr.gph  Gr_hainaut_DD2wr.gph Gr_hainaut_DD2br.gph , iscale(.4) cols(3) rows(1)  legendfrom(Gr_hainaut_DD2lr.gph) ///
title("Change in income level handicap" "in % of Belgian average", size(3))  ycommon ///
subtitle("DD[1] vs DD[2] estimates; t=1993 vs t+s=2000/2013", size(2))

graph save Gr_hainaut_DD2_allr, replace



/****************************************************************************/

/* About Taxable income ...
Le revenu net imposable par déclaration est le revenu correspondant à la déclaration située au milieu de la série, lorsque les déclarations sont classées par ordre croissant de revenus. 
Celui-ci n’est pas influencé par des valeurs aberrantes (‘outliers’). Dans le fichier de données, un autre indicateur de tendance centrale est donné (le revenu moyen net imposable par déclaration). 
Il s’agit du revenu correspondant au quotient du revenu total net imposable et du nombre total de déclarations. Il est influencé par des valeurs aberrantes ('outliers'). 

Les déclarations avec revenus imposables nuls ne sont pas prises en compte dans les calculs. 

Lorsqu’on analyse les données fiscales, il est important de tenir compte des éléments suivants : 
Les statistiques sont calculées sur la base des déclarations à l’impôt des personnes physiques au lieu de résidence. 
Une déclaration peut être remplie par une (déclaration individuelle) ou deux personnes (déclaration commune). 
La règle générale veut que chacun remplit une déclaration individuelle, à l’exception des personnes mariées et des cohabitants légaux. 
L’impôt des personnes physiques est dû par les habitants du royaume, c’est-à-dire par les personnes qui ont établi en Belgique leur domicile ou le siège de leur fortune. 
L’année de revenu est l’année pour laquelle des impôts sont dus. 
Le revenu total net imposable se compose de tous les revenus nets, après soustraction des dépenses déductibles, à savoir: 
1) le total des revenus professionnels nets, 
2) le total des revenus immobiliers nets, 
3) le total des revenus mobiliers nets, 
4) le total des revenus divers nets, i.e. la somme des revenus nets divers, distinctement et globalement, par exemple les pensions alimentaires. 

Il s'agit également de la somme des revenus nets imposables globalement et des revenus nets imposables distinctement. Plus d’information sur le site du SPF- économie.
*/
