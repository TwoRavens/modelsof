************************************************************
*  Ziller / Helbling (2017) Antidiscrimination laws,       *
*  Policy Knowledge, and Political Support                 *
*  27 Jun 2017                                             *
*  Analyses file                                           *
************************************************************

************************************************************
* NOTE 1: DUE TO RESTRICTIONS IN DATA AVAILABILITY         *
* VARIABLE std2fb_c (PROPORTIONS OF FOREIGN-BORN) IS NOT   *
* INCLUDED IN THE REPLICATION DATA FILE. PLEASE VISIT      *
* EUROSTAT IN ORDER TO OBTAIN THE MICRODATA, WHICH CAN BE  *
* AGGREGATED TO COUNTRY-YEAR FIGURES.                      *
* MODELS CAN ALTERNATIVELY BE ESTIMATED WITHOUT THIS       *
* CONTROL VARIABLE. TO DO SO, FIND AND REPLACE (Ctrl+H)    * 
* ANY "std2fb_c" IN THE DO-FILE.                           *
************************************************************ 

************************************************************
* NOTE 2: TO REPLICATE COEFFICIENT PLOTS PLEASE FIRST      *
* EXECUTE "Antidiscrimination law (EB).do"                 *
************************************************************


use "Antidiscrimination laws_data (ESS).dta", clear



********* 1. AVERAGE EFFECTS

//satdem




mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint       ///
std2unempl_c   std2fb_c std2adp_c std2know_c  ///
   i.year i.idx   ||year_cnt:
eststo satdem_nat_f

mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint      ///
std2unempl_c std2fb_c std2adp_c std2know_c ///
   i.year i.idx if gender==1  ||year_cnt:
eststo satdem_gender_f

mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint      ///
std2unempl_c std2fb_c std2adp_c std2know_c ///
   i.year i.idx if first==1  ||year_cnt:
eststo satdem_first_f




//poltrust

mixed poltrust std2age  gender first std2educyears  std2feel_inc unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2adp_c std2know_c  ///
   i.year i.idx   ||year_cnt:
eststo polcon_nat_f

mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint      ///
std2unempl_c std2fb_c std2adp_c std2know_c ///
   i.year i.idx if gender==1  ||year_cnt:
eststo polcon_gender_f

mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint      ///
std2unempl_c std2fb_c std2adp_c std2know_c ///
   i.year i.idx if first==1  ||year_cnt:
eststo polcon_first_f





estimates dir
estimates replay polcon_nat_f
estimates replay polcon_gender_f
estimates replay polcon_first_f

estimates replay satdem_nat_f
estimates replay satdem_gender_f
estimates replay satdem_first_f



estimates restore polcon_nat_f
eret list
estimates save "myestESS.est" , replace
estimates restore polcon_gender_f
eret list
estimates save "myestESS.est" , append
estimates restore polcon_first_f
eret list
estimates save "myestESS.est" , append
estimates restore satdem_nat_f
eret list
estimates save "myestESS.est" , append
estimates restore satdem_gender_f
eret list
estimates save "myestESS.est" , append
estimates restore satdem_first_f
eret list
estimates save "myestESS.est" , append





******* 2. INTERACTION DISCRIMINATED 

***KNOWLEDGE



//satdem

mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2adp_c c.std2know_c##c.discr ///
   i.year i.idx    ||year_cnt: discr  
eststo satdem_nat_f_dis

mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2adp_c c.std2know_c##c.discr ///
   i.year i.idx if gender==1   ||year_cnt: discr  
eststo satdem_gender_f_dis


mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2adp_c c.std2know_c##c.discr ///
   i.year i.idx if first==1   ||year_cnt: discr  
eststo satdem_first_f_dis




//poltrust

mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2adp_c c.std2know_c##c.discr ///
   i.year i.idx    ||year_cnt: discr  
eststo polcon_nat_f_dis


mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2adp_c c.std2know_c##c.discr ///
   i.year i.idx if gender==1   ||year_cnt: discr  
eststo polcon_gender_f_dis

mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2adp_c c.std2know_c##c.discr ///
   i.year i.idx if first==1   ||year_cnt: discr  
