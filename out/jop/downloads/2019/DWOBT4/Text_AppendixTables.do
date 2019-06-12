

log using Text_FN_AppendixTables.txt, replace text

** Appendix Tables + Analyses noted in the text

// Footnote 8, page 9
/*In Study 1, we included a sixth condition that asked subjects about which chain contributed the most to both parties.
*/

** McDonalds and Walmart contributed the most
use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study1_Final.dta"
recode ham_treat (.=6)
recode store_treat (.=6)
** McDonalds Gift cards  (Republicans)
tab ham_card_mcd ham_treat if pid_3==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, col
** McDonalds Gift cards (Democrats)
tab ham_card_mcd ham_treat if pid_3==2 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, col

** Walmart Gift cards (Republicans)
tab store_card_wm store_treat if pid_3==1 & store_treat!=1 & store_treat!=2 & store_treat!=3 & store_treat!=4, col
** Walmart Gift cards
tab store_card_wm store_treat if pid_3==2 & store_treat!=1 & store_treat!=2 & store_treat!=3 & store_treat!=4, col

** McDonalds Shopping Intentions (Republicans)
ttest mcd_future if pid_3==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by(ham_treat)
** McDonalds Shopping Intentions (Democrats)
ttest mcd_future if pid_3==2 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by(ham_treat)

** Walmart Shopping Intentions (Republicans)
ttest wm_future if pid_3==1 & store_treat!=1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by(store_treat)
** Walmart Shopping Intentions (Democrats)
ttest wm_future if pid_3==2 & store_treat!=1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by(store_treat)
clear


// Footnote 9, page 10
/* In Study 1, 96.2% of respondents assigned to a treatment and 96.0% of those assigned to the control agreed to participate in the lottery. 
In Study 2, 96.0% of respondents assigned to a treatment and 95.1% of those assigned to the control agreed to participate. 
*/
use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study1_Final.dta"
// Study 1 Treatment group raffle entry
tab ham_raffle if ham_treat!=5
tab store_raffle if store_treat!=5
dis (98.03+94.45)/2
// Study 1 Control group raffle entry
tab ham_raffle if ham_treat==5
tab store_raffle if store_treat==5
dis (96.48+95.47)/2

clear

use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study2_Final.dta"
// Study 2 Treatment group raffle entry
tab ham_raffle if ham_treat!=5
tab store_raffle if store_treat!=5
tab pizza_raffle if ham_treat!=5
tab drug_raffle if store_treat!=5
dis (93.25+97.97+95.65+96.63)/4

// Study 2 Control group raffle entry
tab ham_raffle if ham_treat==5
tab store_raffle if store_treat==5
tab pizza_raffle if ham_treat==5
tab drug_raffle if store_treat==5
dis (94.20+95.56+95.86+94.44)/4
clear

// Study 1 Balance Tests
use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study1_Final.dta"
// Hamburger Experiment
mlogit ham_treat age gender_1 presapproval mcdonalds_freq, base(5)
// Big Box Experiment
mlogit store_treat age gender_1 presapproval walmart_freq, base(5)
clear


// Study 2 Balance Tests
use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study2_Final.dta"
** Hamburger Experiment
** 0 = never, 4 = "several times a week"
mlogit ham_treat age gender_male presapproval mcdonalds_freq, base(5)
** Big Box Experiment
mlogit store_treat age gender_male presapproval walmart_freq, base(5)
** Pizza Experiment
mlogit pizza_treat age gender_male presapproval pizzahut_freq, base(5)
** Drug Store Experiment
mlogit drug_treat age gender_male presapproval walgreens_freq, base(5)
clear


*** Table A1 ***


use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study1_Final.dta"
** Study 1 Hamburger Conditions ** 
tab ham_treat
** Study 1 Big Box Conditions **
tab store_treat
clear

use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study2_Final.dta"
** Study 2 Hamburger Conditions ** 
tab ham_treat
** Study 2 Big Box Conditions **
tab store_treat
** Study 2 Pizza Conditions **
tab pizza_treat
** Study 2 Drug Store Conditions **
tab drug_treat
clear


*** Table A2 ***



use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study1_Final.dta"
// Table A2, Study 1 - Hamburger Restaurants
** Which of the following companies is responsible for coming up with the dollar menu?**
tab dollar
** Which restaurant named their chicken nuggets? **
tab nuggets
** Which of these ingredients is NOT a base ingredient for a Whopper? **
tab whopper
** Which of these companies gave the largest percentage of their political contributions to Republican candidates in 2014?  **
tab prham
** Which of these companies gave the largest percentage of their political contributions to Democratic candidates in 2014? **
tab pdham
** Which of these companies gave the most dollars to Republican candidates in 2014? **
tab amrham
** Which of these companies gave the most dollars to Democratic candidates in 2014? **
tab amdham
** In 2010, which restaurant added sea salt to their fries? **
tab cham

// Table A2, Study 1 - Big Box Stores
** Which of the following companies achieved $1 billion in sales in the quickest amount of time?
tab sales
** Which of the following companies has a mascot named “Bullseye”?
tab bullseye
** Which of the following companies was the first to open the “superstore”? 
tab superstore
** Which of these companies gave the largest percentage of their political contributions to Republican candidates in 2014?
tab prstore
** Which of these companies gave the largest percentage of their political contributions to Democratic candidates in 2014?
tab pdstore
** Which of these companies gave the most dollars to Republican candidates in 2014?
tab amrstore
** Which of these companies gave the most dollars to Democratic candidates in 2014?
tab amdstore
** Which of the following companies does not issue coupons (even on Black Friday)?
tab cstore
clear


use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study2_Final.dta"
// Table A2, Study 2 - Hamburger Restaurants
** Which of the following companies is responsible for coming up with the dollar menu?**
tab dollar
** Which restaurant named their chicken nuggets? **
tab nuggets
** Which of these ingredients is NOT a base ingredient for a Whopper? **
tab whopper
** Which of these companies gave the largest percentage of their political contributions to Republican candidates in 2014?  **
tab prham
** Which of these companies gave the largest percentage of their political contributions to Democratic candidates in 2014? **
tab pdham
** Which of these companies gave the most dollars to Republican candidates in 2014? **
tab amrham
** Which of these companies gave the most dollars to Democratic candidates in 2014? **
tab amdham
** In 2010, which restaurant added sea salt to their fries? **
tab cham

// Table A2, Study 2 - Big Box Stores
** Which of the following companies achieved $1 billion in sales in the quickest amount of time?
tab sales
** Which of the following companies has a mascot named “Bullseye”?
tab bullseye
** Which of the following companies was the first to open the “superstore”? 
tab superstore
** Which of these companies gave the largest percentage of their political contributions to Republican candidates in 2014?
tab prstore
** Which of these companies gave the largest percentage of their political contributions to Democratic candidates in 2014?
tab pdstore
** Which of these companies gave the most dollars to Republican candidates in 2014?
tab amrstore
** Which of these companies gave the most dollars to Democratic candidates in 2014?
tab amdstore
** Which of the following companies does not issue coupons (even on Black Friday)?
tab cstore

// Table A2, Study 2 - Pizza Restuarants
** Which of the following companies currently sponsors a football stadium?
tab stadium
** Which pizza restaurant was the first company to deliver food to the International Space Station?
tab spacestation
** Which of the following companies introduced the modern belt driven pizza oven?
tab oven
** Which of these companies gave the largest percentage of their political contributions to Republican candidates in 2014?
tab prpizza
** Which of these companies gave the largest percentage of their political contributions to Democratic candidates in 2014?
tab pdpizza
** Which of these companies gave the most dollars to Republican candidates in 2014?
tab rapizza
** Which of these companies gave the most dollars to Democratic candidates in 2014?
tab dapizza
** Which of the following companies began operating out of a broom closet?
tab cpizza

// Table A2, Study 2 - Drug Stores
** Which of the following companies bought out Target’s pharmacy and clinic services?
tab pharmacy
** Which of the following companies originally featured a soda fountain and luncheon service?
tab soda
** Which of the following companies did not include a pharmacy when it was founded?
tab nopharmacy
** Which of these companies gave the largest percentage of their political contributions to Republican candidates in 2014?
tab rpd
** Which of these companies gave the largest percentage of their political contributions to Democratic candidates in 2014?
tab dpdem
** Which of these companies gave the most dollars to Republican candidates in 2014?
tab rad
** Which of these companies gave the most dollars to Democratic candidates in 2014?
tab dad
** Which of these companies banned the sell of tobacco products?
tab cd
clear


use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study3_Final.dta"
// Table A2, Study 3 - Big Box Stores
** Which of the following stores grew out of a chain of supermarkets?
tab FBC401
** Which of the following stores was founded in New Jersey?
tab FBC402
** Which of the following stores gave the largest percentage of its political contributions to Republican candidates in 2016?
tab FBC403 if store_treat==1
** Which of the following stores gave the largest percentage of its political contributions to Democratic candidates in the 2016 election cycle?
tab FBC404 if store_treat==2
** Which of the following stores used a smiley face, very much like an emoji, in many of its advertisements during the the 1990s?
tab FBC405 if store_treat==5

// Table A2, Study 3 - Hamburger Restuarants
** Which of the following hamburger restaurants has a training program known as “Hamburger University” for its managers?
tab FBC406
** Which of the following hamburger restaurants added sea salt to their fries in 2010?
tab FBC407
** Which of the following hamburger restaurants has given the most money to Republican candidates in the 2016 election cycle?
tab FBC408 if ham_treat==3
** Which of the following hamburger restaurants has given the most money to Democratic candidates in the 2016 election cycle?
tab FBC409 if ham_treat==4
** Which of the following hamburger restaurants advertises burgers as flame-grilled and made to order?
tab FBC410 if ham_treat==5

clear


*** TABLE A3 ***


use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study1_Final.dta"
** Table A3, Study 1, Row 1 (Burger King)
** Ctrl
mean ham_card_bk if pid_3==2 & ham_treat==5
** R%
mean ham_card_bk if pid_3==2 & ham_treat==1
** D%
mean ham_card_bk if pid_3==2 & ham_treat==2
** R Amt
mean ham_card_bk if pid_3==2 & ham_treat==3
** D Amt
mean ham_card_bk if pid_3==2 & ham_treat==4
** Diference in D% and Ctrl means
ttest ham_card_bk if pid_3==2 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A3, Study 1, Row 2 (McDonalds)
** Ctrl
mean ham_card_mcd if pid_3==2 & ham_treat==5
** R%
mean ham_card_mcd if pid_3==2 & ham_treat==1
** D%
mean ham_card_mcd if pid_3==2 & ham_treat==2
** R Amt
mean ham_card_mcd if pid_3==2 & ham_treat==3
** D Amt
mean ham_card_mcd if pid_3==2 & ham_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest ham_card_mcd if pid_3==2 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Dmeocrats
ttest ham_card_mcd if pid_3==2 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)


** Table A3, Study 1, Row 3 (Wendys)
** Ctrl (also mentioned in the text on page 13)
mean ham_card_wendys if pid_3==2 & ham_treat==5
** R% (also mentioned in the text on page 12)
mean ham_card_wendys if pid_3==2 & ham_treat==1
** D%
mean ham_card_wendys if pid_3==2 & ham_treat==2
** R Amt
mean ham_card_wendys if pid_3==2 & ham_treat==3
** D Amt
mean ham_card_wendys if pid_3==2 & ham_treat==4
** Diference in R% and Ctrl means among Democrats
ttest ham_card_wendys if pid_3==2 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)


** Table A3, Study 1, Row 4 (Burger King)
** Ctrl
mean ham_card_bk if pid_3==1 & ham_treat==5
** R%
mean ham_card_bk if pid_3==1 & ham_treat==1
** D%
mean ham_card_bk if pid_3==1 & ham_treat==2
** R Amt
mean ham_card_bk if pid_3==1 & ham_treat==3
** D Amt
mean ham_card_bk if pid_3==1 & ham_treat==4
** Diference in D% and Ctrl means among Republicans
ttest ham_card_bk if pid_3==1 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A3, Study 1, Row 5 (McDonalds)
** Ctrl
mean ham_card_mcd if pid_3==1 & ham_treat==5
** R%
mean ham_card_mcd if pid_3==1 & ham_treat==1
** D%
mean ham_card_mcd if pid_3==1 & ham_treat==2
** R Amt
mean ham_card_mcd if pid_3==1 & ham_treat==3
** D Amt
mean ham_card_mcd if pid_3==1 & ham_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest ham_card_mcd if pid_3==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest ham_card_mcd if pid_3==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A3, Study 1, Row 6 (Wendys)
** Ctrl (also mentioned in the text on page 13)
mean ham_card_wendys if pid_3==1 & ham_treat==5
** R% (also mentioned in the text on page 13)
mean ham_card_wendys if pid_3==1 & ham_treat==1
** D%
mean ham_card_wendys if pid_3==1 & ham_treat==2
** R Amt
mean ham_card_wendys if pid_3==1 & ham_treat==3
** D Amt
mean ham_card_wendys if pid_3==1 & ham_treat==4
** Diference in R% and Ctrl means among Republicans
ttest ham_card_wendys if pid_3==1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)


** Table A3, Study 1, Row 7 (Bed Bath and Beyond)
** Ctrl
mean store_card_bbb if pid_3==2 & store_treat==5
** R%
mean store_card_bbb if pid_3==2 & store_treat==1
** D%
mean store_card_bbb if pid_3==2 & store_treat==2
** R Amt
mean store_card_bbb if pid_3==2 & store_treat==3
** D Amt
mean store_card_bbb if pid_3==2 & store_treat==4
** Diference in D% and Ctrl means among Democrats
ttest store_card_bbb if pid_3==2 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A3, Study 1, Row 8 (Target)
** Ctrl
mean store_card_target if pid_3==2 & store_treat==5
** R%
mean store_card_target if pid_3==2 & store_treat==1
** D%
mean store_card_target if pid_3==2 & store_treat==2
** R Amt
mean store_card_target if pid_3==2 & store_treat==3
** D Amt
mean store_card_target if pid_3==2 & store_treat==4

