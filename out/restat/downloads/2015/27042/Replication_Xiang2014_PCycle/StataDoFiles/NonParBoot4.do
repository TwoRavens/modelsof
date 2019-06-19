drop _all
clear all
set more 1
set memory 10g
capture log close

   
cd "C:\Main\p-cycle\Writing\ReStatRevision\BootStrapSE"
set logtype text
log using NonParBoot4, replace

/* Lowess with Fixed Effects, Bootstrap SE, Using codes from di Giovanni and Levchenko */
/* generate Figure 4*/

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
        quietly lowess `1' `2', bw(0.6) gen(smth)
        ge rep = `i'
        append using `3'
        save `3', replace
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

use "C:\Main\p-cycle\Writing\ReStatRevision\NonPar\NonParBoot3a.dta"
sort msic87
collapse (mean) vtbar, by(msic87)
sort msic87
save c1, replace


use "C:\Main\p-cycle\Writing\ReStatRevision\ZhuStuff\YearFu.dta"
sort msic87
merge msic87 using c1 /* using exactly the same weight as in Figure 4*/
tab _merge
drop _merge
egen x=sum(fobSng), by(msic87) 
egen y=sum(fobNng), by(msic87)
drop if x==0 & y==0
drop x y
drop if year<=77
gen dd=(fobSng/fobSog)/(fobNng/fobNog) 
gen ddlog=log(dd)
gen ddf=(fobSngf/fobSogf)/(fobNngf/fobNogf)
gen ddlogf=log(ddf)
sort year 
collapse (mean) ddlog ddlogf [aweight=vtbar], by(year)
gen t=year-77
gen rep=0

/**************************************************************************
   step 3 Regression for ddlog, matching-based n.g., on t
**************************************************************************/

quietly lowess ddlog t, bw(0.6) gen(smth)
save NonParBoot4, replace

lowboot ddlog t NonParBoot4
rename smth smth_ddlog
rename smth_p2sd smth_p2sd_ddlog
rename smth_m2sd smth_m2sd_ddlog
drop sdsmth

gen rep=0
save NonParBoot4, replace

/**************************************************************************
   step 4 Regression for ddlogf, prod-codes based n.g., on t
**************************************************************************/


quietly lowess ddlogf t, bw(0.6) gen(smth)
save NonParBoot4, replace

lowboot ddlogf t NonParBoot4
rename smth smth_ddlogf
rename smth_p2sd smth_p2sd_ddlogf
rename smth_m2sd smth_m2sd_ddlogf
drop sdsmth

save NonParBoot4, replace


/**************************************************************************
   step 5 Graphs
**************************************************************************/

#delimit;
replace year=year+1900;
label var ddlog "Ave. Rel. Exp. Ratio"; label var ddlogf "Ave. Rel. Exp. Ratio, Prod. Codes";
label var smth_ddlog "Non-Par. Fit and Bounds"; label var smth_ddlogf "Non-Par. Fit and Bounds, Prod. Codes";
label var smth_p2sd_ddlog ""; label var smth_m2sd_ddlog ""; label var smth_p2sd_ddlogf ""; label var smth_m2sd_ddlogf "";
twoway (scatter ddlog year, msymbol(O)) (scatter ddlogf year, msymbol(X))  
    (line smth_ddlog smth_p2sd_ddlog smth_m2sd_ddlog year,lpattern(l l l) lcolor(black black black))
    (line smth_ddlogf smth_p2sd_ddlogf smth_m2sd_ddlogf year,lpattern(dot dot dot) lcolor(black black black)
    xtitle(year)
    saving(Figure4, replace));
log close;

