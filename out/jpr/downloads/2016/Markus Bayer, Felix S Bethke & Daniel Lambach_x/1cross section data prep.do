***Set Working Directory
clear
cd "D:\Felix\JPR\replication files"

**Ulfelder Data
insheet using "Ulfelder sample.csv", comma clear
gen regdur=(end-begin)+1

**Gen ID-variables
ssc install kountry
kountry country, from(other) stuck marker
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown)
rename _COWN_ ccode
replace ccode =482 if country=="CAR"
replace ccode =484 if country=="Congo-Brazzaville"
replace ccode =315 if country=="Czechoslovakia"
replace ccode =713 if country=="Taiwan"
replace ccode =345 if country=="Yugoslavia, Former"
drop iso3n MARKER
egen regid = group(ccode begin)

**gen resistance variables
rename methodrevised RC
gen RCnum =.
replace RCnum=0 if RC=="."
replace RCnum=1 if RC=="V"
replace RCnum=2 if RC=="NV"

gen RCdum =.
replace RCdum=0 if RCnum==0
replace RCdum=0 if RCnum==1
replace RCdum=1 if RCnum==2

save "Ulfelderdata.dta", replace
clear

***adding Covariates
**GDPpc
import delimited "gdpv6.txt", delimiter(tab) varnames(1) clear
rename statenum ccode
rename year begin
sort ccode begin
tsset ccode begin, yearly
gen lrgdppc=log(rgdppc)
gen Llrgdppc=l.lrgdppc
*adjust values for Georgia and Azerbaijan
replace Llrgdppc=lrgdppc if Llrgdppc==.
keep ccode begin Llrgdppc lrgdppc
save "gdpmerge.dta", replace
clear

**Population Data
import delimited "NMC_v4_0.csv", delimiter(comma) varnames(1) clear
rename year begin
sort ccode begin
tsset ccode begin, yearly
replace tpop=. if tpop==-9
replace upop=. if upop==-9
*ipolate data for syria
tsfill
bysort ccode: ipolate tpop begin, g(tpop2)
bysort ccode: ipolate upop begin, g(upop2)
replace tpop=tpop2 if tpop==.
replace upop=upop2 if upop==.
drop tpop2 upop2
gen Ltpop=l.tpop
gen ltpop=log(tpop+0.0001)
gen Lltpop=log(Ltpop+0.0001)
gen up=upop/tpop
gen Lup=l.up
keep ccode begin tpop upop Ltpop Lltpop Lup
save "popmerge.dta", replace
clear

**Previous Instabillity
import delimited "rgj2010.csv", delimiter(comma) varnames(1) clear
rename cowcode ccode
replace ccode=816 if pitfcode=="DRV" & year<=1976
replace ccode=530 if pitfcode=="ETH" & year<=1992
replace ccode=530 if pitfcode=="ETI" & year>=1993
replace ccode=260 if pitfcode=="GFR" & year<=1989
replace ccode=260 if pitfcode=="GER" & year>=1990
replace ccode=770 if pitfcode=="PKS" & year<=1971
replace ccode=770 if pitfcode=="PAK" & year>=1972
replace ccode=365 if pitfcode=="RUS" & year>=1992
replace ccode=345 if pitfcode=="SRB" & year>=2007
replace ccode=365 if pitfcode=="USS" & year<=1991
replace ccode=816 if pitfcode=="VIE" & year>=1976
replace ccode=678 if pitfcode=="YAR" & year<=1990
replace ccode=678 if pitfcode=="YEM" & year>=1991
replace ccode=345 if pitfcode=="YGS" & year>=1992 & year<=2006
replace ccode=345 if pitfcode=="YUG" & year<=1991
replace ccode=816 if pitfcode=="DRV" & year==1976
replace ccode=260 if pitfcode=="GFR" & year==1990
replace ccode=365 if pitfcode=="RUS" & year==1991
replace ccode=345 if pitfcode=="SRB" & year==2006
replace ccode=678 if pitfcode=="YEM" & year==1990
replace ccode=345 if pitfcode=="YUG" & year==1992
drop if ccode==.
keep ccode pitfcode year rgjtadt rgjtdat
rename year begin
gen previnst=rgjtadt + rgjtdat
drop rgjtadt rgjtdat
save "previnst.dta", replace
clear

