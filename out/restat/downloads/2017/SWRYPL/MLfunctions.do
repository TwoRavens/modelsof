/* MLfunctions.do reads in all the handwritten ml functions */

* Overview of models *

*	ML_crra_NAI 		Risk attitudes with CRRA - NO ASSET INTEGRATION
*	ML_crra_FAI 		Risk attitudes with CRRA - FULL ASSET INTEGRATION
*	ML_crra_PAI 		Risk attitudes with CRRA - PARTIAL ASSET INTEGRATION

*	ML_crra_NAI_P 		Risk attitudes with CRRA - NO ASSET INTEGRATION  - RDEU - Prelec weighting 
*	ML_crra_FAI_P 		Risk attitudes with CRRA - FULL ASSET INTEGRATION - RDEU - Prelec weighting 
*	ML_crra_PAI_P 		Risk attitudes with CRRA - PARTIAL ASSET INTEGRATION - RDEU - Prelec weighting 

*	ML_crra_NAI_P1 		Risk attitudes with CRRA - NO ASSET INTEGRATION  - RDEU - Prelec weighting  - constrained
*	ML_crra_FAI_P1 		Risk attitudes with CRRA - FULL ASSET INTEGRATION - RDEU - Prelec weighting    - constrained
*	ML_crra_PAI_P1 		Risk attitudes with CRRA - PARTIAL ASSET INTEGRATION - RDEU - Prelec weighting   - constrained 


program ML_crra_NAI

	args lnf r LNmu

	   * declare temporary variables to be used
    tempvar choice prob0l prob1l prob2l prob3l prob0r prob1r prob2r prob3r m0l m1l m2l m3l m0r m1r m2r m3r u0l u1l u2l u3l u0r u1r u2r u3r euL euR euDiff low high mu
	
    * do not display all these steps on the screen
    quietly {

        * initialize the data
        generate int 		`choice' 	= $ML_y1
		generate double 	`mu' 		= exp(`LNmu')

        generate double `prob0l' = $ML_y2
        generate double `prob1l' = $ML_y3
        generate double `prob2l' = $ML_y4
        generate double `prob3l' = $ML_y5

        generate double `prob0r' = $ML_y6
        generate double `prob1r' = $ML_y7
        generate double `prob2r' = $ML_y8
        generate double `prob3r' = $ML_y9

        generate double `m0l' = $ML_y10/$scale 
        generate double `m1l' = $ML_y11/$scale 
        generate double `m2l' = $ML_y12/$scale 
        generate double `m3l' = $ML_y13/$scale 

        generate double `m0r' = $ML_y14/$scale 
        generate double `m1r' = $ML_y15/$scale 
        generate double `m2r' = $ML_y16/$scale 
        generate double `m3r' = $ML_y17/$scale 


        * evaluate the utility function
        forvalues i=0/3 {	
            generate double `u`i'l' = (`m`i'l'^(1-`r'))/(1-`r')
			generate double `u`i'r' = (`m`i'r'^(1-`r'))/(1-`r')
		}
	
        * calculate EU of each lottery
        generate double `euL' = (`prob0l'*`u0l')+(`prob1l'*`u1l')+(`prob2l'*`u2l')+(`prob3l'*`u3l')
        generate double `euR' = (`prob0r'*`u0r')+(`prob1r'*`u1r')+(`prob2r'*`u2r')+(`prob3r'*`u3r')

        * get the Fechner index
        if "$contextual" == "y" {
               egen `low' = rowmin(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r' )
			egen `high' = rowmax(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r')       
            generate double `euDiff' = ((`euR' - `euL')/(`high'-`low'))/`mu'
        }
        else {
            generate double `euDiff' = (`euR' - `euL')/`mu'
        }			

		replace `lnf'=ln(invlogit( `euDiff')) if $ML_y1==1 
		replace `lnf'=ln(invlogit(-`euDiff')) if $ML_y1==0 
		
		
        * save the likelihoods
        replace ll = `lnf'
		if "$getLL" =="y" {
			local nLL = $nLL
			forvalues x = 1/`nLL' {
				global ll_`x' = `lnf'[`x']
			}		
		}


	}

end

