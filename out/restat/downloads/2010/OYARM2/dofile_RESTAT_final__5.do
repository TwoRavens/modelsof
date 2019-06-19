clear
set mem 100m
capture log close

cd "C:\Documents and Settings\fgallego\My Documents\Pancho\history\final\"

use Restatdata1, clear

**All data is available in the two files but data on Christian missionaries that belongs to Robert Woodberry.

*Table 1
tabstat primary1900p tyr primary secondar higher lsettler lpopd es_es_go es_es_ba ss1 catholic muslim orelig cath1900 musl1900 ///
orel1900 british french spanish demo1900 demo gastil norm_dec cent1900 dec_adm dec_funds1 lgdp95_e ratio80, c(s) s(n mean median sd p5 p95)

log using Ftest_t2.txt,replace text

* Table 2: Reduced form estimates
quietly: reg primary1900p lsettler lpopd es_es_go es_es_ba ss1 , r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 using table2,bd(2) td(2) replace
gen prueba1=e(sample)
quietly: reg primary1900p lsettler lpopd es_es_go es_es_ba ss1 british french spanish cath1900 musl1900 orel1900 , r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 british french spanish cath1900 musl1900 orel1900 using table2,bd(2) td(2)
gen prueba2=e(sample)
test british french spanish 
test cath1900 musl1900 orel1900 

quietly: reg tyr lsettler lpopd es_es_go es_es_ba ss1 ,  r
outreg2 lsettler lpopd es_es_go es_es_ba ss1 using table2,bd(2) td(2)
gen prueba3=e(sample)
quietly: reg tyr lsettler lpopd es_es_go es_es_ba ss1 british french spanish catholic muslim orelig ,  r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 british french spanish catholic muslim orelig using table2,bd(2) td(2)
gen prueba4=e(sample)
test british french spanish 
test catholic muslim orelig 

quietly: reg primary lsettler lpopd es_es_go es_es_ba ss1 ,  r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 using table2,bd(2) td(2)
gen prueba5=e(sample)
quietly: reg primary lsettler lpopd es_es_go es_es_ba ss1 british french spanish catholic muslim orelig,  r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 british french spanish catholic muslim orelig using table2,bd(2) td(2)
gen prueba6=e(sample)
test british french spanish 
test catholic muslim orelig 

quietly: reg secondar lsettler lpopd es_es_go es_es_ba ss1 ,  r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 using table2,bd(2) td(2)
gen prueba7=e(sample)
quietly: reg secondar lsettler lpopd es_es_go es_es_ba ss1 british french spanish catholic muslim orelig ,  r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 british french spanish catholic muslim orelig using table2,bd(2) td(2)
gen prueba8=e(sample)
test british french spanish 
test catholic muslim orelig 

quietly: reg higher lsettler lpopd es_es_go es_es_ba ss1 ,  r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 using table2,bd(2) td(2)
gen prueba9=e(sample)
quietly: reg higher lsettler lpopd es_es_go es_es_ba ss1 british french spanish catholic muslim orelig ,  r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 british french spanish catholic muslim orelig using table2,bd(2) td(2) excel
gen prueba10=e(sample)
test british french spanish 
test catholic muslim orelig 

log close


log using Ftest_t3.txt,replace text

*Table 3

* Panel A: IV estimates


quietly: ivreg primary1900p (demo1900 cent1900=lsettler lpopd es_es_go es_es_ba ss1) british french spanish cath1900 musl1900 orel1900 , r first
outreg2 demo1900 cent1900 using table3a, bd(2) td(2) replace
gen prueba11=e(sample)
test british french spanish 
test cath1900 musl1900 orel1900
predict residiv1 if e(sample), resid


