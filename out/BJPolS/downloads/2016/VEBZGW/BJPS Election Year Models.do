

**********************************************************
*
*	REPLICAITON CODE FOR DISAGGREGATED MODELS
*	NOTE THAT SOME FORMATTING MAY BE REQUIRED IN EXCEL
*
**********************************************************

clear all
use "~/Dropbox/Projects/Public Opinion and Foreign Policy/Data and Do Files/ANES_POST_FACTOR_COMBINED.dta"
cd "/Users/michaelflynn/Dropbox/Projects/public opinion and foreign policy/BJPS R&R/BJPS Final Submission Materials/BJPS Replication Files"
set more off
set matsize 5000


gen ps0 = 0
replace ps0 = 1 if PS_tertile == 1 | PS_tertile == 2 | PS_tertile == 3
gen ps1 = 0 
replace ps1 = 1 if PS_tertile == 1 
gen ps2 = 0
replace ps2 = 1 if PS_tertile == 2
gen ps3 = 0 
replace ps3 = 1 if PS_tertile == 3
label define ps0 1 "All"
label define ps1 1 "Lowest Tertile"
label define ps2 1 "Middle Tertile"
label define ps3 1 "Highest Tertile"
label values ps0 ps0
label values ps1 ps1
label values ps2 ps2
label values ps2 ps3
label var ps0 "All Levels"
label var ps1 "Lowest Tertile"
label var ps2 "Middle Tertile"
label var ps3 "Highest Tertile"
label var PID_7 "Party ID"
label var Lib_Con_Scale "Ideology"
label var PartyGap "Thermometer"
label var Pres_Vote "Vote Choice"
label var F1_Adj "Economic"
label var F2_Adj "Social"
*set trace on

eststo clear 
postutil clear
postfile mypost str20 outcome str20 pslevel time econ soc con Obs R2 loglike using simresults.dta, replace

capture{
foreach DV of varlist  PID_7 Lib_Con_Scale {
foreach ps of varlist ps0 ps1 ps2 ps3 {
local year = 1972 
while `year' <= 2012     {
capture eststo: reg `DV' F1_Adj F2_Adj if year == `year' & `ps' == 1 & `DV'!=., robust
local year = `year' + 4
}
}
}
}

* Vote Choise Models
recode Pres_Vote (3 = .) (2 = 0) 
capture{
foreach DV of varlist Pres_Vote {
foreach ps of varlist ps0 ps1 ps2 ps3 {
local year = 1972 
while `year' <= 2012     {
capture noisily eststo: probit `DV' F1_Adj F2_Adj if year == `year' & `ps' == 1 & `DV'!=., robust
local year = `year' + 4
}
}
}
}


