*This program evaluates probabilities of the treatment

*******************************************************
*Unconditional marginal probability of the instruments* 
*******************************************************

*If condition that a monotone instrument is actually used   
if ("${minstr1}"~="") {

   local lr ${mmxi}   
   forvalues i=1/`lr' {   

      *Loop over values of the instrument   
      sca totp=0   
      local vv = ${mvi`i'n}   
      forvalues i1=1/`vv' {   
         global k: word `i1' of ${mvi`i'}   

         qui gen byte d1=(${minstr`i'}==${k}) if ${minstr`i'}<.    
         qui su d1 ${testw}, meanonly                     
         sca p_mi`i'v`i1'_eq=r(mean)   
         assert (p_mi`i'v`i1'_eq>-${tolr} & p_mi`i'v`i1'_eq<1+${tolr})   
         sca totp = totp + p_mi`i'v`i1'_eq   
         drop d1   

      }   
      *Checking that the probabilities sum up to 1   
      assert abs(totp-1)<${tolr}   
      sca drop totp   

   *End of loop over instruments   
   }   
*End of if condition that either a monotone or an exogenous instrument is actually used 
}

****************************************
*Probabilities related to the treatment*
****************************************

*Loop over values of the treatment 
forvalues t=1/$vtn {
   local j: word `t' of ${vt}

   *Loop over ranges of values relative to the treatment value in the loop   
   foreach rvt in 0 1 4 {   
      *Equal   
      if `rvt'==0 {   
         global ineq "=="   
         local sfi eq   
      }   
      *Lower   
      else if `rvt'==1 {   
         global ineq "<"   
         local sfi less   
      }   
      *Lower or equal   
      else if `rvt'==2 {   
         global ineq "<="   
         local sfi lesseq   
      }   
      *Greater or equal   
      else if `rvt'==3 {   
         global ineq ">="   
         local sfi moreeq   
      }   
      *Greater   
      else if `rvt'==4 {   
         global ineq ">"   
         local sfi more   
      }   

      ****************************************
      *Probability of receiving the treatment*
      ****************************************

      qui gen byte d1=(${treat}${ineq}`j') if ${treat}<.   
      qui su d1 ${testw}, meanonly                  
      sca ptr`t'_`sfi'=r(mean)
      assert (ptr`t'_`sfi'>-${tolr} & ptr`t'_`sfi'<1+${tolr})
      drop d1
      
      *Probabilities of treatment conditional on the first MIV instrument

      *If condition that a monotone instrument is actually used   
      if ("${minstr1}"~="") {

      	 *Loop over values of the instrument      
      	 local vv = ${mvi1n}   
      	 forvalues i=1/`vv' {   
      	    global k: word `i' of ${mvi1}   

      	    *Probability given the current value of the instrument in the loop   
      	    qui gen byte d1=(${treat}${ineq}`j') if ${treat}<. & ${minstr1}==${k}    
      	    qui su d1 ${testw}, meanonly                     
      	    sca ptr`t'_mi1v`i'_`sfi'=r(mean)   
      	    assert ptr`t'_mi1v`i'_`sfi'>-${tolr} & ptr`t'_mi1v`i'_`sfi'<1+${tolr}   
      	    drop d1   
      	       
      	    *Checking that the probabilities sum to 1   
      	    if `rvt'==4 {   
      	       assert abs(1-(ptr`t'_mi1v`i'_less+ptr`t'_mi1v`i'_eq+ptr`t'_mi1v`i'_more))<${tolr}   
      	    }   
      	       
      	 *End of loop over the values of the first instrument   
      	 }   
   
      *End of if condition that either a monotone or an exogenous instrument is actually used   
      } 
   *End of loop over ranges of values relative to the treatment value in the loop   
   }    
*End of the loop over the value of the treatment
}


