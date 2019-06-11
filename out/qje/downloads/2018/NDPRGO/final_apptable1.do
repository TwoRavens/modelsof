/*******************************************************************
table1.do  summary statistics

*******************************************************************/
clear all
cap log close
set more off
set mem 12000m
cd E:\RA\RA_Inequality\summer

set linesize 255

log using table1,text replace

use E:\RA\RA_Inequality\summer\data1\completedata1964_acs_1940.dta 

sort year
/*************Deflating*******************/
merge year using E:\RA\RA_Inequality\summer\data1\cpi_acs.dta
gen rincwage = incwage/cpi*100
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


gen lrincwage = rincwage
replace lrincwage = 1 if rincwage == 0
replace lrincwage = log(lrincwage)


gen lincwage = lrincwage

cap drop i
cap drop N
cap drop pct

sort year lrincwage
by year: egen N = total(perwt) 
by year lrincwage: egen temp = total(perwt)
gen half = temp/2
by year: gen runsum = sum(perwt)
gen runsum_n_1 = runsum[_n-1]
by year: replace runsum_n_1 = 0 if _n==1
gen i = .
by year lrincwage: replace i = half+runsum_n_1 if _n==1
replace i = i[_n-1] if i==.
gen pct = i/N*100
drop runsum runsum_n_1 half temp N i

/*Education*/
gen HS = (educ>=6)
gen BA = (educ>=10)

/*Percentile Rank Education*/
sort year yreduc
by year: egen N = total(perwt) 
by year yreduc: egen temp = total(perwt)
gen half = temp/2
by year: gen runsum = sum(perwt)
gen runsum_n_1 = runsum[_n-1]
by year: replace runsum_n_1 = 0 if _n==1
gen i = .
by year yreduc: replace i = half+runsum_n_1 if _n==1
replace i = i[_n-1] if i==.
gen pctEduc = i/N*100
drop runsum runsum_n_1 half temp N i

/*Labor Force Participation*/
gen olf = empstat==3

/*Unemployed*/
gen unemp = (empstat==2)


 gen incar = (gqtype == 2) if year <= 1980
  replace incar = (gqtype==1) if year>1980

 gen nioolf = (incar == 0 & olf == 1)
 gen niilfu = (incar == 0 & olf == 0 & unemp == 1)
 gen zerearn = incwage == 0 

/*INDUSTRY*/
gen ind1 = (ind1950==105)|(ind1950==116)|(ind1950==126)     /*FFA*/
gen ind2 = (ind1950==206)|(ind1950==216)|(ind1950==226)|(ind1950==236)|(ind1950==239)    /*Mining*/
gen ind3 = (ind1950==246)    /*Construction*/
gen ind4 = (ind1950>=306 & ind1950<=499)    /*Manufacturing*/
gen ind5 = (ind1950>=506 &  ind1950<=598)   /*Transp and Public Utilities*/
gen ind6 = (ind1950>=606 & ind1950<=699)    /*Trade*/
gen ind7 = (ind1950>=716 & ind1950<=808)|(ind1950>=868 & ind1950<=899)    /*Professional Services*/
gen ind8 = (ind1950>=816 & ind1950<=859)    /*Other Services*/
gen ind9 = (ind1950>=906 & ind1950<=982)     /*Other*/

/*Region*/
gen regN = (region==11 | region==12 | region==13 )
gen regS = (region==31 | region==32 | region==33 | region==34)
gen regM = (region==21 | region==22 | region==23)
gen regW = (region==41 | region==42 | region==43)

/* TABLING */

tokenize 1940 1950 1960 1970 1980 1990 2000 2007 2010 2014
matrix ehw = (.,.,.,.,.,.,.,.,.,.)
matrix ebw = (.,.,.,.,.,.,.,.,.,.)
matrix eyw = (.,.,.,.,.,.,.,.,.,.)
matrix epw = (.,.,.,.,.,.,.,.,.,.)

