*Jeremy Berkowitz
*Department of Political Science, Binghamton University
*Replication Materials for Appendix of Delegating Terror: Principal-Agent Based Decision Making in State Sponsorship of Terrorism

clear all
set mem 1000m

use "delegatingterror.dta", clear

*Appendix Table 1
*Summary Statistics
summ unanimous_support nonunanimous_support total_support unanimoustargeted_tminus1  nonunanimoustargeted_tminus1 totaltargeted_tminus1 strategic_rivalry weaker_state_difference
summ xconst  coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East  EastEurope_CentralAsia militaryconflict preexisting_unanimous preexisting_nonunamious preexisting_total timelastsponsor_unanimous timelastsponsor_nonunanimous timelastsponsor_total


*Appendix Table 3
*Predicted Probabilites for Hypothesis 1
prvalue, x(strategic_rivalry=1 weaker_state_difference=.19 rivalry_weaker=.19) delta save
prvalue, x(strategic_rivalry=1 weaker_state_difference=-.19 rivalry_weaker=-.19) delta diff 

*Appendix Table 4
*Models with Control Variables Only
logit  unanimous_support coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_unanimous timelastsponsor_unanimous, vce(robust)
logit  nonunanimous_support coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict  preexisting_nonunamious timelastsponsor_nonunanimous, vce(robust)
logit  total_support coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)

*Appendix Table 5
*Models with Politically Relevant Dyads Only
*All Hypotheses*
logit  unanimous_support strategic_rivalry weaker_state_difference rivalry_weaker unanimoustargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_unanimous timelastsponsor_unanimous if pol_rel == 1, vce(robust)
lroc, nograph
logit  nonunanimous_support strategic_rivalry weaker_state_difference rivalry_weaker nonunanimoustargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict  preexisting_nonunamious timelastsponsor_nonunanimous if pol_rel == 1, vce(robust)
lroc, nograph
logit  total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if pol_rel == 1, vce(robust)
lroc, nograph

*Appendix Table 6
*Alternative Measurement of Hypothesis 1
gen enduring_rivalry = 0
replace enduring_rivalry = 1 if abbrevdyad == "USACAN" & year >= 1974 & year <= 1997
replace enduring_rivalry = 1 if abbrevdyad == "CANUSA" & year >= 1974 & year <= 1997
replace enduring_rivalry = 1 if abbrevdyad == "USACUB" & year >= 1970 & year <= 1996
replace enduring_rivalry = 1 if abbrevdyad == "CUBUSA" & year >= 1970 & year <= 1996
replace enduring_rivalry = 1 if abbrevdyad == "USAECU" & year >= 1970 & year <= 1981
replace enduring_rivalry = 1 if abbrevdyad == "ECUUSA" & year >= 1970 & year <= 1981
replace enduring_rivalry = 1 if abbrevdyad == "USAPER" & year >= 1970 & year <= 1992
replace enduring_rivalry = 1 if abbrevdyad == "PERUSA" & year >= 1970 & year <= 1992
replace enduring_rivalry = 1 if abbrevdyad == "USARUS" & year >= 1970 & year <= 2000
replace enduring_rivalry = 1 if abbrevdyad == "RUSUSA" & year >= 1970 & year <= 2000
replace enduring_rivalry = 1 if abbrevdyad == "USALIB" & year >= 1973 & year <= 1996
replace enduring_rivalry = 1 if abbrevdyad == "LIBUSA" & year >= 1973 & year <= 1996
replace enduring_rivalry = 1 if abbrevdyad == "USACHN" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "CHNUSA" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "USAPRK" & year >= 1970 & year <= 2000
replace enduring_rivalry = 1 if abbrevdyad == "PRKUSA" & year >= 1970 & year <= 2000
replace enduring_rivalry = 1 if abbrevdyad == "HONSAL" & year >= 1970 & year <= 1993
replace enduring_rivalry = 1 if abbrevdyad == "SALHON" & year >= 1970 & year <= 1993
replace enduring_rivalry = 1 if abbrevdyad == "HONNIC" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "NICHON" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "VENGUY" & year >= 1970 & year <= 1999
replace enduring_rivalry = 1 if abbrevdyad == "GUYVEN" & year >= 1970 & year <= 1999
replace enduring_rivalry = 1 if abbrevdyad == "GUYSUR" & year >= 1976 & year <= 2000
replace enduring_rivalry = 1 if abbrevdyad == "SURGUY" & year >= 1976 & year <= 2000
replace enduring_rivalry = 1 if abbrevdyad == "ECUPER" & year >= 1977 & year <= 1998
replace enduring_rivalry = 1 if abbrevdyad == "PERECU" & year >= 1977 & year <= 1998
replace enduring_rivalry = 1 if abbrevdyad == "CHLARG" & year >= 1970 & year <= 1984
replace enduring_rivalry = 1 if abbrevdyad == "ARGCHL" & year >= 1970 & year <= 1984
replace enduring_rivalry = 1 if abbrevdyad == "UKGRUS" & year >= 1970 & year <= 1999
replace enduring_rivalry = 1 if abbrevdyad == "RUSUKG" & year >= 1970 & year <= 1999
replace enduring_rivalry = 1 if abbrevdyad == "UKGIRQ" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "IRQUKG" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "SPNMOR" & year >= 1970 & year <= 1980
replace enduring_rivalry = 1 if abbrevdyad == "MORSPN" & year >= 1970 & year <= 1980
replace enduring_rivalry = 1 if abbrevdyad == "GRCTUR" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "TURGRC" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "CYPTUR" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "TURCYP" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "RUSNOR" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "NORRUS" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "RUSTUR" & year >= 1970 & year <= 1987
replace enduring_rivalry = 1 if abbrevdyad == "TURRUS" & year >= 1970 & year <= 1987
replace enduring_rivalry = 1 if abbrevdyad == "RUSAFG" & year >= 1980 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "AFGRUS" & year >= 1980 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "RUSCHN" & year >= 1970 & year <= 1994
replace enduring_rivalry = 1 if abbrevdyad == "CHNRUS" & year >= 1970 & year <= 1994
replace enduring_rivalry = 1 if abbrevdyad == "RUSJPN" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "JPNRUS" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "GHATOG" & year >= 1970 & year <= 1994
replace enduring_rivalry = 1 if abbrevdyad == "TOGGHA" & year >= 1970 & year <= 1994
replace enduring_rivalry = 1 if abbrevdyad == "CONDRC" & year >= 1970 & year <= 1997
replace enduring_rivalry = 1 if abbrevdyad == "DRCCON" & year >= 1970 & year <= 1997
replace enduring_rivalry = 1 if abbrevdyad == "DRCUGA" & year >= 1977 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "UGADRC" & year >= 1977 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "DRCZAM" & year >= 1971 & year <= 1994
replace enduring_rivalry = 1 if abbrevdyad == "ZAMDRC" & year >= 1971 & year <= 1994
replace enduring_rivalry = 1 if abbrevdyad == "UGAKEN" & year >= 1970 & year <= 1997
replace enduring_rivalry = 1 if abbrevdyad == "KENUGA" & year >= 1970 & year <= 1997
replace enduring_rivalry = 1 if abbrevdyad == "UGASUD" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "SUDUGA" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "SOMETH" & year >= 1970 & year <= 1985
replace enduring_rivalry = 1 if abbrevdyad == "ETHSOM" & year >= 1970 & year <= 1985
replace enduring_rivalry = 1 if abbrevdyad == "ETHSUD" & year >= 1970 & year <= 1997
replace enduring_rivalry = 1 if abbrevdyad == "SUDETH" & year >= 1970 & year <= 1997
replace enduring_rivalry = 1 if abbrevdyad == "MORALG" & year >= 1970 & year <= 1984
replace enduring_rivalry = 1 if abbrevdyad == "ALGMOR" & year >= 1970 & year <= 1984
replace enduring_rivalry = 1 if abbrevdyad == "IRNIRQ" & year >= 1970 & year <= 1999
replace enduring_rivalry = 1 if abbrevdyad == "IRQIRN" & year >= 1970 & year <= 1999
replace enduring_rivalry = 1 if abbrevdyad == "TURIRQ" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "IRQTUR" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "TURSYR" & year >= 1970 & year <= 1998
replace enduring_rivalry = 1 if abbrevdyad == "SYRTUR" & year >= 1970 & year <= 1998
replace enduring_rivalry = 1 if abbrevdyad == "IRQISR" & year >= 1970 & year <= 1998
replace enduring_rivalry = 1 if abbrevdyad == "ISRIRQ" & year >= 1970 & year <= 1998
replace enduring_rivalry = 1 if abbrevdyad == "IRQSAU" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "SAUIRQ" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "IRQKUW" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "KUWIRQ" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "SYRJOR" & year >= 1970 & year <= 1982
replace enduring_rivalry = 1 if abbrevdyad == "JORSYR" & year >= 1970 & year <= 1982
replace enduring_rivalry = 1 if abbrevdyad == "SYRISR" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "ISRSYR" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "LEBISR" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "ISRLEB" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "JORISR" & year >= 1970 & year <= 1973
replace enduring_rivalry = 1 if abbrevdyad == "ISRJOR" & year >= 1970 & year <= 1973
replace enduring_rivalry = 1 if abbrevdyad == "ISRSAU" & year >= 1970 & year <= 1981
replace enduring_rivalry = 1 if abbrevdyad == "SAUISR" & year >= 1970 & year <= 1981
replace enduring_rivalry = 1 if abbrevdyad == "AFGPAK" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "PAKAFG" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "CHNTAW" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "TAWCHN" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "CHNROK" & year >= 1970 & year <= 1994
replace enduring_rivalry = 1 if abbrevdyad == "ROKCHN" & year >= 1970 & year <= 1994
replace enduring_rivalry = 1 if abbrevdyad == "CHNJPN" & year >= 1978 & year <= 1999
replace enduring_rivalry = 1 if abbrevdyad == "JPNCHN" & year >= 1978 & year <= 1999
replace enduring_rivalry = 1 if abbrevdyad == "CHNIND" & year >= 1970 & year <= 1987
replace enduring_rivalry = 1 if abbrevdyad == "INDCHN" & year >= 1970 & year <= 1987
replace enduring_rivalry = 1 if abbrevdyad == "CHNDRV" & year >= 1975 & year <= 1998
replace enduring_rivalry = 1 if abbrevdyad == "DRVCHN" & year >= 1975 & year <= 1998
replace enduring_rivalry = 1 if abbrevdyad == "CHNPHI" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "PHICHN" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "PRKROK" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "ROKPRK" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "ROKJPN" & year >= 1970 & year <= 1999
replace enduring_rivalry = 1 if abbrevdyad == "JPNROK" & year >= 1970 & year <= 1999
replace enduring_rivalry = 1 if abbrevdyad == "INDPAK" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "PAKIND" & year >= 1970 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "INDBNG" & year >= 1976 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "BNGIND" & year >= 1976 & year <= 2001
replace enduring_rivalry = 1 if abbrevdyad == "THICAM" & year >= 1970 & year <= 1998
replace enduring_rivalry = 1 if abbrevdyad == "CAMTHI" & year >= 1970 & year <= 1998
replace enduring_rivalry = 1 if abbrevdyad == "THILAO" & year >= 1970 & year <= 1988
replace enduring_rivalry = 1 if abbrevdyad == "LAOTHI" & year >= 1970 & year <= 1988
replace enduring_rivalry = 1 if abbrevdyad == "THIDRV" & year >= 1970 & year <= 1995
replace enduring_rivalry = 1 if abbrevdyad == "DRVTHI" & year >= 1970 & year <= 1995
generate erivalry_weaker = enduring_rivalry*weaker_state_difference
*Hypotheses
logit  unanimous_support enduring_rivalry weaker_state_difference erivalry_weaker coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_unanimous timelastsponsor_unanimous, vce(robust)
logit  nonunanimous_support enduring_rivalry weaker_state_difference erivalry_weaker coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict  preexisting_nonunamious timelastsponsor_nonunanimous, vce(robust)
logit  total_support enduring_rivalry weaker_state_difference erivalry_weaker coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)


