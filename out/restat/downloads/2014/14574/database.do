capture clear
capture log close
clear matrix
clear mata
set mem 200m
set matsize 3000
set maxvar 10000
set more off


* Indicate the path to the main file 
cd "F:\cle\Regulation des secteurs en amont\Bourlès et al. 2010\Nos publications\Restat\Programs and data"






************** Creation of a benchmark presentation in order to 'balance' the presentation of the database (usefull to manipulate it) ****************

tempfile cyl cylbase1 cylbase2 cylbase3

clear
input time
1970
1971
1972
1973
1974
1975
1976
1977
1978
1979
1980
1981
1982
1983
1984
1985
1986
1987
1988
1989
1990
1991
1992
1993
1994
1995
1996
1997
1998
1999
2000
2001
2002
2003
2004
2005
2006
2007
end
gen cou="AUS"
gen industry="15-16"
save "`cylbase1'", replace
save "`cylbase2'", replace
foreach z in AUT BEL CAN CHE CZE DEU DNK ESP FIN FRA GBR GRC HUN IRL ISL ITA JPN KOR LUX MEX NLD NOR NZL POL PRT SVK SWE USA {
use "`cylbase1'"
replace cou="`z'"
tempfile cylbase`z'
save "`cylbase`z''", replace
use "`cylbase2'"
append using "`cylbase`z''"
save "`cylbase2'", replace
}
save "`cylbase3'", replace
foreach x in 10 15 17 20 21 23 26 27 29 290 30 34 36 40 45 50 500 55 60 600 64 65 650 70 700 71 {
use "`cylbase2'"
replace industry="`x'"
tempfile cylbase`x'
save "`cylbase`x''", replace
use "`cylbase3'"
append using "`cylbase`x''"
save "`cylbase3'", replace
}

* As the composed codes were not accepted as databse name, we've changed it and now we come back to the true name

replace industry="10-41" if industry=="10"
replace industry="15-37" if industry=="15"
replace industry="17-19" if industry=="17"
replace industry="21-22" if industry=="21"
replace industry="23-25" if industry=="23"
replace industry="27-28" if industry=="27"
replace industry="29-33" if industry=="290"
replace industry="30-33" if industry=="30"
replace industry="34-35" if industry=="34"
replace industry="36-37" if industry=="36"
replace industry="40-41" if industry=="40"
replace industry="50-52" if industry=="50"
replace industry="50-74" if industry=="500"
replace industry="60-63" if industry=="60"
replace industry="60-64" if industry=="600"
replace industry="65-67" if industry=="65"
replace industry="65-74" if industry=="650"
replace industry="70-74" if industry=="700"
replace industry="71-74" if industry=="71"


sort cou industry time
compress
save "`cyl'", replace









*********************************************************************** BUILDING OF THE CAPITAL STOCKS DATABASE **********************************************************************



tempfile pdbi euklems k_old


********** The capital stock is from the PDBi database ******

clear
insheet using "sources\2_PDBi_05June09.txt", names case delimiter(";")
rename year time
keep if var=="K3"
drop sou
reshape wide value, i(cou ind time) j(var) string
renpfix value ""

* Preparation to the merge

