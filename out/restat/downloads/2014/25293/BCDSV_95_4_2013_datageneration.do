clear mata
clear matrix
clear
capture log close
program drop _all
macro drop _all
version 10.0
set mem 500m
set mat 2000
set more off
*ssc install egenmore (if not yet intalled)

*here set your directory
cd "D:\BCDVS_95_4_2013\codes"
log using "BCDVS_95_4_2013_datageneration.log", replace
use "BCDVS_source_data.dta", clear


*****************************************************************************************************************
******  In this file we describe the data sources and how we constructed the main variables of interests   ******
******  For further details on the construction of the database please contact:                            ******
******  Dr. LORENZO CIARI (CiariL@ebrd.com)                                                                ******
*****************************************************************************************************************

/****************************************************************************************************************

The starting point for the creation of the main variables used in 
our regressions is the Stata datafile "BCDVS_source_data.dta"

This file was generated by merging different data sources. Most of the work
to put these different sources together has been done in Excell. We therefore only
report the cleaned raw data. The references to the papers cited in this file 
can be found in the online Appendix of the paper.

		**************************************************************************************
		**************************************************************************************
		** Please notice that all databases used to construct our raw database have been    **
		** downloaded during 2008. It might be that some of these databases (for instance   **
		** the KLEMS database) have been since then updated. Hence, it might be that        ** 
		** some of the values for some of the variables do not completely correspond to     **
		** the values reported in our source database.                                      **
		**************************************************************************************
		**************************************************************************************

In the following, we report the various data sources and explain which 
specific variables we used


1. The EU-KLEMS and the Groningen Growth and Development Centre databeses

TFP-related measures. All measures needed to generate TFP variables in 
	our database are taken from the EU-KLEMS database. The exact construction
	of some of this variables is explained below. The EU-KLEMS database covers 
	all the countries involved in our study except for Canada. 
	To measure TFP variables for Canada, we used data from the Groningen 
	Growth and Development Centre (GGDC). The GGDC methodology is totally 
	analogous to the one adopted by the EU-KLEMS consortium, of which the 
	GGDC is a member. The correlation between the EU-KLEMS TFP and the GGDC 
	TFP is high (0.7) and strongly significant. 

Human Capital. We measure human capital as the share of high-skilled 
	labour employed in each country-industry in a given year. We took data 
	on human capital from the KLEMS database, which holds information on 
	the level of educational attainment of workers by industry for all 
	the EU member countries, the US and Japan from 1970 to 2004. Unfortunately, 
	data on human capital are not available for Canada.


2. OECD Analytical Business Enterprise Research and Development (ANBERD) database

R&D. The variable we use in our regressions is the ratio
	between R&D expenditure and the industry-level value added, both in
	nominal values. We gathered detailed data on the level of
	expenditure in R&D in different industries from the OECD Analytical
	Business Enterprise Research and Development (ANBERD) database,
	which covers 19 OECD countries, from 1987 to 2004. We took data on
	value added from the EU-KLEMS database. Unfortunately, data on R&D
	for the 'Agriculture, forestry and fishing' sector and the 'Mining
	and quarrying' sectors for all countries involved in the study, as
	well as data for Hungary, are not available in ANBERD. We therfore 
	integrated with OECD data for ISIC 1,2. The formula to construct this 
	variable is: 
	
	gen rddklems= rd / valurealklemsppp
	
	where rd is R&D spending, source ANBERD, in constant prices constant gdp, 
	using GDP deflator and GDP PPP source OECD


3. OECD STAN database

Trade openness. We measure the degree of openness to trade
	by the ratio of industry import over value added in each specific
	industry. The data is collected from the OECD STAN database, which contains
	data on total exports and imports for 19 OECD countries, plus the
	EU, from 1987 to 2004, disaggregated by industry.

4. OECD PMR database

Product Market Regulation. We measure the tightness of
	product market regulation by the aggregate PMR index, taken from the
	OECD PMR database. The aggregate PMR index covers formal regulations
	in the following areas: state control of business enterprizes, legal
	and administrative barriers to entrepreneurship, and barriers to
	international trade and investment. The tightness of regulation is
	measured at the national level on a scale between 0 and 6, where
	lower values indicate less tight regulation. Data on PMR are
	available for two years: 1998 and 2003.
	
	The original data exist only for 1998 and 2003. We made the following 
	imputation:
	- for the years before 1998, we use the 1998 data
	- for the yaers between 1998 and 2003, we use the average between the 1998 and 2003 vales
	- for the years after 2003, we use the 2003 data 	
	
5. World Bank Worldwide Governance Indicators (WGI) database

	This database collects aggregate and individual
	indicators for six dimensions of governance: voice and
	accountability, political stability and absence of violence,
	government effectiveness, regulatory quality, rule of law, control
	of corruption. The data cover 212 countries and territories over the period 1996-2006
	and are based on the views of a large number of enterprisers,
	citizens, and experts. We use the index that measures the national
	rule of law, as the most appropriate indicator of a country's legal
	system. The index takes values from -2.5 to 2.5, with higher values
	indicating better governance outcomes.
 
6. Fraser Institute Database

	This Database, which is used to construct the 'Economic Freedom of the World' indexes. From
	this database, we use an aggregate index (index\_2) called 'legal
	system', which aggregates information on variables measuring
	judiciary independence, impartiality of the courts, protection of
	intellectual property, law and order, and legal enforcement of
	contracts. These indexes, just like the WGIs, are based on the perceptions
	of enterprisers, citizens and experts. The indexes take values
	between 0 and 10, with higher values indicating better governance
	outcomes.

7. The Doing Business database of the World Bank

	This database collects data representing 'objective measures' of the overall quality of the
	regulatory and institutional environment in 181 countries. The data
	we use in our empirical model relate to the time and cost of
	enforcing debt contracts through the national courts
	system. The time of enforcing debt contracts represents the
	estimated duration, in calendar days, between the moment of issuance
	of judgment and the moment the landlord repossesses the property
	(for the eviction case) or the creditor obtains payment (for the
	check collection case). The cost of enforcing contracts represents
	the estimated cost as a percentage of the debt involved in the
	contract. For a full description, see Djankov et. al
	(2003b). Both variables have been measured within
	the Doing Business Project from 2004 on. In our specifications, we
	use the end of sample (2005) values, and assume it represents the
	quality of contracts enforced for the entire sample period.

8. The legal origin database from La Porta et al. (1997).

9. An enhanced version of the Political Manifesto Database

	The political variables taht we use are derived from the dataset developed by Cusack and
	Fuchs (2002) which uses two main sources: the first is
	a database on political parties' programmatic position developed in
	the Manifesto dataset by Klingemann et al. (2006),
	while the second is the database developed by Woldendorp, Keman, and
	Budge (2000) on government compositions for 48
	countries from 1948 onwards. For each country and year in our
	sample, we create measures of a government location along the
	Manifesto�s political dimensions by taking a weighted average of the
	programmatic positions of each of the parties belonging to
	government coalition. As weights, we used the number of each party's
	votes. We used the following programmatic positions:

Market regulation (per403). This variable measures
	favorable mentions in the parties' programs of the need for
	regulations to make private enterprizes work better, actions against
	monopoly and trusts, in defence of consumer, and encouraging
	economic competition.

Economic planning (per404). This variable measures
	favorable mentions in the parties' programs of long-standing
	economic planning of a consultative or indicative nature.

Welfare state limitations planning (per505). This variable
	measures negative mentions in the parties' programs of the need to
	introduce, maintain or expand any social service or social security scheme.

European Community (per108): This variable measures
	favorable mentions in the parties' programs of the European
	Community in general, and on the desirability of expanding its competency.

**************************************************************************************/


