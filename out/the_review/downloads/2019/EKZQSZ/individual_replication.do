*APSR replication files
*Title: When Do Citizens Respond Politically to the Local Economy? Evidence from Registry Data on Local Housing Markets
*Authors: Frederik Hjorth, Martin Vinæs Larsen, Peter Thisted Dinesen and Kim Mannemar Sønderskov.

*FILE PURPOSE: Produces Tables and Figures based on the individual-level analyses for both the article and the Online Appendix.
*VERSION: STATA 15.1

version 12
cd "E:\workdata\702992\702992\201607housing\replication files_APSR"
use "individual_replidata", clear

**setting some global definitions
global dist 1000 1500
global nom 20 40
global year 2002 2004 2006 2008 2010 2011

*setting up for time series analysis
tsset pnr panel

*setting up baseline variables to create tables
gen hp=.
gen lhp=.
gen uen=.
gen aincome=.
gen hppos=.
gen hpneg=.

tab round, gen(dumess)


*labeling
la var aincome1000 "Average income 1000 meters"
la var aincome1500 "Average income 1500 meters"
la var uen1000 "Unemployment rate 1000 meters"
la var uen1500 "Unemployment rate 1500 meters"
la var uenzip "Unemployment rate zip code"
la var aincomezip "Average income zip code"
la var hp_1yr1000 "$\Delta$ housing price  1000 meters"
la var hp_1yr1500 "$\Delta$ housing price 1500 meters"
la var hp_1yr20 "$\Delta$ housing price  20 closest"
la var hp_1yr40 "$\Delta$ housing price 40 closest"
la var hp_1yrzip "$\Delta$ housing price zip code"

la var hp "$\Delta$ housing price"
lab var edureg "Years of schooling"
lab var uen "Unemployment rate (context)"
lab var aincome "Average income (context)"
lab var hppos "$\Delta$ housing price (positive)"
lab var hpneg "$\Delta$ housing price (negative)"
lab var inter "Mover"
lab var lrscale "Left/Right Scale"
lab var pincome "Personal income"
la var oneunemplo4 "Unnemployed (household)"
la var homeown "Home Owner"
la var seller "Seller"
la var buyer "Buyer"
la var inmarket "Within Market"
la var outmarket "Outside Market"


**running all analyses that use different contextual variables
foreach i in  $nom $dist 3000 {
if `i' <501{
local d=1000 
}
if `i'>500 {
local d=`i'
}
if `i'!=3000{
replace uen=uen`d'
replace aincome=aincome`d'
replace hp=hp_1yr`i'
}
if `i'==3000{
replace uen=uenzip
replace aincome=aincomezip
replace hp=hp_1yrzip
}
*main models
qui eststo a`i': xtreg incs c.hp i.essround uen aincome pincome oneunemplo4 , fe vce(cluster pnr)
qui eststo b`i': xtreg incs c.hp##c.inter i.essround uen aincome pincome oneunemplo4 , fe vce(cluster pnr)

