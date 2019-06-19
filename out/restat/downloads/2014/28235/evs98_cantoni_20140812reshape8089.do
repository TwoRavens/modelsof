	*** Datei umformen
	*** (reshape data) 
	
	* An dieser Stelle wird der Datensatz so umgeformt, dass nicht mehr jedes Individuum/Haushalt 
	* eine Beobachtung darstellt, sondern dass jede Kombination (Individuum*Konsumausgabe fuer 
	* Gut i) eine Beobachtung darstellt. Es wird also ein Panel-artiger Datensatz durch den
	* reshape-Befehl kreiert.

gen id=_n

rename ef4 bundesland
rename ef6 gemeindegr

keep ef100001 ef100002 ef100004 ef100005 ef100006 ef100007 ef100008 ef100012 ef100013 ef100014 ef100015 ///
	treat* ln_dispincome disposableincome kids weight id age agesq single female german employed retired onwelfare ///
	berlinost bula* smallcity muni dist* bundesland gemeindegr ard_signalstaerke__durchschn_

reshape long ef, i(id) j(good)


	*** Einfuegen der Info ueber Werbung im Fernsehen
	*** (adding info about minutes of advertising)

do "Z:\GWA4 - Cantoni\C_Programm\evs_cantoni_advertising8089.do"

gen minXtre = minpd8089*treat
gen shaXtre = share8089*treat

gen minXtrepr = minpd8089*treatpr
gen shaXtrepr = share8089*treatpr

gen minXdistkm = minpd8089*distkm
gen minXdisthr = minpd8089*disthr


	*** Generierung von Ausgabenvariablen: log(Ausgaben), relative Ausgaben
	*** (generate alternative expenditure variables)

gen logef = log(ef)
gen log0ef = log(1+ef)

bysort id: egen ef41=sum(ef)
gen ef_shexp = ef/ef41

replace logef=100*logef
replace log0ef=100*log0ef
replace ef_shexp = 100*ef_shexp


	*** Generierung der Gewichte
	*** (generate weights)

bysort good: egen totexpgood=total(ef)
egen totexp=total(ef)
gen budsh = totexpgood/totexp

gen wmix = budsh*weight


