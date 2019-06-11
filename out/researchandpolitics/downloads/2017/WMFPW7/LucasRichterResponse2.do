	capture log close
	log using FW-response.log, replace
	
 

* Set control variables *
global cvar = "ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem"

use temp,clear
gen n_hm_oil = ln(1+l.total_oil_income_pc) if R_rog_GDPGSRE_Mpc_ln~=.
gen n_hm0_oil = n_hm_oil
recode n_hm0_oil (mis=0) if R_totaloilincomepc_HM==0 & R_naturalgasincomepc_HM==0 & R_rog_0_GDPGSRE_Mpc_ln~=.
qui  logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail, cluster(cowcode)
gen s1 = e(sample)==1
qui logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_fail if e(sample), cluster(cowcode)
gen s2 = e(sample)==1 
egen caseid = group(geddes_case)
egen regimetype = group(geddes_regime)
egen region = group(geddes_region)
egen prior= group(geddes_prior)
recode prior (.=0)
keep if ged_dem~=. & year>1946 & year<2008  /* autocratic regime sample, 1947-2007 is years with lag oil available */
keep s1 s2 time* geddes_spell geddes_duration geddes_fail geddes_fail_subsregime ged_dict /*
*/ ged_dem ged_fail mean_dem mean_dict mean_fail year cowcode caseid prior region regimetype $cvar /*
*/ n_hm_oil n_hm0_oil R_rog_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln hm_oil dev_hmoil mean_hmoil hm_fuel mean_hmfuel dev_hmfuel lgdp  price_oil 
label var time "Calendar time"
label var time2 "Calendar time-squared"
label var time3 "Calendar time-cubed"
label var geddes_spell "Regime spell"
label var geddes_duration "Regime duration"
label var geddes_fail "Regime collapse"
label var geddes_fail_subsregime "Regime collapse, subsequent regime type"
label var ged_dict "Autocratic transition"
label var ged_dem "Democratic transition"
label var mean_dem "Country-mean: democratic transition"
label var mean_dict "Country-mean: autocratic transition"
label var mean_fail "Country mean: regime collapse"
label var year "Year"
label var cowcode "County code"
label var caseid "Regime-case identifier"
label var prior "Prior democracy"
label var region "Geographic region"
label var regimetype "Regime type"
label var n_hm_oil "N rents (log)"
label var n_hm0_oil "N rents, 0's filled in (log)"
label var R_rog_GDPGSRE_Mpc_ln "LR rents (log)"
label var R_rog_0_GDPGSRE_Mpc_ln "LR rents, 0's filled in (log)"
label var hm_oil "HM rents (log)"
label var dev_hmoil "Country deviation: HM rents"
label var mean_hmoil "Country mean: HM rents"
label var hm_fuel "HM fuel rents (log)"
label var mean_hmfuel "Country mean: HM fuel rents"
label var dev_hmfuel "Country deviation: HM fuel rents"
label var lgdp "GDP per capita (log)"
label var price_oil "World oil price"
 


sutex, minmax labels
saveold temp1, replace version(12)  /* use this data set for imputations */

use temp, clear
gen s0 = R_rog_GDPGSRE_Mpc_ln~=. 
qui logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail, cluster(cowcode)
gen s1 = e(sample)
tab s1 if geddes_duration~=.  &  mad_lgdppc~=. & year<2008 /* 3.6 % missing oil data */
tab geddes_duration if geddes_duration~=.  &  mad_lgdppc~=.  & year<2008 & s1==0  /* 20% of these are first years in the data, lagged caused missing */
keep if s1==1
qui logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_fail if e(sample), cluster(cowcode)
gen s2 = e(sample)==1 /* Lucas & Richter sample */
gen sample = s0
replace sample = 2 if s0==0 & s2==1
replace sample = 3 if s2==0
 
*** Figure 1 ***
egen yrms1=mean(s0), by(year)
replace yrms1 = 1-yrms1
egen yrms2 = mean(s2), by(year)
replace yrms2 = 1-yrms2
egen tagyr = tag(year) if yrms2~=. & yrms1~=.
gen yrms=1

table year , c(mean yrms2)

