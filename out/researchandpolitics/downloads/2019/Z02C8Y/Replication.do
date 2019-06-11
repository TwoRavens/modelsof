*This is the replication do-file for the paper:
	*"Explaining the Salience of Anti-Elitism and Reducing Political Corruption for Political Parties in Europe with the 2014 Chapel Hill Expert Survey Data"


************************************************
**CROSSVALIDATION
************************************************
use "Crossvalidation.dta", clear // CHES trend and CMP data merged 
corr corrupt_salience per304 // Correlation of CHES corruption salience and CMP per304     


************************************************
**ANALYSES 
************************************************
use "Analysis.dta", clear // CHES trend data (year 2014 only), QoG and Party Facts merged data

********************
*Anti-corruption Salience 
xtmixed corrupt_salience c.lrecon##c.lrecon c.galtan##c.galtan c.age##c.age i.gov icrg_qog [weight=vote]  || country: , mle  // KEY MODEL
outreg2 using corrupt, tex(frag) dec(3) replace

margins , atmeans at(lrecon=(0(1)10))
marginsplot, recast(line) recastci(rline) ci1opts(fintensity(50) lpattern(dot)) scheme(s2mono) yti(Anti-corruption Salience) xscale(r(-1 11)) yscale(r(0 10)) ylabel(0 2 4 6 8 10) ti("") ///
	xlabel(0 "Extreme left" 1" " 2" " 3" " 4" " 5"center" 6" " 7" " 8" " 9" " 10"Extreme right", noticks) xti(Economic Left-Right) graphr(fc(white)) saving(Corr_lr.gph, replace)
	
margins , atmeans at(galtan=(0(1)10))
marginsplot, recast(line) recastci(rline) ci1opts(fintensity(50) lpattern(dot)) scheme(s2mono) yti(Anti-corruption Salience) xscale(r(-1 11)) ylabel(0 2 4 6 8 10) yscale(r(0 10)) ti("") ///
	xlabel(0 "GAL" 1" " 2" " 3" " 4" " 5"center" 6" " 7" " 8" " 9" " 10"TAN", noticks) xti(GALTAN) graphr(fc(white)) saving(Corr_gt.gph, replace)
	
margins , atmeans at(icrg_qog=(.39(0.1)1))
marginsplot,  recast(line)   recastci(rline) ci1opts(fintensity(50) lpattern(dot)) yti(Anti-corruption Salience) xscale(r(.3 1)) ylabel(0 2 4 6 8 10) yscale(r(0 10)) ti("") ///
	 ylabel(0 2 4 6 8 10) xlabel(0 "Low" 1"High", noticks) xti(Quality of Government) scheme(s2mono) graphr(fc(white)) ///
	yti(Anti-corruption Salience) title("") saving(Corr_qog.gph, replace) // figure in paper
	
margins, atmeans at(gov=(0 1))
marginsplot, recast(bar) plot1opts(fintensity(50))  ciopts(fintensity(10)) xlabel( , noticks) ///
	yscale(r(0 10)) ylabel(0 2 4 6 8 10)  scheme(s2mono) graphr(fc(white)) ///
	yti(Anti-corruption Salience) title("") saving(Corr_gov.gph, replace) // figure in paper

margins , atmeans at(age=(0(10)70))
marginsplot, recast(line) recastci(rline) ci1opts(fintensity(50) lpattern(dot)) scheme(s2mono) yti(Anti-corruption Salience) xscale(r(0 70)) ylabel(0 2 4 6 8 10) ti("") ///
	xlabel(0 10 20 30 40 50 60 70, noticks) xti(Party age) graphr(fc(white)) saving(Corr_age.gph, replace)



graph combine Corr_lr.gph Corr_gt.gph Corr_qog.gph Corr_gov.gph Corr_age.gph , note(Source: CHES 2014, size(vsmall))scheme(s2mono) graphr(fc(white))  // figure in paper

********************
*Anti-elite Salience 
xtmixed antielite_salience c.lrecon##c.lrecon c.galtan##c.galtan c.age##c.age i.gov icrg_qog [weight=vote] || country: , mle   // KEY MODEL
outreg2 using corrupt, tex(frag) dec(3) append

margins , atmeans at(lrecon=(0(1)10))
marginsplot, recast(line) recastci(rline) ci1opts(fintensity(50) lpattern(dot)) scheme(s2mono) yti(Anti-Elite Salience) xscale(r(-1 11)) ylabel(0 2 4 6 8 10) ti("") ///
	xlabel(0 "Extreme left" 1" " 2" " 3" " 4" " 5"center" 6" " 7" " 8" " 9" " 10"Extreme right", noticks) xti(Economic Left-Right) graphr(fc(white)) saving(Anti_lr.gph, replace)
	
margins , atmeans at(galtan=(0(1)10))
marginsplot, recast(line) recastci(rline) ci1opts(fintensity(50) lpattern(dot)) scheme(s2mono) yti(Anti-Elite Salience) xscale(r(-1 11)) ylabel(0 2 4 6 8 10) ti("") ///
	xlabel(0 "GAL" 1" " 2" " 3" " 4" " 5"center" 6" " 7" " 8" " 9" " 10"TAN", noticks) xti(GALTAN) graphr(fc(white)) saving(Anti_gt.gph, replace)
	
margins , atmeans at(icrg_qog=(.39(0.1)1))
marginsplot,  recast(line)   recastci(rline) ci1opts(fintensity(50) lpattern(dot)) yti(Anti-corruption Salience) xscale(r(.3 1)) ylabel(0 2 4 6 8 10) yscale(r(0 10)) ti("") ///
	 ylabel(0 2 4 6 8 10) xlabel(0 "Low" 1"High", noticks) xti(Quality of Government) scheme(s2mono) graphr(fc(white)) ///
	yti(Anti-Elite Salience) title("") saving(Anti_region.gph, replace) // figure in paper

margins, atmeans at(gov=(0 1))
marginsplot, recast(bar) plot1opts(fintensity(50))  ciopts(fintensity(10)) xlabel( , noticks) ///
	yscale(r(0 10)) ylabel(0 2 4 6 8 10)  scheme(s2mono) graphr(fc(white)) ///
	yti(Anti-Elite Salience) title("") saving(Anti_gov.gph, replace) // figure in paper
	
margins , atmeans at(age=(0(10)70))
marginsplot, recast(line) recastci(rline) ci1opts(fintensity(50) lpattern(dot)) scheme(s2mono) yti(Anti-Elite Salience) xscale(r(0 70)) ylabel(0 2 4 6 8 10) ti("") ///
	xlabel(0 10 20 30 40 50 60 70, noticks) xti(Party age) graphr(fc(white)) saving(Anti_age.gph, replace)

	

graph combine Anti_lr.gph Anti_gt.gph Anti_region.gph  Anti_gov.gph Anti_age.gph, note(Source: CHES 2014, size(vsmall))scheme(s2mono) graphr(fc(white))  // figure in paper
