*********************************************************
* LOCUS OF CONTROL AND JOB SEARCH STRATEGIES
* Marco Caliendo, Deborah Cobb-Clark, and Arne Uhlendorff
* Review of Economics and Statistics 
* DOI: 
*********************************************************
* THIS FILE: 03_reg_jobprobability 
* OUTPUT: Regressions for Table 4  
*********************************************************


version 9.2
capture log close

log using 03_reg_jobprobability, text replace


clear

set mem 200m
set matsize 800
set more off
set maxvar 8000 
set trace off
set tracedepth 1
set varabbrev off


/* ========== */
/* Basic Regs */
/* ========== */

global data "DATA DIRECTORY"
global desc "OUTPUT DIRECTORY" 
global reg  "OUTPUT DIRECTORY" 

macro drop _all
   
capture estimates drop _all


forvalues reg = 2/2 {

	forvalues sex = 2/2 {            

          
            /* === Datensatz oeffnen ======================== */
            
	    forvalues sample = 2/2 {
	     
	    use ${data}/data_estimation, clear

	    gen LOC_intext36 = LOC_int3 * LOC_ext6
	    gen jobprob = v139 if v139!=-999&v139!=.
	    gen searchown_full36 = search_own * LOC_full36 
	    rename logestwage lwage
	    gen searchown_intext36 = search_own * LOC4_intext36
	    
	   
	    
		if `sample'==1 {
				count
				local add "lwage"
				count
				}		

		if `sample'==2 {
				count
				local add "lwage"
				keep if su_alter>=20
				count
				}	

		if `sample'==3 {
				count
				local add "lwage"
				keep if iza_lastalo_durmiss==0
				count
				}	

		if `sample'==4 {
				count
				local add "lwage"
				keep if iza_lastalo_durmiss==1
				count
				}	
				
	    
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

		tab daloq internal_loc 
	 	tab daloq0_int
	 	tab daloq1_int
	 	tab daloq2_int
	 	tab daloq3_int

		gen daloq_reswage = daloq*lwage  


		
/******************************************************/
/* === Specifications =============================== */
/******************************************************/
           
            
 	forvalues spec = 1/3 {

		
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

	     global basevar2 "			selfempl benefit benlevel3
						_Isu_schule_1 _Isu_schule_2 _Isu_schule_3
		 				_Isu_ausbila1 _Isu_ausbila2
		 				su_alo_age su_sv_age 
		 				_Ibefstat_2 _Ibefstat_3 _Ibefstat_4 _Ibefstat_5
						iza_sv_tminus1 iza_sv_tminus2 iza_sv_tminus3
					 	iza_ln0wage_tminus1 iza_ln0wage_tminus2 iza_ln0wage_tminus3 
						";

global newhist "iza_lastalo_durmiss iza_lastemp_durmiss expect_alo expect_empl
					 	";

global occupation " _Iiza_beruf_3 _Iiza_beruf_4 _Iiza_beruf_5 _Iiza_beruf_6
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
		

	     if `spec'==1 {          /* Basiskonfiguration (plus Newhist und Occupation) */
                #delimit;
                local rhs " 
                    $basevar1 $basevar2 $persvar search_own searchown_full36 loc_full36_st $sm_big5 $newhist $occupation 
                    ";
                #delimit cr
            	 }

             if `spec'==2 {          /* Basiskonfiguration (plus Newhist und Occupation)  */
                #delimit;
                local rhs " 
                    $basevar1 $basevar2 $persvar search_own searchown_full36 LOC_full36 $sm_big5 $newhist $occupation
                    " ;
                #delimit cr
            	 }

            if `spec'==3 {          /* Basiskonfiguration (plus Newhist und Occupation) */
                #delimit;
                local rhs " 
                    $basevar1 $basevar2 $persvar search_own searchown_intext36 LOC4_intext36 $sm_big5 $newhist $occupation
                    " ;
                #delimit cr
            	 }


	     if `spec'==4 {          /* Basiskonfiguration (plus Newhist und Occupation) */
                #delimit;
                local rhs " 
                    daloq_reswage $basevar1 $basevar2 $persvar search_own searchown_full36 loc_full36_st $sm_big5 $newhist $occupation 
                    ";
                #delimit cr
            	 }

             if `spec'==5 {          /* Basiskonfiguration (plus Newhist und Occupation)  */
                #delimit;
                local rhs " 
                    daloq_reswage $basevar1 $basevar2 $persvar search_own searchown_full36 LOC_full36 $sm_big5 $newhist $occupation
                    " ;
                #delimit cr
            	 }

            if `spec'==6 {          /* Basiskonfiguration (plus Newhist und Occupation) */
                #delimit;
                local rhs " 
                    daloq_reswage $basevar1 $basevar2 $persvar search_own searchown_intext36 LOC4_intext36 $sm_big5 $newhist $occupation
                    " ;
                #delimit cr
            	 }
		 
 

            if `spec'==44 {          /* Basiskonfiguration (ohne BASEVAR2) */
                #delimit;
                local rhs " 
                    $basevar1 $persvar search_own searchown_full36 loc_full36_st $sm_big5
                    " ;
                #delimit cr
            	 }

            if `spec'==55 {          /* Basiskonfiguration (ohne BASEVAR2) */
                #delimit;
                local rhs " 
                    $basevar1 $persvar search_own searchown_full36 LOC_full36 $sm_big5
                    " ;
                #delimit cr
            	 }

            if `spec'==66 {          /* Basiskonfiguration (ohne BASEVAR2) */
                #delimit;
                local rhs " 
                    $basevar1 $persvar search_own searchown_intext36 LOC4_intext36 $sm_big5
                    " ;
                #delimit cr
            	 }
		 
		 
            /* ================== */
            /* === Estimation === */
            /* ================== */

              foreach lhs in probveryhigh { 
              
		   if "`lhs'"=="probveryhigh" {       
			local regfct "probit" 
			#delimit cr
			 }	
			 
	      `regfct' `lhs' `rhs' `add'
	       mfx2, replace 
                if `spec'==1{
                	#del;
	               est2vec `lhs'_`reg'`sex'sa`sample', vars(
						test search_own searchown_full36 
						searchown_intext36 loc_full36_st LOC_full36 LOC4_intext36
						lwage
						daloq_reswage
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
						var-traits
						sm_openness_st sm_conscient_st sm_extraversion_st sm_neuroticism_st
						_Iv61a_3 _Iv61a_1 _Iv61a_2 
						_Iv63a_4 _Iv63a_1 _Iv63a_2  
						var-other	
						v21_1 v21_2 v21_3 v21_4 v21_5 v21_6
						_Iv65_1 _Iv65_2 _Iv65_3 _Iv65_4 _Iv65_5
						_Idaloq_0 _Idaloq_1 _Idaloq_2 _Idaloq_3	       
						_Iiza_beruf_1 _Iiza_beruf_3 _Iiza_beruf_4 _Iiza_beruf_5 _Iiza_beruf_6
						iza_lastalo_durmiss 
					 	iza_lastemp_durmiss 
					 	expect_alo
						expect_empl
						daloq0_int daloq1_int daloq2_int daloq3_int
						) e(r2_p ll) replace name(`lhs'`spec');
   				 	est2extlbl, addto(`lhs'_`reg'`sex'sa`sample') intex($temp/texlabels_reg.tex) 
   				 	path($reg/) replace dropall saving;
   				 	#del cr
					 	}
					 	
	    				else {
					 	est2vec tex, addto(`lhs'_`reg'`sex'sa`sample') name(`lhs'`spec')
					 	}

					 #d;   /*suppress*/
						 est2tex `lhs'_`reg'`sex'sa`sample', replace preserve path($reg/)
						 mark(starb) levels(90 95 99) fancy leadzero thousep ;
					 #d cr
					

					 	} /* Ende lhs */					


			}	/* ende: spec */

			} /* Ende sample */
	} /* Ende Reg */

} /* Ende Sex */




log close
          