** Table A3, Study 1, Row 9 (TJ Maxx)
** Ctrl
mean store_card_tjm if pid_3==2 & store_treat==5
** R%
mean store_card_tjm if pid_3==2 & store_treat==1
** D%
mean store_card_tjm if pid_3==2 & store_treat==2
** R Amt
mean store_card_tjm if pid_3==2 & store_treat==3
** D Amt
mean store_card_tjm if pid_3==2 & store_treat==4
** Diference in R% and Ctrl means among Democrats
ttest store_card_tjm if pid_3==2 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A3, Study 1, Row 10 (Walmart)
** Ctrl
mean store_card_wm if pid_3==2 & store_treat==5
** R%
mean store_card_wm if pid_3==2 & store_treat==1
** D%
mean store_card_wm if pid_3==2 & store_treat==2
** R Amt
mean store_card_wm if pid_3==2 & store_treat==3
** D Amt
mean store_card_wm if pid_3==2 & store_treat==4

** Diference in R Amt and Ctrl means among Democrats
ttest store_card_wm if pid_3==2 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest store_card_wm if pid_3==2 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

** Table A3, Study 1, Row 11 (Bed Bath and Beyond)
** Ctrl
mean store_card_bbb if pid_3==1 & store_treat==5
** R%
mean store_card_bbb if pid_3==1 & store_treat==1
** D%
mean store_card_bbb if pid_3==1 & store_treat==2
** R Amt
mean store_card_bbb if pid_3==1 & store_treat==3
** D Amt
mean store_card_bbb if pid_3==1 & store_treat==4
** Diference in D% and Ctrl means among Republicans
ttest store_card_bbb if pid_3==1 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A3, Study 1, Row 12 (Target)
** Ctrl
mean store_card_target if pid_3==1 & store_treat==5
** R%
mean store_card_target if pid_3==1 & store_treat==1
** D%
mean store_card_target if pid_3==1 & store_treat==2
** R Amt
mean store_card_target if pid_3==1 & store_treat==3
** D Amt
mean store_card_target if pid_3==1 & store_treat==4

** Table A3, Study 1, Row 13 (TJ Maxx)
** Ctrl
mean store_card_tjm if pid_3==1 & store_treat==5
** R%
mean store_card_tjm if pid_3==1 & store_treat==1
** D%
mean store_card_tjm if pid_3==1 & store_treat==2
** R Amt
mean store_card_tjm if pid_3==1 & store_treat==3
** D Amt
mean store_card_tjm if pid_3==1 & store_treat==4
** Diference in R% and Ctrl means among Republicans
ttest store_card_tjm if pid_3==1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A3, Study 1, Row 14 (Walmart)
** Ctrl
mean store_card_wm if pid_3==1 & store_treat==5
** R%
mean store_card_wm if pid_3==1 & store_treat==1
** D%
mean store_card_wm if pid_3==1 & store_treat==2
** R Amt
mean store_card_wm if pid_3==1 & store_treat==3
** D Amt
mean store_card_wm if pid_3==1 & store_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest store_card_wm if pid_3==1 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest store_card_wm if pid_3==1 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

clear

use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study2_Final.dta"

** Table A3, Study 2, Row 1 (Burger King)
** Ctrl
mean ham_card_bk if pid_3==2 & ham_treat==5
** R%
mean ham_card_bk if pid_3==2 & ham_treat==1
**  D%
mean ham_card_bk if pid_3==2 & ham_treat==2
** R Amt
mean ham_card_bk if pid_3==2 & ham_treat==3
** D Amt
mean ham_card_bk if pid_3==2 & ham_treat==4
** Diference in D% and Ctrl means
ttest ham_card_bk if pid_3==2 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A3, Study 2, Row 2 (McDonalds)
** Ctrl
mean ham_card_mcd if pid_3==2 & ham_treat==5
** R%
mean ham_card_mcd if pid_3==2 & ham_treat==1
** D%
mean ham_card_mcd if pid_3==2 & ham_treat==2
** R Amt
mean ham_card_mcd if pid_3==2 & ham_treat==3
** D Amt
mean ham_card_mcd if pid_3==2 & ham_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest ham_card_mcd if pid_3==2 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Dmeocrats
ttest ham_card_mcd if pid_3==2 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A3, Study 2, Row 3 (Wendys)
** Ctrl
mean ham_card_wendys if pid_3==2 & ham_treat==5
** R%
mean ham_card_wendys if pid_3==2 & ham_treat==1
** D%
mean ham_card_wendys if pid_3==2 & ham_treat==2
** R Amt
mean ham_card_wendys if pid_3==2 & ham_treat==3
** D Amt
mean ham_card_wendys if pid_3==2 & ham_treat==4
** Diference in R% and Ctrl means among Democrats
ttest ham_card_wendys if pid_3==2 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)


** Table A3, Study 2, Row 4 (Burger King)
** Ctrl
mean ham_card_bk if pid_3==1 & ham_treat==5
** R%
mean ham_card_bk if pid_3==1 & ham_treat==1
** D%
mean ham_card_bk if pid_3==1 & ham_treat==2
** R Amt
mean ham_card_bk if pid_3==1 & ham_treat==3
** D Amt
mean ham_card_bk if pid_3==1 & ham_treat==4
** Diference in D% and Ctrl means among Republicans
ttest ham_card_bk if pid_3==1 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A3, Study 2, Row 5 (McDonalds)
** Ctrl
mean ham_card_mcd if pid_3==1 & ham_treat==5
** R%
mean ham_card_mcd if pid_3==1 & ham_treat==1
** D%
mean ham_card_mcd if pid_3==1 & ham_treat==2
** R Amt
mean ham_card_mcd if pid_3==1 & ham_treat==3
** D Amt
mean ham_card_mcd if pid_3==1 & ham_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest ham_card_mcd if pid_3==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest ham_card_mcd if pid_3==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A3, Study 2, Row 6 (Wendys)
** Ctrl
mean ham_card_wendys if pid_3==1 & ham_treat==5
** R%
mean ham_card_wendys if pid_3==1 & ham_treat==1
** D%
mean ham_card_wendys if pid_3==1 & ham_treat==2
** R Amt
mean ham_card_wendys if pid_3==1 & ham_treat==3
** D Amt
mean ham_card_wendys if pid_3==1 & ham_treat==4
** Diference in R% and Ctrl means among Republicans
ttest ham_card_wendys if pid_3==1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)


** Table A3, Study 2, Row 7 (Bed Bath and Beyond)
** Ctrl
mean store_card_bbb if pid_3==2 & store_treat==5
** R%
mean store_card_bbb if pid_3==2 & store_treat==1
** D%
mean store_card_bbb if pid_3==2 & store_treat==2
** R Amt
mean store_card_bbb if pid_3==2 & store_treat==3
** D Amt
mean store_card_bbb if pid_3==2 & store_treat==4
** Diference in D% and Ctrl means among Democrats
ttest store_card_bbb if pid_3==2 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A3, Study 2, Row 8 (Target)
** Ctrl
mean store_card_target if pid_3==2 & store_treat==5
** R%
mean store_card_target if pid_3==2 & store_treat==1
** D%
mean store_card_target if pid_3==2 & store_treat==2
** R Amt
mean store_card_target if pid_3==2 & store_treat==3
** D Amt
mean store_card_target if pid_3==2 & store_treat==4

** Table A3, Study 2, Row 10 (Walmart)
** Ctrl
mean store_card_wm if pid_3==2 & store_treat==5
** R%
mean store_card_wm if pid_3==2 & store_treat==1
** D%
mean store_card_wm if pid_3==2 & store_treat==2
** R Amt
mean store_card_wm if pid_3==2 & store_treat==3
** D Amt
mean store_card_wm if pid_3==2 & store_treat==4
** Diference in R% and Ctrl means among Democrats
ttest store_card_wm if pid_3==2 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)
** Diference in R Amt and Ctrl means among Democrats
ttest store_card_wm if pid_3==2 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest store_card_wm if pid_3==2 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

** Table A3, Study 2, Row 11 (Bed Bath and Beyond)
** Ctrl
mean store_card_bbb if pid_3==1 & store_treat==5
** R%
mean store_card_bbb if pid_3==1 & store_treat==1
** D%
mean store_card_bbb if pid_3==1 & store_treat==2
** R Amt
mean store_card_bbb if pid_3==1 & store_treat==3
** D Amt
mean store_card_bbb if pid_3==1 & store_treat==4
** Diference in D% and Ctrl means among Republicans
ttest store_card_bbb if pid_3==1 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A3, Study 2, Row 12 (Target)
** Ctrl
mean store_card_target if pid_3==1 & store_treat==5
** R%
mean store_card_target if pid_3==1 & store_treat==1
** D%
mean store_card_target if pid_3==1 & store_treat==2
** R Amt
mean store_card_target if pid_3==1 & store_treat==3
** D Amt
mean store_card_target if pid_3==1 & store_treat==4

** Table A3, Study 2, Row 14 (Walmart)
** Ctrl
mean store_card_wm if pid_3==1 & store_treat==5
** R%
mean store_card_wm if pid_3==1 & store_treat==1
** D%
mean store_card_wm if pid_3==1 & store_treat==2
** R Amt
mean store_card_wm if pid_3==1 & store_treat==3
** D Amt
mean store_card_wm if pid_3==1 & store_treat==4
** Diference in R% and Ctrl means among Republicans
ttest store_card_wm if pid_3==1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)
** Diference in R Amt and Ctrl means among Republicans
ttest store_card_wm if pid_3==1 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest store_card_wm if pid_3==1 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)


** Table A3, Study 2, Row 15 (Dominos)
** Ctrl
mean pizza_card_dominos if pid_3==2 & pizza_treat==5
** R%
mean pizza_card_dominos if pid_3==2 & pizza_treat==1
** D%
mean pizza_card_dominos if pid_3==2 & pizza_treat==2
** R Amt
mean pizza_card_dominos if pid_3==2 & pizza_treat==3
** D Amt
mean pizza_card_dominos if pid_3==2 & pizza_treat==4
** Diference in D% and Ctrl means among Democrats
ttest pizza_card_dominos if pid_3==2 & pizza_treat!=1 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)

** Table A3, Study 2, Row 16 (Papa Johns)
** Ctrl
mean pizza_card_papajohns if pid_3==2 & pizza_treat==5
** R%
mean pizza_card_papajohns if pid_3==2 & pizza_treat==1
** D%
mean pizza_card_papajohns if pid_3==2 & pizza_treat==2
** R Amt
mean pizza_card_papajohns if pid_3==2 & pizza_treat==3
** D Amt
mean pizza_card_papajohns if pid_3==2 & pizza_treat==4

** Table A3, Study 2, Row 17 (Pizza Hut)
** Ctrl
mean pizza_card_pizzahut if pid_3==2 & pizza_treat==5
** R%
mean pizza_card_pizzahut if pid_3==2 & pizza_treat==1
** D%
mean pizza_card_pizzahut if pid_3==2 & pizza_treat==2
** R Amt
mean pizza_card_pizzahut if pid_3==2 & pizza_treat==3
** D Amt
mean pizza_card_pizzahut if pid_3==2 & pizza_treat==4
** Diference in R% and Ctrl means among Democrats
ttest pizza_card_pizzahut if pid_3==2 & pizza_treat!=2 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)
** Diference in R Amt and Ctrl means among Democrats
ttest pizza_card_pizzahut if pid_3==2 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=4, by (pizza_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest pizza_card_pizzahut if pid_3==2 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=3, by (pizza_treat)


** Table A3, Study 2, Row 18 (Dominos)
** Ctrl
mean pizza_card_dominos if pid_3==1 & pizza_treat==5
** R%
mean pizza_card_dominos if pid_3==1 & pizza_treat==1
** D%
mean pizza_card_dominos if pid_3==1 & pizza_treat==2
**  R Amt
mean pizza_card_dominos if pid_3==1 & pizza_treat==3
** D Amt
mean pizza_card_dominos if pid_3==1 & pizza_treat==4
** Diference in D% and Ctrl means among Republicans
ttest pizza_card_dominos if pid_3==1 & pizza_treat!=1 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)

** Table A3, Study 2, Row 19 (Papa Johns)
** Ctrl
mean pizza_card_papajohns if pid_3==1 & pizza_treat==5
** R%
mean pizza_card_papajohns if pid_3==1 & pizza_treat==1
** D%
mean pizza_card_papajohns if pid_3==1 & pizza_treat==2
** R Amt
mean pizza_card_papajohns if pid_3==1 & pizza_treat==3
** D Amt
mean pizza_card_papajohns if pid_3==1 & pizza_treat==4

