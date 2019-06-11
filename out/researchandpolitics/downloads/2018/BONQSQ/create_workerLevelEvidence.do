* The Distributional Consequences of Technological Change: Worker-Level Evidence
* Thomas Kurer and Aina Gallego

* Prepare EU-KLEMS data to merge with BHPS-UKHLS
* Merge with BHPS-UKHLS

*###############################################################################

clear
set more off

* set working directory
global wd "INSERTYOURPATH"   

* Load EU-KLEMS data (various sheets in excel file)

import excel using "$wd/UK_capital_17i.xlsx", sheet("Iq_CT") firstrow
drop if code == "TOT" | code == "MARKT"
encode code, gen(euklems_num)

* numerator
foreach var in 	Iq_CT Iq_IT Iq_Soft_DB Iq_RD Iq_OIPP Iq_GFCF Kq_CT Kq_IT Kq_Soft_DB Kq_RD Kq_OIPP Kq_GFCF ///
				I_CT I_IT I_Soft_DB I_RD I_OIPP I_GFCF K_CT K_IT K_Soft_DB K_RD K_OIPP K_GFCF {
clear
import excel using "$wd/UK_capital_17i.xlsx", sheet("`var'") firstrow
drop if code == "TOT" | code == "MARKT"
encode code, gen(euklems_num)
reshape long `var', i(euklems_num) j(year) 
drop if year<1997
save "$wd/file_`var'", replace
}

* denominators
foreach var in VA GO CAP EMP EMPE H_EMP H_EMPE VA_QI VAConKIT {
clear
import excel using data/EUKLEMS/release2017/output/UK_output_17i.xlsx, sheet("`var'") firstrow
drop if code == "TOT" | code == "MARKT"
encode code, gen(euklems_num)
reshape long `var', i(euklems_num) j(year) 
drop if year<1997
save data/EUKLEMS/file_`var', replace
}

