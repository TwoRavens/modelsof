/*
This will add msa codes to round info, using the firm file

The file Òround.dtaÓ does not include MSA codes for the investments, 
but the file containing info about the firms, "fund.dtaÓ does. 
So we link the MSA codes from the company file to the round file, 
dropping all unknown MSAs and foreign ones in the process. Hence,
we assign each investment to the locations of the investing firms, 
not to the location of the target company.
*/



// Local macros
local vcdir "~/Files/Research/Data/VentureXpert2006"
local censusdir "SBA"
local geodir "Geography"
tempfile temp


/*
// Get MSA codes from fund.dta
// First drop foreign funds and those with unknown MSA
// Next change the variable name to msacode to match the info in later files
// Then drop all other variables and prepare for merge
*/

use "`vcdir'/fund.dta", clear
drop if fundmsacode == 0
drop if fundmsacode == 9999
rename fundmsacode msacode
keep fundid msacode
sort fundid
save vcmsa.dta, replace


// Merge round data with previous file to add MSA code info to rounds
// Drop all obs not in both originals, i.e., rounds for which we don't
// have an MSA code or MSA codes for which we don't have rounds (none).


use "`vcdir'/round.dta", clear
sort fundid
merge fundid using vcmsa.dta
drop if _merge != 3
drop _merge
save vcmsa.dta, replace


// We now have round info for all rounds that can be linked to MSAs

/*
This will find VC funds and the link those with the round info
dropping all others.

Since weÕre interested in VC activity, we need to identify all VC 
rounds in the data. The way we do this is we go to the Òfund.dtaÓ 
file that contains info on all the funds and find all funds that match
our criteria. We then link this to the round information and drop all 
rounds where a VC fund did not participate. Hence, there could be others 
participating in the same round, but as long as the round has one VC 
in it, we count it.

The criteria we use is
- fundstagefocus = "Balanced Stage", "Development", "Expansion", "Later Stage", 
                   "Early Stage", or "Seed Stage"
Additionally for both of these, we also identify the subset that are private, i.e.,
fundtypeshortdescription = "PRIV".

*/


// Get the fund data
use "`vcdir'/fund.dta", clear


// Identify VCs based on stage
gen stage         = 1 if fundstagefocus == "Seed Stage"
replace stage     = 1 if fundstagefocus == "Development"
replace stage     = 1 if fundstagefocus == "Early Stage"
replace stage     = 1 if fundstagefocus == "Later Stage"
replace stage     = 1 if fundstagefocus == "Balanced Stage"
replace stage     = 1 if fundstagefocus == "Expansion"
replace stage     = 0 if stage == .

// Identify VCs based on stage and being private
gen stagepriv     = 1 if stage == 1 & fundtypeshortdescription == "PRIV"
replace stagepriv = 0 if stagepriv == .



// Now drop other variables, sort, and save as a temp file to be merged with round info
// keep fundid type typepriv stage stagepriv
keep fundid stage stagepriv
sort fundid
save "`temp'", replace



// Match that info with the round info from the first do-file, round info with
// company MSA codes added.
use vcmsa.dta
sort fundid
merge fundid using "`temp'"
drop if _merge!=3
drop _merge
save vcmsa.dta, replace

// We now have all rounds that were done by VCs and can be linked to MSAs


/*
This will calculate annual counts of VC investments by MSA

Now weÕre ready to calculate annual VC activity for each MSA. 
The previous steps have resulted in a file of round info that 
includes only rounds that can be 
linked to MSAs. 
 
First, we reduce to only one observation per round, so that the same round
is not calculated multiple times. We do this by coding a unique round identifier
from the companyid and rounddate, implicitly assuming that there never were two
rounds for the same company in the same day.

The basic idea then is to have each round carry the following info:
- the date, size, and MSA codes
- 0-1 identifier if the round was the first for the company or not
- 0-1 identifier for each of the VC definitions

We can then use these identifiers to calculate easily the numbers of rounds for
different VC definitions and, if multiplied by the roundsize, also for the money
totals.

This step needs a file (vcmsa.dta in current directory) that contains
info on rounds with the MSA codes and VC classification.
*/

// First we calculate the variables for Census years (Apr to Mar)
preserve

