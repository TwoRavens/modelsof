/*******************************************************************
table1.do  summary statistics

*******************************************************************/
clear all
cap log close
set more off
set mem 12000m
cd F:\RA\RA_Inequality\summer

set linesize 255

log using table1,text replace

use F:\RA\RA_Inequality\summer\data1\completedata1964_acs_1940.dta 

sort year
replace incbusfm =  incbus + 1.4*incfarm if year >= 1970 & year <= 1990
replace incbusfm = incbus00 if year >= 2000
replace incbusfm = incbus00*1.4 if year >= 2000 & ind1950 == 105
replace incbusfm = 0 if incbusfm == 999999
 
replace incwage = 0 if incwage == 99999
replace incbusfm = 0 if incbusfm < 0

replace incwage = 1.2*incwage if ind1950 == 105
replace incbusfm = 1.4*incbusfm if ind1950 == 105 & year <= 1960

gen incpe= incwage+incbusfm /*Including business and farm data*/

replace incpe=incwage if incpe==.
/*************Deflating*******************/
merge year using F:\RA\RA_Inequality\summer\data1\cpi_acs.dta
gen rincpe = incpe/cpi*100
drop _merge cpi
/****************************************/

sort year
* fix race
drop other 

* white, black
gen whiteno = (white == 1 & hispan == 0)
drop white 
rename whiteno white

gen blackno = (black == 1 & hispan == 0)
drop black
rename blackno black

gen other = (white == 0 & black == 0)
replace perwt = 100 if gqtype != 1 & year == 1950




/* TABLING */

tokenize 1940 1950 1960 1970 1980 1990 2000 2007 2010 2014


matrix i50w = (.,.,.,.,.,.,.,.,.,.)
matrix i75w = (.,.,.,.,.,.,.,.,.,.)

matrix i90w = (.,.,.,.,.,.,.,.,.,.)

matrix c50w = (.,.,.,.,.,.,.,.,.,.)
matrix cmeaw = (.,.,.,.,.,.,.,.,.,.)


matrix i50b = (.,.,.,.,.,.,.,.,.,.)
matrix i75b = (.,.,.,.,.,.,.,.,.,.)

matrix i90b = (.,.,.,.,.,.,.,.,.,.)

matrix c50b = (.,.,.,.,.,.,.,.,.,.)
matrix cmeab = (.,.,.,.,.,.,.,.,.,.)



/*Earnings Distributions for All Males*/


forvalues t = 1/10 {



	sum rincpe [fw=perwt] if year==``t'' & white==1,d
	matrix i50w[1,`t']=round(r(p50),0.00001)
	matrix i75w[1,`t']=round(r(p75),0.00001)

	matrix i90w[1,`t']=round(r(p90),0.00001)


	sum rincpe [fw=perwt] if year==``t'' & rincpe>0  & white==1,d
	matrix c50w[1,`t']=round(r(p50),0.00001)
	matrix cmeaw[1,`t']=round(r(mean),0.00001)


	sum rincpe [fw=perwt] if year==``t'' & black==1,d
	matrix i50b[1,`t']=round(r(p50),0.00001)
	matrix i75b[1,`t']=round(r(p75),0.00001)

	matrix i90b[1,`t']=round(r(p90),0.00001)


	sum rincpe [fw=perwt] if year==``t'' & rincpe>0 & black==1,d
	matrix c50b[1,`t']=round(r(p50),0.00001)
	matrix cmeab[1,`t']=round(r(mean),0.00001)

	
}

matrix table1p1 = i50w\i75w\i90w\c50w\cmeaw
		  
matrix table1p2 = i50b\i75b\i90b\c50b\cmeab
		  
matrix colnames table1p1 = 1940 1950 1960 1970 1980 1990 2000 2007 2010 2014
matrix colnames table1p2 = 1940 1950 1960 1970 1980 1990 2000 2007 2010 2014

matrix rownames table1p1 = "Median, all white" "75, all white" "90, all white" "Median, pos white" "Mean pos white"
matrix rownames table1p2 = "Median, all black" "75, all black" "90, all black"  "Median, pos black" "Mean pos black"

			   
esttab matrix(table1p1),title("Table 2: Summary Statistics")
esttab matrix(table1p2),title("Table 2: Summary Statistics")

esttab matrix(table1p1) using E:\RA\RA_Inequality\summer\results\table2_wage.tex,title("Table 2: Summary Statistics")
esttab matrix(table1p2) using E:\RA\RA_Inequality\summer\results\table2_wage.tex,title("Table 2: Summary Statistics")		 		  