twoway(bar yrms year  if tagyr==1, sort col(gs15))   (bar yrms1 year  if tagyr==1, sort col(red)) (bar yrms2 year if tagyr==1, sort col(blue) /*
*/ scheme(lean2) ylab(0(.2)1,glcolor(gs15)) xscale(range(1950 2005)) xlab(1950(10)2000) xtitle(Year) /*
*/ ytitle(Share of WFG sample covered) legend(lab(1 "GSRE") lab(2 "GSRE + HM zeros") lab(3 "LR missing") pos(6) ring(1) col(3))) 
graph export "C:\Users\jwright\Dropbox\Research\Oil and Authoritarian Stability\LucasRichter\Fig1.pdf", as(pdf) replace
drop yrms yrms2 yrms1 tagyr
tab s2 if year<1974 /* 40% missing prior to 3rd wave */
sum ged_dict ged_dem if year<1974
sum ged_dict ged_dem if year>=1974

*** Table 1 ***
tab sample
table sample, c(min year max year n year)
table sample, c(mean hm_oil mean ged_dem mean ged_dict)
sum hm_oil ged_dem ged_dict if s2==1  
sum hm_oil ged_dem ged_dict if s1==1 
forval i = 1(1)3 { 
	egen c`i'tag = tag(cowcode) if sample==`i'
	tab c`i'tag
	egen coil`i'tag = tag(cowcode) if sample==`i' & hm_oil>0
	tab coil`i'tag 
	drop  coil`i'tag   c`i'tag 
}
egen c12tag = tag(cowcode) if s2==1
tab c12tag if s2==1
egen coil12tag =  tag(cowcode) if s2==1 & hm_oil>0 
tab coil12tag if s2==1
egen c123tag = tag(cowcode) if s1==1
tab c123tag if s1==1
egen coil123tag =  tag(cowcode) if s1==1 & hm_oil>0 
tab coil123tag if s1==1
drop *tag

*** Correlates of missing data ***  democratic transition years less likely to be in sample
logit s2 ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil, cluster(cowcode)
outtex

* Use the same procedure of filling in 0s using HM data
tsset cowcode year
gen l_hmoil = hm_oil
gen n_hm_oil = hm_oil 
replace n_hm_oil=. if  R_rog_GDPGSRE_Mpc_ln==.
sum n_hm_oil R_rog_GDPGSRE_Mpc_ln if s2==1 & R_rog_GDPGSRE_Mpc_ln~=.
sum n_hm_oil R_rog_GDPGSRE_Mpc_ln if s2==1  
pwcorr n_hm_oil R_rog_GDPGSRE_Mpc_ln if s2==1,obs
twoway scatter n_hm_oil R_rog_GDPGSRE_Mpc_ln if s2==1, scheme(lean2) ylab(,glcolor(gs15))
recode n_hm_oil (mis=0) if R_totaloilincomepc_HM==0 & R_naturalgasincomepc_HM==0 & R_rog_0_GDPGSRE_Mpc_ln~=.
egen n_mean_hmoil = mean(n_hm_oil), by(cowcode)
gen n_dev_hmoil = n_hm_oil-n_mean_hmoil

* Compare oil measures 
sum R_rog_GDPGSRE_Mpc_ln n_mean_hmoil n_dev_hmoil R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a if s0==1
corr n_mean_hmoil R_rog_0_GDPGSRE_Mpc_lnm_a if s0==1
corr n_dev_hmoil R_rog_0_GDPGSRE_Mpc_lnmdev_a if s0==1

* Compare deviations *
pwcorr n_dev_hmoil dev_hmoil R_rog_0_GDPGSRE_Mpc_lnmdev_a if s2==1,obs
twoway scatter n_dev_hmoil R_rog_0_GDPGSRE_Mpc_lnmdev_a if s2==1, scheme(lean2) ylab(,glcolor(gs15))

* Compare means *
pwcorr n_mean_hmoil mean_hmoil R_rog_0_GDPGSRE_Mpc_lnm_a if s2==1,obs
twoway scatter n_mean_hmoil R_rog_0_GDPGSRE_Mpc_lnm_a if s2==1, scheme(lean2) ylab(,glcolor(gs15))



