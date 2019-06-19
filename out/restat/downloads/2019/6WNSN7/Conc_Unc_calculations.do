*This program calculates the bounds for means of the outcomes
*set trace on

*Calculating the various probabilities
do "${projf}/Programs/Bounds/Conc_Unc_probabilities.do"

*Calculating  average treatment effects
if $meanact==1 {
   do "${projf}/Programs/Bounds/Conc_Unc_expv.do"
}

*Calculating the differences between bounds of different treatments
*set trace on

*Loop over methods
foreach mth in $gmethod {

*Loop over statistics
forvalues stn=1/$stat_n {
   local st: word `stn' of ${stat}

   *Recording the if conditions for the methods that do and do not require a minimum of 0 for the ATE
   global mne ""
   global me ""
   forvalues k=1/$nm0 {
      local gm: word `k' of ${m0}
      if `k'==1 {
         global mne "`mth'"!="`gm'"
         global me "`mth'"=="`gm'"
      }
      else if `k'>1 {
         global mne "${mne}" & "`mth'"!="`gm'"
         global me "${me}" | "`mth'"=="`gm'"
      }
   }

   *Outer loop over values of the treatment            
   forvalues t=1/$vtn2 {
      local jj = `t'+ 1             

      *Outer loop over values of the treatment
      forvalues m = `jj'/$vtn {            
         
         *By assumption the bounds cannot be less than zero once one imposes MTR
         
         *Lower bound of the difference           
                  
         if ("${mne}") {
            sca `st'_tr`m'_tr`t'_lb_`mth' = max(0,`st'_tr`m'_lb_`mth' - `st'_tr`t'_ub_`mth') 
            assert `st'_tr`m'_tr`t'_lb_`mth'< (${max${outn}}-${min${outn}})+${tolr}   
         }
         else if ("${me}") {
            sca `st'_tr`m'_tr`t'_lb_`mth' = `st'_tr`m'_lb_`mth' - `st'_tr`t'_ub_`mth'            
            assert `st'_tr`m'_tr`t'_lb_`mth'> (${min${outn}}-${max${outn}})-${tolr}   & ///
               `st'_tr`m'_tr`t'_lb_`mth'< (${max${outn}}-${min${outn}})+${tolr} 
         }

         *Upper bound of the difference            
         if ("${mne}") {
            sca `st'_tr`m'_tr`t'_ub_`mth' = max(0,`st'_tr`m'_ub_`mth' - `st'_tr`t'_lb_`mth')
            assert `st'_tr`m'_tr`t'_ub_`mth'< (${max${outn}}-${min${outn}})+${tolr} 
         }
         else if ("${me}") {
            sca `st'_tr`m'_tr`t'_ub_`mth' = `st'_tr`m'_ub_`mth' - `st'_tr`t'_lb_`mth'
            assert `st'_tr`m'_tr`t'_ub_`mth'> (${min${outn}}-${max${outn}})-${tolr}   & ///
	       `st'_tr`m'_tr`t'_ub_`mth'< (${max${outn}}-${min${outn}})+${tolr} 
         }


      *End of inner loop over the values of the treatment	    
      }            
   *End of outer loop over the values of the treatment	    
   }

*End of loop over statistics
}
*End of loop over methods
}