** Table A3, Study 2, Row 20 (Pizza Hut)
** Ctrl
mean pizza_card_pizzahut if pid_3==1 & pizza_treat==5
** R%
mean pizza_card_pizzahut if pid_3==1 & pizza_treat==1
** D%
mean pizza_card_pizzahut if pid_3==1 & pizza_treat==2
** R Amt
mean pizza_card_pizzahut if pid_3==1 & pizza_treat==3
** D Amt
mean pizza_card_pizzahut if pid_3==1 & pizza_treat==4
** Diference in R% and Ctrl means among Republicans
ttest pizza_card_pizzahut if pid_3==1 & pizza_treat!=2 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)
** Diference in R Amt and Ctrl means among Republicans
ttest pizza_card_pizzahut if pid_3==1 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=4, by (pizza_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest pizza_card_pizzahut if pid_3==1 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=3, by (pizza_treat)


** Table A3, Study 2, Row 21 (CVS)
** Ctrl
mean drugs_card_cvs if pid_3==2 & drug_treat==5
** R%
mean drugs_card_cvs if pid_3==2 & drug_treat==1
** D%
mean drugs_card_cvs if pid_3==2 & drug_treat==2
** R Amt
mean drugs_card_cvs if pid_3==2 & drug_treat==3
** D Amt
mean drugs_card_cvs if pid_3==2 & drug_treat==4
** Diference in D% and Ctrl means among Democrats
ttest drugs_card_cvs if pid_3==2 & drug_treat!=1 & drug_treat!=3 & drug_treat!=4, by (drug_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest drugs_card_cvs if pid_3==2 & drug_treat!=1 & drug_treat!=2 & drug_treat!=3, by (drug_treat)

** Table A3, Study 2, Row 22 (Rite Aid)
** Ctrl
mean drugs_card_riteaid if pid_3==2 & drug_treat==5
** R%
mean drugs_card_riteaid if pid_3==2 & drug_treat==1
** D%
mean drugs_card_riteaid if pid_3==2 & drug_treat==2
** R Amt
mean drugs_card_riteaid if pid_3==2 & drug_treat==3
** D Amt
mean drugs_card_riteaid if pid_3==2 & drug_treat==4
** Diference in R% and Ctrl means among Democrats
ttest drugs_card_riteaid if pid_3==2 & drug_treat!=2 & drug_treat!=3 & drug_treat!=4, by (drug_treat)

** Table A3, Study 2, Row 23 (Walgreens)
** Ctrl
mean drugs_card_walgreens if pid_3==2 & drug_treat==5
** R%
mean drugs_card_walgreens if pid_3==2 & drug_treat==1
** D%
mean drugs_card_walgreens if pid_3==2 & drug_treat==2
** R Amt
mean drugs_card_walgreens if pid_3==2 & drug_treat==3
** D Amt
mean drugs_card_walgreens if pid_3==2 & drug_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest drugs_card_walgreens if pid_3==2 & drug_treat!=1 & drug_treat!=2 & drug_treat!=4, by (drug_treat)

** Table A3, Study 2, Row 24 (CVS)
** Ctrl
mean drugs_card_cvs if pid_3==1 & drug_treat==5
** R%
mean drugs_card_cvs if pid_3==1 & drug_treat==1
** D%
mean drugs_card_cvs if pid_3==1 & drug_treat==2
** R Amt
mean drugs_card_cvs if pid_3==1 & drug_treat==3
** D Amt
mean drugs_card_cvs if pid_3==1 & drug_treat==4
** Diference in D% and Ctrl means among Republicans
ttest drugs_card_cvs if pid_3==1 & drug_treat!=1 & drug_treat!=3 & drug_treat!=4, by (drug_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest drugs_card_cvs if pid_3==1 & drug_treat!=1 & drug_treat!=2 & drug_treat!=3, by (drug_treat)

** Table A3, Study 2, Row 21 (Rite Aid)
** Ctrl
mean drugs_card_riteaid if pid_3==1 & drug_treat==5
** R%
mean drugs_card_riteaid if pid_3==1 & drug_treat==1
** D%
mean drugs_card_riteaid if pid_3==1 & drug_treat==2
** R Amt
mean drugs_card_riteaid if pid_3==1 & drug_treat==3
** D Amt
mean drugs_card_riteaid if pid_3==1 & drug_treat==4
** Diference in R% and Ctrl means among Republicans
ttest drugs_card_riteaid if pid_3==1 & drug_treat!=2 & drug_treat!=3 & drug_treat!=4, by (drug_treat)

** Table A3, Study 2, Row 21 (Walgreens)
** Ctrl
mean drugs_card_walgreens if pid_3==1 & drug_treat==5
** R%
mean drugs_card_walgreens if pid_3==1 & drug_treat==1
** D%
mean drugs_card_walgreens if pid_3==1 & drug_treat==2
** R Amt
mean drugs_card_walgreens if pid_3==1 & drug_treat==3
** D Amt
mean drugs_card_walgreens if pid_3==1 & drug_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest drugs_card_walgreens if pid_3==1 & drug_treat!=1 & drug_treat!=2 & drug_treat!=4, by (drug_treat)

clear


*** TABLE A5 ***


use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study1_Final.dta"

** Table A5, Study 1, Row 1 (Burger King)
** Ctrl
mean bk_future if pid_3==2 & ham_treat==5
** R%
mean bk_future if pid_3==2 & ham_treat==1
** D%
mean bk_future if pid_3==2 & ham_treat==2
** R Amt
mean bk_future if pid_3==2 & ham_treat==3
** D Amt
mean bk_future if pid_3==2 & ham_treat==4
** Diference in D% and Ctrl means among Democrats
ttest bk_future if pid_3==2 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A5, Study 1, Row 2 (McDonalds)
** Ctrl
mean mcd_future if pid_3==2 & ham_treat==5
** R%
mean mcd_future if pid_3==2 & ham_treat==1
** D%
mean mcd_future if pid_3==2 & ham_treat==2
** R Amt
mean mcd_future if pid_3==2 & ham_treat==3
** D Amt
mean mcd_future if pid_3==2 & ham_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest mcd_future if pid_3==2 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest mcd_future if pid_3==2 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A5, Study 1, Row 3 (Wendys)
** Ctrl
mean wendys_future if pid_3==2 & ham_treat==5
** R%
mean wendys_future if pid_3==2 & ham_treat==1
** D%
mean wendys_future if pid_3==2 & ham_treat==2
** R Amt
mean wendys_future if pid_3==2 & ham_treat==3
** D Amt
mean wendys_future if pid_3==2 & ham_treat==4
** Diference in R% and Ctrl means among Democrats
ttest wendys_future if pid_3==2 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)


** Table A5, Study 1, Row 4 (Burger King)
** Ctrl
mean bk_future if pid_3==1 & ham_treat==5
** R%
mean bk_future if pid_3==1 & ham_treat==1
** D%
mean bk_future if pid_3==1 & ham_treat==2
** R Amt
mean bk_future if pid_3==1 & ham_treat==3
** D Amt
mean bk_future if pid_3==1 & ham_treat==4
** Diference in D% and Ctrl means among Republicans
ttest bk_future if pid_3==1 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A5, Study 1, Row 5 (McDonalds)
** Ctrl
mean mcd_future if pid_3==1 & ham_treat==5
** R%
mean mcd_future if pid_3==1 & ham_treat==1
** D%
mean mcd_future if pid_3==1 & ham_treat==2
** R Amt
mean mcd_future if pid_3==1 & ham_treat==3
** D Amt
mean mcd_future if pid_3==1 & ham_treat==4

** Diference in R Amt and Ctrl means among Republicans
ttest mcd_future if pid_3==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest mcd_future if pid_3==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A5, Study 1, Row 6 (Wendys)
** Ctrl
mean wendys_future if pid_3==1 & ham_treat==5
** R%
mean wendys_future if pid_3==1 & ham_treat==1
** D%
mean wendys_future if pid_3==1 & ham_treat==2
** R Amt
mean wendys_future if pid_3==1 & ham_treat==3
** D Amt
mean wendys_future if pid_3==1 & ham_treat==4
** Diference in R% and Ctrl means among Republicans
ttest wendys_future if pid_3==1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)


** Table A5, Study 1, Row 7 (Bed Bath and Beyond)
** Ctrl
mean bbb_future if pid_3==2 & store_treat==5
** R%
mean bbb_future if pid_3==2 & store_treat==1
** D%
mean bbb_future if pid_3==2 & store_treat==2
** R Amt
mean bbb_future if pid_3==2 & store_treat==3
** D Amt
mean bbb_future if pid_3==2 & store_treat==4
** Diference in D% and Ctrl means among Democrats
ttest bbb_future if pid_3==2 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A5, Study 1, Row 8 (Target)
** Ctrl
mean target_future if pid_3==2 & store_treat==5
** R%
mean target_future if pid_3==2 & store_treat==1
** D%
mean target_future if pid_3==2 & store_treat==2
** R Amt
mean target_future if pid_3==2 & store_treat==3
** D Amt
mean target_future if pid_3==2 & store_treat==4

** Table A5, Study 1, Row 9 (TJ Maxx)
** Ctrl
mean tjm_future if pid_3==2 & store_treat==5
** R%
mean tjm_future if pid_3==2 & store_treat==1
** D%
mean tjm_future if pid_3==2 & store_treat==2
** R Amt
mean tjm_future if pid_3==2 & store_treat==3
** D Amt
mean tjm_future if pid_3==2 & store_treat==4
** Diference in R% and Ctrl means among Democrats
ttest tjm_future if pid_3==2 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A5, Study 1, Row 10 (Walmart)
** Ctrl
mean wm_future if pid_3==2 & store_treat==5
** R%
mean wm_future if pid_3==2 & store_treat==1
** D%
mean wm_future if pid_3==2 & store_treat==2
** R Amt
mean wm_future if pid_3==2 & store_treat==3
** D Amt
mean wm_future if pid_3==2 & store_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest wm_future if pid_3==2 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest wm_future if pid_3==2 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

// Republicans
** Table A5, Study 1, Row 11 (Bed Bath and Beyond)
** Ctrl
mean bbb_future if pid_3==1 & store_treat==5
** R%
mean bbb_future if pid_3==1 & store_treat==1
** D%
mean bbb_future if pid_3==1 & store_treat==2
** R Amt
mean bbb_future if pid_3==1 & store_treat==3
** D Amt
mean bbb_future if pid_3==1 & store_treat==4
** Diference in D% and Ctrl means among Republicans
ttest bbb_future if pid_3==1 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)


** Table A5, Study 1, Row 12 (Target)
** Ctrl
mean target_future if pid_3==1 & store_treat==5
** R%
mean target_future if pid_3==1 & store_treat==1
** D%
mean target_future if pid_3==1 & store_treat==2
** R Amt
mean target_future if pid_3==1 & store_treat==3
** D Amt
mean target_future if pid_3==1 & store_treat==4

** Table A5, Study 1, Row 13 (TJ Maxx)
** Ctrl
mean tjm_future if pid_3==1 & store_treat==5
** R%
mean tjm_future if pid_3==1 & store_treat==1
** D%
mean tjm_future if pid_3==1 & store_treat==2
** R Amt
mean tjm_future if pid_3==1 & store_treat==3
** D Amt
mean tjm_future if pid_3==1 & store_treat==4
** Diference in R% and Ctrl means among Republicans
ttest tjm_future if pid_3==1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A5, Study 1, Row 14 (Walmart)
mean wm_future if pid_3==1 & store_treat==5
mean wm_future if pid_3==1 & store_treat==1
mean wm_future if pid_3==1 & store_treat==2
mean wm_future if pid_3==1 & store_treat==3
mean wm_future if pid_3==1 & store_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest wm_future if pid_3==1 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest wm_future if pid_3==1 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

clear

use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study2_Final.dta"

** Table A5, Study 2, Row 1 (Burger King)
** Ctrl
mean bk_future if pid_3==2 & ham_treat==5
** R%
mean bk_future if pid_3==2 & ham_treat==1
** D%
mean bk_future if pid_3==2 & ham_treat==2
** R Amt
mean bk_future if pid_3==2 & ham_treat==3
** D Amt
mean bk_future if pid_3==2 & ham_treat==4
** Diference in D% and Ctrl means among Democrats
ttest bk_future if pid_3==2 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A5, Study 2, Row 2 (McDonalds)
** Ctrl
mean mcd_future if pid_3==2 & ham_treat==5
** R%
mean mcd_future if pid_3==2 & ham_treat==1
** D%
mean mcd_future if pid_3==2 & ham_treat==2
** R Amt
mean mcd_future if pid_3==2 & ham_treat==3
** D Amt
mean mcd_future if pid_3==2 & ham_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest mcd_future if pid_3==2 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest mcd_future if pid_3==2 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)


** Table A5, Study 2, Row 3 (Wendys)
** Ctrl
mean wendys_future if pid_3==2 & ham_treat==5
** R%
mean wendys_future if pid_3==2 & ham_treat==1
** D%
mean wendys_future if pid_3==2 & ham_treat==2
** R Amt
mean wendys_future if pid_3==2 & ham_treat==3
** D Amt
mean wendys_future if pid_3==2 & ham_treat==4
** Diference in R% and Ctrl means among Democrats
ttest wendys_future if pid_3==2 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)


** Table A5, Study 2, Row 4 (Burger King)
** Ctrl
mean bk_future if pid_3==1 & ham_treat==5
** R%
mean bk_future if pid_3==1 & ham_treat==1
** D%
mean bk_future if pid_3==1 & ham_treat==2
** R Amt
mean bk_future if pid_3==1 & ham_treat==3
** D Amt
mean bk_future if pid_3==1 & ham_treat==4
** Diference in D% and Ctrl means among Republicans
ttest bk_future if pid_3==1 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A5, Study 2, Row 5 (McDonalds)
** Ctrl
mean mcd_future if pid_3==1 & ham_treat==5
** R%
mean mcd_future if pid_3==1 & ham_treat==1
** D%
mean mcd_future if pid_3==1 & ham_treat==2
** R Amt
mean mcd_future if pid_3==1 & ham_treat==3
** D Amt
mean mcd_future if pid_3==1 & ham_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest mcd_future if pid_3==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest mcd_future if pid_3==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)


