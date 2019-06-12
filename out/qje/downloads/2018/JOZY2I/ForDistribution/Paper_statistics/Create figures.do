** Paper figures based on data
*Most figures are time series plots of price change statistics in "working\Mgavgsy.dta", mostly
* for averages across ELI's, which coresponds to the values for majgroup 13

*Figure 6 (Dispersion of Log Prices Within ELI)
use "working\Mgavgsy.dta", clear
label variable priceiqrallymedian "IQR, all prices"
label variable priceiqrnsymedian "IQR Excluding Sales"
tsline priceiqrallymedian priceiqrnsymedian if majgroup == 13 & year != 1977, lcolor(black gs11) ttitle("") tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") ylabel(, nogrid) graphregion(fcolor(white)) title("Dispersion of Prices Within ELI") saving("Figures\Fig6.gph", replace)
export delimited year priceiqrallymedian priceiqrnsymedian using "Figures\Fig6.csv" if majgroup == 13 & year != 1977, replace

*Figure 9 (Absolute Size of Price Changes)
use "working\Mgavgsy.dta", clear
label variable absymedian "Regular Price Changes"
label variable abssaleymedian "All Price Changes Including Sales"
tsline absymedian abssaleymedian if majgroup == 13 & year != 1977, lcolor(black gs11) graphregion(fcolor(white)) ttitle("") tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") ylabel(, nogrid) yscale(range(0 0.16)) ylabel(0(0.02)0.16) title("Absolute Size of Price Changes") saving("Figures\Fig9.gph", replace)
export delimited year absymedian abssaleymedian using "Figures\Fig9.csv" if majgroup == 13 & year != 1977, replace

*Figure 11 (Standard Deviation of Absolute Size of Price Changes)
use "working\Mgavgsy.dta", clear
tsline SDabsymedian if majgroup == 13 & year != 1977, ttitle("") tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") ylabel(, nogrid) title("Standard Deviation of Absolute Size of Price Changes") ///
	yscale(range(0 0.16)) ylabel(0(0.02)0.16) ytitle("") lcolor(black) graphregion(fcolor(white)) saving("Figures\Fig11.gph", replace)
export delimited year SDabsymedian using "Figures\Fig11.csv" if majgroup == 13 & year != 1977, replace

*Figure 14 (Frequency of Price Changes in U.S. Data)
use "working\Mgavgsy.dta", clear
keep if majgroup == 13
merge 1:1 year using "working\Aggsy.dta"
label variable freqymedian "Frequency of Price Change"
label variable yinfl "Annual CPI inflation (right axis)"
twoway (tsline freqymedian if year != 1977 & year <= 2014, yaxis(1) ytitle("", axis(1)) ylabel(0.05(0.05)0.2, nogrid axis(1)) lcolor(black) xtitle("") ) ///
	(tsline yinfl if year != 1977 & year <= 2014, yaxis(2) ytitle("", axis(2)) yscale(range(-0.02 0.16)) ylabel(0(0.05)0.15, nogrid axis(2)) lcolor(gs11) xtitle("") ), ///
	 graphregion(fcolor(white)) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 "2000" 2010m1 "2010") saving("Figures\Fig14.gph", replace)
export delimited year freqymedian yinfl using "Figures\Fig14.csv" if majgroup == 13 & year != 1977, replace


*Figure 15 (Frequency of Price Increases and Decreases Quarterly Running Average)
*Create quarterly series by keeping last month of every quarter
use "working\Freq12.dta", clear
sort year month
keep if month == 3 | month == 6 | month == 9 | month == 12
label variable frequp12median "Frequency of Price Increases"
label variable freqdw12median "Frequency of Price Decreases"
label variable yinfl "CPI Inflation (right axis)"
twoway (tsline frequp12median freqdw12median if majgroup == 13 & year != 1977, yaxis(1) yscale(range(0 0.15)) ylabel(0(0.05)0.15, nogrid axis(1)) lcolor(black black) lpattern(solid dash) ttitle("") ///
	ytitle("",axis(1))) (tsline yinfl if year != 1977 & majgroup == 13, yaxis(2) ytitle("", axis(2)) yscale(range(-0.03 0.16)) ylabel(0(0.05)0.15, nogrid axis(2)) lcolor(gs11)), ///
	title("Frequency of Price Increases and Decreases") tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 "2000" 2010m1 "2010") graphregion(fcolor(white)) saving("Figures\Fig15.gph", replace)
export delimited year month frequp12median freqdw12median using "Figures\Fig15.csv" if majgroup == 13 & year != 1977, replace

*Figure 16 (Frequency of Price Change in Data and Model): Combines model results from Matlab with Frequency up and down
use "working\Mgavgsy.dta", clear
label variable frequpymedian "Freq Up Data"
label variable freqdwymedian "Freq Down Data"
tsline frequpymedian freqdwymedian if majgroup == 13 & year != 1977, title("Frequency of Price Change in Data") saving("Figures\Fig16.gph", replace)
export delimited year frequpymedian freqdwymedian using "Figures\Fig16.csv" if majgroup == 13 & year != 1977, replace

