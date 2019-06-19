// cex_tables_figures.do

version 10

//use sample constructed cex_sample
clear
clear matrix
set mem 500m
use cex_sample
set more off

//should be 27,219 total, with 2,508 entrepreneurs
tab entre

/*******************************************
 * TABLES FROM PAPER
 ******************************************/

 //table 1
tabstat loglaborbus [aw=adjwt], s(mean median) by(entre)
tabstat logtotalinc [aw=adjwt], s(mean median) by (entre)
tabstat logtotalincextax [aw=adjwt], s(mean median) by (entre)
tabstat logfood [aw=adjwt], s(mean median) by(entre)
tabstat lognondur [aw=adjwt], s(mean median) by(entre)
tabstat logtotal [aw=adjwt], s(mean median) by(entre)

tabstat age ed_cat2 ed_cat3 ed_cat4 ed_cat5 black married hhsize hours ///
    [aw=adjwt], by (entr)

// home ownership rates
gen ownhome = cutenur >= 1 & cutenur <= 3
tabstat ownhome [aw=adjwt], s(mean) by (entre)

//table 2: OLS and IV estimates of beta and gamma for alternative
//expenditure categories
cap erase cex_table2.txt
ren logtotalincextax logtotdisinc
foreach y in logtotalinc loglaborbus logtotdisinc {
    foreach c in lognondur logtotal logfood {
        //ols
        reg `c' entre `y' age???? black married hhsize_cat* year_cat* ///
            [pw=adjwt], robust
        est sto ols_`y'_`c'
        outreg2 `y' entre using cex_table2, cttop(OLS)
        //insturment income with education
        ivreg2 `c' entre (`y' = ed_cat*) age???? black married hhsize_cat* ///
            year_cat* [pw=adjwt], robust
        est sto iv_`y'_`c'
        outreg2 `y' entre using cex_table2, cttop(2SLS)
        }
    }
ren logtotdisinc logtotalincextax

//table 3: estimated percent of income underreported (1-kappa) 
//compute the underreporting estimates and standard errors
foreach e in iv_logtotalinc_lognondur iv_logtotalinc_logtotal iv_logtotalinc_logfood {
    qui estimates restore `e'
    disp "`e'"
    nlcom 1-exp(-_b[entre]/_b[logtotalinc])
    }
foreach e in iv_loglaborbus_lognondur iv_loglaborbus_logtotal iv_loglaborbus_logfood {
    qui estimates restore `e'
    disp "`e'"
    nlcom 1-exp(-_b[entre]/_b[loglaborbus])
    }
foreach e in iv_logtotdisinc_lognondur iv_logtotdisinc_logtotal iv_logtotdisinc_logfood {
    qui estimates restore `e'
    disp "`e'"
    nlcom 1-exp(-_b[entre]/_b[logtotdisinc])
    }

//table 4: robustness of 1-kappa estimate to alternative specifications
capture drop loghours
gen loghours = log(hours)
//use log work hours w/ total income measure
foreach e in logfood lognondur logtotal {
    qui ivreg2 `e' entre (logtotalinc = ed_cat*) age???? black married ///
        hhsize_cat* year_cat* loghours [pw=adjwt], robust
    disp "`e'"
    nlcom 1-exp(-_b[entre]/_b[logtotalinc])
    }
//use log hours as a control w/ loglaborbus
foreach e in logfood lognondur logtotal {
    qui ivreg2 `e' entre (loglaborbus = ed_cat*) age???? black married ///
        hhsize_cat* year_cat* loghours [pw=adjwt], robust
    disp "`e'"
    nlcom 1-exp(-_b[entre]/_b[loglaborbus])
    }
//use log hours as a control w/ disposable income
foreach e in logfood lognondur logtotal {
    qui ivreg2 `e' entre (logtotalincextax = ed_cat*) age???? black married ///
        hhsize_cat* year_cat* loghours [pw=adjwt], robust
    disp "`e'"
    nlcom 1-exp(-_b[entre]/_b[logtotalincextax])
    }
//restrict sample to young households 
foreach e in logfood lognondur logtotal {
    qui ivreg2 `e' entre (logtotalincextax = ed_cat*) age???? black married ///
        hhsize_cat* year_cat* [pw=adjwt] if age < 40, robust
    disp "`e'"
    nlcom 1-exp(-_b[entre]/_b[logtotalincextax])
    }
//restrict sample to older households
foreach e in logfood lognondur logtotal {
    qui ivreg2 `e' entre (logtotalincextax = ed_cat*) age???? black married ///
        hhsize_cat* year_cat* [pw=adjwt] if age >= 40, robust
    disp "`e'"
    nlcom 1-exp(-_b[entre]/_b[logtotalincextax])
    }
//restrict sample to early years
foreach e in logfood lognondur logtotal {
    qui ivreg2 `e' entre (logtotalinc = ed_cat*) age???? black married ///
        hhsize_cat* year_cat* [pw=adjwt] if year >= 1980 & year <= 1991, robust
    disp "`e'"
    nlcom 1-exp(-_b[entre]/_b[logtotalinc])
    }
//restrict sample to later years
foreach e in logfood lognondur logtotal {
    qui ivreg2 `e' entre (logtotalinc = ed_cat*) age???? black married ///
        hhsize_cat* year_cat* [pw=adjwt] if year >= 1992 & year <= 2003, robust
    disp "`e'"
    nlcom 1-exp(-_b[entre]/_b[logtotalinc])
    }


/*********************************
 * OTHER ROBUSTNES CHECKS
 ********************************/
// use utility expenditures
cap drop logutil
gen logutil = ln(utility)
foreach y in loglaborbus logtotalinc logtotalincextax {
	ivreg2 logutil entre (`y' = ed_cat*) year_cat* age???? black married
	nlcom 1-exp(-_b[entre]/_b[`y'])
}

// use transportation expenditures
cap drop logtrans
gen logtrans = log(transport)
foreach y in loglaborbus logtotalinc logtotalincextax {
	ivreg2 logtrans entre (`y' = ed_cat*) year_cat* age???? black married
	nlcom 1-exp(-_b[entre]/_b[`y'])
}
 
// business wealth > 0
cap drop entre_wealth
gen entre_wealth = investb * (entre > 0)

ren logtotalincextax logtotdisinc
foreach y in logtotalinc logtotdisinc {
    foreach c in lognondur logtotal logfood {
        //insturment income with education
        ivreg2 `c' entre entre_wealth (`y' = ed_cat*) age???? black married hhsize_cat* ///
            year_cat* [pw=adjwt], robust
        est sto iv_`y'_`c'
        }
    }
ren logtotdisinc logtotalincextax

foreach e in iv_logtotalinc_lognondur iv_logtotalinc_logtotal iv_logtotalinc_logfood {
    qui estimates restore `e'
    disp "`e'"
    nlcom 1-exp(-_b[entre]/_b[logtotalinc])
    }
 foreach e in iv_logtotdisinc_lognondur iv_logtotdisinc_logtotal iv_logtotdisinc_logfood {
    qui estimates restore `e'
    disp "`e'"
    nlcom 1-exp(-_b[entre]/_b[logtotdisinc])
    }

log close


/*****************************************************
 * LIFECYCLE ESTIMATES FROM SECTION 6C
 ****************************************************/
 if 0 { 
clear
set mem 500m
//*****remember to modify so that 65 year olds are included****
use cex_sample_65

//self employment rate by age
tabstat entre [aw=adjwt], by (age)

tabstat laborbus [aw=adjwt], by (age)

replace laborbus = 1.25 * laborbus if entre == 1
tabstat laborbus [aw=adjwt], by (age)
}
