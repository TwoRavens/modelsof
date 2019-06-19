	**** Datensatz einlesen

use  "Z:\GWA4 - Cantoni\A_Mikrodaten\evs1993_gwap.dta", clear


	*** Nur oestliche Bundeslaender:
	*** (keep only states in East Germany)

drop if ef3<12


	*** Generierung von (Dummy-)Variablen fuer Haushaltseigenschaften
	*** (generate categorical variables for household characteristics)

quietly tab ef3, gen(bula)
gen berlinost = ef3==22
gen smallcity = ef5==1

replace ef8u1 = 93-ef8u1
rename ef8u1 age
gen agesq=age^2

gen female=0
replace female=1 if ef8u2==2

gen single=.
replace single=1 if ef56==1 | ef56==2
replace single=0 if ef56>2  & ef56~=.

gen german=.
replace german=1 if ef8u6==1
replace german=0 if ef8u6==2

gen employed=0
replace employed=1 if ef8u5<=6 & ef8u5~=.

gen retired=0
replace retired=1 if ef8u5>=8 & ef8u5<=9

gen onwelfare=0
replace onwelfare=1 if ef61==2


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
rename ef58 kids
rename ef66 weight
rename ef19 netincome
rename ef21 disposableincome
rename ef26 transfers
rename entfernung_zur_brd__km_ distkm
rename entfernung_zur_brd__stunden_ disthr

gen ln_netincome = log(netincome)
gen ln_dispincome = log(disposableincome)
gen ln_transfers = log(transfers)
	
	
	*** Konsum und Sparverhalten
	*** (consumption vs. saving)

gen saving = ef50+ef51-(ef382+ef383+ef384+ef385+ef386+ef387+ef388+ef389+ef390+ef391+ef392+ef393+ef394+ef395+ef396+ef397+ef398+ef399+ef400+ef401+ef402+ef624)
gen saving01 = (saving>0)

gen savingslevel=ef770
gen savingslevel01 = (savingslevel>0)


	*** Kreditaufnahme
	*** (credit taking behavior)

gen int_conscredit = ef625
gen int_overdraft = ef626

foreach X in int_conscredit int_overdraft {
	gen `X'01 = (`X'>0)
}


	*** Aggregieren der Konsumvariablen in Gruppen
	*** (aggregate consumption expenditure variables into groups)


gen ef100001 = ef541+ef542+ef543+ef549+ef551+ef552+12*(ef553+ef554+ef555)+ef556+12*(ef558+ef559+ef561+ef564+ef565+ef566+ef567+ef568+ef578) // Media, leisure
gen ef100002 = 12*(ef498+ef499) // Cleaning and washing
gen ef100004 = ef510+12*(ef514+ef515+ef516+ef517+ef518) // Body care + mouth care
gen ef100005 = ef519+ef520+ef523+ef525+ef526+12*ef527+ef528+ef530+12*ef531+ef534 // Cars, accessories
gen ef100006 = ef32+12*ef581 // Clothes, textiles
gen ef100007 = ef31 // Food + sweets + Milk + non-alcoholic beverages + Hot drinks + Beer, wine + Liquors
gen ef100008 = ef35+12*(ef569+ef570+ef571+ef572) // Home and garden
gen ef100012 = 12*(ef504+ef505+ef506) // Pharmaceuticals
gen ef100013 = ef546+12*(ef547+ef548)+12*ef550+12*(ef557+ef560)+ef579 // Photo, optics, watches, jewelry
gen ef100014 = 12*ef535+ef536+ef537+ef540+ef583+ef584+ef585+ef586+ef587+ef588+ef589+ef590+ef591 // Transportation and tourism

gen ef100015 = ef40-ef100001-ef100002-ef100004-ef100005-ef100006-ef100007-ef100008-ef100012-ef100013-ef100014 // All other private consumption
gen ef100000 = ef100001+ef100002+ef100004+ef100005+ef100006+ef100007+ef100008+ef100012+ef100013+ef100014 // All advertised consumption
gen ef100100 = ef40 // All private consumption

foreach X of numlist 0(1)15 100 {
	cap gen ln_ef`=100000+`X'' = log(ef`=100000+`X'')
}

foreach X of numlist 0(1)15 100 {
	cap gen ln0_ef`=100000+`X'' = log(1+ef`=100000+`X'')
}

foreach X of numlist 0(1)15 {
	cap gen sh_ef`=100000+`X'' = ef`=100000+`X''/ef100100
}


