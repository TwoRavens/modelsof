clear all
set mem 500m
set more off
************************************************************************************

clear
use aha_1948_2006
replace fcounty1=36999 if fcounty1==36005
replace fcounty1=36999 if fcounty1==36047
replace fcounty1=36999 if fcounty1==36061
replace fcounty1=36999 if fcounty1==36081
replace fcounty1=36999 if fcounty1==36085
gen days=adc*360
collapse (sum) bdtot days admtot paytot fte exptot (count) firms=_newid (mean) rural, by (fcounty1 year cntrl)
** merge the temp file with the state county names for the fips codes **
** merge this with the collapsed AHA data at the county level
drop if cntrl==3
drop if cntrl==.
tostring fcounty1, replace

replace rural=0 if fcounty1=="12025" 
replace rural=0 if fcounty1=="13089"
replace rural=0 if fcounty1=="17089" 
replace rural=1 if fcounty1=="24007"
replace rural=1 if fcounty1=="28121"
replace rural=0 if fcounty1=="29021"
replace rural=0 if fcounty1=="29095"
replace rural=0 if fcounty1=="6037" 
replace rural=0 if fcounty1=="8001"
replace rural=0 if fcounty1=="8059"
replace rural=0 if fcounty1=="9009"
replace rural=0 if fcounty1=="29183"
replace rural=0 if fcounty1=="36005"
replace rural=0 if fcounty1=="36059"
replace rural=0 if fcounty1=="36061"
replace rural=0 if fcounty1=="36065"
replace rural=0 if fcounty1=="36081"
replace rural=0 if fcounty1=="36085"
replace rural=0 if fcounty1=="36119"
replace rural=0 if fcounty1=="37183"
replace rural=0 if fcounty1=="42045"
replace rural=0 if fcounty1=="42077"
replace rural=0 if fcounty1=="42091"
replace rural=0 if fcounty1=="42095"
replace rural=0 if fcounty1=="45045"
replace rural=1 if fcounty1=="48157"
replace rural=0 if fcounty1=="48201"
replace rural=0 if fcounty1=="51129"
replace rural=0 if fcounty1=="51161"
replace rural=1 if fcounty1=="51159"


reshape wide bdtot days admtot paytot fte exptot firms rural, j(cntrl) i(fcounty1 year)
replace rural1=0 if missing(rural1)
replace rural2=0 if missing(rural2)
replace rural4=0 if missing(rural4)

gen rural=rural1+rural2+rural4
drop rural1 rural2 rural4
replace rural=1 if rural>0

rename bdtot1 bdtotfp 
rename bdtot2 bdtotnp 
rename bdtot4 bdtotpb 
rename days1 daysfp 
rename days2 daysnp 
rename days4 dayspb 
rename admtot1 admtotfp 
rename admtot2 admtotnp 
rename admtot4 admtotpb 
rename paytot1 paytotfp 
rename paytot2 paytotnp 
rename paytot4 paytotpb 
rename fte1 ftefp 
rename fte2 ftenp 
rename fte4 ftepb 
rename exptot1 exptotfp 
rename exptot2 exptotnp 
rename exptot4 exptotpb 
rename firms1 firmsfp 
rename firms2 firmsnp 
rename firms4 firmspb 

destring fcounty1, replace
sort fcounty1 year
merge fcounty1 year using arftemp
order _merge fcounty1 year 

rename _merge merge1
sort fcounty1 year


tsset fcounty1 year
tsfill
local varlist "bdtot* days*"
foreach x of varlist bdtotfp daysfp admtotfp paytotfp ftefp exptotfp firmsfp bdtotnp daysnp admtotnp paytotnp ftenp exptotnp firmsnp bdtotpb dayspb admtotpb paytotpb ftepb exptotpb firmspb {
	by fcounty1: ipolate `x' year, gen(i`x')
}
foreach x of varlist bdtotfp daysfp admtotfp paytotfp ftefp exptotfp firmsfp bdtotnp daysnp admtotnp paytotnp ftenp exptotnp firmsnp bdtotpb dayspb admtotpb paytotpb ftepb exptotpb firmspb {
	replace `x'=i`x' if merge==.
}
drop ibdtotfp idaysfp iadmtotfp ipaytotfp iftefp iexptotfp ifirmsfp ibdtotnp idaysnp iadmtotnp ipaytotnp iftenp iexptotnp ifirmsnp ibdtotpb idayspb iadmtotpb ipaytotpb iftepb iexptotpb ifirmspb


*******************************
tostring fcounty1, replace
sort fcounty1 year

