
gen lji4=.
replace lji4=1 if lji>=.4
replace lji4=0 if lji<.4
replace lji4=. if lji==.

gen lji4b=.
replace lji4b=1 if lji>=.4 & lji<.9
replace lji4b=0 if lji<.4
replace lji4b=. if lji==.




Model 1
psmatch2 lji4 yrslastconflict civilian military british french rgdppclag1 regimechange h_polcon3 al_ethnic, outcome(civilwar) noreplacement

pstest

gen match=ccode[_n1]
  gen treat=ccode if _n1!=.
   gen pair=_id if _treated==0
  replace pair=_n1 if _treated==1 
  bysort pair: egen paircount=count(pair)
  tab paircount
   tab paircount if paircount!=0
   
   drop if paircount!=2
 
   
   probit civilwar lji4, robust 
  margins, at(lji4=(0 1)) atmeans
  marginsplot
  

  
  
  Model 2
psmatch2 lji4b yrslastconflict civilian military british french rgdppclag1 regimechange h_polcon3 al_ethnic, outcome(civilwar) noreplacement

gen match=ccode[_n1]
  gen treat=ccode if _n1!=.
   gen pair=_id if _treated==0
  replace pair=_n1 if _treated==1 
  bysort pair: egen paircount=count(pair)
  tab paircount
   tab paircount if paircount!=0
   
   drop if paircount!=2
 

probit civilwar lji4b, robust 
  margins, at(lji4b=(0 1)) atmeans
  marginsplot
  

    
  
  
