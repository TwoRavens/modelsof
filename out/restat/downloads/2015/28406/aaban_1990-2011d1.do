****************************
*** aaban_1990-2011d1.do ***
****************************

**********************************************************************
*** This program creates the data and variables used in Incentives ***
*** to Identify: Racial Identity in the Age of Affirmative Action, ***
*** by Francisca Antman and Brian Duncan.                          ***
*** -------------------------------------------------------------- ***
*** The data comes from three sources:                             ***
*** (1) the 1990 Census PUMS 5% sample                             ***
*** (2) the 2000 Census PUMS 5% sample                             ***
*** (3) the 2001-2011 American Community Survey (ACS)              ***
***                                                                ***
*** The source data can be downloaded at:                          ***
*** https://usa.ipums.org/usa/                                     ***
**********************************************************************

capture log close
log using aaban_1990-2011d1.log, replace

#delimit ;
set more off;

clear;
use usa_00022.dta;

************************;
*** Race / Ethnicity ***;
************************;

   gen byte usborn            = (bpld<=9900);
   gen byte fborn             = (usborn==0);

   gen byte hisp              = (hispand>=100 & hispand<=499);
   gen byte white             = (raced==100   & hisp==0);
   gen byte black             = (raced==200   & hisp==0);
   gen byte asian             = (raced>=400   & raced<=699 & hisp==0);
   gen byte othrace           = (raced>=300   & raced<=399 & hisp==0) | 
                                (raced>=700 & hisp==0);
   assert hisp+white+black+asian+othrace==1;

   gen byte race_cat5         = 0;
   replace  race_cat5         = 1 if hisp==1;
   replace  race_cat5         = 2 if white==1;
   replace  race_cat5         = 3 if black==1;
   replace  race_cat5         = 4 if asian==1;
   replace  race_cat5         = 5 if othrace==1;
   label define race_cat5
                              0   "MISSING"
                              1   "Hispanic"
                              2   "White"
                              3   "Black"
                              4   "Asian"
                              5   "Other Race";
   label values race_cat5 race_cat5;

   gen byte white_any        = raced==100 | racwht==2;
   gen byte black_any        = raced==200  | racblk==2;
   gen byte asian_any        = (raced>=400 & raced<=699) | 
                                racasian==2 | racpacis==2;

   gen byte allocated_race   = (qrace~=0);
   gen byte allocated_hisp   = (qhispan~=0);

*****************************;
*** State Level Variables ***;
*****************************;

   egen S_fborn              = mean(fborn),   by(year statefip);
   egen S_hisp               = mean(hisp),    by(year statefip);
   egen S_black              = mean(black),   by(year statefip);
   egen S_asian              = mean(asian),   by(year statefip);

*****************************************************;
*** Limit the Sample to:                          ***;
*** 1. US-born.                                   ***;
*** 2. Without an allocated Race/Hispanic Origin. ***;
*** 3. Age 0-59.                                  ***;
*****************************************************;

   keep if usborn==1;
   keep if allocated_race==0 & allocated_hisp==0;
   keep if (age<=59);

**********************;
*** Age Subsamples ***;
**********************;

   gen byte age_cat6         = 0;
   replace  age_cat6         = 1 if (age<=9);
   replace  age_cat6         = 2 if (age>=10 & age<=17);
   replace  age_cat6         = 3 if (age>=18 & age<=25);
   replace  age_cat6         = 4 if (age>=26 & age<=34);
   replace  age_cat6         = 5 if (age>=35 & age<=59);
   label define age_cat6
                              0   "Not in any sample"
                              1   "Age 0-9"
                              2   "Age 10-17"
                              3   "Age 18-25"
                              4   "Age 26-34"
                              5   "Age 35-59";
   label values age_cat6 age_cat6;
   assert age_cat6~=0;

*******************************************************************;
*** collegeage = individuals 18 to 25 with a high school or GED ***;
*** degree, but not a bachelor's degree                         ***; 
*******************************************************************;

   gen  collegeage           = (age>=18 & age<=25) & 
                               (educd>=62 & educd<=90);

****************;
*** Ancestry ***;
****************;

* Not Reported;
   gen byte none_anc            = ancestr1d==9990 & ancestr2d==9990;
   gen byte some_anc            = (none_anc==0);

* Asians;
   gen byte asian_anc           = (ancestr1d>=6000 & ancestr1d<=8700) |
                                  (ancestr2d>=6000 & ancestr2d<=8700) ;
   gen byte asian_anc2          = (ancestr1d>=6000 & ancestr1d<=8700) &
                                  (ancestr2d>=6000 & ancestr2d<=8700) ;
   gen byte asian_anc1          =  asian_anc==1 & asian_anc2==0;
   assert asian_anc1+asian_anc2==asian_anc;

   gen noasian_anc              = (1-asian_anc)*some_anc;
   assert noasian_anc+none_anc+asian_anc==1;

   gen byte noneasian_anc       = (1-asian_anc);