*Figure 17 (Frequency of Temporary Sales) 
use "working\Mgavgsy.dta", clear
tsline freqsaleymean if majgroup == 0 & year != 1977, ytitle("") ttitle("") lcolor(black) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") yscale(range(0 0.25)) ylabel(0(0.05)0.25, nogrid) title("Processed Food") graphregion(fcolor(white) lcolor(white)) saving("Figures\Sale0.gph", replace)
tsline freqsaleymean if majgroup == 1 & year != 1977, ttitle("") lcolor(black) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") yscale(range(0 0.25)) ylabel(0(0.05)0.25, nogrid) ytitle("") title("Unprocessed Food") graphregion(fcolor(white) lcolor(white)) saving("Figures\Sale1.gph", replace)
tsline freqsaleymean if majgroup == 3 & year != 1977, ttitle("") lcolor(black) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") yscale(range(0 0.4)) ylabel(0(0.1)0.4, nogrid) ytitle("") title("Apparel") graphregion(fcolor(white) lcolor(white)) saving("Figures\Sale3.gph", replace)
tsline freqsaleymean if majgroup == 2 & year != 1977, ttitle("") lcolor(black) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") yscale(range(0 0.3)) ylabel(0(0.05)0.3, nogrid) ytitle("") title("Household Furnishings") graphregion(fcolor(white) lcolor(white)) saving("Figures\Sale2.gph", replace)
tsline freqsaleymean if majgroup == 6 & year != 1977, ttitle("") lcolor(black) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") yscale(range(0 0.2)) ylabel(0(0.05)0.2, nogrid) ytitle("") title("Household Furnishings") graphregion(fcolor(white) lcolor(white)) saving("Figures\Sale6.gph", replace)
graph combine "Figures\Sale0.gph" "Figures\Sale1.gph" "Figures\Sale3.gph" "Figures\Sale2.gph" "Figures\Sale6.gph", graphregion(fcolor(white) lcolor(white)) ///
	rows(3) xsize(5) ysize(8) title("Frequency of Temporary Sales") saving("Figures\Fig17.gph", replace)
export delimited year majgroup freqsaleymean using "Figures\Fig17.csv" if  year != 1977 & (majgroup == 0 | majgroup == 1| majgroup == 3| majgroup == 3| majgroup == 6), replace
erase "Figures\Sale0.gph" 
erase "Figures\Sale1.gph"
erase "Figures\Sale3.gph"
erase "Figures\Sale2.gph"
erase "Figures\Sale6.gph"
	
*Figure 18 (Distribution of Number of Replicates for Each Product-Month Observation)
insheet using "BLS_datafiles\Repdistnonmiss.csv", comma clear
drop _type_ _freq_
drop if month < 7701
egen nmobs = rowtotal(nr1-nr12)
egen totobs = sum(nmobs)
forvalues i = 1/12 {
egen nrs`i' = sum(nr`i')
gen pct`i' = ((nrs`i')/totobs)*100
label variable pct`i' "`i'"
drop nr`i' nrs`i'
}
keep if _n == 1
drop month nmobs totobs
 graph bar (asis) pct1 pct2 pct3 pct4 pct5 pct6  pct7 pct8 pct9 pct10 pct11 ///
	pct12, blabel(name, position(base)) legend(off) title("Number of Replicates") ytitle("% of All Observations") saving("Figures\Fig18.gph", replace)


*Figura A.1 (Mean Absolute Size of Price Changes by Sector)
use "working\Mgavgsy.dta", clear
tsline absymedian if majgroup == 0 & year != 1977, ytitle("") ttitle("") lcolor(black) yscale(range(0 0.2)) ylabel(0(0.05)0.2, nogrid) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") title("Processed Food") graphregion(fcolor(white) lcolor(white)) yscale(range(0 0.2)) ylabel(0(0.05)0.2) saving("Figures\Size0.gph", replace)
tsline absymedian if majgroup == 1 & year != 1977, ttitle("") lcolor(black) yscale(range(0 0.2)) ylabel(0(0.05)0.2, nogrid) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") ytitle("") title("Unprocessed Food") yscale(range(0 0.2)) ylabel(0(0.05)0.2) graphregion(fcolor(white) lcolor(white)) saving("Figures\Size1.gph", replace)
tsline absymedian if majgroup == 3 & year != 1977, ttitle("") lcolor(black) yscale(range(0 0.2)) ylabel(0(0.05)0.2, nogrid) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") ytitle("") title("Apparel") yscale(range(0 0.2)) ylabel(0(0.05)0.2) graphregion(fcolor(white) lcolor(white)) saving("Figures\Size3.gph", replace)
tsline absymedian if majgroup == 2 & year != 1977, ttitle("") lcolor(black) yscale(range(0 0.15)) ylabel(0(0.05)0.15, nogrid) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") ytitle("") title("Household Furnishings") yscale(range(0 0.15)) ylabel(0(0.05)0.15, nogrid) graphregion(fcolor(white) lcolor(white)) saving("Figures\Size2.gph", replace)
tsline absymedian if majgroup == 6 & year != 1977, ttitle("") lcolor(black) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") ytitle("") title("Household Furnishings") yscale(range(0 0.15)) ylabel(0(0.05)0.15, nogrid) graphregion(fcolor(white) lcolor(white)) saving("Figures\Size6.gph", replace)
tsline absymedian if majgroup == 9 & year != 1977, ttitle("") lcolor(black) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 ///
	"2000" 2010m1 "2010") ytitle("") title("Services") yscale(range(0 0.1)) ylabel(0(0.02)0.1, nogrid) graphregion(fcolor(white) lcolor(white)) saving("Figures\Size9.gph", replace)
