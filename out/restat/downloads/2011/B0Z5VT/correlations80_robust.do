*This program takes data on year to year growth rates and computes a variance covariance matrix across sectors
*In original form I am not controlling for the nunmber of observations used to build the correlation
*I should control for it. I need a minimum criteria.

set mem 300m
pause off
*use c:\research\data\industry\growth_rates_unido_3d_2005
use z:\data\industry\growth_rates_unido_3d_2005

*The sample would go back three years to 1977 to get DFA, DNK, and BGD. For the rest, the cutoff point would be 1980

keep if (year>=1977 & wbcode=="DNK") | (year>=1978 & wbcode=="BGD") | (year>=1979 & wbcode=="DFA") | year>=1980

pause

*keep if year>=1980

keep wbcode isic year gth_vareal share nestab
drop if isic==300

*Initial filtering

egen nobs = count(gth_vareal), by(wbcode isic)
pause

drop if nobs<15 /*I need at least 15 observations to compute the variance covariance matrix with 28 sectors*/

egen tmp1 = min(year) if gth_vareal~=., by(wbcode isic)
gen tmp2 = gth_vareal if year==tmp1
egen nsect = count(tmp2), by(wbcode)

*Marking the first year for each country
egen tmp3 = min(year) if gth_vareal~=., by(wbcode)
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
levelsof wbcode, local(countries)

foreach i of local industries {
    di "`i'"
*    qui {
    gen  tmp1 = gth_vareal if isic==`i'
    egen tmp2 = min(tmp1), by(wbcode year)
    gen corr`i'_rob = .
    foreach j of local industries {
        *di "`j'"
        foreach c of local countries {
            *di "`c'"
            capture rreg gth_vareal tmp2 if isic==`j' & wbcode=="`c'", g(W)
            if _rc==0 {
      *          di "here"
                qui corr gth_vareal tmp2 if isic==`j' & wbcode=="`c'" [aw=W]
                qui replace corr`i'_rob = r(rho) if isic==`j' & wbcode=="`c'"
            }
            else if _rc~=0 {
                if `i'==`j' qui replace corr`i'_rob=1 if isic==`j' & wbcode=="`c'"
            }
     *       pause
            capture drop W
        }
    *pause
    }
*}
*pause
qui drop tmp1 tmp2
}

/*Now averaging across country-industries*/

collapse corr*, by(wbcode isic)

save correlations_robust, replace