merge fcounty1 year using hbprtemp
drop  pop regioncode regionname nfmd POP65 employm nwpop fam urbpop POPLT5 popdens medfaminc
replace hbfund_np=0 if missing(hbfund_np)
replace hbfund_pb=0 if missing(hbfund_pb)

gen hbfund_tot= hbfund_pb + hbfund_np

//save aha_county, replace

* fix negative and 8000000 values for NWPOP from ARF
gen testnwpop=inwpop if year==1950 | year==1960| year==1970 | year==1980| year==1990 | year>=2000

order testnwpop
replace testnwpop=0 if testnwpop==80000000
replace testnwpop=2368 if testnwpop==90002368 & fcounty1=="51195"
replace testnwpop=2968 if testnwpop==90002968 & fcounty1=="51005"
replace testnwpop=944 if testnwpop==90000944 & fcounty1=="51077"

replace testnwpop=0 if testnwpop<0
sort fcounty year
by fcounty1: ipolate testnwpop year, gen(itestnwpop)
drop inwpop
rename itestnwpop inwpop

** give 1948 and 1949 the same growth rate as 1950-51 growth in nwpops **
*1949 population *
sort fcounty1 year
gen inwpop2=(inwpop[_n+2]-inwpop[_n+1])/inwpop[_n+1]
gen inwpop3=inwpop[_n+1]
gen inwpop4=inwpop3/(1+inwpop2)
replace inwpop=inwpop4 if missing(inwpop)

* 1948 variable *
drop inwpop2 inwpop3 inwpop4
sort fcounty1 year
gen inwpop2=(inwpop[_n+2]-inwpop[_n+1])/inwpop[_n+1]
gen inwpop3=inwpop[_n+1]
gen inwpop4=inwpop3/(1+inwpop2)
replace inwpop=inwpop4 if missing(inwpop)
drop inwpop2 inwpop3 inwpop4


gen inwpop_pct=inwpop/ipop
order inwpop_pct


drop if year>1975
set obs 89218
replace year = 1948 in 89218
replace fcounty1 = "56045" in 89218
set obs 89219
replace year = 1950 in 89219
replace fcounty1 = "56045" in 89219
set obs 89220
replace year = 1947 in 89220
replace fcounty1 = "56045" in 89220

egen cnt_obs=count(year), by(fcounty1)
list fcounty1 if cnt_ob<29

drop if fcounty1=="4012"
drop if fcounty1=="51800" | fcounty1=="51730" | fcounty1=="51740" | fcounty1=="51710" | fcounty1=="51590"


save aha_county1, replace


************************* create data_working from aha_county1*******************
clear 
use aha_county1 

destring fcounty1, replace
sort fcounty1 year
drop _merge
merge fcounty1 year using "C:\Users\Andrea\Desktop\School - CMU\Research\HillBurton\older_aha_data\aha47.dta"

replace bdtotfp=bedsfp if year==1947
replace bdtotnp=bedsnp if year==1947
replace bdtotpb=bedspb if year==1947

replace admtotfp=admissionsfp if year==1947
replace admtotnp=admissionsnp if year==1947
replace admtotpb=admissionspb if year==1947

replace daysfp=365*adcfp if year==1947
replace daysnp=365*adcnp if year==1947
replace dayspb=365*adcpb if year==1947
 
drop  bedsfp adcfp admissionsfp bedsnp adcnp admissionsnp bedspb adcpb admissionspb

*drop if year>1975

drop if fcounty==15001 | fcounty==15003 | fcounty1==15007 |fcounty==15009

tostring fcounty1, replace

label variable ipop "Popn"
label variable imedfaminc "Med Family Income"

sort fcounty1 year
	by fcounty1: ipolate ipop year, gen(ipop2)
	drop ipop
	rename ipop2 ipop

* replace missing values for beds
replace bdtotfp=0 if missing(bdtotfp)
replace bdtotnp=0 if missing(bdtotnp)
replace bdtotpb=0 if missing(bdtotpb)

gen beds_tot=bdtotfp+bdtotnp+bdtotpb
gen beds_nppb=bdtotnp+bdtotpb

* treatment variable (time in which county got funding)
	gen treat_it=1 if hbfund_np!=0 | hbfund_pb!=0
	replace treat_it=0 if hbfund_np==0 & hbfund_pb==0

* group public and nonprofits since thats how treatment variable is defined
gen beds_nppub=bdtotnp+bdtotpb

