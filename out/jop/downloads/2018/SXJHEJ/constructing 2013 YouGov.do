use "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2014 and 2015/AJPS/AJPS reject and resubmit/YouGovFeb2013noerror.dta", clear
keep weight race educ Q8_1 Q8_2 Q8_3 Q8_4 Q4_1 Q4_2 Q4_3 Q4_4 Q4_5 Q5 Q14_1 Q14_2 Q14_3 Q15_1 Q15_2 Q19a Q19b Q21a Q21b gender birthyr Q17 marstat Q12_4
save "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2016/Guilt Paper/JOP submitted/JOP rejected/JOP resubmission/JOP resubmitted/JOP rerejected/JOP reresubmitted/JOP Final Revisions_2.2018/replication files/2013 YouGov raw data.dta", replace
 
use "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2016/Guilt Paper/JOP submitted/JOP rejected/JOP resubmission/JOP resubmitted/JOP rerejected/JOP reresubmitted/JOP Final Revisions_2.2018/replication files/2013 YouGov raw data.dta", clear

 
*white
gen white=0
replace white=1 if race==1

*aid to blacks
gen atbtemp=Q8_1
replace atbtemp=Q8_2 if atbtemp==9
replace atbtemp=Q8_3 if atbtemp==9
replace atbtemp=Q8_4 if atbtemp==9
recode atbtemp 8=4
gen atb=((atbtemp*(-1))+7)/6
tab atb, miss

*obamacare
gen obamacaretemp=Q4_1
replace obamacaretemp=Q4_2 if obamacaretemp==9
replace obamacaretemp=Q4_3 if obamacaretemp==9
replace obamacaretemp=Q4_4 if obamacaretemp==9
replace obamacaretemp=Q4_5 if obamacaretemp==9
recode obamacaretemp 8=4
gen obamacare=((obamacaretemp*(-1))+7)/6
tab obamacare

*welfare
gen welfaretemp=Q5
recode welfaretemp 8=.
gen welfare=((welfaretemp*(-1)+7))/6
tab welfare Q5, miss


*guilt about racial inequality
gen guilt1=Q14_1
recode guilt1 8=. 1=0 2=.17 3=.34 4=.5 5=.67 6=.84 7=1
tab Q14_1 guilt1, miss
gen guilt1rev=((guilt1*(-1))+1)
tab guilt1rev
corr guilt1rev guilt1
gen guilt2=Q14_2
recode guilt2 8=. 1=1 2=.84 3=.67 4=.5 5=.34 6=.17 7=0
tab Q14_2 guilt2, miss
gen guilt3=Q14_3
recode guilt3 8=. 1=1 2=.84 3=.67 4=.5 5=.34 6=.17 7=0
tab Q14_3 guilt3, miss
alpha guilt1 guilt2 guilt3, gen(guilt) item

*racial stereotypes
gen stlazywtemp=Q15_1
recode stlazywtemp 8=.
gen stlazyw=(stlazywtemp-1)/6
tab stlazyw Q15_1, miss
gen stlazybtemp=Q15_2
recode stlazybtemp 8=.
gen stlazyb=(stlazybtemp-1)/6
tab stlazyb Q15_2, miss
*blacks lazier than whites
gen stlazybw=(stlazyb-stlazyw+1)/2
tab stlazybw

*pidrep
gen pidreptemp=Q19a
recode pidreptemp 9=.
replace pidreptemp=Q19b if pidreptemp==.
gen pidrep=(pidreptemp-1)/6
tab pidrep

*id
gen idtemp=Q21a
recode idtemp 999=.
replace idtemp=Q21b if idtemp==.
gen id=(idtemp-1)/6
tab id

*female
gen female=0
replace female=1 if gender==2
tab female gender, miss

*age
gen age=2012-birthyr
tab age
gen age0to1=(age-18)/73
tab age0to1

*educ
gen educ0to1=(educ-1)/5

*classidentity
gen classidentity=Q17
recode classidentity 8=.
replace classidentity=(classidentity-1)/4

*married
gen married=0
replace married=1 if marstat==1
tab marstat married, miss

*obamatherm
gen obamathermtemp=Q12_4
recode obamathermtemp 998=.
gen obamatherm=obamathermtemp/100
tab obamatherm

save "/Users/spencerpiston/Dropbox/Chupperton/Chupperton 2016/Guilt Paper/JOP submitted/JOP rejected/JOP resubmission/JOP resubmitted/JOP rerejected/JOP reresubmitted/JOP Final Revisions_2.2018/replication files/2013 YouGov constructed data.dta", replace
