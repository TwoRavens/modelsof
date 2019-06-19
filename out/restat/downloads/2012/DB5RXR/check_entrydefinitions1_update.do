clear
set more off
version 10
set mem 400m
capture log close
capture program drop _all
log using ${empdecomp}check_entrydefinitions1_update, text replace

* Last updated and rerun 14.10.2008***************************************
* just added some code to get some info about size of panel 1992-2004 and 
* see how drop procedures affect panel
**************************************************************************

* **** 14.05.2007*********************************************************
* New attempt at defining entry and exit, based on the following 
* relevant previous do files in \prosjekt: foumerge, firstdrop1, firstdrop,
* define_entryexit, and 2002info.do. 
* Do file continues in check_entrydefinitions2.do based on seconddrop.do
**************************************************************************


*******25.04.2008**************************************************
* Extended to include additional years of data, including 2002-2005
* Small changes in earlier code to accommodate this.
* Changed the cleaning on isic changes to a much simpler version, 
* and dropping of small plants, investment plants etc also simplified
* Definitions of reentry simplified
* Saves 2 datasets: 
* 1. data set with all plants, all years and all investment variables:
* used in order to generate capital values in gen_capital_update.do
* 2. ${industri}entrycheck_update.dta, from 1990: basic panel for 
* analysis. Without investment variables
*******************************************************************

***************
* 1. From foumerge.do
* Changed to first make a panel of plants from the
* manufacturing statistics, dropping the new "kitchen table"
* plants introduced from 1998. Check bnr, fnr and isiccodes
* Keep aar bnr fnr naering nace
* save temporary panel
***************

* Sjekker industridatafilene for problem med bnr, fonr og naeringskode
* Løser eventuelle problem

forvalues t=1972/1995 {
use ${IND_DIR}in`t', clear
keep aar bnr fonr naering btype storb tilstand bkode v13
quietly gen bnrmis=1 if bnr==. | bnr==0
quietly replace bnrmis=0 if bnrmis==.
quietly gen fonrmis=1 if fonr==. | fonr==0
quietly replace fonrmis=0 if fonrmis==.
quietly gen isicmis=1 if naering==. | naering==0
quietly replace isicmis=0 if isicmis==.
tempfile temp`t'
quietly save temp`t', replace
}
* NACE kode innføres i 1996
forvalues t=1996/1997 {
use ${IND_DIR}in`t', clear
quietly keep aar bnr fonr naering nace btype storb tilstand bkode v13
quietly gen bnrmis=1 if bnr==. | bnr==0
quietly replace bnrmis=0 if bnrmis==.
quietly gen fonrmis=1 if fonr==. | fonr==0
quietly replace fonrmis=0 if fonrmis==.
quietly gen isicmis=1 if naering==. | naering==0
quietly replace isicmis=0 if isicmis==.
assert nace!=.
tempfile temp`t'
quietly save temp`t', replace
}

* From 1998 the file size in indsta doubles due to the inclusion 
* of very small firms. In 1998 they have utvalg==2, from 1999 they have 
* opop==0 in inYYYYny.dta files (according to documentation by Jarle)
use ${IND_DIR}in1998ny, clear
keep bnr utvalg
drop if utvalg==2
drop utvalg
sort bnr
merge bnr using ${IND_DIR}in1998, keep(aar bnr fonr naering nace btype storb tilstand bkode v13)
quietly assert _merge!=1
quietly keep if _merge==3
drop _merge
quietly gen bnrmis=1 if bnr==. | bnr==0
quietly replace bnrmis=0 if bnrmis==.
quietly gen fonrmis=1 if fonr==. | fonr==0
quietly replace fonrmis=0 if fonrmis==.
quietly gen isicmis=1 if naering==. | naering==0
quietly replace isicmis=0 if isicmis==.
assert nace!=.
tempfile temp1998
quietly save temp1998, replace

forvalues t=1999/2000 {
use ${IND_DIR}in`t'ny, clear
keep bnr opop
drop if opop==0
drop opop
sort bnr
merge bnr using ${IND_DIR}in`t', keep(aar bnr fonr naering nace btype storb tilstand bkode v13)
quietly assert _merge!=1 
quietly keep if _merge==3
drop _merge
quietly gen bnrmis=1 if bnr==. | bnr==0
quietly replace bnrmis=0 if bnrmis==.
quietly gen fonrmis=1 if fonr==. | fonr==0
quietly replace fonrmis=0 if fonrmis==.
quietly gen isicmis=1 if naering==. | naering==0
quietly replace isicmis=0 if isicmis==.
quietly assert nace!=.
tempfile temp`t'
quietly save temp`t', replace
}
* Kan vise at hver bnr bare er registrert en gang i indstat pr aar 
* Unntaket er 2001 med 4 bedrifter, se kommentar i dokumentasjonen
* til Jarle Moen. Kobler paa variabelen fs fra in2001ny. Indikator
* for skifte av foretak. Keep variable fs, if value 2 must be dropped
* later, but must be kept until all relevant info fron in2001 is 
* included in panel
use ${IND_DIR}in2001ny, clear
keep bnr opop fs
drop if opop==0
drop opop 
sort bnr
merge bnr using ${IND_DIR}in2001, keep(aar bnr fonr naering nace btype storb tilstand bkode v13)
assert _merge!=1 
quietly keep if _merge==3
drop _merge
quietly gen bnrmis=1 if bnr==. | bnr==0
quietly replace bnrmis=0 if bnrmis==.
quietly gen fonrmis=1 if fonr==. | fonr==0
quietly replace fonrmis=0 if fonrmis==.
quietly gen isicmis=1 if naering==. | naering==0
quietly replace isicmis=0 if isicmis==.
assert nace!=.
drop if fs==2
tempfile temp2001
quietly save temp2001, replace