* Only Asian;
   gen byte onlyasian_anc       = (ancestr1d>=6000 & ancestr1d<=8700) &
                                  (ancestr2d>=6000 & ancestr2d<=8700) ;
   replace onlyasian_anc        = 1 if (ancestr1d>=6000 & ancestr1d<=8700) &
                                       (ancestr2d==9990);
   replace onlyasian_anc        = 1 if (ancestr2d>=6000 & ancestr2d<=8700) &
                                       (ancestr1d==9990);

   gen byte asianother_anc      = asian_anc*(1-onlyasian_anc);

* Asian Ancestry Categories;
   assert noneasian_anc+onlyasian_anc+asianother_anc==1;
   gen byte anc_cat3_asian       = 0;
   replace  anc_cat3_asian       = 1 if noneasian_anc==1;
   replace  anc_cat3_asian       = 2 if asianother_anc==1;
   replace  anc_cat3_asian       = 3 if onlyasian_anc==1;
   label define anc_cat3_asian
                              0   "Error!"
                              1   "No Asian"
                              2   "Mixed Asian"
                              3   "Only Asian";
   label values anc_cat3_asian anc_cat3_asian;

   assert noasian_anc+none_anc+onlyasian_anc+asianother_anc==1;
   gen byte anc_cat4_asian       = 0;
   replace  anc_cat4_asian       = 1 if noasian_anc==1;
   replace  anc_cat4_asian       = 2 if none_anc==1;
   replace  anc_cat4_asian       = 3 if asianother_anc==1;
   replace  anc_cat4_asian       = 4 if onlyasian_anc==1;
   label define anc_cat4_asian
                              0   "Error!"
                              1   "Non-Asian"
                              2   "No Ancestry"
                              3   "Mixed Asian"
                              4   "Only Asian";
   label values anc_cat4_asian anc_cat4_asian;

* Blacks;
   gen byte black_anc           = (ancestr1d>=5000 & ancestr1d<=5990) |
                                  (ancestr1d>=9000 & ancestr1d<=9020) |
                                  (ancestr2d>=5000 & ancestr2d<=5990) |
                                  (ancestr2d>=6000 & ancestr2d<=8700) ;
   gen byte black_anc2          = ((ancestr1d>=5000 & ancestr1d<=5990) |
                                  (ancestr1d>=9000 & ancestr1d<=9020)) &
                                  ((ancestr2d>=5000 & ancestr2d<=5990) |
                                  (ancestr2d>=6000 & ancestr2d<=8700)) ;
   gen byte black_anc1          =  black_anc==1 & black_anc2==0;
   assert black_anc1+black_anc2==black_anc;

   gen noblack_anc              = (1-black_anc)*some_anc;
   assert noblack_anc+none_anc+black_anc==1;

   gen byte noneblack_anc       = (1-black_anc);

* Only Black;
   gen byte onlyblack_anc       = ((ancestr1d>=5000 & ancestr1d<=5990) |
                                  (ancestr1d>=9000 & ancestr1d<=9020)) &
                                  ((ancestr2d>=5000 & ancestr2d<=5990) |
                                  (ancestr2d>=6000 & ancestr2d<=8700)) ;
   replace onlyblack_anc        = 1 if ((ancestr1d>=5000 & ancestr1d<=5990) |
                                       (ancestr1d>=9000 & ancestr1d<=9020)) &
                                       (ancestr2d==9990);
   replace onlyblack_anc        = 1 if ((ancestr2d>=5000 & ancestr2d<=5990) |
                                       (ancestr2d>=9000 & ancestr2d<=9020)) &
                                       (ancestr1d==9990);

   gen byte blackother_anc      = black_anc*(1-onlyblack_anc);

* Black Ancestry Categories;
   assert noneblack_anc+onlyblack_anc+blackother_anc==1;
   gen byte anc_cat3_black       = 0;
   replace  anc_cat3_black       = 1 if noneblack_anc==1;
   replace  anc_cat3_black       = 2 if blackother_anc==1;
   replace  anc_cat3_black       = 3 if onlyblack_anc==1;
   label define anc_cat3_black
                              0   "Error!"
                              1   "No Black"
                              2   "Mixed Black"
                              3   "Only Black";
   label values anc_cat3_black anc_cat3_black;

   assert noblack_anc+none_anc+onlyblack_anc+blackother_anc==1;
   gen byte anc_cat4_black       = 0;
   replace  anc_cat4_black       = 1 if noblack_anc==1;
   replace  anc_cat4_black       = 2 if none_anc==1;
   replace  anc_cat4_black       = 3 if blackother_anc==1;
   replace  anc_cat4_black       = 4 if onlyblack_anc==1;
   label define anc_cat4_black
                              0   "Error!"
                              1   "Non-Black"
                              2   "No Ancestry"
                              3   "Mixed Black"
                              4   "Only Black";
   label values anc_cat4_black anc_cat4_black;

