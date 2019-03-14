
*****INSTRUCTIONS FOR GENERATING THE REPLICATION DATA*****


** Replication Data = Dataset used to replicate the main results in Krcmaric's article
** Change Point Data = Dataset used to replicate the change point analysis in Krcmaric's article (derived from Replication Data)
** Base Data = Krcmaric's personal update to Archigos 2.9 and original data on leader culpability (starting point for recreating Replication Data)
** See below for instructions on merging other variables used in the analysis into Base Data to create Replication Data 


* Merge in conflict intensity variable
use "Base Data.dta"
merge m:1 gwno year using "UCDPconflictCYv412.dta"
drop if _merge == 2
drop _merge
save "Replication Data.dta"

* Merge in western affinity variable
use "Replication Data.dta"
merge m:1 gwno year using "BSVidealpoint.dta"
drop if _merge == 2
drop _merge
save "Replication Data", replace

* Merge in democracy variable 
use "Replication Data.dta"
merge m:1 gwno year using "GWFglobal.dta"
gen gwf_dem = 0
replace gwf_dem = 1 if gwf_nonautocracy == "democracy"
replace gwf_dem = . if gwf_nonautocracy == ""
drop if _merge == 2
drop _merge
save "Replication Data.dta", replace

* Merge in revolutionary activity variable
use "Replication Data.dta"
merge m:1 gwno year using "BanksCNTS.dta"
drop if _merge == 2
drop _merge
save "Replication Data.dta", replace

