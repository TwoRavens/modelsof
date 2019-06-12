capture log close
log using "RRP-APSR-ReplicationCode-Main-2017-04-04.log", replace

clear
clear matrix
set more off

version 14.2


****************************************************************************************
*
* Reese, Ruby and Pape 
*
* "Days of Action or Restraint? How the Islamic Calendar Impacts Violence"
*
* Main Article Analysis Replication Code
* 
* April 4, 2017
*
****************************************************************************************



****************************************************************************************
* Figure 2
****************************************************************************************


** Prepare data file by appending and labeling cases

*Afghanistan
clear
use "RRP-APSR-RepData-2017-04-04-AFG.dta"
gen case = "Afghanistan"
rename rcname province
rename ctwits wits // NCTC-WITS Attacks
rename ctgtd gtd // START-GTD Attacks
rename ctsigact siga // SIGACT Events
keep case gdate gyear gday gnummnth hyear hnummnth hday wits gtd siga 
save "temp2.dta", replace

*Iraq
use "RRP-APSR-RepData-2017-04-04-IRQ.dta"
gen case = "Iraq"
rename ctwits wits // NCTC-WITS Attacks
rename ctgtd gtd // START-GTD Attacks
rename ctibc ibc // Iraq Body Count
keep case gdate gyear gday gnummnth hyear hnummnth hday wits gtd ibc 
save "temp1.dta", replace

*Pakistan
clear
use "RRP-APSR-RepData-2017-04-04-PAK.dta"
gen case = "Pakistan"
rename prov province
rename ctwits wits // NCTC-WITS Attacks
rename ctgtd gtd // START-GTD Attacks
rename ctpips pips // PIPS Attacks
keep case province gdate gyear gnummnth gday hyear hnummnth hday wits gtd pips 
append using "temp1.dta"
append using "temp2.dta"
label var province "Province"
label var case "Case"
label var gyear "Gregorian Year" 
label var gnummnth "Gregorian Month"
label var gday "Gregorian Day"
label var hyear "Hijri Year"
label var hnummnth "Hijri Month"
label var hday "Hijri Day"
erase "temp1.dta"
erase "temp2.dta"

**Aggregation

*Aggregate attacks to Case-Gregorian Date from Case-Province-Gregorian Date
collapse ///
(first) gyear gnummnth gday hyear hnummnth hday ///
(sum) wits  ///
(sum) gtd ///
(sum) ibc ///
(sum) siga ///
(sum) pips ///
, by (case gdate)
save "temp1.dta", replace

*Aggregate to Hijri Year Month
collapse ///
(sum) wits  ///
(sum) gtd ///
(sum) ibc ///
(sum) siga ///
(sum) pips ///
, by (case hyear hnummnth)
save "temp2.dta", replace

*Create Gregorian to Hijri Date Lookup 
clear
use "temp1.dta"
keep case gdate gyear gday gnummnth hyear hnummnth hday
merge m:1 case hyear hnummnth using temp2.dta
erase "temp1.dta"
erase "temp2.dta"
label var case "Case"
label var gyear "Gregorian Year" 
label var gnummnth "Gregorian Month"
label var gday "Gregorian Day"
label var hyear "Hijri Year"
label var hnummnth "Hijri Month"
label var hday "Hijri Day"
label var wits "WITS"
label var gtd "GTD"
label var ibc "IBC"
label var siga "SIGACTs"
label var pips "PIPS"

*Convert gdate from string to date
gen gdated = date(gdate, "MDY")
format %tdNN/DD/CCYY gdated
drop gdate
rename gdated gdate

*WITS Jan 2004 to Dec 2011
replace wits = . if gdate >date("20111231","YMD")

*IBC Jan 2004 to June 2009 in Iraq
replace ibc = . if gdate >= date("20090701","YMD") & case == "Iraq"
replace ibc = . if case != "Iraq"

*SIGACTS Jan 2008 - Dec 2014 in Afghanistan
replace siga = . if gdate <= date("20071231","YMD") & case == "Afghanistan"
replace siga = . if case != "Afghanistan"

*PIPS in Pakistan
replace pips = . if case != "Pakistan"

sort case gdate  

*Drop incomplete Hijri Months from beginning and end of each dataset since these
*will give appearance of false decline aggregating to Hijri Month Year.

replace gtd = . if hyear==1424 & hnummnth==11 // begin GTD
replace gtd = . if hyear==1436 & hnummnth==3 // end GTD
replace wits = . if hyear==1424 & hnummnth==11 // begin WITS
replace wits = . if hyear==1433 & hnummnth==2 // end WITS
replace pips = . if hyear==1424 & hnummnth==11 & case == "Pakistan" // begin PIPS
replace pips = . if hyear==1436 & hnummnth==3 & case == "Pakistan" // end PIPS
replace ibc = . if hyear==1424 & hnummnth==11 & case=="Iraq" // begin IBC
replace ibc = . if hyear==1430 & hnummnth==7 & case=="Iraq" // end IBC
replace siga = . if hyear==1436 & hnummnth==3 & case == "Afghanistan" // end SIGACTs
replace siga = . if hyear==1428 & hnummnth==12 & case=="Afghanistan" // beginning SIGACT
by case: gene daynum=_n