// Translate the date info from string into year number
// Here we need to follow the Census Bureau's data, since
// that goes from April to March. Hence, we code Jan-Mar to
// have been in the previous year.
gen int year = year(date(rounddate,"MDY"))
gen int month = month(date(rounddate,"MDY"))
replace year = year - 1 if month < 4
drop month

// Identify only first rounds in each company
gen     firstround = 1 if roundnumber == 1
replace firstround = 0 if roundnumber != 1

// Drop all rounds that are not VC investments, even if made by VC funds
drop if companystagelevel1ateachrounddat != "Early Stage" & /// 
        companystagelevel1ateachrounddat != "Startup/Seed" & ///
        companystagelevel1ateachrounddat != "Later Stage" & ///
        companystagelevel1ateachrounddat != "Expansion"

// Translate round total from string to number and calculate the average investment
// by a partner in the round. We use that to estimate the size of each investment
// destring disclosedroundtotal000, ignore(",") gen(roundsize)
destring estimatedroundtotal000, ignore(",") gen(roundsize)
replace roundsize = 1000*roundsize / roundnumberofinvestors

// Calculate the totals for each kind of VC definition
gen vcstgprvtot = roundsize * stagepriv

// Calculate the counts for each kind of VC definition and for first & all rounds
gen vcstgprvcntall = stagepriv 
gen vcstgprvcntfst = stagepriv * firstround


// Leave only one obs per msa & year
sort msacode year
collapse (sum) vcstgprvcntall vcstgprvcntfst vcstgprvtot, by(msacode year)
sort msacode year
save `temp', replace



// Then we calculate the variables for calendar years (Jan to Dec)
restore

// Translate the date info from string into year number
// Here we need to follow the Census Bureau's data, since
// that goes from April to March. Hence, we code Jan-Mar to
// have been in the previous year.
gen int year = year(date(rounddate,"MDY"))
gen int month = month(date(rounddate,"MDY"))
drop month

// Identify only first rounds in each company
gen     firstround = 1 if roundnumber == 1
replace firstround = 0 if roundnumber != 1

// Drop all rounds that are not VC investments, even if made by VC funds
drop if companystagelevel1ateachrounddat != "Early Stage" & /// 
        companystagelevel1ateachrounddat != "Startup/Seed" & ///
        companystagelevel1ateachrounddat != "Later Stage" & ///
        companystagelevel1ateachrounddat != "Expansion"

// Translate round total from string to number and calculate the average investment
// by a partner in the round. We use that to estimate the size of each investment
// destring disclosedroundtotal000, ignore(",") gen(roundsize)
destring estimatedroundtotal000, ignore(",") gen(roundsize)
replace roundsize = 1000*roundsize / roundnumberofinvestors

// Calculate the totals for each kind of VC definition
gen cvcstgtot    = roundsize * stage
gen cvcstgprvtot = roundsize * stagepriv

// Calculate the counts for each kind of VC definition and for first & all rounds
gen cvcstgprvcntall = stagepriv 
gen cvcstgprvcntfst = stagepriv * firstround

// Leave only one obs per msa & year
sort msacode year
collapse (sum) cvcstgprvcntall cvcstgprvcntfst cvcstgprvtot, by(msacode year)
sort msacode year
merge msacode year using `temp'
drop _merge
sort msacode year
save vcmsa.dta, replace


/*
This will prepare the census data for merger and 
merge it with the VentureXpert data

Having calculated the VC activity for each MSA, we can 
now merge the VC data with the Census data described in 
Data for Entrepreneurial Activity in MSAs.

This step needs one argument, census directory, as well as
a file (vcmsa.dta in the current directory) that contains
the measures of VC activity by MSA code and year.
*/


// Prepare census data for merging
use "`censusdir'/MSA93-02.dta", clear
drop if msacode == 1 // refers to all of US

// Now merge using msacode and year, the two panel variables
sort msacode year
merge msacode year using vcmsa.dta
drop _merge

// We can now save the final file and erase the temp file.
sort msacode year
save vcmsa.dta, replace


// First we need to prepare a bit by adding info on the funds to the LP info:
// the year of initial closing, the size of the fund, the type code, and the stage
// focus.