gen industry="TOTAL" if ind=="CTOTAL"
replace industry="01" if ind=="C01"
replace industry="01-02" if ind=="C01T02"
replace industry="01-05" if ind=="C01T05"
replace industry="02" if ind=="C02"
replace industry="05" if ind=="C05"
replace industry="10" if ind=="C10"
replace industry="10-12" if ind=="C10T12"
replace industry="10-14" if ind=="C10T14"
replace industry="10-41" if ind=="C10T41"
replace industry="10-74X" if ind=="C10T74X"
replace industry="11" if ind=="C11"
replace industry="12" if ind=="C12"
replace industry="13" if ind=="C13"
replace industry="13-14" if ind=="C13T14"
replace industry="14" if ind=="C14"
replace industry="15" if ind=="C15"
replace industry="15-16" if ind=="C15T16"
replace industry="15-37" if ind=="C15T37"
replace industry="16" if ind=="C16"
replace industry="17" if ind=="C17"
replace industry="17-18" if ind=="C17T18"
replace industry="17-19" if ind=="C17T19"
replace industry="18" if ind=="C18"
replace industry="19" if ind=="C19"
replace industry="20" if ind=="C20"
replace industry="20-36" if ind=="C20A36"
replace industry="21" if ind=="C21"
replace industry="21-22" if ind=="C21T22"
replace industry="22" if ind=="C22"
replace industry="23" if ind=="C23"
replace industry="23-25" if ind=="C23T25"
replace industry="24" if ind=="C24"
replace industry="2423" if ind=="C2423"
replace industry="24X" if ind=="C24X"
replace industry="25" if ind=="C25"
replace industry="26" if ind=="C26"
replace industry="27" if ind=="C27"
replace industry="271-31" if ind=="C271T31"
replace industry="272-32" if ind=="C272T32"
replace industry="27-28" if ind=="C27T28"
replace industry="27-35" if ind=="C27T35"
replace industry="28" if ind=="C28"
replace industry="29" if ind=="C29"
replace industry="29-33" if ind=="C29T33"
replace industry="30" if ind=="C30"
replace industry="30-33" if ind=="C30T33"
replace industry="31" if ind=="C31"
replace industry="313" if ind=="C313"
replace industry="31X" if ind=="C31X"
replace industry="32" if ind=="C32"
replace industry="321" if ind=="C321"
replace industry="322" if ind=="C322"
replace industry="323" if ind=="C323"
replace industry="33" if ind=="C33"
replace industry="3312" if ind=="C3312"
replace industry="3313" if ind=="C3313"
replace industry="33X" if ind=="C33X"
replace industry="34" if ind=="C34"
replace industry="34-35" if ind=="C34T35"
replace industry="35" if ind=="C35"
replace industry="351" if ind=="C351"
replace industry="352-9" if ind=="C352A9"
replace industry="353" if ind=="C353"
replace industry="36" if ind=="C36"
replace industry="36-37" if ind=="C36T37"
replace industry="37" if ind=="C37"
replace industry="40" if ind=="C40"
replace industry="40-41" if ind=="C40T41"
replace industry="41" if ind=="C41"
replace industry="45" if ind=="C45"
replace industry="50" if ind=="C50"
replace industry="50-52" if ind=="C50T52"
replace industry="50-55" if ind=="C50T55"
replace industry="50-64" if ind=="C50T64"
replace industry="50-74" if ind=="C50T74"
replace industry="50-74X" if ind=="C50T74X"
replace industry="50-99" if ind=="C50T99"
replace industry="51" if ind=="C51"
replace industry="515" if ind=="C515"
replace industry="51X" if ind=="C51X"
replace industry="52" if ind=="C52"
replace industry="55" if ind=="C55"
replace industry="60" if ind=="C60"
replace industry="60-63" if ind=="C60T63"
replace industry="60-64" if ind=="C60T64"
replace industry="61" if ind=="C61"
replace industry="62" if ind=="C62"
replace industry="63" if ind=="C63"
replace industry="64" if ind=="C64"
replace industry="641" if ind=="C641"
replace industry="642" if ind=="C642"
replace industry="65" if ind=="C65"
replace industry="65-67" if ind=="C65T67"
replace industry="65-74" if ind=="C65T74"
replace industry="66" if ind=="C66"
replace industry="67" if ind=="C67"
replace industry="70" if ind=="C70"
replace industry="70-74" if ind=="C70T74"
replace industry="71" if ind=="C71"
replace industry="71-74" if ind=="C71T74"
replace industry="72" if ind=="C72"
replace industry="73" if ind=="C73"
replace industry="74" if ind=="C74"
replace industry="75" if ind=="C75"
replace industry="75-99" if ind=="C75T99"
replace industry="80" if ind=="C80"
replace industry="85" if ind=="C85"
replace industry="90" if ind=="C90"
replace industry="90-93" if ind=="C90T93"
replace industry="91" if ind=="C91"
replace industry="92" if ind=="C92"
replace industry="93" if ind=="C93"
replace industry="95" if ind=="C95"
drop ind
keep cou industry time K3
sort cou industry time
compress
save "`pdbi'", replace





************ To complete the capital stock series we use the EU KLEMS database and a previous databse on capital stock **********



***** EU KLEMS ********


use sources\baseuklems.dta
keep cou code time i_it i_ct i_soft i_traeq i_omach i_ocon ip_it ip_ct ip_soft ip_traeq ip_omach ip_ocon emp
* emp is used to complete employment data in the TFP gap calculations when doing the simulation
rename emp emp_euklems

* We need prices equal to one in 2000
sort cou code time
by cou code : replace ip_it=ip_it/ip_it[31]
by cou code : replace ip_soft=ip_soft/ip_soft[31]
by cou code : replace ip_ct=ip_ct/ip_ct[31]
by cou code : replace ip_traeq=ip_traeq/ip_traeq[31]
by cou code : replace ip_omach=ip_omach/ip_omach[31]
by cou code : replace ip_ocon=ip_ocon/ip_ocon[31]

* Calculation of volumes
gen i_it_q=i_it/ip_it
gen i_soft_q=i_soft/ip_soft
gen i_ct_q=i_ct/ip_ct
gen i_traeq_q=i_traeq/ip_traeq
gen i_omach_q=i_omach/ip_omach
gen i_ocon_q=i_ocon/ip_ocon

* Agreggate investment
gen i_euklems=i_it_q+i_soft_q+i_ct_q+i_traeq_q+i_omach_q+i_ocon_q

