#replication files for Table 2 in What We Talk About When We Talk About FDI###


###models 1-3#####
local DV flows2000 dstock2000 capex2000 
local IV l.(c.polity2  c.lngdp   c.lngdppc   lntradegdp  c.lndist  gdpgrowth  c.LOR  c.ckaopen2010   ) i.year  if OECDMT ==0 & sanctions !=1
est clear
foreach DV in `DV'{
qui rreg `DV' `IV' 
est store `DV'
 }
 estout * , keep(L.polity2 L.lngdp L.lngdppc L.lndist L.LOR L.ckaopen2010 L.gdpgrowth L.lntradegdp _cons) cells(b(star fmt(%9.1f) label(coef.)) se(par fmt(%9.1f)label(SE))) style(fixed) stats(r2 N) label legend posthead("") prefoot("") postfoot("")  varlabels(_cons Constant) starlevels(  * 0.05 ** 0.01 *** 0.001) number ("" "") 

 
###generate within sample desrciptive statisics###  
 
 su flows2000 dstock capex2000 L.polity2 L.lngdp L.lngdppc L.lndist L.LOR L.ckaopen2010 L.gdpgrowth L.lntradegdp if e(sample)


####generate the panel avarages for use in model 4-6#####
local IV  ckaopen2010 polity2 lngdp lngdppc LOR gdpgrowth lntradegdp 
local dv flows2000 dstock2000 capex2000 
foreach IV in `IV'{
egen `IV'97 = mean(`IV') if year >=1982 & year <= 1996, by(cowcode)
}
foreach dv in `dv'{
egen `dv'97 = mean(`dv') if year >=1997, by(cowcode)
}


###models 4-6#####
est clear
local DV flows200097 dstock200097 capex200097 
local IV l.(polity297 lngdp97    lngdppc97   lntradegdp97 lndist gdpgrowth97   LOR97  ckaopen201097  )   if OECDMT ==0 & sanctions !=1
foreach DV in `DV'{
qui rreg `DV' `IV' 
est store `DV'
 }
 estout * , cells(b(star fmt(%9.1f) label(coef.)) se(par fmt(%9.1f)label(SE))) style(fixed) stats(r2 N) label legend posthead("") prefoot("") postfoot("")  varlabels(_cons Constant) starlevels(* 0.05 ** 0.01 *** 0.001) number ("" "") 

###generate within sample desrciptive statisics###  

su flows200097 dstock97 capex200097 ckaopen201097 l.(polity297 lngdp97    lngdppc97   lntradegdp97 lndist gdpgrowth97   LOR97  ckaopen201097  )  if e(sample)