matrix low = (.,.,.,.,.,.,.,.,.,.)
matrix luw = (.,.,.,.,.,.,.,.,.,.)
matrix liw = (.,.,.,.,.,.,.,.,.,.)
matrix lzw = (.,.,.,.,.,.,.,.,.,.)


matrix i10w = (.,.,.,.,.,.,.,.,.,.)
matrix i25w = (.,.,.,.,.,.,.,.,.,.)
matrix i50w = (.,.,.,.,.,.,.,.,.,.)
matrix i75w = (.,.,.,.,.,.,.,.,.,.)
matrix i90w = (.,.,.,.,.,.,.,.,.,.)

matrix c10w = (.,.,.,.,.,.,.,.,.,.)
matrix c25w = (.,.,.,.,.,.,.,.,.,.)
matrix c50w = (.,.,.,.,.,.,.,.,.,.)
matrix c75w = (.,.,.,.,.,.,.,.,.,.)
matrix c90w = (.,.,.,.,.,.,.,.,.,.)

matrix p10w = (.,.,.,.,.,.,.,.,.,.)
matrix p25w = (.,.,.,.,.,.,.,.,.,.)
matrix p50w = (.,.,.,.,.,.,.,.,.,.)
matrix p75w = (.,.,.,.,.,.,.,.,.,.)
matrix p90w = (.,.,.,.,.,.,.,.,.,.)

matrix amw = (.,.,.,.,.,.,.,.,.,.)
matrix asw = (.,.,.,.,.,.,.,.,.,.)
matrix a1w = (.,.,.,.,.,.,.,.,.,.)
matrix a2w = (.,.,.,.,.,.,.,.,.,.)
matrix a3w = (.,.,.,.,.,.,.,.,.,.)
matrix a4w = (.,.,.,.,.,.,.,.,.,.)
matrix a5w = (.,.,.,.,.,.,.,.,.,.)
matrix a6w = (.,.,.,.,.,.,.,.,.,.)

matrix ind1w  = (.,.,.,.,.,.,.,.,.,.)
matrix ind2w  = (.,.,.,.,.,.,.,.,.,.)
matrix ind3w  = (.,.,.,.,.,.,.,.,.,.)
matrix ind4w  = (.,.,.,.,.,.,.,.,.,.)
matrix ind5w  = (.,.,.,.,.,.,.,.,.,.)
matrix ind6w  = (.,.,.,.,.,.,.,.,.,.)
matrix ind7w  = (.,.,.,.,.,.,.,.,.,.)
matrix ind8w  = (.,.,.,.,.,.,.,.,.,.)
matrix ind9w  = (.,.,.,.,.,.,.,.,.,.)

matrix regNw = (.,.,.,.,.,.,.,.,.,.)
matrix regSw = (.,.,.,.,.,.,.,.,.,.)
matrix regMw = (.,.,.,.,.,.,.,.,.,.)
matrix regWw = (.,.,.,.,.,.,.,.,.,.)

/*Need to do 1-digit industries*/

/*Regions*/

matrix ehb = (.,.,.,.,.,.,.,.,.,.)
matrix ebb = (.,.,.,.,.,.,.,.,.,.)
matrix eyb = (.,.,.,.,.,.,.,.,.,.)
matrix epb = (.,.,.,.,.,.,.,.,.,.)

matrix lob = (.,.,.,.,.,.,.,.,.,.)
matrix lub = (.,.,.,.,.,.,.,.,.,.)
matrix lib = (.,.,.,.,.,.,.,.,.,.)
matrix lzb = (.,.,.,.,.,.,.,.,.,.)

matrix i10b = (.,.,.,.,.,.,.,.,.,.)
matrix i25b = (.,.,.,.,.,.,.,.,.,.)
matrix i50b = (.,.,.,.,.,.,.,.,.,.)
matrix i75b = (.,.,.,.,.,.,.,.,.,.)
matrix i90b = (.,.,.,.,.,.,.,.,.,.)