*extensions
qui eststo sup01`i': xtreg incs c.hp##c.inter i.essround uen aincome pincome oneunemplo4 if round!=2, fe vce(cluster pnr)
qui eststo sup10`i': xtreg incs c.hp c.homeown  i.essround uen aincome pincome oneunemplo4 , fe vce(cluster pnr)
qui eststo sup11`i': xtreg incs c.hp##c.homeown  i.essround uen aincome pincome oneunemplo4 , fe vce(cluster pnr)
qui eststo sup20`i': xtlogit incs c.hp i.essround uen aincome pincome oneunemplo4 , fe
qui eststo sup21`i': xtlogit incs c.hp##c.inter i.essround uen aincome pincome oneunemplo4 , fe
qui eststo sup30`i': xtreg lrscale c.hp i.essround uen aincome pincome oneunemplo4  , fe vce(cluster pnr)
qui eststo sup31`i': xtreg incs c.hp##(c.dumess2) i.essround uen aincome pincome oneunemplo4  , fe vce(cluster pnr)
qui eststo sup40`i': xtreg pm c.hp i.essround uen aincome pincome oneunemplo4  , fe vce(cluster pnr)
qui eststo sup41`i': xtreg pm c.hp##(c.inter) i.essround uen aincome pincome oneunemplo4  , fe vce(cluster pnr)
qui eststo sup50`i': xtreg incs c.hp i.essround edureg lrscale uen aincome pincome oneunemplo4  , fe vce(cluster pnr)
qui eststo sup51`i': xtreg incs c.hp##(c.inter) edureg lrscale i.essround uen aincome pincome oneunemplo4  , fe vce(cluster pnr)
qui eststo sup60`i': xtreg incs c.hp##c.seller   i.essround uen aincome pincome oneunemplo4  , fe vce(cluster pnr)
qui eststo sup61`i': xtreg incs c.hp##c.buyer   i.essround uen aincome pincome oneunemplo4  , fe vce(cluster pnr)
}


*tables for the main manuscript

*table 4
esttab a20 a40 a1000 a1500 a3000 using table4.tex, replace star(* 0.05) label keep(hp uen aincome oneunemplo4 pincome) ///
mtitles("20 Closest"  "40 Closest" "1000 metres"   "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Linear Regression of Voting for Governing party"} \footnotesize  \label{inddv) se 

*table 5
esttab b20 b40 b1000 b1500 b3000 using table5.tex, replace star(* 0.05) label keep(hp c.hp#c.inter inter uen aincome oneunemplo4 pincome ) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Linear Regression of Voting for Governing party"} \footnotesize  \label{tabmovers) se 



*appendix

*Table G1-G9
esttab sup2020 sup2040 sup201000 sup201500 sup203000 using tableg1.tex, replace star(* 0.05) label keep(hp uen aincome oneunemplo4 pincome ) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Logistic Regression of Voting for Governing party"} \footnotesize  \label{logit) se 

esttab sup2120 sup2140 sup211000 sup211500 sup213000 using tableg2.tex, replace star(* 0.05) label keep(hp c.hp#c.inter inter uen aincome oneunemplo4 pincome ) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Logistic Regression of Voting for Governing party"} \label{logitinter) se 

esttab sup1020 sup1040 sup101000 sup101500 sup103000 using tableg3.tex, replace star(* 0.05) label keep(hp homeown uen aincome oneunemplo4 pincome ) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Linear Regression of Voting for Governing party"} \footnotesize  \label{homebase) se 

esttab sup1120 sup1140 sup111000 sup111500 sup113000 using tableg4.tex, replace star(* 0.05) label keep(hp c.hp#c.homeown homeown uen aincome oneunemplo4 pincome ) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Linear Regression of Voting for Governing party"} \footnotesize  \label{homeinter) se 

esttab sup3020 sup3040 sup301000 sup301500 sup303000 using tableg5.tex, replace star(* 0.05) label keep(hp uen aincome oneunemplo4 pincome ) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Linear Regression of Left-Right Self Placement (Ideology)"} \footnotesize  \label{lrscale) se 

esttab sup4020 sup4040 sup401000 sup401500 sup403000 using tableg6.tex, replace star(* 0.05) label keep(hp uen aincome oneunemplo4 pincome ) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Linear Regression of Voting for Prime Minister party"} \footnotesize  \label{pm) se 

esttab sup4120 sup4140 sup411000 sup411500 sup413000 using tableg7.tex, replace star(* 0.05) label keep(hp c.hp#c.inter inter uen aincome oneunemplo4 pincome ) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Linear Regression of Voting for Prime Minister party"} \footnotesize  \label{pmint) se 

esttab sup5020 sup5040 sup501000 sup501500 sup503000 using tableg8.tex, replace star(* 0.05) label keep(hp uen aincome oneunemplo4 pincome edureg lrscale) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Linear Regression of Voting for Governing party"} \footnotesize  \label{controls) se 

esttab sup5120 sup5140 sup511000 sup511500 sup513000 using tableg9.tex, replace star(* 0.05) label keep(hp c.hp#c.inter inter uen aincome oneunemplo4 pincome edureg lrscale) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Linear Regression of Voting for Governing party"} \footnotesize  \label{controlsint) se 

*Table K1
la var dumess2 "ESS round 2"
esttab sup3120 sup3140 sup311000 sup311500 sup313000 using tablek1.tex, replace star(* 0.05) label keep(hp c.hp#c.dumess2   uen aincome oneunemplo4 pincome ) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=dumess2" "Voter FE=2.essround") b(%9.3f) ///
title("Linear Regression of Voting for Governing party"} \footnotesize  \label{wave) se 

*Table L1-L2
esttab sup6020 sup6040 sup601000 sup601500 sup603000 using tablel1.tex, replace star(* 0.05) label keep(hp c.hp#c.seller seller uen aincome oneunemplo4 pincome) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Linear Regression of Voting for Governing party"} \footnotesize  \label{seller) se 

esttab sup6120 sup6140 sup611000 sup611500 sup613000 using tablel2.tex, replace star(* 0.05) label keep(hp c.hp#c.buyer buyer uen aincome oneunemplo4 pincome) ///
mtitles("20 Closest" "40 Closest" "1000 metres"  "1500 metres" "Zip code") nonum ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Linear Regression of Voting for Governing party"} \footnotesize  \label{buyer) se 

*extra analysis for those moving within the same market (table M1)
eststo a:  xtreg incs c.hp_1yrzip##c.inter aincomezip uenzip i.essround oneun pincome, fe vce(cluster pnr)
eststo b:  xtreg incs c.hp_1yrzip##c.inmarket aincomezip uenzip i.essround oneun pincome if outmarket==0, fe vce(cluster pnr)
eststo c:  xtreg incs c.hp_1yrzip##c.outmarket aincomezip uenzip i.essround oneun pincome if inmarket==0, fe vce(cluster pnr)


esttab a b c using tablem1.tex, replace star(* 0.05) label keep(hp_1yrzip c.hp_1yrzip#c.inmarket ///
c.hp_1yrzip#c.outmarket c.hp_1yrzip#c.inter c.hp_1yrzip#c.inmarket inter outmarket ///
inmarket uenzip aincomezip oneunemplo4 pincome) mtitles("All" "Outmarket" "Inmarket" ) ///
nonum order(hp_1yrzip inter inmarket outmarket c.hp_1yrzip#c.inter /// 
c.hp_1yrzip#c.inmarket c.hp_1yrzip#c.outmarket c.hp_1yrzip#c.outmarket ) ///
indicate("\hline  Round FE=2.essround" "Voter FE=4.essround") b(%9.3f) ///
title("Linear Regression of Voting for Governing party"} \footnotesize  \label{inoutmar) se 


*descriptive statistics (table c2)
la var incs "Government Voter"
la var pm "Prime Minister Voter"

drop  hp hppos hpneg uen aincome rounds lhp panel ageR _est* pnr essround zip dumess*
sutex * , labels title(Descriptive Statistics, Individual-level data) file(tablec2) nobs replace


