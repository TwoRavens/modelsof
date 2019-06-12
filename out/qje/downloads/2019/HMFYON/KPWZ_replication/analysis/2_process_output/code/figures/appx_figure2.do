* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appendix Figure 2
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019

* This .do file plots the bar graph of number of years to decision after an initial rejection




*--------- APPENDIX FIGURE 2 ---------*

  * get the data
  use "$data/dta/init_rej.dta", clear 

  lab drop vallab
  label define vallab 0 "Zero" 1 "One" 2 "Two" 3 "Three" 4 "Four" 5 "Five" 6 "Six" 7 "Seven" 8 "Eight" 9 "Nine" 10 "Ten +" 11 "Never/censored"
  label values yearsuntilgrant vallab

  graph bar share, over(yearsuntilgrant, label(angle(45))) ///
    ytitle("Proportion") title("") ///
    plotregion(fcolor(white) lcolor(white)) graphregion(color(white) lcolor(white)) bgcolor(white)
  graph export "$figures/appx_figure2.pdf", replace
  
  
