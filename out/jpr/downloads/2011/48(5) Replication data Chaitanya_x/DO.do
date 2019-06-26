set more off

***********************************************************************************
local NE conflicts = "D:\KC\RESEARCH\CONSTRUCTION\NE conflicts"  /*change relative path to the directory where the files are located */
cd "`NE conflicts'"
***********************************************************************************

*** provide labels 

label var cw "civil conflict Incidence"
label var lnpcgdp "Per capita GDP (log)"
label var lnpop "Population (log)"
label var lnpopden "Population Density GDP (log)"
label var lnforest "Forest area (log)"
label var lnarea "total area (log)"
label var frac "Religious & Lingustic Fractionalization"
label var lnarb "Arable land (log)"
label var lnpolicepc "Police force per head (log)"
label var lnpolice "Police force (log)"
label var peace "civil peace years"
label var pdum "civil peace years dummy"
label var ncw "Nighbors civil conflict incidence"
label var nonset "Nighbors onset"
label var lndist "Distance from Capital city to New Delhi (log)"
label var pov "poverty rate (% people living below poverty line)"
label var rpov "Relative Poverty (Poverty in state i / Country's poverty)"
label var edi "Economic Discrimination Index"
label var pdi "Political Discrimination Index"
label var tdi "Total Discrimination Index"
label var pract "Panchayat Raj Act of respective states"

* Correlation Matrix: 

corr(cw l.lnpcgdp l.lnpopden l.farea l.frac l.lnpolicepc l.lndist l.pdum l.ncw l.pract l.edi l.pdi l.tdi l.pov l.rpov)

* Descriptive Statistics: 

sum(cw cwc lnpcgdp lnpopden farea frac lnpolicepc lndist pdum ncw pract edi pdi tdi pov rpov)


*** TABLE 1: PROBIT ESTIMATIONS ***

** column 1
xi: probit cw laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract i.year, robust
margins, dydx(*) at(_all) post
estimates store c1_mfx

** column 2
xi: probit cw laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagedi i.year, robust
margins, dydx(*) at(_all) post
estimates store c2_mfx

** column 3
xi: probit cw laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagpdi i.year, robust
margins, dydx(*) at(_all) post
estimates store c3_mfx

** column 4
xi: probit cw laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagtdi i.year, robust
margins, dydx(*) at(_all) post
estimates store c4_mfx

** column 5
xi: probit cw laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagpov i.year, robust
margins, dydx(*) at(_all) post
estimates store c5_mfx

** column 6
xi: probit cw laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagrpov i.year, robust
margins, dydx(*) at(_all) post
estimates store c6_mfx

estout c1_mfx c2_mfx c3_mfx c4_mfx c5_mfx c6_mfx using "tables\table 1.txt", append label delimiter(_tab) noabbrev  	///										
				cells(b(star fmt(%9.3f)) t(par abs fmt(2))) style(fixed) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N ,	///		
				labels("Number of observations") fmt(0 0 2 2)) 															///		
				mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") keep(laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagedi lagpdi lagtdi lagpov lagrpov)


*** TABLE 2: GMM ESTIMATIONS ***

** column 1

xi: xtabond2 cw l.cw l.lnpcgdp l.lnpopden l.farea l.frac l.lnpolicepc l.lndist l.pdum l.ncw l.pract i.year, gmm(l3.cw, collapse) iv(l3.cw l2.lnpcgdp l2.lnpopden l2.farea l2.frac l2.lnpolicepc l2.lndist l2.pdum l2.ncw l2.pract i.year) robust
estimates store vkc
outreg2 using "op", excel

** column 3

xi: xtabond2 cw l.cw l.lnpcgdp l.lnpopden l.farea l.frac l.lnpolicepc l.lndist l.pdum l.ncw l.pract l.edi i.year, gmm(l3.cw, collapse) iv(l3.cw l.edi l2.edi l3.edi l2.lnpcgdp l2.lnpopden l2.farea l2.frac l2.lnpolicepc l2.lndist l2.pdum l2.ncw l2.pract i.year) robust
outreg2 using "op", excel

** column 2

