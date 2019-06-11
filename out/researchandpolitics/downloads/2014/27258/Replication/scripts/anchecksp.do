/*
==========================================================================
File-Name:    anchecksp.do                         
Date:         May 24th, 2009                                    
Author:       Fernando Martel                                 
Purpose:      Check the sample of country and years used by the author.
              On page 865 the article states that the sample includes 168 
              sovereign countries (i.e members of WB or UN, correspondence 
              with author) with population over 200,000 (in 2000?), yet 
              the ANNUAL file contains 169 countries.  
              The extra country is CYP.  It has annual data but for some 
              reason in quinquennial data all data except Polity are missing. 
              Check missingness and missingness patterns.
Data Input:   - ross1y
              Created from main_replication_data.dta
              Received from author via e-mail Feb 25th 2007.  
              Contains ANNUAL data used in the paper, except for HIV data 
              and democratic years.
              Data spans 1965 to 2000.
              ross1y contains standardised country codes added by crmaster.do
              - ross5y
              cretaed from replication data - 5 year panels.dta
              Received from author via e-mail Aug 18th 2008.  
              Data spans 1970 to 2000
              ross5y contains standardised country codes added by crmaster.do
              - aclp
              Przeworski et als regime data.
Output File:  None
Data Output:  None                                   
Previous file:crmaster.do (creates aclp ross1y and ross5y)
              anmaster.do 
Status:       Complete                                     
Machine:      IBM, X41 tablet running Windows XP spck 3                                
**************************************************************************
*/

clear
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"

************************************************************************
*Define local varlist
************************************************************************
#delimit ;
global rossvars = " logCMRwdi smallstate logCMRwdi_1 logIMRunicef_1 logIMRwdi_1 
 logGDPcap_1 logHIV_1 logDen_1 GDPgrowth_1 Polity_1  logDEMYRS_1 
 transition_1";
global rossregfe = "logCMRwdi logGDPcap_1 logHIV_1 logDen_1 
 GDPgrowth_1 Polity_1 ";
global rossregldv = "logCMRwdi logCMRwdi_1 logGDPcap_1 logHIV_1 logDen_1
 GDPgrowth_1 logDEMYRS_1";
di "$rossvars";
di "$rossregfe";
di "$rossregldv";
#delimit cr

************************************************************************
* Check sampling frame for countries 
* 168 sovereign countries (i.e members of WB or UN, author email)
* Pop > 200,000 (in what year?)
************************************************************************
use ../data_clean/ross1y

* Check population threshold, should be sovereign 
* There are country years with populaton less than 200,000
count if population < 200000 // 

* If year criteria was applied was > 1993 no problem
count if population <200000 & year==1993
count if population <200000 & year==1994

* Count number of countries in annual data
levelsof ctycode, clean local(temp)
local temp1 = 0
foreach l of local temp {
     local temp1 = `temp1' + 1 
     di "`temp1'  `l'"
}
di "Annual dataset contains a total of `temp1' countries, one more than paper"

* Count number of countries in quinquennial data
clear
use "..\data_clean\ross5y.dta
levelsof ctycode, clean local(temp)
local temp1 = 0
foreach l of local temp {
     local temp1 = `temp1' + 1 
     di "`temp1'  `l'"
}
di "Quinquennial dataset contains a total of `temp1' countries, one more than paper"

* Above suggests there are 169 countries in both annual and quinquennial
* datasets, yet Table 4 in Ross (2006) which uses filled in dataset reports
* 168 countries.  What is going on?

* Cyprus (CYP) was excluded/truncated from imputation
clear
use ../data_raw/Ross_Replication_Data/mr1replication1.dta
su IDdum40
list if id=="CYP"
 
* CYP is in quinquennial dataset but its dummy is 0 everywhere, also missing
* much data
clear
use "..\data_clean\ross5y.dta
su IDdum*
su IDdum40
list ctycode period IDdum40 $rossvars if ctycode=="CYP", clean noobs c

* However much of the underlying data is in the annual dataset but
* Polity takes different values
su Polity if ctycode=="CYP"
clear
use "..\data_clean\ross1y.dta" 
su Polity if ctycode=="CYP"
list ctycode year Polity logCMRwdi ///
  density GDPcap logIMRunicef logIMRwdi population ///
  if ctycode=="CYP", clean noobs c

* So CYP in annual dataset, much of the data lost in quinquennial data,
* and somehow dummy for CYP always zero.  CYP dissapears altogether from
* imputed data, though its dummy variable remains (and is always zero).


**************************************************************************
* Check years in annual and quinquennial data
**************************************************************************

* Check time periods in annual data
xtset ctynum  year     		                  //declare as panel dataset
xtdes
su year 
di "Annual data runs from `r(min)' to `r(max)'"

