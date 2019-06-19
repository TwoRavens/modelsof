*This program takes data on year to year growth rates and computes a variance covariance matrix across sectors
*In original form I am not controlling for the nunmber of observations used to build the correlation
*I should control for it. I need a minimum criteria.

set mem 300m
*pause on
use c:\research\data\industry\growth_rates_unido_3d_2005

*The sample would go back three years to 1977 to get DFA, DNK, and BGD. For the rest, the cutoff point would be 1980

keep if (year>=1977 & wbcode=="DNK") | (year>=1978 & wbcode=="BGD") | (year>=1979 & wbcode=="DFA") | year>=1980

pause

*keep if year>=1980

keep wbcode isic year HPvareal nestab
drop if isic==300

*Initial filtering

egen nobs = count(HPvareal), by(wbcode isic)
pause

drop if nobs<15 /*I need at least 15 observations to compute the variance covariance matrix with 28 sectors*/

egen tmp1 = min(year) if HPvareal~=., by(wbcode isic)
gen tmp2 = HPvareal if year==tmp1
egen nsect = count(tmp2), by(wbcode)

*Marking the first year for each country
egen tmp3 = min(year) if HPvareal~=., by(wbcode)
egen minyear = min(tmp3), by(wbcode)

*Keep only those countries with at least 10 sectors

keep if nsect>=10
drop tmp*
*pause
*fillin wbcode isic year
*drop _fillin

*egen nsect=group(isic)
*local i=1
*qui sum nsect
*local I=r(max)

levels isic , local(industries)

foreach i of local industries {
    qui {
    gen  tmp1 = HPvareal if isic==`i'
    egen tmp2 = min(tmp1), by(wbcode year)
    egen tmp3 = mean(HPvareal), by(wbcode isic)     /*taking the mean of each sector*/
    egen tmp4 = mean(tmp2), by(wbcode isic)    /*taking the mean of sector i */
    egen sd1  = sd(tmp2), by(wbcode isic)        /*Computing standard deviation of sector i*/
    egen n1   = count(tmp2), by(wbcode isic)      /*Counting observations of sector i */
    replace sd1=sd1*sqrt((n1-1)/n1)              /*unbiased estimator of standard deviation of i*/
    egen sd2=sd(HPvareal), by(wbcode isic)         /*Standard deviation of each sector*/
    egen n2=count(HPvareal), by(wbcode isic)       /*Counting observations of each sector*/
    replace sd2=sd2*sqrt((n2-1)/n2)              /*Unbiased estimator*/
    gen tmp5=HPvareal-tmp3                         /*demean each sectors' growth*/
    gen tmp6= tmp2-tmp4                        /*demean sector i*/
    gen tmp7=tmp5*tmp6                        /*Multiply demeaned growth rates*/
    egen tmp8=sum(tmp7), by(wbcode isic)     /*Sum the product of demeaned: sum{(x_i-\bar{x_i})(x_j-\bar{x_j})}*/
    egen tmp9=count(tmp7), by(wbcode isic)   /*Count the number of non-missing products*/
    qui gen corrHPva`i'=(tmp8/tmp9)/(sd1*sd2)        /*Computing correlation*/
    qui gen covHPva`i' =(tmp8/tmp9)
    pause
    drop tmp* sd1 sd2 n1 n2
}
}

/*Now averaging across country-industries*/

collapse HPvareal corrHPva* covHPva* minyear nestab (count) nHPva=HPvareal (sd) sdHPva = HPvareal, by(wbcode isic)

save correlationsHPvareal.dta, replace
