use "DATABASE.dta", clear

***************** 
**** TABLE A1**** 
*****************

sum c033 dum_empl3 x001 x003 dummy_married x023r x047 c034 findev GDP_pc unempl min_wage lab_regul regulation GDP_growth bank_own trust civ_com 

***************** 
**** TABLE 1 **** 
*****************

bys s025: oprob c033 dum_empl3 dummy_married x001 x003 age_sq x023r  
bys s025: oprob c033 dum_empl3 x047 dummy_married x001 x003 age_sq x023r  

***************** 
**** TABLE 2 **** 
*****************

sort s025

foreach num of numlist 321991 401990 401999 561981 561990 561999 761991 1001990 1001999 1122000 1241982 1241990 1521990 1561990 1911999 2031990 2031991 2031999 2081981 2081990 2081999 2331990 2331999 2461990 2462000 2501981 2501990 2501999 2761990 2761999 3001999 3481991 3481999 3521984 3521990 3521999 3561990 3721981 3721990 3721999 3801981 3801990 3801999 3921990 4281990 4281999 4401990 4401999 4421999 4701983 4701999 4841990 5281981 5281990 5281999 5661990 5781982 5781990 6161989 6161990 6161999 6201990 6421993 6421999 6431990 6431999 7031990 7031991 7031999 7051992 7051999 7101990 7241981 7241990 7241999 7521982 7521999 7922001 8041999 8261981 8261990 8261999 8401982 8401990 9001981 9091981 9091990 9091999 {
display `num'
oprob c033 dum_empl3 dummy_married x001 x003 age_sq x023r if x028!=2&occup!=4&s025==`num'
matrix list e(b)
matrix A=e(b)
scalar b_`num'=A[1,1]
replace happy=b_`num' if s025==`num'
matrix list e(V)
matrix B=e(V)
scalar b_`num'=B[1,1]
replace happy_se=sqrt(b_`num') if s025==`num'
}



foreach num of numlist 321991 401990 401999 561981 561990 561999 761991 1001990 1001999 1122000 1241982 1241990 1521990 1561990 1911999 2031990 2031991 2031999 2081981 2081990 2081999 2331990 2331999 2461990 2462000 2501981 2501990 2501999 2761990 2761999 3001999 3481991 3481999 3521984 3521990 3521999 3561990 3721981 3721990 3721999 3801981 3801990 3801999 3921990 4281990 4281999 4401990 4401999 4421999 4701983 4701999 4841990 5281981 5281990 5281999 5661990 5781982 5781990 6161989 6161990 6161999 6201990 6421993 6421999 6431990 6431999 7031990 7031991 7031999 7051992 7051999 7101990 7241981 7241990 7241999 7521982 7521999 7922001 8041999 8261981 8261990 8261999 8401982 8401990 9001981 9091981 9091990 9091999 {
display `num'
oprob x047 dum_empl3 dummy_married x001 x003 age_sq x023r if x028!=2&occup!=4&s025==`num'
matrix list e(b)
matrix A=e(b)
scalar b_`num'=A[1,1]
replace rich=b_`num' if s025==`num'
matrix list e(V)
matrix B=e(V)
scalar b_`num'=B[1,1]
replace rich_se=sqrt(b_`num') if s025==`num'
}

gen happy_weight=happy/happy_se
gen rich_weight=rich/rich_se
gen labor_regul=-lab_regul
pwcorr happy_weight rich_weight findev GDP_pc unempl min_wage, st(0.01)


***************** 
**** TABLE 3 **** 
*****************
xi: reg c033 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4), robust cluster (country_status)
xi: reg c033 findev_3_100  dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4), robust cluster (country_status)
xi: reg c033 findev_3_100  GDP_pc_3_1000 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4), robust cluster (country_status)
xi: reg c033 findev_3_100  GDP_growth_3 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4), robust cluster (country_status)
xi: reg c033 findev_3_100  unempl_3 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4), robust cluster (country_status)
xi: reg c033 findev_3_100  regulation_3 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4), robust cluster (country_status)
xi: reg c033 bank_own_3  GDP_pc_3_1000 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4), robust cluster (country_status)


