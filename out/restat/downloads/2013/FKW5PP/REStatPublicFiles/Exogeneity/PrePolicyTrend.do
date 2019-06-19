cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Exogeneity
*Rename directory according to own folder name.
clear
set more off
capture log close
log using PrePolicyTrend.log, text replace

set mem 500m
set matsize 3000

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

This file performs "Pre-Program Regression" tests to examine whether
trends in pre-binding period are correlated with the treatment/control effect.
Drop Australia.
Try:
 -Month Trend
 -Academic Year trend
 -Exam Year trend

SAT Data Acquisition and Defined Binding Dates available in:
C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT

Sample Includes:
       AltSource |     Drop
   Baccalaureate |       Keep
          Branch |     Drop
CommunityCollege |     Drop
     InCB_NotUSN |     Drop
   International |     Drop
          IntlCC |     Drop
 IntlProprietary |     Drop
     LiberalArts |       Keep
         Masters |       Keep
         Medical |     Drop
     NonAcademic |     Drop
           Other |     Drop
     Proprietary |     Drop
        Research |       Keep
       Specialty |     Drop
    TwoYrPrivate |     Drop
        USAbroad |     Drop

Drop unranked schools among these 4 types
*******************************************************************************/





/*************************************
SET UP DATA
*************************************/
use C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT\CleanSAT.dta, clear

*Table Years of Test Taken
tab latsty

*Select School Types
drop if type=="AltSource"
drop if type=="Branch"
drop if type=="CommunityCollege"
drop if type=="InCB_NotUSN"
drop if type=="International"
drop if type=="IntlCC"
drop if type=="IntlProprietary"
drop if type=="Medical"
drop if type=="NonAcademic"
drop if type=="Other"
drop if type=="Proprietary"
drop if type=="Specialty"
drop if type=="TwoYrPrivate"
drop if type=="USAbroad"

*Drop Unranked, Big 4 Type
drop if gentier==4
save temp-a.dta, replace





/*************************************
Aggregate & Create Aggregate Dummies 
*************************************/
gen obs=1
collapse (sum) obs weight, by(latsty latstm satdate typenum gentier genfund bea frgnadd)
sort  latsty latstm satdate typenum gentier genfund bea frgnadd
save temp-b.dta, replace

use temp-a.dta, clear
collapse (mean) math verbal sat bind  [aw=weight], by(latsty latstm satdate typenum gentier genfund bea frgnadd)
sort  latsty latstm satdate typenum gentier genfund bea frgnadd
merge latsty latstm satdate typenum gentier genfund bea frgnadd using temp-b.dta
tab _merge
drop _merge
erase temp-a.dta
erase temp-b.dta


gen facyear=latsty if latstm>=9
replace facyear=latsty-1 if latstm<9
label var facyear "Fall of Academic Year"
gen examyear=latsty


gen key5=0
replace key5=1 if frgnadd==20
replace key5=1 if frgnadd==100
replace key5=1 if frgnadd==115
replace key5=1 if frgnadd==375
replace key5=1 if frgnadd==505


sum
tab bind
tab satdate, gen(dy)
 local ys=r(r)
tab typenum, gen(dtype)
 local types=r(r)
tab gentier, gen(dtier)
 local tiers=r(r)
tab genfund, gen(dfund)
 local funds=r(r)
tab bea, gen(dbea)
 local beas=r(r)
egen school=group(typenum gentier genfund bea)
quietly tab school, gen(dschool)
 local schools=r(r)
egen id=group(typenum gentier genfund bea frgnadd)
tab facyear, gen(dfy)
 local fys=r(r)
tab latsty, gen(dey)
 local eys=r(r)
tab latstm, gen(dm)
 local ms=r(r)

