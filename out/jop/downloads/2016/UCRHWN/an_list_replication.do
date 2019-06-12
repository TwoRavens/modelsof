********************************************************************************
* Baumann, Debus, Klingelhöfer: 
* Keeping One’s Seat: The Competiveness of MP Renomination in Mixed-Member Electoral Systems
* 
* Analysis of renomination competitiveness in the list tier
* Dataset: data_list.dta
* Stata version: 12
*
********************************************************************************

version 12
clear all
macro drop _all
set linesize 200

global file = // assign path to working directory

use "$file\Replication Renomination Competitiveness\data_list.dta", clear

///////////////	
// DESCRIPTIVE STATISTICS

* Table 1: Changes in list positioning by party affiliation
tab listChange_relativ_cat party, col

* Figure 1: Distribution of ideological positions within parliamentary party groups in the German Bundestag, 2009–2013
gen partei_figure = partei_string
replace partei_figure = "CDU/CSU" if partei_string=="CSU"
replace partei_figure = "CDU/CSU" if partei_string=="CDU"
replace partei_figure = "Greens" if partei_string=="GRÜNE"
replace partei_figure = "The Left" if partei_string=="DIE LINKE"

drop if partei_figure=="Anderer KWV"

graph box ts_raw if ///
	!((Kandidaten_Nachname=="Kauder" & Kandidaten_Vorname=="Volker") | Kandidaten_Nachname=="Gysi" | Kandidaten_Nachname=="Steinmeier" | Kandidaten_Nachname=="Brüderle" | ///
		Kandidaten_Nachname=="Homburger" | Kandidaten_Nachname=="Künast" | Kandidaten_Nachname=="Trittin") ///
		, over(partei_figure) ytitle("Estimated left-right position", size(large)) ylabel(3.8(0.1)4.3, labsize(large))

* Figure 2: Positions of prominent and/or leftist/rightist MPs
* Angela Merkel
gen merkel_lr = 0
replace merkel_lr = ts_raw if Kandidaten_Nachname=="Merkel" & Kandidaten_Vorname=="Angela"
egen merkel_lr_ = max(merkel_lr)

* Ursula von der Leyen
gen leyen_lr = 0
replace leyen_lr = ts_raw if Kandidaten_Nachname=="von der Leyen"
egen leyen_lr_ = max(leyen_lr)

* Matthias Birkwald (former DKP, now reform faction)
gen birkwald_lr = 0
replace birkwald_lr = ts_raw if Kandidaten_Nachname=="Birkwald"
egen birkwald_lr_ = max(birkwald_lr)

* Stefan Liebich
gen liebich_lr = 0
replace liebich_lr = ts_raw if Kandidaten_Nachname=="Liebich"
egen liebich_lr_ = max(liebich_lr)

* Petra Ernstberger (Seeheimer Circle)
gen ernst_lr = 0
replace ernst_lr = ts_raw if Kandidaten_Nachname=="Ernstberger"
egen ernst_lr_ = max(ernst_lr)

* Andrea Nahles
gen nahles_lr = 0
replace nahles_lr = ts_raw if Kandidaten_Nachname=="Nahles"
egen nahles_lr_ = max(nahles_lr)

* Sahra Wagenknecht
gen wagen_lr = 0
replace wagen_lr = ts_raw if Kandidaten_Nachname=="Wagenknecht"
egen wagen_lr_ = max(wagen_lr)

gen test = 1
gen test_ = 2
gen test__ = 3

