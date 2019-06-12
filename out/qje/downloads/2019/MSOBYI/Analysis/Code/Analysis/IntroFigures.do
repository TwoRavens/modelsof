/* IntroFigures.do */


global Fig = "Output/StylizedFacts/Figures"



/* GLOBAL OBESITY AND GDP */
import delimited Data\Other\CIAFactbookGDP.txt, delimiter(tab) varnames(nonames) clear 
gen country = substr(v1,8,50)
gen GDP = substr(v1,60,6)
destring GDP, replace force ignore(",")

save Calculations/Global/GDPandObesity.dta, replace



import delimited Data\Other\CIAFactbookObesity.txt, delimiter(tab) varnames(nonames) clear 
gen country = substr(v1,8,50)
gen Obesity = substr(v1,59,5)
destring Obesity, replace force

merge 1:1 country using Calculations/Global/GDPandObesity.dta

save Calculations/Global/GDPandObesity.dta, replace


twoway (scatter Obesity GDP), ///
		graphregion(color(white) lwidth(medium)) ///
		ytitle("Obesity rate (%)") xtitle("GDP at PPP ($)") //
graph export $Fig/ObesityandGDP.pdf, as(pdf) replace
		

/* OBESITY TRENDS */
import excel Data/ObesityTrends.xlsx, sheet("Obesity") firstrow clear cellrange(A1:D8) 


twoway (connect Overweight Obesity year, lp(- l) lc(navy maroon)), ///
		graphregion(color(white) lwidth(medium)) ///
		ytitle("Age-adjusted prevalence (%)") //
		
		
		
graph export $Fig/ObesityTrends.pdf, as(pdf) replace

twoway (connect Overweight Obesity Diabetes year, lp(- l _) lc(navy maroon black)), ///
		graphregion(color(white) lwidth(medium)) ///
		ytitle("Age-adjusted prevalence (%)") //
		
		/*
twoway (connect Overweight Obesity year, lp(- l)) ///
		(connect Diabetes year, lp(_) yaxis(2)), ///
		graphregion(color(white) lwidth(medium)) ///
		ytitle("Age-adjusted prevalence (%)", axis(1)) ///
		ytitle("Diabetes prevalence (%)", axis(2))
		*/
		
		
graph export $Fig/ObesityTrends_WithDiabetes.pdf, as(pdf) replace



/* BRFSS */
* http://www.cdc.gov/brfss/annual_data/annual_2013.html
* http://www.cdc.gov/brfss/annual_data/2013/pdf/codebook13_llcp.pdf
* http://www.cdc.gov/brfss/annual_data/2013/llcp_varlayout_13_onecolumn.html

infix IncomeCat 152-153 Weight 154-157 Height 158-161 Sex 178 BMICat 2196 PersonWeight 1953-1962 using "Data\BFRSS\LLCP2013.ASC",clear

gen Male = cond(Sex==1,1,0)
gen Obese = cond(BMICat==4,1,0)
gen Overweight = cond(BMICat==3,1,0)

gen Income = 5 if IncomeCat==1
replace Income = 12.5 if IncomeCat==2
replace Income = 17.5 if IncomeCat==3
replace Income = 22.5 if IncomeCat==4
replace Income = 30 if IncomeCat==5
replace Income = 42.5 if IncomeCat==6
replace Income = 62.5 if IncomeCat==7
replace Income = 100 if IncomeCat==8

save Calculations/BRFSS/BRFSS.dta, replace

use Calculations/BRFSS/BRFSS.dta, replace

collapse (mean) Obese Overweight [aw=PersonWeight],by(Income Male)

*** Men and women on two separate panels
	twoway (scatter Obese Income if Male==1,yscale(range(0.15 0.35)) ylabel(0.15(0.05)0.35)), ///
		graphregion(color(white) lwidth(medium)) ///
		xtitle("Household income ($000s)") ytitle("Obesity rate") ///
		title("Men")


			graph save $Fig/Obesity_Income_Male, replace


	twoway (scatter Obese Income if Male==0,yscale(range(0.15 0.35)) ylabel(0.15(0.05)0.35)), ///
		graphregion(color(white) lwidth(medium)) ///
		xtitle("Household income ($000s)") ytitle("Obesity rate") ///
		title("Women")
		
			graph save $Fig/Obesity_Income_Female, replace


graph combine $Fig/Obesity_Income_Male.gph ///
	 $Fig/Obesity_Income_Female.gph, ///
	   	graphregion(color(white) lwidth(medium)) ///
		rows(1) cols(2) fysize(100) fxsize(100) 
				
		graph export $Fig/Obesity_Income.pdf, as(pdf) replace

*** Women only 
	twoway (scatter Obese Income if Male==0,yscale(range(0.15 0.35)) ylabel(0.15(0.05)0.35)), ///
		graphregion(color(white) lwidth(medium)) ///
		xtitle("Household income ($000s)") ytitle("Obesity rate") //

			graph export $Fig/Obesity_Income_Female.pdf, as(pdf) replace
		
/*Combining Male and Female Together*/
		use Calculations/BRFSS/BRFSS.dta, replace

collapse (mean) Obese Overweight [aw=PersonWeight],by(Income)

twoway (scatter Obese Income ,yscale(range(0.2 0.35)) ylabel(0.2(0.05)0.35)) ///
	(lfit Obese Income), ///
		graphregion(color(white) lwidth(medium)) legend(off) ///
		xtitle("Household income ($000s)") ytitle("Obesity rate") 
		graph export $Fig/Obesity_Income_Pooled.pdf, as(pdf) replace