* Create major power ally dummy
gen us_ally = 0
replace us_ally = 1 if gwno==20 & year>1948 | gwno==31 & year>1981 | gwno==40 & year>1944 & year<1963 | gwno==41 & year>1944 | gwno==42 & year>1944 | gwno==51 & year>1968 | gwno==52 & year>1966 | gwno==53 & year>1966 | gwno==54 & year>1978 | gwno==55 & year>1974 | gwno==56 & year>1978 | gwno==57 & year>1980 | gwno==58 & year>1980 | gwno==60 & year>1983 | gwno==70 & year>1944 | gwno==80 & year>1990 | gwno==90 & year>1944 | gwno==91 & year>1944 | gwno==92 & year>1944 | gwno==93 & year>1944 | gwno==94 & year>1944 | gwno==95 & year>1944 | gwno==100 & year>1944 | gwno==101 & year>1944 | gwno==110 & year>1990 | gwno==115 & year>1976 | gwno==130 & year>1944 | gwno==135 & year>1944 | gwno==140 & year>1944 | gwno==145 & year>1944 | gwno==150 & year>1944 | gwno==155 & year>1944 | gwno==160 & year>1944 | gwno==165 & year>1944 | gwno==200 & year>1948 | gwno==210 & year>1948 | gwno==211 & year>1948 | gwno==212 & year>1948 | gwno==220 & year>1948 | gwno==230 & year>1969 | gwno==235 & year>1948 | gwno==255 & year>1953 | gwno==260 & year>1953 | gwno==290 & year>1961 & year<1965 | gwno==290 & year>1998 | gwno==310 & year>1998 | gwno==316 & year>1998 | gwno==325 & year>1948 | gwno==350 & year>1950 | gwno==385 & year>1948 | gwno==390 & year>1948 | gwno==395 & year>1948 | gwno==450 & year>1958 | gwno==630 & year>1957 & year<1980 | gwno==640 & year>1950 | gwno==645 & year>1957 & year<1960 | gwno==666 & year>1980 & year<1992 | gwno==710 & year>1961 & year<1965 | gwno==713 & year>1953 & year<1981 | gwno==732 & year>1952 | gwno==740 & year>1950 | gwno==750 & year>1961 & year<1965 | gwno==770 & year>1953 | gwno==775 & year>1961 & year<1965 |  gwno==800 & year>1953 & year<1978 | gwno==811 & year>1961 & year<1965 | gwno==816 & year>1961 & year<1965 | gwno==817 & year>1961 & year<1965 | gwno==840 & year>1950 | gwno==900 & year>1950 | gwno==920 & year>1950 & year<1987 | gwno==365 & year>1961 & year<1965
gen uk_ally = 0
replace uk_ally = 1 if gwno==2 & year>1948 | gwno==20 & year>1948 | gwno==210 & year>1947 | gwno==211 & year>1947 | gwno==212 & year>1947 | gwno==220 & year>1947 | gwno==230 & year>1980 | gwno==235 & year>1944 | gwno==255 & year>1953 | gwno==260 & year>1953 | gwno==290 & year>1961 & year<1965 | gwno==290 & year>1998 | gwno==310 & year>1998 | gwno==316 & year>1998 | gwno==325 & year>1948 | gwno==350 & year>1950 | gwno==365 & year>1944 & year<1956 | gwno==365 & year>1961 & year<1965 | gwno==385 & year>1948 | gwno==390 & year>1948 | gwno==590 & year>1967 & year<1977 | gwno==620 & year>1952 & year<1970 | gwno==630 & year<1947 | gwno==630 & year>1954 & year<1980 | gwno==640 & year>1950 | gwno==645 & year>1944 & year<1960 | gwno==651 & year>1944 & year<1957 | gwno==663 & year>1945 & year<1957 | gwno==666 & year>1955 & year<1957| gwno==710 & year>1961 & year<1965 | gwno==750 & year>1961 & year<1965 | gwno==770 & year>1953 & year<1980 | gwno==775 & year>1961 & year<1965 | gwno==800 & year>1953 & year<1978 | gwno==811 & year>1961 & year<1965 | gwno==816 & year>1961 & year<1965 | gwno==817 & year>1961 & year<1965 | gwno==820 & year>1956 & year<1972 | gwno==840 & year>1953 & year<1978 | gwno==900 & year>1953 & year<1978 | gwno==920 & year>1953 & year<1978
gen france_ally = 0
replace france_ally = 1 if gwno==2 & year>1948 | gwno==20 & year>1948 | gwno==200 & year>1947 | gwno==210 & year>1947 | gwno==211 & year>1947 | gwno==212 & year>1947 | gwno==230 & year>1980 | gwno==235 & year>1948 | gwno==255 & year>1953 | gwno==260 & year>1953 | gwno==290 & year>1961 & year<1965 | gwno==290 & year>1998 | gwno==310 & year>1998 | gwno==316 & year>1998 | gwno==325 & year>1948 | gwno==350 & year>1950 | gwno==365 & year>1944 & year<1956 | gwno==365 & year>1970 | gwno==372 & year>1993 | gwno==385 & year>1948 | gwno==390 & year>1948 | gwno==395 & year>1948 | gwno==481 & year>1959 | gwno==482 & year>1959 & year<1977 | gwno==483 & year>1959 & year<1979 | gwno==484 & year>1959 & year<1979 | gwno==600 & year>1955 & year<1967 | gwno==620 & year>1954 & year<2012 | gwno==640 & year>1950 | gwno==666 & year>1955 & year<1957 | gwno==710 & year>1961 & year<1965 | gwno==750 & year>1961 & year<1965 | gwno==770 & year>1953 & year<1973 | gwno==775 & year>1961 & year<1965 | gwno==800 & year>1953 & year<1975 | gwno==811 & year>1961 & year<1965 | gwno==816 & year>1961 & year<1965 | gwno==817 & year>1961 & year<1965 | gwno==840 & year>1953 & year<1975 | gwno==900 & year>1953 & year<1975 | gwno==920 & year>1953 & year<1975
gen russia_ally = 0 
replace russia_ally = 1 if gwno==20 & year>1961 & year<1965 | gwno==20 & year>1970 & year<1993 | gwno==220 & year>1944 & year<1956 | gwno==220 & year>1970 | gwno==255 & year>1990 | gwno==265 & year>1954 & year<1990 | gwno==290 & year>1944 & year<1990 | gwno==290 & year>1991 | gwno==310 & year>1947 & year<1990 | gwno==315 & year>1944 & year<1990 | gwno==325 & year>1989 & year<1992 | gwno==339 & year>1954 & year<1969 | gwno==345 & year>1944 & year<1950 | gwno==355 & year>1947 & year<1990 | gwno==355 & year>1991 | gwno==359 & year>1994 | gwno==360 & year>1947 & year<1990 | gwno==369 & year>1994 | gwno==370 & year>1991 | gwno==371 & year>1991 | gwno==372 & year>1991 | gwno==373 & year>1991 | gwno==375 & year>1947 | gwno==484 & year>1980 & year<1992 | gwno==530 & year>1977 & year<1992 | gwno==540 & year>1975 & year<1992 | gwno==541 & year>1976 & year<1992 | gwno==630 & year<1947 | gwno==640 & year>1991 | gwno==645 & year>1971 & year<1991 | gwno==651 & year>1970 & year<1977 | gwno==652 & year>1979 & year<1992 | gwno==680 & year>1978 & year<1991 | gwno==700 & year<1980 | gwno==701 & year>1991 | gwno==702 & year>1991 | gwno==703 & year>1991 | gwno==704 & year>1991 | gwno==705 & year>1991 | gwno==710 & year>1944 & year<1981 | gwno==710 & year>1995 | gwno==712 & year<1992 | gwno==712 & year>1999 | gwno==731 & year>1960 & year<1996 | gwno==731 & year>1999 | gwno==750 & year>1961 & year<1965 | gwno==750 & year>1970 & year<1992 | gwno==775 & year>1961 & year<1965 | gwno==800 & year>1961 & year<1965 | gwno==811 & year>1961 & year<1965 | gwno==816 & year>9161 & year<1965 | gwno==816 & year>1977 & year<1992 | gwno==817 & year>1961 & year<1965
gen china_ally = 0 
replace china_ally = 1 if gwno==2 & year>1961 & year<1965 | gwno==20 & year>1961 & year<1965 | gwno==200 & year>1961 & year<1965 | gwno==220 & year>1961 & year<1965 | gwno==290 & year>1961 & year<1965 | gwno==365 & year>1944 & year<1981 | gwno==365 & year>1995 | gwno==630 & year>2001 | gwno==700 & year>1959 & year<1980 | gwno==700 & year>2001 | gwno==701 & year>2001 | gwno==702 & year>1995 | gwno==703 & year>1995 | gwno==704 & year>2000 | gwno==705 & year>1995 | gwno==731 & year>1960 | gwno==750 & year>1961 & year<1965 | gwno==770 & year>2001 | gwno==775 & year>1959 & year<1968 | gwno==800 & year>1961 & year<1965 | gwno==811 & year>1959 & year<1971 | gwno==816 & year>1961 & year<1965 | gwno==817 & year>1961 & year<1965
gen majorpower_ally = 0
replace majorpower_ally = 1 if us_ally == 1 | uk_ally == 1 | france_ally == 1 | russia_ally == 1 | china_ally == 1 

