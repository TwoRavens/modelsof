* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appebndix Table 10
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates sensitivity analysis table



*--------- APPENDIX TABLE 10 ---------*

 *SIX CASES WHERE WAGE PREMIUM IS EXOGENOUS
	 clear
	 set obs 6
	 
	 g case = _n
	 
	 *Inputs
	 g double wageratio = .
	 g double retelasticity = .
	 g double pi = .
	 
	 *Case 1: wage ratio comes from Table 7, pi comes from Table 8, col 4b, retention elasticity from table 9
	 replace wageratio = 79/43.5 if case==1
	 replace pi = .61 if case==1
	 replace retelasticity = 1.22 if case==1
	 
	 
	 *Case 2: wage ratio =1.2 , pi comes from Table 8, col 4b, retention elasticity from table 9
	 replace wageratio = 1.2 if case==2
	 replace pi = .61 if case==2
	 replace retelasticity = 1.22 if case==2

	 *Case 3:  wage ratio comes from Table 7 , pi comes from Table 8, col 4b, 
		*retention elasticity from table 9 + 1 SD
	 replace wageratio = 79/43.5 if case==3
	 replace pi = .61 if case==3
	 replace retelasticity = 1.22+.58 if case==3

	 *Case 4:  wage ratio comes from Table 7 , pi comes from Table 8, col 4b, 
		*retention elasticity from table 9 - 1 SD
	 replace wageratio = 79/43.5 if case==4
	 replace pi = .61 if case==4
	 replace retelasticity = 1.22-.58 if case==4
	 
	 *Case 5:  wage ratio comes from Table 7 , pi comes from Table 8, col 4b, +1SD
		*retention elasticity from table 9 
	 replace wageratio = 79/43.5 if case==5
	 replace pi = .61+.3 if case==5
	 replace retelasticity = 1.22 if case==5

	 *Case 6:  wage ratio comes from Table 7 , pi comes from Table 8, col 4b, +1SD
		*retention elasticity from table 9 
	 replace wageratio = 79/43.5 if case==6
	 replace pi = .61-.3 if case==6
	 replace retelasticity = 1.22 if case==6
	 
	 *Order output vars
	 g double eta = .
	 g double theta = .
	 g double cprime_w = .
	 g double epsilon = .
	 
	 *Calculate output, Cases 1-6
	 replace eta = retelasticity*(wageratio/(wageratio-1)) 
	 replace theta = eta/(eta+1) 
	 replace cprime_w = (wageratio-1)/theta 
	 replace epsilon = theta/(theta-pi) 
	 
	 replace theta = 999 if theta>1 & theta!=.
	 replace epsilon = 999 if epsilon<0 & epsilon!=.
	 
	 order wageratio retelasticity pi eta cprime_w theta epsilon
	 
	 xpose, clear varname
	 	 
	 drop if _varname=="case"
	 
	 drop _varname
	 
	 tempfile tabsensitivitya
	 save `tabsensitivitya'
	 
	 drop in 6/7
	 
	 * convert to a matrix, top of table
	    mkmat *, mat(tabsensitivitya)
	    tempfile tab_sensitivitya
            matrix_to_txt, saving(`tab_sensitivitya') mat(tabsensitivitya) title(<tab:sensitivity>) replace
	    
	 use `tabsensitivitya', clear
	 keep in 6/7
	 
	  *Convert to string
	 forv i=1/6{
	    tostring v`i', force replace
	    
	    *Format
	    replace v`i' = string(real(v`i'),"%12.2f") in 1
	    replace v`i' = string(real(v`i'),"%12.1f") in 2
	    
	    replace v`i' = "" if v`i'=="."
	    replace v`i' = "-" if regexm(v`i',"999")
	 }
	 tempfile tab_sensitivitya_lastrows
         export delimited using `tab_sensitivitya_lastrows', delim(tab)  novar replace
 	    
  *FOUR CASES WHERE EPSILON PREMIUM IS EXOGENOUS   
	 clear
	 set obs 6
	 
	 g case = _n
	 
	 *Inputs
	 g double epsilon = 6 if inrange(case, 3, 6)
	 g double retelasticity = .
	 g double pi = .
 
	 *Case 3:  wage ratio comes from Table 7 , pi comes from Table 8, col 4b, 
		*retention elasticity from table 9 + 1 SD
	 replace pi = .61 if case==3
	 replace retelasticity = 1.22+.58 if case==3

	 *Case 4:  wage ratio comes from Table 7 , pi comes from Table 8, col 4b, 
		*retention elasticity from table 9 - 1 SD
	 replace pi = .61 if case==4
	 replace retelasticity = 1.22-.58 if case==4
	 
	 *Case 5:  wage ratio comes from Table 7 , pi comes from Table 8, col 4b, +1SD
		*retention elasticity from table 9 
	 replace pi = .61+.3 if case==5
	 replace retelasticity = 1.22 if case==5

	 *Case 6:  wage ratio comes from Table 7 , pi comes from Table 8, col 4b, +1SD
		*retention elasticity from table 9 
	 replace pi = .61-.3 if case==6
	 replace retelasticity = 1.22 if case==6
	 
	 
	 *Order output vars
	 g double wageratio = . 
	 g double eta = .
	 g double theta = .
	 g double cprime_w = .

	 
	 *Calculate output, 
	 replace theta = epsilon*pi/(epsilon-1) 
	 replace eta = theta/(1-theta)
	 replace wageratio = eta/(eta-retelasticity) 
	 replace cprime_w = (wageratio-1)/theta
	 
	 *Replace results that are impossible
	 replace wageratio = 999 if abs(wageratio)<1 & wageratio!=.
	 replace eta = 999 if eta<0 & eta!=.
	 replace theta = 999 if theta>1 & theta!=.
         replace epsilon = 999 if epsilon<0 & epsilon!=. 
	 replace cprime_w = 999 if cprime_w<0 & cprime_w!=.
	 
	 order epsilon retelasticity pi wageratio eta cprime_w theta
	 xpose, clear varname
	 
	 drop if _varname=="case"
	 
	 drop _varname
	 
	 tempfile tabsensitivityb
	 save `tabsensitivityb'
	 
	 drop in 4/7
	 
	 * convert to a matrix, top of table
	    mkmat *, mat(tabsensitivityb)
	    tempfile tab_sensitivityb
            matrix_to_txt, saving(`tab_sensitivityb') mat(tabsensitivityb) replace
	    
	 use `tabsensitivityb', clear
	 keep in 4/7
	 
	  *Convert to string
	 forv i=1/6{
	    tostring v`i', force replace
	    
	    *Format
	    replace v`i' = string(real(v`i'),"%12.1f") in 1/3
	    replace v`i' = string(real(v`i'),"%12.2f") in 4
	    
	    replace v`i' = "" if v`i'=="."
	    replace v`i' = "-" if regexm(v`i',"999")
	 }
	 tempfile tab_sensitivityb_lastrows
     export delimited using `tab_sensitivityb_lastrows', delim(tab)  novar replace
    
    * now the panel table
    ! rm -f "$tables/appx_table10.txt" && cat `tab_sensitivitya' `tab_sensitivitya_lastrows' `tab_sensitivityb' `tab_sensitivityb_lastrows'  > "$tables/appx_table10.txt"
