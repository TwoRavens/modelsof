*Need to install DETREND.ado
version 11.2
clear matrix
clear
set mem 1500m
cd /Users/gehlbach/Dropbox/Projects/Ukraine/Data/Replication
set matsize 1500


/* ENTERPRISE DATA */

use ukr_manuf_final, clear
gen emp = exp(lnemp)
gen rsales = exp(lnrsales)
drop region
rename modreg region
gen lso = 1
replace lso = 0 if ldo == 1 | lfo == 1
sort id year
save work, replace

use oligarch_align, clear
sort id year
merge id year using work
drop if _m == 1
drop _m
*1656 firms match, of which 239 oligarch-owned -- after collapsing by id:

*     (mean) |
*  alignment |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          1 |        158        2.06        2.06
*          2 |         31        0.40        2.46
*      2.375 |          1        0.01        2.47
*          3 |         49        0.64        3.11
*          4 |      7,445       96.89      100.00
*------------+-----------------------------------
*      Total |      7,684      100.00

*one firm with changing alignment is id == 445771, code as value from 2003, as only have cross-sectional data in general
replace alignment = 1 if id == 445771

gen oligarch = 1 if alignment < 4
replace oligarch = 0 if alignment == 4
sort id year
save work, replace


/* REGIONAL DATA */

use Ukraine_regions, clear
sort region
save temp, replace
*sumstats
sum YuDec rus2001
*illustrate instruments
scatter YuDec ruslang2001, xtitle(Proportion Russian speakers) ytitle(Proportion vote for Yushchenko) scheme(s2mono)
scatter YuDec rus2001, xtitle(Proportion ethnic Russian) ytitle(Proportion vote for Yushchenko) scheme(s2mono)
*
use work
sort region year
merge region using temp
drop _m


/* SUMSTATS */

sum rsales emp avrcap ldo lfo if year == 92
sum rsales emp avrcap ldo lfo if year == 97
sum rsales emp avrcap ldo lfo if year == 102
sum rsales emp avrcap ldo lfo if year == 107


/* VARIABLE CONSTRUCTION */ 

*Create industry dummies
tab modeind2, gen(ind) 

*Region dummies
local j=1
foreach i of numlist 1 5 7 12 14 18 21 23 26 32 35 44 46 48 51 53 56 59 61 63 65 68 71 73 74 80 85 {
local j=`i'+1300
gen reg`i' = 1 if region==`j'
replace reg`i' = 0 if region!=`j'
}

*Year dummies
tab year, gen(y)
rename y1 y89
label variable y89 ""
local j=1
forval i=2/17 {
local j=`i'+90
rename y`i' y`j'
label variable y`j' `""'
}

*Production functions
forval i=1/22 {
gen emp`i'=lnemp*ind`i'
}
forval i=1/22 {
gen cap`i'=lnavrcap*ind`i'
}

*ldo*year interactions
 *essentially no privatizations until 1994
foreach i of numlist 94/107 {
gen ldo_y`i' = ldo*y`i'
}

*ldo*industry*year interactions
 *demean industry on annual basis to facilitate interpretation of regional effects
forv i = 1/22 {
gen y_ind`i'mean = .
foreach j of numlist 89 92/107 {
egen temp = mean(ind`i') if year == `j'
replace y_ind`i'mean = temp if year == `j'
drop temp
}
}
forv i = 1/22 {
gen y_dmind`i' = ind`i'-y_ind`i'mean
}
 *interactions
