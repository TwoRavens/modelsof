***Analyses February 2015

use "C:\Users\ev42\Dropbox\Oil & Globalization\ReplicationData\ReplicationdataRossVoeten.dta", clear

 set more off
 xtset ccode Year
 
 
*Table with descriptive statistics


tabstat minimal strucint political LEGAL oilexp newoildum logoil lnfuelexportscap lnnonfuelexportscap lngdp tradegdp lnpop polity democracy if (Year<2006 & Year>1969), stat(n mean sd min max)long col(stat) format(%9.2f)



**Table 2: Fixed Year and Country Effects

xtreg minimal l.oilexp  i.Year if Year>1969 , fe 
outreg2 l.oilexp using table2.doc, nolabel dec(2) replace

xtreg strucint l.oilexp i.Year if Year>1969, fe 
outreg2 l.oilexp using table2.doc, nolabel dec(2) append

xtreg political l.oilexp i.Year if Year>1969, fe 
outreg2 l.oilexp using table2.doc, nolabel dec(2) append

xtreg LEGAL l.oilexp i.Year if Year>1969, fe 
outreg2 l.oilexp using table2.doc, nolabel dec(2) append


***Table 3


xtreg strucint l.oilexp l.tradegdp l.lngdp  l.polity2 l.lnpop l.lnpopsq i.Year if Year>1969, fe 
outreg2 using table3.doc, nolabel dec(2) replace

xtreg strucint l.oilexp l.polity2 l.tradegdp l.lngdp l.lnpop l.lnpopsq i.Year if (mideas==0 & Year>1969) , fe 
outreg2 using table3.doc, nolabel dec(2) append

xtreg strucint l.newoildum l.polity2 l.tradegdp l.lngdp l.lnpop l.lnpopsq  i.Year if Year>1969 , fe 
outreg2 using table3.doc, nolabel dec(2) append

xtreg strucint l.logoil l.logoilsq l.polity2 l.tradegdp l.lngdp l.lnpop l.lnpopsq  i.Year if Year>1969 , fe 
outreg2 using table3.doc, nolabel dec(2) append


***Table 4

xtreg minimal l.newoildum l.democracy l.tradegdp l.lngdp l.lnpop l.lnpopsq i.Year if Year>1969 , fe 
outreg2 using table4.doc, nolabel dec(2) replace

xtreg strucint l.newoildum l.democracy l.tradegdp l.lngdp l.lnpop l.lnpopsq i.Year if Year>1969 , fe 
outreg2 using table4.doc, nolabel dec(2) append

xtreg LEGAL l.newoildum l.democracy l.tradegdp l.lngdp l.lnpop l.lnpopsq i.Year if Year>1969, fe 
outreg2 using table4.doc, nolabel dec(2) append

xtreg political l.newoildum l.democracy l.tradegdp l.lngdp l.lnpop l.lnpopsq i.Year if Year>1969, fe 
outreg2 using table4.doc, nolabel dec(2) append

***Table 5

xtreg d.minimal l.minimal l.lnfuelexportscap d.lnfuelexportscap l.lnnonfuelexportscap d.lnnonfuelexportscap l.lngdp d.lngdp l.democracy d.democracy l.lnpop d.lnpop t1 t2 t3 coldwar if Year>1969 , robust cluster(ccode)
outreg2 using table5.doc, nolabel dec(2) replace

xtreg d.strucint l.strucint l.lnfuelexportscap d.lnfuelexportscap l.lnnonfuelexportscap d.lnnonfuelexportscap l.lngdp d.lngdp l.democracy d.democracy l.lnpop d.lnpop t1 t2 t3 coldwar if Year>1969 , robust cluster(ccode)
outreg2 using table5.doc, nolabel dec(2) append

xtreg d.political l.political l.lnfuelexportscap d.lnfuelexportscap l.lnnonfuelexportscap d.lnnonfuelexportscap l.lngdp d.lngdp l.democracy d.democracy  l.lnpop d.lnpop t1 t2 t3 coldwar if Year>1969 , robust cluster(ccode)
outreg2 using table5.doc, nolabel dec(2) append

