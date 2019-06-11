// ----------------------------bjps-extension.do-------------------------------
// Title:     Who is afraid of conflict?
//            Replication script using data supplied by Schuck et al (2014)
// Authors:   Zoltan Fazekas & Erik Gahner Larsen
// Email:     zfa@sam.sdu.dk; egl@sam.sdu.dk
// Paper:     Media content and political behavior in observational research: A critical assessment
// Journal:   British Journal of Political Science
// Data:      PIREDEU Media (2010) and Voter Study (2013)
//			  Downloaded from the GESIS archive, (free) registration required
// Stata v:   13.1
// Note:      Script to reproduce models
//
// ----------------------------------------------------------------------------

* Load media data
use "ZA5056_v1-0-0.dta", clear

* Generate country variable
tostring V4, g(outlet)
replace outlet = "0" + outlet if length(outlet) == 6
g countryCode = substr(outlet,1,3)

g countryStr = .
tostring countryStr, replace
replace countryStr = "AT" if V4 == 401001 | V4 == 401002 | V4 == 401003 | V4 == 402001 | V4 == 402002
replace countryStr = "BE-F" if V4 == 0561001 | V4 == 0561002 | V4 == 0561003 | V4 == 0562001 | V4 == 0562002
replace countryStr = "BE-W" if V4 == 0561004 | V4 == 0561005 | V4 == 0561006 | V4 == 0562003 | V4 == 0562004
replace countryStr = "BG" if V4 == 1001001 | V4 == 1001002 | V4 == 1001003 | V4 == 1002001 | V4 == 1002002
replace countryStr = "CYP" if V4 == 1961001 | V4 == 1961002 | V4 == 1961003 | V4 == 1962001 | V4 == 1962002 
replace countryStr = "CZ" if V4 == 2031001 | V4 == 2031002 | V4 == 2031003 | V4 == 2032001 | V4 == 2032002
replace countryStr = "DK" if V4 == 2081001 | V4 == 2081002 | V4 == 2081003 | V4 == 2082001 | V4 == 2082002
replace countryStr = "EE" if V4 == 2331001 | V4 == 2331002 | V4 == 2331003 | V4 == 2332001 | V4 == 2332002
replace countryStr = "FI" if V4 == 2461001 | V4 == 2461002 | V4 == 2461003 | V4 == 2462001 | V4 == 2462002
replace countryStr = "FR" if V4 == 2501001 | V4 == 2501002 | V4 == 2501003 | V4 == 2502001 | V4 == 2502002
replace countryStr = "DE" if V4 == 2761001 | V4 == 2761002 | V4 == 2761003 | V4 == 2762001 | V4 == 2762002 | V4 == 2762003 | V4 == 2762004
replace countryStr = "GRE" if V4 == 3001001 | V4 == 3001002 | V4 == 3001003 | V4 == 3002001 | V4 == 3002002
replace countryStr = "HU" if V4 == 3481001 | V4 == 3481002 | V4 == 3481003 | V4 == 3482001 | V4 == 3482002
replace countryStr = "IRE" if V4 == 3721001 | V4 == 3721002 | V4 == 3721003 | V4 == 3722001 | V4 == 3722002
replace countryStr = "IT" if V4 == 3801001 | V4 == 3801002 | V4 == 3801003 | V4 == 3802001 | V4 == 3802002
replace countryStr = "LAT" if V4 == 4281001 | V4 == 4281002 | V4 == 4281003 | V4 == 4282001 | V4 == 4282002
replace countryStr = "LIT" if V4 == 4401001 | V4 == 4401002 | V4 == 4401003 | V4 == 4402001 | V4 == 4402002
replace countryStr = "LUX" if V4 == 4421001 | V4 == 4421002 | V4 == 4421003 | V4 == 4422001
replace countryStr = "MT" if V4 == 4701001 | V4 == 4701002 | V4 == 4701003 | V4 == 4702001 | V4 == 4702002 | V4 == 4702003
replace countryStr = "NL" if V4 == 5281001 | V4 == 5281002 | V4 == 5281003 | V4 == 5282001 | V4 == 5282002
replace countryStr = "PL" if V4 == 6161001 | V4 == 6161002 | V4 == 6161003 | V4 == 6162001 | V4 == 6162002
replace countryStr = "PT" if V4 == 6201001 | V4 == 6201002 | V4 == 6201003 | V4 == 6202001 | V4 == 6202002
replace countryStr = "RO" if V4 == 6421001 | V4 == 6421002 | V4 == 6421003 | V4 == 6422001 | V4 == 6422002
replace countryStr = "SVK" if V4 == 7031001 | V4 == 7031002 | V4 == 7031003 | V4 == 7032001 | V4 == 7032002
replace countryStr = "SLO" if V4 == 7051001 | V4 == 7051002 | V4 == 7051003 | V4 == 7052001 | V4 == 7052002
replace countryStr = "SPA" if V4 == 7241001 | V4 == 7241002 | V4 == 7241003 | V4 == 7242001 | V4 == 7242002 | V4 == 7242003
replace countryStr = "SWE" if V4 == 7521001 | V4 == 7521002 | V4 == 7521003 | V4 == 7522001 | V4 == 7522002
replace countryStr = "UK" if V4 == 8261001 | V4 == 8261002 | V4 == 8261003 | V4 == 8262001 | V4 == 8262002