* Preparation for the merge
gen industry="15-16" if code=="15t16"
replace industry="17-19" if code=="17t19"
replace industry="20" if code=="20"
replace industry="21-22" if code=="21t22"
replace industry="23-25" if code=="23t25"
replace industry="26" if code=="26"
replace industry="27-28" if code=="27t28"
replace industry="29" if code=="29"
replace industry="30-33" if code=="30t33"
replace industry="34-35" if code=="34t35"
replace industry="36-37" if code=="36t37"
replace industry="40-41" if code=="E"
replace industry="45" if code=="F"
replace industry="50-52" if code=="G"
replace industry="55" if code=="H"
replace industry="60-63" if code=="60t63"
replace industry="64" if code=="64"
replace industry="65-67" if code=="65t67"
replace industry="70" if code=="70"
replace industry="71-74" if code=="71t74"
replace industry="15-37" if code=="D"
drop if industry==""
replace cou="AUS" if cou=="aus"
replace cou="AUT" if cou=="aut"
replace cou="BEL" if cou=="bel"
replace cou="CZE" if cou=="cze"
replace cou="DNK" if cou=="dnk"
replace cou="FIN" if cou=="fin"
replace cou="FRA" if cou=="fra"
replace cou="DEU" if cou=="ger"
replace cou="GRC" if cou=="grc"
replace cou="HUN" if cou=="hun"
replace cou="IRL" if cou=="irl"
replace cou="ITA" if cou=="ita"
replace cou="JPN" if cou=="jpn"
replace cou="KOR" if cou=="kor"
replace cou="LUX" if cou=="lux"
replace cou="NLD" if cou=="nld"
replace cou="POL" if cou=="pol"
replace cou="PRT" if cou=="prt"
replace cou="SVK" if cou=="svk"
replace cou="ESP" if cou=="esp"
replace cou="SWE" if cou=="swe"
replace cou="GBR" if cou=="uk"
replace cou="USA" if cou=="usa-naics"

keep cou industry time i_euklems emp_euklems
compress
sort cou industry time
save "`euklems'", replace



***** Previous OECD capital stock series *********

use sources\PDBi_data_for_ECO.dta
rename year time
drop lbind
keep if var=="K3"
reshape wide value, i(cou ind time) j(var) string
rename valueK3 K_old

* Preparation to the merge

gen industry="TOTAL" if ind=="CTOTAL"
replace industry="01" if ind=="C01"
replace industry="01-02" if ind=="C01T02"
replace industry="01-05" if ind=="C01T05"
replace industry="02" if ind=="C02"
replace industry="05" if ind=="C05"
replace industry="10" if ind=="C10"
replace industry="10-12" if ind=="C10T12"
replace industry="10-14" if ind=="C10T14"
replace industry="10-41" if ind=="C10T41"
replace industry="10-74X" if ind=="C10T74X"
replace industry="11" if ind=="C11"
replace industry="12" if ind=="C12"
replace industry="13" if ind=="C13"
replace industry="13-14" if ind=="C13T14"
replace industry="14" if ind=="C14"
replace industry="15" if ind=="C15"
replace industry="15-16" if ind=="C15T16"
replace industry="15-37" if ind=="C15T37"
replace industry="16" if ind=="C16"
replace industry="17" if ind=="C17"
replace industry="17-18" if ind=="C17T18"
replace industry="17-19" if ind=="C17T19"
replace industry="18" if ind=="C18"
replace industry="19" if ind=="C19"
replace industry="20" if ind=="C20"
replace industry="20-36" if ind=="C20A36"
replace industry="21" if ind=="C21"
replace industry="21-22" if ind=="C21T22"
replace industry="22" if ind=="C22"
replace industry="23" if ind=="C23"
replace industry="23-25" if ind=="C23T25"
replace industry="24" if ind=="C24"
replace industry="2423" if ind=="C2423"
replace industry="24X" if ind=="C24X"
replace industry="25" if ind=="C25"
replace industry="26" if ind=="C26"
replace industry="27" if ind=="C27"
replace industry="271-31" if ind=="C271T31"
replace industry="272-32" if ind=="C272T32"
replace industry="27-28" if ind=="C27T28"
replace industry="27-35" if ind=="C27T35"
replace industry="28" if ind=="C28"
replace industry="29" if ind=="C29"
replace industry="29-33" if ind=="C29T33"
replace industry="30" if ind=="C30"
replace industry="30-33" if ind=="C30T33"
replace industry="31" if ind=="C31"
replace industry="313" if ind=="C313"
replace industry="31X" if ind=="C31X"
replace industry="32" if ind=="C32"
replace industry="321" if ind=="C321"
replace industry="322" if ind=="C322"
replace industry="323" if ind=="C323"
replace industry="33" if ind=="C33"
replace industry="3312" if ind=="C3312"
replace industry="3313" if ind=="C3313"
replace industry="33X" if ind=="C33X"
replace industry="34" if ind=="C34"
replace industry="34-35" if ind=="C34T35"
replace industry="35" if ind=="C35"
replace industry="351" if ind=="C351"
replace industry="352-9" if ind=="C352A9"
replace industry="353" if ind=="C353"
replace industry="36" if ind=="C36"
replace industry="36-37" if ind=="C36T37"
replace industry="37" if ind=="C37"
replace industry="40" if ind=="C40"
replace industry="40-41" if ind=="C40T41"
replace industry="41" if ind=="C41"
replace industry="45" if ind=="C45"
replace industry="50" if ind=="C50"
replace industry="50-52" if ind=="C50T52"
replace industry="50-55" if ind=="C50T55"
replace industry="50-64" if ind=="C50T64"
replace industry="50-74" if ind=="C50T74"
replace industry="50-74X" if ind=="C50T74X"
replace industry="50-99" if ind=="C50T99"
replace industry="51" if ind=="C51"
replace industry="515" if ind=="C515"
replace industry="51X" if ind=="C51X"
replace industry="52" if ind=="C52"
replace industry="55" if ind=="C55"
replace industry="60" if ind=="C60"
replace industry="60-63" if ind=="C60T63"
replace industry="60-64" if ind=="C60T64"
replace industry="61" if ind=="C61"
replace industry="62" if ind=="C62"
replace industry="63" if ind=="C63"
replace industry="64" if ind=="C64"
replace industry="641" if ind=="C641"
replace industry="642" if ind=="C642"
replace industry="65" if ind=="C65"
replace industry="65-67" if ind=="C65T67"
replace industry="65-74" if ind=="C65T74"
replace industry="66" if ind=="C66"
replace industry="67" if ind=="C67"
replace industry="70" if ind=="C70"
replace industry="70-74" if ind=="C70T74"
replace industry="71" if ind=="C71"
replace industry="71-74" if ind=="C71T74"
replace industry="72" if ind=="C72"
replace industry="73" if ind=="C73"
replace industry="74" if ind=="C74"
replace industry="75" if ind=="C75"
replace industry="75-99" if ind=="C75T99"
replace industry="80" if ind=="C80"
replace industry="85" if ind=="C85"
replace industry="90" if ind=="C90"
replace industry="90-93" if ind=="C90T93"
replace industry="91" if ind=="C91"
replace industry="92" if ind=="C92"
replace industry="93" if ind=="C93"
replace industry="95" if ind=="C95"
keep cou industry time K_old
compress
sort cou industry time
save "`k_old'", replace



