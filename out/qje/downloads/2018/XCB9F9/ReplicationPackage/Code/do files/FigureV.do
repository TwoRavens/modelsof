#delimit;

set seed 20160710;
local rounds = 500;

	foreach k in 2 3 {;
		gen tt_r_eq`k' = tt_r == `k';
		bootstrap _b, reps(`rounds') cl(club_id): ivqte Y (tt_r_eq`k') if (tt_r == 1 | tt_r == `k') & attrition == 0, q(.1(.1).9)  unordered (superstrata);
		cap drop beta4Q* se4Q* ;
		forvalues i = 1(1)9 { ;
          generate beta4Q`i' = _b[Quantile_`i'];
		  generate se4Q`i' = _se[Quantile_`i'];
        };

		preserve ;  
		collapse beta*Q* se*Q* ;
		  
		gen id=1;
		reshape long beta4Q se4Q, i(id) j(bip);

		forvalues x=4(1)4 { ;
			gen up`x'=beta`x'Q+1.65*se`x'Q ;
			gen lo`x'=beta`x'Q-1.65*se`x'Q ;
		} ;

		generate decile=bip ;
		drop bip ;
		gen zero=0 ;

		if `k' == 2 {;
			twoway (rcap up4 lo4 decile , lpattern(dash) lcolor(gs8) sort) (line beta4Q decile , msymbol(triangle) mcolor(black) lpattern(solid) lcolor(black) legend(off) xlabel(1(1)9) ), xtitle("Decile") ytitle("QTE on Output, {it:y}") ylabel(-200(200)400);
		} ;
		else if `k' == 3 { ;
			twoway (rcap up4 lo4 decile , lpattern(dash) lcolor(gs8) sort) (line beta4Q decile , msymbol(triangle) mcolor(black) lpattern(solid) lcolor(black) legend(off) xlabel(1(1)9) ), xtitle("Decile") ytitle("QTE on Output, {it:y}") ylabel(-200(200)400);

		};
		capture graph export "Output/FigureV_`k'.pdf", as(pdf) replace ;
		capture graph export "Output/FigureV_`k'.tif", as(tif) replace ;
		restore ;
	} ;

	foreach k in 3 4 {;
		gen treatment_type_0_`k' = treatment_type_0 == `k';
		bootstrap _b, reps(`rounds') cl(club_id): ivqte Y (treatment_type_0_`k') if (treatment_type_0 == 1 | treatment_type_0 == `k') & attrition == 0, q(.1(.1).9)  unordered (superstrata);
		cap drop beta4Q* se4Q* ;
		forvalues i = 1(1)9 { ;
          generate beta4Q`i' = _b[Quantile_`i'];
		  generate se4Q`i' = _se[Quantile_`i'];
        };

		preserve ;  
		collapse beta*Q* se*Q* ;
		  
		gen id=1;
		reshape long beta4Q se4Q, i(id) j(bip);

		forvalues x=4(1)4 { ;
			gen up`x'=beta`x'Q+1.65*se`x'Q ;
			gen lo`x'=beta`x'Q-1.65*se`x'Q ;
		} ;

		generate decile=bip ;
		drop bip ;
		gen zero=0 ;
		
		if `k' == 3 {;
			twoway  (rcap up4 lo4 decile , lpattern(dash) lcolor(gs8) sort) (line beta4Q decile , msymbol(triangle) mcolor(black) lpattern(solid) lcolor(black) legend(off) xlabel(1(1)9) ), xtitle("Decile") ytitle("QTE on Output, {it:y}") ylabel(-200(200)400) ;
		} ;
		else if `k' == 4 {;
			twoway  (rcap up4 lo4 decile , lpattern(dash) lcolor(gs8) sort) (line beta4Q decile , msymbol(triangle) mcolor(black) lpattern(solid) lcolor(black) legend(off) xlabel(1(1)9) ), xtitle("Decile") ytitle("QTE on Output, {it:y}") ylabel(-200(200)400) ;		
		};
		capture graph export "Output/SupFigureIII_`k'.pdf", as(pdf) replace ;
		capture graph export "Output/SupFigureIII_`k'.tif", as(tif) replace ;		
		restore ;
	} ;
