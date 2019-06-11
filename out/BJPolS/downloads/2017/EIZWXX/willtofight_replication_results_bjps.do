clear
set more off

use willtofight_dataset 




********************************************************************************\
*TABLE A.1 - COUNTRIES IN THE DATASET
********************************************************************************\
*preserve
*collapse willtofight, by(country year)
*order country year willtofight
*rename willtofight willtofight_mean
*sort country year
*outsheet using coverage_countryyr.csv, comma replace
*collapse willtofight, by(country)
*outsheet using coverage_country.csv, comma replace
*clear
*restore


********************************************************************************\
*TABLE A.2 -- SUMMARY STATISTICS
********************************************************************************\

egen gini_net_mean=rowmean(_1_gini_net-_100_gini_net)
replace pop=pop/1000000
replace gdp=gdp/1000000
foreach var in willtofight quintile female age i.maritalstatus secular languagemin ///
				gini_net_mean pop gdp democracy conflict5 conscription elf61 {
			sum `var'
		}

pwcorr education income, star(.05) sig //Correlation between education and income

replace pop=pop*1000000
replace gdp=gdp*1000000
replace gdp=ln(gdp+1)
replace pop=ln(pop+1)


********************************************************************************\
*TABLE 1 - MAIN RESULTS (MALES ONLY) and TABLES A.3 (FULL SAMPLE)
********************************************************************************\

* COLUMN 1: No interaction, no controls, only country and survey fixed effects
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net ib5.quintile `fixedeffects' if female==0
*Predicted probability of willtofight==1
*mimrgns quintile, predict(pr)  post
*test _b[1.quintile]= _b[5.quintile]
*mimrgns, predict(pr)  at((min) gini_net)  at((max) gini_net) post
*test _b[1._at]=_b[2._at]

* TABLE A.3 (1)
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net ib5.quintile `fixedeffects' 


* COLUMN 2: No interaction + individuals and country time varying controls and fe
local countrycontrols gdp pop democracy conflict5 conscription    
local individualcontrols female c.age##c.age i.maritalstatus   secular 
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net ib5.quintile  `individualcontrols' `countrycontrols' `fixedeffects' if female==0
*Predicted probability of willtofight==1
*mimrgns quintile, predict(pr) post
*test _b[1.quintile]= _b[5.quintile]
*mimrgns, predict(pr)  at((min) gini_net)  at((max) gini_net) post
*test _b[1._at]=_b[2._at]

* TABLE A.3 (3)
local countrycontrols gdp pop democracy conflict5 conscription    
local individualcontrols female c.age##c.age i.maritalstatus   secular 
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net ib5.quintile  `individualcontrols' `countrycontrols' `fixedeffects' 


* COLUMN 3: Interaction, no controls, only country and wave fe
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile `fixedeffects' if female==1
*Predicted probability of willtofight==1
*mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
*test _b[2._at#1.quintile]=_b[2._at#5.quintile]
*test _b[1._at#1.quintile]=_b[1._at#5.quintile]
*test _b[2._at#1.quintile]=_b[1._at#1.quintile]
*test _b[2._at#5.quintile]=_b[1._at#5.quintile]

* TABLE A.3 (5)
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile `fixedeffects' 


* COLUMN 4: Interaction + individuals and country time varying controls and fe
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile  `individualcontrols' `countrycontrols' `fixedeffects' if female==0
*Predicted probability of willtofight==1
*mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
*test _b[2._at#1.quintile]=_b[2._at#5.quintile]
*test _b[1._at#1.quintile]=_b[1._at#5.quintile]
*test _b[2._at#1.quintile]=_b[1._at#1.quintile]
*test _b[2._at#5.quintile]=_b[1._at#5.quintile]

* TABLE A.3 (7)
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile  `individualcontrols' `countrycontrols' `fixedeffects'


* COLUMN 5: Interaction + individuals and country time varying controls and fe,
*standard errors adjusted for subnational clustering
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile  `individualcontrols' `countrycontrols' `fixedeffects' if female==0, cluster(regioncountry)

********************************************************************************\
*TABLES 2 & A.4 - PREDICTED PROBABILITY WILLTOFIGHT==1 
********************************************************************************\
*Predicted probability in Table 2 in the paper
mimrgns quintile, predict(pr) at((min) gini_net) at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

* TABLE A.3 (9)
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile  `individualcontrols' `countrycontrols' `fixedeffects', cluster(regioncountry)
* TABLE A.4 (PREDICTED PROBABILITY BASED ON TABLE A.3 COLUMN 9)
mimrgns quintile, predict(pr) at((min) gini_net) at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]



********************************************************************************\
*TABLE 3 - ROBUSTNESS CHECKS PREDICTED PROBABILITIES AND TABLES A.5-A.7  
********************************************************************************\

* COLUMN 1: LIS GINI instead of SWIID gini_net
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
probit willtofight c.c.gini##ib5.quintile  `individualcontrols' `countrycontrols' `fixedeffects' if female==0, cluster(regioncountry)

margins quintile,  at((min) gini) at((max) gini)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

*Full sample
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
probit willtofight c.c.gini##ib5.quintile  `individualcontrols' `countrycontrols' `fixedeffects', cluster(regioncountry)

margins quintile,  at((min) gini) at((max) gini)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]


* COLUMN 2: RELATIVE REDISTRIBUTION INSTEAD OF NET GINI
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.rel_red##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if female==0, cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) rel_red) at((max) rel_red) post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

*Full sample
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.rel_red##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects', cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) rel_red) at((max) rel_red) post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]


* COLUMN 3 -- DROPPING OUTLIERS
*Generating outliers
gen willtofight_missing=0
replace willtofight_missing=1 if willtofight==.
bys ccode: egen willtofight_missrate=mean(willtofight_missing)
gen outlier_miss=0
sum willtofight_missrate, de
replace outlier_miss=1 if willtofight_missrate>r(p90) & willtofight_missrate!=1
la var outlier_miss "1 if the share of missing answers to dv is >p90 worldwide"
bys ccode: egen willtofight_rate=mean(willtofight)
gen outlier_dv=0
sum willtofight_rate, de
replace outlier_dv=1 if willtofight_rate>r(p90) & willtofight_rate!=. | willtofight_rate<r(p10) & willtofight_rate!=.
la var outlier_dv "1 if the share of 'yes' answers to dv is >p90 or <p10 worldwide"

local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if female==0 & outlier_miss==0 & outlier_dv==0, cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

*Full sample
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if outlier_miss==0 & outlier_dv==0, cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]


* COLUMN 4 -- DEMOCRACIES
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if female==0 & democracy>=0.7 & democracy!=., cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

*Full sample
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if democracy>=0.7 & democracy!=., cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]


* COLUMN 5 -- NON-DEMOCRACIES
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if female==0 & democracy<0.7 & democracy!=., cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

*Full sample
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if democracy<0.7 & democracy!=., cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

* COLUMN 6 -- YOUNG MALES IN DEMOCRACIES
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if female==0 & democracy>=0.7 & democracy!=.& age>=18 & age<=45, cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]


********************************************************************************\
*TABLE 4 - ALTERNATIVE EXPLANATIONS PREDICTED PROBABILITIES AND TABLE A.9 COEFFICIENTS 
********************************************************************************\

* COLUMN 1 -- PROUD OF NATIONALITY
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: reg proudnationality c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if female==0, cluster(regioncountry)

mimrgns quintile, at((min) gini_net)  at((max) gini_net) post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

* COLUMN 2 -- PROUD OF NATIONALITY -- LINGUISTIC MINORITY
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus secular
local fixedeffects i.wave i.ccode
mi estimate: reg proudnationality c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if female==0 & languagemin==1, cluster(regioncountry)

mimrgns quintile, at((min) gini_net)  at((max) gini_net) post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

*COLUMN 3 -- WILLINGNESS TO FIGHT -- LINGUISTIC MINORITY
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if female==0 & languagemin==1, cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net) post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

* COLUMN 4 -- WAR NECESSARY (only in wave 6)
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
*local fixedeffects i.ccode
mi estimate: probit warnecessary c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if female==0 & wave==6, cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

* COLUMN 5 -- OKAY TO CHEAT ON TAXES
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: reg cheat c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if female==0, cluster(regioncountry)

mimrgns quintile, at((min) gini_net)  at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

* COLUMN 6 -- WAR LIKELY (wave 6 only)
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
*local fixedeffects i.ccode
mi estimate: reg warlikely c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if female==0 & wave==6, cluster(regioncountry)
mimrgns quintile, at((min) gini_net)  at((max) gini_net) post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]



********************************************************************************\
*TABLE A.8 - ADDITIONAL CONTROLS
********************************************************************************\

*COLUMN 1: CONTROLLING FOR COLLEGE DEGREE AND LINGUISTIC MINORITY
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus secular 
local additionalcontrols1 college languagemin
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile `additionalcontrols1' `individualcontrols' `countrycontrols' `fixedeffects' if female==0, cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

*COLUMN 2: ATTITUDINAL CONTROLS
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus secular 
local additionalcontrols2 confidenceingovernment confidenceinarmy proudnationality
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile `additionalcontrols2' `individualcontrols' `countrycontrols' `fixedeffects' if female==0, cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

*COLUMN 3: NO COUNTRY FE + CONTROLLING FOR ELF61
local countrycontrols gdp pop democracy conflict5 conscription elf61
local individualcontrols female c.age##c.age i.maritalstatus secular 
local fixedeffects i.wave
mi estimate: probit willtofight c.gini_net##ib5.quintile  `individualcontrols' `countrycontrols' `fixedeffects' if female==0, cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net)  at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

********************************************************************************\
*DIFFERENCE IN DIFFERENCE CALCULATION IN FOOTNOTE 15 IN THE PAPER
********************************************************************************\

*IS THE DROP IN WILLINGNESS TO FIGHT AMONG THE RICH IS BIGGER THAN THE DROP 
*AMONG THE POOR WHEN INEQUALITY GOES UP

local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus secular
local fixedeffects i.wave i.ccode

mi estimate: probit willtofight c.gini_net##ib5.quintile `individualcontrols' `countrycontrols' `fixedeffects' if female==0, cluster(regioncountry)

mimrgns quintile, predict(pr) at((min) gini_net) at((max) gini_net) post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

*Diff-in-diff -- change among the poor vs change among the rich
test _b[1._at#1.quintile]-_b[2._at#1.quintile]=_b[1._at#5.quintile]-_b[2._at#5.quintile]
*0.152=0.261

********************************************************************************
*COUNTRY-CLUSTERED SES (FEMALES ONLY)
********************************************************************************

* COLUMN 5: Interaction + individuals and country time varying controls and fe,
*standard errors adjusted for subnational clustering
local countrycontrols gdp pop democracy conflict5 conscription 
local individualcontrols female c.age##c.age i.maritalstatus   secular
local fixedeffects i.wave i.ccode
mi estimate: probit willtofight c.gini_net##ib5.quintile  `individualcontrols' `countrycontrols' `fixedeffects' if female==0, cluster(ccode)

********************************************************************************\
*PREDICTED PROBABILITY WILLTOFIGHT==1 
********************************************************************************\
*Predicted probability in Table 2 in the paper
mimrgns quintile, predict(pr) at((min) gini_net) at((max) gini_net)  post
test _b[2._at#1.quintile]=_b[2._at#5.quintile]
test _b[1._at#1.quintile]=_b[1._at#5.quintile]
test _b[2._at#1.quintile]=_b[1._at#1.quintile]
test _b[2._at#5.quintile]=_b[1._at#5.quintile]

log close
