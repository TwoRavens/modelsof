cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Macro
*Rename directory according to own folder name.
clear
capture log close
log using MacroConditions.log, text replace
set mem 3g

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

This file creates macroeconomic conditions data based upon the %
 of immigrants in each US sector in 2000, and US sectoral output
 in each successive year.

Data Sources: Individual - 5% Census in 2000; ACS in 2001-08 (Both from IPUMS)
              Macro -      Bureau of Economic Analysis; OECD

Step A: Input and Clean IPUMS data.
Step B: Create BEA industry codes.
Step C: Input BEA Real GDP by industry (millions of chained 2005 dollars)
        Source: http://www.bea.gov/regional/gsp/action.cfm
        Include only aggregated industries (non-government)
        Then Merge with IPUMS data.
Step D: Give IPUMS birthplaces SAT country codes
Step E: Create country-specific data on US macro conditions 
        expected by immigrants (based upon IPUMS and BEA data)
Step F: Label frgnadd, and
        Describe labels of data in Steps A-E no longer used.
**************************************************************************/









/*****************************************************************
Step A: Input and clean IPUMS data
*****************************************************************/
set more off

clear
quietly infix              ///
  int     year      1-4    ///
  byte    gq        5-5    ///
  float   perwt     10-15  ///
  int     age       16-18  ///
  long    bpld      19-23  ///
  byte    citizen   24-24  ///
  byte    school    25-25  ///
  int     educd     26-28  ///
  byte    empstat   29-29  ///
  int     ind       30-33  ///
  str     indnaics  34-41  ///
  byte    wkswork2  42-42  ///
  byte    uhrswork  43-44  ///
  long    incwage   45-50  ///
  using `"usa_00061.dat"'

replace perwt    = perwt    / 100

format perwt    %6.2f

label var year     `"Census year"'
label var gq       `"Group quarters status"'
label var perwt    `"Person weight"'
label var age      `"Age"'
label var bpld     `"Birthplace [detailed version]"'
label var citizen  `"Citizenship status"'
label var school   `"School attendance"'
label var educd    `"Educational attainment [detailed version]"'
label var empstat  `"Employment status [general version]"'
label var ind      `"Industry"'
label var indnaics `"Industry, NAICS classification"'
label var wkswork2 `"Weeks worked last year, intervalled"'
label var uhrswork `"Usual hours worked per week"'
label var incwage  `"Wage and salary income"'



*Year
keep if year>=2000 & year<=2008


*GQ: keep if non group quarter
keep if gq==1|gq==2|gq==5
drop gq


*Perwt: No Change


*Age: Keep if age 18-65
keep if age>=18 & age<=65
drop age


*BPLD: Several Edits
*classify all US together
replace bpld=09900 if bpld<=09900
*classify all UK together
replace bpld=41300 if (bpld>=41000&bpld<=41300)|bpld==41410
*classify Korea together
replace bpld=50200 if bpld>=50200 & bpld<=50220
*classify Serbia and Montenegro as Yugoslavia
replace bpld=45700 if bpld>=45720 & bpld<=45730


*Citizen: Classify those born abroad to US parents as born in USA
replace bpld=09900 if citizen==1
drop citizen


*School: Drop those attending School
drop if school==2
drop school


*educd: Classify BA vs no BA
gen bachelors=.
replace bachelors=0 if educ>=002 & educ<=083
replace bachelors=1 if educ>=101 & educ<=116
tab educ if bachelors==.
drop educ


*ind and indnaics: Divide Ind codes by 10 for 2003+,
*Aggregate to comparable BEA Indutries Below.
replace ind=ind/10 if year>=2003
drop if ind==0|ind==.
drop if ind>=967 & ind<=987


*empstat: redfine for employed vs unemployed
keep if empstat==1 | empstat==2
gen emp = 2-empstat
drop empstat


*wkswork2 & uhrswork: Classify FT employees
gen ft=.
replace ft=0 if emp==1
replace ft=1 if (wkswork2==5|wkswork2==6) & uhrswork>=34 & uhrswork!=.
drop wkswork2 uhrswork


*Incwage: Put in real 2005 terms
*       See www.bls.gov/cpi
replace incwage = incwage*1.13 if year==2000
replace incwage = incwage*1.10 if year==2001
replace incwage = incwage*1.09 if year==2002
replace incwage = incwage*1.06 if year==2003
replace incwage = incwage*1.03 if year==2004
replace incwage = incwage*1.00 if year==2005
replace incwage = incwage*0.97 if year==2006
replace incwage = incwage*0.94 if year==2007
replace incwage = incwage*0.91 if year==2008



collapse (sum) perwt, by(year bpld ind indnaics bachelors emp ft)
compress








/***************************************************************************
Step B: AGGREGATE TO BEA INDUSTRIES
***************************************************************************/
gen beaind=.
replace beaind=3 if ind>=17 & ind<=29
replace beaind=6 if ind>=37 & ind<=49
replace beaind=10 if ind>=57 & ind<=69
replace beaind=11 if ind==77
replace beaind=12 if ind>=107 & ind<=399
replace beaind=34 if ind>=407 & ind<=459
replace beaind=35 if ind>=467 & ind<=579
replace beaind=36 if ind>=607 & ind<=639
replace beaind=45 if ind>=647 & ind<=679
replace beaind=50 if ind>=687 & ind<=699
replace beaind=55 if ind>=707 & ind<=719

replace beaind=58 if ind>=727 & ind<=749
replace beaind=62 if ind==757
replace beaind=63 if ind>=758 & ind<=779

replace beaind=66 if ind>=786 & ind<=789
replace beaind=67 if ind>=797 & ind<=847
replace beaind=71 if ind>=856 & ind<=859
replace beaind=74 if ind>=866 & ind<=869
replace beaind=77 if ind>=877 & ind<=929

tab ind if beaind==.

*drop government employees
drop if ind>=937 & ind<=959

*Classify unemployed census industry
replace beaind=100 if ind==992


collapse (sum) perwt, by(year bpld beaind bachelors emp ft)
sort year beaind
save MacroConditions.dta, replace







/***************************************************************************
Step C: Input aggregated BEA Real GDP
***************************************************************************/
insheet using gdpbyind.csv, comma clear
# delimit;
keep if beaind==3|beaind==6|beaind==10|beaind==11|beaind==12|beaind==34|beaind==35|beaind==36
       |beaind==45|beaind==50|beaind==55|beaind==58|beaind==62|beaind==63|beaind==66|beaind==67
       |beaind==71|beaind==74|beaind==77;
# delimit cr
keep beaind indgdp2000-indgdp2008
reshape long indgdp, i(beaind) j(year)
sort year beaind

merge year beaind using MacroConditions.dta
tab _merge
sum if _merge==2
drop _merge
sort year beaind
save MacroConditions.dta, replace








/***************************************************************************
Step D: Give IPUMS Birthplace (BPL) codes SAT Country Codes
***************************************************************************/
gen frgnadd=1000
 
replace frgnadd=	1	 if bpld==	52000	   
replace frgnadd=	3	 if bpld==	43000	   
replace frgnadd=	15	 if bpld==	30005	   
replace frgnadd=	20	 if bpld==	70010	   
replace frgnadd=	25	 if bpld==	45000	   
replace frgnadd=	29	 if bpld==	46541	   
replace frgnadd=	35	 if bpld==	26043	   
replace frgnadd=	45	 if bpld==	52110	   
replace frgnadd=	50	 if bpld==	26044	   
replace frgnadd=	55	 if bpld==	42000	   
replace frgnadd=	56	 if bpld==	21010	   
replace frgnadd=	60	 if bpld==	16010	   
replace frgnadd=	65	 if bpld==	30010	   
replace frgnadd=	69	 if bpld==	45740	   
replace frgnadd=	75	 if bpld==	30015	   
replace frgnadd=	85	 if bpld==	45100	   
replace frgnadd=	94	 if bpld==	46510	   
replace frgnadd=	95	 if bpld==	60072	   
replace frgnadd=	100	 if bpld==	15000	   
replace frgnadd=	107	 if bpld==	71042	   
replace frgnadd=	115	 if bpld==	30020	   
replace frgnadd=	120	 if bpld==	30025	   
replace frgnadd=	130	 if bpld==	21020	   
replace frgnadd=	133	 if bpld==	45710	   
replace frgnadd=	135	 if bpld==	25000	   
replace frgnadd=	140	 if bpld==	53100	   
replace frgnadd=	142	 if bpld==	45213	   
replace frgnadd=	150	 if bpld==	40000	   
replace frgnadd=	155	 if bpld==	26010	   
replace frgnadd=	165	 if bpld==	30030	   
replace frgnadd=	170	 if bpld==	60012	   
replace frgnadd=	175	 if bpld==	21030	   
replace frgnadd=	182	 if bpld==	60065	   
replace frgnadd=	184	 if bpld==	46000	   
replace frgnadd=	185	 if bpld==	60044	   
replace frgnadd=	190	 if bpld==	71021	   
replace frgnadd=	195	 if bpld==	40100	   
replace frgnadd=	200	 if bpld==	42100	   
replace frgnadd=	208	 if bpld==	46542	   
replace frgnadd=	210	 if bpld==	45300	   
replace frgnadd=	215	 if bpld==	60023	   
replace frgnadd=	220	 if bpld==	43300	   
replace frgnadd=	230	 if bpld==	21040	   
replace frgnadd=	233	 if bpld==	60024	   
replace frgnadd=	235	 if bpld==	30040	   
replace frgnadd=	240	 if bpld==	26020	   
replace frgnadd=	245	 if bpld==	21050	   
replace frgnadd=	250	 if bpld==	50010	   
replace frgnadd=	251	 if bpld==	45400	   
replace frgnadd=	255	 if bpld==	40200	   
replace frgnadd=	260	 if bpld==	52100	   
replace frgnadd=	265	 if bpld==	51200	   
replace frgnadd=	270	 if bpld==	52200	   
replace frgnadd=	275	 if bpld==	41400	   
replace frgnadd=	280	 if bpld==	53400	   
replace frgnadd=	285	 if bpld==	43400	   
replace frgnadd=	295	 if bpld==	26030	   
replace frgnadd=	300	 if bpld==	50100	   
replace frgnadd=	305	 if bpld==	53500	   
replace frgnadd=	307	 if bpld==	51100	   
replace frgnadd=	308	 if bpld==	46543	   
replace frgnadd=	310	 if bpld==	60045	   
replace frgnadd=	315	 if bpld==	50200	   
replace frgnadd=	315	 if bpld==	50210	   
replace frgnadd=	315	 if bpld==	50220	   
replace frgnadd=	320	 if bpld==	53600	   
replace frgnadd=	328	 if bpld==	46100	   
replace frgnadd=	330	 if bpld==	53700	   
replace frgnadd=	335	 if bpld==	60027	   
replace frgnadd=	343	 if bpld==	60013	   
replace frgnadd=	344	 if bpld==	46200	   
replace frgnadd=	347	 if bpld==	50020	   
replace frgnadd=	348	 if bpld==	43330	   
replace frgnadd=	360	 if bpld==	51400	   
replace frgnadd=	375	 if bpld==	20000	   
replace frgnadd=	376	 if bpld==	46520	   
replace frgnadd=	380	 if bpld==	60014	   
replace frgnadd=	387	 if bpld==	52400	   
replace frgnadd=	390	 if bpld==	42500	   
replace frgnadd=	405	 if bpld==	70020	   
replace frgnadd=	420	 if bpld==	21060	   
replace frgnadd=	430	 if bpld==	60031	   
replace frgnadd=	435	 if bpld==	40400	   
replace frgnadd=	445	 if bpld==	52140	   
replace frgnadd=	450	 if bpld==	21070	   
replace frgnadd=	455	 if bpld==	30045	   
replace frgnadd=	457	 if bpld==	50000	   
replace frgnadd=	460	 if bpld==	30050	   
replace frgnadd=	465	 if bpld==	51500	   
replace frgnadd=	470	 if bpld==	45500	   
replace frgnadd=	475	 if bpld==	43600	   
replace frgnadd=	480	 if bpld==	60057	   
replace frgnadd=	483	 if bpld==	45600	   
replace frgnadd=	484	 if bpld==	46500	   
replace frgnadd=	488	 if bpld==	10010	   
replace frgnadd=	490	 if bpld==	54000	   
replace frgnadd=	497	 if bpld==	60032	   
replace frgnadd=	500	 if bpld==	60033	   
replace frgnadd=	503	 if bpld==	45212	   
replace frgnadd=	505	 if bpld==	51600	   
replace frgnadd=	510	 if bpld==	60094	   
replace frgnadd=	515	 if bpld==	43800	   
replace frgnadd=	520	 if bpld==	52150	   
replace frgnadd=	525	 if bpld==	60015	   
replace frgnadd=	535	 if bpld==	40500	   
replace frgnadd=	540	 if bpld==	42600	   
replace frgnadd=	545	 if bpld==	54100	   
replace frgnadd=	555	 if bpld==	50040	   
replace frgnadd=	560	 if bpld==	60054	   
replace frgnadd=	565	 if bpld==	51700	   
replace frgnadd=	575	 if bpld==	26060	   
replace frgnadd=	585	 if bpld==	54200	   
replace frgnadd=	588	 if bpld==	41000	   
replace frgnadd=	588	 if bpld==	41100	   
replace frgnadd=	588	 if bpld==	41200	   
replace frgnadd=	588	 if bpld==	41300	   
replace frgnadd=	588	 if bpld==	41410	   
replace frgnadd=	589	 if bpld==	46530	   
replace frgnadd=	590	 if bpld==	60055	   
replace frgnadd=	594	 if bpld==	46547	   
replace frgnadd=	595	 if bpld==	30060	   
replace frgnadd=	600	 if bpld==	30065	   
replace frgnadd=	605	 if bpld==	51800	   
replace frgnadd=	615	 if bpld==	26094	   
replace frgnadd=	623	 if bpld==	54400	   
replace frgnadd=	625	 if bpld==	45700	   
replace frgnadd=	625	 if bpld==	45730	 

replace frgnadd=1001 if bpld==09900
*Code 1000 is foreign, undefined
*Code 1001 is American born

tab bpld if frgnadd>=1000

collapse (sum) perwt, by(year frgnadd beaind bachelors emp ft indgdp)
sort year frgnadd beaind
save MacroConditions.dta, replace








/***************************************************************************
Step E: Create country-specific data on US macro conditions 
        expected by immigrants (based upon IPUMS and BEA data)
***************************************************************************/
*0) Set up final data file
use MacroConditions.dta, clear
collapse (sum) perwt, by(year frgnadd beaind)
drop perwt
drop if frgnadd>=1000
drop if beaind>=100
quietly tab frgnadd
di "Countries " r(r)
quietly tab beaind
di "Industries " r(r)
fillin year frgnadd beaind
drop _fillin
sort frgnadd beaind
save tempmaster.dta, replace


*1) Create share of each country's high-ed full-time employees in each industry in 2000.
use MacroConditions.dta, clear
keep if year==2000
keep if bachelors==1
keep if ft==1
drop if frgnadd>=1000
drop if beaind>=100

collapse (sum) perwt, by(frgnadd beaind)
fillin frgnadd beaind
replace perwt=0 if perwt==.
drop _fillin
sort frgnadd
by frgnadd: egen tot=total(perwt)
gen c_indempshare = perwt/tot
label var c_indempshare "Industry Share of Employment for Country in 2000"
keep frgnadd beaind c_indempshare
sort frgnadd beaind
merge frgnadd beaind using tempmaster.dta
tab _merge
di "Merge=2 implies IPUMS recorded no high-ed full time employees from"
di "That country in 2000"
tab bea frgnadd if _m==2
drop _merge

order year frgnadd beaind
sort year beaind
save tempmaster.dta, replace


*2) Average GDP by sector
use MacroConditions.dta, clear
drop if beaind>=100
collapse (sum) perwt, by(year beaind indgdp)
keep year beaind indgdp
sum

sort year beaind
merge year beaind using tempmaster.dta
tab _merge
drop _merge
order year frgnadd beaind
sort frgnadd year beaind
sum
tab frgnadd if c_==.
drop if c_==.
tab frgnadd
di r(r)
sum
sort year beaind
save tempmaster.dta, replace


*3) Create GDP Index
*use MacroConditions.dta, clear
gen gdpindex=indgdp*c_indempshare
collapse (sum) gdpindex, by(year frgnadd)
label var gdpindex "US GDP weighted by 2000 Country Representation (Millions 2005$)"
sort year frgnadd
save MacroConditions.dta, replace
erase tempmaster.dta


*4)Define OECD Countries
gen oecd=0
 
replace oecd=1 if frgnadd==	20	   
replace oecd=1 if frgnadd==	25	   
replace oecd=1 if frgnadd==	55	   
replace oecd=1 if frgnadd==	100	   
replace oecd=1 if frgnadd==	115	   
replace oecd=1 if frgnadd==	142	   
replace oecd=1 if frgnadd==	150	   
replace oecd=1 if frgnadd==	184	   
replace oecd=1 if frgnadd==	195	   
replace oecd=1 if frgnadd==	200	   
replace oecd=1 if frgnadd==	210	   
replace oecd=1 if frgnadd==	220	   
replace oecd=1 if frgnadd==	251	   
replace oecd=1 if frgnadd==	255	   
replace oecd=1 if frgnadd==	275	   
replace oecd=1 if frgnadd==	280	   
replace oecd=1 if frgnadd==	285	   
replace oecd=1 if frgnadd==	300	   
replace oecd=1 if frgnadd==	315	   
replace oecd=1 if frgnadd==	345	   
replace oecd=1 if frgnadd==	375	   
replace oecd=1 if frgnadd==	390	   
replace oecd=1 if frgnadd==	405	   
replace oecd=1 if frgnadd==	435	   
replace oecd=1 if frgnadd==	470	   
replace oecd=1 if frgnadd==	475	   
replace oecd=1 if frgnadd==	503	   
replace oecd=1 if frgnadd==	504	   
replace oecd=1 if frgnadd==	515	   
replace oecd=1 if frgnadd==	535	   
replace oecd=1 if frgnadd==	540	   
replace oecd=1 if frgnadd==	585	   
replace oecd=1 if frgnadd==	588	 

sort year frgnadd
save MacroConditions.dta, replace








/***************************************************************************
Step F: Label frgnadd, and
        Describe labels of data in Steps A-E no longer used.
***************************************************************************/
label define addlbl	1	 "Afghanistan"   
label define addlbl	3	 "Albania", add	   
label define addlbl	5	 "Algeria", add	   
label define addlbl	8	 "Andorra", add	   
label define addlbl	10	 "Angola", add	    
label define addlbl	15	 "Argentina", add	   
label define addlbl	16	 "Armenia", add	   
label define addlbl	17	 "Aruba", add	   
label define addlbl	20	 "Australia", add	   
label define addlbl	25	 "Austria", add	   
label define addlbl	29	 "Azerbaijan", add	   
label define addlbl	35	 "Bahamas, The", add	   
label define addlbl	40	 "Bahrain", add	   
label define addlbl	45	 "Bangladesh", add	   
label define addlbl	50	 "Barbados", add	   
label define addlbl	55	 "Belgium", add	   
label define addlbl	56	 "Belize", add	   
label define addlbl	58	 "Benin", add	   
label define addlbl	60	 "Bermuda", add	   
label define addlbl	63	 "Bhutan", add	   
label define addlbl	65	 "Bolivia", add	   
label define addlbl	69	 "Bosnia and Herzegovina", add	   
label define addlbl	70	 "Botswana", add	   
label define addlbl	75	 "Brazil", add	   
label define addlbl	77	 "British Virgin Islands", add	   
label define addlbl	81	 "Brunei", add	   
label define addlbl	85	 "Bulgaria", add	   
label define addlbl	92	 "Burundi", add	   
label define addlbl	94	 "Belarus", add	   
label define addlbl	95	 "Cameroon", add	   
label define addlbl	100	 "Canada", add	   
label define addlbl	106	 "Cape Verde", add	   
label define addlbl	107	 "Micronesia, Federated States of", add	   
label define addlbl	110	 "Cayman Islands", add	   
label define addlbl	113	 "Central African Republic", add	   
label define addlbl	114	 "Chad", add	   
label define addlbl	115	 "Chile", add	   
label define addlbl	120	 "Colombia", add	   
label define addlbl	122	 "Comoros", add	   
label define addlbl	125	 "Congo, Republic of the (Brazzaville)", add	   
label define addlbl	126	 "Cook Islands", add	   
label define addlbl	130	 "Costa Rica", add	   
label define addlbl	133	 "Croatia", add	   
label define addlbl	135	 "Cuba", add	   
label define addlbl	140	 "Cyprus", add	   
label define addlbl	142	 "Czech Republic", add	   
label define addlbl	150	 "Denmark", add	   
label define addlbl	153	 "Djibouti", add	   
label define addlbl	155	 "Dominican Republic", add	   
label define addlbl	165	 "Ecuador", add	   
label define addlbl	170	 "Egypt", add	   
label define addlbl	175	 "El Salvador", add	   
label define addlbl	182	 "Eritrea", add	   
label define addlbl	183	 "Equatorial Guinea", add	   
label define addlbl	184	 "Estonia", add	   
label define addlbl	185	 "Ethiopia", add	   
label define addlbl	190	 "Fiji", add	   
label define addlbl	195	 "Finland", add	   
label define addlbl	200	 "France", add	   
label define addlbl	202	 "French Polynesia", add	   
label define addlbl	203	 "French Guiana", add	   
label define addlbl	204	 "Gabon", add	   
label define addlbl	205	 "Gambia, The", add	   
label define addlbl	208	 "Georgia", add	   
label define addlbl	210	 "Germany", add	   
label define addlbl	215	 "Ghana", add	   
label define addlbl	217	 "Gibraltar", add	   
label define addlbl	220	 "Greece", add	   
label define addlbl	225	 "Greenland", add	   
label define addlbl	228	 "Guadeloupe", add	   
label define addlbl	230	 "Guatemala", add	   
label define addlbl	233	 "Guinea", add	   
label define addlbl	234	 "Guinea-Bissau", add	   
label define addlbl	235	 "Guyana", add	   
label define addlbl	240	 "Haiti", add	   
label define addlbl	245	 "Honduras", add	   
label define addlbl	250	 "Hong Kong", add	   
label define addlbl	251	 "Hungary", add	   
label define addlbl	255	 "Iceland", add	   
label define addlbl	260	 "India", add	   
label define addlbl	265	 "Indonesia", add	   
label define addlbl	270	 "Iran", add	   
label define addlbl	273	 "Iraq", add	   
label define addlbl	275	 "Ireland", add	   
label define addlbl	280	 "Israel", add	   
label define addlbl	285	 "Italy", add	   
label define addlbl	290	 "Cote D’Ivoire", add	   
label define addlbl	295	 "Jamaica", add	   
label define addlbl	300	 "Japan", add	   
label define addlbl	305	 "Jordan", add	   
label define addlbl	307	 "Cambodia", add	   
label define addlbl	308	 "Kazakhstan", add	   
label define addlbl	310	 "Kenya", add	   
label define addlbl	312	 "Kiribati", add	   
label define addlbl	314	 "Korea (DPR)", add	   
label define addlbl	315	 "Korea (ROK)", add	   
label define addlbl	320	 "Kuwait", add	   
label define addlbl	323	 "Kyrgyzstan", add	   
label define addlbl	325	 "Laos", add	   
label define addlbl	328	 "Latvia", add	   
label define addlbl	330	 "Lebanon", add	   
label define addlbl	333	 "Lesotho", add	   
label define addlbl	335	 "Liberia", add	   
label define addlbl	340	 "Libya", add	   
label define addlbl	343	 "Liechtenstein", add	   
label define addlbl	344	 "Lithuania", add	   
label define addlbl	345	 "Luxembourg", add	   
label define addlbl	347	 "Macau", add	   
label define addlbl	348	 "Macedonia, The Former Yugoslav Republic of", add	   
label define addlbl	350	 "Madagascar", add	   
label define addlbl	355	 "Malawi", add	   
label define addlbl	360	 "Malaysia", add	   
label define addlbl	361	 "Maldives", add	   
label define addlbl	363	 "Mali", add	   
label define addlbl	365	 "Malta", add	   
label define addlbl	366	 "Martinique", add	   
label define addlbl	368	 "Marshall Islands", add	   
label define addlbl	369	 "Mauritania", add	   
label define addlbl	370	 "Mauritius", add	   
label define addlbl	375	 "Mexico", add	   
label define addlbl	376	 "Moldova", add	   
label define addlbl	378	 "Monaco", add	   
label define addlbl	379	 "Mongolia", add	   
label define addlbl	380	 "Morocco", add	   
label define addlbl	381	 "Montserrat", add	   
label define addlbl	383	 "Montenegro", add	   
label define addlbl	385	 "Mozambique", add	   
label define addlbl	386	 "Nauru", add	   
label define addlbl	387	 "Nepal", add	   
label define addlbl	388	 "Namibia", add	   
label define addlbl	390	 "Netherlands", add	   
label define addlbl	395	 "Netherlands Antilles", add	   
label define addlbl	396	 "New Caledonia", add	   
label define addlbl	400	 "Papua New Guinea", add	   
label define addlbl	405	 "New Zealand", add	   
label define addlbl	420	 "Nicaragua", add	   
label define addlbl	425	 "Niger", add	   
label define addlbl	430	 "Nigeria", add	   
label define addlbl	433	 "Niue", add	   
label define addlbl	435	 "Norway", add	   
label define addlbl	443	 "Oman", add	   
label define addlbl	445	 "Pakistan", add	   
label define addlbl	447	 "Palau", add	   
label define addlbl	450	 "Panama", add	   
label define addlbl	455	 "Paraguay", add	   
label define addlbl	457	 "China, People’s Republic of", add	   
label define addlbl	460	 "Peru", add	   
label define addlbl	465	 "Philippines", add	   
label define addlbl	470	 "Poland", add	   
label define addlbl	475	 "Portugal", add	   
label define addlbl	477	 "Qatar", add	   
label define addlbl	480	 "Zimbabwe", add	   
label define addlbl	482	 "Reunion", add	   
label define addlbl	483	 "Romania", add	   
label define addlbl	484	 "Russia", add	   
label define addlbl	487	 "Rwanda", add	   
label define addlbl	488	 "San Marino", add	   
label define addlbl	489	 "Sao Tome and Principe", add	   
label define addlbl	490	 "Saudi Arabia", add	   
label define addlbl	497	 "Senegal", add	   
label define addlbl	498	 "Seychelles", add	   
label define addlbl	499	 "Serbia", add	   
label define addlbl	500	 "Sierra Leone", add	   
label define addlbl	503	 "Slovakia", add	   
label define addlbl	504	 "Slovenia", add	   
label define addlbl	505	 "Singapore", add	   
label define addlbl	506	 "Solomon Islands", add	   
label define addlbl	507	 "Somalia", add	   
label define addlbl	510	 "South Africa", add	   
label define addlbl	515	 "Spain", add	   
label define addlbl	520	 "Sri Lanka", add	   
label define addlbl	525	 "Sudan", add	   
label define addlbl	527	 "Suriname", add	   
label define addlbl	530	 "Swaziland", add	   
label define addlbl	535	 "Sweden", add	   
label define addlbl	540	 "Switzerland", add	   
label define addlbl	545	 "Syria", add	   
label define addlbl	550	 "Tahiti", add	   
label define addlbl	555	 "Taiwan", add	   
label define addlbl	556	 "Tajikistan", add	   
label define addlbl	560	 "Tanzania", add	   
label define addlbl	565	 "Thailand", add	   
label define addlbl	567	 "Togo", add	   
label define addlbl	570	 "Tonga", add	   
label define addlbl	575	 "Trinidad and Tobago", add	   
label define addlbl	580	 "Tunisia", add	   
label define addlbl	584	 "Turkmenistan", add	   
label define addlbl	585	 "Turkey", add	   
label define addlbl	586	 "Turks and Caicos Islands", add	   
label define addlbl	587	 "Tuvalu", add	   
label define addlbl	588	 "United Kingdom", add	   
label define addlbl	589	 "Ukraine", add	   
label define addlbl	590	 "Uganda", add	   
label define addlbl	591	 "United Arab Emirates", add	   
label define addlbl	593	 "Burkina Faso", add	   
label define addlbl	594	 "Uzbekistan", add	   
label define addlbl	595	 "Uruguay", add	   
label define addlbl	596	 "Vanuatu", add	   
label define addlbl	597	 "Holy See (Vatican City)", add	   
label define addlbl	600	 "Venezuela", add	   
label define addlbl	605	 "Vietnam", add	   
label define addlbl	611	 "West Bank & Palestinian Territories", add	   
label define addlbl	615	 "West Indies and Associated States", add	   
label define addlbl	620	 "Samoa (former Western Samoa)", add	   
label define addlbl	623	 "Yemen", add	   
label define addlbl	625	 "Yugoslav, Late Era (Serbia & Montenegro)", add	   
label define addlbl	630	 "Congo, Democratic Republic of the (former Kinshasa)", add	   
label define addlbl	635	 "Zambia", add	   
label values frgnadd addlbl					 







/*******************************************************************
Labels No longer used:

label var beaind "BEA Industry"
label var indgdp "Real GDP (millions of chained 2005 dollars)"
label var emp "Employed"
label var ft "Full Time Employee"
label var bachelors "Has Bachelor Degree"

label define emp_lbl 0 `"Unemployed"'
label define emp_lbl 1 `"Employed"', add
label values emp emp_lbl

label define ft_lbl 0 "Part Time Employee"
label define ft_lbl 1 "Full Time Employee", add
label values ft ft_lbl

label define ba_lbl 0 "No Bachelors Degree"
label define ba_lbl 1 "Has Bachelors Degree", add
label values bachelors ba_lbl

 
label define beaind_lbl 1 "All industry total"
label define beaind_lbl 2 "Private industries", add   
label define beaind_lbl 3 "Agriculture, forestry, fishing, and hunting", add   
label define beaind_lbl 4 "Crop and animal production (Farms)", add   
label define beaind_lbl 5 "Forestry, fishing, and related activities", add   
label define beaind_lbl 6 "Mining", add   
label define beaind_lbl 7 "Oil and gas extraction", add   
label define beaind_lbl 8 "Mining, except oil and gas", add   
label define beaind_lbl 9 "Support activities for mining", add   
label define beaind_lbl 10 "Utilities", add   
label define beaind_lbl 11 "Construction", add   
label define beaind_lbl 12 "Manufacturing", add   
label define beaind_lbl 13 "Durable goods", add   
label define beaind_lbl 14 "Wood product manufacturing", add   
label define beaind_lbl 15 "Nonmetallic mineral product manufacturing", add   
label define beaind_lbl 16 "Primary metal manufacturing", add   
label define beaind_lbl 17 "Fabricated metal product manufacturing", add   
label define beaind_lbl 18 "Machinery manufacturing", add   
label define beaind_lbl 19 "Computer and electronic product manufacturing", add   
label define beaind_lbl 20 "Electrical equipment and appliance manufacturing", add   
label define beaind_lbl 21 "Motor vehicle, body, trailer, and parts manufacturing", add   
label define beaind_lbl 22 "Other transportation equipment manufacturing", add   
label define beaind_lbl 23 "Furniture and related product manufacturing", add   
label define beaind_lbl 24 "Miscellaneous manufacturing", add   
label define beaind_lbl 25 "Nondurable goods", add   
label define beaind_lbl 26 "Food product manufacturing", add   
label define beaind_lbl 27 "Textile and textile product mills", add   
label define beaind_lbl 28 "Apparel manufacturing", add   
label define beaind_lbl 29 "Paper manufacturing", add   
label define beaind_lbl 30 "Printing and related support activities", add   
label define beaind_lbl 31 "Petroleum and coal products manufacturing", add   
label define beaind_lbl 32 "Chemical manufacturing", add   
label define beaind_lbl 33 "Plastics and rubber products manufacturing", add   
label define beaind_lbl 34 "Wholesale trade", add   
label define beaind_lbl 35 "Retail trade", add   
label define beaind_lbl 36 "Transportation and warehousing, excluding Postal Service", add   
label define beaind_lbl 37 "Air transportation", add   
label define beaind_lbl 38 "Rail transportation", add   
label define beaind_lbl 39 "Water transportation", add   
label define beaind_lbl 40 "Truck transportation", add   
label define beaind_lbl 41 "Transit and ground passenger transportation", add   
label define beaind_lbl 42 "Pipeline transportation", add   
label define beaind_lbl 43 "Other transportation and support activities", add   
label define beaind_lbl 44 "Warehousing and storage", add   
label define beaind_lbl 45 "Information", add   
label define beaind_lbl 46 "Publishing including software", add   
label define beaind_lbl 47 "Motion picture and sound recording industries", add   
label define beaind_lbl 48 "Broadcasting and telecommunications", add   
label define beaind_lbl 49 "Information and data processing services", add   
label define beaind_lbl 50 "Finance and insurance", add   
label define beaind_lbl 51 "Federal Reserve banks, credit intermediation and related services", add   
label define beaind_lbl 52 "Securities, commodity contracts, investments", add   
label define beaind_lbl 53 "Insurance carriers and related activities", add   
label define beaind_lbl 54 "Funds, trusts, and other financial vehicles", add   
label define beaind_lbl 55 "Real estate and rental and leasing", add   
label define beaind_lbl 56 "Real estate", add   
label define beaind_lbl 57 "Rental and leasing services and lessors of intangible assets", add   
label define beaind_lbl 58 "Professional and technical services", add   
label define beaind_lbl 59 "Legal services", add   
label define beaind_lbl 60 "Computer systems design and related services", add   
label define beaind_lbl 61 "Other professional, scientific and technical services", add   
label define beaind_lbl 62 "Management of companies and enterprises", add   
label define beaind_lbl 63 "Administrative and waste services", add   
label define beaind_lbl 64 "Administrative and support services", add   
label define beaind_lbl 65 "Waste management and remediation services", add   
label define beaind_lbl 66 "Educational services", add   
label define beaind_lbl 67 "Health care and social assistance", add   
label define beaind_lbl 68 "Ambulatory health care services", add   
label define beaind_lbl 69 "Hospitals and nursing and residential care facilities", add   
label define beaind_lbl 70 "Social assistance", add   
label define beaind_lbl 71 "Arts, entertainment, and recreation", add   
label define beaind_lbl 72 "Performing arts, museums, and related activities", add   
label define beaind_lbl 73 "Amusement, gambling, and recreation", add   
label define beaind_lbl 74 "Accommodation and food services", add   
label define beaind_lbl 75 "Accommodation", add   
label define beaind_lbl 76 "Food services and drinking places", add   
label define beaind_lbl 77 "Other services, except government", add   
label define beaind_lbl 78 "Government", add   
label define beaind_lbl 79 "Federal civilian", add   
label define beaind_lbl 80 "Federal military", add   
label define beaind_lbl 81 "State and local", add   
label define beaind_lbl 100 "Unemployed, No Industry Listed", add 
label values beaind beaind_lbl
*******************************************************************/











compress
order year frgnadd oecd
sum
sort year frgnadd 
save MacroConditions.dta, replace

log close
exit