set scheme plotplain
twoway (scatter  test  ts_raw if party==2, mcolor(gs14) mlabcolor(black) msymbol(circle)) ///
(scatter  test_  ts_raw if party==5, mcolor(gs12) mlabcolor(black) msymbol(circle)) ///
(scatter  test__  ts_raw if party==6, mcolor(gs10) mlabcolor(black) msymbol(circle)) ///
(scatter test liebich_lr_ if Kandidaten_Nachname=="Liebich", mcolor(black) mlabcolor(black) mlabel(Kandidaten_Nachname)  msymbol(circle) mlabpos(6)) ///
(scatter test birkwald_lr_ if Kandidaten_Nachname=="Birkwald", mcolor(black) mlabcolor(black) mlabel(Kandidaten_Nachname)  msymbol(circle) mlabpos(6)) ///
(scatter test_ nahles_lr_ if Kandidaten_Nachname=="Nahles", mcolor(black) mlabcolor(black) mlabel(Kandidaten_Nachname)  msymbol(circle) mlabpos(6)) ///
(scatter test__ merkel_lr_ if Kandidaten_Nachname=="Merkel", mcolor(black) mlabcolor(black) mlabel(Kandidaten_Nachname)  msymbol(circle) mlabpos(12)) ///
(scatter test__ leyen_lr_ if Kandidaten_Nachname=="von der Leyen", mcolor(black) mlabcolor(black) mlabel(Kandidaten_Nachname)  msymbol(circle) mlabpos(6)) ///
(scatter test_ ernst_lr_ if Kandidaten_Nachname=="Ernstberger", mcolor(black) mlabcolor(black) mlabel(Kandidaten_Nachname)  msymbol(circle) mlabpos(6) ///
  ylabel(0 " " 1 "The Left" 2 "SPD" 3 "CDU/CSU"  4 " ") xlabel(3.8(0.1)4.3) ///
xtitle(Estimated left-right position) aspectratio(1)) ///
, legend(off) 


////////////////////
// REGRESSION MODELS

* Model 1:
eststo M1: ologit listChange_relativ_cat c.deviation_bdm_sqts_raw ts_raw_se list_only_2009 list_only_2013, ///
	cluster(party)

* Model 2
eststo M2: ologit listChange_relativ_cat c.deviation_bdm_sqts_raw i.government seatshare ts_raw_se female rookie AusschussVors east age list_only_2009 list_only_2013, ///
	cluster(party)

* Model 3:
eststo M3: ologit listChange_relativ_cat c.deviation_bdm_sqts_raw##i.government seatshare rookie female AusschussVors east age ts_raw_se list_only_2009 list_only_2013, ///
	cluster(party)

* Table 3:
esttab M1 M2 M3, ///
    abs b(2) se(2) ///
    aic ///
    scalars("r2_p Pseudo R²") ///
    star(+ 0.10 * 0.05 ** 0.01) ///
    nonotes addnotes("+ significant at 10%, * significant at 5%, ** significant at 1%.") ///
	label	

* Figure 3: Marginsplot for deviation and government status (Model 3)
label define govstatus 0 "Opposition MPs" 1 "Government MPs"
label values government_B govstatus	
est res M3
margins, predict(outcome(1)) at(government=(0 (1) 1) deviation_bdm_sqts_raw=(0.0001(.001).031)) vsquish
* set scheme plotplain_mb
marginsplot, x(deviation_bdm_sqts_raw) recast(line) level(90) title("") ///
	ytitle("Likelihood to receive a worse position on the party list") ///
	xtitle("Ideological distance between party and MP")

* Alternative variant of model 3 mentioned in footnote 7:
ologit listChange_relativ_cat c.deviation_bdmts_raw##i.government seatshare rookie female AusschussVors east age ts_raw_se list_only_2009 list_only_2013, ///
	cluster(party)
	
* Alternative variants of model 3 mentioned in footnote 8:
ologit listChange_relativ_cat c.deviation_bdm_sqts_lbg##i.government seatshare rookie female AusschussVors east age ts_raw_se list_only_2009 list_only_2013, ///
	cluster(party)
ologit listChange_relativ_cat c.deviation_bdm_sqts_mv##i.government seatshare rookie female AusschussVors east age ts_raw_se list_only_2009 list_only_2013, ///
	cluster(party)
ologit listChange_relativ_cat c.deviation_bdm_sqts_raw_r1##i.government seatshare rookie female AusschussVors east age ts_raw_se list_only_2009 list_only_2013, ///
	cluster(party)	
	
	
	
	