* 2002 har 4 obs med bnr==.
use ${IND_DIR}in2002ny, clear
keep bnr opop
drop if opop==0
drop opop 
drop if bnr==.
sort bnr
merge bnr using ${IND_DIR}in2002, keep(aar bnr fonr naering nace btype storb tilstand bkode v13)
assert _merge!=1 
quietly keep if _merge==3
drop _merge
quietly gen bnrmis=1 if bnr==. | bnr==0
quietly replace bnrmis=0 if bnrmis==.
quietly gen fonrmis=1 if fonr==. | fonr==0
quietly replace fonrmis=0 if fonrmis==.
quietly gen isicmis=1 if naering==. | naering==0
quietly replace isicmis=0 if isicmis==.
assert nace!=.
tempfile temp2002
quietly save temp2002, replace

forvalues t=2003/2005 {
use ${IND_DIR}in`t', clear
keep aar bnr fonr naering nace opop btype storb bkode v13
drop if opop==0
drop opop
sort bnr
quietly gen bnrmis=1 if bnr==. | bnr==0
quietly replace bnrmis=0 if bnrmis==.
quietly gen fonrmis=1 if fonr==. | fonr==0
quietly replace fonrmis=0 if fonrmis==.
quietly gen isicmis=1 if naering==. | naering==0
quietly replace isicmis=0 if isicmis==.
assert nace!=.
tempfile temp`t'
quietly save temp`t', replace
}

* Kobler temp filene i et panel
use temp1972
forvalues t=1973/2005 {
quietly append using temp`t'
}
quietly compress
* Sletter tempfilene igjen og lagrer temppanel
forvalues t=1972/2005 {
quietly erase temp`t'.dta
}
quietly save ${empdecomp}temp.dta, replace

* Sjekk BNR
*************
assert bnrmis!=1
bysort bnr aar: gen n=_n
assert n==1
drop n bnrmis
save ${empdecomp}temp.dta, replace


* Sjekk FONR
***************
* Sjekker hvilke aar det er problem med manglende fonr 
* og retter opp dette
tab aar fonrmis 
* Tabellene over viser at det mangler ett fonr i 87 og i 97 og 04, 
* og 81 fonr i 2000, 

list if fonrmis==1 & aar!=2000
tsset bnr aar
list aar fonr naering  if bnr==6494404
list aar fonr naering if bnr==5746353
replace fonr=F.fonr if bnr==F.bnr & aar==2004 & fonr==.
drop if aar==1997 & fonrmis==1 
replace fonr=F.fonr if bnr==F.bnr & aar==1987 & fonrmis==1 

* Loesning for aaret 1987, og 2004 er a bruke foretaksnr for samme bnr i 1988
* foretaksnr: 4857836
* Loesning for 1997 er aa droppe denne obs. da bnr bare er obs dette aaret

* Lager entry og exit variabel
sort bnr aar
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
* Foerer fonr fram og tilbake
replace fonr=L.fonr if fonr==. & aar==2000
replace fonr=F.fonr if fonr==. & aar==2000
replace fonr=fonr[_n-1] if fonr==. & aar==2000 & bnr==bnr[_n-1]
replace fonr=fonr[_n+1] if fonr==. & aar==2000 & bnr==bnr[_n+1]
assert fonr!=. 

* Sjekk ISICkode
******************
* naering mangler for noen observasjoner etter 1996, alle i 2003-05
* nace kode finnes for alle med naering=. 
* Problemet er at naering=. og ikke at naering=0

count if isicmis==1
count if naering==.
count if naering==. & nace!=.
tab aar isicmis

* Retter opp manglende naeringskode
replace naering=L.naering if naering==. & entry <1995 & bnr==L.bnr
replace naering=L.naering if naering==. 
replace naering=F.naering if naering==.
drop if entry==exit & naering==.
count if naering==.
	* For de resterende missing hjelper ikke de to kommandoene over
save ${empdecomp}temp.dta, replace

* Bruker en korrespondanse mellom nace og isic koder 
* for aa fylle isic koder som mangler. Korrespondansen finner 
* jeg ved manuell sjekk av Jarles Foudata\naering2.dta 
use "C:\Paper2\Data\FoUdata\naering2.dta", clear
rename nace5 nace
sort nace
save ${empdecomp}nacetemp.dta, replace
use ${empdecomp}temp.dta, clear
sort nace
merge nace using ${empdecomp}nacetemp.dta
replace naering=sn83 if naering==. & _merge==3
drop if _merge==2
count if naering==.

* Korrespondanse fra naering.dta
quietly replace naering=31310 if nace==15930 & naering==.
quietly replace naering=32111 if nace==17140 & naering==.
quietly replace naering=32111 if nace==17170 & naering==.
quietly replace naering=35409 if nace==23100 & naering==.
quietly replace naering=35291 if nace==24630 & naering==.
quietly replace naering=36100 if nace==26240 & naering==.
quietly replace naering=36910 if nace==26250 & naering==.
quietly replace naering=36910 if nace==26300 & naering==.
quietly replace naering=36920 if nace==26530 & naering==.
quietly replace naering=38192 if nace==27310 & naering==.
quietly replace naering=38192 if nace==27330 & naering==.
quietly replace naering=38520 if nace==33500 & naering==.
quietly replace naering=38299 if nace==35410 & naering==.

* Resten må kodes direkt ut fra klassifiseringsheftene
quietly replace naering=29000 if nace==10300 & naering==.
quietly replace naering=31310 if nace==15910 & naering==.
quietly replace naering=32112 if nace==17250 & naering==.
quietly replace naering=32190 if nace==17530 & naering==.
quietly replace naering=35120 if nace==24200 & naering==.
quietly replace naering=35299 if nace==24650 & naering==.
quietly replace naering=36200 if nace==26110 & naering==.
quietly replace naering=38230 if nace==29410 & naering==.
quietly replace naering=38230 if nace==29420 & naering==.
quietly replace naering=38230 if nace==29430 & naering==.
quietly replace naering=39020 if nace==36300 & naering==.
quietly replace naering=39010 if nace==36610 & naering==.

assert naering!=.
drop _merge sn83
erase ${empdecomp}nacetemp.dta
bys bnr: gen initialN=_N
label var entry "1st year plant number is observed in industri data files"
label var exit "Last year plant number is observed in industri data files"
label var N "No of years plant is observed in origin. ind. data files"
quietly save ${empdecomp}temp.dta, replace



**************************************************
* 2 .
* From firstdrop1.do
* Drop plants not in ordinary production, 
* investment plants etc. Dropping procedures 
* do not generate holes in time series for a plant.
*************************************************
	use ${empdecomp}temp.dta, clear
	count
* Drop plants outside manufacturing
* all years
	quietly gen isic2=int(naering/1000)
	quietly gen x=1 if isic2<30 | isic2>39
	bys bnr: egen y=sum(x)
	quietly drop if y==initialN
	tab y if n==initialN
* 1 or more times outside manufacturing(200 plants)
	quietly drop if y>=1 
	assert x!=1
	drop x y
	count

* summary info about obs, etc before further drop procedures
* info only for the years 1992-2004 that we end up using in
* the analysis
tab aar if aar>1991 & aar<2005
tab isic2 if aar>1991 & aar<2005
sum v13 if aar>1991 & aar<2005
preserve
keep if aar>1991 & aar<2005
drop n N
bys bnr: gen n=_n
bys bnr: gen N=_N
count if n==N
egen totsyss=sum(v13)
sum totsyss
restore

* storb
*******
* Drop plants that are defined as small all their life
	assert storb==1 | storb==0
	bys bnr: egen y=sum(storb) 
	drop if y==0
	drop y
* The remaining small plant codes
	count if storb==0

* btype
********
tab btype
list aar bnr fonr entry exit isic2 N initialN if btype==13
tsset bnr aar
replace btype=L.btype if btype==13
* One plant has btype=0, replace to value before
list aar bnr fonr entry exit isic2 N initialN if btype==0
replace btype=btype[_n-1] if btype==0 & aar==2003 & bnr==bnr[_n-1]
replace btype=btype[_n-1] if btype==0 & aar==2004 & bnr==bnr[_n-1]
assert btype>=1 & btype<=4
* Drop plants that are service units all their life
gen x=1 if btype==4
bys bnr: egen y=sum(x)
drop if y==N
drop x y

* bkode
*******
tab bkode
count
tab aar if bkode==2
	* all in 2002
sort bnr aar
replace bkode=L.bkode if bkode==2
assert bkode!=2 | bkode!=.
bys bnr: egen x=sum(bkode)

* tilstand
***********
* This variable disappears after 1999 or 2000
* Obs different from tilst=9 are so few, that 
* I choose to ognore this, in addition
* most of these obs will drop out anyway because we 
* are only using years after 1990
* Look at variable tilstand: 9: ordinary production, 0 investment plants 
* (ie under construction)
* In principle a new plant should have tilstand=0 the first years it is in the panel
* Overview of tilstand variable. Some plants have code 5 these are in ordinary prod
* according to Jarle: aktive bedrifter knytta til utgaatte foretak
tab tilstand
tab aar if tilstand!=.
replace tilstand=9 if tilstand==.
foreach t in 0 1 2 4 5 {
	quietly gen til`t'=1 if tilstand==`t'
	quietly replace til`t'=0 if tilstand!=`t'
	quietly bys bnr: egen y`t'=sum(til`t')
	display "tilstand`t'"
	tab y`t'
}
assert initialN==N
keep aar bnr fonr nace btype tilstand bkode storb naering v13 fs n N entry exit isic2
sort bnr aar
quietly save ${empdecomp}temp.dta, replace

* Small plants again
********************
tab storb
tab bkode
tab btype
* Drop the remaining plants that have v13<6 all their life
	gen z=1 if v13<=5
	bys bnr: egen w=sum(z)
	drop if w==N
	drop z w
* Drop the remaining plants that have v13<10 all their life
	gen z=1 if v13<10
	bys bnr: egen w=sum(z)
	drop if w==N
	drop z w
* Drop plants that are large <30% of their life 
	bys bnr: egen y=sum(storb)
	gen x=y/N
	count if x<0.5 & n==N
	drop if x<0.3
	drop x y
* The remaining small plant codes
	count if storb==0
	sort bnr aar

* summary info about obs, etc before further drop procedures
* info only for the years 1992-2004 that we end up using in
* the analysis
tab aar if aar>1991 & aar<2005
tab isic2 if aar>1991 & aar<2005
sum v13 if aar>1991 & aar<2005
preserve
keep if aar>1991 & aar<2005
drop n N
bys bnr: gen n=_n
bys bnr: gen N=_N
count if n==N
egen totsyss=sum(v13)
sum totsyss
restore


* Drop plants that are only observed twice, and not in concecutive years
	gen fill=1 if n==1 & N==2 & F.bnr==.
	count if n==N & N==2
	count if N==2 & n==1 & fill==1
	bys bnr: egen fills=sum(fill)
	drop if fills==1
	drop fill fills
* Drop plants that are obs 3 years, not conc
	gen fill=1 if n==1 & N==3 & F.bnr==.
	replace fill=1 if n==2 & N==3 & F.bnr==.
	replace fill=2 if n==1 & N==3 & F.bnr==. & F2.bnr==.
	bys bnr: egen fills=sum(fill)
	tab fills
	drop if fills>=2

* There are many remaining small plant obs, but 
* leave them in panel at this point. Sofar not created 
* hole in obs series for a plant
keep aar bnr fonr naering nace n N entry exit isic2
sort bnr aar
save ${empdecomp}temp.dta, replace


* Cleaning on isicchanges
**************************
	program define isicupdate
		drop isic2 isic3 isic4
		gen isic2=int(naering/1000)
		gen isic3=int(naering/100)
		gen isic4=int(naering/10)
	end
	gen isic3=.
	gen isic4=.
	isicupdate

* generate indicator for the type of isic=5 in t-1, isic=7 in t and isic=5 in t+1
* and change the observation in t
	tsset bnr aar
	quietly gen x=1  if bnr==l.bnr & bnr==f.bnr & isic2!=l.isic2 & isic2!=f.isic2 & l.isic2==f.isic2
	quietly bys bnr: egen sumx=sum(x)
	tab sumx if n==N
* plants with one 2 digit change if sector: replace the one-off change 
	quietly replace naering=l.naering if sumx==1 & x==1
* if two of these occur in two consecutive years, assume the last change is the 
* definite one, hence replace naering in the first case
	quietly replace naering=l.naering if sumx==2 & x==1 & f.x==1
* the plant with 3 changes
	quietly replace naering=l.naering if sumx==3 & x==1 
	drop x sumx
	isicupdate
* Redo, and replace the 2 strange isicobservations for the remaining plant
	quietly gen x=1  if bnr==l.bnr & bnr==f.bnr & isic2!=l.isic2 & isic2!=f.isic2 & l.isic2==f.isic2
	quietly bys bnr: egen sumx=sum(x)
	tab sumx if n==N
	list aar bnr n N isic2 naering if sumx==2
	quietly replace naering=l.naering if sumx==2 & x==1 
	drop x sumx
	isicupdate
* 
* Repeat above at 3 digit level
	quietly gen x=1  if bnr==l.bnr & bnr==f.bnr & isic3!=l.isic3 & isic3!=f.isic3 & l.isic3==f.isic3
	quietly bys bnr: egen sumx=sum(x)
	tab sumx if n==N
* plants with one 3digit change of sector: replace the one-off change 
	quietly replace naering=l.naering if sumx==1 & x==1
* if two of these occur in two consecutive years, assume the last change is the 
* definite one, hence replace naering in the first case
	quietly replace naering=l.naering if sumx==2 & x==1 & f.x==1
* the plant with 3 changes, based on browsing: change
	*list aar bnr n N isic3 naering if sumx==3
	quietly replace naering=l.naering if sumx==3 & x==1 
	drop x sumx
	isicupdate
* No changes left in concecutive years
	quietly gen x=1  if bnr==l.bnr & bnr==f.bnr & isic3!=l.isic3 & isic3!=f.isic3 & l.isic3==f.isic3
	quietly bys bnr: egen sumx=sum(x)
	tab sumx if n==N
	drop x sumx
*
* Repeat above at 4 digit level
	quietly gen x=1  if bnr==l.bnr & bnr==f.bnr & isic4!=l.isic4 & isic4!=f.isic4 & l.isic4==f.isic4
	quietly bys bnr: egen sumx=sum(x)
	tab sumx if n==N
* plants with one 4digit change of sector: replace the one-off change 
	quietly replace naering=l.naering if sumx==1 & x==1
* if two of these occur in two consecutive years, assume the last change is the 
* definite one, hence replace naering in the first case
	quietly replace naering=l.naering if sumx==2 & x==1 & f.x==1
	drop x sumx
	isicupdate
* No changes left in concecutive years
	quietly gen x=1  if bnr==l.bnr & bnr==f.bnr & isic4!=l.isic4 & isic4!=f.isic4 & l.isic4==f.isic4
	quietly bys bnr: egen sumx=sum(x)
	tab sumx if n==N
	drop sumx x
*
* Repeat above at 5 digit level
	quietly gen x=1  if bnr==l.bnr & bnr==f.bnr & naering!=l.naering & naering!=f.naering & l.naering==f.naering
	quietly bys bnr: egen sumx=sum(x)
	tab sumx if n==N
* plants with one 5digit change of sector: replace the one-off change 
	quietly replace naering=l.naering if sumx==1 & x==1
* if two of these occur in two consecutive years, assume the last change is the 
* definite one, hence replace naering in the first case
	quietly replace naering=l.naering if sumx==2 & x==1 & f.x==1
	drop x sumx
	isicupdate
* Do not change the plant with 3 changes: printing sector, reasonable change
	quietly gen x=1  if bnr==l.bnr & bnr==f.bnr & naering!=l.naering & naering!=f.naering & l.naering==f.naering
	bys bnr: egen sumx=sum(x)
	tab sumx if n==N
	drop sumx x
*
*****
* Count the total number of remaining isic4changes per plant, 
	program define isic4change
		bys bnr: gen w=1 if isic4!=isic4[_n-1]
		replace w=0 if n==1
	 	replace w=0 if w==.
		bys bnr: egen z=sum(w)
	end
	isic4change
* Show the number of plants in the panel and the number 
* of isicchanges per plant
	tab z if n==N
* Leave it at that.
* Note that only naering is changed, not NACE codes, 
* as we use naering. Otherwise should have done similar stuff on nace 
save ${empdecomp}temp.dta, replace
tab aar


*****
* Make panel with all vars from industristat

forvalues t=1972/1995 {
use ${IND_DIR}in`t', clear
drop fonr naering
sort bnr aar
merge bnr aar using ${empdecomp}temp.dta
quietly keep if _merge==3
drop _merge
assert aar==`t'
sort bnr aar
quietly save ${empdecomp}temp`t', replace
}

