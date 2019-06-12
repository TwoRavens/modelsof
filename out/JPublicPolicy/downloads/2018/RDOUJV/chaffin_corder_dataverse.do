* Replication do file 
* HOW DO SOCIAL SECURITY EXPENDITURES VARY BY STATE?
* Chaffin & Corder 2017
* 1 November 2017

use chaffin_corder_dataverse

* Generate per capita measures and ratios
* oa is in millions of dollars

*convert oa and income to 2013 constant dollars using cpi
gen roa=oa*232.962/cpi
gen rinc=i*232.962/cpi

gen rpercapita_oa=1000000*roa/p
gen rpercap65_oa=1000000*roa/o
gen pct_over65=100*o/p

* The variable below was added after first set of reviews
* percentage change in seniors over previous year
sort state year
gen delta_o=(100*(o-o[_n-1]))/o[_n-1] if state==state[_n-1]

* These are the dependent variables:  average benefits and percent of seniors covered
gen av_ben=1000000*roa/(nch+nrw+nsp)
gen coverage=100*(nrw+nsp)/o

* Old age benefits as a percentage of state gdp
gen pct_gdp=100*oa/g

* Percentage of population in poverty and percentage minority
gen poverty=100*pov/p
gen minority=100*(p-white)/p

* use egen to generate yearly averages for three measures
* Note that this is not actual national average since state populations vary
* This is average of the states, not weighted
* Use this below to plot Michigan and Louisiana and national average

egen average1=mean(pct_gdp) , by(year)
egen average2=mean(rpercapita_oa), by(year)
egen average3=mean(av_ben), by(year)
egen average4=mean(coverage), by(year)
egen group=group(state)

tsset group year

* Convert real income to thousands (makes coefficients easier to interpret)
replace rinc=rinc/1000

* Create lags for income and manufacturing
* This is done to test where the income variable switches to positive
* This lag choice does not impact the unemployment coefficient
* Anything lag 12 or above is OK

* Create the lags for real per capita income 
gen  lag5_rinc=l5.rinc
gen lag10_rinc=l10.rinc
gen lag11_rinc=l11.rinc
gen lag12_rinc=l12.rinc
gen lag13_rinc=l13.rinc
gen lag14_rinc=l14.rinc
gen lag15_rinc=l15.rinc
gen lag20_rinc=l20.rinc
gen lag25_rinc=l25.rinc
* Create the lags for manufacturing employment and use identical lags as above
gen lag5_manf=l5.pct_manf
gen lag10_manf=l10.pct_manf
gen lag11_manf=l11.pct_manf
gen lag12_manf=l12.pct_manf
gen lag13_manf=l13.pct_manf
gen lag14_manf=l14.pct_manf
gen lag15_manf=l15.pct_manf

* Drop DC and observations with missing data
* Missing data are years with only cpi and real per capita income

drop if oa==.
drop if state=="District of Columbia"

sort year



* FIGURES

#delimit ;
* FIGURE 2;
graph twoway
(scatter average1 year, c(l) lpattern(solid) msymbol(d) mcolor(gs2))
(scatter pct_gdp year if state=="Michigan",c(l) lpattern(dot) msymbol(o) mcolor(gs2)) 
(scatter pct_gdp year if state=="Louisiana",c(l) lpattern(dot) msymbol(t) mcolor(gs2)),
xtitle("")  text(4.5 2011 "Michigan") text(2.35 2001 "Louisiana" ) text(3.12 2006 "U.S. average")
yscale(range(2(1)5))
ytitle("") l2title("OA as percentage of state GDP")
xlabel(2000 2004 2008 2012, format(%2.0f) angle(0))  
legend(off) 
;
*graph export figure2.tif, width(800) replace;