use "`vcdir'/fund.dta", clear

// Find the year of the first investment done by a fund and the year of initial closing. 
// If the latter is missing, we use the former.
gen int year = year(date(fundinitialclosing,"MDY"))
gen int month = month(date(fundinitialclosing,"MDY"))
drop month

gen int firstinvestyear = year(date(datefundmadeitsfirstinvestment,"MDY"))
gen int month = month(date(datefundmadeitsfirstinvestment,"MDY"))
drop month

replace year = firstinvestyear if year == .

replace year = fundyear if year == .

sort fundid
save "`temp'", replace

// Find the first round year from the round file.
use "`vcdir'/round.dta", clear

gen int firstroundyear = year(date(rounddate,"MDY"))
gen int month = month(date(rounddate,"MDY"))
drop month

sort fundid
collapse (min) firstroundyear, by(fundid)
sort fundid
merge fundid using "`temp'"
drop _merge

replace year = firstroundyear if year == . & firstroundyear != .
drop firstroundyear

keep year fundid
sort fundid
save "`temp'", replace

// Then merge them to the LP file using fund id
use "`vcdir'/LP1.dta", clear
sort fundid
merge fundid using "`temp'"
drop _merge

replace year = lpyearstarted if year == .
drop if year == .

// Drop LPs with missing MSA codes
drop if lpmsacode == .
ren lpmsacode msacode

// Now we'll collapse by lpid to find the earliest investment year
// for each LP
sort lpid
collapse (min) year msacode, by(lpid)

// Next we collapse by msacode & year to count all new LPs in a year
// and MSA pair
sort msacode year
gen year2 = year
collapse (count) newlps = year2, by(msacode year)

// Now we fill in all the missing years so that for each MSA we
// have one observation per year
tsset msacode year 
tsfill, full
replace newlps = 0 if newlps == .

// Then we add up the new ones to get a count of active ones in each year.
// The main point is that the _n counter goes through the observations
// in each by-group in the sort order, in this case year. Hence, we can
// for each year simply add to the previous year's count the new ones that
// joined. We'll focus on those that have been active for at least a year.
sort msacode year
gen activelps10 = 0
by msacode: replace activelps10 = activelps10[_n-1] + newlps[_n-10] if newlps[_n-10] != .
drop newlps

drop if year<1978
drop if year>2006

// Then we merge with the rest of the data
sort msacode year
merge msacode year using vcmsa.dta
drop _merge
sort msacode year
save vcmsa.dta, replace



/*
This file prepares the main project file for analysis

Since we have all the VC investments as well as LBO inflows 
for the years in question, we can fill in with zeros the MSA-year 
pairs for which we donÕt have an observation, since they must be 
zero. We also calculate logs of the main variables. We calculate 
annual changes in employment, payroll, and average pay. For the 
latter ones, we calculate the change from year n to year n+1 and 
assign it to year n.
*/


// Fill in years with no investments or flows, first with missing variables
drop if year == .
tsset msacode year, yearly
tsfill, full
tsset, clear

sort msacode year
xtset msacode year


// Calculate logs for the variables
gen births_20_log  = log(births_20)
gen emplmnt_log   	   = log(emplmnt)
gen payroll_log  	   = log(payroll*1000)
gen estab_tot_log  = log(estab_tot)

gen vcstgprvtot_log    = log(1+vcstgprvtot)
gen vcstgprvcntall_log = log(1+vcstgprvcntall)
gen vcstgprvcntfst_log = log(1+vcstgprvcntfst)
gen cvcstgprvcntfst_log = log(1+cvcstgprvcntfst)
gen cvcstgprvcntall_log = log(1+cvcstgprvcntall)
gen cvcstgprvtot_log    = log(1+cvcstgprvtot)

sort msacode year
save vcmsa.dta, replace


// Open the patent file, calculate variables, save
//use "Patent_counts.dta", clear
use "Patents.dta", clear
sort msacode year
save "`temp'", replace

// Open the main data file, merge with patent data
use "vcmsa.dta", clear
merge msacode year using "`temp'"
drop _merge
sort msacode year
drop if msacode == -1 | msacode == -2
drop if year < 1980
replace patent = 0 if patent == . 

