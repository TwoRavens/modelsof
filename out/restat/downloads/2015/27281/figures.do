//setup
	clear all
	set matsize 4000
	args SEED REPS TYPE
	capture cd "D:/DATA.IDB/Dropbox/1.Research/2.Methods/BDM/BDM2012/code/"
	if _rc==0 global cd = "D:/DATA.IDB/Dropbox/1.Research/2.Methods/BDM/BDM2012/code/"
	capture cd "D:/Dropbox/My Dropbox/1.Research/2.Methods/BDM/BDM2012/code/"
	if _rc==0 global cd = "D:/Dropbox/My Dropbox/1.Research/2.Methods/BDM/BDM2012/code/"
	capture cd "/accounts/fac/jmccrary/research/BDM2012/code/"
	if _rc==0 global cd = "/accounts/fac/jmccrary/research/BDM2012/code/"
	global dir = "$cd/Figures/"
	//load library
	mata: mata set matastrict off
	run "frolichdgp.ado"  //Froelich DGP
	run "nswdgp.ado"      //NSW DGP
	run "msdgp.ado"      //DGP for misspecified estimators
	cd "$cd"

// Frolich DGP Outcome Curves
	local n = 10000
	frolichlogitdgp, n(`n') design(1) curves(1 2 3 4 5 6) var(0.1)
	keep m* pX
	replace pX = round(pX,0.01)
	collapse (mean) m*, by(pX)
	sort pX

	* Figure 1: curves 1-3
	twoway ///
	(line m1 m2 m3 pX, lcolor(gs8)), ///
	ytitle("m(p)") yscale(range(0 1) lcolor(gs12)) ylabel(0(0.2)1) ///
	yline(0.2 0.4 0.6 0.8, lwidth(thin) lpattern(solid) lcolor(gs14)) ///
	xtitle("Propensity Score") xscale(range(0 1) lcolor(gs14)) xlabel(0(0.2)1) ///
	legend(off) scheme(s2mono) ///
	graphregion(color(white) fcolor(white)) ///
	title("A. Curves 1-3", size(small))
	graph save Graph "$dir/S1.gph", replace

	* Figure 1: curves 4-6
	twoway ///
	(line m4 m5 m6 pX, lcolor(gs8)), ///
	ytitle("m(p)") yscale(range(0 1) lcolor(gs12)) ylabel(0(0.2)1) ///
	yline(0.2 0.4 0.6 0.8, lwidth(thin) lpattern(solid) lcolor(gs14)) ///
	xtitle("Propensity Score") xscale(range(0 1) lcolor(gs14)) xlabel(0(0.2)1) ///
	legend(off) scheme(s2mono) ///
	graphregion(color(white) fcolor(white)) ///
	title("B. Curves 4-6", size(small))
	graph save Graph "$dir/S2.gph", replace

	graph combine "$dir/S1.gph" "$dir/S2.gph", scheme(s2mono) xsize(5) ysize(2) title("Figure 2: Frolich Outcome Curves", size(small))
	graph save Graph "$dir/frolich_curves.gph", replace 

//Frolich Designs
	// Define mata function
	clear all
	mata
	real colvector function Lambdainv(real colvector v) {
	  return( ln(v):-ln(1:-v) )
	}
	  real colvector function Lambda(real colvector z) {
	  real colvector emz
	  emz=exp(-z)
	  return( 1:/(1:+emz) )
	}
	real matrix function fig1(real scalar alpha, real scalar beta, real scalar n) {
	real scalar c0, c1, q
	real colvector Lambda, v, Lambdainv, einv, f, f1, f0
	c0=0
	c1=sqrt(2)
	q=alpha+beta/2
	Lambda=(1::n)/(n+1) //ranges 0 to 1
	v=Lambda*beta:+alpha //ranges alpha to beta
	Lambdainv=Lambdainv(v) 
	einv=(Lambdainv((v:-alpha)/beta):-c0)/c1 //gives X values corresponding to v
	f=normalden(einv):*(1/(c1*beta)):*(1:/(v:*(1:-v)))
	f1=(1/q)    *(alpha:+beta*Lambda(c0:+c1*einv)):*f
	f0=(1/(1-q))*(1:-alpha:-beta*Lambda(c0:+c1*einv)):*f
	return(f,f1,f0,v)
	}
	end

	//Now loop over Designs and produce overlap plots
	forvalues d=1(1)5{
     if (`d'==1) {
	  local alpha=0
	  local beta=1
	  local title="A. Design `d'"
	 }
	 else if (`d'==2) {
	  local alpha=0.15
	  local beta=0.7
	  local title="B. Design `d'"
	}
	 else if (`d'==3) {
	  local alpha=0.3
	  local beta=0.4
	  local title="C. Design `d'"
	}
	 else if (`d'==4) {
	  local alpha=0
	  local beta=0.4
	  local title="D. Design `d'"
	}
 	 else if (`d'==5) {
	  local alpha=0.6
	  local beta=0.4
	  local title="E. Design `d'"    
	}
	 mata: A=fig1(`alpha',`beta',1000)
	 mata: f =A[.,1]
	 mata: f1=A[.,2]
	 mata: f0=A[.,3]
	 mata: v =A[.,4]
	 getmata f f1 f0 v, replace
	 ren f1 f1_d`d'
	 ren f0 f0_d`d'
	 ren v v_`d'
	 drop f
	}

	* Figure 1: Design 1 and 2
	graph twoway ///
	(line f1_d1 v_1, lcolor(black) lpattern(solid) lwidth(thin)) ///
	(line f0_d1 v_1, lcolor(black) lpattern(shortdash)  lwidth(thin)) ///
	(line f1_d2 v_2, lcolor(gs9)   lpattern(solid) lwidth(thin)) ///
	(line f0_d2 v_2, lcolor(gs9)   lpattern(shortdash)  lwidth(thin)) ///
	, xlabel(0 0.2 0.4 0.6 0.8 1) title("A. Designs 1 and 2", size(small) color(black)) ///
	xtitle("Propensity Score") ytitle("Density") ///
	legend(order(1 "T=1" 2 "T=0") region(lcolor(none))) ///
	xscale(noline) yscale(noline) ///
	graphregion(color(white) fcolor(white))
	graph save Graph "$dir/S1.gph", replace

	* Figure 2: Design 3, 4 and 5 
	graph twoway ///
	(line f1_d3 v_3, lcolor(black) lpattern(solid) lwidth(thin)) ///
	(line f0_d3 v_3, lcolor(black) lpattern(shortdash)  lwidth(thin)) ///
	(line f1_d4 v_4, lcolor(gs9)   lpattern(solid) lwidth(thin)) ///
	(line f0_d4 v_4, lcolor(gs9)   lpattern(shortdash)  lwidth(thin)) ///
	(line f1_d5 v_5, lcolor(gs12)  lpattern(solid) lwidth(thin)) ///
	(line f0_d5 v_5, lcolor(gs12)  lpattern(shortdash)  lwidth(thin)) ///
	, xlabel(0 0.2 0.4 0.6 0.8 1) title("B. Designs 3, 4 and 5", size(small) color(black)) ///
	xtitle("Propensity Score") ytitle("Density") ///
	legend(order(1 "T=1" 2 "T=0") region(lcolor(none))) ///
	xscale(noline) yscale(noline) ///
	graphregion(color(white) fcolor(white))
	graph save Graph "$dir/S2.gph", replace

	graph combine "$dir/S1.gph" "$dir/S2.gph", scheme(s2mono) xsize(5) ysize(2) title("Figure 1: Frolich Propensity Score Conditional Densities", size(small))
	graph save Graph "$dir/frolich_designs.gph", replace 

//NSW overlap plot
	cd "$cd"
	cap program drop fig3
	program define fig3
	{
	 syntax , k(integer) a(real) b(real) title(string) ///
	 range1(string) range2(string) h1(real) h0(real)
	 drop _all
	 nswdgp, k(`k')
	 if ("`k'"=="1") {
	  local range1 "-2 22"
	  local range2 "0 20"
	  local bwidth=0.012
	 }
	 else if ("`k'"=="5") {
	  local range1 "-0.5 6"
	  local range2 "0 5.8"
	  local bwidth=0.01
	 }
	 local G=100
	 local GG=`G'-1
	 if (`GG'>_N) set obs `GG'
	 gen double x0=(_n-1)/(`GG'-1) in 1/`GG'
	 replace x0=(`a')+((`b')-(`a'))*x0
	 kdensity pX if T==0, bwidth(`h0') at(x0) gen(fhat0) nograph
	 kdensity pX if T==1, bwidth(`h1') at(x0) gen(fhat1) nograph
 	 gen zero=0

	 twoway ///
	 (line fhat1 x0, lcolor(black) lpattern(solid) lwidth(medium) yaxis(1)) ///
	 (line fhat0 x0, lcolor(black) lpattern(shortdash) lwidth(thin) yaxis(1)) ///
	 (scatter one  pX if T==1, ///
	 msymbol(triangle_hollow) mcolor(gs9) msize(small) yaxis(2) ///
	 yscale(range(`range1'))) ///
	 (scatter zero pX if T==0, ///
	 msymbol(circle_hollow) mcolor(gs9) msize(small) yaxis(2)), ///
	 legend(off) ///
	 ytitle("Density") ///
	 ytitle(, size(medsmall) margin(tiny) color(black)) ///
	 xtitle("Propensity Score", size(medsmall) margin(tiny) color(black)) ///
	 title("`title'", size(small) margin(tiny) color(black)) ///
	 ylabel(, axis(1)) ylabel(, axis(2) noticks nolabel) ///
	 yscale(range(`range2') noline axis(1)) yscale(noline axis(2)) ///
	 xlabel(0(0.2)1) xscale(noline) ///
	 graphregion(color(white) fcolor(white))
	 }
	 end

	set seed 987654321
	fig3, k(1) a(0) b(1) title("A. NSW (Bad Overlap)") range1("-2 22") range2("0 20") h1(0.01) h0(0.01)
	graph save Graph "$dir/S1.gph", replace

	set seed 987654321
	fig3, k(5) a(0) b(1) title("B. NSW (Good Overlap)") range1("-2 22") range2("0 20") h1(0.01) h0(0.01)
	graph save Graph "$dir/S2.gph", replace

	graph combine "$dir/S1.gph" "$dir/S2.gph", scheme(s2mono) xsize(5) ysize(2) title("Figure 3: NSW Propensity Score Conditional Densities", size(small))
	graph save Graph "$dir/nsw.gph", replace 

	graph combine "$dir/frolich_designs.gph" "$dir/frolich_curves.gph" "$dir/nsw.gph", cols(1) imargin(zero) xsize(5) ysize(6) graphregion(margin(zero))
    graph play "$cd/labels&lines.grec"

   graph save Graph "$dir/figure.gph", replace 
   capture graph export "$dir/figure.pdf", as(pdf) replace
   graph export "$dir/figure.eps", replace
   !epstopdf $dir/figure.eps	   

   
   //Edits for RESTAT typesetting
   //fig1
   graph use "$dir/frolich_designs.gph"
   graph play "$cd/labels&line_fig1.grec"
   graph play "$cd/labels&line_fig1_p2.grec"
   graph save "$dir/frolich_designs_edit.gph", replace
   graph export "$dir/frolich_designs_edit.eps", as(eps) preview(on) replace

   //fig2
   graph use "$dir/frolich_curves.gph"
   graph play "$cd/labels&line_fig2.grec"
   graph play "$cd/labels&line_fig2_p2.grec"
   graph play "$cd/labels&line_fig2_p3.grec"
   graph save "$dir/frolich_curves_edit.gph", replace
   graph export "$dir/frolich_curves_edit.eps", as(eps) preview(on) replace

   //fig3
   graph use "$dir/nsw.gph"
   graph play "$cd/labels&line_fig3.grec"
   graph play "$cd/labels&line_fig3_p2.grec"
   graph save "$dir/nsw_edit.gph", replace
   graph export "$dir/nsw_edit.eps", as(eps) preview(on) replace
   

   cap erase "$dir/S1.gph" 
   cap erase "$dir/S2.gph"
   cap erase "$dir/S1.eps" 
   cap erase "$dir/S2.eps"
   cap erase "$dir/frolich_designs.gph" 
   cap erase "$dir/frolich_curves.gph" 
   cap erase "$dir/nsw.gph"
   cap erase "$dir/frolich_designs.eps" 
   cap erase "$dir/frolich_curves.eps" 
   cap erase "$dir/nsw.eps"
   cap erase "$dir/frolich_designs.pdf" 
   cap erase "$dir/frolich_curves.pdf" 
   cap erase "$dir/nsw.pdf"
   cap erase "$dir/figure.eps"
   
   