** Table A5, Study 2, Row 6 (Wendys)
** Ctrl
mean wendys_future if pid_3==1 & ham_treat==5
** R%
mean wendys_future if pid_3==1 & ham_treat==1
** D%
mean wendys_future if pid_3==1 & ham_treat==2
** R Amt
mean wendys_future if pid_3==1 & ham_treat==3
** D Amt
mean wendys_future if pid_3==1 & ham_treat==4
** Diference in R% and Ctrl means among Republicans
ttest wendys_future if pid_3==1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)


** Table A5, Study 2, Row 7 (Bed Bath and Beyond)
** Ctrl
mean bbb_future if pid_3==2 & store_treat==5
** R%
mean bbb_future if pid_3==2 & store_treat==1
** D%
mean bbb_future if pid_3==2 & store_treat==2
** R Amt
mean bbb_future if pid_3==2 & store_treat==3
** D Amt
mean bbb_future if pid_3==2 & store_treat==4
** Diference in D% and Ctrl means among Democrats
ttest bbb_future if pid_3==2 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)


** Table A5, Study 2, Row 8 (Target)
** Ctrl
mean target_future if pid_3==2 & store_treat==5
** R%
mean target_future if pid_3==2 & store_treat==1
** D%
mean target_future if pid_3==2 & store_treat==2
** R Amt
mean target_future if pid_3==2 & store_treat==3
** D Amt
mean target_future if pid_3==2 & store_treat==4


** Table A5, Study 2, Row 10 (Walmart)
** Ctrl
mean wm_future if pid_3==2 & store_treat==5
** R%
mean wm_future if pid_3==2 & store_treat==1
** D%
mean wm_future if pid_3==2 & store_treat==2
** R Amt
mean wm_future if pid_3==2 & store_treat==3
** D Amt
mean wm_future if pid_3==2 & store_treat==4
** Diference in R% and Ctrl means among Democrats
ttest wm_future if pid_3==2 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)
** Diference in R Amt and Ctrl means among Democrats
ttest wm_future if pid_3==2 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest wm_future if pid_3==2 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

** Table A5, Study 2, Row 11 (Bed Bath and Beyond)
** Ctrl
mean bbb_future if pid_3==1 & store_treat==5
** R%
mean bbb_future if pid_3==1 & store_treat==1
** D%
mean bbb_future if pid_3==1 & store_treat==2
** R Amt
mean bbb_future if pid_3==1 & store_treat==3
** D Amt
mean bbb_future if pid_3==1 & store_treat==4
** Diference in D% and Ctrl means among Republicans
ttest bbb_future if pid_3==1 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)


** Table A5, Study 2, Row 12 (Target)
** Ctrl
mean target_future if pid_3==1 & store_treat==5
** R%
mean target_future if pid_3==1 & store_treat==1
** D%
mean target_future if pid_3==1 & store_treat==2
** R Amt
mean target_future if pid_3==1 & store_treat==3
** D Amt
mean target_future if pid_3==1 & store_treat==4

** Table A5, Study 2, Row 14 (Walmart)
** Ctrl
mean wm_future if pid_3==1 & store_treat==5
** R%
mean wm_future if pid_3==1 & store_treat==1
** D%
mean wm_future if pid_3==1 & store_treat==2
** R Amt
mean wm_future if pid_3==1 & store_treat==3
** D Amt
mean wm_future if pid_3==1 & store_treat==4
** Diference in R% and Ctrl means among Republicans
ttest wm_future if pid_3==1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)
** Diference in R Amt and Ctrl means among Republicans
ttest wm_future if pid_3==1 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest wm_future if pid_3==1 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

** Table A5, Study 2, Row 15 (Dominos)
** Ctrl
mean dominos_future if pid_3==2 & pizza_treat==5
** R%
mean dominos_future if pid_3==2 & pizza_treat==1
** D%
mean dominos_future if pid_3==2 & pizza_treat==2
** R Amt
mean dominos_future if pid_3==2 & pizza_treat==3
** D Amt
mean dominos_future if pid_3==2 & pizza_treat==4
** Diference in D% and Ctrl means among Democrats
ttest dominos_future if pid_3==2 & pizza_treat!=1 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)

** Table A5, Study 2, Row 16 (Papa Johns)
** Ctrl
mean papajohns_future if pid_3==2 & pizza_treat==5
** R%
mean papajohns_future if pid_3==2 & pizza_treat==1
** D%
mean papajohns_future if pid_3==2 & pizza_treat==2
** R Amt
mean papajohns_future if pid_3==2 & pizza_treat==3
** D Amt
mean papajohns_future if pid_3==2 & pizza_treat==4


** Table A5, Study 2, Row 17 (Pizza Hut)
** Ctrl
mean pizzahut_future if pid_3==2 & pizza_treat==5
** R%
mean pizzahut_future if pid_3==2 & pizza_treat==1
** D%
mean pizzahut_future if pid_3==2 & pizza_treat==2
** R Amt
mean pizzahut_future if pid_3==2 & pizza_treat==3
** D Amt
mean pizzahut_future if pid_3==2 & pizza_treat==4
** Diference in R% and Ctrl means among Democrats
ttest pizzahut_future if pid_3==2 & pizza_treat!=2 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)
** Diference in R Amt and Ctrl means among Democrats
ttest pizzahut_future if pid_3==2 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=4, by (pizza_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest pizzahut_future if pid_3==2 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=3, by (pizza_treat)



** Table A5, Study 2, Row 18 (Dominos)
** Ctrl
mean dominos_future if pid_3==1 & pizza_treat==5
** R%
mean dominos_future if pid_3==1 & pizza_treat==1
** D%
mean dominos_future if pid_3==1 & pizza_treat==2
** R Amt
mean dominos_future if pid_3==1 & pizza_treat==3
** D Amt
mean dominos_future if pid_3==1 & pizza_treat==4
** Diference in D% and Ctrl means among Republicans
ttest dominos_future if pid_3==1 & pizza_treat!=1 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)


** Table A5, Study 2, Row 19 (Papa Johns)
** Ctrl
mean papajohns_future if pid_3==1 & pizza_treat==5
** R%
mean papajohns_future if pid_3==1 & pizza_treat==1
** D%
mean papajohns_future if pid_3==1 & pizza_treat==2
** R Amt
mean papajohns_future if pid_3==1 & pizza_treat==3
** D Amt
mean papajohns_future if pid_3==1 & pizza_treat==4