eststo polcon_first_f_dis






***ADP


//satdem

mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2know_c  c.std2adp_c##c.discr  ///
   i.year i.idx    ||year_cnt: discr  
eststo satdem_nat_f_disA

mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2know_c c.std2adp_c##c.discr ///
   i.year i.idx if gender==1   ||year_cnt: discr  
eststo satdem_gender_f_disA


mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2know_c c.std2adp_c##c.discr ///
   i.year i.idx if first==1   ||year_cnt: discr  
eststo satdem_first_f_disA





//poltrust

mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2know_c c.std2adp_c##c.discr   ///
   i.year i.idx    ||year_cnt: discr  
eststo polcon_nat_f_disA

mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2know_c c.std2adp_c##c.discr ///
   i.year i.idx if gender==1   ||year_cnt: discr  
eststo polcon_gender_f_disA

mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c std2fb_c std2know_c c.std2adp_c##c.discr ///
   i.year i.idx if first==1   ||year_cnt: discr  
eststo polcon_first_f_disA





estimates dir
estimates replay satdem_nat_f_dis
estimates replay satdem_gender_f_dis
estimates replay satdem_first_f_dis
estimates replay satdem_nat_f_disA
estimates replay satdem_gender_f_disA
estimates replay satdem_first_f_disA

 

estimates restore satdem_nat_f_dis
eret list
estimates save "myestESS_dis3.est" , replace
estimates restore satdem_gender_f_dis
eret list
estimates save "myestESS_dis3.est" , append
estimates restore satdem_first_f_dis
eret list
estimates save "myestESS_dis3.est" , append
estimates restore satdem_nat_f_disA
eret list
estimates save "myestESS_dis3.est" , append
estimates restore satdem_gender_f_disA
eret list
estimates save "myestESS_dis3.est" , append
estimates restore satdem_first_f_disA
eret list
estimates save "myestESS_dis3.est" , append

estimates dir
estimates replay polcon_nat_f_dis
estimates replay polcon_gender_f_dis
estimates replay polcon_first_f_dis
estimates replay polcon_nat_f_disA
estimates replay polcon_gender_f_disA
estimates replay polcon_first_f_disA
 


estimates restore polcon_nat_f_dis
eret list
estimates save "myestESS_dis4.est" , replace
estimates restore polcon_gender_f_dis
eret list
estimates save "myestESS_dis4.est" , append
estimates restore polcon_first_f_dis
eret list
estimates save "myestESS_dis4.est" , append
estimates restore polcon_nat_f_disA
eret list
estimates save "myestESS_dis4.est" , append
estimates restore polcon_gender_f_disA
eret list
estimates save "myestESS_dis4.est" , append
estimates restore polcon_first_f_disA
eret list
estimates save "myestESS_dis4.est" , append





******* 3. INTERACTION EGALITARIANISM 

***KNOWLEDGE

//satdem

   
   
   mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c  std2fb_c std2adp_c c.std2know_c##c.std2egal ///
   i.year i.idx    ||year_cnt:  std2egal , stddev
eststo satdem_nat_f_c

   mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c  std2fb_c std2adp_c c.std2know_c##c.std2egal ///
   i.year i.idx  if gender==1   ||year_cnt:  std2egal , stddev
eststo satdem_gender_f_c

   mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c  std2fb_c std2adp_c c.std2know_c##c. std2egal ///
   i.year i.idx   if first==1  ||year_cnt:  std2egal , stddev
eststo satdem_first_f_c



//poltrust


mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c  std2fb_c std2adp_c c.std2know_c##c.std2egal ///
   i.year i.idx    ||year_cnt:  std2egal , stddev
eststo polcon_nat_f_c


mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c  std2fb_c std2adp_c c.std2know_c##c.std2egal ///
   i.year i.idx  if gender==1  ||year_cnt:  std2egal , stddev
eststo polcon_gender_f_c


mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c  std2fb_c std2adp_c c.std2know_c##c.std2egal ///
   i.year i.idx  if first==1  ||year_cnt:  std2egal , stddev
eststo polcon_first_f_c



***ADP

