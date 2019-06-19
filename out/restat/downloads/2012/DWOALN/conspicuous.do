# delimit;

* the scheme for printing a graph: height 8, width 10.5;

*** initialize globals;
capture program drop initialize_globals; program define initialize_globals;
	global today = string(date("`c(current_date)'","DMY"),"%tdCCYYNNDD"); global today = "${today}"; // just for version
	global my_pwd "U:/User6/oh33/NBER/consp2010";
	global vindices_path "U:/User6/oh33/NBER/consp2010/vindex";
	cd $my_pwd; set mem 200m;
#delimit;
	global fandate "20100323"; global fanh "050"; * notice: "050" will translate to h=0.50 etc.;
	global yname "fc"; global xname "ltot";
	global fanversion "${fandate}allh$fanh${yname}${xname}";
*	global fanversion "${fandate}h$fanh${yname}${xname}";
	global usedata_fflie "../data/updated_ce_files/ffile0305.dta if fullyr==1"; // notice: since we use 8 quarters of data, "totwt" sums to a number that in itself is not meaningful. however, i verified that the relative size of the different sub-data-files is such that one can simply sum the weights, as the code currently does.
	global usedata_mfile "../data/updated_ce_files/mfile0305.dta";
	global vindices_version "20100304"; 
	global subgroup "_";
	global cpi_pathfile "U:/User6/oh33/stlouisfed/CPIAUCNS_processed.dta";
	global base_cpi "195.29167"; // this is cpi_q_a for yearq=20051.
end;

#delimit cr
*** read data file and prepare expenditure variables
capture program drop prepare_data 
program define prepare_data

	use $usedata_fflie, clear
	count

* see Harris and Sabelhaus (2005) (S&H) for details on variables.
* notice that in the following, omitted are three "historically" empty categories: toiletry (var(32)), housuppl (37), gambling (65).
	gen c1=foodhome
	gen c2=foodout /* notice that foodwork is left out */
	gen c3=tobacco
	gen c4=alcohol
	gen c5=niteclub
	gen c6=clothes /*   */

	gen c7=0  /*  */

	gen c8=tailors
	gen c9=jewel
	gen c10=hlthbeau
	gen c11=renthome+12*homeval2 /* notice homeval2 not in vars 23-69 */ 
	gen c12=rentoth
	gen c13=furnish
	gen c14=gas+elect+water /* notice that homefuel is left out */
	gen c15=telephon /*  */

	gen c16=0  /*  */

	gen c17=servants
	gen c18=drugs+orthop+doctors+hospital+helthins /* notice that nurs is left out */
	gen c19=busiserv
	gen c20=lifeins
	gen c21=autos
	gen c22=parts+carservs
	gen c23=gasolin /* notice that tolls is left out */
	gen c24=autoins
	gen c25=masstran+othtrans
	gen c26=airfare
	gen c27=books+pubs
	gen c28=recsport
	gen c29=othrec
	gen c30=highedu+lowedu+othedu 
	gen c31=charity
* these 31 (29) cats are constructed from vars 23-69 in S&H (but see comments above),
* the only exception being that 12*homeval2 (var(75)) is added.
* notice that foodwork+homefuel+nurs+tolls+toiletry+housuppl+gambling" (weighted by totwt) amount to 0.61% of exptot (notice: these are real figures; 10,400 obs). this figure is reported in the paper (notice though that January 2005 is missing in the data): "and together cover 99.4 percent of consumption expenditures in the data we use."

