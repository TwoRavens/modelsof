
clear 
set mem 2000m
set more off
set linesize 200


clear
use ./dta/region_xwalk
sort fipsStateCode fipsCountyCode
save ./dta/region_xwalk, replace



**
* 1980 pub year version, get rid of everything after County, Co. and UPPERCASE everything
**
clear
insheet using ./dta/countyr.csv
drop statecode1
replace county = upper(county)
replace county = substr(county, 1, strpos(county, "COUNTY") - 1) if strpos(county, "COUNTY") > 0
replace county = substr(county, 1, strpos(county, "CO.") - 1) if strpos(county, "CO.") > 0
replace county = trim(county)
bys statecode county: keep if _n == 1
sort statecode county
save ./dta/countyr_1979.dta, replace

clear
insheet using ../AHA/aha_1980_raw.txt
desc, full
summ
gen orig_f = trim(f)
replace f = trim(f)
do facility_code_to_tech_dummy init
gen first_comma = 0
gen temp_var = .
gen length_f = length(f)
desc, full
forvalues t = 1(1)50 {
 replace temp_var = .
 replace first_comma = strpos(f, ",")
 replace temp_var = real(substr(f, 1, first_comma - 1)) if first_comma > 0
 replace f = substr(f, first_comma + 1, .) if first_comma > 0
 replace f = trim(f)
 replace length_f = length(f)
 ** tab length_f, missing
 qui do facility_code_to_tech_dummy update temp_var 
}

replace county = trim(county)
keep if county != ""

list county state in 1/10

rename state state_str
replace state_str = "DC" if state_str == "DISTRICT OF COLUMBIA"
sort state_str
capture drop _merge
merge state_str using ./dta/state_str_to_stcd, uniqusing
tab _merge, missing
tab state_str if _merge != 3, missing
keep if _merge == 3

replace county = trim(upper(county))

**
* manually fix county names
**
replace county = "BAY" if county == "BAY COUNTY"
replace county = "HIGHLANDS" if county == "HIGHLANDA"
replace county = "PINELLAS" if county == "PINEILAS"
replace county = "CHATTOOGA" if county == "CHATTOGA"
replace county = "MERIWETHER" if county == "MERLWETHER"
replace county = "MINIDOKA" if county == "MINLDOKA"
replace county = "PEORIA" if county == "PEORLA"
replace county = "HENDRICKS" if county == "HENDRLCKS"
replace county = "NICHOLAS" if county == "NICHOLES"
replace county = "ROCKCASTLE" if county == "ROCK CASTLE"
replace county = "NATCHITOCHES" if county == "NATCHLTOCHES PARISH"
replace county = "TENSAS" if county == "TENSAE PARISH"
replace county = "BERRIEN" if county == "BERRIAN"
replace county = "SHIAWASEE" if county == "SHLAWASSEE"
replace county = "LAC QUI PARLE" if county == "LAC QUI PARIE"
replace county = "CAPE GIRARDEAU" if county == "CAPE GLRARDEAU"
replace county = "ST.. LOUIS" if county == "ST.LOUIS"
replace county = "FERGUS" if county == "FERGUE"
replace county = "KEITH" if county == "KELTH"
replace county = "SAN MIGUEL" if county == "SAN MLGUEL"
replace county = "VALENCIA" if county == "VALENCLA"
replace county = "WILKES" if county == "WILKEE"
replace county = "STUTSMAN" if county == "STUTEMAN"
replace county = "STEPHENS" if county == "STEPHENE"
replace county = "CRAWFORD" if county == "CRAWTORD"
replace county = "INDIANA" if county == "INDIANS"
replace county = "LEHLGH" if county == "LEHLGH AND NORTHAMPTON"
replace county = "SCHUYLKILL" if county == "SCHUYLKLLL"
replace county = "DARLINGTON" if county == "DARLLNGTON"
replace county = "HAMBLEN" if county == "HAMBIEN"
replace county = "HUMPHREYS" if county == "HUMPHREYA"
replace county = "SEQUATCHIE" if county == "SEQUATCHLE"
replace county = "UNICOI" if county == "UNICOL"
replace county = "BLANCO" if county == "BLANCE"
replace county = "VAL VERDE" if county == "VAL VARDE"
replace county = "SPOKANE" if county == "SPKANE"
replace county = "ASHLAND" if county == "ASHIAND"
replace county = "JUNEAU" if county == "JUNSAU"
replace county = "ST.CROLX" if county == "ST. CROIX"
replace county = "ST. CROLX" if county == "ST. CROIX"