forvalues t=1996/2000 {
use ${IND_DIR}in`t', clear
drop fonr naering nace
sort bnr aar
quietly merge bnr aar using ${empdecomp}temp.dta
quietly keep if _merge==3
drop _merge
quietly assert aar==`t'
sort bnr aar
quietly save ${empdecomp}temp`t', replace
}


use ${IND_DIR}in2001ny, clear
quietly drop if fs==2
keep bnr fnr aar
rename fnr fonr
sort bnr fonr aar
quietly save ${empdecomp}temp2001, replace
use ${IND_DIR}in2001, clear
drop naering nace
sort bnr fonr aar
quietly merge bnr fonr aar using ${empdecomp}temp2001.dta
quietly keep if _merge==3
drop _merge
sort bnr aar
quietly merge bnr aar using ${empdecomp}temp.dta
quietly keep if _merge==3
drop _merge
assert aar==2001
sort bnr aar
quietly save ${empdecomp}temp2001, replace

forvalues t=2002/2005 {
use ${IND_DIR}in`t', clear
drop fonr naering nace
sort bnr aar
quietly merge bnr aar using ${empdecomp}temp.dta
quietly keep if _merge==3
drop _merge
assert aar==`t'
sort bnr aar
quietly save ${empdecomp}temp`t', replace
}