**Diffusion
import delimited "rgj2010.csv", delimiter(comma) varnames(1) clear
rename cowcode ccode
replace ccode=816 if pitfcode=="DRV" & year<=1976
replace ccode=530 if pitfcode=="ETH" & year<=1992
replace ccode=530 if pitfcode=="ETI" & year>=1993
replace ccode=260 if pitfcode=="GFR" & year<=1989
replace ccode=260 if pitfcode=="GER" & year>=1990
replace ccode=770 if pitfcode=="PKS" & year<=1971
replace ccode=770 if pitfcode=="PAK" & year>=1972
replace ccode=365 if pitfcode=="RUS" & year>=1992
replace ccode=345 if pitfcode=="SRB" & year>=2007
replace ccode=365 if pitfcode=="USS" & year<=1991
replace ccode=816 if pitfcode=="VIE" & year>=1976
replace ccode=678 if pitfcode=="YAR" & year<=1990
replace ccode=678 if pitfcode=="YEM" & year>=1991
replace ccode=345 if pitfcode=="YGS" & year>=1992 & year<=2006
replace ccode=345 if pitfcode=="YUG" & year<=1991
replace ccode=816 if pitfcode=="DRV" & year==1976
replace ccode=260 if pitfcode=="GFR" & year==1990
replace ccode=365 if pitfcode=="RUS" & year==1991
replace ccode=345 if pitfcode=="SRB" & year==2006
replace ccode=678 if pitfcode=="YEM" & year==1990
replace ccode=345 if pitfcode=="YUG" & year==1992
drop if ccode==.
save "diffusion.dta", replace
clear
import delimited "qog_std_cs_jan15.csv", delimiter(comma) varnames(1) clear
keep ccodecow cname ht_region
rename ccodecow ccode
save "region.dta", replace
clear
use "diffusion.dta", clear
sort ccode 
merge m:1 ccode using "region.dta"
replace ht_region=7 if ccode==817 
replace ht_region=3 if ccode==680 
replace ht_region=3 if ccode==678 
replace ht_region=1 if ccode==347 
replace ht_region=1 if ccode==345
replace ht_region=1 if ccode==315
replace ht_region=5 if ccode==260
replace ht_region=5 if ccode==265
drop if _m==2
drop _m
*proportion democratic
gen aut=0
replace aut=1 if rgjtype=="A"
gen dem=0
replace dem=1 if rgjtype=="D"
bysort ht_region year: egen demcount = sum(dem)
bysort ht_region year: egen autcount = sum(aut)
gen regbyregion = autcount+demcount
gen propdem = (demcount/regbyregion)*100
replace propdem=0 if propdem==.
keep ccode year cname ht_region propdem
duplicates drop ccode year, force
tsset ccode year, yearly
gen Lpropdem=l.propdem
save "diffusion.dta", replace
clear
*fill in missing values for Lpropdem for indonesia in 1955 with Boix-Miller-Rosato data
use democracy-v2.0.dta, clear
drop if year<1950
merge m:1 ccode using "region.dta"
replace ht_region=7 if ccode==817 
replace ht_region=3 if ccode==680 
replace ht_region=3 if ccode==678 
replace ht_region=1 if ccode==347 
replace ht_region=1 if ccode==348
replace ht_region=1 if ccode==342
replace ht_region=1 if ccode==364
replace ht_region=4 if ccode==529
replace ht_region=8 if ccode==769
replace ht_region=7 if ccode==818
replace ht_region=1 if ccode==345
replace ht_region=1 if ccode==315
replace ht_region=5 if ccode==260
replace ht_region=5 if ccode==265
drop if _m==2
drop _m
gen aut=0
replace aut=1 if democracy==0
gen dem=0
replace dem=1 if democracy==1
bysort ht_region year: egen demcount = sum(dem)
bysort ht_region year: egen autcount = sum(aut)
gen regbyregion = autcount+demcount
gen propdem = (demcount/regbyregion)*100
replace propdem=0 if propdem==.
tsset ccode year, yearly
gen Lpropdem2=l.propdem
keep if ccode==850 & year>1950 & year<1960
keep ccode year Lpropdem2
save "diffusionindo.dta", replace
use "diffusion.dta", clear
sort ccode year
merge 1:1 ccode year using "diffusionindo.dta"
replace Lpropdem=Lpropdem2 if Lpropdem==.
drop if _m==2
drop _m
drop Lpropdem2
rename year begin
save "diffusion.dta", replace
clear