******************************
*** Autocratic transitions ***
******************************
	gen beta_dev=.
	gen beta_mean=.
	gen hi_dev=.
	gen hi_mean=.
	gen lo_dev=.
	gen lo_mean=.
 
* WFG oil data, No LR interpolation, WFG sample *
logit ged_dict $cvar dev_hmoil mean_hmoil mean_dict if s1==1, cluster(cowcode)
	qui nlcom _b[dev_hmoil], post
	est store dict1
	matrix beta =e(b) 
	qui replace beta_dev = beta[1,1] if _n==1
	matrix se= e(V)
	qui replace hi_dev = beta[1,1] + (1.96*sqrt(se[1,1])) if _n==1
	qui replace lo_dev = beta[1,1] - (1.96*sqrt(se[1,1])) if _n==1
	qui logit ged_dict $cvar dev_hmoil  mean_hmoil mean_dict if s1==1, cluster(cowcode)
	qui nlcom _b[mean_hmoil], post
	matrix beta =e(b) 
	qui replace beta_mean = beta[1,1] if _n==1
	matrix se=e(V)
	qui replace hi_mean = beta[1,1] + (1.96*sqrt(se[1,1])) if _n==1
	qui replace lo_mean = beta[1,1] - (1.96*sqrt(se[1,1])) if _n==1
	tab ged_dict if s1==1

* WFG oil data, LR sample *
logit ged_dict $cvar n_dev_hmoil n_mean_hmoil mean_dict if s2==1, cluster(cowcode)
	qui nlcom _b[n_dev_hmoil], post
	est store dict2
	matrix beta =e(b) 
	qui replace beta_dev = beta[1,1] if _n==2
	matrix se= e(V)
	qui replace hi_dev = beta[1,1] + (1.96*sqrt(se[1,1])) if _n==2
	qui replace lo_dev = beta[1,1] - (1.96*sqrt(se[1,1])) if _n==2
	qui logit ged_dict $cvar n_dev_hmoil  n_mean_hmoil mean_dict if s2==1, cluster(cowcode)
	qui nlcom _b[n_mean_hmoil], post
	matrix beta =e(b) 
	qui replace beta_mean = beta[1,1] if _n==2
	matrix se=e(V)
	qui replace hi_mean = beta[1,1] + (1.96*sqrt(se[1,1])) if _n==2
	qui replace lo_mean = beta[1,1] - (1.96*sqrt(se[1,1])) if _n==2
	