* Data are available before 1970 for UNICEF infant and child mortality, pop,
* real GDP per capita, GDP growth, but not for other moratlity data, density
list ctycode year logCMRunicef logCMRwdi logCMRwho logIMRunicef logIMRwdi population ///
       rgdpch density GDPgrowth if year<1970, separator(0) divider

* Check time periods in quinuennial data
* Data set has 7 periods corresponting to 1970, 1975, ... 2000
clear 
use ../data_clean/ross5y
xtset ctynum  period     		                  //declare as panel dataset
xtdes
su period
tab period
format $rossvars %7.1f
tabstat  $rossvars if period==1, ///
         stat(count mean sd min max) columns(statistics) ///
         format(%7.1f)
mdesc $rossvars  if period==1

* Above shows that data for all lagged variables in period 1 is missing, except for 
* logCMRwdi_1, Polity_1, transition.  This is surprising since data for some of 
* the missing variables is available for 1965 in annual dataset, as shown above.
* It seems annual data set was truncated in 1970 before computing averages and lags.
* This throws out a substantial amount of data.

* For some reason logCMRwdi == logCMRwdi_1 if period==1
list ctycode period logCMRwdi logCMRwdi_1 if period==1
capture noisily assert logCMRwdi == logCMRwdi_1 if period==1

* The transition variable is missing for Cyprus.
list ctycode period transition if transition_1==., clean noobs

* It is not clear to me how the lagged value of Polity was created since Polity
* is missing in annual data prior to 1970 (even though original source has data 
* before 1970).  More details in ancheckiv.do
list ctycode period Polity Polity_1 if period==1

* Note that even lagged HIV is missing in 1970 despite the fact that 
* Ross (2006, p. 867) appears to assume HIV rates prior to 1980 were "close to 
* zero". Unfortunately data on HIV is not included in the annual data set,
* so I cannot replicate the quinquennial file.


**************************************************************************
* Check definition of sovereignty
**************************************************************************
* Consider Germany.  From 1965 when Ross (2006) annual data starts, to 1989
* Germany is two entities: FDR and DDR
* In 1990 the latter two are superseded by a single united Germany (DEU)
* ACLP code when a country is first and last observed since 1946 to 2002
* using the variables
* FLAGC=1 first year country is observed, zero otherwise
* FLAGE=1 last year coutry is observed, zero otherwise
* Here I check Ross (2000) country years against ACLP

* Create ACLP population dummy
* aclppop = 1 if country year in aclp database, . otherwise.
clear
use ../data_clean/aclp
gen aclppop = 1  // generate flag for ACLP country years
drop if year<1965 // Year where Ross's (2006) annual data starts
keep ctycode ctyname year aclppop
sort ctycode year, stable
save aclppop, replace

* Merge ross1y onto  aclppop data
merge ctycode year using ../data_clean/ross1y

