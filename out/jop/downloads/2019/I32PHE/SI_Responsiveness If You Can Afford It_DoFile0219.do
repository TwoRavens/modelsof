********************************************************************************
*
* This do file replicates the results for the supplementary information file
* of "Responsiveness, If You Can Afford It: Policy Responsiveness in Good and  
* Bad Economic Times"
*
* Ezrow, Lawrence, Timothy Hellwig, and Michele Fenzl
*
* Created, Jan 2019
*
********************************************************************************

version 13

drop _all
clear matrix
clear mata

capture net install outreg2, from(http://fmwww.bc.edu/RePEc/bocode/o)			
capture net install grinter, from(http://myweb.uiowa.edu/fboehmke/stata)

********************************************************************************

local DIR = ""  /*change the path to the directory on your computer 		*/
cd "`DIR'"

/* Note: You have to change "local DIR" to the directory you copy the original  
files contained in the zip file and then run this do. If you don't set the wd 
you will not be able to export xls outputs (i.e. the outreg2 commands below will
return an error. If you prefer not to replicate the xls files, skip the outreg2
commands 																   */

********************************************************************************

use "Responsiveness If You Can Afford It.dta", replace

set more off

xtset cc year

********************************************************************************

/* Tables are numbered as they appear in the SI. If you do not want to output 
the tables in excel formats, skip the lines starting with the command outreg2 */

* Summary statics (S1a & S1b)

sum totgen d.totgen cmedianall d.cmedianall real d.real labf1000 d.labf1000 if used == 1

tab emu if used == 1

* Figure S1.

qui xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.labf1000 l.labf1000 i.emu i.cc, corr(ar1)
cap gen byte used = e(sample)

cap gen dtotgen = d.totgen
cap gen ltotgen = l.totgen
cap gen dcmedianall = d.cmedianall
cap gen lcmedianall = l.cmedianall
cap gen drealgdpgr = d.realgdpgr
cap gen lrealgdpgr = l.realgdpgr
cap gen dlabf1000 = d.labf1000
cap gen llabf1000 = l.labf1000
cap gen Dinter = dcmedianall * drealgdpgr
cap gen Linter = lcmedianall * lrealgdpgr

label var dtotgen "Change in generosity (t)"
label var lcmedianall "Median voter position (t-1)"
label var lrealgdpgr "Economic growth (t-1)"


xtpcse dtotgen ltotgen dcmedianall lcmedianall drealgdpgr lrealgdpgr ///
	Dinter Linter dlabf1000 llabf1000 i.emu if used == 1, corr(ar1)
grinter (lcmedianall), inter(Linter) const(lrealgdpgr) ///
	yline(0, lc(gs7)) lc(black) kdensity non scheme(s2mono) ///
	ytitle(Conditional coefficient on Median voter position (t-1)) ///
	graphr(c(white))

* Table S2

label var decade "Decade"

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.labf1000 l.labf1000 i.emu i.cc i.decade if used == 1, corr(ar1)
outreg2 using s2, excel lab  ctitle("Change in generosity") dec(2) ///
	keep (l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.labf1000 l.labf1000 i.emu ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall i.decade) replace

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.labf1000 l.labf1000 i.emu i.cc i.decade if used == 1, corr(ar1)
outreg2 using s2, excel lab ctitle("Change in generosity") dec(2) ///
	keep (l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.labf1000 l.labf1000 i.emu ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall i.decade) append
	
* Table S3

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.debt l.debt d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
outreg2 using s3, excel lab  ctitle("Change in generosity") dec(2) ///
	keep (l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.debt l.debt d.labf1000 l.labf1000 i.emu ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall) replace

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.debt l.debt d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
outreg2 using s3, excel lab ctitle("Change in generosity") dec(2) ///
	keep (l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.debt l.debt d.labf1000 l.labf1000 i.emu ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall) append

* Table S4

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.curac l.curac d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
outreg2 using s4, excel lab  ctitle("Change in generosity") dec(2) ///
	keep (l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.curac l.curac d.labf1000 l.labf1000 i.emu ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall) replace

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.curac l.curac d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
outreg2 using s4, excel lab ctitle("Change in generosity") dec(2) ///
	keep (l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.curac l.curac d.labf1000 l.labf1000 i.emu ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall) append

* Table S5

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.effpar_leg l.effpar_leg d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
outreg2 using s5, excel lab  ctitle("Change in generosity") dec(2) ///
	keep (l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.labf1000 l.labf1000 i.emu ///
	d.effpar_leg l.effpar_leg ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall) replace

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.effpar_leg l.effpar_leg d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
outreg2 using s5, excel lab ctitle("Change in generosity") dec(2) ///
	keep (l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.labf1000 l.labf1000 i.emu ///
	d.effpar_leg l.effpar_leg ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall) append

* Table S6

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.dis_abs l.dis_abs c.d.dis_abs#c.d.cmedianall c.l.dis_abs#c.l.cmedianall ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
outreg2 using s6, excel lab  ctitle("Change in generosity") dec(2) ///
	keep (l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.dis_abs l.dis_abs c.d.dis_abs#c.d.cmedianall c.l.dis_abs#c.l.cmedianall ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.labf1000 l.labf1000 i.emu i.prop) replace

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.dis_abs l.dis_abs c.d.dis_abs#c.d.cmedianall c.l.dis_abs#c.l.cmedianall ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.labf1000 l.labf1000 i.emu i.prop i.cc if used == 1, corr(ar1)
outreg2 using s6, excel lab ctitle("Change in generosity") dec(2) ///
	keep (l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.dis_abs l.dis_abs c.d.dis_abs#c.d.cmedianall c.l.dis_abs#c.l.cmedianall ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.labf1000 l.labf1000 i.emu i.prop) append	
	


* Table S7

cap gen federalism = 0
replace federalism = 1 if fed >= 1

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	l.federalism l.federalism#c.l.cmedianall  ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
outreg2 using s7, excel lab ctitle("Change in generosity") dec(2) ///
	keep (l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	l.federalism l.federalism#c.l.cmedianall  ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.labf1000 l.labf1000 i.emu) replace
	
* Table S8

cap drop bix
cap gen bix = 0
replace bix = 1 if bic > 3

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	l.bix c.l.bix#c.l.cmedianall c.l.bix#c.d.cmedianall ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)	
outreg2 using s8, excel lab ctitle("Change in generosity") dec(2) ///
	keep (l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	l.bix c.l.bix#c.l.cmedianall c.l.bix#c.d.cmedianall ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.labf1000 l.labf1000 i.emu) replace
	
	
	
* Table S9

cap gen rescaled_govtrile = ( ( (10 - 0) / (50 - -50) ) * ( govt_rile - 50 ) ) + 10
pwcorr rescaled_govtrile govt_rile

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.rescaled_govtrile l.rescaled_govtrile d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
	
xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.govt_wel l.govt_wel d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
	
* Table S10

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	gov_chan d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