* FIGURE 4;
graph twoway
(scatter average4 year, c(l) lpattern(solid) msymbol(d) mcolor(gs2))
(scatter coverage year if state=="Michigan",c(l) lpattern(dot) msymbol(o) mcolor(gs2)) 
(scatter coverage year if state=="Louisiana",c(l) lpattern(dot) msymbol(t) mcolor(gs2)),
xtitle("")  text(96 2008 "Michigan") text(80 2002 "Louisiana" ) text(87 2005  "U.S. average")
yscale(range(70(10)100)) ylabel(75 85 95, format(%3.0fc))
ytitle("") l2title("Percentage of seniors covered")
xlabel(2000 2004 2008 2012, format(%2.0f) angle(0))  
legend(off);
*graph export figure4.tif, width(800) replace;

*FIGURE 5;
graph twoway
(scatter average3 year, c(l) lpattern(solid) msymbol(d) mcolor(gs2))
(scatter av_ben year if state=="Louisiana",c(l) lpattern(dot) msymbol(o) mcolor(gs2)) 
(scatter av_ben year if state=="Michigan",c(l) lpattern(dot) msymbol(t) mcolor(gs2)),
xtitle("")  text(10750 2004 "Louisiana") text(14500 2006 "Michigan" ) text(12500 2004  "U.S. average")
ytitle("") l2title("Average OA benefit (2013 dollars)")
xlabel(2000 2004 2008 2012, format(%2.0f) angle(0))  
legend(off);
*graph export figure5.tif, width(800) replace;

* FIGURE 1;
scatter rpercapita_oa pct_over65,
b2("Percent of state population 65 and over") xtitle("") ytitle("") 
l2("OA benefits per capita, 2013 dollars") scheme(s1mono) ylabel(,format(%12.0fc))
;
*graph export figure1.tif, width(800) replace;

* FIGURE 3;
scatter pct_gdp pct_over65,
b2("Percent of state population 65 and over") xtitle("") ytitle("") 
l2("OA as percent of state GDP") scheme(s1mono) ylabel(,format(%12.0fc))
;
*graph export figure3.tif, width(800) replace;

#delimit cr

* FIGURE 6
sort group year
gen temp1=d.av_ben
egen dmean_ben=mean(temp1), by(year)
gen temp2=d.ur
egen dmean_ur=mean(temp2), by(year)
gen temp3=d.rinc
egen dmean_rinc=mean(temp3), by(year)
sort year

#delimit ;
graph twoway (line dmean_ben year,yaxis(1) ytitle(" " , axis(1)) lpattern(solid))   (line dmean_ur  year, yaxis(2) ytitle(" " , axis(2)) lpattern(dash)),
r2("Unemployment, change from previous year") l2("Average real benefit, change from previous year") xlabel(2000 2004 2008 2012, format(%2.0f) angle(0))  
legend( order(1 "Average real annual benefit, first difference" 2  "Unemployment, first difference") rows(2) symplacement(right) symxsize(10) forcesize position(6) bmargin(t+5)) ;
#delimit cr
*graph export figure6.tif, width(800) replace

*FIGURE 7 
sort group year
#delimit ;
graph twoway (line d.av_ben year if state=="Louisiana", yaxis(1) ytitle(" " , axis(1)) lpattern(solid))   (line d.ur  year if state=="Louisiana", yaxis(2) ytitle(" " , axis(2)) lpattern(dash)), ylabel(-4(2)6, axis(2)) ylabel(-500(500)1000, axis(1))
r2("Unemployment, change from previous year") l2("Average real benefit, change from previous year") xlabel(2000 2004 2008 2012, format(%2.0f) angle(0))  
legend( order(1 "Average real annual benefit, first difference" 2  "Unemployment, first difference") rows(2) symplacement(right) symxsize(10) forcesize position(6) bmargin(t+5)) ;
*graph export figure7.tif, width(800) replace;
#delimit cr

