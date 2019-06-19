
version 8
clear
capture program drop _all
capture log close
set more off
pause on
set memory 20m


**************************************************
* Prepares the original datafiles from Statstics Norway
* from the SIFON register of foreign ownership in Norway
* Merge info from SIFOn onto the manufaxcturing statstics 
* from Statistics Norway
**************************************************


* Lager et program som lesere aarsfilene med hovedvariablene inn i STATA
* Problemet med nacekoden rettes opp

program define stataformat1
         local i=1990
         while `i'<=2001 {
			clear
                 	display `i'
			insheet using ${sifon}SNF_sifon`i'.sdv, delimit(";")
			destring, replace
			compress
			order aar orgnr orgnr_konsern fnr konsern_nr
			sort orgnr
			save temp`i', replace
                 	local i=`i'+1
         }
end


* Lager et program som setter sammen de aarvise STATA-filene

program define kombiner1
clear
use  temp1990
  	   local i=1991
         while `i'<=2001 {
                 display `i'
                 append using temp`i'
		     erase temp`i'.dta
                 local i=`i'+1
         }
erase temp1990.dta
sort orgnr aar
end




* Kjoerer de to programmene over for aa lage et panel med
* hovedvariablene og setter labels paa variablene.

stataformat1
kombiner1

label var aar "aar"
label var orgnr_konsern "orgnr konsern; 0+fnr konsern hvis missing"        
label var orgnr "orgnr foretak; 0+fnr hvis missing"
label var tilst "tilstand: 1=normal drift, 2=opphoert siden i fjor, 3=hjemkj siden i fjor"
label var ftype "foretakstype: 1= mor, 2= dtr ogsaa direkte utleiet, 3=dtr indirekte  utleiet"
label var sektor "institusjonell sektorkode"
label var nace1 "naeringskode"
label var komm "kommunekode"
label var akap_utl "utenlandskeiede aksjer, paalydende, 1000 kr"
label var akap_pv "aksjekapital, paalydende, 1000 kr, alle selskaper"
label var akap_mv "aksjekapital, markedverdi, 1000 kr, boersnoterte selskaper"
label var stutla "stoerste utenlandske eierandel, prosent"
label var totutla "total utenlansk eierandel, prosent"
label var stutland "landkode for stoerste utenlandske eier"
label var stutla2 "stoerste utenlandske eierandel i morselskapet, prosent"
label var totutla2 "total utenlansk eierandel i morselskapet, prosent"
label var stutland2 "landkode for stoerste utenlandske eier i morselskapet"
label var fnr "foretaksnummer BoF"
label var konsern_nr "konsernnummer BoF"


* Retter problemet med nacekoden, lagrer
* denne uten punktum etter to siffer

replace nace1=round(nace1, 0.001)
replace nace1=int(nace1*1000)


* I aargangene fom 1997 ligger en del foretak inne med to 
* observasjoner registrert paa to forskjellige kommuner.
* Den ene observasjonen har tall for akap_utl og missing
* verdier i akap_pv og akap_mv. I den andre observasjonen
* er det motsatt. Ellers er alle variablene like.

*Demonstrerer problemet:
bysort orgnr aar (akap_utl): gen n=_n
bysort orgnr aar (akap_utl): gen N=_N
tab n
tab aar if n==2
tab tilst if n==2

*Viser hvilke variable som er ulike
bysort n: sum komm if N==2
bysort n: sum akap_utl if N==2
bysort n: sum akap_pv if N==2 
bysort n: sum akap_mv if N==2
tab komm if n==1 & N==2
tab komm if n==2 & N==2

*Viser hvilke variabler som er like
bysort n: sum aar if N==2
bysort n: sum orgnr if N==2
bysort n: sum orgnr_konsern if N==2
bysort n: sum fnr if N==2
bysort n: sum konsern_nr if N==2
bysort n: sum tilst if N==2
bysort n: sum ftype if N==2
bysort n: sum sektor if N==2
bysort n: sum nace1 if N==2
bysort n: sum stutla if N==2
bysort n: sum stutland if N==2 
bysort n: sum stutla2 if N==2
bysort n: sum totutla2 if N==2 
bysort n: sum stutland2 if N==2

