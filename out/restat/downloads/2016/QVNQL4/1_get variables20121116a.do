set more off
cd /media/Data/Research/shak/EmpiricalApp/NLSY
* cd /home/user/NLSY

* get weights from 1979 to 2000
infile CASEID weight00 using ./data/rawdata/weight_all_2000.dat, clear
* transform weight to represent actual respondents
gen weight_trans = int(weight00 / 100)
replace weight00 = weight_trans
drop weight_trans
sort CASEID
save ./data/workdata/weight2000, replace

* get weights from 1979 to 2010
* intuitively, some respondents were dropped between 2000 and 2010 years, for those who dropped
* the weights are zero. so the remaining were given higher weights to represent whole population
infile CASEID weight10 using ./data/rawdata/weight_all_2010.dat, clear
* transform weight to represent actual respondents
gen weight_trans = int(weight10 / 100)
replace weight10 = weight_trans
drop weight_trans
sort CASEID
save ./data/workdata/weight2010, replace

* get variables, including part (a) ~ (c), 
set more off
infile using ./data/rawdata/get_variable.dct, clear

* merge with weight
rename R0000100 CASEID
sort CASEID
merge 1:1 CASEID using ./data/workdata/weight2000
tab _merge
keep if _merge == 3
drop _merge
sort CASEID
merge 1:1 CASEID using ./data/workdata/weight2010
tab _merge
keep if _merge == 3
drop _merge
sort CASEID

save ./data/workdata/workdata, replace