capture{
foreach DV of varlist PartyGap {
foreach ps of varlist ps0 ps1 ps2 ps3 {
local year = 1980 
while `year' <= 2012     {
capture eststo: reg `DV' F1_Adj F2_Adj if year == `year' & `ps' == 1 & `DV'!=., robust
local year = `year' + 4
}
}
}
}

postclose mypost


***************************************************************
*			MAIN TABLE NOT BROKEN OUT BY SOPHISTICATION
***************************************************************

* Party ID
* PID Part 1 -- All Sophistication 
esttab est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 est11  using bjps_table_1_0.csv, replace ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) ///
label nonotes compress nogaps nolines nonum ///
mtitles("1972" "1976" "1980" "1984" "1988" "1992" "1996" "2000" "2004" "2008" "2012") ///
scalars("N N" "r2 R-squared") ///
title("Party ID -- All Sophistication Levels")

* Ideology
* Ideology Part 1 -- All Sophistication 
esttab est45 est46 est47 est48 est49 est50 est51 est52 est53 est54 est55  using bjps_table_1_0.csv, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) ///
label nonotes compress nogaps nolines nonum nomtitles ///
scalars("N N" "r2 R-squared") ///
title("Ideology -- All Sophistication Levels")

* Vote Choice
* Vote Choice Part 1 -- All Sophistication
esttab est89 est90 est91 est92 est93 est94 est95 est96 est97 est98 est99  using bjps_table_1_0.csv, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) nomtitles nodepvars ///
label nonotes compress nogaps nolines nonum  ///
scalars("N N" "ll Log-Likelihood") ///
title("Vote Choice -- All Sophistication Levels")

* Affect Polarization
* Affect Polarization Part 1 -- All Sophistication 
esttab est133 est134 est135 est136 est137 est138 est139 est140 est141 using bjps_table_1_0.csv, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) ///
label nonotes compress nogaps nolines nonum nomtitles ///
scalars("N N" "r2 R-squared") ///
title("Affect Polarization -- All Sophistication Levels")




******************************************************
*				FULL TABLE
******************************************************

* Party ID
* PID Part 1 -- All Sophistication 
esttab est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 est11  using bjps_table_1_1.csv, replace ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) ///
label nonotes compress nogaps nolines nonum ///
mtitles("1972" "1976" "1980" "1984" "1988" "1992" "1996" "2000" "2004" "2008" "2012") ///
scalars("N N" "r2 R-squared") ///
title("Party ID -- All Sophistication Levels")

* PID Part 2 -- Low Sophistication 
esttab est12 est13 est14 est15 est16 est17 est18 est19 est20 est21 est22 using bjps_table_1_1.csv, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) nomtitles nonum ///
label nonotes compress nogaps nolines ///
scalars("N N" "r2 R-squared") ///
title("Party ID -- Low Sophistication")

* PID Part 3 -- Medium Sophistication 
esttab  est23 est24 est25 est26 est27 est28 est29 est30 est31 est32 est33  using bjps_table_1_1.csv, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) nomtitles nonum ///
label nonotes compress nogaps nolines ///
scalars("N N" "r2 R-squared") ///
title("Party ID -- Medium Sophistication")

* PID Part 4 -- High Sophistication 
esttab est34 est35 est36 est37 est38 est39 est40 est41 est42 est43 est44  using bjps_table_1_1.csv, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) nomtitles nonum ///
label nonotes compress nogaps nolines ///
scalars("N N" "r2 R-squared") ///
title("Party ID -- High Sophistication")

* Ideology
* Ideology Part 1 -- All Sophistication 
esttab est45 est46 est47 est48 est49 est50 est51 est52 est53 est54 est55  using bjps_table_1_2.csv, replace ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) ///
label nonotes compress nogaps nolines nonum ///
mtitles("1972" "1976" "1980" "1984" "1988" "1992" "1996" "2000" "2004" "2008" "2012") ///
scalars("N N" "r2 R-squared") ///
title("Ideology -- All Sophistication Levels")

* Ideology Part 2 -- Low Sophistication 
esttab est56 est57 est58 est59 est60 est61 est62 est63 est64 est65 est66 using bjps_table_1_2.csv, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) nomtitles nonum ///
label nonotes compress nogaps nolines ///
scalars("N N" "r2 R-squared") ///
title("Ideology -- Low Sophistication")

* Ideology Part 3 -- Medium Sophistication 
esttab  est67 est68 est69 est70 est71 est72 est73 est74 est75 est76 est77  using bjps_table_1_2.csv, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) nomtitles nonum ///
label nonotes compress nogaps nolines ///
scalars("N N" "r2 R-squared") ///
title("Ideology -- Medium Sophistication")

* Ideology Part 4 -- High Sophistication 
esttab est78 est79 est80 est81 est82 est83 est84 est85 est86 est87 est88  using bjps_table_1_2.csv, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) ///
label nonotes compress nogaps nolines nonum nomtitles ///
scalars("N N" "r2 R-squared") ///
title("Ideology -- High Sophistication")

* Vote Choice
* Vote Choice Part 1 -- All Sophistication
esttab est89 est90 est91 est92 est93 est94 est95 est96 est97 est98 est99  using bjps_table_1_3.csv, replace ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) ///
label nonotes compress nogaps nolines nonum ///
mtitles("1972" "1976" "1980" "1984" "1988" "1992" "1996" "2000" "2004" "2008" "2012") ///
scalars("N N" "ll Log-Likelihood") ///
title("Vote Choice Part -- All Sophistication Levels")

* Vote Choice Part 2 -- Low Sophistication 
esttab est100 est101 est102 est103 est104 est105 est106 est107 est108 est109 est110 using bjps_table_1_3.csv, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) nomtitles nonum ///
label nonotes compress nogaps nolines ///
scalars("N N" "ll Log-Likelihood") ///
title("Vote Choice -- Low Sophistication")

* Vote Choice Part Part 3 -- Medium Sophistication 
esttab  est111 est112 est113 est114 est115 est116 est117 est118 est119 est120 est121  using bjps_table_1_3.csv, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) nomtitles nonum ///
label nonotes compress nogaps nolines ///
scalars("N N" "ll Log-Likelihood") ///
title("Vote Choice -- Medium Sophistication")

* Vote Choice Part Part 4 -- High Sophistication 
esttab est122 est123 est124 est125 est126 est127 est128 est129 est130 est131 est132  using bjps_table_1_3.csv, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) nomtitles nonum ///
label nonotes compress nogaps nolines ///
scalars("N N" "ll Log-Likelihood") ///
title("Vote Choice -- High Sophistication")

* Affect Polarization
* Affect Polarization Part 1 -- All Sophistication 
esttab est133 est134 est135 est136 est137 est138 est139 est140 est141   using bjps_table_1_4.rtf, replace ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) ///
label nonotes compress nogaps nolines nonum ///
mtitles("1980" "1984" "1988" "1992" "1996" "2000" "2004" "2008" "2012") ///
scalars("N N" "r2 R-squared") ///
title("Affect Polarization -- All Sophistication Levels")

* Affect Polarization Part 2 -- Low Sophistication 
esttab est142 est143 est144 est145 est146 est147 est148 est149 est150  using bjps_table_1_4.rtf, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) nomtitles nonum ///
label nonotes compress nogaps nolines ///
scalars("N N" "r2 R-squared") ///
title("Affect Polarization -- Low Sophistication")

* Affect Polarization 3 -- Medium Sophistication 
esttab  est151 est152 est153 est154 est155 est156 est157 est158 est159   using bjps_table_1_4.rtf, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) nomtitles nonum ///
label nonotes compress nogaps nolines ///
scalars("N N" "r2 R-squared") ///
title("Affect Polarization -- Medium Sophistication")

* Affect Polarization Part 4 -- High Sophistication 
esttab est160 est161 est162 est163 est164 est165 est166 est167 est168  using bjps_table_1_4.rtf, append ///
keep(F1_Adj F2_Adj) ///
se(%5.3fc) b(%5.3fc) nomtitles nonum ///
label nonotes compress nogaps nolines ///
scalars("N N" "r2 R-squared") ///
title("Affect Polarization -- High Sophistication")



