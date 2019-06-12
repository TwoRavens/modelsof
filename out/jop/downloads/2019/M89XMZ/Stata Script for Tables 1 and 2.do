** Replication Data for DeSante and Smith (JOP) "Less is More..." ** 
**Data used are ANES_CDF_VERSION:2018-Dec-06
 
 gen year =  VCF0004
tab year
gen weight=VCF0009x
  
tab VCF0106 
** Non-Hispanic Whites ONLY IN ANALYSIS:*
keep if VCF0106 ==1 
*** Variables for APC:***
 
gen age = VCF0101 
sum age
drop if age==0
sum age if year<1955
tab year age if age>89
tab age
replace age=. if age==0
replace age=18	 if age==17
tab age
sum age, detail
tab age, nolab
keep if age<90


tab VCF9039
*RR1 : Conditions/Slavery*
tab VCF9040
*RR2: Special Favors
tab VCF9041
*RR3: Try Harder
tab VCF9042
*RR4: Blacks have gotten less*


tab VCF9039
gen rr1=  VCF9039-1 if VCF9039>0 & VCF9039<8
gen rr2=  5-VCF9040  if VCF9040>0 & VCF9040<8
gen rr3=  5-VCF9041  if VCF9041>0 & VCF9041<8
gen rr4=  VCF9042-1   if VCF9042>0 & VCF9042<8
alpha rr1-rr4  
tab rr4

gen rrsum=(rr1+rr2+rr3+rr4)/16
sum rrsum

***RR First asked in 1986 **
drop if year < 1986


*** Table 1:
bysort year: sum rrsum if VCF0017 != 4

 
tab age year
gen agegroup=age
recode agegroup  (17/24 =20) (25/29=25) (30/34=30) (35/39=35) 
recode agegroup (40/44 =40) (45/49=45) (50/54=50) (55/59=55)
recode agegroup (60/64 =60) (65/69=65) (70/74=70) (75/79=75)
recode agegroup (80/84=80) (85/90=85) 
tab agegroup

gen yeargroup=year
 recode yeargroup (1972/1975=1975) (1976/1980=1980)(1981/1985=1985)(1986/1990=1990)
 recode yeargroup (1991/1995=1995) (1996/2000=2000) (2001/2005=2005) (2006/2010=2010) (2011/2016=2015)
 tab yeargroup
 
 gen cohortgroup = yeargroup-agegroup
tab cohortgroup
 

*** APC_IE Package Here: ***
*** findit apc_ie ***

findit apc_ie
*Estimates from Table 2:
apc_ie rrsum [aweight=weight] , age(agegroup) period(yeargroup) family(gaussian) link(identity)
