******************************************************
*This file contains the code to generate the time series cross section
*analysis data set analyzed in the paper from its various sources.  
******************************************************

*Set appropriate working directory to include all source files

*****STEP 1: Merge source data files and define variables

*This code creates a single source file with party positin data
import delimited "MPDS2012b_withSEandLogitSE.csv", clear
keep party date logrile eu pervote
gen sdate = string(date)
gen month = real(substr(sdate, 5,2))
gen year = real(substr(sdate, 1,4))
destring, replace force
keep party year month logrile eu pervote
order year month party
save LogRileAux, replace

import delimited "pos_elff_pa.csv", clear
keep country party year month econlr_mean
merge 1:1 party year month using LogRileAux, keep(match master)
drop _merge

*Generate ccode2 variable for merging with economic variables and dropping all countries not included in analysis
recode country (11 = 380) (12 = 385) (13 = 390) (22=210) (31 = 220) (32 = 325) (33 = 230) (35 = 235) (41 = 260) (43 = 225 ) (51 = 200)  (53 = 205) (62 = 20) (64 = 920) (63 = 900) (71 = 740) (else = .), gen(ccode2)
drop if ccode2 == .
sort ccode2 year month party

*Select main left parties following Pontusson and Rueda (2010), Comparative Political Studies.
gen mleftp = .
replace mleftp = 1 if party == 63320| party == 62420 | party == 13320 | party == 31320 | party == 41320 | party == 53320 | party ==  71320|  party == 22320 | party == 64320 | party == 12320 | party == 11320 | party == 43320 | party == 51320 | party == 33320 | party == 35311
replace mleftp = 1 if party == 32220 & year < 2006
replace mleftp = 1 if party == 32329 & year > 2001
replace mleftp = 1 if party == 32320 & year < 1996
keep if mleftp == 1


*For Italy, replace position by weighted mean of communist and socialist party
bysort country year month: egen sum_pervote = mean(pervote)
bysort country year month: gen econlr_wi = pervote*econlr_mean/sum_pervote
bysort country year month: egen econlr_wmean = mean(econlr_wi)
bysort country year month: gen logrile_wi = pervote*logrile/sum_pervote
bysort country year month: egen logrile_wmean = mean(logrile_wi)
replace econlr_mean = econlr_wmean if ccode2 == 325
replace logrile = logrile_wmean if ccode2 == 325
drop if party == 32320
keep ccode2 year month econlr_mean logrile eu
save ppositions_aux, replace


*Prepare data on elections and electoral rules
use es_data-v2_0, clear
*Select countries used in analysis
drop if presidential==1
keep if ccode2 == 20 | ccode2 == 200 | ccode2 == 205 | ccode2 == 210 | ccode2 == 220 | ccode2 == 225| ccode2 == 230 | ccode2 == 235 | ccode2 == 260 | ccode2 ==  325 | ccode2 == 380 | ccode2 == 385 | ccode2 == 390 | ccode2 == 740 |ccode2 == 900 | ccode2 ==  920
 *Generate month variable for merging with ppositions
gen date2 = date(date, "MDY")
format date2 %d
generate month = month(date2)

*Code to calculate (log) average district magnitude
*Note that this treats dependent-mixed systems like Germany in line with political economy litearture
*rather than as district magnitude = 1
gen dm = tier1_avemag
replace dm = seats/tier2_districts if ccode2==260
replace dm = seats/tier2_districts if ccode2==325 & (year == 1994 | year == 1996 | year == 2001)
replace dm = seats/(tier1_districts + tier2_districts) if ccode2==740 & year >= 1996
replace dm = seats/tier2_districts if ccode2==920 & year > 1996
replace dm = seats/(tier1_districts + tier2_districts) if ccode2==390
gen dml = log(dm)

*Proportional representation is coded in line with Iversen and Soskice (2006 APSR)
recode legislative_type (1 = 0) (2=1) (3=0), gen(pr)
*Mixed systems that are dependent are PR
replace pr = 1 if mixed_type ==  4 | mixed_type ==  5 
*Iversen and Soskice code Ireland as non-PR
replace pr = 0 if ccode2 == 205

