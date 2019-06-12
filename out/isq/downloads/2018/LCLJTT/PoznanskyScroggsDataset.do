******************************************************************************
*                                                                            *
* Michael Poznansky and Matt K. Scroggs                                      *
* "Ballots and Blackmail: Coercive Bargaining and the Democratic Peace"      *
* International Studies Quarterly                                            *
*                                                                            *
******************************************************************************


* Purpose
* This Stata do file walks through the process of creating the final version of our dataset, providing the websites we found our data.
*
* https://dataverse.harvard.edu/dataverse/mkscroggs
*
* Version 1.0
* Last updated: January 15, 2016

clear
set more off

use EUGeneUniverse.dta
*We start with data generated using the EUGene program, including the variables listed below.
keep ccode1 ccode2 year flow1 flow2 imports2 imports2 ///
	exports1 exports2 dependa dependb
drop if ccode1>ccode2
rename ccode1 ccode
sort ccode year
merge m:1 ccode year using MaddisonGDP.Revise.dta
*This data comes from Angus Maddison's annual GDP figures, for which we have included a Stata file.
rename GDP GDP1
drop _merge
rename ccode ccode1
rename ccode2 ccode
sort ccode year
merge m:1 ccode year using MaddisonGDP.Revise.dta
rename GDP GDP2
drop _merge
rename ccode ccode2

drop if missing(ccode1)
drop if missing(ccode2)

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using p4v2011_clean.dta
*This data comes from Polity IV, only including the polity2 variable. The data can be download here: http://www.systemicpeace.org/inscrdata.html
rename polity2 polity_1
drop _merge
rename ccode ccode1
rename ccode2 ccode
sort ccode year
merge m:1 ccode year using p4v2011_clean.dta
rename polity2 polity_2
gen polyprod = ((polity_1+10)/2)*((polity_2+10)/2) if (polity_1>-11) & (polity_2>-11)
gen polity_low=.
replace polity_low=polity_1 if polity_1<polity_2
replace polity_low=polity_2 if polity_2<polity_1
replace polity_low=polity_1 if polity_1==polity_2
replace polity_low=. if missing(polity_1)
replace polity_low=. if missing(polity_2)
gen polity_both=.
replace polity_both=1 if(polity_1>6)&(polity_2>6)
replace polity_both=0 if(polity_1<7)&(polity_2<7)
replace polity_both=0 if(polity_1<7)&(polity_2>6)
replace polity_both=0 if(polity_1>6)&(polity_2<7)
replace polity_both=. if missing(polity_1)
replace polity_both=. if missing(polity_2)
gen polity_10=.
replace polity_10=1 if(polity_1==10)&(polity_2==10)
replace polity_10=0 if(polity_1<10)&(polity_2==10)
replace polity_10=0 if(polity_1==10)&(polity_2<10)
replace polity_10=0 if(polity_1<10)&(polity_2<10)
drop _merge
rename ccode ccode2

sort ccode1 ccode2 year
merge m:1 ccode1 ccode2 year using alliance_clean.dta
*This is alliance data from Correlates of War. http://www.correlatesofwar.org/data-sets/formal-alliances
drop _merge
replace alliance1 = 0 if missing(alliance1)
replace alliance2 = 0 if missing(alliance2)

drop if missing(ccode1)
drop if missing(ccode2)

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using NMC_v4_0_clean.dta
*This is National Material Capabilities data from Correlates of War, only including the CINC scores for each country year. http://www.correlatesofwar.org/data-sets/national-material-capabilities
rename ccode ccode1
rename ccode2 ccode
rename cinc cinc1
drop _merge
sort ccode year
merge m:1 ccode year using NMC_v4_0_clean.dta
rename ccode ccode2
rename cinc cinc2
gen cincratio1 = cinc1/cinc2
gen cincratio2 = cinc2/cinc1
replace cincratio1=. if(cinc1==-9)|(cinc2==-9)
replace cincratio2=. if(cinc1==-9)|(cinc2==-9)
gen cincratio =.
replace cincratio = max(cincratio1, cincratio2)
drop _merge

sort ccode1 ccode2 year
merge m:1 ccode1 ccode2 year using affinity_01242010_clean.dta
*This is data on UN affinity scores from Erik Gartzke. http://pages.ucsd.edu/~egartzke/datasets.htm
rename s2un4608i UN_affinity1
replace UN_affinity1 = 0 if missing(UN_affinity1)
rename s3un4608i UN_affinity2
replace UN_affinity2 = 0 if missing(UN_affinity2)
drop _merge

drop if missing(ccode1)
drop if missing(ccode2)