*Retter opp ved aa hente missing verdier fra den andre observasjonen samme aar
sort orgnr aar n
replace  akap_utl= akap_utl[_n-1] if N==2 & orgnr==orgnr[_n-1] & aar==aar[_n-1] & akap_utl==.
replace  akap_pv= akap_pv[_n+1] if N==2 & orgnr==orgnr[_n+1] & aar==aar[_n+1] & akap_pv==.
replace  akap_mv= akap_mv[_n+1] if N==2 & orgnr==orgnr[_n+1] & aar==aar[_n+1] & akap_mv==.
bysort n: sum akap_utl if N==2
bysort n: sum akap_pv if N==2 
bysort n: sum akap_mv if N==2

*Observasjoner med n==2 har avvikende kommunenummer naar
*en sammenligner med andre aarganger. Fjerner derfor disse
sort orgnr aar n
egen maxN=max(N), by(orgnr)
sort maxN orgnr aar n
drop if n==2
drop n N maxN
tsset orgnr aar


* Retter opp sammenblanding av fnr og sektor
* for foretak med tilstandskode 2 og 3

replace fnr=sektor if tilst==2 | tilst==3
assert fnr==L.fnr if (tilst==2 | tilst==3) & L.fnr!=.
assert sektor!=L.sektor if (tilst==2 | tilst==3) & L.sektor!=.
replace sektor=. if sektor ==fnr & (tilst==2 | tilst==3)


* Lagrer panelet med hovedvariablene

sort orgnr aar
save ${sifon}sifonpanel, replace


*ved innlesing av totutla og totutla2 skjer det avrunding som
*gjør at de ikke blir oppfatta som like sjøl om de er det. Retter opp 
*og kontrollerer at problemet er loest

generate float stutla1=stutla
drop stutla
rename stutla1 stutla
generate float totutla1=totutla
drop totutla
rename totutla1 totutla
label var stutla "stoerste utenlandske eierandel, prosent"
label var totutla "total utenlansk eierandel, prosent"

*sjekker at totutla=totutla2 naar foretaket er et morselskap 
*og at det ikke er . obs
assert totutla==totutla2 if ftype==1
assert totutla!=. if ftype==1

*sjekker at dir. utenl eierskap er . naar foretaket er indirekte utenl eid,
*og at det ikke er .obs for indirekte eirerskap
assert totutla==. if ftype==3
assert totutla2!=. if ftype==3

*sjekker at dir og indir utenl eierskap ikke er . naar ftype=2
assert totutla2!=. & totutla!=. if ftype==2

*sjekker at obs for utenl eierskap er . naar foretaket er
*hjemkjoept eller opphoert siden i fjor
assert (totutla2==. & totutla==.) if (tilst==2 | tilst==3)

* sjekker at ftype ikke er . for foretak i ordinaer drift
assert ftype!=. if tilst==1

*lager en ny variabel med grader av direkte utenl eierskap
* Denne er sammenlignbar med utenl variabelen i ind foer
* 1990 (Sifon hadde da bare info om direkte utenl eierskap)
generate sifonutenl=1 if (totutla>=50 & totutla<.)
replace sifonutenl=0 if totutla<20 
replace sifonutenl=2 if totutla>=20 & totutla<50 
assert sifonutenl!=. if ftype==1 | ftype==2
assert sifonutenl==. if ftype==3
replace sifonutenl=0 if ftype==3
assert sifonutenl==. if tilst==2 | tilst==3
assert sifonutenl!=. if ftype==1 & tilst==1
replace sifonutenl=0 if tilst==2 | tilst==3
assert sifonutenl!=.
label var sifonutenl "utenlandsk eierandel: 0:<20%, 1:>=50%, 2:=20-50%, "

*lagrer sifonpanelet
sort orgnr aar
save ${sifon}sifonpanel, replace


forvalues t=1990/2001 {
clear
use ${sifon}sifonpanel
keep if aar==`t'
sort fnr
save ${sifon}sifon`t', replace
}


**************************************************************
* Programmet kobler sifonaarsfilene med aarsfilene
* fra industristatistikken. De kobla filene lagres i 
* industriYYYY og sifonaarsfilene slettes
*
* Inspeksjon av sifon aarsfilene viser at foretaksnummer finnes
* for alle observasjoner (med inntil 8 siffer), men naar det 
* gjelder orgnr saa er dette i noen tilfeller lik foretaksnummeret.
* I industristatistikken finnes foretaksnr i alle aar med inntil
* 8 siffer, mens orgnr foerst kommer i 1996. Mener det blir riktig
* aa koble sifon paa industristatistikken ved aa bruke foretaksnummer
**************************************************************