***Figure EPS Export

set scheme s1color

**Color

*Afghanistan Color
twoway (line wits daynum if case == "Afghanistan", lwidth(medthick) lcolor(green)) ///
(line gtd daynum if case == "Afghanistan", lwidth(medthick)) ///
(line siga daynum if case == "Afghanistan", xaxis(2) lwidth(medthick) yaxis(2)), ///
title("AFGHANISTAN", position(11) size(vlarge)) ///
legend(label(1 "WITS") label(2 "GTD") label(3 "SIGACTs (Secondary Axis)") ring(0) position(10) rows(3)) /// changes legend series labels, places them in the drawing region, and forces them to one column
ylabel(, labsize(large)) ///
ylabel(, labsize(large) axis(2)) ///
xtick(51 406 761 1115 1469 1823 2178 2532 2887 3241 3596 3950, axis(1) tl(*2)) ///
xline(51 406 761 1115 1469 1823 2178 2532 2887 3241 3596 3950, axis(1) lcolor(gs10)) ///
xtick(0 366 731 1096 1461 1827 2192 2557  2922 3288  3653 4018, axis(2) tl(*2)) ///
xlabel(228 "1425" 583 "1426" 938 "1427" 1292 "1428" 1646 "1429" 2000 "1430" 2355 "1431" 2709 " 1431" 3064 "1432" 3418 "1433" 3773 "1434", axis(1) labsize(large) notick) ///
xlabel(183 "2004" 549 "2005" 914 "2006"	1279 "2007"	1644 "2008"	2010 "2009"	2375 "2010"	2740 "2011"	3105 "2012"	3471 "2013"	3836 "2014", axis(2) labsize(large) notick) ///
xtitle("Hijri Calendar", axis(1) size(large) margin(top)) ///
xtitle("Gregorian Calendar", axis(2) size(medlarge) margin(bottom)) ///
ytitle("Violent Events", size(large)) ytitle("", axis(2)) ///
ysize(2.25) xsize(6.5)
graph export "RRP-Fig2-AFG-Color.eps", replace

*Iraq Color
twoway (line wits daynum if case == "Iraq", xaxis(1) lwidth(medthick) lcolor(green)) ///
(line gtd daynum if case == "Iraq", xaxis(1) lwidth(medthick)) ///
(line ibc daynum if case == "Iraq", xaxis(2) lwidth(medthick)), ///
title("IRAQ", position(11) size(vlarge)) ///
legend(label(1 "WITS") label(2 "GTD") label(3 "IBC") ring(0) position(10) rows(3)) /// changes legend series labels, places them in the drawing region, and forces them to one column
xtick(51 406 761 1115 1469 1823 2178 2532 2887 3241 3596 3950, axis(1) tl(*2)) ///
xline(51 406 761 1115 1469 1823 2178 2532 2887 3241 3596 3950, axis(1) lcolor(gs10)) ///
xtick(0 366 731 1096 1461 1827 2192 2557  2922 3288  3653 4018, axis(2) tl(*2)) ///
xlabel(228 "1425" 583 "1426" 938 "1427" 1292 "1428" 1646 "1429" 2000 "1430" 2355 "1431" 2709 " 1431" 3064 "1432" 3418 "1433" 3773 "1434", axis(1) labsize(large) notick) ///
xlabel(183 "2004" 549 "2005" 914 "2006"	1279 "2007"	1644 "2008"	2010 "2009"	2375 "2010"	2740 "2011"	3105 "2012"	3471 "2013"	3836 "2014", axis(2) labsize(large) notick) ///
ylabel(, labsize(large)) ///
xtitle("Hijri Calendar", axis(1) size(large) margin(top)) ///
xtitle("Gregorian Calendar", axis(2) size(large) margin(bottom)) ///
ytitle("Violent Events", size(large)) ///
ysize(2.25) xsize(6.5)
graph export "RRP-Fig2-IRQ-Color.eps", replace

*Pakistan Color
twoway (line wits daynum if case == "Pakistan", lwidth(medthick) lcolor(green)) ///
(line gtd daynum if case == "Pakistan", lwidth(medthick)) ///
(line pips daynum if case == "Pakistan", xaxis(2) lwidth(medthick)), ///
title("PAKISTAN", position(11) size(vlarge)) /// 
legend(label(1 "WITS") label(2 "GTD") label(3 "PIPS") ring(0) position(10) rows(3)) /// changes legend series labels, places them in the drawing region, and forces them to one column
xtick(51 406 761 1115 1469 1823 2178 2532 2887 3241 3596 3950, axis(1) tl(*2)) ///
xline(51 406 761 1115 1469 1823 2178 2532 2887 3241 3596 3950, axis(1) lcolor(gs10)) ///
xtick(0 366 731 1096 1461 1827 2192 2557  2922 3288  3653 4018, axis(2) tl(*2)) ///
xlabel(228 "1425" 583 "1426" 938 "1427" 1292 "1428" 1646 "1429" 2000 "1430" 2355 "1431" 2709 " 1431" 3064 "1432" 3418 "1433" 3773 "1434", axis(1) labsize(large) notick) ///
xlabel(183 "2004" 549 "2005" 914 "2006"	1279 "2007"	1644 "2008"	2010 "2009"	2375 "2010"	2740 "2011"	3105 "2012"	3471 "2013"	3836 "2014", axis(2) labsize(large) notick) ///
ylabel(, labsize(medlarge)) ///
xtitle("Hijri Calendar", axis(1) size(large) margin(top)) ///
xtitle("Gregorian Calendar", axis(2) size(large) margin(bottom)) ///
ytitle("Violent Events", size(large)) ///
ysize(2.25) xsize(6.5)
graph export "RRP-Fig2-PAK-Color.eps", replace