** Table A5, Study 2, Row 20 (Pizza Hut)
** Ctrl
mean pizzahut_future if pid_3==1 & pizza_treat==5
** R%
mean pizzahut_future if pid_3==1 & pizza_treat==1
** D%
mean pizzahut_future if pid_3==1 & pizza_treat==2
** R Amt
mean pizzahut_future if pid_3==1 & pizza_treat==3
** D Amt
mean pizzahut_future if pid_3==1 & pizza_treat==4
** Diference in R% and Ctrl means among Republicans
ttest pizzahut_future if pid_3==1 & pizza_treat!=2 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)
** Diference in R Amt and Ctrl means among Republicans
ttest pizzahut_future if pid_3==1 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=4, by (pizza_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest pizzahut_future if pid_3==1 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=3, by (pizza_treat)

** Drug Stores **

** Table A5, Study 2, Row 21 (CVS)
** Ctrl
mean cvs_future if pid_3==2 & drug_treat==5
** R%
mean cvs_future if pid_3==2 & drug_treat==1
** D%
mean cvs_future if pid_3==2 & drug_treat==2
** R Amt
mean cvs_future if pid_3==2 & drug_treat==3
** D Amt
mean cvs_future if pid_3==2 & drug_treat==4
** Diference in D% and Ctrl means among Democrats
ttest cvs_future if pid_3==2 & drug_treat!=1 & drug_treat!=3 & drug_treat!=4, by (drug_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest cvs_future if pid_3==2 & drug_treat!=1 & drug_treat!=2 & drug_treat!=3, by (drug_treat)


** Table A5, Study 2, Row 22 (Rite Aid)
** Ctrl
mean riteaid_future if pid_3==2 & drug_treat==5
** R%
mean riteaid_future if pid_3==2 & drug_treat==1
** D%
mean riteaid_future if pid_3==2 & drug_treat==2
** R Amt
mean riteaid_future if pid_3==2 & drug_treat==3
** D Amt
mean riteaid_future if pid_3==2 & drug_treat==4
** Diference in R% and Ctrl means among Democrats
ttest riteaid_future if pid_3==2 & drug_treat!=2 & drug_treat!=3 & drug_treat!=4, by (drug_treat)


** Table A5, Study 2, Row 23 (Walgreens)
** Ctrl
mean walgreens_future if pid_3==2 & drug_treat==5
** R%
mean walgreens_future if pid_3==2 & drug_treat==1
** D%
mean walgreens_future if pid_3==2 & drug_treat==2
** R Amt
mean walgreens_future if pid_3==2 & drug_treat==3
** D Amt
mean walgreens_future if pid_3==2 & drug_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest walgreens_future if pid_3==2 & drug_treat!=1 & drug_treat!=2 & drug_treat!=4, by (drug_treat)

** Table A5, Study 2, Row 24 (CVS)
** Ctrl
mean cvs_future if pid_3==1 & drug_treat==5
** R%
mean cvs_future if pid_3==1 & drug_treat==1
** D%
mean cvs_future if pid_3==1 & drug_treat==2
** R Amt
mean cvs_future if pid_3==1 & drug_treat==3
** D Amt
mean cvs_future if pid_3==1 & drug_treat==4
** Diference in D% and Ctrl means among Republicans
ttest cvs_future if pid_3==1 & drug_treat!=1 & drug_treat!=3 & drug_treat!=4, by (drug_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest cvs_future if pid_3==1 & drug_treat!=1 & drug_treat!=2 & drug_treat!=3, by (drug_treat)


** Table A5, Study 2, Row 25 (Rite Aid)
** Ctrl
mean riteaid_future if pid_3==1 & drug_treat==5
** R%
mean riteaid_future if pid_3==1 & drug_treat==1
** D%
mean riteaid_future if pid_3==1 & drug_treat==2
** R Amt
mean riteaid_future if pid_3==1 & drug_treat==3
** D Amt
mean riteaid_future if pid_3==1 & drug_treat==4
** Diference in R% and Ctrl means among Republicans
ttest riteaid_future if pid_3==1 & drug_treat!=2 & drug_treat!=3 & drug_treat!=4, by (drug_treat)


** Table A5, Study 2, Row 26 (Walgreens)
** Ctrl
mean walgreens_future if pid_3==1 & drug_treat==5
** R%
mean walgreens_future if pid_3==1 & drug_treat==1
** D%
mean walgreens_future if pid_3==1 & drug_treat==2
** R Amt
mean walgreens_future if pid_3==1 & drug_treat==3
** D Amt
mean walgreens_future if pid_3==1 & drug_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest walgreens_future if pid_3==1 & drug_treat!=1 & drug_treat!=2 & drug_treat!=4, by (drug_treat)
clear

use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study3_Final.dta"
** Table A5, Study 3, Row 29 (Burger King)
** Amount Control
mean burgerking if ham_treat==5  & democrat==1
** Amount GOP Treatment
mean burgerking if ham_treat==3 & democrat==1
** Amount Dem Treatment
mean burgerking if ham_treat==4 & democrat==1

** Table A5, Study 3, Row 30 (McDonalds)
** Amount Control
mean mcdonalds if ham_treat==5  & democrat==1
** Amount GOP Treatment
mean mcdonalds if ham_treat==3 & democrat==1
** Amount Dem Treatment
mean mcdonalds if ham_treat==4 & democrat==1
** Diference in R Amt and Ctrl means among Democrats
ttest mcdonalds if ham_treat!=4 & democrat==1, by(ham_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest mcdonalds if ham_treat!=3 & democrat==1, by(ham_treat)

** Table A5, Study 3, Row 31 (Wendys)
** Amount Control
mean wendys if ham_treat==5  & republican==1
** Amount GOP Treatment
mean wendys if ham_treat==3 & republican==1
** Amount Dem Treatment
mean wendys if ham_treat==4 & republican==1

** Table A5, Study 3, Row 32 (Burger King)
** Amount Control
mean burgerking if ham_treat==5  & republican==1
** Amount GOP Treatment
mean burgerking if ham_treat==3 & republican==1
** Amount Dem Treatment
mean burgerking if ham_treat==4 & republican==1

** Table A5, Study 3, Row 33 (McDonalds)
** Amount Control
mean mcdonalds if ham_treat==5  & republican==1
** Amount GOP Treatment
mean mcdonalds if ham_treat==3 & republican==1
** Amount Dem Treatment
mean mcdonalds if ham_treat==4 & republican==1
** Diference in R Amt and Ctrl means among Democrats
ttest mcdonalds if ham_treat!=4 & republican==1, by(ham_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest mcdonalds if ham_treat!=3 & republican==1, by(ham_treat)

** Table A5, Study 3, Row 34 (Wendys)
** Amount Control
mean wendys if ham_treat==5  & republican==1
** Amount GOP 
mean wendys if ham_treat==3 & republican==1
** Amount Dem
mean wendys if ham_treat==4 & republican==1

** Table A5, Study 3, Row 35 (Bed Bath and Beyond)
** Control
mean BBB if store_treat==5  & democrat==1
** R% 
mean BBB if store_treat==1 & democrat==1
** D%
mean BBB if store_treat==2 & democrat==1
** Diference in D% and Ctrl means among Democrats
ttest BBB if store_treat!=1 & democrat==1, by(store_treat)

** Table A5, Study 3, Row 36 (Kohls)
** Control
mean kohls if store_treat==5  & democrat==1
** R% 
mean kohls if store_treat==1 & democrat==1
** D%
mean kohls if store_treat==2 & democrat==1

** Table A5, Study 3, Row 37 (Target)
** Control
mean target if store_treat==5  & democrat==1
** R% 
mean target if store_treat==1 & democrat==1
** D%
mean target if store_treat==2 & democrat==1

** Table A5, Study 3, Row 38 (Walmart)
** Control
mean walmart if store_treat==5  & democrat==1
** R% 
mean walmart if store_treat==1 & democrat==1
** D%
mean walmart if store_treat==2 & democrat==1
** Diference in R% and Ctrl means among Democrats
ttest walmart if store_treat!=2 & democrat==1, by(store_treat)

** Table A5, Study 3, Row 39 (Bed Bath and Beyond)
** Control
mean BBB if store_treat==5  & republican==1
** R% 
mean BBB if store_treat==1 & republican==1
** D%
mean BBB if store_treat==2 & republican==1
** Diference in D% and Ctrl means among Democrats
ttest BBB if store_treat!=1 & republican==1, by(store_treat)

** Table A5, Study 3, Row 40 (Kohls)
** Control
mean kohls if store_treat==5  & republican==1
** R% 
mean kohls if store_treat==1 & republican==1
** D%
mean kohls if store_treat==2 & republican==1

** Table A5, Study 3, Row 41 (Target)
** Control
mean target if store_treat==5  & republican==1
** R% 
mean target if store_treat==1 & republican==1
** D%
mean target if store_treat==2 & republican==1

** Table A5, Study 3, Row 42 (Walmart)
** Control
mean walmart if store_treat==5  & republican==1
** R% 
mean walmart if store_treat==1 & republican==1
** D%
mean walmart if store_treat==2 & republican==1
** Diference in R% and Ctrl means among Democrats
ttest walmart if store_treat!=2 & republican==1, by(store_treat)
clear



*** TABLE A6 ***
//  Respondents' Choice of Gift Cards by Experimental Condition in Studies 1 and 2, Controlling for Partisanship with “Leaning” Independents Included as Partisans


use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study1_Final.dta"
** Table A6, Study 1, Row 1 (Burger King)
** Ctrl
mean ham_card_bk if dems_wlean==1 & ham_treat==5
** R%
mean ham_card_bk if dems_wlean==1 & ham_treat==1
** D%
mean ham_card_bk if dems_wlean==1 & ham_treat==2
** R Amt
mean ham_card_bk if dems_wlean==1 & ham_treat==3
** D Amt
mean ham_card_bk if dems_wlean==1 & ham_treat==4
** Diference in D% and Ctrl means among Democrats
ttest ham_card_bk if dems_wlean==1 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A6, Study 1, Row 2 (McDonalds)
** Ctrl
mean ham_card_mcd if dems_wlean==1 & ham_treat==5
** R%
mean ham_card_mcd if dems_wlean==1 & ham_treat==1
** D%
mean ham_card_mcd if dems_wlean==1 & ham_treat==2
** R Amt
mean ham_card_mcd if dems_wlean==1 & ham_treat==3
** D Amt
mean ham_card_mcd if dems_wlean==1 & ham_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest ham_card_mcd if dems_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest ham_card_mcd if dems_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A6, Study 1, Row 3 (Wendys)
** Ctrl
mean ham_card_wendys if dems_wlean==1 & ham_treat==5
** R%
mean ham_card_wendys if dems_wlean==1 & ham_treat==1
** D%
mean ham_card_wendys if dems_wlean==1 & ham_treat==2
** R Amt
mean ham_card_wendys if dems_wlean==1 & ham_treat==3
** D Amt
mean ham_card_wendys if dems_wlean==1 & ham_treat==4
** Diference in R% and Ctrl means among Democrats
ttest ham_card_wendys if dems_wlean==1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A6, Study 1, Row 4 (Burger King)
** Ctrl
mean ham_card_bk if reps_wlean==1 & ham_treat==5
** R%
mean ham_card_bk if reps_wlean==1 & ham_treat==1
** D%
mean ham_card_bk if reps_wlean==1 & ham_treat==2
** R Amt
mean ham_card_bk if reps_wlean==1 & ham_treat==3
** D Amt
mean ham_card_bk if reps_wlean==1 & ham_treat==4
** Diference in D% and Ctrl means among Republicans
ttest ham_card_bk if reps_wlean==1 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A6, Study 1, Row 5 (McDonalds)
** Ctrl
mean ham_card_mcd if reps_wlean==1 & ham_treat==5
** R%
mean ham_card_mcd if reps_wlean==1 & ham_treat==1
** D%
mean ham_card_mcd if reps_wlean==1 & ham_treat==2
** R Amt
mean ham_card_mcd if reps_wlean==1 & ham_treat==3
** D Amt
mean ham_card_mcd if reps_wlean==1 & ham_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest ham_card_mcd if reps_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest ham_card_mcd if reps_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A6, Study 1, Row 6 (Wendys)
** Ctrl
mean ham_card_wendys if reps_wlean==1 & ham_treat==5
** R%
mean ham_card_wendys if reps_wlean==1 & ham_treat==1
** D%
mean ham_card_wendys if reps_wlean==1 & ham_treat==2
** R Amt
mean ham_card_wendys if reps_wlean==1 & ham_treat==3
** D Amt
mean ham_card_wendys if reps_wlean==1 & ham_treat==4
** Diference in R% and Ctrl means among Republicans
ttest ham_card_wendys if reps_wlean==1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A6, Study 1, Row 7 (Bed Bath and Beyond)
** Ctrl
mean store_card_bbb if dems_wlean==1 & store_treat==5
** R%
mean store_card_bbb if dems_wlean==1 & store_treat==1
** D%
mean store_card_bbb if dems_wlean==1 & store_treat==2
** R Amt
mean store_card_bbb if dems_wlean==1 & store_treat==3
** D Amt
mean store_card_bbb if dems_wlean==1 & store_treat==4
** Diference in D% and Ctrl means among Democrats
ttest store_card_bbb if dems_wlean==1 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A6, Study 1, Row 8 (Target)
** Ctrl
mean store_card_target if dems_wlean==1 & store_treat==5
** R%
mean store_card_target if dems_wlean==1 & store_treat==1
** D%
mean store_card_target if dems_wlean==1 & store_treat==2
** R Amt
mean store_card_target if dems_wlean==1 & store_treat==3
** D Amt
mean store_card_target if dems_wlean==1 & store_treat==4

** Table A6, Study 1, Row 9 (TJ Maxx)
** Ctrl
mean store_card_tjm if dems_wlean==1 & store_treat==5
** R%
mean store_card_tjm if dems_wlean==1 & store_treat==1
** D%
mean store_card_tjm if dems_wlean==1 & store_treat==2
** R Amt
mean store_card_tjm if dems_wlean==1 & store_treat==3
** D Amt
mean store_card_tjm if dems_wlean==1 & store_treat==4
** Diference in R% and Ctrl means among Democrats
ttest store_card_tjm if dems_wlean==1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A6, Study 1, Row 10 (Walmart)
** Ctrl
mean store_card_wm if dems_wlean==1 & store_treat==5
** R%
mean store_card_wm if dems_wlean==1 & store_treat==1
** D%
mean store_card_wm if dems_wlean==1 & store_treat==2
** R Amt
mean store_card_wm if dems_wlean==1 & store_treat==3
** D Amt
mean store_card_wm if dems_wlean==1 & store_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest store_card_wm if dems_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest store_card_wm if dems_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

** Table A6, Study 1, Row 11 (Bed Bath and Beyond)
** Ctrl
mean store_card_bbb if reps_wlean==1 & store_treat==5
** R%
mean store_card_bbb if reps_wlean==1 & store_treat==1
** D%
mean store_card_bbb if reps_wlean==1 & store_treat==2
** R Amt
mean store_card_bbb if reps_wlean==1 & store_treat==3
** D Amt
mean store_card_bbb if reps_wlean==1 & store_treat==4
** Diference in D% and Ctrl means among Republicans
ttest store_card_bbb if reps_wlean==1 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A6, Study 1, Row 12 (Target)
** Ctrl
mean store_card_target if reps_wlean==1 & store_treat==5
** R%
mean store_card_target if reps_wlean==1 & store_treat==1
** D%
mean store_card_target if reps_wlean==1 & store_treat==2
** R Amt
mean store_card_target if reps_wlean==1 & store_treat==3
** D Amt
mean store_card_target if reps_wlean==1 & store_treat==4

** Table A6, Study 1, Row 13 (TJ Maxx)
** Ctrl
mean store_card_tjm if reps_wlean==1 & store_treat==5
** R%
mean store_card_tjm if reps_wlean==1 & store_treat==1
** D%
mean store_card_tjm if reps_wlean==1 & store_treat==2
** R Amt
mean store_card_tjm if reps_wlean==1 & store_treat==3
** D Amt
mean store_card_tjm if reps_wlean==1 & store_treat==4
** Diference in R% and Ctrl means among Republicans
ttest store_card_tjm if reps_wlean==1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A6, Study 1, Row 13 (Walmart)
** Ctrl
mean store_card_wm if reps_wlean==1 & store_treat==5
** R%
mean store_card_wm if reps_wlean==1 & store_treat==1
** D%
mean store_card_wm if reps_wlean==1 & store_treat==2
** R Amt
mean store_card_wm if reps_wlean==1 & store_treat==3
** D Amt
mean store_card_wm if reps_wlean==1 & store_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest store_card_wm if reps_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest store_card_wm if reps_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)
clear

use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study2_Final.dta"
** Table A6, Study 2, Row 1 (Burger King)
** Ctrl
mean ham_card_bk if dems_wlean==1 & ham_treat==5
** R%
mean ham_card_bk if dems_wlean==1 & ham_treat==1
** D%
mean ham_card_bk if dems_wlean==1 & ham_treat==2
** R Amt
mean ham_card_bk if dems_wlean==1 & ham_treat==3
** D Amt
mean ham_card_bk if dems_wlean==1 & ham_treat==4
** Diference in D% and Ctrl means among Democrats
ttest ham_card_bk if dems_wlean==1 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A6, Study 2, Row 2 (McDonalds)
** Ctrl
mean ham_card_mcd if dems_wlean==1 & ham_treat==5
** R%
mean ham_card_mcd if dems_wlean==1 & ham_treat==1
** D%
mean ham_card_mcd if dems_wlean==1 & ham_treat==2
** R Amt
mean ham_card_mcd if dems_wlean==1 & ham_treat==3
** D Amt
mean ham_card_mcd if dems_wlean==1 & ham_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest ham_card_mcd if dems_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest ham_card_mcd if dems_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A6, Study 2, Row 3 (Wendys)
** Ctrl
mean ham_card_wendys if dems_wlean==1 & ham_treat==5
** R%
mean ham_card_wendys if dems_wlean==1 & ham_treat==1
** D%
mean ham_card_wendys if dems_wlean==1 & ham_treat==2
** R Amt
mean ham_card_wendys if dems_wlean==1 & ham_treat==3
** D Amt
mean ham_card_wendys if dems_wlean==1 & ham_treat==4
** Diference in R% and Ctrl means among Democrats
ttest ham_card_wendys if dems_wlean==1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A6, Study 2, Row 4 (Burger King)
** Ctrl
mean ham_card_bk if reps_wlean==1 & ham_treat==5
** R%
mean ham_card_bk if reps_wlean==1 & ham_treat==1
** D%
mean ham_card_bk if reps_wlean==1 & ham_treat==2
** R Amt
mean ham_card_bk if reps_wlean==1 & ham_treat==3
** D Amt
mean ham_card_bk if reps_wlean==1 & ham_treat==4
** Diference in D% and Ctrl means among Republicans
ttest ham_card_bk if reps_wlean==1 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A6, Study 2, Row 5 (McDonalds)
** Ctrl
mean ham_card_mcd if reps_wlean==1 & ham_treat==5
** R%
mean ham_card_mcd if reps_wlean==1 & ham_treat==1
** D%
mean ham_card_mcd if reps_wlean==1 & ham_treat==2
** R Amt
mean ham_card_mcd if reps_wlean==1 & ham_treat==3
** D Amt
mean ham_card_mcd if reps_wlean==1 & ham_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest ham_card_mcd if reps_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest ham_card_mcd if reps_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A6, Study 2, Row 6 (Wendys)
** Ctrl
mean ham_card_wendys if reps_wlean==1 & ham_treat==5
** R%
mean ham_card_wendys if reps_wlean==1 & ham_treat==1
** D%
mean ham_card_wendys if reps_wlean==1 & ham_treat==2
** R Amt
mean ham_card_wendys if reps_wlean==1 & ham_treat==3
** D Amt
mean ham_card_wendys if reps_wlean==1 & ham_treat==4
** Diference in R% and Ctrl means among Republicans
ttest ham_card_wendys if reps_wlean==1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A6, Study 2, Row 7 (Bed Bath and Beyond)
** Ctrl
mean store_card_bbb if dems_wlean==1 & store_treat==5
** R%
mean store_card_bbb if dems_wlean==1 & store_treat==1
** D%
mean store_card_bbb if dems_wlean==1 & store_treat==2
** R Amt
mean store_card_bbb if dems_wlean==1 & store_treat==3
** D Amt
mean store_card_bbb if dems_wlean==1 & store_treat==4
** Diference in D% and Ctrl means among Democrats
ttest store_card_bbb if dems_wlean==1 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A6, Study 2, Row 8 (Target)
** Ctrl
mean store_card_target if dems_wlean==1 & store_treat==5
** R%
mean store_card_target if dems_wlean==1 & store_treat==1
** D%
mean store_card_target if dems_wlean==1 & store_treat==2
** R Amt
mean store_card_target if dems_wlean==1 & store_treat==3
** D Amt
mean store_card_target if dems_wlean==1 & store_treat==4

** Table A6, Study 2, Row 10 (Walmart)
** Ctrl
mean store_card_wm if dems_wlean==1 & store_treat==5
** R%
mean store_card_wm if dems_wlean==1 & store_treat==1
** D%
mean store_card_wm if dems_wlean==1 & store_treat==2
** R Amt
mean store_card_wm if dems_wlean==1 & store_treat==3
** D Amt
mean store_card_wm if dems_wlean==1 & store_treat==4
** Diference in R% and Ctrl means among Democrats
ttest store_card_wm if dems_wlean==1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)
** Diference in R Amt and Ctrl means among Democrats
ttest store_card_wm if dems_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest store_card_wm if dems_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

** Table A6, Study 2, Row 11 (Bed Bath and Beyond)
** Ctrl
mean store_card_bbb if reps_wlean==1 & store_treat==5
** R%
mean store_card_bbb if reps_wlean==1 & store_treat==1
** D%
mean store_card_bbb if reps_wlean==1 & store_treat==2
** R Amt
mean store_card_bbb if reps_wlean==1 & store_treat==3
**  D Amt
mean store_card_bbb if reps_wlean==1 & store_treat==4
** Diference in D% and Ctrl means among Republicans
ttest store_card_bbb if reps_wlean==1 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A6, Study 2, Row 12 (Target)
** Ctrl
mean store_card_target if reps_wlean==1 & store_treat==5
** R%
mean store_card_target if reps_wlean==1 & store_treat==1
** D%
mean store_card_target if reps_wlean==1 & store_treat==2
** R Amt
mean store_card_target if reps_wlean==1 & store_treat==3
** D Amt
mean store_card_target if reps_wlean==1 & store_treat==4

** Table A6, Study 2, Row 14 (Walmart)
** Ctrl
mean store_card_wm if reps_wlean==1 & store_treat==5
** R%
mean store_card_wm if reps_wlean==1 & store_treat==1
** D%
mean store_card_wm if reps_wlean==1 & store_treat==2
** R Amt
mean store_card_wm if reps_wlean==1 & store_treat==3
** D Amt
mean store_card_wm if reps_wlean==1 & store_treat==4
** Diference in R% and Ctrl means among Republicans
ttest store_card_wm if reps_wlean==1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)
** Diference in R Amt and Ctrl means among Republicans
ttest store_card_wm if reps_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest store_card_wm if reps_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

** Table A6, Study 2, Row 15 (Dominos)
** Ctrl
mean pizza_card_dominos if dems_wlean==1 & pizza_treat==5
** R%
mean pizza_card_dominos if dems_wlean==1 & pizza_treat==1
** D%
mean pizza_card_dominos if dems_wlean==1 & pizza_treat==2
** R Amt
mean pizza_card_dominos if dems_wlean==1 & pizza_treat==3
** D Amt
mean pizza_card_dominos if dems_wlean==1 & pizza_treat==4
** Diference in D% and Ctrl means among Democrats
ttest pizza_card_dominos if dems_wlean==1 & pizza_treat!=1 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)

** Table A6, Study 2, Row 16 (Papa Johns)
** Ctrl
mean pizza_card_papajohns if dems_wlean==1 & pizza_treat==5
** R%
mean pizza_card_papajohns if dems_wlean==1 & pizza_treat==1
** D%
mean pizza_card_papajohns if dems_wlean==1 & pizza_treat==2
** R Amt
mean pizza_card_papajohns if dems_wlean==1 & pizza_treat==3
** D Amt
mean pizza_card_papajohns if dems_wlean==1 & pizza_treat==4

** Table A6, Study 2, Row 17 (Pizza Hut)
** Ctrl
mean pizza_card_pizzahut if dems_wlean==1 & pizza_treat==5
** R%
mean pizza_card_pizzahut if dems_wlean==1 & pizza_treat==1
** D%
mean pizza_card_pizzahut if dems_wlean==1 & pizza_treat==2
** R Amt
mean pizza_card_pizzahut if dems_wlean==1 & pizza_treat==3
** D Amt
mean pizza_card_pizzahut if dems_wlean==1 & pizza_treat==4
** Diference in R% and Ctrl means among Democrats
ttest pizza_card_pizzahut if dems_wlean==1 & pizza_treat!=2 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)
** Diference in R Amt and Ctrl means among Democrats
ttest pizza_card_pizzahut if dems_wlean==1 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=4, by (pizza_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest pizza_card_pizzahut if dems_wlean==1 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=3, by (pizza_treat)

** Table A6, Study 2, Row 18 (Dominos)
** Ctrl
mean pizza_card_dominos if reps_wlean==1 & pizza_treat==5
** R%
mean pizza_card_dominos if reps_wlean==1 & pizza_treat==1
** D%
mean pizza_card_dominos if reps_wlean==1 & pizza_treat==2
** R Amt
mean pizza_card_dominos if reps_wlean==1 & pizza_treat==3
**  D Amt
mean pizza_card_dominos if reps_wlean==1 & pizza_treat==4
** Diference in D% and Ctrl means among Republicans
ttest pizza_card_dominos if reps_wlean==1 & pizza_treat!=1 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)