xi: xtabond2 cw l.cw l.lnpcgdp l.lnpopden l.farea l.frac l.lnpolicepc l.lndist l.pdum l.ncw l.pract l.pdi i.year, gmm(l3.cw, collapse) iv(l3.cw l.pdi l2.pdi l3.pdi l2.lnpcgdp l2.lnpopden l2.farea l2.frac l2.lnpolicepc l2.lndist l2.pdum l2.ncw l2.pract i.year) robust
outreg2 using "op", excel

** column 4

xi: xtabond2 cw l.cw l.lnpcgdp l.lnpopden l.farea l.frac l.lnpolicepc l.lndist l.pdum l.ncw l.pract l.pov i.year, gmm(l3.cw, collapse) iv(l3.cw l.pov l2.pov l3.pov l2.lnpcgdp l2.lnpopden l2.farea l2.frac l2.lnpolicepc l2.lndist l2.pdum l2.ncw l2.pract i.year) robust
outreg2 using "op", excel

** column 5

xi: xtabond2 cw l.cw l.lnpcgdp l.lnpopden l.farea l.frac l.lnpolicepc l.lndist l.pdum l.ncw l.pract l.rpov i.year, gmm(l3.cw, collapse) iv(l3.cw l.rpov l2.rpov l3.rpov l2.lnpcgdp l2.lnpopden l2.farea l2.frac l2.lnpolicepc l2.lndist l2.pdum l2.ncw l2.pract i.year) robust
outreg2 using "op", excel



*** ROBUSTNESS CHECK 1 - without West Bengal ***

preserve

drop if state =="West Bengal"

** column 1
xi: probit cw l.lnpcgdp l.lnpopden l.farea l.frac l.lnpolicepc l.lndist l.pdum l.ncw l.pract i.year, robust
margins, dydx(*) at(_all) post

** column 2
xi: probit cw l.lnpcgdp l.lnpopden l.farea l.frac l.lnpolicepc l.lndist l.pdum l.ncw l.pract l.edi i.year, robust
margins, dydx(*) at(_all) post

** column 3
xi: probit cw l.lnpcgdp l.lnpopden l.farea l.frac l.lnpolicepc l.lndist l.pdum l.ncw l.pract l.pdi i.year, robust
margins, dydx(*) at(_all) post

** column 4
xi: probit cw l.lnpcgdp l.lnpopden l.farea l.frac l.lnpolicepc l.lndist l.pdum l.ncw l.pract l.tdi i.year, robust
margins, dydx(*) at(_all) post

** column 5
xi: probit cw l.lnpcgdp l.lnpopden l.farea l.frac l.lnpolicepc l.lndist l.pdum l.ncw l.pract l.pov i.year, robust
margins, dydx(*) at(_all) post

** column 6
xi: probit cw l.lnpcgdp l.lnpopden l.farea l.frac l.lnpolicepc l.lndist l.pdum l.ncw l.pract l.rpov i.year, robust
margins, dydx(*) at(_all) post

restore



*** ROBUSTNESS CHECK 2 - Civil War Presence ***

** column 1
xi: probit cwc laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract i.year, robust
margins, dydx(*) at(_all) post

** column 2
xi: probit cwc laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagedi i.year, robust
margins, dydx(*) at(_all) post

** column 3
xi: probit cwc laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagpdi i.year, robust
margins, dydx(*) at(_all) post

** column 4
xi: probit cwc laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagtdi i.year, robust
margins, dydx(*) at(_all) post

** column 5
xi: probit cwc laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagpov i.year, robust
margins, dydx(*) at(_all) post

** column 6
xi: probit cwc laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagrpov i.year, robust
margins, dydx(*) at(_all) post



*** ROBUSTNESS CHECK 3 - Civil War Years Count ***

** column 1
xi: nbreg cwcount laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract i.year, robust
margins, dydx(*) at(_all) post

** column 2
xi: nbreg cwcount laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagedi i.year, robust
margins, dydx(*) at(_all) post

** column 3
xi: nbreg cwcount laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagpdi i.year, robust
margins, dydx(*) at(_all) post

** column 4
xi: nbreg cwcount laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagtdi i.year, robust
margins, dydx(*) at(_all) post