*Appendix Table 7
*Democracy Score
logit  unanimous_support democ coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_unanimous timelastsponsor_unanimous, vce(robust)
logit  nonunanimous_support democ coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict  preexisting_nonunamious timelastsponsor_nonunanimous, vce(robust)
logit  total_support democ coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
prgen democ, generate(_democ) rest(mean) n(10) ci
*Broad Government Type
replace semidemocratic = . if democ == .
replace autocratic = . if democ == .
logit  unanimous_support  autocratic semidemocratic coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_unanimous timelastsponsor_unanimous, vce(robust)
logit  nonunanimous_support  autocratic semidemocratic coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict  preexisting_nonunamious timelastsponsor_nonunanimous, vce(robust)
logit  total_support  autocratic semidemocratic coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)

*Appendix Table 8
*Tripartate Executive Constraints
gen triple_exec = .
replace triple_exec = 3 if xconst >= 6
replace triple_exec = 2 if xconst >= 3 & xconst <= 5
replace triple_exec = 1 if xconst <= 2
logit  unanimous_support triple_exec coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_unanimous timelastsponsor_unanimous, vce(robust)
logit  nonunanimous_support triple_exec coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict  preexisting_nonunamious timelastsponsor_nonunanimous, vce(robust)
logit  total_support triple_exec coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
prgen triple_exec, generate(_triple) rest(mean) n(10) ci
*POLCON Measurement
logit  unanimous_support polconiii coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_unanimous timelastsponsor_unanimous, vce(robust)
logit  nonunanimous_support polconiii coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict  preexisting_nonunamious timelastsponsor_nonunanimous, vce(robust)
logit  total_support polconiii coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
prgen polconiii, generate(_polcon) rest(mean) n(10) ci