program ML_crra_PAI

	args lnf r LNmu LNrho LNomega

	   * declare temporary variables to be used
    tempvar choice prob0l prob1l prob2l prob3l prob0r prob1r prob2r prob3r m0l m1l m2l m3l m0r m1r m2r m3r u0l u1l u2l u3l u0r u1r u2r u3r euL euR euDiff low high wealth mu rho omega
	
    * do not display all these steps on the screen
    quietly {

        * initialize the data
		generate double `mu' 		= 	exp(`LNmu')
		* transform parameters
		generate double `rho'   = 1 - 	exp(`LNrho' )
        generate double `omega' = 		$high*exp(`LNomega')

        generate int 	`choice' = $ML_y1
		generate double `wealth' = $ML_y18

        generate double `prob0l' = $ML_y2
        generate double `prob1l' = $ML_y3
        generate double `prob2l' = $ML_y4
        generate double `prob3l' = $ML_y5

        generate double `prob0r' = $ML_y6
        generate double `prob1r' = $ML_y7
        generate double `prob2r' = $ML_y8
        generate double `prob3r' = $ML_y9

        generate double `m0l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y10/$scale )^`rho')^(1/`rho')  
        generate double `m1l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y11/$scale )^`rho')^(1/`rho')  
        generate double `m2l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y12/$scale )^`rho')^(1/`rho')  
        generate double `m3l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y13/$scale )^`rho')^(1/`rho')
		
        generate double `m0r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y14/$scale )^`rho')^(1/`rho')  
        generate double `m1r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y15/$scale )^`rho')^(1/`rho')  
        generate double `m2r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y16/$scale )^`rho')^(1/`rho')  
        generate double `m3r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y17/$scale )^`rho')^(1/`rho')  
		
		* evaluate the utility function
        forvalues i=0/3 {	
            generate double `u`i'l' = (`m`i'l'^(1-`r'))/(1-`r')
			generate double `u`i'r' = (`m`i'r'^(1-`r'))/(1-`r')
		}
	
        * calculate EU of each lottery
        generate double `euL' = (`prob0l'*`u0l')+(`prob1l'*`u1l')+(`prob2l'*`u2l')+(`prob3l'*`u3l')
        generate double `euR' = (`prob0r'*`u0r')+(`prob1r'*`u1r')+(`prob2r'*`u2r')+(`prob3r'*`u3r')

        * get the Fechner index
        if "$contextual" == "y" {
             egen `low' = rowmin(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r' )
			egen `high' = rowmax(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r')       
            generate double `euDiff' = ((`euR' - `euL')/(`high'-`low'))/`mu'
        }
        else {
            generate double `euDiff' = (`euR' - `euL')/`mu'
        }			

		replace `lnf'=ln(invlogit( `euDiff')) if $ML_y1==1 
		replace `lnf'=ln(invlogit(-`euDiff')) if $ML_y1==0 
		
		
        * save the likelihoods
        replace ll = `lnf'
		if "$getLL" =="y" {
			local nLL = $nLL
			forvalues x = 1/`nLL' {
				global ll_`x' = `lnf'[`x']
			}		
		}


	}

end

program ML_crra_PAI_expo

	args lnf r alpha LNmu LNrho LNomega

	   * declare temporary variables to be used
    tempvar choice prob0l prob1l prob2l prob3l prob0r prob1r prob2r prob3r m0l m1l m2l m3l m0r m1r m2r m3r u0l u1l u2l u3l u0r u1r u2r u3r euL euR euDiff low high wealth mu rho omega
	
    * do not display all these steps on the screen
    quietly {

        * initialize the data
		generate double `mu' 		= 	exp(`LNmu')
		* transform parameters
		generate double `rho'   = 1 - 	exp(`LNrho' )
        generate double `omega' = 		$high*exp(`LNomega')

        generate int 	`choice' = $ML_y1
		generate double `wealth' = $ML_y18

        generate double `prob0l' = $ML_y2
        generate double `prob1l' = $ML_y3
        generate double `prob2l' = $ML_y4
        generate double `prob3l' = $ML_y5

        generate double `prob0r' = $ML_y6
        generate double `prob1r' = $ML_y7
        generate double `prob2r' = $ML_y8
        generate double `prob3r' = $ML_y9

        generate double `m0l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y10/$scale )^`rho')^(1/`rho')  
        generate double `m1l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y11/$scale )^`rho')^(1/`rho')  
        generate double `m2l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y12/$scale )^`rho')^(1/`rho')  
        generate double `m3l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y13/$scale )^`rho')^(1/`rho')
		
        generate double `m0r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y14/$scale )^`rho')^(1/`rho')  
        generate double `m1r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y15/$scale )^`rho')^(1/`rho')  
        generate double `m2r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y16/$scale )^`rho')^(1/`rho')  
        generate double `m3r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y17/$scale )^`rho')^(1/`rho')  
		
		* evaluate the utility function
        forvalues i=0/3 {	
            generate double `u`i'l' = (1-exp(-`alpha'*(`m`i'l'^(1-`r'))))/(`alpha')
			generate double `u`i'r' = (1-exp(-`alpha'*(`m`i'r'^(1-`r'))))/(`alpha')
		}
	
        * calculate EU of each lottery
        generate double `euL' = (`prob0l'*`u0l')+(`prob1l'*`u1l')+(`prob2l'*`u2l')+(`prob3l'*`u3l')
        generate double `euR' = (`prob0r'*`u0r')+(`prob1r'*`u1r')+(`prob2r'*`u2r')+(`prob3r'*`u3r')

        * get the Fechner index
        if "$contextual" == "y" {
             egen `low' = rowmin(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r' )
			egen `high' = rowmax(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r')       
            generate double `euDiff' = ((`euR' - `euL')/(`high'-`low'))/`mu'
        }
        else {
            generate double `euDiff' = (`euR' - `euL')/`mu'
        }			

		replace `lnf'=ln(invlogit( `euDiff')) if $ML_y1==1 
		replace `lnf'=ln(invlogit(-`euDiff')) if $ML_y1==0 
		
		
        * save the likelihoods
        replace ll = `lnf'
		if "$getLL" =="y" {
			local nLL = $nLL
			forvalues x = 1/`nLL' {
				global ll_`x' = `lnf'[`x']
			}		
		}


	}

end


