
* Original Bolks and Stoll 2000 Model, Table 2
sureg (gbsships gbtht3 gbpdef3 gbins3 gblshp3 gbwar gbwarwin gbmilal3) ///
(ussships ustht3 uspdef3 usins3 uslshp3 uswar uswarwin uswarlos uscomp3 usmilal3) ///
(frsships frtht3 frpdef3 frins3 frlshp3 frwar frwarwin frmilal3) ///
(rusships rutht3 rupdef3 ruins3 rulshp3 ruwar ruwarwin rucomp3 rumilal3), corr

* Bolks and Stoll model with Crisher Souva tonnage data: 3 year lag of dv        

sureg (gb_tonnage gbtht3 gbpdef3 gbins3 gb_tonnagelag3 gbwar gbwarwin gbmilal3) ///
(usa_tonnage ustht3 uspdef3 usins3 usa_tonnagelag3 uswar uswarwin usa_competitionlag3 usmilal3) ///
(france_tonnage frtht3 frpdef3 frins3 france_tonnagelag3 frwar frwarwin frmilal3) ///
(russia_tonnage rutht3 rupdef3 ruins3 russia_tonnagelag3 ruwar ruwarwin russia_competitionlag3 rumilal3), corr