* Generate EU related story variable				  
recode V13 (1=0 "No") (2=1 "Yes"), g(isEU)

* Generate date variable
g date = mdy(V3b, V3a, 2009)

* Rename and recode conflict variables
rename V33 conf1
rename V34a conf2
rename V35 conf3
rename V36a conf4

foreach var of varlist conf1 conf2 conf3 conf4 {
  replace `var' = `var' -1
}


* Generate polity evaluation variable
recode V26 (3=-2 "negative") (4=-1 "rather negative") (5 2=0 "balanced/mixed") (6=1 "rather positive") (7=2 "positive") (else=.), g(peval)

* Generate conflict and non-conflict variables
g confOrig = (conf1 + conf2 + conf3 + conf4)/4
g nonConfOrig = (confOrig - 1)*-1

g c1 = .
g c2 = .
g c3 = .
g c4 = .
levelsof V4, local(levels) 
foreach l of local levels {
	su conf1 if V4 == `l'
	replace c1 = r(sum) if V4 == `l'
	su conf2 if V4 == `l'
	replace c2 = r(sum) if V4 == `l'
	su conf3 if V4 == `l'
	replace c3 = r(sum) if V4 == `l'
	su conf4 if V4 == `l'
	replace c4 = r(sum) if V4 == `l'
}

g conflict = 1 if conf1 == 1 | conf2 == 1 | conf3 == 1 | conf4 == 1
g nConflict = .
levelsof V4, local(levels) 
foreach l of local levels {
	su conflict if V4 == `l'
	replace nConflict = r(sum) if V4 == `l'
}
g confSVdV = .
levelsof V4, local(levels) 
foreach l of local levels {
	su confOrig if V4 == `l'
	replace confSVdV = r(mean) if V4 == `l'

}
g nonConfSVdV = .
levelsof V4, local(levels) 
foreach l of local levels {
	su nonConfOrig if V4 == `l'
	replace nonConfSVdV = r(mean) if V4 == `l'

}

* Generate EU related stories variable
g totalEU = .
levelsof V4, local(levels) 
foreach l of local levels {
	su isEU if V4 == `l'
	replace totalEU = r(sum) if V4 == `l'
}

* Generate mean polity evaluation variable
g polity = .
levelsof V4, local(levels) 
foreach l of local levels {
	su peval if V4 == `l'
	replace polity = r(mean) if V4 == `l'
}

* Generate total stories variable
g totalStories = .
levelsof V4, local(levels) 
foreach l of local levels {
	su V2 if V4 == `l'
	replace totalStories = r(N) if V4 == `l'
}

