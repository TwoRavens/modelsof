clear *

// =================================================================
//  IDEOLOGY DATA FROM BONICA
//
//  From https://data.stanford.edu/dime#download-data
// =================================================================
import delimited "rawData/dime_recipients_1979_2014.csv" , varnames(1)

keep if election=="fd2010"
rename candid FECID
drop if missing(FECID)
keep FECID dwnom1 

// remove duplicates (one case has DWNOM1 for one of two duplicates; we sort it first so it's retained)
by FECID (dwnom1), sort: keep if _n==1
compress

save dataSets/Bonica2010_ideology.dta, replace


// =================================================================
//    WMP DATA
//
//   This is the Wesleyan Media Project 2010 dataset
//   for federal races from http://mediaproject.wesleyan.edu/dataaccess/data-access-2010/
//
//   $CMAGDataFile global is set in doItAll.do to location of [wmp-federal-2010-v1.3.dta]
// =================================================================
clear
use $CMAGDataFile

// ---------------------------------------------------
// Apply primary dates 
// ---------------------------------------------------
gen byte primary=0
replace primary=1 if airdate<d(	1jun2010	) & state=="AL"
replace primary=1 if airdate<d(	24aug2010	) & state=="AK"
replace primary=1 if airdate<d(	24aug2010	) & state=="AZ"
replace primary=1 if airdate<d(	18may2010	) & state=="AR"
replace primary=1 if airdate<d(	8jun2010	) & state=="CA"
replace primary=1 if airdate<d(	10aug2010	) & state=="CO"
replace primary=1 if airdate<d(	10aug2010	) & state=="CT"
replace primary=1 if airdate<d(	14sep2010	) & state=="DE"
replace primary=1 if airdate<d(	24aug2010	) & state=="FL"
replace primary=1 if airdate<d(	20jul2010	) & state=="GA"
replace primary=1 if airdate<d(	18sep2010	) & state=="HI"
replace primary=1 if airdate<d(	25may2010	) & state=="ID"
replace primary=1 if airdate<d(	2feb2010	) & state=="IL"
replace primary=1 if airdate<d(	4may2010	) & state=="IN"
replace primary=1 if airdate<d(	8jun2010	) & state=="IA"
replace primary=1 if airdate<d(	3aug2010	) & state=="KS"
replace primary=1 if airdate<d(	18may2010	) & state=="KY"
replace primary=1 if airdate<d(	28aug2010	) & state=="LA"
replace primary=1 if airdate<d(	8jun2010	) & state=="ME"
replace primary=1 if airdate<d(	14sep2010	) & state=="MD"
replace primary=1 if airdate<d(	14sep2010	) & state=="MA"
replace primary=1 if airdate<d(	3aug2010	) & state=="MI"
replace primary=1 if airdate<d(	10aug2010	) & state=="MN"
replace primary=1 if airdate<d(	1jun2010	) & state=="MS"
replace primary=1 if airdate<d(	3aug2010	) & state=="MO"
replace primary=1 if airdate<d(	8jun2010	) & state=="MT"
replace primary=1 if airdate<d(	11may2010	) & state=="NE"
replace primary=1 if airdate<d(	8jun2010	) & state=="NV"
replace primary=1 if airdate<d(	14sep2010	) & state=="NH"
replace primary=1 if airdate<d(	8jun2010	) & state=="NJ"
replace primary=1 if airdate<d(	1jun2010	) & state=="NM"
replace primary=1 if airdate<d(	14sep2010	) & state=="NY"
replace primary=1 if airdate<d(	4may2010	) & state=="NC"
replace primary=1 if airdate<d(	8jun2010	) & state=="ND"
replace primary=1 if airdate<d(	4may2010	) & state=="OH"
replace primary=1 if airdate<d(	27jul2010	) & state=="OK"
replace primary=1 if airdate<d(	18may2010	) & state=="OR"
replace primary=1 if airdate<d(	18may2010	) & state=="PA"
replace primary=1 if airdate<d(	14sep2010	) & state=="RI"
replace primary=1 if airdate<d(	8jun2010	) & state=="SC"
replace primary=1 if airdate<d(	8jun2010	) & state=="SD"
replace primary=1 if airdate<d(	5aug2010	) & state=="TN"
replace primary=1 if airdate<d(	2mar2010	) & state=="TX"
replace primary=1 if airdate<d(	22jun2010	) & state=="UT"
replace primary=1 if airdate<d(	24aug2010	) & state=="VT"
replace primary=1 if airdate<d(	8jun2010	) & state=="VA"
replace primary=1 if airdate<d(	17aug2010	) & state=="WA"
replace primary=1 if airdate<d(	11may2010	) & state=="WV"
replace primary=1 if airdate<d(	14sep2010	) & state=="WI"
replace primary=1 if airdate<d(	17aug2010	) & state=="WY"

by creative (primary), sort: gen airedPrimary = primary[_N]			// last observation is one if primary airing exists
by creative (primary):       gen airedGeneral = 1 - primary[1]		// first observation is zero if general election airing exists

