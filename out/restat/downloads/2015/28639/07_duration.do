*********************************************************
* LOCUS OF CONTROL AND JOB SEARCH STRATEGIES
* Marco Caliendo, Deborah Cobb-Clark, and Arne Uhlendorff
* Review of Economics and Statistics 
* DOI: 
*********************************************************
* THIS FILE: 07_duration / Table 7
*********************************************************

version 9.2
capture log close

log using 07_duration, text replace

clear

set mem 1g
set matsize 800
set more off
 
set trace off
set tracedepth 1


/* ========== */
/* Basic Regs */
/* ========== */

macro drop _all

global data "DATA DIRECTORY"
global reg "OUTPUT DIRECTORY" 

capture estimates drop _all

/*********

	/* RESHAPE FOR DURATION ANALYSIS */

	use ${data}/data_estimation if su_w2==1, clear
	reshape long su_emp_ , i(iza_id) j(t)
	
	gen indicator1=0
	replace indicator1=1 if t==0
	by iza_id: replace indicator1=1 if indicator1[_n-1]==1 & su_emp_[_n-1]==0 & (su_emp_==0)

	/* Transition Variables for Estimation */

	gen depue = 0
	by iza_id: replace depue = 1 if indicator1==1 & indicator1[_n+1]==0 & su_emp_[_n+1]==1

	gen t1 = 0 
	replace t1 = 1 if t>=1 & t<=2
	gen t2 = 0 
	replace t2 = 1 if t>=3 & t<=4
	gen t3 = 0 
	replace t3 = 1 if t>=5 & t<=6
	gen t4 = 0 
	replace t4 = 1 if t>=7 & t<=8
	gen t5 = 0 
	replace t5 = 1 if t>=9 & t<=10
	gen t6 = 0 
	replace t6 = 1 if t>=11 & t<=12
	gen t7 = 0 
	replace t7 = 1 if t>=13 & t<=15

	compress
	save ${data}/data_est_reshape, replace

***********/