*Appendix Table 9
*Same Geographic Region
generate same_region = 0
replace same_region = 1 if NorthAmerica_WestEurope == 1 & NorthAmerica_WestEurope_2 == 1
replace same_region = 1 if LatinAmerica == 1 & LatinAmerica_2 == 1
replace same_region = 1 if Africa == 1 & Africa_2 == 1
replace same_region = 1 if Middle_East == 1 & Middle_East_2 == 1
replace same_region = 1 if EastEurope_CentralAsia == 1 & EastEurope_CentralAsia_2 == 1
replace same_region = 1 if EastAsia_Oceania == 1 & EastAsia_Oceania_2 == 1
**Regression Analyses
logit  unanimous_support strategic_rivalry weaker_state_difference rivalry_weaker unanimoustargeted_tminus1 xconst coldwar militaryconflict preexisting_unanimous  same_region timelastsponsor_unanimous, vce(robust)
logit  nonunanimous_support strategic_rivalry weaker_state_difference rivalry_weaker nonunanimoustargeted_tminus1 xconst coldwar militaryconflict  preexisting_nonunamious   same_region timelastsponsor_nonunanimous, vce(robust)
logit  total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar militaryconflict preexisting_total   same_region timelastsponsor_total, vce(robust)
*Geographic Controls for Target
*North America & Western Europe
generate NorthAmerica_WestEurope_2 = 0
replace NorthAmerica_WestEurope_2 = 1 if ccode2 >= 2 & ccode2 <= 20
replace NorthAmerica_WestEurope_2 = 1 if ccode2 >= 200 & ccode2 <= 260
replace NorthAmerica_WestEurope_2 = 1 if ccode2 == 325
replace NorthAmerica_WestEurope_2 = 1 if ccode2 >= 375 & ccode2 <= 390
*Latin America
generate LatinAmerica_2 = 0
replace LatinAmerica_2 = 1 if ccode2 >=31 & ccode2 <= 165
*Africa
generate Africa_2 = 0
replace Africa_2 = 1 if ccode2 >=402 & ccode2 <= 591
*Middle East
generate Middle_East_2 = 0
replace Middle_East_2 = 1 if ccode2 >= 600 & ccode2 <= 698
*Eastern Europe & Central Asia
generate EastEurope_CentralAsia_2 = 0
replace EastEurope_CentralAsia_2 = 1 if ccode2 >= 265 & ccode2 <= 373
replace EastEurope_CentralAsia_2 = 1 if ccode2 >= 700 & ccode2 <= 705
*East Asia & Oceania
generate EastAsia_Oceania_2 = 0
replace EastAsia_Oceania_2 = 1 if ccode2 >= 710 & ccode2 <= 990
*Regression Analyses
logit  unanimous_support strategic_rivalry weaker_state_difference rivalry_weaker unanimoustargeted_tminus1 xconst coldwar  NorthAmerica_WestEurope_2 LatinAmerica_2 Africa_2 Middle_East_2 EastEurope_CentralAsia_2 militaryconflict preexisting_unanimous timelastsponsor_unanimous, vce(robust)
logit  nonunanimous_support strategic_rivalry weaker_state_difference rivalry_weaker nonunanimoustargeted_tminus1 xconst coldwar  NorthAmerica_WestEurope_2 LatinAmerica_2 Africa_2 Middle_East_2 EastEurope_CentralAsia_2 militaryconflict  preexisting_nonunamious timelastsponsor_nonunanimous, vce(robust)
logit  total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar  NorthAmerica_WestEurope_2 LatinAmerica_2 Africa_2 Middle_East_2 EastEurope_CentralAsia_2 militaryconflict preexisting_total timelastsponsor_total, vce(robust)

