
use "Census_Tax_Linkage\Data\CensusTax.dta", clear

sort census06 id year

keep if age>=25 & age<68

drop if sex==.
drop if province==.
drop if marst==.

replace value=0 if value==.
replace penadj=0 if penadj==.

gen married=(marst==1|marst==2)

replace naics=trunc(naics/1000)

replace hlos=-1 if hlos==.
replace hcdd=-1 if hcdd==.

gen hsgrad_plus=(hlos>=6 | hcdd>=2)
gen tradecert_plus=(hlos>=7 | hcdd>=3)
gen somepse_plus=(hlos>=8 | hcdd>=5)
gen univgrad_plus=(hlos>=18 | hcdd>=9)

gen mandyrs=exit-entry

gen rspnetcont=rspcont-rspwd
gen saving=rspnetcont+penadj
gen rsprate=rspnetcont/totinc
gen penrate=penadj/totinc

gen yearat14sq=yearat14^2

local counter=1991
foreach i of numlist 0.828 0.840 0.856 0.857 0.876 0.889 0.904 0.913 0.929 0.954 0.978 1.000 1.028 1.047 1.070 1.091 1.115 1.144 1.165 {
	foreach x of varlist disability dues rspcont empinc rspwd penadj totinc value {
		replace `x'=(`x'/`i')*1.165 if year==`counter'
	}
	local counter=`counter'+1
}

foreach x of varlist dues empinc penadj totinc rspnetcont {
	gen has_`x'=(`x'>0)
}

foreach x of varlist age married rspnetcont penadj saving disability empinc totinc value has_dues has_empinc has_penadj has_totinc has_rspnetcont {
	by census06 id: egen mean_`x'=mean(`x')
}

egen grp=group(birth_pl yearat14)

save "Census_Tax_Linkage\Data\CensusTax_Education.dta", replace

clear

exit
