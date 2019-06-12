

* Original Bolks and Stoll 2000 Model, Table 1
sureg (gbsships gbtht3 gbpdef3 gbins3 gblshp3 gbwar gbwarwin           dum1880 dum1910  gbcomp3 gbmilal3) ///
(ussships ustht3 uspdef3 usins3 uslshp3 uswar uswarwin           dum1880 dum1910  uscomp3 usmilal3) ///
(frsships frtht3 frpdef3 frins3 frlshp3 frwar frwarwin frwarlos  dum1880 dum1910  frcomp3 frmilal3) ///
(gesships getht3 gepdef3 geins3 gelshp3 gewar gewarwin           dum1880 dum1910  gecomp3 gemilal3) ///
(ahsships ahtht3 ahpdef3 ahins3 ahlshp3 ahwar ahwarwin ahwarlos  dum1880 dum1910  ahcomp3 ahmilal3) ///
(itsships ittht3 itpdef3 itins3 itlshp3 itwar itwarwin           dum1880 dum1910  itcomp3 itmilal3) ///
(rusships rutht3 rupdef3 ruins3 rulshp3 ruwar ruwarwin ruwarlos  dum1880 dum1910  rucomp3 rumilal3) ///
(jpsships jptht3 jppdef3 jpins3 jplshp3 jpwar jpwarwin           dum1880 dum1910  jpcomp3 jpmilal3), corr

* Bolks and Stoll with Crisher Souva tonnage data: 3 year lag of dv        

sureg (gb_tonnage gbtht3 gbpdef3 gbins3 gb_tonnagelag3 gbwar gbwarwin dum1880 dum1910 gb_compton3 gbmilal3) ///
(usa_tonnage ustht3 uspdef3 usins3 usa_tonnagelag3 uswar uswarwin dum1880 dum1910 usa_comp3 usmilal3) ///
(france_tonnage frtht3 frpdef3 frins3 france_tonnagelag3 frwar frwarwin frwarlos  dum1880 dum1910 france_comp3 frmilal3) ///
(germany_tonnage getht3 gepdef3 geins3 germany_tonnagelag3 gewar gewarwin dum1880 dum1910 germany_comp3 gemilal3) ///
(ah_tonnage ahtht3 ahpdef3 ahins3 ah_tonnagelag3 ahwar ahwarwin ahwarlos dum1880 dum1910 ah_comp3 ahmilal3) ///
(italy_tonnage ittht3 itpdef3 itins3 italy_tonnagelag3 itwar itwarwin dum1880 dum1910  italy_comp3 itmilal3) ///
(russia_tonnage rutht3 rupdef3 ruins3 russia_tonnagelag3 ruwar ruwarwin ruwarlos  dum1880 dum1910 russia_comp3 rumilal3) ///
(japan_tonnage jptht3 jppdef3 jpins3 japan_tonnagelag3 jpwar jpwarwin dum1880 dum1910 japan_comp3 jpmilal3), corr 