sort statecode county
capture drop _merge
merge statecode county using ./dta/countyr_1979, uniqusing
tab _merge, missing
tab statecode _merge, missing
sort statecode county

preserve
bys county _merge: keep if _n == 1
keep    if _merge == 1 | ///
   _merge[_n - 1] == 1 | ///
   _merge[_n + 1] == 1 

count if _merge == 1
count if _merge == 1 & countyr == ""
replace countyr = countyr[_n+1] if countyr[_n+1] == countyr[_n-1] & _merge == 1
replace countyr = countyr[_n+1] if strpos(county[_n+1], county) > 0 & _merge == 1
replace countyr = countyr[_n-1] if strpos(county[_n-1], county) > 0 & _merge == 1
count if _merge == 1
count if _merge == 1 & countyr == ""
sort statecode county
list statecode county _merge countyr /// 
 if (countyr == "" |  countyr[_n-1] == "" |  countyr[_n+1] == "")
keep if countyr != "" & _merge == 1

gen countyr2 = countyr
keep statecode county countyr2
sort statecode county
save ./tmp/county.dta, replace
restore

drop if _merge == 2

sort statecode county
capture drop _merge 
merge statecode county using ./tmp/county, uniqusing
replace countyr = countyr2 if countyr == "" & countyr2 != ""
drop if _merge == 2
drop countyr2

sort statecode
capture drop _merge
merge statecode using ./dta/statecode, uniqusing
tab statecode _merge, missing
keep if _merge == 3

sort stcd
capture drop _merge
merge stcd using ./dta/stcd, uniqusing
tab _merge
tab stcd _merge, missing
keep if _merge == 3

rename fstcd fipsStateCode

list county countyr in 1/10
replace countyr = upper(countyr)

drop county
rename countyr county
sort fipsStateCode county
capture drop _merge
merge fipsStateCode county using ./dta/fipscounties_1980, uniqusing
tab _merge, missing
tab fipsStateCode _merge, missing
drop if _merge == 2

/**
preserve
sort fipsStateCode county
list fipsStateCode county _merge fipsCountyCode if _merge != 3
restore
tab county if _merge != 3, missing
**/

rename fipsCountyCode fcounty

**
** store PUBLICATION YEAR
**
gen year = 1980
save ../AHA/1980pubr.dta, replace
count
**desc, full



clear
insheet using ./dta/countyr.csv
sort statecode county 
by statecode county: keep if _n == 1
save ./dta/countyr.dta, replace




**
* can assign county (using countyr) for 1979
**


clear 
set more off

clear
insheet using ./dta/countyr.csv
sort county 
by county: keep if _n == 1
save ./dta/countyr2.dta, replace



