
clear
set mem 250m
set more off


use "C:\xxx\xxx\jpr data.dta", clear

*********************************************************************************
***  twxxxxxx denotes TWEED DATA
***  miptxxxxxx denotes MIPT DATA
***  xxxxxxx1 donotes incidents one year prior to coalition formation
***  xxxxxxx1 donotes incidents one year prior to coalition formation
***  xxkilledx number of fatalities
***  xxinjuredx number of injured
***  xxnoactsx numer of terrorist incidents
***  xxextrax number of terrorist incidents taking account of coordinated attacks
**********************************************************************************

foreach var in twkilled1 twkilled2 twkilled3 twinjured1 twinjured2 twinjured3 twnoacts1 twnoacts2 twnoacts3 twextra1 twextra2 twextra3 {
	gen `var'min=`var'*minority
	gen `var'larg=`var'*largest
	gen `var'med=`var'*median
	gen `var'surpl=`var'*surpl
	gen `var'cabp=`var'*cabparties
	gen `var'gdiv=`var'*govdiv
	gen `var'odiv=`var'*oppdiv
	gen `var'gpol=`var'*govtpolariz
	gen `var'opol=`var'*opppolariz
}

foreach var in  miptkilled1 miptkilled2 miptkilled3 miptinjured1 miptinjured2 miptinjured3 miptnoacts1 miptnoacts2 miptnoacts3 miptextra1 miptextra2 miptextra3 {
	gen `var'min=`var'*minority
	gen `var'larg=`var'*largest
	gen `var'med=`var'*median
	gen `var'surpl=`var'*surpl
	gen `var'cabp=`var'*cabparties
	gen `var'gdiv=`var'*govdiv
	gen `var'odiv=`var'*oppdiv
	gen `var'gpol=`var'*govtpolariz
	gen `var'opol=`var'*opppolariz
}

****************************************************
*** Analysis for MIPT data - Transnational Terrorism
****************************************************

foreach var in min surpl larg med cabp gpol opol gdiv odiv {
	gen mipt`var'=miptkilled1`var'
	}

label var miptmin "\textsc{   --- T*Minority Coalition}"
label var miptsurpl "\textsc{   --- T*Surplus Coalition}"
label var miptlarg "\textsc{   --- T*Largest Party}"
label var miptmed "\textsc{   --- T*Median Party}"
label var miptcabp "\textsc{   --- T*No.~Parties}"
label var miptopol "\textsc{   --- T*Opp.~Polarization}"
label var miptgpol "\textsc{   --- T*Gov't Polarization}"


**************************************************************************
*** Uncomment est2vec and est2tex commands to output tables to latex
*** est2tex package: http://econ.ucsd.edu/muendler/docs/stata/est2tex.html
**************************************************************************

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz miptmin miptsurpl miptmed miptlarg miptcabp miptgpol miptopol if majparty==0, group(formopp) 
*est2vec miptan, replace vars(minority miptmin surpl miptsurpl cabparties miptcabp largest miptlarg median miptmed govtpolariz miptgpol opppolariz miptopol) name(MIPTK1) e(ll N)

