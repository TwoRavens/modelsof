set more off
adopath + "/NDrive/SIL-Common/estout/"
set matsize 2000

local d "/NDrive/HospitalChoice-P146101-BE/Work/SwitchCostSandbox"

log using "`d'/Logs/migrantsEstimSC_`: di %tdCY-N-D daily("$S_DATE","DMY")'.log", replace

//Import parameters (from R
foreach loc in "minZipHospPpl" "ageCut06" "feHonoreDist" "feHonoreSwitch"{
    file open fi using "`d'/Param/`loc'.txt", read
    file read fi `loc'
    display "`loc' = ``loc''"
    file close fi
}


use if age06 <= `ageCut06' & nHospChoose > 1 using "`d'/Data/estimDat_minPpl_all_`minZipHospPpl'.dta", clear

//Generate subgroups
g baseSub = 1
g secondBirthSub = birthNum == 2
g honoreSub =  hospSwitchFirst2==1 & noMove3 == 1 & birthNum == 3
g age18Sub = (age06 <= 18 )
g normalLDSub =  normalLD_indic 
g commercialSub = payer == 4 
g medicaidFFSSub =  payer == 2
g moversSub = pat_zip != pat_zip_prev
g sameClinicianSub = (atten_phyid == atten_phyid_prev) & !mi(atten_phyid)


//Baseline and robustness estimates
foreach vari of varlist *Sub{
    
    clogit obs_choice i.hosp_id_alt time_current  chosenPrev if `vari' == 1, group(admission) difficult iter(20) 
    count if e(sample) & obs_choice == 1
    scalar NUnit = `r(N)'
    estadd scalar NUnit

    putexcel set "`d'/Data/hosp_dumvar_agg_lagdv_`vari'",replace
    matrix b = e(b)'
    putexcel A1 = matrix(b), rownames
    !libreoffice4.3 --headless --convert-to csv "`d'/Data/hosp_dumvar_agg_lagdv_`vari'.xlsx" --outdir  "`d'/Data"


    nlcom _b[chosenPrev]/_b[time_current]
    matrix ratioBetaMat = r(b)
    matrix ratioSEMat = r(V)
    scalar ratioBeta = ratioBetaMat[1,1]
    scalar ratioSE = sqrt(ratioSEMat[1,1])
    estadd scalar ratioBeta
    estadd scalar ratioSE

    predict hospChoicePrev
    qui sum hospChoicePrev if birthNum >1 & `vari' == 1 & chosenPrev == 1
    if `r(N)' == 0{
        scalar shrPrevHosp = 0
    }
    else{
        scalar shrPrevHosp = `r(mean)'
    }
        
    estadd scalar shrPrevHosp
    
    local variNm = regexr("`vari'","Sub","")

    eststo `variNm'

    clogit obs_choice i.hosp_id_alt time_current  if `vari' == 1, group(admission) difficult iter(20) 
    count if e(sample) & obs_choice == 1
    scalar NUnit = `r(N)'
    estadd scalar NUnit

    putexcel set "`d'/Data/hosp_dumvar_agg_stlogit_`vari'",replace
    matrix b = e(b)'
    putexcel A1 = matrix(b), rownames
    !libreoffice4.3 --headless --convert-to csv "`d'/Data/hosp_dumvar_agg_stlogit_`vari'.xlsx" --outdir  "`d'/Data"


    predict hospChoicePrevJustTime
    qui sum hospChoicePrevJustTime if birthNum >1 & `vari'==1 & chosenPrev == 1 
    if `r(N)' == 0{
        scalar shrPrevHosp = 0
    }
    else{
        scalar shrPrevHosp = `r(mean)'
    }

    estadd scalar shrPrevHosp

    local variNm = regexr("`vari'","Sub","NoSC")
    
    eststo `variNm'

    drop hospChoicePrev*
}


esttab using "`d'/Results/Switch/naive_estimates_migrants.csv", nostar plain cells(b se) stats(NUnit ratioBeta ratioSE shrPrevHosp) keep(time_current chosenPrev)  replace wide

//First and second choice births
eststo clear
eststo: clogit obs_choice i.hosp_id_alt time_current chosenFirstHosp chosenSecHosp if honoreSub == 1, group(admission) difficult iter(20)
esttab using "`d'/Results/Switch/third_birth_estimates.csv",nostar plain cells(b se) keep(time_current chosen*) replace wide


g offsetVar = time_current * `feHonoreDist' + chosenPrev * `feHonoreSwitch'

foreach vari of varlist baseSub honoreSub{
    clogit obs_choice i.hosp_id_alt,  group(admission) difficult iter(20) offset(offsetVar)
putexcel set "`d'/Data/hosp_dumvar_agg_fe_`vari'",replace
matrix b = e(b)'
putexcel A1 = matrix(b), rownames
!libreoffice4.3 --headless --convert-to csv "`d'/Data/hosp_dumvar_agg_fe_`vari'.xlsx" --outdir  "`d'/Data"
}


log close