* Viser at i industristatistikken har alle obs registrert
* bnr og fonr i alle aar fra 1990 til 2001 unntatt i 2000,
* der er 135 obs uten fonr
forvalues t=1990/2001 {
use ${IND_DIR}in`t', clear
display `t'
sum aar bnr fonr tilstand
}

* Viser at i sifon har alle obs registerert fnr og orgnr
forvalues t=1990/2001 {
use ${sifon}sifon`t', clear
display `t'
sum aar fnr orgnr tilst
}

* Ser paa serien av foretaksnummer
forvalues t=1990/2001 {
use ${IND_DIR}in`t', clear
display `t'
sum fonr 
use ${sifon}sifon`t', clear
sum fnr
sum orgnr
}


* Kan vise at hver bnr bare er registrert en gang i indstat pr aar 
* Unntaket er 2001 med 4 bedrifter, Kobler paa variabelen fs fra in2001ny. Indikator
* for skifte av foretak. Dropper hvis fs==2
use ${IND_DIR}in2001, clear
bysort bnr: gen n=_n
tab n
drop n
sort bnr
save ${industri}in2001, replace
merge bnr using ${IND_DIR}in2001ny, keep (fs)
assert _merge==3
drop _merge
drop if fs==2
drop fs
save ${industri}in2001, replace


* Viser at i 2000 finnes de 135 obs uten fonr i industri stat 
* heller ikke i sifon. Konkl er at kobling av sifon paa ind stat
* kan gjoeres paa foretaksnummer.  
use ${sifon}sifon2000, clear
sort orgnr
save ${sifon}sifon2000, replace
use ${IND_DIR}in2000, clear
keep if fonr==.
sort orgnr
merge orgnr using ${sifon}sifon2000
assert _merge!=3
use ${sifon}sifon2000, clear
sort fnr
save ${sifon}sifon2000, replace

* From 1998 the file size in indsta doubles due to the inclusion 
* of very small firms. In 1998 they have utvalg==2, from 1999 they have 
* opop==0 in inYYYYny.dta files 
use ${IND_DIR}in1998ny, clear
keep bnr utvalg
drop if utvalg==2
drop utvalg
sort bnr
save ${industri}temp1998ny, replace
use ${IND_DIR}in1998, clear
sort bnr 
merge bnr using ${industri}temp1998ny
assert _merge!=2
keep if _merge==3
drop _merge
save ${industri}in1998, replace

forvalues t=1999/2000 {
use ${IND_DIR}in`t'ny, clear
keep bnr opop
drop if opop==0
drop opop
sort bnr
save ${industri}temp`t'ny, replace
use ${IND_DIR}in`t', clear
sort bnr 
merge bnr using ${industri}temp`t'ny
assert _merge!=2
keep if _merge==3
drop _merge
save ${industri}in`t', replace
}
use ${IND_DIR}in2001ny, clear
keep bnr opop fs
drop if opop==0
drop opop
drop if fs==2
drop fs
sort bnr
save ${industri}temp2001ny, replace
use ${industri}in2001, clear
sort bnr 
merge bnr using ${industri}temp2001ny
assert _merge!=2
keep if _merge==3
drop _merge
bys bnr: gen N=_N
assert N==1
drop N
save ${industri}in2001, replace

erase ${industri}temp1998ny.dta
erase ${industri}temp1999ny.dta
erase ${industri}temp2000ny.dta
erase ${industri}temp2001ny.dta

* Kobler sifon og industristat paa variabelen fnr 
forvalues t=1990/1997 {
use ${IND_DIR}in`t', clear
rename fonr fnr
sort fnr 
if `t'>=1996 {
	rename orgnr indorgnr
	}
merge fnr using ${sifon}sifon`t'
rename orgnr sifonorgnr
tab _merge
drop if _merge==2
compress
save ${industri}industri`t', replace
}
forvalues t=1998/2001 {
use ${industri}in`t', clear
rename fonr fnr
rename orgnr indorgnr
sort fnr 
merge fnr using ${sifon}sifon`t'
rename orgnr sifonorgnr
tab _merge
drop if _merge==2
compress
save ${industri}industri`t', replace
}
forvalues t=1990/2001 {
erase ${sifon}sifon`t'.dta
}
forvalues t=1998/2001 {
erase ${industri}in`t'.dta
}


exit