**************** Merge of the capital stock databases and completion of the pdbi capital stock series *****************

use "`pdbi'"
joinby (cou industry time) using "`cyl'", unmatch(using)
drop _merge
joinby(cou industry time) using "`k_old'", unmatch(master)
drop _merge
joinby(cou industry time) using "`euklems'", unmatch(master)
drop _merge



* Dummies

gen str2 indu=industry
gen indn=real(indu)
drop indu
replace indn=99 if industry=="50-74"
replace indn=00 if industry=="15-37"

egen id=group(cou)
gen ctyind=id*100+indn
gen idtime=id*10000+time
gen indtime=indn*10000+time




****** Completion ********


egen sect=group(industry)
gen idsect=id*1000+sect
tsset idsect time
gen i_euklems_m=(i_euklems+l.i_euklems+l2.i_euklems+l3.i_euklems+l4.i_euklems+l5.i_euklems+l6.i_euklems+l7.i_euklems+l8.i_euklems+l9.i_euklems)/10
replace i_euklems_m=l.i_euklems_m*(l.i_euklems_m/l2.i_euklems_m) if time==2006

* I assume the key constant overtime for Irland (because of lack of data avaibility)
sort cou industry time 
by cou industry : gen i_euklems_m2=i_euklems_m[35]
replace i_euklems_m=i_euklems_m2 if cou=="IRL"


*** For previous OECD capital series

sort cou time industry
by cou time : gen K_old2933=K_old[11]
by cou time : gen K_old6064=K_old[21]
by cou time : gen K_old6574=K_old[24]
by cou time : gen K_old7074=K_old[26]

* Special case
replace K_old=K_old6574-K_old7074 if cou=="FIN" & industry=="65-67"


* I use EU KLEMS data as a key

sort cou time industry
by cou time : gen i_euklems_m29=i_euklems_m[10]
by cou time : gen i_euklems_m3033=i_euklems_m[12]
by cou time : gen i_euklems_m6063=i_euklems_m[20]
by cou time : gen i_euklems_m64=i_euklems_m[22]
by cou time : gen i_euklems_m70=i_euklems_m[25]
by cou time : gen i_euklems_m7174=i_euklems_m[27]
sort cou industry time
replace K_old=K_old2933*i_euklems_m29/(i_euklems_m29+i_euklems_m3033) if industry=="29" & cou=="FRA"
replace K_old=K_old2933*i_euklems_m3033/(i_euklems_m29+i_euklems_m3033) if industry=="30-33" & cou=="FRA"
replace K_old=K_old6064*i_euklems_m6063/(i_euklems_m6063+i_euklems_m64) if industry=="60-63" & (cou=="ESP" | cou=="GRC" | cou=="IRL" | cou=="ITA" | cou=="KOR")
replace K_old=K_old6064*i_euklems_m64/(i_euklems_m6063+i_euklems_m64) if industry=="64" & (cou=="ESP" | cou=="GRC" | cou=="IRL" | cou=="ITA" | cou=="KOR")
replace K_old=K_old7074*i_euklems_m70/(i_euklems_m70+i_euklems_m7174) if industry=="70" & (cou=="ESP" | cou=="FRA" |c ou=="GRC" | cou=="IRL" | cou=="ITA" | cou=="KOR")
replace K_old=K_old7074*i_euklems_m7174/(i_euklems_m70+i_euklems_m7174) if industry=="71-74" & (cou=="ESP" | cou=="FRA" |c ou=="GRC" | cou=="IRL" | cou=="ITA" | cou=="KOR")


