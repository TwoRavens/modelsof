*******************************************************************************************
* INTERNATIONAL CRISES AND THE CAPITALIST PEACE
* Erik Gartzke and J. Joseph Hewitt
* International Interactions 2010 (Volume 36)
*
* This do-file replicates all statistical analyses reported in the above article. To run
* properly, this file requires that two STATA plug-ins have been installed. They are 
* Richard Tucker's BTSCS and Gary King's CLARIFY.
*******************************************************************************************


set more off
set mem 300m
set matsize 500

log using log_01.txt , text replace

* Prepare Polity data with modified Polity variables (polity21, polity22) for
* merging

use polity.dta
gen double dydyrid=((ccode1*1000+ccode2)*10000)+year
sort dydyrid
keep dydyrid polity21 polity22
save temp_polity_a.dta , replace

* Merge new Polity data, start with original file that includes crisis data;

use icb_futility_war_082004.dta
gen double dydyrid=((statea*1000+stateb)*10000)+year
sort dydyrid
merge dydyrid using temp_polity_a.dta
drop if _merge==2
drop _merge
mvdecode polity21 polity22 , mv(-99)
gen demlo2=min(polity21,polity22)
replace demlo2=. if polity21==. | polity22==.
gen demhi2=max(polity21,polity22)
replace demhi2=. if polity21==. | polity22==.

* Recode capopenl missing values to 0 (new variable capopnl2)
gen capopnl2=capopenl
replace capopnl2=0 if (capopenl==. & year>=1966)

gen gdppcln=ln(rgdppclo)
gen gdplncon=gdppcln*contig

btscs crisis1 year statea stateb, g(crisyrs) nspline(3)

***********************************************************************************
* Models with crisis onset as DV - Reported in Table A1
***********************************************************************************

* model A1
logit crisis1 demlo2 demhi2 deplo contig logdstab majpdyds alliesr lncaprt ///
 nafmeast crisyrs _spline1 _spline2 _spline3, cluster(dyadid)

* model A2 - Adding Capital
logit crisis1 demlo2 demhi2 deplo capopnl2 contig logdstab majpdyds allies ///
 lncaprt nafmeast crisyrs _spline1 _spline2 _spline3, cluster(dyadid)

* model A3 - Adding Interests
logit crisis1 demlo2 demhi2 deplo capopnl2 sun2cati contig logdstab majpdyds allies ///
 lncaprt nafmeast crisyrs _spline1 _spline2 _spline3, cluster(dyadid)

*model A4 - Adding Interests with GDP per capita (logged)
logit crisis1 demlo2 demhi2 deplo capopnl2 sun2cati gdppcln contig logdstab majpdyds allies ///
 lncaprt nafmeast crisyrs _spline1 _spline2 _spline3, cluster(dyadid)

* model A5 - Adding GDP per capita with Continguity interaction 
logit crisis1 demlo2 demhi2 deplo capopnl2 gdppcln gdplncon sun2cati contig ///
 logdstab majpdyds allies lncaprt nafmeast crisyrs _spline1 _spline2 _spline3, cluster(dyadid) 

save temp_data_01.dta , replace

************************************************************************************
* Generate data for substantive significance analysis (For graphs in Figure 2)
* Model 5 without regional Mideast dummy and with un-logged GDP per capita
************************************************************************************

estsimp logit crisis1 demlo2 demhi2 deplo capopnl2 rgdppclo gdpcontg sun2cati ///
 contig logdstab majpdyds allies lncaprt _spline1 _spline2 _spline3 , cluster(dyadid)

setx (demlo2 demhi2 deplo capopnl2 rgdppclo gdpcontg sun2cati lncaprt _spline1 ///
 _spline2 _spline3) mean contig 1 logdstab 6.529642 majpdyds 0 allies 0

* Simulating predicted values for DEMLO2

