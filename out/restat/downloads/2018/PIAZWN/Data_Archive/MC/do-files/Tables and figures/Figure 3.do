*********************************************************
**Use the results obtained by running "Run_simulation" to 
**generate Figure3.
*********************************************************

cd "XXXX define path to folders XXXX/MC"


clear *
set more off
set mem 2000m

gen Power=.

forvalues R = 1(1)200 {

foreach B in 500 {
foreach N in 25 100     {

	foreach a_b in  "50_200"   {

		foreach c in 0.01  0.1 0.2   {
		
			forvalues Power=0(1)20 {
	
			  cap append using Results/`N'_`a_b'_`c'_`Power'_Round`R'.dta
			  
			  replace Power = `Power'/10 if Power==.
		
		}
		}
	}	
}
}
}


tab  Power c if N==25 
tab  Power if N==100

gen above=M_bin10>5

collapse (mean) rej* , by(N above Power c b)

la var Power "Effect Size"

la var reject_FP_5 "Bootstrap with heteroskedasticity correction"

la var reject_t  "t-test (true variance)"

set scheme s2mono




foreach N in 25 100 {

	foreach b in 200  {
	
		foreach c in "01" "1" "2" {
	
		twoway (scatter reject_FP_5 Power if N==`N' & b==`b' & above==1 & inrange(c,0.`c'-0.0001,0.`c'+0.0001), mcolor(gs4))  ///
			   (scatter reject_FP_5 Power if N==`N' & b==`b' & above==0 & inrange(c,0.`c'-0.0001,0.`c'+0.0001), mcolor(gs10))  ///
      		   (line reject_t Power if N==`N' & b==`b' & above==1 & inrange(c,0.`c'-0.0001,0.`c'+0.0001), lcolor(gs4) lpattern(solid)) ///
      		   (line reject_t Power if N==`N' & b==`b' & above==0 & inrange(c,0.`c'-0.0001,0.`c'+0.0001), lcolor(gs10) lpattern(solid)) ///
      		 , xscale(range(0 2))  xlabel(0(0.1)2) yscale(range(0 1.05))  ylabel(0(0.1)1)  graphregion(color(white)) ///
      		 legend(cols(2)) legend(label(1 "Bootstrap with correction") label(2 "Bootstrap with correction" )  label(3 "t-test (true variance)" ) label(4 "t-test (true variance)" )) legend(order(- "Above the median" - "Below the median"  1 2 3 4    ))
      		 
      		 
			graph export "Figures/Above_`N'_`b'_`c'.pdf", replace
			
		}
	}
}



