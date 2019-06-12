clear *
set more off


global mypath "\\rschfs1x\userRS\A-E\dbr88_RS\Documents\Selection over time\"

global make_stata_data "on"  //Runs NBER do files to make stata data from each month's raw dat file
global combine_stata_data "on" //Combines the monthly file into one dataset for the entire period
global clean_data "on"   //Cleans and formats data for analysis

***Runs the NBER files to transform data to Stata format
if "${make_stata_data}"=="on" {
	local i=1
	foreach year in 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 {
		foreach month in jan feb mar apr may jun jul aug sep oct nov dec {
			global year `year'
			global month `month'
			clear   *
			if `i'>=1 & `i'<4 {
				local period "jan94"
			} 
			else if `i'>=4 & `i'<18 {
				local period "apr94"
			} 
			else if `i'>=18 & `i'<21 {
				local period "jun95"
			} 
			else if `i'>=21 & `i'<49 {
				local period "sep95"
			} 
			else if `i'>=49 & `i'<109 {
				local period "jan98"
			} 
			else if `i'>=109 & `i'<125 {
				local period "jan03"
			} 		
			else if `i'>=125 & `i'<140 {
				local period "may04"
			} 		
			else if `i'>=140 & `i'<157 {
				local period "aug05"
			} 
			else if `i'>=157 & `i'<181 {
				local period "jan07"
			} 	
			else if `i'>=181 & `i'<193 {
				local period "jan09"
			} 
			else if `i'>=193 & `i'<217 {
				local period "jan10"
			} 			
			else {
				local period "problem"
			}
			di "period `period' y `year' m `month'"
			do "${mypath}data\raw\nber do files\cpsb`period'.do"



			
			local ++i
		}


	}
}
***Combines the montly files into one stata dataset
if "${combine_stata_data}"=="on" {
	clear *
	g period=""
	local i=1
	foreach year in 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 {
		foreach month in jan feb mar apr may jun jul aug sep oct nov dec {
			if `i'>=1 & `i'<4 {
				local period "jan94"
			} 
			else if `i'>=4 & `i'<18 {
				local period "apr94"
			} 
			else if `i'>=18 & `i'<21 {
				local period "jun95"
			} 
			else if `i'>=21 & `i'<49 {
				local period "sep95"
			} 
			else if `i'>=49 & `i'<109 {
				local period "jan98"
			} 
			else if `i'>=109 & `i'<125 {
				local period "jan03"
			} 		
			else if `i'>=125 & `i'<140 {
				local period "may04"
			} 		
			else if `i'>=140 & `i'<157 {
				local period "aug05"
			} 
			else if `i'>=157 & `i'<181 {
				local period "jan07"
			} 	
			else if `i'>=181 & `i'<193 {
				local period "jan09"
			} 
			else if `i'>=193 & `i'<217 {
				local period "jan10"
			} 			
			else {
				local period "problem"
			}
			
			append using "${mypath}data\stata\cpsb`month'`year'.dta"
			replace period="`period'" if period==""

			local ++i
		}


	}
	save "${mypath}data\combined_stata.dta", replace
	keep if hrmis==1 
	keep hupr period huinttyp hrhhid pemlr peeduca  *age pesex prnmchld perace  ptdtrace  prdtrace  puslfprx hrmis	 puslfprx pemaritl gestfips gtmetsta hrnumhou gemetsta hrmonth hryear*
	save "${mypath}data\combined_stata_mid.dta", replace

	

}

