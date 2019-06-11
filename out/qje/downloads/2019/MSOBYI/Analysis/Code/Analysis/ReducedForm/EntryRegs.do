/* EntryRegs.do */
* This file correlates entry with effects in the Homescan data
* Note: Must run StylizedFacts.do before this to get global $HealthVarQDiff.
* Clustering by CTractGroup in addition to household_code increases standard errors by 5-8% in one example regression.

/* STATEMENTS IN TEXT */
** Number of entries experienced in the sample
use $Externals/Calculations/Homescan/HHxQuarterwithEntry.dta, replace
tab CountEntryt_10 
tab CountEntryt_15

collapse (max) CountEntryt_10, by(household_code)

sum CountEntryt_10
local N=r(N)
sum CountEntryt_10 if CountEntryt_10==0
local Share0=r(N)/`N'*100
sum CountEntryt_10 if CountEntryt_10==1
local Share1=r(N)/`N'*100
*sum CountEntryt_10 if CountEntryt_10==2
*local S2=r(N)/`N'*100
sum CountEntryt_10 if CountEntryt_10>=2&CountEntryt_10!=.
local Share2Plus=r(N)/`N'*100

foreach var in Share0 Share1 Share2Plus {
	clear
	set obs 1
	gen var = ``var''
	format var %8.0f
	tostring var, replace force u
	outfile var using "Output/NumbersForText/`var'Entries.tex", replace noquote
}

