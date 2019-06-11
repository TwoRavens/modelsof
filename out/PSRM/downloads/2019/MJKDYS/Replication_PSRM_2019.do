**************************************************************************************************
** File name: 	Replication_PSRM_2019.do  (Manuscript + Supplementary materials)			    **
** Purpose: 	Estimations, producing tables and figures										**
** Paper:		Are Election Results More Unpredictable? A Forecasting Test						**
** Date: 		January 2019																	**
** Authors: 	Richard Nadeau, Ruth Dassonneville, Michael S. Lewis-Beck & Philippe Mongrain	**
**************************************************************************************************


** install commands (if not installed yet) and set scheme for graphs 

ssc install loevh, replace all
ssc install blindschemes, replace all
ssc install estout, replace all
set scheme plotplainblind, permanently                                          // sets daniel bischof's plottig scheme as the default scheme for graphs


**********************
**   main results 	**
**********************

** load data
	
	use "Dataset_PSRM_2019.dta", clear
	
** description of the data (Table 1)

	tab country
	tab country if Year>=1955 & Year<=1984
	tab country if Year>=1987 & Year<=2017
	
	tab country if Year>=1955 & Year<=1970
	tab country if Year>=1971 & Year<=1986
	tab country if Year>=1987 & Year<=2002
	tab country if Year>=2003 & Year<=2017 

** main model (Table 2)

	eststo m1: reg Incvote Intvote GDPq2 Australia Canada Denmark Germany USA [pweight=weight], cluster(country)
	
	predict modelpredictions
	
	gen abserror=abs(Incvote-modelpredictions)
	
	esttab m1  using table2.tex , b(2) se(2) r2 ar2 nogap wide replace 
	 
** MAE by time period (Table 3)

	sum abserror                                                                // gives the MAE for the full sample (entered in Table 2)
	
	sum abserror if Year>=1955 & Year<=1984
	sum abserror if Year>=1987 & Year<=2017
	
	sum abserror if Year>=1955 & Year<=1970
	sum abserror if Year>=1971 & Year<=1986
	sum abserror if Year>=1987 & Year<=2002
	sum abserror if Year>=2003 & Year<=2017
	
** plot of absolute errors (Figure 1) 
	
	twoway scatter abserror Year || lpolyci abserror Year, saving("figure1.gph", replace) ytitle("Absolute unstandardized residuals") xlabel(1950(10)2020) legend(off)
	
** regressing errors on time (Table 4)

	eststo m2: reg abserror Time Australia Canada Denmark Germany USA [pweight=weight], cluster(country)
	esttab m2  using table4.tex , b(2) se(2) r2 nogap wide replace 
	
	
	
	
*****************************
** supplementary materials **
*****************************

** A. coding and sources of variables

** B. country-specific models

	eststo m1: reg Incvote Intvote GDPq2 if UK==1
	predict uk_errors
	
	eststo m2: reg Incvote Intvote GDPq2 if Australia==1
	predict aus_errors
	
	eststo m3: reg Incvote Intvote GDPq2 if Canada==1
	predict can_errors
	
	eststo m4: reg Incvote Intvote GDPq2 if Denmark==1
	predict dnk_errors
	
	eststo m5: reg Incvote Intvote GDPq2 if Germany==1
	predict deu_errors
	
	eststo m6: reg Incvote Intvote GDPq2 if USA==1
	predict usa_errors
	
	esttab m1 m2 m3 m4 m5 m6 using appB_table1.tex , b(2) se(2) nogap replace 
	
	gen country_errors=uk_errors if UK==1
	replace country_errors=aus_errors if Australia==1
	replace country_errors=can_errors if Canada==1
	replace country_errors=dnk_errors if Denmark==1
	replace country_errors=deu_errors if Germany==1
	replace country_errors=usa_errors if USA==1
	
	gen abscountryerrors=abs(Incvote-country_errors)
	twoway scatter abscountryerrors Year || lpolyci abscountryerrors Year
	
	twoway scatter abscountryerrors Year if UK==1 || lpolyci abscountryerrors Year if UK==1, saving(uk_poly.gph, replace) title("United Kingdom") legend(off)
	twoway scatter abscountryerrors Year if Australia==1 || lpolyci abscountryerrors Year if Australia==1, saving(aus_poly.gph, replace) title("Australia") legend(off)
	twoway scatter abscountryerrors Year if Canada==1 || lpolyci abscountryerrors Year if Canada==1, saving(can_poly.gph, replace) title("Canada") legend(off)
	twoway scatter abscountryerrors Year if Denmark==1 || lpolyci abscountryerrors Year if Denmark==1, saving(dnk_poly.gph, replace) title("Denmark") legend(off)
	twoway scatter abscountryerrors Year if Germany==1 || lpolyci abscountryerrors Year if Germany==1, saving(deu_poly.gph, replace) title("Germany") legend(off)
	twoway scatter abscountryerrors Year if USA==1 || lpolyci abscountryerrors Year if USA==1, saving(usa_poly.gph, replace) title("United States") legend(off)
	
	graph combine uk_poly.gph aus_poly.gph can_poly.gph dnk_poly.gph deu_poly.gph usa_poly.gph, col(2) ycommon
	
