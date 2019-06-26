

***Goldsmith & He, JPR, "Letting Go without a Fight: Decolonization, Democracy, and War, 1900-1994"; 
***Stata commands for tables I & II.


*****model 1
#del;

xtgee  war1000 polity2A1slag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

*****mdoel 2
#del;

xtgee  war1000 demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;



*** model 3


#del;

xtgee  war1000 polity2A1slag RisDec lnparity PostIndep if year<= indep+7 & year >= indep-7, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

*** model 4


#del;

xtgee  war1000 polity2A1slag jntdem7lag RisDec lnparity if year<= indep+7 & year >= indep, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


*** model 5

#del;

xtgee  war1000 exrecAslag exconstAslag polcompAslag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


*** model 6

#del;

xtgee  war1000 exrecAslag  RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

*** model 7

#del;

xtgee  war1000 Wlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

***model 8

#del;

xtgee  war1000 polcompAslag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

*** model 9

#del;

xtgee  war1000 exconstAslag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;











*****additional analyses*******************************


******additional analyses [ annualindep lncumindep cumindep UNmemJnt UNmem2 UNmem1 
post45 tpopB1 polity2B1fill contiglandBG lndistanceBG distanceBG  capB1 rgdpcombined000sus1990B rgdppcB 
bgnatid jntdem7fill UNdemA DeclDem autocatA autocatAlag regchg3 demztn autztn regchgdum polity2B1s]


#del;

xtgee  war1000 demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


***annualindep

#del;

xtgee  war1000 annualindep demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

**cumindep 

#del;
xtgee  war1000 cumindep demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

**cumindep 5 years

#del;
xtgee  war1000 cumindep demcatAlag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;




**UNmemJnt 

#del;
xtgee  war1000 UNmemJnt demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

**UNmemJnt 5 years

#del;
xtgee  war1000 UNmemJnt demcatAlag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


**UNmem2 

#del;
xtgee  war1000 UNmem2 demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


**UNmem2 5 years

#del;
xtgee  war1000 UNmem2 demcatAlag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;



**UNmem1 

#del;
xtgee  war1000 UNmem1 demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


**UNmem1 5 years

#del;
xtgee  war1000 UNmem1 demcatAlag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;



**post45 

#del;
xtgee  war1000 post45 demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

**post45 5 years

#del;
xtgee  war1000 post45 demcatAlag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;



**tpopB1 

#del;
xtgee  war1000 tpopB1 demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

**polity2B1fill 

#del;
xtgee  war1000 polity2B1fill demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


**polity2B1fill 5 years

#del;
xtgee  war1000 polity2B1fill demcatAlag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;



**polity2B1fill  noA

#del;
xtgee  war1000 polity2B1fill RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


**polity2B1fill 5 years noA

#del;
xtgee  war1000 polity2B1fill  RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;



**contiglandBG 

#del;
xtgee  war1000 contiglandBG demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


**contiglandBG 5 years

#del;
xtgee  war1000 contiglandBG demcatAlag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;




**lndistanceBG 


#del;
xtgee  war1000 lndistanceBG demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

**distanceBG  

#del;
xtgee  war1000 distanceBG demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

**capB1 

#del;
xtgee  war1000 capB1 demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;



**capB1 5 years

#del;
xtgee  war1000 capB1 demcatAlag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;




**rgdpcombined000sus1990B 

#del;
xtgee  war1000 rgdpcombined000sus1990B  demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


**rgdpcombined000sus1990B  5 years

#del;
xtgee  war1000 rgdpcombined000sus1990B  demcatAlag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

**rgdpcombined000sus1990B  7 years

#del;
xtgee  war1000 rgdpcombined000sus1990B  demcatAlag RisDec lnparity PostIndep if year<= indep+7 & year >= indep-7, 
     family(binomial) link(logit) corr(ar1) force robust nolog;




**rgdppcB 

#del;
xtgee  war1000 rgdppcB  demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog; 




**rgdppcB 5 years

#del;
xtgee  war1000 rgdppcB  demcatAlag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog; 







*****************************************
***break at 1945

#del;

xtgee  war1000 demcatAlag RisDec lnparity PostIndep if year >1945 & year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

#del;

xtgee  war1000 demcatAlag RisDec lnparity PostIndep if year < 1946 & year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;



***bgnatid [fails]

#del;

xtgee  war1000 bgnatid demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

***bgnatid & polityA
#del;

xtgee  war1000 bgnatid  polity2A1slag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;




***bgnatid 5 years

#del;

xtgee  war1000 bgnatid demcatAlag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;

**jntdem7fill

#del;

xtgee  war1000 jntdem7fill demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


**UNdemA 

#del;

xtgee  war1000 UNdemA demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


**DeclDem 

#del;

xtgee  war1000 DeclDem demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


**autocatA 

#del;

xtgee  war1000 autocatA demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;




**autocatAlag 

#del;

xtgee  war1000 autocatAlag demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


**regchg3 

#del;

xtgee  war1000 regchg3 demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;



**demztn 

#del;

xtgee  war1000 demztn demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;



**autztn 

#del;

xtgee  war1000 autztn demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;



**regchgdum 

#del;

xtgee  war1000 regchgdum demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;



**polity2B1s


#del;

xtgee  war1000 polity2B1s demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;




**demcatBlag


#del;

xtgee  war1000 demcatBlag demcatAlag RisDec lnparity PostIndep if year<= indep+3 & year >= indep-3, 
     family(binomial) link(logit) corr(ar1) force robust nolog;





**demcatBlag


#del;

xtgee  war1000 demcatBlag demcatAlag RisDec lnparity PostIndep if year<= indep+5 & year >= indep-5, 
     family(binomial) link(logit) corr(ar1) force robust nolog;