matrix c10b = (.,.,.,.,.,.,.,.,.,.)
matrix c25b = (.,.,.,.,.,.,.,.,.,.)
matrix c50b = (.,.,.,.,.,.,.,.,.,.)
matrix c75b = (.,.,.,.,.,.,.,.,.,.)
matrix c90b = (.,.,.,.,.,.,.,.,.,.)

matrix p10b = (.,.,.,.,.,.,.,.,.,.)
matrix p25b = (.,.,.,.,.,.,.,.,.,.)
matrix p50b = (.,.,.,.,.,.,.,.,.,.)
matrix p75b = (.,.,.,.,.,.,.,.,.,.)
matrix p90b = (.,.,.,.,.,.,.,.,.,.)

matrix amb = (.,.,.,.,.,.,.,.,.,.)
matrix asb = (.,.,.,.,.,.,.,.,.,.)
matrix a1b = (.,.,.,.,.,.,.,.,.,.)
matrix a2b = (.,.,.,.,.,.,.,.,.,.)
matrix a3b = (.,.,.,.,.,.,.,.,.,.)
matrix a4b = (.,.,.,.,.,.,.,.,.,.)
matrix a5b = (.,.,.,.,.,.,.,.,.,.)
matrix a6b = (.,.,.,.,.,.,.,.,.,.)

matrix ind1b = (.,.,.,.,.,.,.,.,.,.)
matrix ind2b = (.,.,.,.,.,.,.,.,.,.)
matrix ind3b = (.,.,.,.,.,.,.,.,.,.)
matrix ind4b = (.,.,.,.,.,.,.,.,.,.)
matrix ind5b = (.,.,.,.,.,.,.,.,.,.)
matrix ind6b = (.,.,.,.,.,.,.,.,.,.)
matrix ind7b = (.,.,.,.,.,.,.,.,.,.)
matrix ind8b = (.,.,.,.,.,.,.,.,.,.)
matrix ind9b = (.,.,.,.,.,.,.,.,.,.)

matrix regNb = (.,.,.,.,.,.,.,.,.,.)
matrix regSb = (.,.,.,.,.,.,.,.,.,.)
matrix regMb = (.,.,.,.,.,.,.,.,.,.)
matrix regWb = (.,.,.,.,.,.,.,.,.,.)

/*Earnings Distributions for All Males*/


