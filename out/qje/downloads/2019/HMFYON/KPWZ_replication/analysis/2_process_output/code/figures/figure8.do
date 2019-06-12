* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Figure 8
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019

* This .do file plots heterogeneous diff-in-diff coefficients, stayers only

  

*--------- FIGURE 8 ---------*
		
	use "$data/dta/DID_vals.dta", clear
	
      * keep and order only the necessary rows
      keep if regexm(variables,"win_Q5") | inlist(variables,"Mean dep var","Elasticity")
      gen i = 1
      gen j = _n
      keep  i j wage_stayersm wage_stayersf rat_stay_inv rat_stay_noninv wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4
      reshape wide wage_stayersm wage_stayersf rat_stay_inv rat_stay_noninv wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4, i(i) j(j)
      order i wage_stayersm* wage_stayersf* rat_stay_inv* rat_stay_noninv* wage_stayq1* wage_stayq2* wage_stayq3* wage_stayq4*
 
      * rename suffixes to comport with STATA reshape syntax
      loc c = 0
      foreach vv of varlist _all {
        if "`vv'"!="i" {
          * point estimates
          if substr("`vv'",-1,1)=="1" {
            loc ++c
            rename `vv' b`c'
          }
          * standard errors of point estimates
          if substr("`vv'",-1,1)=="2" {
              rename `vv' se`c'
          }
          * mean of outcome variable
          if substr("`vv'",-1,1)=="3" {
            rename `vv' md`c'
	    g flag`c' = (regexm("`vv'", "_diff") | regexm("`vv'", "_gain"))
          }
          * % impact at the mean
          if substr("`vv'",-1,1)=="4" {
            rename `vv' el`c'
          }
	  
        }
      }
      
      * stack the data according to the
      reshape long b se md el flag, i(i) j(j)

      * bounds on point estimate
      gen lower_b = b - ($ci * se)
      gen upper_b = b + ($ci * se)

      * bounds on elasticity
      gen lower_el = 100*(lower_b/md)
      gen upper_el = 100*(upper_b/md)

      * reshape to operate a "by" statement
      keep i j *b *el
      foreach vv of varlist *b {
        rename `vv' `vv'1
      }
      foreach vv of varlist *el {
        loc new = subinstr("`vv'","el","b",.)
        rename `vv' `new'2
      }
      reshape long b lower_b upper_b, i(i j) j(k)
      * reorder everything to print properly
      replace j = ((`=_N'/2) - j) + 1

  
	* run the program to fill the graph depending on the type of figure we want to produce
	  * insert empty rows
      set obs 22

      * label ordering
      replace j = 0 in 17
      replace j = 4.33 in 18
      replace j = 4.66 in 19
      replace j = 6.33 in 20
      replace j = 6.66 in 21
      replace j = 8.33 in 22

      * name for k, labeled
      gen k_label = ""
      replace k_label = "Coefficients" if inlist(k, . , 1)
      replace k_label = "Percent Impacts" if k==2

      replace j = j-.25 if k_label == "Percent Impacts"
      gsort j k
      g order = _n

      * truncate CI if above 25
      g upper_b_marker = upper_b if upper_b<=25
      replace upper_b = 25 if upper_b>25
      * truncate CI if below -5
      g lower_b_marker = lower_b if lower_b>=-5
      replace lower_b = -5 if lower_b<-5
     
      
      * lines for magnitude of effect
      gl magnitude_lines ""
      forvalues i = -5(5)25 {
        gl magnitude_lines "$magnitude_lines xline(`i', lwidth(thin) lpattern(dash) lcolor(gs15))"
      }

      * horizontal lines to track across the figure
      gl label_lines "2 3 4 5 6 7 8 9 12 13 14 15 18 19 20 21"
	  gl nolabel_lines "10 11 16 17"

      * plot the figure
      #delimit ;
      twoway
          (dot b order if k_label=="Coefficients",
              horizontal msymbol(circle) msize(small) mcolor(dknavy)
              dcolor(none) dlcolor(none) dsymbol(none)  ndots(0)
              ylabel(, tlength(0))
              $magnitude_lines)
          (rcapsym lower_b upper_b order if k_label=="Coefficients",
              horizontal lpattern(solid) lwidth(thin) lcolor(dknavy) ms(i))
		  (rscatter lower_b_marker upper_b_marker order if k_label=="Coefficients",
              horizontal lpattern(blank) lcolor(none) msize(small) ms(pipe) mcolor(dknavy) )
	 
	      (dot b order if k_label=="Percent Impacts",
              horizontal msymbol(circle) msize(small) mcolor(ebblue)
              dcolor(none) dlcolor(none) dsymbol(none)  ndots(0)
              ylabel(, tlength(0))
              $magnitude_lines)
          (rcapsym lower_b upper_b order if k_label=="Percent Impacts",
              horizontal lpattern(solid) lwidth(thin) lcolor(ebblue) ms(i))
	      (rscatter lower_b_marker upper_b_marker order if k_label=="Percent Impacts",
              horizontal lpattern(blank) lcolor(none) msize(small) ms(pipe) mcolor(ebblue) )
			  ,
          plotregion(fcolor(white) lcolor(white))
          graphregion(color(white) lcolor(white))
              bgcolor(white)
          legend(order(1 4) label(1 "Coefficient (1K 2014 USD per worker)") 
		label(4 "Percent Impact") row(2) 
		region(lcolor(white)) span)
          ysize(13) xsize(10)
          xline(0, lwidth(thin) lcolor(gs0))
          ylabel(
              1 " "
	      2 " "
              3 "Q4 earnings" 
	      4 " "
              5 "Q3 earnings" 
	      6 " "
              7 "Q2 earnings" 
	      8 " "
              9 "Q1 earnings"
              10  "{bf:Quartiles:}                "
              11 " "
	      12 " "
              13 "Non-inventor earnings" 
	      14 " "
              15 "Inventor earnings"
              16 "{bf:Inventors:}                  "
              17 " " 
	      18 " " 
              19 "Female earnings"
	      20 " "
              21 "Male earnings"
              22 "{bf:Gender:}                     "
              23 " ",
              angle(0) labsize(small) nogrid)
          yline($label_lines, lwidth(thin) lcolor(gs14))
		  yline($nolabel_lines, lwidth(tiny) lcolor(white))
          xlabel(-5(5)25, labsize(small)) xscale(r(-5 25))
          ytitle("")
          title("");
      #delimit cr
    graph export "$figures/figure8.pdf", replace
	