**previous regime
*Because of differences in the timing of transition events between Ulfelder and GWF this data was coded manualy and not merged
use "Ulfelderprevaut2.dta", clear
save "prevaut.dta", replace


*combine covariates
*prevaut
use "Ulfelderdata.dta", clear
sort ccode begin
merge 1:1 country begin using "prevaut.dta"
drop if _m==2
drop _m
save "Ulfelderdatafinal.dta", replace
*gdp
use "Ulfelderdatafinal.dta", clear
sort ccode begin
merge 1:n ccode begin using "gdpmerge.dta"
drop if _m==2
drop _m
save "Ulfelderdatafinal.dta", replace
*pop
use "Ulfelderdatafinal.dta", clear
sort ccode begin
merge 1:n ccode begin using "popmerge.dta"
drop if _m==2
drop _m
save "Ulfelderdatafinal.dta", replace
*prev instabillity
use "Ulfelderdatafinal.dta", clear
merge 1:n ccode begin using "previnst.dta"
drop if _m==2
drop _m
save "Ulfelderdatafinal.dta", replace
*diffusion
use "Ulfelderdatafinal.dta", clear
merge 1:n ccode begin using "diffusion.dta"
drop if _m==2
drop _m
save "Ulfelderdatafinal.dta", replace
*clean up
drop ht_region pitfcode cname
save "Ulfelderdatafinal.dta", replace
clear

***Geddes et al. Data
insheet using "GWF sample.csv", comma clear
drop v6 v7 v8 v9
drop if regimetype != "democracy"
drop regimetype
destring end, generate(end2)
drop end
rename end2 end
gen failure=0
replace failure = 1 if end !=.
gen censoring=0
replace censoring=1 if failure==0
replace end=2010 if end==.
*adjustments and censoring for Czechoslovakia 
replace failure=0 if country=="Czechoslovakia" & begin==1990
replace censoring=1 if country=="Czechoslovakia" & begin==1990
replace end=1992 if country=="Czechoslovakia" & begin==1990
replace end=2006 if casename=="Serbia 00-NA" 
replace failure=0 if casename=="Serbia 00-NA" 
replace censoring=1 if casename=="Serbia 00-NA" 
gen regdur=(end-begin)+1
*droping regimes <1955
drop if begin <1955
drop if begin >2006

**Add campaign data
sort casename
merge 1:1 casename using "GWFcampaign.dta"
*dropping transitions related to independence or new countries
drop if _m==1
drop _m
save "GWFdata.dta", replace
*id variable
kountry country, from(other) stuck marker
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown)
rename _COWN_ ccode
replace ccode=484 if casename=="Congo-Brz 92-97"
replace ccode =713 if casename=="Taiwan 00-NA"
replace ccode =315 if casename=="Czechoslovakia 89-93"
drop iso3n MARKER
egen regid = group(ccode begin)

**gen resistance variables
gen RCnum =.
replace RCnum=0 if RC=="none"
replace RCnum=1 if RC=="violent"
replace RCnum=2 if RC=="nonviolent"
gen RCdum =.
replace RCdum=0 if RCnum==0
replace RCdum=0 if RCnum==1
replace RCdum=1 if RCnum==2
save "GWFdata.dta", replace

**adding Covariates

*previous regime
use "GWF_AllPoliticalRegimes.dta", clear
rename year begin
rename cowcode ccode
sort ccode gwf_casename begin
keep ccode begin gwf_casename gwf_prior
rename gwf_casename casename
gen mil=0
replace mil=1 if gwf_prior=="military"
replace mil=1 if gwf_prior=="milpersonal"
replace mil=1 if gwf_prior=="indirect military"
drop gwf_prior
save "GWFprevaut.dta", replace