*Appendix Table 10
*Civil War Dyads Only
generate civil_war = 0
*41 Haiti
replace civil_war = 1 if ccode2 == 41 & year == 1989
replace civil_war = 1 if ccode2 == 41 & year == 1991
replace civil_war = 1 if ccode2 == 41 & year == 2004
*52 Trinidad and Tobago
replace civil_war = 1 if ccode2 == 52 & year == 1990
*70 Mexico
replace civil_war = 1 if ccode2 == 70 & year == 1994
replace civil_war = 1 if ccode2 == 70 & year == 1996
*90 Guatemala 
replace civil_war = 1 if ccode2 == 90 & year >= 1970 & year <= 1995
*92 El Salvador
replace civil_war = 1 if ccode2 == 92 & year >= 1979 & year <= 1991
*93 Nicaragua
replace civil_war = 1 if ccode2 == 93 & year >= 1977 & year <= 1979
replace civil_war = 1 if ccode2 == 93 & year >= 1982 & year <= 1990
*95 Panama
replace civil_war = 1 if ccode2 == 95 & year == 1989
*100 Colombia
replace civil_war = 1 if ccode2 == 100 & year >= 1970 
*101 Venezuela
replace civil_war = 1 if ccode2 == 101 & year == 1982
replace civil_war = 1 if ccode2 == 101 & year == 1992
*135 Peru
replace civil_war = 1 if ccode2 == 135 & year >= 1982 & year <= 1999
replace civil_war = 1 if ccode2 == 135 & year >= 2007
*150 Paraguay
replace civil_war = 1 if ccode2 == 150 & year == 1989
*155 Chile
replace civil_war = 1 if ccode2 == 155 & year == 1973
*160 Argentina
replace civil_war = 1 if ccode2 == 160 & year >= 1974 & year <= 1977
*165 Uruguay
replace civil_war = 1 if ccode2 == 165 & year == 1972
*200 United Kingdom
replace civil_war = 1 if ccode2 == 200 & year >= 1971 & year <= 1991
replace civil_war = 1 if ccode2 == 200 & year == 1998
*230 Spain
replace civil_war = 1 if ccode2 == 230 & year >= 1978 & year <= 1982
replace civil_war = 1 if ccode2 == 230 & year >= 1985 & year <= 1987
replace civil_war = 1 if ccode2 == 230 & year >= 1991 & year <= 1992
*235 Portugal
replace civil_war = 1 if ccode2 == 235 & year >= 1970 & year <= 1974
*343 Macedonia
replace civil_war = 1 if ccode2 == 343 & year == 2001
*344 Croatia
replace civil_war = 1 if ccode2 == 344 & year >= 1992 & year <= 1995
*345 Yugoslavia
replace civil_war = 1 if ccode2 == 345 & year == 1991
replace civil_war = 1 if ccode2 == 345 & year >= 1998 & year <= 1999
*346 Bosnia and Herzegovina
replace civil_war = 1 if ccode2 == 346 & year >= 1992 & year <= 1995
*359 Moldova
replace civil_war = 1 if ccode2 == 359 & year == 1992
*360 Romania
replace civil_war = 1 if ccode2 == 360 & year == 1989
*365 Russia 
replace civil_war = 1 if ccode2 == 365 & year == 1990
replace civil_war = 1 if ccode2 == 365 & year >= 1993 & year <= 1996
replace civil_war = 1 if ccode2 == 365 & year >= 1999
*372 Georgia
replace civil_war = 1 if ccode2 == 372 & year >= 1992 & year <= 1993
replace civil_war = 1 if ccode2 == 372 & year == 2004
replace civil_war = 1 if ccode2 == 372 & year == 2008
*373 Azerbaijan
replace civil_war = 1 if ccode2 == 373 & year >= 1991 & year <= 1995
replace civil_war = 1 if ccode2 == 373 & year == 2005
*404 Guinea-Bissau
replace civil_war = 1 if ccode2 == 404 & year >= 1998 & year <= 1999
*420 Gambia
replace civil_war = 1 if ccode2 == 420 & year == 1981
*432 Mali
replace civil_war = 1 if ccode2 == 432 & year == 1990
replace civil_war = 1 if ccode2 == 432 & year == 1994
replace civil_war = 1 if ccode2 == 432 & year >= 2007
*433 Senegal
replace civil_war = 1 if ccode2 == 433 & year >= 1990 & year <= 2003
*435 Mauritania
replace civil_war = 1 if ccode2 == 435 & year >= 1975 & year <= 1978
*436 Niger
replace civil_war = 1 if ccode2 == 436 & year >= 1991 & year <= 1992
replace civil_war = 1 if ccode2 == 436 & year == 1994
replace civil_war = 1 if ccode2 == 436 & year == 1995
replace civil_war = 1 if ccode2 == 436 & year == 1997
replace civil_war = 1 if ccode2 == 436 & year >= 2007 & year <= 2008
*438 Guinea
replace civil_war = 1 if ccode2 == 438 & year >= 2000 & year <= 2001
*439 Burkina Faso
replace civil_war = 1 if ccode2 == 439 & year == 1987
*450 Liberia
replace civil_war = 1 if ccode2 == 450 & year == 1980
replace civil_war = 1 if ccode2 == 450 & year >= 1989 & year <= 1990
replace civil_war = 1 if ccode2 == 450 & year >= 2000 & year <= 2003
*451 Sierra Leone
replace civil_war = 1 if ccode2 == 451 & year >= 1991 & year <= 2000
*452 Ghana
replace civil_war = 1 if ccode2 == 452 & year == 1981
replace civil_war = 1 if ccode2 == 452 & year == 1983
*461 Togo
replace civil_war = 1 if ccode2 == 461 & year == 1986
*471 Cameroon
replace civil_war = 1 if ccode2 == 471 & year == 1984
*475 Nigeria
replace civil_war = 1 if ccode2 == 475 & year == 1970
replace civil_war = 1 if ccode2 == 475 & year == 2004
*482 Central African Republic
replace civil_war = 1 if ccode2 == 482 & year >= 2001 & year <= 2002
replace civil_war = 1 if ccode2 == 482 & year == 2006
*483 Chad
replace civil_war = 1 if ccode2 == 483 & year >= 1970 & year <= 1972
replace civil_war = 1 if ccode2 == 483 & year >= 1976 & year <= 1986
replace civil_war = 1 if ccode2 == 483 & year >= 1989 & year <= 1994
replace civil_war = 1 if ccode2 == 483 & year >= 1997 & year <= 2002
replace civil_war = 1 if ccode2 == 483 & year >= 2005 & year <= 2008
*484 Congo
replace civil_war = 1 if ccode2 == 484 & year == 1993
replace civil_war = 1 if ccode2 == 484 & year >= 1997 & year <= 2002
*490 DRC
replace civil_war = 1 if ccode2 == 490 & year >= 1977 & year <= 1978
replace civil_war = 1 if ccode2 == 490 & year >= 1996 & year <= 2001
replace civil_war = 1 if ccode2 == 490 & year >= 2006
*500 Uganda
replace civil_war = 1 if ccode2 == 500 & year >= 1971 & year <= 1972
replace civil_war = 1 if ccode2 == 500 & year == 1974
replace civil_war = 1 if ccode2 == 500 & year >= 1979 & year <= 2008
*501 Kenya
replace civil_war = 1 if ccode2 == 501 & year == 1982
*516 Burundi
replace civil_war = 1 if ccode2 == 516 & year >= 1991 & year <= 1992
replace civil_war = 1 if ccode2 == 516 & year >= 1994 & year <= 2003
*517 Rwanda
replace civil_war = 1 if ccode2 == 517 & year >= 1990 & year <= 1994
replace civil_war = 1 if ccode2 == 517 & year >= 1997 & year <= 2002
*520 Somalia
replace civil_war = 1 if ccode2 == 520 & year >= 1982 & year <= 1996
replace civil_war = 1 if ccode2 == 520 & year >= 2001 & year <= 2002
replace civil_war = 1 if ccode2 == 520 & year >= 2006
*522 Djibouti
replace civil_war = 1 if ccode2 == 522 & year >= 1991 & year <= 1994
replace civil_war = 1 if ccode2 == 522 & year >= 1997 & year <= 1999
*530 Ethiopia
replace civil_war = 1 if ccode2 == 530 & year >= 1970
*531 Eritrea
replace civil_war = 1 if ccode2 == 531 & year >= 1997 & year <= 1999
replace civil_war = 1 if ccode2 == 531 & year == 2003
*540 Angola
replace civil_war = 1 if ccode2 == 540 & year >= 1975 
*541 Mozambique
replace civil_war = 1 if ccode2 == 541 & year >= 1977 & year <= 1992
*560 South Africa
replace civil_war = 1 if ccode2 == 560 & year >= 1970 & year <= 1988
*570 Lesotho
replace civil_war = 1 if ccode2 == 570 & year == 1998 
*580 Madagascar
replace civil_war = 1 if ccode2 == 580 & year == 1971 
*581 Comoros
replace civil_war = 1 if ccode2 == 581 & year == 1989
replace civil_war = 1 if ccode2 == 581 & year == 1997
*600 Morocco
replace civil_war = 1 if ccode2 == 600 & year == 1971
replace civil_war = 1 if ccode2 == 600 & year == 1975 & year <= 1989
*615 Algeria
replace civil_war = 1 if ccode2 == 615 & year >= 1990
*616 Tunisia
replace civil_war = 1 if ccode2 == 616 & year == 1980
*625 Sudan
replace civil_war = 1 if ccode2 == 625 & year >= 1970 & year <= 1972
replace civil_war = 1 if ccode2 == 625 & year == 1976
replace civil_war = 1 if ccode2 == 625 & year >= 1983
*630 Iran
replace civil_war = 1 if ccode2 == 630 & year >= 1979 & year <= 2001
replace civil_war = 1 if ccode2 == 630 & year >= 2005
*640 Turkey
replace civil_war = 1 if ccode2 == 640 & year >= 1984
*645  Iraq
replace civil_war = 1 if ccode2 == 645 & year >= 1970 & year <= 1996
replace civil_war = 1 if ccode2 == 645 & year >= 2004
*651 Egypt
replace civil_war = 1 if ccode2 == 651 & year >= 1993 & year <= 1998
*652 Syria
replace civil_war = 1 if ccode2 == 652 & year >= 1979 & year <= 1982
*660 Lebanon
replace civil_war = 1 if ccode2 == 660 & year >= 1975 & year <= 1976
replace civil_war = 1 if ccode2 == 660 & year >= 1983 & year <= 1986
replace civil_war = 1 if ccode2 == 660 & year == 1989
*666 Israel
replace civil_war = 1 if ccode2 == 666 & year >= 1970
*670 Saudi Arabia
replace civil_war = 1 if ccode2 == 670 & year == 1979
*678 North Yemen
replace civil_war = 1 if ccode2 == 678 & year == 1970
replace civil_war = 1 if ccode2 == 678 & year >= 1979 & year <= 1982
*679 Yemen
replace civil_war = 1 if ccode2 == 679 & year == 1994
*680 South Yemen
replace civil_war = 1 if ccode2 == 680 & year == 1986
*698 Oman 
replace civil_war = 1 if ccode2 == 698 & year >= 1970 & year <= 1975
*700 Afghanistan
replace civil_war = 1 if ccode2 == 700 & year >= 1978 & year <= 2001
replace civil_war = 1 if ccode2 == 700 & year >= 2003
*702 Tajikistan
replace civil_war = 1 if ccode2 == 702 & year >= 1992 & year <= 1998
*704 Uzbekistan
replace civil_war = 1 if ccode2 == 704 & year >= 1999 & year <= 2000
replace civil_war = 1 if ccode2 == 704 & year == 2004
*750 India
replace civil_war = 1 if ccode2 == 750 & year >= 1970 & year <= 1971
replace civil_war = 1 if ccode2 == 750 & year >= 1979
*770 Pakistan
replace civil_war = 1 if ccode2 == 770 & year == 1971
replace civil_war = 1 if ccode2 == 770 & year >= 1974 & year <= 1977
replace civil_war = 1 if ccode2 == 770 & year == 1990
replace civil_war = 1 if ccode2 == 770 & year >= 1995 & year <= 1996
replace civil_war = 1 if ccode2 == 770 & year >= 2004
*771 Bangladesh
replace civil_war = 1 if ccode2 == 771 & year >= 1975 & year <= 1992
*775 Myanmar
replace civil_war = 1 if ccode2 == 775 & year >= 1970
*780 Sri Lanka
replace civil_war = 1 if ccode2 == 780 & year == 1971
replace civil_war = 1 if ccode2 == 780 & year >= 1984
*790 Nepal
replace civil_war = 1 if ccode2 == 790 & year >= 1996 & year <= 2006
*800 Thailand
replace civil_war = 1 if ccode2 == 800 & year >= 1974 & year <= 1982
replace civil_war = 1 if ccode2 == 800 & year >= 2003
*811 Cambodia
replace civil_war = 1 if ccode2 == 811 & year >= 1970 & year <= 1975
replace civil_war = 1 if ccode2 == 811 & year >= 1978 & year <= 1998
*812 Laos
replace civil_war = 1 if ccode2 == 812 & year >= 1970 & year <= 1973
replace civil_war = 1 if ccode2 == 812 & year >= 1989 & year <= 1990
*820 Malaysia
replace civil_war = 1 if ccode2 == 820 & year >= 1974 & year <= 1975
replace civil_war = 1 if ccode2 == 820 & year == 1981
*840 Philippines
replace civil_war = 1 if ccode2 == 840 & year >= 1970
*850 Indonesia
replace civil_war = 1 if ccode2 == 850 & year >= 1976 & year <= 1981
replace civil_war = 1 if ccode2 == 850 & year == 1984
*910 Papua New Guinea
replace civil_war = 1 if ccode2 == 910 & year >= 1989 & year <= 1996
*Regression Analyses
logit  total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if civil_war == 1, vce(robust)
logit  total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if civil_war == 0, vce(robust)
logit  total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)