program ML_crra_FAI

	args lnf r LNmu

	   * declare temporary variables to be used
    tempvar choice prob0l prob1l prob2l prob3l prob0r prob1r prob2r prob3r m0l m1l m2l m3l m0r m1r m2r m3r u0l u1l u2l u3l u0r u1r u2r u3r euL euR euDiff low high wealth mu
	
    * do not display all these steps on the screen
    quietly {

        * initialize the data
		generate double 	`mu' 		= exp(`LNmu')
        generate int `choice' = $ML_y1
		generate double `wealth'= $ML_y18

        generate double `prob0l' = $ML_y2
        generate double `prob1l' = $ML_y3
        generate double `prob2l' = $ML_y4
        generate double `prob3l' = $ML_y5

        generate double `prob0r' = $ML_y6
        generate double `prob1r' = $ML_y7
        generate double `prob2r' = $ML_y8
        generate double `prob3r' = $ML_y9

        generate double `m0l' = (`wealth' + $ML_y10)/$scale
        generate double `m1l' = (`wealth' + $ML_y11)/$scale
        generate double `m2l' = (`wealth' + $ML_y12)/$scale
        generate double `m3l' = (`wealth' + $ML_y13)/$scale

        generate double `m0r' = (`wealth' + $ML_y14)/$scale
        generate double `m1r' = (`wealth' + $ML_y15)/$scale
        generate double `m2r' = (`wealth' + $ML_y16)/$scale
        generate double `m3r' = (`wealth' + $ML_y17)/$scale
		
		* evaluate the utility function
        forvalues i=0/3 {	
            generate double `u`i'l' = (`m`i'l'^(1-`r'))/(1-`r')
			generate double `u`i'r' = (`m`i'r'^(1-`r'))/(1-`r')
		}
	
        * calculate EU of each lottery
        generate double `euL' = (`prob0l'*`u0l')+(`prob1l'*`u1l')+(`prob2l'*`u2l')+(`prob3l'*`u3l')
        generate double `euR' = (`prob0r'*`u0r')+(`prob1r'*`u1r')+(`prob2r'*`u2r')+(`prob3r'*`u3r')

        * get the Fechner index
        if "$contextual" == "y" {
            egen `low'  = rowmin(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r' )
			egen `high' = rowmax(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r')       
            generate double `euDiff' = ((`euR' - `euL')/(`high'-`low'))/`mu'
        }
        else {
            generate double `euDiff' = (`euR' - `euL')/`mu'
        }			

		replace `lnf'=ln(invlogit( `euDiff')) if $ML_y1==1 
		replace `lnf'=ln(invlogit(-`euDiff')) if $ML_y1==0 
		
		
        * save the likelihoods
        replace ll = `lnf'
		if "$getLL" =="y" {
			local nLL = $nLL
			forvalues x = 1/`nLL' {
				global ll_`x' = `lnf'[`x']
			}		
		}


	}

end

