// *************************************************************************************************
// * ANALYSIS DO FILE FOR "WORMS AT WORK: LONG-RUN IMPACTS OF A CHILD HEALTH INVESTMENT"
// * SARAH BAIRD, JOAN HAMORY HICKS, MICHAEL KREMER, AND EDWARD MIGUEL
// * DATE: JULY 2016 
// *************************************************************************************************

// NOTE: THIS DO FILE PRODUCES THE TABLES, FIGURES, AND IN-TEXT RESULTS PRESENTED IN BAIRD ET AL. (2016)

// Preamble
	version 10.1
	clear
	set mem 750m
	set matsize 800
	set more off
	cap log close

// Folder structure
	global dir   = "" // UPDATE THIS FOLDER FOR YOUR MACHINE
	global da   = "$dir/data"
	global dl    = "$dir/output" 
	global output = "$dir/output"

// Start log file and date
	log using "$dl/Baird-etal-QJE-2016_log_main.txt", replace text


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

		
// *******************************************************************
// * TABLE I
// * Deworming impacts on health
// *******************************************************************

// Moderate-heavy worm infections in 2001
	
	* Open data set
		use "$da/Baird-etal-QJE-2016_data_infection9802", clear
		keep if year==2001
	
	* Regressions
		reg any_ics treatment $x_controls2 if insample==1                     , cl(psdpsch98)
		reg any_ics treatment $x_controls2 if insample==1 & female_baseline==0, cl(psdpsch98)
		reg any_ics treatment $x_controls2 if insample==1 & female_baseline==1, cl(psdpsch98)
	
	* Control group mean
		sum any_ics if insample==1 & treatment==0
		sum any_ics if insample==1 & treatment==0 & female_baseline==0
		sum any_ics if insample==1 & treatment==0 & female_baseline==1
		