graph combine "Figures\Size0.gph" "Figures\Size1.gph" "Figures\Size3.gph" "Figures\Size2.gph" "Figures\Size6.gph" "Figures\Size9.gph", graphregion(fcolor(white)) ///
	rows(3) xsize(6) ysize(8) b1title("Mean Absolute Size of Price Changes by Sector") saving("Figures\FigA1.gph", replace)
export delimited year majgroup absymedian using "Figures\FigA1.csv" if  year != 1977 & (majgroup == 0 | majgroup == 1| majgroup == 3| majgroup == 3| majgroup == 6| majgroup == 9), replace
erase "Figures\Size0.gph"
erase "Figures\Size1.gph"
erase "Figures\Size3.gph"
erase "Figures\Size2.gph"
erase "Figures\Size6.gph"
erase "Figures\Size9.gph"

*Figure A.2 (Quantiles of the Absolute Size of Price Changes)
use "working\Abssize_qtiles.dta", clear 
label variable absnsyq10 "10th"
label variable absnsyq25 "25th"
label variable absnsymedia "50th"
label variable absnsyq75 "75th"
label variable absnsyq90 "90th"
tsline absnsyq10 absnsyq25 absnsymedian absnsyq75 absnsyq90, lcolor(black gs10 black gs10 black) lpattern(solid solid dash_dot dash_dot dot) title(Weighted Quantiles of Absolute Size of Price Change) ///
	graphregion(fcolor(white)) tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 "2000" 2010m1 "2010")  ttitle("") yscale(range(0.02 0.2)) ylabel(0.04(0.04)0.2, nogrid) ///
	title("Quantiles of the Absolute Size of Price Changes") saving("Figures\FigA2.gph", replace) 
export delimited year absnsyq10 absnsyq25 absnsymedian absnsyq75 absnsyq90 using "Figures\FigA2.csv" if  year != 1977, replace
	
*Figure A.3 (Absolute Size of Price Increases and Decreases, Quarterly running average)
use "working\Freq12.dta", clear
sort year month
keep if month == 3 | month == 6 | month == 9 | month == 12
label variable absup12median "Size of Price Increases"
label variable absdw12median "size of Price Decreases"
tsline absup12median absdw12median if year != 1977 & majgroup == 13, yscale(range(0 0.16)) ylabel(0(0.02)0.16) saving("Figures\FigA3.gph", replace)
export delimited year month absup12median absdw12median using "Figures\FigA3.csv" if  year != 1977 & majgroup == 13, replace

*Figure A.4 (Frequency of Price Increases and Decreases for Food and Services, Quartery running average)
use "working\Freq12.dta", clear
sort year month
keep if month == 3 | month == 6 | month == 9 | month == 12
label variable frequp12median "Frequency of Increases"
label variable freqdw12median "Frequency of Decreases"
label variable yinfl "Sectoral CPI Inflation (right axis)"
twoway (tsline frequp12median freqdw12median if majgroup == 9 & year != 1977, yaxis(1) ///
	ytitle("",axis(1))) (tsline yinfl if year != 1977 & majgroup == 9, yaxis(2) ytitle("", axis(2))), ///
	tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 "2000" 2010m1 "2010") title("Services") ///
	graphregion(fcolor(white)) ttitle("") saving("Figures\FigA4serv.gph", replace)

use "working\Foodfreq12.dta", clear
keep if month == 3 | month == 6 | month == 9 | month == 12
label variable frequp12median "Frequency of Increases"
label variable freqdw12median "Frequency of Decreases"
label variable yinfl "Sectoral CPI Inflation (right axis)"
twoway (tsline frequp12median freqdw12median if  year != 1977, yaxis(1) ///
	ytitle("",axis(1))) (tsline yinfl if year != 1977, yaxis(2) ytitle("", axis(2))), ///
	tlabel(1980m1 "1980" 1990m1 "1990" 2000m1 "2000" 2010m1 "2010") title("Food") ///
	graphregion(fcolor(white)) ttitle("") saving("Figures\FigA4food.gph", replace)
	
graph combine "Figures\FigA4food.gph" "Figures\FigA4serv.gph", xsize(7) ysize(3) graphregion(fcolor(white)) rows(1) saving("Figures\FigA4.gph", replace)
use "working\Freq12.dta", clear
keep if majgroup == 9
append using "working\Foodfreq12.dta"
export delimited year month majgroup frequp12median freqdw12median yinfl using "Figures\FigA4.csv" if  year != 1977, replace