foreach i of numlist 1/22 {
foreach j of numlist 94/107 {
gen ldo_ind`i'_y`j' = ldo_y`j'*y_dmind`i'
}
}

*treatment variables
replace year = year + 1900
gen or = 0
replace or = 1 if year > 2004
gen or_Yu = or*YuDec
gen or_west_border = or*west_border
gen or_east_border = or*east_border
gen or_macrowest = or*macrowest
gen or_macrocenter = or*macrocenter
gen or_macroeast = or*macroeast
gen or_macrosouth = or*macrosouth

gen preyear97 = 0
replace preyear97 = year - 1996 if year > 1996
gen preyear97_Yu = preyear97*YuDec
*
gen preyear98 = 0
replace preyear98 = year - 1997 if year > 1997
gen preyear98_Yu = preyear98*YuDec
*
gen preyear99 = 0
replace preyear99 = year - 1998 if year > 1998
gen preyear99_Yu = preyear99*YuDec
*
gen treatment = 0
replace treatment = 1 if year > 2004
gen treatment_Yu = treatment*YuDec
*
gen postyear = 0
replace postyear = year - 2005 if year > 2005
gen postyear_Yu = postyear*YuDec

*instruments
gen or_Rus2001 = or*rus2001
gen or_Ruslang2001 = or*ruslang2001

save work, replace
 
 
/* DETRENDING */

 *So long as properly handle missing values, equivalent to a) first detrend trending variables and then interact 
 *with non-trending variables (e,g., region, industry when not demeaned), and b) first interact trending variables with  
 *non-trending variables and then detrend interactions.  Computationally easier to do (a) (as we did in APSR paper). In practice, some mix of each here.

tsset id year
DETREND lnrsales lnavrcap lnemp ldo* lfo emp1-emp22 cap1-cap22 y89-y107 *_Yu or_Rus* or_west_border-or_macrosouth, by(id) time(year)
rename _DTlnrsales dtlnrsales
rename _DTlnavrcap dtlnavrcap
rename _DTlnemp dtlnemp
rename _DTldo dtldo
forv i = 94/107 {
rename _DTldo_y`i' dtldo_y`i'
}
rename _DTlfo dtlfo
forv i = 1/22 {
rename _DTemp`i' dtemp`i'
}
forv i = 1/22 {
rename _DTcap`i' dtcap`i'
}
foreach i of numlist 89 92/107 {
rename _DTy`i' dty`i'
}
foreach i of numlist 1/22 {
foreach j of numlist 94/107 {
rename _DTldo_ind`i'_y`j' dtldo_ind`i'_y`j' 
}
}
rename _DTor_Yu dtor_Yu
rename _DTpreyear97_Yu dtpreyear97_Yu
rename _DTpreyear98_Yu dtpreyear98_Yu
rename _DTpreyear99_Yu dtpreyear99_Yu
rename _DTtreatment_Yu dttreatment_Yu
rename _DTpostyear_Yu dtpostyear_Yu
rename _DTor_Rus2001 dtor_Rus2001
rename _DTor_Ruslang2001 dtor_Ruslang2001
rename _DTor_west_border dtor_west_border
rename _DTor_east_border dtor_east_borderrename _DTor_macrowest dtor_macrowest
rename _DTor_macrocenter dtor_macrocenter
rename _DTor_macroeast dtor_macroeast
rename _DTor_macrosouth dtor_macrosouth
save work, replace


/* INTERACTIONS AFTER DETRENDING */

*ldo*region*year
foreach i of numlist 1 5 7 12 14 18 21 23 26 32 35 44 46 48 51 53 56 59 61 63 65 68 71 73 74 80 85 {
foreach j of numlist 94/107 {
gen ldo_reg`i'_y`j' = ldo_y`j'*reg`i'
}
}

*lso*region*year
foreach i of numlist 1 5 7 12 14 18 21 23 26 32 35 44 46 48 51 53 56 59 61 63 65 68 71 73 74 80 85 {
foreach j of numlist 94/107 {
gen lso_reg`i'_y`j' = lso*y`j'*reg`i'
}
}

*lso*industry*year
foreach i of numlist 1/22 {
foreach j of numlist 94/107 {
gen lso_ind`i'_y`j' = lso*y`j'*y_dmind`i'
}
}

*industry*year
foreach i of numlist 89 92/107 {
forv j = 1/22 {
gen ind`j'_y`i' = ind`j'*y`i'
}
}

*dt_industry*year interactions
foreach i of numlist 89 92/107 {
forv j = 1/22 {
gen dtind`j'_y`i' = ind`j'*dty`i'
}
}

*dt_ldo*region interactions
foreach j of numlist 1 5 7 12 14 18 21 23 26 32 35 44 46 48 51 53 56 59 61 63 65 68 71 73 74 80 85 {
gen dtldo_reg`j' = dtldo*reg`j'
}

*dt_ldo*region*year interactions
foreach i of numlist 1 5 7 12 14 18 21 23 26 32 35 44 46 48 51 53 56 59 61 63 65 68 71 73 74 80 85 {
foreach j of numlist 94/107 {
gen dtldo_reg`i'_y`j' = dtldo_y`j'*reg`i'
}
}

*dt_ldo*industry interactions
 *demean industry to facilitate interpretation of regional effects
forv i = 1/22 {
egen ind`i'mean = mean(ind`i')
}
forv i = 1/22 {
gen dmind`i' = ind`i'-ind`i'mean
}
forv i = 1/22 {
gen dtldo_dmind`i' = dtldo*dmind`i'
}

save interwork_did, replace 


/* ESTIMATION */

*TABLE 3:  DiD
 *FE 
xtreg lnrsales or_Yu emp1-emp22 cap1-cap22 ind*_y*, fe cluster(region)
outreg2 using table3, excel bdec(3) replace
 *FEFT (also for all subsequent regressions)
reg dtlnrsales dtor_Yu dtemp* dtcap* dtind*_y*, cluster(region)
outreg2 using table3, excel bdec(3)
 *Ownership controls
reg dtlnrsales dtor_Yu dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region)
outreg2 using table3, excel bdec(3)
 *Variation within macroregions