*Keep variables needed for analysis and merging
keep ccode2 year month pr dm dml

*Merge party position data
merge 1:1 ccode2 year month using ppositions_aux, keep(match master)
drop _merge

*Merge country-year economic data 
merge m:1 ccode2 year using econ_data
drop _merge

*Add turnout data from IDEA
merge m:1 ccode2 year using idea_turnout, keepusing(vap_turnout)
drop if _merge==2
drop _merge

*Drop observations in Spain and Portugal before democratic transition
drop if ccode2 == 230 & year < 1977
drop if ccode2 == 235 & year < 1976

*This code defines variable "inccab" (i.e., whether party is member of incumbent cabinet) used in robustness test reported in S3.
*The coding is based on sources discussed in S3.
gen inccab =.
replace inccab = 0 if month !=.
*Australia
replace inccab = 1  if ccode2==900 & year ==1946
replace inccab = 1  if ccode2==900 & year ==1949
replace inccab = 1  if ccode2==900 & year ==1972
replace inccab = 1  if ccode2==900 & year == 1974
replace inccab = 1  if ccode2==900 & year == 1984
replace inccab = 1  if ccode2==900 & year == 1987
replace inccab = 1  if ccode2==900 & year == 1990
replace inccab = 1  if ccode2==900 & year == 1993
replace inccab = 1  if ccode2==900 & year == 1996
replace inccab = 1  if ccode2==900 & year == 2010
*Canada
replace inccab = 1  if ccode2==20 & year ==1949
replace inccab = 1  if ccode2==20 & year ==1953
replace inccab = 1  if ccode2==20 & year ==1965
replace inccab = 1  if ccode2==20 & year ==1968
replace inccab = 1  if ccode2==20 & year ==1972
replace inccab = 1  if ccode2==20 & year ==1974
replace inccab = 1  if ccode2==20 & year ==1984
replace inccab = 1  if ccode2==20 & year ==1997
replace inccab = 1  if ccode2==20 & year ==2000
replace inccab = 1  if ccode2==20 & year ==2004
replace inccab = 1  if ccode2==20 & year ==2006
*Denmark
replace inccab = 1  if ccode2==390 & year ==1950
replace inccab = 1  if ccode2==390 & year ==1957
replace inccab = 1  if ccode2==390 & year ==1960
replace inccab = 1  if ccode2==390 & year ==1964
replace inccab = 1  if ccode2==390 & year ==1966
replace inccab = 1  if ccode2==390 & year ==1968
replace inccab = 1  if ccode2==390 & year ==1973
replace inccab = 1  if ccode2==390 & year ==1977
replace inccab = 1  if ccode2==390 & year ==1979
replace inccab = 1  if ccode2==390 & year ==1981
replace inccab = 1  if ccode2==390 & year ==1994
replace inccab = 1  if ccode2==390 & year ==1998
replace inccab = 1  if ccode2==390 & year ==2001
*France
replace inccab = 1  if ccode2==220 & year ==1946
replace inccab = 1  if ccode2==220 & year ==1951
replace inccab = 1  if ccode2==220 & year ==1981
replace inccab = 1  if ccode2==220 & year ==1986
replace inccab = 1  if ccode2==220 & year == 1988
replace inccab = 1  if ccode2==220 & year == 1993
replace inccab = 1  if ccode2==220 & year == 2002
replace inccab = 1  if ccode2==220 & year == 2012
*Germany
replace inccab = 1  if ccode2==260 & year == 1969
replace inccab = 1  if ccode2==260 & year == 1972
replace inccab = 1  if ccode2==260 & year == 1976
replace inccab = 1  if ccode2==260 & year == 1980
replace inccab = 1  if ccode2==260 & year == 2002
replace inccab = 1  if ccode2==260 & year == 2005
replace inccab = 1  if ccode2==260 & year == 2009
*Ireland
replace inccab = 1  if ccode2==205 & year == 1951
replace inccab = 1  if ccode2==205 & year == 1957 
replace inccab = 1  if ccode2==205 & year == 1977 
replace inccab = 1  if ccode2==205 & year == 1982
replace inccab = 1  if ccode2==205 & year == 1987
replace inccab = 1  if ccode2==205 & year == 1997
*Italy
replace inccab = 1  if ccode2==325 & year == 1968
replace inccab = 1  if ccode2==325 & year == 1983
replace inccab = 1  if ccode2==325 & year == 1992
replace inccab = 1  if ccode2==325 & year == 1994 
replace inccab = 1  if ccode2==325 & year == 2001
replace inccab = 1  if ccode2==325 & year == 2008
*Japan
replace inccab = 1  if ccode2==740 & year == 1996
*Netherlands
replace inccab = 1  if ccode2==210 & year == 1948
replace inccab = 1  if ccode2==210 & year == 1952
replace inccab = 1  if ccode2==210 & year == 1967
replace inccab = 1  if ccode2==210 & year == 1977
replace inccab = 1  if ccode2==210 & year == 1994
replace inccab = 1  if ccode2==210 & year == 1998
replace inccab = 1  if ccode2==210 & year == 2002
*New Zealand
replace inccab = 1 if ccode2==920 & year == 1946
replace inccab = 1 if ccode2==920 & year == 1949 
replace inccab = 1 if ccode2==920 & year == 1960
replace inccab = 1 if ccode2==920 & year == 1975
replace inccab = 1 if ccode2==920 & year == 1987
replace inccab = 1 if ccode2==920 & year == 1990
replace inccab = 1 if ccode2==920 & year == 2002
replace inccab = 1 if ccode2==920 & year == 2005
replace inccab = 1 if ccode2==920 & year == 2008 
*Norway
replace inccab = 1 if ccode2==385 & year == 1949
replace inccab = 1 if ccode2==385 & year == 1953
replace inccab = 1 if ccode2==385 & year == 1957
replace inccab = 1 if ccode2==385 & year == 1961
replace inccab = 1 if ccode2==385 & year == 1965
replace inccab = 1 if ccode2==385 & year == 1977
replace inccab = 1 if ccode2==385 & year == 1981
replace inccab = 1 if ccode2==385 & year == 1989
replace inccab = 1 if ccode2==385 & year == 1993
replace inccab = 1 if ccode2==385 & year == 1997
replace inccab = 1 if ccode2==385 & year == 2001
replace inccab = 1 if ccode2==385 & year == 2009
*Portugal
replace inccab = 1 if ccode2==235 & year == 1979
replace inccab = 1 if ccode2==235 & year == 1985
replace inccab = 1 if ccode2==235 & year == 1999
replace inccab = 1 if ccode2==235 & year == 2002
replace inccab = 1 if ccode2==235 & year == 2009
*Spain
replace inccab = 1 if ccode2==230 & year == 1986
replace inccab = 1 if ccode2==230 & year == 1989
replace inccab = 1 if ccode2==230 & year == 1993
replace inccab = 1 if ccode2==230 & year == 1996
replace inccab = 1 if ccode2==230 & year == 2008
replace inccab = 1 if ccode2==230 & year == 2011 
*Sweden
replace inccab = 1 if ccode2==380 & year == 1948
replace inccab = 1 if ccode2==380 & year == 1952
replace inccab = 1 if ccode2==380 & year == 1956
replace inccab = 1 if ccode2==380 & year == 1958
replace inccab = 1 if ccode2==380 & year == 1960
replace inccab = 1 if ccode2==380 & year == 1964
replace inccab = 1 if ccode2==380 & year == 1968
replace inccab = 1 if ccode2==380 & year == 1970
replace inccab = 1 if ccode2==380 & year == 1973
replace inccab = 1 if ccode2==380 & year == 1976
replace inccab = 1 if ccode2==380 & year == 1985
replace inccab = 1 if ccode2==380 & year == 1988
replace inccab = 1 if ccode2==380 & year == 1991
replace inccab = 1 if ccode2==380 & year == 1998
replace inccab = 1 if ccode2==380 & year == 2002
replace inccab = 1 if ccode2==380 & year == 2006
*Switzerland
replace inccab = 1  if ccode2==225
*United Kingdom
replace inccab = 1 if ccode2==200 & year == 1945
replace inccab = 1 if ccode2==200 & year == 1950
replace inccab = 1 if ccode2==200 & year == 1951
replace inccab = 1 if ccode2==200 & year == 1966
replace inccab = 1 if ccode2==200 & year == 1970
replace inccab = 1 if ccode2==200 & year == 1974 & month ==10
replace inccab = 1 if ccode2==200 & year == 1979
replace inccab = 1 if ccode2==200 & year == 2001
replace inccab = 1 if ccode2==200 & year == 2005
replace inccab = 1 if ccode2==200 & year == 2010