**Grayscale

*Afghanistan Grayscale
twoway (line wits daynum if case == "Afghanistan", lwidth(medthick) lcolor(black) lpattern(solid)) ///
(line gtd daynum if case == "Afghanistan", lwidth(medthick) lcolor(gray) lpattern(solid)) ///
(line siga daynum if case == "Afghanistan", xaxis(2) lwidth(medthick) lcolor(black) lpattern(dash) yaxis(2)), ///
title("AFGHANISTAN", position(11) size(vlarge)) ///
legend(label(1 "WITS") label(2 "GTD") label(3 "SIGACTs (Secondary Axis)") ring(0) position(10) rows(3)) /// changes legend series labels, places them in the drawing region, and forces them to one column
ylabel(, labsize(large)) ///
ylabel(, labsize(large) axis(2)) ///
xtick(51 406 761 1115 1469 1823 2178 2532 2887 3241 3596 3950, axis(1) tl(*2)) ///
xline(51 406 761 1115 1469 1823 2178 2532 2887 3241 3596 3950, axis(1) lcolor(gs10)) ///
xtick(0 366 731 1096 1461 1827 2192 2557  2922 3288  3653 4018, axis(2) tl(*2)) ///
xlabel(228 "1425" 583 "1426" 938 "1427" 1292 "1428" 1646 "1429" 2000 "1430" 2355 "1431" 2709 " 1431" 3064 "1432" 3418 "1433" 3773 "1434", axis(1) labsize(large) notick) ///
xlabel(183 "2004" 549 "2005" 914 "2006"	1279 "2007"	1644 "2008"	2010 "2009"	2375 "2010"	2740 "2011"	3105 "2012"	3471 "2013"	3836 "2014", axis(2) labsize(large) notick) ///
xtitle("Hijri Calendar", axis(1) size(large) margin(top)) ///
xtitle("Gregorian Calendar", axis(2) size(large) margin(bottom)) ///
ytitle("Violent Events", size(large)) ytitle("", axis(2)) ///
ysize(2.25) xsize(6.5)
graph export "RRP-Fig2-AFG-Grayscale.eps", replace

*Iraq Grayscale
twoway (line wits daynum if case == "Iraq", lwidth(medthick) lcolor(black) lpattern(solid)) ///
(line gtd daynum if case == "Iraq", lwidth(medthick) lcolor(gray) lpattern(solid)) ///
(line ibc daynum if case == "Iraq", xaxis(2) lwidth(medthick) lcolor(black) lpattern(dash)), ///
title("IRAQ", position(11) size(vlarge)) ///
legend(label(1 "WITS") label(2 "GTD") label(3 "IBC") ring(0) position(10) rows(3)) /// changes legend series labels, places them in the drawing region, and forces them to one column
xtick(51 406 761 1115 1469 1823 2178 2532 2887 3241 3596 3950, axis(1) tl(*2)) ///
xline(51 406 761 1115 1469 1823 2178 2532 2887 3241 3596 3950, axis(1) lcolor(gs10)) ///
xtick(0 366 731 1096 1461 1827 2192 2557  2922 3288  3653 4018, axis(2) tl(*2)) ///
xlabel(228 "1425" 583 "1426" 938 "1427" 1292 "1428" 1646 "1429" 2000 "1430" 2355 "1431" 2709 " 1431" 3064 "1432" 3418 "1433" 3773 "1434", axis(1) labsize(large) notick) ///
xlabel(183 "2004" 549 "2005" 914 "2006"	1279 "2007"	1644 "2008"	2010 "2009"	2375 "2010"	2740 "2011"	3105 "2012"	3471 "2013"	3836 "2014", axis(2) labsize(large) notick) ///
ylabel(, labsize(medlarge)) ///
xtitle("Hijri Calendar", axis(1) size(large) margin(top)) ///
xtitle("Gregorian Calendar", axis(2) size(large) margin(bottom)) ///
ytitle("Violent Events", size(large)) ///
ysize(2.25) xsize(6.5)
graph export "RRP-Fig2-IRQ-Grayscale.eps", replace

