// *************************************************************************************************
// * ANALYSIS DO FILE FOR APPENDICES OF "WORMS AT WORK: LONG-RUN IMPACTS OF A CHILD HEALTH INVESTMENT"
// * SARAH BAIRD, JOAN HAMORY HICKS, MICHAEL KREMER, AND EDWARD MIGUEL
// * DATE: JULY 2016 
// *************************************************************************************************

// NOTE: THIS DO FILE PRODUCES THE TABLES, FIGURES, AND IN-TEXT RESULTS PRESENTED IN THE APPENDICES OF BAIRD ET AL. (2016)

// Preamble
	version 10.1
	clear
	set mem 750m
	set matsize 800
	cap log close
	set more off
	
// Folder structure
	global dir   = "" // UPDATE THIS FOLDER FOR YOUR MACHINE
	global da   = "$dir/data"
	global dl    = "$dir/output" 
	global output = "$dir/output"

// Start log file and date
	log using "$dl/Baird-etal-QJE-2016_log_appendices.txt", replace text


// *************************************************************
// * DEFINE CONTROL SETS FOR ANALYSIS 
// *************************************************************

// Controls 1 - Main specification
	global x_controls1 ///
		saturation_dm demeaned_popT_6k ///
		zoneidI2-zoneidI8 pup_pop wave2 month_interviewI2-month_interviewI12 cost_sharing  ///
		std98_base_I2 std98_base_I3 std98_base_I4 std98_base_I5 std98_base_I6 female_baseline avgtest96

// Controls 2 - Same as "controls 1", but for 1998-2001 outcomes only
	global x_controls2 ///
		saturation_dm demeaned_popT_6k ///
		zoneidI2-zoneidI8 pup_pop cost_sharing ///
		std98_base_I2 std98_base_I3 std98_base_I4 std98_base_I5 std98_base_I6 female_baseline avgtest96
		
// Controls 3 - Same as "controls 1" + interaction with gender
	global x_controls3 ///
		saturation_dm demeaned_popT_6k treatment_gender ///
		zoneidI2-zoneidI8 pup_pop wave2 month_interviewI2-month_interviewI12 cost_sharing ///
		std98_base_I2 std98_base_I3 std98_base_I4 std98_base_I5 std98_base_I6 female_baseline avgtest96

// Controls 4 - Same as "controls 1" + indicator for in std 5,6,7 in 1998 + interaction with high std indicator
	global x_controls4 ///
		saturation_dm demeaned_popT_6k treatment_high_std ///
		zoneidI2-zoneidI8 pup_pop wave2 month_interviewI2-month_interviewI12 cost_sharing ///
		high_standard female_baseline avgtest96

// Controls 5 - Same as "controls 1" + zonal infection (demeaned) + interaction with zonal infection
	global x_controls5  ///
		saturation_dm demeaned_popT_6k z_inf98 treatment_worm ///
		/*zoneidI2-zoneidI8*/ pup_pop wave2 month_interviewI2-month_interviewI12 cost_sharing ///
		std98_base_I2 std98_base_I3 std98_base_I4 std98_base_I5 std98_base_I6 female_baseline avgtest96

// Controls 6 - Same as "controls 1" + infection + interaction with infection (seperate Geohelmith and schisto)
	global x_controls6 ///
		saturation_dm demeaned_popT_6k ///
		/*zoneidI2-zoneidI8*/ pup_pop wave2 month_interviewI2-month_interviewI12 cost_sharing ///
		std98_base_I2 std98_base_I3 std98_base_I4 std98_base_I5 std98_base_I6 female_baseline avgtest96 ///
		within_5km_lake z_geohelmith1998_demeaned treatment_5kmlake treatment_geohelmith
	
// Controls 7 - Same as "controls 1" + interaction with saturation
	global x_controls7 ///
		saturation_dm demeaned_popT_6k T_saturation_dm ///
		zoneidI2-zoneidI8 pup_pop wave2 month_interviewI2-month_interviewI12 cost_sharing ///
		std98_base_I2 std98_base_I3 std98_base_I4 std98_base_I5 std98_base_I6 female_baseline avgtest96

// Controls 8 - Same as "controls 1" + with saturation term squared
	global x_controls8 ///
		saturation_dm demeaned_popT_6k saturation_dm_sq ///
		zoneidI2-zoneidI8 pup_pop wave2 month_interviewI2-month_interviewI12 cost_sharing ///
		std98_base_I2 std98_base_I3 std98_base_I4 std98_base_I5 std98_base_I6 female_baseline avgtest96
	
// Controls 9 - Same as "controls 1" without externalities (and no total population either)
	global x_controls9 ///
		zoneidI2-zoneidI8 pup_pop wave2 month_interviewI2-month_interviewI12 cost_sharing ///
		std98_base_I2 std98_base_I3 std98_base_I4 std98_base_I5 std98_base_I6 female_baseline avgtest96
	
// Controls 10 - Same as "controls 1", but using the level externality term instead of the proportion
	global x_controls10 ///
		demeaned_pop12_6km demeaned_popT_6k ///
		zoneidI2-zoneidI8 pup_pop wave2 month_interviewI2-month_interviewI12 cost_sharing ///
		std98_base_I2 std98_base_I3 std98_base_I4 std98_base_I5 std98_base_I6 female_baseline avgtest96
	

// *******************************************************************
// * FIGURE S1
// * Worm infection rates over time, by treatment group
// *******************************************************************
		
* Open data set
	use "$da/Baird-etal-QJE-2016_data_infection9802", clear
	
* Collapse by group
	collapse any_ics, by(wgrp year)

* Worm infection rates over time
	two (connected any_ics year if wgrp==1 & year>=1998 & year<=1999, lpat(solid) lc(black) ms(o) msize(large) mfcolor(white) mlcolor(black)) ///
		(connected any_ics year if wgrp==1 & year>=1999 & year<=2002, lpat(solid) lc(black) ms(o) msize(large) mfcolor(black) mlcolor(black)) ///
		(connected any_ics year if wgrp==2 & year>=1998 & year<=2000, lpat(dash)  lc(black) ms(T) msize(large) mfcolor(white) mlcolor(black)) ///
		(connected any_ics year if wgrp==2 & year>=2000 & year<=2002, lpat(dash)  lc(black) ms(T) msize(large) mfcolor(black) mlcolor(black)) ///
		(connected any_ics year if wgrp==3 & year>=2001 & year<=2002, lpat(dot)   lc(black) ms(S) msize(large) mfcolor(white) mlcolor(black)) ///
		(connected any_ics year if wgrp==3 & year>=2002 & year<=2002, lpat(dot)   lc(black) ms(S) msize(large) mfcolor(black) mlcolor(black)), ///
				xtitle("Year") ytitle("% with Moderate-to-Heavy Infection") ///
				legend(order(1 "Group 1" 3 "Group 2" 5 "Group 3") cols(1)) ///
				saving("$output/Baird-etal-QJE-2016_AppFigS1", replace)

						
// *******************************************************************
// * FIGURE S2
// * Kernel densities of hours worked and log earnings in self- and wage employment for males, treatment versus control
// *******************************************************************

* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear

* If working 10 to 80 hours in sector
	foreach lhs in emp_hrs7_total selfemp_hrs7_total {
		des `lhs'
		sum `lhs'
		g       trim_`lhs'=`lhs'
		replace trim_`lhs'=. if `lhs'<10 | `lhs'>80
		}
		
* Top 5% trimmed
	g       trim_ly = ln_selfemp_profits30_total_cal
	sum ln_selfemp_profits30_total_cal, detail
	replace trim_ly = . if ln_selfemp_profits30_total_cal > r(p95)

* Panel A: Hours worked in self-employment in last week
	twoway (kdensity trim_selfemp_hrs7_total if treatment==1 & female_baseline==0 [aw=weight], epan bwidth(10) lc(black) lw(thick)) ///
		   (kdensity trim_selfemp_hrs7_total if treatment==0 & female_baseline==0 [aw=weight], epan bwidth(10) lc(gs11) lw(thick)), ///
				graphregion(fcolor(white)) text(0.014 72 "Treatment", size(medsmall)) text(0.009 61 "Control", size(medsmall)) ///
				text(0.019 10 "{bf:A}", size(large) place(e)) ylabel(.005 .01 .015 .02) yscale(range(0 .02)) xlabel(10(20)80) ///
				legend(off) xtitle("Hours worked in self-employment, males") ytitle("Kernel density") ///
				saving("$output/Baird-etal-QJE-2016_AppFigS2_PanelA", replace)

* Panel B: Hours worked in wage employment last week
	twoway (kdensity trim_emp_hrs7_total if treatment==1 & female_baseline==0 [aw=weight], epan bwidth(10) lc(black) lw(thick)) ///
		   (kdensity trim_emp_hrs7_total if treatment==0 & female_baseline==0 [aw=weight], epan bwidth(10) lc(gs11) lw(thick)), ///
				graphregion(fcolor(white)) ///
				text(0.019 10 "{bf:B}", size(large) place(e)) ylabel(.005 .01 .015 .02) yscale(range(0 .02)) xlabel(10(20)80) ///
				legend(off) xtitle("Hours worked in wage employment, males") ytitle("") ///
				saving("$output/Baird-etal-QJE-2016_AppFigS2_PanelB", replace)

* Panel C: Log self-employed profits in last month (top 5% trimmed)
	twoway (kdensity trim_ly if treatment==1 & female_baseline==0 [aw=weight], epan bwidth(0.5) lc(black) lw(thick)) ///
		   (kdensity trim_ly if treatment==0 & female_baseline==0 [aw=weight], epan bwidth(0.5) lc(gs11) lw(thick)), ///
				graphregion(fcolor(white)) ///
				text(0.415 3 "{bf:C}", size(large) place(e)) xscale(range(3 11)) xlabel(3(1)11) yscale(range(0 .45)) ///
				legend(off) xtitle("Log self-employment profits, males") ytitle("Kernel density") ///
				saving("$output/Baird-etal-QJE-2016_AppFigS2_PanelC", replace)
				
				
* Panel D: Log earnings in wage employment in past month
	twoway (kdensity ln_emp_salary_total if treatment==1 & female_baseline==0 [aw=weight], epan bwidth(0.5) lc(black) lw(thick)) ///
		   (kdensity ln_emp_salary_total if treatment==0 & female_baseline==0 [aw=weight], epan bwidth(0.5) lc(gs11) lw(thick)), ///
				graphregion(fcolor(white)) ///
				text(0.415 3 "{bf:D}", size(large) place(e)) xscale(range(3 11)) xlabel(3(1)11) yscale(range(0 .45)) ///
				legend(off) xtitle("Log wage employment earnings, males") ytitle("") ///
				saving("$output/Baird-etal-QJE-2016_AppFigS2_PanelD", replace)

// Combine panels
graph combine "$output/Baird-etal-QJE-2016_AppFigS2_PanelA" "$output/Baird-etal-QJE-2016_AppFigS2_PanelB" "$output/Baird-etal-QJE-2016_AppFigS2_PanelC" ///
	"$output/Baird-etal-QJE-2016_AppFigS2_PanelD", ysize(8.5) xsize(12.5) row(2) col(2) graphregion(fcolor(white)) imargin(small) ///
	saving("$output/Baird-etal-QJE-2016_AppFigS2_ALL", replace)
	
				
// *******************************************************************
// * FIGURE S3
// * Kernel densities of hours worked and log earnings in self- and wage employment for females, treatment versus control 
// *******************************************************************

* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear

* If working 10 to 80 hours in sector
	foreach lhs in emp_hrs7_total selfemp_hrs7_total {
		des `lhs'
		sum `lhs'
		g       trim_`lhs'=`lhs'
		replace trim_`lhs'=. if `lhs'<10 | `lhs'>80
		}
		
* Top 5% trimmed
	g       trim_ly = ln_selfemp_profits30_total_cal
	sum ln_selfemp_profits30_total_cal, detail
	replace trim_ly = . if ln_selfemp_profits30_total_cal > r(p95)

