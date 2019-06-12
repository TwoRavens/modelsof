/*******************************************************************************
"SCARCITY WITHOUT LEVIATHAN: The Violent Effects of Cocaine Supply Shortages
in the Mexican Drug War"
J.C. Castillo, D. Mejia, P. Restrepo
*********************************************************************************

This do file produces:
FIGURE 7: 	Relationship between seizures in Colombia and other anti-drug policies 
			in Colombia and Mexico.
			
Before running: set the path to current folder at line 19			
*******************************************************************************/
clear all
set matsize 5000
set more off
set more off

*Set local folder
local folder /*SET THE PATH TO CURRENT FOLDER HERE*/

*Set working directory
cd `folder'
use dta\CastilloMejiaRestrepo.dta

tab year if  timeTS >= ym(2006,12), gen(yy)

*mexican seasons
gen rainy=(month>=5 & month<=9)
gen hurricane=((month>=6 & month<=11))

*us seasons
gen spring=(month>=3 & month<=5)
gen summer=(month>=6 & month<=8)
gen fall=(month>=9 & month<=11)

*quarters
gen quart1=(month>=1 & month<=3)
gen quart2=(month>=4 & month<=6)
gen quart3=(month>=7 & month<=9)
gen quart4=(month>=10 & month<=12)

*month effects
tab month, gen(mm)
drop mm12 
local tscontrols t t2 t3  yy2 yy3 yy4 yy5 

*Cocaine seizures
gen supplyShock=log(cocaincCol)/10
*Homicides in Mexico
gen homicides=homSIMBAD


/****************************************************************/
/*******  Estimates for alternative anti-drug policies   ********/
/****************************************************************/ 

collapse `tscontrols' supplyShock unemp IGAE rainy hurricane price mm* prodNetaCol labsdestrCol insliqCol inssolCol (sum) heroseiz cocaseiz homicides poblacion, by(timeTS)

tsset timeTS

/*Colombian seizures of liquid inputs*/
gen depvar=log(insliqCol)
reg depvar supplyShock `tscontrols'  rainy hurricane if  timeTS >= ym(2006,12), robust
local est1=_b[supplyShock]
local se1=_se[supplyShock]

/*Colombian seizures of solid inputs*/
replace depvar=log(inssolCol)
reg depvar supplyShock `tscontrols'  rainy hurricane if  timeTS >= ym(2006,12), robust
local est2=_b[supplyShock]
local se2=_se[supplyShock]

/*Colombian destruction of cocaine labs*/
replace depvar=log(labsdestrCol)
reg depvar supplyShock `tscontrols'  rainy hurricane if  timeTS >= ym(2006,12), robust
local est3=_b[supplyShock]
local se3=_se[supplyShock]

/*Mexican seizures of cocaine*/
replace depvar=log(cocaseiz)
reg depvar supplyShock `tscontrols'  unemp IGAE rainy hurricane if  timeTS >= ym(2006,12), robust
local est4=_b[supplyShock]
local se4=_se[supplyShock]

/*Mexican seizure rate of cocaine*/
replace depvar=log(cocaseiz/prodNetaCol)
reg depvar supplyShock `tscontrols'  unemp IGAE rainy hurricane if  timeTS >= ym(2006,12), robust
local est5=_b[supplyShock]
local se5=_se[supplyShock]

/*Mexican seizures of heroin*/
replace depvar=log(heroseiz)
reg depvar supplyShock `tscontrols'  unemp IGAE rainy hurricane if  timeTS >= ym(2006,12), robust
local est6=_b[supplyShock]
local se6=_se[supplyShock]

/********************************/
/*Generate dataset for Figure 7 */
clear
set obs 6
gen category=_n
gen beta=.
gen serr=.

replace beta=`est1' in 1
replace beta=`est2' in 2
replace beta=`est3' in 3
replace beta=`est4' in 4
replace beta=`est5' in 5
replace beta=`est6' in 6

replace serr=`se1' in 1
replace serr=`se2' in 2
replace serr=`se3' in 3
replace serr=`se4' in 4
replace serr=`se5' in 5
replace serr=`se6' in 6

gen min95=beta-1.96*serr
gen max95=beta+1.96*serr
gen min90=beta-1.65*serr
gen max90=beta+1.65*serr

replace category=3*(category-1)+1


/************************/
/*Plot and save Figure 7*/

twoway  (bar beta category, fcolor(gs8%50) lcolor(black) lwidth(thin) barwidth(0.5))   ///
        (scatter beta category, mcolor(black) msize(small))       ///
        (rcap min90 max90 category, lcolor(black)) , ///
title(Relationship between seizures in Colombia and other policies, size(4.5)) ytitle(Estimates) xtitle("")   ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) /// 
ylabel(#8, glwidth(thin) glcolor(gs12)) legend(off) ///
xlabel( 1 `""Colombian" "seizures of" "liquid" "inputs""' ///
		4 `""Colombian" "seizures of" "solid"  "inputs""' ///
		7 `""Colombian" "destruction of" "cocaine"  "labs""' ///
		10 `""Mexican" "seizures of" "cocaine""' ///
		13 `""Mexican" "seizure rate" "of cocaine""' ///
		16 `""Mexican" "seizures" "of heroin""') 
graph export Figures/Figure7.eps, as(eps)   replace



 