*Pakistan Grayscale
twoway (line wits daynum if case == "Pakistan", lwidth(medthick) lcolor(black) lpattern(solid)) ///
(line gtd daynum if case == "Pakistan", lwidth(medthick) lcolor(gray) lpattern(solid)) ///
(line pips daynum if case == "Pakistan", xaxis(2) lwidth(medthick) lcolor(black) lpattern(dash)), ///
title("PAKISTAN", position(11) size(vlarge)) ///
legend(label(1 "WITS") label(2 "GTD") label(3 "PIPS") ring(0) position(10) rows(3)) /// changes legend series labels, places them in the drawing region, and forces them to one column
xtick(51 406 761 1115 1469 1823 2178 2532 2887 3241 3596 3950, axis(1) tl(*2)) ///
xline(51 406 761 1115 1469 1823 2178 2532 2887 3241 3596 3950, axis(1) lcolor(gs10)) ///
xtick(0 366 731 1096 1461 1827 2192 2557  2922 3288  3653 4018, axis(2) tl(*2)) ///
xlabel(228 "1425" 583 "1426" 938 "1427" 1292 "1428" 1646 "1429" 2000 "1430" 2355 "1431" 2709 " 1431" 3064 "1432" 3418 "1433" 3773 "1434", axis(1) labsize(large) notick) ///
xlabel(183 "2004" 549 "2005" 914 "2006"	1279 "2007"	1644 "2008"	2010 "2009"	2375 "2010"	2740 "2011"	3105 "2012"	3471 "2013"	3836 "2014", axis(2) labsize(large) notick) ///
ylabel(, labsize(large)) ///
xtitle("Hijri Calendar", axis(1) size(large) margin(top)) ///
xtitle("Gregorian Calendar", axis(2) size(large) margin(bottom)) ///
ytitle("Violent Events", size(large)) ///
ysize(2.25) xsize(6.5)
graph export "RRP-Fig2-PAK-Grayscale.eps", replace



****************************************************************************************
* Table 2
****************************************************************************************


***Afghanistan (Columns 1-3)

use RRP-APSR-RepData-2017-04-04-AFG.dta, clear


**WITS (Column 1)

*N, Average, St. Dev.
sum ctwits if gyear>=2004 & gyear<=2011, detail
local ntmp=r(N)

*Total Events
display r(sum)

*Zero-Days (and Percentage)
quietly sum ctwits if ctwits==0 & gyear>=2004 & gyear<=2011, detail
display r(N)
display r(N)/`ntmp'


**GTD (Column 2)

*N, Average, St. Dev.
sum ctgtd if gyear>=2004 & gyear<=2014, detail
local ntmp=r(N)

*Total Events
display r(sum)

*Zero-Days (and Percentage)
quietly sum ctgtd if ctgtd==0 & gyear>=2004 & gyear<=2014, detail
display r(N)
display r(N)/`ntmp'


**SIGACTs (Column 3)

*N, Average, St. Dev.
sum ctsigact if gyear>=2008 & gyear<=2014, detail
local ntmp=r(N)

*Total Events
display r(sum)

*Zero-Days (and Percentage)
quietly sum ctsigact if ctsigact==0 & gyear>=2008 & gyear<=2014, detail
display r(N)
display r(N)/`ntmp'


***Iraq (Columns 4-6)

use RRP-APSR-RepData-2017-04-04-IRQ.dta, clear


**WITS (Column 4)

*N, Average, St. Dev.
sum ctwits if gyear>=2004 & gyear<=2011, detail
local ntmp=r(N)

*Total Events
display r(sum)

*Zero-Days (and Percentage)
quietly sum ctwits if ctwits==0 & gyear>=2004 & gyear<=2011, detail
display r(N)
display r(N)/`ntmp'


**GTD (Column 5)

*N, Average, St. Dev.
sum ctgtd if gyear>=2004 & gyear<=2014, detail
local ntmp=r(N)

*Total Events
display r(sum)

*Zero-Days (and Percentage)
quietly sum ctgtd if ctgtd==0 & gyear>=2004 & gyear<=2014, detail
display r(N)
display r(N)/`ntmp'


**IBC (Column 6)

*N, Average, St. Dev.
sum ctibc if (gyear>=2004 & gyear<=2008) | (gyear==2009 & gnummnth<=6), detail
local ntmp=r(N)

*Total Events
display r(sum)

*Zero-Days (and Percentage)
quietly sum ctibc if ctibc==0 & ((gyear>=2004 & gyear<=2008) | (gyear==2009 & gnummnth<=6)), detail
display r(N)
display r(N)/`ntmp'


***Pakistan (Columns 7-9)

use RRP-APSR-RepData-2017-04-04-PAK.dta, clear


**WITS (Column 7)

*N, Average, St. Dev.
sum ctwits if gyear>=2004 & gyear<=2011, detail
local ntmp=r(N)

*Total Events
display r(sum)

*Zero-Days (and Percentage)
quietly sum ctwits if ctwits==0 & gyear>=2004 & gyear<=2011, detail
display r(N)
display r(N)/`ntmp'


**GTD (Column 8)

*N, Average, St. Dev.
sum ctgtd if gyear>=2004 & gyear<=2014, detail
local ntmp=r(N)

*Total Events
display r(sum)

*Zero-Days (and Percentage)
quietly sum ctgtd if ctgtd==0 & gyear>=2004 & gyear<=2014, detail
display r(N)
display r(N)/`ntmp'


**PIPS (Column 9)

*N, Average, St. Dev.
sum ctpips if gyear>=2004 & gyear<=2014, detail
local ntmp=r(N)