quietly: ivreg tyr (demo norm_dec lgdp95_e=lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r first
outreg2 demo norm_dec lgdp95_e using table3a, bd(2) td(2) excel
gen prueba12=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv2 if e(sample), resid


* Panel B: First stages

quietly: reg demo1900  lsettler lpopd es_es_go es_es_ba ss1 british french spanish cath1900 musl1900 orel1900 , r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 british french spanish cath1900 musl1900 orel1900 using table3b, bd(2) td(2) replace
gen prueba13=e(sample)
test british french spanish 
test cath1900 musl1900 orel1900
quietly: reg cent1900 lsettler lpopd es_es_go es_es_ba ss1 british french spanish cath1900 musl1900 orel1900 , r
outreg2 lsettler lpopd es_es_go es_es_ba ss1 british french spanish cath1900 musl1900 orel1900 using table3b, bd(2) td(2)
gen prueba14=e(sample)
test british french spanish 
test cath1900 musl1900 orel1900

quietly: reg demo lsettler lpopd es_es_go es_es_ba ss1 ratio80 british french spanish catholic muslim orelig if residiv2~=.,  r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 ratio80 british french spanish catholic muslim orelig using table3b, bd(2) td(2)
gen prueba15=e(sample)
test british french spanish 
test catholic muslim orelig 
quietly: reg norm_dec lsettler lpopd es_es_go es_es_ba ss1 ratio80 british french spanish catholic muslim orelig if residiv2~=.,  r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 ratio80 british french spanish catholic muslim orelig using table3b, bd(2) td(2)
gen prueba16=e(sample)
test british french spanish 
test catholic muslim orelig 
quietly: reg lgdp95_e lsettler lpopd es_es_go es_es_ba ss1 ratio80 british french spanish catholic muslim orelig if residiv2~=.,  r 
outreg2 lsettler lpopd es_es_go es_es_ba ss1 ratio80 british french spanish catholic muslim orelig using table3b, bd(2) td(2) excel
gen prueba17=e(sample)
test british french spanish 
test catholic muslim orelig 

log close

 

log using Ftest_t4.txt,replace text
* table 4: Other estimates

quietly: ivreg tyr (gastil norm_dec lgdp95_e=lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 gastil norm_dec lgdp95_e british french spanish catholic muslim orelig using table4, bd(2) td(2) replace
gen prueba18=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv3 if e(sample), resid

quietly: ivreg tyr (demo lgdp95_e=lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 demo lgdp95_e british french spanish catholic muslim orelig using table4, bd(2) td(2)
gen prueba19=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv4 if e(sample), resid

quietly: ivreg tyr (norm_dec lgdp95_e=lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 norm_dec lgdp95_e british french spanish catholic muslim orelig using table4, bd(2) td(2)
gen prueba20=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv5 if e(sample), resid

quietly: ivreg tyr (inst_ajr norm_dec lgdp95_e=lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 inst_ajr norm_dec lgdp95_e british french spanish catholic muslim orelig using table4, bd(2) td(2)
gen prueba21=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv6 if e(sample), resid


quietly: ivreg tyr (demo norm_dec =lsettler lpopd es_es_go es_es_ba ss1 ratio80) lgdp95_e british french spanish catholic muslim orelig ,  r
outreg2 demo norm_dec lgdp95_e british french spanish catholic muslim orelig using table4, bd(2) td(2)
gen prueba22=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv7 if e(sample), resid

quietly: ivreg tyr (demo norm_dec lgdp95_e=lsettler lpopd es_es_go es_es_ba ss1 ratio80) frac_et british french spanish catholic muslim orelig ,  r
outreg2 demo norm_dec lgdp95_e frac_et british french spanish catholic muslim orelig using table4, bd(2) td(2)
gen prueba23=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv8 if e(sample), resid

quietly: ivreg tyr (demo norm_dec lgdp95_e=lsettler lpopd es_es_go es_es_ba ss1 ratio80) giniland british french spanish catholic muslim orelig ,  r
outreg2 demo norm_dec lgdp95_e giniland british french spanish catholic muslim orelig using table4, bd(2) td(2)
gen prueba24=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv9 if e(sample), resid

quietly: ivreg tyr (demo norm_dec lgdp95_e=lsettler lpopd es_es_go es_es_ba ss1 ratio80) missionaries british french spanish catholic muslim orelig ,  r
outreg2 demo norm_dec lgdp95_e missionaries british french spanish catholic muslim orelig using table4, bd(2) td(2)
gen prueba25=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv10 if e(sample), resid

quietly: ivreg primary (demo norm_dec lgdp95_e=lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 demo norm_dec lgdp95_e british french spanish catholic muslim orelig using table4, bd(2) td(2)
gen prueba26=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv11 if e(sample), resid

quietly: ivreg secondar (demo norm_dec lgdp95_e=lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 demo norm_dec lgdp95_e british french spanish catholic muslim orelig using table4, bd(2) td(2)
gen prueba27=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv12 if e(sample), resid

quietly: ivreg higher (demo norm_dec lgdp95_e=lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig,  r
outreg2 demo norm_dec lgdp95_e british french spanish catholic muslim orelig using table4, bd(2) td(2) excel
gen prueba28=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv13 if e(sample), resid

log close


log using Ftest_t5.txt,replace text
* table 5 Measures of decentralization

ivreg dec_adm (demo  norm_dec lgdp95_e =lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig,  r
outreg2 demo  norm_dec lgdp95_e british french spanish catholic muslim orelig using table5, bd(2) td(2) replace
gen prueba29=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv14 if e(sample), resid

ivreg dec_funds1 (demo  norm_dec lgdp95_e =lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 demo  norm_dec lgdp95_e british french spanish catholic muslim orelig using table5, bd(2) td(2)
gen prueba30=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv15 if e(sample), resid

ivreg tyr (demo  dec_adm lgdp95_e =lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig,  r
outreg2 demo  dec_adm lgdp95_e british french spanish catholic muslim orelig using table5, bd(2) td(2)
gen prueba31=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv16 if e(sample), resid

ivreg tyr (demo  dec_funds1 lgdp95_e =lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 demo  dec_funds1 lgdp95_e british french spanish catholic muslim orelig using table5, bd(2) td(2)
gen prueba32=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv17 if e(sample), resid

ivreg primary (demo  dec_adm lgdp95_e =lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 demo  dec_adm lgdp95_e british french spanish catholic muslim orelig using table5, bd(2) td(2)
gen prueba33=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv18 if e(sample), resid

ivreg primary (demo  dec_funds1 lgdp95_e =lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 demo  dec_funds1 lgdp95_e british french spanish catholic muslim orelig using table5, bd(2) td(2)
gen prueba34=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv19 if e(sample), resid

ivreg secondar (demo  dec_adm lgdp95_e =lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig,  r
outreg2 demo  dec_adm lgdp95_e british french spanish catholic muslim orelig using table5, bd(2) td(2)
gen prueba35=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv20 if e(sample), resid

ivreg secondar (demo  dec_funds1 lgdp95_e =lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 demo  dec_funds1 lgdp95_e british french spanish catholic muslim orelig using table5, bd(2) td(2)
gen prueba36=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv21 if e(sample), resid

ivreg higher (demo  dec_adm lgdp95_e =lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 demo  dec_adm lgdp95_e british french spanish catholic muslim orelig using table5, bd(2) td(2)
gen prueba37=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv22 if e(sample), resid

ivreg higher (demo  dec_funds1 lgdp95_e =lsettler lpopd es_es_go es_es_ba ss1 ratio80) british french spanish catholic muslim orelig ,  r
outreg2 demo  dec_funds1 lgdp95_e british french spanish catholic muslim orelig using table5, bd(2) td(2) excel
gen prueba38=e(sample)
test british french spanish 
test catholic muslim orelig 
predict residiv23 if e(sample), resid

log close


*table 6

* Panel A at the end of this file

* Panel B 

reg primary1900p pri_col_ cath1900 musl1900 orel1900 lsettler lpopd es_es_go es_es_ba ss1 , r
outreg2 pri_col_ cath1900 musl1900 orel1900 lsettler lpopd es_es_go es_es_ba ss1 using table6b, bd(2) td(2) replace
gen prueba39=e(sample)
reg tyr pri_col_ catholic muslim orelig lsettler lpopd es_es_go es_es_ba ss1 , r
outreg2 pri_col_ catholic muslim orelig lsettler lpopd es_es_go es_es_ba ss1 using table6b, bd(2) td(2) excel
gen prueba40=e(sample)


* Panel C 

ivreg tyr demo1900 euro1900 primary1900p , r
outreg2 demo1900 euro1900 primary1900p using table6c, bd(2) td(2) replace
gen prueba41=e(sample)
ivreg tyr demo1900 euro1900 primary1900p british french spanish catholic muslim orelig , r
outreg2 demo1900 euro1900 primary1900p british french spanish catholic muslim orelig using table6c, bd(2) td(2)
gen prueba42=e(sample)
ivreg tyr (demo1900 euro1900 primary1900p=lpopd lsettler miss_pro) , r
outreg2 demo1900 euro1900 primary1900p using table6c, bd(2) td(2)
gen prueba43=e(sample)
ivreg tyr (demo1900 euro1900 primary1900p=lpopd lsettler miss_pro) british french spanish catholic muslim orelig , r
outreg2 demo1900 euro1900 primary1900p british french spanish catholic muslim orelig using table6c, bd(2) td(2) excel
gen prueba44=e(sample)


*Figure 1

twoway (lfit tyr primary1900p) (scatter tyr primary1900p, mlabel(code)) , legend(off) xtitle("Primary enrollment in 1900") ytitle("Years of Schooling, 1985-1995") 
twoway (lfit tyr primary1900p) (scatter tyr primary1900p, mlabel(code)) if primary1900p<40, legend(off) xtitle("Primary enrollment in 1900") ytitle("Years of Schooling, 1985-1995") 

*Figure 2
reg tyr dec_adm demo lgdp95_e, r
gen prueba45=e(sample)
avplot dec_adm, ml(code) xtitle("School Decentralization of Management conditional on GDP and Democracy") ytitle("Schooling conditional on GDP and Democracy")  

reg tyr dec_funds1 demo lgdp95_e, r
gen prueba46=e(sample)
avplot dec_funds1, ml(code) xtitle("School Decentralization of Finance conditional on GDP and Democracy") ytitle("Schooling conditional on GDP and Democracy")  

*Other exercises, mentioned in the text but non reported in tables

* Regression between current and past schooling
reg tyr primary1900p, r

* Spearman rank correlation between current and past schooling 
spearman tyr primary1900p

* IV estimates for 1900 in Table 3, controlling for urbanization in 1700
ivreg primary1900p (demo1900 cent1900=lsettler lpopd es_es_go es_es_ba ss1) british french spanish cath1900 musl1900 orel1900 urb1700, r 
ivreg primary1900p (demo1900 cent1900=lsettler lpopd es_es_go es_es_ba ss1) british french spanish cath1900 musl1900 orel1900 urb1700c, r  

*Table 6
* Panel A

use Restatdata2, clear

areg  primary priml demol  t1-t8 , a(code) r
outreg2 priml demol using table6a, bd(2) td(2) replace
gen prueba1=e(sample)
areg  primary priml2 demol2  t1-t8 , a(code) r
outreg2 priml2 demol2 using table6a, bd(2) td(2)
gen prueba2=e(sample)
areg  primary priml3 demol3  t1-t8 , a(code) r
outreg2 priml3 demol3 using table6a, bd(2) td(2)
gen prueba3=e(sample)
areg  demo priml demol  t1-t8 , a(code) r
outreg2 priml demol using table6a, bd(2) td(2)
gen prueba4=e(sample)
areg  demo priml2 demol2  t1-t8 , a(code) r
outreg2 priml2 demol2 using table6a, bd(2) td(2)
gen prueba5=e(sample)
areg  demo priml3 demol3  t1-t8 , a(code) r
outreg2 priml3 demol3 using table6a, bd(2) td(2) excel
gen prueba6=e(sample)