//satdem
   
   mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c  std2fb_c  std2know_c  c.std2adp_c##c.std2egal ///
   i.year i.idx    ||year_cnt:  std2egal , stddev
eststo satdem_nat_f_cA

   mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c  std2fb_c  std2know_c  c.std2adp_c##c.std2egal ///
   i.year i.idx  if gender==1  ||year_cnt:  std2egal , stddev
eststo satdem_gender_f_cA

   mixed satdem std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c  std2fb_c  std2know_c  c.std2adp_c##c.std2egal ///
   i.year i.idx   if first==1 ||year_cnt:  std2egal , stddev
eststo satdem_first_f_cA

//poltrust

mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c  std2fb_c  std2know_c  c.std2adp_c##c.std2egal ///
   i.year i.idx    ||year_cnt:  std2egal  , stddev
eststo polcon_nat_f_cA

mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c  std2fb_c  std2know_c  c.std2adp_c##c.std2egal ///
   i.year i.idx   if gender==1  ||year_cnt:  std2egal , stddev
eststo polcon_gender_f_cA

mixed poltrust std2age  gender first std2educyears std2feel_inc  unemp3 u1 u2 u4 u5   std2polint     ///
std2unempl_c  std2fb_c  std2know_c  c.std2adp_c##c.std2egal ///
   i.year i.idx  if first==1  ||year_cnt:  std2egal , stddev
eststo polcon_first_f_cA




******* 4. FIGURES


////PLOT Fig. 4



