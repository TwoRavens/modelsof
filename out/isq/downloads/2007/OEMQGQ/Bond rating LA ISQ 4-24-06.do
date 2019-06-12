
* bond ratings in LA
* constant debt 1995 calc using lagged nasa


use "C:\Documents and Settings\Administrator\My Documents\Biglaiser\bond data la econ reform - use this 4-22-06.dta", clear
*Moody's

drop if moody<1
drop if moody==.

gen debtgdpcon=nasa1995l*external_debt_gdp__l_ 

*gen budbalcon=nasa1995l* budget_balance__l_

tsset country1 year1, yearly

*wooldridge test

*xtserial rating election__l_ honeymoon__l_ ideology__l_ imf com__l_ fri__l_ pri__l_ tax__l_ cali__l_ polity_lagged_ ///
cpi_lagged_ ///
current_account_balance____of_gd debtgdpcon gdp_growth__annual_____lagged_ gdp_per_capita__constant_1995_us  ///
new_bond_default_5yearslagged_  


*hausman test

*xtregar rating election__l_ honeymoon__l_ ideology__l_ imf com__l_ fri__l_ pri__l_ tax__l_ cali__l_ polity_lagged_ ///
cpi_lagged_ ///
current_account_balance____of_gd debtgdpcon gdp_growth__annual_____lagged_ gdp_per_capita__constant_1995_us  ///
new_bond_default_5yearslagged_  

*est store re

*xtregar rating election__l_ honeymoon__l_ ideology__l_ imf com__l_ fri__l_ pri__l_ tax__l_ cali__l_ polity_lagged_ ///
cpi_lagged_ ///
current_account_balance____of_gd debtgdpcon gdp_growth__annual_____lagged_ gdp_per_capita__constant_1995_us  ///
new_bond_default_5yearslagged_  , fe

*hausman . re

xtpcse rating election__l_ honeymoon__l_ ideology__l_ imf com__l_ fri__l_ pri__l_ tax__l_ cali__l_ polity_lagged_ ///
cpi_lagged_ ///
current_account_balance____of_gd debtgdpcon gdp_growth__annual_____lagged_ gdp_per_capita__constant_1995_us  ///
new_bond_default_5yearslagged_  ,corr(ar1) pairwise

sum rating election__l_ honeymoon__l_ ideology__l_ imf com__l_ fri__l_ pri__l_ tax__l_ cali__l_ ///
polity_lagged_ cpi_lagged_ current_account_balance____of_gd debtgdpcon gdp_growth__annual_____lagged_ ///
gdp_per_capita__constant_1995_us  new_bond_default_5yearslagged_ 

*corr rating election__l_ honeymoon__l_ ideology__l_ imf com__l_ fri__l_ pri__l_ tax__l_ cali__l_ ///
polity_lagged_ cpi_lagged_ current_account_balance____of_gd debtgdpcon gdp_growth__annual_____lagged_ ///
gdp_per_capita__constant_1995_us  new_bond_default_5yearslagged_  budbalcon

mfx compute


*best
mfx compute, at(com__l_=.975  cpi_lagged_=63.1   gdp_per_capita__constant_1995_us=6580.89  ///
new_bond_default_5yearslagged_=0 debtgdpcon=.577 )

*worst
mfx compute, at(com__l_=.901  cpi_lagged_=239.88 gdp_per_capita__constant_1995_us=1562.6  ///
new_bond_default_5yearslagged_=1 debtgdpcon=.236 )

*
use "C:\Documents and Settings\Administrator\My Documents\Biglaiser\bond data la econ reform - use this 4-22-06.dta", clear

**********SP's

drop if s_p<1
drop if s_p==.

gen debtgdpcon=nasa1995l*external_debt_gdp__l_

*gen budbalcon=nasa1995l* budget_balance__l_

tsset country1 year1, yearly

*wooldridge test

*xtserial rating election__l_ honeymoon__l_ ideology__l_ imf com__l_ fri__l_ pri__l_ tax__l_ cali__l_ polity_lagged_ ///
cpi_lagged_ ///
current_account_balance____of_gd debtgdpcon gdp_growth__annual_____lagged_ gdp_per_capita__constant_1995_us  ///
new_bond_default_5yearslagged_  


*hausman test

*xtregar rating election__l_ honeymoon__l_ ideology__l_ imf com__l_ fri__l_ pri__l_ tax__l_ cali__l_ polity_lagged_ ///
cpi_lagged_ ///
current_account_balance____of_gd debtgdpcon gdp_growth__annual_____lagged_ gdp_per_capita__constant_1995_us  ///
new_bond_default_5yearslagged_  

*est store re 

*xtregar rating election__l_ honeymoon__l_ ideology__l_ imf com__l_ fri__l_ pri__l_ tax__l_ cali__l_ polity_lagged_ ///
cpi_lagged_ ///
current_account_balance____of_gd debtgdpcon gdp_growth__annual_____lagged_ gdp_per_capita__constant_1995_us  ///
new_bond_default_5yearslagged_  , fe

*hausman . re

xtpcse rating election__l_ honeymoon__l_ ideology__l_ imf com__l_ fri__l_ pri__l_ tax__l_ cali__l_ ///
polity_lagged_ cpi_lagged_ current_account_balance____of_gd debtgdpcon gdp_growth__annual_____lagged_ ///
gdp_per_capita__constant_1995_us  new_bond_default_5yearslagged_ , corr(ar1) pairwise

sum rating election__l_ honeymoon__l_ ideology__l_ imf com__l_ fri__l_ pri__l_ tax__l_ cali__l_ ///
polity_lagged_ cpi_lagged_ current_account_balance____of_gd debtgdpcon gdp_growth__annual_____lagged_ ///
gdp_per_capita__constant_1995_us  new_bond_default_5yearslagged_ 

*corr rating election__l_ honeymoon__l_ ideology__l_ imf com__l_ fri__l_ pri__l_ tax__l_ cali__l_ polity_lagged_ ///
cpi_lagged_ current_account_balance____of_gd debtgdpcon gdp_growth__annual_____lagged_ ///
gdp_per_capita__constant_1995_us  new_bond_default_5yearslagged_  budbalcon

mfx compute

*best

mfx compute, at(com__l_=.975  cpi_lagged_=70.3 ///
gdp_per_capita__constant_1995_us=6555 new_bond_default_5yearslagged_=0 debtgdpcon=.635)


*worst

mfx compute, at(com__l_=.911  ///
cpi_lagged_=235.02 gdp_per_capita__constant_1995_us=1705.1 debtgdpcon=.239 new_bond_default_5yearslagged_=0 )