// Calculate patents as the log of the total in the prior year
gen pats_log = log(1+l.patent)
gen pats5_log = log(1+l.patent+l2.patent+l3.patent+l4.patent+l5.patent)
gen tmp = l.patent
replace patent = tmp



// Merge with population data
merge msacode year using "`geodir'/msa_population.dta"
drop _merge
sort msacode year
gen pop_log = log(l.population)


// Then drop Puerto Rico, for which we have no Census data and fill in missing values (i.e., no patents) & sum lags
drop if msacode == 60   // Aguadilla, PR
drop if msacode == 470  // Arecibo, PR
drop if msacode == 1310 // Caguas, PR
drop if msacode == 4840 // Mayaguez, PR
drop if msacode == 6360 // Ponce, PR
drop if msacode == 7440 // San Juan, PR
drop if msacode == 5740


// Fill in VC & IV data with zeros for missing values, since we have the complete data. 
// Thus any zero is a sign of no activity, i.e., a zero value.
mvencode vc*  if year > 1979 & year < 2007, mv(0) override
mvencode cvc*  if year > 1979 & year < 2007, mv(0) override
mvencode act* if year > 1977 & year < 2007, mv(0) override


// Generate codes for exceptional states
gen CA = 0
gen MA = 0
gen TX = 0
replace CA = 1 if strpos(msaname,"CA") > 0
replace MA = 1 if strpos(msaname,"MA") > 0
replace TX = 1 if strpos(msaname,"TX") > 0



// Next we'll add in the returns info.
sort year
merge year using "EndowmentReturns.dta"
drop _merge

// Add latitude and longitude in order to calculate distance weighted variables
sort msacode
merge msacode using "`geodir'/msa_centroids.dta"
drop _merge

// Since we need the year, lat & lon info, we drop all the obs where they are missing
drop if lat  == .
drop if year == .
replace lat = lat * _pi/180
replace lon = lon * _pi/180


// Make into a panel data set
sort msacode year
xtset msacode year


// Calculate the instrument
gen activelps10_log = log(activelps10+1)
quietly do coordwt activelps10_log lat lon year 1
sort msacode year
gen lpreturn10_log_wt1 = activelps10_log_wt1*endowret
gen lpreturn10_1_3_1 = l1.lpreturn10_log_wt1 + l2.lpreturn10_log_wt1+l3.lpreturn10_log_wt1


// Generate variables for long-term impact
gen births_20_grp = 0
gen pats_grp = 0
forvalues i = 0/9 {
	replace births_20_grp = births_20_grp + f`i'.births_20 if year == 1993
	replace pats_grp = pats_grp + f`i'.patent if year == 1993
}
gen births_20_grp_log = log(births_20_grp)
gen pats_grp_log = log(1 + pats_grp)
gen emplmnt_grp_log = log(f9.emplmnt) if year == 1993
gen payroll_grp_log = log(f9.payroll) if year == 1993
gen firms_grp_log = log(f9.firms) if year == 1993
gen estab_grp_log = log(f9.estab_tot) if year == 1993
gen vccntf_grp_log = log(1 + l.vcstgprvcntfst + l2.vcstgprvcntfst + l3.vcstgprvcntfst + l4.vcstgprvcntfst + l5.vcstgprvcntfst) if year == 1993
gen vccnta_grp_log = log(1 + l.vcstgprvcntall + l2.vcstgprvcntall + l3.vcstgprvcntall + l4.vcstgprvcntall + l5.vcstgprvcntall) if year == 1993
gen vcamt_grp_log = log(1 + l.vcstgprvtot + l2.vcstgprvtot + l3.vcstgprvtot + l4.vcstgprvtot + l5.vcstgprvtot) if year == 1993