* Panel A: Hours worked in self-employment in last week
	twoway (kdensity trim_selfemp_hrs7_total if treatment==1 & female_baseline==1 [aw=weight], epan bwidth(10) lc(black) lw(thick)) ///
		   (kdensity trim_selfemp_hrs7_total if treatment==0 & female_baseline==1 [aw=weight], epan bwidth(10) lc(gs11) lw(thick)), ///
				graphregion(fcolor(white)) text(0.011 74.5 "Treatment", size(medsmall)) text(0.009 44 "Control", size(medsmall)) ///
				text(0.023 10 "{bf:A}", size(large) place(e)) ylabel(.005 .01 .015 .02 .025) yscale(range(0 .027)) xlabel(10(20)80) ///
				legend(off) xtitle("Hours worked in self-employment, females") ytitle("Kernel density") ///
				saving("$output/Baird-etal-QJE-2016_AppFigS3_PanelA", replace)
				
* Panel B: Hours worked in wage employment last week
	twoway (kdensity trim_emp_hrs7_total if treatment==1 & female_baseline==1 [aw=weight], epan bwidth(10) lc(black) lw(thick)) ///
		   (kdensity trim_emp_hrs7_total if treatment==0 & female_baseline==1 [aw=weight], epan bwidth(10) lc(gs11) lw(thick)), ///
				graphregion(fcolor(white)) ///
				text(0.023 10 "{bf:B}", size(large) place(e)) ylabel(.005 .01 .015 .02  .025) yscale(range(0 .027)) xlabel(10(20)80) ///
				legend(off) xtitle("Hours worked in wage employment, females") ytitle("") ///
				saving("$output/Baird-etal-QJE-2016_AppFigS3_PanelB", replace)

* Panel C: Log self-employed profits in last month (top 5% trimmed)
	twoway (kdensity trim_ly if treatment==1 & female_baseline==1 [aw=weight], epan bwidth(0.5) lc(black) lw(thick)) ///
		   (kdensity trim_ly if treatment==0 & female_baseline==1 [aw=weight], epan bwidth(0.5) lc(gs11) lw(thick)), ///
				graphregion(fcolor(white)) ///
				text(0.42 3 "{bf:C}", size(large) place(e)) xscale(range(3 11)) xlabel(3(1)11) yscale(range(0 .45)) ///
				legend(off) xtitle("Log self-employment profits, females") ytitle("Kernel density") ///
				saving("$output/Baird-etal-QJE-2016_AppFigS3_PanelC", replace)
				
* Panel D: Log earnings in wage employment in past month
	twoway (kdensity ln_emp_salary_total if treatment==1 & female_baseline==1 [aw=weight], epan bwidth(0.5) lc(black) lw(thick)) ///
		   (kdensity ln_emp_salary_total if treatment==0 & female_baseline==1 [aw=weight], epan bwidth(0.5) lc(gs11) lw(thick)), ///
				graphregion(fcolor(white)) ///
				text(0.42 3 "{bf:D}", size(large) place(e)) xscale(range(3 11)) xlabel(3(1)11) yscale(range(0 .45)) ///
				legend(off) xtitle("Log wage employment earnings, females") ytitle("") ///
				saving("$output/Baird-etal-QJE-2016_AppFigS3_PanelD", replace)

// Combine panels
graph combine "$output/Baird-etal-QJE-2016_AppFigS3_PanelA" "$output/Baird-etal-QJE-2016_AppFigS3_PanelB" "$output/Baird-etal-QJE-2016_AppFigS3_PanelC" ///
	"$output/Baird-etal-QJE-2016_AppFigS3_PanelD", ysize(8.5) xsize(12.5) row(2) col(2) graphregion(fcolor(white)) imargin(small) ///
	saving("$output/Baird-etal-QJE-2016_AppFigS3_ALL", replace)


// *******************************************************************
// * FIGURE S4
// * Deworming treatment effect estimates conditional on different specifications of the cross-school externality effect
// *******************************************************************

* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear

* Regression output for: Number of meals eaten
	reg num_meals_yesterday treatment                                     $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment saturation_2km_dm demeaned_popT_2km $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment saturation_3km_dm demeaned_popT_3km $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment saturation_4km_dm demeaned_popT_4km $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment saturation_5km_dm demeaned_popT_5km $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment saturation_6km_dm demeaned_popT_6k $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment saturation_7km_dm demeaned_popT_7km $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment saturation_3km_dm saturation36k_dm demeaned_popT_3km demeaned_popT_36k                                    $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment saturation_3km_dm saturation36k_dm saturation69k_dm demeaned_popT_3km demeaned_popT_36k demeaned_popT_69k $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	
* Regression output for: Hours worked last week, males
	reg total_hours treatment                                     $x_controls9 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
	reg total_hours treatment saturation_1km_dm demeaned_popT_1km $x_controls9 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
	reg total_hours treatment saturation_2km_dm demeaned_popT_2km $x_controls9 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
	reg total_hours treatment saturation_3km_dm demeaned_popT_3km $x_controls9 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
	reg total_hours treatment saturation_4km_dm demeaned_popT_4km $x_controls9 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
	reg total_hours treatment saturation_5km_dm demeaned_popT_5km $x_controls9 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
	reg total_hours treatment saturation_6km_dm demeaned_popT_6k $x_controls9 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
	reg total_hours treatment saturation_7km_dm demeaned_popT_7km $x_controls9 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
	reg total_hours treatment saturation_3km_dm saturation36k_dm demeaned_popT_3km demeaned_popT_36k                                    $x_controls9 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
	reg total_hours treatment saturation_3km_dm saturation36k_dm saturation69k_dm demeaned_popT_3km demeaned_popT_36k demeaned_popT_69k $x_controls9 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
	
* Regression output for: Passed primary exam, females
	reg passed_primary_exam treatment                                     $x_controls9 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	reg passed_primary_exam treatment saturation_2km_dm demeaned_popT_2km $x_controls9 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	reg passed_primary_exam treatment saturation_3km_dm demeaned_popT_3km $x_controls9 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	reg passed_primary_exam treatment saturation_4km_dm demeaned_popT_4km $x_controls9 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	reg passed_primary_exam treatment saturation_5km_dm demeaned_popT_5km $x_controls9 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	reg passed_primary_exam treatment saturation_6km_dm demeaned_popT_6k $x_controls9 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	reg passed_primary_exam treatment saturation_7km_dm demeaned_popT_7km $x_controls9 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	reg passed_primary_exam treatment saturation_3km_dm saturation36k_dm demeaned_popT_3km demeaned_popT_36k                                    $x_controls9 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	reg passed_primary_exam treatment saturation_3km_dm saturation36k_dm saturation69k_dm demeaned_popT_3km demeaned_popT_36k demeaned_popT_69k $x_controls9 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
* Regression output for: Ln(Total labor earnings)
	reg ln_emp_salary_total treatment                                     $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment saturation_2km_dm demeaned_popT_2km $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment saturation_3km_dm demeaned_popT_3km $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment saturation_4km_dm demeaned_popT_4km $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment saturation_5km_dm demeaned_popT_5km $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment saturation_6km_dm demeaned_popT_6k $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment saturation_7km_dm demeaned_popT_7km $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment saturation_3km_dm saturation36k_dm demeaned_popT_3km demeaned_popT_36k                                    $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment saturation_3km_dm saturation36k_dm saturation69k_dm demeaned_popT_3km demeaned_popT_36k demeaned_popT_69k $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
			
* Create summary graphic

insheet using "$da/Baird-etal-QJE-2016_input_AppFigS4.csv", clear
*This file was created by taking the regression results produced above and inputting the point estimates and 95% confidence interval values
*	(high and low) for each outcome

label var ext_type "No ext=1, 0-2=2, 0-3=3, 0-4=4, 0-5=5, 0-6=6, 0-7=7, 0-3 & 3-6=8, 0-3 & 3-6 & 6-9=9"

label var meals_est "Treatment effect on meals, coeff. est."
label var meals_h "Treatment effect on meals, 95% CI upper bound"
label var meals_l "Treatment effect on meals, 95% CI lower bound"

label var hours_est "Treatment effect on hours, coeff. est."
label var hours_h "Treatment effect on hours, 95% CI upper bound"
label var hours_l "Treatment effect on hours, 95% CI lower bound"

label var exam_est "Treatment effect on exams, coeff. est."
label var exam_h "Treatment effect on exams, 95% CI upper bound"
label var exam_l "Treatment effect on exams, 95% CI lower bound"

label var earnings_est "Treatment effect on earnings, coeff. est."
label var earnings_h "Treatment effect on earnings, 95% CI upper"
label var earnings_l "Treatment effect on earnings, 95% CI lower"


* PANEL A: Number of meals eaten
local outcome "meals"
twoway 	rcap `outcome'_h `outcome'_l ext_type, lwidth(thick) lcolor(gs10) msize(vtiny) || ///
		scatter `outcome'_est ext_type if ext_type==1, ///
			msymbol(circle) msize(huge) mfcolor(gs12) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==2, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==3, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==4, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==5, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==6, ///
			msymbol(circle) msize(huge) mfcolor(gs5) mlcolor(gs10) || ///			
		scatter `outcome'_est ext_type if ext_type==7, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==8, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==9, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) ///
		legend(off)  ///
		l1title("Deworming treatment effect", size(medsmall) margin(zero)) /// 
		t1title("Meals eaten yesterday", size(medium) margin(vsmall)) ///
		yscale(range(-0.02 0.22)) ylabel(0 0.05 0.1 0.15 0.2) ///  
		yline(0, lcolor(gs10) lwidth(vvthin) lpattern(shortdash)) ///
		xscale(off) ///
		text(0.22 0.5 "{bf:A}", size(vlarge) place(e)) /// 
		text(0.17 1 "None", size(medsmall)) ///
		text(0.17 2 "0-2", size(medsmall)) ///
		text(0.17 3 "0-3", size(medsmall)) ///
		text(0.17 4 "0-4", size(medsmall)) ///
		text(0.17 5 "0-5", size(medsmall)) ///
		text(0.17 6 "0-6", size(medsmall)) ///
		text(0.185 7 "0-7", size(medsmall)) ///
		text(0.185 8 "0-3,", size(medsmall)) ///
		text(0.17 8 "3-6 ", size(medsmall)) ///
		text(0.20 9 "0-3,", size(medsmall)) ///
		text(0.185 9 "3-6,", size(medsmall)) ///
		text(0.17 9 "6-9 ", size(medsmall)) ///
		graphregion(fcolor(white)) ///
		saving("$output/Baird-etal-QJE-2016_AppFigS4_PanelA", replace)

* PANEL B: Hours worked (males)
local outcome "hours"
twoway 	rcap `outcome'_h `outcome'_l ext_type, lwidth(thick) lcolor(gs10) msize(vtiny) || ///
		scatter `outcome'_est ext_type if ext_type==1, ///
			msymbol(circle) msize(huge) mfcolor(gs12) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==2, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==3, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==4, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==5, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==6, ///
			msymbol(circle) msize(huge) mfcolor(gs5) mlcolor(gs10) || ///	
		scatter `outcome'_est ext_type if ext_type==7, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==8, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==9, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) ///
		legend(off)  ///
		l1title("", size(medsmall) margin(zero))  ///
		t1title("Hours worked last week, males", size(medium) margin(vsmall)) ///
		yscale(range(-0.5 8)) ylabel(0 1 3 5 7)   ///
		yline(0, lcolor(gs10) lwidth(vvthin) lpattern(shortdash)) ///
		xscale(off) ///
		text(8 0.5 "{bf:B}", size(vlarge) place(e))  ///
		text(6.9 1 "None", size(medsmall)) ///
		text(6.9 2 "0-2", size(medsmall)) ///
		text(6.9 3 "0-3", size(medsmall)) ///
		text(6.9 4 "0-4", size(medsmall)) ///
		text(6.9 5 "0-5", size(medsmall)) ///
		text(6.9 6 "0-6", size(medsmall)) ///
		text(7.4 7 "0-7", size(medsmall)) ///
		text(7.4 8 "0-3,", size(medsmall)) ///
		text(6.9 8 "3-6 ", size(medsmall)) ///
		text(7.9 9 "0-3,", size(medsmall)) ///
		text(7.4 9 "3-6,", size(medsmall)) ///
		text(6.9 9 "6-9 ", size(medsmall)) ///
		graphregion(fcolor(white)) ///
		saving("$output/Baird-etal-QJE-2016_AppFigS4_PanelB", replace)

