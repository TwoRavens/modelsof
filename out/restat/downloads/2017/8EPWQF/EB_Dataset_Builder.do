						*** Eurobarometer Life Satisfaction Dataset ***
/*	
	 George Ward

The Eurobarometer has been running from 1973, but a life satisfaction question has not been asked in all of the rounds.  
A full list of the rounds in which it has been asked can be found at:

http://www.gesis.org/en/eurobarometer/topics-trends/eb-trends-trend-files/list-of-trends/life-satisf/

In this .do file I take the Mannheim Trend file 1973-2002, fill in the gaps, and extend it to 2013.

Download the relevant Eurobarometer datafiles from zacat.gesis.org/webview and place them in a folder somewhere.  These files are not
provided here, since you have to sign up and agree to the terms of use, etc. 

Set this folder containing the raw EB files as the working directory. 	

Buckle up, this is going to be a long and annoying process.														*/

cd  "/Users/wardg/Documents/Raw Data/Original_EBs/"
clear
set more off

*************
use "ZA2828_F1.dta" /* Open Data for Eurobarometer 44.2bis*/

gen eb = 442
gen year = 1996
gen month = 2
rename v604 date_interview 

rename v5 id_original
rename v2 study_id
rename v8 country
rename v9 wnation
rename v7 wuk
rename v37 satislfe
rename v554 age
rename v550 marital_status
rename v551 education
recode education (0=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/80=9), gen(educ_10cat)
rename v553 sex

/* In this wave Finland, Sweden and Austria are coded differently to elsewhere in the EB */
recode country (15=16) (16=17) (17=18)

keep eb year month date_interview id_original study_id country wnation wuk satislfe age marital_status educ_10cat sex 



save	"44.2.dta"	, replace		
*************


*************
use "ZA3693_F1.dta"	/*	Open Data for Eurobarometer 58.1*/

gen eb = 581
gen year = 2002
gen month = 10
rename v448 date_interview 

rename v5 id_original
rename v2 study_id
rename v8 country
rename v9 wnation
rename v7 wuk
rename v40 satislfe
rename v42 expec_econsit
rename v420 age
rename v416 marital_8cat
recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
rename v417 education
recode education (98=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/80=9), gen(educ_10cat)
rename v419 sex

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
age marital_8cat marital_status  educ_10cat sex 

save	"58.1.dta"	, replace
*************


*************
use "ZA3938_F1.dta"	/*	Open Data for Eurobarometer60.1	*/

gen eb = 601
gen year = 2003
gen month = 10
rename v626 date_interview 

rename v5 id_original
rename v2 study_id
rename v8 country
rename v9 wnation
rename v7 wuk
rename v38 satislfe
rename v40 expec_econsit
rename v598 age
rename v594 marital_8cat
recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
rename v595 education
recode education (98=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/80=9), gen(educ_10cat)
rename v597 sex
 
keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_8cat marital_status educ_10cat sex 


save	"60.1.dta"	, replace
*************


*************
use "ZA4229_F1.dta"	/*	Open Data for Eurobarometer62.0	*/

gen eb = 620
gen year = 2004
gen month = 10
rename v445 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v69 satislfe
rename v71 expec_econsit
rename v429 age
rename v425 marital_8cat
rename v426 education
rename v428 sex

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit age marital_8cat  ///
sex  marital_status educ_10cat

save	"62.0.dta"	, replace
*************


*************
use "ZA4231_F1.dta"	/*	Open Data for Eurobarometer62.2	*/

gen eb = 622
gen year = 2004
gen month = 11
rename v493 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
recode v219 (5/6=.)
rename v219 satislfe
rename v471 age
rename v467 marital_8cat
rename v468 education
rename v470 sex

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe age marital_8cat education sex marital_status educ_10cat

save	"62.2.dta"	, replace
*************


*************
use "ZA4411_F1.dta"	/*	Open Data for Eurobarometer63.4	*/