** Share of sample lives in food deserts
use $Externals/Calculations/Homescan/HHxQuarterwithEntry.dta, replace
sum panel_year
local N = r(N)
sum panel_year if est_LargePre==0
local FDShare = r(N)/`N'
display "`FDShare'"
clear
set obs 1
gen var = `FDShare'*100
format var %8.0f
tostring var, replace force u
outfile var using "Output/NumbersForText/Entry_FDSampleShare.tex", replace noquote

********************************************************************************
********************************************************************************

/* FIGURES WITH TDLINX ENTRY */
global YVarList =  "expshare_Eretailer FD_expshare_Eretailer expshare_GSC FD_expshare_GSC lHEI_per1000Cal FD_lHEI_per1000Cal" // HealthIndex_per1000Cal FD_HealthIndex" // lnCalories expshare_AEntrant expshare_ACSC expshare_NonChainGroc expshare_DrugConv FreshProduce Produce
global Fig = "Output/ReducedForm/Figures" 
global WindowList = "408 808" //  
global dlist = "10 15" // 015
global slist = "1" // "1 2" specifications


foreach YVar in $YVarList {
	foreach window in $WindowList {
		use $Externals/Calculations/Homescan/HHxQuarterwithEntry.dta, replace
		*** Data prep
		** Food desert subsamples, and create YVar with appropriate name
		if strpos("`YVar'","FD_")!=0 {
			* Estimates in food desert sample only
			local `YVar'orig = subinstr("`YVar'","FD_","",.)
			gen `YVar' = ``YVar'orig'
			keep if est_LargePre==0
		}
		
		*** Make the PostEntryt indicators 0 if in the Balanced window but not part of the entry being studied. 
			* This is necessary only for cases where the pre-window is part of the end of the post-window for a previous entry that occurred more than 3 quarters before, or when the post-window is part of the pre-window for a later entry that occurs more than 8 quarters later.
		local prewindow = real(substr("`window'",1,1))
		local postwindow = real(substr("`window'",2,2))
		local begin = 10-`prewindow'
		local end = 10+`postwindow'
		foreach d in 10 15 {
		forvalues q = `begin'/`end' {
			replace Q`q'PostEntryt_`d' = 0 if Balanced`window'_`d'==1 & Balanced`window'_`d'_begin[_n+10-`q']!=1
		}
		}
		* Note: reg delivers almost identical estimates as areg here because of the strictly balanced panel. We use areg just to make the regressions as symmetric as possible with the tables.
		if "`window'" == "808" {
			local extraleads_10 = "c.Q2PostEntryt_10 c.Q3PostEntryt_10 c.Q4PostEntryt_10 c.Q5PostEntryt_10 c.Q6PostEntryt_10"
			local extraleads_15 = "c.Q2PostEntryt_15 c.Q3PostEntryt_15 c.Q4PostEntryt_15 c.Q5PostEntryt_15 c.Q6PostEntryt_15"
		}
		else if "`window'" == "608" {
			local extraleads_10 = "c.Q4PostEntryt_10 c.Q5PostEntryt_10 c.Q6PostEntryt_10"
			local extraleads_15 = "c.Q4PostEntryt_15 c.Q5PostEntryt_15 c.Q6PostEntryt_15"
		}
		else if "`window'" == "508" {
			local extraleads_10 = "c.Q5PostEntryt_10 c.Q6PostEntryt_10"
			local extraleads_15 = "c.Q5PostEntryt_15 c.Q6PostEntryt_15"
		}
		else if "`window'" == "408" {
			local extraleads_10 = "c.Q6PostEntryt_10"
			local extraleads_15 = "c.Q6PostEntryt_15"
			local extraleads_015 = "c.Q6PostEntryt_015"
		}
		else if "`window'" == "308" {
			local extraleads_10 = ""
			local extraleads_15 = ""
			local extraleads_015 = ""
		}
		else if "`window'" == "612" {
			local extraleads_10 = "c.Q4PostEntryt_10 c.Q5PostEntryt_10 c.Q6PostEntryt_10 c.Q19PostEntryt_10 c.Q20PostEntryt_10 c.Q21PostEntryt_10 c.Q22PostEntryt_10"
			local extraleads_15 = "c.Q4PostEntryt_15 c.Q5PostEntryt_15 c.Q6PostEntryt_15 c.Q19PostEntryt_15 c.Q20PostEntryt_15 c.Q21PostEntryt_15 c.Q22PostEntryt_15"
		}
		else if "`window'" == "412" {
			local extraleads_10 = "c.Q6PostEntryt_10 c.Q19PostEntryt_10 c.Q20PostEntryt_10 c.Q21PostEntryt_10 c.Q22PostEntryt_10"
			local extraleads_15 = "c.Q6PostEntryt_15 c.Q19PostEntryt_15 c.Q20PostEntryt_15 c.Q21PostEntryt_15 c.Q22PostEntryt_15"
		}
		else {
			error: need to code extraleads
		}
	
	** For 0-10 and 10-15 separately
	/*
	** Separate for each distance
	foreach d in `dlist' {
		if "`YVar'" == "expshare_E" {
			capture drop expshare_E
			gen expshare_E = expshare_E`window'_`d' 
		}	
		reghdfe `YVar' c.Balanced`window'_`d'#(`extraleads_`d'' c.Q7PostEntryt_`d' c.Q8PostEntryt_`d' c.Q10PostEntryt_`d' c.Q11PostEntryt_`d' ///
			c.Q12PostEntryt_`d' c.Q13PostEntryt_`d' c.Q14PostEntryt_`d' c.Q15PostEntryt_`d' c.Q16PostEntryt_`d' c.Q17PostEntryt_`d' c.Q18PostEntryt_`d') Balanced`window'_`d' ///
			i.RegionYQ $Ctls, robust cluster(household_code) absorb(household_location)
		est store F1`YVar'`window' // F for figure
	}
	*/
	** Combined in one regression
	reghdfe `YVar' c.Balanced`window'_10#(`extraleads_10' c.Q7PostEntryt_10 c.Q8PostEntryt_10 c.Q10PostEntryt_10 c.Q11PostEntryt_10 ///
			c.Q12PostEntryt_10 c.Q13PostEntryt_10 c.Q14PostEntryt_10 c.Q15PostEntryt_10 c.Q16PostEntryt_10 c.Q17PostEntryt_10 c.Q18PostEntryt_10) Balanced`window'_10 ///
			c.Balanced`window'_15#(`extraleads_15' c.Q7PostEntryt_15 c.Q8PostEntryt_15 c.Q10PostEntryt_15 c.Q11PostEntryt_15 ///
			c.Q12PostEntryt_15 c.Q13PostEntryt_15 c.Q14PostEntryt_15 c.Q15PostEntryt_15 c.Q16PostEntryt_15 c.Q17PostEntryt_15 c.Q18PostEntryt_15) Balanced`window'_15 ///
			$Ctls, vce(cluster household_code CTractGroup) absorb(household_location RegionYQ) //
		est store F1`YVar'`window' // F for figure
	
	/*
	** For the full 0-15 minute range
	reghdfe `YVar' c.Balanced`window'_015#(`extraleads_015' c.Q7PostEntryt_015 c.Q8PostEntryt_015 c.Q10PostEntryt_015 c.Q11PostEntryt_015 ///
			c.Q12PostEntryt_015 c.Q13PostEntryt_015 c.Q14PostEntryt_015 c.Q15PostEntryt_015 c.Q16PostEntryt_015 c.Q17PostEntryt_015 c.Q18PostEntryt_015) Balanced`window'_015 ///
			i.RegionYQ $Ctls, robust cluster(household_code) absorb(household_location)
		est store F2`YVar'`window' // F for figure
	*/
			*****************************************************************************
	}
}




