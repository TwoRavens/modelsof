*********************************************************
* LOCUS OF CONTROL AND JOB SEARCH STRATEGIES
* Marco Caliendo, Deborah Cobb-Clark, and Arne Uhlendorff
* Review of Economics and Statistics 
* DOI: 
*********************************************************
* THIS FILE: 02_regressions 
* OUTPUT: Regressions for Table 5  
*********************************************************

version 9.2
capture log close

log using 02_regressions, text replace

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

macro drop _all

global data "DATA DIRECTORY"
global desc "OUTPUT DIRECTORY" 
global reg  "OUTPUT DIRECTORY" 

use ${data}/data_estimation, clear


capture estimates drop _all

forvalues reg = 2/2 {
	forvalues sex = 2/2 {            
	     forvalues sample = 50/50 {

            use ${data}/data_estimation2, clear
            
	    count
	    
	    su iza_lastalo_dur iza_lastalo_durmiss iza_lastemp_dur iza_lastemp_durmiss	
	    su expect_alo expect_empl
	    su loc_full36
	    scalar sdfull = r(sd)
	    su loc_ext6
	    scalar sdext = r(sd)
	    su loc_int3
	    scalar sdint = r(sd)

	    gen loc_full36_sd = loc_full36/scalar(sdfull)
	    gen loc_int3_sd = loc_int3/scalar(sdint)
	    gen loc_ext_sd = loc_ext6/scalar(sdext)

	    gen locfull_sq_new = (loc_full36/scalar(sdfull))^2
	    gen locext6_sq_new = (loc_ext6/scalar(sdext))^2
	    gen locint3_sq_new = (loc_int3/scalar(sdint))^2

	    gen locfull_cu_new = locfull_sq_new^2
	    gen locext6_cu_new = locext6_sq_new^2
	    gen locint3_cu_new = locint3_sq_new^2

	    gen locfull_sq = loc_full36_st*loc_full36_st
	    gen locext6_sq = loc_ext6_st*loc_ext6_st 
	    gen locint3_sq = loc_int3_st*loc_int3_st
	    
	    
	    gen LOC_intext36 = LOC_int3 * LOC_ext6
	    gen owncut2 = search_own
	    gen own5 = search_own/dauloint_kw
	    replace owncut2=100 if owncut2>100
	    gen ocut3 = search_own
            replace ocut3 = . if search_own>=200	    
	    rename search_channel chan 
	    rename search_own own 
	    rename owncut ocut
	    rename owncut2 ocut2
	    
	    rename logestwage lwage
	    gen loc_36st_chan = loc_full36_st*chan
	    gen loc_36st_ownc = loc_full36_st*ocut
	    gen pas2=chan-act2
	    
	    /* SPEC DESCRIPTION ...
	    
	    SPEC 41-45: Main Results (including Square)
	    SPEC 51-62: Sensitivtiy (including LOC2) 
	    SPEC 81-90: Int/Ext only 	
	    SPEC 91-93: including test4correct-test6correct	

	    */
			
	    	if `sample'==50 {       /* replicates Table 5 (incl. occupation und last emp/unemp) */
				count
				local fromto "100/105"
				local tex "100"	
				}			

				
		if `sample'==51 {       /* replicates Table 5 (incl. occupation und last emp/unemp) */
				count
				keep if su_alter>=20
				count
				local fromto "100/100"
				local tex "100"	
				}			
				

		if `sample'==52 {       /* replicates Table 5 (incl. occupation und last emp/unemp) */
				count
				keep if iza_lastalo_durmiss==1
				count
				local fromto "100/100"
				local tex "100"	
				}		
				
		if `sample'==53 {       /* replicates Table 5 (incl. occupation und last emp/unemp) */
				count
				keep if iza_lastalo_durmiss==0
				count
				local fromto "100/100"
				local tex "100"	
				}		
				
		if `sample'==54 {       /* Cognitive Skills sample */
				count
				local fromto "100/100"
				local tex "100"
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

		/* Interaction Dummies LOC Reg-ALO */

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
           
            
 	forvalues spec = `fromto' {
		
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
					 	iza_lastalo_dur 
					 	iza_lastemp_dur 
					 	iza_lastalo_durmiss
					 	iza_lastemp_durmiss";						
						
	     global basevar3 "			selfempl benefit benlevel3
						_Isu_schule_1 _Isu_schule_2 _Isu_schule_3
		 				_Isu_ausbila1 _Isu_ausbila2
		 				su_alo_age su_sv_age 
		 				_Ibefstat_2 _Ibefstat_3 _Ibefstat_4 _Ibefstat_5
						iza_sv_tminus1 iza_sv_tminus2 iza_sv_tminus3
					 	iza_ln0wage_tminus1 iza_ln0wage_tminus2 iza_ln0wage_tminus3 
					 	iza_lastemp_durmiss
					 	expect_empl 
					 	iza_lastalo_durmiss
					 	expect_alo 
					 	_Iiza_beruf_3 _Iiza_beruf_4 _Iiza_beruf_5 _Iiza_beruf_6";						

						
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

		
	   /* Main Results Table 5*/ 
	   
	   if `spec'==100 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar3 $persvar loc_full36_st 
                    " ;
		 #delimit cr
            	 }

	   if `spec'==101 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar3 $persvar loc_full36_st locfull_sq 
                    " ;
		 #delimit cr
            	 }
            	 

           if `spec'==102 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar3 $persvar LOC_full36 
                    " ;
		 #delimit cr
            	 }

           if `spec'==103 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar3 $persvar LOC2_full36
                    " ;
		  #delimit cr
            	 }
            	 
	   if `spec'==104 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar3 $persvar LOC4_intext36
                    " ;
		 #delimit cr
            	 }

	   if `spec'==105 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar3 $persvar LOC44_0 LOC44_2
                    " ;
		 #delimit cr
            	 }

            	 
	   /* Main Results Table 5 (fuer cognitive skills sample) */ 

	   if `spec'==120 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar3 $persvar loc_full36_st $sm_big5 test4correct test5correct test6correct
                    " ;
		 #delimit cr
            	 }

	   if `spec'==121 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar3 $persvar loc_full36_sd locfull_sq_new $sm_big5 test4correct test5correct test6correct
                    " ;
		 #delimit cr
            	 }
            	 

           if `spec'==122 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar3 $persvar LOC_full36 $sm_big5 test4correct test5correct test6correct
                    " ;
		 #delimit cr
            	 }

           if `spec'==123 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar3 $persvar $sm_big5 LOC3_full36 test4correct test5correct test6correct	 
                    " ;
		  #delimit cr
            	 }
            	 
	   if `spec'==124 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar3 $persvar LOC4_intext36 $sm_big5 test4correct test5correct test6correct
                    " ;
		 #delimit cr
            	 }

	   if `spec'==125 {          /* Basiskonfiguration + v120-Kat + LOC*/
                #delimit;
                local rhs " 
                    $basevar1 $basevar3 $persvar LOC44_0 LOC44_2 $sm_big5 test4correct test5correct test6correct
                    " ;
		 #delimit cr
            	 }            	 

            	 
		 
            /* ================== */
            /* === Schaetzung === */
            /* ================== */

	    foreach lhs in own lwage { 

	      if "`lhs'"=="lwage"|"`lhs'"=="own"{
	      local regcom "reg" 
	      }

	      `regcom' `lhs' `rhs' `res'

              if `spec'==`tex'{
                	#del;
	               est2vec l_`lhs'_`reg'`sex'sa`sample', vars(
		       				test
		       				loc_full36_st  
		       				locfull_sq
						LOC_full36 
						LOC2_full36 
						LOC4_intext36 
						LOC44_1 LOC44_0 LOC44_2
						var-socio
						reg2 sex2 
						german married _Ichild_0 _Ichild_1 _Ichild_2
						_Isu_kat_al_1 _Isu_kat_al_2 _Isu_kat_al_3 _Isu_kat_al_4
						_Isu_schule_0 _Isu_schule_1 _Isu_schule_2 _Isu_schule_3
		 				_Isu_ausbila0 _Isu_ausbila1 _Isu_ausbila2
						var-emp	
		 				su_alo_age su_sv_age 
						benefit benlevel3 
		 				_Iiza_beruf_1 _Iiza_beruf_3 _Iiza_beruf_4 _Iiza_beruf_5 _Iiza_beruf_6
		 				_Ibefstat_1 _Ibefstat_3 _Ibefstat_4 _Ibefstat_5 
						selfempl
						iza_sv_tminus1 iza_sv_tminus2 iza_sv_tminus3
					 	iza_ln0wage_tminus1 iza_ln0wage_tminus2 iza_ln0wage_tminus3 
						iza_lastalo_durmiss 
					 	expect_alo
						iza_lastemp_durmiss 
					 	expect_empl
						var-traits
						sm_openness_st sm_conscient_st sm_extraversion_st sm_neuroticism_st
						_Iv61a_3 _Iv61a_1 _Iv61a_2 
						_Iv63a_4 _Iv63a_1 _Iv63a_2  
						var-other	
						v21_1 v21_2 v21_3 v21_4 v21_5 v21_6
						_Iv65_1 _Iv65_2 _Iv65_3 _Iv65_4 _Iv65_5
						_Idaloq_0 _Idaloq_1 _Idaloq_2 _Idaloq_3
					 	test4correct	test5correct test6correct
						) e(r2 r2_a) replace name(`lhs'`spec');
   				 	est2extlbl, addto(l_`lhs'_`reg'`sex'sa`sample') intex($temp/texlabels_reg.tex) 
   				 	path($reg/) replace dropall saving;
   				 	#del cr
					 	}
	    				else {
					 	est2vec tex, addto(l_`lhs'_`reg'`sex'sa`sample') name(`lhs'`spec')
					 	}
					 
					 #d;	/*suppress*/
						 est2tex l_`lhs'_`reg'`sex'sa`sample', replace preserve path($reg/)
						 mark(starb) levels(90 95 99) fancy leadzero thousep ;
					 #d cr
					

					 	} /* Ende lhs */					


			}	/* ende: spec */
			} /* Ende Sample */	
	} /* Ende Reg */

} /* Ende Sex */


log close

