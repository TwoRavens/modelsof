clear
set more off

use Evans_drugs_seven
replace state="NEW YORK" if state=="NEWYORK"
replace state="NEW JERSEY" if state=="NEWJERSEY"
replace state="NEW HAMPSHIRE" if state=="NEWHAMPSHIRE"
replace state="NEW MEXICO" if state=="NEWMEXICO"
replace state="DISTRICT OF COLUMBIA" if state=="DC"
replace state="NORTH CAROLINA" if state=="NORTHCAROLINA"
replace state="NORTH DAKOTA" if state=="NORTHDAKOTA"
replace state="SOUTH CAROLINA" if state=="SOUTHCAROLINA"
replace state="SOUTH DAKOTA" if state=="SOUTHDAKOTA"
replace state="WEST VIRGINIA" if state=="WESTVIRGINIA"
replace state="RHODE ISLAND" if state=="RHODEISLAND"
drop population FLORIDA _merge codeine methadone
sort state year quarter
save evans_drugs_seven_a, replace
clear

use opioids_together
sort state year quarter

merge 1:1 state year quarter using evans_drugs_seven_a

*construct the dummies used in analysis
keep if year>=2004
gen florida=fips==12
sort florida year quarter
rename Pentobarbital pentobarbital

collapse (sum) oxycodone oxymorphone hydrocodone morphine codeine fentanyl ///
hydromorphone pentobarbital meperdine population, by(florida year quarter)


export excel using ../processed_data/florida_vs_rest_arcos.xlsx, replace firstrow(variables)


gen trend=4*(year-2004)+quarter

gen oxy_pc=oxycodone*1000/population
gen oxymorphone_pc=oxymorphone*1000/population
gen hydrocodone_pc=hydrocodone*1000/population
gen morphine_pc=morphine*1000/population
gen codeine_pc=codeine*1000/population
gen fentanyl_pc=fentanyl*1000/population
gen hydromorphone_pc=hydromorphone*1000/population
gen pentobarbital_pc=pentobarbital*1000/population
gen meperdine_pc=meperdine*1000/population

gen z=trend-27
gen post=trend>=27
gen zpost1=post*z
gen zpost2=zpost1*zpost1
gen zpre1=(1-post)*z
gen zpre2=zpre1*zpre1

gen zpref1=zpre1*florida
gen zpref2=zpre2*florida
gen zpostf1=zpost1*florida
gen zpostf2=zpost2*florida

gen zpren1=zpre1*(1-florida)
gen zpren2=zpre2*(1-florida)
gen zpostn1=zpost1*(1-florida)
gen zpostn2=zpost2*(1-florida)


reg oxy_pc florida zpref1 zpren1 zpostf1 zpostn1, vce(robust)
test zpref1=zpren1
test zpostf1=zpostn1
test (zpref1=zpren1) (zpostf1=zpostn1)
** and test whether there is a break in oxy_pc use outside of florida
lincom zpostn1 - zpren1
lincom zpostf1 - zpref1

reg hydrocodone_pc florida zpref1 zpren1 zpostf1 zpostn1, vce(robust)
test zpref1=zpren1
test zpostf1=zpostn1
test (zpref1=zpren1) (zpostf1=zpostn1)

reg morphine_pc florida zpref1 zpren1 zpostf1 zpostn1, vce(robust)
test zpref1=zpren1
test zpostf1=zpostn1
test (zpref1=zpren1) (zpostf1=zpostn1)

reg oxymorphone_pc florida zpref1 zpren1 zpostf1 zpostn1, vce(robust)
test zpref1=zpren1
test zpostf1=zpostn1
test (zpref1=zpren1) (zpostf1=zpostn1)

reg codeine_pc florida zpref1 zpren1 zpostf1 zpostn1, vce(robust)
test zpref1=zpren1
test zpostf1=zpostn1
test (zpref1=zpren1) (zpostf1=zpostn1)

reg hydromorphone_pc florida zpref1 zpren1 zpostf1 zpostn1, vce(robust)
test zpref1=zpren1
test zpostf1=zpostn1
test (zpref1=zpren1) (zpostf1=zpostn1)

reg fentanyl_pc florida zpref1 zpren1 zpostf1 zpostn1, vce(robust)
test zpref1=zpren1
test zpostf1=zpostn1
test (zpref1=zpren1) (zpostf1=zpostn1)

reg pentobarbital_pc florida zpref1 zpren1 zpostf1 zpostn1, vce(robust)
test zpref1=zpren1
test zpostf1=zpostn1
test (zpref1=zpren1) (zpostf1=zpostn1)

reg meperdine_pc florida zpref1 zpren1 zpostf1 zpostn1, vce(robust)
test zpref1=zpren1
test zpostf1=zpostn1
test (zpref1=zpren1) (zpostf1=zpostn1)

* means for florida in 4 quarters prior
sum oxy_pc hydrocodone_pc morphine_pc oxymorphone_pc codeine_pc hydromorphone_pc ///
 fentanyl_p pentobarbital_pc meperdine_pc if trend<=26 & trend>=23 & florida==1

* means for rest of US in 4 quarters prior
sum oxy_pc hydrocodone_pc morphine_pc oxymorphone_pc codeine_pc hydromorphone_pc ///
 fentanyl_p pentobarbital_pc meperdine_pc if trend<=26 & trend>=23 & florida==0



 