* PANEL C: Passed primary school leaving exam (females)
local outcome "exam"
twoway 	rcap `outcome'_h `outcome'_l ext_type, lwidth(thick) lcolor(gs10) msize(vtiny) || ///
		scatter `outcome'_est ext_type if ext_type==1, ///
			msymbol(circle) msize(huge) mfcolor(gs12) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==2, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==3, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==4, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==5, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==6, ///
			msymbol(circle) msize(huge) mfcolor(gs5) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==7, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==8, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==9, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) ///
		legend(off)  ///
		l1title("Deworming treatment effect", size(medsmall) margin(zero))  ///
		t1title("Passed primary exam, females", size(medium) margin(vsmall)) ///
		yscale(range(-0.05 0.22)) ylabel(0 0.05 0.1 0.15 0.2)   ///
		yline(0, lcolor(gs10) lwidth(vvthin) lpattern(shortdash)) ///
		xscale(off) ///
		text(0.22 0.5 "{bf:C}", size(vlarge) place(e))  ///
		text(0.17 1 "None", size(medsmall)) ///
		text(0.17 2 "0-2", size(medsmall)) ///
		text(0.17 3 "0-3", size(medsmall)) ///
		text(0.17 4 "0-4", size(medsmall)) ///
		text(0.17 5 "0-5", size(medsmall)) ///
		text(0.19 6 "0-6", size(medsmall)) ///
		text(0.17 7 "0-7", size(medsmall)) ///
		text(0.19 8 "0-3,", size(medsmall)) ///
		text(0.17 8 "3-6 ", size(medsmall)) ///
		text(0.21 9 "0-3,", size(medsmall)) ///
		text(0.19 9 "3-6,", size(medsmall)) ///
		text(0.17 9 "6-9 ", size(medsmall)) ///
		graphregion(fcolor(white)) ///
		saving("$output/Baird-etal-QJE-2016_AppFigS4_PanelC", replace)
		
* PANEL D: Ln(Total labor earnings)
local outcome "earnings"
twoway 	rcap `outcome'_h `outcome'_l ext_type, lwidth(thick) lcolor(gs10) msize(vtiny) || ///
		scatter `outcome'_est ext_type if ext_type==1, ///
			msymbol(circle) msize(huge) mfcolor(gs12) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==2, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==3, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==4, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==5, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==6, ///
			msymbol(circle) msize(huge) mfcolor(gs5) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==7, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==8, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) || ///
		scatter `outcome'_est ext_type if ext_type==9, ///
			msymbol(circle) msize(huge) mfcolor(gs15) mlcolor(gs10) ///
		legend(off)  ///
		l1title("", size(medsmall) margin(zero))  ///
		t1title("Ln(Total labor earnings)", size(medium) margin(vsmall)) ///
		yscale(range(-0.02 0.6)) ylabel(0 0.1 0.3 0.5)   ///
		yline(0, lcolor(gs10) lwidth(vvthin) lpattern(shortdash)) ///
		xscale(off) ///
		text(0.6 0.5 "{bf:D}", size(vlarge) place(e))  ///
		text(0.47 1 "None", size(medsmall)) ///
		text(0.47 2 "0-2", size(medsmall)) ///
		text(0.47 3 "0-3", size(medsmall)) ///
		text(0.47 4 "0-4", size(medsmall)) ///
		text(0.47 5 "0-5", size(medsmall)) ///
		text(0.47 6 "0-6", size(medsmall)) ///
		text(0.55 7 "0-7", size(medsmall)) ///
		text(0.51 8 "0-3,", size(medsmall)) ///
		text(0.47 8 "3-6 ", size(medsmall)) ///
		text(0.55 9 "0-3,", size(medsmall)) ///
		text(0.51 9 "3-6,", size(medsmall)) ///
		text(0.47 9 "6-9 ", size(medsmall)) ///
		graphregion(fcolor(white)) ///
		saving("$output/Baird-etal-QJE-2016_AppFigS4_PanelD", replace)

* Multi-panel figure
graph combine "$output/Baird-etal-QJE-2016_AppFigS4_PanelA" "$output/Baird-etal-QJE-2016_AppFigS4_PanelB" ///
	"$output/Baird-etal-QJE-2016_AppFigS4_PanelC" "$output/Baird-etal-QJE-2016_AppFigS4_PanelD", /// 
	ysize(8) xsize(12) row(2) col(2) /// 
	graphregion(fcolor(white)) ///
	imargin(small) ///
	saving("$output/Baird-etal-QJE-2016_AppFigS4_ALL", replace)


// *******************************************************************
// * TABLE S1
// * 1998 average pupil and school characteristics, pre-treatment
// *******************************************************************

* See Miguel and Kremer (2014) 
* "Worms: Identifying impacts on education and health in the presence of treatment
*  		externalities. Guide to replication of Miguel and Kremer (2004)"
*  		CEGA working paper #39

			
// *******************************************************************
// * TABLE S2
// * Baseline (1998) summary statistics and PSDP randomization checks,
// * and KLPS (2007-2009) survey attrition patterns
// *******************************************************************

// Panel A: Baseline summary statistics

	* Open data set
		use "$da/Baird-etal-QJE-2016_data_attrition.dta", clear
		keep if surveyed==1
		
	* Age (1998)
		reg s2_age98_klps treatment [pw=weight] if surveyed==1                     , cl(psdpsch98)
		reg s2_age98_klps treatment [pw=weight] if surveyed==1 & female_baseline==0, cl(psdpsch98)
		reg s2_age98_klps treatment [pw=weight] if surveyed==1 & female_baseline==1, cl(psdpsch98)
		
		sum s2_age98_klps [aw=weight] if surveyed==1 & treatment==0
		sum s2_age98_klps [aw=weight] if surveyed==1 & treatment==0 & female_baseline==0
		sum s2_age98_klps [aw=weight] if surveyed==1 & treatment==0 & female_baseline==1
		
	* Grade (1998)
		reg std98_base treatment [pw=weight] if surveyed==1                     , cl(psdpsch98)
		reg std98_base treatment [pw=weight] if surveyed==1 & female_baseline==0, cl(psdpsch98)
		reg std98_base treatment [pw=weight] if surveyed==1 & female_baseline==1, cl(psdpsch98)
		
		sum std98_base [aw=weight] if surveyed==1 & treatment==0
		sum std98_base [aw=weight] if surveyed==1 & treatment==0 & female_baseline==0
		sum std98_base [aw=weight] if surveyed==1 & treatment==0 & female_baseline==1

	* Female indicator
		reg female_baseline treatment [pw=weight] if surveyed==1, cl(psdpsch98)
		sum female_baseline [aw=weight] if surveyed==1 & treatment==0
		
	* School average test score (1996)
		reg avgtest96 treatment [pw=weight] if surveyed==1                     , cl(psdpsch98)
		reg avgtest96 treatment [pw=weight] if surveyed==1 & female_baseline==0, cl(psdpsch98)
		reg avgtest96 treatment [pw=weight] if surveyed==1 & female_baseline==1, cl(psdpsch98)

		sum avgtest96 [aw=weight] if surveyed==1 & treatment==0
		sum avgtest96 [aw=weight] if surveyed==1 & treatment==0 & female_baseline==0
		sum avgtest96 [aw=weight] if surveyed==1 & treatment==0 & female_baseline==1
		
	* Primary school located in Budalangi division indicator
		reg buda treatment [pw=weight] if surveyed==1                     , cl(psdpsch98)
		reg buda treatment [pw=weight] if surveyed==1 & female_baseline==0, cl(psdpsch98)
		reg buda treatment [pw=weight] if surveyed==1 & female_baseline==1, cl(psdpsch98)

		sum buda [aw=weight] if surveyed==1 & treatment==0
		sum buda [aw=weight] if surveyed==1 & treatment==0 & female_baseline==0
		sum buda [aw=weight] if surveyed==1 & treatment==0 & female_baseline==1
		
	* Population of primary school
		reg pup_pop treatment [pw=weight] if surveyed==1                     , cl(psdpsch98)
		reg pup_pop treatment [pw=weight] if surveyed==1 & female_baseline==0, cl(psdpsch98)
		reg pup_pop treatment [pw=weight] if surveyed==1 & female_baseline==1, cl(psdpsch98)

		sum pup_pop [aw=weight] if surveyed==1 & treatment==0
		sum pup_pop [aw=weight] if surveyed==1 & treatment==0 & female_baseline==0
		sum pup_pop [aw=weight] if surveyed==1 & treatment==0 & female_baseline==1
		
	* Total primary school students within 6 km
		reg popT_06k_updated treatment [pw=weight] if surveyed==1                     , cl(psdpsch98)
		reg popT_06k_updated treatment [pw=weight] if surveyed==1 & female_baseline==0, cl(psdpsch98)
		reg popT_06k_updated treatment [pw=weight] if surveyed==1 & female_baseline==1, cl(psdpsch98)

		sum popT_06k_updated [aw=weight] if surveyed==1 & treatment==0
		sum popT_06k_updated [aw=weight] if surveyed==1 & treatment==0 & female_baseline==0
		sum popT_06k_updated [aw=weight] if surveyed==1 & treatment==0 & female_baseline==1
		
	* Primary school students within 6 km in treatment schools (Group 1,2)
		reg pop12_06k_updated treatment [pw=weight] if surveyed==1                     , cl(psdpsch98)
		reg pop12_06k_updated treatment [pw=weight] if surveyed==1 & female_baseline==0, cl(psdpsch98)
		reg pop12_06k_updated treatment [pw=weight] if surveyed==1 & female_baseline==1, cl(psdpsch98)

		sum pop12_06k_updated [aw=weight] if surveyed==1 & treatment==0
		sum pop12_06k_updated [aw=weight] if surveyed==1 & treatment==0 & female_baseline==0
		sum pop12_06k_updated [aw=weight] if surveyed==1 & treatment==0 & female_baseline==1
		
	* Saturation (Pj): Proportion of treated students within 6 km
		reg saturation treatment [pw=weight] if surveyed==1                     , cl(psdpsch98)
		reg saturation treatment [pw=weight] if surveyed==1 & female_baseline==0, cl(psdpsch98)
		reg saturation treatment [pw=weight] if surveyed==1 & female_baseline==1, cl(psdpsch98)

		sum saturation [aw=weight] if surveyed==1 & treatment==0
		sum saturation [aw=weight] if surveyed==1 & treatment==0 & female_baseline==0
		sum saturation [aw=weight] if surveyed==1 & treatment==0 & female_baseline==1
		
	* Years of assigned deworming treatment, 1998-2003
		reg Tyears_base treatment [pw=weight] if surveyed==1                     , cl(psdpsch98)
		reg Tyears_base treatment [pw=weight] if surveyed==1 & female_baseline==0, cl(psdpsch98)
		reg Tyears_base treatment [pw=weight] if surveyed==1 & female_baseline==1, cl(psdpsch98)

		sum Tyears_base [aw=weight] if surveyed==1 & treatment==0
		sum Tyears_base [aw=weight] if surveyed==1 & treatment==0 & female_baseline==0
		sum Tyears_base [aw=weight] if surveyed==1 & treatment==0 & female_baseline==1
	