** C. different operationalisations of time
	
	gen TimeBis=Year-1955
	
	eststo m1: reg abserror c.Time##c.Time Australia Canada Denmark Germany USA [pweight=weight], cluster(country)
	eststo m2: reg abserror TimeBis Australia Canada Denmark Germany USA [pweight=weight], cluster(country)
	
	esttab m1 m2 using appC_table1.tex, b(2) se(2) r2 nogap replace
	

** D. disregarding outliers
	
	gen outlier=0
	replace outlier=1 if Canada==1 & Year==1958
	replace outlier=1 if Canada==1 & Year==1984
	replace outlier=1 if Canada==1 & Year==1993
	replace outlier=1 if Denmark==1 & Year==1973
	
	* table 1
	eststo m1: reg Incvote Intvote GDPq2 Australia Canada Denmark Germany USA if outlier==0 [pweight=weight], cluster(country)
	predict modelpredictions_nooutliers
	
	gen abserror_nooutliers=abs(Incvote-modelpredictions_nooutliers)
	replace abserror_nooutliers=. if outlier==1
	
	esttab m1  using appD_table1.tex , b(2) se(2) r2 nogap wide replace 
	
	* table 2
	sum abserror_nooutliers
	
	sum abserror_nooutliers if Year>=1955 & Year<=1984
	sum abserror_nooutliers if Year>=1987 & Year<=2017
	
	sum abserror_nooutliers if Year>=1955 & Year<=1970
	sum abserror_nooutliers if Year>=1971 & Year<=1986
	sum abserror_nooutliers if Year>=1987 & Year<=2002
	sum abserror_nooutliers if Year>=2003 & Year<=2017
	
	* table 3
	eststo m2: reg abserror_nooutliers Time Australia Canada Denmark Germany USA if outlier==0 [pweight=weight], cluster(country)
	esttab m2  using appD_table3.tex , b(2) se(2) r2 nogap wide replace 
	
	
** E. test with government approval data (only available for three countries)

	* load dataset that includes approval data for UK, Germany and USA
	use "Approval_PSRM_2019.dta", clear

	* estimate popularity models
	eststo m1: reg Incvote GovPopularity3m GDPq2 if Germany==1
	predict predictm1 if Germany==1
	
	eststo m2: reg Incvote GovPopularity3m GDPq2 i.country , cluster(country)
	predict predictm2 if e(sample)==1
	
	eststo m3: reg Incvote GovPopularity3m GDPq2 i.country if UK==1 | USA==1, cluster(country)
	predict predictm3 if e(sample)==1
	
	eststo m4: reg Incvote GovPopularity6m GDPq2 i.country if UK==1 | USA==1, cluster(country)
	predict predictm4 if e(sample)==1
	
	* table 1
	esttab m1 m2 m3 m4  using appE_table1.tex, b(2) se(2) r2 wide nogap replace

	* regress popularity errors on time	
	gen time_01=(Year-1955)/(2017-1955)
	
	gen popularity_errorm1=abs(Incvote-predictm1) 
	gen popularity_errorm2=abs(Incvote-predictm2) 
	gen popularity_errorm3=abs(Incvote-predictm3) 
	gen popularity_errorm4=abs(Incvote-predictm4) 
	
	eststo m5: reg popularity_errorm1 time_01 
	eststo m6: reg popularity_errorm2 time_01 i.country , cluster(country)
	eststo m7: reg popularity_errorm3 time_01 i.country , cluster(country)
	eststo m8: reg popularity_errorm4 time_01 i.country , cluster(country)
	
	* table 2
	esttab m5 m6 m7 m8 using appE_table2.tex, b(2) se(2) r2 wide nogap replace