* LR oil data, LR interpolation, LR sample *
logit ged_dict $cvar R_rog_0_GDPGSRE_Mpc_lnmdev_a R_rog_0_GDPGSRE_Mpc_lnm_a mean_dict if s2==1, cluster(cowcode)
	qui nlcom _b[R_rog_0_GDPGSRE_Mpc_lnmdev_a], post
	est store dict3
	matrix beta =e(b) 
	qui replace beta_dev = beta[1,1] if _n==3
	matrix se= e(V)
	qui replace hi_dev = beta[1,1] + (1.96*sqrt(se[1,1])) if _n==3
	qui replace lo_dev = beta[1,1] - (1.96*sqrt(se[1,1])) if _n==3
	qui logit ged_dict $cvar R_rog_0_GDPGSRE_Mpc_lnmdev_a R_rog_0_GDPGSRE_Mpc_lnm_a mean_dict if s2==1, cluster(cowcode)
	qui nlcom _b[R_rog_0_GDPGSRE_Mpc_lnm_a], post
	matrix beta =e(b) 
	qui replace beta_mean = beta[1,1] if _n==3
	matrix se=e(V)
	qui replace hi_mean = beta[1,1] + (1.96*sqrt(se[1,1])) if _n==3
	qui replace lo_mean = beta[1,1] - (1.96*sqrt(se[1,1])) if _n==3
	
	/*
	gen ld=ln(ged_time)
	 krls ged_dict $cvar R_rog_0_GDPGSRE_Mpc_lnmdev_a R_rog_0_GDPGSRE_Mpc_lnm_a mean_dict if s2==1, deriv
	 sort ld
	twoway scatter d_R_rog_0_GDPGSRE_Mpc_lnmdev_a  ld,mcolor(gs13)||lowess d_R_rog_0_GDPGSRE_Mpc_lnmdev_a /*
	*/ ld,color(blue)bw(.15) scheme(lean2) legend(off) ylab(,glcolor(gs15)) xtitle(Regime duration (log))/*
	*/ ytitle(Marginal effect of oil,height(-1)) yline(-.000994 ,lcolor(black)) yline(0,lcolor(red))
	ttest d_R_rog_0_GDPGSRE_Mpc_lnmdev_a, by(civilwar)
	*/
 
 * Plot estimates *
	gen n = _n
	gen rdev=round(beta_dev, 0.001)
	gen rmean=round(beta_mean, 0.001)
	twoway (scatter beta_dev n if _n<=3, title(Deviations) xtitle("") ytitle(Coefficient estimate, height(-5)) /*
	*/ xscale(range(0.75 3.25)) xlab(1 "HMrents" 2 "Nrents" 3 "LRrents") yline(0,lcolor(black)) mlab(rdev)) /*
	*/ (rspike hi_dev lo_dev n if _n<=3, scheme(lean2) ylab(-.8(.2).2,glcolor(gs15)) legend(lab(1 "estimate") /*
	*/ lab(2 "95 CI") pos(6) ring(1) col(2)) saving(h1,replace))
	twoway (scatter beta_mean n if _n<=3, title(Means) xtitle("") ytitle(Coefficient estimate, height(-5)) /*
	*/ xscale(range(0.75 3.25)) xlab(1 "HMrents" 2 "Nrents" 3 "LRrents") yline(0,lcolor(black)) mlab(rmean)) /*
	*/ (rspike hi_mean lo_mean n if _n<=3, scheme(lean2) yscale(range(-.8 .2)) ylab(-.8(.2).2,glcolor(gs15)) legend(lab(1 "estimate") /*
	*/ lab(2 "95 CI") pos(6) ring(1) col(2)) saving(h2,replace))
		
	graph combine h1.gph h2.gph, col(2) xsize(3)   ysize(1.4)  scheme(lean2) b1()
	graph export "C:\Users\jwright\Dropbox\Research\Oil and Authoritarian Stability\LucasRichter\Fig2.pdf", as(pdf) replace

	drop beta_* hi_* lo_* n rdev rmean

	sort year
	gen negdev= dev_hmoil<0
	listtex geddes_case year if ged_dict==1  & s2==0 & s1==1  using dict.tex, rs(tabular) replace
	tab negdev if ged_dict==1  & s2==0 & s1==1
	tab geddes_region if ged_dict==1  & s2==0 & s1==1
 
/*		Autocracy-Autocracy transitions dropped by change in sample: 2/3 (65%) have oil income BELOW the country-mean; 
		over 1/2 occur prior to 1973 oil shock; the majority are from South America, Central Africa, and Middle East

        Bolivia 46-51   1951   -1.580618  
          Egypt 22-52   1952   -1.687682  
        Bolivia 51-52   1952   -1.775107  
       Colombia 49-53   1953   -.0461817  
      Argentina 51-55   1955   -1.090029  
      Argentina 55-58   1958   -1.068891  
           Iraq 32-58   1958   -.7413011  
       Pakistan 47-58   1958   -.5281982  
           Cuba 52-59   1959   -1.297489  
         Turkey 57-60   1960    .0282072  
      Congo-Brz 60-63   1963   -2.653683  
           Iraq 58-63   1963   -.1872783  
        Bolivia 52-64   1964   -.5039504  
      Indonesia 49-66   1966   -.8802292  
      Argentina 58-66   1966   -.3229029  
      Congo-Brz 63-68   1968   -3.509695  
          Libya 51-69   1969     1.82058  
        Bolivia 69-71   1971   -.4858894  
     Afganistan 29-73   1973           0  
     Bangladesh 71-75   1975   -.0171457  
       Pakistan 75-77   1977   -.0816716  
    Afghanistan 73-78   1978           0  
           Iraq 68-79   1979    1.543822  
           Iran 25-79   1979     1.68196  
     Bangladesh 75-82   1982   -.0171457  
      Guatemala 70-85   1985    1.804235  
        Myanmar 62-88   1988    .1698394  
     Yugoslavia 45-90   1990    1.123126  
        Belarus 91-94   1994   -.1487746  
    Congo/Zaire 60-97   1997    .4730105  
     Kyrgyzstan 91-05   2005    .0376712  
*/
			