gen eb = 634
gen year = 2005
gen month = 5
rename v584 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v69 satislfe
rename v71 expec_econsit
rename v411 age
rename v407 marital_8cat
rename v408 education
rename v410 sex

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9) (97=1), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_8cat education sex  marital_status educ_10cat

save	"63.4.dta"	, replace
*************


*************
use "ZA4414_F1.dta"	/*	Open Data for Eurobarometer64.2	*/

gen eb = 642
gen year = 2005
gen month = 10
rename v3309 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v75 satislfe
rename v77 expec_econsit

rename v440 age
rename v436 marital_8cat
rename v437 education
rename v439 sex
recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_8cat education sex  marital_status educ_10cat

save	"64.2.dta"	, replace
*************


*************
use "ZA4506_F1.dta"	/*	Open Data for Eurobarometer65.2	*/

gen eb = 652
gen year = 2006
gen month = 3
rename v3342 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v73 satislfe
rename v75 expec_econsit
rename v3311 age
rename v3307 marital_8cat
rename v3308 education
rename v3310 sex

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_8cat education sex marital_status educ_10cat


save	"65.2.dta"	, replace
*************


*************
use "ZA4526_F1.dta"	/*	Open Data for Eurobarometer66.1	*/

gen eb = 661
gen year = 2006
gen month = 9
rename v491 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v75 satislfe
rename v77 expec_econsit
rename v463 age
rename v459 marital_8cat
rename v460 education
rename v462 sex

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
  age marital_8cat education sex   marital_status educ_10cat


save	"66.1.dta"	, replace
*************


*************
use "ZA4530_F1.dta"	/*	Open Data for Eurobarometer67.2	*/

gen eb = 672
gen year = 2007
gen month = 4
rename v579 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v83 satislfe
rename v85 expec_econsit
rename v549 age
rename v545 marital_8cat
rename v546 education
rename v548 sex

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_8cat education sex  marital_status educ_10cat


save	"67.2.dta"	, replace
*************


*************
use "ZA4565_F1.dta"	/*	Open Data for Eurobarometer68.1	*/

gen eb = 681
gen year = 2007
gen month = 9
rename v3968 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v87 satislfe
rename v98 expec_econsit
rename v421 age
rename v417 marital_8cat
rename v418 education
rename v420 sex

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_8cat education sex   marital_status educ_10cat


save	"68.1.dta"	, replace
*************


*************
use "ZA4744_F1.dta"	/*	Open Data for Eurobarometer 69.2	*/


gen eb = 692
gen year = 2008
gen month = 3
rename v798 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v88 satislfe
rename v90 expec_econsit
* CORRECT rename v768 age
rename v468 age
rename v764 marital_8cat
rename v765 education
rename v767 sex

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_8cat education sex  marital_status educ_10cat

save	"69.2.dta"	, replace
*************


*************
use "ZA4819_F1.dta"	/*	Open Data for Eurobarometer70.1	*/

gen eb = 701
gen year = 2008
gen month = 10
rename v699 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v88 satislfe
rename v124 expec_econsit
rename v671 age
rename v667 marital_8cat
rename v668 education
rename v670 sex

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_8cat education sex  marital_status educ_10cat

save	"70.1.dta"	, replace
*************


*************
use "ZA4971_F1.dta"	/*	Open Data for Eurobarometer71.1	*/

gen eb = 711
gen year = 2009
gen month = 2
rename v675 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v90 satislfe
rename v104 expec_econsit
rename v645 age
rename v641 marital_8cat
rename v642 education
rename v644 sex

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_8cat education sex  marital_status educ_10cat

save	"71.1.dta"	, replace
*************


*************
use "ZA4972_F1.dta"	/*	Open Data for Eurobarometer71.2	*/

gen eb = 712
gen year = 2009
gen month = 5
rename v459 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v84 satislfe
rename v110 expec_econsit
rename v428 age
rename v424 marital_14cat
rename v425 education
rename v427 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex  marital_status educ_10cat


save	"71.2.dta"	, replace
*************


*************
use "ZA4973_F1.dta"	/*	Open Data for Eurobarometer71.3	*/

