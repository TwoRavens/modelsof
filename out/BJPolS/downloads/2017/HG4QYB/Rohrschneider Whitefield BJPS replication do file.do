/* The analyses in this do file replicate all results from the Rohrschneider/Whitefield article 
"Critical Parties: How Parties Evaluate the Performance of Democracies". 
Two data files are required to run the analyses below: one called "RW for BJPS party level data.dta" which provides information 
for all analyses located at the party level. A second data file, called "RW expert_level_data for BJPS for SI 1.dta" 
provides the expert-level data needed to replicate the analyses presented in SI 1. 
After the two files are downloaded, and the paths specified according to local conditions, the do file first provides procedures to replicate all figures and 
tables in the published paper; then it provides procedures for the analyses presented in the supplementary online index. 
*/

use "C:\Users\roro\Dropbox\Rob\Parties in Europe\Expert Survey\Survey 4 Europe 2013\Papers\BJPS\BJPS Final published\Replication files\RW for BJPS party level data.dta", clear


***Figure 1a natdemo by electoral integrity at country level
*first create new positions for select countries to avoid label overlap
gen		pos=3
replace pos=8  if country==1
replace pos=1  if country==2
replace pos=2  if country==9
replace pos=12  if country==15
replace pos=9  if country==16
replace pos=12 if country==21
replace pos=6  if country==24
replace pos=9  if country==26
twoway	(scatter cyq19i1 inst if noneu==0&year==2013,mlabel(country) mlabv(pos)) ///
		,ytitle(Regime Evaluations 1 Negative 7 Positive)						///
		xtitle(Institutional Quality (Low to high))								///
		yscale(range (2(1) 6))ylabels(2 (1)6)								///
		xscale(range(-1(1)9))xlabel(-1(1)9,labsize(small))					///
		xsize(6) ysize(4) scheme(sj)

***Figure 1b natdemo by citizen natdemo at country level
drop 	pos
gen		pos=3
replace pos=8  if country==1
replace pos=1  if country==2
replace pos=9  if country==6
replace pos=1  if country==8
replace pos=2  if country==9
replace pos=6  if country==14
replace pos=5  if country==15
replace pos=3  if country==21
replace pos=6  if country==24
replace pos=9  if country==25

