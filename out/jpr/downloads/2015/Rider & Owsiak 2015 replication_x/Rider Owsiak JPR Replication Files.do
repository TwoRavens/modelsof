*********************************************************************************************
*     Replication Files for 																*
*        Rider, Toby J., and Andrew P. Owsiak												*
*        Border Settlement, Commitment Problems, and the Causes of Contiguous Rivalry		*
*        Journal of Peace Research															*
*																							*
*********************************************************************************************

*LOAD THE FOLLOWING DATA:
*Use "Rider Owsiak JPR Replication Files.dta"

keep if conttype==1

*Replicate Table 1
tab settlem if kgd06rivstart==1
tab settlem if kgd06rivend==1

tab settlem if kgd06erstart==1
tab settlem if kgd06erend==1

tab settlem if crt07start==1
tab settlem if crt07end==1


*Replicate Table 2
*Model 1
sort cdyad year
by cdyad:  generate duration=_n
stset duration, id(cdyad) failure(kgd06riv==1) exit(failure)

gen lntime =  ln(_t)
gen CW_t = civilwar*lntime
gen coldwar_t = coldwar_terminate*lntime
gen powerchange_t = powerdistchange*lntime

stcox settlem jtdem6 majinvolve atopally cincratio civilwar CW_t  independence worldwarshock coldwar_terminate coldwar_t powerdistchange powerchange_t, efron cluster(cdyad) nolog

*Model 2
drop duration _st _d _t _t0 lntime CW_t coldwar_t powerchange_t
sort cdyad year
by cdyad:  generate duration=_n
stset duration, id(cdyad) failure(kgd06er==1) exit(failure)

gen lntime =  ln(_t)
gen CW_t = civilwar*lntime
gen coldwar_t = coldwar_terminate*lntime
gen powerchange_t = powerdistchange*lntime


stcox settlem jtdem6 majinvolve atopally cincratio civilwar CW_t  independence worldwarshock coldwar_terminate coldwar_t powerdistchange powerchange_t, efron cluster(cdyad) nolog

*Model 3
drop duration _st _d _t _t0 lntime CW_t coldwar_t powerchange_t
sort cdyad year
by cdyad:  generate duration=_n
stset duration, id(cdyad) failure(crt07riv==1) exit(failure)

gen lntime =  ln(_t)
gen CW_t = civilwar*lntime
gen coldwar_t = coldwar_terminate*lntime
gen powerchange_t = powerdistchange*lntime


stcox settlem jtdem6 majinvolve atopally cincratio civilwar CW_t  independence worldwarshock coldwar_terminate coldwar_t powerdistchange powerchange_t, efron cluster(cdyad) nolog

drop duration _st _d _t _t0 lntime CW_t coldwar_t powerchange_t

*Variables used in first file
*settlem kgd06rivstart kgd06rivend kgd06erstart kgd06erend crt07start crt07end jtdem6 majinvolve atopally cincratio civilwar independence worldwarshock coldwar_terminate powerdistchange cdyad midonset firstmid trade kgdtodrop ertodrop crttodrop rvsdcrttodrop flag year ccode1 ccode2 


*Replicate Table 3
drop if conttype!=1
keep if year < 1996 & year > 1918
tab settlem strvalue if kgd06riv==0, chi2 gamma r
tab settlem ecovalue if kgd06riv==0, chi2 gamma r
tab settlem sal_power if kgd06riv==0, chi2 gamma r


*Replicate Table 4
*Model 4
sort cdyad year
by cdyad:  generate duration=_n
stset duration, id(cdyad) failure(kgd06riv==1) exit(failure)

gen lntime =  ln(_t)
gen CW_t = civilwar*lntime

stcox sal_power jtdem6 majinvolve atopally cincratio civilwar CW_t  independence worldwarshock, efron cluster(cdyad) nolog

*Model 5
drop duration _st _d _t _t0 lntime CW_t
sort cdyad year
by cdyad:  generate duration=_n
stset duration, id(cdyad) failure(kgd06er==1) exit(failure)

gen lntime =  ln(_t)
gen CW_t = civilwar*lntime

stcox sal_power jtdem6 majinvolve atopally cincratio civilwar CW_t  independence worldwarshock, efron cluster(cdyad) nolog

*Model 6
drop duration _st _d _t _t0 lntime CW_t
sort cdyad year
by cdyad:  generate duration=_n
stset duration, id(cdyad) failure(crt07riv==1) exit(failure)

gen lntime =  ln(_t)
gen CW_t = civilwar*lntime

stcox sal_power jtdem6 majinvolve atopally cincratio civilwar CW_t  independence worldwarshock, efron cluster(cdyad) nolog

drop duration _st _d _t _t0 lntime CW_t


*Variables used in second file
*settlem strvalue ecovalue sal_power year conttype kgd06riv cdyad jtdem6 majinvolve atopally cincratio civilwar independence worldwarshock kgd06rivstart kgd06erstart crt07start










