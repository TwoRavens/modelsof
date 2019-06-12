clear all
set more off
#delimit;
set excelxlsxlargefile on;
set type double;

*move one of the dataset files to the main folder;

import excel dataset.xlsx, sheet("Sheet1") clear;

qui rename A time;
qui rename B p;
qui rename C That;
qui rename D w;
qui rename E theta;
qui rename F f;
qui rename G e;
qui rename H b;
qui rename I u;
qui rename J phi;
qui rename K T;
qui rename L That_innovation;
qui rename M s;


tset time, monthly;

qui gen logb=log(b);  
qui gen logv=log(theta*u);
qui gen logp=log(p);
reg logp L.logp;
predict logp_innovation, residuals;

******************************************************************************************;
******************************************************************************************;

global Thorizonstart=0;
global Thorizonend=8;
global scaleshock_That=1;
global figurehorstart=0;
global figurehorend=8;  


preserve;
foreach j of num $Thorizonstart/$Thorizonend{;
  qui gen coeffUI`j'=.;    
  qui gen LHS`j'=F`j'.logv;   
  qui reg LHS`j' That_innovation logp_innovation L(0/11).u;
  qui replace coeffUI`j'= $scaleshock_That*_b[That_innovation];   
};  
keep coeff*;
qui gen ivar=0;
duplicates drop;
reshape long coeffUI, i(ivar) j(horizon);
drop ivar; 
input;
-100 . . . . . .;
-50  . . . . . .;
end;
qui replace coeffUI=0 if horizon<0;
qui replace horizon=-1.333 if horizon==-100;
qui replace horizon=-0.666 if horizon==-50;
qui gen zeroline=0;
sort horizon;
line coeffUI horizon if horizon>=$figurehorstart & horizon<=$figurehorend, ylabels(-0.04 -0.02 0, nogrid labsize(5.00)) yscale(r(-0.05 0.005) titlegap(4.00)) xlabels(0 2 4 6 8, labsize(4.50)) xscale(r(-0.13 8.1)) ytitle("Change in Log Vacancies", size(4.50)) legend(off) xtitle("") title("") graphregion(color(white)) lpattern(solid) lcolor(blue) lw(0.75);
	 graph export "figures_temp\That_innovation_v_stand.pdf", as(pdf) replace;	  
restore;


preserve;
foreach j of num $Thorizonstart/$Thorizonend{;
  qui gen coeffUI`j'=.;
  qui gen LHS`j'=F`j'.u;   
  qui reg LHS`j' That_innovation logp_innovation L(0/11).u;
  qui replace coeffUI`j'= 100*$scaleshock_That*_b[That_innovation];    
};  
keep coeff*;
qui gen ivar=0;
duplicates drop;
reshape long coeffUI, i(ivar) j(horizon);
drop ivar; 
input;
-100 . . . . . .;
-50  . . . . . .;
end;
qui replace coeffUI=0 if horizon<0;
qui replace horizon=-1.333 if horizon==-100;
qui replace horizon=-0.666 if horizon==-50;
qui gen zeroline=0;
sort horizon;	
line coeffUI horizon if horizon>=$figurehorstart & horizon<=$figurehorend, ylabels(0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.14, nogrid labsize(5.00)) yscale(r(-0.01 0.145) titlegap(4.00)) xlabels(0 2 4 6 8, labsize(4.50)) xscale(r(-0.13 8.1)) ytitle("Change in Unemployment Rate (PP)", size(4.50)) legend(off) xtitle("") title("") graphregion(color(white)) lpattern(solid) lcolor(blue) lw(0.75);
	 graph export "figures_temp\That_innovation_u_stand.pdf", as(pdf) replace;		  
restore;



preserve;
foreach j of num $Thorizonstart/$Thorizonend{;
  qui gen coeffUI`j'=.;
  qui gen LHS`j'=F`j'.phi;   
  qui reg LHS`j' That_innovation logp_innovation L(0/11).u;
  qui replace coeffUI`j'= 100*$scaleshock_That*_b[That_innovation];     
};  
keep coeff*;
qui gen ivar=0;
duplicates drop;
reshape long coeffUI, i(ivar) j(horizon);
drop ivar; 
input;
-100 . . . . . .;
-50  . . . . . .;
end;
qui replace coeffUI=0 if horizon<0;
qui replace horizon=-1.333 if horizon==-100;
qui replace horizon=-0.666 if horizon==-50;
qui gen zeroline=0;
sort horizon;
line coeffUI horizon if horizon>=$figurehorstart & horizon<=$figurehorend, ylabels(0 0.1 0.2 0.3 0.4, nogrid labsize(5.00)) yscale(r(-0.01 0.40) titlegap(4.00)) xlabels(0 2 4 6 8, labsize(4.50)) xscale(r(-0.13 8.1)) ytitle("Change in Fraction Receiving UI (PP)", size(4.50)) legend(off) xtitle("") title("") graphregion(color(white)) lpattern(solid) lcolor(blue) lw(0.75);
	 graph export "figures_temp\That_innovation_phi_stand.pdf", as(pdf) replace;	 
restore;


preserve;
foreach j of num $Thorizonstart/$Thorizonend{;
  qui gen coeffUI`j'=.; 
  qui gen LHS`j'=F`j'.logb;   
  qui reg LHS`j' That_innovation logp_innovation L(0/11).u;
  qui replace coeffUI`j'= $scaleshock_That*_b[That_innovation];  
};  
keep coeff*;
qui gen ivar=0;
duplicates drop;
reshape long coeffUI, i(ivar) j(horizon);
drop ivar; 
input;
-100 . . . . . .;
-50  . . . . . .;
end;
qui replace coeffUI=0 if horizon<0;
qui replace horizon=-1.333 if horizon==-100;
qui replace horizon=-0.666 if horizon==-50;
qui gen zeroline=0;
sort horizon;
line coeffUI horizon if horizon>=$figurehorstart & horizon<=$figurehorend, ylabels(0 0.003 0.006 0.009 0.012, nogrid labsize(5.00)) yscale(r(-0.001 0.013) titlegap(4.00)) xlabels(0 2 4 6 8, labsize(4.50)) xscale(r(-0.13 8.1)) ytitle("Change in Log Opportunity Cost", size(4.50)) legend(off) xtitle("") title("") graphregion(color(white)) lpattern(solid) lcolor(blue) lw(0.75);
	 graph export "figures_temp\That_innovation_b_stand.pdf", as(pdf) replace;	 
restore;