*Apendix Table 11
**Military Support for terrorist groups**
generate military_support = 0
* African National Congress
replace military_support = 1 if ccode1 == 365 & ccode2 == 560 & year == 1981
*al-Gama'at al-Islamiyya (IG)
replace military_support = 1 if ccode1 == 625 & ccode2 == 651 & year == 1993 
*Al-Ittihaad al-Islami (AIAI)
replace military_support = 1 if ccode1 == 625 & ccode2 == 530 & year == 1996 
replace military_support = 1 if ccode1 == 531 & ccode2 == 530 & year == 1996 
*All Tripura Tiger Force (ATTF)
replace military_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 1992
*Al-Shabaab
replace military_support = 1 if ccode1 == 531 & ccode2 == 520 & year == 2008
*Armed Islamic Group (GIA)
replace military_support = 1 if ccode1 == 625 & ccode2 == 615 & year == 1993 
replace military_support = 1 if ccode1 == 630 & ccode2 == 615 & year == 1993 
*Baloch Liberation Army (BLA)
replace military_support = 1 if ccode1 == 750 & ccode2 == 770 & year == 2005 
replace military_support = 1 if ccode1 == 700 & ccode2 == 770 & year == 2005 
*Baloch Republican Army (BRA)
replace military_support = 1 if ccode1 == 750 & ccode2 == 770 & year == 2008
replace military_support = 1 if ccode1 == 700 & ccode2 == 770 & year == 2008
*Burma Communist Party
replace military_support = 1 if ccode1 == 710 & ccode2 == 775 & year == 1988 
*Communist Party of India - Maoist (CPI-M)
replace military_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 2005
*Communist Party of Thailand
replace military_support = 1 if ccode1 == 710 & ccode2 == 800 & year == 1979 
replace military_support = 1 if ccode1 == 816 & ccode2 == 800 & year == 1979 
*Contras
replace military_support = 1 if ccode1 == 2 & ccode2 == 93 & year == 1982
*Dev Sol
replace military_support = 1 if ccode1 == 652 & ccode2 == 640 & year == 1991 
replace military_support = 1 if ccode1 == 350 & ccode2 == 640 & year == 1991 
*Eritrean Liberation Front
replace military_support = 1 if ccode1 == 652 & ccode2 == 530 & year == 1970 
replace military_support = 1 if ccode1 == 645 & ccode2 == 530 & year == 1970 
replace military_support = 1 if ccode1 == 365 & ccode2 == 530 & year == 1970 
*Eritrean Peoples Liberation Front
replace military_support = 1 if ccode1 == 620 & ccode2 == 530 & year == 1989 
replace military_support = 1 if ccode1 == 645 & ccode2 == 530 & year == 1989 
replace military_support = 1 if ccode1 == 652 & ccode2 == 530 & year == 1989 
replace military_support = 1 if ccode1 == 625 & ccode2 == 530 & year == 1989
*Ethiopian People's Revolutionary Party
replace military_support = 1 if ccode1 == 625 & ccode2 == 530 & year == 1986 
*Farabundo Marti National Liberation Front
replace military_support = 1 if ccode1 == 93 & ccode2 == 92 & year == 1978 
replace military_support = 1 if ccode1 == 40 & ccode2 == 92 & year == 1978 
*Free Aceh Movement (GAM)
replace military_support = 1 if ccode1 == 620 & ccode2 == 850 & year == 1977 
*Front for the Liberation of the Enclave of Cabinda (FLEC)
replace military_support = 1 if ccode1 == 484 & ccode2 == 540 & year == 1992 
*Hezb-e Wahdat-e Islami-yi Afghanistan
replace military_support = 1 if ccode1 == 630 & ccode2 == 700 & year == 1992
*Hizballah
replace military_support = 1 if ccode1 == 630 & ccode2 == 666 & year == 1983
replace military_support = 1 if ccode1 == 652 & ccode2 == 666 & year == 1983
*Hizb-I-Islami
replace military_support = 1 if ccode1 == 2 & ccode2 == 365 & year == 1988
replace military_support = 1 if ccode1 == 770 & ccode2 == 365 & year == 1988
*Irish Republican Army (IRA)
replace military_support = 1 if ccode1 == 620 & ccode2 == 200 & year == 1971
*Islamic Courts Union (ICU)
replace military_support = 1 if ccode1 == 531 & ccode2 == 520 & year == 2007
*Islamic Legion
replace military_support = 1 if ccode1 == 625 & ccode2 == 483 & year == 1990
replace military_support = 1 if ccode1 == 620 & ccode2 == 483 & year == 1990
*Islamic Movement for Change
replace military_support = 1 if ccode1 == 630 & ccode2 == 670 & year == 1996
*Islamic Salvation Front (FIS)
replace military_support = 1 if ccode1 == 630 & ccode2 == 615 & year == 1992 
replace military_support = 1 if ccode1 == 625 & ccode2 == 615 & year == 1992 
*Jamiat-e Islami-yi Afghanistan
replace military_support = 1 if ccode1 == 2 & ccode2 == 700 & year == 1992
replace military_support = 1 if ccode1 == 630 & ccode2 == 700 & year == 1992
*Justice and Equality Movement (JEM)
replace military_support = 1 if ccode1 == 531 & ccode2 == 625 & year == 2006 
replace military_support = 1 if ccode1 == 620 & ccode2 == 625 & year == 2006 
replace military_support = 1 if ccode1 == 483 & ccode2 == 625 & year == 2006
*Karen National Union
replace military_support = 1 if ccode1 == 800 & ccode2 == 775 & year == 1979 
replace military_support = 1 if ccode1 == 750 & ccode2 == 775 & year == 1988
*Khmer Rouge
replace military_support = 1 if ccode1 == 710 & ccode2 == 811 & year == 1989 
replace military_support = 1 if ccode1 == 800 & ccode2 == 811 & year == 1989 
*Kosovo Liberation Army (KLA)
replace military_support = 1 if ccode1 == 339 & ccode2 == 345 & year == 1998 
*Kurdish Democratic Party-Iraq (KDP)
replace military_support = 1 if ccode1 == 666 & ccode2 == 645 & year == 1984 
*Kurdistan Workers' Party (PKK)
replace military_support = 1 if ccode1 == 652 & ccode2 == 640 & year == 1984 
replace military_support = 1 if ccode1 == 630 & ccode2 == 640 & year == 1984 
*Liberation Tigers of Tamil Eelam (LTTE)
replace military_support = 1 if ccode1 == 750 & ccode2 == 780 & year == 1975 
*Liberians United for Reconciliation and Democracy (LURD)
replace military_support = 1 if ccode1 == 438 & ccode2 == 450 & year == 2001 
*Lord's Resistance Army (LRA)
replace military_support = 1 if ccode1 == 625 & ccode2 == 500 & year == 1994 
*M-19 (Movement of April 19)
replace military_support = 1 if ccode1 == 40 & ccode2 == 100 & year == 1978
*Mahdi Army
replace military_support = 1 if ccode1 == 630 & ccode2 == 645 & year == 2004
*Moro National Liberation Front (MNLF)
replace military_support = 1 if ccode1 == 620 & ccode2 == 840 & year == 1975 
replace military_support = 1 if ccode1 == 820 & ccode2 == 840 & year == 1975 
replace military_support = 1 if ccode1 == 630 & ccode2 == 840 & year == 1975 
*Movement of Democratic Forces of Casamamance
replace military_support = 1 if ccode1 == 435 & ccode2 == 433 & year == 1990 
replace military_support = 1 if ccode1 == 420 & ccode2 == 433 & year == 1990 
replace military_support = 1 if ccode1 == 404 & ccode2 == 433 & year == 1990 
*Mozambique National Resistance Movement
replace military_support = 1 if ccode1 == 552 & ccode2 == 541 & year == 1979
replace military_support = 1 if ccode1 == 560 & ccode2 == 541 & year == 1979 
replace military_support = 1 if ccode1 == 501 & ccode2 == 541 & year == 1979
*Mujahedin-e Khalq (MEK)
replace military_support = 1 if ccode1 == 645 & ccode2 == 630 & year == 1979
*Muslim Brotherhood
replace military_support = 1 if ccode1 == 645 & ccode2 == 652 & year == 1979 
replace military_support = 1 if ccode1 == 663 & ccode2 == 652 & year == 1979
*National Congress for the Defense of the People (CNDP)
replace military_support = 1 if ccode1 == 517 & ccode2 == 490 & year == 2008
*National Liberation Front of Tripura (NLFT)
replace military_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 1995
*National Patriotic Front of Liberia (NPFL)
replace military_support = 1 if ccode1 == 437 & ccode2 == 450 & year == 1990
replace military_support = 1 if ccode1 == 620 & ccode2 == 450 & year == 1990
replace military_support = 1 if ccode1 == 439 & ccode2 == 450 & year == 1990
*National Redemption Front
replace military_support = 1 if ccode1 == 483 & ccode2 == 625 & year == 2006
*National Socialist Council of Nagaland
replace military_support = 1 if ccode1 == 775 & ccode2 == 750 & year == 1992 
replace military_support = 1 if ccode1 == 771 & ccode2 == 750 & year == 1992 
replace military_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 1992 
replace military_support = 1 if ccode1 == 710 & ccode2 == 750 & year == 1992 
*National Union for the Total Independence of Angola (UNITA)
replace military_support = 1 if ccode1 == 560 & ccode2 == 540 & year == 1978
replace military_support = 1 if ccode1 == 2 & ccode2 == 540 & year == 1978 
replace military_support = 1 if ccode1 == 490 & ccode2 == 540 & year == 1978 
replace military_support = 1 if ccode1 == 510 & ccode2 == 540 & year == 1978 
replace military_support = 1 if ccode1 == 551 & ccode2 == 540 & year == 1978 
replace military_support = 1 if ccode1 == 666 & ccode2 == 540 & year == 1978 
replace military_support = 1 if ccode1 == 651 & ccode2 == 540 & year == 1978 
replace military_support = 1 if ccode1 == 670 & ccode2 == 540 & year == 1978 
replace military_support = 1 if ccode1 == 690 & ccode2 == 540 & year == 1978 
*Nicaraguan Democratic Force (FDN)
replace military_support = 1 if ccode1 == 2 & ccode2 == 93 & year == 1983 
replace military_support = 1 if ccode1 == 91 & ccode2 == 93 & year == 1983 
replace military_support = 1 if ccode1 == 94 & ccode2 == 93 & year == 1983
*Palestine Liberation Organization (PLO)
replace military_support = 1 if ccode1 == 663 & ccode2 == 666 & year == 1970 
replace military_support = 1 if ccode1 == 652 & ccode2 == 666 & year == 1970 
replace military_support = 1 if ccode1 == 651 & ccode2 == 666 & year == 1970 
replace military_support = 1 if ccode1 == 645 & ccode2 == 666 & year == 1970 
replace military_support = 1 if ccode1 == 630 & ccode2 == 666 & year == 1970 
*Patriotic Union of Kurdistan (PUK)
replace military_support = 1 if ccode1 == 652 & ccode2 == 645 & year == 1981 
replace military_support = 1 if ccode1 == 630 & ccode2 == 645 & year == 1981 
replace military_support = 1 if ccode1 == 2 & ccode2 == 645 & year == 1981 
replace military_support = 1 if ccode1 == 620 & ccode2 == 645 & year == 1981 
*People's Liberation Army (India)
replace military_support = 1 if ccode1 == 771 & ccode2 == 750 & year == 1984 
replace military_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 1984
*People's War Group (PWG)
replace military_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 1990 
*Polisario Front
replace military_support = 1 if ccode1 == 615 & ccode2 == 600 & year == 1976 
replace military_support = 1 if ccode1 == 620 & ccode2 == 600 & year == 1976 
*Rally of Democratic Forces (RAFD)
replace military_support = 1 if ccode1 == 625 & ccode2 == 483 & year == 2006
*Revolutionary United Front (RUF)
replace military_support = 1 if ccode1 == 450 & ccode2 == 451 & year == 1993 
replace military_support = 1 if ccode1 == 439 & ccode2 == 451 & year == 1993 
replace military_support = 1 if ccode1 == 620 & ccode2 == 451 & year == 1993 
*Rohingya Solidarity Organization
replace military_support = 1 if ccode1 == 620 & ccode2 == 775 & year == 1992
*Rwanda Patriotic Front (RPF)
replace military_support = 1 if ccode1 == 500 & ccode2 == 517 & year == 1992 
*Sandinista National Liberation Front (FSLN)
replace military_support = 1 if ccode1 == 40 & ccode2 == 93 & year == 1970 
replace military_support = 1 if ccode1 == 94 & ccode2 == 93 & year == 1970 
*Shanti Bahini - Peace Force
replace military_support = 1 if ccode1 == 750 & ccode2 == 771 & year == 1986
*South-West Africa People's Organization (SWAPO)
replace military_support = 1 if ccode1 == 551 & ccode2 == 560 & year == 1975 
replace military_support = 1 if ccode1 == 540 & ccode2 == 560 & year == 1975 
*Sudan Liberation Movement
replace military_support = 1 if ccode1 == 531 & ccode2 == 625 & year == 2007 
replace military_support = 1 if ccode1 == 620 & ccode2 == 625 & year == 2007 
replace military_support = 1 if ccode1 == 483 & ccode2 == 625 & year == 2007 
*Sudan People's Liberation Army (SPLA)
replace military_support = 1 if ccode1 == 666 & ccode2 == 625 & year == 1986 
replace military_support = 1 if ccode1 == 670 & ccode2 == 625 & year == 1986 
replace military_support = 1 if ccode1 == 552 & ccode2 == 625 & year == 1986 
replace military_support = 1 if ccode1 == 651 & ccode2 == 625 & year == 1986 
replace military_support = 1 if ccode1 == 530 & ccode2 == 625 & year == 1986 
replace military_support = 1 if ccode1 == 531 & ccode2 == 625 & year == 1991 
replace military_support = 1 if ccode1 == 2 & ccode2 == 625 & year == 1986 
*Supreme Council for Islamic Revolution in Iraq (SCIRI)
replace military_support = 1 if ccode1 == 630 & ccode2 == 645 & year == 1992 
*Tunisian Armed Resistance
replace military_support = 1 if ccode1 == 620 & ccode2 == 616 & year == 1980
*Union of Forces for Democracy and Development (UFDD)
replace military_support = 1 if ccode1 == 625 & ccode2 == 483 & year == 2006
*United Front for Democratic Change (FUCD)
replace military_support = 1 if ccode1 == 625 & ccode2 == 483 & year == 2006
*United Liberation Front of Assam (ULFA)
replace military_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 1988
*United National Liberation Front (UNLF)
replace military_support = 1 if ccode1 == 771 & ccode2 == 750 & year == 2003 
replace military_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 2003 
*United Somali Congress
replace military_support = 1 if ccode1 == 620 & ccode2 == 520 & year == 1992
*Western Somalia Liberation Front
replace military_support = 1 if ccode1 == 520 & ccode2 == 530 & year == 1983
replace military_support = 1 if ccode1 == 520 & ccode2 == 40 & year == 1983
*Zimbabwe African Nationalist Union (ZANU)
replace military_support = 1 if ccode1 == 365 & ccode2 == 552 & year == 1978 
replace military_support = 1 if ccode1 == 40 & ccode2 == 552 & year == 1978 
replace military_support = 1 if ccode1 == 710 & ccode2 == 552 & year == 1978 