*This code defines variable "leftcomp" (i.e., whether there is a left competitor) used in robustness test reported in S3.
*The coding is based on sources discussed in S3.
gen leftcompet =.
replace leftcompet = 0 if month !=.
*Australia
replace leftcompet = 1 if ccode2==900 & year > 1989 & year < 2011 & month !=.
*Canada
replace leftcompet = 1 if ccode2==20 & month !=.
*Denmark
replace leftcompet = 1 if ccode2==390 & month !=. & year != 1950 & year != 1953
*France
replace leftcompet = 1 if ccode2==220 & month !=. & year != 1951 & year != 1956 & year != 1981 & year != 1986
*Germany
replace leftcompet = 1 if ccode2==260 & month !=. & year > 1983
*Ireland
replace leftcompet = 1 if ccode2==205 & month !=. & year != 1973 & year != 1969
*Italy
replace leftcompet = 1 if ccode2==325 & month !=. & year != 1946  & year != 1968 & year != 1972 & year != 1976 & year != 1979 & year < 2008
*Japan
replace leftcompet = 1 if ccode2==740 & month !=. & year != 1990 & year != 2000 & year != 2003
*Netherlands
replace leftcompet = 1 if ccode2==210 & month !=. & year == 1977
replace leftcompet = 1 if ccode2==210 & month !=. & year > 1981
*New Zealand
replace leftcompet = 1 if ccode2==920 & month !=. & year == 1972
replace leftcompet = 1 if ccode2==920 & month !=. & year > 1972 & year != 1984
*Norway
replace leftcompet = 1 if ccode2==385 & month !=. & year > 1961
*Portugal
replace leftcompet = 1 if ccode2==235 & month !=. & year > 1975
*Spain
replace leftcompet = 1 if ccode2==230 & month !=. & year > 1975
*Sweden
replace leftcompet = 1 if ccode2==380 & month !=. & year != 1960
*Switzerland
replace leftcompet = 1 if ccode2==225 & month !=. & year > 1990 & year != 2003
*UK
replace leftcompet = 1 if ccode2==200 & month !=. & year == 1951
replace leftcompet = 1 if ccode2==200 & month !=. & year == 1997
replace leftcompet = 1 if ccode2==200 & month !=. & year == 2001
replace leftcompet = 1 if ccode2==200 & month !=. & year == 2005