gen eb = 713
gen year = 2009
gen month = 6
rename v701 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v104 satislfe
rename v120 expec_econsit
rename v666 age
rename v662 marital_14cat
rename v663 education
rename v665 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex  marital_status educ_10cat


save	"71.3.dta"	, replace
*************


*************
use "ZA4994_F1.dta"	/*	Open Data for Eurobarometer72.4	*/

gen eb = 724
gen year = 2009
gen month = 10
rename v606 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v84 satislfe
rename v112 expec_econsit
rename v585 age
rename v580 marital_14cat
rename v582 education
rename v584 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex  marital_status educ_10cat

save	"72.4.dta"	, replace
*************


*************
use "ZA5234_F1.dta"	/*	Open Data for Eurobarometer73.4	*/

gen eb = 734
gen year = 2010
gen month = 5
rename v581 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v91 satislfe
rename v123 expec_econsit
rename v556 age
rename v551 marital_14cat
rename v553 education
rename v555 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex  marital_status educ_10cat

save	"73.4.dta"	, replace
*************


*************
use "ZA5235_F1.dta"	/*	Open Data for Eurobarometer73.5	*/

gen eb = 735
gen year = 2010
gen month = 6
rename v417 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v70 satislfe
rename v96 expec_econsit
rename v386 age
rename v381 marital_14cat
rename v383 education
rename v385 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex  marital_status educ_10cat

save	"73.5.dta"	, replace
*************


*************
use "ZA5449_F1.dta"	/*	Open Data for Eurobarometer74.2	*/

gen eb = 742
gen year = 2010
gen month = 11
rename v626 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v91 satislfe
rename v109 expec_econsit
rename v603 age
rename v597 marital_14cat
rename v600 education
rename v602 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex marital_status educ_10cat

save	"74.2.dta"	, replace
*************

/* The following Eurobarometers are pre-releases, at the time of coding */
*************
use "ZA5481_F1.dta"	/*	Open Data for Eurobarometer75.3	*/

gen eb = 753
gen year = 2011
gen month = 5
rename V651 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v109 satislfe
rename v127 expec_econsit
rename v616 age
rename v610 marital_14cat
rename v613 education
rename v615 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex  marital_status educ_10cat

save	"75.3.dta"	, replace
*************


*************
use "ZA5564_F1.dta"	/*	Open Data for Eurobarometer75.4	*/

gen eb = 754
gen year = 2011
gen month = 6
rename V631 date_interview

rename V5 id_original
rename V2 study_id
rename V6 country
rename V8 wnation
rename V10 wuk
rename V186 satislfe
rename V212 expec_econsit
rename V595 age
rename V588 marital_14cat
rename V592 education
rename V594 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex   marital_status educ_10cat

save	"75.4.dta"	, replace
*************


*************
use "ZA5567_F1.dta"	/*	Open Data for Eurobarometer76.3	*/

gen eb = 763
gen year = 2011
gen month = 11
rename p1 date_interview

rename caseid id_original
rename archive2 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)
rename qa5a_2 expec_econsit
rename vd11 age
rename d7 marital_14cat
rename vd8 education
rename d10 sex

recode expec_econsit (4=.)
recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (0=10) (99=.) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9) (98/99=.), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex marital_status educ_10cat

save	"76.3.dta"	, replace
*************


*************
use "ZA5612_F1.dta"	/*	Open Data for Eurobarometer77.3	*/

gen eb = 773
gen year = 2012
gen month = 5

rename caseid id_original
rename archive2 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)
rename qa5a_2 expec_econsit
rename vd11 age
rename d7 marital_14cat
rename vd8 education
rename d10 sex

recode expec_econsit (4=.)
recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=.) (99=.) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9) (0=10), gen(educ_10cat)

keep eb year month  id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex  marital_status educ_10cat

save	"77.3.dta"	, replace
*************


*************
use "ZA5613_F1.dta"	/*	Open Data for Eurobarometer77.4	*/
gen eb = 774
gen year = 2012
gen month = 6

