clear 
set memory 100m

use REPLICATECOOKRESTAT2010

tsset seccount year

tab year, generate(time)
gen fyear = fix*year
tab fyear, generate(ftime)
tab seccount, gen(indexer) 
gen europe = 0
replace europe = 1 if country == 3
replace europe = 1 if country == 4
replace europe = 1 if country == 6
replace europe = 1 if country == 7
replace europe = 1 if country == 8
replace europe = 1 if country == 9
replace europe = 1 if country == 10
replace europe = 1 if country == 11
replace europe = 1 if country == 12
replace europe = 1 if country == 14
replace europe = 1 if country == 16
replace europe = 1 if country == 17
replace europe = 1 if country == 18
replace europe = 1 if country == 19
replace europe = 1 if country == 20
replace europe = 1 if country == 21
gen euroyear = europe*year
tab euroyear, gen(eurotime)
gen  euroland = 0
replace euroland = 1 if country == 3
replace euroland = 1 if country == 4
replace euroland = 1 if country == 6
replace euroland = 1 if country == 7
replace euroland = 1 if country == 8
replace euroland = 1 if country == 9

replace euroland = 1 if country == 11
replace euroland = 1 if country == 12
replace euroland = 1 if country == 14
replace euroland = 1 if country == 17
replace euroland = 1 if country == 18




gen tradable = 0
replace tradable = 1 if sector == 26
replace tradable = 1 if sector == 28
replace tradable = 1 if sector == 29

gen nontradable = 1-tradable
gen commodity = 0
replace commodity = 1 if sector ==28
replace commodity = 1 if sector ==29
gen noncommodity = 1-commodity
gen EMU = 0
replace EMU = 1 if year > 1998
replace EMU = 0 if country == 6 
gen nonEMU = 1-EMU

gen trfix = tradable*fix
gen ntrfix = nontradable*fix
gen cfix = commodity*fix
gen ncfix = noncommodity*fix
gen EMUfix = EMU*fix
gen nEMUfix = nonEMU*fix




gen length = 0
replace length = year-1981 if country ==3 & year > 1981
replace length = year-1980 if country ==4 & year > 1980
replace length = year-1999 if country ==6 & year > 1999
replace length = year-1995 if country ==7 & year > 1995
replace length = year-1997 if country ==8 & year > 1997
replace length = year-1999 if country ==9 & year > 1999
replace length = year -1997 if country ==11 & year > 1997
replace length = year -1997 if country ==12 & year > 1997
replace length = year -1983 if country ==14 & year > 1983
replace length = year - 1994 if country == 17 & year > 1994
replace length = year -1994 if country == 18 & year > 1994
gen upmark5 = (upmark+l1.upmark+l2.upmark+l3.upmark+l4.upmark)/5
gen fix5 = (fix+l1.fix+l2.fix+l3.fix+l4.fix)/5
gen quentennial = 0
replace quentennial = 1 if year == 1988
replace quentennial = 1 if year == 1993
replace quentennial = 1 if year == 1998
replace quentennial = 1 if year == 2003
gen countryear = (country*10000)+year



gen eighty = 0
replace eighty =1 if year < 1992
gen ninety = 0
replace ninety = 1 if year > 1991
gen eightyfix = eighty*fix
gen ninetyfix = ninety*fix
gen lengthfix = length*fix

gen austria = 0
replace austria = 1 if country == 3
gen belgium = 0
replace belgium = 1 if country == 4
gen denmark = 0
replace denmark = 1 if country == 6
gen finland = 0
replace finland = 1 if country == 7
gen france = 0
replace france = 1 if country == 8
gen germany = 0
replace germany = 1 if country == 9
gen ireland = 0
replace ireland = 1 if country == 11
gen italy = 0 
replace italy = 1 if country == 12
gen holland = 0
replace holland = 1 if country == 14
gen portugal = 0
replace portugal = 1 if country == 17
gen spain = 0
replace spain = 1 if country == 18
gen austriafix = austria*fix
gen belgiumfix = belgium*fix
gen denmarkfix = denmark*fix
gen finlandfix = finland*fix
gen francefix = france*fix
gen germanyfix = germany*fix
gen irelandfix = ireland*fix
gen italyfix  = italy*fix
gen hollandfix = holland*fix
gen portugalfix = portugal*fix
gen spainfix = spain*EMUfix 

gen manufacturing = 0
replace manufacturing = 1 if sector == 26
gen agriculture = 0
replace agriculture = 1 if sector == 28
gen mining = 0
replace mining = 1 if sector == 29
gen utility = 0
replace utility = 1 if sector == 30
gen construct = 0
replace construct = 1 if sector == 31
gen trade = 0
replace trade = 1 if sector == 32
gen transport = 0
replace transport = 1 if sector == 33
gen pss = 0
replace pss = 1 if sector == 34
gen firebs = 0
replace firebs = 1 if sector ==36
gen bs = 0
replace bs = 1 if sector == 35
gen retail = 0
replace retail = 1 if sector ==38
gen hotel = 0
replace hotel = 1 if sector == 39
gen bss = 0
replace bss = 1 if sector == 40