*This code defines variable "party_cent" (i.e., party centralization) used in robustness test reported in S3
*The coding is based on sources discussed in S3 (p. 28); data on Portugal is missing.
gen party_cent = .
replace party_cent =  2 if ccode2 == 225 | ccode2 == 260 |  ccode2 == 380 |  ccode2 == 385 |  ccode2 == 900 
replace party_cent = 3 if ccode2 == 20 | ccode2 == 200 |  ccode2 == 205 |  ccode2 == 210 |  ccode2 == 325 |  ccode2 == 390 |  ccode2 == 740 | ccode2 == 920
replace party_cent = 3.5 if ccode2 == 220  
replace party_cent = 4 if ccode2 == 230
*Coding reforms in Australia and Netherlands
replace party_cent = 3 if ccode2==900 & year > 1998
replace party_cent = 2 if ccode2==210 & year > 1988
*For meaningful interpretation of interaction with party_cent, rescale to vary between 0 and 1
replace party_cent = (party_cent - 2)/2
replace party_cent = . if month == .

*This code defines variable "euint" (i.e., EU integration) used in robustness test reported in S3.
*The coding is based on sources discussed in S3
recode eu (10=1)
gen euinteg = 0 if eu !=.
replace euinteg = 6 if eu==1 & year > 1956 & year < 1968
replace euinteg = 14 if eu==1 & year > 1967 & year < 1992
replace euinteg = 25 if eu==1 & year > 1991 & year < 2000
replace euinteg = 33 if eu==1 & year > 1999 & year < 2013
replace euinteg = euinteg/60