*generate country-industry dummies
egen identif=group(iso_code isicrev3)
tab identif, gen (dummy2_)
label var identif "Identifier: industry-country"

* generate year dummies
tab year, gen (y_)

* generate industry dummies
tab isicrev3, gen (ind_)

* generate country dummies
tab iso_code, gen (cn_)


* value added variables
gen valurealklems=valureal
gen valur=valuk/100*valu95 if iso_code=="Can"

replace valurealklems=valur if iso_code=="Can"
label var valurealklems "Value Added Real"

gen valurealklemsppp=valurealklems/gdp_ppp
label var valurealklemsppp "Value Added Real, constant ppp"

gen va1=va
replace va1=valu_nominal if iso_code=="Can" 
label var va1 "Value added nominal"

* generate industry trends
gen year2=year^2
gen yhat=.
forvalues n=1/264{
quietly reg valurealklemsppp year year2 if identif==`n'
quietly predict a
quietly replace yhat=a if identif==`n'
drop a
}

gen ind_trend=(valurealklems - yhat)/10000000
label var ind_trend "Industry trend"

*labour share
gen lab1=lab
label var lab1 "Labour compensation"

gen lab1can=labourshare*valu_nominal
replace lab1=lab1can if iso_code=="Can"
label var lab1can "Labour compensation Canada"

