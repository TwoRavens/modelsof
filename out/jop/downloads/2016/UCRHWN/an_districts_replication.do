********************************************************************************
* Baumann, Debus, Klingelhöfer: 
* Keeping One’s Seat: The Competiveness of MP Renomination in Mixed-Member Electoral Systems
* 
* Analysis of renomination competitiveness in the list tier
* Dataset: data_districts.dta
* Stata version: 12
*
********************************************************************************

version 12
clear all
macro drop _all
set linesize 200

global file = // assign path to working directory

use "$file\Replication Renomination Competitiveness\data_districts.dta", clear


///////////////	
// DESCRIPTIVE STATISTICS

* Table 2: Competition in Renomination for District Candidacy by Party
tab intraparty_compet_B party, col

* Figure 1b: Distribution of ideological positions within parliamentary party groups in the German Bundestag, 2009–2013
* set scheme plotplain_mb
graph box ts_raw if ///
	!((Kandidaten_Nachname=="Kauder" & Kandidaten_Vorname=="Volker") | Kandidaten_Nachname=="Gysi" | Kandidaten_Nachname=="Steinmeier" | Kandidaten_Nachname=="Brüderle" | ///
		Kandidaten_Nachname=="Homburger" | Kandidaten_Nachname=="Künast" | Kandidaten_Nachname=="Trittin") ///
		, ytitle("Left-right ideological dimension", size(medsmall)) over(partei_string) label ylabel(3.8(0.1)4.3)

////////////////////
// REGRESSION MODELS

* Model 1: 
eststo M1: logit intraparty_compet_B deviation_bdm_sqts_raw ts_raw_se rookie female AusschussVors age east diff_firstsecond ///
	, cluster(land) 

* Model 2: 
eststo M2: logit intraparty_compet_B c.deviation_bdm_sqts_raw##i.union ts_raw_se rookie female AusschussVors age east diff_firstsecond ///
	, cluster(land) 

* Model 3:
eststo M3: logit intraparty_compet_B deviation_bdm_sqts_raw alq_2012 i.union ts_raw_se rookie female AusschussVors age east diff_firstsecond ///
	, cluster(land) 

* Table 4:
esttab M1 M2 M3, ///
    abs b(2) se(2) ///
    aic ///
    scalars("r2_p Pseudo R²") ///
    star(+ 0.10 * 0.05 ** 0.01) ///
    mtitles("Model 1" "Model 2" "Model 3" "Model 4") ///
    nonotes addnotes("+ significant at 10%, * significant at 5%, ** significant at 1%.") ///
	label

