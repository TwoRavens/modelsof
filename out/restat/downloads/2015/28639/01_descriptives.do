*********************************************************
* LOCUS OF CONTROL AND JOB SEARCH STRATEGIES
* Marco Caliendo, Deborah Cobb-Clark, and Arne Uhlendorff
* Review of Economics and Statistics 
* DOI: 
*********************************************************
* THIS FILE: 01_descriptives  
* OUTPUT: DESCRIPTIVE TABLES 1, 2 and 3 and Figures 1 and 2
*********************************************************

version 9.2
capture log close

log using 01_descriptives, text replace

clear
set mem 100m
set matsize 800
set more off
set trace off
   

global data "DATA DIRECTORY"
global desc "OUTPUT DIRECTORY" 
global reg  "OUTPUT DIRECTORY" 

use ${data}/data_estimation, clear


#del; 

/* LOC - Table 1 */ 

	global loc "
	v325_0 v325_1 v325_2 v325_3 v325_5 v325_6 v325_7 v325_8 v325_9 v325_10 
	loc_int3 loc_ext6 loc_full36 loc_full26 
	LOC_int3 LOC_ext6 
		";	

/* Outvars - Table 3 */ 
		
global outvar " estwage_h logestwage 
		search_own
		_Is_own_kat_0 _Is_own_kat_1 _Is_own_kat_2 _Is_own_kat_3 _Is_own_kat_4 _Is_own_kat_5
		 ";
global jobprob " v139 v139_1 v139_2 v139_3 v139_4
		 ";

/* Descriptives - Table 2 + NEW VARIABLES */		 
		 
global mixvar "reg2 sex2 
		  german
		  su_alter 
		  married _Ichild_1 _Ichild_2
		  benefit benlevel2 benlevel3
		  _Isu_schule_0 _Isu_schule_1 _Isu_schule_2 _Isu_schule_3
		  _Isu_ausbila1 _Isu_ausbila2
		  su_alo_age su_sv_age 
		  _Ibefstat_2 _Ibefstat_3 _Ibefstat_4 _Ibefstat_5
		 iza_sv_tminus1 iza_sv_tminus2 iza_sv_tminus3
		 iza_ln0wage_tminus1 iza_ln0wage_tminus2 iza_ln0wage_tminus3 
		 _Idaloq_0 _Idaloq_1 _Idaloq_2 _Idaloq_3 selfempl
		  openness conscient extraversion neuroticism
		  _Iv61a_3 _Iv61a_1 _Iv61a_2 
		 _Iv63a_4 _Iv63a_1 _Iv63a_2  
		 _Iv65_1 _Iv65_2 _Iv65_3 _Iv65_4 _Iv65_5
		 v21_1 v21_2 v21_3 v21_4 v21_5 v21_6";		  
		
/* NEW: ALL INDEPVARS */		 
global indepvars "reg2 sex2 
		  german
		  su_alter 
		  married _Ichild_1 _Ichild_2
		  benefit benlevel2 benlevel3
		  _Isu_schule_0 _Isu_schule_1 _Isu_schule_2 _Isu_schule_3
		  _Isu_ausbila1 _Isu_ausbila2
		  su_alo_age su_sv_age 
		  _Ibefstat_2 _Ibefstat_3 _Ibefstat_4 _Ibefstat_5
		 iza_sv_tminus1 iza_sv_tminus2 iza_sv_tminus3
		 iza_ln0wage_tminus1 iza_ln0wage_tminus2 iza_ln0wage_tminus3 
		 _Idaloq_0 _Idaloq_1 _Idaloq_2 _Idaloq_3 selfempl
		  openness conscient extraversion neuroticism
		  _Iv61a_3 _Iv61a_1 _Iv61a_2 
		 _Iv63a_4 _Iv63a_1 _Iv63a_2  
		 _Iv65_1 _Iv65_2 _Iv65_3 _Iv65_4 _Iv65_5
		 v21_1 v21_2 v21_3 v21_4 v21_5 v21_6
		iza_lastemp_durmiss
		expect_empl 
		iza_lastalo_durmiss
		expect_alo 
		_Iiza_beruf_1 _Iiza_beruf_3 _Iiza_beruf_4 _Iiza_beruf_5 _Iiza_beruf_6
		 ";		  
		
