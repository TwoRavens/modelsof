

set more off


cd "..\RESTAT_WorkesBeneatTheFloodgates_Utar"


use "TCWorkers_1999_2010.dta", clear







**Industry Dummies** 
gen manu=0
replace manu=1 if pernace>=150000 & pernace<370000 & year<2008
replace manu=1 if pernace>=100000 & pernace<340000 & year>=2008

*service sector 
gen service=0
replace service=1 if pernace>=500000 & pernace<980000 & pernace~=. & year<2008 
replace service=1 if pernace>=450000 & pernace<980000 & pernace~=. & year>=2008  


destring joblength, replace //Full-time, Part-time jobs (jobkat)

gen D_FT=0 // full-time jobs , including unemployment breaks //
replace D_FT=1 if joblength==1 | joblength==5

gen D_PST=0 //part-time and side jobs //
replace D_PST=1 if joblength==2 | joblength==3 | joblength==6 | joblength==7

gen D_PT=0
replace D_PT=1 if joblength==2  | joblength==6 

gen D_CFT=0 //continous full-time
replace D_CFT=1 if joblength==1

gen D_Unknown=0
replace D_Unknown=1 if joblength==0 | joblength==9




*******Labor Market Positions*******


gen selfemp=0
replace selfemp=1 if pstill_i==12 | pstill_i==14 |  pstill_i==13 | pstill_i==19 

gen selfemp2=0  
replace selfemp2=1 if type=="S" 

gen emp=0
replace emp=1 if type=="S" | type=="A"  //this includes both self-employed but also those who have their own business and employ somebody//

gen unemp_e=0
replace unemp_e=1 if pstill_i==40  //unemployed in November  (entry to , partly covered by the union)

gen unemp=0
replace unemp=1 if pstill_i==40 | pstill_i==46 | pstill_i==47 | pstill_i==48 | pstill_i==51 | pstill_i==52 | pstill_i==55 | pstill_i==95 

gen unemp50=0
replace unemp50=1 if arledgr>=500 //if person spent at least half of the year unemployed //

gen unemp10=0
replace unemp10=1 if arledgr>=100 // if person spent at least 10 percent of the year unemployed //

gen pensioner=0
replace pensioner=1 if pstill_i==92  

gen earlyret=0
replace earlyret=1 if pstill_i==50  | pstill_i==93

gen retired=0
replace retired=1 if pstill_i==50 | pstill_i==92 | pstill_i==93 | pstill_i==94  // all retirees //

gen allpens=0
replace allpens=1 if pstill_i==50 | pstill_i==51 | pstill_i==52 | pstill_i==55 | pstill_i==92 | pstill_i==93 | pstill_i==94

gen ineduc=0
replace ineduc=1 if pstill_i==46 | pstill_i==91  | pstill_i==98 
gen outlab=0
replace outlab=1 if pstill_i==41 | pstill_i==42 | pstill_i==43 | pstill_i==45 | pstill_i==46 | pstill_i==47 | pstill_i==48 | pstill_i==49 | pstill_i==50 
replace outlab=1 if pstill_i==51 | pstill_i==52 | pstill_i==55 | pstill_i==56 | pstill_i==57 | pstill_i==90 | pstill_i==91 | pstill_i==92
replace outlab=1 if pstill_i==93 | pstill_i==94 | pstill_i==95 | pstill_i==96 | pstill_i==97 | pstill_i==98

*income-transfer

gen leave=0
replace leave=1 if pstill_i==41 | pstill_i==42 | pstill_i==43 | pstill_i==71 | pstill_i==72 | pstill_i==73 | pstill_i==74 | pstill_i==75 | pstill_i==76 | pstill_i==77





destring pnr, gen(pid)

destring cvrnr, gen(fid)
replace fid=0 if fid==.  //not working //


sort pnr year
egen spell=group(pid fid)


bysort pnr (year): gen pnyr=_n  
bysort pnr: gen pycount=_N  

tab pycount if pnyr==1 

bysort pnr (year) : gen lspell=spell[_n-1]  
replace lspell=. if pnyr==1

bysort pnr (year) : gen ltc=tc[_n-1]  
replace ltc=. if pnyr==1

gen cont=0
replace cont=1 if spell==lspell
replace cont=. if pnyr==1

gen switch=0
replace switch=1 if spell~=lspell
replace switch=. if pnyr==1

bysort pnr (year): gen sswitch=sum(switch)
bysort pnr: egen sumswitch=sum(switch)