* generate log of outcome variable
	replace beds_tot=1 if beds_tot==0	
	replace bdtotfp=1 if bdtotfp==0	
	replace bdtotnp=1 if bdtotnp==0	
	replace bdtotpb=1 if bdtotpb==0	
	replace beds_nppub=1 if beds_nppub==0	

	
	gen lbeds_tot=log(beds_tot)
	gen lbdtotfp=log(bdtotfp)
	gen lbdtotnp=log(bdtotnp)
	gen lbdtotpb=log(bdtotpb)
	gen lbeds_nppub=log(beds_nppub)

** interpolate median family inc for year1954 **
sort fcounty1 year
	by fcounty1: ipolate imedfaminc year, gen(imedfaminc2)
	drop imedfaminc 
	rename imedfaminc2 imedfaminc 
sort fcounty1 year
	by fcounty1: ipolate infmd year, gen(infmd2)
	drop infmd
	rename infmd2 infmd
sort fcounty1 year
	by fcounty1: ipolate ipop65 year, gen(ipop652)
	drop ipop65
	rename ipop652 ipop65
sort fcounty1 year
	by fcounty1: ipolate ipoplt5 year, gen(ipoplt52)
	drop ipoplt5
	rename ipoplt52 ipoplt5
sort fcounty1 year
	by fcounty1: ipolate inwpop_pct year, gen(inwpop_pct2)
	drop inwpop_pct
	rename inwpop_pct2 inwpop_pct

/* fix median family income values */
replace imedfaminc=. if imedfaminc==800000
rename imedfaminc medfaminc
replace medfaminc=. if year<1950
replace medfaminc=. if year>1950 & year<1960

by fcounty: ipolate medfaminc year, gen (imedfaminc)
*1949 medfaminc *
gen imedfaminc2=(imedfaminc[_n+2]-imedfaminc[_n+1])/imedfaminc[_n+1]
gen imedfaminc3=imedfaminc[_n+1]
gen imedfaminc4=imedfaminc3/(1+imedfaminc2)
replace imedfaminc=imedfaminc4 if missing(imedfaminc)
* 1948 medfaminc *
drop imedfaminc2 imedfaminc3 imedfaminc4
gen imedfaminc2=(imedfaminc[_n+2]-imedfaminc[_n+1])/imedfaminc[_n+1]
gen imedfaminc3=imedfaminc[_n+1]
gen imedfaminc4=imedfaminc3/(1+imedfaminc2)
replace imedfaminc=imedfaminc4 if missing(imedfaminc)
drop imedfaminc2 imedfaminc3 imedfaminc4

/* fix median poplt5 values */
rename ipoplt5 poplt5
replace poplt5=. if year>1950 & year<1960
replace poplt5=. if year<1950
replace poplt5=. if year>1960 & year<1970

replace poplt5=181 if fcounty=="53055" & year==1950
replace poplt5=409 if fcounty=="49029" & year==1950
replace poplt5=50 if fcounty=="32011" & year==1950
replace poplt5=436 if fcounty=="30051" & year==1950
replace poplt5=1351 if fcounty=="22125" & year==1950
replace poplt5=960 if fcounty=="22023" & year==1950
replace poplt5=834 if fcounty=="21197" & year==1950
replace poplt5=1238 if fcounty=="21175" & year==1950
replace poplt5=365 if fcounty=="20203" & year==1950
replace poplt5=310 if fcounty=="20187" & year==1950
replace poplt5=430 if fcounty=="17155" & year==1950
replace poplt5=325 if fcounty=="17151" & year==1950
replace poplt5=504 if fcounty=="16061" & year==1950
replace poplt5=137 if fcounty=="16033" & year==1950
replace poplt5=103 if fcounty=="8111" & year==1950
replace poplt5=262 if fcounty=="8097" & year==1950
replace poplt5=48 if fcounty=="8079" & year==1950
replace poplt5=64 if fcounty=="8047" & year==1950
replace poplt5=436 if fcounty=="30019" & year==1950
replace poplt5=360 if fcounty=="55078" & year==1950
replace poplt5=360 if fcounty=="55078" & year==1960
replace poplt5=1347 if fcounty=="18117" & year==1960
replace poplt5=610 if fcounty=="20201" & year==1960
replace poplt5=610 if fcounty=="20201" & year==1950


by fcounty: ipolate poplt5 year, gen (ipoplt5)
*1949 POPLT5 *
gen ipoplt52=(ipoplt5[_n+2]-ipoplt5[_n+1])/ipoplt5[_n+1]
gen ipoplt53=ipoplt5[_n+1]
gen ipoplt54=ipoplt53/(1+ipoplt52)
replace ipoplt5=ipoplt54 if missing(ipoplt5)
* 1948 POPLT5 *
drop  ipoplt52 ipoplt53 ipoplt54
gen ipoplt52=(ipoplt5[_n+2]-ipoplt5[_n+1])/ipoplt5[_n+1]
gen ipoplt53=ipoplt5[_n+1]
gen ipoplt54=ipoplt53/(1+ipoplt52)
replace ipoplt5=ipoplt54 if missing(ipoplt5)
drop  ipoplt52 ipoplt53 ipoplt54



