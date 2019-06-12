*********This file provides code to replicate 'Durable Democracy: Economic Inequality and Democratic Accountability in the New Gilded Age'*******

************************************
*********Table 1, 2006 CCES*********
************************************
use "2006 CCES Durable Democracy.dta"

****column 1, non interaction model
xtmelogit voteincmbsen gini00zip_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 || statefips: || zip: , intpoints(2 2)

****column 2, including interaction
xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 || statefips: || zip: , intpoints(2 2)

************************************
*********Table 2, 2006 CCES*********
************************************

**column 1, Dem incumbents
xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 if incsenpid==0 || statefips: || zip: , intpoints(2 2)

**column 2, GOP incumbents
xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 if incsenpid==1 || statefips: || zip: , intpoints(2 2)

************************************
*********Table 3, 2006 CCES*********
************************************

**column 1, Dem voters
xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 if pid<4 || statefips: || zip: , intpoints(4 4) 

**column 2, GOP voters
xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 if pid>4 || statefips: || zip: , intpoints(2 2)

**column 3, Household Income, 1st quartile
xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 if inc4==1 || statefips: || zip: , intpoints(2 2)

**column 4, Household Income, 4th quartile
xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 if inc4==4 || statefips: || zip: , intpoints(2 2)

clear

**column 5, Political Knowledge-Low
use "2006 CCES Add Sophistication Vars Durable Democracy.dta"
xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 if polknow==0 || statefips: || zip: , intpoints(2 2)

**column 6, Political Knowledge-High
xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 if polknow==2 || statefips: || zip: , intpoints(2 2)

clear
**********************************************
*********Table 4, 2008/09 & 2012 CCES*********
**********************************************

**column 1, 2008-09 CCES**
use  "2008-09 CCES Durable Democracy.dta"
xtmelogit voteincsen gini0812zip_01 dwnom110e_01 gini0812zip_01Xdwnom110e_01 medearn812zip_01 unemp0812zip_01 pblk0812zip_01 pbush_01 popden0812zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse Rsenpideq relig01 dwnom110e_01Xmedearn812zip_01 dwnom110e_01Xpbush_01 sid2009 || state: || zip: , intpoints(2 2)

clear

**column 2, 2012 CCES**
use "2012 CCES Durable Democracy.dta"
xtmelogit incumbentvote gini0812zip_01 dwnom112e_01 gini0812zip_01Xdwnom112e_01 medearn812zip_01 unemp0812zip_01 pblk0812zip_01 promney12cnty_01 popden0812zip_01 educ_01 incomei_01 age male black hisp unemployed homeowner relig01 partyagree dwnom112e_01Xmedearn812zip_01 dwnom112e_01Xpromney12cnty_01 || statefips: || zip: , intpoints(2 2)

clear

****************************
***********Appendix*********
****************************
use "2006 CCES Durable Democracy.dta"

***Table C1, using 80/20

xtmelogit voteincmbsen highlow_01 dwnom109e_01 highlow_01_dwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 || statefips: || zip: , intpoints(2 2)

***Table C2, controlling for population density

xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 popden00zip_01_dwnom109e_01 || statefips: || zip: , intpoints(2 2)

***Table C3, controlling for additional incumbent factors
 
xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 incumbent_nonwhite incubment_gender year_elected incumbent_spend challenger_spend  medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 presapprove_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 || statefips: || zip: , intpoints(2 2)

***Table D1, exluding atyptical senators

xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 if atypicalstate==0 || statefips: || zip: , intpoints(2 2)

***Table E1, alternative political knowledge model 
use "2006 CCES Add Sophistication Vars Durable Democracy.dta"

xtmelogit voteincmbsen gini00zip_01 dwnom109e_01 gini00zip_01Xdwnom109e_01 medhinc00zip_01 pctunemp00zip_01 pctblk00zip_01 pbush_01 popden00zip_01 educ_01 incomei_01 age male black hisp unemp ownhouse stateeconeval_01 partyagree relig01 dwnom109e_01Xmedhinc00zip_01 dwnom109e_01Xpbush_01 if poldontknow==1 || statefips: || zip: , intpoints(2 2)

clear