reg dtlnrsales dtor_Yu or_macrowest or_macrosouth or_macroeast dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region)
outreg2 using table3, excel bdec(3)
 *Border effect?
reg dtlnrsales dtor_Yu or_west_border or_east_border dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region)
outreg2 using table3, excel bdec(3)
 *dynamics
reg dtlnrsales dtpreyear98_Yu dttreatment_Yu dtpostyear_Yu dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region)
outreg2 using table3, excel bdec(3)
lincom dttreatment_Yu + 2*dtpostyear_Yu

*OTHER RESULTS RELATED TO TABLE 3
 *drop regions one by one (biggest effect is from dropping Lviv - drops to 0.152 (still significant at p = 0.05))
reg dtlnrsales dtor_Yu dtldo dtlfo dtemp* dtcap* dtind*_y* if region ~= 1301, cluster(region)
outreg2 using dropregion, excel bdec(3) replace
foreach i of numlist 5 7 12 14 18 21 23 26 32 35 44 46 48 51 53 56 59 61 63 65 68 71 73 74 80 85 {
reg dtlnrsales dtor_Yu dtldo dtlfo dtemp* dtcap* dtind*_y* if region ~= 1300 + `i', cluster(region)
outreg2 using dropregion, excel bdec(3)
}
 *dynamics - other base years
reg dtlnrsales dtpreyear97_Yu dttreatment_Yu dtpostyear_Yu dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region)
reg dtlnrsales dtpreyear99_Yu dttreatment_Yu dtpostyear_Yu dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region)
 *dynamics - fixed effects
xtreg lnrsales preyear98_Yu treatment_Yu postyear_Yu emp1-emp22 cap1-cap22 ind*_y*, fe cluster(region)
 *IV
reg dtor_Yu dtor_Rus2001 dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region) 
*F-stat: (1.859755/.2961182)^2 = 39.444
ivreg dtlnrsales (dtor_Yu = dtor_Rus2001) dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region)
ranktest (dtor_Yu) (dtor_Rus2001), partial(dtldo dtlfo dtemp* dtcap* dtind*_y*) cluster(region)
ivreg dtlnrsales (dtor_Yu = dtor_Ruslang2001) dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region) first
 *Other SEs
gen regionyear = region*year
reg dtlnrsales dtor_Yu dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(regionyear)
reg dtlnrsales dtor_Yu dtldo dtlfo dtemp* dtcap* dtind*_y*, robust
reg dtlnrsales dtor_Yu dtldo dtlfo dtemp* dtcap* dtind*_y*


/* GENERAL VS. PARTICULARISTIC POLICIES */

*MACRO-LEVEL EVIDENCE
use Ukraine_regions_panel, clear

gen or = 0
replace or = 1 if year > 2004
gen or_Yu = or*YuDec
gen or_Rus2001 = or*rus2001

foreach i of numlist 1 5 7 12 14 18 21 23 26 32 35 44 46 48 51 53 56 59 61 63 65 68 71 73 74 80 85 {
gen reg`i'trend = 0
replace reg`i'trend = year if region == 1300 + `i'
}
*
gen lnpopn = ln(popn)
gen lnfdi = ln(fdi)
gen lnsmallent = ln(smallent)
gen lnexports = ln(exports)
gen lnimports = ln(imports)
sum indprod ILO lnsmallent lnexports lnimports lnfdi
gen temp = indprod if year == 2004
egen indprod04 = max(temp), by(region)
gen or_indprod04 = or*indprod04
*
*Productivity trends reflected in region-level industrial production
xi: reg indprod or_Yu i.year i.region *trend, robust
outreg2 using tablemacro, excel bdec(3) replace
*Not about bounce-back from transition depression
xi: reg indprod or_Yu or_indprod04 i.year i.region *trend, robust
outreg2 using tablemacro, excel bdec(3)
*no increase in unemployment
xi: reg ILO or_Yu i.year i.region *trend, robust
outreg2 using tablemacro, excel bdec(3)
*no increase in SMEs (from labor shedding; from deregulation in poorer parts of country, a la Aslund)
xi: reg lnsmallent or_Yu lnpopn i.year i.region *trend, robust
outreg2 using tablemacro, excel bdec(3)
*Aslund suggests that trade with West could revitalize western Ukraine:
xi: reg lnexports or_Yu lnpopn i.year i.region *trend, robust
outreg2 using tablemacro, excel bdec(3)
xi: reg lnimports or_Yu lnpopn i.year i.region *trend, robust
outreg2 using tablemacro, excel bdec(3)
*FDI?
xi: reg lnfdi or_Yu lnpopn i.year i.region *trend, robust
outreg2 using tablemacro, excel bdec(3)

