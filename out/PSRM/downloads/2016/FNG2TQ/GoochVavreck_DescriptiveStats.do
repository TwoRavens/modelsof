** GOOCH AND VAVRECK -- Descriptive Statistics 

** Run this file on data called GoochVavreck_DescriptiveStats




***  CREATE VARS for the DESCRIPTIVE STATS TABLEScapture drop *NMforeach i in ideo {	foreach k in bo mr jh "" {			gen `i'`k'NM = `i'`k'			replace `i'`k'NM = . if `i'`k' >= 9			}		}** CREATE DK indicators for favorabilityforeach j in favor { 	foreach z in mormon muslim tea {			gen `j'`z'NM = `j'`z'			replace `j'`z'NM = . if `j'`z' >= 9	}}					foreach v in favor {		foreach k in bo mr jh {			gen `v'`k'NM = `v'`k'			replace `v'`k'NM = . if `v'`k' >= 9		}	}	** CREATE DK indicators for matchupsforeach m in match {		foreach k in _mr _jh {			gen `m'`k'NM = `m'`k'			replace `m'`k'NM = . if `m'`k' >=3		}	}		** CREATE DK indicators for everything else#delimit ;foreach i in abort register gym taxes health gaymar defense pluto turnout08 
	choice08 newsp dentist techinternetfreq smoker drink churatd
	moby meds wsum1 wsum2 wsum4 wsum5 
	immi partyid retro income educ race trust interest bible teaparty
	rr_1 rr_2 rr_3 rr_4 { ;	  set more off;		gen `i'NM = `i';		replace `i'NM = . if `i' >=8;		};#delimit crforeach i in vp roberts prime {
	gen `i'codeNM = `i'code
	replace `i'codeNM = . if `i'code == 0
	}foreach i in bible pluto churatd  turnout08 drink {
	replace `i'NM = . if `i' == 5
	}
	
foreach i in meds register {
	replace `i'NM = . if `i' == 3
	}
	
replace choice08NM = . if choice08NM == 4
	
***** CREATE TABLE OF DESCRIPTIVE STATISTICS

sum *NM, separator(0)	