foreach var in min surpl larg med cabp gpol opol gdiv odiv {
	replace mipt`var'=miptkilled2`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz miptmin miptsurpl miptmed miptlarg miptcabp miptgpol miptopol if majparty==0, group(formopp) 
*est2vec miptan, addto(miptan) name(MIPTK2)


foreach var in min surpl larg med cabp gpol opol gdiv odiv {
	replace mipt`var'=miptinjured1`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz miptmin miptsurpl miptmed miptlarg miptcabp miptgpol miptopol if majparty==0, group(formopp) 
*est2vec miptan, addto(miptan) name(MIPTI1)

foreach var in min surpl larg med cabp gpol opol gdiv odiv {
	replace mipt`var'=miptinjured2`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz miptmin miptsurpl miptmed miptlarg miptcabp miptgpol miptopol if majparty==0, group(formopp) 
*est2vec miptan, addto(miptan) name(MIPTI2)

foreach var in min surpl larg med cabp gpol opol gdiv odiv {
	replace mipt`var'=miptnoacts1`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz miptmin miptsurpl miptmed miptlarg miptcabp miptgpol miptopol if majparty==0, group(formopp) 
*est2vec miptan, addto(miptan) name(MIPTNO1)

foreach var in min surpl larg med cabp gpol opol gdiv odiv {
	replace mipt`var'=miptnoacts2`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz miptmin miptsurpl miptmed miptlarg miptcabp miptgpol miptopol if majparty==0, group(formopp) 
*est2vec miptan, addto(miptan) name(MIPTNO2)

foreach var in min surpl larg med cabp gpol opol gdiv odiv {
	replace mipt`var'=miptextra1`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz miptmin miptsurpl miptmed miptlarg miptcabp miptgpol miptopol if majparty==0, group(formopp) 
*est2vec miptan, addto(miptan) name(MIPTE1)

foreach var in min surpl larg med cabp gpol opol gdiv odiv {
	replace mipt`var'=miptextra2`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz miptmin miptsurpl miptmed miptlarg miptcabp miptgpol miptopol if majparty==0, group(formopp) 
*est2vec miptan, addto(miptan) name(MIPTE2)

*est2tex miptan, replace dropall path(C:\Projects\Clientelism\Terrorism Paper\) mark(starb) fancy label levels(90 95 99)



****************************************************
*** Analysis for TWEED data - Domestic Terrorism
****************************************************


foreach var in min surpl larg med cabp gdiv odiv gpol opol {
	gen tw`var'=twkilled1`var'
	}

label var twmin "\textsc{   --- T*Minority Coalition}"
label var twsurpl "\textsc{   --- T*Surplus Coalition}"
label var twlarg "\textsc{   --- T*Largest Party}"
label var twmed "\textsc{   --- T*Median Party}"
label var twcabp "\textsc{   --- T*No.~Parties}"
label var twopol "\textsc{   --- T*Opp.~Polarization}"
label var twgpol "\textsc{   --- T*Gov't Polarization}"

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz twmin twsurpl twlarg twmed twcabp twgpol twopol if majparty==0, group(formopp) 
*est2vec twan, replace vars(minority twmin surpl twsurpl cabparties twcabp largest twlarg median twmed govtpolariz twgpol opppolariz twopol) name(TWK1) e(ll N)

foreach var in min surpl larg med cabp gdiv odiv gpol opol {
	replace tw`var'=twkilled2`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz twmin twsurpl twlarg twmed twcabp twgpol twopol if majparty==0, group(formopp) 
*est2vec twan, addto(twan) name(TWK2)

foreach var in min surpl larg med cabp gdiv odiv gpol opol {
	replace tw`var'=twinjured1`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz twmin twsurpl twlarg twmed twcabp twgpol twopol if majparty==0, group(formopp) 
*est2vec twan, addto(twan) name(TWI1)

foreach var in min surpl larg med cabp gdiv odiv gpol opol {
	replace tw`var'=twinjured2`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz twmin twsurpl twlarg twmed twcabp twgpol twopol if majparty==0, group(formopp) 
*est2vec twan, addto(twan) name(TWI2)

foreach var in min surpl larg med cabp gdiv odiv gpol opol {
	replace tw`var'=twnoacts1`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz twmin twsurpl twlarg twmed twcabp twgpol twopol if majparty==0, group(formopp) 
*est2vec twan, addto(twan) name(TWNO1)

foreach var in min surpl larg med cabp gdiv odiv gpol opol {
	replace tw`var'=twnoacts2`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz twmin twsurpl twlarg twmed twcabp twgpol twopol if majparty==0, group(formopp) 
*est2vec twan, addto(twan) name(TWNO2)

foreach var in min surpl larg med cabp gdiv odiv gpol opol {
	replace tw`var'=twextra1`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz twmin twsurpl twlarg twmed twcabp twgpol twopol if majparty==0, group(formopp) 
*est2vec twan, addto(twan) name(TWNOD1)

foreach var in min surpl larg med cabp gdiv odiv gpol opol {
	replace tw`var'=twextra2`var'
	}

clogit cabinet minority surpl cabparties largest median govtpolariz opppolariz twmin twsurpl twlarg twmed twcabp twgpol twopol if majparty==0, group(formopp) 
*est2vec twan, addto(twan) name(TWNOD2)

*est2tex twan, replace dropall path(C:\Projects\Clientelism\Terrorism Paper\) mark(starb) fancy label levels(90 95 99)