**
** pubr for 1979 pub year is a mess
**  use dictionary file instead
**
**forvalues year = 1967(1)1978 {
**foreach year of numlist 1967(1)1978 1980 {
foreach year of numlist 1967(1)1980 {
 **local year = 1980

  clear

  use ../AHA/`year'pubr
  
  di "***************"
  di "`year' ..."
  di "***************"
  count
  **desc

  local yr = `year' - 1 - 1900
  replace year = year - 1

  if (`year' != 1979) {
   rename totexp exptot
   rename payexp paytot
   replace exptot = exptot * 1000
   replace paytot = paytot * 1000

  }
  
  if (`year' != 1980) {
   rename bed    bdtot
   rename adm    admtot
   rename inpatcen ipdtot
   replace ipdtot = ipdtot * 365
  }
  else {
   gen ipdtot = .
   rename bed bed_str
   gen bdtot = real(bed_str)
  }

  if (`year' <= 1978) {
    replace county = trim(county)

    /**
    replace county = "Orange ()" if county == "Orange"
    replace county = "DC ()" if county == "DC"
    local regex = "^(.+)\(";
    gen county_str = regexs(1) if regexm(county, "`regex'")
    replace county_str = trim(county_str)
    local regex = "^(.+)\(";
    replace county_str = regexs(1) if regexm(county_str, "`regex'")
    replace county_str = trim(county_str)
    **/

    sort statecode county
    capture drop _merge 
    merge statecode county using ./dta/countyr, uniqusing

    tab _merge
    drop if _merge == 2

    preserve
    keep if _merge == 3
    drop _merge
    save /tmp/m3, replace
    restore

    keep if _merge == 1
    sort county
    drop statecode* 
    capture drop _merge 
    merge county using ./dta/countyr2, uniqusing
    drop if _merge == 2
    tab _merge
    keep if _merge == 3
   
    append using /tmp/m3

   }

   if (`year' <= 1979) {
    capture drop county
    rename countyr county

    sort statecode
    capture drop _merge
    merge statecode using ./dta/statecode, uniqusing
    tab _merge
    assert( _merge == 3)
    drop _merge

    sort stcd
    capture drop _merge
    merge stcd using ./dta/stcd, uniqusing
    tab _merge
    assert( _merge == 3)
    drop _merge
    rename fstcd fipsStateCode

    replace county = "Statewide" if county == "Independent" | county == "DC" | county == ""
    replace county = "St. " + substr(county, 4, .) if strpos(county, "St ") == 1

    sort fipsStateCode county    
    capture drop _merge
    merge fipsStateCode county using ./dta/fipscounties, uniqusing
    tab _merge
    drop if _merge == 2 | fipsStateCode == 2
    list county* statecode* if _merge == 1
    keep if _merge == 3
    drop _merge

    rename fipsCountyCode fcounty
  }

  if (`year' != 1979) {
   rename control cntrl
   replace cntrl = 40 if cntrl == 3
   replace cntrl = 10 if missing(cntrl)

   rename service serv
   replace serv = 10 if serv == 1
   replace serv = 10 if missing(serv)
  }

  if (`year' <= 1979) {
   rename stay short_term
   replace short_term = 0 if short_term > 1 & short_term < .
   replace short_term = 1 if missing(short_term)

   count if missing(id)
   assert r(N) < 10
   assert(id < 10000 | missing(id))
  }
  else {
   gen id = _n
   rename stay short_term_str
   gen short_term = (short_term_str != "l")
   rename fte paidpers
  }

  if (`year' >= 1970) {
    rename paidpers fte
    drop fipsStateCode
    keep year id stcd *county exptot paytot admtot ipdtot bdtot cntrl serv short_term *tot fte *name*
  }
  else {
   drop fipsStateCode
   keep year id stcd *county exptot paytot admtot ipdtot bdtot cntrl serv short_term *tot *name*
  }
      
  save /tmp/aha`yr', replace

  **
  * NOTE: Figure out why the exptot/paytot missings
  *   exist
  **
  count
  summ exptot paytot
  gen exp_missing = (exptot == .)
  tab stcd exp_missing
}




/**
 **
 *
 * NOT using electronic files for 73-79
 *  using Amy's PAPER DATA instead
 *   (we use this because it has LPN's, RN's, NPAYDPR, NPAYINT)
foreach y of numlist 78 {
clear
infix using ../AHA/aha19`y'.dct
gen year = 19`y'
gen fcounty = .

replace fcounty = mcounty if fcounty == .

rename los short_term
replace short_term = 0 if short_term > 1 & short_term < .
replace short_term = 1 if missing(short_term)

save /tmp/aha`y'.dta, replace

*di "***************"
*di "year `y' ..."
*desc
summ *
}
 **
 **/





foreach y of numlist 80(1)105 {
  clear
  local year = `y'
  if (`y' > 99) {
    local temp = `y' - 100
    use "../AHA/aha0`temp'.dta"
  }
  else {
   use "../AHA/aha`year'.dta"
  }


  di "***************"
  di "`year' ..."
  di "***************"

  desc 

  rename id id_str
  count if length(id_str) != 7
  assert r(N) < 5
  drop if length(id_str) != 7
  gen id = real(substr(id_str, 4, .))

  count if missing(id)
  assert r(N) < 30
  assert(id < 10000 | missing(id))

  gen year = 1900 + `y'


  if (`y' == 90) {
   preserve
   keep *county 
   sort mcounty
   save aha_fips_counties.dta, replace
   restore
  }

  if (`y' <= 89 | `y' == 93) { 
    capture gen fcounty = .
    capture replace fcounty = real(mcounty) if fcounty == .
    capture replace fcounty = mcounty if fcounty == .
  }
  else {   
    if (`y' <= 94) {
    rename fcounty fcounty_str
    gen fcounty = real(fcounty_str)
    }
    else {
    rename fcounty fcounty_str
    gen fcounty = real(fcounty_str)
    }
  }

  ** where are these values?
  if (`y' >= 94) {
   di "looking for DEPRECIATION! ..."
   capture di *dpr* *int*
   gen npaydpr = .
   gen npayint = .
  }

  if (`y' >= 97 | `y' == 84) { 
    rename stcd stcd_str
    gen byte stcd = real(stcd_str)
  }

  rename los short_term
  replace short_term = 0 if short_term > 1 & short_term < .

  if (`y' == 80) {
    gen pttot = .
  }

  if (`y' >= 85 & `y' <= 89) { 
   desc year  *county 
   capture drop stcd  
   gen stcd = real(substr(id_str, 2, 2))
   keep year id stcd *county exptot paytot admtot ipdtot bdtot short_term cntrl serv *npaydpr* *npayint* fttot pttot fte ftelpn ftern *name*
    **  ftlpn ftrn ptelpn ptern ptlpn ptrn
  }
  else {
   desc year *stcd  *county 
   *tab stcd
   keep year id stcd *county exptot paytot admtot ipdtot bdtot short_term cntrl serv *npaydpr* *npayint* fttot pttot fte ftelpn ftern *name*
    ** ftlpn ftrn ptelpn ptern ptlpn ptrn
  }
  save ./tmp/aha`y', replace
}

clear

di "STARTING APPEND ..."
use ./tmp/aha66.dta
foreach y of numlist 67(1)105 {
**foreach y of numlist 67(1)78 80(1)105 {
**foreach y of numlist 67(1)78 80(1)96 {
**foreach y of numlist 67(1)96 {
 di "appending year `y' ..."
 append using "./tmp/aha`y'.dta"
}
di "FINISHED APPEND!"



