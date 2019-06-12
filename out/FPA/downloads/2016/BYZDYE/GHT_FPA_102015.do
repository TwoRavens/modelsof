*************************************************************
***replication file for 
***Sumit Ganguly, Timothy Hellwig, & William R. Thompson, "The Foreign Policy Attitudes of Indian Elites." FOREIGN POLICY ANALYSIS
***October 20, 2015
***contact thellwig@indiana.edu
*************************************************************
log using "\indiafp_102015.log", replace
use "\indiafp_051215.dta", clear
set more off

/*coding variables*/
gen xresistbd = resistbd
recode xresistbd 6=3 .=3 1=5 2=4 4=2 5=1
gen xterrorsp = terrorsp
recode xterrorsp 6=3 .=3 1=5 2=4 4=2 5=1
gen xcnassert = cnassert
recode xcnassert 6=3 .=3 1=5 2=4 4=2 5=1
gen xbanglaim = banglaim
recode xbanglaim 6=3 .=3 1=5 2=4 4=2 5=1
gen xtamilrgt = tamilrgt
recode xtamilrgt 6=3 .=3 1=5 2=4 4=2 5=1
gen xforcefpg = forcefpg
recode xforcefpg 6=3 .=3 1=5 2=4 4=2 5=1
gen xirangood = irangood
recode xirangood 6=3 .=3 1=5 2=4 4=2 5=1
gen xmoneyaf = moneyaf
recode xmoneyaf 6=3 .=3 1=5 2=4 4=2 5=1
gen xmiltcapb = miltcapb
recode xmiltcapb 6=3 .=3 1=5 2=4 4=2 5=1
gen xcutsmlt = cutsmlt
recode xcutsmlt 1=1 2=3 3=2 .=2
gen xnuclsize = nuclsize
recode xnuclsize 1=3 2=2 3=1 4=3 5=2 .=2
gen xgulfindo = gulfindo
recode xgulfindo 6=3 .=3 1=5 2=4 4=2 5=1
gen xglobnatl = globnatl
recode xglobnatl 6=3 .=3 1=5 2=4 4=2 5=1
gen xmulco2 = mulco2
recode xmulco2 6=3 .=3 1=5 2=4 4=2 5=1
gen xgccind = gccind
recode xgccind 6=3 .=3 1=5 2=4 4=2 5=1
gen xdemoword = demoword
recode xdemoword 6=3 .=3 1=5 2=4 4=2 5=1
gen xr2pind = r2pind
recode xr2pind 6=3 .=3 1=5 2=4 4=2 5=1
gen xpaktrade = paktrade
recode xpaktrade 6=3 .=3 1=5 2=4 4=2 5=1
gen xnucdisrm = nucdisrm
recode xnucdisrm 6=3 .=3 1=5 2=4 4=2 5=1
gen xglobaliz = globaliz
recode xglobaliz .=3 1=5 2=4 4=2 5=1
gen xgwelfind = gwelfind
recode xgwelfind 6=3 .=3 1=5 2=4 4=2 5=1
gen xdomestic = domestic
recode xdomestic 6=3 .=3 1=5 2=4 4=2 5=1
gen xcutssoc = cutssoc
recode xcutssoc 1=1 2=0 3=.5 .=.5
gen xeconomy = economy 
recode xeconomy 1=0 2=.25 3=.5 4=.75 5=1 .=.5
gen xinequity = inequity
recode xinequity 1=0 2=.25 3=.5 4=.75 5=1 .=.5
gen xenviron = environ
recode xenviron 1=0 2=.25 3=.5 4=.75 5=1 .=.5
gen ideocomp = (xcutssoc + xeconomy + xinequity + xenviron)/4
sum ideocomp, d
gen libcon = politpov
recode libcon 1=0 2=.25 3=.5 4=.75 5=1 *=.5
gen ageunder40 = age
gen age60plus = age
recode ageunder40 1/2=1 *=0
recode age60plus 5/max=1 *=0
gen pg_educ = educn
recode pg_educ 5=1 *=0
gen xgovempl = govempl
recode xgovempl 1=1 *=0

