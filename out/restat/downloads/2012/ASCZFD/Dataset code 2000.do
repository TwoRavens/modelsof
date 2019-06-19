clear
set mem 4g
global path "U:\user3\klp27\Blau and Kahn\Immigration"

use "$path\Census 2000 data", clear

*Create consistent occupational categories using propsed taxonomy of Meyer and Osborne (2005)
scalar CPSDATA=0
scalar CENSUSDATA=1
rename occ ocsrc
*Note this do-file is only designed for use on a dataset from a single year
do "$path\remapjob"
rename ocsrc occ
rename ocdest occmo

sort year serial pernum

*Create subfamily ID var (consistent with CPS definition)
*CHECK ALL OF THIS
gen coupleid=.
replace coupleid=pernum if sex==1 & sploc>0
replace coupleid=sploc if sex==2 & sploc>0

gen momid=.
replace momid=momloc if momloc>0
replace momid=pernum if nchild>0 & sex==2
sort serial pernum
gen momid2=momid
by serial: replace momid2=coupleid[momid] if coupleid[momid]~=.

gen popid=.
replace popid=poploc if poploc>0
replace popid=pernum if nchild>0 & sex==1

gen subfamunit=coupleid
replace subfamunit=momid2 if subfamunit==./* & momid~=pernum*/
*replace subfamunit=momid2 if subfamunit==. & momid==pernum
replace subfamunit=popid if subfamunit==. /*& popid~=pernum*/
replace subfamunit=pernum if subfamunit==.

drop coupleid momid momid2 popid


save "$path\Census 2000 data", replace


*NOTE THE AGE RESTRICTION IN THIS: 18-65
*ALSO I AM CURRENTLY COUNTING CHILDREN AS LONG AS THEY ARE NOT MARRIED WITH SPOUSE PRESENT OR ABSENT

*The following creates a matched wife-husband dataset (Census 2000 Wife data.dta)
keep year serial pernum age sex marst momloc poploc nchild
*The next two lines create a var that allocates children to their mother or their father if she isn't present
gen parent=momloc
replace parent=poploc if momloc==0

sort year serial pernum
save "$path\interim", replace
keep if marst==1 & age>17 & age<66
save "$path\full child", replace