** For pdbi capital stock series

sort cou time industry
by cou time : gen K32933=K3[11]
by cou time : gen K36064=K3[21]
sort cou industry time
replace K3=K32933*i_euklems_m29/(i_euklems_m29+i_euklems_m3033) if industry=="29" & cou=="FRA"
replace K3=K32933*i_euklems_m3033/(i_euklems_m29+i_euklems_m3033) if industry=="30-33" & cou=="FRA"
replace K3=K36064*i_euklems_m6063/(i_euklems_m6063+i_euklems_m64) if industry=="60-63" & (cou=="ESP" | cou=="GRC" | cou=="IRL" | cou=="ITA" | cou=="KOR")
replace K3=K36064*i_euklems_m64/(i_euklems_m6063+i_euklems_m64) if industry=="64" & (cou=="ESP" | cou=="GRC" | cou=="IRL" | cou=="ITA" | cou=="KOR")




*** Finally :

gen K=K3
replace K=K_old if K==.


keep cou industry time K emp_euklems
sort cou industry time
compress
tempfile capital 
save "`capital'", replace






******************************************************************************* PURCHASING POWER PARITIES *******************************************************************************



tempfile ppp_gdp ppp_gfcf ppa


****** PPP index of the GDP *******

clear
insheet using sources\ppp_gdp_1997.txt, names

* Preparation to the merge
replace cou="GBR" if cou=="UK"
replace cou="POL" if cou=="PLD"
rename country cou

* Changes for germany
sort cou
replace ppp_gdp=ppp_gdp/ppp_gdp[7]

save "`ppp_gdp'", replace


******* PPP index of the investment ******


use sources\ppp_gfcf.dta

* Preparation to the merge
rename _2005 ppp_gfcf
gen time=2005
rename cty cou
replace cou="AUS" if cou=="aus"
replace cou="AUT" if cou=="aut"
replace cou="BEL" if cou=="bel"
replace cou="CAN" if cou=="can"
replace cou="CZE" if cou=="cze"
replace cou="DNK" if cou=="dnk"
replace cou="FIN" if cou=="fin"
replace cou="FRA" if cou=="fra"
replace cou="DEU" if cou=="deu"
replace cou="GRC" if cou=="grc"
replace cou="HUN" if cou=="hun"
replace cou="IRL" if cou=="irl"
replace cou="ISL" if cou=="isl"
replace cou="ITA" if cou=="ita"
replace cou="JPN" if cou=="jpn"
replace cou="KOR" if cou=="kor"
replace cou="LUX" if cou=="lux"
replace cou="MEX" if cou=="mex"
replace cou="NLD" if cou=="nld"
replace cou="NZL" if cou=="nzl"
replace cou="NOR" if cou=="nor"
replace cou="POL" if cou=="pol"
replace cou="PRT" if cou=="prt"
replace cou="SVK" if cou=="svk"
replace cou="ESP" if cou=="esp"
replace cou="SWE" if cou=="swe"
replace cou="CHE" if cou=="che"
replace cou="TUR" if cou=="tur"
replace cou="GBR" if cou=="gbr"
replace cou="USA" if cou=="usa"
sort cou
save "`ppp_gfcf'", replace



***** Alternative PPP: PPPs at the industry level (for the sensibility analysis) ******


use sources\ppa.dta
sort cou industry
save "`ppa'", replace





****************************************************************************** BUILDING THE STAN DATABASE  **********************************************************************************


* Preparing the different sheets

tempfile valu valk empn labr gfcf gfck