rename caseid id_original
rename archive2 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qb1 satislfe
recode satislfe (5=.)
rename qb3_12 expec_econsit
rename vd11 age
rename d7 marital_14cat
rename vd8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=.) (99=.) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9) (0=10), gen(educ_10cat)
recode expec_econsit (4=.)

keep eb year month  id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex  marital_status educ_10cat
save	"77.4.dta"	, replace
*************


*************
use "ZA5685_F1.dta"	/*	Open Data for Eurobarometer78.1	*/
gen eb = 781
gen year = 2012
gen month = 11
rename p1 date_interview

rename CASEID id_original
rename ARCHIVE2 study_id
rename COUNTRY country
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)
rename qa4a_2 expec_econsit
rename vd11 age
rename d7 marital_14cat
rename vd8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=.) (99=.) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9) (0=10), gen(educ_10cat)
recode expec_econsit (4=.)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex  marital_status educ_10cat

save	"78.1.dta"	, replace
*************

use "ZA5689_v1-0-0.dta"	/*	Open Data for Eurobarometer 79.3	*/
gen eb = 793
gen year = 2013
gen month = 5
rename p1 date_interview

rename caseid id_original
rename studyno1 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)
rename qa4a_2 expec_econsit
rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/99=.), gen(marital_status)
recode education (98=10) (99=.) (0/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9) (97=10), gen(educ_10cat)
recode expec_econsit (4=.)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
 age marital_14cat education sex  marital_status educ_10cat

save	"79.3.dta"	, replace
*****************

use "ZA5876_v1-0-0.dta"	/*	Open Data for Eurobarometer 79.3	*/
gen eb = 801
gen year = 2013
gen month = 11
rename p1 date_interview

rename caseid id_original
rename studyno1 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)
rename qa3a_2 expec_econsit
rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/99=.), gen(marital_status)
recode education (98=10) (99=.) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9) (0=.), gen(educ_10cat)
recode expec_econsit (4=.)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  expec_econsit  ///
  age marital_14cat education sex marital_status educ_10cat

save	"80.1.dta"	, replace
************


use "ZA5877_v1-0-0.dta"	/*	Open Data for Eurobarometer 79.3	*/
gen eb = 802
gen year = 2013
gen month = 12
rename p1 date_interview