* Kobler temp filene i et panel
use ${empdecomp}temp1972.dta, clear
forvalues t=1973/2005 {
quietly append using ${empdecomp}temp`t'
}
quietly compress
sort bnr aar

* Sletter tempfilene igjen og lagrer panelet
forvalues t=1972/2005 {
quietly erase ${empdecomp}temp`t'.dta
}

* Correct missing obs on utenl= foreign ownership in 1988
* All obs in 1988 are coded as "Norwegian"
* Change utenl in 1988 to either the year before or after
	tsset bnr aar
	quietly replace utenl=. if aar==1988
	quietly replace utenl=L.utenl if aar==1988
	quietly replace utenl=F.utenl if aar==1988 & utenl==.
	quietly replace utenl=utenl[_n-1] if aar==1988 & utenl==.
	quietly replace utenl=utenl[_n+1] if aar==1988 & utenl==.
	quietly replace utenl=0 if utenl==. & aar==1988
* Utenl after 1990 will be generated directly from merge with
* sifonregister
	sort bnr aar

* Since the empdecomp paper is only to use years after 1990,
* drop years before that to minimize dataset, but first save 
* a panel with investment info in order to generate capital values
	quietly save ${industri}entrycheck_update.dta, replace
	sort bnr aar
	keep aar bnr naering storb v13 v34 v45-v47 v50-v57 v60-v71 v114-v119 n N entry exit
	quietly save ${empdecomp}capitalpanel.dta, replace
	use ${industri}entrycheck_update.dta, clear
	* drop investment variables here
	drop if aar<1989
	drop v46-v47 v50-v57 v60-v71 v114-v119 
	quietly save ${industri}entrycheck_update.dta, replace
	quietly erase ${empdecomp}temp.dta