* Create dummy for countries with history of civil war 
egen incidence_ever = max(incidence), by(gwno)

* Create exile count variables (used for graphs in Appendix)
gen exile_culp = 0
replace exile_culp = 1 if exile==1 & culpable==1
replace exile_culp = . if exile==. | culpable==.
egen exile_culp_count = sum(exile_culp), by(year)
gen exile_nonculp = 0
replace exile_nonculp = 1 if exile==1 & culpable==0
replace exile_nonculp = . if exile==. | culpable==.
egen exile_nonculp_count = sum(exile_nonculp), by(year)
 
* Make final data more presentable
keep leadid gwno year ccname leader startobs endobs exile culpable culp_post98 post1998 culpablePITF culpPITF_post98 maxintyear domestic7 tenure idealpoint gwf_dem majorpower_ally incidence_ever exile_culp_count exile_nonculp_count
keep if year > 1959 & year < 2011
order leadid gwno ccname leader startobs endobs year exile culpable post1998 culp_post98 culpablePITF culpPITF_post98 tenure maxintyear idealpoint gwf_dem domestic7 majorpower_ally incidence_ever exile_culp_count exile_nonculp_count
sort gwno startobs
label variable leadid "leader identifier"
label variable gwno "country identifier"
label variable year "year"
label variable ccname "country name"
label variable leader "leader name"
label variable startobs "start of observation period"
label variable endobs "end of observation period"
label variable exile "exile dummy"
label variable culpable "leader culpability dummy"
label variable culp_post98 "interaction of culpable and post1998"
label variable post1998 "post-1998 dummy"
label variable culpablePITF "alternative leader culpabilty variable using PITF"
label variable culpPITF_post98 "interaction of culpablePITF and post1998"
label variable tenure "years leader has been in office"
label variable maxintyear "civil conflict intensity using battle deaths ordinal measure"
label variable domestic7 "revolutionary activity"
label variable idealpoint "western affinity"
label variable gwf_dem "democracy dummy"
label variable majorpower_ally "alliance with UNSC P5 member dummy"
label variable incidence_ever "civil conflict in post-WWII era dummy"
label variable exile_culp_count "count of culpable leaders going into exile each year"
label variable exile_nonculp_count "count of nonculpable leaders going into exile each year"
save "Replication Data.dta", replace
 
* Create separate dataset for change point analysis
logit exile i.year if culpable==1 
predict yhat1
replace yhat1=0 if yhat1==.
collapse yhat1, by(year)
label variable yhat1 "proportion of culpable ledaers going into exile each year"
save "Change Point Data.dta"