/* Make and save graphs */
*** Save graph data
clear 
set obs 21
gen Q=_n+1
gen QuartersAfter = Q-10



foreach YVar in $YVarList {
	foreach window in $WindowList {
	foreach s in $slist { // specification
		est restore F`s'`YVar'`window'
		local YVarShort = substr("`YVar'",1,15)
		foreach d in $dlist {	// 15 10
			* The specs above don't include all distances.
			if ("`s'"=="1" & "`d'"=="015") | ("`s'"=="2" & "`d'"!="015") {
				continue
			}
			foreach param in b se {
				gen `param'_`s'`YVarShort'`window'_`d' = 0

				forvalues Q = 2/22 { // 5/23 {
					capture replace `param'_`s'`YVarShort'`window'_`d' = _`param'[Balanced`window'_`d'#Q`Q'PostEntryt_`d'] if Q==`Q' // 
				}		
			}

			* Confidence intervals	
			gen ci_`s'`YVarShort'`window'_`d'_l = b_`s'`YVarShort'`window'_`d' - $tstat*se_`s'`YVarShort'`window'_`d'
			gen ci_`s'`YVarShort'`window'_`d'_u = b_`s'`YVarShort'`window'_`d' + $tstat*se_`s'`YVarShort'`window'_`d'
		}
	}
	}
}


save $Externals/Calculations/StoreEntryExit/StoreEntryFigure.dta, replace



*** Make graphs
graph drop _all

foreach s in $slist { // specification
	foreach window in $WindowList {
		local prewindow = real(substr("`window'",1,1))
		local postwindow = real(substr("`window'",2,2))
		use $Externals/Calculations/StoreEntryExit/StoreEntryFigure.dta, replace, ///
			if QuartersAfter>=-`prewindow'&QuartersAfter<=`postwindow'
			
		foreach YVar in $YVarList {
			local YVarShort = substr("`YVar'",1,15)
			
			
			** Set labels
			local outcome = "`YVar'"
			include Code/Analysis/StylizedFacts/FigureTitles.do
			if strpos("`YVar'","expshare") != 0 {
				local yaxis="yscale(range(-1 3)) ylabel(-1(1)3)"
			}
			/*
			if "`YVar'" == "Produce" {
				local yaxis="yscale(range(-.4 .4)) ylabel(-.4(0.1).4)"
			}
			if "`YVar'" == "HealthIndex_FD" {
				local yaxis="yscale(range(-.05 .05)) ylabel(-.05(0.05).05)"
			}
			*/
			if strpos("`YVar'","lHEI_per1000Cal") != 0 {
				local yaxis="yscale(range(-.05 .05)) ylabel(-.05(0.05).05)"
			}
			/*
			** All distances without confidence intervals
			twoway (line b_`s'`YVarShort'`window'* QuartersAfter, ///
						lp(dash_dot l) lcolor(black blue ) lwidth(medthick medthick)), /// dash_dot - orange maroon
						title("`title'") ytitle("`ytitle'") ///  
						xtitle("Quarters after entry") xlabel(-4(4)8)  ///
						legend(label(1 "0-10 minutes") label(2 "10-15 minutes")) ///
						xline(-1, lp(dash) lw(thin) lc(maroon)) ///
						graphregion(color(white) lwidth(medium))

					graph export Output/ReducedForm/Figures/Entry`s'`YVar'`window'.pdf, as(pdf) replace
			*/
			
			** Within d minutes with confidence intervals
			if "`window'" == "808" {
				local xlabel = "xlabel(-8(4)8)"
			}
			else {
				local xlabel = "xlabel(-4(4)8)"
			}
			foreach d in $dlist {
					twoway (line b_`s'`YVarShort'`window'*_`d' ci_`s'`YVarShort'`window'_`d'_l ci_`s'`YVarShort'`window'_`d'_u QuartersAfter, ///
						lp(l - -) lcolor(navy gs8 gs8) lwidth(medthick medthin medthin) `yaxis'), /// 
						title("`title'") ytitle("`ytitle'") /// 
						xtitle("Quarters after entry") `xlabel' ///
						legend(off) ///
						xline(-1, lp(dash) lw(thin) lc(maroon)) ///
						graphregion(color(white))
						
					graph export $Fig/Entry`s'`YVar'`window'`d'.pdf, as(pdf) replace
					graph save $Fig/Entry`s'`YVar'`window'`d', replace	
			}
		}

		foreach d in $dlist {
			graph combine $Fig/Entry`s'expshare_Eretailer`window'`d'.gph $Fig/Entry`s'FD_expshare_Eretailer`window'`d'.gph  ///
				$Fig/Entry`s'expshare_GSC`window'`d'.gph $Fig/Entry`s'FD_expshare_GSC`window'`d'.gph ///
			   $Fig/Entry`s'lHEI_per1000Cal`window'`d'.gph  $Fig/Entry`s'FD_lHEI_per1000Cal`window'`d'.gph , ///
				graphregion(color(white) lwidth(medium)) ///
				rows(3) cols(2) xcommon 
				
				graph export $Fig/Entry`s'Figures`window'`d'.pdf, as(pdf) replace
		}
	}
	
}

*******************************************************************************
*******************************************************************************

capture log close
log using Output/LogFiles/RetailerEntryRegs.log, replace

/* ESTIMATES FOR TABLE - TDLINX ENTRY */
global YVarList = "expshare_Eretailer expshare_GSC expshare_DrugConv lHEI_per1000Cal" // expshare_OtherMass HealthIndex_per1000Cal HEI_per1000Cal expshare_NonChainGroc Produce lnCalories" // expshare_AEntrant expshare_ACSC
foreach EntryType in Supercenter All { // MUST DO "ALL" LAST BECAUSE THE BOUNDING CALCULATION BELOW USES THE MOST RECENT BOTTOM-QUARTILE ESTIMATES THAT WERE STORED.
	foreach YVar in $YVarList {
	
	*** Set up data
	use $Externals/Calculations/Homescan/HHxQuarterwithEntry.dta, replace
	local YVarSub = substr("`YVar'",1,13)
	local Regression = "reghdfe `YVar' CountEntryt_10 CountEntryt_15 $Ctls, vce(cluster household_code CTractGroup) absorb(household_location RegionYQ)" // 
	if "`EntryType'" == "Supercenter" {
		if inlist("`YVar'","expshare_DrugConv")==1 { 
			continue // No need to estimate this for supercenters
		}
		if "`YVar'" == "expshare_Eretailer" {
			replace expshare_Eretailer = expshare_ESretailer // Use entrant supercenter expenditures instead of all entrant expenditures
		}
		* Use the Supercenter entry count variables
		replace CountEntryt_10 = CountEntryt_S_10
		replace CountEntryt_15 = CountEntryt_S_15
	}
	
	** Drop unneeded variables
	drop Q*PostEntryt_*
	
	*** Run regressions
	* Full sample
	`Regression'
		est store `YVarSub'Base
		sum `YVar' if e(sample)
		estadd scalar YVarMean = r(mean)
		local CIu = _b[CountEntryt_10] + 1.96*_se[CountEntryt_10]
		estadd scalar UB `CIu'	
	
	* Low-income
	`Regression', if IncomeResidQuartile==1
		est store `YVarSub'LI
		sum `YVar'  if e(sample)
		estadd scalar YVarMean = r(mean)
		local CIu = _b[CountEntryt_10] + 1.96*_se[CountEntryt_10]
		estadd scalar UB `CIu'
	
	* Food deserts
	`Regression', if est_LargePre==0
		est store `YVarSub'FD
		sum `YVar'  if e(sample)
		estadd scalar YVarMean = r(mean)
		local CIu = _b[CountEntryt_10] + 1.96*_se[CountEntryt_10]
		estadd scalar UB `CIu'

	
	if "`YVar'" == "$HealthVar" & "`EntryType'"!="Supercenter" { // Then also run regressions using alternative food desert definitions
	** Underserved "food desert" subsample
	`Regression', if NProduceUPCsPre<=1 // 1000 (this variable is in thousands)
		est store `YVarSub'AFD1
		sum `YVar'  if e(sample)
		estadd scalar YVarMean = r(mean)
		local CIu = _b[CountEntryt_10] + 1.96*_se[CountEntryt_10]
		estadd scalar UB `CIu'
	
	`Regression', if est_LargePre==0&est_LSmallGrocPre==0
		est store `YVarSub'AFD2
		sum `YVar'  if e(sample)
		estadd scalar YVarMean = r(mean)
		local CIu = _b[CountEntryt_10] + 1.96*_se[CountEntryt_10]
		estadd scalar UB `CIu'
		
	`Regression', if est_Large_3mPre==0
		est store `YVarSub'AFD3
		sum `YVar'  if e(sample)
		estadd scalar YVarMean = r(mean)
		local CIu = _b[CountEntryt_10] + 1.96*_se[CountEntryt_10]
		estadd scalar UB `CIu'
	}
	}
	
	*** Output tables for paper
	if "`EntryType'" == "All" {
		** Panel A: Expenditure shares
		esttab expshare_EretBase expshare_GSCBase expshare_EretLI expshare_GSCLI expshare_EretFD expshare_GSCFD using "Output/ReducedForm/RetailerEntry_Exp.tex", replace ///
				b(%8.3f) se(%8.3f) /// 
				keep(CountEntryt_10 CountEntryt_15) ///
				mtitles("Entrants" "\shortstack{Grocery/ \\ super/club}" "Entrants" "\shortstack{Grocery/ \\ super/club}" "Entrants" "\shortstack{Grocery/ \\ super/club}") ///
				mgroups("\underline{Full sample}" "\underline{Bottom quartile}" "\underline{Food deserts}", pattern(1 0 1 0 1 0) span prefix(\multicolumn{@span}{c}{)suffix(})) /// 
				stats(N YVarMean, l("Observations" "Dependent var. mean") fmt(%12.0fc %8.1f)) ///  UB "95% confidence interval upper bound"  %8.3f
				star(* 0.10 ** 0.05 *** 0.01) label nonotes nogaps
				
				
		** Panel B: Healthy eating
		local HealthVarSub = substr("$HealthVar",1,13)
		esttab `HealthVarSub'Base `HealthVarSub'LI `HealthVarSub'FD using "Output/ReducedForm/RetailerEntry_Health.tex", replace ///
				b(%8.3f) se(%8.3f) /// 
				keep(CountEntryt_10 CountEntryt_15) /// 
				nomtitles /// mtitles("\underline{Full sample}" "\underline{Bottom quartile}" "\underline{Food deserts}") /// 
				mgroups("\underline{Full sample}" "\underline{Bottom quartile}" "\underline{Food deserts}", pattern(1 1 1) span prefix(\multicolumn{@span}{c}{)suffix(})) /// 
				stats(N, l("Observations") fmt(%12.0fc)) ///  UB "95% confidence interval upper bound"  %8.3f
				star(* 0.10 ** 0.05 *** 0.01) label nonotes nogaps


		*** Appendix estimates
		/*
		** Panel A: Expenditure shares on less healthful channel types
		* We are seeing small but detectable positive effects on Other Mass in the output RetailerEntry1.tex, which I think is due to occasional misclassification of Walmart Supercenters as Walmart Regular in the Homescan data. So this is not a reliable result.
		esttab expshare_DrugBase expshare_OtheBase expshare_DrugLI expshare_OtheLI expshare_DrugFD expshare_OtheFD using "Output/ReducedForm/RetailerEntry1.tex", replace ///
				b(%8.3f) se(%8.3f) /// 
				keep(CountEntryt_10 CountEntryt_15) ///
				mtitles("\shortstack{Conv/ \\ drug stores}" "\shortstack{Other mass/ \\ merchants}" "\shortstack{Conv/ \\ drug stores}" "\shortstack{Other mass/ \\ merchants}" "\shortstack{Conv/ \\ drug stores}" "\shortstack{Other mass/ \\ merchants}") ///
				mgroups("\underline{Full sample}" "\underline{Bottom quartile}" "\underline{Food deserts}", pattern(1 0 1 0 1 0) span prefix(\multicolumn{@span}{c}{)suffix(})) /// 
				stats(N YVarMean, l("Observations" "Dependent var. mean") fmt(%12.0fc %8.1f)) ///  UB "95% confidence interval upper bound"  %8.3f
				star(* 0.10 ** 0.05 *** 0.01) label nonotes nogaps
		*/
		** Panel A: Expenditure shares on drug/convenience.
		esttab expshare_DrugBase expshare_DrugLI expshare_DrugFD using "Output/ReducedForm/RetailerEntry_DrugConv.tex", replace ///
				b(%8.3f) se(%8.3f) /// 
				keep(CountEntryt_10 CountEntryt_15) ///
				nomtitles ///
				mgroups("\underline{Full sample}" "\underline{Bottom quartile}" "\underline{Food deserts}", pattern(1 1 1) span prefix(\multicolumn{@span}{c}{)suffix(})) /// 
				stats(N YVarMean, l("Observations" "Dependent var. mean") fmt(%12.0fc %8.1f)) ///  UB "95% confidence interval upper bound"  %8.3f
				star(* 0.10 ** 0.05 *** 0.01) label nonotes nogaps
			

		** Panel B: Healthy eating in food deserts with different definitions
		esttab `HealthVarSub'AFD1 `HealthVarSub'AFD2 `HealthVarSub'AFD3 using "Output/ReducedForm/RetailerEntry_AltFD.tex", replace ///
				b(%8.3f) se(%8.3f) /// 
				keep(CountEntryt_10 CountEntryt_15) ///
				nomtitles ///
				mgroups("\underline{$<$1000 produce UPCs}" "\underline{No medium groceries}" "\underline{Three-mile radius}", pattern(1 1 1) span prefix(\multicolumn{@span}{c}{)suffix(})) /// 
				stats(N, l("Observations") fmt(%12.0fc)) ///  UB "95% confidence interval upper bound"  %8.3f
				star(* 0.10 ** 0.05 *** 0.01) label nonotes nogaps
	}
	if "`EntryType'" == "Supercenter" {
		*** Appendix estimates for supercenters only
		** Panel A: Expenditure shares
		esttab expshare_EretBase expshare_GSCBase expshare_EretLI expshare_GSCLI expshare_EretFD expshare_GSCFD using "Output/ReducedForm/RetailerEntry_Exp_Supercenter.tex", replace ///
				b(%8.3f) se(%8.3f) /// 
				keep(CountEntryt_10 CountEntryt_15) ///
				mtitles("Entrants" "\shortstack{Grocery/ \\ super/club}" "Entrants" "\shortstack{Grocery/ \\ super/club}" "Entrants" "\shortstack{Grocery/ \\ super/club}") ///
				mgroups("\underline{Full sample}" "\underline{Bottom quartile}" "\underline{Food deserts}", pattern(1 0 1 0 1 0) span prefix(\multicolumn{@span}{c}{)suffix(})) /// 
				stats(N YVarMean, l("Observations" "Dependent var. mean") fmt(%12.0fc %8.1f)) ///  UB "95% confidence interval upper bound"  %8.3f
				star(* 0.10 ** 0.05 *** 0.01) label nonotes nogaps
				
				
		** Panel B: Healthy eating
		local HealthVarSub = substr("$HealthVar",1,13)
		esttab `HealthVarSub'Base `HealthVarSub'LI `HealthVarSub'FD using "Output/ReducedForm/RetailerEntry_Health_Supercenter.tex", replace ///
				b(%8.3f) se(%8.3f) /// 
				keep(CountEntryt_10 CountEntryt_15) /// 
				nomtitles /// mtitles("\underline{Full sample}" "\underline{Bottom quartile}" "\underline{Food deserts}") /// 
				mgroups("\underline{Full sample}" "\underline{Bottom quartile}" "\underline{Food deserts}", pattern(1 1 1) span prefix(\multicolumn{@span}{c}{)suffix(})) /// 
				stats(N, l("Observations") fmt(%12.0fc)) ///  UB "95% confidence interval upper bound"  %8.3f
				star(* 0.10 ** 0.05 *** 0.01) label nonotes nogaps
	}
}




/* Robustness checks 
* Is entry correlated with within-household income changes?
use $Externals/Calculations/Homescan/HHxQuarterwithEntry.dta, replace
		
reghdfe lnIncome CountEntryt_10 CountEntryt_15 i.RegionYQ, vce(cluster household_code CTractGroup) absorb(household_location RegionYQ)
*/

*** Calculation of bounds of contribution to nutrition-income relationship
use $Externals/Calculations/Homescan/HHxQuarterwithEntry.dta, replace
rename panel_year year
merge m:1 zip_code year using $Externals/Calculations/Geographic/ZipCodeSupplyInfo.dta, nogen keep(match master) ///
	keepusing(est_Large)	
rename year panel_year

merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
		nogen keep(match master) keepusing(projection_factor)


** Average supermarkets for top and bottom quartile
foreach q in 1 4 {
	sum est_Large [aw=projection_factor] if IncomeResidQuartile==`q'
	local Q`q'Supermarkets=r(mean)
}
	
** Difference
local SupermarketsQDiff = `Q4Supermarkets'-`Q1Supermarkets'
	
** Upper bound of 95% CI for low-income households
local HealthVarSub = substr("$HealthVar",1,13)
est restore `HealthVarSub'LI 
local EntryUB = _b[CountEntryt_10] + 1.96*_se[CountEntryt_10]

** Upper bound on contribution to nutrition-income relationship (in percentage points)
if "$HealthVarQDiff"=="" {
	preserve
	use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
	reg $HealthVar ib1.IncomeQuartile $SESCtls i.panel_year [pw=projection_factor], robust cluster(household_code)
	global HealthVarQDiff = _b[4.IncomeQuartile]
	restore
}
local EntryContribution = 100* `EntryUB'*`SupermarketsQDiff'/$HealthVarQDiff

** Output all numbers for text
foreach var in Q1Supermarkets Q4Supermarkets SupermarketsQDiff EntryUB EntryContribution {
	clear
	set obs 1
	gen var = ``var''
	if "`var'" == "UB" {
		format var %8.3f
	}
	else if "`var'" == "Bound"|"`var'" == "EntryContribution" {
		format var %8.1f
	}
	else {
		format var %8.2f
	}
	tostring var, replace force u
	outfile var using "Output/NumbersForText/`var'.tex", replace noquote
}

capture log close 
	
