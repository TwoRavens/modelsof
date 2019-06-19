*This program generates results using partial identification
*The program is run for the project on consumption uncertainty and precautionary saving using DNB data
*November 2018 - D. Christelis, D. Georgarakos, T. Jappelli, M. van Rooij

version 13.1
clear all
macro drop _all
set maxvar 3000
set matsize 1100
set more off
set seed 1234

*ATTENTION - ATTENTION - ATTENTION 
*The following lines defines the file path. Please adapt to own computer
do "c:/foldp/foldp.do"
global projf "${foldp}/DNB_survey_consumption/ConGrowth/Replication"

*Reading parameters
qui do "${projf}/Programs/Bounds/Par_Conc_Unc.do"

*Log file
cap log close   
log using "${projf}/Programs/Bounds/PI_dist_${dist}_b${bsn}.log", replace   
   
global stdate $S_DATE 
global sttime $S_TIME   
noisily display "Begin program at ${stdate} ${sttime}"   /* time stamp */   
   
*Loop over outcomes      
forvalues out=1/$outno {      
   global out `out'      
   local out`out': word `out' of ${outl}      
      
   global out`out' `out`out''      
   global outn: word `out' of ${outl}      
      
   *Loop over treatments      
   *First element of the loop      
   local fltv: word 1 of ${gtlist}       
      
   forvalues tv=1/$tno {      
      global tv `tv'
      global treat: word `tv' of ${gtlist}      
      
      *Reading the data                  
      qui use "${projf}/Data/Data_cons_uncertainty.dta", clear       

      *There are few observations in the 2nd quantile, and thus we merge it with the
      *first quantile
      if ("${minstr1}"=="q10_hvsptri_incgr" | "${minstr1}"=="q10_hvtrio_incgr")  {      
         qui replace ${minstr1}=1 if ${minstr1}==2      
      }      
      if ("${minstr1}"=="q10_hvsptri_incgr" | "${minstr1}"=="q10_hvtrio_incgr") {      
         qui replace ${minstr1}=${minstr1}-1 if ${minstr1}>1 & ${minstr1}<.      
      }      

      *Dropping observations in which the outcome, treatment or the sampling weight is missing            
      qui drop if (${out${out}}>=.) | ${treat}>=. | (${wgt}>=. | ${wgt}<${tolr})      
         
      *Defining the treatments
      qui do "${projf}/Programs/Bounds/Conc_Unc_treat_definitions.do"  
         
      *Deleting missing values so as to keep sample size the same across distributions      
      qui keep if regio<.       
      if "${dist}"=="trio" {      
            
         qui keep if hmsptri_sqcgr<. & hvsptri_incgr<.               
      }      
            
      *Maximum and minimum treatment values      
      qui su ${treat} [aw=${wgt}], d      
      global max${treat} = r(max)      
      global min${treat} = r(min)      

      *Maximum and minimum possible values of outcomes
      qui su ${out`out'} [aw=${wgt}]       
      global min${outn} = r(min)      
      global max${outn} = r(max)      
      
      *Number of observations      
      qui count 
      sca nobs_nomiv = r(N)	
            
      *Number of obs for both samples, taking into account the MIV assumption instruments                  
      if "${minstr1}"~="" {                  
         
         qui count if ${minstr1}~=.       
         sca nobs_miv1 = r(N)            
      }                  

      keep nohhold ${out${out}} ${treat} ${minstr1} ${wgt} ${clustv}             
            
      qui save "${projf}/Data/temp1.dta", replace            
         
      *Global of column names of the output matrix            
      global cl lb ub 
      forvalues npv=1/$ncicv {      
         local pv: word `npv' of ${cicv}      
         local pv1=100*`pv'      
         global cl ${cl} `pv1'_bci_low `pv1'_bci_high `pv1'_imci_low `pv1'_imci_high             
      }      

      global cln: word count ${cl}            
         
      global cl ${cl} blank      
      
             
      *List of output from the bootstrapped program      

      *Global of level coefficients
      global levcoeff ""

      *We then put in the outcomes      
      *Loop over methods (excluding the ones without the bias adjustment)      

      foreach mth in $gmethod {      

         *Loop over treatments            
         forvalues t=1/$vtn {            

            *Loop over statistics      
            foreach st in $stat {      
               
               *We then add the outcomes            
               global reslist ${reslist} `st'_tr`t'_lb_`mth' `st'_tr`t'_ub_`mth'                             
               global levcoeff ${levcoeff} `st'_tr`t'_lb_`mth' `st'_tr`t'_ub_`mth'                             
                           
               *Adding the differences across values of the treatment            
               local jj = `t'+ 1             
               forvalues m = `jj'/$vtn {            
               
                  global reslist ${reslist} `st'_tr`m'_tr`t'_lb_`mth' `st'_tr`m'_tr`t'_ub_`mth'            
               }            
             
            *End of loop over statistics below      
            }        
         *End of loop over treatments below            
         }            
      *End of loop over methods below      
      }      

      *Size of results list         
      global blistn: word count ${reslist}         
            
      *Generating a matrix into which the bootstrap results will be put         
      mat BR = J(${bsn},${blistn},.)         
      global cbr ""         
      foreach rs in $reslist {         

         global cbr ${cbr} v`rs'         
      }         
      mat colnames BR = ${cbr}         
            
      *Showing the combination for which calculations are performed         
      di in yellow "Outcome ${out`out'}, treat ${treat}, miv1 ${minstr1}"         

      local sd = ${tv} + ${out}            
      set seed `sd'         
      *Indicator of boostrap runs         
      global sr = 0         

      *Running the calculations program                        
      global testw [aw=${wgt}]	                
      qui do "${projf}/Programs/Bounds/Conc_Unc_calculations.do"		         
      
      *Recording the point estimates 
      foreach rs in $reslist {
         sca b_`rs' = `rs'
         sca drop `rs'
      }

      *Bootstrap program
      di in yellow "Bootstrap replicates"
      forvalues bb=1/$bsn {

         *Defining an index that will determine whether the loop finishes or not
         if `bb'==1 {
            local sr = 1
         }
         else if `bb'>1 {
         
         *Augmenting the index that tracks valid simulation runs by one
           local sr = `sr' + 1
         }
         global sr = `bb'
         *di in red "`sr'"

         local sd = ${tv} + ${out} + `bb'    
         set seed `sd'
         
         global testw [aw=${wgt}]	       
         qui use "${projf}/Data/temp1.dta", clear
         bsample,cluster(${clustv}) 
         
         *Running the calculations program
         qui do "${projf}/Programs/Bounds/Conc_Unc_calculations.do"		

         *Putting the results in the relevant variables      
         forvalues mc=1/$blistn {      
            
            local brv: word `mc' of ${reslist}      
            mat BR[`sr',`mc']=`brv'      
            sca drop `brv'
         }      
         *Periodically displaying the no of runs
         forvalues kk=1/5 {
            
            if `sr'==$bsn*(`kk'/5) {
               
               di in yellow "Bootstrap run no. `sr'"
            }
         }

      *End of bootstrap loop below      
      }      

      drop _all
               
      *Saving the matrix of results as new variables
      qui svmat double BR, names(col)

      *Saving the dataset
      qui save "${projf}/Data/tempres.dta", replace
      qui save "${projf}/Data/tempres1.dta", replace
               
      assert _N==${bsn}         
           
      *Calculating magnitudes of interest
      forvalues an=1/$blistn {
                  
         local rs: word `an' of ${reslist}
                  
         *Checking that the results have been saved properly                  
         assert v`rs'<.

         *Average of the point estimates of the boostrap run                  
         qui su v`rs'
         sca av_`rs' = r(mean)
         sca se_`rs' = r(sd)
         assert se_`rs'<.

         *Bootstrap bias 
         foreach cs in $levcoeff {
            if "`rs'"=="`cs'" {
         
               sca bias_`rs'= av_`rs' - b_`rs'         
               assert bias_`rs'<.                        
            }
         }
      } 

      *For methods not involving instruments, we put the bias equal to 0         
      foreach mth in $gnobias0 {         

         *Loop over statistics         
	  foreach st in $stat {	

            forvalues t=1/$vtn {         
  
               foreach bb in lb ub {         

                  sca bias_`st'_tr`t'_`bb'_`mth' = 0         
      	       }                              
            *End of loop over treatment values below         
            }         
         *End of loop over statistcs below         
         }         
      *End of loop over methods below         
      }          

      *After calculating the bias, we substract it from the estimates of the bounds in each 	       
      *bootstrap run. Then, we calculate an indicator         	       
      *that shows the percentage of runs for which the bias-corrected lower bound is higher than         	       
      *the corresponding upper one          	       
      foreach mth in $gnobias0 $gbias0 {         	       

         *Loop over statistics         	       
         foreach st in $stat {         	       

            *Loop over values of the treatment   	       
            forvalues t=1/$vtn {   	       
                  	       
               foreach bb in lb ub {   	       

                  *Recording the values of the bootstrap run before the bias correction         
                  foreach mth2 in $gbias0 {         
                                 
                     if "`mth'"=="`mth2'" {         

                        qui gen double v`st'_tr`t'_`bb'_`mth2'nb = v`st'_tr`t'_`bb'_`mth2'                       
 	              }	
                  }		

	          *Applying the bias correction
	          qui replace v`st'_tr`t'_`bb'_`mth' = max(${min${outn}}, ///          
                     min(v`st'_tr`t'_`bb'_`mth' - bias_`st'_tr`t'_`bb'_`mth',${max${outn}}))             		
                     	       
	          *Checking that the bias corrected values fall between the overall minima and maxima          
                  assert v`st'_tr`t'_`bb'_`mth'>${min${outn}}-${tolr} & ///            		
                     v`st'_tr`t'_`bb'_`mth'<${max${outn}}+${tolr}             		
               }                                 		
                     	       
	       *Indicator for the % of bootstrap runs in which LB>UB          
               qui gen byte pr_`t'_`mth' = (v`st'_tr`t'_lb_`mth'>v`st'_tr`t'_ub_`mth'+${tolr})             		
               qui su pr_`t'_`mth', meanonly            		
                 
               foreach s1 in $gnobias0 {               	                 		
                     	       
	          if "`s1'"=="`mth'" {          
                      		
                     global pcr_`st'_tr`t'_`mth' = 100*round(r(mean),1e-2)            		
                  }            	       
               }            	       
               foreach s1 in $gbias0 {               	                 		
                     	       
	          if "`s1'"=="`mth'" {          
                     		
                     global pcr_`st'_tr`t'_`mth' = 100*round(r(mean),1e-2)   		
                     global pcr_`st'_tr`t'_`mth'nb = ${pcr_`st'_tr`t'_`mth'}    		
                  }            	       
              }            	       
                     	       
	      drop pr_`t'_`mth'          

            *End of loop over treatment values below   	       
            }            	       
         *End of loop over statistcs below         	       
         }         	       
      *End of loop over methods below         	       
      }          	       

      qui save "${projf}/Data/tempres.dta", replace	       

      *For methods that use monotone instruments 
      *we need to substract the bias in order to get the point estimates               	       
      *We also record the estimates and std errors without the bias correction               	       

      *Loop over methods using instruments	       
      foreach mth in $gbias0 {               	       
         global mth `mth'	       

         *Loop over statistics         	       
         foreach st in $stat {         	       
            	       
            global st `st'	       
            	       
            *Loop over treatments                  	       
            forvalues t=1/$vtn {                  	       
                  	       
               global t = `t'   	       
                  	       
               *First, we record the values and std. errors before any corrections   	       
               *Loop over bounds             	       
               foreach bb in lb ub {                  	       
                     	       
                  sca b_`st'_tr`t'_`bb'_`mth'nb = b_`st'_tr`t'_`bb'_`mth'                  	       
                  sca se_`st'_tr`t'_`bb'_`mth'nb = se_`st'_tr`t'_`bb'_`mth'   	       
                  sca bias_`st'_tr`t'_`bb'_`mth'nb = bias_`st'_tr`t'_`bb'_`mth'   	       
                     	       
                  *Adding the differences across values of the treatment         	       
                  local jj = `t'+ 1                   	       
                  forvalues m = `jj'/$vtn {                  	       
                        	       
                     sca b_`st'_tr`m'_tr`t'_`bb'_`mth'nb = b_`st'_tr`m'_tr`t'_`bb'_`mth'                  	       
                     sca se_`st'_tr`m'_tr`t'_`bb'_`mth'nb = se_`st'_tr`m'_tr`t'_`bb'_`mth'      	       
                     *sca drop se_`st'_tr`m'_tr`t'_`bb'_`mth'   	       
                  }            	       
               }   	       
 
               *Indicator for the % of bootstrap runs in which LB>UB   	       
               qui gen byte pr_`t'_`mth' = (v`st'_tr`t'_lb_`mth'>v`st'_tr`t'_ub_`mth'+${tolr})        	   		
               qui su pr_`t'_`mth', meanonly            		
               global pcr_`st'_tr`t'_`mth'=100*round(r(mean),1e-2)            		
	       drop pr_`t'_`mth'          

               *If there is no problem with the boostrap runs or with the point estimates of the LB and UB   	       
               *then we substract the bias from the point estimates            	       
               if (b_`st'_tr`t'_lb_`mth' - bias_`st'_tr`t'_lb_`mth' <= ///            	       
                  b_`st'_tr`t'_ub_`mth' - bias_`st'_tr`t'_ub_`mth'+${tolr}) {            	       
                           	       
                  *Loop over bounds             	       
                  foreach bb in lb ub {                  	       
                           	       
                     if "`bb'"=="lb" {                  	       
                     	       
                        sca b_`st'_tr`t'_`bb'_`mth' = max(${min${outn}}, min(b_`st'_tr`t'_`bb'_`mth' - ///   	       
                           bias_`st'_tr`t'_`bb'_`mth',${max${outn}}))                  	       
                     }                  	       
                     if "`bb'"=="ub" {                  	       
                     	       
                        sca b_`st'_tr`t'_`bb'_`mth' = min(${max${outn}}, max(b_`st'_tr`t'_`bb'_`mth' - ///   	       
                           bias_`st'_tr`t'_`bb'_`mth',${min${outn}}))                  	       
                     }                  	       
                     	       
                     *Checking that the values after the bias correction fall in the range defined by the          	       
                     *overall mininum and maximum                  	       
                     assert b_`st'_tr`t'_`bb'_`mth'>${min${outn}}-${tolr} &  b_`st'_tr`t'_`bb'_`mth'<${max${outn}}+${tolr}                  	       
                           	       
                  *End of loop over bounds below                  	       
                  }                                       	       
               *End of if conditions over the percentage of problematic boostrap runs            	       
               }            	       

               if (b_`st'_tr`t'_ub_`mth'+${tolr}<b_`st'_tr`t'_lb_`mth') {            	       
                  di "Upper bound smaller than lower bound, statistic `st', treat, `t', method `mth'"            	       
                  di b_`st'_tr`t'_ub_`mth' b_`st'_tr`t'_lb_`mth'            	       
                  stop            	       
               }            	       
                        	       
            *End of loop over treatments below                  	       
            }   	       
          
         *End of loop over statistics below               	       
         }            	       
      *End of loop over methods that use instruments, except for those using instruments partially applied         	       
      }         	       

      *Creating an indicator that the bootstrap run value is less or equal to the point estimate         
      *It is used for the computation of confidence intervals using the percentile method
      foreach mth in $gnobias0 $gbias0 $gbiasnb {	       
                  
         *Loop over statistics         	       
	 foreach st in $stat {	       
            *Loop over treatment values         
            forvalues t=1/$vtn {         	       
            
               *Loop over bounds         
               foreach bb in lb ub {         	       

                  qui gen byte ib = v`st'_tr`t'_`bb'_`mth'<=b_`st'_tr`t'_`bb'_`mth'+tolr if ///         
                     v`st'_tr`t'_`bb'_`mth'<.         

                  *Calculating the percentage of draws that is less or equal to the bound            		
                  qui su ib, meanonly            		
                  sca le_`st'_tr`t'_`bb'_`mth' = r(mean)            		
                  drop ib         		

         	  *Loop over p-values of confidence intervals                   
         	  forvalues npv=1/$ncicv {                  
      
                     local pv: word `npv' of ${cicv} 	             
                     local pv1 = round(`pv'*1000)	             

                     *Calculating the z-stat                  		
                     local zstat = invnormal(1-((1-`pv')/2))                  		

                     *Calculationg the percentile corresponding to the lower bound                  		
                     if "`bb'"=="lb" {         		
                             		
                       local pp = normal(2*invnormal(le_`st'_tr`t'_`bb'_`mth')-`zstat')                  		
                     }                  
                     else if "`bb'"=="ub" {         		
                             		
                       local pp = normal(2*invnormal(le_`st'_tr`t'_`bb'_`mth')+`zstat')                  		
                     }                  
                             		
                     *Calculating the value of the bootstrap runs corresponding to this percentile                  		
                     if `pp'>tolr & `pp'<1-tolr {         		
                             		
                        local pp1=100*`pp'         		
                        qui _pctile v`st'_tr`t'_`bb'_`mth', p(`pp1')                           		
                        sca bci`pv1'`st'_tr`t'_`bb'_`mth' = r(r1)                           		
                     }         		
                     else if `pp'<=tolr {         		
                             		
                        qui su v`st'_tr`t'_`bb'_`mth', meanonly         		
                        sca bci`pv1'`st'_tr`t'_`bb'_`mth' = r(min)         		
                     }         		
                     else if `pp'>=1-tolr {         		
                             		
                        qui su v`st'_tr`t'_`bb'_`mth', meanonly         		
                        sca bci`pv1'`st'_tr`t'_`bb'_`mth' = r(max)         		
                     }         		

                     *For the nex method, we use these CIs in place of the         
                     *Manski Imbens ones         
                     if "`mth'"=="nex" {         
                              
                         sca ci`pv1'`st'_tr`t'_`bb'_`mth' = bci`pv1'`st'_tr`t'_`bb'_`mth'          
                     }         

            	   *End of loop over p-values of confidence intervals                  
            	   }                              
              *End of loop over bounds below		
              }                              		
            *End of loop over treatment values below         	       
            }         	       
         *End of loop over statistcs below         	       
         }         	       
      *End of loop over methods below         	       
      }          	       

      *Recording treatment effects	       
              	       
      *Loop over methods using instruments         	       
      foreach mth in $gbias0 {      	       

         assert $nm0>0         	       
         	       
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

         *Loop over statistics         	       
         foreach st in $stat {         	       
               	       
            *Loop over treatments                  	       
            *ATTENTION: do not merge this loop over treatments with the one above, which needs to be completed   	       
            *before this one            	       
            forvalues t=1/$vtn {                  	       
                  	       
               *Adding the differences across values of the treatment                  	       
               local jj = `t'+ 1          	       
               forvalues m = `jj'/$vtn {                  	       
                     	       
                  foreach bb in lb ub {                  	       
                            	       
                     *Calculating the point estimate after taking into account the bias correction                          
            	      if "`bb'"=="lb" {                     

            	         if ("${mne}") {                     
            	                   
            	            sca b_`st'_tr`m'_tr`t'_`bb'_`mth' = max(0,b_`st'_tr`m'_lb_`mth'-b_`st'_tr`t'_ub_`mth')                           
            	                     
            	            *We generate the difference in the bootstrap run results to calculate the standard error            
           	            qui gen double vse = max(0,v`st'_tr`m'_lb_`mth'-v`st'_tr`t'_ub_`mth')         
            	         }         
            	         else if ("${me}") {                     

            	            sca b_`st'_tr`m'_tr`t'_`bb'_`mth' = b_`st'_tr`m'_lb_`mth'-b_`st'_tr`t'_ub_`mth'                           
            	                
            	            *We generate the difference in the bootstrap run results to calculate the standard error            
           	            qui gen double vse = (v`st'_tr`m'_lb_`mth'-v`st'_tr`t'_ub_`mth')         
            	         }                     
            	      }                     

            	      else if "`bb'"=="ub" {                     
            	         if ("${mne}") {                     
            	                   
            	            sca b_`st'_tr`m'_tr`t'_`bb'_`mth' = max(0,b_`st'_tr`m'_ub_`mth'-b_`st'_tr`t'_lb_`mth')            
            	                
            	            *We generate the difference in the bootstrap run results to calculate the standard error            
           	            qui gen double vse = max(0,v`st'_tr`m'_ub_`mth'-v`st'_tr`t'_lb_`mth')         
            	         }                     
            	         else if ("${me}") {                     

            	            sca b_`st'_tr`m'_tr`t'_`bb'_`mth' = b_`st'_tr`m'_ub_`mth'-b_`st'_tr`t'_lb_`mth'            
            	                  
            	            *We generate the difference in the bootstrap run results to calculate the standard error            
          	            qui gen double vse = v`st'_tr`m'_ub_`mth'-v`st'_tr`t'_lb_`mth'         
            	         }                     
            	      }                     

            	      qui count if vse<.            
            	      assert r(N)==${bsn}            

            	      sca se_`st'_tr`m'_tr`t'_`bb'_`mth'ol = se_`st'_tr`m'_tr`t'_`bb'_`mth'            
            	      qui su vse             
             	      sca se_`st'_tr`m'_tr`t'_`bb'_`mth' = r(sd)         
             	               
            	      assert b_`st'_tr`m'_tr`t'_`bb'_`mth'>(${min${outn}}-${max${outn}})-${tolr} & ///                           
            	         b_`st'_tr`m'_tr`t'_`bb'_`mth'<(${max${outn}}-${min${outn}})+${tolr}             
            	      drop vse               
                     	       
                  *End of loop over bounds below                  	       
                  }         	       
               *End of inner loop over treatments below                  	       
               }                  	       
            *End of outer loop over treatments below                  	       
            }               	       
         *End of outer loop over statistics below               	       
         }               	       
      *End of loop over methods using instruments below         	       
      }         	       
      
      *Calculating bootstrap percentile confidence intervals	       
      foreach mth in $gnobias0 $gbias0 $gbiasnb {      	       

         assert $nm0>0         	       
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

         *Loop over statistics         	       
         foreach st in $stat {         	       
               	       
            *Loop over treatments                  	       
            *ATTENTION: do not merge this loop over treatments with the one above, which needs to be completed   	       
            *before this one            	       
            forvalues t=1/$vtn {                  	       
                  	       
               *Adding the differences across values of the treatment                  	       
               local jj = `t'+ 1          	       
               forvalues m = `jj'/$vtn {                  	       
                     	       
                  foreach bb in lb ub {                  	       

                     *Creating an indicator that the bootstrap run value is less or equal to the point estimate         
            	     qui gen byte ib = 0 if v`st'_tr`t'_`bb'_`mth'<.         

                     *Calculating the point estimate after taking into account the bias correction                          
            	     if "`bb'"=="lb" {                     

            	        if ("${mne}") {                     
            	                   
                           qui replace ib = 1 if max(0,v`st'_tr`m'_lb_`mth'-v`st'_tr`t'_ub_`mth')< ///         
                              b_`st'_tr`m'_tr`t'_lb_`mth'+tolr & v`st'_tr`t'_`bb'_`mth'<.         
            	                  
                           *Calculating the percentage of draws that is less or equal to the bound   		
                           qui su ib, meanonly   		
                           sca le_`st'_tr`m'_tr`t'_`bb'_`mth' = r(mean)   		
                           drop ib		

         	           *Loop over p-values of confidence intervals          
         	           forvalues npv=1/$ncicv {         
      
               	              local pv: word `npv' of ${cicv}          
               	              local pv1 = round(`pv'*1000)         

                              *Calculating the z-stat         		
         	              local zstat = invnormal(1-((1-`pv')/2))                  

                              *Calculationg the percentile corresponding to the lower bound         		
                              local pp = normal(2*invnormal(le_`st'_tr`m'_tr`t'_`bb'_`mth')-`zstat')         		

                              *Calculating the value of the bootstrap runs corresponding to this percentile         		
                              qui gen double dci=max(0,v`st'_tr`m'_lb_`mth'-v`st'_tr`t'_ub_`mth')         
                              
                              if `pp'>tolr & `pp'<1-tolr {		
                          		
                                 local pp1=100*`pp'		
                                 qui _pctile dci, p(`pp1')                  		
                                 sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = r(r1)                  		
                              }		
                              else if `pp'<=tolr {		
                          		
                                 qui su dci, meanonly		
                                 sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = r(min)		
                              }		
                              else if `pp'>=1-tolr {		
                          		
                                 qui su dci, meanonly		
                                 sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = r(max)		
                              }		
            	              drop dci         

            	           *End of loop over p-values of confidence intervals         
            	           }                     
            	        }         
            	        else if ("${me}") {                     

                           qui replace ib = 1 if v`st'_tr`m'_lb_`mth'-v`st'_tr`t'_ub_`mth'< ///         
                              b_`st'_tr`m'_tr`t'_lb_`mth'+tolr         

                           *Calculating the percentage of draws that is less or equal to the bound   		
                           qui su ib, meanonly   		
                           sca le_`st'_tr`m'_tr`t'_`bb'_`mth' = r(mean)   		
                           drop ib		

         	           *Loop over p-values of confidence intervals          
         	           forvalues npv=1/$ncicv {         
      
               	              local pv: word `npv' of ${cicv}          
               	              local pv1 = round(`pv'*1000)         

                              *Calculating the z-stat         		
                              local zstat = invnormal(1-((1-`pv')/2))         		
                              *Calculationg the percentile corresponding to the lower bound         		
                              local pp = normal(2*invnormal(le_`st'_tr`m'_tr`t'_`bb'_`mth')-`zstat')         		

                              *Calculating the value of the bootstrap runs corresponding to this percentile         		
                              qui gen double dci=v`st'_tr`m'_lb_`mth'-v`st'_tr`t'_ub_`mth'		
                              if `pp'>tolr & `pp'<1-tolr {		
                          		
                                local pp1=100*`pp'		
                                qui _pctile dci, p(`pp1')                  		
                                sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = r(r1)                  		
                             }		
                             else if `pp'<=tolr {		
                           		
                                qui su dci, meanonly		
                                sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = r(min)		
                             }		
                             else if `pp'>=1-tolr {		
                          		
                                qui su dci, meanonly		
                                sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = r(max)		
                             }		
            	             drop dci         

                             *For the nex method, we use these CIs in place of the         
                             *Manski Imbens ones         
                             if "`mth'"=="nex" {         
                              
                                 sca ci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth'          
                             }         

            	           *End of loop over p-values of confidence intervals         
            	           }                     
            	        }                     
            	     }                     

            	     else if "`bb'"=="ub" {                     
            	        if ("${mne}") {                     
            	                   
                           qui replace ib = 1 if max(0,v`st'_tr`m'_ub_`mth'-v`st'_tr`t'_lb_`mth')< ///         
                              b_`st'_tr`m'_tr`t'_ub_`mth'+tolr         

                           *Calculating the percentage of draws that is less or equal to the bound   		
                           qui su ib, meanonly   		
                           sca le_`st'_tr`m'_tr`t'_`bb'_`mth' = r(mean)   		
                           drop ib		

         	           *Loop over p-values of confidence intervals          
         	           forvalues npv=1/$ncicv {         
      
               	              local pv: word `npv' of ${cicv}          
               	              local pv1 = round(`pv'*1000)         

                              *Calculating the z-stat         		
                              local zstat = invnormal(1-((1-`pv')/2))         		
                              *Calculationg the percentile corresponding to the lower bound         		
                              local pp = normal(2*invnormal(le_`st'_tr`m'_tr`t'_`bb'_`mth')+`zstat')         		

                              *Calculating the value of the bootstrap runs corresponding to this percentile         		
                              qui gen double dci=max(0,v`st'_tr`m'_ub_`mth'-v`st'_tr`t'_lb_`mth')         
                              if `pp'>tolr & `pp'<1-tolr {		
                          		
                                 local pp1=100*`pp'		
                                 qui _pctile dci, p(`pp1')                  		
                                 sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = r(r1)                  		
                              }		
                              else if `pp'<=tolr {		
                          		
                                 qui su dci, meanonly		
                                 sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = r(min)		
                              }		
                              else if `pp'>=1-tolr {		
                          		
                                 qui su dci, meanonly		
                                 sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = r(max)		
                              }		
            	              drop dci         

            	           *End of loop over p-values of confidence intervals         
            	           }                     
            	        }                     
            	        else if ("${me}") {                     

                           qui replace ib = 1 if v`st'_tr`m'_ub_`mth'-v`st'_tr`t'_lb_`mth'< ///         
                              b_`st'_tr`m'_tr`t'_ub_`mth'+tolr         

                           *Calculating the percentage of draws that is less or equal to the bound   		
                           qui su ib, meanonly   		
                           sca le_`st'_tr`m'_tr`t'_`bb'_`mth' = r(mean)   		
                           drop ib		

         	           *Loop over p-values of confidence intervals          
         	           forvalues npv=1/$ncicv {         
      
               	              local pv: word `npv' of ${cicv}          
               	              local pv1 = round(`pv'*1000)         

                              *Calculating the z-stat         		
                              local zstat = invnormal(1-((1-`pv')/2))         		
                              *Calculationg the percentile corresponding to the lower bound         		
                              local pp = normal(2*invnormal(le_`st'_tr`m'_tr`t'_`bb'_`mth')+`zstat')         		

                              *Calculating the value of the bootstrap runs corresponding to this percentile         		
                              qui gen double dci=v`st'_tr`m'_ub_`mth'-v`st'_tr`t'_lb_`mth'		
                              if `pp'>tolr & `pp'<1-tolr {		
                          		
                                 local pp1=100*`pp'		
                                 qui _pctile dci, p(`pp1')                  		
                                 sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = r(r1)                  		
                              }		
                              else if `pp'<=tolr {		
                          		
                                 qui su dci, meanonly		
                                 sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = r(min)		
                              }		
                              else if `pp'>=1-tolr {		
                          		
                                 qui su dci, meanonly		
                                 sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = r(max)		
                              }		
            	              drop dci         

                              *For the nex method, we use these CIs in place of the         
                              *Manski Imbens ones         
                              if "`mth'"=="nex" {         
                              
                                 sca ci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth'          
                              }         

            	            *End of loop over p-values of confidence intervals         
            	            }                     
            	         }                     
            	      }                     

                  *End of loop over bounds below                  	       
                  }         	       
               *End of inner loop over treatments below                  	       
               }                  	       
            *End of outer loop over treatments below                  	       
            }               	       
         *End of outer loop over statistics below               	       
         }               	       
      *End of loop over methods using instruments below         	       
      }         	       

      *Increasing the nubmer of observations in order to accommodate a new variable            
      local newobs=((${chigh}-${clow})*${incc}) + 1            
      qui set obs `newobs'            


      *Imbens-Manski (2004) confidence intervals         
         	
      *Loop over statistics         
      forvalues stn=1/$stat_n {         
         local st: word `stn' of ${stat}         
         local fst: word 1 of ${stat}         
                  
         *Loop over methods            
         forvalues mnn=1/$gmethod2_n {            
            local mth: word `mnn' of ${gmethod2}         
            local fmth: word 1 of ${gmethod2}         

            *Loop over values of the treatment            
            forvalues t=1/$vtn2 {            
         	            
         	local j1: word `t' of ${vt}            
         	local jj = `t'+ 1                
         	               

         	forvalues m = `jj'/$vtn {               

         	   *Condition excluding the nex method            
         	   if ! ("`mth'"=="nex") {            

         	      *If the std errors of the lower and upper bounds are not both equal to zero then we             
         	      *calculate a coefficient for the confidence interval of the point estimate            
         	      if ! (se_`st'_tr`m'_tr`t'_lb_`mth'<tolr & se_`st'_tr`m'_tr`t'_ub_`mth'<tolr) {            

         	         *Loop over p-values of confidence intervals             
         	         forvalues npv=1/$ncicv {            
         	            
         	            local pv: word `npv' of ${cicv}             
         	            local pv1 = `pv'*1000            


                           *Generating a variable that takes values between the upper and lower bounds of the coefficient                  
                           *for the calculation of the confidence interval in predefined increments                   
                           qui set obs `newobs'                  
                           qui gen double d1 = ${clow} + (_n-1)/${incc} if _n<=((${chigh}-${clow})*${incc}) + 1                  

         	            *We calculate the difference between two cumulative normals            
         	            qui gen double dcn = normal(d1 + ((b_`st'_tr`m'_tr`t'_ub_`mth' - b_`st'_tr`m'_tr`t'_lb_`mth')/ ///            
         	               max(se_`st'_tr`m'_tr`t'_lb_`mth',se_`st'_tr`m'_tr`t'_ub_`mth'))) - normal(-d1)            
         	                  
         	            *Generating a variable equal to the difference between the difference of the two cumulative normals and            
         	            *the required coverage            

      	                    *If the bounds do not cross then the difference is put equal to alpha         
      	                    if ! (b_`st'_tr`m'_tr`t'_ub_`mth'+${tolr}<b_`st'_tr`m'_tr`t'_lb_`mth') {          
      	                       
      	                       qui gen double d2 = abs(dcn - `pv') if dcn~=.                   
      	                    }         
      	                    *If the bounds cross then the difference is put equal to alpha/2         
      	                    else if (b_`st'_tr`m'_tr`t'_ub_`mth'+${tolr}<b_`st'_tr`m'_tr`t'_lb_`mth') {          

      	                       qui gen double d2 = abs(dcn - (`pv'/2)) if dcn~=.                   
      	                    }         

         	            *Finding which value is closest to the required coverage            
         	            qui su d2 if dcn~=., meanonly            
         	            sca tt = r(min)            
         	            qui gen double d3 = d1 if abs(d2-tt)<tolr & dcn~=.            
         	            qui count if d3~=. & dcn~=.            
         	            *For methods for which the upper bound is at least as high as the lower bound, then         
         	            *the value should be unique         
         	            if b_`st'_tr`m'_tr`t'_ub_`mth' - b_`st'_tr`m'_tr`t'_lb_`mth'>=-${tolr} {         
         	               assert r(N)==1 & tt<1e-3            
         	            }         
         	            qui su d3 if dcn~=., meanonly            
         	            sca co`st'_tr`m'_tr`t'_`mth'`pv1' = r(max)            
         	            drop d1 d2 d3 dcn            
         	            sca drop tt            
         	            drop _all         

         	         *End of loop over p-values of confidence intervals         
         	         }         
         	      }         
         	               
         	      *If the std errors of both the lower and upper bounds are zero then we put the coefficient         
         	      *of the confidence interval equal to zero for the Manski Imbens bound, and the          
         	      *confidence interval bound equal to the estimate.         
         	      if (se_`st'_tr`m'_tr`t'_lb_`mth'<tolr & se_`st'_tr`m'_tr`t'_ub_`mth'<tolr) {         
         	                  

         	         *Loop over p-values of confidence intervals          
         	         forvalues npv=1/$ncicv {         
         	            
         	            local pv: word `npv' of ${cicv}          
         	            local pv1 = `pv'*1000         

         	            sca co`st'_tr`m'_tr`t'_`mth'`pv1' = 0         
         	                  
                          foreach bb in lb ub {		
                          		
                             sca bci`pv1'`st'_tr`m'_tr`t'_`bb'_`mth' = b_`st'_tr`m'_tr`t'_`bb'_`mth'		
                          }		
         	                  
         	         *End of loop over p-values of conficence intervals         
         	         }         
         	      }         
         	      *Loop over p-values of confidence intervals          
         	      forvalues npv=1/$ncicv {         
         	            
         	         local pv: word `npv' of ${cicv}          
         	         local pv1 = `pv'*1000         

         	         assert co`st'_tr`m'_tr`t'_`mth'`pv1'~=.            
         	      *End of loop over p-values of conficence intervals         
         	      }         
         	   *End of condition excluding the nex method         
         	   }         
         	*End of inner loop over treatment values            
         	}            
            *End of outer loop over treatment values            
            } 	             

            *Adding the levels of the means across treatments    	         

            *Loop over values of the treatment            
            forvalues t=1/$vtn {           
         	         
         	if ! ("`mth'"=="nex") {         
         	            
         	   *If the std errors of the lower and upper bounds are not both equal to zero then we          
         	   *calculate a coefficient for the confidence interval of the point estimate         
         	   if ! (se_`st'_tr`t'_lb_`mth'==0 & se_`st'_tr`t'_ub_`mth'==0) {         

         	      *Loop over p-values of confidence intervals          
         	      forvalues npv=1/$ncicv {         

         	         local pv: word `npv' of ${cicv}          
         	         local pv1 = `pv'*1000         

                        *Generating a variable that takes values between the upper and lower bounds of the coefficient                  
                        *for the calculation of the confidence interval in predefined increments                   
                        qui set obs `newobs'                  
                        qui gen double d1 = ${clow} + (_n-1)/${incc} if _n<=((${chigh}-${clow})*${incc}) + 1                  
         	               
         	         *We calculate the difference between two cumulative normals            
         	         qui gen double dcn = normal(d1 + ((b_`st'_tr`t'_ub_`mth' - b_`st'_tr`t'_lb_`mth')/ ///               
         	            max(se_`st'_tr`t'_lb_`mth',se_`st'_tr`t'_ub_`mth'))) - normal(-d1)               
         	                  
         	         *Generating a variable equal to the difference between the difference of the two cumulative normals and               
         	         *the required coverage               
      	                    
      	                 *If the bounds do not cross then the difference is put equal to alpha         
      	                 if ! (b_`st'_tr`t'_ub_`mth'+${tolr}<b_`st'_tr`t'_lb_`mth') {          
      	                       
      	                    qui gen double d2 = abs(dcn - `pv') if dcn~=.                   
      	                 }         
      	                 *If the bounds cross then the difference is put equal to alpha/2         
      	                 else if (b_`st'_tr`t'_ub_`mth'+${tolr}<b_`st'_tr`t'_lb_`mth') {          

      	                    qui gen double d2 = abs(dcn - (`pv'/2)) if dcn~=.                   
      	                 }         

         	         *Finding which value is closest to the required coverage               
         	         qui su d2 if dcn~=., meanonly               
         	         sca tt = r(min)               
         	         qui gen double d3 = d1 if abs(d2-tt)<tolr & dcn~=.               
         	         qui count if d3~=. & dcn~=.               
         	         *For methods for which the upper bound is at least as high as the lower bound, then         
         	         *the value should be unique         
         	         if b_`st'_tr`t'_ub_`mth' - b_`st'_tr`t'_lb_`mth'>=-${tolr} {         
         	            assert r(N)==1 & tt<1e-3               
         	         }         
         	         qui su d3 if dcn~=., meanonly               
         	         sca co`st'_tr`t'_`mth'`pv1' = r(max)               
         	                  
         	         drop d1 d2 d3 dcn               
         	         sca drop tt               
         	         drop _all         

         	      *End of loop over p-values of conficence intervals         
	  	      }	
         	   }         

         	   *If the std errors of both the lower and upper bounds are zero then we put the coefficient         
         	   *of the confidence interval equal to zero for the Manski Imbens bound, and the          
         	   *confidence interval bound equal to the estimate.         
         	   else if (se_`st'_tr`t'_lb_`mth'<tolr & se_`st'_tr`t'_ub_`mth'<tolr) {         
         	               
         	      *Loop over p-values of confidence intervals          
         	      forvalues npv=1/$ncicv {         
         	            
         	         local pv: word `npv' of ${cicv}          
         	         local pv1 = `pv'*1000         
 
         	         sca co`st'_tr`t'_`mth'`pv1' = 0         

                       foreach bb in lb ub {		
                          		
                          sca bci`pv1'`st'_tr`t'_`bb'_`mth' = b_`st'_tr`t'_`bb'_`mth'		
                       }		
         	      *End of loop over p-values of conficence intervals         
         	      }         
         	   }         
         	   *Loop over p-values of confidence intervals          
         	   forvalues npv=1/$ncicv {         
         	            
         	      local pv: word `npv' of ${cicv}          
         	      local pv1 = `pv'*1000         

         	      assert co`st'_tr`t'_`mth'`pv1'~=.         
         	   *End of loop over p-values of conficence intervals         
         	   }         
         	            
         	*End of condition excluding the nex method         
	  	}	
            *End of loop over values of the treatment below         
            }            
         *End of loop over methods below          
         }                         
      *End of loop over statistics below          
      }                         

      *Assembling the results

      *Loop over statistics         
      forvalues stn=1/$stat_n {         
         local st: word `stn' of ${stat}         
         local fst: word 1 of ${stat}         
                  
         *Loop over methods            
         forvalues mnn=1/$gmethod2_n {            
            local mth: word `mnn' of ${gmethod2}         
            local fmth: word 1 of ${gmethod2}         

            *Local of the rownames of the output matrix               
            local rl ""            

            *Loop over values of the treatment            
            forvalues t=1/$vtn2 {            
         	            
         	local j1: word `t' of ${vt}            
         	local jj = `t'+ 1                
         	               
         	forvalues m = `jj'/$vtn {               

         	   local j2: word `m' of ${vt}             
         	   local rl `rl' `st'_`mth'_v`j2'v`j1'               

         	*End of inner loop over treatment values            
         	}            
            *End of outer loop over treatment values            
            } 	             

            *Adding the levels of the means across treatments    	         
            *Putting a blank line to separate results for differences from those for levels    	         

            if "`rl'"~="" {         
         	local rl `rl' blank            
            }         

            *Loop over values of the treatment            
            forvalues t=1/$vtn {           

         	local j1: word `t' of ${vt}         
         	local rl `rl'  `st'_`mth'_v`j1'            

            *End of loop over values of the treatment below         
            }            

            foreach mth2 in $gmethod $gbiasnb { 	         
         	if "`mth'"=="`mth2'" {         
         	   forvalues t=1/$vtn {            
         	                  
         	      local j1: word `t' of ${vt}         
         	      local rl `rl' pcr_`mth2'_v`j1'         
         	   }         
         	}         
            }         

            local rl `rl' blank            
                  
            *Number of rows of the output matrix            
            local rln: word count `rl'            
         	                  
	    *Output matrix      	       
            *For the nex method we also input the number of observations             	
            if ("`st'"=="m" & "`mth'"=="nex") {             	
               local rln = `rln'+1             	
               local rl `rl' nobs_nomiv             	
                          	
               if ("${minstr1}"=="") {             	
                  local rln = `rln'+1             	
                  local rl `rl' blank               	
               }             	
                          	
               else if ("${minstr1}"!="") {             	
                 local rln = `rln'+2             	
                 local rl `rl' nobs_miv1 blank             	
               }             	
            }                  
            mat Aout`out'_`mth'_t`tv'_`st' = J(`rln',${cln}+1,.)                  

           mat colnames Aout`out'_`mth'_t`tv'_`st' = ${cl}      	   	
           mat rownames Aout`out'_`mth'_t`tv'_`st' = `rl'      	   	

            *Filling in the output matrix      	      	
	    local cv = 0      		

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

           *Putting in first the results of the differences                        	      	
           forvalues t=1/$vtn2 {            	
        	local jj = `t'+ 1             	
        	         	
        	forvalues m = `jj'/$vtn {            	
        	   local cv = `cv'+1            	
        	   local plc = 0      	
        	         	
        	   *Lower bound            	
        	   local plc = `plc'+1      	
        	   mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']=b_`st'_tr`m'_tr`t'_lb_`mth'            	

        	   *Upper bound            	
        	   local plc = `plc'+1      	
        	   mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']=b_`st'_tr`m'_tr`t'_ub_`mth'             	

         	   *Loop over p-values of confidence intervals          
         	   forvalues npv=1/$ncicv {         
         	            
         	      local pv: word `npv' of ${cicv}          
         	      local pv1 = round(`pv'*1000)         
         	      *local pv0 = round(1000*(1-`pv'))         
        	                  	
        	      *Bootstrap percentile method      	
        	            	
        	      *Low boundary of the confidence interval            	
        	            	
        	      local plc = `plc'+1      	
        	      if ("${mne}") {      	

        	         mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc'] = ///      	
        	            min(max(0,bci`pv1'`st'_tr`m'_tr`t'_lb_`mth'),${max${outn}}-${min${outn}})      	
        	      }            	
        	      else if ("${me}") {      	
        	               	
        	        mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']= ///      	
        	            min(max(${min${outn}}-${max${outn}},bci`pv1'`st'_tr`m'_tr`t'_lb_`mth'), ${max${outn}}-${min${outn}})            	
        	      }            	

        	      *Upper boundary of the confidence interval            	

        	      local plc = `plc'+1      	
        	      if ("${mne}") {      	

	  	         mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']= ///	
	  	            min(max(0,bci`pv1'`st'_tr`m'_tr`t'_ub_`mth'),${max${outn}}-${min${outn}})      	
        	      }               	
        	      else if ("${me}") {      	
	  	         	
	  	         mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']= ///	
	  	            min(max(${min${outn}}-${max${outn}},bci`pv1'`st'_tr`m'_tr`t'_ub_`mth'), ${max${outn}}-${min${outn}})      	
        	      }      	

                     *Imbens-Manski (2004) confidence intervals         
        	            	
        	      *Low boundary of the confidence interval            	
        	      local plc = `plc'+1      	
        	      if ("${mne}") {      	

        	         mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc'] = ///      	
        	            min(max(0,b_`st'_tr`m'_tr`t'_lb_`mth' - ///            	
        	            co`st'_tr`m'_tr`t'_`mth'`pv1'*se_`st'_tr`m'_tr`t'_lb_`mth'), ///      	
        	            ${max${outn}}-${min${outn}})            	
        	      }            	

        	      else if ("${me}") {      	
        	               	
        	         if ("`mth'"~="nex") {      	
        	                  	
        	            mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']= ///      	
        	               min(max(${min${outn}}-${max${outn}},b_`st'_tr`m'_tr`t'_lb_`mth' - ///            	
        	               co`st'_tr`m'_tr`t'_`mth'`pv1'*se_`st'_tr`m'_tr`t'_lb_`mth'), ///      	
        	               ${max${outn}}-${min${outn}})            	
        	         }      	
        	         else if ("`mth'"=="nex") {      	
        	                  	
        	            mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']= ///      	
        	               min(max(${min${outn}}-${max${outn}},ci`pv1'`st'_tr`m'_tr`t'_lb_nex), ///      	
        	               ${max${outn}}-${min${outn}})            	
        	         }      	
        	      }            	

        	      *Upper boundary of the confidence interval            	
        	            	
        	      local plc = `plc'+1      	
        	      if ("${mne}") {      	

	  	         mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']= ///	
	  	            min(max(0,b_`st'_tr`m'_tr`t'_ub_`mth' + ///      	
        	            co`st'_tr`m'_tr`t'_`mth'`pv1'*se_`st'_tr`m'_tr`t'_ub_`mth'), ///      	
        	            ${max${outn}}-${min${outn}})            	
        	      }               	
        	      else if ("${me}") {      	
	  	         	
	  	         if ("`mth'"!="nex") {	
	  	            	
	  	            mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']= ///	
	  	               min(max(${min${outn}}-${max${outn}},b_`st'_tr`m'_tr`t'_ub_`mth' + ///      	
        	               co`st'_tr`m'_tr`t'_`mth'`pv1'*se_`st'_tr`m'_tr`t'_ub_`mth'), ///      	
        	               ${max${outn}}-${min${outn}})            	
        	            sca drop co`st'_tr`m'_tr`t'_`mth'`pv1'            	
                                    
                        }            
        	            	
        	         else if ("`mth'"=="nex") {      	
        	                  	
        	            mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']= ///      	
        	               min(max(${min${outn}}-${max${outn}},ci`pv1'`st'_tr`m'_tr`t'_ub_nex), ///      	
        	               ${max${outn}}-${min${outn}})            	
        	         }      	
        	      }      	

         	   *End of loop over p-values of conficence intervals         
         	   }         

              *End of inner loop over treatment values            	
              }            	
           *End of outer loop over treatment values            	
           }             	

           *Putting in afterwards the results of the levels and the percentage of boostrap runs	      	
           *for which the lower bound is higher than the upper bound      	
           *Loop over rows of the matrix      	
           if `cv'>0 {      	
        	local cv = `cv'+1            	
           }      	
           forvalues t=1/$vtn {            	
        	      	
        	local cv = `cv'+1            	
        	local plc = 0            	  	         	
        	      	
        	*Lower bound               	
        	local plc = `plc'+1      	
        	mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']=b_`st'_tr`t'_lb_`mth'               	

        	*Upper bound               	
        	local plc = `plc'+1      	
        	mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']=b_`st'_tr`t'_ub_`mth'               	

         	*Loop over p-values of confidence intervals             
         	forvalues npv=1/$ncicv {            
         	            
         	   local pv: word `npv' of ${cicv}             
         	   local pv1 = round(`pv'*1000)            
         	   *local pv0 = round(1000*(1-`pv'))            
        	                 	
        	   *Bootstrap percentile method            	  	         	
        	         	
        	   *Low boundary of the confidence interval               	

        	   local plc = `plc'+1      	
        	   mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc'] = ///        	
        	      min(${max${outn}},max(${min${outn}},bci`pv1'`st'_tr`t'_lb_`mth'))               	

        	   *Upper boundary of the confidence interval               	
        	   local plc = `plc'+1      	
	  	   mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc'] = ///   	
	  	      max(${min${outn}},min(${max${outn}},bci`pv1'`st'_tr`t'_ub_`mth'))         	

        	   *Imbens-Manski (2004) confidence intervals      	
        	         	
        	   *Low boundary of the confidence interval               	
        	   local plc = `plc'+1      	
        	   if ("`mth'"!="nex") {         	
        	               	
        	      mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc'] = ///         	
        	         min(${max${outn}},max(${min${outn}}, b_`st'_tr`t'_lb_`mth' - ///               	
        	         co`st'_tr`t'_`mth'`pv1'*se_`st'_tr`t'_lb_`mth'))               	
                  }            
        	   else if ("`mth'"=="nex") {         	
        	                  	
        	      mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']= ///         	
        	         min(${max${outn}},max(${min${outn}},ci`pv1'`st'_tr`t'_lb_nex))         	
        	   }         	

        	   *Upper boundary of the confidence interval               	
        	   local plc = `plc'+1      	
        	   if ("`mth'"!="nex") {         	
	  	      mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc'] = ///   	
	  	         max(${min${outn}},min(${max${outn}},b_`st'_tr`t'_ub_`mth' + ///         	
        	         co`st'_tr`t'_`mth'`pv1'*se_`st'_tr`t'_ub_`mth'))               	
         	           	         
        	         sca drop co`st'_tr`t'_`mth'`pv1'                	

                  }            	  	               
        	   else if ("`mth'"=="nex") {         	
	  	      mat Aout`out'_`mth'_t`tv'_`st'[`cv',`plc'] = ///   	
	  	         max(${min${outn}},min(${max${outn}},ci`pv1'`st'_tr`t'_ub_nex))         	
                  }            	  	               

        	   *assert Aout`out'_`mth'_t`tv'_`st'[`cv',`plc']>${min${outn}}-tolr               	

         	*End of loop over p-values of confidence intervals         
         	}         

           *End of loop over rows of the matrix            	
	   }       	

           *Putting in the percentage of bootstrap draws for which the upper bound is lower than	      	
	   *the lower bound	
           foreach mth2 in $gmethod $gbiasnb {      	
        	      	
        	if "`mth'"=="`mth2'" {      	
        	      	
        	   forvalues t=1/$vtn {            	
        	      local cv = `cv'+1            	
            
        	      mat Aout`out'_`mth'_t`tv'_`st'[`cv',1] = ${pcr_`st'_tr`t'_`mth2'}      	
	  	   }	
        	}      	
           }                              	

            *Adding the number of observations for the nex method         
            if ("`st'"=="m" & "`mth'"=="nex") {         
                     
               local cv = `cv'+2               
               mat Aout`out'_`mth'_t`tv'_`st'[`cv',1]=nobs_nomiv         
                        
               if ("${minstr1}"!="") {         
                  local cv = `cv'+1               
                  mat Aout`out'_`mth'_t`tv'_`st'[`cv',1]=nobs_miv1         
               }         
            }            

            *Checking that the number of cells matches the number of results               
	    assert `cv' == `rln'-1       	

            *Stacking vertically the results over methods
            if `mnn'==1 {
               mat A_out`out'_t`tv'_`st' = Aout`out'_`mth'_t`tv'_`st'
            }
            else if `mnn'!=1 {
               mat A_out`out'_t`tv'_`st' = ///
                  (A_out`out'_t`tv'_`st'\Aout`out'_`mth'_t`tv'_`st')
            }
            mat drop Aout`out'_`mth'_t`tv'_`st'

        
         *End of loop over methods below 
         } 

         *Stacking vertically the results over statistics   
      	 if `stn'==1 {   
      	    mat A_out`out'_t`tv' = A_out`out'_t`tv'_`st'   
      	 }   
      	 else if `stn'!=1 {   
      	    mat A_out`out'_t`tv' = ///   
      	       (A_out`out'_t`tv'\A_out`out'_t`tv'_`st')   
      	 }   
      	 mat drop A_out`out'_t`tv'_`st'   

      *End of loop over statistics below         
      }   

      erase "${projf}/Data/temp1.dta"      
      erase "${projf}/Data/tempres.dta"      
      erase "${projf}/Data/tempres1.dta"      

      *Stacking vertically the results over treatment variables   
      if "${treat}"=="`fltv'" {   
         mat A_out`out' = A_out`out'_t`tv'   
      }   
      else if "${treat}"!="`fltv'" {   
         mat A_out`out' = (A_out`out'\A_out`out'_t`tv')   
      }   
      mat drop A_out`out'_t`tv'   

   *End of loop over treatment variables below   
   }   

   *Joining results horizontally over outcomes   
   if `out'==1 {   
      mat A = A_out`out'    
   }   
   else if `out'>1 {   
      mat A = (A,A_out`out')   
   }   
   mat drop A_out`out'   

*End of loop over outcomes below
}

mat list A
mat2txt, mat(A) saving("${projf}/Results/Bounds/Res_PI_dist_${dist}_b${bsn}_test.txt") replace format(%15.6f) ///      
  title("Partial identification results using distribution ${dist} and MIV1 ${minstr1}, finished at $S_TIME on $S_DATE")      
mat drop _all


*Time stamp
noisily display "Program started at: ${sttime} of ${stdate}"      /* beginning time stamp */
noisily display "Program finished at: $S_TIME of $S_DATE"       /*ending time stamp*/       

cap log close


