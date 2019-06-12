**********************************************************
//////////////////////////////////////////////////////////
// Author: Matthew R. DiGiuseppe  
//
// Do File: ISQreplication
//
// Date: 12/06/13
//////////////////////////////////////////////////////////
**********************************************************



use Allen_DiGi_Rep, clear

global rhs IMR cinc sumrival1 wovers_1 atwar5 ayr ayr2 ayr3

//////////////////////////////////////////////////////////
/////// TABLE 2  /////////////////////////////////////////
//////////////////////////////////////////////////////////
set more off
// MODEL 2.1
probit  formationB2N extdebtcrisis_1 $rhs  , robust
//  MODEL 2.2
// major powers only
probit  formationB2N extdebtcrisis_1 $rhs  if majpow==1 , robust
//  MODEL 2.3
// non-major powers only
probit  formationB2N extdebtcrisis_1 $rhs  if majpow!=1 , robust

//////////////////////////////////////////////////////////
/////// TABLE 4  /////////////////////////////////////////
//////////////////////////////////////////////////////////

// Table 4.1
// cent gov't debt (all states)
probit  formationB2N cntgovtdbtgdp1 $rhs  , robust

// Table 4.2
// cent gov't debt (maj powers)
probit  formationB2N cntgovtdbtgdp1 $rhs if majpow==1  , robust

// Table 4.3
// cent gov't debt (maj powers)
probit  formationB2N cntgovtdbtgdp1 $rhs if majpow!=1  , robust


//////////////////////////////////////////////////////////
/////// TABLE 5  /////////////////////////////////////////
//////////////////////////////////////////////////////////

// Table 5 Model 5.1
// II rating variable
probit formationB2N rating_1 $rhs, robust

// Table 5 Model 5.1
// II rating variable
probit formationB2N rating_1  $rhs if majpow==1  , robust

// Table 5 Model 5.3
// II rating variable
probit formationB2N rating_1  $rhs if majpow!=1  , robust



///////////////////////////////////////////////////////////
//// TABLE 6 - Controlling for WWI, WWII and Cold War ///// 
///////////////////////////////////////////////////////////
set more off

global rhs IMR cinc sumrival1 wovers_1 atwar5 wwi wwii coldwar ayr ayr2 ayr3

//Table 6, Model 6.1 - debt crisis
probit formationB2N extdebtcrisis_1 $rhs, robust
//Table 6, Model 6.2 - debt/GDP ratio
probit formationB2N cntgovtdbtgdp1 $rhs, robust
//Table 6, Model 6.3 - II Rating 
probit formationB2N rating_1 $rhs, robust





//////////////////////////////////////////////////////////
//crisis fig 1
//////////////////////////////////////////////////////////
// * NOTE*: THE FIGURE REPORTED IN THE PRINTED VERSION HAS A SMALL MISKATE
// THE SIMULATIONS ARE PRESETNED BETWEEN 7.5 AND 97.5 PERCENTILES 
// THE SIMULATIONS SHOULD BE PRESETNED BETWEEN 2.5 AND 97.5 PERCENTILES
// THE FIGURE BELOW CORRECTS FOR THIS TYPO 

global rhs IMR cinc sumrival1 wovers_1 atwar5 ayr ayr2 ayr3

estsimp probit formationB2N extdebtcrisis_1 $rhs if majpow==1, robust

	setx mean if majpow==1
	setx extdebtcrisis_1 0

	simqi, prval(1) genpr (nodef)
	
	_pctile nodef, p(7.5,97.5)
	replace nodef =. if nodef < r(r1) | nodef > r(r2)
	summarize nodef

	setx mean if majpow==1
	setx extdebtcrisis_1 1

	simqi, prval(1) genpr (def)
	
	_pctile def, p(2.5,97.5)
	replace def =. if def < r(r1) | def > r(r2)
	summarize def

	gen def_change = ((def-nodef)/nodef)*100
	sum def_change
	
	twoway hist def, frequency ||hist nodef, ysc(on) frequency xlabel(0 .25 .5)  ///
	xtitle("Pr(Alliance Formation)") ylabel(0 20 40 60) ytitle(Frequency)  ///
	scheme(s2mono) graphregion(fcolor(white))
	










