clear all
set more off
#delimit;
set excelxlsxlargefile on;
set type double;
	 


local dir : pwd;
	 
cd "..\figures_highb_baseline";
import excel dataset_counterfactuals_persistence.xlsx, sheet("Sheet1") clear;

qui rename A time;
qui rename B p_EB;
qui rename C That_EB;
qui rename D w_EB;
qui rename E theta_EB;
qui rename F f_EB;
qui rename G e_EB;
qui rename H b_EB;
qui rename I u_EB;
qui rename J phi_EB;
qui rename K T_EB;
qui rename L That_innovation_EB;
qui rename M s_EB;

tset time, monthly;

qui gen logp_EB=log(p_EB);
global Tstart=800;
global Tend=870;
qui gen year=time-$Tstart;	
	 	 
cd "..\figures_highb_counterfactuals";
save counterfactuals_persistence_highb.dta, replace;



cd "..\figures_highb_noEB";
import excel dataset_counterfactuals_persistence.xlsx, sheet("Sheet1") clear;

qui rename A time;
qui rename B p_noEB;
qui rename C That_noEB;
qui rename D w_noEB;
qui rename E theta_noEB;
qui rename F f_noEB;
qui rename G e_noEB;
qui rename H b_noEB;
qui rename I u_noEB;
qui rename J phi_noEB;
qui rename K T_noEB;
qui rename L That_innovation_noEB;
qui rename M s_noEB;

tset time, monthly;

qui gen logp_noEB=log(p_noEB);
global Tstart=800;
global Tend=870;
qui gen year=time-$Tstart;

cd "..\figures_highb_counterfactuals";
merge m:m year time using counterfactuals_persistence_highb.dta, nogenerate keep(master matched);
save counterfactuals_persistence_highb.dta, replace;

*************************************************************************************************;
*************************************************************************************************;
*************************************************************************************************;
*************************************************************************************************;
cd "..\figures_highb_counterfactuals";


line logp_EB year if time>=$Tstart & time<=$Tend, ylabels(, nogrid labsize(5.00)) yscale(titlegap(4.00)) xlabels(0 10 22 34 46 58 70, labsize(4.50)) xscale(r(0 33)) ytitle("Log Productivity", size(4.50)) legend(order(1 "With Benefit Extensions" 2 "No Benefit Extensions") r(1) region(lcolor(white)) size(3.80)) xtitle("") title("") graphregion(color(white)) lpattern(longdash) lcolor(blue) lw(0.75)||
     line logp_noEB year if time>=$Tstart & time<=$Tend, lpattern(dash) lcolor(dkorange) lw(0.80);
	 graph export "simulations_persistence_p.pdf", as(pdf) replace;	
	 
line s_EB year if time>=$Tstart & time<=$Tend, ylabels(0.03 0.04 0.05 0.06, nogrid labsize(5.00)) yscale(r(0.025 0.060) titlegap(4.00)) xlabels(0 10 22 34 46 58 70, labsize(4.50)) xscale(r(0 33)) ytitle("Separation Rate", size(4.50)) legend(order(1 "With Benefit Extensions" 2 "No Benefit Extensions") r(1) region(lcolor(white)) size(3.80)) xtitle("") title("") graphregion(color(white)) lpattern(longdash) lcolor(blue) lw(0.75)||
     line s_noEB year if time>=$Tstart & time<=$Tend, lpattern(dash) lcolor(dkorange) lw(0.80);
	 graph export "simulations_persistence_s.pdf", as(pdf) replace;		 

line u_EB year if time>=$Tstart & time<=$Tend, ylabels(0.05 0.06 0.07 0.08 0.09 0.10, nogrid labsize(5.00)) yscale(r(0.048 0.102) titlegap(4.00))  xlabels(0 10 22 34 46 58 70, labsize(4.50)) xscale(r(0 33)) ytitle("Unemployment Rate", size(4.50)) legend(order(1 "With Benefit Extensions" 2 "No Benefit Extensions") r(1) region(lcolor(white)) size(3.80)) xtitle("") title("") graphregion(color(white)) lpattern(longdash) lcolor(blue) lw(0.75)||
     line u_noEB year if time>=$Tstart & time<=$Tend, lpattern(dash) lcolor(dkorange) lw(0.80);
	 graph export "simulations_persistence_u.pdf", as(pdf) replace;		 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