twoway	(scatter cyq19i1 c_satdemo if noneu==0&year==2013,mlabel(country)mlabv(pos))	///
		,ytitle(Party Regime Evaluations 1 Negative 7 Positive)				///
		xtitle(Citizens' Perceptions Low to high)							///
		yscale(range (2(1) 6))ylabels(2 (1)6)								///
		xscale(range(1(1)10))xlabel(1(1)10,labsize(small))					///
		xsize(6) ysize(4) scheme(sj)

***Figure 2: party positions on the performance of democracies, by party ideology
*CEE 2013
twoway (scatter q19i1 q27 if noneu==0&EW==0&year==2013,mlabel(partyname)) 	/// 
		(qfit q19i1 q27 if noneu==0&EW==0&year==2013),	scheme(sj)			///
		ytitle(Regime Evaluations 1 Negative 7 Positive) legend (off)		///
		yscale(range (0(1) 8))ylabels(0 (2)8) xlabel(0(1)8, valuelabel)		///
		xsize(6) ysize(4) 

*WE 2013
twoway (scatter q19i1 q27 if noneu==0&EW==1&year==2013,mlabel(partyname)) 	/// 
		(qfit q19i1 q27 if noneu==0&EW==1&year==2013),	scheme(sj)			///
		ytitle(Regime Evaluations 1 Negative 7 Positive) legend (off)		///
		yscale(range (0(1) 8))ylabels(0 (2)8) xlabel(0(1)8, valuelabel)		///
		xsize(6) ysize(4) 


*Table 2 , model 1
set more off
mixed q19i1 if noneu==0&year==2013 || country: 

*Table 2, model 2:
set more off
mixed q19i1  i.gov1 lelecn c.Proportion c.app c.q26ibimp c.q27##c.q27   ///
	i.cont F M if noneu==0&year==2013|| country:  

*Table 2, model 3:
mixed q19i1 i.gov1 lelecn c.Proportion c.app c.q26ibimp c.q27##c.q27  ///
	i.cont  F M polityIV L1or  gdpcap unemp  inflation ///
	if noneu==0 & year==2013 ///
	|| country:  

*TAble 2, model 4: 
set more off
mixed q19i1 i.gov1 lelecn c.Proportion c.app c.q26ibimp c.q27##c.q27  ///
	i.cont F M inst L1or  gdpcap unemp  inflation ///
	if noneu==0&year==2013 ///
	|| country: 

*Table 2, model 5:
set more off
mixed q19i1 i.gov1 lelecn c.Proportion c.app c.q26ibimp c.q27##c.q27  ///
	i.cont F M polityIV inst L1or  gdpcap unemp  inflation ///
	if noneu==0&year==2013 ///
	|| country: 

*Table 2, model 6:
set more off
mixed q19i1 i.gov1 lelecn c.Proportion c.polityIV  c.app c.q26ibimp c.q27##c.q27  ///
	i.cont F M govturn  inst c.L1or##c.gov1  gdpcap   unemp  inflation ///
	if noneu==0 & year==2013 ///
	|| country: 

*Table 2, model 7:
set more off
mixed q19i1 i.gov1 lelecn c.Proportion##c.L1or c.app c.q26ibimp c.q27##c.q27  ///
	i.cont F M polityIV inst L1or  gdpcap unemp  inflation ///
	if noneu==0&year==2013 ///
	|| country: 

*Table 3, model 8:
set more off
mixed  q19i1  c.gov1##c.polityIV45 c.pmgov1 c.polityIV45 c.cmgov1 c.polityIV45  c.q27##c.q27 ///
	     M F i.crisis  ///
		if noneu==0 & nyear==2 ||  country: || partyname:  	,   ///
		  residuals(exchangeable,t(year)) 


*******Supplementary Indices************
***SI 1 (requires the expert-level data set):
use "C:\Users\roro\Dropbox\Rob\Parties in Europe\Expert Survey\Survey 4 Europe 2013\Papers\BJPS\BJPS Final published\Replication files\RW for BJPS expert_level_data for SI 1.dta", clear
mixed q19i1 || country: || partyname:
estat icc

mixed q27 || country: || partyname:
estat icc

mixed app || country: || partyname:
estat icc

mixed q26ibimp01 || country: || partyname:
estat icc

********SI2 to SI7 (supplementary party-level analyses):
use "C:\Users\roro\Dropbox\Rob\Parties in Europe\Expert Survey\Survey 4 Europe 2013\Papers\BJPS\BJPS Final published\Replication files\RW for BJPS party level data.dta", clear


***SI 2 Table : predicting SDs of key variables
mixed q19i1_sd 	sd19i1	lelecn gov1 econ cultu EW i.pf1 polityIV gdp ///
	if year==2013 & noneu==0|| country:

mixed q27_sd 	sdq27	lelecn gov1 econ cultu EW i.pf1 polityIV gdp ///
	if year==2013 & noneu==0|| country:

mixed app_sd 	sdapp	lelecn gov1 econ cultu EW i.pf1 polityIV gdp ///
	if year==2013 & noneu==0|| country:

mixed q26ibimp_sd sdq26ibimp		lelecn gov1 econ cultu EW i.pf1 polityIV gdp ///
	if year==2013 & noneu==0|| country:


***SI 3 correlating World Bank and Varieties of Democracy data
gen		pos1=12 if country==16
replace pos1=9  if country==4
replace pos1=6  if country==17
replace pos1=1  if country==19
replace pos1=12  if country==25
replace pos1=11  if country==26

scatter inst svodinst if noneu==0,mlabel(country)mlabv(pos1)	///
	ytitle(World Bank Institutional Quality (low to high)) ///
	xtitle(Varieties of Democracy institutional quality)

***SI4 re-estimating model 5 by region: exclude macros
set more off
*CEE: model 5 with F M
set more off
mixed q19i1 gov1 lelecn c.Proportion  c.app c.q26ibimp c.q27##c.q27  ///
	i.cont   F M  i.country  ///
	if noneu==0 & EW==0 & year==2013  || country: , robust

*WE model 5 
set more off
mixed q19i1 gov1 lelecn c.Proportion  c.app c.q26ibimp c.q27##c.q27  ///
	i.cont   F M  i.country  ///
	if noneu==0 & EW==1 & year==2013  || country: , robust


***SI 5 
*Interacting Lijphart scores with Proportion: model 7 in table 2
*L1or:
set more off
mixed q19i1 c.L1or##c.Proportion F M i.gov1 lelecn ///
c.Proportion   c.app c.q26ibimp c.q27##c.q27  i.cont /// 
	polityIV   	inst gdpcap  unemp  inflation ///
	if noneu==0 & year==2013|| country: 



***SI 6 compute party swd change scores for different combinations of gov1 polityIV
*Mature democracies*
*became government
mean 	dq19i1 if dgov1==2&polityIV<1980 &noneu==0&nyear==2
matrix 	b=r(table)
scalar 	mphiint		=b[1,1]
scalar 	sephiint	=b[2,1]
gen		meanphiint	=mphiint
gen		sdphiint	=sephiint

*became opposition
mean 	dq19i1 if dgov1==0&polityIV<1980 &noneu==0&nyear==2
matrix 	b=r(table)
scalar 	mnhiint		=b[1,1]
scalar 	senhiint	=b[2,1]
gen		meannhiint	=mnhiint
gen		sdnhiint	=senhiint

*Stayed same
mean 	dq19i1 if dgov1==1&polityIV<1980 &noneu==0&nyear==2
matrix 	b=r(table)
scalar 	mshiint		=b[1,1]
scalar 	seshiint	=b[2,1]
gen		meanshiint	=mshiint
gen		sdshiint	=seshiint

****Newer democracies****
*became government
mean 	dq19i1 if dgov1==2&polityIV>1980 &noneu==0&nyear==2 
matrix 	b=r(table)
scalar 	mploint		=b[1,1]
scalar 	seploint	=b[2,1]
gen		meanploint	=mploint
gen		sdploint	=seploint

*became opposition
mean 	dq19i1 if dgov1==0&polityIV>1980 &noneu==0&nyear==2 
matrix 	b=r(table)
scalar 	mnloint		=b[1,1]
scalar 	senloint	=b[2,1]
gen		meannloint	=mnloint
gen		sdnloint	=senloint

*Stayed Same
mean 	dq19i1 if dgov1==1&polityIV>1980 &noneu==0&nyear==2 
matrix 	b=r(table)
scalar 	msloint		=b[1,1]
scalar 	sesloint	=b[2,1]
gen		meansloint	=msloint
gen		sdsloint	=sesloint


*now create one variable containing all meanses
gen		Me	=meanphiint 	if dgov1== 2&polityIV<1980 &noneu==0&nyear==2
replace	Me	=meannhiint		if dgov1== 0&polityIV<1980 &noneu==0&nyear==2
replace	Me	=meanshiint		if dgov1== 1&polityIV<1980 &noneu==0&nyear==2
replace	Me	=meanploint 	if dgov1== 2&polityIV>1980 &noneu==0&nyear==2
replace	Me	=meannloint 	if dgov1== 0&polityIV>1980 &noneu==0&nyear==2
replace	Me	=meansloint 	if dgov1== 1&polityIV>1980 &noneu==0&nyear==2

*now create one variable containing all sds
gen		SD	=sdphiint 		if dgov1== 2&polityIV<1980 &noneu==0&nyear==2
replace SD	=sdnhiint 		if dgov1== 0&polityIV<1980 &noneu==0&nyear==2
replace SD	=sdshiint 		if dgov1== 1&polityIV<1980 &noneu==0&nyear==2
replace	SD	=sdploint 		if dgov1== 2&polityIV>1980 &noneu==0&nyear==2
replace	SD	=sdnloint 		if dgov1== 0&polityIV>1980 &noneu==0&nyear==2
replace	SD	=sdsloint 		if dgov1== 1&polityIV>1980 &noneu==0&nyear==2

*now create ranges plot for figure 3
*Stable democracies
serrbar Me SD dgov1 if polityIV<1980, ytitle(Delta Regime Evaluations -1 More Negative in 2013 1 More Positive) ///
	ytitle(, size(small)) ylabel(-2(1)2) xtitle(Change in Incumbency Status 2008-2013) 	///
	xlabel(#3, angle(default) valuelabel alternate) recast(rbar) lwidth(medium) barwidth(.5)  xsize(3) ysize(3)scheme(s2mono)

*Newer democracies
serrbar Me SD dgov1 if polityIV>1980, ytitle(Delta Regime Evaluations -1 More Negative in 2013 1 More Positive) ///
	ytitle(, size(small)) xtitle(Change in Incumbency Status 2008-2013) 	///
	xlabel(#3, angle(default) valuelabel alternate) recast(rbar) lwidth(medium) barwidth(.5)xsize(3) ysize(3)scheme(sj)


***SI 7 model 5 in table 2: adding posC 
*Pooled: model 5 
set more off
mixed q19i1 c.Proportion  c.app i.gov1 lelecn  c.q26ibimp c.q27##c.q27  ///
	i.cont F M c.posC polityIV inst  L1or  gdpcap  unemp  inflation  ///
	if noneu==0  & year==2013 || country:

***SI 7: Pooled: model 5 in table 2 including with interaction posC inst 
set more off
mixed q19i1 c.Proportion c.app i.gov1 lelecn   c.q26ibimp c.q27##c.q27  ///
	i.cont F M c.posC##c.inst  polityIV   L1or gdpcap  unemp  inflation ///
	if noneu==0  & year==2013 || country : 