xtreg d.LEGAL l.LEGAL l.lnfuelexportscap d.lnfuelexportscap l.lnnonfuelexportscap d.lnnonfuelexportscap l.lngdp d.lngdp l.democracy d.democracy l.lnpop d.lnpop t1 t2 t3 coldwar if Year>1969 , robust cluster(ccode)
outreg2 using table5.doc, nolabel dec(2) append


***


****Figure 1


graph drop _all
 
 xtreg strucint l.newoildum##c.l.tradegdp  i.Year if Year>1969 , fe 

quietly: margins l.newoildum, at(l.tradegdp=(0(10)100)) 
marginsplot , title(Structured and Interventionist IGOs) xtitle("Merchandise Trade as a % of GDP") ///
scheme(s1mono) recast(line) recastci(rarea) legend(order(1 "Oil poor" 2 "Oil rich")) name(g2)
 
  xtreg minimal l.newoildum##c.l.tradegdp i.Year if Year>1969 , fe 

quietly: margins l.newoildum, at(l.tradegdp=(0(10)100)) 
marginsplot , title(Minimal IGOs) xtitle("Merchandise Trade as a % of GDP") ///
scheme(s1mono) recast(line) recastci(rarea) legend(order(1 "Oil poor" 2 "Oil rich")) name(g3)
 
  xtreg political l.newoildum##c.l.tradegdp  i.Year if Year>1969, fe 

quietly: margins l.newoildum, at(l.tradegdp=(0(10)100)) 
marginsplot , title(KOF Political Globalization) xtitle("Merchandise Trade as a % of GDP") ///
 scheme(s1mono) recast(line) recastci(rarea) legend(order(1 "Oil poor" 2 "Oil rich")) name(g5)
 
 xtreg LEGAL l.newoildum##c.l.tradegdp i.Year if Year>1969, fe 

quietly: margins l.newoildum, at(l.tradegdp=(0(10)100)) 
marginsplot , title(Compulsory Jurisdiction Index) xtitle("Merchandise Trade as a % of GDP") ///
scheme(s1mono) recast(line) recastci(rarea) legend(order(1 "Oil poor" 2 "Oil rich")) name(g6)
 
 graph combine  g2 g3  g5 g6, col(2) scheme(s1mono)

  
 **Table 6
 
use "C:\Users\ev42\Dropbox\Oil & Globalization\ReplicationData\AlleePeinharddatawithOil.dta", clear

oprobit icsid_clause permncx1 law_and_order1 law_and_order2 durable2 polconiii_2 atopally colony_any gdppc_grow2 ibrdida_gdp2 exp_gdp2 right_gov2 cowstartten2 gdpbal1, robust
outreg2 using table6.doc, nolabel dec(2) replace

oprobit icsid_clause oilexpb permncx1 law_and_order1 law_and_order2 durable2 polconiii_2 atopally colony_any gdppc_grow2 ibrdida_gdp2 exp_gdp2 right_gov2 cowstartten2 gdpbal1, robust
outreg2 using table6.doc, nolabel dec(2) append
*taking into account leverage of home country

oprobit icsid_clause c.oilexpb##newoilduma  permncx1 law_and_order1 law_and_order2 durable2 polconiii_2 atopally colony_any gdppc_grow2 ibrdida_gdp2 exp_gdp2 right_gov2 cowstartten2 gdpbal1, robust

outreg2 using table6.doc, nolabel dec(2) append

  oprobit icsid_clause newoildumb##newoilduma  permncx1 law_and_order1 law_and_order2 durable2 polconiii_2 atopally colony_any gdppc_grow2 ibrdida_gdp2 exp_gdp2 right_gov2 cowstartten2 gdpbal1, robust
 outreg2 using table6.doc, nolabel dec(2) append
 
  
  
  
  
  ****** Various Robustness Checks
  
  use "C:\Users\ev42\Dropbox\Oil & Globalization\ReplicationData\ReplicationdataRossVoeten.dta", clear

  *Models with random effects
  
 
 set more off
 xtset ccode Year
  
  