*Total Events
display r(sum)

*Zero-Days (and Percentage)
quietly sum ctpips if ctpips==0 & gyear>=2004 & gyear<=2014, detail
display r(N)
display r(N)/`ntmp'



****************************************************************************************
* Table 5
****************************************************************************************


**Afghanistan Models

use RRP-APSR-RepData-2017-04-04-AFG.dta, clear

*Model 1
nbreg ctwits drelph drelnph dsecph afgelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg drcid2-drcid5 d2005-d2011 dayid ctwitslg if gyear>=2004 & gyear<=2011, robust nolog

*Model 2
nbreg ctgtd drelph drelnph dsecph afgelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg drcid2-drcid5 d2005-d2014 dayid ctgtdlg if gyear>=2004 & gyear<=2014, robust nolog

*Model 3
nbreg ctsigact drelph drelnph dsecph afgelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg drcid2-drcid5 d2009-d2014 dayid ctsigactlg if gyear>=2008 & gyear<=2014, robust nolog


**Iraq Models

use RRP-APSR-RepData-2017-04-04-IRQ.dta, clear

*Model 4
nbreg ctwits drelph drelnph dsecph irqelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dprovid2-dprovid18 d2005-d2011 dayid ctwitslg if gyear>=2004 & gyear<=2011, robust nolog

*Model 5
nbreg ctgtd drelph drelnph dsecph irqelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dprovid2-dprovid18 d2005-d2014 dayid ctgtdlg if gyear>=2004 & gyear<=2014, robust nolog

*Model 6
nbreg ctibc drelph drelnph dsecph irqelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dprovid2-dprovid18 d2005-d2009 dayid ctibclg if (gyear>=2004 & gyear<=2008) | (gyear==2009 & gnummnth<=6), robust nolog


**Pakistan Models

use RRP-APSR-RepData-2017-04-04-PAK.dta, clear

*Model 7
nbreg ctwits drelph drelnph dsecph pakelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dproid2-dproid8 d2005-d2011 dayid ctwitslg if gyear>=2004 & gyear<=2011, robust nolog

*Model 8
nbreg ctgtd drelph drelnph dsecph pakelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dproid2-dproid8 d2005-d2014 dayid ctgtdlg if gyear>=2004 & gyear<=2014, robust nolog

*Model 9
nbreg ctpips drelph drelnph dsecph pakelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dproid2-dproid8 d2005-d2014 dayid ctpipslg if gyear>=2004 & gyear<=2014, robust nolog



****************************************************************************************
* Table 6
****************************************************************************************


***Afghanistan Models

use RRP-APSR-RepData-2017-04-04-AFG.dta, clear


**Model 1

clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctwits drelph drelnph dsecph afgelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg drcid2-drcid5 d2005-d2011 dayid ctwitslg if gyear>=2004 & gyear<=2011, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx drelph 0 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx drelph 1 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Both Religious Day and Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx mean
setx afgelect30 0 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
local pbase=r(mean)
quietly drop expval
setx afgelect30 1 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Afghan Election within 30 Days"
display (r(mean)-`pbase')/`pbase'
*
quietly drop expval
setx mean
quietly simqi, genev(expval)
quietly sum expval, detail
local cbase=r(mean)
quietly drop expval
quietly summarize temp if gyear>=2004 & gyear<=2011, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx temp `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Temp +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize wesd if gyear>=2004 & gyear<=2011, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx wesd `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Snow Cover +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize precip if gyear>=2004 & gyear<=2011, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx precip `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Precipitation +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
quietly drop dropb-drope

**Model 2

clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctgtd drelph drelnph dsecph afgelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg drcid2-drcid5 d2005-d2014 dayid ctgtdlg if gyear>=2004 & gyear<=2014, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx drelph 0 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx drelph 1 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Both Religious Day and Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx drelph 0 drelnph 1 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Both Religious Day and Not Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx mean
setx afgelect30 0 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
local pbase=r(mean)
quietly drop expval
setx afgelect30 1 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Afghan Election within 30 Days"
display (r(mean)-`pbase')/`pbase'
*
quietly drop expval
setx mean
quietly simqi, genev(expval)
quietly sum expval, detail
local cbase=r(mean)
quietly drop expval
quietly summarize grainindex if gyear>=2004 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx grainindex `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Daily Grain Price Index +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize temp if gyear>=2004 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx temp `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Temp +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize wesd if gyear>=2004 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx wesd `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Snow Cover +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize precip if gyear>=2004 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx precip `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Precipitation +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
quietly drop dropb-drope