*markups
gen pcmpoolklems=va1/(lab1 + (govbond-inflat+0.07)*icaprklems)
label var pcmpoolklems "Price Cost Margin"

		******************************************************************************************************************
		******************************************************************************************************************
		** NOTE:																										**
		** Icaprklems has been created according to the following formula (an exact reconstruction within this do file  **
		** is not possible given the update in the Klems database and the fact that we use of data from 1990. The com-	**
		** mands to generate this variable are the following:															**
		** 																												**
		** gen gfcfrklems=iq_gfcf 																						**
		** replace gfcfrklems=gfcfr if iq_gfcf==.																		**
		** so country isic year																							**
		** gen rrklems=1 if gfcfrklems>0.1&gfcfrklems<100000000															**
		** egen rryearklems = min(rrklems*year), by(country isic)														**
		** so country isic																								**
		** gen icaprklems = gfcfrklems/(kdepr+0.03) if year==rryearklems												**
		** qui by country isic: replace icaprklems = icaprklems[_n-1]*(1-kdepr) + gfcfrklems if year>rryearklems 		**
		**																												**
		** where																										**
		** iq_gfcf = Real gross fixed capital formation, bse year 2000 (Source Klems)									**
		** gfcfr= Real gross fixed capital formation (PPP) for non Klems countries, using STAN (variable GFCF - gross 	**
		** fixed capital formation at current prices / GDP deflator base year 2000 (Source OECD - MEI)					**
		** 																												**
		******************************************************************************************************************
		******************************************************************************************************************


*TFP growth corrrected for markups
xtset identif year
gen tfpcorrectedklems= (va_qi-l.va_qi)/l.va_qi - (pcmpoolklems*cap/(cap+lab)+l.pcmpoolklems*l.cap/(l.cap+l.lab))/2*((cap_qi- l.cap_qi)/l.cap_qi)-(pcmpoolklems*lab/(lab+cap)+l.pcmpoolklems*l.lab/(l.lab+l.cap))/2*((lab_qi-l.lab_qi)/l.lab_qi)
gen tfpcorrectedklemscan=output- (pcmpoolklems*labourshare+l.pcmpoolklems*l.labourshare)/2*labour- (pcmpoolklems*ictshare+l.pcmpoolklems*l.ictshare)/2*ictcapital-(pcmpoolklems*(1-labourshare-ictshare)+ l.pcmpoolklems*(1-l.labourshare-l.ictshare))/2* nonictcapital 
gen tfpcorrectedoverklems=tfpcorrectedklems
replace tfpcorrectedoverklems=tfpcorrectedklemscan/100 if iso_code=="Can"
label var tfpcorrectedoverklems "TFP growth"

 
* Tecnology Gap & TFP growth of the leader
bysort isic year: egen avervalurklems =gmean(valurealklemsppp)

gen labourshareklems=lab/va if iso_code!="Can"
replace labourshareklems=labourshare if iso_code=="Can"

gen capitalshareklems=cap/va if iso_code!="Can"
replace capitalshareklems=(1-labourshare) if iso_code=="Can"

gen labourshareklemscorr=labourshareklems*pcmpoolklems 
bysort isic year: egen averlabourshareklemscorr=gmean(labourshareklemscorr)

gen capitalshareklemscorr=capitalshareklems*pcmpoolklems
bysort isic year: egen avercapitalshareklemscorr=gmean(capitalshareklemscorr)

gen capstockklemsppp =icaprklems/gdp_ppp
bysort isic year: egen avercapstockklemsppp =gmean(capstockklemsppp)

gen labourgrif=((H_EMP*HHS)^labhs)*((H_EMP*HMS)^labms)*((H_EMP*HLS)^labls)
replace labourgrif=H_empcan if iso_code=="Can"
bysort isic year: egen averlabour=gmean(labourgrif)

gen tecratioklems =ln(valurealklemsppp /avervalurklems )-(capitalshareklemscorr+avercapitalshareklemscorr)/2*ln(capstockklemsppp /avercapstockklemsppp ) -(labourshareklemscorr+averlabourshareklemscorr)/2*ln(labourgrif/averlabour)
bysort year isic: egen tecnoleaderklems =max(tecratioklems)

gen tecnogapklems =tecnoleaderklems -tecratioklems 
label var tecnogapklems "Techno Gap"

gen zz=tfpcorrectedoverklems if tecnogapklems ==0
bysort isic year: egen tfpleadershipklems =mean(zz)
drop zz
label var tfpleadershipklems "TFP leader"


* Labourproductivity / labour productivity gap 
gen labourproductivityklems =valurealklemsppp /labourgrif
xtset identif year
by identif: gen LPgrowth= (labourproductivityklems - l.labourproductivityklems)/ l.labourproductivityklems
label var LPgrowth "LP Growth"

bysort year isic: egen leaderproductivityklems =max(labourproductivityklems)
bysort year isic: gen productivitygapklems =leaderproductivityklems /labourproductivityklems 

gen zz=labourproductivityklems if productivitygapklems ==1
bysort isic year: egen labourproductivityleaderklems=mean(zz)
replace labourproductivityleaderklems=labourproductivityleaderklems/10000
label var labourproductivityleaderklems "LP leader"

drop zz
gen tecnogapklemsLP=productivitygapklems 
label var tecnogapklemsLP "Techno Gap - LP"

*tradelib

		******************************************************************************************************************
		******************************************************************************************************************
		** NOTE:																										**
		** 																												**
		** For tadelib we made two imputations																			**
		** 1. impute the 2003 value of trade liberalization in 2004 to increase sample size								**
		** 2. set imports = 0 for the sectors 17-22 																	**
		******************************************************************************************************************
		******************************************************************************************************************

gen tradelib= (impo)/ valurealklemsppp
label var tradelib "Import penetration"
xtset identif year
gen xx=l.tradelib
replace tradelib = xx if year==2004
drop xx
 
replace compindex=. if enf==.
replace antitrust=. if enf==.

*The CPI EU variable is constructed as follow
*gen CPI_EU=(2/3)*instoveral+(1/3)*enf
*replace resourcesindex=. if resourcesindex==-3

so identif year

save BCDVS_95_4_2013_estimation_data.dta, replace

log close