xtreg minimal l.oilexp  i.Year if Year>1969 , fe 
outreg2 l.oilexp using table2.doc, nolabel dec(2) replace

xtreg strucint l.oilexp i.Year if Year>1969, fe 
outreg2 l.oilexp using table2.doc, nolabel dec(2) append

xtreg political l.oilexp i.Year if Year>1969, fe 
outreg2 l.oilexp using table2.doc, nolabel dec(2) append

xtreg LEGAL l.oilexp i.Year if Year>1969, fe 
outreg2 l.oilexp using table2.doc, nolabel dec(2) append


***Table 3


xtreg strucint l.oilexp l.tradegdp l.lngdp  l.polity2 l.lnpop l.lnpopsq i.Year if Year>1969, re 
outreg2 using table3.doc, nolabel dec(2) replace

xtreg strucint l.oilexp l.polity2 l.tradegdp l.lngdp l.lnpop l.lnpopsq i.Year if (mideas==0 & Year>1969) , re 
outreg2 using table3.doc, nolabel dec(2) append

xtreg strucint l.newoildum l.polity2 l.tradegdp l.lngdp l.lnpop l.lnpopsq  i.Year if Year>1969 , re 
outreg2 using table3.doc, nolabel dec(2) append

xtreg strucint l.logoil l.logoilsq l.polity2 l.tradegdp l.lngdp l.lnpop l.lnpopsq  i.Year if Year>1969 , re 
outreg2 using table3.doc, nolabel dec(2) append


***Table 4

xtreg minimal l.newoildum l.democracy l.tradegdp l.lngdp l.lnpop l.lnpopsq i.Year if Year>1969 , re 
outreg2 using table4.doc, nolabel dec(2) replace

xtreg strucint l.newoildum l.democracy l.tradegdp l.lngdp l.lnpop l.lnpopsq i.Year if Year>1969 , re 
outreg2 using table4.doc, nolabel dec(2) append

xtreg LEGAL l.newoildum l.democracy l.tradegdp l.lngdp l.lnpop l.lnpopsq i.Year if Year>1969, re 
outreg2 using table4.doc, nolabel dec(2) append

xtreg political l.newoildum l.democracy l.tradegdp l.lngdp l.lnpop l.lnpopsq i.Year if Year>1969, re 
outreg2 using table4.doc, nolabel dec(2) append




***Replication of Donno, Metzger, and Russett
use "C:\Users\ev42\Dropbox\Oil & Globalization\ReplicationData\DonnoRussettISQdata.dta", clear


	probit member 	oilexp pHat strInst_epol intvInst_epol security_epol econBGN ///
					systemSize avgPolityEx3_d eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2  ///
					, cluster(ccodeYr)
					
	outreg2 using table1.doc, nolabel dec(2) replace
		
							
					
	probit member 	lnfuelexportscap lnfuelexportscapsq lnnonfuelexportscap pHat strInst_epol intvInst_epol security_epol econBGN ///
									systemSize avgPolityEx3_d eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)
		
	outreg2 using table1.doc, nolabel dec(2) append		
	
		probit member 	lnfuelexportscap lnfuelexportscapsq lnnonfuelexportscap lngdppercap pHat strInst_epol intvInst_epol security_epol econBGN ///
									systemSize avgPolityEx3_d eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3  ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 i.region ///
					, cluster(ccodeYr)
		
	outreg2 using table1.doc, nolabel dec(2) append	
	

		
		probit member 	logoil logoilsq lntradegdp lngdppercap pHat strInst_epol intvInst_epol security_epol econBGN ///
									systemSize avgPolityEx3_d eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3   ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 i.region  ///
					, cluster(ccodeYr)
					
			outreg2 using table1.doc, nolabel dec(2) append	
	



