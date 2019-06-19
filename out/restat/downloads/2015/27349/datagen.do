***********************************************************************
********* Data set generation for *************************************
********* A & F,  Review of Economics and Statistics ******************
***********************************************************************



cd "C:\Users\aichele\Documents\projects\bilateral\submission reconstat\data and code"



*** create dataset with aggregate, bilateral data ***
use work_beim_poisson2, clear

egen eex= sum(BEEX_srio), by(pairy)
egen expo = sum(exp), by(pairy)
egen eim = sum(BEIM), by(pairy)
egen impo= sum(imp), by(pairy)
drop CCT
g CCT= (eex/expo)/(eim/impo)

sort ccode pcode year

collapse (first) dk fta wto eu nnn* eex - CCT, by(ccode pcode year)

g intens=eim/impo

sum

sort ccode pcode year

save data_aggregate, replace


g laggbeim=ln(eim)
g laggimp=ln(impo)
g laggint=ln(intens)
g laggCTT=ln(CCT)


label var dk "Kyoto_m-Kyoto_x"
label var eu "Joint EU (0,1)"
label var wto "Joint WTO (0,1)"
label var fta "FTA (0,1)"


egen iddi=group(ccode pcode)
	xtset iddi year

save data_aggregate, replace



*** create dataset for long diff-in-diff ***
use data_kyotoandleakage_restat, clear

*treatment window 2001-2003
g per=0 if year<2001
replace per=1 if year>2003
drop if per==.

replace CCT_sec=. if BEEX_srio<0

collapse BEIM CCT_sec* imp int_imp cky pkyo dk cICC pICC dkICC ccgdp pcgdp fta wto eu mrdis mrcon mrcom mrfta mrwto mreu, by(sid per ccode pcode category)

tsset sid per

xi i.per, prefix(ttt) noomit

local names "ARG AUS AUT BEL BRA CAN CHE CHN CZE DEU DNK ESP EST FIN FRA GBR GRC HUN IDN IND IRL ISR ITA JPN KOR MEX NLD NOR NZL POL PRT RUS SVK SVN SWE TUR USA ZAF ROU CHL" 
	foreach x of local names {
		g nnn`x'_0=0
		replace nnn`x'_0=1 if pcode=="`x'" & per==0
		replace nnn`x'_0=1 if ccode=="`x'" & per==0
	}
	
local names "ARG AUS AUT BEL BRA CAN CHE CHN CZE DEU DNK ESP EST FIN FRA GBR GRC HUN IDN IND IRL ISR ITA JPN KOR MEX NLD NOR NZL POL PRT RUS SVK SVN SWE TUR USA ZAF ROU CHL" 
	foreach x of local names {
		g nnn`x'_1=0
		replace nnn`x'_1=1 if pcode=="`x'" & per==1
		replace nnn`x'_1=1 if ccode=="`x'" & per==1
	}	

g lcy=ln(ccgdp)
g lpy=ln(pcgdp)
g lbeim=ln(BEIM)
g lint=ln(int_imp)
g limp=ln(imp)
g lCTT_sec=ln(CCT_sec)

label var ckyoto "Kyoto_m"
label var pkyoto "Kyoto_x"
label var lcy "ln GDP_m"
label var lpy "ln GDP_x"
label var fta "Joint FTA (0,1)"
label var wto "Joint WTO (0,1)"
label var eu "Joint EU (0,1)"
label var dk "Kyoto_m-Kyoto_x"
label var mrdis "MR distance"
label var mrcon "MR contiguity"
label var mrcom "MR language"
label var mrfta "MR FTA"
label var mrwto "MR WTO"
label var mreu "MR EU"

save work_beim2_long, replace


*** create dataset for long diff-in-diff, placebo treatment ***

* treatment in i=1997,1998
forvalues i=1997(1)1998{
use data_kyotoandleakage_restat, clear

g per=0 if year<`i'
replace per=1 if year>=`i'
* drop post-treatment period
drop if year>=2001


replace CCT_sec=. if BEEX_srio<0

collapse ccomm pcomm BEIM CCT_sec int_imp imp cky pkyo dk ccgdp pcgdp fta wto eu mrdis mrcon mrcom mrfta mrwto mreu, by(sid per ccode pcode category)

drop dk

g dk=0
replace dk=ccomm-pcomm if per==1

order sid ccode pcode category per dk ccom pcomm

tsset sid per

xi i.per, prefix(ttt) noomit

local names "ARG AUS AUT BEL BRA CAN CHE CHN CZE DEU DNK ESP EST FIN FRA GBR GRC HUN IDN IND IRL ISR ITA JPN KOR MEX NLD NOR NZL POL PRT RUS SVK SVN SWE TUR USA ZAF ROU CHL" 
	foreach x of local names {
		g nnn`x'_0=0
		replace nnn`x'_0=1 if pcode=="`x'" & per==0
		replace nnn`x'_0=1 if ccode=="`x'" & per==0
	}
	
local names "ARG AUS AUT BEL BRA CAN CHE CHN CZE DEU DNK ESP EST FIN FRA GBR GRC HUN IDN IND IRL ISR ITA JPN KOR MEX NLD NOR NZL POL PRT RUS SVK SVN SWE TUR USA ZAF ROU CHL" 
	foreach x of local names {
		g nnn`x'_1=0
		replace nnn`x'_1=1 if pcode=="`x'" & per==1
		replace nnn`x'_1=1 if ccode=="`x'" & per==1
	}	

g lcy=ln(ccgdp)
g lpy=ln(pcgdp)
g lbeim=ln(BEIM)
g lint=ln(int_imp)
g limp=ln(imp)
g lCTT_sec=ln(CCT_sec)

label var ckyoto "Kyoto_m"
label var pkyoto "Kyoto_x"
label var lcy "ln GDP_m"
label var lpy "ln GDP_x"
label var fta "Joint FTA (0,1)"
label var wto "Joint WTO (0,1)"
label var eu "Joint EU (0,1)"
label var dk "Kyoto_m-Kyoto_x"
label var mrdis "MR distance"
label var mrcon "MR contiguity"
label var mrcom "MR language"
label var mrfta "MR FTA"
label var mrwto "MR WTO"
label var mreu "MR EU"

save work_beim2_long_placebo`i', replace
}