rename caseid id_original
rename studyno1 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename d70 satislfe
recode satislfe (5=.)
rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/100=.), gen(marital_status)
recode education (99=.) (0=.) (97=1) (98=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
  age marital_14cat education sex  marital_status educ_10cat

save	"80.2.dta"	, replace
************









********************************************************************************


*************
/* Recode the Mannheim Trend File so that it is consistent with the other files about to merged with it */

use "ZA3521_F1.dta" /* 	Open Trend File 	*/

recode married (9/10=.), gen(marital_status)
rename educ educ_10cat
rename nation1 country
rename id id_original

/* The trend file includes several waves that do not include a life satisfaction question.
	These waves are dropped from the analysis */

drop if satislfe == .

/* The Trend file does not have the fieldwork month. This is added for each wave (source: EB website) */

gen month = .
replace month =	9	if eb ==	3
replace month =	5	if eb ==	30
replace month =	10	if eb ==	40
replace month =	5	if eb ==	50
replace month =	11	if eb ==	60
replace month =	4	if eb ==	70
replace month =	10	if eb ==	80
replace month =	5	if eb ==	90
replace month =	10	if eb ==	100
replace month =	4	if eb ==	110
replace month =	4	if eb ==	130
replace month =	4	if eb ==	150
replace month =	3	if eb ==	170
replace month =	10	if eb ==	180
replace month =	3	if eb ==	190
replace month =	10	if eb ==	200
replace month =	3	if eb ==	210
replace month =	10	if eb ==	220
replace month =	3	if eb ==	230
replace month =	10	if eb ==	240
replace month =	3	if eb ==	250
replace month =	10	if eb ==	260
replace month =	4	if eb ==	270
replace month =	10	if eb ==	280
replace month =	3	if eb ==	290
replace month =	3	if eb ==	310
replace month =	7	if eb ==	311
replace month =	10	if eb ==	320
replace month =	11	if eb ==	321
replace month =	3	if eb ==	330
replace month =	10	if eb ==	340
replace month =	11	if eb ==	341
replace month =	3	if eb ==	350
replace month =	11	if eb ==	360
replace month =	3	if eb ==	370
replace month =	4	if eb ==	371
replace month =	9	if eb ==	380
replace month =	11	if eb ==	381
replace month =	3	if eb ==	390
replace month =	10	if eb ==	400
replace month =	4	if eb ==	410
replace month =	11	if eb ==	420
replace month =	4	if eb ==	431
replace month =	3	if eb ==	471
replace month =	4	if eb ==	490
replace month =	10	if eb ==	520
replace month =	11	if eb ==	521
replace month =	4	if eb ==	530
replace month =	11	if eb ==	541
replace month =	4	if eb ==	551
replace month =	9	if eb ==	561
replace month =	10	if eb ==	562
replace month =	3	if eb ==	571


save "trend.dta", replace

*************

********************************************************************************

/* Combine all of the non-trend file waves to form a 2003-2012 trend dataset */

clear
use  "44.2.dta"
save "non_trend.dta", replace

append using	"58.1.dta"
append using	"60.1.dta"
append using	"62.0.dta"
append using	"62.2.dta"
append using	"63.4.dta"
append using	"64.2.dta"
append using	"65.2.dta"
append using	"66.1.dta"
append using	"67.2.dta"
append using	"68.1.dta"
append using	"69.2.dta"
append using	"70.1.dta"
append using	"71.1.dta"
append using	"71.2.dta"
append using	"71.3.dta"
append using	"72.4.dta"
append using	"73.4.dta"
append using	"73.5.dta"
append using	"74.2.dta"
append using	"75.3.dta"
append using	"75.4.dta"
append using	"76.3.dta"
append using	"77.3.dta"
append using	"77.4.dta"
append using	"78.1.dta"
append using	"79.3.dta"
append using	"80.1.dta"
append using	"80.2.dta"


save "non_trend.dta", replace

/* combine this non-trend file with the original trend file */

append using "trend.dta"

keep study_id id_original wuk country wnation satislfe  marital_status education sex ///
 age  date_interview   eb year month educ_10cat educrec expec_econsit  marital_8cat  marital_14cat wsample  

 sort country eb id_original 

gen id = _n

gen day = 1 
gen survey_date = mdy(month, day, year) 
format survey_date %td
drop month day year
gen survey_month = mofd(survey_date)
format survey_month %tm
gen survey_quarter = qofd(survey_date)
format survey_quarter %tq
gen year = yofd(survey_date)

* The Life Satisfaction variable is coded counter-intuitively.
recode satislfe (4=1) (3=2) (2=3) (1=4)
label define Satisfaction 1 "Not at all satisfied" 2 "Not very satisfied " 3 "Fairly satisfied" 4 "Very satisfied"
label values satislfe Satisfaction

* The expectations questions are coded slightly oddly. At the moment 1=better, 2=worse, 3=same, 4=DK
* Let's recode it to be more intuitive

label define Expectations 1 "Worse" 2 "Same" 3 "Better"
 recode expec_econsit (2=1) (3=2) (1=3) (4/100=.)
label values expec_econsit Expectations

gen econexpec_worse = (expec_econsit==1) if expec_econsit!=. 
gen econexpec_same = (expec_econsit==2) if expec_econsit!=.
gen econexpec_better = (expec_econsit==3) if expec_econsit!=.


label define nation1 1 "FRA" 2 "BEL" 3 "NLD" 4 "DEU-W" 5 "ITA" 6 "LUX" 7 ///
"DNK"8 "IRL" 9 "GBR" 10 "NI" 11 "GRC" 12 "ESP" 13 "PRT" 14 "DEU-E" ///
16 "FIN" 17 "SWE" 18 "AUT", replace
label values country nation1

***********************

gen dem_gender = sex
recode educ_10cat (1/2=1) (3/6=2) (7/9=3) (10=4), gen(educ_4cat)
replace educ_4cat = educrec if educrec!=.
gen dem_educ = educ_4cat
gen dem_marital = marital_status
rename age dem_age 
gen dem_age_sq = dem_age^2

foreach var of varlist dem_gender dem_educ dem_marital  {
recode `var' (missing=999)
}

 *********

erase   "44.2.dta"
erase	"58.1.dta"
erase	"60.1.dta"
erase	"62.0.dta"
erase	"62.2.dta"
erase	"63.4.dta"
erase	"64.2.dta"
erase	"65.2.dta"
erase	"66.1.dta"
erase	"67.2.dta"
erase	"68.1.dta"
erase	"69.2.dta"
erase	"70.1.dta"
erase	"71.1.dta"
erase	"71.2.dta"
erase	"71.3.dta"
erase	"72.4.dta"
erase	"73.4.dta"
erase	"73.5.dta"
erase	"74.2.dta"
erase	"75.3.dta"
erase	"75.4.dta"
erase	"76.3.dta"
erase	"77.3.dta"
erase	"77.4.dta"
erase	"78.1.dta"
erase	"79.3.dta"
erase	"80.1.dta"
erase	"80.2.dta"
erase 	"non_trend.dta"
erase 	"trend.dta"



* I am only here interested in the so-called "EU15", since they have all been surveyed most often 
*	and over the longest period of time 																								
	
label define country 1 "FRA" 2 "BEL" 3 "NLD" 4 "DEU" 5 "ITA" 6 "LUX" 7 ///
"DNK"8 "IRL" 9 "GBR" 10 "GBR" 11 "GRC" 12 "ESP" 13 "PRT" 14 "" ///
16 "FIN" 17 "SWE" 18 "AUT", replace
label values country country
decode country, gen(code)
drop if code==""


keep   satislfe dem_gender dem_educ dem_marital dem_age dem_age_sq econexpec_* ///
 study_id id_original  country code wnation wsample wuk eb  survey_month  survey_quarter year survey_date
order country code eb year  survey_month satislfe  dem_gender dem_educ dem_marital dem_age dem_age_sq 





*** Merge in Macro Data ***



cd "/Users/wardg/Dropbox (MIT)/Projects/Loss Aversion Project/ReStat Replication Files/Macroeconomic Data/"
merge m:1 code year using "restat_unemployment_inflation.dta", force
keep if _merge==3
drop _merge
merge m:1 code year using "restat_gdp.dta", force
keep if _merge==3
drop _merge

egen countryyear = group(code year)	
egen	std_lifesat = std(satislfe)

replace gdpgrowth_wb_neg = abs(gdpgrowth_wb_neg)
encode code, gen(co)

mkspline wbhhconumptionpcgrowth_n 0 wbhhconumptionpcgrowth_p = wbhhconumptionpcgrowth


lab var wbhhconumptionpcgrowth "HH consumption growth"
lab var wbhhconumptionpcgrowth_n "Negative HH consumption growth"
lab var wbhhconumptionpcgrowth_p "Positive HH consumption growth"
lab var econexpec_better "Economic Expectations: Better (vs. same)"
lab var econexpec_worse "Economic Expectations: Worse (vs. same)"
lab var satislfe "Life satisfaction (1-4)"

cd "/Users/wardg/Dropbox (MIT)/Projects/Loss Aversion Project/ReStat Replication Files/Eurobarometer/"
saveold "eb_restat.dta", replace



 
 
*** Consistent demographic controls across the three datasets 
gen controls_age = dem_age
gen controls_age_sq = dem_age_sq
gen controls_male = (dem_gender==1)
gen controls_education_med = (dem_educ==2)
gen controls_education_high = (dem_educ==3)
gen controls_married = (dem_marital==2)

saveold "eb_restat.dta", replace