/* fix median pop65+ values */
rename ipop65 pop65
replace pop65=. if year>1950 & year<1960
replace pop65=. if year<1950

replace pop65=120 if fcounty=="55078" & year==1950
by fcounty: ipolate pop65 year, gen (ipop65)
*1949 pop65 *
gen ipop652=(ipop65[_n+2]-ipop65[_n+1])/ipop65[_n+1]
gen ipop653=ipop65[_n+1]
gen ipop654=ipop653/(1+ipop652)
replace ipop65=ipop654 if missing(ipop65)
* 1948 pop65 *
drop   ipop652 ipop653 ipop654
gen ipop652=(ipop65[_n+2]-ipop65[_n+1])/ipop65[_n+1]
gen ipop653=ipop65[_n+1]
gen ipop654=ipop653/(1+ipop652)
replace ipop65=ipop654 if missing(ipop65)
drop   ipop652 ipop653 ipop654


** get values fo 1947 data **
sort fcounty1 year
	gen ipop2=(ipop[_n+2]-ipop[_n+1])/ipop[_n+1]
	gen ipop3=ipop[_n+1]
	gen ipop4=ipop3/(1+ipop2)
	replace ipop=ipop4 if missing(ipop)
	drop ipop2 ipop3 ipop4

sort fcounty1 year
	gen inwpop2=(inwpop[_n+2]-inwpop[_n+1])/inwpop[_n+1]
	gen inwpop3=inwpop[_n+1]
	gen inwpop4=inwpop3/(1+inwpop2)
	replace inwpop=inwpop4 if missing(inwpop)
	drop inwpop2 inwpop3 inwpop4
sort fcounty1 year
	gen imedfaminc2=(imedfaminc[_n+2]-imedfaminc[_n+1])/imedfaminc[_n+1]
	gen imedfaminc3=imedfaminc[_n+1]
	gen imedfaminc4=imedfaminc3/(1+imedfaminc2)
	replace imedfaminc =imedfaminc4 if missing(imedfaminc)
	drop imedfaminc2 imedfaminc3 imedfaminc4
sort fcounty1 year
	gen infmd2=(infmd[_n+2]-infmd[_n+1])/infmd[_n+1]
	gen infmd3=infmd[_n+1]
	gen infmd4=infmd3/(1+infmd2)
	replace infmd=infmd4 if missing(infmd)
	drop infmd2 infmd3 infmd4
sort fcounty1 year
	gen ipop652=(ipop65[_n+2]-ipop65[_n+1])/ipop65[_n+1]
	gen ipop653=ipop65[_n+1]
	gen ipop654=ipop653/(1+ipop652)
	replace ipop65=ipop654 if missing(ipop65)
	drop ipop652 ipop653 ipop654
sort fcounty1 year
	gen ipoplt52=(ipoplt5[_n+2]-ipoplt5[_n+1])/ipoplt5[_n+1]
	gen ipoplt53=ipoplt5[_n+1]
	gen ipoplt54=ipoplt53/(1+ipoplt52)
	replace ipoplt5=ipoplt54 if missing(ipoplt5)
	drop ipoplt52 ipoplt53 ipoplt54
sort fcounty1 year
	gen inwpop_pct2=(inwpop_pct[_n+2]-inwpop_pct[_n+1])/inwpop_pct[_n+1]
	gen inwpop_pct3=inwpop_pct[_n+1]
	gen inwpop_pct4=inwpop_pct3/(1+inwpop_pct2)
	replace inwpop_pct=inwpop_pct4 if missing(inwpop_pct)
	drop inwpop_pct2 inwpop_pct3 inwpop_pct4
replace inwpop_pct=0 if missing(inwpop_pct)

drop if fcounty1=="15001"
drop if fcounty1=="15003"
drop if fcounty1=="15007"

drop if fcounty1=="15009"

replace firmsfp=0 if missing(firmsfp)
replace firmsnp=0 if missing(firmsnp)
replace firmspb=0 if missing(firmspb)


**************************************
* merge adjacent county funding data *
**************************************
drop _merge
destring fcounty1, replace
sort fcounty1 year
merge fcounty1 year using adjcounty_fund
drop if _merge==2
replace hbfund_adjcnty=0 if missing(hbfund_adjcnty)
replace hbfund_adj_firsttreat=0 if missing(hbfund_adj_firsttreat)