*** make it real :) 
	merge m:1 yearq using ${cpi_pathfile}, keep(match master)
	drop _m
	local i=1
	while `i'<=31 {
		gen nom_c`i' = c`i' // just in case we want to test it. these nominal values can be deleted.
		replace c`i' = c`i'/cpi_q_a*${base_cpi}
		local ++i
	} 

	#delimit; 
	gen exptotal=0; local i=1; while `i'<=31 {; replace exptot=exptot+c`i'; local ++i; }; 

	#delimit cr
	local i=1
	while `i'<=31 { 
		gen lc`i' = log(1+c`i')
		gen fc`i' = c`i'/exptot
		local i = `i' + 1
	}
	gen ltot = log(1+exptot)
	gen ftot = 1/exptot
end

*** merge data with Vindexes: 
capture program drop merge_vindices
program define merge_vindices
	merge using ${vindices_path}/${vindices_version}/Vindices${vindices_version}_all.dta /*,unique */
	ta _m
	drop _m
end

*** create Lux-Nec-index (that is: a luxury-necessity index) for each category: is its share going up or down?
* notice that this routine relies on fan variables to be either in logs (lc`i' and ltot) or PIGLOG (fc`i' and ltot)
capture program drop vis_lux
program define vis_lux
	capture gen luxurindexb$spec=.
	capture gen luxurindexf$spec=.
	capture gen f_temp=. /* f for fake (just kidding. for fraction, or share) */
	capture gen e_temp=. /* e for elasticity */
	local icat = 1
	while `icat' <=31 {
	 quietly{
		if      "$spec"=="lc" {
			replace e_temp=slopelc`icat'ltot
			replace f_temp = exp(pylc`icat'ltot - xxlc`icat'ltot)
		}
		else if "$spec"=="fc" {
			replace e_temp=1+((slopefc`icat'ltot)/(pyfc`icat'ltot))
			replace f_temp = pyfc`icat'ltot
		}
		else if "$spec"=="c" { /* this is a linear specification (in both variables) */
			replace e_temp=((xxc`icat'exptot)/(pyc`icat'exptot))*(slopec`icat'exptot)
			replace f_temp = (pyc`icat'exptot)/(xxc`icat'exptot)
		}
		su e_temp [w=binwt${spec}`icat'ltot] if $incbin
		replace luxurindexb$spec = r(mean) if ncats${subgroup}==`icat'
		replace luxurindexb$spec = . if ncats${subgroup}==`icat' & (`icat'==7 | `icat'==16) 			
		su f_temp [w=binwt${spec}`icat'ltot] if $incbin
		replace luxurindexf$spec = r(mean) if ncats${subgroup}==`icat'
		local ++icat
	 }
	}
	if "$save_vis_lux_vars" == "Yes" {
		preserve
		drop if ncats${subgroup}==.
		keep luxurindexb$spec catsb${subgroup} servi ser_catsb${subgroup} luxurindexf$spec ncats${subgroup}
		save Fan\vis_lux_vars${today}${fangr}h$fanh$yname$x_${subgroup}$iplot, replace
		restore
	}
		
	if "$influential_analysis" == "Yes" {
		local icat = 1
		while `icat' <=32 { // notice: when icat = 32 regression will include all observations.
			if `icat'==7 | `icat'==16 local ++icat
			foreach iserv in "" "servi" "servi ser_catsb${subgroup}" {
				qui reg luxurindexb$spec catsb${subgroup} `iserv' [w=luxurindexf$spec] if _n~=`icat'
				local inf_note = "OLS:`iserv' N=" + string(e(N)) + " R^2=" + string(round(e(r2),.01)) + " b=" + string(round(_b[catsb${subgroup}],.1)) + " p="
				qui test _b[catsb${subgroup}]=0
				local inf_note = "`inf_note'" + string(round(r(p),0.001))
				di "`icat' inf_note: `inf_note'"
			}
			local ++icat
		}
	}

