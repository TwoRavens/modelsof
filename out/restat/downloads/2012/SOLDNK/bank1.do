* The Ticket to Easy Street?
* Scott Hankins, Mark Hoekstra, Paige Skiba
* April 12 2010

/* 
This do file merges the lottery, phonebook and bankruptcy data
if you have any questions, please contact me
* Scott Hankins
* University of Kentucky
* scott.hankins@gmail.com

*/


version 10
clear all
macro drop _all
capture log close
set mem 1g

log using bank1.smcl, replace


/*
loads the FL lottery data

generates 
    indicators of the game played (lotto, fantasy5)
    5 digit zip codes (zip5)
    
- merge phonebook (unique names at county level) with lottery (fl_lottery.dta) using first/last/county
    save as fl_lottery_phone.dta

- save the bankruptcy data with only name, county, state, zip, date filed, case_id
- clean county names
- saves the whole bankruptcy data as fl_bankruptcy_complete.dta
- reshape then save as fl_bankruptcy.dta
- merge with fl_lottery.dta

- adjusts lottery amounts for inflation
    ftp://ftp.bls.gov/pub/special.requests/cpi/cpiai.txt
    *  CPI numbers (Annual Averages)
    *  1988  118.3  207.3/118.3 = 1.7523
    *  1989  124.0  1.6718
    *  1990  130.7  1.5861
    *  1991  136.2  1.522
    *  1992  140.3  1.4775
    *  1993  144.5  1.4346
    *  1994  148.2  1.3988
    *  1995  152.4  1.3602
    *  1996  156.9  1.3212
    *  1997  160.5  1.2916
    *  1998  163.0  1.2718
    *  1999  166.6  1.2443
    *  2000  172.2  1.2038
    *  2001  177.1  1.1705
    *  2002  179.9  1.1523
    *  2003  184.0  1.1266
    *  2004  188.9  1.0974
    *  2005  195.3  1.0614
    *  2006  201.6  => 207.3/201.6 = 1.0283
    *  2007  207.3  => 207.3/207.3 = 1.0000

- saves merged data as lottery_bankruptcy_county.dta

*/

* change this to the directory where the data is stored 
local data_dir = "/media/disk/complete_bank/data"


*the data has fixed width fields so this works and it avoids the few misplaced typos (commas) in the city names
infix str name 1-44 str city 46-63 str zip 65-74 str draw_date 76-85 str claim_date 87-96 str game_type 98-108 str game_name 110-124 amount 127-139 using `data_dir'/FL_lottery_88_08.txt
duplicates drop

*some zip codes are 9 digit, gen 5 digit zip code 
gen zip5 = regexs(1) if regexm(zip, "^([0-9][0-9][0-9][0-9][0-9])")

gen draw_date1 = date(draw_date, "MDY")
format draw_date1 %d
gen claim_date1 = date(claim_date, "MDY")
format claim_date1 %d

drop draw_date claim_date
rename draw_date1 draw_date
rename claim_date1 claim_date

* it looks like some of the drawing and claim dates got reversed (i.e. drawing after claim)
gen temp = claim_date
replace claim_date = draw_date if claim_date < draw_date
replace draw_date = temp if temp < draw_date
drop temp

gen draw_year = year(draw_date)

gen lotto = game_name == "LOTTO"
gen fantasy5 = game_name == "FANTASY5"

* remove the .'s
gen new_name = subinstr(name , "." , "" , .)
* remove any ('s
replace new_name = subinstr(new_name, "(" , "" , .)
replace new_name = subinstr(new_name, ")" , "" , .)
* strip out JR, SR,...
replace new_name=regexr(new_name, " JR|SR|III|II|MD|111|3rd|2nd " ,"")
* some of the names have just one letter at the end of the name
replace new_name=regexr(new_name, " [A-Z]$" ,"")
* trims off trailing spaces at the end of a name
replace new_name=rtrim(new_name)
* trim leading spaces
replace new_name=ltrim(new_name)
* trim double spaces
replace new_name = itrim(new_name)
* some of the letter O are number 0 
replace new_name = subinstr(new_name , "0" , "O" , .)
* replace ` with '
replace new_name = subinstr(new_name , "`" , "'" , .)

gen first = regexs(1) if regexm(new_name, "^([A-Z]*) +")
replace first = regexs(1) if regexm(new_name, "^([A-Z]*\-*[A-Z]*) +") & first == ""
replace first = regexs(1) if regexm(new_name, "^([A-Z]*'*[A-Z]*) +") & first == ""

gen last = regexs(1) if regexm(new_name, " +([A-Z']+)$")
replace last = regexs(1) if regexm(new_name, "([A-Z]*\-[A-Z]*)$") & last == ""
replace last = regexs(1) if regexm(new_name, "([A-Z]*'[A-Z]*)$") & last == ""

gen first_length = length(first)
gen last_length = length(last)

replace first = upper(first)
replace last = upper(last)

count

drop if first_length <=2
drop if last_length <=2
drop first_length last_length

drop if city == ""

/* merge county names using zips */
drop if zip5 == ""
sort zip5
merge zip5 using `data_dir'/fl_zips, nokeep _merge(merge_county) keep(county)
tab merge_county

replace county = upper(county)

* there are 2 different phonebook datasets because the names were looked up based on the game won
/* merge county phone data */
sort first last county
merge first last county using `data_dir'/county_phone_results.dta, _merge(county_phone_merge) nokeep uniqusing keep(county_phone_num)
tab county_phone_merge