* Merge in info from SIFON register
* Merge on firm numner: fnr
* Rename orgnr in manufacturing data to indorgnr when that is
* introduced in 1996
* Rename orgnr in SIFON to sifonorgnr
* Kobler sifon og industristat paa variabelen fnr 

forvalues t=1990/2005 {
use ${industri}entrycheck_update.dta, clear
keep if aar==`t'
rename fonr fnr
sort fnr 
if `t'<1996 {
	assert orgnr==.
	}
if `t'>=1996 {
	rename orgnr indorgnr
	}
merge fnr using ${sifon}sifon`t', keep(orgnr stutla totutla stutla2 totutla2 ftype)
rename orgnr sifonorgnr
tab _merge
drop if _merge==2
quietly compress
quietly save ${empdecomp}temp`t', replace
}
*use ${industri}entrycheck_update.dta, clear
*quietly keep if aar==2005
*rename fonr fnr
*rename orgnr indorgnr
*quietly save ${empdecomp}temp2005.dta, replace
use ${industri}entrycheck_update.dta, clear
quietly keep if aar==1989
rename fonr fnr
rename orgnr indorgnr
quietly save ${empdecomp}temp1989.dta, replace

use ${empdecomp}temp1990.dta, clear
forvalues t=1991/2005 {
quietly append using ${empdecomp}temp`t'
}
quietly compress

sort bnr aar
quietly save ${industri}entrycheck_update.dta, replace