******************************
*** Democratic transitions ***
******************************
	gen beta_dev=.
	gen beta_mean=.
	gen hi_dev=.
	gen hi_mean=.
	gen lo_dev=.
	gen lo_mean=.
 
* HMrents, WFG sample *
logit ged_dem $cvar dev_hmoil mean_hmoil mean_dem if s1==1, cluster(cowcode)
	qui nlcom _b[dev_hmoil], post
	est store dict1
	matrix beta =e(b) 
	qui replace beta_dev = beta[1,1] if _n==1
	matrix se= e(V)
	qui replace hi_dev = beta[1,1] + (1.96*sqrt(se[1,1])) if _n==1
	qui replace lo_dev = beta[1,1] - (1.96*sqrt(se[1,1])) if _n==1
	qui logit ged_dem $cvar dev_hmoil  mean_hmoil mean_dem if s1==1, cluster(cowcode)
	qui nlcom _b[mean_hmoil], post
	matrix beta =e(b) 
	qui replace beta_mean = beta[1,1] if _n==1
	matrix se=e(V)
	qui replace hi_mean = beta[1,1] + (1.96*sqrt(se[1,1])) if _n==1
	qui replace lo_mean = beta[1,1] - (1.96*sqrt(se[1,1])) if _n==1
	
* Nrents, LR sample *
logit ged_dem $cvar n_dev_hmoil n_mean_hmoil mean_dem if s2==1, cluster(cowcode)
	qui nlcom _b[n_dev_hmoil], post
	est store dict2
	matrix beta =e(b) 
	qui replace beta_dev = beta[1,1] if _n==2
	matrix se= e(V)
	qui replace hi_dev = beta[1,1] + (1.96*sqrt(se[1,1])) if _n==2
	qui replace lo_dev = beta[1,1] - (1.96*sqrt(se[1,1])) if _n==2
	qui logit ged_dem $cvar n_dev_hmoil  n_mean_hmoil mean_dem if s2==1, cluster(cowcode)
	qui nlcom _b[n_mean_hmoil], post
	matrix beta =e(b) 
	qui replace beta_mean = beta[1,1] if _n==2
	matrix se=e(V)
	qui replace hi_mean = beta[1,1] + (1.96*sqrt(se[1,1])) if _n==2
	qui replace lo_mean = beta[1,1] - (1.96*sqrt(se[1,1])) if _n==2
	