// --------------------------------------------
// drop unnecessary observations and variables
// --------------------------------------------
by creative, sort: keep if _n==1 // one observation per ad

drop market station-programtype
rename * wmp_*
rename wmp_creative creative

// --------------------------------------------
// Clean up candname for matching to Bonica dataset
// --------------------------------------------
gen candname = word(creative,2)
replace candname = substr(candname,index(candname,"&")+1,.                    ) if substr(candname,1,5)=="DCCC&"
replace candname = substr(candname,1                    ,index(candname,"&")-1) if index(candname,"&")

*Fix errors in the WMP data
replace candname     ="WILLIAMS-BURNETT" if candname=="BURNETT"
replace candname     ="DOW-FORD" if candname=="FORD"
replace candname     ="KIRKLAND" if candname=="ROBKIRKLAND"
replace wmp_district =3 if candname=="THOMAS" & wmp_district==4 & wmp_state=="IN"
replace wmp_district =9 if candname=="POLLAK" & wmp_district==2 & wmp_state=="IL"
replace wmp_district =8 if wmp_district==4 & wmp_state=="WI" & candname=="KAGAN"
replace wmp_district =. if candname=="MCCAIN" & wmp_state=="AZ"
replace candname     ="KAGEN" if candname=="KAGAN" & wmp_state=="WI"
replace wmp_district =8 if candname=="KAGEN" & wmp_state=="WI"
replace candname     ="LAMANTAGNE" if candname=="LAMONTAGNE" & wmp_state=="NH"
replace candname     ="FLERLAGE" if candname=="FLERAGE" & wmp_state=="CO"
replace candname     ="LEE" if candname=="JACKSON" & wmp_state=="TX" & wmp_district==18
replace candname     ="VAN HAAFTEN" if candname=="VAN" & wmp_state=="IN" & wmp_district==8
replace wmp_district =19 if candname=="GRABER" & wmp_state=="FL"
replace candname     ="RACZKOWSKI" if candname=="RACKOWSKI" & wmp_state=="MI"
replace candname     ="BOCCIERI" if candname=="BOCCIERRI"
replace candname     ="RACZKOWSKI" if candname=="RACZOWSKI"
replace candname     ="CANSECO" if candname=="CONSECO"
replace candname     = "" if candname=="AAN"		

* Candidate ads only 
replace candname = "" if wmp_sponsor!=1

gen stcd2=wmp_state+string(wmp_district)
replace stcd2 = subinstr(stcd2, ".", "",.)

*bring in the FECIDs
merge m:1 candname stcd2 using "rawData/fecid_2010.dta", keep(match master)
drop _merge
rename fecid FECID

// --------------------------------------------
// Map opposing candidates where possible
// --------------------------------------------
preserve
	keep if wmp_airedGeneral
	drop if wmp_airedPrimary
	drop if mi(candname)
	drop if !(inlist(wmp_party,"Democrat","Republican"))

	by stcd2 wmp_party (candname), sort: gen newcand = candname!=candname[_n-1]
	by stcd2 wmp_party (candname), sort: gen totCandsByParty  = sum(newcand)
	by stcd2 wmp_party (candname), sort: replace totCandsByParty  = totCandsByParty[_N]
	drop if totCandsByParty>1

	by stcd2 wmp_party candname, sort: keep if _n==1
	by stcd2 , sort: gen nCands = _N
	drop if nCands==1

	by stcd2 (wmp_party), sort: gen opname = candname[3-_n]
	by stcd2 (wmp_party), sort: gen opparty = wmp_party[3-_n]
	by stcd2 (wmp_party), sort: gen opFECID = FECID[3-_n]
	
	keep stcd2 wmp_party candname FECID op*
	sort stcd2 wmp_party candname
	save dataSets/opponent_mapping, replace
restore

merge m:1 stcd2 wmp_party candname using dataSets/opponent_mapping
ta _merge
drop _merge

// --------------------------------------------
// apply DW-NOMINATE from Bonica dataset
// --------------------------------------------
merge m:1 FECID using dataSets/Bonica2010_ideology, keep(match master)

// rename cfscore bonica_cfscore
rename dwnom1  bonica_dwnominate
rename FECID   bonica_fecid
// la var bonica_cfscore    "Bonica donor-based ideology score"
la var bonica_dwnominate "DW-NOMINATE first dimension ideology score"
la var bonica_fecid      "FEC ID for candidate/race"

// now apply opponent ideology 
drop _merge
preserve
	use dataSets/Bonica2010_ideology, clear
	rename FECID opFECID 
	la var opFECID "SIC -- THIS ALLOWS MERGING FECID OF OPPONENT"
 	tempfile bonicatemp
	save "`bonicatemp'", replace
restore

merge m:1 opFECID using "`bonicatemp'", keep(match master)
rename dwnom1  bonica_oc_dwnominate
rename opFECID bonica_oc_fecid
la var bonica_oc_dwnominate "OC: DW-NOMINATE first dimension ideology score"
la var bonica_oc_fecid      "OC: FEC ID for opposing candidate/race"

drop _merge 

save "dataSets/cmag_adcoding2010_withideology", replace