* Ross (2006) defines soverieng as memebers of WB or UN  at some (unspecified) 
* point in time.  Say it is year 2000.  Then effectively we are looking at 
* soveriegn countries in 2000 and running them back into history to create
* a balanced panel.
* This creates articifial "sovereign" country years when in fact the entity
* may have been a colony, a part of the USSR, or not even a country (e.g. 
* unified Germany or Viet Nam did not exist in 1970, and so on.
* ACLP code sovereign country years in an unblanaced panel, recording when
* entities are born, die, merge, or split.
tab _merge   

* Show "sovereign" country years in Ross (2006) not in ACLP
levelsof ctycode if _merge==2, local(ctycodes)
di "The following 905 country years in Ross (2006) are not in ACLP data"
foreach i in `ctycodes' {
  quietly levelsof ctyname if ctycode=="`i'", local(b)
  quietly su year if ctycode=="`i'" & _merge==2
  di "`i' `r(min)' `r(max)' " `b' 
}
* Ross (2006) sets out to create a balanced panel of sovereign country
* years from 1965 to 2002 for 169 countries.  That is 6,422 cells.  Of 
* these "sovereign" country year cells 905 are not reflected in ACLP, or
* 14.1% of the data.

* Show sovereign country years in ACLP not in Ross (2006)
levelsof ctycode if _merge==1, local(ctycodes)
di "The following 905 country years in Ross (2006) are not in ACLP data"
foreach i in `ctycodes' {
  quietly levelsof ctyname if ctycode=="`i'", local(b)
  quietly su year if ctycode=="`i'" & _merge==1
  di "`i' `r(min)' `r(max)' " `b' 
}
* most of these are small coutnries except Czeck, Cyprus, East Germany, Ethiopia, 
* West Germany, USSR, Somaliland, Taiwan, Yemen, Yugoslavia.  In turn many of
* these are deceased entities like USSR.
* Note aclp code Somaliland as sovereign even though not recognised by UN
* Here is an example of how Ross (2006) and ACLP treat Germany from 1965
* ACLP do not have observations for united Germany (DEU) before 1990
* instead have West (FDR) and East (DDR) Germany from 1965 to 1989
* Ross has what appears to be a (synthetic) West Germany from 1965 to 2002
* and ignores East Germany 
list ctycode ctyname year aclppop population if ctycode=="DEU" ///
     | ctycode=="DDR" | ctycode=="FDR", clean  noobs

* Here is an example of a FSU entity, Ukraine
* Note also the data for 1970, not sure where it is coming from, though the ///
* label for GDPcap in annual data reads: "from WDI, constant 1995 dollars,  ///
* w 1970 FSU imp data added".  And the label for rgdpch, the data actually  ///
* used reads " GDP pr capita, chain series; plus values for 1970&2000 from  ///
* short dataset"
drop if _merge==1
xtset ctynum year
list  year ctycode ctyname aclppop U5MRwdi Polity rgdpch density GDPgrowth ///
   if  ctycode=="UKR", clean noobs c

* Here is Cyprus
* ACLP code CYP as Greek Cyprus from 1983 (CY2)
list  year ctycode ctyname aclppop U5MRwdi Polity rgdpch density GDPgrowth ///
   if  ctycode=="CYP", clean noobs c

* Similar problem for Ethiopia
* ACLP code ETH as ET2 from 1993
list  year ctycode ctyname aclppop U5MRwdi Polity rgdpch density GDPgrowth ///
   if  ctycode=="ETH", clean noobs c

* Similar problem for Yemen
* Yemen breaks up at various points in history, only unified in 1990, so 
* ACLP code it as YEM only from 1990 on
list  year ctycode ctyname aclppop U5MRwdi Polity rgdpch density GDPgrowth ///
   if  ctycode=="YEM", clean noobs c

* Ross claims to be using WB ctycode, but WB has no code for YUG
* YUG here refers to Serbia and Montenegro
* YUG war starts 1991, when Solvenia and Croatia declare independence
* ACLP code this as Yugoslavia2
* 1993-07-28 (Newsletter III-45): Numeric code of Yugoslavia changed from 890 to 891
* (a consequence of the splitting off of Bosnia and Herzegovina, Croatia, Macedonia, and Slovenia).
* What remains is Serb & Mon. (which splits in 2006, beyond our sample)
* The correct ctycode is SCG
* See http://www.infoplease.com/spot/yugotimeline1.html
* I corected this when creating ross1y.dta
list  year ctycode ctyname aclppop  logCMRunicef Polity rgdpch density GDPgrowth if  ctycode=="SCG", clean noobs c

* Here is UKR in quinquennial data
clear
use ../data_clean/ross5y
egen year = fill (1970 1975 1980 1985 1990 1995 2000 1970 1975 1980 1985 1990 1995 2000)
list  year ctycode ctyname logCMRwdi logCMRwdi_1 Polity_1 logGDPcap_1  logDen_1 ///
      GDPgrowth_1 if  ctycode=="UKR", clean noobs c


**************************************************************************
* Check variables
**************************************************************************

* Variables in annual data
clear 
use ../data_clean/ross1y
des

* Variables in annual data
clear 
use ../data_clean/ross5y
drop IDd*
des

* The dependent variables are:
*   IMRwdi,          logIMRwdi
*   infmort_unicef,  logIMRunicef
*   U5MRwdi,         logCMRwdi
*   kidmort_unicef   logCMRunicef
*   kidmort_who      logCMRwho
* These are all in annual dataset, but only some in quinquennial one.

* Independent variable:
*    Polity "PolityIV, combined dem and aut scores -10 to 10, ///
*    nonsovereign yrs filled in"
* This variable cannot be replicated in quinquennial data, as shown
* later.  In quinquennial data it appears Polity V is used:
clear 
use ../data_clean/ross5y
di "Polity label in quinquennial dataset"
des Polity_1
clear 
use ../data_clean/ross1y
di "Polity label in annual dataset"
des Polity
* Labels are different

* Controls
* smallstate logGDPcap_1 logHIV_1 logDen_1 GDPgrowth_1 logDEMYRS_1  transition_1
* Smallstate: is not in annual data, but presumably created using population var
*   in text defined as 1 for countries with population < 1,000,000
* logGDPcap_1: is constructed from rgdpch in annual data
* logHIV_1: HIV data not in annual data
* logDen_1: based on density in annual data
* GDPgrowth_1: from GDPgrowth in annual
* logDEMYRS_1: not in annual dataset
* transition_1: not in dataset.


* Others, I will ignore these
*    commie
*    democracy
*    smallstate








