	
	////////////////////////////////////////
	////////////////////////////////////////
	/////    Loading Data              /////
	////////////////////////////////////////
	////////////////////////////////////////
	
	/* We need to increase the maximum number of variables of stata */
	clear
    capture set maxvar  32767 
	
	clear
	/*Define working directory */
    cd "C:\"
	
    /* Loading data from Experiment 1 */
    clear
    import excel "Dataset Limelight.xls", sheet("Experiment 1") cellrange(A1:AL580) firstrow
    save "Dataset Limelight Experiment 1.dta", replace
    
    /* Loading data from Experiment 2 */
    clear
    import excel "Dataset Limelight.xls", sheet("Experiment 2") cellrange(A1:AL1368) firstrow
    save "Dataset Limelight Experiment 2.dta", replace
    
    /* Combining both Experiments into one dataset */
    clear

    use "Dataset Limelight Experiment 1.dta"
    append using "Dataset Limelight Experiment 2.dta"
	save "Dataset Limelight Full.dta", replace

	////////////////////////////////////////
	////////////////////////////////////////
	/////    Decision variable         /////
	////////////////////////////////////////
	////////////////////////////////////////

    /* For our analyses it is convenient to recode the decision variable to
       take the value 1 for "No Deal" and 0 for "Deal" */

	qui gen decision = (deal==0)
    label define dond 1 "No Deal" 0 "Deal" 
    label values decision dond

	////////////////////////////////////////
	////////////////////////////////////////
	/////    Sort Suitcases            /////
	////////////////////////////////////////
	////////////////////////////////////////
 	
    /* Furthermore, it is beneficial to remove the gaps between suitcases to
       facilitate computations */
	
	* Creating temporary variables that facilitate ordering
	forvalues x = 1/26 {
	qui gen xtemp_`x'  = x`x'
	}
	
	qui gen temp    = 0
	
    * Creating buckets for the sorted suitcases
	forvalues x = 1/20 {
	qui gen xs_`x'     = .
	}
    
    * Ordering suitcases
	forvalues x = 20(-1)1 {
	forvalues y = 26(-1)1 {
	qui replace temp      = xtemp_`y'  if xtemp_`y'!=0 & xs_`x'==.  
	qui replace xtemp_`y' = 0          if xtemp_`y'!=0 & xs_`x'==.      
	qui replace xs_`x'    = temp       if xs_`x'==. &temp!=0
	qui replace temp      = 0 
	}
	}

    * Removing temporary variables
    drop xtemp* temp
	
	////////////////////////////////////////
	////////////////////////////////////////
	/////   Excected value suitcase    /////
	////////////////////////////////////////
	////////////////////////////////////////
	
    /* Here we create the variables that are related to the expected value of the subject's suitcase */
	
	* Creating a variable giving the expected value of the subject's suitcase
	qui gen ev = .
	qui replace ev = (xs_1+xs_2+xs_3+xs_4+xs_5+xs_6+xs_7+xs_8+xs_9+xs_10+xs_11+xs_12+xs_13+xs_14+xs_15+xs_16+xs_17+xs_18+xs_19+xs_20)/20 if round==1
	qui replace ev = (xs_6+xs_7+xs_8+xs_9+xs_10+xs_11+xs_12+xs_13+xs_14+xs_15+xs_16+xs_17+xs_18+xs_19+xs_20)/15 if round==2
	qui replace ev = (xs_10+xs_11+xs_12+xs_13+xs_14+xs_15+xs_16+xs_17+xs_18+xs_19+xs_20)/11 if round==3
	qui replace ev = (xs_13+xs_14+xs_15+xs_16+xs_17+xs_18+xs_19+xs_20)/8 if round==4
	qui replace ev = (xs_15+xs_16+xs_17+xs_18+xs_19+xs_20)/6 if round==5
	qui replace ev = (xs_16+xs_17+xs_18+xs_19+xs_20)/5 if round==6
	qui replace ev = (xs_17+xs_18+xs_19+xs_20)/4 if round==7
	qui replace ev = (xs_18+xs_19+xs_20)/3 if round==8
	qui replace ev = (xs_19+xs_20)/2 if round==9
	
	* Creating variables that will be used in the probit analyses based on the expected value
	qui gen evoffer = ev/offer
	qui gen offerev = offer/ev
	qui gen ev100   = ev/100
	
	* For some analyses we also need the initial expected value, which is fixed in our experiments
	qui gen initialev = (9*0.01+0.05+0.1+0.25+0.5+0.75+1+2.5+5+7.5+10+20+30+40+50+100+250+500)/26

	////////////////////////////////////////
	////////////////////////////////////////
	/////  Expectations for next round /////
	////////////////////////////////////////
	////////////////////////////////////////

    /* For the structural model estimates and for the probit analyses,
       we need to compute the potential EVs in the next round, the resulting expected bank
       offers, and the associated probabilities. Here we will create these entities. */

	gen evcount =comb(8,5)+comb(8,4)+comb(8,3)+comb(8,2)+comb(8,1)+comb(8,0)
	qui sum evcount
	forvalues x = 1/`r(max)' {
	qui gen EV`x' = 0
	qui gen P`x'  = 0
	}

	////////////////////////////////////////
	/////     Round 9                  /////
	////////////////////////////////////////

	qui replace EV1 = xs_20 if round==9
	qui replace EV2 = xs_19 if round==9

	qui replace P1   = 0.5   if round==9
	qui replace P2   = 0.5   if round==9

	////////////////////////////////////////
	/////     Round 8                  /////
	////////////////////////////////////////

	qui replace EV1 = (xs_20+xs_19)/2 if round==8
	qui replace EV2 = (xs_20+xs_18)/2 if round==8
	qui replace EV3 = (xs_19+xs_18)/2 if round==8

	qui replace P1   = 1/3   if round==8
	qui replace P2   = 1/3   if round==8
	qui replace P3   = 1/3   if round==8

	////////////////////////////////////////
	/////     Round 7                  /////
	////////////////////////////////////////

	qui replace EV1 = (xs_20+xs_19+xs_18)/3 if round==7
	qui replace EV2 = (xs_20+xs_19+xs_17)/3 if round==7
	qui replace EV3 = (xs_20+xs_17+xs_18)/3 if round==7
	qui replace EV4 = (xs_17+xs_19+xs_18)/3 if round==7

	qui replace P1  = 0.25   if round==7
	qui replace P2  = 0.25   if round==7
	qui replace P3  = 0.25   if round==7
	qui replace P4  = 0.25   if round==7

	////////////////////////////////////////
	/////     Round 6                  /////
	////////////////////////////////////////

	qui replace EV1 = (xs_20+xs_19+xs_18+xs_17)/4 if round==6
	qui replace EV2 = (xs_20+xs_19+xs_18+xs_16)/4 if round==6
	qui replace EV3 = (xs_20+xs_19+xs_16+xs_17)/4 if round==6
	qui replace EV4 = (xs_20+xs_16+xs_18+xs_17)/4 if round==6
	qui replace EV5 = (xs_16+xs_19+xs_18+xs_17)/4 if round==6

	qui replace P1  = 0.2    if round==6
	qui replace P2  = 0.2    if round==6
	qui replace P3  = 0.2    if round==6
	qui replace P4  = 0.2    if round==6
	qui replace P5  = 0.2    if round==6

	////////////////////////////////////////
	/////     Round 5                  /////
	////////////////////////////////////////

	qui replace EV1 = (xs_20+xs_19+xs_18+xs_17+xs_16)/5 if round==5
	qui replace EV2 = (xs_20+xs_19+xs_18+xs_17+xs_15)/5 if round==5
	qui replace EV3 = (xs_20+xs_19+xs_18+xs_15+xs_16)/5 if round==5
	qui replace EV4 = (xs_20+xs_19+xs_15+xs_17+xs_16)/5 if round==5
	qui replace EV5 = (xs_20+xs_15+xs_18+xs_17+xs_16)/5 if round==5
	qui replace EV6 = (xs_15+xs_19+xs_18+xs_17+xs_16)/5 if round==5

	qui replace P1  = 1/6    if round==5
	qui replace P2  = 1/6    if round==5
	qui replace P3  = 1/6    if round==5
	qui replace P4  = 1/6    if round==5
	qui replace P5  = 1/6    if round==5
	qui replace P6  = 1/6    if round==5

	////////////////////////////////////////
	/////     Round 4                  /////
	////////////////////////////////////////
	
	/* Here the coding becomes too involved to program all combinations by hand.
	   Therefore, we use the tuples command to create a list of all possible
	   combinations to be drawn out of the remaining suitcases. We then use this
	   list to derive all possible EVs that can result in the next round.
	   Note: if you do not have the tuples yet type  "ssc d tuples" followed by
	   "ssc install tuples". */
    
    tuples xs_20 xs_19 xs_18 xs_17 xs_16 xs_15 xs_14 xs_13,  max(2)

    local i = 1
    
	local totalcomb = comb(8,1)+comb(8,2)
	local lowercomb = comb(8,1)+1
     
	qui egen total   = rsum(xs_20 xs_19 xs_18 xs_17 xs_16 xs_15 xs_14 xs_13)

	forvalues x = `lowercomb'/`totalcomb'{
	qui egen open`x' = rsum(`tuple`x'')
	qui replace EV`i'= (total-open`x')/6 if round==4
    qui replace P`i' = 1/comb(8,2)       if round==4
    drop open`x'
    local i=`i'+1
	}
	
	drop total
    
	////////////////////////////////////////
	/////     Round 3                  /////
	////////////////////////////////////////

    tuples xs_20 xs_19 xs_18 xs_17 xs_16 xs_15 xs_14 xs_13 xs_12 xs_11 xs_10 ,  max(3)

    local i = 1
    
	local totalcomb = comb(11,1)+comb(11,2)+comb(11,3)
	local lowercomb = comb(11,1)+comb(11,2)+1
     
	qui egen total   = rsum(xs_20 xs_19 xs_18 xs_17 xs_16 xs_15 xs_14 xs_13 xs_12 xs_11 xs_10)

	forvalues x = `lowercomb'/`totalcomb'{
	qui egen open`x' = rsum(`tuple`x'')
	qui replace EV`i'= (total-open`x')/8 if round==3
    qui replace P`i' = 1/comb(11,3)      if round==3
    drop open`x'
    local i=`i'+1
	}
	 
	drop total

	////////////////////////////////////////
	/////     Round 2                  /////
	////////////////////////////////////////
	
	/* Round 1 and 2 have a large number of possibilities. Round 1 has 15504, round 2 has 1365 combinations.
	   To simplify, we take the 8 highest prizes left in the game, and set the remaining prizes equal to their average.
	   We have verified that this approximation is extremely accurate.
	  */
	  
	  
	tuples xs_20 xs_19 xs_18 xs_17 xs_16 xs_15 xs_14 xs_13,  max(4)
 
  	qui egen total       = rsum(xs_20 xs_19 xs_18 xs_17 xs_16 xs_15 xs_14 xs_13 xs_12 xs_11 xs_10 xs_9 xs_8 xs_7 xs_6)
    qui egen lowcases    = rsum(xs_12 xs_11 xs_10 xs_9 xs_8 xs_7 xs_6)
	qui replace lowcases = lowcases/7
	
     
    replace EV1 = (total - 4*lowcases)/11    if round==2
	replace P1  = comb(7,4)/comb(15,4)	     if round==2
	
	local i= 2
	local totalcomb = comb(8,1)
    local lowercomb = 1
	forvalues x = `lowercomb'/`totalcomb'{
	qui egen open`x' = rsum(`tuple`x'')
	qui replace open`x' = open`x'+3*lowcases
	qui replace EV`i'= (total-open`x')/11 if round==2
    qui replace P`i' = comb(7,3)/comb(15,4)       if round==2
    drop open`x'
    local i=`i'+1
	 }
	
    local totalcomb = comb(8,2)+comb(8,1)
    local lowercomb = comb(8,1)+1
    
	forvalues x = `lowercomb'/`totalcomb'{
	qui egen open`x' = rsum(`tuple`x'')
	qui replace open`x' = open`x'+2*lowcases
	qui replace EV`i'= (total-open`x')/11 if round==2
    qui replace P`i' = comb(7,2)/comb(15,4)       if round==2
    drop open`x'
    local i=`i'+1
	 }
	 
    local totalcomb = comb(8,3)+comb(8,2)+comb(8,1)
    local lowercomb = comb(8,2)+comb(8,1)+1
	forvalues x = `lowercomb'/`totalcomb'{
	qui egen open`x' = rsum(`tuple`x'')
	qui replace open`x' = open`x'+ lowcases
	qui replace EV`i'= (total-open`x')/11 if round==2
    qui replace P`i' = comb(7,1)/comb(15,4)       if round==2
    drop open`x'
    local i=`i'+1
	 }
	 	 
	local totalcomb = comb(8,4)+comb(8,3)+comb(8,2)+comb(8,1)
    local lowercomb = comb(8,3)+comb(8,2)+comb(8,1)+1
    
	forvalues x = `lowercomb'/`totalcomb'{
	qui egen open`x' = rsum(`tuple`x'')
	qui replace EV`i'= (total-open`x')/11 if round==2
    qui replace P`i' = comb(7,0)/comb(15,4)       if round==2
    drop open`x'
    local i=`i'+1
	 }
	 
		
	drop total lowcases

	////////////////////////////////////////
	/////     Round 1                  /////
	////////////////////////////////////////
   

    tuples xs_20 xs_19 xs_18 xs_17 xs_16 xs_15 xs_14 xs_13,  max(5)

    local i= 1
    	  
	qui egen total   = rsum(xs_20 xs_19 xs_18 xs_17 xs_16 xs_15 xs_14 xs_13 xs_12 xs_11 xs_10 xs_9 xs_8 xs_7 xs_6 xs_5 xs_4 xs_3 xs_2 xs_1)
    qui egen lowcases    = rsum(xs_12 xs_11 xs_10 xs_9 xs_8 xs_7 xs_6 xs_5 xs_4 xs_3 xs_2 xs_1)
	qui replace lowcases = lowcases/12

	replace EV1 = (total - 5*lowcases)/15    if round==1
	replace P1  = comb(12,5)/comb(20,5)	     if round==1

	local i= 2
	local totalcomb = comb(8,1)
    local lowercomb = 1
	forvalues x = `lowercomb'/`totalcomb'{
	qui egen open`x' = rsum(`tuple`x'')
	qui replace open`x' = open`x'+4*lowcases
	qui replace EV`i'= (total-open`x')/15 if round==1
    qui replace P`i' = comb(12,4)/comb(20,5)       if round==1
    drop open`x'
    local i=`i'+1
	 }
	
    local totalcomb = comb(8,2)+comb(8,1)
    local lowercomb = comb(8,1)+1
    
	forvalues x = `lowercomb'/`totalcomb'{
	qui egen open`x' = rsum(`tuple`x'')
	qui replace open`x' = open`x'+3*lowcases
	qui replace EV`i'= (total-open`x')/15 if round==1
    qui replace P`i' = comb(12,3)/comb(20,5)       if round==1
    drop open`x'
    local i=`i'+1
	 }
	 
    local totalcomb = comb(8,3)+comb(8,2)+comb(8,1)
    local lowercomb = comb(8,2)+comb(8,1)+1
	forvalues x = `lowercomb'/`totalcomb'{
	qui egen open`x' = rsum(`tuple`x'')
	qui replace open`x' = open`x'+ 2*lowcases
	qui replace EV`i'= (total-open`x')/15 if round==1
    qui replace P`i' = comb(12,2)/comb(20,5)       if round==1
    drop open`x'
    local i=`i'+1
	 }
	 	 
	local totalcomb = comb(8,4)+comb(8,3)+comb(8,2)+comb(8,1)
    local lowercomb = comb(8,3)+comb(8,2)+comb(8,1)+1
    
	forvalues x = `lowercomb'/`totalcomb'{
	qui egen open`x' = rsum(`tuple`x'')
	qui replace EV`i'= (total-open`x')/15 if round==1
    qui replace P`i' = comb(12,1)/comb(20,5)       if round==1
    drop open`x'
    local i=`i'+1
	 }
	 
	local totalcomb = comb(8,5)+comb(8,4)+comb(8,3)+comb(8,2)+comb(8,1)
    local lowercomb = comb(8,4)+comb(8,3)+comb(8,2)+comb(8,1)+1
    
	forvalues x = `lowercomb'/`totalcomb'{
	qui egen open`x' = rsum(`tuple`x'')
	qui replace EV`i'= (total-open`x')/15 if round==1
    qui replace P`i' = comb(12,0)/comb(20,5)       if round==1
    drop open`x'
    local i=`i'+1
	 }	
	drop total
	 
	

    ////////////////////////////////////////
	////////////////////////////////////////
	/////  Standard Deviation of EVs   /////
	////////////////////////////////////////
	////////////////////////////////////////

    /* For the probit analyses we need a measure of the standard deviation of
       the future EVs. Here we compute this measure */

	
	qui gen FutureEVmean = 0
	
	qui sum evcount
	forvalues x = 1/`r(max)' {	
	qui replace FutureEVmean = FutureEVmean + P`x'*EV`x'
	}
	
	qui gen variance = 0
	qui sum evcount
	forvalues x = 1/`r(max)' {
	qui replace variance = variance + P`x'*(EV`x'-FutureEVmean)^2
	}
	
	qui gen stdev   = sqrt(variance)
	qui gen stdevev = stdev/ev
	drop variance 

	gen P = 0
	qui sum evcount
	forvalues x = 1/`r(max)' {
	replace P = P + P`x'
	}
	

    ////////////////////////////////////////
	////////////////////////////////////////
	/////  Generating Expected Offers  /////
	////////////////////////////////////////
	////////////////////////////////////////

    /* For the structural models, we require expected offers, not expected values.
    These are computed here. */
    
	qui sum evcount
	forvalues x = 1/`r(max)' {
	qui gen expoff`x'     = 0.30*EV`x' if round==1 & exp2
	qui replace expoff`x' = 0.45*EV`x' if round==2 & exp2
	qui replace expoff`x' = 0.60*EV`x' if round==3 & exp2
	qui replace expoff`x' = 0.70*EV`x' if round==4 & exp2
	qui replace expoff`x' = 0.80*EV`x' if round==5 & exp2
	qui replace expoff`x' = 0.90*EV`x' if round==6 & exp2
	qui replace expoff`x' = 1.00*EV`x' if round==7 & exp2
	qui replace expoff`x' = 1.00*EV`x' if round==8 & exp2
	qui replace expoff`x' = 1.00*EV`x' if round==9 & exp2
	qui replace expoff`x' = EV`x'*(offerev + (1 - offerev)* 0.832 ^(9-round)) if exp1
	drop EV`x'
	}
	
	/* The highest and lowest expected offers are used to constrain the reference point.
	   The following code generates their values */
	   
	qui gen highestexpoff = 0
	qui gen lowestexpoff  = 500
	
	qui sum evcount
	forvalues x = 1/`r(max)' {
	qui replace highestexpoff = max(highestexpoff,expoff`x') if expoff`x'!=0
	qui replace lowestexpoff  = min(lowestexpoff,expoff`x')  if expoff`x'!=0
	}
	
	
    ////////////////////////////////////////
	////////////////////////////////////////
	/////    Winners and losers		   /////
	////////////////////////////////////////
	////////////////////////////////////////
	
	/* In some parts of the paper, we split up the sample into losers, neutrals,
	   and winners. The following code constructs these groups as defined in the paper.
    */
	
	* We create a counter for number of cases left as this will facilitate computations
	qui gen numcases = 0

	forvalues x = 1/20 {
	qui replace numcases = numcases + 1 if xs_`x'!=.
	}
	
	* We take the value of the best and worst prize still left in the game
	gen xsmin = min(xs_1,xs_2,xs_3,xs_4,xs_5,xs_6,xs_7,xs_8,xs_9,xs_10,xs_11,xs_12,xs_13,xs_14,xs_15,xs_16,xs_17,xs_18,xs_19,xs_20)
    gen xsmax = max(xs_1,xs_2,xs_3,xs_4,xs_5,xs_6,xs_7,xs_8,xs_9,xs_10,xs_11,xs_12,xs_13,xs_14,xs_15,xs_16,xs_17,xs_18,xs_19,xs_20)
	
	* We use these variables to define the worst case and best case scenario for each subject.
	qui gen WC  = round((numcases*ev)-xsmax,0.01)/(numcases-1)
	qui gen BC  = round((numcases*ev)-xsmin,0.01)/(numcases-1)
	
	* We order subjects on the basis of their best case scenario
	sort exp2 limelight comeback round BC
	bysort exp2 limelight comeback round: gen orderBC = _n
	bysort exp2 limelight comeback round: gen totalBC = _N
	
	* We determine the size of the groups
	qui gen cat_size = ceil((1/3)*totalBC)
	
	* We take the subjects with the worst BC
	qui gen worstBC = (orderBC<=cat_size)
	
	/* We make sure that if two subjects have the same BC, it cannot be that
	   one subject is said to have the worst BC, while the other hasn't. In
	   this case both are said not to have the worst BC */
	   
	sort exp2 limelight comeback round BC
	qui replace worstBC = 0 if worstBC==1 & BC[_n-1]==BC & worstBC[_n-1]==0 & round[_n-1]==round
	qui replace worstBC = 0 if worstBC==1 & BC[_n-1]==BC & worstBC[_n-1]==0 & round[_n-1]==round
	qui replace worstBC = 0 if worstBC==1 & BC[_n-1]==BC & worstBC[_n-1]==0 & round[_n-1]==round
	qui replace worstBC = 0 if worstBC==1 & BC[_n-1]==BC & worstBC[_n-1]==0 & round[_n-1]==round
	qui replace worstBC = 0 if worstBC==1 & BC[_n-1]==BC & worstBC[_n-1]==0 & round[_n-1]==round
	
	qui replace worstBC = 0 if worstBC==1 & BC[_n+1]==BC & worstBC[_n+1]==0 & round[_n+1]==round
	qui replace worstBC = 0 if worstBC==1 & BC[_n+1]==BC & worstBC[_n+1]==0 & round[_n+1]==round
	qui replace worstBC = 0 if worstBC==1 & BC[_n+1]==BC & worstBC[_n+1]==0 & round[_n+1]==round
	qui replace worstBC = 0 if worstBC==1 & BC[_n+1]==BC & worstBC[_n+1]==0 & round[_n+1]==round
	qui replace worstBC = 0 if worstBC==1 & BC[_n+1]==BC & worstBC[_n+1]==0 & round[_n+1]==round
	
	* After this we order subjects on the basis of their worst case scenario
	qui gen reverseWC = -1*WC
	sort exp2 limelight comeback round reverseWC
	bysort exp2 limelight comeback round: gen orderWC = _n
	bysort exp2 limelight comeback round: gen totalWC = _N
	
    * We take the subjects with the best WC
	qui gen bestWC = (orderWC<=cat_size)

	/* We make sure that if two subjects have the same WC, it cannot be that
	   one subject is said to have the best WC, while the other hasn't. In
	   this case both are said not to have the best WC */
	   	
	sort exp2 limelight comeback round reverseWC
	qui replace bestWC = 0 if bestWC==1 & reverseWC[_n-1]==reverseWC & bestWC[_n-1]==0 & round[_n-1]==round
	qui replace bestWC = 0 if bestWC==1 & reverseWC[_n-1]==reverseWC & bestWC[_n-1]==0 & round[_n-1]==round
	qui replace bestWC = 0 if bestWC==1 & reverseWC[_n-1]==reverseWC & bestWC[_n-1]==0 & round[_n-1]==round
	qui replace bestWC = 0 if bestWC==1 & reverseWC[_n-1]==reverseWC & bestWC[_n-1]==0 & round[_n-1]==round
	qui replace bestWC = 0 if bestWC==1 & reverseWC[_n-1]==reverseWC & bestWC[_n-1]==0 & round[_n-1]==round

	qui replace bestWC = 0 if bestWC==1 & reverseWC[_n+1]==reverseWC & bestWC[_n+1]==0 & round[_n+1]==round
	qui replace bestWC = 0 if bestWC==1 & reverseWC[_n+1]==reverseWC & bestWC[_n+1]==0 & round[_n+1]==round
	qui replace bestWC = 0 if bestWC==1 & reverseWC[_n+1]==reverseWC & bestWC[_n+1]==0 & round[_n+1]==round
	qui replace bestWC = 0 if bestWC==1 & reverseWC[_n+1]==reverseWC & bestWC[_n+1]==0 & round[_n+1]==round
	qui replace bestWC = 0 if bestWC==1 & reverseWC[_n+1]==reverseWC & bestWC[_n+1]==0 & round[_n+1]==round
	
	/* On the basis of these variables we determine winners and losers.*/
	   
	qui gen loser  = (worstBC==1&bestWC==0)
	qui gen winner = (worstBC==0&bestWC==1)
	qui gen neutral= (worstBC==bestWC)
    
    * Now we remove all the unnecessary variables 
    drop numcases-bestWC
	
	save "Dataset Limelight for Analyses.dta",  replace