***Cleans combined stata file
if "${clean_data}"=="on" {
	use "${mypath}data\combined_stata_mid.dta", clear

	*Period from Jan 98 to Dec 02 allows up to 99 attempts (other peroids limted at 9)
	recode  hupr (1=1) (2=2) (3/75=3) (0=4) (-1=4), g(difficulty)
		label define difficulty 1 "1 visit" 2 "2 visits" 3 "3 or more visits" 4 "Unknown"
		label values difficulty difficulty
	g attempts_cleaned=hupr if hupr!=0
			
	*Mode codes change over time, have to recode**
	*recode huinttyp (1=1) (2=2) (-1=3), g(mode)
		*label define mode 1 "In person" 2 "Telephone" 3 "Unknown"
		*label values mode mode
			
	recode pemlr (1/2=1) (3/4=2) (5/7=3) (-1=.), g(employment)
		label define employ 1 "Employed" 2 "Unemployed" 3 "NILF"
		label values employment employ

	g employed=1 if employment==1
		replace employed=0 if employment==2 | employment==3
		label variable employed "Employed"
	g notemployed=1 if employment==2 | employment==3
		label variable notemployed "Either NILF or unemployed"
	g unemployed=1 if employment==2 
		replace unemployed=0 if employment==3 
		label variable unemployed "Unemployed, conditional on not being employed" 
	g unconditional_unemployed=1 if employment==2
		replace unconditional_unemployed=0 if employment==1 | employment==3
	g unemployment_rate=.
		replace unemployment_rate=1 if unemployed==1 
		replace unemployment_rate=0 if employed==1
	g laborforce=(employment==1 |employment==2)
			
			
	recode peeduca (31/38=1) (39=2) (40/42=3) (43/46=4) (-1=5), g(education)
		label define education 1 "Less than high school" 2 "High School" 3 "Some college or associate's degree" 4 "Bachelor's degree or more" 5 "Missing educ."
		label values education education
				
	*recode prtage (-1=6) (16/19=1) (20/39=2) (40/49=3) (50/64=4) (65/99=5)  (0/15=7)  (miss=6), g(age1) 
	recode peage (-1=6) (16/19=1) (20/39=2) (40/49=3) (50/64=4) (65/99=5)  (0/15=7)  (miss=6), g(age)
	
	
		label variable age "Individual's age"
		label define age 1 "Age 16-19" 2 "Age 20-39" 3 "Age 40-49" 4 "Age 50-64" 5 "Age 65 and up" 6 "Age missing " 7 "Age 0 to 15"
		label values age age
			
	recode pesex (1=0) (2=1) (-1=2), g(female) 
		label variable female "Individual's sex"
		label define female 0 "Male" 1 "Female" 2 "Missing sex"
		label values female female
	
	*Don't have this variable in the older data.
	*recode prnmchld (-1=0) (0=0) (1/12=1), g(children)
	*	label define children  0 "No children under 18 in HH" 1 "1 or more children under 18 in HH"
	*	label values children children
	
	*race changed combinations for asians and pacific islander and hawaiins
	recode perace (1=1) (2=2) (3=3) (4=4) (5=6) (nonmiss=7) (miss=7), g(race1)
	recode ptdtrace (1=1) (2=2) (3=3) (4=4) (5=4) (6/26=6) (-1=7) (nonmiss=7) (miss=7), g(race2)
	recode prdtrace (1=1) (2=2) (3=3) (4=4) (5=4) (6/26=6) (-1=7) (nonmiss=7) (miss=7), g(race3)
	
	
		g race=race1
		replace race=race2 if race==7 & race2!=7
		replace race=race3 if race==7 & race3!=7

		label define race 1 "White" 2 "Black" 3 "American Indian" 4 "see doc" 5 "see doc" 6 "Other" 7 "Missing race"
		label values race race		
				
	recode puslfprx (1=1) (2=0) (3=0), g(self)
		label variable self "Was labor force participation completely filled out by self"
		label define self 1 "Completed by self" 2 "Completed by proxy or mix of self and proxy"
			
	recode puslfprx (2=1) (1=0) (3=0), g(nonself)
		label variable nonself "Was labor force participation completely filled out by proxy"
		label define nonself 1 "Completed by prox" 2 "Completed by self or mix of self and proxy"
			
	recode pemaritl (-1=999) (miss=999) , g(marriage)
		label variable marriage "Marital status"
		label define marriage 1 "Married-spouse present" 2 "Married - spouse absent" 3 "Widowed" 4 "Divorced" 5 "Seperated" 6 "Never married"
			
	recode gestfips (-1=999) (miss=999) , g(statenum)
		label variable statenum "State"
	
	
	recode hrnumhou (1=1) (2=2) (3=3) (4=4) (nonmiss=5) (miss=6), g(size)
		label variable size "Size of HH"
		label define size 1 "1 member" 2 "2 members" 3 "3 members"  4 "4 members"  5 "5 or members" 6 "Missing size"
		label values size size		

	
	
	
	recode gemetsta (3=3) (-1=3) (miss=3), g(urban_rural1)
	
	recode gtmetsta (3=3) (-1=3) (miss=3), g(urban_rural2)
	
	g urban_rural=urban_rural1
		replace urban_rural=urban_rural2 if urban_rural==3 & urban_rural2!=3
		label variable urban_rural "Metropolotan status"
		label define urban_rural 1 "Metropolitan" 2 "Nonmetropolotin" 3 "Missing"
		label values urban_rural urban_rural
				
	recode hrmonth (-1=99) (miss=99) , g(interview_month)
		label variable interview_month "Interview month"
			
	recode hryear4  (-1=9999) (miss=9999)  , g(interview_year)
		replace interview_year=hryear if interview_year==9999 & hryear!=.
		tostring interview_year, replace
		replace interview_year="19"+interview_year if length(interview_year)==2
		label variable interview_year "Interview year"

	drop if age==7 //Drops those younger than 16
	keep if employment!=. //Only keep those with employment information and considered to be in the labor force
	
	save "${mypath}data\combined_stata_cleaned.dta", replace
}
