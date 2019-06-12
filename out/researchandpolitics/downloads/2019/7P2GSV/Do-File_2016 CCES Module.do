*Model for Figure 1, Panel A / Table C1, Column 1
gen cons=1
eq cons: cons
eq f1: gini1115cnty_01 medinc1115cnty_01 punemp1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(fips) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons

*Model for Figure 1, Panel B / Table C1, Column 2
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons

*County Models for Figure 2, Panel A / Table C2
*1st Quintile Respondent Income
gen cons=1
eq cons: cons
eq f1: gini1115cnty_01 medinc1115cnty_01 punemp1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01
gllamm perceivedineq Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01 if incomei5==1, i(fips) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*2nd Quintile Respondent Income
gen cons=1
eq cons: cons
eq f1: gini1115cnty_01 medinc1115cnty_01 punemp1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01
gllamm perceivedineq Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01 if incomei5==2, i(fips) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*3rd Quintile Respondent Income
gen cons=1
eq cons: cons
eq f1: gini1115cnty_01 medinc1115cnty_01 punemp1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01
gllamm perceivedineq Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01 if incomei5==3, i(fips) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*4th Quintile Respondent Income
gen cons=1
eq cons: cons
eq f1: gini1115cnty_01 medinc1115cnty_01 punemp1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01
gllamm perceivedineq Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01 if incomei5==4, i(fips) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*5th Quintile Respondent Income
gen cons=1
eq cons: cons
eq f1: gini1115cnty_01 medinc1115cnty_01 punemp1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01
gllamm perceivedineq Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01 if incomei5==5, i(fips) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons

*Zip Code Models for Figure 2, Panel A / Table C3
*1st Quintile Respondent Income
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm perceivedineq Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01 if incomei5==1, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*2nd Quintile Respondent Income
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm perceivedineq Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01 if incomei5==2, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*3rd Quintile Respondent Income
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm perceivedineq Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01 if incomei5==3, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*4th Quintile Respondent Income
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm perceivedineq Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01 if incomei5==4, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*5th Quintile Respondent Income
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm perceivedineq Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01 if incomei5==5, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons

*Table C4, Column 1
ologit perceivedineq gini1115cnty_01 inc5d2 inc5d3 inc5d4 inc5d5 gini1115cnty_01Xinc5d2 gini1115cnty_01Xinc5d3 gini1115cnty_01Xinc5d4 gini1115cnty_01Xinc5d5 medinc1115cnty_01 punemp1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01 educ_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, cluster(fips)
*Table C4, Column 2
ologit perceivedineq gini1115zip_01 inc5d2 inc5d3 inc5d4 inc5d5 gini1115zip_01Xinc5d2 gini1115zip_01Xinc5d3 gini1115zip_01Xinc5d4 gini1115zip_01Xinc5d5 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01 educ_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, cluster(zip)

*Table C6, Column 1
ologit perceivedineq gini1115cnty_01 medinc1115cnty_01 punemp1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01 educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, cluster(fips)
*Table C6, Column 2
ologit perceivedineq gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01 educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, cluster(zip)

*Table D1, Column 1
gen cons=1
eq cons: cons
eq f1: gini1115cnty_01 medinc1115cnty_01 punemp1115cnty_01 pfampov1115cnty_01 phomeless15cnty_01 incdiv1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(fips) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Table D1, Column 2
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 fampov1115zip_01 phomeless15cnty_01 incdiv1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons

*Table D2, Column 1
gen cons=1
eq cons: cons
eq f1: incdiv1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(fips) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Table D2, Column 2
gen cons=1
eq cons: cons
eq f1: incdiv1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Table D3, Column 1
gen cons=1
eq cons: cons
eq f1: below25_01 above100_01 below25_01Xabove100_01 medinc1115cnty_01 punemp1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(fips) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Table D3, Column 2
gen cons=1
eq cons: cons
eq f1: below25zip_01 above100zip_01 below25zip_01Xabove100zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Table D4, Column 1 (w/o zip code Gini)
gen cons=1
eq cons: cons
eq f1: gini1216cd_01 medinc1216cd_01 unemp1216cd_01 pblk1216cd_01 promney12cnty_01 popden1216cd_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(congdist) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Table D4, Column 2 (w/ zip code Gini)
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 gini1216cd_01 medinc1216cd_01 unemp1216cd_01 pblk1216cd_01 promney12cnty_01 popden1216cd_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(congdist) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons

*Table D5, Column 1 (Controlling for Total Population & Land Area)
gen cons=1
eq cons: cons
eq f1: gini1115cnty_01 medinc1115cnty_01 punemp1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01 totpop1115cnty_01 larea1115cnty_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(fips) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Table D5, Column 2
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01 totpop1115zip_01 larea1115zip_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons


*Table D6, Column 1
gen cons=1
eq cons: cons
eq f1: gini1115cnty_01 medhinc00cnty_01 pctunemp00cnty_01 pctblk00cnty_01 promney12cnty_01 popden00cnty_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(fips) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Table D6, Column 2
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 promney12cnty_01 popden00zip_01 
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons

*Table D7 (excluding zip code level controls)
gen cons=1
eq cons: cons
eq f1: gini1115zip_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partyid_01 ideology_01 religattend_01, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons

*Table D8, Column 1
gen cons=1
eq cons: cons
eq f1: gini1115cnty_01 medinc1115cnty_01 punemp1115cnty_01 pblk1115cnty_01 promney12cnty_01 popden1115cnty_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partydum1 partydum2 partydum3 partydum5 partydum6 partydum7 ideodum1 ideodum2 ideodum4 ideodum5 religattend_01, i(fips) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
*Table D8, Column 2
gen cons=1
eq cons: cons
eq f1: gini1115zip_01 medinc1115zip_01 punemp1115zip_01 pblk1115zip_01 promney12cnty_01 popden1115zip_01
gllamm perceivedineq educ_01 incomei_01 Age male black latino asian mixedrace unemployed unionmem partydum1 partydum2 partydum3 partydum5 partydum6 partydum7 ideodum1 ideodum2 ideodum4 ideodum5 religattend_01, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)
drop cons
