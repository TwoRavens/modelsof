
*** THE FOLLOWING COMMANDS REPLICATE MODELS 1 AND 2 IN TABLE II ***

probit cwmid relcap relexcap dem_low depend_lo cwpceyrs cwpceyrs2 cwpceyrs3 if pol_rel == 1, robust
probit cwmid inparity_exprep inprep_exparity sym_prepprep asym_prepprep dem_low depend_lo cwpceyrs cwpceyrs2 cwpceyrs3 if pol_rel == 1, robust



*** THE FOLLOWING COMMANDS CREATE FIGURE 1 ***

#delimit ;
probit cwmid relexcap relcap dem_low depend_lo cwpceyrs cwpceyrs2 cwpceyrs3 if pol_rel == 1, robust ;
preserve ; 
drawnorm MG_b1-MG_b8, n(10000) means(e(b)) cov(e(V)) clear ;

postutil clear ;

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 using simpower1 , replace ;

noisily display "start" ;

local a=0 ; 
while `a' <=1 { ;

	{ ; 

	scalar h_DemLo=-3.354 ;
	scalar h_DepLo=.002 ;
	scalar h_PceYrs1=28.72 ;
	scalar h_PceYrs2=1746.60 ;
	scalar h_PceYrs3=151112.2 ;
	scalar h_constant=1 ;

	generate x_betahat0 = MG_b1*(`a')
			+MG_b2*(.151)
			+MG_b3*h_DemLo
			+MG_b4*h_DepLo
			+MG_b5*h_PceYrs1
			+MG_b6*h_PceYrs2
			+MG_b7*h_PceYrs3
			+MG_b8*h_constant ;  


	generate x_betahat1 = MG_b1*(.594)
			+MG_b2*(`a')
			+MG_b3*h_DemLo
			+MG_b4*h_DepLo
			+MG_b5*h_PceYrs1
			+MG_b6*h_PceYrs2
			+MG_b7*h_PceYrs3
			+MG_b8*h_constant ;  


	gen prob0=normal(x_betahat0) ;
	gen prob1=normal(x_betahat1) ;

	egen probhat0=mean(prob0) ;
	egen probhat1=mean(prob1) ;

	egen diffhat0=mean(diff0) ;


	tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 ;


	_pctile prob0, p(5,95) ;
	scalar `lo0'=r(r1) ;
	scalar `hi0'=r(r2) ;

	_pctile prob1, p(5, 95) ;
	scalar `lo1'=r(r1) ;
	scalar `hi1'=r(r2) ;


	scalar `prob_hat0'=probhat0 ;
	scalar `prob_hat1'=probhat1 ;


	post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat0') (`diff_lo0') (`diff_hi0') ;

	} ;

	drop x_betahat0 x_betahat1 prob0 prob1 probhat0 probhat1 ;

	local a= `a' + .01 ;

	display "." _c ;

	} ;

display"" ;
postclose mypost ;


#delimit ;
use simpower1, clear ;


gen MV1 = (_n-1) * .01 ;


#delimit ;
graph twoway line prob_hat0 MV, clwidth(medium) clcolor(black)
	|| line lo0 MV, clpattern(dash) clwidth(thin) clcolor(black)
	|| line hi0 MV, clpattern(dash) clwidth(thin) clcolor(black) 
	|| ,
		yline(0)
		xlabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(2.5)) 
		ylabel(0 .01 .02 .03 .04 .05 .06, labsize(2.5)) 
		legend(rows(2) size(small) order(1 2) label(1 "Relative External Power") label(2 "90% CI"))  
		subtitle("External Capabilities", size(3))
		xtitle("Relative External Power",size(3))
		ytitle("Pr(Dispute)",size(3))
		xsca(titlegap(2))
		ysca(titlegap(3)) ;

graph save Graph "C:\prob1.gph", replace ;


#delimit ;
graph twoway line prob_hat1 MV, clwidth(medium) clcolor(black)
	|| line lo1 MV, clpattern(dash) clwidth(thin) clcolor(black)
	|| line hi1 MV, clpattern(dash) clwidth(thin) clcolor(black) 
	|| ,
		yline(0)
		xlabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(2.5)) 
		ylabel(0 .01 .02 .03 .04 .05 .06, labsize(2.5)) 
		legend(rows(2) size(small) order(1 2) label(1 "Relative Internal Power") label(2 "90% CI"))  
		subtitle("Internal Power", size(3))
		xtitle("Relative Internal Power",size(3))
		ytitle("Pr(Dispute)",size(3))
		xsca(titlegap(2))
		ysca(titlegap(3)) ;

graph save Graph "C:\prob2.gph", replace ;



#delimit ;
graph combine "C:\prob1.gph"
	"C:\prob2.gph", col(2)
	title("Figure 1. Predicted Probability of a Dispute as a Function of Internal" 
		"and External Power" , size(3.5) color(black) span) ;