coefplot (polcon_nat_f_c \ polcon_gender_f_c \ polcon_first_f_c \ satdem_nat_f_c \ satdem_gender_f_c \ satdem_first_f_c , keep(c.std2know_c#c.std2egal) msymbol(d) msize(small)) ///
, aseq  swap headings(polcon_nat_f_c = "{bf:DV: Political trust}" satdem_nat_f_c = "{bf:DV: Satisfaction democracy}")  ///
xline(0) scheme(s1mono) ciopts(lwidth(*0.9) lcolor(gs10 )  ) levels(95)  grid(none)   ///
coeflabels(polcon_nat_f_dis="M19: All respondents" polcon_gender_f_dis="M20: Women only" polcon_first_f_dis="M21: Foreign-born only" ///
satdem_nat_f_dis="M22: All respondents" satdem_gender_f_dis="M23: Women only" satdem_first_f_dis="M24: Foreign-born only") 

graph save Graph "Fig 4a.gph", replace

coefplot (polcon_nat_f_cA \ polcon_gender_f_cA \ polcon_first_f_cA \ satdem_nat_f_cA \ satdem_gender_f_cA \ satdem_first_f_cA , keep(c.std2adp_c#c.std2egal) msymbol(o) msize(small)) ///
, aseq  swap headings(polcon_nat_f_cA = "{bf:DV: Political trust}" satdem_nat_f_cA = "{bf:DV: Satisfaction democracy}")  ///
xline(0) scheme(s1mono) ciopts(lwidth(*0.9)  ) levels(95)  grid(none)   ///
coeflabels(polcon_nat_f_cA="M28/M29: All respondents" polcon_gender_f_cA="M30/M31: Women only" polcon_first_f_cA="M32/M33: Foreign-born only" ///
satdem_nat_f_cA="M34/M35: All respondents" satdem_gender_f_cA="M36/M37: Women only" satdem_first_f_cA="M38/M39: Foreign-born only")

graph save Graph "Fig 4b.gph", replace


graph combine "Fig 4b.gph" "Fig 4b.gph" "Fig 4a.gph", t1(Law indicator) t2(Policy knowledge) cols(3)  graphregion(margin(zero))  scheme(s1mono) //needs to be configurated manually




**Figure 2

clear all
eret list


estimates use "myestEB.est", number(1)
eret list
estimates store po_sit_nat_f

estimates use "myestEB.est", number(2)
eret list
estimates store po_sit_gender_f


estimates use "myestEB.est", number(3)
eret list
estimates store po_sit_first_f


estimates use "myestESS.est", number(1)
eret list
estimates store polcon_nat_f


estimates use "myestESS.est", number(2)
eret list
estimates store polcon_gender_f


estimates use "myestESS.est", number(3)
eret list
estimates store polcon_first_f


estimates use "myestESS.est", number(4)
eret list
estimates store satdem_nat_f


estimates use "myestESS.est", number(5)
eret list
estimates store satdem_gender_f


estimates use "myestESS.est", number(6)
eret list
estimates store satdem_first_f



coefplot (po_sit_nat_f \ po_sit_gender_f \ po_sit_first_f \ polcon_nat_f \ polcon_gender_f \ polcon_first_f \ satdem_nat_f \ satdem_gender_f \ satdem_first_f ///
, keep(std2adp_c) label(Law indicator) msymbol(o) msize(small) )  ///
(po_sit_nat_f \ po_sit_gender_f \ po_sit_first_f \ polcon_nat_f \ polcon_gender_f \ polcon_first_f \ satdem_nat_f \ satdem_gender_f \ satdem_first_f, keep(std2know_c) label(Knowledge indicator) msymbol(d) msize(small)) ///
, aseq  swap headings(po_sit_nat_f = "{bf:DV: Eval. public administration}" polcon_nat_f = "{bf:DV: Political trust}" satdem_nat_f = "{bf:DV: Satisfaction democracy}")  ///
xline(0) scheme(s1mono) ciopts(lwidth(*0.9)  ) levels(95)  grid(none)  legend(rows(1) region(lpattern(blank))) ///
coeflabels(po_sit_nat_f="M1: All respondents" po_sit_gender_f="M2: Women only" po_sit_first_f="M3: Foreign-born only" ///
polcon_nat_f="M4: All respondents" polcon_gender_f="M5: Women only" polcon_first_f="M6: Foreign-born only" ///
satdem_nat_f="M7: All respondents" satdem_gender_f="M8: Women only" satdem_first_f="M9: Foreign-born only")


graph save Graph "Fig 2.gph", replace



esttab po_sit_nat_f  po_sit_gender_f    po_sit_first_f   ///
using "Table_1a.rtf", b(3)  star(* 0.05 ** 0.01 )  se   stats(N r2) transform(ln*: exp(@) exp(@)) replace

esttab  polcon_nat_f polcon_gender_f polcon_first_f satdem_nat_f satdem_gender_f satdem_first_f ///
using "Table_1b.rtf", b(3)  star(* 0.05 ** 0.01 )  se   stats(N r2) transform(ln*: exp(@) exp(@)) replace




**Figure 3


clear all
eret list



estimates use "myestESS_dis4.est", number(1)
eret list
estimates store polcon_nat_f_dis

estimates use "myestESS_dis4.est", number(2)
eret list
estimates store polcon_gender_f_dis


estimates use "myestESS_dis4.est", number(3)
eret list
estimates store polcon_first_f_dis


estimates use "myestESS_dis4.est", number(4)
eret list
estimates store polcon_nat_f_disA

estimates use "myestESS_dis4.est", number(5)
eret list
estimates store polcon_gender_f_disA


estimates use "myestESS_dis4.est", number(6)
eret list
estimates store polcon_first_f_disA



estimates use "myestESS_dis3.est", number(1)
eret list
estimates store satdem_nat_f_dis

estimates use "myestESS_dis3.est", number(2)
eret list
estimates store satdem_gender_f_dis


estimates use "myestESS_dis3.est", number(3)
eret list
estimates store satdem_first_f_dis


estimates use "myestESS_dis3.est", number(4)
eret list
estimates store satdem_nat_f_disA

estimates use "myestESS_dis3.est", number(5)
eret list
estimates store satdem_gender_f_disA


estimates use "myestESS_dis3.est", number(6)
eret list
estimates store satdem_first_f_disA



estimates use "myestEB_dis2.est", number(1)
eret list
estimates store po_sit_nat_f_dis

estimates use "myestEB_dis2.est", number(2)
eret list
estimates store po_sit_gender_f_dis


estimates use "myestEB_dis2.est", number(3)
eret list
estimates store po_sit_first_f_dis


estimates use "myestEB_dis2.est", number(4)
eret list
estimates store po_sit_nat_f_disA

estimates use "myestEB_dis2.est", number(5)
eret list
estimates store po_sit_gender_f_disA


estimates use "myestEB_dis2.est", number(6)
eret list
estimates store po_sit_first_f_disA


coefplot (po_sit_nat_f_dis \ po_sit_gender_f_dis \ po_sit_first_f_dis \  polcon_nat_f_dis \ polcon_gender_f_dis \ polcon_first_f_dis \ satdem_nat_f_dis \ satdem_gender_f_dis \ satdem_first_f_dis , keep(c.std2know_c#c.discr) msymbol(d) msize(small)) ///
, aseq  swap headings(po_sit_nat_f_dis = "{bf:DV: Eval. public administration}" polcon_nat_f_dis = "{bf:DV: Political trust}" satdem_nat_f_dis = "{bf:DV: Satisfaction democracy}")  ///
xline(0) scheme(s1mono) ciopts(lwidth(*0.9) lcolor(gs10 )  ) levels(95)  grid(none)   ///
coeflabels(po_sit_nat_f_dis="M1: All respondents" po_sit_gender_f_dis="M2: Women only" po_sit_first_f_dis="M3: Foreign-born only" ///
polcon_nat_f_dis="M10/M11: All respondents" polcon_gender_f_dis="M20: Women only" polcon_first_f_dis="M21: Foreign-born only" ///
satdem_nat_f_dis="M22: All respondents" satdem_gender_f_dis="M23: Women only" satdem_first_f_dis="M24: Foreign-born only") 

graph save Graph "Fig 3a.gph", replace

coefplot (po_sit_nat_f_disA \ po_sit_gender_f_disA \ po_sit_first_f_disA \ polcon_nat_f_disA \ polcon_gender_f_disA \ polcon_first_f_disA \ satdem_nat_f_disA \ satdem_gender_f_disA \ satdem_first_f_disA , keep(c.std2adp_c#c.discr) msymbol(o) msize(small)) ///
, aseq  swap headings(po_sit_nat_f_disA = "{bf:DV: Eval. public administration}" polcon_nat_f_disA = "{bf:DV: Political trust}" satdem_nat_f_disA = "{bf:DV: Satisfaction democracy}")  ///
xline(0) scheme(s1mono) ciopts(lwidth(*0.9)  ) levels(95)  grid(none)   ///
coeflabels(po_sit_nat_f_disA="M10/M11: All respondents" po_sit_gender_f_disA="M12/M13: Women only" po_sit_first_f_disA="M14/M15: Foreign-born only" ///
polcon_nat_f_disA="M16/M17: All respondents" polcon_gender_f_disA="M18/M19: Women only" polcon_first_f_disA="M20/M21: Foreign-born only" ///
satdem_nat_f_disA="M22/M23: All respondents" satdem_gender_f_disA="M24/M25: Women only" satdem_first_f_disA="M26/M27: Foreign-born only")

graph save Graph "Fig 3b.gph", replace


graph combine "Fig 3b.gph" "Fig 3b.gph" "Fig 3a.gph", t1(Law indicator) t2(Policy knowledge) cols(3)  graphregion(margin(zero))  scheme(s1mono) //need to be configurated manually



esttab  po_sit_nat_f_disA po_sit_nat_f_dis po_sit_gender_f_disA  po_sit_gender_f_dis po_sit_first_f_disA po_sit_first_f_dis ///
using "Table_2a.rtf", b(3)  star(* 0.05 ** 0.01 )  se   stats(N r2) transform(ln*: exp(@) exp(@)) replace

esttab  polcon_nat_f_disA polcon_nat_f_dis polcon_gender_f_disA polcon_gender_f_dis polcon_first_f_disA polcon_first_f_dis ///
 satdem_nat_f_disA satdem_nat_f_dis satdem_gender_f_disA satdem_gender_f_dis satdem_first_f_disA satdem_first_f_dis ///
using "Table_2b.rtf", b(3)  star(* 0.05 ** 0.01 )  se   stats(N r2) transform(ln*: exp(@) exp(@)) replace