*OLS
use interwork_did, clear
 *OLS with industry-year FEs
reg lnrsales or_Yu YuDec emp1-emp22 cap1-cap22 ind*_y*, cluster(region)


/* HETEROGENEOUS EFFECTS */

*SIZE
egen temp = mean(emp) if year < 2004, by(id)
egen meanemp = max(temp), by(id)
gen large = 0
replace large = 1 if meanemp > 150
gen or_large = or*large
DETREND or_large, by(id) time(year)
rename _DTor_large dtor_large
gen dtor_Yu_large = dtor_Yu*large
reg dtlnrsales dtor_Yu dtor_large dtor_Yu_large dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region)
outreg2 using table5, excel bdec(3) replace

*OLIGARCH OWNERSHIP
gen or_olig = or*oligarch
DETREND or_olig, by(id) time(year)
rename _DTor_olig dtor_olig
gen dtor_Yu_olig = dtor_Yu*oligarch
reg dtlnrsales dtor_Yu dtor_olig dtor_Yu_olig dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region)
outreg2 using table5, excel bdec(3)
 *both size and oligarch ownership
reg dtlnrsales dtor_Yu dtor_large dtor_Yu_large dtor_olig dtor_Yu_olig dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region)

*GOVERNMENT SUPPLIER
*NACE codes here: http://www.fifoost.org/database/nace/nace-en_2002c.php
gen govt = 0
replace govt = 1 if modeind2 == 29 | modeind2 == 35
gen or_govt = or*govt
DETREND or_govt, by(id) time(year)
rename _DTor_govt dtor_govt
gen dtor_Yu_govt = dtor_Yu*govt
reg dtlnrsales dtor_Yu dtor_govt dtor_Yu_govt dtldo dtlfo dtemp* dtcap* dtind*_y*, cluster(region)
outreg2 using table5, excel bdec(3)

*PRIVATE OWNERSHIP

*See below.

 
/* DECOMPOSITION */

*GENERAL DECOMPOSITION
reg dtlnrsales dtor_Yu dtldo dtlfo dtind*_y*, cluster(region)
outreg2 using decomp, excel bdec(3) replace
reg dtlnemp dtor_Yu dtldo dtlfo dtind*_y*, cluster(region)
outreg2 using decomp, excel bdec(3)
reg dtlnavrcap dtor_Yu dtldo dtlfo dtind*_y*, cluster(region)
outreg2 using decomp, excel bdec(3)

*SIZE
reg dtlnrsales dtor_Yu dtor_large dtor_Yu_large dtldo dtlfo dtind*_y*, cluster(region)
outreg2 using decomp, excel bdec(3)
reg dtlnemp dtor_Yu dtor_large dtor_Yu_large dtldo dtlfo dtind*_y*, cluster(region)
outreg2 using decomp, excel bdec(3) 
reg dtlnavrcap dtor_Yu dtor_large dtor_Yu_large dtldo dtlfo dtind*_y*, cluster(region)
outreg2 using decomp, excel bdec(3) 

