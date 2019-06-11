#delimit ;
set logtype text;
log using varep.out, replace;

infile aapor abori aborl aborlc abortd abortdc abortdg abortdgc abortr abortrc 
  abortrg abortrgc btherm bushrate campint canflag cari carint carl carlc 
  carsd carsdc carsdg carsdgc carsr carsrc carsrg carsrgc cheney consprot 
  demcther divgov econ2b econ2w econi econint econl econlc econod econodc 
  econodg econodgc economy econor econorc econorg econorgc educ educd educdc 
  educdg educdgc educr educrc educrg educrgc edui eduint edul edulc fips 
  fovermaj govinfl govlean govrate govveto1 govveto2 govvflag govvote guni 
  gunint gunl gunlc gunsd gunsdc gunsdg gunsdgc gunsr gunsrc gunsrg gunsrgc 
  hispanic ideob ideobc ideod ideodc ideodg ideodgc ideoi ideoint ideol 
  ideolc ideor ideorc ideorg ideorgc ifdem ifearl ifrep ifwarn income infl 
  infl2g infl2l infleq intdate intherm issuflag lean mii mii2 morecons motive 
  nsthmadc nsthmaj nsthmarc nstsmadc nstsmaj nstsmarc numvote nwspaper party 
  pctseadh pctseads pctsearh pctsears poldo race_1 race_2 race_3 race_4 race_5 
  race_6 race_7 reg religion repcther respnum rgender sct source stgov sthmaj 
  stltgov strengtd strengtr stsen stsen2 stsmaj taxesd taxesdc taxesdg 
  taxesdgc taxesr taxesrc taxesrg taxesrgc taxi taxint taxl taxlc terrfd 
  terrfdc terrfdg terrfdgc terrfr terrfrc terrfrg terrfrgc terri terrint 
  terrl terrlc time_ trani tranint tranl tranlc transd transdc transdg 
  transdgc transr transrc transrg transrgc ushmaj votelike whynotdo yrborn 
  yrsresid
  using elect01vafin.asc;
set more off;

/* ANES question for New Jersey (Table 3 and "depends" on page 11) */

tab divgov;

/* create preference orderings from the conditional questions */

/* separable preference orderings */
/* RR [RD DR] DD -- sep pref for R pres R cong
RR P RD, DR P DD, RR P DR, RD P DD */
gen cprefrank=1 if ifearl==2 & ifwarn==2 & ifrep==2 & ifdem==2;

/* DD [DR RD] RR -- sep pref for D pres D cong
RD P RR, DD P DR, DR P RR, DD P RD */
replace cprefrank=3 if ifearl==1 & ifwarn==1 & ifrep==1 & ifdem==1;

/* RD [RR DD] DR -- sep pref for R pres D cong 
RD P RR, DD P DR,  RR P DR, RD P DD */
replace cprefrank=5 if ifearl==1 & ifwarn==1 & ifrep==2 & ifdem==2;

/* DR [DD RR] RD -- sep pref for D pres R cong
RR P RD, DR P DD, DR P RR, DD P RD */
replace cprefrank=7 if ifearl==2 & ifwarn==2 & ifrep==1 & ifdem==1;

/* [DD RR] [RD DR] -- unified government
RR P RD, DD P DR, RR P DR, DD P RD */
replace cprefrank=9 if ifearl==2 & ifwarn==1 & ifrep==2 & ifdem==1;

/* non-separable preference orderings */
/* [DR RD] [DD RR] -- divided government
RD P RR, DR P DD, DR P RR, RD P DD */
replace cprefrank=13 if ifearl==1 & ifwarn==2 & ifrep==1 & ifdem==2;

/* partially-separable preference orderings */
/* RR DR DD RD
 RR P RD, DR P DD, RR P DR, DD P RD */
replace cprefrank=17 if ifearl==2 & ifwarn==2 & ifrep==2 & ifdem==1;

/* DD RD RR DR
 RD P RR, DD P DR, RR P DR, DD P RD */
replace cprefrank=18 if ifearl==1 & ifwarn==1 & ifrep==2 & ifdem==1;

/* RR RD DD DR
RR P RD, DD P DR, RR P DR, RD P DD */
replace cprefrank=19 if ifearl==2 & ifwarn==1 & ifrep==2 & ifdem==2;

/* DD DR RR RD
RR P RD, DD P DR, DR P RR, DD P RD */
replace cprefrank=20 if ifearl==2 & ifwarn==1 & ifrep==1 & ifdem==1;

/* RD DD DR RR
RD P RR, DD P DR, DR P RR, RD P DD */
replace cprefrank=21 if ifearl==1 & ifwarn==1 & ifrep==1 & ifdem==2;

/* DR RR RD DD
RR P RD, DR P DD, DR P RR, RD P DD */
replace cprefrank=22 if ifearl==2 & ifwarn==2 & ifrep==1 & ifdem==2;

/* RD RR DR DD
RD P RR, DR P DD, RR P DR, RD P DD */
replace cprefrank=23 if ifearl==1 & ifwarn==2 & ifrep==2 & ifdem==2;

/* DR DD RD RR
RD P RR, DR P DD, DR P RR, DD P RD */
replace cprefrank=24 if ifearl==1 & ifwarn==2 & ifrep==1 & ifdem==1;

/* intransitive preferences
RR P RD, DD P DR, DR P RR, RD P DD */
replace cprefrank=25 if ifearl==2 & ifwarn==1 & ifrep==1 & ifdem==2;

/* RD P RR, DR P DD, RR P DR, DD P RD */
replace cprefrank=26 if ifearl==1 & ifwarn==2 & ifrep==2 & ifdem==1;

replace cprefrank=27 if ifearl==3 | ifwarn==3 | ifrep==3 | ifdem==3;

label variable cprefrank "Gov Preference Rank";
label define cprefv  1 "Sep Rep" 3 "Sep Dem" 5 "Sep DG (RD)" 
  7 "Sep DG (DR)" 9 "Non-sep unified" 13 "Non-sep divided" 17 "part
  sep unified (17)" 18 "part sep unified (18)" 
  19 "part sep unified (19)" 20 "part sep unified (20)" 
  21 "part sep divided (21)" 22 "part sep divide (22)" 
  23 "part sep divided (23)" 24 "part sep divided (24)" 25
  "intrasitive" 26 "instransitve" 27 "doesn't matter"; 
label values cprefrank cprefv;

/* Table 4 */

tab cprefrank if cprefrank>=1 & cprefrank<=26;
tab cprefrank;

/* create party identification */

gen partyid=0 if strengtd==1;
replace partyid=1 if strengtd==2;
replace partyid=2 if lean==3;
replace partyid=3 if lean==2;
replace partyid=4 if lean==1;
replace partyid=5 if strengtr==2;
replace partyid=6 if strengtr==1;

/* strong partisans' unconditional preferences (page 12) */ 

tab divgov if partyid==0; tab divgov if partyid==6;

/* Strong partisans' conditional preferences (page 12) */ 

tab cprefrank if partyid==0; tab cprefrank if partyid==6;

/* partisan conditional responses for unconditional "doesn't matter"
(page 12) */

tab cprefrank if divgov==3;

/* "doesn't matter" conditional responses  (page 12) */

gen onecond=(ifwarn==3 | ifearl==3 | ifdem==3 | ifrep==3);

tab onecond if divgov==3;

log close;