foreach var in valu valk empn labr gfcf gfck {
use "sources\stan\stan_aus_`var'.dta"
gen cou="AUS"
drop if isic_rev_3==""
sort cou isic_rev_3 
renpfix _ `var'
save "``var''", replace
foreach zz in AUT BEL CAN CHE CZE DEU DNK ESP FIN FRA GBR GRC HUN IRL ISL ITA JPN KOR LUX MEX NLD NOR NZL POL PRT SVK SWE USA {
use "sources\stan\stan_`zz'_`var'.dta"
gen cou="`zz'"
drop if isic_rev_3==""
renpfix _ `var'
sort cou isic_rev_3 
append using "``var''"
sort cou isic_rev_3
save "``var''", replace
}
}

* Merge of the sheets

use "`valu'"
joinby(cou isic_rev_3) using "`valk'", unmatch(master)
drop _merge
joinby(cou isic_rev_3) using "`labr'", unmatch(master)
drop _merge
joinby(cou isic_rev_3) using "`empn'", unmatch(master)
drop _merge
joinby(cou isic_rev_3) using "`gfcf'", unmatch(master)
drop _merge
joinby(cou isic_rev_3) using "`gfck'", unmatch(master)
drop _merge
rename isic_rev_3 industry
drop desc
reshape long valu valk empn labr gfcf gfck , i(cou industry) j(time)



* Sometimes the unity differs between countries, we change that

replace valu=valu*1000 if cou=="JPN" | cou=="KOR"
replace valk=valk*1000 if cou=="JPN" | cou=="KOR" 
replace labr=labr*1000 if cou=="JPN" | cou=="KOR"
replace empn=empn/10 if cou=="AUS" | cou=="AUT" | cou=="BEL" | cou=="CHE" | cou=="CZE" | cou=="DNK" | cou=="FIN" | /*
*/cou=="GRC" | cou=="HUN" | cou=="IRL" | cou=="ISL" | cou=="LUX" | cou=="NLD" | cou=="NOR" | cou=="NZL" | cou=="PRT" | cou=="SVK" | cou=="SWE"
replace empn=empn/1000 if cou=="MEX"


* Other issues (changes because of data problems)

gen exclu=1 if (time==1995 | time==1996) & (industry=="30-33" | industry=="64" | industry=="65-67" | industry=="70" | industry=="71-74") & cou=="SVK"
replace exclu=1 if (time==1995 | time==1996) & industry=="71-74" & cou=="SVK"
replace exclu=1 if cou=="SVK" & (industry=="15-16" | industry=="40-41")
replace exclu=1 if (time==1995 | time==1996) & industry=="70" & cou=="CZE"
replace exclu=1 if cou=="SWE" & industry=="30-33" 
replace exclu=1 if cou=="PRT" & industry=="34-35" & (time==1995 | time==1996 | time==1997)
replace exclu=1 if cou=="FIN" & industry=="40-41"

replace valk=. if exclu==1
replace valu=. if exclu==1
replace labr=. if exclu==1
drop exclu

replace labr=. if (cou=="AUS" & industry=="70") | (cou=="SWE" & industry=="36-37")






**************************************************************************** PRODUCTIVITY CALCULATION **********************************************************************************


********* Merge ***********

sort cou industry time
joinby (cou industry time) using "`cyl'", unmatch(using)
drop _merge
joinby(cou industry time) using "`capital'", unmatch(master)
drop _merge
joinby (cou) using "`ppp_gfcf'", unmatch(master)
drop _merge
joinby (cou) using "`ppp_gdp'", unmatch(master)
drop _merge
joinby (cou industry) using "`ppa'", unmatch(master)
drop _merge


* Dummies

gen str2 indu=industry
gen indn=real(indu)
drop indu
egen id=group(cou)
gen ctyind=id*100+indn
gen idtime=id*10000+time
gen indtime=indn*10000+time

* Some countries barely informed are dropped

drop if cou=="LUX" | cou=="IRL" | cou=="MEX" | cou=="NZL" 


* Treatment of the US price in the industry 30-33 :

gen vap=valu/valk
sort idtime indn
by idtime : gen vap0=vap[1]
replace vap=vap0 if industry=="30-33" & cou=="USA"
replace valk=valu/vap if industry=="30-33" & cou=="USA"
* Alternative specification for the sensibility analysis
*sort industry time cou
*by industry time : gen vap_us=vap[25]
*replace vap=vap_us if industry=="30-33"
*drop vap_us


* We drop the industry out of our estimation sample

drop if industry=="29-33" | industry=="10-41" | industry=="60-64" | industry=="65-74" | industry=="70-74" | industry=="15-37" | industry=="50-74"


* Alternative for the sensibility analysis
*replace ppp_gdp=ppa


* 2000 is the reference year, but the PPP index is equal to 1 in 1997 for GDP and in 2005 for investment, so we change it

gen gfcfp=gfcf/gfck
sort industry time cou
by industry time : gen vap_us=vap[25]
by industry time : gen gfcfp_us=gfcfp[25]
sort cou industry time
by cou industry : gen ppp_gdp2=ppp_gdp*vap_us[27]/vap[27]
by cou industry : gen ppp_gfcf2=ppp_gfcf*gfcfp_us[35]/gfcfp[35]
replace ppp_gdp=ppp_gdp2
replace ppp_gfcf=ppp_gfcf2


* Calculation of data in PPP

gen valk_ppp=valk/ppp_gdp
gen K_ppp=K/ppp_gfcf
replace valk=valk_ppp
replace K=K_ppp


* When doing the simulation :
*replace empn=emp_euklems if empn==.


* Labor productivity

gen LP=valk/empn
gen k=K/empn


tsset ctyind time


* Various calculations of the labor share

gen lshare=labr/valu if time>1984
tsset ctyind time
gen lshare1=(lshare+l.lshare)/2
replace lshare1=lshare if lshare1==.
egen lshare2=mean(lshare) if time>1984, by(ctyind)
egen lshare3=mean(lshare2) if time>1984, by(indn)
egen lshare4=mean(lshare1) if time>1984, by(indtime)
replace lshare1=1 if lshare1>1 & lshare1!=.
replace lshare2=1 if lshare2>1 & lshare2!=.
sort indn time id
by indn time : gen lshare_us=lshare1[25]
by indn time : gen lshare_us2=lshare2[25]
tsset ctyind time


* MFP calculation

egen valk_m=mean(valk) if valk!=. & empn!=. & K!=. & lshare!=., by(indn)
egen empn_m=mean(empn) if valk!=. & empn!=. & K!=. & lshare!=., by(indn)
egen K_m=mean(K) if valk!=. & empn!=. & K!=. & lshare!=., by(indn)

gen ltfp1=ln(valk)-ln(valk_m)-lshare1*(ln(empn)-ln(empn_m))-(1-lshare1)*(ln(K)-ln(K_m))
gen ltfp2=ln(valk)-ln(valk_m)-lshare2*(ln(empn)-ln(empn_m))-(1-lshare2)*(ln(K)-ln(K_m))
gen ltfp3=ln(valk)-lshare3*ln(empn)-(1-lshare3)*ln(K)
gen ltfp4=ln(valk)-lshare4*ln(empn)-(1-lshare4)*ln(K)
gen ltfpus=ln(valk)-lshare_us*ln(empn)-(1-lshare_us)*ln(K)
gen ltfpus2=ln(valk)-lshare_us2*ln(empn)-(1-lshare_us2)*ln(K)

gen tfp1=exp(ltfp1)
gen tfp2=exp(ltfp2)
gen tfp3=exp(ltfp3)
gen tfp4=exp(ltfp4)
gen tfpus=exp(ltfpus)
gen tfpus2=exp(ltfpus2)





************************************************************ TECHNOLOGICAL FRONTIER *********************************************************************


* In order to take into account of mistaken changes in the variable gap and 'leader MFP growth', when the leading country enter or exit
* of the sample because of data availability, we exclude from the sample the concerned country*sector (or sector*years when they are few)

gen exclutfp3=1 if (cou=="GRC" & industry=="15-16") | (cou=="GRC" & industry=="40-41") | (cou=="GRC" & industry=="45") /*
*/| (cou=="BEL" & industry=="60-63") | (cou=="BEL" & industry=="64") | (cou=="FIN" & industry=="27-28") | (cou=="SWE" & industry=="65-67") /*
*/| cou=="KOR" | (cou=="FIN" & industry=="30-33" & time>1997)
gen exclutfp1=1 if exclutfp3==1
gen exclutfp2=1 if exclutfp3==1
gen exclutfp4=1 if exclutfp3==1
gen exclutfpus=1 if exclutfp3==1
gen exclutfpus2=1 if exclutfp3==1

replace exclutfp1=1 if (industry=="15-16" & time>2005) | (industry=="23-25" & time==2007) | (industry=="29" & time>2005) | /*
*/(industry=="45" & time==2007) | (industry=="55" & time>2005)
replace exclutfp2=1 if (industry=="15-16" & time>2005) | (industry=="20" & time==2007) | (industry=="23-25" & time==2007) | /*
*/(industry=="45" & time==2007) | (industry=="55" & time>2005)
replace exclutfp3=1 if (industry=="15-16" & time==2007) | (industry=="23-25" & time==2007) | /*
*/(industry=="40-41" & time==2007) | (industry=="45" & time==2007) | (industry=="55" & time>2005) | (industry=="70" & time>2005)
replace exclutfp4=1 if (industry=="23-25" & time==2007) | (industry=="45" & time==2007) | /*
*/(industry=="55" & time>2005)
replace exclutfpus=1 if (industry=="23-25" & time==2007) | (industry=="55" & time>2005)
replace exclutfpus2=1 if (industry=="23-25" & time==2007) | (industry=="30-33" & time==2007) | (industry=="45" & time==2007) | (industry=="55" & time==2007)/*
*/ | (industry=="65-67" & time>2005)

gen excluLP=1 if (cou=="NLD" & industry=="26") | (cou=="ISL" & industry=="45") | (cou=="ITA" & industry=="60-63") | /*
*/(cou=="SWE" & industry=="65-67") | (cou=="ITA" & industry=="70") | (cou=="GRC" & industry=="70") | /*
*/(cou=="DEU" & industry=="71-74") | (cou=="BEL" & industry=="60-63") | (cou=="BEL" & industry=="70")

replace excluLP=1 if industry=="65-67" & time==2007



* Identification of the technological frontier

gen fronttfp1=.
gen countryfronttfp1=.
foreach x in 15-16 17-19 20 21-22 23-25 26 27-28 29 30-33 34-35 36-37 40-41 45 50-52 55 60-63 64 65-67 70 71-74 {
foreach z in 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 /*
*/1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 {
summarize tfp1 if industry=="`x'" *& time==`z' & exclutfp1!=1
replace fronttfp1=r(max) if industry=="`x'" & time==`z' & exclutfp1!=1
}
}
replace countryfronttfp1=1 if tfp1==fronttfp1 & tfp1!=.

gen fronttfp2=.
gen countryfronttfp2=.
foreach x in 15-16 17-19 20 21-22 23-25 26 27-28 29 30-33 34-35 36-37 40-41 45 50-52 55 60-63 64 65-67 70 71-74 {
foreach z in 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 /*
*/1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 {
summarize tfp2 if industry=="`x'" & time==`z' & exclutfp2!=1
replace fronttfp2=r(max) if industry=="`x'" & time==`z' & exclutfp2!=1
}
}
replace countryfronttfp2=1 if tfp2==fronttfp2 & tfp2!=.

gen fronttfp3=.
gen countryfronttfp3=.
foreach x in 15-16 17-19 20 21-22 23-25 26 27-28 29 30-33 34-35 36-37 40-41 45 50-52 55 60-63 64 65-67 70 71-74 {
foreach z in 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 /*
*/1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 {
summarize tfp3 if industry=="`x'" & time==`z' & exclutfp3!=1
replace fronttfp3=r(max) if industry=="`x'" & time==`z' & exclutfp3!=1
}
}
replace countryfronttfp3=1 if tfp3==fronttfp3 & tfp3!=.

gen fronttfp4=.
gen countryfronttfp4=.
foreach x in 15-16 17-19 20 21-22 23-25 26 27-28 29 30-33 34-35 36-37 40-41 45 50-52 55 60-63 64 65-67 70 71-74 {
foreach z in 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 /*
*/1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 {
summarize tfp4 if industry=="`x'" & time==`z'   & exclutfp4!=1
replace fronttfp4=r(max) if industry=="`x'" & time==`z' & exclutfp4!=1
}
}
replace countryfronttfp4=1 if tfp4==fronttfp4 & tfp4!=.

gen fronttfpus=.
gen countryfronttfpus=.
foreach x in 15-16 17-19 20 21-22 23-25 26 27-28 29 30-33 34-35 36-37 40-41 45 50-52 55 60-63 64 65-67 70 71-74 {
foreach z in 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 /*
*/1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 {
summarize tfpus if industry=="`x'" & time==`z' & exclutfpus!=1
replace fronttfpus=r(max) if industry=="`x'" & time==`z'  & exclutfpus!=1
}
}
replace countryfronttfpus=1 if tfpus==fronttfpus & tfpus!=.

gen fronttfpus2=.
gen countryfronttfpus2=.
foreach x in 15-16 17-19 20 21-22 23-25 26 27-28 29 30-33 34-35 36-37 40-41 45 50-52 55 60-63 64 65-67 70 71-74 {
foreach z in 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 /*
*/1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 {
summarize tfpus2 if industry=="`x'" & time==`z' & exclutfpus2!=1
replace fronttfpus2=r(max) if industry=="`x'" & time==`z' & exclutfpus2!=1
}
}
replace countryfronttfpus2=1 if tfpus2==fronttfpus2 & tfpus2!=.

gen frontLP=.
gen countryfrontLP=.
foreach x in 15-16 17-19 20 21-22 23-25 26 27-28 29 30-33 34-35 36-37 40-41 45 50-52 55 60-63 64 65-67 70 71-74 {
foreach z in 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 /*
*/1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 {
summarize LP if industry=="`x'" & time==`z' & excluLP!=1
replace frontLP=r(max) if industry=="`x'" & time==`z'  & excluLP!=1
}
}
replace countryfrontLP=1 if LP==frontLP & LP!=.


* Calculation of the productivity gap and 'Leader productivity growth' variables

gen gaptfp1=ln(fronttfp1)-ln(tfp1)
gen gaptfp2=ln(fronttfp2)-ln(tfp2)
gen gaptfp3=ln(fronttfp3)-ln(tfp3)
gen gaptfp4=ln(fronttfp4)-ln(tfp4)
gen gaptfpus=ln(fronttfpus)-ln(tfpus)
gen gaptfpus2=ln(fronttfpus2)-ln(tfpus2)
gen gapLP=ln(frontLP)-ln(LP)

*dfront
gen dfronttfp1=ln(fronttfp1)-ln(l.fronttfp1)
gen dfronttfp2=ln(fronttfp2)-ln(l.fronttfp2)
gen dfronttfp3=ln(fronttfp3)-ln(l.fronttfp3)
gen dfronttfp4=ln(fronttfp4)-ln(l.fronttfp4)
gen dfronttfpus=ln(fronttfpus)-ln(l.fronttfpus)
gen dfronttfpus2=ln(fronttfpus2)-ln(l.fronttfpus2)
gen dfrontLP=ln(frontLP)-ln(l.frontLP)




************************************************************** Merge with the regulation data ******************************************************


sort cou industry time
joinby (cou industry time) using sources\regulations.dta, unmatch(master)
drop _merge


keep cou industry time regimpact_us dom gbr fra direct tarif_dir FDI_dir /*
*/ tfp1 dfronttfp1 gaptfp1 countryfronttfp1 tfp2 dfronttfp2 gaptfp2 countryfronttfp2 tfp3 dfronttfp3 gaptfp3 countryfronttfp3 tfpus dfronttfpus gaptfpus countryfronttfpus tfpus2 dfronttfpus2 gaptfpus2 countryfronttfpus2 /*
*/ LP k dfrontLP gapLP countryfrontLP exclutfp3 excluLP



sort cou industry time
compress
save base, replace







exit



