*OLIGARCH OWNERSHIP
reg dtlnrsales dtor_Yu dtor_olig dtor_Yu_olig dtldo dtlfo dtind*_y*, cluster(region)
outreg2 using decomp, excel bdec(3)
reg dtlnemp dtor_Yu dtor_olig dtor_Yu_olig dtldo dtlfo dtind*_y*, cluster(region)
outreg2 using decomp, excel bdec(3) 
reg dtlnavrcap dtor_Yu dtor_olig dtor_Yu_olig dtldo dtlfo dtind*_y*, cluster(region)
outreg2 using decomp, excel bdec(3) 

*GOVERNMENT SUPPLIER
reg dtlnrsales dtor_Yu dtor_govt dtor_Yu_govt dtldo dtlfo dtind*_y*, cluster(region)
outreg2 using decomp, excel bdec(3)
reg dtlnemp dtor_Yu dtor_govt dtor_Yu_govt dtldo dtlfo dtind*_y*, cluster(region)
outreg2 using decomp, excel bdec(3) 
reg dtlnavrcap dtor_Yu dtor_govt dtor_Yu_govt dtldo dtlfo dtind*_y*, cluster(region)
outreg2 using decomp, excel bdec(3) 


/* PRIVATE OWNERSHIP -- FIRST STAGE */

*Figure: Aggregate dynamics by Yushchenko support, controlling for time-varying sector privatization effects */
*Yu = 1 if among 14 top regions for Yushchenko, Yan if among the remaining 13
use interwork_did, clear
gen Yu = 0
replace Yu = 1 if region == 1361 | region == 1326 | region == 1346 | region == 1307 | region == 1356 | region == 1305 | region == 1332 | region == 1368 | region == 1373 | region == 1359 | region == 1371 | region == 1380 | region == 1374 | region == 1321
gen Yan = 1 - Yu
foreach i of numlist 94/107 {
gen dtldo_y`i'_Yu = dtldo_y`i'*Yu
}
foreach i of numlist 94/107 {
gen dtldo_y`i'_Yan = dtldo_y`i'*Yan
}
*
reg dtlnrsales dtldo_y94_Yu-dtldo_y107_Yu dtldo_y94_Yan-dtldo_y107_Yan dtldo_ind1_y94-dtldo_ind21_y107 dtlfo dtemp* dtcap* dtind*_y* , cluster(id) noc
*difference in 2007, reported in text
lincom dtldo_y107_Yu - dtldo_y107_Yan
matrix b = e(b)'
matrix dynamics = b[1..28,1]
svmat dynamics
keep in 1/28
keep dynamics
matrix year = [1994\1995\1996\1997\1998\1999\2000\2001\2002\2003\2004\2005\2006\2007\1994\1995\1996\1997\1998\1999\2000\2001\2002\2003\2004\2005\2006\2007]
svmat year
rename dynamics1 dynamics
rename year1 year
twoway scatter dynamics year in 1/14, connect(l) mcolor(navy) lc(navy) || scatter dynamics year in 15/28, connect(l) title("") xlabel(1994(1)2007) xtitle("") ytitle(Estimated average effect of private ownership) ylabel(-.1(.1).53) legend(label(1 "Yushchenko regions") label(2 "Yanukovich regions")) mcolor(navy) lc(navy) lp(dash)
twoway scatter dynamics year in 1/14, connect(l) || scatter dynamics year in 15/28, connect(l) title("") xlabel(1994(1)2007) xtitle("") ytitle(Estimated average effect of private ownership) ylabel(-.1(.1).55) legend(label(1 "Yushchenko regions") label(2 "Yanukovich regions")) lp(dash) scheme(s2mono)

*Region-year private-ownership effects
use interwork_did, clear
reg dtlnrsales dtldo_reg*_y* dtldo_ind1_y94-dtldo_ind22_y107 dtlfo dtemp* dtcap* dtind*_y*, cluster(id) noc
matrix b = e(b)'
matrix privDT = b[1..378,1]
svmat privDT
rename privDT1 privDT
keep privDT
keep if privDT ~= .
replace privDT = . if privDT == 0
save privDT, replace
clear matrix

