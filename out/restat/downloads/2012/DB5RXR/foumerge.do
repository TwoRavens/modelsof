version 8
clear
set memory 250m
capture log close
set more off


* Main point of this do file is to make a panel of 
* manufacturing firms where inforation from SIFON register is 
* included. Saves panel in foumerge.dta
* Some dropping of very small plants done here


* 1.
* Sjekker inYYYY filene for problem med bnr, fonr og naering og finner
* forslag til loesning
* 3.
* Lager et panel av industridata filene, 1972-2001. Fra 1990 er Sifon med.
* Bare utvalgte variable
* 4.
* Retter opp problem funnet i pkt 1.

* 6.
* Lager nye utenlandsk kategorivariabel fra 1990
* 
* 7. 
* Lagrer i ${industri}foumerge.dta, denne skal brukes i 
* neste do-fil med enkel rydding
**********************************************************************

* 1.
* Sjekker industridatafilene for problem med bnr, fonr og naeringskode
* Forslag til loesning av eventuelle problem

* Plukker industridata i 3 puljer etter hvilke variable jeg trenger
forvalues t=1972/1995 {
use ${IND_DIR}in`t', clear
keep aar bnr fonr naering 
gen bnrmis=1 if bnr==. | bnr==0
replace bnrmis=0 if bnrmis==.
gen fonrmis=1 if fonr==. | fonr==0
replace fonrmis=0 if fonrmis==.
gen isicmis=1 if naering==. | naering==0
replace isicmis=0 if isicmis==.
tempfile temp`t'
save temp`t', replace
}
forvalues t=1996/2000 {
use ${IND_DIR}in`t', clear
keep aar bnr fonr naering nace 
gen bnrmis=1 if bnr==. | bnr==0
replace bnrmis=0 if bnrmis==.
gen fonrmis=1 if fonr==. | fonr==0
replace fonrmis=0 if fonrmis==.
gen isicmis=1 if naering==. | naering==0
replace isicmis=0 if isicmis==.
assert nace!=.
tempfile temp`t'
save temp`t', replace
}
use ${industri}industri2001, clear
gen fonr=fnr
keep aar bnr fonr naering nace
gen bnrmis=1 if bnr==. | bnr==0
replace bnrmis=0 if bnrmis==.
gen fonrmis=1 if fonr==. | fonr==0
replace fonrmis=0 if fonrmis==.
gen isicmis=1 if naering==. | naering==0
replace isicmis=0 if isicmis==.
assert nace!=.
tempfile temp2001
save temp2001, replace

* Kobler temp filene i et panel
use temp1972
forvalues t=1973/2001 {
append using temp`t'
}
compress
* Sletter tempfilene igjen
forvalues t=1972/2001 {
erase temp`t'.dta
}
* Sjekker hvilke aar det er problem med manglende fonr og naering
assert bnrmis!=1
tab aar fonrmis 
tab aar isicmis 
* Tabellene over viser at det mangler ett fonr i 87 og i 97, 
* og 135 fonr i 2000, det mangler ingen bnr, naering mangler for 
* noen observasjoner etter 1996

* Er alle bnr bare observert 1 gang pr aar?
bys aar bnr: gen n=_n
assert n==1

* Ser paa missing fonr i 1987 og 1997
list if fonrmis==1 & aar!=2000
tsset bnr aar
list aar fonr naering  if bnr==6494404
list aar fonr naering if bnr==5746353
* Loesning for aaret 1987 er a bruke foretaksnr for samme bnr i 1988
* foretaksnr: 4857836
* Loesning for 1997 er aa droppe denne obs. da bnr bare er obs dette aaret

* Lager entry og exit variabel
sort bnr aar
drop n
bys bnr: gen n=_n
bys bnr: gen N=_N
by bnr: gen entry=aar[1]
by bnr: gen exit=aar[_N]

