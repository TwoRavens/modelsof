****************************************************************************************
* This file generates the tables for the paper.
****************************************************************************************

sort uni_numb
eststo clear
macro drop _all
cd "Directory_Path"

use Main_Data.dta

***************************************************************************************************
*** Define arrays of variables 
***************************************************************************************************

** Sets of independent variables

local Ind_Vars corr_crsp_vw ln_iped_avg_allyrs actspending_to_nefi Pub_Priv endow_per_fte_1000
local Ind_Vars `Ind_Vars' prop_admit debt_to_assets res_nefi_ratio doctoral bach_gen bach_la

local IVers perc_tuition perc_govt perc_priv_gift perc_pub_gift

local BR_Var sd_all_rev fte_stdev

local Asset_Class all_equity fi_and_cash alt_assets all_real_estate

***************************************************************************************************
*** Table 1
***************************************************************************************************
estpost summ nefi nefi_fte res_nefi_ratio iped_avg_allyrs debt_to_assets actspending_to_nefi prop_admit, detail
esttab using Sum_Stats.txt, append wide tab nogaps cells("mean sd p25 p50 p75")

estpost summ Pub_Priv  doctoral master bach_gen bach_la, detail
esttab using Sum_Stats.txt, append wide tab nogaps cells("mean sd p25 p50 p75")

estpost summ size2003 endow_per_fte_1000, detail
esttab using Sum_Stats.txt, append wide tab nogaps cells("mean sd p25 p50 p75")

estpost summ size2003 if Pub_Priv==1, detail
esttab using Sum_Stats.txt, append wide tab nogaps cells("mean sd p25 p50 p75")

estpost summ size2003 if Pub_Priv==0, detail
esttab using Sum_Stats.txt, append wide tab nogaps cells("mean sd p25 p50 p75")

estpost summ nacubo_avg_ret nacubo_stdev, detail
esttab using Sum_Stats.txt, append wide tab nogaps cells("mean sd p25 p50 p75")


***************************************************************************************************
*** Table 2
***************************************************************************************************

local Asset_Vars all_equity all_fi all_real_estate alt_assets cash hedge_funds vc private_equity oil_gas commodity

foreach var of local Asset_Vars{
	count if `var'>0
	summ `var' if `var'>0
	summ `var' if `var'>0 [weight=size2003]
}

***************************************************************************************************
*** Table 3
***************************************************************************************************

estpost summ nefi_growth sd_all_rev fte_sd, detail
esttab using Sum_Stats.txt, append wide tab nogaps cells("mean p25 p50 p75")


****************************************************************
*** Table 4
****************************************************************

foreach ivvar of local BR_Var{
	eststo: ivregress liml nacubo_stdev `Ind_Vars' (`ivvar' = `IVers') if nac_std_ret_numb>4 
	estat firststage
	matrix Temp = r(singleresults)
	estadd local FTest=Temp[1,4]
	estat overid
	estadd scalar Overid_Test=r(basmann)
	estadd scalar Numb_Obs=e(N)	
}