forvalues reg = 2/2 {

	forvalues sex = 2/2 {            
           
            /* === Datensatz oeffnen ======================== */
            
	     forvalues sample = 2/2 {

            use ${data}/data_est_reshape, clear
	    gen LOC_intext36 = LOC_int3 * LOC_ext6
	    rename search_channel chan 
	    rename search_own own 
	    rename w2_employed w2emp
	    rename w2_emp_ls w2empls
	    rename w2_estwage_h w2rwage
	    gen lw2rwage = log(w2rwage)	
	    rename w2_hwage_ls w2hwage
	    rename w2_alodur alodur
	    rename w2_alodur_ext alodurex 
	    rename w2_empdur empdur
	    rename w2_empdur_ext empdurex 
	    rename unemp_dur_first firstue
	    gen first_hwage = q1313k6_first/(q1312k6_first*4)    
	    rename first_hwage firstwage
	    gen lw2hwage = log(w2hwage)	    
	    replace lw2hwage=0 if lw2hwage<0
	    gen loc_36st_chan = loc_full36_st*chan
	    gen loc_36st_ownc = loc_full36_st*owncut

	    
	    	if `sample'==1 {
				count
				}			
		if `sample'==2 {
				count
				keep if su_w2==1
				count
				}		


		/* Sample definieren */

				if `sex'==2 {
								replace su_sex = 2								
								}			
				if `reg'==2 {
								replace reg =2								
								}			
								
				
				count
				keep if su_sex == `sex' & reg == `reg'
				count

				
				
		/* Interaktionsdummies LOC Reg-ALO */

		gen daloq0_int = 0
		replace  daloq0_int = 0 if daloq ==0 & internal_loc==1
		gen daloq1_int = 0
		replace  daloq1_int = 1 if daloq ==1 & internal_loc==1
		gen daloq2_int = 0
		replace  daloq2_int = 1 if daloq ==2 & internal_loc==1
		gen daloq3_int = 0
		replace  daloq3_int = 1 if daloq ==3 & internal_loc==1
		

		
		
/******************************************************/
/* === Spezifikationen ============================== */
/******************************************************/
           
            
 	forvalues spec = 1/12 {
		
            #del; 
            global basevar1 "			t1 t2 t3 t4 t5 t6 t7
	    					reg2 sex2 migra2
						german married _Ichild_1 _Ichild_2
						_Isu_kat_al_2 _Isu_kat_al_3 _Isu_kat_al_4
		 				_Isu_eintri_1 _Isu_eintri_2 _Isu_eintri_3 _Isu_eintri_4 _Isu_eintri_5
		 				_Isu_eintri_6 _Isu_eintri_7 _Isu_eintri_8 _Isu_eintri_9 _Isu_eintri_10 _Isu_eintri_11
						_Idauloint__8 _Idauloint__9 _Idauloint__10
						_Idauloint__11 _Idauloint__12 _Idauloint__13 _Idauloint__14
						_Idaloq_1 _Idaloq_2 _Idaloq_3 
						";

	     global basevar2 "			selfempl benefit benlevel3
						_Isu_schule_1 _Isu_schule_2 _Isu_schule_3
		 				_Isu_ausbila1 _Isu_ausbila2
		 				su_alo_age su_sv_age 
		 				_Ibefstat_2 _Ibefstat_3 _Ibefstat_4 _Ibefstat_5
						iza_sv_tminus1 iza_sv_tminus2 iza_sv_tminus3
					 	iza_ln0wage_tminus1 iza_ln0wage_tminus2 iza_ln0wage_tminus3 
						";

		global persvar "
		_Iv61a_1 _Iv61a_2 
		_Iv63a_1 _Iv63a_2  
		_Iv65_2 _Iv65_3 _Iv65_4 _Iv65_5
		v21_1 v21_2 v21_3 v21_4 v21_5 v21_6";   				

		global big5 "
		openness_st conscient_st extraversion_st neuroticism_st";   				

		global sm_big5 "
		sm_openness_st sm_conscient_st sm_extraversion_st sm_neuroticism_st";   				
		#del cr

		
	   if `spec'==1 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $persvar loc_full36_st $sm_big5	
                    " ;
                #delimit cr
            	 }		 
	
	   if `spec'==2 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar2 $persvar loc_full36_st $sm_big5	
                    " ;
                #delimit cr
            	 }		 

           if `spec'==3 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $persvar loc_int3_st loc_ext6_st $sm_big5	
                    " ;
                #delimit cr
            	 }

           if `spec'==4 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar2 $persvar loc_int3_st loc_ext6_st $sm_big5	
                    " ;
                #delimit cr
            	 }			 
		
           if `spec'==5 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $persvar loc_full36_st $sm_big5 logestwage own	
                    " ;
                #delimit cr
            	 }

           if `spec'==6 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar2 $persvar loc_full36_st $sm_big5	logestwage own
                    " ;
                #delimit cr
            	 }		 
		 		 
           if `spec'==7 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $persvar loc_int3_st loc_ext6_st $sm_big5 logestwage own	
                    " ;
                #delimit cr
            	 }

           if `spec'==8 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar2 $persvar loc_int3_st loc_ext6_st $sm_big5 logestwage own	
                    " ;
                #delimit cr
            	 }			 

	   if `spec'==9 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $persvar _ILOC3_full_1 _ILOC3_full_2 $sm_big5	
                    " ;
                #delimit cr
            	 }		 
	
	   if `spec'==10 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar2 $persvar _ILOC3_full_1 _ILOC3_full_2 $sm_big5	
                    " ;
                #delimit cr
            	 }		 		 

           if `spec'==11 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $persvar _ILOC3_full_1 _ILOC3_full_2 $sm_big5 logestwage own	
                    " ;
                #delimit cr
            	 }

           if `spec'==12 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar2 $persvar _ILOC3_full_1 _ILOC3_full_2 $sm_big5	logestwage own
                    " ;
                #delimit cr
            	 }				  		 
		 
		
            /* ================== */
            /* === Schaetzung === */
            /* ================== */

	    foreach lhs in depue { 

	      if "`lhs'"=="depue" {
	      local regcom = "logit" 
	      }

	      `regcom' `lhs' `rhs' if indicator1==1 & t<=12
    
              if `spec'==1{
                	#del;
	               est2vec l_`lhs'_`reg'`sex'sa`sample', vars(
		       				test
						t1 t2 t3 t4 t5 t6 t7
		       				loc_full36_st _ILOC3_full_0 _ILOC3_full_1 _ILOC3_full_2 loc_int3_st loc_ext6_st  
						own logestwage
						openness_st conscient_st extraversion_st neuroticism_st
						sm_openness_st sm_conscient_st sm_extraversion_st sm_neuroticism_st
						selfempl benefit benlevel3
						_Isu_schule_1 _Isu_schule_2 _Isu_schule_3
		 				_Isu_ausbila1 _Isu_ausbila2
		 				su_alo_age su_sv_age 
		 				_Ibefstat_2 _Ibefstat_3 _Ibefstat_4 _Ibefstat_5
						iza_sv_tminus1 iza_sv_tminus2 iza_sv_tminus3
					 	iza_ln0wage_tminus1 iza_ln0wage_tminus2 iza_ln0wage_tminus3 
						
						) e(r2 r2_a) replace name(`lhs'`spec');
   				 	est2extlbl, addto(l_`lhs'_`reg'`sex'sa`sample') intex($temp/texlabels_reg.tex) 
   				 	path($reg/) replace dropall saving;
   				 	#del cr
					 	}
	    				else {
					 	est2vec tex, addto(l_`lhs'_`reg'`sex'sa`sample') name(`lhs'`spec')
					 	}
					 
					 #d;
						 est2tex l_`lhs'_`reg'`sex'sa`sample', replace preserve path($reg/)
						 mark(starb) levels(90 95 99) fancy leadzero thousep suppress;
					 #d cr
					

					 	} /* Ende lhs */					


			}	/* ende: spec */
			} /* Ende Sample */	
	} /* Ende Reg */

} /* Ende Sex */




log close