// Self-reported health "very good" indicator at KLPS-2

	* Opens data
		use "$da/Baird-etal-QJE-2016_data_primary", clear
	
	* Regressions
		reg general_health treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg general_health treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg general_health treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
	* Control group mean
		sum general_health [aw=weight] if insample==1 & treatment==0
		sum general_health [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum general_health [aw=weight] if insample==1 & treatment==0 & female_baseline==1

// Height at KLPS-2
	
	* Opens data
		use "$da/Baird-etal-QJE-2016_data_primary", clear
		tab height 
		*Huge dropoff below 125, to unreasonable heights. Trim below 125.
		replace height=. if height<125

	* Regressions
		reg height treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg height treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg height treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	
	* Control group mean
		sum height [aw=weight] if insample==1 & treatment==0
		sum height [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum height [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
// Body mass index (BMI) at KLPS-2
	
	* Opens data
		use "$da/Baird-etal-QJE-2016_data_primary", clear
		tab BMI 
		*Huge jump above 57, to unreasonable BMI levels. Trim above 57.
		replace BMI=. if BMI>57
	
	* Regressions
		reg BMI treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg BMI treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg BMI treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
		
		* Control group mean
		sum BMI [aw=weight] if insample==1 & treatment==0
		sum BMI [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum BMI [aw=weight] if insample==1 & treatment==0 & female_baseline==1

// Miscarriages at KLPS-2 (pregnancy level data)
	
	* Prepares data
		use "$da/Baird-etal-QJE-2016_data_miscarriage", clear
	
	* Regressions
		dprobit miscarriage_plevel treatment $x_controls1  [pw=weight] if insample==1                     , cl(psdpsch98)
		dprobit miscarriage_plevel treatment $x_controls1  [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		dprobit miscarriage_plevel treatment $x_controls1  [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
	 
	 * Control group mean
		sum miscarriage_plevel [aw=weight] if insample==1 & treatment==0
		sum miscarriage_plevel [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum miscarriage_plevel [aw=weight] if insample==1 & treatment==0 & female_baseline==1


// *******************************************************************
// * TABLE II
// * Deworming impacts on education
// *******************************************************************

// Opens data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	
// Loop over all dependent variables
	foreach lhs in totyrs_enrolled total_years_enrolledP repeat_somept s5_highstd2007 s5_attend_secsch_2007 passed_primary_exam out_of_school {
		
	* Regressions
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
		
	* Control group mean
		sum `lhs' [aw=weight] if insample==1 & treatment==0
		sum `lhs' [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum `lhs' [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		}

		
// *******************************************************************
// * TABLE III
// * Deworming impacts on labor hours and occupational choice
// *******************************************************************

// Opens data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear

// Panel A: Hours worked
	
	* Full sample
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
		
	* Full sample - control group mean
		sum total_hours [aw=weight] if insample==1 & treatment==0
		sum total_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum total_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
	* Older than school age
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1                      & s2_age98_klps>12 & s2_age98_klps!=., cl(psdpsch98)
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0 & s2_age98_klps>12 & s2_age98_klps!=., cl(psdpsch98)
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1 & s2_age98_klps>12 & s2_age98_klps!=., cl(psdpsch98)
		
	* Older than school age - control group mean
		sum total_hours [aw=weight] if insample==1 & treatment==0                      & s2_age98_klps>12 & s2_age98_klps!=.
		sum total_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==0 & s2_age98_klps>12 & s2_age98_klps!=.
		sum total_hours [aw=weight] if insample==1 & treatment==0 & female_baseline==1 & s2_age98_klps>12 & s2_age98_klps!=.

// Panel B: Sectoral time allocation (full sample)

	foreach lhs in selfemp_hrs7_total_ALL farmhrs2_ALL emp_hrs7_total_ALL {
	
	* Regressions
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
		
	* Control group mean
		sum `lhs' [aw=weight] if insample==1 & treatment==0
		sum `lhs' [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum `lhs' [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		}

// Panel C: Occupational choice (full sample)

	* Manufacturing, construction, domestic service
		foreach num in 4 2 7 {  
		
		* Regressions
			reg industry`num'_ALL treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
			reg industry`num'_ALL treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
			reg industry`num'_ALL treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)

		* Control group mean
			sum industry`num'_ALL [aw=weight] if insample==1 & treatment==0
			sum industry`num'_ALL [aw=weight] if insample==1 & treatment==0 & female_baseline==0
			sum industry`num'_ALL [aw=weight] if insample==1 & treatment==0 & female_baseline==1
			}

	* Grows cash crop indicator				
		
		* Regressions
			reg cash_crop_FULL treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
			reg cash_crop_FULL treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
			reg cash_crop_FULL treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
			
		* Control group mean
			sum cash_crop_FULL [aw=weight] if insample==1 & treatment==0
			sum cash_crop_FULL [aw=weight] if insample==1 & treatment==0 & female_baseline==0
			sum cash_crop_FULL [aw=weight] if insample==1 & treatment==0 & female_baseline==1


// *******************************************************************
// * TABLE IV
// * Deworming impacts on living standards and labor earnings
// *******************************************************************

// Opens data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear

// Panel A: Consumption and non-agricultural earnings
	foreach lhs in num_meals_yesterday earnings_nonag_total_ALL {

	* Full sample
		reg `lhs' treatment  $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg `lhs' treatment  $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg `lhs' treatment  $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
		
	* Full sample - control group mean
		sum `lhs' [aw=weight] if insample==1 & treatment==0
		sum `lhs' [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum `lhs' [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		
	* Older than school age
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1                      & s2_age98_klps>12 & s2_age98_klps!=., cl(psdpsch98)
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0 & s2_age98_klps>12 & s2_age98_klps!=., cl(psdpsch98)
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1 & s2_age98_klps>12 & s2_age98_klps!=., cl(psdpsch98)
      
	* Older than school age - control group mean
		sum `lhs' [aw=weight] if insample==1 & treatment==0                      & s2_age98_klps>12 & s2_age98_klps!=.
		sum `lhs' [aw=weight] if insample==1 & treatment==0 & female_baseline==0 & s2_age98_klps>12 & s2_age98_klps!=.
		sum `lhs' [aw=weight] if insample==1 & treatment==0 & female_baseline==1 & s2_age98_klps>12 & s2_age98_klps!=.
		}

// Panel B: Wage earnings (among wage earners)
	foreach lhs in ln_emp_salary_total ln_wage_10hrs ln_emp_salary_total_2007 {
		
	* Regressions
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg `lhs' treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)

	* Control group mean
		sum `lhs' [aw=weight] if insample==1 & treatment==0
		sum `lhs' [aw=weight] if insample==1 & treatment==0 & female_baseline==0
		sum `lhs' [aw=weight] if insample==1 & treatment==0 & female_baseline==1
		}

// Panel C: Non-agricultural self-employment outcomes

	* Total self-empoyed profits, Total self-empoyed profits (5% trimmed)
		foreach lhs in selfemp_profits30_total selfemp_profits30_tott5 {
			
		* Regressions
			reg `lhs' treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
			reg `lhs' treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
			reg `lhs' treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
			
		* Control group mean
			sum `lhs' [aw=weight] if insample==1 & treatment==0
			sum `lhs' [aw=weight] if insample==1 & treatment==0 & female_baseline==0
			sum `lhs' [aw=weight] if insample==1 & treatment==0 & female_baseline==1
			}

	* Total employees hired (excluding self)
	
		* Regressions
			nbreg selfemp_employees_total treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
			nbreg selfemp_employees_total treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
			nbreg selfemp_employees_total treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)

		* Control group mean
			sum selfemp_employees_total [aw=weight] if insample==1 & treatment==0
			sum selfemp_employees_total [aw=weight] if insample==1 & treatment==0 & female_baseline==0
			sum selfemp_employees_total [aw=weight] if insample==1 & treatment==0 & female_baseline==1

 
// *******************************************************************
// * TABLE V
// * Fiscal impacts of deworming subsidies
// *******************************************************************

// PANEL A: CALIBRATION PARAMETERS
	
	// Parameters
		clear
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
	
// PANEL B: No Health Spillovers
	
	// Partial subsidy
		di %9.2f (b * WEEKS * WAGE)
		di %9.2f (b * WEEKS * WAGE * OMEGA)
		di %9.2f (b * WEEKS * WAGE * OMEGA) * TAX - sb
		
	// Full subsidy
		di %9.2f (B * WEEKS * WAGE)
		di %9.2f (B * WEEKS * WAGE * OMEGA)
		di %9.2f (B * WEEKS * WAGE * OMEGA) * TAX - sB

// PANEL C: With Health Spillovers
	
	// Partial subsidy
		di %9.2f (b + g/R) * WEEKS * WAGE
		di %9.2f (b + g/R) * WEEKS * WAGE * OMEGA
		di %9.2f (b + g/R) * WEEKS * WAGE * OMEGA * TAX - (sb + sg)
		
	// Full subsidy
		di %9.2f (B + G/R) * WEEKS * WAGE
		di %9.2f (B + G/R) * WEEKS * WAGE * OMEGA
		di %9.2f (B + G/R) * WEEKS * WAGE * OMEGA * TAX - (sB + sG)


// *******************************************************************
// * FIGURE II
// *******************************************************************

// Opens data set
	use "$da/Baird-etal-QJE-2016_data_primary", clear

// Condition: plot if working 10-80 hours in sector
	foreach lhs in emp_hrs7_total selfemp_hrs7_total {
		des `lhs'
		sum `lhs'
		g       trim_`lhs'=`lhs'
		replace trim_`lhs'=. if `lhs'<10 | `lhs'>80
		}

// Panel A: Hours worked in self-employment, males
	twoway (kdensity trim_selfemp_hrs7_total if treatment==1 & female_baseline==0 [aw=weight], epan bwidth(10) lc(black) lw(thick)) ///
		   (kdensity trim_selfemp_hrs7_total if treatment==0 & female_baseline==0 [aw=weight], epan bwidth(10) lc(gs11) lw(thick)), ///
				graphregion(fcolor(white)) text(0.014 72 "Treatment", size(medsmall)) text(0.009 62 "Control", size(medsmall)) ///
				text(0.019 10 "{bf:A}", size(large) place(e)) ylabel(.005 .01 .015 .02) yscale(range(.005 .02)) ///
				legend(off) xtitle("Hours worked in self-employment, males") ytitle("Kernel density") xlabel(10(20)80) ///
				saving("$output/Baird-etal-QJE-2016_Fig2_PanelA", replace)

// Panel B: Hours worked in self-employment in last week, females
	twoway (kdensity trim_selfemp_hrs7_total if treatment==1 & female_baseline==1 [aw=weight], epan bwidth(10) lc(black) lw(thick)) ///
		   (kdensity trim_selfemp_hrs7_total if treatment==0  & female_baseline==1 [aw=weight], epan bwidth(10) lc(gs11) lw(thick)), ///
				graphregion(fcolor(white)) text(0.019 10 "{bf:B}", size(large) place(e)) yscale(range(.005 .02)) ylabel(.005 .01 .015 .02) ///
				legend(off) xtitle("Hours worked in self-employment, females") ytitle("") xlabel(10(20)80) ///
				saving("$output/Baird-etal-QJE-2016_Fig2_PanelB", replace)

// Panel C: Log earnings in wage employment, males
	twoway (kdensity ln_emp_salary_total if treatment==1 & female_baseline==0 [aw=weight], epan bwidth(0.5) lc(black) lw(thick)) ///
		   (kdensity ln_emp_salary_total if treatment==0 & female_baseline==0 [aw=weight], epan bwidth(0.5) lc(gs11) lw(thick)), ///
				graphregion(fcolor(white)) text(0.43 4 "{bf:C}", size(large) place(e)) yscale(range(0 .45)) ylabel(0 .1 .2 .3 .4)  ///
				legend(off) xtitle("Log earnings in wage employment, males") ytitle("Kernel density") xlabel(4(1)11) ///
				saving("$output/Baird-etal-QJE-2016_Fig2_PanelC", replace)

// Panel D: Log earnings in wage employment in past month, females
	twoway (kdensity ln_emp_salary_total if treatment==1 & female_baseline==1 [aw=weight], epan bwidth(0.5) lc(black) lw(thick)) ///
		   (kdensity ln_emp_salary_total if treatment==0 & female_baseline==1 [aw=weight], epan bwidth(0.5) lc(gs11) lw(thick)), ///
				graphregion(fcolor(white)) text(0.43 4 "{bf:D}", size(large) place(e)) yscale(range(0 .45)) ylabel(0 .1 .2 .3 .4) ///
				legend(off) xtitle("Log earnings in wage employment, females") ytitle("") xlabel(4(1)11) ///
				saving("$output/Baird-etal-QJE-2016_Fig2_PanelD", replace)

// Combine panels
graph combine "$output/Baird-etal-QJE-2016_Fig2_PanelA" "$output/Baird-etal-QJE-2016_Fig2_PanelB" "$output/Baird-etal-QJE-2016_Fig2_PanelC" ///
	"$output/Baird-etal-QJE-2016_Fig2_PanelD", ysize(8.5) xsize(12.5) row(2) col(2) graphregion(fcolor(white)) imargin(small) ///
	saving("$output/Baird-etal-QJE-2016_Fig2_ALL", replace)
	
graph export "$output/Baird-etal-QJE-2016_Fig2_ALL.tif", width(1000) replace

graph export "$output/Baird-etal-QJE-2016_Fig2_ALL.eps", replace


// *******************************************************************
// * RESULTS PRESENTED IN TEXT ONLY
// *******************************************************************

// Section 2.3, Claim: "The effective survey tracking rate in KLPS-2 is 82.5%, and 83.9% among those still alive..."
	use "$da/Baird-etal-QJE-2016_data_attrition.dta", clear
	sum surveyed [aw=weight] if attrition_sample==1
	sum surveyed [aw=weight] if attrition_sample==1 & dead==0

// Section 4.1, Claim: "We cannot reject equal effects [on self-reported health] for both genders, but gains 
// are slightly larger for women."
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	regress general_health treatment $x_controls1 treatment_gender [pw=weight] if insample==1 , robust cluster(psdpsch98)
	
// Section 4.3, Claim: "We next focus on a subpopulation that is largely older than school age, which we operationalize 
// as those who were older than 12 years old (the median age) at baseline, and thus at least 22 or 23 years of age at 
// follow-up: only 5% of control individuals in this age group were still enrolled in any school at follow-up, compared 
// to 39% among younger control individuals."
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	sum s5_attendsch_survey [aw=weight] if insample==1 & treatment==0 & age_older==1
	sum s5_attendsch_survey [aw=weight] if insample==1 & treatment==0 & age_older==0

// Section 4.3, Claim: "Treated women worked 2.01 more hours per week, and although we cannot reject the hypothesis of no 
// effect for women, we also cannot reject the hypothesis of equal treatment effects by gender." 
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	reg total_hours treatment $x_controls1 treatment_gender [pw=weight] if insample==1  & age_older==1, cl(psdpsch98)
	
// Section 4.3, Claim: "Breaking results down by gender, point estimates suggest that deworming leads men to increase total 
// work hours, and we cannot reject the hypothesis of equal percentage increases across sectors (Table III, Panel B)."	
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	gen ln_selfemphrs=ln(selfemp_hrs7_total_ALL)
	gen ln_farmhrs=ln(farmhrs2_ALL)
	gen ln_emphrs=ln(emp_hrs7_total_ALL)
	foreach lhs in selfemphrs farmhrs emphrs {
		/*Note that when running the original regressions, you should not use cluster command (do this in suest step instead), and it 
		is not possible to use pweights, so use iweights instead (very close to same results as expanding first to approximate weights)*/
		reg ln_`lhs' treatment $x_controls1 [iw=weight] if insample==1 & female_baseline==0
		eststo eqn_`lhs'
	}
	suest eqn_selfemphrs eqn_farmhrs eqn_emphrs, vce(cluster psdpsch98)
	test [eqn_selfemphrs_mean]treatment=[eqn_farmhrs_mean]treatment=[eqn_emphrs_mean]treatment

// Section 4.3, Claim: "However, there is no significant difference in education levels between women working in agriculture
// and those in non-agricultural self-employment."	
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	gen self_only=1 if selfemp==1 & farmwork2==0
	replace self_only=0 if selfemp==0 & farmwork2==1
	regress s5_highstd2007 self_only [aw=weight] if female_baseline==1 & insample==1 & treatment==0

// Section 4.3, Claim: "Manufacturing jobs require more hours per week than other occupations: they average 53 hours per week, 
// compared to 42 hours for all wage earning jobs, 34 hours for self-employment and 11 hours for agriculture."	
	sum emp_hrs7_total [aw=weight] if emp==1 & industry4_ALL==1 & insample==1 & grp3==1
	sum emp_hrs7_total [aw=weight] if emp==1 & insample==1 & grp3==1
	sum selfemp_hrs7_total [aw=weight] if selfemp==1 & insample==1 & grp3==1
	sum farmhrs2_ALL [aw=weight] if farmwork2==1 & insample==1 & grp3==1

// Section 4.3, Claim: "Workers in manufacturing tend to miss relatively few work days due to poor health, at just 1.1 days 
// in the last month (in the control group), compared to 1.5 days among all wage earners."	
	sum s16_1_10poorhealth [aw=weight] if emp==1 & industry4_ALL==1 & insample==1 & grp3==1
	sum s16_1_10poorhealth [aw=weight] if emp==1 & insample==1 & grp3==1

// Section 4.4, Claim: "Most importantly, if agricultural productivity had declined, one might expect that food consumption 
// among those working in agriculture would decline, but there is in fact an increase of 0.065 meals (SE 0.033) in this group."
	reg num_meals_yesterday treatment $x_controls1 [pw=weight] if insample==1 & farmhrs2_ALL>0, cl(psdpsch98)
 	

// Section 4.7, Claim: "In addition, stacking the data and using seemingly unrelated regression (SUR) estimation across outcomes, 
// we reject the hypothesis that the cost-sharing coefficients are zero (P<0.001); see appendix section B for further details."
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
		/*T3*/ total_hours /*age sample*/ selfemp_hrs7_total_ALL farmhrs2_ALL emp_hrs7_total_ALL industry4_ALL industry2_ALL industry7_ALL cash_crop_FULL 
		/*T4*/ num_meals_yesterday /*age sample*/ earnings_nonag_total_ALL /*age sample*/ ln_emp_salary_total ln_wage_10hrs ln_emp_salary_total_2007 selfemp_profits30_total selfemp_profits30_tott5 selfemp_employees_total {;
		regress `lhs'  treatment $x_controls1 if insample==1;
		estimates store su_`i';
		local i=`i'+1;
		};
	suest su_1 su_2 su_3 su_4 su_5 su_6 su_7 su_8 su_9 su_10 su_11 su_12 su_13 su_14 su_15 su_16 su_17 su_18 su_19 su_20 su_21 
		su_22 su_23 su_24 su_25 su_26, vce(cluster psdpsch98);
	test [su_1_mean]cost_sharing [su_2_mean]cost_sharing [su_3_mean]cost_sharing [su_4_mean]cost_sharing [su_5_mean]cost_sharing 
		[su_6_mean]cost_sharing [su_7_mean]cost_sharing [su_8_mean]cost_sharing [su_9_mean]cost_sharing [su_10_mean]cost_sharing 
		[su_11_mean]cost_sharing [su_12_mean]cost_sharing [su_13_mean]cost_sharing [su_14_mean]cost_sharing [su_15_mean]cost_sharing 
		[su_16_mean]cost_sharing [su_17_mean]cost_sharing [su_18_mean]cost_sharing [su_19_mean]cost_sharing	[su_20_mean]cost_sharing 
		[su_21_mean]cost_sharing [su_22_mean]cost_sharing [su_23_mean]cost_sharing [su_24_mean]cost_sharing [su_25_mean]cost_sharing 
		[su_26_mean]cost_sharing;
	#delimit cr
	
// Section 5, Claim: "The annualized social IRR with no health spillovers is very high at 31.8%, and with health 
// spillovers is a massive 51.0%."	

	// Parameters
		clear
		// Size of subsidy (Table V, Panel A)
			scalar S = 1.42
		// Takeup rate under full subsidy (Table V, Panel A)		
			scalar T = 0.75
		// IRR with no health spillovers 
			scalar IRR = 0.317938896
		// IRR with health spillovers 
			scalar IRR2 = 0.510205444
		// Number of weeks in the year
			scalar WEEKS = 52 
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
			// r = IRR that solves the equation in Section 5 (without spillovers)
			// gamma_1 = coeffcient on age from regression of earnings on age, age^2, female dummy, indicators for attained primary/secondary/beyond, 
				// and province dummies, using 1998/1999 Kenyan Labor Force Survey (0.1019575)
			// gamme_2 = absolute value of coeffcient on age^2 from regression of earnings on age, age^2, female dummy, indicators for attained primary/secondary/beyond, 
				// and province dummies, using 1998/1999 Kenyan Labor Force Survey (0.0010413)
			// Final calculation: See formula for OMEGA in Baird-etal-QJE-2016_fiscal-impacts-detail.pdf.	
			scalar OMEGA_IRR = 0.36205249
		// Multiplier 2
			// Calculated as defined in Baird-etal-QJE-2016_fiscal-impacts-detail.pdf, where:
			// g = average per-capita GDP growth rate in Kenya during the 2001 to 2011 period (World Bank Development Indicators; 1.52% per annum)
			// r = IRR that solves the equation in Section 5 (including spillovers)
			// gamma_1 = coeffcient on age from regression of earnings on age, age^2, female dummy, indicators for attained primary/secondary/beyond, 
				// and province dummies, using 1998/1999 Kenyan Labor Force Survey (0.1019575)
			// gamme_2 = absolute value of coeffcient on age^2 from regression of earnings on age, age^2, female dummy, indicators for attained primary/secondary/beyond, 
				// and province dummies, using 1998/1999 Kenyan Labor Force Survey (0.0010413)
			// Final calculation: See formula for OMEGA in Baird-etal-QJE-2016_fiscal-impacts-detail.pdf.	
			scalar OMEGA_IRR2 = 0.059237653

	// Increase in hours worked 
		// Lambda 1 (full subsidy)  
			// Calculated as increase in work hours/week for men (Table III, Panel A, 3.49) * 1/2 (women no change; Table III, Panel A) = (3.49*0.5)
			// multiplied by uptake at full subsidy divided by uptake at full subsidy (Table V, Panel A, 0.75/0.75). 
			// Final calculation: 3.49 * .5 * (.75/.75)
			scalar B = 1.745 
		// Lambda 2 (full subsidy) 
			// Calculated as increase in work hours/week due to externality (Table III, Panel A, 10.2), multiplied by fraction of treated 
			// primary school students within 6 km (See R above, 0.68133333), multiplied by uptake at full subsidy (Table V, Panel A, 0.75). 
			// Final calculation: 10.2 * 0.68133333 * 0.75
			scalar G = 5.2122 
		
	// Increase in schooling costs
		// Note that additional secondary schools costs per pupil per year ($116.85) are calculated as 
			// the sum of yearly secondary schooling compensation ($5041) and yearly secondary schooling teacher benefits ($217.47), 
			// divided by average pupils per teacher (45). These figures were received from the Kenyan field team.
		// Mean increase in schooling costs (full subsidy)
			// Caculated as the discounted value of [additional secondary schooling costs per pupil per year (See note above, $116.85) 
			// multiplied by the direct increase in secondary schooling (Table S3, by year for 1999-2007)].
			scalar sB_IRR = 4.52261334
		// Mean increase in schooling costs, direct and from externality (full subsidy)
			// Caculated as the discounted value of [additional secondary schooling costs per pupil per year (See note above, $116.85) 
			// multiplied by the direct + externality increase in secondary schooling (do file for Table S3, by year for 1999-2007)].
			scalar sG_IRR2 = 3.856970743
 	
	// IRR WITH NO HEALTH SPILLOVERS
		// IRR is defined as the interest rate that equates the NPV of the full social cost and all earning gains
		// Cost of subsidy (year 0)
			di %9.2f (S * T)
		// NPV increase in per-person earnings (relative to no subsidy) minus NPV of increase in schooling costs (no spillovers)
			di %9.2f (B * WEEKS * WAGE * OMEGA_IRR) - sB_IRR
		// Thus, the IRR that equates these two is:
			di %9.3f IRR
		
	// IRR WITH HEALTH SPILLOVERS
		// IRR is defined as the interest rate that equates the NPV of the full social cost and all earning gains
		// Cost of subsidy (year 0)
			di %9.2f (S * T)
		// NPV increase in per-person earnings (relative to no subsidy) minus NPV of increase in schooling costs (no spillovers)
			di %9.2f (B + G/R) * WEEKS * WAGE * OMEGA_IRR2 - sG_IRR2
		// Thus, the IRR that equates these two is:
			di %9.3f IRR2

// Section 5, Claim: "we bootstrapped standard errors (with 1000 runs), and find that net revenue gains are less than zero 29% 
// of the time for the case of no health spillovers."	
	// See file entitled "Baird-etal-QJE-2016_do_bootstrap.do" for the code to produce this result, and 
	// "Baird-etal-QJE-2016_fiscal-impacts-detail.pdf" for an explanation of the procedure.

// Table 1 notes, Claim: "Sixteen unreasonably low values for height are dropped, but the height results are substantively the same if these 
// are not dropped."
	
	* Opens data
		use "$da/Baird-etal-QJE-2016_data_primary", clear

	* Regressions
		reg height treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg height treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg height treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)

// Table 1 notes, Claim: "Sixteen unreasonably high values (at 98 and above) for BMI are dropped (these are the same 16 observations that 
// were dropped for height); note that the female BMI effect estimate is not statistically significant at traditional confidence levels 
// if these observations are retained (not shown)."
	
	* Opens data
		use "$da/Baird-etal-QJE-2016_data_primary", clear
	
	* Regressions
		reg BMI treatment $x_controls1 [pw=weight] if insample==1                     , cl(psdpsch98)
		reg BMI treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
		reg BMI treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==1, cl(psdpsch98)
		
log c