gen pes = .
gen plo = .
gen phi = .
gen xaxis = -10 + (_n-1)*0.4
local a = -10
while `a' <= 10.1 {
     display "Simulating for democ = `a'"  
     setx demlo2 `a'
     simqi, prval(1) genpr(pi)
     summarize pi
     replace pes = r(mean) if xaxis==float(`a')
     _pctile pi, p(2.5,97.5)
     replace plo = r(r1) if xaxis==float(`a')
     replace phi = r(r2) if xaxis==float(`a')
     drop pi
     local a = `a' + 0.4
}

outfile xaxis phi plo pes using pvals_dem.txt in 1/51 , comma wide replace

drop pes plo phi xaxis

* Simulating predicted values for CAPOPENL

gen pes = .
gen plo = .
gen phi = .
gen xaxis = 0 + (_n-1)*0.16
local a = 0
while `a' <= 8.1 {
     display "Simulating for capopnl = `a'"  
     setx capopnl2 `a'
     simqi, prval(1) genpr(pi)
     summarize pi
     replace pes = r(mean) if xaxis==float(`a')
     _pctile pi, p(2.5,97.5)
     replace plo = r(r1) if xaxis==float(`a')
     replace phi = r(r2) if xaxis==float(`a')
     drop pi
     local a = `a' + 0.16
}

outfile xaxis phi plo pes using pvals_cap.txt in 1/51 , comma wide replace

drop pes plo phi xaxis

* Simulating predicted values for interests

gen pes = .
gen plo = .
gen phi = .
gen xaxis = -1 + (_n-1)*0.04
local a = -1
while `a' <= 1.1 {
     display "Simulating for interests = `a'"  
     setx sun2cati `a'
     simqi, prval(1) genpr(pi)
     summarize pi
     replace pes = r(mean) if xaxis==float(`a')
     _pctile pi, p(2.5,97.5)
     replace plo = r(r1) if xaxis==float(`a')
     replace phi = r(r2) if xaxis==float(`a')
     drop pi
     local a = `a' + 0.04
}

outfile xaxis phi plo pes using pvals_int.txt in 1/51 , comma wide replace

drop pes plo phi xaxis

* Simulating predicted values for GDP/capita and interaction for contig
* dyads. Hence, GDP/capita and the interaction are equivalent in each simulated
* model.

gen pes = .
gen plo = .
gen phi = .
gen xaxis = 0 + (_n-1)*639.38
local a = 0
while `a' <= 31969.1 {
     display "Simulating for GDP/capita = `a'"  
     setx rgdppclo `a' gdpcontg `a'
     simqi, prval(1) genpr(pi)
     summarize pi
     replace pes = r(mean) if xaxis==float(`a')
     _pctile pi, p(2.5,97.5)
     replace plo = r(r1) if xaxis==float(`a')
     replace phi = r(r2) if xaxis==float(`a')
     drop pi
     local a = `a' + 639.38
}

outfile xaxis phi plo pes using pvals_gdp_ctig.txt in 1/51 , comma wide replace

drop pes plo phi xaxis

* Simulating predicted values for GDP/capita for non-contig pairs. Hence
* the interaction always equals 0.

gen pes = .
gen plo = .
gen phi = .
gen xaxis = 0 + (_n-1)*639.38
local a = 0
while `a' <= 31969.1 {
     display "Simulating for GDP*contig = `a'"  
     setx contig 0 gdpcontg 0 rgdppclo `a'
     simqi, prval(1) genpr(pi)
     summarize pi
     replace pes = r(mean) if xaxis==float(`a')
     _pctile pi, p(2.5,97.5)
     replace plo = r(r1) if xaxis==float(`a')
     replace phi = r(r2) if xaxis==float(`a')
     drop pi
     local a = `a' + 639.38
}

outfile xaxis phi plo pes using pvals_gdp_nctig.txt in 1/51 , comma wide replace

*****************************************************************************************
* Models presented in Tables 2 and 3
******************************************************************************************

* Preliminary steps to organize data and define relevant variables

use temp_data_01.dta , clear
rename dydyrid dyyrid
sort dyyrid
save temp_data_02.dta , replace


* Crisis Escalation Data (882 crisis-dyad onset years)

use crisis_escalation.dta , clear

keep statea stateb year oneside mrdy cendy sevdy grvdy war cmt trigcol gravcol ///
 grava gravb issa issb


* Define appropriate lag

gen yr1 = year-1
gen double dyyrid = (((statea*1000)+stateb)*10000)+yr1
keep dyyrid oneside mrdy cendy sevdy grvdy war cmt trigcol gravcol grava gravb issa issb
sort dyyrid
save temp_escalation_data.dta , replace


* Use file with crisis fatality and severity data

use crisis_severity.dta , clear
drop if ongoing==1
drop dyyrid


* Create new dyad-year id with 1-year lag

gen yr1 = year-1
gen double dyyrid = (((statea*1000)+stateb)*10000)+yr1
keep dyyrid totfatal severity
sort dyyrid
save temp_intensity_data.dta , replace

use temp_escalation_data.dta , clear

merge dyyrid using temp_intensity_data.dta
drop _merge
sort dyyrid

merge dyyrid using temp_data_02.dta

drop if _merge==1 | _merge==2

gen mrcol = 1 if mrdy>=6
replace mrcol =0 if mrdy<6


* Dummy indicating that violence was 'important' or 'preeminent'
gen cencol = 1 if cendy==3 | cendy==4
replace cencol = 0 if cendy==1 | cendy==2

* Dummy indicating that violence intensity was 'severe clashes' or 'war'
gen sevcol = 1 if sevdy==3 | sevdy==4
replace sevcol = 0 if sevdy==1 | sevdy==2



* Create an issue variable indicating crises over territory (or not). First, create
* a dummy based on the GRAV(A,B) variables. Territorial threats are certain when the
* variable equals 3 for either state. A territorial threat is possible when it equals
* 5 or 6

gen terrthrt = 2 if grava==3 | gravb==3
replace terrthrt = 1 if (grava==5 | grava==6 | gravb==5 | gravb==6)
replace terrthrt = 1 if oneside==1 & (gravb==5 | gravb==6)
replace terrthrt = 1 if oneside==2 & (grava==5 | grava==6)
replace terrthrt = 0 if oneside==0 & (grava==0 | grava==1 | grava==2 | grava==4 | grava==7) ///
 & (gravb==0 | gravb==1 | gravb==2 | gravb==4 | gravb==7)
replace terrthrt = 0 if oneside==1 & (gravb==0 | gravb==1 | gravb==2 | gravb==4 | gravb==7)
replace terrthrt = 0 if oneside==2 & (grava==0 | grava==1 | grava==2 | grava==4 | grava==7)

* Create final territorial dummy

gen terrtory = 1 if terrthrt==2
replace terrtory = 1 if terrthrt==1 & (issa==1 | issb==1)
replace terrtory = 0 if terrthrt==1 & (issa!=1 & issb!=1)
replace terrtory = 0 if terrthrt==0 & (issa==1 | issb==1)
replace terrtory = 0 if terrthrt==0

* Dichotimze countries into 'developed' and 'non-developed' categories. Original data
* is in 1985 constant dollars.

* Version 1 takes the 2004 World Bank cutoff between lower-middle income states and
* upper-middle income states ($3,256) and uses this as the threshold (converted to
* 1985 dollars).

gen devel = 1 if rgdppclo>=2262 & missing(rgdppclo)==0
replace devel = 0 if rgdppclo<2262 & missing(rgdppclo)==0

* Version 2 takes the 2004 World Bank range for upper-middle income countries ($3,256-$10,066)
* and takes the midpoint as the threshold value ($6661 in current 2004 dollars, converted to
* 1985 dollars)

gen devel2 = 1 if rgdppclo>=4627 & missing(rgdppclo)==0
replace devel2 = 0 if rgdppclo<4627 & missing(rgdppclo)==0

label variable devel "Developed state: GDPC(85)>$2,262"
label variable devel2 "Developed state: GDPPC(85)>$4,627"
label variable terrtory "Crisis over territory?"

label define vallble 0 No 1 Yes

label values devel vallble
label values devel2 vallble
label values terrtory vallble

tabulate devel terrtory , chi2 row
tabulate devel2 terrtory , chi2 row

gen gdp1000 = rgdppclo/1000

* Bivariate logistic regression
logit terrtory gdp1000

***********************************************************************************
* TABLE 2
***********************************************************************************

* Model 1
logit mrcol demlo2 demhi2 deplo trigcol gravcol contig logdstab majpdyds ///
 alliesr lncaprt

* Model 2
logit mrcol demlo2 demhi2 deplo capopnl2 trigcol gravcol contig logdstab majpdyds ///
 alliesr lncaprt

* Model 3
logit mrcol demlo2 demhi2 deplo capopnl2 gdppcln trigcol gravcol contig logdstab ///
 majpdyds alliesr lncaprt

* Model 4
logit mrcol demlo2 demhi2 deplo capopnl2 gdppcln gdplncon trigcol gravcol contig ///
 logdstab majpdyds alliesr lncaprt

* Model 5
logit mrcol demlo2 demhi2 deplo capopnl2 gdppcln gdplncon sun2cati trigcol gravcol ///
 contig logdstab majpdyds alliesr lncaprt


*************************************************************************************
* TABLE 3 - OLS Regression of Political/Economic Variables on Crisis Intensity
*************************************************************************************

gen fat1000=totfatal*0.001 /* To produce more interpretable coefficients */

* Model 6
regress fat1000 demlo2 demhi2 deplo contig logdstab majpdyds alliesr lncaprt

* Model 7
regress fat1000 demlo2 demhi2 deplo capopnl2 contig logdstab majpdyds allies ///
 lncaprt

* Model 8
regress fat1000 demlo2 demhi2 deplo capopnl2 gdppcln contig logdstab majpdyds ///
 allies lncaprt

* Model 9
regress fat1000 demlo2 demhi2 deplo capopnl2 gdppcln gdplncon contig logdstab ///
 majpdyds allies lncaprt

* Model 10
regress fat1000 demlo2 demhi2 deplo capopnl2 gdppcln gdplncon sun2cati contig ///
 logdstab majpdyds allies lncaprt