* Generate merge ID
g mergeID = countryStr + "-" + substr(outlet,4,1) + substr(outlet,7,1)

* Collapse and save
collapse c1 c2 c3 c4 nConflict confSVdV nonConfSVdV totalEU polity totalStories (first) countryStr (first) mergeID, by(outlet)
save "media-outlets-2009.dta", replace

* Load survey data
use "ZA5055_v1-1-0.dta", clear

* Create unique ID variable
clonevar uID = t100

* Generate turnout variable
recode q24 (1=1) (2=0) (else=.), g(turnout)

* Generate gender variable
recode q102 (2=1) (1=0) (else=.), g(female)

* Generate age variable
g age = 2009-q103 if q103 != 7777

* Generate education variable
recode v200 (0/3.2=0) (3.3/5=1) (5.1/6=2) (else=.), g(edu)

* Genrate campaign contact variables
recode q21_a-q21_g (6/8=.)

replace q21_a = (q21_a-2)*-1
replace q21_b = (q21_b-2)*-1
replace q21_c = (q21_c-2)*-1
replace q21_d = (q21_d-2)*-1
replace q21_e = (q21_e-2)*-1
replace q21_f = (q21_f-2)*-1
replace q21_g = (q21_g-2)*-1

g directCont = 0 
replace directCont = directCont + q21_f if q21_f != .
replace directCont = directCont + q21_g if q21_g != .

g indirectCont = 0
replace indirectCont = indirectCont + q21_a if q21_a != .
replace indirectCont = indirectCont + q21_b if q21_b != .
replace indirectCont = indirectCont + q21_c if q21_c != .
replace indirectCont = indirectCont + q21_d if q21_d != .
replace indirectCont = indirectCont + q21_e if q21_e != .

* Generate exposure variable
rename q12_a paper1
rename q12_b paper2
rename q12_c paper3
rename q8_a tv1 
rename q8_b tv2
rename q8_c tv3
rename q8_d tv4

recode paper1 paper2 paper3 (77 88=.)
recode tv1 tv2 tv3 tv4 (77 88 99=.)

g paperSum = 0
replace paperSum = paperSum + paper1 if paper1 != .
replace paperSum = paperSum + paper2 if paper2 != .
replace paperSum = paperSum + paper3 if paper3 != .
g tvSum = 0
replace tvSum = tvSum + tv1 if tv1 != .
replace tvSum = tvSum + tv2 if tv2 != .
replace tvSum = tvSum + tv3 if tv3 != .
replace tvSum = tvSum + tv4 if tv4 != .
g exposure = paperSum + tvSum

* Generate country variable
decode t103, g(countryStr)
replace countryStr = "BE-W" if countryStr == "BE_Wallon"
replace countryStr = "BE-F" if countryStr == "BE_Flanders"
replace countryStr = "GRE" if countryStr == "EL"
replace countryStr = "SVK" if countryStr == "SK"
replace countryStr = "SPA" if countryStr == "ES"
replace countryStr = "LUX" if countryStr == "LU"
replace countryStr = "IRE" if countryStr == "IE"
replace countryStr = "CYP" if countryStr == "CY"
replace countryStr = "LIT" if countryStr == "LT"
replace countryStr = "LAT" if countryStr == "LV"
replace countryStr = "SLO" if countryStr == "SI"
replace countryStr = "SWE" if countryStr == "SE"

* Remove unneeded variables
keep countryStr paper1-paper3 tv1-tv4 uID-exposure

* Generate media variables
g medie1 = paper1
g medie2 = paper2
g medie3 = paper3
g medie4 = tv1
g medie5 = tv2
g medie6 = tv3
g medie7 = tv4

* Reshape data
reshape long medie, i(uID) j(variable)

* Generate value for individual outlets
g value = .
replace value = paper1 if variable == 1
replace value = paper2 if variable == 2
replace value = paper3 if variable == 3
replace value = tv1 if variable == 4
replace value = tv2 if variable == 5
replace value = tv3 if variable == 6
replace value = tv4 if variable == 7