forvalues t=1990/2005 {
quietly erase ${empdecomp}temp`t'.dta
}


* Lager en kategorivariabel for indirekte utenl eierskap
gen indirutenl=1 if totutla2>=50 & totutla2<. & ftype!=1
quietly replace indirutenl=2 if totutla2>=20 & totutla2<50 & ftype!=1
quietly replace indirutenl=0 if totutla2<20 & ftype!=1
assert indirutenl==. if ftype==1
assert indirutenl!=. if ftype==2 | ftype==3
table aar indirutenl, row col
quietly replace indirutenl=0 if indirutenl==.
label var indirutenl "Total indirect for ownership: 0 <20%, 1>=50%, 2 >=20, <50%" 
quietly gen stindirutenl=1 if stutla2>=50 & stutla2<. & ftype!=1
quietly replace stindirutenl=2 if stutla2>=20 & stutla2<50 & ftype!=1
quietly replace stindirutenl=0 if stutla2<20 & ftype!=1
assert stindirutenl==. if ftype==1
assert stindirutenl!=. if ftype==2 | ftype==3
table stindirutenl
quietly replace stindirutenl=0 if stindirutenl==.
label var stindirutenl "Largest indirect owner: 0 <20%, 1>=50%, 2 >=20, <50%" 

* Lager en kategorivariabel for direkte utenl eierskap fra SIFON
drop utenl
quietly gen utenl=1 if totutla>=50 & totutla<. 
quietly replace utenl=2 if totutla>=20 & totutla<50 
quietly replace utenl=0 if totutla<20 
table aar utenl, row col
quietly replace utenl=0 if utenl==.
label var utenl "total direct foreign ownership: 0 <20%, 1>=50%, 2 >=20, <50%" 
quietly gen stutenl=1 if stutla>=50 & stutla<. 
quietly replace stutenl=2 if stutla>=20 & stutla<50 
quietly replace stutenl=0 if stutla<20 
table stutenl
quietly replace stutenl=0 if stutenl==.
label var stutenl "Largest direct owner: 0 <20%, 1>=50%, 2 >=20, <50%" 

* lager kategorivar som inkluderer baade
* indirekte og direkte utenl eierskap
quietly gen totutenl=1 if utenl==1 | indirutenl==1
quietly replace totutenl=2 if utenl==2 | indirutenl==2
quietly replace totutenl=0 if totutenl==.
table aar totutenl, row col
label var totutenl "Total foreign ownership, dir and indir, 0,1,2" 
drop stutla stutla2 totutla totutla2
quietly gen larutenl=1 if stutenl==1 | stindirutenl==1
quietly replace larutenl=2 if stutenl==2 | stindirutenl==2
quietly replace larutenl=0 if larutenl==.
table aar larutenl, row col
label var larutenl "Largest foreign owner, dir and indir, 0,1,2" 
sort bnr aar
quietly save ${industri}entrycheck_update.dta, replace



* From linkorgnrfnr9601.do
***22.11.04***RBal*******************************************************
* This do-file ignores 2 probls with fnr orgnr associations in ind.data 
* a) more than one orgnr per fnr per year(1997)and b)changing orgnr for 1
* fnr over time. Instead use linkfiles received from SSB 28.01.05 for the 
* years 1993-1995 to get orgnr in the industryfiles. For firms that do not 
* get orgnr this way, I try to fill in orgnr for the years 1993-95 from 
* 1996 where possible. The orgnr are used when merging in kapitaldatabasen. 
*************************************************************************
*** Revidert 28.01.05 and 19.03.05****************************************
	
* 1. 
* Merge in orgnr from files orgfnrYYYY.dta, received from SSB
* for the years 1993,1994,1995 to help with merging in 
* Kapitaldatabasen later

* Make a panel of the fnr-orgnr connections
	use ${IND_DIR}orgfnr1993.dta, clear
	quietly gen aar=1993
	quietly save ${industri}temp1.dta, replace
	use ${IND_DIR}orgfnr1994.dta
	quietly gen aar=1994
	quietly append using ${industri}temp1.dta
	quietly save ${industri}temp1.dta, replace
	use ${IND_DIR}orgfnr1995.dta
	quietly gen aar=1995
	quietly append using ${industri}temp1.dta
	sort fnr aar
	quietly save ${industri}temp1.dta, replace
* Merge onto the entrycheck.dta
	use ${industri}entrycheck_update.dta, clear
	sort fnr aar
	merge fnr aar using ${industri}temp1.dta, _merge(test)
	tab test
	quietly drop if test==2
* Replace indorgnr with orgnr from the linkfiles
	quietly replace indorgnr=orgnr if aar==1993
	quietly replace indorgnr=orgnr if aar==1994
	quietly replace indorgnr=orgnr if aar==1995
	drop orgnr test

* 2.
* Extend the orgnr in 1996 to the years 1993-1995 if indorgnr=.
	sort bnr aar
	quietly replace indorgnr=indorgnr[_n+1] if aar==1995 & indorgnr[_n+1]!=. & bnr==bnr[_n+1] & fnr==fnr[_n+1] & indorgnr==.
	quietly replace indorgnr=indorgnr[_n+1] if aar==1994 & indorgnr[_n+1]!=. & bnr==bnr[_n+1] & fnr==fnr[_n+1] & indorgnr==.
	quietly replace indorgnr=indorgnr[_n+1] if aar==1993 & indorgnr[_n+1]!=. & bnr==bnr[_n+1] & fnr==fnr[_n+1] & indorgnr==.

count if aar==1993
count if indorgnr==. & aar==1993
count if aar==1994
count if indorgnr==. & aar==1994
count if aar==1995
count if indorgnr==. & aar==1995

sort bnr aar
quietly save ${industri}entrycheck_update.dta, replace
erase ${industri}temp1.dta


* Drop variables clearly not going to be used
quietly append using ${empdecomp}temp1989.dta
rename n initialn
rename N initialN
label var initialn " obs number for plant in full panel from 1972"
label var initialN " Number of obs for plant in full panel from 1972"		
drop eierform regn kopi skjema ktgml ktny handel 
drop invest kt7gml kt8gml kt8ny syssel v11 v12 
drop v105 v107 v109 v111 w z navn fs opop _merge  
drop bkode arbeid loennk loennsI loennsII
sort bnr aar
quietly save ${industri}entrycheck_update.dta, replace
erase ${empdecomp}temp1989.dta


****************
* 4 From define_entryexit.do: to define temporary exits and reentry
****************
use ${industri}entrycheck_update.dta, clear
* Use fillin command to investigate holes in obs series for each plant
	tab aar
	bys bnr: gen n=_n
	bys bnr: gen N=_N
	label var n " obs number for plant in panel from 1989"
	label var N " Number of obs for plant in full panel from 1989"		
	count if n==N
	* Initial number of entering plants pr year before reentry definitions
	tab aar  if aar==entry 
	fillin bnr aar 
	bys bnr: egen entryaar=mean(entry)
	bys bnr: egen exitaar=mean(exit)
	* Drop filled in obs before entry and after exit
	quietly drop if _fillin==1 & aar<entryaar
	quietly drop if _fillin==1 & aar>exitaar
	tab _fillin
	assert _fillin==0 if aar==entryaar | aar==exitaar
	rename _fillin fill
	program define countfill
		quietly bys bnr: gen nfill=_n
		quietly bys bnr: gen Nfill=_N
		quietly bys bnr: egen sumfill=sum(fill)
	end
	countfill

* Replace entry with new entry if plant is first obs
* in 1992 or later, but had entry <1989. First entry after 1990
	assert nfill==4 if n==1 & aar==1992 & entryaar!=1992 & sumfill!=0
	assert nfill>=4 if n==1 & aar>=1992 & entryaar<aar & sumfill!=0
	assert entry<1989 if nfill==4 & n==1 & aar==1992 & sumfill!=0
	assert entry<1989 if nfill>=4 & n==1 & aar>=1992 & sumfill!=0
	gen y=aar if n==1 & nfill>=4 & entry<1989 & sumfill!=0
	bys bnr: egen x=mean(y)
	tab x
	tab y
	replace entryaar=x if entryaar<1989 & x!=.
	drop if fill==1 & aar<entryaar
	replace entry=entryaar if x!=.
	drop x y

* Plants first obs in 1991 but with entry<1989, drop filled in obs before 
* 1991
	gen x=1 if aar==1991 & nfill==3 & n==1
	bys bnr: egen y=mean(x)
	drop if fill==1 & aar<1991 & y==1
	drop x y
	gen x=1 if aar==1990 & nfill==2 & n==1
	bys bnr: egen y=mean(x)
	drop if fill==1 & aar<1990 & y==1
	drop x y nfill Nfill sumfill
	countfill
	assert n==1 if nfill==1

* Drop single filled-in observations 
	drop if fill==1 & L.fill==0 & F.fill==0
	drop nfill Nfill sumfill
	countfill
	assert sumfill!=1

* Drop 2 filled-in obs in a row: 
	program define gendiff
		gen nyn=n
		replace nyn=L.nyn if n==.
		assert nyn!=.
		gen diff=nfill-nyn
		assert diff==0 if n==1
		gen x=1 if diff==2 & L.diff==2 & L2.diff==1 & L3.diff==0
		bys bnr: egen y=mean(x)
		drop if y==1 & fill==1 & diff<=2
	end
	gendiff
	drop x y nyn diff nfill Nfill sumfill
	countfill
	gendiff
	drop x y nyn diff nfill Nfill sumfill
	countfill
	gendiff
	drop x y nyn diff nfill Nfill sumfill
	countfill
	gendiff
	assert sumfill!=1 | sumfill!=2

* 3 or more filled-in obs in a row is assumed a temporary
* closure. Define new entry and exit, drop filled in obs
	tsset bnr aar
		gen z=1 if diff==3 & L.diff==3 & L2.diff==2 & L3.diff==1 & L4.diff==0
	program define reentry
		gen newentry=aar if z==1
		bys bnr: egen zplant=mean(z)
		bys bnr: egen zentry=mean(newentry)
		replace newentry=zentry if zplant==1 & diff!=0
		gen ex=1 if diff==0 & F.diff==1 & zplant==1
		gen newexit=aar if ex==1
		bys bnr: egen zexit=mean(newexit)
		replace newexit=zexit if zplant==1 & diff==0
		drop if fill==1 & zplant==1
	end
	reentry
	assert newentry!=. if sumfill==3 & nfill==Nfill
	assert newexit!=. if sumfill==3 & nfill==1
	assert newentry==. if sumfill==3 & nfill==1
	assert newexit==. if sumfill==3 & nfill==Nfill
		gen entry1=newentry if newentry!=.
		gen exit1=newexit if newexit!=.
		assert entry1==. if zplant==.
		assert exit1==. if zplant==.
	drop x y z newentry ex newexit nfill Nfill sumfill diff nyn zplant zentry zexit
	countfill
	gendiff
	gen z=1 if diff==3 & L.diff==3 & L2.diff==2 & L3.diff==1 & L4.diff==0
	reentry
	assert sumfill!=3

* 4 or more filled in observations in a row is assumed a 
* temporary closure
* define new entry and exit, drop filled in obs
	drop x y z newentry ex newexit nfill Nfill sumfill diff nyn zplant zentry zexit
	countfill
	gendiff
	gen z=1 if diff==4 & L.diff==4 & L2.diff==3 & L3.diff==2 & L4.diff==1 & L5.diff==0
	reentry
	assert newentry!=. if sumfill==4 & nfill==Nfill
	assert newexit!=. if sumfill==4 & nfill==1
	assert newentry==. if sumfill==4 & nfill==1
	assert newexit==. if sumfill==4 & nfill==Nfill

	gen entry2=newentry if newentry!=.
	gen exit2=newexit if newexit!=.
	assert entry2==. if zplant==.
	assert exit2==. if zplant==.

	drop x y z newentry ex newexit nfill Nfill sumfill diff nyn zplant zentry zexit
	countfill
	gendiff
	gen z=1 if diff==4 & L.diff==4 & L2.diff==3 & L3.diff==2 & L4.diff==1 & L5.diff==0
	reentry
	* no obs dropped
	assert sumfill==0 | sumfill>4

* Check that all remaining filled-in obs come in a row
* For plants with 5 6 8 9 filled in obs this is so
	gen test=Nfill-N if fill==0
	assert test==sumfill if fill==0
	tsset bnr aar
	assert L6.diff==0 if diff==5 & L.diff==5 & L2.diff==4 & sumfill==5
	assert L7.diff==0 if diff==6 & L.diff==6 & L2.diff==5 & sumfill==6	
	*assert L8.diff==0 if diff==7 & L.diff==7 & L2.diff==6 & sumfill==7
	assert L9.diff==0 if diff==8 & L.diff==8 & L2.diff==7 & sumfill==8
	assert L10.diff==0 if diff==9 & L.diff==9 & L2.diff==8 & sumfill==9
	assert L11.diff==0 if diff==10 & L.diff==10 & L2.diff==9 & sumfill==10
	assert L12.diff==0 if diff==11 & L.diff==11 & L2.diff==10 & sumfill==11
	assert L13.diff==0 if diff==12 & L.diff==12 & L2.diff==11 & sumfill==12
	assert L14.diff==0 if diff==13 & L.diff==13 & L2.diff==12 & sumfill==13
	drop x y z newentry ex newexit nfill Nfill sumfill diff nyn zplant zentry zexit
	countfill
	gendiff
	gen z=1 if diff==5 & fill==0 & L.diff==5 & L.fill==1 & sumfill==5
	foreach t in 6 8 9 10 11 12 13 {
		replace z=1 if z==. & diff==`t' & fill==0 & L.diff==`t' & L.fill==1 & sumfill==`t'
	} 
	reentry
	gen entry3=newentry if newentry!=.
	gen exit3=newexit if newexit!=.
	assert entry3==. if zplant==.
	assert exit3==. if zplant==.
	drop x y z newentry ex newexit nfill Nfill sumfill diff nyn zplant zentry zexit
	countfill
	gendiff
	gen z=1 if diff==5 & fill==0 & L.diff==5 & L.fill==1 & sumfill==5
	foreach t in 6 8 9 10 11 12 13 {
		replace z=1 if z==. & diff==`t' & fill==0 & L.diff==`t' & L.fill==1 & sumfill==`t'
	} 
	reentry
	* nochanges made/no obs dropped
	assert sumfill==0 | sumfill==7
	* drop the 139 obs from the 10 plants with 7 filled in obs, 
	* these plants have more than one temp exit
	drop if sumfill==7

* Fix the entry variables
	assert fill==0
	drop x y z newentry ex newexit nfill Nfill sumfill diff nyn zplant zentry zexit
	drop fill entryaar exitaar
	sum entry* exit*
	egen entrymiss=rowmiss(entry1 entry2 entry3)
	egen exitmiss=rowmiss(exit1 exit2 exit3)
	tab entrymiss
	tab exitmiss

	foreach t in 1 2 3 {
		bys bnr: egen me`t'=mean(entry`t')
		bys bnr: egen mex`t'=mean(exit`t')
	}
	egen me_miss=rowmiss(me1 me2 me3)
	egen mex_miss=rowmiss(mex1 mex2 mex3)
	tab me_miss
	tab mex_miss
* Based on above: all plants have only one reentry
	replace entry1=entry2 if entry1==. & entry2!=.
	replace entry1=entry3 if entry1==. & entry3!=.
	replace exit1=exit2 if exit1==. & exit2!=.
	replace exit1=exit3 if exit1==. & exit3!=.
	sum entry1 exit1
* Number of plants with ekstra entry is 147
	count if exit1!=. & n==1
	count if entry1!=. & n==N
* Panel now has no filled in observations



****
* Save panel: drop year 1989
drop if aar==1989
drop entry2 entry3 exit2 exit3 me* mex* *miss test
sort bnr aar
quietly save ${industri}entrycheck_update.dta, replace

tab totutenl if aar==entry1
tab larutenl if aar==entry1

tab larutenl
tab totutenl
tab larutenl if aar==entry

* repeat summary info: compare with before dropping to see 
* the effect of drop procedures
tab aar if aar>1991 & aar<2005
tab isic2 if aar>1991 & aar<2005
sum v13 if aar>1991 & aar<2005
tab totutenl if aar>1991 & aar<2005
keep if aar>1991 & aar<2005
drop n N
bys bnr: gen n=_n
bys bnr: gen N=_N
count if n==N
egen totsyss=sum(v13)
sum totsyss

log close
exit