esttab using IV_Regs.txt, append b(3) t(2) tab brackets nogaps obslast  star(* 0.10 ** 0.05 *** 0.01) title(`var') addn(" " " ") `Out_Form' nonotes stats(r2 FTest Overid_Test Numb_Obs, fmt(%9.3f))
eststo clear

*****************************************************************
* Tables 5 & 6
*****************************************************************

	**************************************************
	*** Set the constraints for the regressions
	**************************************************

constraint 1 [#1]_b[_cons]+[#2]_b[_cons]+[#3]_b[_cons]+[#4]_b[_cons]=100
constraint 2 [#1]_b[sd_all_rev]+[#2]_b[sd_all_rev]+[#3]_b[sd_all_rev]+[#4]_b[sd_all_rev]=0
constraint 3 [#1]_b[fte_stdev]+[#2]_b[fte_stdev]+[#3]_b[fte_stdev]+[#4]_b[fte_stdev]=0

local Cons_Maker `Ind_Vars' 

local i 4
foreach var of local Ind_Vars{
	constraint `i' [#1]_b[`var']+[#2]_b[`var']+[#3]_b[`var']+[#4]_b[`var']=0
	local ++i
}

	*************************************************
	* Run regressions
	*************************************************
	
foreach key_var of local BR_Var{
	local EQ (all_equity `key_var' `Ind_Vars')
	local FI (fi_and_cash `key_var' `Ind_Vars')
	local AA (alt_assets `key_var' `Ind_Vars')
	local RE (all_real_estate `key_var' `Ind_Vars')
	local IVSD (`key_var' `Ind_Vars' `IVers')

	quietly eststo: reg3 `EQ' `FI' `AA' `RE' `IVSD' `IFFER', constraint(`Constr') small

	local Stater
	local i 1
	local RHS_Vars `key_var' `Ind_Vars' 
	foreach var of local RHS_Vars{
		quietly: test `var'
		quietly: estadd scalar P_Val_`i'=r(p)
		local Stater `Stater' P_Val_`i'
		local ++i
	}
	quietly: test `IVers'
	quietly: estadd scalar F_Val_IVs=r(F)
	quietly: estadd scalar P_Val_IVs=r(p)
	local Stater `Stater' F_Val_IVs P_Val_IVs
	esttab using Reg3.txt, append b(3) t(2) tab brackets nogaps obslast star(* 0.10 ** 0.05 *** 0.01) title(`var') addn(" " " ") nonotes unstack stats(r2 `Stater', fmt(%9.6fc))
	eststo clear
}
constraint drop _all


*****************************************************************
* Table 7
*****************************************************************


	* Set the constraints
	**********************************************

constraint 1 [#1]_b[_cons]+[#2]_b[_cons]+[#3]_b[_cons]+[#4]_b[_cons]+[#5]_b[_cons]+[#6]_b[_cons]=100
constraint 2 [#1]_b[sd_all_rev]+[#2]_b[sd_all_rev]+[#3]_b[sd_all_rev]+[#4]_b[sd_all_rev]+[#5]_b[sd_all_rev]+[#6]_b[sd_all_rev] =0
constraint 3 [#1]_b[fte_stdev]+[#2]_b[fte_stdev]+[#3]_b[fte_stdev]+[#4]_b[fte_stdev]+[#5]_b[fte_stdev]+[#6]_b[fte_stdev] =0

local Cons_Maker `Ind_Vars' 

local i 4
foreach var of local Ind_Vars{
	constraint `i' [#1]_b[`var']+[#2]_b[`var']+[#3]_b[`var']+[#4]_b[`var']+[#5]_b[`var']+[#6]_b[`var']=0
	local ++i
}

	*********************************************
	* Run regressions
	*********************************************

foreach key_var of local BR_Var{
	local EQ (all_equity `key_var' `Ind_Vars')
	local FI (fi_and_cash `key_var' `Ind_Vars')
	local HF (hedge_funds `key_var' `Ind_Vars')
	local VC (vc `key_var' `Ind_Vars')
	local PE (private_equity `key_var' `Ind_Vars')
	local RE (all_real_estate `key_var' `Ind_Vars')
	local IVSD (`key_var' `Ind_Vars' `IVers')

	quietly eststo: reg3 `EQ' `FI' `HF' `VC' `PE' `RE' `IVSD' `IFFER', constraint(`Constr') small

	local Stater
	local i 1
	local RHS_Vars `key_var' `Ind_Vars' 
	foreach var of local RHS_Vars{
		quietly: test `var'
		quietly: estadd scalar P_Val_`i'=r(p)
		local Stater `Stater' P_Val_`i'
		local ++i
	}
	quietly: test `IVers'
	quietly: estadd scalar F_Val_IVs=r(F)
	quietly: estadd scalar P_Val_IVs=r(p)
	local Stater `Stater' F_Val_IVs P_Val_IVs
	esttab using Reg3_Robust.txt, append b(3) t(2) tab brackets nogaps obslast star(* 0.10 ** 0.05 *** 0.01) title(`var') addn(" " " ") nonotes unstack stats(r2 `Stater', fmt(%9.6fc))
	eststo clear
}
constraint drop _all