// Panel B: Sample attrition, KLPS (2007-09)

	* Open data set
		use "$da/Baird-etal-QJE-2016_data_attrition.dta", clear
		keep if attrition_sample==1

	* Found indicator
		reg found treatment [pw=weight]                      , cl(psdpsch98)
		reg found treatment [pw=weight] if female_baseline==0, cl(psdpsch98)
		reg found treatment [pw=weight] if female_baseline==1, cl(psdpsch98)
		
		sum found [aw=weight] if treatment==0
		sum found [aw=weight] if treatment==0 & female_baseline==0
		sum found [aw=weight] if treatment==0 & female_baseline==1
		
	* Surveyed indicator
		reg surveyed treatment [pw=weight]                      , cl(psdpsch98)
		reg surveyed treatment [pw=weight] if female_baseline==0, cl(psdpsch98)
		reg surveyed treatment [pw=weight] if female_baseline==1, cl(psdpsch98)
		
		sum surveyed [aw=weight] if treatment==0
		sum surveyed [aw=weight] if treatment==0 & female_baseline==0
		sum surveyed [aw=weight] if treatment==0 & female_baseline==1
		
	* Not surveyed, deceased indicator
		reg dead treatment [pw=weight]                      , cl(psdpsch98)
		reg dead treatment [pw=weight] if female_baseline==0, cl(psdpsch98)
		reg dead treatment [pw=weight] if female_baseline==1, cl(psdpsch98)
		
		sum dead [aw=weight] if treatment==0
		sum dead [aw=weight] if treatment==0 & female_baseline==0
		sum dead [aw=weight] if treatment==0 & female_baseline==1
		

// *******************************************************************
// * TABLE S3
// * Deworming impacts on school enrollment, by year and gender
// *******************************************************************

* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear

// Panel A: Primary school

	* Overall
		reg s5_attendPsch1999     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendPsch2000     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendPsch2001     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendPsch2002     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendPsch2003     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendPsch2004     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendPsch2005     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendPsch2006     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendPsch2007     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg total_years_enrolledP treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
	
	* Male
		reg s5_attendPsch1999     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendPsch2000     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendPsch2001     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendPsch2002     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendPsch2003     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendPsch2004     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendPsch2005     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendPsch2006     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendPsch2007     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg total_years_enrolledP treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		
	* Female
		reg s5_attendPsch1999     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendPsch2000     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendPsch2001     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendPsch2002     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendPsch2003     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendPsch2004     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendPsch2005     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendPsch2006     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendPsch2007     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg total_years_enrolledP treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)

// Panel B: Secondary school

	* Overall
		reg s5_attendSsch1999     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendSsch2000     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendSsch2001     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendSsch2002     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendSsch2003     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendSsch2004     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendSsch2005     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendSsch2006     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendSsch2007     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg total_years_enrolledS treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)

	* Male
		reg s5_attendSsch1999     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendSsch2000     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendSsch2001     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendSsch2002     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendSsch2003     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendSsch2004     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendSsch2005     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendSsch2006     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendSsch2007     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg total_years_enrolledS treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		
	* Female
		reg s5_attendSsch1999     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendSsch2000     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendSsch2001     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendSsch2002     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendSsch2003     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendSsch2004     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendSsch2005     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendSsch2006     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendSsch2007     treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg total_years_enrolledS treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		
// Panel C: Primary and secondary school

	* Overall
		reg s5_attendsch1999 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendsch2000 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendsch2001 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendsch2002 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendsch2003 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendsch2004 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendsch2005 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendsch2006 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg s5_attendsch2007 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		reg totyrs_enrolled  treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
		
	* Male
		reg s5_attendsch1999 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendsch2000 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendsch2001 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendsch2002 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendsch2003 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendsch2004 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendsch2005 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendsch2006 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg s5_attendsch2007 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		reg totyrs_enrolled  treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==0, cl(psdpsch98)
		
	* Female
		reg s5_attendsch1999 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendsch2000 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendsch2001 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendsch2002 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendsch2003 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendsch2004 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendsch2005 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendsch2006 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg s5_attendsch2007 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		reg totyrs_enrolled  treatment $x_controls1 [pw=weight] if insample_edu_matrix==1 & female==1, cl(psdpsch98)
		

// *******************************************************************
// * TABLE S4
// * Baseline (1998) summary statistics across treatment groups,
// * for "out-of-school" subsample
// *******************************************************************

* Open data set
	use "$da/Baird-etal-QJE-2016_data_attrition.dta", clear
	