bysort pnr (year): gen fswitch=1 if switch==1 & sswitch==1
bysort pnr:  egen fswitch_yr=max(year*fswitch)

gen nz_sswitch=0
replace nz_sswitch=1 if sswitch~=0


gen aux=fid if year==1999
bysort pnr: egen fid99=max(aux)
drop aux
gen mis_fid=fid if fid~=0
bysort pnr (year): carryforward mis_fid, gen(last_firm)
gen lainifirm=0
replace lainifirm=1 if last_firm==fid99

bysort pnr (year): carryforward pernace, gen(last_nace)


sort pnr year
gen last_nace_year=year if pernace~=.

bysort pnr (year): carryforward last_nace_year, replace



*1996-1999 averages 
merge n:1 pnr using "normsal98.dta", keepusing(normpers9699 normtotwag9699 normHrs9699 normsal9699 normHrs9699)
tab _merge
keep if _merge==3
drop _merge


***Benefits**


sort pnr year
merge 1:1 pnr year using  "indk_unemptc.dta", keepusing(adagp arblhu)
tab _merge
drop if _merge==2
drop _merge


sort pnr year
merge 1:1 pnr year using  "indk_bentc.dta", keepusing(andakas adagpagn quddydl)
tab _merge
drop if _merge==2
drop _merge


*************Industry and Occupation Experience******************
sort pnr
merge n:1 pnr using "IndOcExp.dta", keepusing(disc2_exp disc1_exp tc_exp manu_exp)
tab _merge
drop if _merge==2
drop _merge

*disc2_exp: 2-digit oc experience (measured in years) since 1991"
*disc1_exp: 1-digit oc experience (measured in years) since 1991"
*tc_exp: industry (T&C) experience (measured in years) since 1985"
*manu_exp: manufacturing experience (measured in years) since 1985"

sort disc4 //disc4 defined in 1999//
merge n:1 disc4 using "OcIndSpec.dta", keepusing(manspec1 manspec2 manspec3 manspec4 tcspec1 tcspec2 tcspec3 tcspec4 tcsize allsize mansize)
tab _merge
drop if _merge==2
drop _merge

*occupations' industry specificity
*in 1999 how intensely each specific occupation was employed in an industry
*manspec4=total 4-digit (ISCO) occupations in manufacturing over total 4-digit occupations economy-wide
*tcspec4=total 4-digit (ISCO) occupations in T&C over total 4-digit occupations economy-wide

************************************************************
gen occupation=disc2_99
sort occupation
merge n:1 occupation using "RTIbyISCO2.dta" 
tab _merge
drop if _merge==2
drop _merge





gen runemp=0
replace runemp=100*arblhu/cpi  if arblhu~=. //unemployment insurance //
gen rsickmun=0
replace rsickmun=100*adagp/cpi  if adagp~=. //sick and maternity benefits paid by municipalities //
gen rsickemp=0
replace rsickemp=100*adagpagn/cpi if adagpagn~=.  //sick benefits paid by employer //
gen redupay=0  // education allowance for unemployed //
replace redupay=100*quddydl/cpi if quddydl~=.
gen rotben=0 //other benefits from UI (no UI, not training) //
replace rotben=100*andakas/cpi if andakas~=.
gen rsickben=rsickemp+rsickmun
gen runempben=0
replace runempben=runemp+redupay+rotben 





**1999 variables

*salary=joblon:labour earnings
gen aux=rsalary if year==1999
bysort pnr: egen rsalary99=max(aux)
drop aux
gen lnrsalary99=ln(rsalary99)

*totwag=slon
gen aux=rtotwag if year==1999
bysort pnr: egen rtotwag99=max(aux)
drop aux
gen lnrtotwag99=ln(rtotwag99)


gen aux=hrs if year==1999
bysort pnr: egen hrs99=max(aux)
drop aux
gen lnhrs99=ln(hrs99)


*timelon
gen aux=rhwage if year==1999
bysort pnr: egen rhwage99=max(aux)
drop aux
gen lnrhwage99=ln(rhwage99)

gen aux=rtotwag if year==1999
bysort pnr: egen rtotwage99=max(aux)
drop aux
gen lnrtotwage99=ln(rtotwage99)


g aux=sumgrad if year==1999
bysort pnr: egen unemp99=max(aux)
drop aux
g yunemp99=unemp99/1000

bysort pnr: egen union99=max(union) 

gen aux=0
replace aux=UImem if year==1999
bysort pnr: egen UImem99=max(aux)
drop aux