global newvars "iza_lastalo_dur
		iza_lastalo_durmiss
		iza_lastemp_dur
		iza_lastemp_durmiss";		  
		 
global cognitive "test4correct test5correct test6correct test7correct";		  


/* DESC2TEX - NEW - FOR LOC2 */ 

	   desc2tex using ${desc}/ttest_loc_intext36, 
	   vars($loc) ttest(LOC4_intext36) tableoff
	   digits(2) replace sd() filled
	   templates($temp/texlabels.tex);
	   
	   desc2tex using ${desc}/ttest_mix_intext36, 
	   vars($mixvar) ttest(LOC4_intext36) tableoff
	   digits(2) replace sd() filled
	   templates($temp/texlabels.tex);

     	   desc2tex using ${desc}/ttest_indepvars_intext36, 
	   vars($indepvars) ttest(LOC4_intext36) tableoff
	   digits(2) replace sd() filled
	   templates($temp/texlabels.tex);
	   
	   desc2tex using ${desc}/ttest_newvars_intext36, 
	   vars($newvars) ttest(LOC4_intext36) tableoff
	   digits(2) replace sd() filled
	   templates($temp/texlabels.tex);

	   desc2tex using ${desc}/ttest_outvar_intext36, 
	   vars($outvar) ttest(LOC4_intext36) tableoff
	   digits(2) replace sd() 
	   templates($temp/texlabels.tex);

	   desc2tex using ${desc}/ttest_jobprob_intext36, 
	   vars($jobprob) ttest(LOC4_intext36) tableoff
	   digits(2) replace sd() filled
	   templates($temp/texlabels.tex);
	   
	   desc2tex using ${desc}/ttest_cognitive_intext36, 
	   vars($cognitive) ttest(LOC4_intext36) tableoff
	   digits(2) replace sd() filled
	   templates($temp/texlabels.tex);

/* DESC2TEX */ 


	   desc2tex using ${desc}/ttest_loc_full36, 
	   vars($loc) ttest(LOC_full36) tableoff
	   digits(2) replace sd() filled
	   templates($temp/texlabels.tex);
	   
	   desc2tex using ${desc}/ttest_mix_full36, 
	   vars($mixvar) ttest(LOC_full36) tableoff
	   digits(2) replace sd() filled
	   templates($temp/texlabels.tex);

	   desc2tex using ${desc}/ttest_newvars, 
	   vars($newvars) ttest(LOC_full36) tableoff
	   digits(2) replace sd() filled
	   templates($temp/texlabels.tex);

   	   desc2tex using ${desc}/ttest_indepvars, 
	   vars($indepvars) ttest(LOC_full36) tableoff
	   digits(2) replace sd() filled
	   templates($temp/texlabels.tex);

	   desc2tex using ${desc}/ttest_outvar, 
	   vars($outvar) ttest(LOC_full36) tableoff
	   digits(2) replace sd() 
	   templates($temp/texlabels.tex);

	   desc2tex using ${desc}/ttest_jobprob, 
	   vars($jobprob) ttest(LOC_full36) tableoff
	   digits(2) replace sd() filled
	   templates($temp/texlabels.tex);
	   
	   desc2tex using ${desc}/ttest_cognitive, 
	   vars($cognitive) ttest(LOC_full36) tableoff
	   digits(2) replace sd() filled
	   templates($temp/texlabels.tex);

	
#del cr

	rename estwage_h ResWage
	
