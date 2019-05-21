* Read Macrodata

insheet using "macrodata.csv", comma clear
dropmiss, obs any force
egen gdpz=std(gdp)
egen tenurez=std(tenure)
egen tradez=std(eutrade)
egen inflz=std(infl)
sort cntry
save "macrodata.dta", replace



* Steenbergen Jone's data, Eurobarometer 46.0 ZA study number 2898
* Download from http://dx.doi.org/10.4232/1.2898

use "ZA2898_F1.dta", clear


* use only respondents 18 or older
drop if v622 < 18

* age
clonevar age = v622

* gen. continuous DV
recode v47 (1=1)(2 3 =0)
gen support = v47+v51

* income quartile dummies
gen inclow = 0
replace inclow = 1 if v647 == 1
gen inchi = 0
replace inchi = 1 if v647 == 4

* left right self placement
gen lright = v614 - 1

* opinion leader index, centered around sample mean
sum v658, meanonly
gen olead = v658 - `r(mean)'


* male
recode v621 (1=1)(2=0),gen(male)

* countries: group west+east germany, gen continuous indicator
recode v6 (13=4)
egen cntry = group(v6)

keep age support inclow inchi lright olead male cntry v6 

sort cntry

* Merge in macrodata
merge m:1 cntry using "macrodata"
dropmiss, obs any force

compress
save data.dta, replace


