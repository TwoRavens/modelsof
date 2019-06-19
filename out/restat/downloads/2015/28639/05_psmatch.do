*********************************************************
* LOCUS OF CONTROL AND JOB SEARCH STRATEGIES
* Marco Caliendo, Deborah Cobb-Clark, and Arne Uhlendorff
* Review of Economics and Statistics 
* DOI: 
*********************************************************
* THIS FILE: 05_psmatch   
*********************************************************

version 9.2
capture log close

log using 05_psmatch, text replace

clear

set mem 50m
set matsize 800
set more off
 
set trace off
set tracedepth 1

/* ========================================== */
/* --- PSMATCH (bootstrap) ------------------ */
/* ========================================== */

global data "DATA DIRECTORY"
global desc "OUTPUT DIRECTORY" 

global score "OUTPUT DIRECTORY"  	
global save  "OUTPUT DIRECTORY"    

forvalues sex = 0/0 {            

        forvalues reg = 2/2 {

	forvalues sample = 1/1 {
	
		forvalue spec = 1/2 {

/* ======================================== */
/* === PSMATCH fuer Spec     ============== */
/* ======================================== */

		#del; 
		foreach lhs in  LOC_full36 LOC4_intext36 LOC_int3 LOC_ext6 
					{;
		foreach out in own logestwage {;	
		#del cr	
		
			use ${score}/score_`lhs'_`spec'_r`reg's`sex'_sa`sample', clear  

			keep if `lhs'!=.

	  		/* Datensatz des Scores */
			
			set seed 1256
			gen random = uniform()
			sort random

			local reps = 100
		   		
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
						
	     global occplus "  expect_alo
						expect_empl iza_lastalo_durmiss iza_lastemp_durmiss
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
            	 	 
		 
		 
		 local c = 1
				while `c'<=1 {

					/* Kernel epan mit common */

					if `c'==1{	
					
					
					di "################ $S_DATE $S_TIME"
					
					bootstrap r(att), reps(`reps'): psmatch2 `lhs' `res', pscore(p_`lhs'_`spec') out(`out') kernel k(epan) nowarn common bw(0.06)
					matrix bse`c' = e(b), e(se)
					psmatch2 `lhs' `res', pscore(p_`lhs'_`spec') out(`out') kernel k(epan) nowarn common bw(0.06) 	
					tab _support if `lhs'==1 
					matrix N = r(N) 
					tab _support if `lhs'==0 
					matrix N0 = r(N) 
					tab _support if `lhs'==1 & _support==0
					matrix Off = r(N)		
					pstest `rhs', sum 
					matrix b0 = r(meanbiasbef)
					matrix b1 = r(meanbiasaft)
					matrix b2 = r(medbiasbef)
					matrix b3 = r(medbiasaft)
					matrix effect`c' = bse`c', N, N0, Off, b0, b1, b2, b3
					}

					/* Kernel epan mit common 0.02*/
					if `c'==2{											
					di "################ $S_DATE $S_TIME"
					bootstrap r(att), reps(`reps'): psmatch2 `lhs' `res', pscore(p_`lhs'_`spec') out(`out') kernel k(epan) nowarn common bw(0.02) 	
					matrix bse`c' = e(b), e(se)
					psmatch2 `lhs' `res', pscore(p_`lhs'_`spec') out(`out') kernel k(epan) nowarn common bw(0.02) 	
					tab _support if `lhs'==1 
					matrix N = r(N) 
					tab _support if `lhs'==0 
					matrix N0 = r(N) 
					tab _support if `lhs'==1 & _support==0
					matrix Off = r(N)		
					pstest `rhs', sum 
					matrix b0 = r(meanbiasbef)
					matrix b1 = r(meanbiasaft)
					matrix b2 = r(medbiasbef)
					matrix b3 = r(medbiasaft)
					matrix effect`c' = bse`c', N, N0, Off, b0, b1, b2, b3
					}

					/* Kernel epan mit common, trim(10)*/

					if `c'==3 {											
					di "################ $S_DATE $S_TIME"
					bootstrap r(att), reps(`reps'): psmatch2 `lhs' `res', pscore(p_`lhs'_`spec') out(`out')  kernel k(epan) nowarn common trim(10) bw(0.06)
					matrix bse`c' = e(b), e(se)
					psmatch2 `lhs' `res', pscore(p_`lhs'_`spec') out(`out') kernel k(epan) nowarn common trim(10) bw(0.06)
					tab _support if `lhs'==1 
					matrix N = r(N) 
					tab _support if `lhs'==0 
					matrix N0 = r(N) 
					tab _support if `lhs'==1 & _support==0
					matrix Off = r(N)		
					pstest `rhs', sum 
					matrix b0 = r(meanbiasbef)
					matrix b1 = r(meanbiasaft)
					matrix b2 = r(medbiasbef)
					matrix b3 = r(medbiasaft)
					matrix effect`c' = bse`c', N, N0, Off, b0, b1, b2, b3
					}							

					
					/* Kernel epan mit common, trim(10) bw(0.02)*/

					if `c'==4 {											
					di "################ $S_DATE $S_TIME"
					bootstrap r(att), reps(`reps'): psmatch2 `lhs' `res', pscore(p_`lhs'_`spec') out(`out') kernel k(epan) nowarn common trim(10) bw(0.02)
					matrix bse`c' = e(b), e(se)
					psmatch2 `lhs' `res', pscore(p_`lhs'_`spec') out(`out') kernel k(epan) nowarn common trim(10) bw(0.02)
					tab _support if `lhs'==1 
					matrix N = r(N) 
					tab _support if `lhs'==0 
					matrix N0 = r(N) 
					tab _support if `lhs'==1 & _support==0
					matrix Off = r(N)		
					pstest `rhs', sum 
					matrix b0 = r(meanbiasbef)
					matrix b1 = r(meanbiasaft)
					matrix b2 = r(medbiasbef)
					matrix b3 = r(medbiasaft)
					matrix effect`c' = bse`c', N, N0, Off, b0, b1, b2, b3
					}							
					
	
					local c = `c'+1
					}						

					#delimit; 
					*matrix result= effect1\effect2\effect3\effect4; 
					matrix result= effect1; 
					#delimit cr

					drop _all
					svmat result, names(effect)
					
					gen str25 art = "Kernel = epan common 0.06"
					*replace art = "Kernel = epan common 0.02" in 2
					*replace art = "Kernel = epan common 0.06 trim10" in 3
					*replace art = "Kernel = epan common 0.02 trim10" in 4
					
					rename effect1 effect
					rename effect2 se
					rename effect3 TN
					rename effect4 NT
					rename effect5 Off
					rename effect6 meanbiasbef
					rename effect7 meanbiasaft
					rename effect8 mdebiasbef
					rename effect9 medbiasaft
					gen t = effect/se
					gen group = "`lhs'"
					gen spec = `spec'
					order group spec art effect se t 
					
					save ${save}/`lhs'_`out'_`spec'_r`reg's`sex'_sa`sample', replace					
					outsheet using ${save}/`lhs'_`out'_`spec'_r`reg's`sex'_sa`sample'.csv, comma noquote replace
														
				  } /* Ende: out */

		
		} /* Ende: lhs */


} /* Ende: spec*/
} /* Ende: sample*/
} /* Ende: reg*/
} /* Ende: sex*/

log close
exit


} /* Ende: spec*/
} /* Ende: sample*/
} /* Ende: reg*/
} /* Ende: sex*/

log close
exit