**************;
*** Gender ***;
**************;

   generate byte female       = (sex==2);

******************;
*** In College ***;
******************;

   gen byte college       = school==2  & (educd>=62 & educd<=90);

**************************************;
*** Original Variables to Keep     ***;
*** ------------------------------ ***;
***  year statefip age             ***;
**************************************;

   drop perwt famsize race yrimmig racesingd educ ind qancest1
        datanum momloc nsibs raced yrsusa1 racamind educd classwkr qbpl
        serial stepmom sfrelate bpl yrsusa2 racasian gradeatt classwkrd 
        qhispan hhwt momrule relate bpld language racblk gradeattd wkswork2 
        qrace poploc related ancestr1 languaged racpacis schltype uhrswork
        gq steppop ancestr1d speakeng racwht empstat inctot
        gqtype poprule sex ancestr2 hispan racother empstatd ftotinc
        gqtyped sploc marst ancestr2d hispand racnum labforce incwage
        pernum sprule birthyr citizen racesing school occ poverty 
        ancestr1d_mom ancestr1d_pop ancestr2d_mom ancestr2d_pop 
        educd_head educd_mom educd_pop ;

***************************************************;
*** Affirmative Action Bans (Year Effective)    ***;
*** ------------------------------------------- ***;
*** Texas (48)         1997-2004                ***;
*** California (6)     1998                     ***;
*** Washington (53)    1999                     ***;
*** Florida (12)       2001                     ***;
*** Nebraska (31)      2009                     ***;
*** Arizona (4)        2011                     ***;
*** Michigan (26)      2007                     ***;
*** New Hampshire (33) 2012                     ***;
*** Oklahoma (40)      2013                     ***;
***************************************************;

   gen banyear          = .;
   replace banyear      = (year - 1997) if statefip==48;
   replace banyear      = (year - 1998) if statefip==6;
   replace banyear      = (year - 1999) if statefip==53;
   replace banyear      = (year - 2001) if statefip==12;
   replace banyear      = (year - 2009) if statefip==31;
   replace banyear      = (year - 2011) if statefip==4;
   replace banyear      = (year - 2007) if statefip==26;
   replace banyear      = (year - 2012) if statefip==33;
   replace banyear      = (year - 2013) if statefip==40;

   gen byte ban         = 0;
   replace  ban         = 1 if statefip==48 & (year>=1997 & year<=2004);
   replace  ban         = 1 if statefip==6  & year>=1998;
   replace  ban         = 1 if statefip==53 & year>=1999;
   replace  ban         = 1 if statefip==12 & year>=2001;
   replace  ban         = 1 if statefip==31 & year>=2009;
   replace  ban         = 1 if statefip==4  & year>=2011;
   replace  ban         = 1 if statefip==26 & year>=2007;
   replace  ban         = 1 if statefip==33 & year>=2012;
   replace  ban         = 1 if statefip==40 & year>=2013;

********************************;
*** AA Ban Interaction Terms ***;
********************************;

*********************************;
*** Ancestry Ban Interactions ***;
*********************************;

   gen ban_none_anc      = ban*none_anc;

* Black;
   gen ban_black_anc     = ban*black_anc;
   gen ban_black_anc1    = ban*black_anc1;
   gen ban_black_anc2    = ban*black_anc2;
   gen ban_noblack_anc   = ban*noblack_anc;

   gen ban_noneblack_anc = ban*noneblack_anc;
   assert ban_black_anc+ban_noneblack_anc+(1-ban)==1; 

   gen ban_onlyblack_anc  = ban*onlyblack_anc;
   gen ban_blackother_anc = ban*blackother_anc;
   assert ban_onlyblack_anc+ban_blackother_anc+ban_noneblack_anc+(1-ban)==1; 
   assert ban_noblack_anc+ban_none_anc+ban_blackother_anc+ban_onlyblack_anc+
          (1-ban)==1;

* Asian;
   gen ban_asian_anc     = ban*asian_anc;
   gen ban_asian_anc1    = ban*asian_anc1;
   gen ban_asian_anc2    = ban*asian_anc2;
   gen ban_noasian_anc   = ban*noasian_anc;

   gen ban_noneasian_anc = ban*noneasian_anc;
   assert ban_asian_anc+ban_noneasian_anc+(1-ban)==1; 

   gen ban_onlyasian_anc  = ban*onlyasian_anc;
   gen ban_asianother_anc = ban*asianother_anc;
   assert ban_onlyasian_anc+ban_asianother_anc+ban_noneasian_anc+(1-ban)==1; 
   assert ban_noasian_anc+ban_none_anc+ban_asianother_anc+ban_onlyasian_anc+
          (1-ban)==1;

*********************;
*** Save the Data ***;
*********************;

   compress;
   d,s;
   save aaban_1990-2011d1.dta, replace;

set more on;
log close;
exit, clear STATA;