gen hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1 if year==1948
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/0.987551867 if year==1949
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1 if year==1950
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.078838174 if year==1951
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.099585062 if year==1952
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.107883817 if year==1953
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.116182573 if year==1954
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.112033195 if year==1955
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.128630705 if year==1956
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.165975104 if year==1957
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.199170124 if year==1958
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.20746888 if year==1959
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.228215768 if year==1960
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.2406639 if year==1961
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.253112033 if year==1962
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.269709544 if year==1963
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.286307054 if year==1964
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.307053942 if year==1965
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.34439834 if year==1966
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.385892116 if year==1967
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.443983402 if year==1968
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.522821577 if year==1969
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.609958506 if year==1970
replace hbfund_adjcnty_totinfladjust=hbfund_adjcnty/1.680497925 if year==1971
***********************************************************************************
***********************************************************************************

**fix inflation adjust median per capita income **
rename imedfaminc imedfaminc_noinfl
gen imedfaminc=imedfaminc_noinfl/0.23432668101 if year==1975
replace imedfaminc=imedfaminc_noinfl/0.21472686568 if year==1974
replace imedfaminc=imedfaminc_noinfl/0.19338484455 if year==1973
replace imedfaminc=imedfaminc_noinfl/0.1820605068 if year==1972
replace imedfaminc=imedfaminc_noinfl/0.17639833793566 if year==1971
replace imedfaminc=imedfaminc_noinfl/0.16899396325688 if year==1970
replace imedfaminc=imedfaminc_noinfl/0.159847382771327 if year==1969
replace imedfaminc=imedfaminc_noinfl/0.15157190518916 if year==1968
replace imedfaminc=imedfaminc_noinfl/0.145474184865458 if year==1967
replace imedfaminc=imedfaminc_noinfl/0.141118670348528 if year==1966
replace imedfaminc=imedfaminc_noinfl/0.137198707283291 if year==1965
replace imedfaminc=imedfaminc_noinfl/0.135020950024826 if year==1964
replace imedfaminc=imedfaminc_noinfl/0.133278744218054 if year==1963
replace imedfaminc=imedfaminc_noinfl/0.131536538411283 if year==1962
replace imedfaminc=imedfaminc_noinfl/0.130229884056204 if year==1961
replace imedfaminc=imedfaminc_noinfl/0.128923229701125 if year==1960
replace imedfaminc=imedfaminc_noinfl/0.12674547244266 if year==1959
replace imedfaminc=imedfaminc_noinfl/0.125874369539274 if year==1958
replace imedfaminc=imedfaminc_noinfl/0.12238995792573 if year==1957
replace imedfaminc=imedfaminc_noinfl/0.118469994860493 if year==1956
replace imedfaminc=imedfaminc_noinfl/0.116727789053721 if year==1955
replace imedfaminc=imedfaminc_noinfl/0.117163340505414 if year==1954
replace imedfaminc=imedfaminc_noinfl/0.116292237602028 if year==1953
replace imedfaminc=imedfaminc_noinfl/0.115421134698642 if year==1952
replace imedfaminc=imedfaminc_noinfl/0.113243377440177 if year==1951
replace imedfaminc=imedfaminc_noinfl/0.10496789985801 if year==1950
replace imedfaminc=imedfaminc_noinfl/0.103661245502931 if year==1949
replace imedfaminc=imedfaminc_noinfl/0.10496789985801 if year==1948

*************************************************************************************
*** DEAL WITH ADMISSION VARIABLE ***
replace admtotpb=0 if missing(admtotpb)
replace admtotnp=0 if missing(admtotnp)
replace admtotfp=0 if missing(admtotfp)

gen adm_nppub=admtotnp+admtotpb
gen admtot=admtotnp+admtotpb+admtotfp

replace adm_nppub=1 if adm_nppub==0
replace admtot=1 if admtot==0
replace admtotfp=1 if admtotfp==0

gen ladm_nppub=log(adm_nppub)
gen ladmtot=log(admtot)
gen ladmtotfp=log(admtotfp)

*************************************************************************************
duplicates list  fcounty year
sort fcounty year

duplicates drop fcounty year, force
drop if fcounty==32510 | fcounty==24510 | fcounty== 46131
drop if fcounty>51000 & fcounty<52000
drop if fcounty==20105 | fcounty==20133 | fcounty==56045 | fcounty==30113 | fcounty==36999 |fcounty==55078
xtset fcounty year

save data_working, replace