clear
use "$wd/file_Iq_CT.dta"
foreach var in Iq_CT Iq_IT Iq_Soft_DB Iq_RD Iq_OIPP Iq_GFCF ///
				Kq_CT Kq_IT Kq_Soft_DB Kq_RD Kq_OIPP Kq_GFCF ///
				I_CT I_IT I_Soft_DB I_RD I_OIPP I_GFCF ///
				K_CT K_IT K_Soft_DB K_RD K_OIPP K_GFCF ///
				VA GO CAP EMP EMPE H_EMP H_EMPE VA_QI VAConKIT {
merge 1:1 euklems_num year using "$wd/file_`var'.dta", generate(match_`var')
}

rename euklems_num euklems_pre
recode euklems_pre 20=1 21=2 22=3 1=4 2=5 3=6 4=7 5=8 6=9 7=10 8=11 9=12 ///
10=13 11=14 23=15 24=16 25=17 12=18 13=19 14=20 26=21 15=22 16=23 27=24 ///
28=25 17=26 18=27 19=28 29=29 30=30 31=31 33=32 32=33 34=34 35=35 37=36 ///
36=37 38=38 39=39 40=40, gen(euklems_num)

label define euklems_num  ///
1	 "AGRICULTURE, FISHING" ///
2	 "MINING AND QUARRYING" ///
3	 "TOTAL MANUFACTURING" ///
4	 "Food, beverages, tobacco" ///
5	 "Textiles, leather " ///
6	 "Wood, paper, printing" ///
7	 "Coke, refined petroleum" ///
8	 "Chemicals" ///
9	 "Rubber and plastics" ///
10	 "Metals" ///
11	 "Electrical and optical" ///
12	 "Machinery n.e.c." ///
13	 "Transport equipment" ///
14	 "Other manufacturing" ///
15	 "ELECTR., GAS, WATER" /// 
16	 "CONSTRUCTION" ///
17	 "TRADE AND MOTOR" ///
18	 "Motor vehicles" ///
19	 "Wholesale trade" ///
20	 "Retail trade" ///
21	 "TRANSPORT, STORAGE" ///
22	 "Transport, storage" ///
23	 "Post and courier" ///
24	 "ACCOMMODATION, FOOD" ///
25	 "INFO. & COMMUNICATION" ///
26	 "Publishing, audiovisual" ///
27	 "Telecommunications" ///
28	 "Information technology" ///
29	 "FINANCE AND INSURANCE" ///
30	 "REAL ESTATE" ///
31	 "PROFESSIONAL, ADMIN." ///
32	 "COMMUNITY, SOCIAL" ///
33	 "Public adm. and defence" ///
34	 "Education" ///
35	 "Health and social work" ///
36	 "ARTS, RECREATION" ///
37	 "Arts, recreation" ///
38	 "Other services" ///
39	 "Households as employers" ///
40	 "Extraterritorial org." ///
, modify

label values euklems_num euklems_num
label variable euklems_num "Industry: EUKLEMS classification"


label define euklems_pre  ///
20	 "AGRICULTURE, FISHING" ///
21	 "MINING AND QUARRYING" ///
22	 "TOTAL MANUFACTURING" ///
1	 "Food, beverages, tobacco" ///
2	 "Textiles, leather " ///
3	 "Wood, paper, printing" ///
4	 "Coke, refined petroleum" ///
5	 "Chemicals" ///
6	 "Rubber and plastics" ///
7	 "Metals" ///
8	 "Electrical and optical" ///
9	 "Machinery n.e.c." ///
10	 "Transport equipment" ///
11	 "Other manufacturing" ///
23	 "ELECTR., GAS, WATER" /// 
24	 "CONSTRUCTION" ///
25	 "TRADE AND MOTOR" ///
12	 "Motor vehicles" ///
13	 "Wholesale trade" ///
14	 "Retail trade" ///
26	 "TRANSPORT, STORAGE" ///
15	 "Transport, storage" ///
16	 "Post and courier" ///
27	 "ACCOMMODATION, FOOD" ///
28	 "INFO. & COMMUNICATION" ///
17	 "Publishing, audiovisual" ///
18	 "Telecommunications" ///
19	 "Information technology" ///
29	 "FINANCE AND INSURANCE" ///
30	 "REAL ESTATE" ///
31	 "PROFESSIONAL, ADMIN." ///
33	 "COMMUNITY, SOCIAL" ///
32	 "Public adm. and defence" ///
34	 "Education" ///
35	 "Health and social work" ///
37	 "ARTS, RECREATION" ///
36	 "Arts, recreation" ///
38	 "Other services" ///
39	 "Households as employers" ///
40	 "Extraterritorial org." ///
, modify


label values euklems_pre euklems_pre
label variable euklems_num "Industry: EUKLEMS classification"



***Generate ICT variable

* capital stock in mil GBP
* H_EMP in thousands.
* multiply denominator with 1000 to get GBP/hour

gen ICT_hours =  (Kq_IT + Kq_CT + Kq_Soft_DB)/H_EMP*1000
label variable ICT_hours "Real fixed ICT capital stock (2010 prices) normalized by hours worked"

*###############################################################################

save "$wd/merged_euklems", replace
clear
*###############################################################################


***Merge with combined BHPS-UKHLS 

/*
Study Number 6614 - Understanding Society: Waves 1-7, 2009-2016 and
Harmonised BHPS: Waves 1-18, 1991-2009.
The depositor has specified that registration is required and standard con-
ditions of use apply. The depositor may be informed about usage.
Available upon registration at UK Data Service
(https://www.ukdataservice.ac.uk/)
*/

* Register, download and merge data. Save as bhps-ukhls.dta. Uncomment next line.
* use "$wd/bhps-ukhls.dta", replace

*###############################################################################

* Recoding

*###############################################################################

gen double id = pidp
format id %16.0f

gen year = wave + 1990

gen age = age_dv
replace age=. if age_dv<0

//impute missing age
xtset pidp year
replace age = L1.age + 1 if missing(age)
replace age = L2.age + 2 if missing(age)
replace age = L3.age + 3 if missing(age)
replace age = L4.age + 4 if missing(age)
replace age = L5.age + 5 if missing(age)
replace age = F1.age - 1 if missing(age)
replace age = F2.age - 2 if missing(age)
replace age = F3.age - 3 if missing(age)
replace age = F4.age - 4 if missing(age)
replace age = F5.age - 5 if missing(age)

gen yearbirth = year - age


***Age square
gen agesq=age*age
label variable age "Age"
label variable agesq "Age squared"

* jbstat consistent across waves, 1=selfemp, 2=emp, 3=unemp, 4=retired. 
* residual categories slightly vary (not used).

foreach var in selfemp emp unemp retired {
local one = `one' + 1
gen `var' = 0
replace `var' = 1 if jbstat==`one'
replace `var' = . if jbstat<0
label variable `var' "jbstat==`one'"
}

* income

gen incomem = paynu
replace incomem = . if paynu<0

label variable incomem "Monthly income (paynu_dv: Usual net pay per month: current job)"
label values incomem incomem

* Deflate wages to 2010 prices

merge m:1 year using "$wd/cpi.dta", gen(merge_cpi)
drop if merge_cpi == 2
drop merge_cpi

gen incomem_nominal = incomem
replace incomem =  incomem * cpi /100
label var incomem_nominal "Usual net pay per month (current job) in current prices"
label var incomem "Usual net pay per month (current job) in 2010 prices"

* job satisfaction
gen satjob = jbsat
replace satjob = . if jbsat<0


* create NACE codes that match EU-KLEMS classification

gen euklems_num=.
replace euklems_num = 1 if jbsic07==1
replace euklems_num = 1 if jbsic07==2
replace euklems_num = 1 if jbsic07==3
replace euklems_num = 2 if jbsic07==5
replace euklems_num = 2 if jbsic07==6
replace euklems_num = 2 if jbsic07==7
replace euklems_num = 2 if jbsic07==8
replace euklems_num = 2 if jbsic07==9
replace euklems_num = 4 if jbsic07==10
replace euklems_num = 4 if jbsic07==11
replace euklems_num = 4 if jbsic07==12
replace euklems_num = 5 if jbsic07==13
replace euklems_num = 5 if jbsic07==14
replace euklems_num = 5 if jbsic07==15
replace euklems_num = 6 if jbsic07==16
replace euklems_num = 6 if jbsic07==17
replace euklems_num = 6 if jbsic07==18
replace euklems_num = 7 if jbsic07==19
replace euklems_num = 8 if jbsic07==20
replace euklems_num = 8 if jbsic07==21
replace euklems_num = 9 if jbsic07==22
replace euklems_num = 9 if jbsic07==23
replace euklems_num = 10 if jbsic07==24
replace euklems_num = 10 if jbsic07==25
replace euklems_num = 11 if jbsic07==26
replace euklems_num = 11 if jbsic07==27
replace euklems_num = 12 if jbsic07==28
replace euklems_num = 13 if jbsic07==29
replace euklems_num = 13 if jbsic07==30
replace euklems_num = 14 if jbsic07==31
replace euklems_num = 14 if jbsic07==32
replace euklems_num = 14 if jbsic07==33
replace euklems_num = 15 if jbsic07==35
replace euklems_num = 15 if jbsic07==36
replace euklems_num = 15 if jbsic07==37
replace euklems_num = 15 if jbsic07==38
replace euklems_num = 15 if jbsic07==39
replace euklems_num = 16 if jbsic07==41
replace euklems_num = 16 if jbsic07==42
replace euklems_num = 16 if jbsic07==43
replace euklems_num = 18 if jbsic07==45
replace euklems_num = 19 if jbsic07==46
replace euklems_num = 20 if jbsic07==47
replace euklems_num = 22 if jbsic07==49
replace euklems_num = 22 if jbsic07==50
replace euklems_num = 22 if jbsic07==51
replace euklems_num = 22 if jbsic07==52
replace euklems_num = 23 if jbsic07==53
replace euklems_num = 24 if jbsic07==55
replace euklems_num = 24 if jbsic07==56
replace euklems_num = 26 if jbsic07==58
replace euklems_num = 26 if jbsic07==59
replace euklems_num = 26 if jbsic07==60
replace euklems_num = 27 if jbsic07==61
replace euklems_num = 28 if jbsic07==62
replace euklems_num = 28 if jbsic07==63
replace euklems_num = 29 if jbsic07==64
replace euklems_num = 29 if jbsic07==65
replace euklems_num = 29 if jbsic07==66
replace euklems_num = 30 if jbsic07==68
replace euklems_num = 31 if jbsic07==69
replace euklems_num = 31 if jbsic07==70
replace euklems_num = 31 if jbsic07==71
replace euklems_num = 31 if jbsic07==72
replace euklems_num = 31 if jbsic07==73
replace euklems_num = 31 if jbsic07==74
replace euklems_num = 31 if jbsic07==75
replace euklems_num = 31 if jbsic07==77
replace euklems_num = 31 if jbsic07==78
replace euklems_num = 31 if jbsic07==79
replace euklems_num = 31 if jbsic07==80
replace euklems_num = 31 if jbsic07==81
replace euklems_num = 31 if jbsic07==82
replace euklems_num = 33 if jbsic07==84
replace euklems_num = 34 if jbsic07==85
replace euklems_num = 35 if jbsic07==86
replace euklems_num = 35 if jbsic07==87
replace euklems_num = 35 if jbsic07==88
replace euklems_num = 37 if jbsic07==90
replace euklems_num = 37 if jbsic07==91
replace euklems_num = 37 if jbsic07==92
replace euklems_num = 37 if jbsic07==93
replace euklems_num = 38 if jbsic07==94
replace euklems_num = 38 if jbsic07==95
replace euklems_num = 38 if jbsic07==96
replace euklems_num = 38 if jbsic07==97
replace euklems_num = 38 if jbsic07==98
replace euklems_num = 40 if jbsic07==99

* create task groups.
* 3-digit ISCO codes only allow aggregated 3-group classification (task3 rather than task).
* difference within non-routine cognitive group is unjustifiable with ISCO 3-digit.

gen isco88_3d = jbisco88_cc
replace isco88_3d = . if jbisco88_cc<0

gen task = .
replace task = 1 if inlist(isco, 241, 243, 244, 341, 347)
replace task = 1 if inrange(isco, 210, 221)
replace task = 1 if inrange(isco, 244, 245)
replace task = 1 if inrange(isco, 310, 321)
replace task = 1 if inrange(isco, 343, 344)

replace task = 2 if inlist(isco, 244, 322, 343, 344)
replace task = 2 if inrange(isco, 100, 131)
replace task = 2 if inrange(isco, 222, 241)
replace task = 2 if inrange(isco, 241, 243)
replace task = 2 if inrange(isco, 245, 247)
replace task = 2 if inrange(isco, 321, 322) 
replace task = 2 if inrange(isco, 322, 341)
/* some of 322 could be considered non-routine manual
but e.g. modern health associate professionals rather non-routine cog */
replace task = 2 if inrange(isco, 341, 342)
replace task = 2 if inrange(isco, 344, 347) 
replace task = 2 if inrange(isco, 347, 348)


replace task = 3 if inrange(isco, 400, 421)

replace task = 4 if inlist(isco, 712, 834, 912, 913)
replace task = 4 if inrange(isco, 1, 110) 
replace task = 4 if inrange(isco, 610, 711)
replace task = 4 if inrange(isco, 720, 829)
replace task = 4 if inrange(isco, 900, 900)
replace task = 4 if inrange(isco, 915, 915)
replace task = 4 if inrange(isco, 915, 916)
replace task = 4 if inrange(isco, 920, 931) 
/* some of 931 could be considered non-routine manual. 
but ISCO description: simple routine tasks related to mining and construction
use of simple hand-held tools and physical effort */

replace task = 5 if inrange(isco, 712, 714)
replace task = 5 if inrange(isco, 830, 833)
replace task = 5 if inrange(isco, 913, 913)
replace task = 5 if inrange(isco, 914, 914)

replace task = 6 if inrange(isco, 422, 422)
replace task = 6 if inrange(isco, 500, 523) 
replace task = 6 if inrange(isco, 910, 911) 
replace task = 6 if inrange(isco, 932, 933) 

* add isco categories 2000 and 3000

replace task = 1 if inlist(isco, 200, 300)

gen task3 = .
replace task3 = 1 if task == 1 | task == 2
replace task3 = 2 if task == 3 | task == 4
replace task3 = 3 if task == 5 | task == 6

* dont use 6-category task variable. isco-3d is not detailed enough.
drop task 

label variable task3 "Task Group, based on ISCO-3d codes, adapted Oesch grouping"
label define task3 1 "Non-Routine Cognitive" 2 "Routine" 3 "Non-Routine Manual"
label values task3 task3


*###############################################################################

* Merge with EU-KLEMS

*###############################################################################

merge m:1 euklems_num year using "$wd/merged_euklems.dta", gen(match_euklems)
drop if match_euklems==2

*###############################################################################

save "$wd/workerLevelEvidence.dta", replace

*###############################################################################

