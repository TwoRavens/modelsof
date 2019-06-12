* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appendix Figure 1
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019

* This .do file plots the histogram of decision years




*--------- APPENDIX FIGURE 1 ---------*

  * get the data
  use "$data/dta/todecision_hist.dta", clear 
  
  // Number of years until the first decision is measured as follows:
	  * decyrlag = earliest_action_date - applicationyear
	  
  // Number of years until the first decision is truncated if >5

  hist decyrlag, start(-.5) width(1) xlabel(0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5+") ///
    xtitle("Decision year minus application year") ytitle("Proportion") title("") ///
    plotregion(fcolor(white) lcolor(white)) graphregion(color(white) lcolor(white)) bgcolor(white)
  graph export "$figures/appx_figure1.pdf", replace


