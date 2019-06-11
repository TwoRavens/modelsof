clear mata
clear all
set seed 1234
local it = 1000

use "$basein/Student_School_House_Teacher_Char.dta", clear


capture drop Z_*_T1
capture drop Z_*_T5
capture drop Z_*_T4
capture drop Z_*_T8
capture drop Z_*_B_T7
capture drop Z_*_C_T7

drop if upid==""
bys upid: gen N=_N
drop if Z_hisabati_T7==. & N==2
keep treatarm treatment Z*_T* $treatmentlist DistID  $schoolcontrol HHSize MissingHHSize IndexPoverty MissingIndexPoverty IndexEngagement MissingIndexEngagement LagExpenditure MissingLagExpenditure LagseenUwezoTests LagpreSchoolYN Lagmale LagAge LagGrade LagZ_kiswahili LagZ_hisabati LagZ_kiingereza LagZ_ScoreFocal  WeekIntvTest_T* upid SchoolID
reshape long Z_kiswahili_T@ Z_hisabati_T@ Z_kiingereza_T@ Z_ScoreFocal_T@ , i(upid) j(T) string
encode T, gen(T2)


replace LagGrade=LagGrade-1 if T=="3"
foreach var in Z_kiswahili Z_kiingereza Z_hisabati Z_ScoreFocal{
	reg Lag`var' i.T2##(c.LagseenUwezoTests c.LagpreSchoolYN c.Lagmale c.LagAge i.DistID i.LagGrade c.($schoolcontrol $HHcontrol) ), vce(cluster SchoolID) 
	predict LagResid_`var', resid
	reg `var'_T i.T2##(c.LagseenUwezoTests c.LagpreSchoolYN c.Lagmale c.LagAge i.DistID i.LagGrade c.($schoolcontrol $HHcontrol) ), vce(cluster SchoolID) 
	predict Resid_`var'_T, resid
}




keep LagResid_Z_kiswahili- Resid_Z_ScoreFocal_T SchoolID treatment treatarm LagGrade T T2

tempfile tempresults
tempfile tempBoot
save `tempresults', replace

*Z_kiswahili Z_kiingereza Z_hisabati
foreach period in 3 7{
	foreach treat in COD Both CG{
		foreach subject in Z_ScoreFocal  {
			foreach grade in 4 {
			
				use `tempresults', clear


				drop if (treatment!="`treat'" & treatment!="Control")
				if(`grade'!=4){
				drop if LagGrade!=`grade'
				}
				keep treatment SchoolID LagResid_`subject' Resid_`subject'_T T T2
				drop if T!="`period'"
				compress
				save `tempBoot', replace

				qui egen kernel_range = fill(.01(.01)1)
				qui replace kernel_range = . if kernel_range>1
				mkmat kernel_range if kernel_range != .
				matrix diff = kernel_range
				matrix x = kernel_range


				quietly forvalues j = 1(1)`it' {
					use `tempBoot', clear
					bsample, strata(treatment) cluster(SchoolID)


					bysort treatment: egen rank`subject' = rank(LagResid_`subject'), unique
					bysort treatment: egen max_rank`subject' = max(rank`subject')
					bysort treatment: gen LagPctileResid_`subject' = rank`subject'/max_rank`subject' 



					egen kernel_range = fill(.01(.01)1)
					qui replace kernel_range = . if kernel_range>1

					*regressing endline scores on percentile rankings
					lpoly Resid_`subject'_T LagPctileResid_`subject' if treatment=="Control" , gen(xcon pred_con) at (kernel_range) nograph
					lpoly Resid_`subject'_T LagPctileResid_`subject' if treatment=="`treat'" , gen(xtre pred_tre) at (kernel_range) nograph
						
						
					mkmat pred_tre if pred_tre != . 
					mkmat pred_con if pred_con != . 
					matrix diff = diff, pred_tre - pred_con

				}

				matrix diff = diff'



				*each variable is a percentile that is being estimated (can sort by column to get 2.5th and 97.5th confidence interval)
				svmat diff
				keep diff* 

				matrix conf_int = J(100, 2, 100)
				qui drop if _n == 1

				*sort each column (percentile) and saving 25th and 975th place in a matrix
				forvalues i = 1(1)100{
				sort diff`i'
				matrix conf_int[`i', 1] = diff`i'[0.025*`it']
				matrix conf_int[`i', 2] = diff`i'[0.975*`it']	
				}

				*******************Graphs for control, treatment, and difference using actual data (BASELINE)*************************************
				use `tempBoot', clear
				  
				bysort treatment: egen rank`subject' = rank(LagResid_`subject'), unique
				bysort treatment: egen max_rank`subject' = max(rank`subject')
				bysort treatment: gen LagPctileResid_`subject' = rank`subject'/max_rank`subject' 


				egen kernel_range = fill(.01(.01)1)
				qui replace kernel_range = . if kernel_range>1


				lpoly Resid_`subject'_T LagPctileResid_`subject' if treatment=="Control" , gen(xcon pred_con) at (kernel_range) nograph
				lpoly Resid_`subject'_T LagPctileResid_`subject' if treatment=="`treat'" , gen(xtre pred_tre) at (kernel_range) nograph

				gen diff = pred_tre - pred_con

				*variables for confidence interval bands
				svmat conf_int


				if "`subject'"=="Z_kiswahili" local name3 Swahili
				else if "`subject'"=="Z_kiingereza"  local name3 English	
				else if "`subject'"=="Z_hisabati" local name3 Math
				else if "`subject'"=="Z_ScoreFocal" local name3 "Index (PCA)"


				if "`grade'"=="1" local name4 1
				else if "`grade'"=="2"  local name4 2	
				else if "`grade'"=="3" local name4 3
				else if "`grade'"=="4" local name4 All

				if "`treat'"=="COD" local name5 "Incentives"
				else if "`treat'"=="Both"  local name5 "Combo"	
				else if "`treat'"=="CG" local name5 "Grants"



				graph twoway (line pred_con xcon, lcolor(blue) lpattern("--.....") legend(lab(1 "Control"))) ///
				(line pred_tre xtre, lcolor(red) lpattern(longdash) legend(lab(2 "Treatment"))) ///
				(line diff xcon, lcolor(black) lpattern(solid) legend(lab(3 "Difference"))) ///
				(line conf_int1 xcon, lcolor(black) lpattern(shortdash) legend(lab(4 "95% Confidence Band"))) ///
				(line conf_int2 xcon, lcolor(black) lpattern(shortdash) legend(lab(5 "95% Confidence Band"))) ///
				,yline(0, lcolor(gs10)) xtitle(Percentile of residual baseline score) ytitle(Residual endline test score) legend(order(1 2 3 4)) ///
				 graphregion(color(white))
				 *title("`name5'-`name3'")
				graph export "$graphs/Lowess_Resid_Percentile_`subject'_`treat'_Pool_`grade'_`period'.pdf", as(pdf) replace


			}
		}
	}

}
