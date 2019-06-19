******************************
* Figure 1 
******************************
use listing_final, clear
collapse (count) num_listing = funded /// 
		 (sum) num_loans = funded ///
		 (mean) prob_funding = funded ///		 
                if inrange(month_id, 11, 20), by(month_id prime_categ)
                
twoway (connected num_listing month_id if prime_categ == 1, lcolor(black) lpattern(solid) mcolor(black)) ///
	   (connected num_listing month_id if prime_categ == 2, lcolor(black) lpattern(dash) mcolor(black)) ///
       (connected num_listing month_id if prime_categ == 3, lcolor(black) lpattern("--....") mcolor(black)), ///
	       xlab(11 "12/2007" 15 "04/2008" 20 "09/2008") xline(15.5) ///
	       legend(lab(1 "Low Risk") lab(2 "Medium Risk") lab(3 "High Risk")) ///
	       ytit("# Listings") xtit("Month") xscale(range(11 20.5)) /// 
	       ylab(0 2000 4000 6000 8000 10000, angle(0)) /// 
		   name(listing_by_risk_type_time_trend, replace ) 

twoway (connected num_loans month_id if prime_categ == 1, lcolor(black) lpattern(solid) mcolor(black)) ///
	   (connected num_loans month_id if prime_categ == 2, lcolor(black) lpattern(dash) mcolor(black)) ///
       (connected num_loans month_id if prime_categ == 3, lcolor(black) lpattern("--....") mcolor(black)), ///
	       xlab(11 "12/2007" 15 "04/2008" 20 "09/2008") xline(15.5) ///
	       legend(lab(1 "Low Risk") lab(2 "Medium Risk") lab(3 "High Risk")) ///
	       ytit("# Loans") xtit("Month") xscale(range(11 20.5)) /// 
	       ylab(0 100 200 300 400 500, angle(0)) /// 
	       name(loan_by_risk_type_time_trend, replace) 
graph combine listing_by_risk_type_time_trend loan_by_risk_type_time_trend
graph export Figure_1.pdf, replace	
window manage close graph _all

******************************
* Figure 2
******************************
use listing_final, clear	
hist max_rate if (~after_change), xtit("Interest Rate Cap") /// 
		xlab(0.06 "6%" 0.1 "10%" 0.15 "15%" 0.2 "20%" 0.25 "25%" 0.3 "30%" 0.36 "36%") ytit("Fraction") ///
		xtit("Interest Rate Cap") fraction
graph export Figure_2.pdf, replace  		
window manage close graph _all