*Previous Instabillity
use "GWF_AllPoliticalRegimes.dta", clear
rename year begin
rename cowcode ccode
sort ccode begin
*Download btscs.ado from https://www.prio.org/Data/Stata-Tools/ before proceding
btscs gwf_fail begin ccode, g(peaceyrs) failure
drop peaceyrs _tuntilf _frstfl
rename _prefail previnst
save "GWFprevinst.dta", replace

*Generate proportion of democratic countries in a region 
use "GWF_AllPoliticalRegimes.dta", clear
rename cowcode ccode
merge m:1 ccode using "region.dta"
drop if _m==2
drop _m
replace ht_region=5 if ccode==265
replace ht_region=1 if ccode==315
replace ht_region=1 if ccode==345
replace ht_region=3 if ccode==678 
replace ht_region=3 if ccode==680 
replace ht_region=7 if ccode==817 
gen aut=0
replace aut=1 if gwf_regimetype !="NA"
gen dem=0
replace dem=1 if gwf_nonautocracy=="democracy"
bysort ht_region year: egen demcount = sum(dem)
bysort ht_region year: egen autcount = sum(aut)
gen regbyregion = autcount+demcount
gen propdem = (demcount/regbyregion)*100
replace propdem=0 if propdem==.
keep ccode year gwf_casename propdem
tsset ccode year, yearly
gen Lpropdem=l.propdem
save "GWFdiffusion.dta", replace
**Fill in missing data for Moldova using Boix-Miller-Rosato Data
use "democracy-v2.0.dta", clear
drop if year<1950
merge m:1 ccode using "region.dta"
replace ht_region=7 if ccode==817 
replace ht_region=3 if ccode==680 
replace ht_region=3 if ccode==678 
replace ht_region=1 if ccode==347 
replace ht_region=1 if ccode==348
replace ht_region=1 if ccode==342
replace ht_region=1 if ccode==364
replace ht_region=4 if ccode==529
replace ht_region=8 if ccode==769
replace ht_region=7 if ccode==818
replace ht_region=1 if ccode==345
replace ht_region=1 if ccode==315
replace ht_region=5 if ccode==260
replace ht_region=5 if ccode==265
drop if _m==2
drop _m
gen aut=0
replace aut=1 if democracy==0
gen dem=0
replace dem=1 if democracy==1
bysort ht_region year: egen demcount = sum(dem)
bysort ht_region year: egen autcount = sum(aut)
gen regbyregion = autcount+demcount
gen propdem = (demcount/regbyregion)*100
replace propdem=0 if propdem==.
tsset ccode year, yearly
gen Lpropdem2=l.propdem
keep if ccode==359 & year>1990 & year<1993
keep ccode year Lpropdem2
save "GWFdiffusionmol.dta", replace
use "GWFdiffusion.dta", clear
sort ccode year
merge 1:1 ccode year using "GWFdiffusionmol.dta"
replace Lpropdem=Lpropdem2 if Lpropdem==.
drop if _m==2
drop _m
drop Lpropdem2
save "GWFdiffusion.dta", replace

**combining covariates
*prevaut
use "GWFdata.dta", clear
merge 1:1 casename begin using "GWFprevaut.dta"
drop if _m==2
drop _m
save "GWFdatafinal.dta", replace
*gdp
use "GWFdatafinal.dta", clear
sort ccode begin
merge 1:n ccode begin using "gdpmerge.dta"
drop if _m==2
drop _m
save "GWFdatafinal.dta", replace
*pop
use "GWFdatafinal.dta", clear
sort ccode begin
merge 1:n ccode begin using "popmerge.dta"
drop if _m==2
drop _m
save "GWFdatafinal.dta", replace
*prev instabillity
use "GWFdatafinal.dta", clear
merge 1:n ccode begin using "GWFprevinst.dta"
drop if _m==2
drop _m
save "GWFdatafinal.dta", replace
*diffusion
use "GWFdatafinal.dta", clear
rename begin year
merge 1:1 ccode year using "GWFdiffusion.dta"
drop if _m==2
drop _m
rename year begin
save "GWFdatafinal.dta", replace
*clean up 
drop gwf_*
save "GWFdatafinal.dta", replace