gen months=	0	 if satdate==	200011	   
replace months=	1	 if satdate==	200012	   
replace months=	2	 if satdate==	200101	   
replace months=	3	 if satdate==	200102	   
replace months=	4	 if satdate==	200103	   
replace months=	5	 if satdate==	200104	   
replace months=	6	 if satdate==	200105	   
replace months=	7	 if satdate==	200106	   
replace months=	8	 if satdate==	200107	   
replace months=	9	 if satdate==	200108	   
replace months=	10	 if satdate==	200109	   
replace months=	11	 if satdate==	200110	   
replace months=	12	 if satdate==	200111	   
replace months=	13	 if satdate==	200112	   
replace months=	14	 if satdate==	200201	   
replace months=	15	 if satdate==	200202	   
replace months=	16	 if satdate==	200203	   
replace months=	17	 if satdate==	200204	   
replace months=	18	 if satdate==	200205	   
replace months=	19	 if satdate==	200206	   
replace months=	20	 if satdate==	200207	   
replace months=	21	 if satdate==	200208	   
replace months=	22	 if satdate==	200209	   
replace months=	23	 if satdate==	200210	   
replace months=	24	 if satdate==	200211	   
replace months=	25	 if satdate==	200212	   
replace months=	26	 if satdate==	200301	   
replace months=	27	 if satdate==	200302	   
replace months=	28	 if satdate==	200303	   
replace months=	29	 if satdate==	200304	   
replace months=	30	 if satdate==	200305	   
replace months=	31	 if satdate==	200306	   
replace months=	32	 if satdate==	200307	   
replace months=	33	 if satdate==	200308	   
replace months=	34	 if satdate==	200309	   
replace months=	35	 if satdate==	200310	   
replace months=	36	 if satdate==	200311	   
replace months=	37	 if satdate==	200312	   
replace months=	38	 if satdate==	200401	   
replace months=	39	 if satdate==	200402	   
replace months=	40	 if satdate==	200403	   
replace months=	41	 if satdate==	200404	   
replace months=	42	 if satdate==	200405	   
replace months=	43	 if satdate==	200406	   
replace months=	44	 if satdate==	200407	   
replace months=	45	 if satdate==	200408	   
replace months=	46	 if satdate==	200409	   
replace months=	47	 if satdate==	200410	   
replace months=	48	 if satdate==	200411	   
replace months=	49	 if satdate==	200412	   
replace months=	50	 if satdate==	200501	   
replace months=	51	 if satdate==	200502	   
replace months=	52	 if satdate==	200503	   
replace months=	53	 if satdate==	200504	   
replace months=	54	 if satdate==	200505	   
replace months=	55	 if satdate==	200506	   
replace months=	56	 if satdate==	200507	   
replace months=	57	 if satdate==	200508	   
replace months=	58	 if satdate==	200509	   
replace months=	59	 if satdate==	200510	   
replace months=	60	 if satdate==	200511	   
replace months=	61	 if satdate==	200512	   
replace months=	62	 if satdate==	200601	   
replace months=	63	 if satdate==	200602	   
replace months=	64	 if satdate==	200603	   
replace months=	65	 if satdate==	200604	   
replace months=	66	 if satdate==	200605	   
replace months=	67	 if satdate==	200606	   
replace months=	68	 if satdate==	200607	   
replace months=	69	 if satdate==	200608	   
replace months=	70	 if satdate==	200609	   
replace months=	71	 if satdate==	200610	   
replace months=	72	 if satdate==	200611	   
replace months=	73	 if satdate==	200612	   
replace months=	74	 if satdate==	200701	   
replace months=	75	 if satdate==	200702	   
replace months=	76	 if satdate==	200703	   
replace months=	77	 if satdate==	200704	   
replace months=	78	 if satdate==	200705	   
replace months=	79	 if satdate==	200706	   
replace months=	80	 if satdate==	200707	   
replace months=	81	 if satdate==	200708	   
replace months=	82	 if satdate==	200709	   
replace months=	83	 if satdate==	200710	   
replace months=	84	 if satdate==	200711	   
replace months=	85	 if satdate==	200712	   
replace months=	86	 if satdate==	200801	   
replace months=	87	 if satdate==	200802	   
replace months=	88	 if satdate==	200803	   
replace months=	89	 if satdate==	200804	   
replace months=	90	 if satdate==	200805	   
replace months=	91	 if satdate==	200806	   
replace months=	92	 if satdate==	200807	   
replace months=	93	 if satdate==	200808	   
replace months=	94	 if satdate==	200809	   
replace months=	95	 if satdate==	200810	   
replace months=	96	 if satdate==	200811	   
replace months=	97	 if satdate==	200812	 