*  NAI RDEU functions using Prelec weighting function 
program ML_crra_NAI_P

	args lnf r LNphi LNeta LNmu

	 * declare temporary variables to be used
    tempvar choice aprob0l aprob1l aprob2l aprob3l aprob0r aprob1r aprob2r aprob3r m0l m1l m2l m3l m0r m1r m2r m3r u0l u1l u2l u3l u0r u1r u2r u3r euL euR euDiff low high mu test
	tempvar w0l w1l w2l w3l w0r w1r w2r w3r testAl testAr eta phi
	
    * do not display all these steps on the screen
    quietly {

        * initialize the data
        generate int 		`choice' 	= $ML_y1
		generate double 	`mu' 		= exp(`LNmu')
		generate double 	`phi' 		=  	exp(`LNphi')
		generate double 	`eta' 		=   exp(`LNeta')

        generate int `aprob0l' = round(($ML_y2+ $ML_y3 + $ML_y4 + $ML_y5)*100)
        generate int `aprob1l' = round(($ML_y3 + $ML_y4 + $ML_y5)*100)
        generate int `aprob2l' = round(($ML_y4 + $ML_y5)*100)
        generate int `aprob3l' = round(($ML_y5 )*100)
		
		generate int `aprob0r' = round(($ML_y6 + $ML_y7 + $ML_y8 + $ML_y9)*100)
        generate int `aprob1r' = round(($ML_y7 + $ML_y8 + $ML_y9)*100)
        generate int `aprob2r' = round(($ML_y8 + $ML_y9)*100)
        generate int `aprob3r' = round(($ML_y9 )*100)
		
		generate double `m0l' = $ML_y10/$scale
        generate double `m1l' = $ML_y11/$scale
        generate double `m2l' = $ML_y12/$scale
        generate double `m3l' = $ML_y13/$scale

        generate double `m0r' = $ML_y14/$scale
        generate double `m1r' = $ML_y15/$scale
        generate double `m2r' = $ML_y16/$scale
        generate double `m3r' = $ML_y17/$scale

		* Generate		
		foreach y in l r {
			generate double `w3`y'' =     0
			replace  		`w3`y'' =     exp((-`eta')*(-ln(`aprob3`y''/100))^`phi')  				if `aprob3`y'' > 0  & (`aprob3`y'') < 100
			replace  		`w3`y'' =     1 if `aprob3`y'' == 100
			replace  		`w3`y'' =     0 if `aprob3`y'' == 0 
			
			generate double `w2`y'' = 	 0
			replace 		`w2`y'' =    exp((-`eta')*(-ln(`aprob2`y''/100))^`phi')      - `w3`y''			if `aprob2`y'' > 0  & (`aprob2`y'') < 100
			replace  		`w2`y'' =    1 - `w3`y''  if `aprob2`y''==100
			replace  		`w2`y'' =    0 if `aprob2`y'' == 0 
			
			generate double `w1`y'' = 	 0
			replace 		`w1`y'' =    exp((-`eta')*(-ln(`aprob1`y''/100))^`phi')    - `w3`y'' - 	`w2`y''		if `aprob1`y'' > 0  & (`aprob1`y'') < 100
			replace  		`w1`y'' =    1  - `w3`y'' - `w2`y''  if `aprob1`y'' ==100
			replace  		`w1`y'' =    0 if `aprob1`y'' == 0 
			
			generate double `w0`y'' =    1 - `w3`y'' - `w2`y'' - `w1`y''
		}
		
				
        * evaluate the utility function
        forvalues i=0/3 {	
            generate double `u`i'l' = (`m`i'l'^(1-`r'))/(1-`r')
			generate double `u`i'r' = (`m`i'r'^(1-`r'))/(1-`r')
		}
	
        * calculate EU of each lottery
        generate double `euL' = (`w0l'*`u0l')+(`w1l'*`u1l')+(`w2l'*`u2l')+(`w3l'*`u3l')
        generate double `euR' = (`w0r'*`u0r')+(`w1r'*`u1r')+(`w2r'*`u2r')+(`w3r'*`u3r')

        * get the Fechner index
        if "$contextual" == "y" {
             egen `low' = rowmin(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r' )
			egen `high' = rowmax(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r')       
            generate double `euDiff' = ((`euR' - `euL')/(`high'-`low'))/`mu'
        }
        else {
            generate double `euDiff' = (`euR' - `euL')/`mu'
        }			

		replace `lnf'=ln(invlogit( `euDiff')) if $ML_y1==1 
		replace `lnf'=ln(invlogit(-`euDiff')) if $ML_y1==0 
				
        * save the likelihoods
        replace ll = `lnf'
		if "$getLL" =="y" {
			local nLL = $nLL
			forvalues x = 1/`nLL' {
				global ll_`x' = `lnf'[`x']
			}		
		}


	}

end

* PW funcitons
program ML_crra_NAI_P1

	args lnf r LNphi LNmu

	   * declare temporary variables to be used
    tempvar choice aprob0l aprob1l aprob2l aprob3l aprob0r aprob1r aprob2r aprob3r m0l m1l m2l m3l m0r m1r m2r m3r u0l u1l u2l u3l u0r u1r u2r u3r euL euR euDiff low high mu test
	tempvar w0l w1l w2l w3l w0r w1r w2r w3r testAl testAr phi eta
	
    * do not display all these steps on the screen
    quietly {

        * initialize the data
        generate int 		`choice' 	= $ML_y1
		generate double 	`mu' 		= exp(`LNmu')
		generate double 	`phi' 		= exp(`LNphi')
		generate double 	`eta' 		= 1

        generate int `aprob0l' = round(($ML_y2+ $ML_y3 + $ML_y4 + $ML_y5)*100)
        generate int `aprob1l' = round(($ML_y3 + $ML_y4 + $ML_y5)*100)
        generate int `aprob2l' = round(($ML_y4 + $ML_y5)*100)
        generate int `aprob3l' = round(($ML_y5 )*100)
		
		generate int `aprob0r' = round(($ML_y6 + $ML_y7 + $ML_y8 + $ML_y9)*100)
        generate int `aprob1r' = round(($ML_y7 + $ML_y8 + $ML_y9)*100)
        generate int `aprob2r' = round(($ML_y8 + $ML_y9)*100)
        generate int `aprob3r' = round(($ML_y9 )*100)
		
		generate double `m0l' = $ML_y10/$scale
        generate double `m1l' = $ML_y11/$scale
        generate double `m2l' = $ML_y12/$scale
        generate double `m3l' = $ML_y13/$scale

        generate double `m0r' = $ML_y14/$scale
        generate double `m1r' = $ML_y15/$scale
        generate double `m2r' = $ML_y16/$scale
        generate double `m3r' = $ML_y17/$scale

		* Generate		
		foreach y in l r {
			generate double `w3`y'' =     0
			replace  		`w3`y'' =     exp((-`eta')*(-ln(`aprob3`y''/100))^`phi')  				if `aprob3`y'' > 0  & (`aprob3`y'') < 100
			replace  		`w3`y'' =     1 if `aprob3`y'' == 100
			replace  		`w3`y'' =     0 if `aprob3`y'' == 0 
			
			generate double `w2`y'' = 	 0
			replace 		`w2`y'' =    exp((-`eta')*(-ln(`aprob2`y''/100))^`phi')      - `w3`y''			if `aprob2`y'' > 0  & (`aprob2`y'') < 100
			replace  		`w2`y'' =    1 - `w3`y''  if `aprob2`y''==100
			replace  		`w2`y'' =    0 if `aprob2`y'' == 0 
			
			generate double `w1`y'' = 	 0
			replace 		`w1`y'' =    exp((-`eta')*(-ln(`aprob1`y''/100))^`phi')    - `w3`y'' - 	`w2`y''		if `aprob1`y'' > 0  & (`aprob1`y'') < 100
			replace  		`w1`y'' =    1  - `w3`y'' - `w2`y''  if `aprob1`y'' ==100
			replace  		`w1`y'' =    0 if `aprob1`y'' == 0 
			
			generate double `w0`y'' =    1 - `w3`y'' - `w2`y'' - `w1`y''
		}
		
        * evaluate the utility function
        forvalues i=0/3 {	
            generate double `u`i'l' = (`m`i'l'^(1-`r'))/(1-`r')
			generate double `u`i'r' = (`m`i'r'^(1-`r'))/(1-`r')
		}
	
        * calculate EU of each lottery
        generate double `euL' = (`w0l'*`u0l')+(`w1l'*`u1l')+(`w2l'*`u2l')+(`w3l'*`u3l')
        generate double `euR' = (`w0r'*`u0r')+(`w1r'*`u1r')+(`w2r'*`u2r')+(`w3r'*`u3r')

        * get the Fechner index
        if "$contextual" == "y" {
             egen `low' = rowmin(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r' )
			egen `high' = rowmax(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r')       
            generate double `euDiff' = ((`euR' - `euL')/(`high'-`low'))/`mu'
        }
        else {
            generate double `euDiff' = (`euR' - `euL')/`mu'
        }			

		replace `lnf'=ln(invlogit( `euDiff')) if $ML_y1==1 
		replace `lnf'=ln(invlogit(-`euDiff')) if $ML_y1==0 
				
        * save the likelihoods
        replace ll = `lnf'
		if "$getLL" =="y" {
			local nLL = $nLL
			forvalues x = 1/`nLL' {
				global ll_`x' = `lnf'[`x']
			}		
		}


	}