* LRrents + 0s filled in, LR sample *
logit ged_dem $cvar R_rog_0_GDPGSRE_Mpc_lnmdev_a R_rog_0_GDPGSRE_Mpc_lnm_a mean_dem if s2==1, cluster(cowcode)
	qui nlcom _b[R_rog_0_GDPGSRE_Mpc_lnmdev_a], post
	est store dict4
	matrix beta =e(b) 
	qui replace beta_dev = beta[1,1] if _n==3
	matrix se= e(V)
	qui replace hi_dev = beta[1,1] + (1.96*sqrt(se[1,1])) if _n==3
	qui replace lo_dev = beta[1,1] - (1.96*sqrt(se[1,1])) if _n==3
	qui logit ged_dem $cvar R_rog_0_GDPGSRE_Mpc_lnmdev_a R_rog_0_GDPGSRE_Mpc_lnm_a mean_dem if s2==1, cluster(cowcode)
	qui nlcom _b[R_rog_0_GDPGSRE_Mpc_lnm_a], post
	matrix beta =e(b) 
	qui replace beta_mean = beta[1,1] if _n==3
	matrix se=e(V)
	qui replace hi_mean = beta[1,1] + (1.96*sqrt(se[1,1])) if _n==3
	qui replace lo_mean = beta[1,1] - (1.96*sqrt(se[1,1])) if _n==3
	
	/*
	qui: krls ged_dem $cvar R_rog_0_GDPGSRE_Mpc_lnmdev_a R_rog_0_GDPGSRE_Mpc_lnm_a mean_dem if s2==1, deriv
	*twoway scatter d_R_rog_0_GDPGSRE_Mpc_lnmdev_a lgdp,mcolor(gs13)||lowess d_R_rog_0_GDPGSRE_Mpc_lnmdev_a /*
	*/ lgdp,color(blue)bw(.15) scheme(lean2) legend(off) ylab(,glcolor(gs15)) xtitle(GDP per capita (log))/*
	*/ ytitle(Marginal effect of oil,height(-1)) yline(-.005058,lcolor(red))
	ttest d_R_rog_0_GDPGSRE_Mpc_lnmdev_a, by(civilwar)
	*/
	
 * Plot estimates *
	gen n = _n
	gen rdev=round(beta_dev, 0.001)
	gen rmean=round(beta_mean, 0.001)
	twoway (scatter beta_dev n if _n<=3, title(Deviations) xtitle("") ytitle(Coefficient estimate, height(-5)) /*
	*/ xscale(range(0.75 3.25)) xlab(1 "HMrents" 2 "Nrents" 3 "LRrents") yline(0,lcolor(black)) mlab(rdev)) /*
	*/ (rspike hi_dev lo_dev n if _n<=3, scheme(lean2) ylab(-1(.2).6,glcolor(gs15)) legend(lab(1 "estimate") /*
	*/ lab(2 "95 CI") pos(6) ring(1) col(2)) saving(h1,replace))
	twoway (scatter beta_mean n if _n<=3, yscale(range(-1 .6)) ylab(-1(.2).6,glcolor(gs15)) title(Means) xtitle("") ytitle(Coefficient estimate, height(1)) /*
	*/ xscale(range(0.75 3.25)) xlab(1 "HMrents" 2 "Nrents" 3 "LRrents") yline(0,lcolor(black)) mlab(rmean)) /*
	*/ (rspike hi_mean lo_mean n if _n<=3, scheme(lean2)  legend(lab(1 "estimate") /*
	*/ lab(2 "95 CI") pos(6) ring(1) col(2))  saving(h2,replace))
		
	graph combine h1.gph h2.gph, col(2) xsize(3) ysize(1.4) scheme(lean2)  
	graph export "C:\Users\jwright\Dropbox\Research\Oil and Authoritarian Stability\LucasRichter\Fig3.pdf", as(pdf) replace

	drop beta_* hi_* lo_* n rdev rmean

 	sort year
	listtex geddes_case year if ged_dem==1  & s2==0 & s1==1  using dem.tex, rs(tabular) replace
	tab negdev if ged_dem==1  & s2==0 & s1==1
	tab geddes_region if ged_dem==1  & s2==0 & s1==1