drop if frgnadd==20
drop if satdate>=200310
save temp-c.dta, replace





/*************************************
CALCULATE TRENDS
*************************************/
*Monthly Trend
use temp-c.dta, clear
collapse (mean) math verbal sat [aw=weight], by(id months typenum gentier genfund bea school frgnadd key5)
gen trend=.
quietly sum id
 local ids=r(max)
 di "ids="`ids'
forvalues i=1(1)`ids' {
quietly count if id==`i'
if r(N)>2 {
*di `i'
quietly reg sat months if id==`i'
quietly replace trend=_b[months] if id==`i'
}
}
collapse (mean) trend, by(id typenum gentier genfund bea school frgnadd key5)
sum trend key5 id
quietly tab typenum, gen(dtype)
quietly tab gentier, gen(dtier)
quietly tab genfund, gen(dfund)
quietly tab bea, gen(dbea)
reg trend key5
outreg key5 using PrePolicyTrend.xls, se bdec(3) 3aster replace cti("Monthly Trend")
reg trend key5 dtype* dtier* dfund* dbea*
outreg key5 using PrePolicyTrend.xls, se bdec(3) 3aster append cti("Monthly Trend")
areg trend key5, absorb(school)
outreg key5 using PrePolicyTrend.xls, se bdec(3) 3aster append cti("Monthly Trend, School FE")


*Academic Year Trend
use temp-c.dta, clear
collapse (mean) math verbal sat [aw=weight], by(id facyear typenum gentier genfund bea school frgnadd key5)
gen trend=.
quietly sum id
 local ids=r(max)
 di "ids="`ids'
forvalues i=1(1)`ids' {
quietly count if id==`i'
if r(N)>2 {
*di `i'
quietly reg sat facyear if id==`i'
quietly replace trend=_b[facyear] if id==`i'
}
}
collapse (mean) trend, by(id typenum gentier genfund bea school frgnadd key5)
sum trend key5 id
quietly tab typenum, gen(dtype)
quietly tab gentier, gen(dtier)
quietly tab genfund, gen(dfund)
quietly tab bea, gen(dbea)
reg trend key5
outreg key5 using PrePolicyTrend.xls, se bdec(3) 3aster append cti("Ac Year Trend")
reg trend key5 dtype* dtier* dfund* dbea*
outreg key5 using PrePolicyTrend.xls, se bdec(3) 3aster append cti("Ac Year Trend")
areg trend key5, absorb(school)
outreg key5 using PrePolicyTrend.xls, se bdec(3) 3aster append cti("Ac Year Trend, School FE")


*Exam Year Trend
use temp-c.dta, clear
collapse (mean) math verbal sat [aw=weight], by(id latsty typenum gentier genfund bea school frgnadd key5)
gen trend=.
quietly sum id
 local ids=r(max)
 di "ids="`ids'
forvalues i=1(1)`ids' {
quietly count if id==`i'
if r(N)>2 {
*di `i'
quietly reg sat latsty if id==`i'
quietly replace trend=_b[latsty] if id==`i'
}
}
collapse (mean) trend, by(id typenum gentier genfund bea school frgnadd key5)
sum trend key5 id
quietly tab typenum, gen(dtype)
quietly tab gentier, gen(dtier)
quietly tab genfund, gen(dfund)
quietly tab bea, gen(dbea)
reg trend key5
outreg key5 using PrePolicyTrend.xls, se bdec(3) 3aster append cti("Ex Year Trend")
reg trend key5 dtype* dtier* dfund* dbea*
outreg key5 using PrePolicyTrend.xls, se bdec(3) 3aster append cti("Ex Year Trend")
areg trend key5, absorb(school)
outreg key5 using PrePolicyTrend.xls, se bdec(3) 3aster append cti("Ex Year Trend, School FE")





















erase temp-c.dta
capture log close

exit

