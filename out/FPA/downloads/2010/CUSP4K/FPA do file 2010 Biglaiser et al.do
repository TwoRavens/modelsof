    
*** Foreign Policy Analysis article 
*** Aug 18 2010
*** Biglaiser, DeRouen, and Archer
*** The 'xtlogit' models below were run to check for FE; to replicate Table 2 findings in paper 
*** replace xtlogit with the 'relogit' command; note that not all Hausman tests would run;
*** the Table 3 relogit models are included with the relogit commands as reported in paper


****MOODY'S

 clear
set mem 333m
 
use "C:\Documents and Settings\kderouen\My Documents\biglaiser\fpa bond paper\curr crises _no repeats 10-08-08.dta", clear
 
 tsset  countrydummy year, yearly
   
gen moodyl1             = L.moody
gen moodyl2             = L.moodyl1
tssmooth ma moodyma     = moody, window(2 1)
tssmooth ma moodymal    = moodyl1, window(2 1)
gen defaultl            = L.bonddefaultunlagged
gen corruptl            = L.corruption_icrg
gen govstabl            = L.govstab_icrg
gen oppsenatel          = L.oppositionpartymajoritysenateorh
gen orderl              = L.lawandorder_icrg
gen exchangel           = L.realexchrate
gen moodyc              = moody-moodyl1
gen currcrisl           = L.cur_crises_f_r_update
gen bankdefl            = L.for_curr_bank_default_s_p
gen bondefl             = L.bonddefaultunlagged
gen govspendl           = L.govtfinalexpend_gdp
gen stabilityl		= L.govstab_icrg
gen moodycl=L.moodyc


recode year (1994=1) (1980/1993=0) (1995/2006=0) ,gen(y94) 
recode year (1995=1) (1980/1994=0) (1996/2006=0) ,gen(y95) 
recode year (1997=1) (1980/1996=0) (1998/2006=0) ,gen(y97) 
recode year (1998=1) (1980/1997=0) (1999/2006=0) ,gen(y98) 
recode year (2001=1) (1980/2000=0) (2002/2006=0) ,gen(y01) 
recode year (2002=1) (1980/2001=0) (2003/2006=0) ,gen(y02) 
 
 drop if moody == .


xtlogit cur_crises_f_r_update cpilagged  govspendl ///
  currentaccountbalanceofgdplagged gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
  tradeexportsimportsgdpl externaldebttotaldodcurrentuslag , nolog
est store re

xtlogit cur_crises_f_r_update cpilagged  govspendl ///
  currentaccountbalanceofgdplagged gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
  tradeexportsimportsgdpl externaldebttotaldodcurrentuslag   , fe nolog
  
hausman . re

xtlogit cur_crises_f_r_update politylagged cpilagged honeymoonl stabilityl govspendl ///
   currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  , nolog
est store re

  
xtlogit cur_crises_f_r_update politylagged cpilagged honeymoonl stabilityl govspendl ///
   currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  , fe nolog
  
hausman . re

xtlogit cur_crises_f_r_update politylagged cpilagged honeymoonl stabilityl govspendl ///
  currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
 tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  ,     nolog

est store re

xtlogit cur_crises_f_r_update politylagged cpilagged honeymoonl stabilityl govspendl ///
  currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
 tradeexportsimportsgdpl externaldebttotaldodcurrentuslag    , fe  nolog

hausman . re


*
relogit cur_crises_f_r_update moodyl1  , cluster(countrydummy)
setx mean
relogitq
relogitq, fd(pr) changex(moodyl1 p95 p5)

relogit cur_crises_f_r_update moodycl   , cluster(countrydummy)
setx mean
relogitq
relogitq, fd(pr) changex(moodycl p95 p5)

relogit cur_crises_f_r_update moodymal , cluster(countrydummy)
setx mean
relogitq
relogitq, fd(pr) changex(moodymal p95 p5)
*



 ****
 clear

use "C:\Documents and Settings\kderouen\My Documents\biglaiser\fpa bond paper\bond defaults _no repeats 10-08-08.dta", clear
 
 
tsset  countrydummy year, yearly
gen moodyl1             = L.moody
gen moodyl2             = L.moodyl1
tssmooth ma moodyma     = moody, window(2 1)
tssmooth ma moodymal    = moodyl1, window(2 1)
gen defaultl            = L.bonddefaultunlagged
gen corruptl            = L.corruption_icrg
gen govstabl            = L.govstab_icrg
gen oppsenatel          = L.oppositionpartymajoritysenateorh
gen orderl              = L.lawandorder_icrg
gen exchangel           = L.realexchrate
gen moodyc              = moody-moodyl1
gen currcrisl           =L.cur_crises_f_r_update
gen bankdefl            =L.for_curr_bank_default_s_p
gen bondefl             =L.bonddefaultunlagged
gen stabilityl		=L.govstab_icrg
gen govspendl		= L.govtfinalexpend_gdp