*Calculate GDP per capita and log of total population
gen gdppc = rgdpe/pop
gen popl = log(1000000*pop)

**********STEP 2: Aggregate data to electoral terms

*Calculate electoral term (i.e., nelection) variable needed for aggregation
*Add month for Canada election in 1945 (missing in Borman and Golder dataset)
replace month = 6 if ccode2 == 20 & year == 1945
*Use loop
gen ey = 0
replace ey = 1 if month != .
bysort ccode2: gen ec = sum(ey)
gen nelection = .
forvalues i = 1/26 {
replace nelection = `i' if ec == `i' & ey == 1
replace nelection = `i' + 1 if ec == `i' & ey == 0
}
replace nelection = 1 if ec == 0
drop ey ec

*Aggregate observations by electoral term
gen yearel = .
replace yearel = year if month !=.
collapse (mean) yearel parlori top1 mean_gini_market econlr_mean logrile pr dml gdppc vap_turnout trade pop65o popl ud euinteg inccab leftcompet party_cent parlorius top1us, by(ccode2 nelection)

**********STEP 3: Add variable and some value labels

*Define period variable
recode yearel (1940/1973 = 1 "1945-73") (1974/1989 = 2 "1974-89") (1990/2012 = 3 "1990-2012"), gen(period)

*Add value labels for country code and PR
label define ccode2lbl  20 "CA" 200 "UK" 205 "IE" 210 "NL" 220 "FR" 225 "CH" 230 "ES" 235 "PT" 260 "DE" 325 "IT" 380 "SE" 385 "NO" 390 "DK" 740 "JP" 900 "AU" 920 "NZ"
label values ccode2 ccode2lbl


lab define prlab 1 "PR" 0 "MAJ"
lab values pr prlab

*Define variable labels
lab var ccode2 "Country code"
lab var nelection "Election Number"
lab var econlr_mean "Left-Right Position"
lab var logrile "Alternative Left-Right Position"
lab var parlori "Top Income Inequality (TI)"
lab var top1 "Top Income Share (TIS)"
lab var mean_gini_market "Market Gini"
lab var pr "Proportional Representation (PR)"
lab var dml "District Magnitude (DM)"
lab var gdppc "Income per capita (in 1000 USD)"
lab var vap_turnout "Voter Turnout"
lab var trade "Trade Openness"
lab var pop65o "Population Over 65 (\%)"
lab var popl "Log of Population"
lab var yearel "Time Trend (Year)"
lab var parlorius "US Top Inequality"
lab var ud "Union Density"
lab var inccab "Incumbent Cabinet"
lab var euinteg "EU Integration"
lab var leftcompet "Left Competitor"
lab var party_cent "Centralization"
lab var parlorius "TI US"
lab var top1us "TIS US"
lab var period "Period"

drop if yearel == .
save data_tscs, replace

*Delete auxilliary files
erase LogRileAux.dta
erase ppositions_aux.dta
