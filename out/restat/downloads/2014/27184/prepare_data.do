***************************************************$
*Do-file to prepare data
****************************************************

*Generates basefile.dta which is then used for estimation


use masterfile.dta
sort idnumber year


*****initial cleaning**

drop if avemplfte == 0

replace staffcostfte = (staffcostpart + staffcostfull) if staffcostfte == 0
gen wage = staffcostfte/avemplfte

gen labprod = addedvalue/avemplfte

gen trainlshare = trainl/(avemplfull + avemplpart)
gen traincshare = trainc/staffcostfte
gen trainhshare = trainh / hoursfte


gen traindum = ((trainl > 0) & trainl ~= .)
sort traindum


***cleaning

gen test = wage/labprod
drop if test > 1.5
drop if wage < 0
drop if labprod > 1000
drop if wage > 1000

drop if trainlshare > 2 & trainlshare ~= .
drop if traincshare > 1 & traincshare ~= .
drop if trainhshare > 1 & trainhshare ~= .

qui{
***************************************************
*//dropping gaps, keeping only consecutive years > 2
****************************************************
*******from do-file damiaan*************************

local req = 2

** give a list of variables that are required to have consecutive observations.

local list "avemplfte"

tsset
di "`r(panelvar)'"
di "`r(timevar)'"
local panelvar  `r(panelvar)'
local timevar  `r(timevar)'

sort `panelvar' `timevar'
fillin `panelvar' `timevar' 

sum `timevar'

local list = "`list' " + "`panelvar' " + "`timevar'"
di "list of required variables = `list'"

** new temporary time variable
gen _year2 = `timevar'

*** make holes in new timevar if variables are missing
foreach var of local list {
replace _year2 = . if `var' == .
}

** which years are part of a consecutive block? 
** trick: calculate all possible "moving sums" of length 'req' for each year

local from = 0
local to = `req' - 1
forvalues i = 1/`req' {
egen _average`i' = filter(_year2), lags(`from'/`to')
local from = `from' - 1
local to = `to' - 1
}

** a certain year is part of a block if any of all possible 
** moving averages of length 'req' could be calculated for that year
gen partofblock = 0
for varlist _average*: replace partofblock = 1 if X ~= .
gen tobedropped = 0
replace tobedropped = 1 if partofblock == 0


** now find the last available year which is part of a block

egen lastnonmissingyeartmp = lastnm(_year2) if partofblock == 1 /*
	*/, by(`panelvar')
egen lastnonmissingyear = mean(lastnonmissingyeartmp), by(`panelvar')

** the years more recent than the first block are to be dropped.
bysort `panelvar': replace tobedropped = 1 if year > lastnonmissingyear

** which years are missing?
gen missingyears = year if _year2 == . 
** the years older than the missing year preceding the first block are to be dropped
egen lastmissingyeartmp = lastnm(missingyears) if year < lastnonmissingyear, by(`panelvar')
egen lastmissingyear = mean(lastmissingyeartmp), by(`panelvar')

replace lastmissingyear = 0 if lastmissingyear == .

bysort `panelvar': replace tobedropped = 1 if year <= lastmissingyear

drop _year2 _fillin _average* partofblock lastnonmissingyeartmp /* 
	*/ lastnonmissingyear missingyears lastmissingyeartmp lastmissingyear


************************************************************************************
************************************************************************************
************************************************************************************
}


drop if tobedropped == 1


*****making variables for estimation
replace GO_P = GO_P*100
tsset mark year
gen lGO_P = l.GO_P					//no observations from EU klems for the year 2006
replace GO_P = 1.023*lGO_P if year == 2006

gen av = ln(addedvalue/ppi_PRIN) if ppi_PRIN ~= .
replace av = ln(addedvalue/GO_P) if ppi_PRIN == .
label var av "Log deflated value added"
gen k = ln(tangibleassetstheur/capitaldefl)
label var k "Log deflated capital stock"
gen l = ln(avemplfte)
label var l "Log labor"
gen m = ln(rawmaterialsconsumables/ppi_PRIN)
replace m = ln(rawmaterialsconsumables/GO_P) if ppi_PRIN == .
label var m "Log deflated raw materials"
********************************

********training intensity variables****

gen avtrainc = trainc/avemplfte
gen avtrainh = trainh/avemplfte  

*****other variables
gen femshare = endemplffte/endemplfte
gen manshare = endemplmanfte/endemplfte
gen bedienshare = endemplbedienfte/endemplfte
gen othshare = endemplothfte/endemplfte