*	plots with regression results as a note
	if "$outreg_results" == "Yes" {
		foreach iserv in "" "servi" "servi ser_catsb${subgroup}" {	
		  foreach ihom in "" { //  " if _n~=11" { // influential analysis just for housing (Hom)	
			qui reg luxurindexb$spec catsb${subgroup} `iserv' [w=luxurindexf$spec] `ihom'
			local note = "OLS: All `iserv' `ihom' : N=" + string(e(N)) + " R^2=" + string(round(e(r2),.01)) + " b=" + string(round(_b[catsb${subgroup}],.1)) + " p="
			qui test _b[catsb${subgroup}]=0
			local note = "`note'" + string(round(r(p),0.001))
			di "iplot: $iplot note: `note'"
			if      "`iserv'"=="servi" 						local tabser = "ser" 
			else if "`iserv'"=="servi ser_catsb${subgroup}" local tabser = "sercatsb"
			cap outreg2 using outreg2/tabRegLuxVis`tabser'${fanversion}${limitdata}_${today}, tex(frag nopretty) bdec(2) rdec(2) label ctitle("${fandate}${fangr}") $firstcol
		  }
		}
	}
	if "$reg_Service" == "Yes" reg luxurindexb$spec servi [w=luxurindexf$spec] // make sure this specification is comparable to the outreg regressions above.
	local tit = "(${iplot}) $ordinal quintile" // (`plotperc'%)"
	if $iplot == 0 local tit = "(A) All households" // (`plotperc'%)"
	if "$draw_graph" == "Yes" twoway ///
		(scatter luxurindexb$spec catsb${subgroup} [w=luxurindexf$spec] ///
				,msymbol(Oh) msize(large) /* mlwidth(thin) */ mcolor(gs11)) ///
		(scatter luxurindexb$spec catsb${subgroup} [w=luxurindexf$spec] if services==0 ///
				,msymbol(Oh) msize(large) mlwidth(thick) mcolor(gs11)) ///
		(scatter luxurindexb$spec catsb${subgroup} in 1/31 ///
				,msize(tiny) msymbol(none) mlabel(ncats3${subgroup}) mlabposition(0) mlabsize(vsmall)) ///
		(lfit luxurindexb$spec catsb${subgroup} [w=luxurindexf$spec], lpattern(shortdash)) ///
		, name($spec$iplot,replace) scheme(sj) ///
	 	title(`tit') note(`note') ///
		xtitle(Vindex) ytitle(Total Expenditure Elasticity) xlabel(.1(.1).8) xmtick(.1(.05).8) ///
		ylabel(0(1)3, angle(horizontal)) ymtick(-0.5(.1)3.5) legend(off)
end

*** run vis_lux and create combined graph
capture program drop run_vis_lux
program define run_vis_lux

	label var catsb${subgroup} "Vindex"
	classify_goods_services
	label var services "Service"
	gen ser_catsb${subgroup} = services*catsb${subgroup} // interaction term for regressions
	label var ser_catsb${subgroup} "Vindex $\times$ Service"
	global spec "$yname" /* "lc", "fc" or "c"; notice: "c" is linear in both vars! */
	cap drop sumbinwt
	
	if "$limitdata" == "onlyq4" { // this is for table by demographics, where we only look at 4th quintile. not currently used in the paper.
		global iplot = 4
		local max_iplot = 4
	}
	else if "$limitdata" == "onlyp10top95" { // 
		global iplot = 1095
		local max_iplot = 1095
	}
	else if "$limitdata" == "onlyall" { // without quintiles 
		global iplot = 0
		local max_iplot = 0
	}
	else {
		global iplot = 0	
		local max_iplot = 5
	}
	while $iplot <= `max_iplot' { 
	 if "$spec" == "c" global incbin "_n>= ${iplot}*6-5 & _n<=${iplot}*6" 
	 else {
		if      $iplot == 0 global incbin "1==1"
		else if $iplot == 1095 global incbin "_n>=9 & _n<=25"
		else if $iplot == 1 {
			global firstcol "append"
			global incbin "_n>=1 & _n<=11" 
			global ordinal "First"
		}
		else if $iplot == 2 { 
			global incbin "_n>=12 & _n<=15"
			global ordinal "Second"
		}
		else if $iplot == 3 { 
			global incbin "_n>=16 & _n<=18"
			global ordinal "Third"
		}						
		else if $iplot == 4 { 
			global incbin "_n>=19 & _n<=21"
			global ordinal "Fourth"
		}
		else if $iplot == 5 { 
			global incbin "_n>=22 & _n<=30"
			global ordinal "Fifth"
		}
	 }
/*
		* these globals are used by vis_lux (but are set outside this probram, see below)
		
		global draw_graph "Yes" // "No" "Yes" 
		global influential_analysis "No" // "No" "Yes" 
		global outreg_results "No" // "No" "Yes"
		global reg_Service = "No" // "No" "Yes" 
		global save_vis_lux_vars "Yes" // "No" "Yes" 
*/
		vis_lux
		su luxurindexb$spec [w=luxurindexf$spec] /* to make sure that weighted elasticities sum to 1 */
		global iplot = $iplot + 1
	}
	if "$draw_graph" == "Yes" {
		graph combine ${spec}0 ${spec}1 ${spec}2 ${spec}3 ${spec}4 ${spec}5, name("FigCorrQ${fanversion}", replace) altshrink cols(2) scheme(sj) xsize(6.5) ysize(8)
		graph export graphs/FigCorr${fanversion}v${vindices_version}_all_q_${today}.eps, logo(off) fontface(Times) replace
		graph export graphs/FigCorr${fanversion}v${vindices_version}_0_${today}.eps, name(${spec}0) logo(off) fontface(Times) replace
	}
end

#delimit;
*** the following Fan (1992) code is based on an example code that I got from fellow grad students at Princeton back in the day. i believe (but am not sure) it was originally written by Chris Paxson. i'm only stating this here in order to not implicitly claim credit that is not mine.

  k(z) = (15/16)(1-z^2)^2 if z<=1, where // quartic kernel
  z=(x-xg)/h
  xg is a point on the grid
  h is the bandwidth;

*** Fan (1992) locally-weighted regression;
#delimit;
cap prog drop fan;
prog def fan;
  **This program will have the following arguments;
  ** 1. Dependent variable (y), 2. Independent variable (x), 3. bandwidth (h),
     4. grid size (grid), 5. lower bound on grid (xl), 6. upper bound on,
     grid (xh),  7. "name" of dep variable;
  ** Each program argument is out into a macro, just so the program is
     easier to read;
  mac def y `1';
  mac def x `2';
  mac def h=`3';
  mac def grid=`4';
  mac def xl=`5';
  mac def xh=`6';
	mac def yname "`7'";
	mac def wt `8';

  **The program will loop through grid values of x running from xl to xh;
  qui gen step=($xh-$xl)/($grid-1); *step size;
  qui gen xg=$xl-step;              *initalize xg;
  qui gen k=.;                      *initialize kernel;
  qui gen z=.;                      *initialize z;
  qui gen py=.;                     *initialize py,i.e. m(x);
  qui gen slope=.;                  *initialize slope, i.e. m'(x);
  qui gen nobs=.; qui gen wobs=.;   **initialize number of obs in regression; *and weighted measure of obs;
  qui gen xx=.;                     *initialize value of xg that is kept;
  qui gen count=0;                  *initialize counter from 1 to gridsize;
  qui gen wgt=0; qui gen binwt=.;	*10/23/2004;
	qui gen conf1=.; qui gen conf2=.; *3/23/07;

  mac def cc=1;                 *counter to run through the grid;
  while $cc<=$grid{;
		qui replace wgt = 0;
    qui replace xg=xg+step;              *update xg;
		qui replace wgt = $wt if $x>xg-(step/2) & $x<=xg+(step/2); * we sum together all the weights of points around the current xg, and this will be the weight for this value-point.; 
		qui egen dum2=sum(wgt)	;	
		qui replace binwt=dum2 if _n==$cc; drop dum2;
    qui replace z=($x-xg)/$h;                *update z;
    qui replace k=(15/16)*((1-(z^2))^2)*$wt if -1<=z & z<=1;  *create WEIGHTED kernel;
    qui replace k=. if z>1 | -1>z;
    egen dum=count(k); egen dum3=sum(k);
    qui reg $y $x [weight=k] if k~=.;      *run regression;
    qui cap replace py=_b[_cons]+_b[$x]*xg if _n==$cc;
              *this stores predicted value in cc'th row of the data;
    qui cap replace slope=_b[$x] if _n==$cc;
*		for confindence intervals;
		local locxg = xg[1]; * just b/c xg is a var, and i need a scalar;
		qui lincom _cons + `locxg'*$x; 
		local interval = invttail(r(df),0.025)*r(se);
		qui replace conf1=r(estimate) - `interval' if _n==$cc;
		qui replace conf2=r(estimate) + `interval' if _n==$cc;
	
    qui cap replace xx=xg if _n==$cc; **stores xg as xx in ccth row;
    qui cap replace nobs=dum if _n==$cc; drop dum;
    qui cap replace wobs=dum3 if _n==$cc; drop dum3;
    qui cap replace count=$cc if _n==$cc; **stores counter;
    mac def cc=$cc+1;
  };
	keep if _n<=$grid;
	gen bwidth=$h;
	keep py slope xx bwidth nobs wobs binwt conf1 conf2;
	rename py py$y$x; rename xx xx$y$x; rename slope slope$y$x; rename nobs nobs$y$x; rename wobs wobs$y$x; rename binwt binwt$y$x;
	rename conf1 conf1$y$x; rename conf2 conf2$y$x;
	cap merge using Fan\fan${today}${fangr}h$fanh$yname$x; cap ta _m; cap drop _merge;
	save Fan\fan${today}${fangr}h$fanh$yname$x, replace;
end;

** 1. Dependent variable (y), 2. Independent variable (x), 3. bandwidth (h),
   4. grid size (grid), 5. lower bound on grid (xl), 6. upper bound on
   grid (xh),  7. "name" of dep variable, 8. weight;

# delimit;
cap program drop run_fan;
program def run_fan;
	cap erase Fan\fan${fanversion};
	local i =1; local numcats = 31;
	if "$yname"=="fsgc" local numcats = 43;
	while `i' <=`numcats' {; di `i';
		preserve;
		gen xl = $xl ; gen xh = $xh ; gen h = $h ;
		gen grid = 30;
		fan ${yname}`i' $xname h grid xl xh "${yname}" totwt;
		restore;
		local ++i;
	};
end;

#delimit;
*** merge fan file; 
cap program drop merge_fan; program def merge_fan;
	merge using Fan/fan$fanversion; ta _m; drop _merge;
end;

* this program (draw_EC) is very useful, but is not currently used in the paper.; 
#delimit;
*** draw scatterplots, fan plots, and linear fits (all weighted);
cap program drop draw_EC; * draw Engel curves; program def draw_EC;
* for making the scatterplots less resource-intensive, draw only 1 in 5 points (randomly chosen);
	cap drop random;
	set seed 12344321; gen random=.; replace random=1 if uniform()<0.2; 
	if      "$yname"=="lc" {; 
		local props="xlabel(8(1)13, grid glcolor(gs8)) ylabel(0(1)10, glcolor(gs8)) xsize(1.1) ysize(2) aspect(2)";
		local lfitrange=",range(9 .)"; }; 
	else if "$yname"=="fc" | "$yname"=="fsgc" {;
		local props="xlabel(8(1)13, grid glcolor(gs8)) ylabel(#10, glcolor(gs8)) xsize(1) ysize(2) aspect(2)";
		local lfitrange=",range(9 .)"; }; 
	else if "$yname"=="c" {;
		local props="xlabel(0(50000)100000, format(%9.0gc)) xmtick(0(10000)130000, grid glcolor(gs8)) ylabel(#5, nogrid) ymtick(#10, grid glcolor(gs8)) xsize(1) ysize(2) aspect(2)";
		local lfitrange=",range(6000 130000)"; }; 
	local i =1; 
	local numcats = 31; if "$yname"=="fsgc" local numcats = 43; 
	while `i' <=`numcats' {; if `i'==7 | `i'==16 local ++i;
		local tit3=ncats3[`i']; local tit4= ncats4[`i']; local tit="`tit3' (`tit4')";
* 	for getting rid of top percentile or other extreme values in case of "fc" or "c";
		preserve;
		if "$yname"=="fc" | "$yname"=="fsgc" {; 
			egen percentiles=cut($yname`i'),group(100); replace random=0 if perce==99; };
		if "$yname"=="c" {; 
			egen percentiles=cut($yname`i'),group(100); replace random=0 if perce>=98; 
			replace random=0 if exptot> 130000; };
* 	notice: weights are totwt;
		twoway (scatter $yname`i' $xname [pw=totwt] if random==1, msize(0.01) jitter(7))
			(scatter py$yname`i'$xname xx$yname`i'$xname [pw=binwt$yname`i'$xname], msize(0.2) c(l)) 
			(scatter conf1$yname`i'$xname conf2$yname`i'$xname xx$yname`i'$xname, msymbol(i i) c(l l) lp(dash dash)) 
			(lfit $yname`i' $xname [pw=totwt] `lfitrange'), /* nodraw */ 
			`props'
			xtitle("") ytitle("") title("`tit'") legend(off) name($yname`i'$xname,replace) /* scheme(sj) */;
			count if random==1;restore;
		local ++i;
	};
	graph combine ${yname}1$x ${yname}2$x ${yname}3$x ${yname}4$x ${yname}5$x ${yname}6$x       ${yname}8$x ${yname}9$x ${yname}10$x
				${yname}11$x ${yname}12$x ${yname}13$x ${yname}14$x ${yname}15$x            ${yname}17$x ${yname}18$x ${yname}19$x ${yname}20$x
				${yname}21$x ${yname}22$x ${yname}23$x ${yname}24$x ${yname}25$x ${yname}26$x ${yname}27$x ${yname}28$x ${yname}29$x ${yname}30$x
				${yname}31$x,             cols(6) altshrink iscale(1.5) xsize(7.5) ysize(10)
/*			title("") subtitle("log-Engel Curves (CEX)")
				note("Scatter plots, locally-weighted regressions, and linear fits are all weighted.") scheme(sj) */;
*				fc31$x, holes(7 16) cols(6) /* scheme(sj) */;
	graph export graphs/Fig29combined${fanversion}_${today}.eps, logo(off) fontface(Times) replace;
	graph save graphs/Fig29combinedFan${fanversion}_${today};
	if "$yname"=="fsgc" {;
		graph combine ${yname}32$x ${yname}33$x ${yname}34$x ${yname}35$x ${yname}36$x ${yname}37$x ${yname}38$x ${yname}39$x ${yname}40$x
				${yname}41$x ${yname}42$x ${yname}43$x , cols(6) altshrink iscale(1.5) xsize(7.5) ysize(10);
		graph export graphs/Fig29combined${fanversion}_b_${today}.eps, logo(off) fontface(Times) replace;
		graph save graphs/Fig29combinedFan${fanversion}_b_${today};
	};
end;

#delimit;
********************************
*Figure29ECs (figures 2 and 3 in the paper)
********************************;
*** this is almost a stand-alone: needs merge_vindices (which in turn needs $vindices_version) for plot titles, but that's all it needs.;
*** global curvetype = "shares" or "" for printing shares or levels ECs. or "e" for graphic elasticities.;
cap program drop Figure29ECs; program def Figure29ECs;
#delimit;
	use Fan/fan${fanversion}.dta; 
	merge_vindices;
	capture gen e_temp=.;
#delimit;
	local i=1; while `i'<=31 {; if `i'==7 | `i'==16 local ++i;
		* prepare for a linear EC presentation (lin-lin);
		gen lin_xxfc`i' = exp(xxfc`i'ltot);
		gen lin_pyfc`i' = (pyfc`i'ltot)*(lin_xxfc`i');
		if "$curvetype" == "shares" gen pyfc100_`i' = pyfc`i'ltot * 100;
		local tit3=ncats3${subgroup}[`i']; local tit4= ncats4${subgroup}[`i']; local tit="`tit3' (`tit4')";
		if "$curvetype" == "shares" twoway (scatter pyfc100_`i'  lin_xxfc`i', msymbol(i) c(l) sort msize(small small) ) 
			, 
			xlabel(0(50000)100000, format(%9.0gc)) xmtick(0(10000)150000, grid /*glcolor(gs8)*/) 
			ylabel(#4, format(%9.1gc) /* alternate */ angle(horizontal) ) ylabel(0,add)
			/* xsize(1) ysize(1.7) aspect(1.7) */
			xtitle("") ytitle("") title("`tit'") legend(off) name(EC`i',replace) scheme(sj);
		else if "$curvetype" == "e" {;
		   if "$yname"=="fc" {;
			replace e_temp=1+((slopefc`i'ltot)/(pyfc`i'ltot));
			twoway (scatter e_temp  lin_xxfc`i', msymbol(i) c(l) sort msize(small small) ) 
			, 
			xlabel(0(50000)100000, format(%9.0gc)) xmtick(0(10000)150000, grid /*glcolor(gs8)*/) 
			ylabel(-2(2)8, format(%9.0gc) /* alternate */ angle(horizontal)) ytick(-2(1)8, grid) ymtick(-2(0.5)8)  /* ylabel(0,add) */
			yline(1, lp(dash) lc(gs6))
			/* xsize(1) ysize(1.7) aspect(1.7) */
			xtitle("") ytitle("") title("`tit'") legend(off) name(EC`i',replace) scheme(sj);
		   };				
		};			
		else twoway (scatter lin_pyfc`i'  lin_xxfc`i', msymbol(i) c(l) sort msize(small small) ) 
			, 
			xlabel(0(50000)100000, format(%9.0gc)) xmtick(0(10000)150000, grid /*glcolor(gs8)*/) 
			ylabel(#3, format(%9.0gc) alternate /*angle(horizontal)*/) ylabel(0,add)
			/* xsize(1) ysize(1.7) aspect(1.7) */
			xtitle("") ytitle("") title("`tit'") legend(off) name(EC`i',replace) scheme(sj);
		local ++i;
	};
	graph combine EC1 EC2 EC3 EC4 EC5 EC6 EC8 EC9 EC10 EC11 EC12 EC13 EC14 EC15 EC17 EC18 EC19 EC20
		 EC21 EC22 EC23 EC24 EC25 EC26 EC27 EC28 EC29 EC30 EC31,
     rows(8) scheme(sj) xsize(6.5) ysize(8);
#delimit;
	graph export graphs/Figure29ECs${fanversion}_${curvetype}_${today}.eps, logo(off) fontface(Times) replace;
	graph save graphs/Figure29ECs${fanversion}_${curvetype}_${today};
end;

#delimit cr
****************************************************
*   create FigureHist (figure 1 in the paper)
****************************************************
* notice: this histogram shows the average, over all (weighted) 
* individuals, share of each expenditure. this is different from aggregating each category (over all 
* weighted individuals) and showing it as a share of aggregated exptot.
cap program drop create_fig_hist
program def create_fig_hist
	cap drop catpercent1 wtcats // notice that the "1" is added by svmat.
	qui mean fc* [w=totwt]
	matrix c = e(b)'
	so ncats${subgroup}
  svmat double c, name(catpercent)
	replace catpercent=100*catpercent
	gen wtcats=int(100000*catpercent) /* b/c hist wouldn't allow aweights; fweights has to be integer. */
	classify_goods_services
	twoway ///
		(hist catsb${subgroup} [fw=wtcats], percent w(.1) start(.1) /* bcolor(*.15) blcolor(*0) */ color(*.15) lwidth(none)) ///
		(dropline catpercent catsb${subgroup} if ncats${subgroup}~=7 & ncats${subgroup} ~=16 & services==0, msymbol(O) msize(*1.5) mlabel(ncats3_) mlabposition(12) mlabsize(vsmall) /* mlabangle(60) */ mlabgap(*2)) ///
		(dropline catpercent catsb${subgroup} if ncats${subgroup}~=7 & ncats${subgroup} ~=16 & services==1, msymbol(Oh) msize(*2) mlabel(ncats3_) mlabposition(12) mlabsize(vsmall) /* mlabangle(60) */ mlabgap(*2)) ///
		,xtitle(Vindex) ytitle(Percent of Total Expenditure) xlabel(.1(.1).8) xmtick(.1(.05).8) ///
		ylabel(0(5)35, angle(horizontal)) ymtick(0(1)35) yline(1 2 3 4, lstyle(grid)) ///
		legend(off) ///
		/* title("Consumption Expenditures and Visibility") */ name(Figure1e, replace)  scheme(sj) 
	
	graph display, xsize(5.2) ysize(6.5)
	graph export graphs/FigureHist_${today}.eps, logo(off) fontface(Times) replace
end

cap program drop classify_goods_services
program def classify_goods_services
	cap gen services=0
	replace services=0
	replace services=1 if inlist(_n, 8,10,12,14,15,17,18,19,20)
	replace services=1 if inlist(_n, 22,24,25,26,29,30,31) 
end

cap program drop merge_mfile 
program def merge_mfile
	count
	merge 1:m newid using ${usedata_mfile}
	ta _m
	drop _m
	count
	keep if fullyr==1
	count
	byso newid: keep if relation==1
	count
* notice that there are 79 duplicates (10,479-10,400), or more specifically there are 73 duplicates and 3 "triplicates" (my word), which means 79 extra obs.
* the extra observations are identifiable in the data (e.g., their "occ" is missing). 
	drop if occ==.
	count
end

cap program drop find_subgroups_totexp // this bit of code is not used in the paper, but it helps to see what the distributions look like.
program def find_subgroups_totexp
	tabstat exptot ltot, stats(n p1 p5 p10 p25 p50 p75 p90 p95 p99)
	tabstat exptot ltot, stats(n p1 p50 p99), if age<50
	tabstat exptot ltot, stats(n p1 p50 p99), if age>=50
	tabstat exptot ltot, stats(n p1 p50 p99), if marital==1
	tabstat exptot ltot, stats(n p1 p50 p99), if marital~=1
	tabstat exptot ltot, stats(n p1 p50 p99), if race==2
	tabstat exptot ltot, stats(n p1 p50 p99), if race~=2
// what we learn is that if we want to create Fan for all subgroups based on the same income range, and we don't 
// want any subgroup's 2nd or 99th percentile to lie inside the range, we should take 10th to 95th 
// percentile of the total population.
// notice that this is not weighted (for substantive reasons).
end



/* 

a list of progs in this file so far:
initialize_globals
prepare_data
merge_vindices
* vis_lux // run by run_vis_lux
run_vis_lux
* fan // run by run_fan
run_fan
merge_fan // only necessary if run_fan is not run
draw_EC // not currently used
Figure29ECs
create_fig_hist
classify_goods_services // run by run_vis_lux and by create_fig_hist
merge_mfile
find_subgroups_totexp // not used for paper, but useful to look at.

* to run the whole thing (in a reasonable order):;
#delimit;
set more off;
initialize_globals; prepare_data; 
*run_fan; *not necessary if file is already created, as it takes a long time to run; 
merge_fan; 
*merge_vindices; *needed here for category titles for draw_EC;
*draw_EC; *only if i want to look at EC's;
run_vis_lux;
*Figure29ECs; *only for that figure;
*create_fig_hist; *only for that histogram;

*/

*** code for creating regression tables (tables 4 and 5 in the paper).

#delimit cr
cap program drop create_reg_tables 
program def create_reg_tables

	*** set globals for (run_)vis_lux

*	global limitdata "" // "onlyp10top95" // "onlyall" // "onlyq4" // this one is now set outside this code
	global draw_graph "No" // "Yes" // "No" 
	global influential_analysis "No" // "No" /* "Yes" */
	global outreg_results "Yes" //"Yes" // "No" 
	global reg_Service = "No" // "Yes" // "No"
	global save_vis_lux_vars "Yes" // "No" // "Yes"


	foreach ivindex in "va" { // "vpr" "vrc" "vyg" "vol" "vmr" "vmN" "vbl" "vbN" { // to add the 8 demographically-based vindices
		global firstcol "replace" /* "append" */ // also for (run_)vis_lux
		foreach idemog in $demog_list { 
			clear
			clear matrix
			initialize_globals 
			qui prepare_data
			merge_mfile
			global p10p95 "No" // "Yes" // no longer using this.
		
			if "`idemog'" == "All" {
				global fangr "all"

*** notice the following is only done for "All"; other demographic subgroups use the _same_ cutoffs to be comparable.			
				
				tabstat exptot ltot,stats(p1 p10 p95 p99) save // notice: not weighted. but that's what we want: to get rid of the extreme 1% in terms of observations.
				matrix matpercentiles = r(StatTotal)
				capture drop percentiles*
				svmat double matpercentiles, name(percentiles)
				if "$p10p95"~="Yes" {
					if "$yname"=="c" {
						global xl = percentiles1[1]
						global xh = percentiles1[4]
						global h = ${fanh}*200 
					}
					else {
						global xl = percentiles2[1]
						global xh = percentiles2[4]
						global h = ${fanh}/100
					}
				}
				else {
					if "$yname"~="c" {
						global xl = percentiles2[2]
						global xh = percentiles2[3]
						global h = ${fanh}/100 
					}
				}
				di "xl: " $xl "    xh: " $xh "    h: " $h
			}
			else if "`idemog'" == "Young" {
				keep if age<50
				global fangr "be50"
			}
			else if "`idemog'" == "Old" {
				keep if age>=50
				global fangr "up50"
			}
			else if "`idemog'" == "Married" {
				keep if marital==1
				global fangr "married"
			}
			else if "`idemog'" == "Non-mar" {
				keep if marital>1 & marital <=5 // the &... isn't necessary, but just in case, for future data.
				global fangr "non_mar"
			}
			else if "`idemog'" == "Black" {
				keep if race==2
				global fangr "black"
			}
			else if "`idemog'" == "Non-bla" {
				keep if race~=2
				global fangr "non_bla"
			}
			global fanversion "${fandate}${fangr}h$fanh${yname}${xname}"
			$run_fan // only if wasn't run before.
			merge_fan

			if      "`ivindex'" == "va"  global subgroup "_"  // va for Vindex All
			else if "`ivindex'" == "vbl" global subgroup "black" 
			else if "`ivindex'" == "vbN" global subgroup "non_black" 
			else if "`ivindex'" == "vmr" global subgroup "married" 
			else if "`ivindex'" == "vmN" global subgroup "non_married" 
			else if "`ivindex'" == "vyg" global subgroup "be50" 
			else if "`ivindex'" == "vol" global subgroup "up50" 
			else if "`ivindex'" == "vrc" global subgroup "hi_inc" 
			else if "`ivindex'" == "vpr" global subgroup "lo_inc" 
			global vindices_version "20100304"	
			merge_vindices
			global fanversion "`ivindex'_${fandate}h$fanh${yname}${xname}" // notice this is a bit of an abuse of the var "fanversion" b/c now it includes details about the vindex. but since at this point fan regressions were already run and merged, it is only used for saving tables and graphs. also notice that it can't include "fangr" b/c then for table 5 in the paper it will create many (outreg2) mini-tables. so one should remember which data it's based on.
			run_vis_lux
			global firstcol "append" // after running run_vis_lux for the first time.
		}
	}
end

*** this prog performs demographic anasis for section 5.2 of the paper. 
* it performs tests for equality of coefficients, for different elasticities but the same full-sample Vindex.
* to run it: run initialize_globals first. other than that, it's a standalone (assuming Fan estimates were created).

global vix_lux_vars_version "20100326"
cap program drop demog_analysis 
program def demog_analysis

	use Fan/vis_lux_vars${vix_lux_vars_version}allh$fanh$yname$x_${subgroup}1095, clear
	rename luxurindexbfc luxurindexbfc_all_1095
	rename luxurindexffc luxurindexffc_all_1095
	
	foreach ifangr in "be50" "up50" "married" "non_mar" "black" "non_bla" {
		merge 1:1  ncats_ catsb_ services ser_catsb_ /// 
			using Fan/vis_lux_vars${vix_lux_vars_version}`ifangr'h$fanh$yname$x_${subgroup}1095
		ta _m
		drop _m
		rename luxurindexbfc luxurindexbfc_`ifangr'_1095
		rename luxurindexffc luxurindexffc_`ifangr'_1095
		
	}
	reshape long luxurindexbfc_ luxurindexffc_, i(ncats) j(fangr) string
	
	xi i.fangr*catsb,pre(cats) noomit	
*	for panel (C): create a service*demographic group, and service*demographic group*vindex interactions
	local i=1
	while  `i'<=7 {
		gen catsfaXbXser_`i' = catsfanXcatsb_`i'*services
		gen catsfaXser_`i'   = catsfangr_`i'*services
		local ++i
	}
* 1 all 2 be50 3 black 4 married 5 non_bla 6 non_mar 7 up50

	foreach iclust in "" "cluster(ncats)" {
		foreach iserv in "" "services" "catsfaXser*" "catsfaX*" { // 1st regression: panel A (w/ or w/o same constant across demogs; 2nd: panel B same services dummy across demogs; 3rd: panel B, individual services dummy; 4th: panel C, separate services dummy and services*vindex interactions.
			foreach isameconst in "yes" "no" {
				if "`isameconst'"=="no" {
					local regressors = "catsfan* [w=luxurindexf],noconst"
					local testcoeffs = "catsfanXcatsb_ catsfangr_"
				}
				else {
					local regressors = "catsfanXcatsb* [w=luxurindexf],"
					local testcoeffs = "catsfanXcatsb_"
				}
				reg luxurindexb `iserv' `regressors' `iclust' 
				foreach icoeff in `testcoeffs' {
					test `icoeff'1 = `icoeff'2 = `icoeff'3 = `icoeff'4 = `icoeff'5 = `icoeff'6 = `icoeff'7
					test `icoeff'2 = `icoeff'7 // age
					test `icoeff'3 = `icoeff'5 // race
					test `icoeff'4 = `icoeff'6 // marital status	
				}
			}
		}
	}
end


/*
*** to run create_reg_tables:

*** Table 4:

set more off
global limitdata "" // "onlyp10top95" // "onlyall" // "onlyq4" // ""
global demog_list `" "All" "'
global run_fan "" // "run_fan" // "" // only if wasn't run previously on data
create_reg_tables

*** Table 5:

set more off
global limitdata "onlyp10top95" // "onlyall" // "onlyq4" // "" // notice that any of these (e.g. "onlyall") makes the code only run once, rather than break it down by 5 quintiles, which it does when $limitdata = "".
global demog_list `" "All" "Young" "Old" "Married" "Non-mar" "Black" "Non-bla" "'
global run_fan "" // "run_fan" // "" // only if wasn't run previously on data
create_reg_tables
*/

*** this proc performs demographic anasis for section 5.3.2 and 5.3.3. 
* it performs tests for equality of coefficients, for full-sample elasticity but different group-based vindices.
* to run it: run initialize_globals first. other than that, it's a standalone (assuming Fan estimates were created).

global vix_lux_vars_version "20100326"
cap program drop demog_analysis_5_3_2 // this is used for sections 5.3.2 and 5.3.3
program def demog_analysis_5_3_2

	use Fan/vis_lux_vars${vix_lux_vars_version}allh$fanh$yname$x_${subgroup}1095, clear
	rename luxurindexbfc luxurindexbfc_all_1095
	rename luxurindexffc luxurindexffc_all_1095
	
	foreach ifangr in "be50" "up50" "married" "non_mar" "black" "non_bla" {
		merge 1:1  ncats_ catsb_ services ser_catsb_ /// 
			using Fan/vis_lux_vars${vix_lux_vars_version}`ifangr'h$fanh$yname$x_${subgroup}1095
		ta _m
		drop _m
		rename luxurindexbfc luxurindexbfc_`ifangr'_1095
		rename luxurindexffc luxurindexffc_`ifangr'_1095
		
	}
	merge 1:1 ncats_ catsb_ using ${vindices_path}/${vindices_version}/Vindices${vindices_version}_all.dta /// notice: merging on ncats_ is enough.
		, keepusing(catsb*)
	ta _m
	drop _m

	reshape long catsb, i(ncats) j(subgr) string
	
	xi i.subgr*catsb,pre(cats) noomit	
*	for panel (C): create a service*demographic group, and service*demographic group*vindex interactions
	local i=1
	while  `i'<=9 {
		gen catssuXbXser_`i' = catssubXcatsb_`i'*services
		gen catssuXser_`i'   = catssubgr_`i'*services
		local ++i
	}
* 1 _ 2 be50 3 black 4 hi_inc 5 lo_inc 6 married 7 non_black 8 non_married 9 up50 
** 1 all 2 be50 3 black 4 married 5 non_bla 6 non_mar 7 up50

	foreach isubgr in "all" "be50" "up50" "married" "non_mar" "black" "non_bla" {
		di "Subgroup: `isubgr'"
		foreach iclust in "cluster(ncats)" { // previously (to look also at non-clustered): "" "cluster(ncats)" {
			foreach iserv in "" "services" "catssuXser*" "catssuX*" { // 1st regression: panel A (w/ or w/o same constant across demogs; 2nd: panel B same services dummy across demogs; 3rd: panel B, individual services dummy; 4th: panel C, separate services dummy and services*vindex interactions.
				foreach isameconst in "yes" "no" {
					if "`isameconst'"=="no" {
						local regressors = "catssub* [w=luxurindexffc_`isubgr'],noconst"
						local testcoeffs = "catssubXcatsb_ catssubgr_"
					}
					else {
						local regressors = "catssubXcatsb* [w=luxurindexffc_`isubgr'],"
						local testcoeffs = "catssubXcatsb_"
					}
					reg luxurindexbfc_`isubgr' `iserv' `regressors' `iclust' 
					foreach icoeff in `testcoeffs' {
						test `icoeff'1 = `icoeff'2 = `icoeff'3 = `icoeff'4 = `icoeff'5 = `icoeff'6 = `icoeff'7 = `icoeff'8 = `icoeff'9
						test `icoeff'2 = `icoeff'9 // age
						test `icoeff'3 = `icoeff'7 // race
						test `icoeff'4 = `icoeff'5 // income
						test `icoeff'6 = `icoeff'8 // marital status	
					}
				}
			}
		}
	}
end
