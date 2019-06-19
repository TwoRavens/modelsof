
/*do file name: BoE_Calculation.do,

Do a back-of-the-envelope calculation
Created by: Junfu Zhang
Last modified on 2/23/2016

*/

clear matrix


set rmsg on
set more off
set matsize 800
set memory 1g
set varlabelpos 15


use CleanedLandData.dta

sum maxfloorlotratio

//Single out the city of Ningbo
keep if city == "宁波市" & residential == 1
drop yearcode* citycode*


//Check to make sure that lnmaxfar = ln(maxfloorlotratio)
ge x = lnmaxfar - ln(maxfloorlotratio)
sum x
drop x

tab year

//CPI data source: http://www.indexmundi.com/facts/china/consumer-price-index
ge CPI = .
replace CPI = 80.97 if year == 2002
replace CPI = 81.90 if year == 2003
replace CPI = 85.08 if year == 2004
replace CPI = 86.63 if year == 2005
replace CPI = 87.90 if year == 2006
replace CPI = 92.08 if year == 2007
replace CPI = 97.48 if year == 2008
replace CPI = 96.79 if year == 2009
replace CPI = 100.00 if year == 2010
replace CPI = 105.41 if year == 2011

egen total_saleprice = total(saleprice/CPI) // in millions of 2010 yuan


sum maxfloorlotratio

ge new_lnmaxfar = ln(maxfloorlotratio + 0.72) //increased by one standard deviation

ge new_lnlandprice = lnlandprice + 0.288*(new_lnmaxfar - lnmaxfar)

ge new_saleprice = saleprice*(exp(new_lnlandprice)/landprice)

egen total_saleprice2 = total(new_saleprice/CPI)

drop new_*

ge increase = 100*total_saleprice2/total_saleprice

list total_saleprice total_saleprice2 increase if _n == 1

count

clear
