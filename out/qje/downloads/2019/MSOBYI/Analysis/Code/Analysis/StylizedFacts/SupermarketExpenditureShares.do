/* SupermarketExpenditureShares.do */


** Average GSC expenditures for text

use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
sum expshare_GSC [aw=projection_factor]
clear
set obs 1
gen var = round(r(mean)*100,1)
format var %12.0fc 
tostring var, replace force u
outfile var using "Output/NumbersForText/Mean_expshare_GSC.tex", replace noquote
	
	

** Interquartile ranges for text
use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
reg expshare_GSC ib1.IncomeQuartile $SESCtls i.panel_year, robust cluster(household_code)
local expshare_GSCQDiff = _b[4.IncomeQuartile]
clear
set obs 1
gen var = round(`expshare_GSCQDiff'*100,0.1)
format var %12.1fc 
tostring var, replace force u
outfile var using "Output/NumbersForText/expshare_GSCQDiff.tex", replace noquote




** Binscatter
use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
** Merge zip code
merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
	keepusing(zip_code) keep(match master) nogen 
	
* Merge food desert definition
rename panel_year year
merge m:1 zip_code year using $Externals/Calculations/StoreEntryExit/ZipCodeBusinessPatterns.dta, keep(match master) keepusing(est_LargeGroc est_SuperClub) nogen // Only 155 hhxyear observations unmatched from master
rename year panel_year

gen est_Large = est_LargeGroc+est_SuperClub 

gen FoodDesert = cond(est_Large==0,1,0)

binscatter expshare_GSC HHAvIncome [aw=projection_factor], ///
		by(FoodDesert) ///
		line(connect) m(O S) /// Circle and square
		controls($SESCtls i.panel_year) ///
		graphregion(color(white)) nquantiles(10) ///
		xtitle("Household income ($000s)") ///
		ytitle("Grocery/supercenter/club store expenditure share") /// xlabel(0(25)125) xscale(range(0 125)) ///
		legend(label(1 "Non-food deserts") label (2 "Food deserts"))
graph export $Fig/GSCExpenditures_Income.pdf, as(pdf) replace	
		

		
		
/* Old code: starting with collapsed data from TransactionDataPrep.do 

use $Externals/Calculations/Homescan/HHAvIncome.dta, replace
		twoway (connect expshare_GSC HHAvIncome) /// , yscale(range(0.8 0.96)) ylabel(0.8(0.04)0.96)) ///
		(connect expshare_GSC_FD HHAvIncome, msymbol(S) lp(dash)), ///
		graphregion(color(white)) ///
		xlabel(0(25)125) xscale(range(0 125)) ///
		xtitle("Household income ($000s)") ytitle("Grocery/supercenter/club store expenditure share") ///
		legend(label(1 "Full sample") label(2 "Households in food deserts"))
	graph export $Fig/GSCExpenditures_Income.pdf, as(pdf) replace

** Top and bottom quartile expenditures for text
foreach Q in 1 4 {
	use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1	
	gen expshare_GSC = expshare_Grocery+expshare_Super+expshare_Club
	sum expshare_GSC [aw=projection_factor] if IncomeQuartile == `Q'
	
	local Q`Q'expshare_GSC = r(mean)
	clear
	set obs 1
	gen var = round(`Q`Q'expshare_GSC'*100,1)
	format var %12.0fc 
	tostring var, replace force u
	outfile var using "Output/NumbersForText/Q`Q'expshare_GSC.tex", replace noquote
}

