*********************************************************
* LOCUS OF CONTROL AND JOB SEARCH STRATEGIES
* Marco Caliendo, Deborah Cobb-Clark, and Arne Uhlendorff
* Review of Economics and Statistics 
* DOI: 
*********************************************************
* THIS FILE: 04_pscore produces Figure 3  
*********************************************************

version 9.2
capture log close

log using 04_pscore, text replace


clear
set mem 200m
set matsize 800
set more off
set maxvar 8000 
set trace off
set tracedepth 1
set varabbrev off, perm


/* ========================================== */
/* ------------------------------------------ */
/* --- Propensity Score Estimation ---------- */
/* ------------------------------------------ */
/* ========================================== */

macro drop _all



global data "DATA DIRECTORY"
global desc "OUTPUT DIRECTORY" 
global reg  "OUTPUT DIRECTORY" 
global pscore "OUTPUT DIRECTORY"  	
global xls "OUTPUT DIRECTORY"   	
global graph "OUTPUT DIRECTORY"   	


forvalues sex = 0/1 {            

        forvalues reg = 2/2 {

		forvalues sample = 1/1 {
	
	
		use ${data}/data_estimation, clear
		
		if `sample'==1 {
				count
				}	

		if `sample'==3 {
				count
				keep if su_alter>=25
				count
				}	

		if `sample'==4 {
				count
				keep if su_alter>=20
				count
				}	
		

		rename search_channel chan 
		    rename search_own own 
		    rename w2_employed w2emp
		    rename w2_emp_ls w2empls
		    rename w2_estwage_h w2rwage
		    gen lw2rwage = log(w2rwage)	
		    gen owncut2 = own
		    replace owncut2=100 if owncut2>100
		    gen pas2=chan-act2 

		if `sex'==2 {
					replace su_sex = 2								
					}			
		if `reg'==2 {
					replace reg = 2								
					}			

		count
		keep if su_sex == `sex' & reg == `reg' 
		count

	     	if `sample'==1 {
				count
				}			

				
	forvalues spec = 2/2 {
    
	capture estimates drop _all

            #del; 
            global basevar1 "			reg2 sex2 migra2
						german married _Ichild_1 _Ichild_2
						_Isu_kat_al_2 _Isu_kat_al_3 _Isu_kat_al_4
		 				_Isu_eintri_1 _Isu_eintri_2 _Isu_eintri_3 _Isu_eintri_4 _Isu_eintri_5
		 				_Isu_eintri_6 _Isu_eintri_7 _Isu_eintri_8 _Isu_eintri_9 _Isu_eintri_10 _Isu_eintri_11
						_Idauloint__8 _Idauloint__9 _Idauloint__10
						_Idauloint__11 _Idauloint__12 _Idauloint__13 _Idauloint__14
						_Idaloq_1 _Idaloq_2 _Idaloq_3 
						";

	     global basevar2alt "			selfempl benefit benlevel3
						_Isu_schule_1 _Isu_schule_2 _Isu_schule_3
		 				_Isu_ausbila1 _Isu_ausbila2
		 				su_alo_age su_sv_age 
		 				_Ibefstat_2 _Ibefstat_3 _Ibefstat_4 _Ibefstat_5
						iza_sv_tminus1 iza_sv_tminus2 iza_sv_tminus3
					 	iza_ln0wage_tminus1 iza_ln0wage_tminus2 iza_ln0wage_tminus3 
						";
						
	     global occplus " 
	     					expect_alo
						expect_empl	
					 	iza_lastalo_durmiss
					 	iza_lastemp_durmiss
	     _Iiza_beruf_3 _Iiza_beruf_4 _Iiza_beruf_5 _Iiza_beruf_6
	     			";

						
		global persvar "
		_Iv61a_1 _Iv61a_2 
		_Iv63a_1 _Iv63a_2  
		_Iv65_2 _Iv65_3 _Iv65_4 _Iv65_5
		v21_1 v21_2 v21_3 v21_4 v21_5 v21_6";   				

		global sm_big5 "
		sm_openness_st sm_conscient_st sm_extraversion_st sm_neuroticism_st";   				
		#del cr


		/* === Spezifikationen ============================== */

	    	/* NEUE SPEZIFIKATIONEN 
			1. Basis 
			2. Mit Occupation */
	    
		 if `spec'== 1 {          /* Basiskonfiguration */
                #delimit;
                local rhs " 
                    $basevar1 $basevar2alt $persvar $sm_big5
                    " ;
                local res "
                ";
                #delimit cr
            	 }		 

		 if `spec'==2 {          /* Basiskonfiguration */
                #delimit;
                local rhs " 
                    $basevar1 $basevar2alt $occplus $persvar $sm_big5
                    " ;
                local res "
                ";
                #delimit cr
            	 }



		 
		 			# del;
					local keepdata "
						reg2 sex2 migra2
						german married _Ichild_1 _Ichild_2
						benefit benlevel3
						_Isu_kat_al_2 _Isu_kat_al_3 _Isu_kat_al_4
						_Isu_schule_1 _Isu_schule_2 _Isu_schule_3
		 				_Isu_ausbila1 _Isu_ausbila2
		 				su_alo_age su_sv_age 
		 				_Isu_eintri_1 _Isu_eintri_2 _Isu_eintri_3 _Isu_eintri_4 _Isu_eintri_5
		 				_Isu_eintri_6 _Isu_eintri_7 _Isu_eintri_8 _Isu_eintri_9 _Isu_eintri_10
						_Isu_eintri_11
		 				_Ibefstat_2 _Ibefstat_3 _Ibefstat_4 _Ibefstat_5
						_Idauloint*
						v325_1 v325_2 v325_3 v325_4 v325_5 v325_6 v325_7 v325_8 v325_9 v325_10
						internal*
						p_* 
						estwage_h v122*
						internal_loc loc*
						logestwage chan own
						search_mobi act act2 owncut owncut2
						sm_openness_st sm_conscient_st sm_extraversion_st sm_neuroticism_st
						active_search
						_Iv61a_1 _Iv61a_2 _Iv61a_3 
						_Iv63a_2 _Iv63a_1 _Iv63a_4 
						_Iv65_2 _Iv65_3 _Iv65_4 _Iv65_5
						v21_1 v21_2 v21_3 v21_4 v21_5 v21_6
						loc* LOC*
						selfem*
						iza_sv_tminus1 iza_sv_tminus2 iza_sv_tminus3
					 	iza_ln0wage_tminus1 iza_ln0wage_tminus2 iza_ln0wage_tminus3 
						_Idaloq_0 _Idaloq_1 _Idaloq_2 _Idaloq_3 
						logestwage own 
						_Iiza_beruf_3 _Iiza_beruf_4 _Iiza_beruf_5 _Iiza_beruf_6
						su_w2
						sm_*
						LOC3_*
						LOC4_*
						expect_alo expect_empl 
					 	iza_lastalo_durmiss
					 	iza_lastemp_durmiss
						"
						;
	  				#del cr
						
            
            /* ================== */
            /* === Schaetzung === */
            /* ================== */
            
	       #del;
            /*char diw_beruf_kat[omit] 3*/
            foreach lhs in 
	    				LOC_full36 LOC4_intext36
	   				/*LOC_int3 LOC_ext6 */
									    { ;
						    #del cr
            
                logit `lhs' `rhs' `res'
                predict p_`lhs'_`spec' if `lhs' != . & e(sample)==1, p
	         	 
	        		  keep `keepdata' 	
                save ${pscore}/score_`lhs'_`spec'_r`reg's`sex'_sa`sample', replace
					 
                /* wird abgespeichert, um bei psmatch darauf zuzugreifen. */

					psgraph, treated(`lhs') pscore(p_`lhs'_`spec') title() legend(off)        
					graph export ${graph}/`lhs'_`spec'_r`reg's`sex'_sa`sample'.png, as(png) replace 
                
                /* --- Beobachtungen --- */
                
                tab `lhs' if `lhs' == 0
                scalar nt_all = r(N)
                tab `lhs' if `lhs' == 1
                scalar tn_all = r(N)
    
                tab `lhs' if `lhs' == 0 & e(sample)
                scalar nt_score = r(N)
                tab `lhs' if `lhs' == 1 & e(sample)
                scalar tn_score = r(N)
                

		if `spec'==2 & "`lhs'" == "LOC_full36" {

				 	#delimit; 
                
               est2vec estall_sa`sample'_r`reg's`sex', vars(
						var-socio
						reg2 sex2 
						german married _Ichild_0 _Ichild_1 _Ichild_2
						_Isu_kat_al_1 _Isu_kat_al_2 _Isu_kat_al_3 _Isu_kat_al_4
						_Isu_schule_0 _Isu_schule_1 _Isu_schule_2 _Isu_schule_3
		 				_Isu_ausbila0 _Isu_ausbila1 _Isu_ausbila2
						var-emp	
		 				su_alo_age su_sv_age 
						benefit benlevel3 
		 				_Ibefstat_1 _Ibefstat_3 _Ibefstat_4 _Ibefstat_5 
						selfempl
						iza_sv_tminus1 iza_sv_tminus2 iza_sv_tminus3
					 	iza_ln0wage_tminus1 iza_ln0wage_tminus2 iza_ln0wage_tminus3 
						_Iiza_beruf_1 _Iiza_beruf_3 _Iiza_beruf_4 _Iiza_beruf_5 _Iiza_beruf_6
						iza_lastalo_dur iza_lastemp_dur iza_lastalo_durmiss iza_lastemp_durmiss
						var-traits
						sm_openness_st sm_conscient_st sm_extraversion_st sm_neuroticism_st
						_Iv61a_3 _Iv61a_1 _Iv61a_2 
						_Iv63a_4 _Iv63a_1 _Iv63a_2  
						var-other	
						v21_1 v21_2 v21_3 v21_4 v21_5 v21_6
						_Iv65_1 _Iv65_2 _Iv65_3 _Iv65_4 _Iv65_5
						_Idaloq_0 _Idaloq_1 _Idaloq_2 _Idaloq_3
		 				) 
		 				e(r2_p ll hitrate) replace name(spec`spec'_lhs`lhs'_r`reg's`sex');
					 	est2extlbl, addto(estall_sa`sample'_r`reg's`sex') intex($temp/texlabels_reg) 
					 	path($pscore/) replace dropall saving;
					 #del cr
					 }
					 
					 else {
					 	est2vec tex, addto(estall_sa`sample'_r`reg's`sex') name(spec`spec'_lhs`lhs'_r`reg's`sex')
					 }
					 
					#d; /*suppress*/
					est2tex estall_sa`sample'_r`reg's`sex', replace
					preserve path($pscore/)
					mark(starb) levels(90 95 99) fancy leadzero thousep ;
					#d cr					
					 
					 }	/* lhs */

 		  
			
          
}	/* ende: spec */
}
}
}
clear
log close