local i=0
while `i'<19 {
	use  "$path\interim", clear

	keep if age==`i' & sex==1 & marst~=1 & nchild==0 & parent~=0

	for num 1/26: gen parentnoX=cond(parent==X,1,0)
	collapse (sum) parentno*, by(year serial)
	reshape long parentno, i(year serial) j(pernum)
	rename parentno nchm`i'
	sort year serial pernum
	save "$path\children`i'", replace

	use "$path\full child", clear
	merge year serial pernum using "$path\children`i'"
	drop if _merge==2
	drop _merge
	sort year serial pernum
	save "$path\full child", replace
	erase "$path\children`i'.dta"
	local i=`i'+1
	}

use  "$path\interim", clear

keep if age>18 & sex==1 & marst~=1 & nchild==0 & parent~=0

for num 1/26: gen parentnoX=cond(parent==X,1,0)
collapse (sum) parentno*, by(year serial)
reshape long parentno, i(year serial) j(pernum)
rename parentno nchm19plus
*Next line added to save space
drop if nchm19plus==0
sort year serial pernum
save "$path\children19", replace

use "$path\full child", clear
merge year serial pernum using "$path\children19"
drop if _merge==2
drop _merge
sort year serial pernum
save "$path\full child", replace
erase "$path\children19.dta"


local i=0
while `i'<19 {
	use  "$path\interim", clear

	keep if age==`i' & sex==2 & marst~=1 & nchild==0 & parent~=0

	for num 1/26: gen parentnoX=cond(parent==X,1,0)
	collapse (sum) parentno*, by(year serial)
	reshape long parentno, i(year serial) j(pernum)
	rename parentno nchf`i'
	sort year serial pernum
	save "$path\children`i'", replace

	use "$path\full child", clear
	merge year serial pernum using "$path\children`i'"
	drop if _merge==2
	drop _merge
	sort year serial pernum
	save "$path\full child", replace
	erase "$path\children`i'.dta"
	local i=`i'+1
	}

use "$path\interim", clear

keep if age>18 & sex==2 & marst~=1 & nchild==0 & parent~=0

for num 1/26: gen parentnoX=cond(parent==X,1,0)
collapse (sum) parentno*, by(year serial)
reshape long parentno, i(year serial) j(pernum)
rename parentno nchf19plus
*Next line added to save space
drop if nchf19plus==0
sort year serial pernum
save "$path\children19", replace

use "$path\full child", clear
merge year serial pernum using "$path\children19"
drop if _merge==2
drop _merge
sort year serial pernum
erase "$path\children19.dta"
erase "$path\interim.dta"

for num 0/18: replace nchmX=0 if nchmX==.
replace nchm19plus=0 if nchm19plus==.
for num 0/18: replace nchfX=0 if nchfX==.
replace nchf19plus=0 if nchf19plus==.

drop age sex marst momloc poploc
save "$path\full child", replace


use "$path\Census 2000 data", clear
keep if sex==1 & marst==1 & age>17 & age<66
sort year serial pernum
merge year serial pernum using "$path\full child"
drop if _merge==2
keep year serial pernum slwt perwt momloc momrule poploc poprule sploc sprule relate age sex race marst nchild /*racgen00 racdet00*/ racamind racasian racblk racpacis racwht racother racnum bpl citizen yrimmig yrsusa1 yrsusa2 hispan school educrec educ99 gradeatt schltype empstat labforce occ ind wkswork1 uhrswork inctot incwage incinvst migplac5 migmet5 migtype5 migtyp00 migcity5 migpuma migpumas movedin incbus00 classwkd qwkswork quhrswor qincbus qincinvs qincwage qbpl qyrimm speakeng occmo nchm0-nchf19plus
for var pernum slwt perwt momloc momrule poploc poprule sploc sprule relate age sex race marst nchild /*racgen00 racdet00*/ racamind racasian racblk racpacis racwht racother racnum bpl citizen yrimmig yrsusa1 yrsusa2 hispan school educrec educ99 gradeatt schltype empstat labforce occ ind wkswork1 uhrswork inctot incwage incinvst migplac5 migmet5 migtype5 migtyp00 migcity5 migpuma migpumas movedin incbus00 classwkd qwkswork quhrswor qincbus qincinvs qincwage qbpl qyrimm speakeng occmo nchm0-nchf19plus: rename X spX
rename sppernum sploc
sort year serial sploc
save "$path\Census 2000 Husb data", replace

use "$path\Census 2000 data", clear
keep if sex==2 & marst==1 & age>17 & age<66
sort year serial pernum
merge year serial pernum using "$path\full child"
drop if _merge==2
keep year datanum serial numprec subsamp hhwt region stateicp statefip metro city gq gqtype vacancy pernum slwt perwt momloc momrule poploc poprule sploc sprule relate age sex race marst nchild /*racgen00 racdet00*/ racamind racasian racblk racpacis racwht racother racnum bpl citizen yrimmig yrsusa1 yrsusa2 hispan school educrec educ99 gradeatt schltype empstat labforce occ ind wkswork1 uhrswork inctot incwage incinvst migplac5 migmet5 migtype5 migtyp00 migcity5 migpuma migpumas movedin incbus00 classwkd qwkswork quhrswor qincbus qincinvs qincwage qbpl qyrimm speakeng occmo nchm0-nchf19plus
sort year serial sploc

joinby year serial sploc using "$path\Census 2000 Husb data"
*merge year serial sploc using "$path\Census 2000 Husb data"
*keep if _merge==3
*drop _merge

for num 0/18: replace nchmX=nchmX+spnchmX
replace nchm19plus=nchm19plus+spnchm19plus
for num 0/18: replace nchfX=nchfX+spnchfX
replace nchf19plus=nchf19plus+spnchf19plus
drop spnchm0-spnchf19plus
****drop if p_stat==2|spp_stat==2
****drop if h_type==9
gen nchtot= nchm0+ nchm1+ nchm2+ nchm3+ nchm4+ nchm5+ nchm6+ nchm7+ nchm8+ nchm9+ nchm10+ nchm11+ nchm12+ nchm13+ nchm14+ nchm15+ nchm16+ nchm17+ nchm18+ nchm19plus+nchf0+ nchf1+ nchf2+ nchf3+ nchf4+ nchf5+ nchf6+ nchf7+ nchf8+ nchf9+ nchf10+ nchf11+ nchf12+ nchf13+ nchf14+ nchf15+ nchf16+ nchf17+ nchf18+ nchf19plus

erase "$path\full child.dta"
erase "$path\Census 2000 Husb data.dta"
save "$path\Census 2000 Wife data", replace


*The following creates a dataset for single men
use "$path\Census 2000 data", clear
keep if sex==1 & marst~=1 & age>17 & age<66
/*To use the next two lines, I would have to alter the child dataset code so that I only used poploc as the parent locator
merge year serial pernum using "$path\full child"
drop if _merge==2*/
keep year datanum serial numprec subsamp hhwt region stateicp statefip metro city gq gqtype vacancy pernum slwt perwt momloc momrule poploc poprule sploc sprule relate age sex race marst nchild /*racgen00 racdet00*/ racamind racasian racblk racpacis racwht racother racnum bpl citizen yrimmig yrsusa1 yrsusa2 hispan school educrec educ99 gradeatt schltype empstat labforce occ ind wkswork1 uhrswork inctot incwage incinvst migplac5 migmet5 migtype5 migtyp00 migcity5 migpuma migpumas movedin incbus00 classwkd qwkswork quhrswor qincbus qincinvs qincwage qbpl qyrimm speakeng occmo

sort year serial sploc
save "$path\Census 2000 Single Men data", replace


*The following creates a dataset for single women
use "$path\Census 2000 data", clear
keep year serial pernum age sex marst momloc poploc nchild
gen parent=momloc

sort year serial pernum
save "$path\interim", replace
keep if sex==2 & marst~=1 & age>17 & age<66
save "$path\full child", replace

local i=0
while `i'<19 {
	use  "$path\interim", clear

	keep if age==`i' & sex==1 & marst~=1 & nchild==0 & parent~=0

	for num 1/26: gen parentnoX=cond(parent==X,1,0)
	collapse (sum) parentno*, by(year serial)
	reshape long parentno, i(year serial) j(pernum)
	rename parentno nchm`i'
	sort year serial pernum
	save "$path\children`i'", replace

	use "$path\full child", clear
	merge year serial pernum using "$path\children`i'"
	drop if _merge==2
	drop _merge
	sort year serial pernum
	save "$path\full child", replace
	erase "$path\children`i'.dta"
	local i=`i'+1
	}

use  "$path\interim", clear

keep if age>18 & sex==1 & marst~=1 & nchild==0 & parent~=0

for num 1/26: gen parentnoX=cond(parent==X,1,0)
collapse (sum) parentno*, by(year serial)
reshape long parentno, i(year serial) j(pernum)
rename parentno nchm19plus
*Next line added to save space
drop if nchm19plus==0
sort year serial pernum
save "$path\children19", replace

use "$path\full child", clear
merge year serial pernum using "$path\children19"
drop if _merge==2
drop _merge
sort year serial pernum
save "$path\full child", replace
erase "$path\children19.dta"


local i=0
while `i'<19 {
	use  "$path\interim", clear

	keep if age==`i' & sex==2 & marst~=1 & nchild==0 & parent~=0

	for num 1/26: gen parentnoX=cond(parent==X,1,0)
	collapse (sum) parentno*, by(year serial)
	reshape long parentno, i(year serial) j(pernum)
	rename parentno nchf`i'
	sort year serial pernum
	save "$path\children`i'", replace

	use "$path\full child", clear
	merge year serial pernum using "$path\children`i'"
	drop if _merge==2
	drop _merge
	sort year serial pernum
	save "$path\full child", replace
	erase "$path\children`i'.dta"
	local i=`i'+1
	}

use "$path\interim", clear

keep if age>18 & sex==2 & marst~=1 & nchild==0 & parent~=0

for num 1/26: gen parentnoX=cond(parent==X,1,0)
collapse (sum) parentno*, by(year serial)
reshape long parentno, i(year serial) j(pernum)
rename parentno nchf19plus
*Next line added to save space
drop if nchf19plus==0
sort year serial pernum
save "$path\children19", replace

use "$path\full child", clear
merge year serial pernum using "$path\children19"
drop if _merge==2
drop _merge
sort year serial pernum
erase "$path\children19.dta"
erase "$path\interim.dta"

for num 0/18: replace nchmX=0 if nchmX==.
replace nchm19plus=0 if nchm19plus==.
for num 0/18: replace nchfX=0 if nchfX==.
replace nchf19plus=0 if nchf19plus==.

drop age sex marst momloc poploc
save "$path\full child", replace

use "$path\Census 2000 data", clear
keep if sex==2 & marst~=1 & age>17 & age<66
sort year serial pernum
merge year serial pernum using "$path\full child"
drop if _merge==2
keep year datanum serial numprec subsamp hhwt region stateicp statefip metro city gq gqtype vacancy pernum slwt perwt momloc momrule poploc poprule sploc sprule relate age sex race marst nchild /*racgen00 racdet00*/ racamind racasian racblk racpacis racwht racother racnum bpl citizen yrimmig yrsusa1 yrsusa2 hispan school educrec educ99 gradeatt schltype empstat labforce occ ind wkswork1 uhrswork inctot incwage incinvst migplac5 migmet5 migtype5 migtyp00 migcity5 migpuma migpumas movedin incbus00 classwkd qwkswork quhrswor qincbus qincinvs qincwage qbpl qyrimm speakeng occmo nchm0-nchf19plus
gen nchtot= nchm0+ nchm1+ nchm2+ nchm3+ nchm4+ nchm5+ nchm6+ nchm7+ nchm8+ nchm9+ nchm10+ nchm11+ nchm12+ nchm13+ nchm14+ nchm15+ nchm16+ nchm17+ nchm18+ nchm19plus+nchf0+ nchf1+ nchf2+ nchf3+ nchf4+ nchf5+ nchf6+ nchf7+ nchf8+ nchf9+ nchf10+ nchf11+ nchf12+ nchf13+ nchf14+ nchf15+ nchf16+ nchf17+ nchf18+ nchf19plus

sort year serial sploc
erase "$path\full child.dta"
save "$path\Census 2000 Single Women data", replace