g aux=experience if year==1999
bysort pnr: egen experience99=max(aux)
drop aux

**2010 variables

g aux=pernace if year==2010
bysort pnr: egen pernace10=max(aux)
drop aux

g aux=unemp_e if year==2010
bysort pnr: egen unemp_e10=max(aux)
drop aux

g aux=outlab if year==2010
bysort pnr: egen outlab10=max(aux)
drop aux



********* Workplace Chars************

gen empneg5=0 if etrendyb~=. & year==1999
replace empneg5=1 if etrendyb==0 & year==1999 //number of employees decreasing more than 5 percent//
bysort pnr: egen ntrend99=max(empneg5)


gen emppos5=0 if etrendyb~=. & year==1999
replace emppos5=1 if etrendyb==2 & year==1999 //number of employees increasing  more than 5 percent//
bysort pnr: egen ptrend99=max(emppos5)


g aux=ravhrate if year==1999
bysort pnr: egen ravhrate99=max(aux)
g lnravhrate99=ln(ravhrate99)
drop aux

g aux=afgrate if year==1999
bysort pnr: egen seprate99=max(aux)
drop aux


global allcontrols "Fem Imm age99 OTA1 OTA2 OTA3  ET1 ET2 ET3 unemp99 lnhwage_ini union99 UImem99 experience99 seprate99 lnravhrate99"





**Time Dummies
gen Dum9901=0
replace Dum9901=1 if year==1999 | year==2000 | year==2001
gen Dum02=0
replace Dum02=1 if year>=2002
gen Dum0202=0
replace Dum0202=1 if year==2002 
gen Dum0203=0
replace Dum0203=1 if  year==2002 |  year==2003 
gen Dum0204=0
replace Dum0204=1 if  year==2002 |  year==2003 |  year==2004
gen Dum0205=0
replace Dum0205=1 if  year==2002 |  year==2003 |  year==2004 | year==2005
gen Dum0206=0
replace Dum0206=1 if  year==2002 |  year==2003 |  year==2004 | year==2005 | year==2006
gen Dum0207=0
replace Dum0207=1 if  year==2002 |  year==2003 |  year==2004 | year==2005 | year==2006 | year==2007
gen Dum0208=0
replace Dum0208=1 if  year==2002 |  year==2003 |  year==2004 | year==2005 | year==2006 | year==2007 | year==2008
gen Dum0209=0
replace Dum0209=1 if  year==2002 |  year==2003 |  year==2004 | year==2005 | year==2006 | year==2007 | year==2008 | year==2009
gen Dum0210=0
replace Dum0210=1 if year==2002 | year==2003 | year==2004 | year==2005 | year==2006 | year==2007 | year==2008 | year==2009 | year==2010




gen g_I=1-nz_sswitch
gen g_T=tc*nz_sswitch
gen g_M=(1-tc)*manu*nz_sswitch
gen g_S=(1-tc)*(1-manu)*service*nz_sswitch
gen g_R=(1-tc)*(1-manu)*(1-service)*nz_sswitch

gen g_WR=(1-tc)*(1-manu)*service*nz_sswitch*(sectno==7) // wholesale and retail//
gen g_HR=(1-tc)*(1-manu)*service*nz_sswitch*(sectno==8) //hotels and restaurants//
gen g_TSC=(1-tc)*(1-manu)*service*nz_sswitch*(sectno==9) //transport, storage, comm//
gen g_FI=(1-tc)*(1-manu)*service*nz_sswitch*(sectno==10) //financial intermediation//
gen g_RRB=(1-tc)*(1-manu)*service*nz_sswitch*(sectno==11) //real estate, renting, and business/
gen g_PD=(1-tc)*(1-manu)*service*nz_sswitch*(sectno==12) //public defense//
gen g_ED=(1-tc)*(1-manu)*service*nz_sswitch*(sectno==13) //education//
gen g_HSW=(1-tc)*(1-manu)*service*nz_sswitch*(sectno==14) //health and social work//
gen g_SPW=(1-tc)*(1-manu)*service*nz_sswitch*(sectno==15) //other community, social and personal services//
gen g_AH=(1-tc)*(1-manu)*service*nz_sswitch*(sectno==16) //activities of households//