* Missing foretaksnr i 2000
tsset bnr aar
* Viser at problemet er at fonr=. og ikke at fonr=0
count if fonrmis==1 & aar==2000
count if fonr==. & aar==2000
count if fonr==0 & aar==2000
* Dropper bnr med fonr=. som bare er obs i 2000
drop if fonr==. & entry==exit & aar==2000
* Foerer fonr fram eller tilbake, hvis exit=2000 eller entry=2000
replace fonr=L.fonr if fonr==. & L.fonr!=. & aar==2000 & exit==2000
replace fonr=F.fonr if fonr==. & F.fonr!=. & aar==2000 & entry==2000
* Foerer fonr fram
replace fonr=L.fonr if fonr==. & aar==2000
list entry exit if fonr==. & aar==2000
* Foerer fonr tilbake for de bnr med exit i 2001
replace fonr=F.fonr if fonr==. & aar==2000
* De gjenvaerende 2 bnr med hull i obs i1999
replace fonr=fonr[_n-1] if fonr==. & aar==2000
assert fonr!=. if aar==2000

* Missing isickode
* Viser at problemet er at naering=. og ikke at naering=0
count if isicmis==1
count if naering==.
count if naering==. & nace!=.
* Viser at alle med naering=. har nacekode
tab entry if naering==.
tab aar if naering==.
* Retter opp manglende naeringskode
replace naering=L.naering if naering==. & entry <1995
count if naering==.
* For de resterende missing hjelper ikke de to kommandoene under
replace naering=L.naering if naering==.
replace naering=F.naering if naering==.
* Bruker en korrespondanse mellom nace og isic koder 
* for aa fylle isic koder som mangler. Korrespondansen finner 
* jeg ved manuell sjekk av Jarles Foudata\naering2.dta 
tab nace if naering==.
* Korrespondanse fra naering.dta
replace naering=31310 if nace==15930 & naering==.
replace naering=32111 if nace==17140 & naering==.
replace naering=32111 if nace==17170 & naering==.
replace naering=35409 if nace==23100 & naering==.
replace naering=35291 if nace==24630 & naering==.
replace naering=36100 if nace==26240 & naering==.
replace naering=36910 if nace==26250 & naering==.
replace naering=36910 if nace==26300 & naering==.
replace naering=36920 if nace==26530 & naering==.
replace naering=38192 if nace==27310 & naering==.
replace naering=38192 if nace==27330 & naering==.
replace naering=38520 if nace==33500 & naering==.
replace naering=38299 if nace==35410 & naering==.
count if naering==.


* 3.
* Lager et panel av industri-datafilene. For aarene 1972 til 1989: inYYYY.dta
* og for aarene 1990 - 2001: industriYYYY.dta (der Sifon data er kobla paa)
#delimit ;
forvalues t=1972/1982 {;
use ${IND_DIR}in`t', clear;
keep aar bnr fonr tilstand btype utenl bkode storb kopi 
naering landsdel kommune v13 v15 v29 v30 v32-v38 v42 v45-v47 
v54-v58 v64-v72 v87 v88 v101 v102 v104 v106 v108 v112 v114-v119 ktny;
rename fonr fnr;
tempfile temp`t';
save temp`t', replace;
};

forvalues t=1983/1989 {;
use ${IND_DIR}in`t', clear;
keep aar bnr fonr tilstand btype utenl bkode storb kopi 
naering landsdel kommune v13 v15 v29 v30 v32-v38 v42 v45-v47 
v54-v58 v64-v72 v87 v88 v104 v106 v108 v112 v114-v119 ktny;
rename fonr fnr;
tempfile temp`t';
save temp`t', replace;
};