sort ccode1 ccode2 year
merge m:1 ccode1 ccode2 year using polrev_clean.dta
*This includes a list of all politically relevant dyads, also generated from EUGene.
drop _merge
replace polrev = 0 if missing(polrev)

drop if missing(ccode1)
drop if missing(ccode2)

sort ccode1 ccode2
merge m:1 ccode1 ccode2 using contdir_clean.dta
*This is a dataset identifying the type of contiguity for a given dyad, from Correlates of War. http://www.correlatesofwar.org/data-sets/direct-contiguity We then simplify the contiguity variable so that the states either share a border (conttype1) or are within 150 miles by water (conttype2).
drop _merge
replace conttype=0 if missing(conttype)
gen conttype1 = conttype
replace conttype1 = 0 if conttype>1
gen conttype2 = conttype
replace conttype2 = 0 if conttype>4
replace conttype2 = 1 if conttype>1
sort ccode1 ccode2 year

drop if missing(ccode1)
drop if missing(ccode2)

rename ccode1 ccode
sort ccode year
merge m:1 ccode year using national_trade_3.0.dta
*This is national trade data from Correlates of War. http://www.correlatesofwar.org/data-sets/bilateral-trade
rename tsal tsala
rename ccode ccode1
rename ccode2 ccode
drop _merge
sort ccode year
merge m:1 ccode year using national_trade_3.0.dta
rename ccode ccode2
rename tsal tsalb
drop _merge

drop if missing(ccode1)
drop if missing(ccode2)

rename ccode1 ccode
sort ccode year
*We incorporate the Contract Intensive Economies data from Mousseau here. The data is available from his website: http://politicalscience.cos.ucf.edu/people/mousseau-michael/
merge m:1 ccode year using CINE_clean.dta
rename CIE CIE_ccode1
drop _merge

rename ccode ccode1
rename ccode2 ccode
sort ccode year
merge m:1 ccode year using CINE_clean.dta
rename CIE CIE_ccode2
drop _merge
rename ccode ccode2
gen lowCIE = min(CIE_ccode1, CIE_ccode2)

drop if missing(ccode1)
drop if missing(ccode2)

sort ccode1 ccode2 year
*This UN ideal point data acts as a substitute for affinity scores. The data can be found here: https://dataverse.harvard.edu/dataset.xhtml?persistentId=hdl:1902.1/12379
merge m:1 ccode1 ccode2 year using UN_Ideal.dta
drop _merge

rename year lstyear
gen year = lstyear+1
*We lag all of our independent variables one year by making this change, so that when the MCT data below is merged, it is attached to the lagged IVs.

sort ccode1 ccode2 year
*Finally, this is the MCT data from Sechser, cleaned to only identify whether an MCT occurred in a given dyad-year: http://faculty.virginia.edu/tsechser/mct_dataset_v09.csv
merge m:1 ccode1 ccode2 year using mct_dataset_v09_clean.dta
drop _merge
replace mct = 0 if missing(mct)
rename mct mct1
rename ccode1 ccode
rename ccode2 ccode1
rename ccode ccode2
sort ccode1 ccode2 year
merge m:1 ccode1 ccode2 year using mct_dataset_v09_clean.dta
drop _merge
rename ccode2 ccode
rename ccode1 ccode2
rename ccode ccode1
replace mct = 0 if missing(mct)
rename mct mct2
gen mct = mct1 + mct2
drop mct1 mct2

drop if missing(ccode1)
drop if missing(ccode2)

gen time = 0
replace time = 0 if (ccode1==ccode1[_n-1]) & (ccode2==ccode2[_n-1]) & (year==year[_n-1]+1) & (mct[_n-1]==1)
replace time = time[_n-1]+1 if (ccode1==ccode1[_n-1]) & (ccode2==ccode2[_n-1]) & (year==year[_n-1]+1) & (mct[_n-1]==0)
gen time_sq = time^2
gen time_cu = time^3

gen flowsum = flow1 + flow2 if (flow1>-1) & (flow2>-1)
gen BarbieriMaddisonDep1 = flowsum/GDP1
gen BarbieriMaddisonDep2 = flowsum/GDP2

gen lowdpnd = min(BarbieriMaddisonDep1, BarbieriMaddisonDep2)

egen dyad_id = group(ccode1 ccode2)

drop if missing(ccode1)
drop if missing(ccode2)
drop if missing(mct)
drop if year>2001
drop if year<1949
drop if ccode1>ccode2
replace mct=1 if mct>1

sort ccode1 ccode2 year

order ccode1 ccode2 lstyear year mct lowdpnd lowCIE polyprod cincratio alliance1 alliance2 UN_affinity1 UN_affinity2 absidealdiff conttype1 conttype2 time time_sq time_cu polrev, first

saveold PoznanskyScroggsISQ.dta, replace version(13)
