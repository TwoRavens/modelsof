drop _all
clear all
set more 1
set memory 10g
capture log close

   
cd "C:\Main\p-cycle\Writing\ReStatRevision\BootStrapSE"
set logtype text
log using NonParBoot3a, replace

/* Lowess with Fixed Effects, Bootstrap SE, Using codes from di Giovanni and Levchenko */
/* generate Figure 3a*/

/**************************************************************************
    Step 1. Bootstrap program
**************************************************************************/

/*
Variables passed to the program are:

    `1': y variable
    `2': x variable
    `3': final name to be saved
*/

capture program drop lowboot
program define lowboot
    set seed 20
    keep `1' `2'
    save temp_30yr, replace

    local i = 1
    quietly while `i'<=1000{
        drop _all
        use temp_30yr
        bsample _N
        ge xgrid = `2'
        sort `2'
        quietly lowess ddlog t, bw(0.6) gen(smth)
        ge rep = `i'
        append using `3'
        save `3', replace
        disp `i'
        local i = `i'+1
     }

    * Generate standard errors

        egen sdsmth = sd(smth), by(`2')
        keep if rep == 0
        sort rep
        save sdtemp_30yr,replace

    use `3',clear

    keep if rep==0
    sort rep
    merge rep using sdtemp_30yr
    tab _m
    drop _m rep

    ge smth_p2sd = smth + 2*sdsmth
    ge smth_m2sd = smth - 2*sdsmth

    save `3',replace

    erase sdtemp_30yr.dta
    erase temp_30yr.dta
end


/**************************************************************************
   step 2 Load Data and Set parameters
**************************************************************************/


use "C:\Main\p-cycle\IndustryResults\NS2\NS2.dta"


sort msic87
egen x=sum(fobSng), by(msic87) 
egen y=sum(fobNng), by(msic87)
drop if x==0 & y==0
drop x y
drop if year<=77
gen dd=(fobSng/fobSog)/(fobNng/fobNog) 
gen ddlog=log(dd)
gen vt=fobSng+fobSog+fobNng+fobNog 
by msic87, sort: egen vtbar=mean(vt) 
gen t=year-77 
encode msic87, gen (ind) 
egen time=group(t)
d

gen t2=t*t
areg ddlog t t2 [aweight=vtbar], absorb(ind) 
predict ddloghat
sort year 
collapse (mean) ddlog ddloghat [aweight=vtbar], by(year)
gen t=year-77
gen rep=0

/**************************************************************************
   step 3 Regression for ddlog on t
**************************************************************************/

quietly lowess ddlog t, bw(0.6) gen(smth)
save NonParBoot3a, replace

lowboot ddlog t NonParBoot3a


/**************************************************************************
   step 4 Graphs
**************************************************************************/

#delimit;
replace year=year+1900;
twoway (scatter ddlog year) (connected ddloghat year, lpattern(dot) msymbol(none)) 
    (line smth smth_p2sd smth_m2sd year,lpattern(l - -) lcolor(black black black)
    legend(off) xtitle(year) ytitle(Relative Exp. Ratio)
    saving(Figure3a, replace));
log close;