** column 5
xi: nbreg cwcount laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagpov i.year, robust
margins, dydx(*) at(_all) post

** column 6
xi: nbreg cwcount laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract lagrpov i.year, robust
margins, dydx(*) at(_all) post




*** Graphs: Marginal Effects of Interaction Terms ***

preserve

*** Conditional Plot: Poverty and EDI

xi: probit cw c.lagpov#c.lagedi laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract i.year, robust

quietly summarize laglnpcgdp  if e(sample)
local mean_laglnpcgdp = r(mean)
quietly summarize laglnpopden if e(sample)
local mean_laglnpopden = r(mean)
quietly summarize lagfarea if e(sample)
local mean_lagfarea = r(mean)
quietly summarize lagfrac if e(sample)
local mean_lagfrac = r(mean)
quietly summarize laglnpolicepc if e(sample)
local mean_laglnpolicepc = r(mean)
quietly summarize laglndist if e(sample)
local mean_laglndist = r(mean)
quietly summarize lagpdum if e(sample)
local mean_lagpdum = r(mean)
quietly summarize lagncw if e(sample)
local mean_lagncw = r(mean)
quietly summarize lagpract if e(sample)
local mean_lagpract = r(mean)

margins, dydx(lagpov) at(lagedi=(0(1)4) laglnpcgdp=(`mean_laglnpcgdp') laglnpopden=(`mean_laglnpopden') lagfarea=(`mean_lagfarea') laglnpolicepc=(`mean_laglnpolicepc') laglndist=(`mean_laglndist') lagpdum=(`mean_lagpdum') lagncw=(`mean_lagncw') lagpract=(`mean_lagpract')) predict(pr) post

*predict pr, post
 
matrix at=e(at)
matrix at=at[1...,2] 
matrix list at
 
parmest, level(`level') norestore
svmat at

twoway(line estimate at1)(line min`level' at1)(line max`level' at1), legend(off) xlabel(0 1 2 3 4,labsize(3)) title("Conditional Plot of Poverty and EDI", size(4)) xtitle(EDI, size(3.5)) ytitle(Marginal Effect of Relative Poverty, size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))



*** Conditional Plot: Relative Poverty and EDI

xi: probit cw c.lagrpov#c.lagedi laglnpcgdp laglnpopden lagfarea lagfrac laglnpolicepc laglndist lagpdum lagncw lagpract i.year, robust

quietly summarize laglnpcgdp  if e(sample)
local mean_laglnpcgdp = r(mean)
quietly summarize laglnpopden if e(sample)
local mean_laglnpopden = r(mean)
quietly summarize lagfarea if e(sample)
local mean_lagfarea = r(mean)
quietly summarize lagfrac if e(sample)
local mean_lagfrac = r(mean)
quietly summarize laglnpolicepc if e(sample)
local mean_laglnpolicepc = r(mean)
quietly summarize laglndist if e(sample)
local mean_laglndist = r(mean)
quietly summarize lagpdum if e(sample)
local mean_lagpdum = r(mean)
quietly summarize lagncw if e(sample)
local mean_lagncw = r(mean)
quietly summarize lagpract if e(sample)
local mean_lagpract = r(mean)

margins, dydx(lagrpov) at(lagedi=(0(1)4) laglnpcgdp=(`mean_laglnpcgdp') laglnpopden=(`mean_laglnpopden') lagfarea=(`mean_lagfarea') laglnpolicepc=(`mean_laglnpolicepc') laglndist=(`mean_laglndist') lagpdum=(`mean_lagpdum') lagncw=(`mean_lagncw') lagpract=(`mean_lagpract')) predict(pr) post

*predict pr, post
 
matrix at=e(at)
matrix at=at[1...,2] 
matrix list at
 
parmest, level(`level') norestore
svmat at

twoway(line estimate at1)(line min`level' at1)(line max`level' at1), legend(off) xlabel(0 1 2 3 4,labsize(3)) title("Conditional Plot of Relative Poverty and EDI", size(4)) xtitle(EDI, size(3.5)) ytitle(Marginal Effect of Relative Poverty, size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))

restore