gen g_MFood=(1-tc)*manu*nz_sswitch*MFood
gen g_MTC=MTC
gen g_MLS=(1-tc)*manu*nz_sswitch*MLS
gen g_MWoodPaper=(1-tc)*manu*nz_sswitch*MWoodPaper
gen g_MPublish=(1-tc)*manu*nz_sswitch*MPublish
gen g_MPetChem=(1-tc)*manu*nz_sswitch*MPetChem
gen g_MGlaMin=(1-tc)*manu*nz_sswitch*MGlaMin
gen g_MMetals=(1-tc)*manu*nz_sswitch*MMetals
gen g_MMachines=(1-tc)*manu*nz_sswitch*MMachines
gen g_MMeasuring=(1-tc)*manu*nz_sswitch*MMeasuring
gen g_MTransEq=(1-tc)*manu*nz_sswitch*MTransEq
gen g_MMisc=(1-tc)*manu*nz_sswitch*MMisc


*lm positions
gen lm_I=(1-nz_sswitch)
gen lm_M=manu*nz_sswitch*(1-outlab)*(1-selfemp)*(1-unemp_e)
gen lm_S=service*nz_sswitch*(1-outlab)*(1-selfemp)*(1-unemp_e)
gen lm_U=unemp_e*nz_sswitch*(1-outlab)*(1-selfemp)
gen lm_SL=nz_sswitch*selfemp*(1-outlab)
gen lm_O=outlab*nz_sswitch
gen lm_OER=outlab*nz_sswitch*earlyret
gen lm_OED=outlab*nz_sswitch*(1-earlyret)*ineduc
gen lm_ORest=outlab*nz_sswitch*(1-earlyret)*(1-ineduc)
gen lm_OP=outlab*nz_sswitch*allpens

**service sector job types: full-time, part-time and side jobs, unknown

gen g_SFT=(1-tc)*(1-manu)*service*nz_sswitch*(D_FT)
gen g_SPST=(1-tc)*(1-manu)*service*nz_sswitch*D_PST
gen g_SUK=(1-tc)*(1-manu)*service*nz_sswitch*D_Unknown

**Industry Dummies** 
gen lamanu=0
replace lamanu=1 if last_nace>=150000 & last_nace<370000 & last_nace_year<2008
replace lamanu=1 if last_nace>=100000 & last_nace<340000 & last_nace_year>=2008

*service 
gen laservice=0
replace laservice=1 if last_nace>=500000 & last_nace<980000 & last_nace~=. & last_nace_year<2008 
replace laservice=1 if last_nace>=450000 & last_nace<980000 & last_nace~=. & last_nace_year>=2008 

*sectors for unemployment decomp (last job)
gen latc=0
replace latc=1 if last_nace>=170000 & last_nace<190000 & last_nace_year<2008
replace latc=1 if last_nace>=130000 & last_nace<150000 & last_nace_year>=2008
 
gen last_ini=lainifirm
gen last_xT=latc*(1-lainifirm)
gen last_T=latc
gen last_M=(1-latc)*lamanu
gen last_S=(1-latc)*(1-lamanu)*laservice
gen last_R=(1-latc)*(1-lamanu)*(1-laservice)

**Preparation of Cumulative variables

gen normsal=normsal9699
gen normHrs=normHrs9699

gen normtwag=normtotwag9699
gen normperson=normpers9699

gen nzsal=0
replace nzsal=1 if rsalary>0 & rsalary~=.
gen nzhrs=0
replace nzhrs=1 if hrs>0 & hrs~=.


preserve