capture drop _merge
sort stcd
merge stcd using stcd, uniqusing
tab _merge

** should show only stcd < 9 (territories) not matching
tab year if _merge == 1
tab stcd if _merge == 1

drop if _merge != 3
drop _merge

rename fstcd fipsStateCode
rename fcounty fipsCountyCode

tab year 

sort fipsStateCode fipsCountyCode
replace fipsCountyCode = fipsCountyCode - 1000*(floor(fipsCountyCode / 1000))

*drop if cntrl > 40
*keep if serv == 10
*save myaha_restricted.dta, replace
*exit

save ./AHA/myaha, replace

exit





exptot for all years
cntrl (drop if > 40)
serv (keep if 10

(1999-02)
cmsacd          str2   %2s                    consolidated metropolitan
msacd           str4   %4s                    metropolitan statistical
mcntycd         str3   %3s                    modified f.i.p.s. county code
fcounty         str5   %5s                    fips state and county code
fstcd           str2   %2s                    fips state code
fcntycd         str3   %3s                    fips county code
cityrk          float  %9.0g                  ranking of 100 largest cities

(1980, 1989, 1990,91,92)
hsa             str5   %9s                    health service area code
mcsanm          str2   %9s                    consolidated metropolitan
                                                statistical area code
mmsanm          str4   %9s                    metropolitan statistical area
                                                code
mcounty         int    %8.0g                  modified F.I.P.S. county code
cityrk          long   %12.0g                 ranking on 100 largest cities
                                                (based on 1980 census)
msmsas          int    %8.0g                  metropolitan statistical area
                                                size

(1981)
mcounty         int    %8.0g                  modified f.i.p.s. county code
                                                (*)
mcsanm          byte   %8.0g                  standard consolidated
                                                statistical
msmsanm         int    %8.0g                  standard metropolitan
                                                statistical
msmsas          byte   %8.0g                  standard metropolitan
cityrk          byte   %8.0g                  ranking of 100 largest cities
                                                statistical
mname           str30  %30s                   name of hospital
mlocad1         str30  %30s                   administrator's name
mlocad2         str30  %30s                   street address
mloccty         str20  %20s                   city
mlocsta         str2   %2s                    state code (#)
mloczip         str5   %5s                    zip code
area            int    %8.0g                  area code
telno           long   %12.0g                 local number
resp            byte   %8.0g                  response code (1=yes  2=no)



(1982)
hsa             str5   %9s                    health service area code
mcsanm          str2   %9s                    consolidated metropolitan
                                                statistical area code
mmsanm          str4   %9s                    metropolitan statistical area
                                                code
  (LEADING ZEROES)
mcounty         str3   %9s                    modified F.I.P.S. county code
cityrk          long   %12.0g                 ranking on 100 largest cities
                                                (based on 1980 census)
msmsas          int    %8.0g                  metropolitan statistical area
                                                size