gen manufix = manufacturing*fix
gen agrifix = agriculture*fix
gen minifix = mining*fix
gen utilfix = utility*fix
gen cnstfix = construct*fix
gen tradefix = trade*fix
gen transfix = transport*fix
gen pssfix = pss*fix
gen firebsfix = firebs*fix
gen bsfix = bs*fix
gen retailfix = retail*fix
gen hotelfix = hotel*fix
gen bssfix = bss*fix








gen exratevolfix = exratevol*fix
gen eplfix = epl*fix
gen barrierfix = barrier*fix
gen brunionfix = brunion*fix*100
gen dbarfix = dbar*fix

gen fixyear = fix*year
tab fixyear, gen(fixtime)



gen yearfix = (year-2003)*fix
gen secdev = sqrt(seccycle)*100
gen seccfix = (secdev^2)*fix


gen fdisecfix = fdisector*fix*1000


gen barsmoothfix = barrier*fix
replace barsmoothfix = barsmoothfix -(dbarfix*.2) if year == 1999
replace barsmoothfix = barsmoothfix -(dbarfix*.4) if year == 2000
replace barsmoothfix = barsmoothfix -(dbarfix*.6) if year == 2001
replace barsmoothfix = barsmoothfix -(dbarfix*.8) if year == 2002
replace barsmoothfix = barsmoothfix -(dbarfix*1) if year == 2003

/*  =====================================================================  */
/*  TABLE 2, PANEL A */
/*
xtreg  upmark time1-time24 fix if year > 1979 & sector ==27 & sector ~=35 & sector < 37, fe
*/
/*  =====================================================================  */

/*  =====================================================================  */
 /*  TABLE 2, PANEL B */
/*
xtreg  upmark time1-time24 fix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */

/*  =====================================================================  */
 /*  TABLE 2, PANEL C  */
/*
reg  upmark isic1-isic229  time1-time24 fix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37 [aweight = secweight], cluster(seccount)  
 */
/*  =====================================================================  */

/*  =====================================================================  */
/*  TABLE 2, PANEL D */
/*
xtreg  upmark time1-time24 eurotime1-eurotime24 fix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */

/*  =====================================================================  */
 /*  TABLE 2, PANEL E  */
/*
xtreg  upmark5 time1-time24 fix5 if year > 1979 & sector ~=27 & sector ~=35 & sector < 37 & quentennial == 1, fe  cluster(seccount)
*/
/*  =====================================================================  */


/*  =====================================================================  */
/* TABLE 2, PANEL G */
/*
  xtreg  upmark time1-time24 EMUfix nEMUfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */


/*  =====================================================================  */
/* TABLE 2, PANEL H */
/*
  xtreg  upmark time1-time24 eightyfix ninetyfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */


/*  =====================================================================  */
/* TABLE 2, PANEL I */
/*
  xtreg  upmark time1-time24 fix length if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */


/*  =====================================================================  */
/* TABLE 3, PANEL A */
/*
  xtreg  upmark time1-time24 manufix-firebsfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */


/*  =====================================================================  */
/* TABLE 3, PANEL B */
/*
  xtreg  upmark time1-time24 trfix ntrfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */

/*  =====================================================================  */
/* TABLE 3, PANEL C */
/*
  xtreg  upmark time1-time24 trfix ntrfix seccfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */


/*  =====================================================================  */
/* TABLE 3, PANEL D */
/*
  xtreg  upmark time1-time24 cfix ncfix seccfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */

/*  =====================================================================  */
/* TABLE 3, PANEL E */
/*
  xtreg  upmark time1-time24 cfix ncfix fdisecfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */

/*  =====================================================================  */
/* TABLE 4, PANEL A */
/*
  xtreg  upmark time1-time24 austriafix-spainfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */


/*  =====================================================================  */
/* TABLE 4, PANEL B */
/*
  xtreg  upmark time1-time24 cfix ncfix seccfix exratevolfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */

/*  =====================================================================  */
/* TABLE 4, PANEL C */
/*
  xtreg  upmark time1-time24 cfix ncfix seccfix exratevolfix germanyfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */



/*  =====================================================================  */
/* TABLE 4, PANEL D */
/*
  xtreg  upmark time1-time24 cfix ncfix seccfix exratevolfix barsmoothfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */

/*  =====================================================================  */
/* TABLE 4, PANEL E */
/*
  xtreg  upmark time1-time24 fix seccfix exratevolfix barsmoothfix if year > 1979 & sector ==27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */


/*  =====================================================================  */
/* TABLE 5, PANEL A */
/*
  xtreg  upmark time1-time24 cfix ncfix seccfix exratevolfix brunionfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */


/*  =====================================================================  */
/* TABLE 5, PANEL B */
/*
  xtreg  upmark time1-time24 cfix ncfix seccfix exratevolfix brunionfix barsmoothfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */


/*  =====================================================================  */
/* TABLE 5, PANEL C */
/*
  xtreg  upmark time1-time24 cfix ncfix seccfix exratevolfix eplfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */


/*  =====================================================================  */
/* TABLE 5, PANEL D */
/*
  xtreg  upmark time1-time24 cfix ncfix seccfix exratevolfix eplfix barsmoothfix if year > 1979 & sector ~=27 & sector ~=35 & sector < 37, fe  cluster(seccount)
*/
/*  =====================================================================  */