/*TABLES 1, 4 & 5 ARE FROM OTHER SOURCES - SEE TABLE NOTES IN TEXT*/

/*TABLE 2*/
/*militarycap*/
alpha xmoneyaf xmiltcapb xcutsmlt xnuclsize xgulfindo
/*forcefulness*/
alpha xresistbd xterrorsp xcnassert xbanglaim xtamilrgt xforcefpg xirangood
/*cooperation*/
alpha xdemoword xr2pind xpaktrade xnucdisrm xglobaliz xgwelfind
/*multilateralism*/
alpha xglobnatl xmulco2 xgccind

/*TABLE 3*/
gen th_milcap = ((xmoneyaf + xmiltcapb + xcutsmlt + xnuclsize + xgulfindo)-5)/16
gen th_forceful = ((xresistbd + xterrorsp + xcnassert + xbanglaim + xtamilrgt + xforcefpg + xirangood)-7)/28
gen th_coop = ((xdemoword + xr2pind + xpaktrade + xnucdisrm + xglobaliz + xgwelfind)-6)/24
gen th_multilat = ((xglobnatl + xmulco2 + xgccind)-3)/12
factor th_milcap th_forceful th_coop th_multilat, pcf
rotate
predict f1 f2
rename f1 mi
rename f2 ci
label variable mi "Militant Internationalism"
label variable ci "Cooperative Internationalism"
recode mi 2.99/max=2.99 min/-2.99=-2.99

/*FIGURE 1*/
graph twoway scatter ci mi, msymbol(o) ysc(r(-3 3)) xsc(r(-3 3)) scheme(s1mono)

/*CLASSIFICATIONS*/
gen miciaccm = 0
recode miciaccm *=1 if mi<0 & ci>0
gen miciintl = 0
recode miciintl *=1 if mi>0 & ci>0
gen miciisol = 0
recode miciisol *=1 if mi<0 & ci<0
gen micihrdl = 0
recode micihrdl *=1 if mi>0 & ci<0
sum mici*

/*EXAMINING THE ISOLATIONISTS*/
gen domest01 = xdomestic
recode domest01 4=1 5=1 *=0
tab miciaccm if domest01==1
tab miciintl if domest01==1
tab miciisol if domest01==1
tab micihrdl if domest01==1
tab2 miciaccm domest01, ch
tab2 miciintl domest01, ch
tab2 miciisol domest01, ch
tab2 micihrdl domest01, ch

/*TABLE 6*/
reg mi libcon ageunder40 age60plus pg_educ xgovempl, r
reg mi ideocomp ageunder40 age60plus pg_educ xgovempl, r  
reg ci libcon ageunder40 age60plus pg_educ xgovempl, r 
reg ci ideocomp ageunder40 age60plus pg_educ xgovempl, r

/*APPENDIX TABLE A1*/
tab age
tab educn
tab govempl
sum airaf armyaf navyaf nonmilt

/*APPENDIX TABLE A2*/
factor xmoneyaf xmiltcapb xcutsmlt xnuclsize xgulfindo xresistbd xterrorsp xcnassert xbanglaim xtamilrgt xforcefpg xirangood xdemoword xr2pind xpaktrade xnucdisrm xglobaliz xgwelfind xglobnatl xmulco2 xgccind, pcf mine(1)
rotate

clear

/*FIGURE 2*/ 
use "\fig2_082515.dta", replace
label variable assertiveness "Assertiveness"
label variable liberalism "Liberalism"
gen pos = 3
replace pos = 9 if csample=="USA(m)"
graph twoway scatter liberalism assertiveness, msymbol(o) mlabel(csample) mlabv(pos) ysc(r(-70 70)) xsc(r(-70 70)) scheme(s1mono)

log off
