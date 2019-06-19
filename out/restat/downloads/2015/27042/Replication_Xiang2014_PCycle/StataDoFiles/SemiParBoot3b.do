drop _all
clear all
set more 1
set memory 10g
set matsize 5000
capture log close

   
cd "C:\Main\p-cycle\Writing\ReStatRevision\BootStrapSE"
set logtype text
log using SemiParBoot3b, replace

/* SemiPar with Fixed Effects, Using codes from di Giovanni and Levchenko semiparametric_regs_mfg5yr_mca_fe.do
main y = ddlog, main x = t, Controls = ddlogtao and industry dummies. standard errors are bootstrapped
produces Figure 3b. Builds on earlier work that produces the residual*/



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


use "C:\Main\p-cycle\Writing\ReStatRevision\NonPar\SemiPar.dta" /*residual data stored here*/
sort year 
collapse (mean) ddlog_net [aweight=vtbar], by(year)
gen t=year-77
gen rep=0

/**************************************************************************
   step 5 Regression for ddlog_net, bootstrap standard errors
**************************************************************************/


quietly lowess ddlog_net t, bw(0.6) gen(smth)
save SemiParBoot3b, replace

lowboot ddlog_net t SemiParBoot3b

save SemiParBoot3b, replace


/**************************************************************************
   step 5 Graphs
**************************************************************************/

#delimit;
replace year=year+1900;
twoway (scatter ddlog_net year)
    (line smth smth_p2sd smth_m2sd year,lpattern(l - -) lcolor(black black black)
    legend(off) xtitle(year) ytitle(Rel. Exp. Ratio Net of Controls)
    saving(Figure3b, replace));
log close;