**Non-Military Support for terrorist groups**
generate nonmilitary_support = 0
*al-Fatah
replace nonmilitary_support = 1 if ccode1 == 660 & ccode2 == 666 & year == 1971 
*al-Gama'at al-Islamiyya (IG)
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 651 & year == 1991 
*Al-Qa`ida
replace nonmilitary_support = 1 if ccode1 == 625 & ccode2 == 2 & year == 1992 
replace nonmilitary_support = 1 if ccode1 == 700 & ccode2 == 2 & year == 1992
*Al-Qassam Brigades
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 666 & year == 2002
*Al-Sa'iqa
replace nonmilitary_support = 1 if ccode1 == 652 & ccode2 == 666 & year == 1984 
*Al-Umar Mujahideen
replace nonmilitary_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 1991 
*Amal
replace nonmilitary_support = 1 if ccode1 == 652 & ccode2 == 660 & year == 1980 
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 660 & year == 1980
*Arab Commando Cells
replace nonmilitary_support = 1 if ccode1 == 620 & ccode2 == 660 & year == 1986
*Arab Liberation Front (ALF)
replace nonmilitary_support = 1 if ccode1 == 645 & ccode2 == 666 & year == 1979 
*Arab Revenge Organization
replace nonmilitary_support = 1 if ccode1 == 620 & ccode2 == 660 & year == 1984
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 660 & year == 1984
*Arabian Peninsula Freemen
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 670 & year == 1989
*Bougainville Revolutionary Army (BRA)
replace nonmilitary_support = 1 if ccode1 == 940 & ccode2 == 910 & year == 1989 
*Cinchoneros Popular Liberation Movement
replace nonmilitary_support = 1 if ccode1 == 40 & ccode2 == 91 & year == 1981 
*Committee of Solidarity with Arab and Middle East Political Prisoners (CSPPA)
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 220 & year == 1986
*Contras
replace nonmilitary_support = 1 if ccode1 == 160 & ccode2 == 93 & year == 1981
*Democratic Front for Renewal (FDR)
replace nonmilitary_support = 1 if ccode1 == 483 & ccode2 == 436 & year == 1995
*Democratic Front for the Liberation of Palestine (DFLP)
replace nonmilitary_support = 1 if ccode1 == 652 & ccode2 == 666 & year == 1974 
replace nonmilitary_support = 1 if ccode1 == 620 & ccode2 == 666 & year == 1974 
replace nonmilitary_support = 1 if ccode1 == 365 & ccode2 == 666 & year == 1974 
replace nonmilitary_support = 1 if ccode1 == 40 & ccode2 == 666 & year == 1974 
*Dnestr Republic Separatists
replace nonmilitary_support = 1 if ccode1 == 365 & ccode2 == 359 & year == 1992
*Free Aceh Movement (GAM)
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 850 & year == 1977 
*Free Papua Movement (OPM-Organisasi Papua Merdeka)
replace nonmilitary_support = 1 if ccode1 == 620 & ccode2 == 850 & year == 1990 
*Front de Liberation du Quebec (FLQ)
replace nonmilitary_support = 1 if ccode1 == 615 & ccode2 == 20 & year == 1970
replace nonmilitary_support = 1 if ccode1 == 40 & ccode2 == 20 & year == 1970
*Guardsmen of Islam
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 220 & year == 1980 
*Hamas (Islamic Resistance Movement)
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 666 & year == 1989
*Harakat ul-Mujahidin (HuM)
replace nonmilitary_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 199
*Harkat ul Ansar
replace nonmilitary_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 1994 
*Irish Republican Army (IRA)
replace nonmilitary_support = 1 if ccode1 == 205 & ccode2 == 200 & year == 1971
*Islamic Movement of Uzbekistan (IMU)
replace nonmilitary_support = 1 if ccode1 == 670 & ccode2 == 704 & year == 2000 
*Jammu and Kashmir Islamic Front
replace nonmilitary_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 1995
*Jundallah
replace nonmilitary_support = 1 if ccode1 == 2 & ccode2 == 630 & year == 2006 
*Kurdish Democratic Party-Iraq (KDP)
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 645 & year == 1976 
replace nonmilitary_support = 1 if ccode1 == 640 & ccode2 == 645 & year == 1976
replace nonmilitary_support = 1 if ccode1 == 640 & ccode2 == 645 & year == 1984 
*May 15 Organization for the Liberation of Palestine
replace nonmilitary_support = 1 if ccode1 == 645 & ccode2 == 666 & year == 1980
*Montoneros (Argentina)
replace nonmilitary_support = 1 if ccode1 == 40 & ccode2 == 160 & year == 1970  
*Movement for Democracy and Development (MDD)
replace nonmilitary_support = 1 if ccode1 == 620 & ccode2 == 483 & year == 1995 
*Movement of the Revolutionary Left (MIR)
replace nonmilitary_support = 1 if ccode1 == 40 & ccode2 == 155 & year == 1976 
replace nonmilitary_support = 1 if ccode1 == 540 & ccode2 == 155 & year == 1976 
replace nonmilitary_support = 1 if ccode1 == 615 & ccode2 == 155 & year == 1976 
replace nonmilitary_support = 1 if ccode1 == 541 & ccode2 == 155 & year == 1976 
replace nonmilitary_support = 1 if ccode1 == 93 & ccode2 == 155 & year == 1976
*National Socialist Council of Nagaland-Isak-Muivah (NSCN-IM)
replace nonmilitary_support = 1 if ccode1 == 710 & ccode2 == 750 & year == 2000
replace nonmilitary_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 2000 
*New People's Army (NPA)
replace nonmilitary_support = 1 if ccode1 == 710 & ccode2 == 840 & year == 1970 
*Ogaden National Liberation Front (ONLF)
replace nonmilitary_support = 1 if ccode1 == 531 & ccode2 == 530 & year == 2007
*Palestinian Islamic Jihad (PIJ)
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 666 & year == 1990
*Peykar
replace nonmilitary_support = 1 if ccode1 == 2 & ccode2 == 630 & year == 1982
*Popular Forces of April 25
replace nonmilitary_support = 1 if ccode1 == 620 & ccode2 == 235 & year == 1980 
*Popular Front for the Liberation of Palestine (PFLP)
replace nonmilitary_support = 1 if ccode1 == 652 & ccode2 == 666 & year == 1970 
replace nonmilitary_support = 1 if ccode1 == 620 & ccode2 == 666 & year == 1970 
replace nonmilitary_support = 1 if ccode1 == 365 & ccode2 == 666 & year == 1970 
replace nonmilitary_support = 1 if ccode1 == 710 & ccode2 == 666 & year == 1970  
*Red Flag (Venezuela)
replace nonmilitary_support = 1 if ccode1 == 40 & ccode2 == 101 & year == 1972 
*Revolutionary Armed Forces of Colombia
replace nonmilitary_support = 1 if ccode1 == 40 & ccode2 == 100 & year == 1975 
*Revolutionary Front for an Independent East Timor (Fretilin)
replace nonmilitary_support = 1 if ccode1 == 235 & ccode2 == 850 & year == 1992 
*Revolutionary Organization of Socialist Muslims
replace nonmilitary_support = 1 if ccode1 == 652 & ccode2 == 200 & year == 1984 
replace nonmilitary_support = 1 if ccode1 == 620 & ccode2 == 200 & year == 1984 
replace nonmilitary_support = 1 if ccode1 == 645 & ccode2 == 200 & year == 1984 
*Shan State Army
replace nonmilitary_support = 1 if ccode1 == 800 & ccode2 == 775 & year == 2008 
*Sons of the South
replace nonmilitary_support = 1 if ccode1 == 666 & ccode2 == 660 & year == 1984 
*Students Islamic Movement of India (SIMI)
replace nonmilitary_support = 1 if ccode1 == 770 & ccode2 == 750 & year == 2001 
*Taliban
replace nonmilitary_support = 1 if ccode1 == 670 & ccode2 == 700 & year == 1995
*Tupamaros (Uruguay)
replace nonmilitary_support = 1 if ccode1 == 40 & ccode2 == 165 & year == 1970 
*Turkish Islamic Jihad
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 640 & year == 1991
*United Arab Revolution
replace nonmilitary_support = 1 if ccode1 == 630 & ccode2 == 690 & year == 1986 
*United Nasirite Organizaiton
replace nonmilitary_support = 1 if ccode1 == 620 & ccode2 == 352 & year == 1986
replace nonmilitary_support = 1 if ccode1 == 620 & ccode2 == 200 & year == 1986
*Regression Analyses
logit  military_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
logit  nonmilitary_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)

*Appendix Table 12
*Simultaneous Equation Model
clear
use "delegatingterror_simultaneous.dta", clear
replace xconst_ccode1 = . if xconst_ccode1 < 0
replace xconst_ccode2 = . if xconst_ccode2 < 0
generate rivalry_weaker_ccode1 =  strategic_rivalry* diff_capabilities_ccode1
generate rivalry_weaker_ccode2 =  strategic_rivalry* diff_capabilities_ccode2
*Regression Analyses
biprobit (unanimous_support_ccode1 strategic_rivalry diff_capabilities_ccode1 rivalry_weaker_ccode1 unanimoustargeted_tminus1_ccode1 xconst_ccode1 coldwar NorthAmerica_WE_ccode1 LatinAmerica_ccode1 Africa_ccode1 Middle_East_ccode1 EastEurope_CA_ccode1 militaryconflict_ccode1 preexisting_unanimous_ccode1) (unanimous_support_ccode2 strategic_rivalry diff_capabilities_ccode2 rivalry_weaker_ccode2 unanimoustargeted_tminus1_ccode2 xconst_ccode2 coldwar NorthAmerica_WE_ccode2 LatinAmerica_ccode2 Africa_ccode2 Middle_East_ccode2 EastEurope_CA_ccode2 militaryconflict_ccode2 preexisting_unanimous_ccode2), robust
biprobit (nonunanimous_support_ccode1 strategic_rivalry diff_capabilities_ccode1 rivalry_weaker_ccode1 nonunantargeted_tminus1_ccode1 xconst_ccode1 coldwar NorthAmerica_WE_ccode1 LatinAmerica_ccode1 Africa_ccode1 Middle_East_ccode1 EastEurope_CA_ccode1 militaryconflict_ccode1 preexisting_nonunamious_ccode1) (nonunanimous_support_ccode2 strategic_rivalry diff_capabilities_ccode2 rivalry_weaker_ccode2 nonunantargeted_tminus1_ccode2 xconst_ccode2 coldwar NorthAmerica_WE_ccode2 LatinAmerica_ccode2 Africa_ccode2 Middle_East_ccode2 EastEurope_CA_ccode2 militaryconflict_ccode2 preexisting_nonunamious_ccode2), robust
biprobit (total_support_ccode1 strategic_rivalry diff_capabilities_ccode1 rivalry_weaker_ccode1 totaltargeted_tminus1_ccode1 xconst_ccode1 coldwar NorthAmerica_WE_ccode1 LatinAmerica_ccode1 Africa_ccode1 Middle_East_ccode1 EastEurope_CA_ccode1 militaryconflict_ccode1 preexisting_total_ccode1) (total_support_ccode2 strategic_rivalry diff_capabilities_ccode2 rivalry_weaker_ccode2 totaltargeted_tminus1_ccode2 xconst_ccode2 coldwar NorthAmerica_WE_ccode2 LatinAmerica_ccode2 Africa_ccode2 Middle_East_ccode2 EastEurope_CA_ccode2 militaryconflict_ccode2 preexisting_total_ccode2), robust