/* create box-plots over grouped versions of loc_full36_st and loc_full36 */
	
	gen loc_full36_st_round = round(loc_full36_st)
	replace loc_full36_st_round = -3 if loc_full36_st_round == -4
	
	gen loc_full36_round = round(loc_full36)
	replace loc_full36_round = 3 if loc_full36_round == 2
	
	/* Group the variables by first number */
	/* Standardized: Make cut-off-points at -4 -3 -2 -1 0 1 2 3 */
	
	egen loc_full36_st_cut1 = cut(loc_full36_st), at(-4 -3 -2 -1 0 1 2 3) 
	replace loc_full36_st_cut1  = -4 if loc_full36_st < - 4
	
	/* Regular: Make cut-off-points at 1/7 */
	egen loc_full36_cut1 = cut(loc_full36), at(1(1)7)
	replace loc_full36_cut1 = 7 if loc_full36 == 7
	replace loc_full36_cut1 = 2 if loc_full36_cut1 == 1
	

	foreach out in ResWage owncut {
	 
		if "`out'" == "ResWage" {
		local label Hourly reservation wage
		local begin 0 
		local step 5
		local end 25
		su `out'
		local max = round(r(max), .01)
		local maxplace = `max' - 1
		local min = round(r(min), .01)
		local minplace = `min' + 1

		}
		if "`out'" == "owncut" {
		local label Number of own applications
		local begin 0 
		local step 10 
		local end 100 
		su `out'
		local max = round(r(max), .01)
		local maxplace = `max' - 3
		local min = round(r(min), .01)
		local minplace = `min' + 3
		}
		
			
	reg `out' loc_full36
	predict `out'hat if e(sample) == 1
	
	
	/****** OHNE min-max-info *******/

	# del ;
	twoway 
	scatter `out' loc_full36 ||
	line `out'hat loc_full36, lwidth(thick) lpattern(solid) ylabel(`begin'(`step')`end') 
	xtitle("Locus of control") xlabel(0(1)8) 
	ytitle(`label') scheme(s2mono)
	graphregion(fcolor(white)) legend(off);
	# del cr
	
	graph export ${desc}/plot2_`out'_loc_36full.png, as(png) replace 
	
	
	# del ;
	twoway 
	scatter `out' loc_full36_st ||
	line `out'hat_st loc_full36_st, lwidth(thick) lpattern(solid) ylabel(`begin'(`step')`end') 
	xtitle("Locus of control (standardized)") xlabel(-5(1)5)
	ytitle(`label') scheme(s2mono)

	graphregion(fcolor(white)) legend(off);
	# del cr
	
	graph export ${desc}/plot2_`out'_loc_36full_st.png, as(png) replace

	/***************/
	/* Boxplot */
	/***************/
	
	foreach cut in round cut1 {
	# del ; 
	graph box `out', over(loc_full36_`cut') ytitle(`label') scheme(s2mono) 
	graphregion(fcolor(white)) legend(off) note("by grouped values of locus of control"); 
	graph export ${desc}/boxplot_`out'_36full_`cut'.png, as(png) replace; 
	# del cr
	}
	
	foreach cut in st_round st_cut1 {
	# del ; 
	graph box `out', over(loc_full36_`cut') ytitle(`label') scheme(s2mono) 
	graphregion(fcolor(white)) legend(off) note("by grouped values of locus of control (standardized)");
	graph export ${desc}/boxplot_`out'_36full_`cut'.png, as(png) replace; 
	# del cr 
	}
	}

/***************************************/
/* Factor Analysis und Factor Loadings */	
/***************************************/

	   generate qlabel = "";
	   replace qlabel = "Q1." in 1;
	   replace qlabel = "Q2." in 2;
	   replace qlabel = "Q3." in 3;
	   replace qlabel = "Q4." in 4;
	   replace qlabel = "Q5." in 5;
	   replace qlabel = "Q6." in 6;
	   replace qlabel = "Q7." in 7;
	   replace qlabel = "Q8." in 8;
	   replace qlabel = "Q9." in 9;
	   replace qlabel = "Q10." in 10;
	   
	factor v325_1-v325_10;
	rotate ;
	loadingplot, mlabel(qlabel);
	graph export ${desc}/loadingplot_r2s2.png, as(png) replace ;

	/* Cronbachs Alpha */
	/* Internal 2 */
	alpha v325_1 v325_6; 
	/* Internal 3 */
	alpha v325_1 v325_6 v325_9; 
	gen v325_1_new = 8-v325_1;
	gen v325_6_new = 8-v325_6;
	gen v325_9_new = 8-v325_9;
	
	/* External 6 */
	alpha v325_2 v325_3 v325_5 v325_7 v325_8 v325_10; 

	/* All items (except v325_4) */

	alpha v325_1 v325_2 v325_3 v325_5 v325_6 v325_7 v325_8 v325_9 v325_10; 
	alpha v325_1_new v325_2 v325_3 v325_5 v325_6_new v325_7 v325_8 v325_9_new v325_10; 
	

/**************************/
/* HISTOGRAM of the INDEX */
/**************************/

	#del;
	hist loc_full36, 
	title("Index: Full") xline(45) percent xscale(range(.0 25))
	graphregion(fcolor(white)); 
	graph export ${desc}/hist_full36.png, as(png) replace ;
	#del cr

	
log close	