* Generate tv ID variable
g tvID = .
replace tvID = 1 if variable < 4
replace tvID = 2 if tvID == .
tostring tvID, replace

clonevar variable2 = variable
replace variable2 = variable2 - 3 if variable > 3
tostring variable2, replace

* Create merge ID variable
g mergeID = countryStr + "-" + tvID + variable2

replace mergeID = "BE-W-14" if countryStr == "BE-W" & variable == 1
replace mergeID = "BE-W-15" if countryStr == "BE-W" & variable == 2
replace mergeID = "BE-W-16" if countryStr == "BE-W" & variable == 3
replace mergeID = "BE-W-23" if countryStr == "BE-W" & variable == 4
replace mergeID = "BE-W-24" if countryStr == "BE-W" & variable == 5
replace mergeID = "" if countryStr == "BE-W" & variable == 6
replace mergeID = "" if countryStr == "BE-W" & variable == 7

* Merge indvidual level data with media outlet data
merge m:1 mergeID using media-outlets-2009.dta

* Generate content exposure variables
g iConfSVdV = value * confSVdV
g inonConfSVdV = value * nonConfSVdV
g iEU = value * (totalEU/totalStories)
g iPolity = value * polity

egen iaConfSVdV = sum(iConfSVdV) if _merge == 3, by(uID)
egen ianonConfSVdV = sum(inonConfSVdV) if _merge == 3, by(uID)
egen iaEU  = sum(iEU ) if _merge == 3, by(uID)
egen iaPolity = sum(iPolity) if _merge == 3, by(uID)

* Drop observations and variables
keep if _merge == 3
drop _merge
drop value tvID variable2 mergeID outlet c1 c2 c3 c4 nConflict confSVdV nonConfSVdV totalEU totalStories iConfSVdV inonConfSVdV iEU iPolity 

* Generate polity evaluation variable
egen polity2 = mean(polity), by(countryStr)
drop polity
rename polity2 polity

* Reshape data
reshape wide medie, i(uID) j(variable)
drop medie*

* Generate correlations reported in Table SI.C1 
bysort countryStr: pwcorr iaConfSVdV ianonConfSVdV
bysort countryStr: pwcorr iaConfSVdV exposure
bysort countryStr: pwcorr exposure ianonConfSVdV

* Generate compulsory voting and simultaneous elections variable
g compVote = .
g simElec = .
replace compVote = 1 if countryStr == "BE-F" | countryStr == "BE-W" | countryStr == "GRE" 
replace compVote = 0 if compVote == .
replace simElec = 1 if countryStr == "BE-F" | countryStr == "BE-W" | countryStr == "DE" | countryStr == "DK" | countryStr == "IRE" | countryStr == "UK" | countryStr == "IT" | countryStr == "LUX" | countryStr == "MT"
replace simElec = 0 if simElec == .

* Generate numeric country variable
egen group = group(countryStr), label 

* Center variables
g confCent = .
levelsof group, local(levels) 
foreach l of local levels {
	su iaConfSVdV if group == `l'
	replace confCent = (iaConfSVdV-r(mean))/r(sd) if group == `l'
}

g noConfCent = .
levelsof group, local(levels) 
foreach l of local levels {
	su ianonConfSVdV if group == `l'
	replace noConfCent = (ianonConfSVdV-r(mean))/r(sd) if group == `l'
}

g expCent = .
levelsof group, local(levels) 
foreach l of local levels {
	su exposure if group == `l'
	replace expCent = (exposure-r(mean))/r(sd) if group == `l'
}


* Prepare for takeoff
xtset group

* Table 2
// Mere exposure
xtlogit turnout age female edu directCont indirectCont polity compVote simElec expCent
// Conflict
xtlogit turnout age female edu directCont indirectCont polity compVote simElec confCent
// No-conflict
xtlogit turnout age female edu directCont indirectCont polity compVote simElec noConfCent
