/*This main file runs the appropriate regressions from Inter-Industry R&D Comovement.
Assumes the working directory has already been set.
This file is when data is deflated using the BEA Chain-Type Price Index.


This file simply runs the models currently being used in the paper and esimates as a SUR rather than equation by equation OLS (robustness check)

Andrew C. Chang
University of California, Irvine
June 30, 2010
v. 1.00 - Original Implementation

Revised for R&R at ReStat
March 26, 2011
Changed file name.
v. 1.01

*/
clear all  //clear memory

capture log close
log using RDPaper_Regressions_Condensed_SUR_7Industriesall.log, replace
set memory 50m
set matsize 800
set more off

insheet using RD_AllData_10Industries.raw  //Chain Deflator
file open pvalueindustryspecific using pvalueindustryspecific_7all.txt, write replace
file open pvalueaggregate using pvalueaggregate_7all.txt, write replace
file open pvaluebaseline using pvaluebaseline_7all.txt, write replace
file open isall using isalldummy_7all.txt, write replace  //dummy variable for if the test involves the 'all other rd' category. 
//Only need one isall file since the dummy would be the same across tests
file open isintra using isintradummy_7all.txt, write replace  //dummy variable for own RD

summarize 

tsset year

local rd "rd28 rd33 rd34 rd35 rd36 rd372and376 rd38 rdall7"
local rd1lag "L.rd28 L.rd33 L.rd34 L.rd35 L.rd36 L.rd372and376 L.rd38 L.rdall7"
local rd2lag "L2.rd28 L2.rd33 L2.rd34 L2.rd35 L2.rd36 L2.rd372and376 L2.rd38 L2.rdall7"

//Baseline

sureg (rd28: rd28 `rd1lag' `rd2lag') ///
      (rd33: rd33 `rd1lag' `rd2lag') ///
      (rd34: rd34 `rd1lag' `rd2lag') ///
      (rd35: rd35 `rd1lag' `rd2lag') ///
      (rd36: rd36 `rd1lag' `rd2lag') ///
      (rd372and376: rd372and376 `rd1lag' `rd2lag') ///
	(rd38: rd38 `rd1lag' `rd2lag') ///
	(rdall7: rdall7 `rd1lag' `rd2lag') ///
,small dfk isure

matrix coeff_baseline = e(b)
matrix sigma_hat_baseline = e(Sigma)
mat2txt, matrix(coeff_baseline) saving(coeff_baseline.txt) replace
mat2txt, matrix(sigma_hat_baseline) saving(sigma_hat_baseline.txt) replace
local all "rdall7"

foreach x of local rd {

	foreach y of local rd {

		test [`x']L.`y' [`x']L2.`y'
		scalar pvalue = r(p)
		file write pvaluebaseline %9.8f (pvalue) _n  //%9.8f means 9 digits, decimal, 8 decimal places in numeric format
		
		if (`x' == `all' | `y' == `all') {
		
			scalar isalldummy = 1
			file write isall %1.1g (isalldummy) _n

		}
		else {

			scalar isalldummy = 0
			file write isall %1.1g (isalldummy) _n

		}	
		if (`x' == `y') {

			scalar isintradummy = 1
			file write isintra %1.1g (isintradummy) _n
		
		}
		else {

			scalar isintradummy = 0
			file write isintra %1.1g (isintradummy) _n
		
		}	
	
	}

}

//Industry GDP, Industry Government Spending, Both Dummies


sureg (rd28: rd28 `rd1lag' `rd2lag' gdp28 govrd28 int81rd28grow dummy91) ///
      (rd33: rd33 `rd1lag' `rd2lag' gdp33 govrd33 int81rd33grow dummy91) ///
      (rd34: rd34 `rd1lag' `rd2lag' gdp34 govrd34 int81rd34grow dummy91) ///
      (rd35: rd35 `rd1lag' `rd2lag' gdp35 govrd35 int81rd35grow dummy91) ///
      (rd36: rd36 `rd1lag' `rd2lag' gdp36 govrd36 int81rd36grow dummy91) ///
      (rd372and376: rd372and376 `rd1lag' `rd2lag' gdp372and376 govrd372and376 int81rd372and376grow dummy91) ///
	(rd38: rd38 `rd1lag' `rd2lag' gdp38 govrd38 int81rd38grow dummy91) ///
	(rdall7: rdall7 `rd1lag' `rd2lag' gdpall7 govrdall7 int81rdall7grow dummy91) ///
,small dfk isure

estat ic

matrix coeff_indspecific = e(b)
matrix sigma_hat_indspecific = e(Sigma)
mat2txt, matrix(coeff_indspecific) saving(coeff_indspecific.txt) replace
mat2txt, matrix(sigma_hat_indspecific) saving(sigma_hat_indspecific.txt) replace

foreach x of local rd {

	foreach y of local rd {

		test [`x']L.`y' [`x']L2.`y'
		scalar pvalue = r(p)
		file write pvalueindustryspecific %9.8f (pvalue) _n  //%9.8f means 9 digits, decimal, 8 decimal places in numeric format
	
	}

}

//One lag to one lead of aggregate GDP and GOV
sureg (rd28: rd28 `rd1lag' `rd2lag' L.gdp gdp F.gdp L.gov gov F.gov) ///
      (rd33: rd33 `rd1lag' `rd2lag' L.gdp gdp F.gdp L.gov gov F.gov) ///
      (rd34: rd34 `rd1lag' `rd2lag' L.gdp gdp F.gdp L.gov gov F.gov) ///
      (rd35: rd35 `rd1lag' `rd2lag' L.gdp gdp F.gdp L.gov gov F.gov) ///
      (rd36: rd36 `rd1lag' `rd2lag' L.gdp gdp F.gdp L.gov gov F.gov) ///
	(rd372and376: rd372and376 `rd1lag' `rd2lag' L.gdp gdp F.gdp L.gov gov F.gov) ///
	(rd38: rd38 `rd1lag' `rd2lag' L.gdp gdp F.gdp L.gov gov F.gov) ///
	(rdall7: rdall7 `rd1lag' `rd2lag' L.gdp gdp F.gdp L.gov gov F.gov) ///
,small dfk isure
estat ic

matrix coeff_agg = e(b)
matrix sigma_hat_agg = e(Sigma)
mat2txt, matrix(coeff_agg) saving(coeff_agg.txt) replace
mat2txt, matrix(sigma_hat_agg) saving(sigma_hat_agg.txt) replace

foreach x of local rd {

	foreach y of local rd {

		test [`x']L.`y' [`x']L2.`y'
		scalar pvalue = r(p)
		file write pvalueaggregate %9.8f (pvalue) _n  //%9.8f means 9 digits, decimal, 8 decimal places in numeric format
	
	}

}

file close pvalueindustryspecific
file close pvalueaggregate
file close pvaluebaseline
file close isall
file close isintra

log close