/*		39 democratic transitions dropped by change in sample: 59% have oil income ABOVE the country-mean; 72% during the Big
		Oil Change era; 29 of 39 occur during or after 1973 oil shock; the majority are from South America and Central/Eastern Europe.

           Ecuador 44-47   1947   -1.198367  
            Turkey 23-50   1950   -.8083522  
              Peru 48-56   1956   -.3975594  
          Colombia 53-58   1958     .007458  
         Venezuela 48-58   1958    .1891131  
           Myanmar 58-60   1960   -.4254036  
            Turkey 60-61   1961   -.0518355  
              Peru 62-63   1963   -.4952517  
           Ecuador 63-66   1966   -1.546829  
          Pakistan 58-71   1971   -.5899462  
         Argentina 66-73   1973    .0836225  
          Thailand 57-73   1973   -.3466797  
             Spain 39-76   1976    2.537554  
           Bolivia 80-82   1982    1.875405  
         Argentina 76-83   1983    1.775219  
            Turkey 80-83   1983     2.48367  
            Brazil 64-85   1985     1.39107  
       Philippines 72-86   1986    .8475993  
          Pakistan 77-88   1988     .735624  
             Chile 73-89   1989   -.8117461  
           Romania 45-89   1989    .0241489  
            Poland 44-89   1989   -.2682177  
    Czechoslovakia 48-89   1989    .1466881  
        Bangladesh 82-90   1990     .069032  
             Benin 72-90   1990    1.656728  
          Bulgaria 44-90   1990   -.1050719  
           Hungary 47-90   1990    .6733813  
           Albania 44-91   1991    .8196201  
      Soviet Union 17-91   1991    .9453707  
         Guatemala 85-95   1995     1.11784  
           Nigeria 93-99   1999   -.3951344  
            Mexico 15-00   2000    .8041401  
             Ghana 81-00   2000    .7672728  
              Peru 92-00   2000    -.204392  
            Taiwan 49-00   2000   -.3572869  
           Senegal 60-00   2000    .0095151  
           Georgia 92-03   2003   -.0868238  
        Mauritania 05-07   2007    5.392722  
          Thailand 06-07   2007    3.255541  
  
*/

 
***************************************************************************************************************************
*************************************************************************************************************************
/*
forval i=1(1)8{
	use oilimp`i', clear
	local var = "R_rog_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln n_hm_oil n_hm0_oil"
	foreach v of local var {
		egen m_`v' = mean(`v'), by(cow)
		gen d_`v' = `v'-m_`v'
	}
	sort cow year
	save, replace
}

		use oil_ave_imp, clear
		local var = "R_rog_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln n_hm_oil n_hm0_oil"
		foreach v of local var {
			egen m_`v' = mean(`v'), by(cow)
			gen d_`v' = `v'-m_`v'
		}	
*/
 use oil_ave_imp, clear
 pwcorr R_rog_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln n_hm_oil n_hm0_oil hm_oil
 corrtex R_rog_0_GDPGSRE_Mpc_ln   n_hm0_oil hm_oil, file(corr) replace

* Democratic transition, LR data *
clear
miest oilimp logit ged_dem d_R_rog_0_GDPGSRE_Mpc_ln m_R_rog_0_GDPGSRE_Mpc_ln  $cvar  mean_dem , cluster(cowcode)
matrix results = J(2,3,.) 
mat rownames results = devLR meanLR  
mat colnames results = beta lo hi
local b1 =_mib[1,1]
local vce1 = _miVCE[1,1]
mat results[1,1]= `b1'
mat results[1,2]=  `b1'-(1.96*sqrt(`vce1'))
mat results[1,3]=  `b1'+(1.96*sqrt(`vce1'))
local b2 =_mib[2,1]
local vce2 = _miVCE[2,2]
mat results[2,1]= `b2'
mat results[2,2]=  `b2'-(1.96*sqrt(`vce2'))
mat results[2,3]=  `b2'+(1.96*sqrt(`vce2'))
mat list results
svmat results, names(demLR)
gen n = _n
sort n
save res1, replace

* Democratic transition, HM data *
clear
miest oilimp logit ged_dem d_n_hm0_oil m_n_hm0_oil $cvar  mean_dem , cluster(cowcode)
matrix results = J(2,3,.) 
mat rownames results = devHM meanHM  
mat colnames results = beta lo hi
local b1 =_mib[1,1]
local vce1 = _miVCE[1,1]
mat results[1,1]= `b1'
mat results[1,2]=  `b1'-(1.96*sqrt(`vce1'))
mat results[1,3]=  `b1'+(1.96*sqrt(`vce1'))
local b2 =_mib[2,1]
local vce2 = _miVCE[2,2]
mat results[2,1]= `b2'
mat results[2,2]=  `b2'-(1.96*sqrt(`vce2'))
mat results[2,3]=  `b2'+(1.96*sqrt(`vce2'))
mat list results
svmat results, names(demHM)
gen n = _n
sort n
save res2, replace