/*merge county LOTTO phone data  */
sort first last county lotto
merge first last county lotto using `data_dir'/county_phone_lotto.dta, uniqusing _merge(lotto_phone_merge) keep(lotto_phone_num)
tab lotto_phone_merge

replace county_phone_num = lotto_phone_num if county_phone_num == .
drop lotto_phone_num

* for name/county combinations that appear more than once, flag the first time someone won
bys first last county (draw_date): gen county_first_time = _n == 1
* flag unique winners at the county level
bys first last county: gen county_unique = _N==1

rename first fname
rename last lname

compress
save `data_dir'/fl_lottery.dta, replace

/***************   clean bankruptcy data    *******************/
clear
use fname lname state zip dfiled caseid1 addr1 partyseqno using `data_dir'/flbkcy.dta

* keep the 1st 2 observations for each filing, some are parties are spouses
bys caseid1 (partyseqno): keep if _n <=2

count

*only keep those observations for the 1st party in a case or 
* where both parties have the same adddress (assumed spouses)
duplicates tag caseid1 addr1, gen(tag)
bys caseid: gen one = 1 if _n==1
gen keep = one==1 | tag==1
tab keep
keep if keep == 1
count

drop keep one tag addr1

replace fname = upper(fname)
replace lname = upper(lname)

replace fname = regexr(fname, "\." , " ")
replace fname = regexr(fname, "\." , " ")
replace fname = regexr(fname, "\." , " ")
replace fname = regexr(fname, "\." , " ")
replace fname = regexr(fname, "\." , " ")
replace fname = regexr(fname, "," , " ")

* some first names have initials or 2 names, use only the first letters
gen new = regexs(0) if regexm(fname, "(^[A-Z]+) ")
replace fname = new if new !=""
drop new

replace lname = regexr(lname, "\." , " ")
replace lname = regexr(lname, "\." , " ")
replace lname = regexr(lname, "\." , " ")
replace lname = regexr(lname, "\." , " ")
replace lname = regexr(lname, "\." , " ")
replace lname = regexr(lname, "," , " ")
replace lname = regexr(lname, "," , " ")

replace fname = trim(fname)
replace fname = itrim(fname)
replace lname = trim(lname)
replace lname = itrim(lname)

/***********  merge county names by zip code  *************************/
rename zip zip5
sort zip5
merge zip5 using `data_dir'/fl_zips.dta, uniqusing nokeep _merge(zip_merge) keep(county)
tab zip_merge

drop if fname == ""
drop if lname == ""
drop if county == ""
drop if state == ""
keep if (state == "FL" | state == "Fl")

replace county = upper(county)

compress
gen year_filed = year(dfiled)
tab year_filed

/**************     make county level data     **************************/
drop if length(fname) <=2
drop if length(lname) <=2

duplicates report fname lname county

gen id = _n
bys fname lname county: replace id = id[1]
bys id (dfiled): gen order = _n
bys id: gen total_cases = _N

* only keep the first 10 cases for each name/county combination
drop if total_cases >10

drop zip5 state partyseqno

sort id (order)
reshape wide dfiled year_filed caseid1, i( id ) j( order )

drop id

compress
sort fname lname county
save `data_dir'/fl_bankruptcy_county.dta, replace


/***********  merge lottery/phone and bankruptcy    *********************/
clear
use `data_dir'/fl_lottery.dta
sort fname lname county
merge fname lname county using `data_dir'/fl_bankruptcy_county.dta, _merge(bank_merge) uniqusing nokeep 
tab bank_merge

**********************************************************
gen double cpi_amount=0
replace cpi_amount=amount*1.7523 if draw_year==1988
replace cpi_amount=amount*1.6718 if draw_year==1989
replace cpi_amount=amount*1.5861 if draw_year==1990
replace cpi_amount=amount*1.522  if draw_year==1991
replace cpi_amount=amount*1.4775 if draw_year==1992
replace cpi_amount=amount*1.4346 if draw_year==1993
replace cpi_amount=amount*1.3988 if draw_year==1994
replace cpi_amount=amount*1.3602 if draw_year==1995
replace cpi_amount=amount*1.3212 if draw_year==1996
replace cpi_amount=amount*1.2916 if draw_year==1997
replace cpi_amount=amount*1.2718 if draw_year==1998
replace cpi_amount=amount*1.2443 if draw_year==1999
replace cpi_amount=amount*1.2038 if draw_year==2000
replace cpi_amount=amount*1.1705 if draw_year==2001
replace cpi_amount=amount*1.1523 if draw_year==2002
replace cpi_amount=amount*1.1266 if draw_year==2003
replace cpi_amount=amount*1.0974 if draw_year==2004
replace cpi_amount=amount*1.0614 if draw_year==2005
replace cpi_amount=amount*1.0283 if draw_year==2006
replace cpi_amount=amount*1      if draw_year==2007

drop if draw_year == 2008

gen double amount_1000 = cpi_amount/1000
drop amount cpi_amount
rename amount_1000 amount

**********************************************************
forvalues i = 1/10 {
    gen diff`i' = dfiled`i' - draw_date
    }


* generate new difference between winning and bankruptcy
* pre_diff accounts for bankruptcy cases before winning
* post_diff accounts for bankruptcy cases after winning
forvalues i=1/10 {
    gen pre_diff`i' = diff`i'
    replace pre_diff`i' = . if pre_diff`i' > 0
    gen post_diff`i' = diff`i'
    replace post_diff`i' = . if post_diff`i' < 0
    }

* the pre or post differences are averaged for ease of coding
egen ave_pre_diff  = rowmean(pre_diff*)
egen ave_post_diff = rowmean(post_diff*)

* mark figured out which players had matched 5 numbers and which players had only played one time that day
*****  merge match5 and playedonce indicators  ****
sort draw_date amount
merge draw_date amount using `data_dir'/match5.dta, nokeep _merge(merge_match5) keep(match5 playedonce)
tab merge_match5
*********************************************************************************

compress
save `data_dir'/lottery_bankruptcy_county.dta, replace

log close