local xlist "9901 0210 0202 0203 0204 0205 0206 0207 0208 0209"
foreach x of local xlist {


bysort pnr: egen CInc=sum(rsalary*Dum`x')
replace CInc=CInc/normsal

bysort pnr: egen CHrs=sum(hrs*Dum`x') //number of total hours worked within a year for the primary occupation (all non-zero)
replace CHrs=CHrs/normHrs


bysort pnr: egen CEmp=sum(nzsal*Dum`x') //**The number of years with non-zero 'salary'//


bysort pnr: egen CUnEmp=sum(arledgr*Dum`x')
replace CUnEmp=CUnEmp/1000

bysort pnr: egen CUnEmpA=sum(arledgr*Dum`x')
replace CUnEmpA=(CUnEmpA*12)/1000


bysort pnr: egen CPerInc=sum(rpersonindk*Dum`x') //**Personal Income
replace CPerInc=CPerInc/normperson


bysort pnr: egen CPenInc=sum(rpensinc*Dum`x') //**Pension Income
replace CPenInc=CPenInc/normperson


bysort pnr: egen CSickBen=sum(rsickben*Dum`x') //**Sickness Benefit
replace CSickBen=CSickBen/normperson


bysort pnr: egen CUIBen=sum(runempben*Dum`x') //**UI Benefit
replace CUIBen=CUIBen/normperson

bysort pnr: egen CUI=sum(runemp*Dum`x')  //only UI
replace CUI=CUI/normperson

bysort pnr: egen CEduAll=sum(redupay*Dum`x') // **Education Allowance
replace CEduAll=CEduAll/normperson

bysort pnr: egen COtBen=sum(rotben*Dum`x') // **Other Benefits
replace COtBen=COtBen/normperson


*The number of years
bysort pnr: egen NY=sum(Dum`x')


**the number of years with non-sero hrs
bysort pnr: egen CNZHrs=sum(nzhrs*Dum`x') 


*number of years with positive UI
g pUI=0
replace pUI=1 if runemp>0 & runemp~=.
bysort pnr: egen CNUI=sum(pUI*Dum`x')


*number of years with positive sick benefit from munic
g psickmun=0
replace psickmun=1 if rsickmun>0 & rsickmun~=0
bysort pnr: egen CNSICKM=sum(psickmun*Dum`x')


*number of years with positive sick benefits from employer 
g psickemp=0
replace psickemp=1 if rsickemp>0 & rsickemp~=.
bysort pnr: egen CNSICKE=sum(psickemp*Dum`x')


*number of years with positive sick benefits from employer + munic
g psickben=0
replace psickben=1 if rsickben>0 & rsickben~=.
bysort pnr: egen CNSICKBEN=sum(psickben*Dum`x')


*number of years with positive education allowance
g peduall=0
replace peduall=1 if redupay>0 & redupay~=.
bysort pnr: egen CNEDU=sum(peduall*Dum`x')



*number of years with positive other unemp benefits
g potben=0
replace potben=1 if rotben>0 & rotben~=.
bysort pnr: egen CNOTBEN=sum(potben*Dum`x')



local ylist " I T M S R SFT SPST SUK SPU SPR"

foreach y of local ylist {

bysort pnr: egen CInc_`y'=sum(rsalary *Dum`x'*g_`y')
replace CInc_`y'=CInc_`y'/normsal

bysort pnr: egen CHrs_`y'=sum(hrs *Dum`x'*g_`y')
replace CHrs_`y'=CHrs_`y'/normHrs

bysort pnr: egen CEmp_`y'=sum(nzsal*Dum`x'*g_`y')



bysort pnr: egen CTWag_`y'=sum(rtotwag *Dum`x'*g_`y')
replace CTWag_`y'=CTWag_`y'/normtwag

bysort pnr: egen CPerInc_`y'=sum(rpersonindk*Dum`x'*g_`y')
replace CPerInc_`y'=CPerInc_`y'/normperson

}






local ylist " WR HR TSC FI RRB PD ED HSW SPW AH MFood MLS MWoodPaper MPublish MPetChem MGlaMin MMetals MMachines MMeasuring MTransEq MMisc"

foreach y of local ylist {

bysort pnr: egen CInc_`y'=sum(rsalary *Dum`x'*g_`y')
replace CInc_`y'=CInc_`y'/normsal

bysort pnr: egen CHrs_`y'=sum(hrs *Dum`x'*g_`y')
replace CHrs_`y'=CHrs_`y'/normHrs

bysort pnr: egen CEmp_`y'=sum(nzsal*Dum`x'*g_`y')

}



local ylist "ini xT T M S R"

foreach y of local ylist {

bysort pnr: egen CUnEmpA_l`y'=sum(arledgr*Dum`x'*last_`y')
replace CUnEmpA_l`y'=(CUnEmpA_l`y'*12)/1000

}


bysort pnr: egen aux=mean(lnrhwage)  if Dum`x'==1                            
bysort pnr: egen LHW=max(aux)
drop aux

bysort pnr: egen aux=mean(lnrhwage)  if Dum`x'*(1-nz_sswitch)==1            
bysort pnr: egen LHW_I=max(aux)
drop aux

bysort pnr: egen aux=mean(lnrhwage)  if Dum`x'*tc*nz_sswitch==1            
bysort pnr: egen LHW_T=max(aux)
drop aux

bysort pnr: egen aux=mean(lnrhwage)  if Dum`x'*(1-tc)*manu*nz_sswitch==1            
bysort pnr: egen LHW_M=max(aux)
drop aux

bysort pnr: egen aux=mean(lnrhwage)  if Dum`x'*(1-tc)*(1-manu)*service*nz_sswitch==1            
bysort pnr: egen LHW_S=max(aux)
drop aux

bysort pnr: egen aux=mean(lnrhwage)  if Dum`x'*(1-tc)*(1-manu)*(1-service)*nz_sswitch==1            
bysort pnr: egen LHW_R=max(aux)
drop aux



local ylist " I T M S R"
foreach y of local ylist {

bysort pnr: egen CNZHrs_`y'=sum(nzhrs*Dum`x'*g_`y') 

bysort pnr: egen CNEDU_`y'=sum(peduall*Dum`x'*g_`y')

bysort pnr: egen CNUI_`y'=sum(pUI*Dum`x'*g_`y')

