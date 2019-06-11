*Full Sample
*Table 1, Column 1, Perceived Local Inequality / Figure 1, Panel C
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm locineq education_01 income_01 age male black latino asian unemployed partyid_01 if time_quality==1, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Table 1, Column 2, Perceived National Inequality
xtlogit divided gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01 education_01 income_01 age male black latino asian unemployed partyid_01 if time_quality==1, i(zip)

*Results by Income
*Figure 2, Panel B / Table C7, Column 1, below $25k
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm locineq age male black latino asian unemployed partyid_01 if time_quality==1 & income==1, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Figure 2, Panel B / Table C7, Column 2, $25-50K
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm locineq age male black latino asian unemployed partyid_01 if time_quality==1 & income==2, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Figure 2, Panel B / Table C7, Column 3, $50-75K
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm locineq age male black latino asian unemployed partyid_01 if time_quality==1 & income==3, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Figure 2, Panel B / Table C7, Column 4, $75-100K
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm locineq age male black latino asian unemployed partyid_01 if time_quality==1 & income==4, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Figure 2, Panel B / Table C7, Column 5, Above $100K
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm locineq age male black latino asian unemployed partyid_01 if time_quality==1 & income==5, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