***************** 
**** TABLE 4 **** 
*****************
xi i.s025
ivregress 2sls c033 (findev_3_100= trust_3)  dum_empl3 x001 x003 dummy_married age_sq x023r  _I*  if x028!=2, robust cluster (country_status)
estat firststage
ivregress 2sls c033 (findev_3_100= bank_own_3)  dum_empl3 x001 x003 dummy_married age_sq x023r  _I*  if x028!=2, robust cluster (country_status) 
estat firststage
ivregress 2sls c033 (findev_3_100= civ_com_3)  dum_empl3 x001 x003 dummy_married age_sq x023r  _I*  if x028!=2, robust cluster (country_status)
estat firststage
ivreg2 c033 (findev_3_100= trust_3 civ_com_3) dum_empl3 x001 x003 dummy_married age_sq x023r  _I*  if x028!=2, robust cluster (country_status) ffirst partial(_I*) nocollin
ivreg2 c033 (findev_3_100= trust_3 bank_own_3)  dum_empl3 x001 x003 dummy_married age_sq x023r  _I*  if x028!=2, robust cluster (country_status) ffirst partial(_I*) nocollin
ivreg2 c033 (findev_3_100= bank_own_3 civ_com_3)  dum_empl3 x001 x003 dummy_married age_sq x023r  _I*  if x028!=2, robust cluster (country_status) ffirst partial(_I*) nocollin


***************** 
**** TABLE 5 **** 
*****************

xi: reg c033 findev_3_100  GDP_pc_3_1000 dum_empl3 x001 x003 age_sq dummy_married  x023r  i.s025 if (x028!=2&occup!=4&findev<71.78), robust cluster (country_status)
xi: reg c033 findev_3_100  GDP_pc_3_1000 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4&findev>71.78), robust cluster (country_status)
xi: reg c033 findev_3_100  GDP_pc_3_1000 dum_empl3 x001 x003  dummy_married age_sq x023r i.s025 if (x028!=2&occup!=4&unempl>8.2), robust cluster (country_status)
xi: reg c033 findev_3_100  GDP_pc_3_1000 dum_empl3 x001 x003  dummy_married age_sq x023r i.s025 if (x028!=2&occup!=4&unempl<8.2), robust cluster (country_status)
xi: reg c033 findev_3_100  GDP_pc_3_1000 dum_empl3 x001 x003  dummy_married age_sq x023r i.s025 if (x028!=2&occup!=4&min_wage==1), robust cluster (country_status)
xi: reg c033 findev_3_100  GDP_pc_3_1000 dum_empl3 x001 x003  dummy_married age_sq x023r i.s025 if (x028!=2&occup!=4&min_wage==0), robust cluster (country_status)
xi: reg c033 findev_3_100 findev_3_100_sq findev_3_100_cub GDP_pc_3_1000 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4), robust cluster (country_status)


***************** 
**** TABLE 6 **** 
*****************
xi: reg c033 dum_empl3 x047 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4), robust cluster (country_status)
xi: reg c033 findev_3_100  GDP_pc_3_1000 dum_empl3 x047 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4&findev<71.78), robust cluster (country_status)
xi: reg c033 findev_3_100  GDP_pc_3_1000 dum_empl3 x047 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4&findev>71.78), robust cluster (country_status)
xi: reg c033  dum_empl3 c034 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4), robust cluster (country_status)
xi: reg c033 findev_3_100 GDP_pc_3_1000 c034 dum_empl3 x001 x003  dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4&findev<71.78), robust cluster (country_status)
xi: reg c033 findev_3_100  c034 GDP_pc_3_1000 dum_empl3 x001 x003  dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4&findev>71.78), robust cluster (country_status)



***************** 
**** TABLE 7 **** 
*****************
xi: reg x047 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4&findev<71.78&c033!=.), robust cluster (country_status)
xi: reg x047 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4&findev>71.78&c033!=.), robust cluster (country_status)
xi: reg x047 findev_3_100  GDP_pc_3_1000 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4&c033!=.), robust cluster (country_status)
xi: reg x047 findev_3_100  GDP_pc_3_1000 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4&findev<71.78&c033!=.), robust cluster (country_status)
xi: reg x047 findev_3_100  GDP_pc_3_1000 dum_empl3 x001 x003 dummy_married age_sq x023r  i.s025 if (x028!=2&occup!=4&findev>71.78&c033!=.), robust cluster (country_status)