** Table A6, Study 2, Row 19 (Papa Johns)
** Ctrl
mean pizza_card_papajohns if reps_wlean==1 & pizza_treat==5
** R%
mean pizza_card_papajohns if reps_wlean==1 & pizza_treat==1
** D%
mean pizza_card_papajohns if reps_wlean==1 & pizza_treat==2
** R Amt
mean pizza_card_papajohns if reps_wlean==1 & pizza_treat==3
** D Amt
mean pizza_card_papajohns if reps_wlean==1 & pizza_treat==4

** Table A6, Study 2, Row 20 (Pizza Hut)
** Ctrl
mean pizza_card_pizzahut if reps_wlean==1 & pizza_treat==5
** R%
mean pizza_card_pizzahut if reps_wlean==1 & pizza_treat==1
** D%
mean pizza_card_pizzahut if reps_wlean==1 & pizza_treat==2
** R Amt
mean pizza_card_pizzahut if reps_wlean==1 & pizza_treat==3
** D Amt
mean pizza_card_pizzahut if reps_wlean==1 & pizza_treat==4
** Diference in R% and Ctrl means among Republicans
ttest pizza_card_pizzahut if reps_wlean==1 & pizza_treat!=2 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)
** Diference in R Amt and Ctrl means among Republicans
ttest pizza_card_pizzahut if reps_wlean==1 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=4, by (pizza_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest pizza_card_pizzahut if reps_wlean==1 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=3, by (pizza_treat)

** Table A6, Study 2, Row 21 (CVS)
** Ctrl
mean drugs_card_cvs if dems_wlean==1 & drug_treat==5
** R%
mean drugs_card_cvs if dems_wlean==1 & drug_treat==1
** D%
mean drugs_card_cvs if dems_wlean==1 & drug_treat==2
** R Amt
mean drugs_card_cvs if dems_wlean==1 & drug_treat==3
** D Amt
mean drugs_card_cvs if dems_wlean==1 & drug_treat==4
** Diference in D% and Ctrl means among Democrats
ttest drugs_card_cvs if dems_wlean==1 & drug_treat!=1 & drug_treat!=3 & drug_treat!=4, by (drug_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest drugs_card_cvs if dems_wlean==1 & drug_treat!=1 & drug_treat!=2 & drug_treat!=3, by (drug_treat)

** Table A6, Study 2, Row 22 (Rite Aid)
** Ctrl
mean drugs_card_riteaid if dems_wlean==1 & drug_treat==5
** R%
mean drugs_card_riteaid if dems_wlean==1 & drug_treat==1
** D%
mean drugs_card_riteaid if dems_wlean==1 & drug_treat==2
** R Amt
mean drugs_card_riteaid if dems_wlean==1 & drug_treat==3
** D Amt
mean drugs_card_riteaid if dems_wlean==1 & drug_treat==4
** Diference in R% and Ctrl means among Democrats
ttest drugs_card_riteaid if dems_wlean==1 & drug_treat!=2 & drug_treat!=3 & drug_treat!=4, by (drug_treat)

** Table A6, Study 2, Row 23 (Walgreens)
** Ctrl
mean drugs_card_walgreens if dems_wlean==1 & drug_treat==5
** R%
mean drugs_card_walgreens if dems_wlean==1 & drug_treat==1
** D%
mean drugs_card_walgreens if dems_wlean==1 & drug_treat==2
** R Amt
mean drugs_card_walgreens if dems_wlean==1 & drug_treat==3
** D Amt
mean drugs_card_walgreens if dems_wlean==1 & drug_treat==4
** Diference in R amt and Ctrl means among Democrats
ttest drugs_card_walgreens if dems_wlean==1 & drug_treat!=1 & drug_treat!=2 & drug_treat!=4, by (drug_treat)

** Table A6, Study 2, Row 24 (CVS)
** Ctrl
mean drugs_card_cvs if reps_wlean==1 & drug_treat==5
** R%
mean drugs_card_cvs if reps_wlean==1 & drug_treat==1
** D%
mean drugs_card_cvs if reps_wlean==1 & drug_treat==2
** R Amt
mean drugs_card_cvs if reps_wlean==1 & drug_treat==3
** D Amt
mean drugs_card_cvs if reps_wlean==1 & drug_treat==4
** Diference in D% and Ctrl means among Republicans
ttest drugs_card_cvs if reps_wlean==1 & drug_treat!=1 & drug_treat!=3 & drug_treat!=4, by (drug_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest drugs_card_cvs if reps_wlean==1 & drug_treat!=1 & drug_treat!=2 & drug_treat!=3, by (drug_treat)

** Table A6, Study 2, Row 25 (Rite Aid)
** Ctrl
mean drugs_card_riteaid if reps_wlean==1 & drug_treat==5
** R%
mean drugs_card_riteaid if reps_wlean==1 & drug_treat==1
** D%
mean drugs_card_riteaid if reps_wlean==1 & drug_treat==2
** R Amt
mean drugs_card_riteaid if reps_wlean==1 & drug_treat==3
** D Amt
mean drugs_card_riteaid if reps_wlean==1 & drug_treat==4
** Diference in R% and Ctrl means among Republicans
ttest drugs_card_riteaid if reps_wlean==1 & drug_treat!=2 & drug_treat!=3 & drug_treat!=4, by (drug_treat)

** Table A6, Study 2, Row 26 (Walgreens)
** Ctrl
mean drugs_card_walgreens if reps_wlean==1 & drug_treat==5
** R%
mean drugs_card_walgreens if reps_wlean==1 & drug_treat==1
** D%
mean drugs_card_walgreens if reps_wlean==1 & drug_treat==2
** R Amt
mean drugs_card_walgreens if reps_wlean==1 & drug_treat==3
** D Amt
mean drugs_card_walgreens if reps_wlean==1 & drug_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest drugs_card_walgreens if reps_wlean==1 & drug_treat!=1 & drug_treat!=2 & drug_treat!=4, by (drug_treat)
clear


*** TABLE A7 ***
** Shopping Intentions by Experimental Condition and Partisanship of the Respondent, Studies 1 and 2, with “Leaning” Independents Included as Partisans


use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study1_Final.dta"
** Table A7, Study 1, Row 1 (Burger King)
** Ctrl
mean bk_future if dems_wlean==1 & ham_treat==5
** R%
mean bk_future if dems_wlean==1 & ham_treat==1
** D%
mean bk_future if dems_wlean==1 & ham_treat==2
** R Amt
mean bk_future if dems_wlean==1 & ham_treat==3
** D Amt
mean bk_future if dems_wlean==1 & ham_treat==4
** Diference in D% and Ctrl means among Democrats
ttest bk_future if dems_wlean==1 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A7, Study 1, Row 2 (McDonalds)
** Ctrl
mean mcd_future if dems_wlean==1 & ham_treat==5
** R%
mean mcd_future if dems_wlean==1 & ham_treat==1
** D%
mean mcd_future if dems_wlean==1 & ham_treat==2
** R Amt
mean mcd_future if dems_wlean==1 & ham_treat==3
** D Amt
mean mcd_future if dems_wlean==1 & ham_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest mcd_future if dems_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest mcd_future if dems_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A7, Study 1, Row 3 (Wendys)
** Ctrl
mean wendys_future if dems_wlean==1 & ham_treat==5
** R%
mean wendys_future if dems_wlean==1 & ham_treat==1
** D%
mean wendys_future if dems_wlean==1 & ham_treat==2
** R Amt
mean wendys_future if dems_wlean==1 & ham_treat==3
** D Amt
mean wendys_future if dems_wlean==1 & ham_treat==4
** Diference in R% and Ctrl means among Democrats
ttest wendys_future if dems_wlean==1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A7, Study 1, Row 3 (Burger King)
** Ctrl
mean bk_future if reps_wlean==1 & ham_treat==5
** R%
mean bk_future if reps_wlean==1 & ham_treat==1
** D%
mean bk_future if reps_wlean==1 & ham_treat==2
** R Amt
mean bk_future if reps_wlean==1 & ham_treat==3
** D Amt
mean bk_future if reps_wlean==1 & ham_treat==4
** Diference in D% and Ctrl means among Republicans
ttest bk_future if reps_wlean==1 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A7, Study 1, Row 5 (McDonalds)
** Ctrl
mean mcd_future if reps_wlean==1 & ham_treat==5
** R%
mean mcd_future if reps_wlean==1 & ham_treat==1
** D%
mean mcd_future if reps_wlean==1 & ham_treat==2
** R Amt
mean mcd_future if reps_wlean==1 & ham_treat==3
** D Amt
mean mcd_future if reps_wlean==1 & ham_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest mcd_future if reps_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest mcd_future if reps_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A7, Study 1, Row 6 (Wendys)
** Ctrl
mean wendys_future if reps_wlean==1 & ham_treat==5
** R%
mean wendys_future if reps_wlean==1 & ham_treat==1
** D%
mean wendys_future if reps_wlean==1 & ham_treat==2
** R Amt
mean wendys_future if reps_wlean==1 & ham_treat==3
** D Amt
mean wendys_future if reps_wlean==1 & ham_treat==4
** Diference in R% and Ctrl means among Republicans
ttest wendys_future if reps_wlean==1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A7, Study 1, Row 7 (Bed Bath and Beyond)
** Ctrl
mean bbb_future if dems_wlean==1 & store_treat==5
** R%
mean bbb_future if dems_wlean==1 & store_treat==1
** D%
mean bbb_future if dems_wlean==1 & store_treat==2
** R Amt
mean bbb_future if dems_wlean==1 & store_treat==3
** D Amt
mean bbb_future if dems_wlean==1 & store_treat==4
** Diference in D% and Ctrl means among Democrats
ttest bbb_future if dems_wlean==1 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A7, Study 1, Row 8 (Target)
** Ctrl
mean target_future if dems_wlean==1 & store_treat==5
** R%
mean target_future if dems_wlean==1 & store_treat==1
** D%
mean target_future if dems_wlean==1 & store_treat==2
** R Amt
mean target_future if dems_wlean==1 & store_treat==3
** D Amt
mean target_future if dems_wlean==1 & store_treat==4

** Table A7, Study 1, Row 9 (TJ Maxx)
** Ctrl
mean tjm_future if dems_wlean==1 & store_treat==5
** R%
mean tjm_future if dems_wlean==1 & store_treat==1
** D%
mean tjm_future if dems_wlean==1 & store_treat==2
** R Amt
mean tjm_future if dems_wlean==1 & store_treat==3
** D Amt
mean tjm_future if dems_wlean==1 & store_treat==4
** Diference in R% and Ctrl means among Democrats
ttest tjm_future if dems_wlean==1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A7, Study 1, Row 10 (Walmart)
** Ctrl
mean wm_future if dems_wlean==1 & store_treat==5
** R%
mean wm_future if dems_wlean==1 & store_treat==1
** D%
mean wm_future if dems_wlean==1 & store_treat==2
** R Amt
mean wm_future if dems_wlean==1 & store_treat==3
** D Amt
mean wm_future if dems_wlean==1 & store_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest wm_future if dems_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest wm_future if dems_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

** Table A7, Study 1, Row 11 (Bed Bath and Beyond)
** Ctrl
mean bbb_future if reps_wlean==1 & store_treat==5
** R%
mean bbb_future if reps_wlean==1 & store_treat==1
** D%
mean bbb_future if reps_wlean==1 & store_treat==2
** R Amt
mean bbb_future if reps_wlean==1 & store_treat==3
** D Amt
mean bbb_future if reps_wlean==1 & store_treat==4
** Diference in D% and Ctrl means among Democrats
ttest bbb_future if reps_wlean==1 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A7, Study 1, Row 12 (Target)
** Ctrl
mean target_future if reps_wlean==1 & store_treat==5
** R%
mean target_future if reps_wlean==1 & store_treat==1
** D%
mean target_future if reps_wlean==1 & store_treat==2
** R Amt
mean target_future if reps_wlean==1 & store_treat==3
** D Amt
mean target_future if reps_wlean==1 & store_treat==4

** Table A7, Study 1, Row 13 (TJ Maxx)
** Ctrl
mean tjm_future if reps_wlean==1 & store_treat==5
** R%
mean tjm_future if reps_wlean==1 & store_treat==1
** D%
mean tjm_future if reps_wlean==1 & store_treat==2
** R Amt
mean tjm_future if reps_wlean==1 & store_treat==3
** D Amt
mean tjm_future if reps_wlean==1 & store_treat==4
** Diference in R% and Ctrl means among Democrats
ttest tjm_future if reps_wlean==1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A7, Study 1, Row 14 (Walmart)
** Ctrl
mean wm_future if reps_wlean==1 & store_treat==5
** R%
mean wm_future if reps_wlean==1 & store_treat==1
** D%
mean wm_future if reps_wlean==1 & store_treat==2
** R Amt
mean wm_future if reps_wlean==1 & store_treat==3
** D Amt
mean wm_future if reps_wlean==1 & store_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest wm_future if reps_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest wm_future if reps_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)
clear

use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study2_Final.dta"
** Table A7, Study 2, Row 1 (Burger King)
** Ctrl
mean bk_future if dems_wlean==1 & ham_treat==5
** R%
mean bk_future if dems_wlean==1 & ham_treat==1
** D%
mean bk_future if dems_wlean==1 & ham_treat==2
** R Amt
mean bk_future if dems_wlean==1 & ham_treat==3
** D Amt
mean bk_future if dems_wlean==1 & ham_treat==4
** Diference in D% and Ctrl means among Democrats
ttest bk_future if dems_wlean==1 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A7, Study 2, Row 2 (McDonalds)
** Ctrl
mean mcd_future if dems_wlean==1 & ham_treat==5
** R%
mean mcd_future if dems_wlean==1 & ham_treat==1
** D%
mean mcd_future if dems_wlean==1 & ham_treat==2
** R Amt
mean mcd_future if dems_wlean==1 & ham_treat==3
** D Amt
mean mcd_future if dems_wlean==1 & ham_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest mcd_future if dems_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest mcd_future if dems_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A7, Study 2, Row 3 (Wendys)
** Ctrl
mean wendys_future if dems_wlean==1 & ham_treat==5
** R%
mean wendys_future if dems_wlean==1 & ham_treat==1
** D%
mean wendys_future if dems_wlean==1 & ham_treat==2
** R Amt
mean wendys_future if dems_wlean==1 & ham_treat==3
** D Amt
mean wendys_future if dems_wlean==1 & ham_treat==4
** Diference in R% and Ctrl means among Democrats
ttest wendys_future if dems_wlean==1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A7, Study 2, Row 4 (Burger King)
** Ctrl
mean bk_future if reps_wlean==1 & ham_treat==5
** R%
mean bk_future if reps_wlean==1 & ham_treat==1
** D%
mean bk_future if reps_wlean==1 & ham_treat==2
** R Amt
mean bk_future if reps_wlean==1 & ham_treat==3
** D Amt
mean bk_future if reps_wlean==1 & ham_treat==4
** Diference in D% and Ctrl means among Republicans
ttest bk_future if reps_wlean==1 & ham_treat!=1 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A7, Study 2, Row 5 (McDonalds)
** Ctrl
mean mcd_future if reps_wlean==1 & ham_treat==5
** R%
mean mcd_future if reps_wlean==1 & ham_treat==1
** D%
mean mcd_future if reps_wlean==1 & ham_treat==2
** R Amt
mean mcd_future if reps_wlean==1 & ham_treat==3
** D Amt
mean mcd_future if reps_wlean==1 & ham_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest mcd_future if reps_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=4, by (ham_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest mcd_future if reps_wlean==1 & ham_treat!=1 & ham_treat!=2 & ham_treat!=3, by (ham_treat)

** Table A7, Study 2, Row 6 (Wendys)
** Ctrl
mean wendys_future if reps_wlean==1 & ham_treat==5
**  R%
mean wendys_future if reps_wlean==1 & ham_treat==1
** D%
mean wendys_future if reps_wlean==1 & ham_treat==2
** R Amt
mean wendys_future if reps_wlean==1 & ham_treat==3
** D Amt
mean wendys_future if reps_wlean==1 & ham_treat==4
** Diference in R% and Ctrl means among Republicans
ttest wendys_future if reps_wlean==1 & ham_treat!=2 & ham_treat!=3 & ham_treat!=4, by (ham_treat)

** Table A7, Study 2, Row 7 (Bed Bath and Beyond)
** Ctrl
mean bbb_future if dems_wlean==1 & store_treat==5
** R%
mean bbb_future if dems_wlean==1 & store_treat==1
** D%
mean bbb_future if dems_wlean==1 & store_treat==2
** R Amt
mean bbb_future if dems_wlean==1 & store_treat==3
** D Amt
mean bbb_future if dems_wlean==1 & store_treat==4
** Diference in D% and Ctrl means among Democrats
ttest bbb_future if dems_wlean==1 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A7, Study 2, Row 8 (Target)
** Ctrl
mean target_future if dems_wlean==1 & store_treat==5
** R%
mean target_future if dems_wlean==1 & store_treat==1
** D%
mean target_future if dems_wlean==1 & store_treat==2
** R Amt
mean target_future if dems_wlean==1 & store_treat==3
** D Amt
mean target_future if dems_wlean==1 & store_treat==4

** Table A7, Study 2, Row 10 (Walmart)
** Ctrl
mean wm_future if dems_wlean==1 & store_treat==5
** R%
mean wm_future if dems_wlean==1 & store_treat==1
** D%
mean wm_future if dems_wlean==1 & store_treat==2
** R Amt
mean wm_future if dems_wlean==1 & store_treat==3
** D Amt
mean wm_future if dems_wlean==1 & store_treat==4
** Diference in R% and Ctrl means among Democrats
ttest wm_future if dems_wlean==1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)
** Diference in R Amt and Ctrl means among Democrats
ttest wm_future if dems_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest wm_future if dems_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

** Table A7, Study 2, Row 11 (Bed Bath and Beyond)
** Ctrl
mean bbb_future if reps_wlean==1 & store_treat==5
** R%
mean bbb_future if reps_wlean==1 & store_treat==1
** D%
mean bbb_future if reps_wlean==1 & store_treat==2
** R Amt
mean bbb_future if reps_wlean==1 & store_treat==3
** D Amt
mean bbb_future if reps_wlean==1 & store_treat==4
** Diference in D% and Ctrl means among Republicans
ttest bbb_future if reps_wlean==1 & store_treat!=1 & store_treat!=3 & store_treat!=4, by (store_treat)

** Table A7, Study 2, Row 12 (Target)
** Ctrl
mean target_future if reps_wlean==1 & store_treat==5
** R%
mean target_future if reps_wlean==1 & store_treat==1
** D%
mean target_future if reps_wlean==1 & store_treat==2
** R Amt
mean target_future if reps_wlean==1 & store_treat==3
** D Amt
mean target_future if reps_wlean==1 & store_treat==4

** Table A7, Study 2, Row 14 (Walmart)
** Ctrl
mean wm_future if reps_wlean==1 & store_treat==5
** R%
mean wm_future if reps_wlean==1 & store_treat==1
** D%
mean wm_future if reps_wlean==1 & store_treat==2
** R Amt
mean wm_future if reps_wlean==1 & store_treat==3
** D Amt
mean wm_future if reps_wlean==1 & store_treat==4
** Diference in R% and Ctrl means among Republicans
ttest wm_future if reps_wlean==1 & store_treat!=2 & store_treat!=3 & store_treat!=4, by (store_treat)
** Diference in R Amt and Ctrl means among Republicans
ttest wm_future if reps_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=4, by (store_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest wm_future if reps_wlean==1 & store_treat!=1 & store_treat!=2 & store_treat!=3, by (store_treat)

** Table A7, Study 2, Row 15 (Dominos)
** Ctrl
mean dominos_future if dems_wlean==1 & pizza_treat==5
** R%
mean dominos_future if dems_wlean==1 & pizza_treat==1
** D%
mean dominos_future if dems_wlean==1 & pizza_treat==2
** R Amt
mean dominos_future if dems_wlean==1 & pizza_treat==3
** D Amt
mean dominos_future if dems_wlean==1 & pizza_treat==4
** Diference in D% and Ctrl means among Democrats
ttest dominos_future if dems_wlean==1 & pizza_treat!=1 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)

** Table A7, Study 2, Row 16 (Papa Johns)
** Ctrl
mean papajohns_future if dems_wlean==1 & pizza_treat==5
** R%
mean papajohns_future if dems_wlean==1 & pizza_treat==1
** D%
mean papajohns_future if dems_wlean==1 & pizza_treat==2
** R Amt
mean papajohns_future if dems_wlean==1 & pizza_treat==3
** D Amt
mean papajohns_future if dems_wlean==1 & pizza_treat==4

** Table A7, Study 2, Row 17 (Pizza Hut)
** Ctrl
mean pizzahut_future if dems_wlean==1 & pizza_treat==5
** R%
mean pizzahut_future if dems_wlean==1 & pizza_treat==1
** D%
mean pizzahut_future if dems_wlean==1 & pizza_treat==2
** R Amt
mean pizzahut_future if dems_wlean==1 & pizza_treat==3
** D Amt
mean pizzahut_future if dems_wlean==1 & pizza_treat==4
** Diference in R% and Ctrl means among Democrats
ttest pizzahut_future if dems_wlean==1 & pizza_treat!=2 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)
** Diference in R Amt and Ctrl means among Democrats
ttest pizzahut_future if dems_wlean==1 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=4, by (pizza_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest pizzahut_future if dems_wlean==1 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=3, by (pizza_treat)

** Table A7, Study 2, Row 18 (Dominos)
** Ctrl
mean dominos_future if reps_wlean==1 & pizza_treat==5
** R%
mean dominos_future if reps_wlean==1 & pizza_treat==1
** D%
mean dominos_future if reps_wlean==1 & pizza_treat==2
** R Amt
mean dominos_future if reps_wlean==1 & pizza_treat==3
** D Amt
mean dominos_future if reps_wlean==1 & pizza_treat==4
** Diference in D% and Ctrl means among Republicans
ttest dominos_future if reps_wlean==1 & pizza_treat!=1 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)

** Table A7, Study 2, Row 19 (Papa Johns)
** Ctrl
mean papajohns_future if reps_wlean==1 & pizza_treat==5
** R%
mean papajohns_future if reps_wlean==1 & pizza_treat==1
** D%
mean papajohns_future if reps_wlean==1 & pizza_treat==2
** R Amt
mean papajohns_future if reps_wlean==1 & pizza_treat==3
** D Amt
mean papajohns_future if reps_wlean==1 & pizza_treat==4

** Table A7, Study 2, Row 20 (Pizza Hut)
** Ctrl
mean pizzahut_future if reps_wlean==1 & pizza_treat==5
** R%
mean pizzahut_future if reps_wlean==1 & pizza_treat==1
** D%
mean pizzahut_future if reps_wlean==1 & pizza_treat==2
** R Amt
mean pizzahut_future if reps_wlean==1 & pizza_treat==3
**  D Amt
mean pizzahut_future if reps_wlean==1 & pizza_treat==4
** Diference in R% and Ctrl means among Republicans
ttest pizzahut_future if reps_wlean==1 & pizza_treat!=2 & pizza_treat!=3 & pizza_treat!=4, by (pizza_treat)
** Diference in R Amt and Ctrl means among Republicans
ttest pizzahut_future if reps_wlean==1 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=4, by (pizza_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest pizzahut_future if reps_wlean==1 & pizza_treat!=1 & pizza_treat!=2 & pizza_treat!=3, by (pizza_treat)

** Table A7, Study 2, Row 21 (CVS)
** Ctrl
mean cvs_future if dems_wlean==1 & drug_treat==5
** R%
mean cvs_future if dems_wlean==1 & drug_treat==1
** D%
mean cvs_future if dems_wlean==1 & drug_treat==2
** R Amt
mean cvs_future if dems_wlean==1 & drug_treat==3
** D Amt
mean cvs_future if dems_wlean==1 & drug_treat==4
** Diference in D% and Ctrl means among Democrats
ttest cvs_future if dems_wlean==1 & drug_treat!=1 & drug_treat!=3 & drug_treat!=4, by (drug_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest cvs_future if dems_wlean==1 & drug_treat!=1 & drug_treat!=2 & drug_treat!=3, by (drug_treat)

** Table A7, Study 2, Row 22 (Rite Aid)
** Ctrl
mean riteaid_future if dems_wlean==1 & drug_treat==5
** R%
mean riteaid_future if dems_wlean==1 & drug_treat==1
** D%
mean riteaid_future if dems_wlean==1 & drug_treat==2
** R Amt
mean riteaid_future if dems_wlean==1 & drug_treat==3
** D Amt
mean riteaid_future if dems_wlean==1 & drug_treat==4
** Diference in R% and Ctrl means among Democrats
ttest riteaid_future if dems_wlean==1 & drug_treat!=2 & drug_treat!=3 & drug_treat!=4, by (drug_treat)

** Table A7, Study 2, Row 23 (Walgreens)
** Ctrl
mean walgreens_future if dems_wlean==1 & drug_treat==5
** R%
mean walgreens_future if dems_wlean==1 & drug_treat==1
** D%
mean walgreens_future if dems_wlean==1 & drug_treat==2
** R Amt
mean walgreens_future if dems_wlean==1 & drug_treat==3
** D Amt
mean walgreens_future if dems_wlean==1 & drug_treat==4
** Diference in R Amt and Ctrl means among Democrats
ttest walgreens_future if dems_wlean==1 & drug_treat!=1 & drug_treat!=2 & drug_treat!=4, by (drug_treat)

** Table A7, Study 2, Row 24 (CVS)
** Ctrl
mean cvs_future if reps_wlean==1 & drug_treat==5
** R%
mean cvs_future if reps_wlean==1 & drug_treat==1
** D%
mean cvs_future if reps_wlean==1 & drug_treat==2
** R Amt
mean cvs_future if reps_wlean==1 & drug_treat==3
** D Amt
mean cvs_future if reps_wlean==1 & drug_treat==4
** Diference in D% and Ctrl means among Republicans
ttest cvs_future if reps_wlean==1 & drug_treat!=1 & drug_treat!=3 & drug_treat!=4, by (drug_treat)
** Diference in D Amt and Ctrl means among Republicans
ttest cvs_future if reps_wlean==1 & drug_treat!=1 & drug_treat!=2 & drug_treat!=3, by (drug_treat)

** Table A7, Study 2, Row 25 (Rite Aid)
** Ctrl
mean riteaid_future if reps_wlean==1 & drug_treat==5
** R%
mean riteaid_future if reps_wlean==1 & drug_treat==1
** D%
mean riteaid_future if reps_wlean==1 & drug_treat==2
** R Amt
mean riteaid_future if reps_wlean==1 & drug_treat==3
** D Amt
mean riteaid_future if reps_wlean==1 & drug_treat==4
** Diference in R% and Ctrl means among Republicans
ttest riteaid_future if reps_wlean==1 & drug_treat!=2 & drug_treat!=3 & drug_treat!=4, by (drug_treat)

** Table A7, Study 2, Row 26 (Walgreens)
** Ctrl
mean walgreens_future if reps_wlean==1 & drug_treat==5
** R%
mean walgreens_future if reps_wlean==1 & drug_treat==1
** D%
mean walgreens_future if reps_wlean==1 & drug_treat==2
** R Amt
mean walgreens_future if reps_wlean==1 & drug_treat==3
** D Amt
mean walgreens_future if reps_wlean==1 & drug_treat==4
** Diference in R Amt and Ctrl means among Republicans
ttest walgreens_future if reps_wlean==1 & drug_treat!=1 & drug_treat!=2 & drug_treat!=4, by (drug_treat)
clear



use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study3_Final.dta"

** Table A7, Study 3, Row 29 (Burger King)
** Amount Control
mean burgerking if ham_treat==5  & dems_wlean==1
** Amount GOP Treatment
mean burgerking if ham_treat==3 & dems_wlean==1
** Amount Dem Treatment
mean burgerking if ham_treat==4 & dems_wlean==1

** Table A7, Study 3, Row 30 (McDonalds)
** Amount Control
mean mcdonalds if ham_treat==5  & dems_wlean==1
** Amount GOP Treatment
mean mcdonalds if ham_treat==3 & dems_wlean==1
** Amount Dem Treatment
mean mcdonalds if ham_treat==4 & dems_wlean==1
** Diference in R Amt and Ctrl means among Democrats
ttest mcdonalds if ham_treat!=4 & dems_wlean==1, by(ham_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest mcdonalds if ham_treat!=3 & dems_wlean==1, by(ham_treat)

** Table A7, Study 3, Row 31 (Wendys)
** Amount Control
mean wendys if ham_treat==5  & reps_wlean==1
** Amount GOP Treatment
mean wendys if ham_treat==3 & reps_wlean==1
** Amount Dem Treatment
mean wendys if ham_treat==4 & reps_wlean==1

** Table A7, Study 3, Row 32 (Burger King)
** Amount Control
mean burgerking if ham_treat==5  & reps_wlean==1
** Amount GOP Treatment
mean burgerking if ham_treat==3 & reps_wlean==1
** Amount Dem Treatment
mean burgerking if ham_treat==4 & reps_wlean==1

** Table A7, Study 3, Row 33 (McDonalds)
** Amount Control
mean mcdonalds if ham_treat==5  & reps_wlean==1
** Amount GOP Treatment
mean mcdonalds if ham_treat==3 & reps_wlean==1
** Amount Dem Treatment
mean mcdonalds if ham_treat==4 & reps_wlean==1
** Diference in R Amt and Ctrl means among Democrats
ttest mcdonalds if ham_treat!=4 & reps_wlean==1, by(ham_treat)
** Diference in D Amt and Ctrl means among Democrats
ttest mcdonalds if ham_treat!=3 & reps_wlean==1, by(ham_treat)

** Table A7, Study 3, Row 34 (Wendys)
** Amount Control
mean wendys if ham_treat==5  & reps_wlean==1
** Amount GOP Treatment
mean wendys if ham_treat==3 & reps_wlean==1
** Amount Dem Treatment
mean wendys if ham_treat==4 & reps_wlean==1

** Table A7, Study 3, Row 35 (Bed Bath and Beyond)
** Control
mean BBB if store_treat==5  & dems_wlean==1
** R% 
mean BBB if store_treat==1 & dems_wlean==1
** D%
mean BBB if store_treat==2 & dems_wlean==1
** Diference in D% and Ctrl means among Democrats
ttest BBB if store_treat!=1 & dems_wlean==1, by(store_treat)

** Table A7, Study 3, Row 36 (Kohls)
** Control
mean kohls if store_treat==5  & dems_wlean==1
** R% 
mean kohls if store_treat==1 & dems_wlean==1
** D%
mean kohls if store_treat==2 & dems_wlean==1

** Table A7, Study 3, Row 37 (Target)
** Control
mean target if store_treat==5  & dems_wlean==1
** R% 
mean target if store_treat==1 & dems_wlean==1
** D%
mean target if store_treat==2 & dems_wlean==1

** Table A7, Study 3, Row 38 (Walmart)
** Control
mean walmart if store_treat==5  & dems_wlean==1
** R% 
mean walmart if store_treat==1 & dems_wlean==1
** D%
mean walmart if store_treat==2 & dems_wlean==1
** Diference in R% and Ctrl means among Democrats
ttest walmart if store_treat!=2 & dems_wlean==1, by(store_treat)

** Table A7, Study 3, Row 39 (Bed Bath and Beyond)
** Control
mean BBB if store_treat==5  & reps_wlean==1
** R% 
mean BBB if store_treat==1 & reps_wlean==1
** D%
mean BBB if store_treat==2 & reps_wlean==1
** Diference in D% and Ctrl means among Democrats
ttest BBB if store_treat!=1 & reps_wlean==1, by(store_treat)

** Table A7, Study 3, Row 40 (Kohls)
** Control
mean kohls if store_treat==5  & reps_wlean==1
** R% 
mean kohls if store_treat==1 & reps_wlean==1
** D%
mean kohls if store_treat==2 & reps_wlean==1

** Table A7, Study 3, Row 41 (Target)
** Control
mean target if store_treat==5  & reps_wlean==1
** R% 
mean target if store_treat==1 & reps_wlean==1
** D%
mean target if store_treat==2 & reps_wlean==1

** Table A7, Study 3, Row 42 (Walmart)
** Control
mean walmart if store_treat==5  & reps_wlean==1
** R% 
mean walmart if store_treat==1 & reps_wlean==1
** D%
mean walmart if store_treat==2 & reps_wlean==1
** Diference in R% and Ctrl means among Democrats
ttest walmart if store_treat!=2 & reps_wlean==1, by(store_treat)

clear

use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study3_Final.dta"

// Footnote 15, page 17
/*
As strong as these results are, they would be even stronger if we were to prime partisan considerations directly rather than in an oblique way via a quiz.
The 2016 CCES pre-election survey asked, “Large corporations often donate money or free equipment to the Republican and Democratic national conventions.
In 2016, [Apple Inc. / Ford Motor Company] announced that it would not be a sponsor of the 2016 Republican National Convention, which it had supported in 2008 and 2012.
Does this decision make you more likely to purchase products made by [Apple Inc. / Ford Motor Company], less likely, or will it make no difference?"
As expected, Republicans and Democrats offered sharply different responses.
*/
tab FBC319 if democrat==1
tab FBC319 if republican==1

// Footnote 17, page 19
/*
The postcards informed respondents that the percentages reported were based on numbers compiled by opensecrets.org.
The text of the postcards characterizes these contributions as PAC contributions, but the opensecrets.org statistics we cited combine PAC contributions with contributions from corporate executives.
Statistics reported in the two MTurk studies were characterized in a similar way, due to our misreading of the opensecrets.org report.
In the 2016 CCES, we experimentally varied question wording to refer to contributions by PACs or by corporate executives, and found no difference.
*/
ttest pacs_execs_exp if democrat==1, by(pacs_execs_treat)
ttest pacs_execs_exp if republican==1, by(pacs_execs_treat)




// Study 4 Balance Tests (not mentioned in the main text)
use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Study4_Final.dta"
generate gender_male = 0 
recode gender_male (0=1) if gender==1
** Hamburger Experiment
** 0 = never, 4 = "several times a week"
mlogit ham_treat age gender_male pre_presapprove pre_wendys if wave==2
** Big Box Experiment
mlogit bigbox_treat age gender_male pre_presapprove pre_BBB if wave==2


// Study 4 Reinterview rate (page 19)
tab wave
// Reinterveiw rate by condition
tab wave ham_treat, col

// Study 4 Demographics of Wave 2 Participants (pages 19 and 20)
tab race if wave==2
tab gender if wave==2
tab pid3 if wave==2
tab pre_wendys if wave==2
tab pre_BBB if wave==2

// Study 4 Manipulations Checks (page 20)
** Correctly Identify Wendys as contributing the highest percentage to Republicans
tab hamburger_correct ham_treat, col
reg hamburger_correct ham_treat


** Correctly Identify BBB as contributing the highest percentage to Democrats
tab bigbox_correct bigbox_treat, col
reg bigbox_correct bigbox_treat




log close

