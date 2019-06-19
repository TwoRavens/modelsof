* lukas
version 10
clear
set memory 2400m
capture log close
capture program drop _all
set more off
set matsize 800
log using ${pap4log}wagereg_ind_rev09_tables, text replace


* 1.
* Use panel made in wageregpanel.do 
* FD is defined at 20% threshold
	use ${pap4data}wagereg1temp.dta, clear
*keep if pid<50000
	replace eduy=9 if eduy==0 | eduy==.
	gen erf=max(0,age-eduy-7)
	replace erf=15 if erf>15
	sum erf
	gen erf2=(erf)^2
	gen erf3=(erf)^3
	gen erf4=(erf)^4
	gen size2=(size)^2
	gen MNE=1 if dommne==1 | formne==1
	replace MNE=0 if MNE==.
	sum realwage, det
	gen FD=(totutenl>0)
	gen Dsex=(sex==1)
	drop sex
	rename Dsex sex
* Drop low wages and very high wages
	drop if realwage<12000
	drop if realwage>200000
	rename wagedef wage
	#delimit ;
	keep aar pid bnr FD dommne formne wage naering 	
		size size2 kint skillshare femshare lp age
		eduy tenure t2 sex erf erf2 erf3 erf4;
	#delimit cr
* Tenure into years
	replace tenure=tenure/12
	drop t2 
	gen t2=tenure*tenure
* Year and industry dummies
	quietly tab aar, gen(Y)
	quietly tab naering, gen (I)
	drop Y1 I1

* Define sample for wageregressions
	quietly reg wage FD size size2 kint skillshare femshare lp eduy tenure  sex erf , cluster(pid)
	gen s=1 if e(sample)
	keep if s==1


	drop s
	codebook naering
* Gender interaction variables
	foreach t in eduy tenure t2 erf erf2 erf3 erf4 {
		gen D`t'=sex*`t'
	}
	compress	
	tempfile regtemp
	save regtemp.dta, replace

* Wage regressions
	global allvar "size size2 kint skillshare femshare eduy tenure t2 sex erf erf2 erf3 erf4"
	global plantvar "size size2 kint skillshare femshare"
	global indvar "eduy tenure t2 sex erf erf2 erf3 erf4"
	global fevar "size size2 kint skillshare femshare eduy tenure t2 erf erf2 erf3 erf4"

