	**** Datensatz einlesen

use "Z:\GWA4 - Cantoni\A_Mikrodaten\evs1998_gwap.dta", clear


	*** Nur oestliche Bundeslaender:
	*** (keep only states in East Germany)

drop if ef4<12

	*** Generierung von (Dummy)-Variablen fuer Haushaltseigenschaften
	*** (generate categorical variables for household characteristics)

quietly tab ef4, gen(bula)
gen berlinost = ef4==22
gen smallcity = ef6==1

replace ef9u3=98-ef9u3 if ef9u3~=99
replace ef9u3=100 if ef9u3==99

rename ef9u3 age
gen agesq=age^2

gen single=.
replace single=1 if ef91==1 | ef91==2
replace single=0 if ef91>2  & ef91~=.

gen female=0
replace female=1 if ef9u2==2

gen german=.
replace german=1 if ef9u5==1
replace german=0 if ef9u5==2 | ef9u5==3

gen employed=0
replace employed=1 if ef9u7>=1 & ef9u7<=5

gen retired=0
replace retired=1 if ef9u7==8 | ef9u7==7

gen kids=.
replace kids=ef81+ef82+ef83+ef84+ef85

gen onwelfare=0
replace onwelfare=1 if ef90>=1


	*** Schaffung der Treatment-Variablen
	*** (generate treatment indicator)

gen treat=(ard_signalstaerke__durchschn_<-86.8)
gen treatpr=1-1/(1+exp(-(ard_signalstaerke__durchschn_+84.6)/2.3))

	*** Umdefinieren der Treatment-Variablen
	*** (redefine treatment indicator as treat=gets TV)

recode treat (0=1) (1=0)
replace treatpr=1-treatpr

	*** Kontrollvariablen neu benennen
	*** (rename control variables)

rename ef2_sysfrei muni
rename ef95 weight 
rename ef20 netincome
rename ef21 disposableincome
rename ef26 transfers
rename entfernung_zur_brd__km_ distkm
rename entfernung_zur_brd__stunden_ disthr
gen ln_netincome = log(netincome)
gen ln_dispincome = log(disposableincome)
gen ln_transfers = log(transfers)
	
	
		*** Konsum und Sparverhalten
		*** (consumption vs. saving)
	
gen saving = ef46+ef47-(ef467+ef468+ef469+ef470+ef471+ef472+ef473+ef474+ef475+ef476+ef477+ef478+ef479+ef480+ef481+ef482+ef483+ef484+ef485+ef486+ef440+ef441+ef442+ef443+ef444+ef445+ef446)
gen saving01 = (saving>0)
	
gen savingslevel=ef58
gen savingslevel01 = (savingslevel>0)

	
		*** Kreditaufnahme
		*** (credit taking behavior)
	
gen int_conscredit = ef720
gen int_overdraft = ef721
	
foreach X in int_conscredit int_overdraft {
	gen `X'01 = (`X'>0)
}
	
	*** Aggregieren der Konsumvariablen in Gruppen
	*** (aggregate consumption expenditure variables into groups)


gen ef100001 = ef668+ef669+ef674+ef675+ef676+ef680+ef681+ef682+ef683+ef684+ef685+ef686+ef687 // Media, leisure
gen ef100002 = ef642 // Cleaning and washing
gen ef100004 = ef648+ef699+ef700 // Body care + Mouth care
gen ef100005 = ef651+ef652+ef655+ef656+ef657+ef658+ef659 // Cars, accessories
gen ef100006 = ef30 // Clothes, textiles
gen ef100007 = ef583 // Food + sweets + Milk + non-alcoholic beverages + Hot drinks + Beer, wine + Liquors
gen ef100008 = ef33+ef677 // Home and garden
gen ef100012 = ef644+ef645 // Pharmaceuticals
gen ef100013 = ef670+ef672+ef673+ef701 // Photo, optics, watches, jewelry
gen ef100014 = ef660+ef661+ef662+ef663+ef664+ef688+ef689+ef697 // Transportation and tourism

gen ef100015 = ef41-ef100001-ef100002-ef100004-ef100005-ef100006-ef100007-ef100008-ef100012-ef100013-ef100014 // All other private consumption
gen ef100000 = ef100001+ef100002+ef100004+ef100005+ef100006+ef100007+ef100008+ef100012+ef100013+ef100014 // All advertised consumption
gen ef100100 = ef41 // All private consumption

foreach X of numlist 0(1)15 100 {
	cap gen ln_ef`=100000+`X'' = log(ef`=100000+`X'')
}

foreach X of numlist 0(1)15 100 {
	cap gen ln0_ef`=100000+`X'' = log(1+ef`=100000+`X'')
}

foreach X of numlist 0(1)15 {
	cap gen sh_ef`=100000+`X'' = ef`=100000+`X''/ef41
}