end

program ML_crra_PAI_P

	args lnf r LNphi LNeta  LNmu LNrho LNomega

	   * declare temporary variables to be used
    tempvar choice aprob0l aprob1l aprob2l aprob3l aprob0r aprob1r aprob2r aprob3r m0l m1l m2l m3l m0r m1r m2r m3r u0l u1l u2l u3l u0r u1r u2r u3r euL euR euDiff low high wealth mu rho omega		
	tempvar w0l w1l w2l w3l w0r w1r w2r w3r testl testr eta phi

	
    * do not display all these steps on the screen
    quietly {

        * initialize the data
		generate double 	`mu' 		= exp(`LNmu')
		* transform parameters
		generate double 	`rho'   	= 1 - exp(`LNrho' )
        generate double 	`omega' 	= 		$high*exp(`LNomega')
		generate double 	`eta' 		= exp(`LNeta')
		generate double 	`phi' 		= exp(`LNphi')


        generate int 	`choice' = $ML_y1
		generate double `wealth'= $ML_y18

        generate int `aprob0l' = round(($ML_y2+ $ML_y3 + $ML_y4 + $ML_y5)*100)
        generate int `aprob1l' = round(($ML_y3 + $ML_y4 + $ML_y5)*100)
        generate int `aprob2l' = round(($ML_y4 + $ML_y5)*100)
        generate int `aprob3l' = round(($ML_y5 )*100)
		
		generate int `aprob0r' = round(($ML_y6 + $ML_y7 + $ML_y8 + $ML_y9)*100)
        generate int `aprob1r' = round(($ML_y7 + $ML_y8 + $ML_y9)*100)
        generate int `aprob2r' = round(($ML_y8 + $ML_y9)*100)
        generate int `aprob3r' = round(($ML_y9 )*100)

        generate double `m0l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y10/$scale )^`rho')^(1/`rho')  
        generate double `m1l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y11/$scale )^`rho')^(1/`rho')  
        generate double `m2l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y12/$scale )^`rho')^(1/`rho')  
        generate double `m3l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y13/$scale )^`rho')^(1/`rho')
		
        generate double `m0r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y14/$scale )^`rho')^(1/`rho')  
        generate double `m1r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y15/$scale )^`rho')^(1/`rho')  
        generate double `m2r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y16/$scale )^`rho')^(1/`rho')  
        generate double `m3r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y17/$scale )^`rho')^(1/`rho')  
			
			* Generate		
		foreach y in l r {
			generate double `w3`y'' =     0
			replace  		`w3`y'' =     exp((-`eta')*(-ln(`aprob3`y''/100))^`phi')  				if `aprob3`y'' > 0  & (`aprob3`y'') < 100
			replace  		`w3`y'' =     1 if `aprob3`y'' == 100
			replace  		`w3`y'' =     0 if `aprob3`y'' == 0 
			
			generate double `w2`y'' = 	 0
			replace 		`w2`y'' =   exp((-`eta')*(-ln(`aprob2`y''/100))^`phi')      - `w3`y''			if `aprob2`y'' > 0  & (`aprob2`y'') < 100
			replace  		`w2`y'' =    1 - `w3`y''  if `aprob2`y''==100
			replace  		`w2`y'' =    0 if `aprob2`y'' == 0 
			
			generate double `w1`y'' = 	 0
			replace 		`w1`y'' =    exp((-`eta')*(-ln(`aprob1`y''/100))^`phi')    - `w3`y'' - 	`w2`y''		if `aprob1`y'' > 0  & (`aprob1`y'') < 100
			replace  		`w1`y'' =    1  - `w3`y'' - `w2`y''  if `aprob1`y'' ==100
			replace  		`w1`y'' =    0 if `aprob1`y'' == 0 
			
			generate double `w0`y'' =    1 - `w3`y'' - `w2`y'' - `w1`y''
		}
		
		
        * evaluate the utility function
        forvalues i=0/3 {	
            generate double `u`i'l' = (`m`i'l'^(1-`r'))/(1-`r')
			generate double `u`i'r' = (`m`i'r'^(1-`r'))/(1-`r')
		}
	
        * calculate EU of each lottery
        generate double `euL' = (`w0l'*`u0l')+(`w1l'*`u1l')+(`w2l'*`u2l')+(`w3l'*`u3l')
        generate double `euR' = (`w0r'*`u0r')+(`w1r'*`u1r')+(`w2r'*`u2r')+(`w3r'*`u3r')

        * get the Fechner index
       if "$contextual" == "y" {
            egen `low' = rowmin(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r' )
			egen `high' = rowmax(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r')       
            generate double `euDiff' = ((`euR' - `euL')/(`high'-`low'))/`mu'
        }
        else {
            generate double `euDiff' = (`euR' - `euL')/`mu'
        }			

		replace `lnf'=ln(invlogit( `euDiff')) if $ML_y1==1 
		replace `lnf'=ln(invlogit(-`euDiff')) if $ML_y1==0 
		
		
        * save the likelihoods
        replace ll = `lnf'
		if "$getLL" =="y" {
			local nLL = $nLL
			forvalues x = 1/`nLL' {
				global ll_`x' = `lnf'[`x']
			}		
		}


	}

end

program ML_crra_PAI_P1

	args lnf r LNphi LNmu LNrho LNomega

	   * declare temporary variables to be used
    tempvar choice aprob0l aprob1l aprob2l aprob3l aprob0r aprob1r aprob2r aprob3r m0l m1l m2l m3l m0r m1r m2r m3r u0l u1l u2l u3l u0r u1r u2r u3r euL euR euDiff low high wealth mu rho omega		
	tempvar w0l w1l w2l w3l w0r w1r w2r w3r testl testr eta phi
	
    * do not display all these steps on the screen
    quietly {

        * initialize the data
		generate double 	`mu' 		= exp(`LNmu')
		* transform parameters
		generate double `rho'   = 1 - exp(`LNrho' )
        generate double `omega' = 		$high*exp(`LNomega')
		generate double 	`phi' 		= exp(`LNphi')
		generate double 	`eta' 		= 1


        generate int `choice' = $ML_y1
		generate double `wealth'= $ML_y18

        generate int `aprob0l' = round(($ML_y2+ $ML_y3 + $ML_y4 + $ML_y5)*100)
        generate int `aprob1l' = round(($ML_y3 + $ML_y4 + $ML_y5)*100)
        generate int `aprob2l' = round(($ML_y4 + $ML_y5)*100)
        generate int `aprob3l' = round(($ML_y5 )*100)
		
		generate int `aprob0r' = round(($ML_y6 + $ML_y7 + $ML_y8 + $ML_y9)*100)
        generate int `aprob1r' = round(($ML_y7 + $ML_y8 + $ML_y9)*100)
        generate int `aprob2r' = round(($ML_y8 + $ML_y9)*100)
        generate int `aprob3r' = round(($ML_y9 )*100)

        generate double `m0l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y10/$scale )^`rho')^(1/`rho')  
        generate double `m1l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y11/$scale )^`rho')^(1/`rho')  
        generate double `m2l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y12/$scale )^`rho')^(1/`rho')  
        generate double `m3l' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y13/$scale )^`rho')^(1/`rho')
		
        generate double `m0r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y14/$scale )^`rho')^(1/`rho')  
        generate double `m1r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y15/$scale )^`rho')^(1/`rho')  
        generate double `m2r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y16/$scale )^`rho')^(1/`rho')  
        generate double `m3r' = (`omega'*(`wealth'/$scale)^`rho' + ($ML_y17/$scale )^`rho')^(1/`rho')  
		
		
		* Generate		
		foreach y in l r {
			generate double `w3`y'' =     0
			replace  		`w3`y'' =     exp((-`eta')*(-ln(`aprob3`y''/100))^`phi')  				if `aprob3`y'' > 0  & (`aprob3`y'') < 100
			replace  		`w3`y'' =     1 if `aprob3`y'' == 100
			replace  		`w3`y'' =     0 if `aprob3`y'' == 0 
			
			generate double `w2`y'' = 	 0
			replace 		`w2`y'' =   exp((-`eta')*(-ln(`aprob2`y''/100))^`phi')      - `w3`y''			if `aprob2`y'' > 0  & (`aprob2`y'') < 100
			replace  		`w2`y'' =    1 - `w3`y''  if `aprob2`y''==100
			replace  		`w2`y'' =    0 if `aprob2`y'' == 0 
			
			generate double `w1`y'' = 	 0
			replace 		`w1`y'' =    exp((-`eta')*(-ln(`aprob1`y''/100))^`phi')    - `w3`y'' - 	`w2`y''		if `aprob1`y'' > 0  & (`aprob1`y'') < 100
			replace  		`w1`y'' =    1  - `w3`y'' - `w2`y''  if `aprob1`y'' ==100
			replace  		`w1`y'' =    0 if `aprob1`y'' == 0 
			
			generate double `w0`y'' =    1 - `w3`y'' - `w2`y'' - `w1`y''
		}
		
        * evaluate the utility function
        forvalues i=0/3 {	
            generate double `u`i'l' = (`m`i'l'^(1-`r'))/(1-`r')
			generate double `u`i'r' = (`m`i'r'^(1-`r'))/(1-`r')
		}
	
        * calculate EU of each lottery
        generate double `euL' = (`w0l'*`u0l')+(`w1l'*`u1l')+(`w2l'*`u2l')+(`w3l'*`u3l')
        generate double `euR' = (`w0r'*`u0r')+(`w1r'*`u1r')+(`w2r'*`u2r')+(`w3r'*`u3r')

        * get the Fechner index
       if "$contextual" == "y" {
            egen `low' = rowmin(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r' )
			egen `high' = rowmax(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r')       
            generate double `euDiff' = ((`euR' - `euL')/(`high'-`low'))/`mu'
        }
        else {
            generate double `euDiff' = (`euR' - `euL')/`mu'
        }			

		replace `lnf'=ln(invlogit( `euDiff')) if $ML_y1==1 
		replace `lnf'=ln(invlogit(-`euDiff')) if $ML_y1==0 
				
        * save the likelihoods
        replace ll = `lnf'
		if "$getLL" =="y" {
			local nLL = $nLL
			forvalues x = 1/`nLL' {
				global ll_`x' = `lnf'[`x']
			}		
		}


	}

end

program ML_crra_FAI_P

	args lnf r LNphi LNeta LNmu

	   * declare temporary variables to be used
    tempvar choice aprob0l aprob1l aprob2l aprob3l aprob0r aprob1r aprob2r aprob3r m0l m1l m2l m3l m0r m1r m2r m3r u0l u1l u2l u3l u0r u1r u2r u3r euL euR euDiff low high wealth mu
		tempvar w0l w1l w2l w3l w0r w1r w2r w3r eta phi

    * do not display all these steps on the screen
    quietly {

        * initialize the data
		generate double 	`mu' 		= exp(`LNmu')
		generate double 	`eta' 		= exp(`LNeta')
		generate double 	`phi' 		= exp(`LNphi')

        generate int 	`choice' 	= $ML_y1
		generate double `wealth'	= $ML_y18

        generate int `aprob0l' = round(($ML_y2+ $ML_y3 + $ML_y4 + $ML_y5)*100)
        generate int `aprob1l' = round(($ML_y3 + $ML_y4 + $ML_y5)*100)
        generate int `aprob2l' = round(($ML_y4 + $ML_y5)*100)
        generate int `aprob3l' = round(($ML_y5 )*100)
		
		generate int `aprob0r' = round(($ML_y6 + $ML_y7 + $ML_y8 + $ML_y9)*100)
        generate int `aprob1r' = round(($ML_y7 + $ML_y8 + $ML_y9)*100)
        generate int `aprob2r' = round(($ML_y8 + $ML_y9)*100)
        generate int `aprob3r' = round(($ML_y9 )*100)

        generate double `m0l' = (`wealth' + $ML_y10)/$scale
        generate double `m1l' = (`wealth' + $ML_y11)/$scale
        generate double `m2l' = (`wealth' + $ML_y12)/$scale
        generate double `m3l' = (`wealth' + $ML_y13)/$scale

        generate double `m0r' = (`wealth' + $ML_y14)/$scale
        generate double `m1r' = (`wealth' + $ML_y15)/$scale
        generate double `m2r' = (`wealth' + $ML_y16)/$scale
        generate double `m3r' = (`wealth' + $ML_y17)/$scale
		
		* Generate
		foreach y in l r {
			generate double `w3`y'' =     0
			replace  		`w3`y'' =     exp((-`eta')*(-ln(`aprob3`y''/100))^`phi')  	if `aprob3`y'' > 0  & (`aprob3`y'') < 100
			replace  		`w3`y'' =     1 if `aprob3`y'' == 100
			replace  		`w3`y'' =     0 if `aprob3`y'' == 0 
			
			generate double `w2`y'' = 	0
			replace 		`w2`y'' =   exp((-`eta')*(-ln(`aprob2`y''/100))^`phi')    - `w3`y''				if `aprob2`y'' > 0  & (`aprob2`y'') < 100
			replace  		`w2`y'' =     1 - `w3`y''  if `aprob2`y''==100
			replace  		`w2`y'' =     0 if `aprob2`y'' == 0 
			
			generate double `w1`y'' = 	0
			replace 		`w1`y'' =    exp((-`eta')*(-ln(`aprob1`y''/100))^`phi')    - `w3`y'' - 	`w2`y''			if `aprob1`y'' > 0  & (`aprob1`y'') < 100
			replace  		`w1`y'' =     1  - `w3`y'' - `w2`y''  if `aprob1`y'' ==100
			replace  		`w1`y'' =     0 if `aprob1`y'' == 0 
			
			generate double `w0`y'' =     1 - `w3`y'' - `w2`y'' - `w1`y''
		}
		        
        * evaluate the utility function
        forvalues i=0/3 {	
            generate double `u`i'l' = (`m`i'l'^(1-`r'))/(1-`r')
			generate double `u`i'r' = (`m`i'r'^(1-`r'))/(1-`r')
		}
	
        * calculate EU of each lottery
        generate double `euL' = (`w0l'*`u0l')+(`w1l'*`u1l')+(`w2l'*`u2l')+(`w3l'*`u3l')
        generate double `euR' = (`w0r'*`u0r')+(`w1r'*`u1r')+(`w2r'*`u2r')+(`w3r'*`u3r')

        * get the Fechner index
         if "$contextual" == "y" {
              egen `low' = rowmin(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r' )
			egen `high' = rowmax(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r')       
            generate double `euDiff' = ((`euR' - `euL')/(`high'-`low'))/`mu'
        }
        else {
            generate double `euDiff' = (`euR' - `euL')/`mu'
        }			

		replace `lnf'=ln(invlogit( `euDiff')) if $ML_y1==1 
		replace `lnf'=ln(invlogit(-`euDiff')) if $ML_y1==0 
		
		
        * save the likelihoods
        replace ll = `lnf'
		if "$getLL" =="y" {
			local nLL = $nLL
			forvalues x = 1/`nLL' {
				global ll_`x' = `lnf'[`x']
			}		
		}


	}

end

program ML_crra_FAI_P1

	args lnf r LNphi LNmu

	   * declare temporary variables to be used
    tempvar choice aprob0l aprob1l aprob2l aprob3l aprob0r aprob1r aprob2r aprob3r m0l m1l m2l m3l m0r m1r m2r m3r u0l u1l u2l u3l u0r u1r u2r u3r euL euR euDiff low high wealth mu
		tempvar w0l w1l w2l w3l w0r w1r w2r w3r eta phi

    * do not display all these steps on the screen
    quietly {

        * initialize the data
		generate double 	`mu' 		= exp(`LNmu')
		generate double 	`phi' 		= exp(`LNphi')
		generate double 	`eta'		= 1
		
        generate int `choice' = $ML_y1
		generate double `wealth'= $ML_y18

        generate int `aprob0l' = round(($ML_y2+ $ML_y3 + $ML_y4 + $ML_y5)*100)
        generate int `aprob1l' = round(($ML_y3 + $ML_y4 + $ML_y5)*100)
        generate int `aprob2l' = round(($ML_y4 + $ML_y5)*100)
        generate int `aprob3l' = round(($ML_y5 )*100)
		
		generate int `aprob0r' = round(($ML_y6 + $ML_y7 + $ML_y8 + $ML_y9)*100)
        generate int `aprob1r' = round(($ML_y7 + $ML_y8 + $ML_y9)*100)
        generate int `aprob2r' = round(($ML_y8 + $ML_y9)*100)
        generate int `aprob3r' = round(($ML_y9 )*100)

        generate double `m0l' = (`wealth' + $ML_y10)/$scale
        generate double `m1l' = (`wealth' + $ML_y11)/$scale
        generate double `m2l' = (`wealth' + $ML_y12)/$scale
        generate double `m3l' = (`wealth' + $ML_y13)/$scale

        generate double `m0r' = (`wealth' + $ML_y14)/$scale
        generate double `m1r' = (`wealth' + $ML_y15)/$scale
        generate double `m2r' = (`wealth' + $ML_y16)/$scale
        generate double `m3r' = (`wealth' + $ML_y17)/$scale
		
		* Generate weights
		foreach y in l r {
			generate double `w3`y'' =     0
			replace  		`w3`y'' =     exp((-`eta')*(-ln(`aprob3`y''/100))^`phi')  	if `aprob3`y'' > 0  & (`aprob3`y'') < 100
			replace  		`w3`y'' =     1 if `aprob3`y'' == 100
			replace  		`w3`y'' =     0 if `aprob3`y'' == 0 
			
			generate double `w2`y'' = 	 0
			replace 		`w2`y'' =    exp((-`eta')*(-ln(`aprob2`y''/100))^`phi')      - `w3`y''				if `aprob2`y'' > 0  & (`aprob2`y'') < 100
			replace  		`w2`y'' =    1 - `w3`y''  if `aprob2`y''==100
			replace  		`w2`y'' =    0 if `aprob2`y'' == 0 
			
			generate double `w1`y'' = 	 0
			replace 		`w1`y'' =    exp((-`eta')*(-ln(`aprob1`y''/100))^`phi')    - `w3`y'' - 	`w2`y''			if `aprob1`y'' > 0  & (`aprob1`y'') < 100
			replace  		`w1`y'' =    1  - `w3`y'' - `w2`y''  if `aprob1`y'' ==100
			replace  		`w1`y'' =    0 if `aprob1`y'' == 0 
			
			generate double `w0`y'' =    1 - `w3`y'' - `w2`y'' - `w1`y''
		}
		        
        * evaluate the utility function
        forvalues i=0/3 {	
            generate double `u`i'l' = (`m`i'l'^(1-`r'))/(1-`r')
			generate double `u`i'r' = (`m`i'r'^(1-`r'))/(1-`r')
		}
	
        * calculate EU of each lottery
        generate double `euL' = (`w0l'*`u0l')+(`w1l'*`u1l')+(`w2l'*`u2l')+(`w3l'*`u3l')
        generate double `euR' = (`w0r'*`u0r')+(`w1r'*`u1r')+(`w2r'*`u2r')+(`w3r'*`u3r')

        * get the Fechner index
         if "$contextual" == "y" {
            egen `low' = rowmin(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r' )
			egen `high' = rowmax(`u0l' `u1l' `u2l' `u3l' `u0r' `u1r' `u2r' `u3r')       
            generate double `euDiff' = ((`euR' - `euL')/(`high'-`low'))/`mu'
        }
        else {
            generate double `euDiff' = (`euR' - `euL')/`mu'
        }			

		replace `lnf'=ln(invlogit( `euDiff')) if $ML_y1==1 
		replace `lnf'=ln(invlogit(-`euDiff')) if $ML_y1==0 
		
		
        * save the likelihoods
        replace ll = `lnf'
		if "$getLL" =="y" {
			local nLL = $nLL
			forvalues x = 1/`nLL' {
				global ll_`x' = `lnf'[`x']
			}		
		}


	}

end


******************
* LL hood extraction code
******************

* extract LL contributions
program define extractLL
	capture: replace ll_extract = .
	capture: generate ll_extract = .
	local nobs = $nLL
	forvalues x=1/`nobs' {
		local number "ll_`x'"
		replace ll_extract = $`number' if _n==`x'
	}
end