* Age (1998)
	reg s2_age98_klps treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0                     , cl(psdpsch98)
	reg s2_age98_klps treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==0, cl(psdpsch98)
	reg s2_age98_klps treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==1, cl(psdpsch98)
		
	sum s2_age98_klps [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0
	sum s2_age98_klps [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==0
	sum s2_age98_klps [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==1
	
* Grade (1998)
	reg std98_base treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0                     , cl(psdpsch98)
	reg std98_base treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==0, cl(psdpsch98)
	reg std98_base treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==1, cl(psdpsch98)
		
	sum std98_base [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0
	sum std98_base [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==0
	sum std98_base [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==1

* Female
	reg female_baseline treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0, cl(psdpsch98)
	sum female_baseline [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0
	
* School average test score (1996)
	reg avgtest96 treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0                     , cl(psdpsch98)
	reg avgtest96 treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==0, cl(psdpsch98)
	reg avgtest96 treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==1, cl(psdpsch98)
	
	sum avgtest96 [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0
	sum avgtest96 [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==0
	sum avgtest96 [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==1
	
* Primary school located in Budalangi division
	reg buda treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0                     , cl(psdpsch98)
	reg buda treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==0, cl(psdpsch98)
	reg buda treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==1, cl(psdpsch98)
	
	sum buda [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0
	sum buda [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==0
	sum buda [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==1

* Population of primary school
	reg pup_pop treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0                     , cl(psdpsch98)
	reg pup_pop treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==0, cl(psdpsch98)
	reg pup_pop treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==1, cl(psdpsch98)
	
	sum pup_pop [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0
	sum pup_pop [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==0
	sum pup_pop [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==1

* Total primary school student within 6 km
	reg popT_06k_updated treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0                     , cl(psdpsch98)
	reg popT_06k_updated treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==0, cl(psdpsch98)
	reg popT_06k_updated treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==1, cl(psdpsch98)
	
	sum popT_06k_updated [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0
	sum popT_06k_updated [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==0
	sum popT_06k_updated [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==1

* Primary school students within 6 km in treatment schools (Group 1,2)
	reg pop12_06k_updated treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0                     , cl(psdpsch98)
	reg pop12_06k_updated treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==0, cl(psdpsch98)
	reg pop12_06k_updated treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==1, cl(psdpsch98)
	
	sum pop12_06k_updated [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0
	sum pop12_06k_updated [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==0
	sum pop12_06k_updated [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==1
	
* Saturation (Pj)
	reg saturation treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0                     , cl(psdpsch98)
	reg saturation treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==0, cl(psdpsch98)
	reg saturation treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==1, cl(psdpsch98)
	
	sum saturation [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0
	sum saturation [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==0
	sum saturation [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==1
	
* Years of assigned deworming treatment, 1998-2003
	reg Tyears_base treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0                     , cl(psdpsch98)
	reg Tyears_base treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==0, cl(psdpsch98)
	reg Tyears_base treatment [pw=weight] if surveyed==1 & s5_attendsch_survey==0 & female_baseline==1, cl(psdpsch98)
	
	sum Tyears_base [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0
	sum Tyears_base [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==0
	sum Tyears_base [aw=weight] if surveyed==1 & s5_attendsch_survey==0 & treatment==0 & female_baseline==1


// *******************************************************************
// * TABLE S5
// * Selection into out-of-school subsample and into employment types
// *******************************************************************

* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear

* Regressors
	global X1 "female_baseline std98_base avgtest96 pup_pop buda saturation_dm demeaned_popT_6k cost_sharing zoneidI2 zoneidI3 zoneidI4 zoneidI5 zoneidI6 zoneidI7 zoneidI8"
	global X2 "female_baseline std98_base avgtest96 pup_pop buda saturation_dm demeaned_popT_6k cost_sharing zoneidI2 zoneidI3 zoneidI4 zoneidI5 zoneidI6 zoneidI7 zoneidI8 T_female_baseline T_std98_base T_avgtest96 T_pup_pop T_buda T_saturation_dm T_demeaned_popT_6k T_zoneidI2 T_zoneidI3 T_zoneidI4 T_zoneidI5 T_zoneidI6 T_zoneidI7 T_zoneidI8"
	global T  "treatment T_female_baseline T_std98_base T_avgtest96 T_pup_pop T_buda T_zoneidI2 T_zoneidI3 T_zoneidI4 T_zoneidI5 T_zoneidI6 T_zoneidI7 T_zoneidI8 T_saturation_dm T_demeaned_popT_6k"
	
* Columns 1-2: Out-of-school at survey
	reg out_of_school treatment $X1 [pw=weight] if insample==1, cl(psdpsch98)
	reg out_of_school treatment $X2 [pw=weight] if insample==1, cl(psdpsch98)
	testparm $T
	
* Columns 3-4: In Wage Employment
	reg emp treatment $X1 [pw=weight] if insample==1, cl(psdpsch98)
	reg emp treatment $X2 [pw=weight] if insample==1, cl(psdpsch98)
	testparm $T
	
* Columns 5-6: In Self-Employment
	reg selfemp treatment $X1 [pw=weight] if insample==1, cl(psdpsch98)
	reg selfemp treatment $X2 [pw=weight] if insample==1, cl(psdpsch98)
	testparm $T
	
* Columns 7-8: In Agriculture
	reg farmwork2 treatment $X1 [pw=weight] if insample==1, cl(psdpsch98)
	reg farmwork2 treatment $X2 [pw=weight] if insample==1, cl(psdpsch98)
	testparm $T
	
* Mean in the control group
	sum out_of_school [aw=weight] if insample==1 & treatment==0
	sum emp           [aw=weight] if insample==1 & treatment==0
	sum selfemp       [aw=weight] if insample==1 & treatment==0
	sum farmwork2     [aw=weight] if insample==1 & treatment==0
	
* Notes: F-tests of the joint significance after the corresponding regression (testparm $T)
	
	
// *******************************************************************
// * TABLE S6
// * Heterogeneous deworming impacts, full sample
// * Dep. variable: Hours worked in last week, all sectors
// *******************************************************************
  
* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	
* Hours worked last 7 days, all sectors
	reg total_hours treatment $x_controls1  [pw=weight] if insample==1, cl(psdpsch98)
	reg total_hours treatment $x_controls10 [pw=weight] if insample==1, cl(psdpsch98)
	reg total_hours treatment $x_controls7 [pw=weight] if insample==1, cl(psdpsch98)
	reg total_hours treatment $x_controls8 [pw=weight] if insample==1, cl(psdpsch98)
	reg total_hours treatment $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg total_hours treatment $x_controls3  [pw=weight] if insample==1, cl(psdpsch98)
	reg total_hours treatment $x_controls4  [pw=weight] if insample==1, cl(psdpsch98)

* Mean (s.d.) in control group
	sum total_hours [aw=weight] if insample==1 & treatment==0
	
	
// *******************************************************************
// * TABLE S7
// * Heterogeneous deworming impacts, full sample
// * Dep. variable: Number of meals eaten yesterday
// *******************************************************************
  
* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	
* Number of meals eaten
	reg num_meals_yesterday treatment $x_controls1  [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment $x_controls10 [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment $x_controls7 [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment $x_controls8 [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment $x_controls3  [pw=weight] if insample==1, cl(psdpsch98)
	reg num_meals_yesterday treatment $x_controls4  [pw=weight] if insample==1, cl(psdpsch98)

* Mean (s.d.) in control group
	sum num_meals_yesterday [aw=weight] if insample==1 & treatment==0
	
	
// *******************************************************************
// * TABLE S8
// * Heterogeneous deworming impacts, full sample
// * Dep. variable: Passed secondary school entrance exam...
// *******************************************************************
  
* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	
* Passed primary school leaving exam
	reg passed_primary_exam treatment $x_controls1  [pw=weight] if insample==1, cl(psdpsch98)
	reg passed_primary_exam treatment $x_controls10 [pw=weight] if insample==1, cl(psdpsch98)
	reg passed_primary_exam treatment $x_controls7 [pw=weight] if insample==1, cl(psdpsch98)
	reg passed_primary_exam treatment $x_controls8 [pw=weight] if insample==1, cl(psdpsch98)
	reg passed_primary_exam treatment $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg passed_primary_exam treatment $x_controls3  [pw=weight] if insample==1, cl(psdpsch98)
	reg passed_primary_exam treatment $x_controls4  [pw=weight] if insample==1, cl(psdpsch98)

* Mean (s.d.) in control group
	sum passed_primary_exam [aw=weight] if insample==1 & treatment==0
	
	
// *******************************************************************
// * TABLE S9
// * Heterogeneous deworming impacts, full sample
// * Dep. variable: Ln(Total labor earnings), past month
// *******************************************************************
  
* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	
* Ln(Total labor earnings), past month
	reg ln_emp_salary_total treatment $x_controls1  [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls10 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls7 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls8 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls9 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls3  [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls4  [pw=weight] if insample==1, cl(psdpsch98)

* Mean (s.d.) in control group
	sum ln_emp_salary_total [aw=weight] if insample==1 & treatment==0

	
// *******************************************************************
// * TABLE S10
// * Heterogeneous deworming impacts, by gender and helminth type
// * Dep. variable: Hours worked in last week, all sectors
// *******************************************************************
  
* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	
* Columns 1-3: All
 	reg total_hours treatment $x_controls5 [pw=weight] if insample==1                     , cl(psdpsch98)
	reg total_hours treatment $x_controls6 [pw=weight] if insample==1                     , cl(psdpsch98)
	reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & within_5km_lake==0, cl(psdpsch98)
	
* Columns 4-6: Males
	reg total_hours treatment $x_controls5 [pw=weight] if insample==1 & female_baseline==0                     , cl(psdpsch98)
	reg total_hours treatment $x_controls6 [pw=weight] if insample==1 & female_baseline==0                     , cl(psdpsch98)
	reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & within_5km_lake==0 & female_baseline==0, cl(psdpsch98)
 	
* Columns 7-9: Females
	reg total_hours treatment $x_controls5 [pw=weight] if insample==1 & female_baseline==1                     , cl(psdpsch98)
	reg total_hours treatment $x_controls6 [pw=weight] if insample==1 & female_baseline==1                     , cl(psdpsch98)
	reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & within_5km_lake==1 & female_baseline==0, cl(psdpsch98)

* Mean (s.d.) in control group
	sum total_hours [aw=weight] if insample==1 & treatment==0
	sum total_hours [aw=weight] if insample==1 & treatment==0 & within_5km_lake==0
	
	sum total_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==0
	sum total_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==0 & within_5km_lake==0

	sum total_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==1
	sum total_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==1 & within_5km_lake==0
	
	
// *******************************************************************
// * TABLE S11
// * Heterogeneous deworming impacts, by gender and helminth type
// * Dep. variable: Number of meals eaten yesterday
// *******************************************************************
  
* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	
* Columns 1-3: All
 	reg num_meals_yesterday treatment $x_controls5 [pw=weight] if insample==1                     , cl(psdpsch98)
	reg num_meals_yesterday treatment $x_controls6 [pw=weight] if insample==1                     , cl(psdpsch98)
	reg num_meals_yesterday treatment $x_controls1 [pw=weight] if insample==1 & within_5km_lake==0, cl(psdpsch98)
	
* Columns 4-6: Males
	reg num_meals_yesterday treatment $x_controls5 [pw=weight] if insample==1 & female_baseline==0                     , cl(psdpsch98)
	reg num_meals_yesterday treatment $x_controls6 [pw=weight] if insample==1 & female_baseline==0                     , cl(psdpsch98)
	reg num_meals_yesterday treatment $x_controls1 [pw=weight] if insample==1 & within_5km_lake==0 & female_baseline==0, cl(psdpsch98)
 	
* Columns 7-9: Females
	reg num_meals_yesterday treatment $x_controls5 [pw=weight] if insample==1 & female_baseline==1                     , cl(psdpsch98)
	reg num_meals_yesterday treatment $x_controls6 [pw=weight] if insample==1 & female_baseline==1                     , cl(psdpsch98)
	reg num_meals_yesterday treatment $x_controls1 [pw=weight] if insample==1 & within_5km_lake==1 & female_baseline==0, cl(psdpsch98)

* Mean (s.d.) in control group
	sum num_meals_yesterday [aw=weight] if insample==1 & treatment==0
	sum num_meals_yesterday [aw=weight] if insample==1 & treatment==0 & within_5km_lake==0
	
	sum num_meals_yesterday [aw=weight] if insample==1 & treatment==0 & female_baseline==0
	sum num_meals_yesterday [aw=weight] if insample==1 & treatment==0 & female_baseline==0 & within_5km_lake==0

	sum num_meals_yesterday [aw=weight] if insample==1 & treatment==0 & female_baseline==1
	sum num_meals_yesterday [aw=weight] if insample==1 & treatment==0 & female_baseline==1 & within_5km_lake==0
	
	
// *******************************************************************
// * TABLE S12
// * Heterogeneous deworming impacts, by gender and helminth type
// * Dep. variable: Passed secondary school entrance exam...
// *******************************************************************
  
* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	
* Columns 1-3: All
 	reg passed_primary_exam treatment $x_controls5 [pw=weight] if insample==1                     , cl(psdpsch98)
	reg passed_primary_exam treatment $x_controls6 [pw=weight] if insample==1                     , cl(psdpsch98)
	reg passed_primary_exam treatment $x_controls1 [pw=weight] if insample==1 & within_5km_lake==0, cl(psdpsch98)
	
* Columns 4-6: Males
	reg passed_primary_exam treatment $x_controls5 [pw=weight] if insample==1 & female_baseline==0                     , cl(psdpsch98)
	reg passed_primary_exam treatment $x_controls6 [pw=weight] if insample==1 & female_baseline==0                     , cl(psdpsch98)
	reg passed_primary_exam treatment $x_controls1 [pw=weight] if insample==1 & within_5km_lake==0 & female_baseline==0, cl(psdpsch98)
 	
* Columns 7-9: Females
	reg passed_primary_exam treatment $x_controls5 [pw=weight] if insample==1 & female_baseline==1                     , cl(psdpsch98)
	reg passed_primary_exam treatment $x_controls6 [pw=weight] if insample==1 & female_baseline==1                     , cl(psdpsch98)
	reg passed_primary_exam treatment $x_controls1 [pw=weight] if insample==1 & within_5km_lake==1 & female_baseline==0, cl(psdpsch98)

* Mean (s.d.) in control group
	sum passed_primary_exam [aw=weight] if insample==1 & treatment==0
	sum passed_primary_exam [aw=weight] if insample==1 & treatment==0 & within_5km_lake==0
	
	sum passed_primary_exam [aw=weight] if insample==1 & treatment==0 & female_baseline==0
	sum passed_primary_exam [aw=weight] if insample==1 & treatment==0 & female_baseline==0 & within_5km_lake==0

	sum passed_primary_exam [aw=weight] if insample==1 & treatment==0 & female_baseline==1
	sum passed_primary_exam [aw=weight] if insample==1 & treatment==0 & female_baseline==1 & within_5km_lake==0
	
	
// *******************************************************************
// * TABLE S13
// * Heterogeneous deworming impacts, by gender and helminth type
// * Dep. variable: Ln(Total labor earnings), past month
// *******************************************************************
  
* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	
* Columns 1-3: All
 	reg ln_emp_salary_total treatment $x_controls5 [pw=weight] if insample==1                     , cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls6 [pw=weight] if insample==1                     , cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls1 [pw=weight] if insample==1 & within_5km_lake==0, cl(psdpsch98)
	
* Columns 4-6: Males
	reg ln_emp_salary_total treatment $x_controls5 [pw=weight] if insample==1 & female_baseline==0                     , cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls6 [pw=weight] if insample==1 & female_baseline==0                     , cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls1 [pw=weight] if insample==1 & within_5km_lake==0 & female_baseline==0, cl(psdpsch98)
 	
* Columns 7-9: Females
	reg ln_emp_salary_total treatment $x_controls5 [pw=weight] if insample==1 & female_baseline==1                     , cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls6 [pw=weight] if insample==1 & female_baseline==1                     , cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls1 [pw=weight] if insample==1 & within_5km_lake==1 & female_baseline==0, cl(psdpsch98)

* Mean (s.d.) in control group
	sum ln_emp_salary_total [aw=weight] if insample==1 & treatment==0
	sum ln_emp_salary_total [aw=weight] if insample==1 & treatment==0 & within_5km_lake==0
	
	sum ln_emp_salary_total [aw=weight] if insample==1 & treatment==0 & female_baseline==0
	sum ln_emp_salary_total [aw=weight] if insample==1 & treatment==0 & female_baseline==0 & within_5km_lake==0

	sum ln_emp_salary_total [aw=weight] if insample==1 & treatment==0 & female_baseline==1
	sum ln_emp_salary_total [aw=weight] if insample==1 & treatment==0 & female_baseline==1 & within_5km_lake==0
	
	
// *******************************************************************
// * TABLE S14
// * Baseline (1998) summary statistics across treatment groups,
// * for wage-earner subsample
// *******************************************************************

* Open data set
	use "$da/Baird-etal-QJE-2016_data_attrition.dta", clear

* Age (1998)	
	reg s2_age98_klps treatment [pw=weight] if surveyed==1 & emp==1                     , cl(psdpsch98)
	reg s2_age98_klps treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==0, cl(psdpsch98)
	reg s2_age98_klps treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==1, cl(psdpsch98)

	sum s2_age98_klps [aw=weight] if surveyed==1 & emp==1 & treatment==0
	sum s2_age98_klps [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==0
	sum s2_age98_klps [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==1
	
* Grade (1998)
	reg std98_base treatment [pw=weight] if surveyed==1 & emp==1                     , cl(psdpsch98)
	reg std98_base treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==0, cl(psdpsch98)
	reg std98_base treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==1, cl(psdpsch98)

	sum std98_base [aw=weight] if surveyed==1 & emp==1 & treatment==0
	sum std98_base [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==0
	sum std98_base [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==1

* Female
	reg female_baseline treatment [pw=weight] if surveyed==1 & emp==1, cl(psdpsch98)
	sum female_baseline [aw=weight] if surveyed==1 & emp==1 & treatment==0

* School average test score (1996)
	reg avgtest96 treatment [pw=weight] if surveyed==1 & emp==1                     , cl(psdpsch98)
	reg avgtest96 treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==0, cl(psdpsch98)
	reg avgtest96 treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==1, cl(psdpsch98)

	sum avgtest96 [aw=weight] if surveyed==1 & emp==1 & treatment==0
	sum avgtest96 [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==0
	sum avgtest96 [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==1
	
* Primary school located in Budalangi division
	reg buda treatment [pw=weight] if surveyed==1 & emp==1                     , cl(psdpsch98)
	reg buda treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==0, cl(psdpsch98)
	reg buda treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==1, cl(psdpsch98)

	sum buda [aw=weight] if surveyed==1 & emp==1 & treatment==0
	sum buda [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==0
	sum buda [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==1
	
* Population of primary schools
	reg pup_pop treatment [pw=weight] if surveyed==1 & emp==1                     , cl(psdpsch98)
	reg pup_pop treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==0, cl(psdpsch98)
	reg pup_pop treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==1, cl(psdpsch98)

	sum pup_pop [aw=weight] if surveyed==1 & emp==1 & treatment==0
	sum pup_pop [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==0
	sum pup_pop [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==1
	
* Total primary school students within 6 km
	reg popT_06k_updated treatment [pw=weight] if surveyed==1 & emp==1                     , cl(psdpsch98)
	reg popT_06k_updated treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==0, cl(psdpsch98)
	reg popT_06k_updated treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==1, cl(psdpsch98)

	sum popT_06k_updated [aw=weight] if surveyed==1 & emp==1 & treatment==0
	sum popT_06k_updated [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==0
	sum popT_06k_updated [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==1
	
* Primary school students within 6 km who are treatment (Group 1,2) pupils
	reg pop12_06k_updated treatment [pw=weight] if surveyed==1 & emp==1                     , cl(psdpsch98)
	reg pop12_06k_updated treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==0, cl(psdpsch98)
	reg pop12_06k_updated treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==1, cl(psdpsch98)

	sum pop12_06k_updated [aw=weight] if surveyed==1 & emp==1 & treatment==0
	sum pop12_06k_updated [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==0
	sum pop12_06k_updated [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==1
	
* Saturation (Pj)
	reg saturation treatment [pw=weight] if surveyed==1 & emp==1                     , cl(psdpsch98)
	reg saturation treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==0, cl(psdpsch98)
	reg saturation treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==1, cl(psdpsch98)

	sum saturation [aw=weight] if surveyed==1 & emp==1 & treatment==0
	sum saturation [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==0
	sum saturation [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==1
	
* Years of assigned deworming treatment, 1998-2003
	reg Tyears_base treatment [pw=weight] if surveyed==1 & emp==1                     , cl(psdpsch98)
	reg Tyears_base treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==0, cl(psdpsch98)
	reg Tyears_base treatment [pw=weight] if surveyed==1 & emp==1 & female_baseline==1, cl(psdpsch98)

	sum Tyears_base [aw=weight] if surveyed==1 & emp==1 & treatment==0
	sum Tyears_base [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==0
	sum Tyears_base [aw=weight] if surveyed==1 & emp==1 & treatment==0 & female_baseline==1


// *******************************************************************
// * TABLE S15
// * Hours Worked Decomposition - Extensive versus Intensive Margins
// *******************************************************************

* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	
// Panel A: Total hours in all sectors

	* Hours Worked
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
		sum total_hours [aw=weight] if insample==1 & treatment==0
		sum total_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum total_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
	* Indicator for hours > 0
		reg worked_hours treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg worked_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg worked_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
		sum worked_hours [aw=weight] if insample==1 & treatment==0
		sum worked_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum worked_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
	* Hours worked, among those with hours > 0
		reg total_hours_positive treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg total_hours_positive treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg total_hours_positive treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
		sum total_hours_positive [aw=weight] if insample==1 & treatment==0
		sum total_hours_positive [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum total_hours_positive [aw=weight] if insample==1 & treatment==0 & female_baseline==1

// Panel B: Agriculture

	* Hours worked
		reg farmhrs2_ALL treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg farmhrs2_ALL treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg farmhrs2_ALL treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
		sum farmhrs2_ALL [aw=weight] if insample==1 & treatment==0
		sum farmhrs2_ALL [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum farmhrs2_ALL [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
	* Indicator for hours > 0
		reg worked_farm_hours treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg worked_farm_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg worked_farm_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
		sum worked_farm_hours [aw=weight] if insample==1 & treatment==0
		sum worked_farm_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum worked_farm_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
	* Hours worked, among those with hours > 0
		reg farmhrs2_pos treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg farmhrs2_pos treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg farmhrs2_pos treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
		sum farmhrs2_pos [aw=weight] if insample==1 & treatment==0
		sum farmhrs2_pos [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum farmhrs2_pos [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
// Panel C: Wage Employment  

	* Hours worked
		reg emp_hrs7_total_ALL treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg emp_hrs7_total_ALL treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg emp_hrs7_total_ALL treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
		sum emp_hrs7_total_ALL [aw=weight] if insample==1 & treatment==0
		sum emp_hrs7_total_ALL [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum emp_hrs7_total_ALL [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
	* Indicator for hours > 0
		reg worked_emp_hours treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg worked_emp_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg worked_emp_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
		sum worked_emp_hours [aw=weight] if insample==1 & treatment==0
		sum worked_emp_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum worked_emp_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
	* Hours worked, among those with hours > 0
		reg emp_hrs7_total_pos treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg emp_hrs7_total_pos treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg emp_hrs7_total_pos treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
		sum emp_hrs7_total_pos [aw=weight] if insample==1 & treatment==0
		sum emp_hrs7_total_pos [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum emp_hrs7_total_pos [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
// Panel D: Self-Employment (non-agricultural) 
 
	* Hours worked
		reg selfemp_hrs7_total_ALL treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg selfemp_hrs7_total_ALL treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg selfemp_hrs7_total_ALL treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
		sum selfemp_hrs7_total_ALL [aw=weight] if insample==1 & treatment==0
		sum selfemp_hrs7_total_ALL [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum selfemp_hrs7_total_ALL [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
	* Indicator for hours > 0
		reg worked_self_hours treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg worked_self_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg worked_self_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
		sum worked_self_hours [aw=weight] if insample==1 & treatment==0
		sum worked_self_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum worked_self_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
	* Hours worked, among those with hours > 0
		reg selfemp_hrs7_total_pos treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg selfemp_hrs7_total_pos treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg selfemp_hrs7_total_pos treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
		sum selfemp_hrs7_total_pos [aw=weight] if insample==1 & treatment==0
		sum selfemp_hrs7_total_pos [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum selfemp_hrs7_total_pos [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		

// *******************************************************************
// * TABLE S16
// * Deworming impacts on occupation, within the wage earner subsample
// *******************************************************************

* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear

* Agriculture
	reg industry1 treatment $x_controls1 [pw=weight] if emp==1 & insample==1                     , cl(psdpsch98)
	reg industry1 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==0, cl(psdpsch98)
	reg industry1 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==1, cl(psdpsch98)

	sum industry1 [aw=weight] if emp==1 & insample==1 & grp3==1
	sum industry1 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==0
	sum industry1 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==1
	
* Casual/Construction laborer
	reg industry2 treatment $x_controls1 [pw=weight] if emp==1 & insample==1                     , cl(psdpsch98)
	reg industry2 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==0, cl(psdpsch98)
	reg industry2 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==1, cl(psdpsch98)

	sum industry2 [aw=weight] if emp==1 & insample==1 & grp3==1
	sum industry2 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==0
	sum industry2 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==1

* Fishing
	reg industry3 treatment $x_controls1 [pw=weight] if emp==1 & insample==1                     , cl(psdpsch98)
	reg industry3 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==0, cl(psdpsch98)
	reg industry3 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==1, cl(psdpsch98)

	sum industry3 [aw=weight] if emp==1 & insample==1 & grp3==1
	sum industry3 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==0
	sum industry3 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==1
	
* Manufacturing
	reg industry4 treatment $x_controls1 [pw=weight] if emp==1 & insample==1                     , cl(psdpsch98)
	reg industry4 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==0, cl(psdpsch98)
	reg industry4 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==1, cl(psdpsch98)

	sum industry4 [aw=weight] if emp==1 & insample==1 & grp3==1
	sum industry4 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==0
	sum industry4 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==1
	
* Retail and wholesale trade
	reg industry5 treatment $x_controls1 [pw=weight] if emp==1 & insample==1                     , cl(psdpsch98)
	reg industry5 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==0, cl(psdpsch98)
	reg industry5 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==1, cl(psdpsch98)

	sum industry5 [aw=weight] if emp==1 & insample==1 & grp3==1
	sum industry5 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==0
	sum industry5 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==1
	
* Services (all)
	reg industry6 treatment $x_controls1 [pw=weight] if emp==1 & insample==1                     , cl(psdpsch98)
	reg industry6 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==0, cl(psdpsch98)
	reg industry6 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==1, cl(psdpsch98)

	sum industry6 [aw=weight] if emp==1 & insample==1 & grp3==1
	sum industry6 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==0
	sum industry6 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==1
	
* Domestic
	reg industry7 treatment $x_controls1 [pw=weight] if emp==1 & insample==1                     , cl(psdpsch98)
	reg industry7 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==0, cl(psdpsch98)
	reg industry7 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==1, cl(psdpsch98)

	sum industry7 [aw=weight] if emp==1 & insample==1 & grp3==1
	sum industry7 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==0
	sum industry7 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==1
	
* Restaurants, cafes, etc.
	reg industry8 treatment $x_controls1 [pw=weight] if emp==1 & insample==1                     , cl(psdpsch98)
	reg industry8 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==0, cl(psdpsch98)
	reg industry8 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==1, cl(psdpsch98)

	sum industry8 [aw=weight] if emp==1 & insample==1 & grp3==1
	sum industry8 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==0
	sum industry8 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==1
	
* Trade contractors
	reg industry9 treatment $x_controls1 [pw=weight] if emp==1 & insample==1                     , cl(psdpsch98)
	reg industry9 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==0, cl(psdpsch98)
	reg industry9 treatment $x_controls1 [pw=weight] if emp==1 & insample==1 & female_baseline==1, cl(psdpsch98)

	sum industry9 [aw=weight] if emp==1 & insample==1 & grp3==1
	sum industry9 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==0
	sum industry9 [aw=weight] if emp==1 & insample==1 & grp3==1 & female_baseline==1
	

// *******************************************************************
// * TABLE S17
// * Average characteristics of occupations within wage employment
// *******************************************************************

* Open data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear

* Agriculture
	sum emp_hrs7_total s16_1_10poorhealth emp_salary_total [aw=weight] if industry1==1 & emp==1 & insample==1 & grp3==1
	
* Casual/Construction laborer
	sum emp_hrs7_total s16_1_10poorhealth emp_salary_total [aw=weight] if industry2==1 & emp==1 & insample==1 & grp3==1
	
* Fishing
	sum emp_hrs7_total s16_1_10poorhealth emp_salary_total [aw=weight] if industry3==1 & emp==1 & insample==1 & grp3==1
	
* Manufacturing
	sum emp_hrs7_total s16_1_10poorhealth emp_salary_total [aw=weight] if industry4==1 & emp==1 & insample==1 & grp3==1
	
* Retail and wholesale trade
	sum emp_hrs7_total s16_1_10poorhealth emp_salary_total [aw=weight] if industry5==1 & emp==1 & insample==1 & grp3==1
	
* Services (all)
	sum emp_hrs7_total s16_1_10poorhealth emp_salary_total [aw=weight] if industry6==1 & emp==1 & insample==1 & grp3==1
	
* Domestic
	sum emp_hrs7_total s16_1_10poorhealth emp_salary_total [aw=weight] if industry7==1 & emp==1 & insample==1 & grp3==1
	
* Restaurants, cafes, etc.
	sum emp_hrs7_total s16_1_10poorhealth emp_salary_total [aw=weight] if industry8==1 & emp==1 & insample==1 & grp3==1
	
* Trade contractors
	sum emp_hrs7_total s16_1_10poorhealth emp_salary_total [aw=weight] if industry9==1 & emp==1 & insample==1 & grp3==1


// *******************************************************************
// * TABLES S18, S19, S20, S21
// * Multiple testing adjustments for key outcomes
// *******************************************************************

* See separate do file titled "Baird-etal-QJE-2016_multiple-testing-adjustment.do" for this output.


// *******************************************************************
// * TABLES S22 and S23
// * Fiscal impacts of deworming subsidies
// *******************************************************************

// CALIBRATION PARAMETERS
	clear	

	// Parameters
		// Number of weeks in the year
			scalar WEEKS = 52 
		// Tax rate
			// Calculated as government expenditures as a % of GDP (World Bank Development Indicators; 0.195) 
			// multiplied by percent non-donor financed (World Bank Africa Can Blog, "Three myths about aid to Kenya"; 0.85).
			// Final calculation: 0.195 * 0.85
			scalar TAX   = 0.16575 
		// Mean starting wage 
			// Calculated as sum of (i) agricultural hourly wage from Suri (2011; Ksh 11.84) multiplied by share 
			// of average weekly hours in agriculture in control group (Table III; 0.44864865); (ii) employment wage (Table IV, Panel B,
			// average control group hourly wage employment wage conditional on working >=10 hours per week in wage employment, 
			// exp(Ksh 2.68)) multiplied by share of average weekly hours in wage employment in control group (Table III, 0.37297297); and
			// (iii) average control group hourly self-employment wage (calculated from total self-employed profits last month in control group 
			// (Table IV, Panel C, Ksh 1,766) divided by 4.5 times weekly self-employed hours conditional on working positive hours 
			// (Table S15, Panel D, 38.1)) multiplied by share of average weekly hours in self-employment employment in control 
			// group (Table III, 0.17837838); with this sum divided by exchange rate of Ksh to USD (Central Bank of Kenya, 74).
			// Final calculation: ((11.84 * 0.44864865) + (EXP(2.68) * 0.37297297) + ((1766/(4.5*38.1)) * 0.17837838)) / 74
			scalar WAGE  = 0.17012446 
		// Fraction of treated primary school students within 6 km
			// Calculated as overall saturation (in treatment and control group; 0.511) divided by take-up rate (Table V, Panel A, 0.75).
			// Final calculation: 0.511 / 0.75
			scalar R     = 0.68133333 
		// Multiplier
			// Calculated as defined in Baird-etal-QJE-2016_fiscal-impacts-detail.pdf, where:
			// g = average per-capita GDP growth rate in Kenya during the 2001 to 2011 period (World Bank Development Indicators; 1.52% per annum)
			// r = annual real interest rate in Kenya (Kenyan interest on sovereign debt from Central Bank of Kenya minus Kenyan inflation rate from WDI; 9.85%)
			// gamma_1 = coeffcient on age from regression of earnings on age, age^2, female dummy, indicators for attained primary/secondary/beyond, 
				// and province dummies, using 1998/1999 Kenyan Labor Force Survey (0.1019575)
			// gamme_2 = absolute value of coeffcient on age^2 from regression of earnings on age, age^2, female dummy, indicators for attained primary/secondary/beyond, 
				// and province dummies, using 1998/1999 Kenyan Labor Force Survey (0.0010413)
			// Final calculation: See formula for OMEGA in Baird-etal-QJE-2016_fiscal-impacts-detail.pdf.	
			scalar OMEGA = 9.22621041 
		// Multiplier 2 (with No Life Cycle Earnings Adjustment or Productivity Growth)
			scalar OMEGA2 = 4.26617334
		
	// Increase in hours worked 
		// Lambda 1 (partial subsidy)
			// Calculated as increase in work hours/week for men (Table III, Panel A, 3.49) * 1/2 (women no change; Table III, Panel A) = (3.49*0.5)
			// multiplied by uptake at partial subsidy divided by uptake at full subsidy (Table V, Panel A, 0.19/0.75).
			// Final calculation: 3.49*.5*(.19/.75)
			scalar b = 0.44206667  
		// Lambda 1 (full subsidy)  
			// Calculated as increase in work hours/week for men (Table III, Panel A, 3.49) * 1/2 (women no change; Table III, Panel A) = (3.49*0.5)
			// multiplied by uptake at full subsidy divided by uptake at full subsidy (Table V, Panel A, 0.75/0.75). 
			// Final calculation: 3.49 * .5 * (.75/.75)
			scalar B = 1.745 
		// Lambda 2 (partial subsidy)
			// Calculated as increase in work hours/week due to externality (Table III, Panel A, 10.2), multiplied by fraction of treated 
			// primary school students within 6 km (See R above, 0.68133333), multiplied by uptake at partial subsidy divided by uptake at 
			// full subsidy (Table V, Panel A, 0.19/0.75). 
			// Final calculation: 10.2 * 0.68133333 * (.19/.75)
			scalar g = 1.76056533 
		// Lambda 2 (full subsidy) 
			// Calculated as increase in work hours/week due to externality (Table III, Panel A, 10.2), multiplied by fraction of treated 
			// primary school students within 6 km (See R above, 0.68133333), multiplied by uptake at full subsidy (Table V, Panel A, 0.75). 
			// Final calculation: 10.2 * 0.68133333 * 0.75
			scalar G = 5.2122 
		// Mu 1 (partial subsidy)
			// Calculated as mean per person increase in earnings/month (Table IV, Panel A, Ksh 112, or $1.5135)
			// multiplied by uptake at partial subsidy divided by uptake at full subsidy (Table V, Panel A, 0.19/0.75).
			// Final calculation: 1.5135 * (.19/.75)
			scalar mu_p = 0.38342342 
		// Mu 1 (full subsidy)
			// Calculated as mean per person increase in earnings/month (Table IV, Panel A, Ksh 112, or $1.5135)
			// multiplied by uptake at full subsidy divided by uptake at full subsidy (Table V, Panel A, 0.75/0.75).
			// Final calculation: 1.5135 * (.75/.75)
			scalar mu_f = 1.51351351 
		
	// Increase in schooling costs
		// Note that additional secondary schools costs per pupil per year ($116.85) are calculated as 
			// the sum of yearly secondary schooling compensation ($5041) and yearly secondary schooling teacher benefits ($217.47), 
			// divided by average pupils per teacher (45). These figures were received from the Kenyan field team.
		// Mean increase in schooling costs (partial subsidy)
			// Caculated as the discounted value of [additional secondary schooling costs per pupil per year (See note above, $116.85) 
			// multiplied by the direct increase in secondary schooling (Table S3, by year for 1999-2007)], multiplied by uptake at partial subsidy 
			// divided by uptake at full subsidy (Table V, Panel A, 0.19/0.75).
			scalar sb = 2.71313999 
		// Mean increase in schooling costs (full subsidy)
			// Caculated as the discounted value of [additional secondary schooling costs per pupil per year (See note above, $116.85) 
			// multiplied by the direct increase in secondary schooling (Table S3, by year for 1999-2007)], multiplied by uptake at full subsidy 
			// divided by uptake at full subsidy (Table V, Panel A, 0.75/0.75).
			scalar sB = 10.7097631 
		// Mean increase in schooling costs from externality (partial subsidy)
			// Caculated as the discounted value of [additional secondary schooling costs per pupil per year (See note above, $116.85) 
			// multiplied by the externality increase in secondary schooling (do file for Table S3, by year for 1999-2007)], 
			// multiplied by uptake at partial subsidy divided by uptake at full subsidy (Table V, Panel A, 0.19/0.75).
			scalar sg = 3.399739651 
		// Mean increase in schooling costs from externality (full subsidy)
			// Caculated as the discounted value of [additional secondary schooling costs per pupil per year (See note above, $116.85) 
			// multiplied by the externality increase in secondary schooling (do file for Table S3, by year for 1999-2007)], 
			// multiplied by uptake at full subsidy divided by uptake at full subsidy (Table V, Panel A, 0.75/0.75).
			scalar sG = 13.4200249 
	
// TABLE S22, PANEL B: No Health Spillovers
	
	* Partial subsidy
		di %9.2f mu_p * 12
		di %9.2f mu_p * 12 * OMEGA
		di %9.2f mu_p * 12 * OMEGA * TAX - sb
		
	* Full subsidy
		di %9.2f mu_f * 12
		di %9.2f mu_f * 12 * OMEGA
		di %9.2f mu_f * 12 * OMEGA * TAX - sB
		
// TABLE S23, PANEL B: No Health Spillovers
	
	* Partial subsidy
		di %9.2f (b * WEEKS * WAGE)
		di %9.2f (b * WEEKS * WAGE * OMEGA2)
		di %9.2f (b * WEEKS * WAGE * OMEGA2) * TAX - sb
		
	* Full subsidy
		di %9.2f (B * WEEKS * WAGE)
		di %9.2f (B * WEEKS * WAGE * OMEGA2)
		di %9.2f (B * WEEKS * WAGE * OMEGA2) * TAX - sB

// TABLE S23, PANEL C: With Health Spillovers
	
	* Partial subsidy
		di %9.2f (b + g/R) * WEEKS * WAGE
		di %9.2f (b + g/R) * WEEKS * WAGE * OMEGA2
		di %9.2f (b + g/R) * WEEKS * WAGE * OMEGA2 * TAX - (sb + sg)
		
	* Full subsidy
		di %9.2f (B + G/R) * WEEKS * WAGE
		di %9.2f (B + G/R) * WEEKS * WAGE * OMEGA2
		di %9.2f (B + G/R) * WEEKS * WAGE * OMEGA2 * TAX - (sB + sG)


// *******************************************************************
// * RESULTS PRESENTED IN TEXT ONLY
// *******************************************************************

// Section B.2, Claim: "In the case where the externality effect was pure 'noise', the likelihood of a sign
// 'match' between the two terms would be distributed as a binomial distribution with p=0.5. In that case, 
// 26 of 30 pairs of estimates have the same sign fewer than once in 10,000 cases."
	clear
	// Idea: Generate 30 coin flips, and determine whether 0-4 out of 30 are tails (negative). Do this 10,000 times to get 
	// the approximate distribution of this outcome. What is the implied p-value?
	set obs 10000
	gen obs_id = [_n]
	gen rand_neg = 0
	replace rand_neg = rbinomial(30,0.5)
	tab rand_neg
	histogram rand_neg
	gen extreme = (rand_neg<=4)
	summ extreme

// Section B.2, Claim: "We obtain a correlation between the pairs of t-statistics of 0.750 (P-value < 0.001) when considering 29
// of the 30 post-2001 outcomes in Tables I-IV (ignoring the pregnancy-level marriage result, since the change in the unit
// of observation complicates pooling this data in the analysis)."
	insheet using "$da/Baird-etal-QJE-2016_input_AppB2.csv", clear
	// This file contains all 30 post-2001 outcome variables in Tables 1-4 of Baird et al. (2016), along with the estimated t-statistics from 
	// (1) the regressions presented in those tables on the treatment term and the saturation term, and (2) a similar set of regressions but 
	// this time additionally including an interaction between the treatment and saturation term (using controls 7 at the start of this do file). 
	pwcorr t_1dir t_1ext, sig obs
	
// Section B.2, Claim: "We obtain a relatively weak and not statistically significant correlation of 0.271 (P-value=0.155) for the full sample."
	insheet using "$da/Baird-etal-QJE-2016_input_AppB2.csv", clear
	// See explanation of this sheet above.
	pwcorr t_2dir t_2interact, sig obs
	
// Section B.2, Claim: "In this SUR analysis, we reject the hypothesis that the cross-school externality effect from 0-6 km is zero (P<0.001)."
	#delimit ;
	clear;
	set matsize 5000;
	use "$da/Baird-etal-QJE-2016_data_primary";
	replace height=. if height<125;
	replace BMI=. if BMI>57;
	
	// Expand dataset by weights, because cannot use pweights in SUR;
	gen weight_rounded=round(weight);
	expand weight_rounded;
	local i=1;
	foreach lhs in 
		/*T1*/ /*2001 health result*/ general_health height BMI /*miscarriage result*/ 
		/*T2*/ totyrs_enrolled total_years_enrolledP repeat_somept s5_highstd2007 s5_attend_secsch_2007 passed_primary_exam out_of_school 
		/*T3*/ total_hours /*age sample*/ selfemp_hrs7_total_ALL farmhrs2_ALL emp_hrs7_total_ALL industry4_ALL industry2_ALL 
				industry7_ALL cash_crop_FULL 
		/*T4*/ num_meals_yesterday /*age sample*/ earnings_nonag_total_ALL /*age sample*/ ln_emp_salary_total ln_wage_10hrs 
				ln_emp_salary_total_2007 selfemp_profits30_total selfemp_profits30_tott5 selfemp_employees_total {;
		regress `lhs'  treatment $x_controls1 if insample==1;
		estimates store su_`i';
		local i=`i'+1;
		};
	suest su_1 su_2 su_3 su_4 su_5 su_6 su_7 su_8 su_9 su_10 su_11 su_12 su_13 su_14 su_15 su_16 su_17 su_18 su_19 su_20 su_21 
		su_22 su_23 su_24 su_25 su_26, vce(cluster psdpsch98);
	test [su_1_mean]saturation_dm [su_2_mean]saturation_dm [su_3_mean]saturation_dm [su_4_mean]saturation_dm [su_5_mean]saturation_dm 
		[su_6_mean]saturation_dm [su_7_mean]saturation_dm [su_8_mean]saturation_dm [su_9_mean]saturation_dm [su_10_mean]saturation_dm  
		[su_11_mean]saturation_dm [su_12_mean]saturation_dm [su_13_mean]saturation_dm [su_14_mean]saturation_dm [su_15_mean]saturation_dm  
		[su_16_mean]saturation_dm [su_17_mean]saturation_dm [su_18_mean]saturation_dm [su_19_mean]saturation_dm	[su_20_mean]saturation_dm  
		[su_21_mean]saturation_dm [su_22_mean]saturation_dm [su_23_mean]saturation_dm [su_24_mean]saturation_dm [su_25_mean]saturation_dm  
		[su_26_mean]saturation_dm;
	#delimit cr

// Section B.2, Claim: "We perform this same SUR estimation including separate terms for 0-3 km and 3-6 km spillovers,
// and also reject the hypothesis that the effects from 3-6 km are zero."
	#delimit ;
	clear;
	set matsize 5000;
	use "$da/Baird-etal-QJE-2016_data_primary";
	replace height=. if height<125;
	replace BMI=. if BMI>57;
	// Expand dataset by weights, because cannot use pweights in SUR;
	gen weight_rounded=round(weight);
	expand weight_rounded;
	local i=1;
	foreach lhs in 
			/*T1*/ /*2001 health result*/ general_health height BMI /*miscarriage result*/
			/*T2*/ totyrs_enrolled total_years_enrolledP repeat_somept s5_highstd2007 s5_attend_secsch_2007 passed_primary_exam out_of_school 
			/*T3*/ total_hours /*age sample*/ selfemp_hrs7_total_ALL farmhrs2_ALL emp_hrs7_total_ALL industry4_ALL industry2_ALL 
					industry7_ALL cash_crop_FULL
			/*T4*/ num_meals_yesterday /*age sample*/ earnings_nonag_total_ALL /*age sample*/ ln_emp_salary_total ln_wage_10hrs 
					ln_emp_salary_total_2007 selfemp_profits30_total selfemp_profits30_tott5 selfemp_employees_total {;
		regress `lhs'  treatment saturation_3km_dm saturation36k_dm demeaned_popT_3km demeaned_popT_36k $x_controls14 if insample==1;
		estimates store su_`i';
		local i=`i'+1;
	};
	suest su_1 su_2 su_3 su_4 su_5 su_6 su_7 su_8 su_9 su_10 su_11 su_12 su_13 su_14 su_15 su_16 su_17 su_18 su_19 su_20 su_21 su_22 su_23 su_24 su_25 su_26, vce(cluster psdpsch98);
	test [su_1_mean]saturation36k_dm [su_2_mean]saturation36k_dm [su_3_mean]saturation36k_dm [su_4_mean]saturation36k_dm [su_5_mean]saturation36k_dm 
		[su_6_mean]saturation36k_dm [su_7_mean]saturation36k_dm [su_8_mean]saturation36k_dm [su_9_mean]saturation36k_dm [su_10_mean]saturation36k_dm 
		[su_11_mean]saturation36k_dm [su_12_mean]saturation36k_dm [su_13_mean]saturation36k_dm [su_14_mean]saturation36k_dm [su_15_mean]saturation36k_dm 
		[su_16_mean]saturation36k_dm [su_17_mean]saturation36k_dm [su_18_mean]saturation36k_dm [su_19_mean]saturation36k_dm	[su_20_mean]saturation36k_dm 
		[su_21_mean]saturation36k_dm [su_22_mean]saturation36k_dm [su_23_mean]saturation36k_dm [su_24_mean]saturation36k_dm [su_25_mean]saturation36k_dm [su_26_mean]saturation36k_dm;
	#delimit cr	
		
// Section C.1, Claim: "The RTR in KLPS-2 is 64.3% and the ITR is 61.2%, which implies that the ETR = 86.2% when including
// all those surveyed, plus those who refused or were found but were unable to be surveyed, and the deceased."
	use "$da/Baird-etal-QJE-2016_data_attrition.dta", clear
	gen found_reg=found
	replace found_reg=0 if found==1 & intensive==1
	tab found_reg [aw=weight_initialsample] /*RTR*/
	tab found if intensive==1 [aw=weight_initialsample] /*ITR*/
	tab found if attrition_sample==1 [aw=weight] /*ETR*/
	
// Section C.1, Claim: "There are no significant deworming impacts on migration out of the study district or to urban areas (not shown)."	
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	regress residence_outbusia treatment $x_controls1  [pw=weight] if insample==1 , cl(psdpsch98)
	regress s3_district_city treatment $x_controls1  [pw=weight] if insample==1 , cl(psdpsch98)

// Section C.2, Claim: "Reassuringly, we cannot reject that treatment effect estimates are equal in the regular tracking
// and the intensive tracking subsamples for the outcomes in Table II (results not shown)."
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	gen T_intensive=intensive*treatment
	foreach lhs in totyrs_enrolled total_years_enrolledP repeat_somept s5_highstd2007 s5_attend_secsch_2007 passed_primary_exam out_of_school {
		reg `lhs' treatment intensive T_intensive $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg `lhs' treatment intensive T_intensive $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg `lhs' treatment intensive T_intensive $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
		}

// Section C.3, Claim: "a plausible lower bound on the total increase in time spent in school induced by the deworming intervention 
// is the 0.137 gain in school participation from 1998-2001 plus the school enrollment gains from 2002-2007 (multiplied by average 
// attendance conditional on enrollment), which works out to nearly 0.3 additional years of schooling (not shown)."
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	// First, the 0.137 gain in school participation from 1998-2001 
	reg totpar treatment $x_controls2 [pweight=weight], robust cluster(psdpsch98)
	// Then, the school enrollment gains from 2002-2007 
	reg s5_attendsch2002 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
	reg s5_attendsch2003 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
	reg s5_attendsch2004 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
	reg s5_attendsch2005 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
	reg s5_attendsch2006 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
	reg s5_attendsch2007 treatment $x_controls1 [pw=weight] if insample_edu_matrix==1, cl(psdpsch98)
	// Finally, average attendance (in 1998) conditional on enrollment
	sum totpar98 if totprs98>0 & totprs98!=.
	// So, calculation is: (0.137+(.883*(.048+.046+.028+.035+.017+.007)))=0.297

// Section C.3, Claim: "We also have test score information for KLPS-2 respondents, from an English vocabulary test and a Raven’s 
// Matrices test. There are no statistically significant treatment effects of deworming on either of these outcome measures 
// (normalized within the sample), using the standard regression specification, either in the full sample or broken out by gender (not shown)."		
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	foreach lhs in ravensB_normalized cognitive_EngVocab_normalized {
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	}
	
// Section C.4, Claim: "...73% in the out-of-school subsample, and 78% for the subsample above median age 12 (not shown)."		
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	sum worked_hours [aw=weight] if insample==1 & treatment==0 & out_of_school==1
	sum worked_hours [aw=weight] if insample==1 & treatment==0 & age_older==1

// Section C.4, Claim "77% of self-employed women are in retail. While 44% of the male self-employed also work in retail, 
// others work in occupations such as commercial fishing (21%), small manufacturing (12%) and passenger transport (9%)... 
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	tab primary_industry_self_indicator [aw=weight] if female_baseline==1 & insample==1 & selfemp==1 & treatment==0
	tab primary_industry_self_indicator [aw=weight] if female_baseline==0 & insample==1 & selfemp==1 & treatment==0

// Section C.5, Claim "It changes little in response to trimming the top 1% of earners, so the result is not driven by outliers, 
// and to including a full set of gender-age fixed effects (results not shown)."
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	reg ln_emp_salary_total_trimmed treatment $x_controls1 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_emp_salary_total treatment $x_controls1 gender_age_base_I* [pw=weight] if insample==1, cl(psdpsch98)
	
// Section C.5, Claim: "A decomposition along the lines of Oaxaca (1973) - which uses mean earnings by occupation in the control group 
// as a reference point - indicates that among wage earners, 75% of the higher earnings in the treatment group can be accounted 
// for by occupational shifts (not shown), for instance, the shift into manufacturing and out of casual labor."
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	// Treatment impact and mean earnings in control group, by industry
	foreach num of numlist 1/20 {
		des industry`num'
		reg industry`num' treatment $x_controls1 [pw=weight] if insample==1 & emp==1, cl(psdpsch98)
		sum emp_salary_total [aw=weight] if insample==1 & emp==1 & industry`num'==1 & treatment==0
		}
	// Overall treatment impact on earnings
	des emp_salary_total
	reg emp_salary_total treatment $x_controls1 [pw=weight] if insample==1 & emp==1, cl(psdpsch98)
	// Plug these results into Excel Spreadsheet "Baird-etal-QJE-2016_Oaxaca-Decomposition" to perform decomposition calculation.
	
// Section C.5, Claim: "We obtain similar results on firm profits (Table IV, Panel C) using both the inverse sine hyperbolic 
// transformation and log profits (not shown)."
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	gen IHS_selfemp_profits30_total=log(selfemp_profits30_total + sqrt(selfemp_profits30_total^2 + 1))
	gen ln_selfemp_profits30_total=ln(selfemp_profits30_total)
	reg IHS_selfemp_profits30_total treatment $x_controls1 [pw=weight] if insample==1, cl(psdpsch98)
	reg ln_selfemp_profits30_total treatment $x_controls1 [pw=weight] if insample==1, cl(psdpsch98)

// Section C.5, Claim: "There are large, positive but not statistically significant impacts on a monthly profit measure based 
// directly on revenues and expenses reported in the survey (not shown)."
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	reg selfemp_profits30_total_cal treatment $x_controls1 [pw=weight] if insample==1, cl(psdpsch98)

// Section C.5, Claim: "The estimated effect on total per capita consumption is near zero and not statistically significant 
// but the confidence interval is large and includes both substantial gains and losses (not shown)."
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	egen ptile98=pctile(pc_ttl_cnsmp_avg_df_usd), p(98)
	gen pc_ttl_cnsmp_avg_df_usd_trm=pc_ttl_cnsmp_avg_df_usd
	replace pc_ttl_cnsmp_avg_df_usd_trm=. if pc_ttl_cnsmp_avg_df_usd>ptile98
	regress pc_ttl_cnsmp_avg_df_usd treatment $x_controls1 [pw=weight] if insample==1, cl(psdpsch98)
	regress pc_ttl_cnsmp_avg_df_usd_trm treatment $x_controls1 [pw=weight] if insample==1, cl(psdpsch98)

// Section C.6, Claim: "For instance, a sizeable 25% of KLPS-2 males who work positive hours for wages worked more than 60 hours in the last week..."
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	gen emp60hrs_indic=0 if emp_hrs7_total_pos!=.
	replace emp60hrs_indic=1 if emp_hrs7_total_pos>60 & emp_hrs7_total_pos!=.
	sum emp60hrs_indic [aw=weight] if female_baseline==0
	
log c