gen moodycl=L.moodyc

recode year (1994=1) (1980/1993=0) (1995/2006=0) ,gen(y94) 
recode year (1995=1) (1980/1994=0) (1996/2006=0) ,gen(y95) 
recode year (1997=1) (1980/1996=0) (1998/2006=0) ,gen(y97) 
recode year (1998=1) (1980/1997=0) (1999/2006=0) ,gen(y98) 
recode year (2001=1) (1980/2000=0) (2002/2006=0) ,gen(y01) 
recode year (2002=1) (1980/2001=0) (2003/2006=0) ,gen(y02) 

drop if moody == .

xtlogit bonddefaultunlagged cpilagged  govspendl ///
  currentaccountbalanceofgdplagged gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
  tradeexportsimportsgdpl externaldebttotaldodcurrentuslag   , nolog
  
est store re

xtlogit bonddefaultunlagged cpilagged  govspendl ///
  currentaccountbalanceofgdplagged gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
  tradeexportsimportsgdpl externaldebttotaldodcurrentuslag   , fe nolog 
  
hausman . re

xtlogit bonddefaultunlagged politylagged cpilagged honeymoonl stabilityl govspendl ///
  currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag , nolog
est store re
  
xtlogit bonddefaultunlagged politylagged cpilagged honeymoonl stabilityl govspendl ///
  currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag , fe nolog
hausman . re  

xtlogit bonddefaultunlagged politylagged cpilagged honeymoonl stabilityl govspendl ///
  currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  , nolog
est store re
  
xtlogit bonddefaultunlagged politylagged cpilagged honeymoonl stabilityl govspendl ///
  currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  , fe nolog
hausman . re


*
relogit bonddefaultunlagged moodyl1  , cluster(countrydummy)
setx mean
relogitq
relogitq, fd(pr) changex(moodyl1 p95 p5)

relogit bonddefaultunlagged moodycl  , cluster(countrydummy)
setx mean
relogitq
relogitq, fd(pr) changex(moodycl p95 p5)

relogit bonddefaultunlagged moodymal , cluster(countrydummy)
setx mean
relogitq
relogitq, fd(pr) changex(moodymal p95 p5)
 *  

 *************************************
 *SP
 clear


use "C:\Documents and Settings\kderouen\My Documents\biglaiser\fpa bond paper\curr crises _no repeats 10-08-08.dta", clear
 
 tsset  countrydummy year, yearly
      

gen spl1			= L.sp
gen spl2			= L.spl1
tssmooth ma spmal  	= spl1, window(2 1)
tssmooth ma spma  	= sp, window(2 1)
gen defaultl		= L.bonddefaultunlagged
gen corruptl		= L.corruption_icrg
gen govstabl		= L.govstab_icrg
gen oppsenatel		= L.oppositionpartymajoritysenateorh
gen orderl			= L.lawandorder_icrg
gen exchangel		= L.realexchrate
gen currcrisl		=L.cur_crises_f_r_update
gen bankdefl		=L.for_curr_bank_default_s_p
gen bondefl			=L.bonddefaultunlagged
gen spc			=sp-spl1
gen stabilityl		=L.govstab_icrg
gen govspendl		= L.govtfinalexpend_gdp
gen spcl=L.spc

recode year (1994=1) (1980/1993=0) (1995/2006=0) ,gen(y94) 
recode year (1995=1) (1980/1994=0) (1996/2006=0) ,gen(y95) 
recode year (1997=1) (1980/1996=0) (1998/2006=0) ,gen(y97) 
recode year (1998=1) (1980/1997=0) (1999/2006=0) ,gen(y98) 
recode year (2001=1) (1980/2000=0) (2002/2006=0) ,gen(y01) 
recode year (2002=1) (1980/2001=0) (2003/2006=0) ,gen(y02)

drop if sp == .

xtlogit cur_crises_f_r_update cpilagged  govspendl ///
   currentaccountbalanceofgdplagged gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag   , nolog

est store re