bysort pnr: egen CNSICKBEN_`y'=sum(psickben*Dum`x'*g_`y')
}

local ylist " lm_I lm_M lm_S lm_SL lm_U lm_O lm_OED lm_OER lm_OP lm_ORest"
foreach y of local ylist {
bysort pnr: egen CNEDU_`y'=sum(peduall*Dum`x'*`y')
bysort pnr: egen NY_`y'=sum(Dum`x'*`y')
bysort pnr: egen CPerInc_`y'=sum(rpersonindk*Dum`x'*`y')
replace CPerInc_`y'=CPerInc_`y'/normperson
bysort pnr: egen CPenInc_`y'=sum(rpensinc*Dum`x'*`y')
replace CPenInc_`y'=CPenInc_`y'/normperson
bysort pnr: egen CSickBen_`y'=sum(rsickben*Dum`x'*`y')
replace CSickBen_`y'=CSickBen_`y'/normperson

bysort pnr: egen CUI_`y'=sum(runemp*Dum`x'*`y')  //only UI
replace CUI_`y'=CUI_`y'/normperson

bysort pnr: egen CUIBen_`y'=sum(runempben*Dum`x'*`y')  // UI+ edu allow+other benefits you receive from UI
replace CUIBen_`y'=CUIBen_`y'/normperson

bysort pnr: egen CEduAll_`y'=sum(redupay*Dum`x'*`y')
replace CEduAll_`y'=CEduAll_`y'/normperson

bysort pnr: egen COtBen_`y'=sum(rotben*Dum`x'*`y')
replace COtBen_`y'=COtBen_`y'/normperson
}



gen PYInc=CInc/CEmp  //per year earnings (in initial earnings)
gen PYHrs=CHrs/CNZHrs //total hours per year of employment in initial total hours


local ylist "I T M S R"
foreach y of local ylist {
gen PYInc_`y'=CInc_`y'/CEmp_`y'
gen PYHrs_`y'=CHrs_`y'/CNZHrs_`y'
}


*avgnrsal avgnrper avgnrtotwag
gen nrsal=rsalary 
gen nrper=rpersonindk

replace nrsal=0 if rtotwag~=. & rsalary==.
replace nrsal=0 if rpersonindk~=. & rsalary==.
replace nrper=0 if rpersonindk<0 & rpersonindk~=.

bysort pid: egen aux=mean(nrsal) if Dum`x'==1
bysort pid: egen avgnrsal=max(aux)
drop aux

bysort pid: egen aux=mean(nrper) if Dum`x'==1
bysort pid: egen avgnrper=max(aux)
drop aux
bysort pid: egen aux=mean(rtotwag) if Dum`x'==1
bysort pid: egen avgnrwag=max(aux)
drop aux



keep pnr pid fid year norm* disc1_99 disc2_99 age99 union99 UImem99 experience99 ntrend99 rsalary99 rtotwage99 unemp99 pernace10 outlab10 unemp_e10 tc_exp manu_exp disc1_exp disc2_exp manspec4 manspec2 tcspec2 tcspec4 dhf99 stdRTI RTI_alm_isco_77 Fem Imm ET1 ET2 ET3 time affwd affwd_rs  avgnrsal avgnrper avgnrwag LHW* PYInc* PYHrs* LHW* C* NY*

keep if year==2010

drop year


sort pnr time

save "CumVars`x'.dta", replace

restore, preserve

}


use "CumVars9901.dta", clear

gen time=1 
label define labn 1 "pre" 2 "post"
label value time labn

sort pnr time

save "CumVars9901.dta", replace


local xlist "0202 0203 0204 0205 0206 0207 0208 0209 0210"
foreach x of local xlist {

use "CumVars`x'.dta", clear

gen time=2 
label define labn 1 "pre" 2 "post"
label value time labn

sort pnr time

save "CumVars`x'.dta", replace

}