* FIGURE 8
#delimit ;
graph twoway (line d.av_ben year if state=="Michigan", yaxis(1) ytitle(" " , axis(1)) lpattern(solid))   (line d.ur  year if state=="Michigan", yaxis(2) ytitle(" " , axis(2)) lpattern(dash)), ylabel(-4(2)6, axis(2)) ylabel(-500(500)1000, axis(1))
r2("Unemployment, change from previous year") l2("Average real benefit, change from previous year") xlabel(2000 2004 2008 2012, format(%2.0f) angle(0))  
legend( order(1 "Average real annual benefit, first difference" 2  "Unemployment, first difference") rows(2) symplacement(right) symxsize(10) forcesize position(6) bmargin(t+5)) ;
*graph export figure8.tif, width(800) replace;
#delimit cr

* UNIT ROOT TESTS 

sort group year

* Unit root tests - these variables or first differences all pass
* Verified August, 2016
* xtunitroot ips d.roa
* xtunitroot ips d.pct_gdp
xtunitroot ips d.av_ben
xtunitroot ips d.cov
xtunitroot ips d.rinc
xtunitroot ips d.poverty
xtunitroot ips d.minority
xtunitroot ips d.ur
xtunitroot ips d.ed
xtunitroot ips d.delta_o
* Note that socseccovered has too many all zeroes and all ones to do this test


* ESTIMATES

* Alternatives as reported in the online appendix are estimated first
* Final specification is also estimated at the end of the .do file

* Alternative specifications - #2 is the manuscript model

xtgls  d.av_ben  d.lag15_rinc d.ur d.minority d.poverty d.ed, corr(ar1) panels(heteroskedastic)
xtgls  d.av_ben  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
xtgls  d.av_ben  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered lag10_manf, corr(ar1) panels(heteroskedastic)

xtgls  d.cov  d.lag15_rinc d.ur d.minority d.poverty d.ed, corr(ar1) panels(heteroskedastic)
xtgls  d.cov  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
xtgls  d.cov  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered lag10_manf, corr(ar1) panels(heteroskedastic)

* Alternative estimation strategies - #1 is the manuscript model

xtgls  d.av_ben  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
reg    d.av_ben  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered
xtreg  d.av_ben  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, fe
xtpcse d.av_ben  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1)

xtgls  d.cov  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
reg    d.cov  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered
xtreg  d.cov  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, fe
xtpcse d.cov  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1)

* Alternative lags of real income - #1 is the manuscript model

xtgls  d.av_ben  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
xtgls  d.av_ben  d.lag10_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
xtgls  d.av_ben  d.lag20_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
xtgls  d.av_ben  d.lag25_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)

xtgls  d.cov  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
xtgls  d.cov  d.lag10_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
xtgls  d.cov  d.lag20_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
xtgls  d.cov  d.lag25_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)

* With and without the great recession (full sample (1999-2014), 1999-2007, and 2006-2014

xtgls  d.av_ben  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
xtgls  d.av_ben  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered if year<2008, corr(ar1) panels(heteroskedastic)
xtgls  d.av_ben  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered if year>2005, corr(ar1) panels(heteroskedastic)

xtgls  d.cov  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
xtgls  d.cov  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered if year<2008, corr(ar1) panels(heteroskedastic)
xtgls  d.cov  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered if year>2005, corr(ar1) panels(heteroskedastic)

* Other information reported in the manuscript

* Summary statistics for data appendix
* summarize av_ben cov lag15_rin ur minority poverty ed delta_o socseccovered

* Use these standard deviations to compare impact across variables 
* since d.x would increase from zero to a one std dev increase if 
* series jumped from one static level to another static level

* Also report the average first difference in the appendix
* summarize d.av_ben d.cov d.lag15_rin d.ur d.minority d.poverty d.ed d.delta_o d.socseccovered

* The models used for the tables in the manuscript:
 xtgls d.cov     d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)
 xtgls d.av_ben  d.lag15_rinc d.ur d.minority d.poverty d.ed d.delta_o socseccovered, corr(ar1) panels(heteroskedastic)