forvalues t = 1/10 {

*

	sum HS [fw=perwt] if year==``t'' & white==1
	matrix ehw[1,`t']=round(r(mean),0.00001)

	sum BA [fw=perwt] if year==``t'' & white==1
	matrix ebw[1,`t']=round(r(mean),0.00001)

	sum yreduc [fw=perwt] if year==``t'' & white==1
	matrix eyw[1,`t']=round(r(mean),0.00001)

	sum pctEduc [fw=perwt] if year==``t'' & white==1
	matrix epw[1,`t']=round(r(mean),0.00001)

	sum nioolf [fw=perwt] if year==``t'' & white==1
	matrix low[1,`t']=round(r(mean),0.00001)

	sum niilfu [fw=perwt] if year==``t'' & white==1
	matrix luw[1,`t']=round(r(mean),0.00001)

	sum incar [fw=perwt] if year==``t'' & white==1
	matrix liw[1,`t']=round(r(mean),0.00001)

	sum zerearn [fw=perwt] if year==``t'' & white==1
	matrix lzw[1,`t']=round(r(mean),0.00001)

	sum rincwage [fw=perwt] if year==``t'' & white==1,d
	matrix i10w[1,`t']=round(r(p10),0.00001)
	matrix i25w[1,`t']=round(r(p25),0.00001)
	matrix i50w[1,`t']=round(r(p50),0.00001)
	matrix i75w[1,`t']=round(r(p75),0.00001)
	matrix i90w[1,`t']=round(r(p90),0.00001)

	sum rincwage [fw=perwt] if year==``t'' & rincwage>0  & white==1,d
	matrix c10w[1,`t']=round(r(p10),0.00001)
	matrix c25w[1,`t']=round(r(p25),0.00001)
	matrix c50w[1,`t']=round(r(p50),0.00001)
	matrix c75w[1,`t']=round(r(p75),0.00001)
	matrix c90w[1,`t']=round(r(p90),0.00001)

	sum pct [fw=perwt] if year==``t'' & white==1,d
	matrix p10w[1,`t'] = round(r(p10),0.00001)
	matrix p25w[1,`t'] = round(r(p25),0.00001)
	matrix p50w[1,`t'] = round(r(p50),0.00001)
	matrix p75w[1,`t'] = round(r(p75),0.00001)
	matrix p90w[1,`t'] = round(r(p90),0.00001)

	sum age [fw=perwt] if year==``t'' & white==1
	matrix amw[1,`t'] = round(r(mean),0.00001)
	matrix asw[1,`t'] = round(r(sd),0.00001)

	sum age1 [fw=perwt] if year==``t'' & white==1
	matrix a1w[1,`t'] = round(r(mean),0.00001)

	sum age2 [fw=perwt] if year==``t'' & white==1
	matrix a2w[1,`t'] = round(r(mean),0.00001)

	sum age3 [fw=perwt] if year==``t'' & white==1
	matrix a3w[1,`t'] = round(r(mean),0.00001)

	sum age4 [fw=perwt] if year==``t'' & white==1
	matrix a4w[1,`t'] = round(r(mean),0.00001)

	sum age5 [fw=perwt] if year==``t'' & white==1
	matrix a5w[1,`t'] = round(r(mean),0.00001)

	sum age6 [fw=perwt] if year==``t'' & white==1
	matrix a6w[1,`t'] = round(r(mean),0.00001)

	sum ind1 [fw=perwt] if year==``t'' & empstat==1 & white==1
	matrix ind1w[1,`t'] = round(r(mean),0.00001)

	sum ind2 [fw=perwt] if year==``t'' & empstat==1 & white==1
	matrix ind2w[1,`t'] = round(r(mean),0.00001)

	sum ind3 [fw=perwt] if year==``t'' & empstat==1 &  white==1
	matrix ind3w[1,`t'] = round(r(mean),0.00001)

	sum ind4 [fw=perwt] if year==``t'' & empstat==1 &  white==1
	matrix ind4w[1,`t'] = round(r(mean),0.00001)

	sum ind5 [fw=perwt] if year==``t'' & empstat==1 &  white==1
	matrix ind5w[1,`t'] = round(r(mean),0.00001)

	sum ind6 [fw=perwt] if year==``t'' & empstat==1 &  white==1
	matrix ind6w[1,`t'] = round(r(mean),0.00001)

	sum ind7 [fw=perwt] if year==``t'' & empstat==1 &  white==1
	matrix ind7w[1,`t'] = round(r(mean),0.00001)

	sum ind8 [fw=perwt] if year==``t'' & empstat==1 &  white==1
	matrix ind8w[1,`t'] = round(r(mean),0.00001)

	sum ind9 [fw=perwt] if year==``t'' & empstat==1 &  black==0
	matrix ind9w[1,`t'] = round(r(mean),0.00001)

	sum regN [fw=perwt] if year==``t'' & white==1
	matrix regNw[1,`t'] = round(r(mean),0.00001)

	sum regM [fw=perwt] if year==``t'' & white==1
	matrix regMw[1,`t'] = round(r(mean),0.00001)

	sum regS [fw=perwt] if year==``t'' & white==1
	matrix regSw[1,`t'] = round(r(mean),0.00001)

	sum regW [fw=perwt] if year==``t'' & white==1
	matrix regWw[1,`t'] = round(r(mean),0.00001)

	sum HS [fw=perwt] if year==``t'' & black==1
	matrix ehb[1,`t']=round(r(mean),0.00001)

	sum BA [fw=perwt] if year==``t'' & black==1
	matrix ebb[1,`t']=round(r(mean),0.00001)

	sum yreduc [fw=perwt] if year==``t'' & black==1
	matrix eyb[1,`t']=round(r(mean),0.00001)

	sum pctEduc [fw=perwt] if year==``t'' & black==1
	matrix epb[1,`t']=round(r(mean),0.00001)

	sum nioolf [fw=perwt] if year==``t'' & black==1
	matrix lob[1,`t']=round(r(mean),0.00001)

	sum niilfu [fw=perwt] if year==``t'' & black==1
	matrix lub[1,`t']=round(r(mean),0.00001)

	sum incar [fw=perwt] if year==``t'' & black==1
	matrix lib[1,`t']=round(r(mean),0.00001)

	sum zerearn [fw=perwt] if year==``t'' & black==1
	matrix lzb[1,`t']=round(r(mean),0.00001)

	sum rincwage [fw=perwt] if year==``t'' & black==1,d
	matrix i10b[1,`t']=round(r(p10),0.00001)
	matrix i25b[1,`t']=round(r(p25),0.00001)
	matrix i50b[1,`t']=round(r(p50),0.00001)
	matrix i75b[1,`t']=round(r(p75),0.00001)
	matrix i90b[1,`t']=round(r(p90),0.00001)

	sum rincwage [fw=perwt] if year==``t'' & rincwage>0 & black==1,d
	matrix c10b[1,`t']=round(r(p10),0.00001)
	matrix c25b[1,`t']=round(r(p25),0.00001)
	matrix c50b[1,`t']=round(r(p50),0.00001)
	matrix c75b[1,`t']=round(r(p75),0.00001)
	matrix c90b[1,`t']=round(r(p90),0.00001)

	sum pct [fw=perwt] if year==``t'' & black==1,d
	matrix p10b[1,`t'] = round(r(p10),0.00001)
	matrix p25b[1,`t'] = round(r(p25),0.00001)
	matrix p50b[1,`t'] = round(r(p50),0.00001)
	matrix p75b[1,`t'] = round(r(p75),0.00001)
	matrix p90b[1,`t'] = round(r(p90),0.00001)

	sum age [fw=perwt] if year==``t'' & black==1
	matrix amb[1,`t'] = round(r(mean),0.00001)
	matrix asb[1,`t'] = round(r(sd),0.00001)

	sum age1 [fw=perwt] if year==``t'' & black==1
	matrix a1b[1,`t'] = round(r(mean),0.00001)

	sum age2 [fw=perwt] if year==``t'' & black==1
	matrix a2b[1,`t'] = round(r(mean),0.00001)

	sum age3 [fw=perwt] if year==``t'' & black==1
	matrix a3b[1,`t'] = round(r(mean),0.00001)

	sum age4 [fw=perwt] if year==``t'' & black==1
	matrix a4b[1,`t'] = round(r(mean),0.00001)

	sum age5 [fw=perwt] if year==``t'' & black==1
	matrix a5b[1,`t'] = round(r(mean),0.00001)

	sum age6 [fw=perwt] if year==``t'' & black==1
	matrix a6b[1,`t'] = round(r(mean),0.00001)


	sum ind1 [fw=perwt] if year==``t'' & empstat==1 &  black==1
	matrix ind1b[1,`t'] = round(r(mean),0.00001)

	sum ind2 [fw=perwt] if year==``t'' & empstat==1 &  black==1
	matrix ind2b[1,`t'] = round(r(mean),0.00001)

	sum ind3 [fw=perwt] if year==``t'' & empstat==1 &  black==1
	matrix ind3b[1,`t'] = round(r(mean),0.00001)

	sum ind4 [fw=perwt] if year==``t'' & empstat==1 &  black==1
	matrix ind4b[1,`t'] = round(r(mean),0.00001)

	sum ind5 [fw=perwt] if year==``t'' & empstat==1 &  black==1
	matrix ind5b[1,`t'] = round(r(mean),0.00001)

	sum ind6 [fw=perwt] if year==``t'' & empstat==1 &  black==1
	matrix ind6b[1,`t'] = round(r(mean),0.00001)

	sum ind7 [fw=perwt] if year==``t'' & empstat==1 &  black==1
	matrix ind7b[1,`t'] = round(r(mean),0.00001)

	sum ind8 [fw=perwt] if year==``t'' & empstat==1 &  black==1
	matrix ind8b[1,`t'] = round(r(mean),0.00001)

	sum ind9 [fw=perwt] if year==``t'' & empstat==1 &  black==1
	matrix ind9b[1,`t'] = round(r(mean),0.00001)

	sum regN [fw=perwt] if year==``t'' & black==1
	matrix regNb[1,`t'] = round(r(mean),0.00001)

	sum regM [fw=perwt] if year==``t'' & black==1
	matrix regMb[1,`t'] = round(r(mean),0.00001)

	sum regS [fw=perwt] if year==``t'' & black==1
	matrix regSb[1,`t'] = round(r(mean),0.00001)

	sum regW [fw=perwt] if year==``t'' & black==1
	matrix regWb[1,`t'] = round(r(mean),0.00001)

}

matrix table1p1 = ehw\ebw\eyw\epw\low\luw\liw\i10w\i25w\i50w\i75w\i90w\ ///
		  c10w\c25w\c50w\c75w\c90w\p10w\p25w\p50w\p75w\p90w\amw\asw\a1w\a2w\a3w\a4w\a5w\a6w\ ///
		  ind1w\ind2w\ind3w\ind4w\ind5w\ind6w\ind7w\ind8w\ind9w\ ///
		  regNw\regMw\regSw\regWw
		  
matrix table1p2 = ehb\ebb\eyb\epb\lob\lub\lib\i10b\i25b\i50b\i75b\i90b\ ///
		  c10b\c25b\c50b\c75b\c90b\p10b\p25b\p50b\p75b\p90b\amb\asb\a1b\a2b\a3b\a4b\a5b\a6b\ ///
		  ind1b\ind2b\ind3b\ind4b\ind5b\ind6b\ind7b\ind8b\ind9b\ ///
		  regNb\regMb\regSb\regWb

		  
matrix colnames table1p1 = 1940 1950 1960 1970 1980 1990 2000 2007 2010 2014
matrix colnames table1p2 = 1940 1950 1960 1970 1980 1990 2000 2007 2010 2014

matrix rownames table1p1 = "HS" "BA" "Yrs Educ" "Pct Rnk Educ" "Out of LF" "Unemp" ///
			   "Incarc" "10" "25" "50" "75" "90" "10" "25" "50" "75" "90" ///
			   "10" "25" "50" "75" "90" "Age (Mean)" "Age (SD)" "Age 25 to 29" ///
			   "Age 30 to 34" "Age 35 to 39" "Age 40 to 44" "Age 45 to 49" "Age 50 to 54" "Food For and Ag" ///
			   "Mining" "Construction" "Manuf" "Transp and Utilities" "Trade" ///
			   "Professional Services" "Other Services" "Other" "North" "Midwest" ///
			   "South" "West"
matrix rownames table1p2 = "HS" "BA" "Yrs Educ" "Pct Rnk Educ" "Out of LF" "Unemp" ///
			   "Incarc" "10" "25" "50" "75" "90" "10" "25" "50" "75" "90" ///
			   "10" "25" "50" "75" "90" "Age (Mean)" "Age (SD)" "Age 25 to 29" ///
			   "Age 30 to 34" "Age 35 to 39" "Age 40 to 44" "Age 45 to 49" "Age 50 to 54" "Food For and Ag" ///
			   "Mining" "Construction" "Manuf" "Transp and Utilities" "Trade" ///
			   "Professional Services" "Other Services" "Other" "North" "Midwest" ///
			   "South" "West"	

			   
esttab matrix(table1p1),title("Table 1: Summary Statistics")
esttab matrix(table1p2),title("Table 1: Summary Statistics")

esttab matrix(table1p1) using E:\RA\RA_Inequality\summer\results\table1p13_0216.tex,title("Table 1: Summary Statistics")
esttab matrix(table1p2) using E:\RA\RA_Inequality\summer\results\table1p23_0216.tex,title("Table 1: Summary Statistics")		 		  
