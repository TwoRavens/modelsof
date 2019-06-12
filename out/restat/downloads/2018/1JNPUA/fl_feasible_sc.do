set more off
adopath + "/NDrive/SIL-Common/estout/"
set matsize 2000

local d "/NDrive/HospitalChoice-P146101-BE/Work/SwitchCostSandbox"

log using "`d'/Logs/migrantsEstimFeasibleSC_`: di %tdCY-N-D daily("$S_DATE","DMY")'.log", replace

//Import parameters (from R
foreach loc in "minZipHospPpl" "ageCut06"{
    file open fi using "`d'/Param/`loc'.txt", read
    file read fi `loc'
    display "`loc' = ``loc''"
    file close fi
}



use if age06 <= `ageCut06' & nHospChoose > 1 & obs_choice == 1 using "`d'/Data/estimDat_minPpl_all_`minZipHospPpl'.dta", clear

//Generate Groups
g grp = .
local grpIDMax = 0
local round1 = "pat_county pat_zip msdrg payer hispanic"
local round2 = "pat_county pat_zip msdrg payer"
local round3 = "pat_county pat_zip msdrg"
local round4 = "pat_county pat_zip"
local round5 = "pat_county"

g flagFirstBirth =  birthNum==1

forvalues rnd = 1/5{
    egen grpTmp = group(`round`rnd''  ) if grp==.
    egen ngrp = sum(flagFirstBirth), by(`round`rnd'' )
    replace grpTmp = . if ngrp<200
    replace grp = grpTmp + `grpIDMax' if mi(grp)  & !mi(grpTmp)
    drop ngrp grpTmp
    qui sum
    local grpIDMax = `r(max)'
}
replace grp = `grpIDMax' + 1 if mi(grp)

keep grp admission
tempfile personGrpDat
save `personGrpDat',replace

//Compute deltas for first births
merge 1:m admission using "`d'/Data/estimDat_minPpl_all_`minZipHospPpl'.dta", assert(using match) keep(match) nogen

//Compute Deltas based on first births
collapse (count) nGrpHosp = admission if birthNum ==1 & obs_choice == 1, by(grp hosp_id_alt)
egen ngrp = sum(nGrpHosp),by(grp)
g grpHospShr = nGrpHosp/ngrp
g grpHospShr0Temp = grpHospShr if hosp_id_alt == 0
egen grpHospShr0 = min(grpHospShr0Temp), by(grp)
drop grpHospShr0Temp
g deltGrpHosp = log(grpHospShr) - log(grpHospShr0)
replace deltGrpHosp =0 if hosp_id_alt == 0

keep grp hosp_id_alt deltGrpHosp
tempfile grpDeltDat
save `grpDeltDat',replace

use `personGrpDat', clear
merge 1:m admission using "`d'/Data/estimDat_minPpl_all_`minZipHospPpl'.dta", assert(using match) keep(match) nogen
/*This only includes in the choice set hospitals for which there was someone in the group that went to it (for a first birth)*/
merge m:1 grp hosp_id_alt using `grpDeltDat', assert(master match) keep(match) nogen

g honoreSub =  hospSwitchFirst2==1 & noMove3 == 1 & birthNum == 3
g nonFirstBirthSub = birthNum > 1

foreach vari of varlist *Sub{
    clogit obs_choice chosenPrev if `vari'==1, group(admission) difficult iter(20) offset(deltGrpHosp)
    count if e(sample) & obs_choice == 1
    scalar NUnit = `r(N)'
    estadd scalar NUnit
    

    local variNm = regexr("`vari'","Sub","")
    eststo `variNm'

    predict hospChoicePrev
    qui sum hospChoicePrev if birthNum >1 & `vari' == 1 & chosenPrev == 1
    if `r(N)' == 0{
        scalar shrPrevHosp = 0
    }
    else{
        scalar shrPrevHosp = `r(mean)'
    }
        
    estadd scalar shrPrevHosp

    drop hospChoicePrev
}


esttab using "`d'/Results/Switch/feasible_nonfe_estimates_migrants.csv", nostar plain cells(b se) stats(NUnit ratioBeta ratioSE shrPrevHosp) keep(chosenPrev)  replace wide


log close