*Decomposition
use interwork_did, clear
reg dtlnrsales dtldo_reg*_y* dtldo_ind1_y94-dtldo_ind22_y107 dtlfo dtind*_y*, cluster(id) noc
matrix b = e(b)'
matrix privDT_sales = b[1..378,1]
svmat privDT_sales
rename privDT_sales1 privDT_sales
keep privDT_sales
keep if privDT_sales ~= .
replace privDT_sales = . if privDT_sales == 0
save privDT_sales, replace
clear matrix
*
use interwork_did, clear
reg dtlnemp dtldo_reg*_y* dtldo_ind1_y94-dtldo_ind22_y107 dtlfo dtind*_y*, cluster(id) noc
matrix b = e(b)'
matrix privDT_emp = b[1..378,1]
svmat privDT_emp
rename privDT_emp1 privDT_emp
keep privDT_emp
keep if privDT_emp ~= .
replace privDT_emp = . if privDT_emp == 0
save privDT_emp, replace
clear matrix
*
use interwork_did, clear
reg dtlnavrcap dtldo_reg*_y* dtldo_ind1_y94-dtldo_ind22_y107 dtlfo dtind*_y*, cluster(id) noc
matrix b = e(b)'
matrix privDT_cap = b[1..378,1]
svmat privDT_cap
rename privDT_cap1 privDT_cap
keep privDT_cap
keep if privDT_cap ~= .
replace privDT_cap = . if privDT_cap == 0
save privDT_cap, replace
clear matrix


/* PRIVATE OWNERSHIP -- SECOND STAGE */

use Ukraine_regions, clear
sort region
save temp, replace

*Merge first-stage estimates
keep region
expand 14
sort region
egen year = fill(1994(1)2007 1994(1)2007)
sort region year
merge using privDT
drop _m
sort region year
merge using privDT_sales
drop _m
sort region year
merge using privDT_emp
drop _m
sort region year
merge using privDT_cap
drop _m
sort region year
merge region using temp

*region-specific trends
foreach i of numlist 1 5 7 12 14 18 21 23 26 32 35 44 46 48 51 53 56 59 61 63 65 68 71 73 74 80 85 {
gen reg`i'trend = 0
replace reg`i'trend = year if region == 1300 + `i'
}

*treatment variables
gen or = 0
replace or = 1 if year > 2004
gen or_Yu = or*YuDec
gen or_west_border = or*west_border
gen or_east_border = or*east_border
gen or_macrowest = or*macrowest
gen or_macrocenter = or*macrocenter
gen or_macroeast = or*macroeast
gen or_macrosouth = or*macrosouth

*TABLE A2: DiDiD
*For most specifications, restrict sample to >= 1996, as a) priv-effect panel unbalanced prior to 1996, b) relatively few priv'ns, so imprecise estimates
*Also, drop Sevastopol due to (b)
 *Two-way fixed effects
xi: reg privDT or_Yu i.year i.region if year > 1995 & region != 1385, robust
outreg2 using tablepriv, excel bdec(3) replace
 *Year fixed effects, regional trends
xi: reg privDT or_Yu i.year i.region *trend if year > 1995 & region != 1385, robust
outreg2 using tablepriv, excel bdec(3)
 *Variation within macroregions
xi: reg privDT or_Yu or_macrowest or_macrosouth or_macroeast i.year i.region *trend if year > 1995 & region != 1385, robust
outreg2 using tablepriv, excel bdec(3) 
 *Border effect?
xi: reg privDT or_Yu or_west_border or_east_border i.year i.region *trend if year > 1995 & region != 1385, robust
outreg2 using tablepriv, excel bdec(3) 
 *Full sample
xi: reg privDT or_Yu i.year i.region *trend, robust
outreg2 using tablepriv, excel bdec(3)

*DECOMPOSITION
xi: reg privDT_sales or_Yu i.year i.region *trend if year > 1995 & region != 1385, robust
outreg2 using tableprivx, excel bdec(3) replace
xi: reg privDT_emp or_Yu i.year i.region *trend if year > 1995 & region != 1385, robust
outreg2 using tableprivx, excel bdec(3)
xi: reg privDT_cap or_Yu i.year i.region *trend if year > 1995 & region != 1385, robust
outreg2 using tableprivx, excel bdec(3)