* Wage regressions
	quietly reg wage FD  Y* I*, cluster(pid)
	estimates store FD_y
	quietly  reg wage dommne formne Y* I*, cluster(pid)
	estimates store df_y

	quietly reg wage FD I* Y* $plantvar, cluster(pid)
	estimates store FD_pl
	quietly reg wage dommne formne I* Y* $plantvar, cluster(pid)
	estimates store df_pl

	sort pid aar
	gen Ddom=dommne-dommne[_n-1] if pid==pid[_n-1]
	gen Dfor=formne-formne[_n-1] if pid==pid[_n-1]
	gen Ddomst=Ddom if bnr==bnr[_n-1] & pid==pid[_n-1]
	gen Dforst=Dfor if bnr==bnr[_n-1] & pid==pid[_n-1]
	foreach t in Ddom Ddomst Dfor Dforst {
		tab `t'
	}
	quietly reg wage FD I* Y* $allvar, cluster(pid)
	estimates store FD_a
	quietly reg wage dommne formne I* Y* $allvar, cluster(pid)
	estimates store df_a
	tab dommne if e(sample)
	tab formne if e(sample)


	gen isic2=int(naering/1000)
	egen ind_year=group(isic2 aar)
	qui tab ind_year, gen(iy)
	drop iy1 isic2 ind_year
	drop I*
	compress
	quietly xtreg wage FD Y* iy* $fevar, fe r
	estimates store fe1
	quietly xtreg wage dommne formne Y* iy* $fevar, fe r
	estimates store fe2
	

	estout FD_y FD_pl FD_a fe1 using ${pap4tab}wageregFD_rev09.tex, keep(FD) replace style(tex) notype /// 
	stats(N r2, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
 	cells(b(fmt(%4.3f)) se(par star fmt(%4.3f))) ///
	starlevels ($^{(\ast)}$ .01 $^{\ast\ast}$ .001) /// 	
	mlabels( , none) label nolz collabels(, none) ///
 	varlabels(FD "Foreign ownership dummy") ///
 	title("Wage premia in foreign owned plants and in multinationals") 

	estout df_y df_pl df_a fe2 /// 
	using ${pap4tab}wageregFD_rev09.tex, append style(tex) notype ///
	stats(N r2, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
 	keep(formne dommne) cells(b(fmt(%4.3f)) se(par star fmt(%4.3f))) ///
	starlevels ($^{(\ast)}$ .01 $^{\ast\ast}$ .001) ///	
 	mlabels( , none) label nolz collabels(, none) ///
	varlabels(formne "Foreign MNE" dommne "Domestic MNE") 

	estimates table FD_y FD_pl FD_a fe1 , keep(FD) stats(N r2) star
	estimates table df_y df_pl df_a fe2 , keep(formne dommne) stats(N r2) star

	drop iy*
	gen isic3=int(naering/100)
	qui tab isic3, gen(I)
	drop I1
quietly xtreg wage FD Y* I* $fevar, fe r
	estimates store fe1
	quietly xtreg wage dommne formne Y* I* $fevar, fe r
	estimates store fe2
	quietly xtreg wage FD Y*  $fevar, fe r
	estimates store fe3
	quietly xtreg wage dommne formne Y*  $fevar, fe r
	estimates store fe4
	estimates table fe1 fe2 fe3 fe4, keep( FD formne dommne) stats(N r2) star

* Repeat with gender interaction variables, 
* results are almost identical
erase regtemp.dta

log close
exit
	use regtemp.dta, clear
* Wage regressions
#delimit ;
	global allvar "size size2 kint skillshare femshare eduy tenure t2 sex erf erf2 erf3 erf4
		Deduy Dtenure Dt2 Derf Derf2 Derf3 Derf4";
	global plantvar "size size2 kint skillshare femshare";
	global indvar "eduy tenure t2 sex erf erf2 erf3 erf4 Deduy Dtenure Dt2 Derf Derf2 Derf3 Derf4";
	global fevar "size size2 kint skillshare femshare eduy tenure t2 erf erf2 erf3 erf4
		Deduy Dtenure Dt2 Derf Derf2 Derf3 Derf4";
#delimit cr
regs
	estout FD_y FD_pl FD_a fe1 using ${pap4tab}wageregFD_rev09_alt.tex, keep(FD) replace style(tex) notype /// 
	stats(N r2, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
 	cells("b(fmt(%4.3f)) se(par star fmt(%4.3f))") ///
	starlevels ($^{(\ast)}$ .01 $^{\ast\ast}$ .001) /// 	
	mlabels( , none) label nolz collabels(, none) ///
 	varlabels(FD "Foreign ownership dummy") ///
 	title("Wage premia in foreign owned plants and in multinationals") 

	estout df_y df_pl df_a fe2 /// 
	using ${pap4tab}wageregFD_rev09.tex, append style(tex) notype ///
	stats(N r2, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
 	keep(formne dommne) cells("b(fmt(%4.3f)) se(par star fmt(%4.3f))") ///
	starlevels ($^{(\ast)}$ .01 $^{\ast\ast}$ .001) ///	
 	mlabels( , none) label nolz collabels(, none) ///
	varlabels(formne "Foreign MNE" dommne "Domestic MNE") 

	estimates table FD_y FD_pl FD_a fe1 , keep(FD) stats(N r2) star
	estimates table df_y df_pl df_a fe2 , keep(formne dommne) stats(N r2) star


capture log close 
exit



