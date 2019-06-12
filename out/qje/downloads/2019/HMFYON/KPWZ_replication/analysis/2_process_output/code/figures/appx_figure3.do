* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appendix Figure 3
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019

* This .do file plots industry compoisition of full sample and initially allowed sample



*--------- APPENDIX FIGURE 3 ---------*
	
	* insheet data
	insheet using "$data/summ/stats_fullsample_ind2D.csv", clear	
	
	keep if d==0 //keep industry in year of application
		
	egen tot = total(count)

	drop if missing(indtitle)
	
   * calculate share of industries 
   gen share = count/tot * 100
  

   graph hbar share, over(indtitle_naics, sort(share) ///
	descending gap(*3) label(labsize(small))) ///
	blabel(bar, format(%9.1f) size(vsmall)) bargap(85) ///
	graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white)) ///
	ytitle("Industry Share of All Firms in Application Year (%)", size(small)) ///
	ylabel(, labsize(vsmall)) ///
	ysize(4.25) xsize(6.75) 
   graph export "$figures/appx_figure3.pdf", replace

   