forvalues t=1990/1992 {;
use ${industri}industri`t', clear;
keep aar bnr fnr tilstand btype utenl bkode storb kopi
naering landsdel kommune sifonorgnr nace 
v13 v15 v29 v30 v32-v38 v42 v45-v47 
v54-v58 v64-v72 v87 v88 v104 v106 v108 v112 v114-v119
nace1 tilst ftype stutla totutla sifonutenl stutla2 
totutla2 stutland stutland2 _merge ktny; 
tempfile temp`t';
save temp`t', replace;
};
forvalues t=1993/1994 {;
use ${industri}industri`t', clear;
keep aar bnr fnr tilstand btype utenl bkode storb kopi
naering landsdel kommune sifonorgnr orgnr nace 
v13 v15 v29 v30 v32-v38 v42 v45-v47 
v54-v58 v64-v72 v87 v88 v104 v106 v108 v112 v114-v119
nace1 tilst ftype stutla totutla sifonutenl stutla2 
totutla2 stutland stutland2 _merge ktny; 
tempfile temp`t';
save temp`t', replace;
};
use ${industri}industri1995, clear;
keep aar bnr fnr tilstand btype utenl bkode storb 
naering landsdel kommune sifonorgnr orgnr nace 
v13 v15 v29 v30 v32-v38 v42 v45-v47 v54-v58 
v64-v72 v87 v88 v104 v106 v108 v112 v114-v119
nace1 tilst ftype stutla totutla sifonutenl stutla2 
totutla2 stutland stutland2 _merge ktny; 
tempfile temp1995;
save temp1995, replace;
forvalues t=1996/2000 {;
use ${industri}industri`t', clear;
keep aar bnr fnr tilstand btype utenl bkode storb 
naering landsdel kommune sifonorgnr indorgnr nace 
v13 v15 v29 v30 v32-v38 v42 v45-v47 v54-v58 
v64-v72 v104 v106 v108 v112 v114-v119
nace1 tilst ftype stutla totutla sifonutenl stutla2 
totutla2 stutland stutland2 _merge; 
tempfile temp`t';
save temp`t', replace;
};

use ${industri}industri2001, clear;
keep aar bnr fnr tilstand btype utenl bkode storb 
naering landsdel kommune sifonorgnr indorgnr nace 
v13 v15 v29 v30 v32-v38 v42 v45-v47 v54-v58
v64-v72 v104 v106 v108 v112 v114-v119
nace1 tilst ftype stutla totutla sifonutenl stutla2 
totutla2 stutland stutland2 _merge;
tempfile temp2001;
save temp2001, replace;
#delimit cr

* Kobler temp filene i et panel
use temp1972
forvalues t=1973/2001 {
append using temp`t'
}
compress
* Sletter tempfilene igjen
forvalues t=1972/2001 {
erase temp`t'.dta
}
 
* Retter opp mangler i fnr bnr naering. Se pkt 1 over 
replace fnr=4857836 if fnr==0 & aar==1987
drop if bnr==5746353 & aar==1997
sort bnr aar
bys bnr: gen n=_n
bys bnr: gen initialN=_N
by bnr: gen entry=aar[1]
by bnr: gen exit=aar[_N]
label var entry "1st year plant number is observed in industri data files"
label var exit "Last year plant number is observed in industri data files"
label var initialN "No of years plant is observed in origin. ind. data files"

tsset bnr aar

drop if fnr==. & entry==exit & aar==2000
replace fnr=L.fnr if fnr==. & L.fnr!=. & aar==2000 & exit==2000
replace fnr=F.fnr if fnr==. & F.fnr!=. & aar==2000 & entry==2000
replace fnr=L.fnr if fnr==. & aar==2000
replace fnr=F.fnr if fnr==. & aar==2000
replace fnr=fnr[_n-1] if fnr==. & aar==2000
assert fnr!=. 
assert bnr!=.

* Missing isickode
replace naering=L.naering if naering==. & entry <1995
count if naering==.
* For de resterende missing hjelper ikke de to kommandoene under
replace naering=L.naering if naering==.
replace naering=F.naering if naering==.
* Bruker en korrespondanse mellom nace og isic koder 
* for aa fylle isic koder som mangler. Korrespondansen finner 
* jeg ved manuell sjekk av Jarles Foudata\naering2.dta 
* Korrespondanse fra naering.dta
replace naering=31310 if nace==15930 & naering==.
replace naering=32111 if nace==17140 & naering==.
replace naering=32111 if nace==17170 & naering==.
replace naering=35409 if nace==23100 & naering==.
replace naering=35291 if nace==24630 & naering==.
replace naering=36100 if nace==26240 & naering==.
replace naering=36910 if nace==26250 & naering==.
replace naering=36910 if nace==26300 & naering==.
replace naering=36920 if nace==26530 & naering==.
replace naering=38192 if nace==27310 & naering==.
replace naering=38192 if nace==27330 & naering==.
replace naering=38520 if nace==33500 & naering==.
replace naering=38299 if nace==35410 & naering==.
count if naering==.


* Erstatter info i variabelen utenl med variabelen sifonutenl
* fra sifon-registeret etter 1990. Dette gjelder bare direkte 
* utenlandsk eierskap.
* Obs som ikke kom fra SIFON faar utenl==0
replace utenl=0 if _merge==1 & aar>=1990
replace utenl=sifonutenl if _merge==3 & aar>=1990
assert utenl!=. 
* dette innebaerer at ftype3 har faatt utenl==0
* selv om indir utenl eierskap kan vaere stort
assert utenl==0 if ftype==3
table aar utenl, row col
drop sifonutenl

* Lager en kategorivariabel for indirekte utenl eierskap
* Lager utenl kategorivar. der totutenl=1 hvis
* total ind eller dir eierandel>50%
gen indirutenl=1 if totutla2>=50 & totutla2<. & ftype!=1
replace indirutenl=2 if totutla2>=20 & totutla2<50 & ftype!=1
replace indirutenl=0 if totutla2<20 & ftype!=1
assert indirutenl==. if aar<1990
assert indirutenl==. if ftype==1
assert indirutenl!=. if ftype==2 | ftype==3
table aar indirutenl, row col
label var indirutenl "Grad av indirekte utenlandsk eierskap: 0 <20%, 1>=50%, 2 >=20, <50%" 
* lager kategorivar som inkluderer baade
* indirekte og direkte utenl eierskap
gen totutenl=1 if utenl==1 | indirutenl==1
replace totutenl=2 if utenl==2 | indirutenl==2
replace totutenl=0 if totutenl==.
table aar totutenl, row col
label var totutenl "Grad av utenlandsk eierskap: baade direkte og indirekte eierskap" 

compress
save ${industri}foumerge_mob.dta, replace


* Use data in foumerge and drop 1) Non-manufacturing sectors
* 2)Service plants 3)Investment plants. Dropping procedures do not 
* generate holes in time series for a plant.
* Replace foumerge.dta.

	tsset bnr aar

* 1.
* Drop plants outside manufacturing
* Drop plants that are outside manufacturing all years
	gen isic2=int(naering/1000)
	gen x=1 if isic2<30 | isic2>39
	bys bnr: egen y=sum(x)
	drop if y==initialN
	tab y if n==initialN
* Drop plants that are obs 1 or more times outside manufacturing(200 plants)
	drop if y>=1 
	assert x!=1
	drop x y


* 2.
* Drop plants that are def as service units (btype=4) all their life 
	assert btype!=.
	count if btype==4
	gen x=1 if btype==4
	bys bnr: egen y=sum(x)
	drop if y==initialN
* Drop plants that are only observed 2 years and one of them as service plant
	drop if y==1 & initialN==2
* Replace btype to missing if the plant is not defined as a service plant the 
* year before and after an obs. with btype==4. and it is btype4 only once.
	sort bnr aar
	replace btype=. if btype==4 & L.btype!=4 & F.btype!=4 & y==1
* update x and y
	drop x y
	gen x=1 if btype==4
	bys bnr: egen y=sum(x)
	drop if y==initialN
	tab y if n==initialN
* Drop remaining plants with 1 or more obs as service plants
	drop if y>=1
	assert btype!=4
	drop x y btype
	assert aar==entry if n==1
	assert aar==exit if n==initialN


* 3
* Look at variable tilstand: 9: ordinary production, 0 investment plants 
* (ie under construction)
* In principle a new plant should have tilstand=0 the first years it is in the panel
* Overview of tilstand variable. Some plants have code 5 these are in ordinary prod
* according to Jarle: aktive bedrifter knytta til utgaatte foretak
	table aar tilstand 
	replace tilstand=9 if tilstand==5
	replace tilstand=0 if tilstand<=4
	replace tilstand=9 if tilstand==.
* Drop plants that are investment plants all their life 
	gen x=1 if tilstand==0
	bys bnr: egen y=sum(x)
	drop if y==initialN
* Drop exit year for a plant if it is then defined as inv plant
	drop if aar==exit & tilstand==0
	drop exit initialN
	bys bnr: gen initialN=_N
	by bnr: gen exit=aar[_N]
	drop if aar==exit & tilstand==0
	drop exit initialN
	bys bnr: gen initialN=_N
	by bnr: gen exit=aar[_N]
	drop if aar==exit & tilstand==0
	drop exit initialN
	bys bnr: gen initialN=_N
	by bnr: gen exit=aar[_N]
	assert tilstand==9 if aar==exit 

	count if tilstand ==0
	tab aar if tilstand==0
* Table above shows that we have not many investment plants left, 
* and most of these are in 2000, something fishy here
	count if v104==. & aar==2000 & tilstand==0
	count if v13==. & aar==2000 & tilstand==0
	* From the fact that most of these plants produce and have empl
	* I change the investment plant code to ordinary production in 2000
	replace tilstand=9 if aar==2000
* The remaining tilst =9 are so few that I drop them here if they are 
* in the entry year of the plant.

* Drop observations where tilstand=0 in the first years a plant is observed
	gen z=1 if n==1 & tilstand==0
	replace z=1 if z[_n-1]==1 & tilstand==0 
	drop if z==1
	drop z
* Need to update initialn initialN entry exit n
	drop n initialN  entry exit
	bys bnr: gen initialn=_n
	bys bnr: gen initialN=_N
	by bnr: gen entry=aar[1]
	by bnr: gen exit=aar[_N]
	assert tilstand!=0 if initialn==1
	assert tilstand!=0 if aar==entry | aar==exit
* Replace tilst=9 if plant has only 1 obs of tilst=0 and is regular prod plant
* both before and after
	sort bnr aar
	replace tilstand=9 if tilstand==0 & L.tilstand==9 & F.tilstand==9 & v104!=0
* observation of tilstand==0 per plant
	drop x y
	gen x=1 if tilstand==0
	bys bnr: egen y=sum(x)
	tab y if initialn==initialN
	drop if y>0
	assert tilstand!=0
	drop x y tilstand
* Need to update entry, exit, etc
	drop initialN initialn entry exit
	bys bnr: gen initialn=_n
	bys bnr: gen initialN=_N
	by bnr: gen entry=aar[1]
	by bnr: gen exit=aar[_N]
	label var entry "1st year plant number is observed in industri data files as prod.plant"
	label var exit "Last year plant number is observed in industri data files as prod plant"
	label var initialN "# of years plant is observed in origin. ind. data files as prod. plant"
	label var initialn "Rank in observation series as prod. plant"
	
count
compress
save ${industri}foumerge_mob.dta, replace


* Look at isic codes and make changes of seemingly incorrect
* incorrect isic codes:  
*************************************************************
	gen isic3=int(naering/100)
	gen isic4=int(naering/10)
	program define updaten
		sort bnr aar
		bys bnr: gen n=_n
		bys bnr: gen N=_N
		sort bnr aar
	end
	updaten
* Define a programme that updates isic2 isic3 isic4, must run
* this whenever isiccodes in the var naering has been changed 
	program define isicupdate
		drop isic2 isic3 isic4
		gen isic2=int(naering/1000)
		gen isic3=int(naering/100)
		gen isic4=int(naering/10)
	end

* Count the number of isicchanges per plant
	program define isicchange
		bys bnr: gen x=1 if naering!=naering[_n-1]
		replace x=0 if n==1
	 	replace x=0 if x==.
		bys bnr: egen z=sum(x)
	end
	isicchange
* z counts the number of isic changes per plant
	count
	tab z if n==N
* Some plants have 4 or more changes of isic code. We drop these plants 
* due to uncertainty about which sector they belong to. (61 plants)
	drop if z>3
* How many of the plants with 2 or 3 changes of isic seems to have a 
* single deviation? Replace this with isic the year before deviation
	count if z>1 & x==1 & L.naering==F.naering & L.naering==L2.naering & F.naering==F2.naering & L.naering!=.
	replace naering=L.naering if z>1 & x==1 & L.naering==F.naering & L.naering==L2.naering & F.naering==F2.naering & L.naering!=.
* Update no of isicchanges per plant
	drop x z
	isicchange	
	tab z if n==N
* Look at remaining isic changes: make indicator for 3 
* isic changes in a row.
	bys bnr: gen rad=1 if x==1 & x[_n+1]==1
	bys bnr: gen rad2=1 if rad==1 & rad[_n+1]==1
	gen d=1 if x==1 & rad==1 & rad2==1
* From browsing we find a pattern with 3 changes in a row
* that looks like this: 32 32 32 35 32 35 35 35 35,
* We choose to change the first 35 to 32, and take the sector 
* change to have happened in the last year
	count if d==1 & naering==naering[_n+2] 
	replace naering=naering[_n-1] if d==1 & naering==naering[_n+2] 
* Update no of isicchanges per plant
	drop x z
	isicchange
* Update changes in row indicators
	drop rad rad2 d
	bys bnr: gen rad=1 if x==1 & x[_n+1]==1
	bys bnr: gen rad2=1 if rad==1 & rad[_n+1]==1
	gen d=1 if x==1 & rad==1 & rad2==1
	bys bnr: egen a=min(d)
* List/browse plants with 3-in-a-row changes, and change isic codes 
* based on list
	count if d==1
	list aar fnr bnr naering if d==1
	drop if bnr==551260
	replace naering=38210 if bnr==897906 & aar==1975
	replace naering=38210 if bnr==897906 & aar==1976
	replace naering=38191 if bnr==1684280 & aar==1974
	replace naering=38191 if bnr==1684280 & aar==1975 
	replace naering=35601 if bnr==1735756 & aar==1977
	replace naering=38299 if bnr==3220109 & aar==1976
	replace naering=38412 if bnr==4874358 & aar==1984
	replace naering=38249 if bnr==5364728 & aar==1990
	replace naering=38249 if bnr==5364728 & aar==1991
	drop a 
* Update no of isicchanges per plant
	drop x z
	isicchange
* Update changes in row indicators
	drop rad rad2 d
	bys bnr: gen rad=1 if x==1 & x[_n+1]==1
	* Now we only have two in a row 
	gen d=1 if x==1 & rad==1 
	bys bnr: egen a=min(d)
* List/browse plants with 2-in-a-row changes. If the first isic
* change happens in year 2 and 3 with the following pattern:
* 36 37 36 36 36.., we change the 37 to 36 (5 digit level)
* We do the same type of replacement if this is the pattern in 
* year N-2 to N
	sort bnr aar
	replace naering=naering[_n-1] if n==2 & naering[_n-1]==naering[_n+1] & rad==1
	replace naering=naering[_n-1] if n==N-1 & naering[_n-1]==naering[_n+1] & rad==1
* Update no of isicchanges per plant
	drop x z
	isicchange
* Update changes in row indicators
	drop rad d a
	bys bnr: gen rad=1 if x==1 & x[_n+1]==1
	gen d=1 if x==1 & rad==1 
	bys bnr: egen a=min(d)
* If isic changes are in year 2 and 3 and from 3 onwards the isic code
* ends with a 9 of the same 3 digit sector as year 1 and 2, replace
* isic in year 1 and 2 with that of year 3
	replace rad=1 if rad[_n-1]==1 & x==1
	* Generate and indicator for whether isic code ends 
	* with a 9 in sector 38
	isicupdate
	gen w=1 if naering==38199 | naering==38249 | naering==38299 | naering==38399 | naering==38490
	gen y=1 if rad==1 & w==1 & isic3==isic3[_n-1] & x[_n+1]!=1
	replace naering=naering[_n+1] if n==2 & y[_n+1]==1
	replace naering=naering[_n+2] if n==1 & y[_n+2]==1
	drop y w
* Update no of isicchanges per plant
	drop x z
	isicchange
* Update changes in row indicators
	drop rad d a
	bys bnr: gen rad=1 if x==1 & x[_n+1]==1
	gen d=1 if x==1 & rad==1 
	bys bnr: egen a=min(d)
* For 2-in-a-row changes another typical pattern is 381x 381y 382,
* or 381x 382y 382z; in the first case we change 381y to 381x, 
* and in the second case we change 382y to 382z
	isicupdate
	replace naering=naering[_n-1] if rad==1 & isic3==isic3[_n-1] & isic3!=isic3[_n+1]
	replace naering=naering[_n+1] if rad==1 & isic3==isic3[_n+1] & isic3!=isic3[_n-1]
* For 2-in-a-row changes another typical pattern is 36x 38y 38z,
* or 38x 38y 36z; in the first case we change 38y to 38z, 
* and in the second case we change 38y to 38x
	isicupdate
	replace naering=naering[_n+1] if rad==1 & isic2==isic2[_n+1] & isic2!=isic2[_n-1]
	replace naering=naering[_n-1] if rad==1 & isic2==isic2[_n-1] & isic2!=isic2[_n+1]
* Update no of isicchanges per plant
	drop x z
	isicchange
* Update changes in row indicators
	drop rad d a
	bys bnr: gen rad=1 if x==1 & x[_n+1]==1
	gen d=1 if x==1 & rad==1 
	bys bnr: egen a=min(d)
* Get rid of single isic deviations
 	replace naering=naering[_n-1] if rad==1 & naering[_n-1]==naering[_n+1]
* Replace naering to the year before or after according to which isic is closest
	isicupdate
	replace naering=naering[_n-1] if rad==1 & isic4[_n-1]==isic4 & isic4!=isic4[_n+1]
	replace naering=naering[_n-1] if rad==1 & isic3[_n-1]==isic3 & isic3!=isic3[_n+1]
	replace naering=naering[_n-1] if rad==1 & isic2[_n-1]==isic2 & isic2!=isic2[_n+1]
	isicupdate
	replace naering=naering[_n+1] if rad==1 & isic4[_n+1]==isic4 & isic4!=isic4[_n-1]
	replace naering=naering[_n+1] if rad==1 & isic3[_n+1]==isic3 & isic3!=isic3[_n-1]
	replace naering=naering[_n+1] if rad==1 & isic2[_n+1]==isic2 & isic2!=isic2[_n-1]
* Update no of isicchanges per plant
	drop x z
	isicchange
* Update changes in row indicators
	drop rad d a
	bys bnr: gen rad=1 if x==1 & x[_n+1]==1
	gen d=1 if x==1 & rad==1 
	bys bnr: egen a=min(d)
	tab z if n==N
	tab a if n==N
* In general with 2 changes in a row: replace deviation 
* with naering the year before?
	replace naering=naering[_n-1] if rad==1 
* Update no of isicchanges per plant
	drop x z
	isicchange
* Update changes in row indicators
	drop rad d a
	bys bnr: gen rad=1 if x==1 & x[_n+1]==1
	gen d=1 if x==1 & rad==1 
	bys bnr: egen a=min(d)
	assert a<2 | a==.
	drop a
	tab z if n==N

* If isic change is in year 2 replace isic year 1 with year 2 isic
	replace naering=naering[_n+1] if n==1 & x==0 & x[_n+1]==1
* Update no of isicchanges per plant
	drop x z
	isicchange
	tab z if n==N
* update n and count of isicchange
	drop n N x z
	updaten
	isicchange
	isicupdate
* Show the number of plants in the panel and the number 
* of isicchanges per plant
	tab z if n==N
* Drop plants with 3 isic changes (57 plants)
	drop if z==3
	drop x rad d z isic2 isic3 isic4
save ${industri}foumerge.dta, replace


exit



