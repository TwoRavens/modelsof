********************************************************************************************************
* Study Title: Social Exclusion and Political Identity: The Case of Asian American Partisanship
* Code to Replicate Analysis of CCES Data President in Online Appendix A Figure 1 
* Date: May 9, 2016
* Written By: Alexander Kuo, Neil Malhotra, and Cecilia Hyunjung Mo
* Datasets: cces08_common_output.dta, cces2012_common.dta
* Run This Stata Code first to produce results matrices cces_stacked.dta and cces_stacked.txt
* Then Run R Code to Make Figure Based on results matrices
********************************************************************************************************


// 2008

use cces08_common_output.dta, clear

gen pid = (cc307a-7)/-6 if cc307a<8
gen ideo = (v243-5)/-4 if v243<6
gen pres = cc410==2 if (cc410==1|cc410==2)


mat results = J(12,4,0)

local a=1
forvalues x = 1/4 {
local b=1
foreach var of varlist pid ideo pres {
qui reg `var' [pweight=v200] if v211==`x'
mat results[`a',1] = _b[_cons]
mat results[`a',2] = _se[_cons]
mat results[`a',3] = `x'
mat results[`a',4] = `b'
local ++a
local ++b
}
}

mat2txt, matrix(results) saving(cces_a) replace

// 2012

use cces2012_common.dta, clear

gen pid = (pid7-7)/-6 if pid7<8
gen ideo = (ideo5-5)/-4 if ideo5<6
gen pres = CC410a==1 if (CC410a==1|CC410a==2)


mat results = J(12,4,0)

local a=1
forvalues x = 1/4 {
local b=4
foreach var of varlist pid ideo pres {
qui reg `var' [pweight=V103] if race==`x'
mat results[`a',1] = _b[_cons]
mat results[`a',2] = _se[_cons]
mat results[`a',3] = `x'
mat results[`a',4] = `b'
local ++a
local ++b
}
}

mat2txt, matrix(results) saving(cces_b) replace

// Stack Datasets

insheet using cces_a.txt, clear
drop v1 v6
save cces2008_x.dta

insheet using cces_b.txt, clear
drop v1 v6
save cces2012_x.dta

use cces2008_x
append using cces2012_x


save cces_stacked.dta
outsheet using cces_stacked.txt