**Model 3
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctsigact drelph drelnph dsecph afgelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg drcid2-drcid5 d2009-d2014 dayid ctsigactlg if gyear>=2008 & gyear<=2014, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx drelph 0 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx drelph 1 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Both Religious Day and Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx mean
setx afgelect30 0 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
local pbase=r(mean)
quietly drop expval
setx afgelect30 1 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Afghan Election within 30 Days"
display (r(mean)-`pbase')/`pbase'
*
quietly drop expval
setx mean
quietly simqi, genev(expval)
quietly sum expval, detail
local cbase=r(mean)
quietly drop expval
quietly summarize oilprice if gyear>=2008 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx oilprice `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Oil Price +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize grainindex if gyear>=2008 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx grainindex `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Daily Grain Price Index +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize wesd if gyear>=2008 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx wesd `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Snow Cover +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize precip if gyear>=2008 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx precip `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Precipitation +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize tcloudc if gyear>=2008 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx tcloudc `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Cloud Cover +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
quietly drop dropb-drope


***Iraq Models

use RRP-APSR-RepData-2017-04-04-IRQ.dta, clear

**Model 4
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctwits drelph drelnph dsecph irqelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dprovid2-dprovid18 d2005-d2011 dayid ctwitslg if gyear>=2004 & gyear<=2011, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx drelph 0 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx drelph 1 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Both Religious Day and Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx drelph 0 drelnph 0 dsecph 1
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Secular Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx mean
setx irqelect30 0 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
local pbase=r(mean)
quietly drop expval
setx irqelect30 1 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Iraqi Election within 30 Days"
display (r(mean)-`pbase')/`pbase'
*
quietly drop expval
setx irqelect30 0 uselect30 1
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "US Election within 30 Days"
display (r(mean)-`pbase')/`pbase'
*
quietly drop expval
setx mean
quietly simqi, genev(expval)
quietly sum expval, detail
local cbase=r(mean)
quietly drop expval
quietly summarize oilprice if gyear>=2004 & gyear<=2011, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx oilprice `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Oil Price +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize grainindex if gyear>=2004 & gyear<=2011, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx grainindex `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Daily Grain Price Index +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize temp if gyear>=2004 & gyear<=2011, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx temp `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Temp +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize ctcoinactlg if gyear>=2004 & gyear<=2011, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx ctcoinactlg `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "COIN Activity +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
quietly drop dropb-drope

**Model 5
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctgtd drelph drelnph dsecph irqelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dprovid2-dprovid18 d2005-d2014 dayid ctgtdlg if gyear>=2004 & gyear<=2014, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx drelph 0 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx drelph 1 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Both Religious Day and Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx drelph 0 drelnph 1 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Both Religious Day and Not Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx mean
quietly simqi, genev(expval)
quietly sum expval, detail
local cbase=r(mean)
quietly drop expval
quietly summarize oilprice if gyear>=2004 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx oilprice `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Oil Price +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize grainindex if gyear>=2004 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx grainindex `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Daily Grain Price Index +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize temp if gyear>=2004 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx temp `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Temp +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
quietly drop dropb-drope

**Model 6
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctibc drelph drelnph dsecph irqelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dprovid2-dprovid18 d2005-d2009 dayid ctibclg if (gyear>=2004 & gyear<=2008) | (gyear==2009 & gnummnth<=6), robust nolog
quietly generate dropb=.
order dropb
setx mean
setx drelph 0 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx drelph 1 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Both Religious Day and Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx drelph 0 drelnph 0 dsecph 1
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Secular Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx mean
setx irqelect30 0 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
local pbase=r(mean)
quietly drop expval
setx irqelect30 0 uselect30 1
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "US Election within 30 Days"
display (r(mean)-`pbase')/`pbase'
*
quietly drop expval
setx mean
quietly simqi, genev(expval)
quietly sum expval, detail
local cbase=r(mean)
quietly drop expval
quietly summarize precip if (gyear>=2004 & gyear<=2008) | (gyear==2009 & gnummnth<=6), detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx precip `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Precipitation +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize tcloudc if (gyear>=2004 & gyear<=2008) | (gyear==2009 & gnummnth<=6), detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx tcloudc `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Cloud Cover +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval

quietly drop dropb-drope


***Pakistan Models

use RRP-APSR-RepData-2017-04-04-PAK.dta, clear

**Model 7
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctwits drelph drelnph dsecph pakelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dproid2-dproid8 d2005-d2011 dayid ctwitslg if gyear>=2004 & gyear<=2011, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx drelph 0 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx drelph 1 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Both Religious Day and Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx mean
setx pakelect30 0 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
local pbase=r(mean)
quietly drop expval
setx pakelect30 0 uselect30 1
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "US Election within 30 Days"
display (r(mean)-`pbase')/`pbase'
*
quietly drop expval
setx mean
quietly simqi, genev(expval)
quietly sum expval, detail
local cbase=r(mean)
quietly drop expval
quietly summarize oilprice if gyear>=2004 & gyear<=2011, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx oilprice `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Oil Price +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize grainindex if gyear>=2004 & gyear<=2011, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx grainindex `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Daily Grain Price Index +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize ctcoinactlg if gyear>=2004 & gyear<=2011, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx ctcoinactlg `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "COIN Activity +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
quietly drop dropb-drope

**Model 8
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctgtd drelph drelnph dsecph pakelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dproid2-dproid8 d2005-d2014 dayid ctgtdlg if gyear>=2004 & gyear<=2014, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx drelph 0 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx drelph 1 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Both Religious Day and Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx mean
setx pakelect30 0 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
local pbase=r(mean)
quietly drop expval
setx pakelect30 1 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Pakistani Election within 30 Days"
display (r(mean)-`pbase')/`pbase'
*
quietly drop expval
setx mean
quietly simqi, genev(expval)
quietly sum expval, detail
local cbase=r(mean)
quietly drop expval
quietly summarize oilprice if gyear>=2004 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx oilprice `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Oil Price +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize precip if gyear>=2004 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx precip `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Precipitation +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize ctcoinactlg if gyear>=2004 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx ctcoinactlg `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "COIN Activity +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
quietly drop dropb-drope

**Model 9
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctpips drelph drelnph dsecph pakelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dproid2-dproid8 d2005-d2014 dayid ctpipslg if gyear>=2004 & gyear<=2014, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx drelph 0 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx drelph 1 drelnph 0 dsecph 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Both Religious Day and Public Holiday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx mean
setx pakelect30 0 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
local pbase=r(mean)
quietly drop expval
setx pakelect30 1 uselect30 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Pakistani Election within 30 Days"
display (r(mean)-`pbase')/`pbase'
*
quietly drop expval
setx mean
quietly simqi, genev(expval)
quietly sum expval, detail
local cbase=r(mean)
quietly drop expval
quietly summarize tcloudc if gyear>=2004 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx tcloudc `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "Mean Cloud Cover +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
setx mean
quietly summarize ctcoinactlg if gyear>=2004 & gyear<=2014, detail
local ivmean=r(mean)
local ivstdev=r(sd)
local mp1sd=`ivmean'+`ivstdev'
setx ctcoinactlg `mp1sd'
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "Daily Mean" Baseline to "COIN Activity +1 SD"
display (r(mean)-`cbase')/`cbase'
*
quietly drop expval
quietly drop dropb-drope


****************************************************************************************
* Table 7
****************************************************************************************


***Afghanistan Models

use RRP-APSR-RepData-2017-04-04-AFG.dta, clear

**Model 1
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctwits ddowk6 dhm01 dhm07 dhm09 dhm11 dhm12 dahny1 ddoas1 dmanu1 dmanh1 disam1 dlyab1 dfdor1 dlaqh1 dlaqu1 deidf3 ddoar1 deida4 dlibd1 danyd1 dvicd1 dlabd1 dindd1 afgelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg drcid2-drcid5 d2005-d2011 dayid ctwitslg if gyear>=2004 & gyear<=2011, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx ddowk6 1 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Friday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 1 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Muharram"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 1 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Laylat al-Bara'at"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 1 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 1 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Laylat al-Qadar (Sunni)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 1 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Fitr (3 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
quietly drop dropb-drope


**Model 2
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctgtd ddowk6 dhm01 dhm07 dhm09 dhm11 dhm12 dahny1 ddoas1 dmanu1 dmanh1 disam1 dlyab1 dfdor1 dlaqh1 dlaqu1 deidf3 ddoar1 deida4 dlibd1 danyd1 dvicd1 dlabd1 dindd1 afgelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg drcid2-drcid5 d2005-d2014 dayid ctgtdlg if gyear>=2004 & gyear<=2014, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx ddowk6 1 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Friday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 1 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Muharram"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 1 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Ramadan"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 1 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Dhu al-Qada"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 1 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Laylat al-Bara'at"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 1 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 1 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "First Day of Ramadan"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 1 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Fitr (3 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 1 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 1 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Day of Arafah"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
quietly drop dropb-drope


**Model 3
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctsigact ddowk6 dhm01 dhm07 dhm09 dhm11 dhm12 dahny1 ddoas1 dmanu1 dmanh1 disam1 dlyab1 dfdor1 dlaqh1 dlaqu1 deidf3 ddoar1 deida4 dlibd1 danyd1 dvicd1 dlabd1 dindd1 afgelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg drcid2-drcid5 d2009-d2014 dayid ctsigactlg if gyear>=2008 & gyear<=2014, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx ddowk6 1 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Friday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 1 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Muharram"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 1 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Rajab"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 1 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Dhu al-Hijja"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 1 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 1 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "First Day of Ramadan"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 1 ddoar1 0 deida4 0 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Fitr (3 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 1 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 1 dlibd1 0 danyd1 0 dvicd1 0 dlabd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Ahda (4 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
quietly drop dropb-drope


***Iraq Models

use RRP-APSR-RepData-2017-04-04-IRQ.dta, clear

**Model 4
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctwits ddowk6 dhm01 dhm07 dhm09 dhm11 dhm12 dahny1 ddoas1 dmanu1 dmanh1 disam1 dlyab1 dfdor1 dlaqh1 dlaqu1 deidf3 ddoar1 deida4 ddowk5 dnyrd1 darmd1 dlabd1 drepd1 dindd1 irqelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dprovid2-dprovid18 d2005-d2011 dayid ctwitslg if gyear>=2004 & gyear<=2011, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx ddowk6 1 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Friday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 1 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Muharram"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 1 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Dhu al-Qada"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 1 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Dhu al-Hijja"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 1 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 1 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "First Day of Ramadan"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 1 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Fitr (3 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 1 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 1 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Ahda (4 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 1 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Thursday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
quietly drop dropb-drope


**Model 5
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctgtd ddowk6 dhm01 dhm07 dhm09 dhm11 dhm12 dahny1 ddoas1 dmanu1 dmanh1 disam1 dlyab1 dfdor1 dlaqh1 dlaqu1 deidf3 ddoar1 deida4 ddowk5 dnyrd1 darmd1 dlabd1 drepd1 dindd1 irqelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dprovid2-dprovid18 d2005-d2014 dayid ctgtdlg if gyear>=2004 & gyear<=2014, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx ddowk6 1 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Friday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 1 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Muharram"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 1 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Ramadan"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 1 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Fitr (3 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 1 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 1 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Ahda (4 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
quietly drop dropb-drope


**Model 6
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctibc ddowk6 dhm01 dhm07 dhm09 dhm11 dhm12 dahny1 ddoas1 dmanu1 dmanh1 disam1 dlyab1 dfdor1 dlaqh1 dlaqu1 deidf3 ddoar1 deida4 ddowk5 dnyrd1 darmd1 dlabd1 drepd1 dindd1 irqelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dprovid2-dprovid18 d2005-d2009 dayid ctibclg if (gyear>=2004 & gyear<=2008) | (gyear==2009 & gnummnth<=6), robust nolog
quietly generate dropb=.
order dropb
setx mean
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx ddowk6 1 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Friday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 1 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Muharram"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 1 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Rajab"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 1 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Dhu al-Hijja"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 1 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 1 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Isra and Mi'raj"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 1 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Fitr (3 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 1 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 1 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Ahda (4 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 1 dnyrd1 0 darmd1 0 dlabd1 0 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Thursday"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk5 0 dnyrd1 0 darmd1 0 dlabd1 1 drepd1 0 dindd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Labor Day"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
quietly drop dropb-drope


***Pakistan Models

use RRP-APSR-RepData-2017-04-04-PAK.dta, clear

**Model 7
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctwits ddowk6 dhm01 dhm07 dhm09 dhm11 dhm12 dahny1 ddoas1 dmanu1 dmanh1 disam1 dlyab1 dfdor1 dlaqh1 dlaqu1 deidf3 ddoar1 deida4 ddowk1 dkhsd1 dpakd1 dlabd1 dindd1 daidd1 dqabd1 pakelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dproid2-dproid8 d2005-d2011 dayid ctwitslg if gyear>=2004 & gyear<=2011, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 1 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Fitr (3 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 1 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Independence Day"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 1 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Allama Iqbal Day"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
quietly drop dropb-drope


**Model 8
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctgtd ddowk6 dhm01 dhm07 dhm09 dhm11 dhm12 dahny1 ddoas1 dmanu1 dmanh1 disam1 dlyab1 dfdor1 dlaqh1 dlaqu1 deidf3 ddoar1 deida4 ddowk1 dkhsd1 dpakd1 dlabd1 dindd1 daidd1 dqabd1 pakelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dproid2-dproid8 d2005-d2014 dayid ctgtdlg if gyear>=2004 & gyear<=2014, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 1 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Dhu al-Qada"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 1 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Mawlid an Nabi (Sunni)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 1 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 1 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Laylat al-Qadar (Sunni)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 1 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Fitr (3 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 1 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 1 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Day of Arafah"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 1 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 1 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Ahda (4 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
quietly drop dropb-drope


**Model 9
clear matrix
set seed 323
quietly generate drope=.
order drope
estsimp nbreg ctpips ddowk6 dhm01 dhm07 dhm09 dhm11 dhm12 dahny1 ddoas1 dmanu1 dmanh1 disam1 dlyab1 dfdor1 dlaqh1 dlaqu1 deidf3 ddoar1 deida4 ddowk1 dkhsd1 dpakd1 dlabd1 dindd1 daidd1 dqabd1 pakelect30 uselect30 oilprice grainindex temp wesd precip tcloudc ctcoinactlg dproid2-dproid8 d2005-d2014 dayid ctpipslg if gyear>=2004 & gyear<=2014, robust nolog
quietly generate dropb=.
order dropb
setx mean
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
local hbase=r(mean)
quietly drop expval
setx ddowk6 0 dhm01 1 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Muharram"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 1 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Dhu al-Hijja"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 1 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 1 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Day of Ashura"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 1 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Mawlid an Nabi (Sunni)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 1 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 1 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "First Day of Ramadan"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 0 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 1 ddoar1 0 deida4 0 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Fitr (3 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
setx ddowk6 0 dhm01 0 dhm07 0 dhm09 0 dhm11 0 dhm12 1 dahny1 0 ddoas1 0 dmanu1 0 dmanh1 0 disam1 0 dlyab1 0 dfdor1 0 dlaqh1 0 dlaqu1 0 deidf3 0 ddoar1 0 deida4 1 ddowk1 0 dkhsd1 0 dpakd1 0 dlabd1 0 dindd1 0 daidd1 0 dqabd1 0
quietly simqi, genev(expval)
quietly sum expval, detail
*% Shift from "All Other Days" Baseline to "Eid al-Ahda (3 Day)"
display (r(mean)-`hbase')/`hbase'
*
quietly drop expval
quietly drop dropb-drope

clear matrix
log close
