****************************
*Mean values of the outcome*
****************************
*set trace on

*Loop over values of the treatment 
forvalues t=1/$vtn {
   local j: word `t' of ${vt}
   global j `j'

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
      
      qui su ${out${out}} if ${treat}${ineq}`j' & ${treat}<. ${testw}, meanonly     
      sca m_out_tr`t'_`sfi'=r(mean)   
    
      *We put the average outcome equal to zero for treatment values less than the minimum
      *We do the same for treatment values larger than the highest 
      if ((`t'==1 & `rvt'==1) | (`t'==${vtn} & `rvt'==4)) {   
         sca m_out_tr`t'_`sfi'=0   
      }    
      
      *Expected value conditional on the first instrument   

      *If condition that a monotone instrument is actually used   
      if ("${minstr1}"~="") {

         *Loop over values of the instrument   
         local lr ${mvi1n}   
         forvalues i=1/`lr' {   
         
            local k: word `i' of ${mvi1}   

            *Counting observations
            qui count if (${treat}${ineq}`j' & ${treat}<. & ${minstr1}==`k')>0 

            *Calculations are performed if the number of observations is larger than zero
            if r(N)>0 {
            
               *Calculation of the mean outcome
               qui su ${out${out}} if ${treat}${ineq}`j' & ${treat}<. & ${minstr1}==`k' ///
                  ${testw}, meanonly     
               sca m_out_tr`t'_mi1v`i'_`sfi'=r(mean)   
            }
            else if r(N)==0 {
               
               sca m_out_tr`t'_mi1v`i'_`sfi'=0
            }
            
            *We put the average outcome equal to zero for treatment values less than the minimum
            *We do the same for treatment values larger than the highest 
            if ((`t'==1 & `rvt'==1) | (`t'==${vtn} & `rvt'==4)) {   
               sca m_out_tr`t'_mi1v`i'_`sfi'=0   
            }    
               
            *Checking that there is no missing value for the point estimate   
            if ! (((`t'==1 & `rvt'==1) | (`t'==${vtn} & `rvt'==4)) | r(N)==0) {   
                assert m_out_tr`t'_mi1v`i'_`sfi'>${min${outn}}-${tolr} & ///   
                   m_out_tr`t'_mi1v`i'_`sfi'<${max${outn}}+${tolr}   
            }   
               
         *End of loop over the values of the first instrument   
         }   
      *End of if condition that a monotone instrument is used 	
      }

   *End of loop over ranges of values relative to the treatment value in the loop   
   }    
*End of loop over the values of the treatment
} 

***********************
*Calculation of bounds*
***********************

*Loop over values of the treatment 
forvalues t=1/$vtn {

   local j: word `t' of ${vt}
   global j `j'

   *************************************
   *Exogenous Treatment Selection - ETS*
   *************************************
   if ${g_nex}==1 {   

      *Upper bound    
      sca m_tr`t'_lb_nex = m_out_tr`t'_eq   
      assert m_tr`t'_lb_nex>${min${outn}}-${tolr} & m_tr`t'_lb_nex<${max${outn}}+${tolr}   

      *Lower bound (equal to the upper bound)   
      sca m_tr`t'_ub_nex = m_out_tr`t'_eq   
      assert m_tr`t'_ub_nex>${min${outn}}-${tolr} & m_tr`t'_ub_nex<${max${outn}}+${tolr}   
      
   }   

   *********************
   *No assumptions - NA*   
   *********************
   *If condition that this method is actually used   
   if ${g_n}==1 {   
      
      *Lower bound   
      sca m_tr`t'_lb_n = (m_out_tr`t'_eq*ptr`t'_eq) + ///   
         (${min${outn}}*(ptr`t'_less + ptr`t'_more))	
    	 assert m_tr`t'_lb_n>${min${outn}}-${tolr} & m_tr`t'_lb_n<${max${outn}}+${tolr}             

     *Upper bound   
     sca m_tr`t'_ub_n=(m_out_tr`t'_eq*ptr`t'_eq) + ///   
        (${max${outn}}*(ptr`t'_less + ptr`t'_more))	
        assert m_tr`t'_ub_n>${min${outn}}-${tolr} & m_tr`t'_ub_n<${max${outn}}+${tolr}   

   *End of if condition that this method is actually used below   
   }   

      
   *****
   *MTR*   
   *****
   *If condition that this method is actually used   
   if ${g_nr}==1 {   
      
      *Lower bound   
      sca m_tr`t'_lb_nr = (m_out_tr`t'_less*ptr`t'_less) + ///   
   	 (m_out_tr`t'_eq*ptr`t'_eq) + (${min${outn}}*ptr`t'_more)   
   	 assert m_tr`t'_lb_nr>${min${outn}}-${tolr} & m_tr`t'_lb_nr<${max${outn}}+${tolr}   

      *Upper bound   
      sca m_tr`t'_ub_nr=(${max${outn}}*ptr`t'_less) + (m_out_tr`t'_eq*ptr`t'_eq) + ///   
         (m_out_tr`t'_more*ptr`t'_more)	
    	 assert m_tr`t'_ub_nr>${min${outn}}-${tolr} & m_tr`t'_ub_nr<${max${outn}}+${tolr}   

   *End of if condition that this method is actually used below   
   }   


   ***************************
   *MTR, MIV first instrument*   
   ***************************
   *If condition that an MIV instrument is actually used   
   if "${minstr1}"~="" & ${g_nrmv1}==1 {   
      
      *Indicator of a problem with the monotone instrument   
      global ip_m_tr`t'_nrmv1 = 0   
      
      *Putting the upper and lower bounds to zero   
   	 sca m_tr`t'_ub_nrmv1 = 0   
   	 sca m_tr`t'_lb_nrmv1 = 0   

   	 *Loop over the values of the instrument   
   	 forvalues i=1/$mvi1n {   
 
         if ptr`t'_mi1v`i'_eq>0 {   

   	    *Lower bound calculations   
 
   	    *First, we calculate the value of the lower bound for the instrument value in the loop            
   	    sca lb_mi1v`i'=((m_out_tr`t'_mi1v`i'_less*ptr`t'_mi1v`i'_less) + ///   
    	       (m_out_tr`t'_mi1v`i'_eq*ptr`t'_mi1v`i'_eq) + (${min${outn}}*ptr`t'_mi1v`i'_more))   
   	    *di in red "nrmv1 initial lower bound, treat`j': lv`i' equal to "lb_mi1v`i'     

   	    *Then we loop over values of the instrument less than the current one and take the overall maximum   
   	    *Loop over values less than the current value in the loop   
   	    local ied1 = `i'-1   
   	    forvalues ll=`ied1'(-1)1 {   
   	       sca lb_minsttest`ll' = ((m_out_tr`t'_mi1v`ll'_less*ptr`t'_mi1v`ll'_less) + ///   
   	          (m_out_tr`t'_mi1v`ll'_eq*ptr`t'_mi1v`ll'_eq) + ///   
   	          (${min${outn}}*ptr`t'_mi1v`ll'_more))   
   	       sca lb_mi1v`i'=max(lb_mi1v`i', lb_minsttest`ll')             
   	       sca drop lb_minsttest`ll'    
   	    }   
   	       
   	    *Updating the lower bound by multiplying the bound in the loop with the
   	    *corresponding probability of the instrument   
   	    sca m_tr`t'_lb_nrmv1 = m_tr`t'_lb_nrmv1 + p_mi1v`i'_eq*lb_mi1v`i'   
   	    sca drop lb_mi1v`i'   
     
   	    *Upper bound calculations   

   	    *First, we calculate the value of the upper bound for the instrument value in the loop            
   	    sca ub_mi1v`i'=((${max${outn}}*ptr`t'_mi1v`i'_less) + ///   
   	       (m_out_tr`t'_mi1v`i'_eq*ptr`t'_mi1v`i'_eq) + ///   
               (m_out_tr`t'_mi1v`i'_more*ptr`t'_mi1v`i'_more))	
   	
   	    *Then we loop over values of the instrument greater than the current one and take the overall minimum   
   	    *Loop over values greater than the current value in the loop   
   	    local ied2 = `i'+1   
   	    forvalues ll=`ied2'/$mvi1n {   
   	       sca ub_minsttest`ll' = ((${max${outn}}*ptr`t'_mi1v`ll'_less) + ///   
   	          (m_out_tr`t'_mi1v`ll'_eq*ptr`t'_mi1v`ll'_eq) + ///   
                  (m_out_tr`t'_mi1v`ll'_more*ptr`t'_mi1v`ll'_more))	
   	       sca ub_mi1v`i'=min(ub_mi1v`i', ub_minsttest`ll')             
   	       sca drop ub_minsttest`ll'    
   	    }   
   	       
   	    *Updating the upper bound by multiplying the bound in the loop with the
   	    *corresponding probability of the instrument   
   	    sca m_tr`t'_ub_nrmv1 = m_tr`t'_ub_nrmv1 + p_mi1v`i'_eq*ub_mi1v`i'   
   	    sca drop ub_mi1v`i'   

   	    }   
   	       
   	 *End of loop over the values of the instrument below       
   	 }	       
         
   	 assert m_tr`t'_lb_nrmv1>${min${outn}}-${tolr} & m_tr`t'_lb_nrmv1<${max${outn}}+${tolr} & ///   
   	    m_tr`t'_ub_nrmv1>${min${outn}}-${tolr} & m_tr`t'_ub_nrmv1<${max${outn}}+${tolr}   

   *End of if condition that an MIV instrument is actually used   
   }   
      
   **********************************************************************************************************************   
     
   *Checking whether lower bounds are smaller than upper bounds for methods requiring no bias correction   

   foreach mth in $gnobias0 {   
            
      assert m_tr`t'_lb_`mth'<=m_tr`t'_ub_`mth'+${tolr}   

   }    
      
*End of loop over the values of the treatment below    
}	    