xtlogit cur_crises_f_r_update cpilagged  govspendl ///
   currentaccountbalanceofgdplagged gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag   , fe nolog

hausman . re
  
xtlogit cur_crises_f_r_update politylagged cpilagged honeymoonl stabilityl govspendl ///
   currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag , nolog
est store re

xtlogit cur_crises_f_r_update politylagged cpilagged honeymoonl stabilityl govspendl ///
   currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  ,  fe nolog
hausman . re
 
xtlogit cur_crises_f_r_update politylagged cpilagged honeymoonl stabilityl govspendl ///
   currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  , nolog
est store re

xtlogit cur_crises_f_r_update politylagged cpilagged honeymoonl stabilityl govspendl ///
   currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  ,  fe nolog
hausman . re

*
relogit cur_crises_f_r_update spl1  , cluster(countrydummy)
setx mean
relogitq
relogitq, fd(pr) changex(spl1 p95 p5)

relogit cur_crises_f_r_update spcl   , cluster(countrydummy)
setx mean
relogitq
relogitq, fd(pr) changex(spcl p95 p5)

relogit cur_crises_f_r_update spmal  , cluster(countrydummy)
setx mean
relogitq
relogitq, fd(pr) changex(spmal p95 p5)
*



**

clear

use "C:\Documents and Settings\kderouen\My Documents\biglaiser\fpa bond paper\bond defaults _no repeats 10-08-08.dta", clear
 
 tsset  countrydummy year, yearly
      

gen spl1			= L.sp
gen spl2			= L.spl1
tssmooth ma spmal  	= spl1, window(2 1)
tssmooth ma spma  	= sp, window(2 1)
gen defaultl		= L.bonddefaultunlagged
gen corruptl		= L.corruption_icrg
gen govstabl		= L.govstab_icrg
gen oppsenatel		= L.oppositionpartymajoritysenateorh
gen orderl			= L.lawandorder_icrg
gen exchangel		= L.realexchrate
gen currcrisl		=L.cur_crises_f_r_update
gen bankdefl		=L.for_curr_bank_default_s_p
gen bondefl			=L.bonddefaultunlagged
gen spc			=sp-spl1
gen stabilityl		=L.govstab_icrg
gen govspendl		= L.govtfinalexpend_gdp
recode year (1994=1) (1980/1993=0) (1995/2006=0) ,gen(y94) 
recode year (1995=1) (1980/1994=0) (1996/2006=0) ,gen(y95) 
recode year (1997=1) (1980/1996=0) (1998/2006=0) ,gen(y97) 
recode year (1998=1) (1980/1997=0) (1999/2006=0) ,gen(y98) 
recode year (2001=1) (1980/2000=0) (2002/2006=0) ,gen(y01) 
recode year (2002=1) (1980/2001=0) (2003/2006=0) ,gen(y02)
gen spcl=L.spc

drop if sp == .


xtlogit bonddefaultunlagged cpilagged  govspendl ///
   currentaccountbalanceofgdplagged gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  , nolog
est store re

xtlogit bonddefaultunlagged cpilagged  govspendl ///
   currentaccountbalanceofgdplagged gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  ,   fe nolog
hausman . re
 
xtlogit bonddefaultunlagged politylagged cpilagged honeymoonl stabilityl govspendl ///
   currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  , nolog
est store re

xtlogit bonddefaultunlagged politylagged cpilagged honeymoonl stabilityl govspendl ///
   currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  ,  fe nolog
hausman . re
 
xtlogit bonddefaultunlagged politylagged cpilagged honeymoonl stabilityl govspendl ///
   currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  , nolog
est store re

xtlogit bonddefaultunlagged politylagged cpilagged honeymoonl stabilityl govspendl ///
   currentaccountbalanceofgdplagged corruptl   gdpgrowthannuallagged gdppercapitaconstant2000uslagged ///
   tradeexportsimportsgdpl externaldebttotaldodcurrentuslag  , fe nolog
hausman . re

*
relogit bonddefaultunlagged spl1  , cluster(countrydummy)
setx mean
relogitq
relogitq, fd(pr) changex(spl1 p95 p5)

relogit bonddefaultunlagged spcl   , cluster(countrydummy)
setx mean
relogitq
relogitq, fd(pr) changex(spcl p95 p5)

relogit bonddefaultunlagged spmal , cluster(countrydummy)
setx mean
relogitq
relogitq, fd(pr) changex(spmal p95 p5)
*