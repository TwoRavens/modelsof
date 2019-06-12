version  11.2
set more off


**********************************************
*											 *
*											 *
*			 	TABLE 1  					 *
*	        							     *
*											 *
*											 *
**********************************************

tab LoTMilitaryRecode

**********************************************
*											 *
*											 *
*			 	TABLE 2 					 *
*	        							     *
*											 *
*											 *
**********************************************



******Model 1***********
ologit ciri_tort p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag GTDDomesticlag dissentlag, robust cluster(ccodecow) nolog

test _b[/cut1]= _b[/cut2]

******Model 2***********
ologit ciri_tort p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag ITERATELoclag dissentlag, robust cluster (ccodecow) nolog

test _b[/cut1]= _b[/cut2]

******Model 3***********
ologit ciri_tort p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag GTDDomesticlag ITERATELoclag dissentlag, robust cluster (ccodecow) nolog

test _b[/cut1]= _b[/cut2]

******Model 4***********
ologit ciri_tort p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag GTDlag dissentlag, robust cluster (ccodecow) nolog

test _b[/cut1]= _b[/cut2]


**********************************************
*											 *
*											 *
*			 	TABLE 3   					 *
*	        							     *
*											 *
*											 *
**********************************************



******Model 5***********
ologit LoTMilitaryRecode p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag GTDDomesticlag RstrctAccess dissentlag, robust cluster (ccodecow) nolog

test _b[/cut1]= _b[/cut2]
test _b[/cut2]= _b[/cut3]
test _b[/cut3]= _b[/cut4]
test _b[/cut4]= _b[/cut5] 

******Model 6***********
ologit LoTMilitaryRecode p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag ITERATELoclag RstrctAccess dissentlag, robust cluster (ccodecow) nolog

test _b[/cut1]= _b[/cut2]
test _b[/cut2]= _b[/cut3]
test _b[/cut3]= _b[/cut4]
test _b[/cut4]= _b[/cut5]

******Model 7***********
ologit LoTMilitaryRecode p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag GTDDomesticlag ITERATELoclag RstrctAccess dissentlag, robust cluster (ccodecow) nolog

test _b[/cut1]= _b[/cut2]
test _b[/cut2]= _b[/cut3]
test _b[/cut3]= _b[/cut4]
test _b[/cut4]= _b[/cut5]

******Model 8*********** 
ologit LoTMilitaryRecode p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag GTDlag RstrctAccess dissentlag, robust cluster (ccodecow) nolog

test _b[/cut1]= _b[/cut2]
test _b[/cut2]= _b[/cut3]
test _b[/cut3]= _b[/cut4]
test _b[/cut4]= _b[/cut5]


exit