gen emplmnt_grp5_log = log(f5.emplmnt) if year == 1995
gen payroll_grp5_log = log(f5.payroll) if year == 1995
gen firms_grp5_log = log(f5.firms) if year == 1995
gen estab_grp5_log = log(f5.estab_tot) if year == 1995
gen vccntf_grp5_log = log(1 + l.vcstgprvcntfst + l2.vcstgprvcntfst + l3.vcstgprvcntfst + l4.vcstgprvcntfst + l5.vcstgprvcntfst) if year == 1995
gen vccnta_grp5_log = log(1 + l.vcstgprvcntall + l2.vcstgprvcntall + l3.vcstgprvcntall + l4.vcstgprvcntall + l5.vcstgprvcntall) if year == 1995
gen vcamt_grp5_log = log(1 + l.vcstgprvtot + l2.vcstgprvtot + l3.vcstgprvtot + l4.vcstgprvtot + l5.vcstgprvtot) if year == 1995
gen pats55_log = pats5_log

gen emplmnt_grp5 = f5.emplmnt/1000 if year == 1995
gen payroll_grp5 = f5.payroll/1000 if year == 1995
gen firms_grp5 = f5.firms if year == 1995
gen estab_grp5 = f5.estab_tot if year == 1995
gen vccntf_grp5 = l.vcstgprvcntfst + l2.vcstgprvcntfst + l3.vcstgprvcntfst + l4.vcstgprvcntfst + l5.vcstgprvcntfst if year == 1995
gen vccnta_grp5 = l.vcstgprvcntall + l2.vcstgprvcntall + l3.vcstgprvcntall + l4.vcstgprvcntall + l5.vcstgprvcntall if year == 1995
gen vcamt_grp5 = (l.vcstgprvtot + l2.vcstgprvtot + l3.vcstgprvtot + l4.vcstgprvtot + l5.vcstgprvtot)/1000000 if year == 1995
gen pats55 = l.patent + l2.patent + l3.patent + l4.patent + l5.patent if year == 1995



// Label variables
lab var lpreturn10_1_3_1	   "LP Returns"
lab var pats_log		"Patents (t-1)"
lab var vcstgprvcntfst_log "VC Cnt First (t)"
lab var vcstgprvcntall_log "VC Cnt All (t)"
lab var vcstgprvtot_log        "VC Amount (t)"
lab var cvcstgprvcntfst_log "VC Cnt First (t)"
lab var cvcstgprvcntall_log "VC Cnt All (t)"
lab var cvcstgprvtot_log        "VC Amount (t)"
lab var vccntf_grp_log "VC Cnt First 88-92"
lab var vccnta_grp_log "VC Cnt All 88-92"
lab var vccnta_grp_log "VC Cnt All 88-92"
lab var vcamt_grp_log "VC Amount 88-92"
lab var vccntf_grp5_log "VC Cnt First 90-94"
lab var vccnta_grp5_log "VC Cnt All 90-94"
lab var vcamt_grp5_log "VC Amount 90-94"
lab var pats5_log "Patents 88-92"
lab var births_20_log "Births"
lab var pats55_log "Patents 90-94"
lab var pop_log "Population (t-1)"
lab var estab_tot_log "Estblmnts 95"
lab var emplmnt_log "Emplmnt 95"
lab var payroll_log "Payroll 95"

lab var vccntf_grp5 "VC Cnt First 1990-94"
lab var vccnta_grp5 "VC Cnt All 1990-94"
lab var vcamt_grp5 "VC Amount 1990-94 (millions)"
lab var pats55 "Patents 1990-94"
lab var emplmnt_grp5 	"Employment 2000 (1000s)"
lab var payroll_grp5 	"Payroll 2000 (millions)"
lab var estab_grp5 		"Establishments 2000"

lab var population			"Population (1000s)"
lab var patent				"Patents "
lab var births_tot          "Births, All"
lab var births_20          "Establ. Births"
lab var emplmnt            "Employment (1000s)"
lab var payroll            "Payroll (millions)"
lab var vcstgprvtot        "VC Amount (millions)"
lab var vcstgprvcntfst     "VC Count First"
lab var vcstgprvcntall     "VC Count All"

lab var estab_tot            "Establishments 1995"
lab var emplmnt            "Employment 1995 (1000s)"
lab var payroll            "Payroll 1995 (millions)"



// Drop excess years, make it into a panel dataset, create year dummies,
// and then save the file.
drop if year < 1980 | year > 2004
drop if msacode == 0
drop if msacode == .
compress
xtset msacode year
sort msacode year
quietly tab year, gen(dyear)
gen trend = year-1992
xi i.msacode|trend
save vcmsa.dta, replace