* Autocratic transition, LR data *
clear
miest oilimp logit ged_dict d_R_rog_0_GDPGSRE_Mpc_ln m_R_rog_0_GDPGSRE_Mpc_ln $cvar mean_dict, cluster(cowcode)
matrix results = J(2,3,.) 
mat rownames results = devLR meanLR  
mat colnames results = beta lo hi
local b1 =_mib[1,1]
local vce1 = _miVCE[1,1]
mat results[1,1]= `b1'
mat results[1,2]=  `b1'-(1.96*sqrt(`vce1'))
mat results[1,3]=  `b1'+(1.96*sqrt(`vce1'))
local b2 =_mib[2,1]
local vce2 = _miVCE[2,2]
mat results[2,1]= `b2'
mat results[2,2]=  `b2'-(1.96*sqrt(`vce2'))
mat results[2,3]=  `b2'+(1.96*sqrt(`vce2'))
mat list results
svmat results, names(dictLR)
gen n = _n
sort n
save res3, replace

* Autocratic transition, HM data *
clear
miest oilimp logit ged_dict d_n_hm0_oil m_n_hm0_oil $cvar mean_dict, cluster(cowcode)
matrix results = J(2,3,.) 
mat rownames results = devHM meanHM  
mat colnames results = beta lo hi
local b1 =_mib[1,1]
local vce1 = _miVCE[1,1]
mat results[1,1]= `b1'
mat results[1,2]=  `b1'-(1.96*sqrt(`vce1'))
mat results[1,3]=  `b1'+(1.96*sqrt(`vce1'))
local b2 =_mib[2,1]
local vce2 = _miVCE[2,2]
mat results[2,1]= `b2'
mat results[2,2]=  `b2'-(1.96*sqrt(`vce2'))
mat results[2,3]=  `b2'+(1.96*sqrt(`vce2'))
mat list results
svmat results, names(dictHM)
gen n = _n
sort n
save res4, replace
sort n
merge n using res3
drop _merge
sort n
merge n using res2
drop _merge
sort n
merge n using res1
drop _merge
save results, replace
forval i = 1/4 {
	erase res`i'.dta
}
use results, clear
stack  dictHM1 dictLR1 demHM1 demLR1, into(beta)  clear
sort _stack
save beta, replace

use results, clear
stack  dictHM2 dictLR2 demHM2 demLR2, into(lo)  clear
sort _stack
save lo, replace

use results, clear
stack  dictHM3 dictLR3 demHM3 demLR3, into(hi)  clear
sort _stack
save hi, replace

merge _stack using lo
drop _merge
sort _stack
merge _stack using beta
drop _merge
sort _stack
save results, replace
erase beta.dta
erase lo.dta
erase hi.dta
gen dev =_n==1|_n==3|_n==5|_n==7
gen lr = _stack==2 | _stack==4
gen dem = _stack==3 | _stack==4
gen n=_n
replace n=n-4 if n>4
 twoway (scatter beta n if dem==1) (rspike lo hi n if dem==1, yline(0) scheme(lean2)/*
 */ xlab(1 `" "N rents"  "deviation" "' 2 `" "N rents"  "mean" "' 3 `" "LR rents"  "deviation" "' /*
 */ 4 `" "LR rents"  "mean" "') xscale(range(.8 4.2))  ylab(-.8(.2).4,glcolor(gs15)) /*
 */ xtitle("") legend(lab(1 "estimate")  lab(2 "95 CI") pos(6) ring(1) col(2)) title(Democratic transition))
 	graph export "C:\Users\jwright\Dropbox\Research\Oil and Authoritarian Stability\LucasRichter\Fig4.pdf", as(pdf) replace

  twoway (scatter beta n if dem==0) (rspike lo hi n if dem==0, yline(0) scheme(lean2)/*
 */ xlab(1 `" "N rents"  "deviation" "' 2 `" "N rents"  "mean" "' 3 `" "LR rents"  "deviation" "' /*
 */ 4 `" "LR rents"  "mean" "') xscale(range(.8 4.2))  ylab(-.8(.2).2,glcolor(gs15)) /*
 */ xtitle("") legend(lab(1 "estimate")  lab(2 "95 CI") pos(6) ring(1) col(2)) title(Autocratic transition))
  	graph export "C:\Users\jwright\Dropbox\Research\Oil and Authoritarian Stability\LucasRichter\Fig5.pdf", as(pdf) replace

log close
