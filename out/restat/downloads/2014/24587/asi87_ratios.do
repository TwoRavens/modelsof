* ASI 1987-88
* Average k/o ratio and percent employment in food industries in 1987


use "$data\asi8788.dta", clear
keep v10 v3 v19 v20 v28 v38 v39 v50 v66 

rename v10 industrycode
rename v3 statecode
rename v20 districtcode
rename v38 fixedcapitalop
rename v39 fixedcapitalcl
rename v50 workers
rename v66 totaloutput
rename v28 openclose
rename v19 schemecode


drop if openclose==1

/* for 87-88 all variables have already been multiplied so we demultiply*/
ge multiplier=1
replace multiplier=1 if schemecode==1|schemecode==2|schemecode==3|schemecode==6|schemecode==7
replace multiplier=3 if schemecode==5|schemecode==9
tab multiplier


replace workers=workers/multiplier
replace totaloutput=totaloutput/multiplier
replace fixedcapitalcl=fixedcapitalcl/multiplier

/* mapping old industry codes to new ones*/
ge indcode_str=string(industrycode)
replace indcode_str=substr(indcode_str, 1,3)
destring indcode_str, generate(indcode_3dig)
drop indcode_str
label var indcode_3dig "3 dig industry code"

gen code=indcode_3dig
do "$do\changingcodes7087.do"

drop if indcode_3dig>=400
drop if indcode_3dig<200

rename code nic87code

/* creating a 2-digit code */
ge nic87code_str=string(nic87code)
replace nic87code_str=substr(nic87code_str, 1,2)
destring nic87code_str, generate(nic87code_2dig)
drop nic87code_str
label var nic87code_2dig "2 dig NIC87 code"

/* creating a 1-digit code */
ge nic87code_str=string(nic87code)
replace nic87code_str=substr(nic87code_str, 1,1)
destring nic87code_str, generate(nic87code_1dig)
drop nic87code_str
label var nic87code_1dig "1 dig NIC87 code"

/* price deflator*/
sort nic87code
merge nic87code using "$data\indexfinal.dta"
tab _merge
keep if _merge==3
drop _merge

g asicode88 = statecode*100 + districtcode

* nonsensical negative revenue

replace totaloutput = -1*totaloutput if totaloutput < 0

* k/o ratio, weighted by multiplier

ge kqratio = (fixedcapitalcl/totaloutput)*multiplier

* dummy for food related industry: food and beverage, cotton textile

ge food = 0
replace food = 1 if  nic87code_2dig == 20| nic87code_2dig == 21| nic87code_2dig == 22| nic87code_2dig == 23

ge fworker = worker*food*multiplier
replace worker = worker*multiplier

collapse (sum) multiplier kqratio fworker worker, by(asicode)

ge kqratio88 = kqratio/multiplier
ge food88 =  (fworker/worker)*100

label var kqratio88 "district average asi capital output ratio in 1987"
label var food88 "district percent employment in food industries in 1987"

keep kqratio88 food88 asicode88


sort asicode88
