/* Bargaining over Maternity Pay: Evidence from UK Universities, Vera Troeger and Mariaelisa Epifanio
Journal of Public Policy*/

/* replication file this file reproduces all tables and figures in the main text and the online appendix */

cd  /*change working directory here once*/

use et_jpp_replication.dta

/* Variables used in the analysis that were generated from variables in the dataset, the variables don't have to be generated again, they are already in the final dataset, this is just for inforamtion.*/

/*

gen weeks_full90= weeks_full_salrep_ml+ weeks90smp_ml+ weeks90_ml
gen ac_fem_pertotal13=ac_fem13/academic_staff_total13
gen ac_fem_pertotal0607=ac_fem0607/academic_staff_total0607
gen proffem_pertotal13= prof_fem13/ academic_staff_total13
gen proffem_perprof13= prof_fem13/ (prof_fem13+ prof_male13)
gen proffem_pertotal13= prof_fem13/ academic_staff_total13
gen proffem_pertotal0607= prof_fem0607/ academic_staff_total0607
gen ac_fem_ft_pertotalfem13= ac_fem_fixedterm13/ ac_fem13
gen ac_fem_ft_pertotal13= ac_fem_fixedterm13/ academic_staff_total13
gen ac_fem_pt_pertotalfem13= ac_fem_parttime13/ ac_fem13
gen ac_fem_pt_pertotal13= ac_fem_parttime13/ academic_staff_total13
gen ac_fem_ft_pertotalfem0607= ac_fem_fixedterm0607/ ac_fem0607
gen ac_fem_ft_pertotal0607= ac_fem_fixedterm0607/ academic_staff_total0607
gen ac_fem_pt_pertotalfem0607= ac_fem_parttime0607/ ac_fem0607
gen ac_fem_pt_pertotal0607= ac_fem_parttime0607/ academic_staff_total0607
gen ac_fem2540_pertotalfem13= (ac_fem25_13+ ac_fem2630_13+ ac_fem3135_13+ ac_fem3640_13)/ ac_fem13
gen ac_fem2540_pertotalfem0607= (ac_fem25_0607+ ac_fem2630_0607+ ac_fem3135_0607+ ac_fem3640_0607)/ ac_fem0607
gen income_researchgrants_inmills_13=income_researchgrants_in000s_13/1000
gen totalincome_inmills_13=totalincome_in000s_13/1000
gen academic_staff_total_in000s_0607=academic_staff_total0607/1000
replace share_fem_sal1=0 if share_fem_sal1==.
replace share_fem_sal2=0 if share_fem_sal2==.
replace share_fem_sal3=0 if share_fem_sal3==.
replace share_fem_sal4=0 if share_fem_sal4==.
replace share_fem_sal5=0 if share_fem_sal5==.
replace share_fem_sal6=0 if share_fem_sal6==.
gen av_fem_sal13= (ac_sal1* share_fem_sal1*17503+ ac_sal2* share_fem_sal2*20428+ ac_sal3* share_fem_sal3*27342+ ac_sal4* share_fem_sal4*36693+ ac_sal5* share_fem_sal5*49261+ ac_sal6* share_fem_sal6*56467)/ ac_fem13
gen statut_matpay_share=7124/av_fem_sal13
label var statut_matpay_share "percentage of statutory maternity pay of average annual female earnings"
gen weeksfull_equivalent2=weeks_full_salrep_ml+0.9* weeks90smp_ml+0.9* weeks90_ml+0.5* weeks_salrep_halfincludessmp_ml+0.5* lowerbtw12paysmpand90+0.5* weekshalfsmp+0.5* halfpay+0.5* greaterbtwhalfpayandsmp+0.5* weekshalfma+statut_matpay_share* weeksstatutory1322+statut_matpay_share* weeksstatutory+statut_matpay_share* smp10salary+statut_matpay_share*lowerbtwsmpand90
gen weeksfull_equivalent=weeks_full_salrep_ml+0.9* weeks90smp_ml+0.9* weeks90_ml+0.5* weeks_salrep_halfincludessmp_ml+0.5* lowerbtw12paysmpand90+0.5* weekshalfsmp+0.5* halfpay+0.5* greaterbtwhalfpayandsmp+0.5* weekshalfma
gen nursery_fillmiss=nursery
replace nursery_fillmiss=0 if nursery==.
gen diffpack=differentpackages_ml
replace diffpack=0 if differentpackages_ml==1
replace diffpack=1 if differentpackages_ml>1

gen maleprof_pertotal2015=ac_male_prof2015/all_staff2015
gen maleprof_pertotal2008=ac_male_prof2008/all_staff2008
gen maleprof_perac2015=ac_male_prof2015/academic2015
gen maleprof_perac2008=ac_male_prof2008/academic2008

gen maleprof_pertotal2009=ac_male_prof2009/all_staff2009
gen maleprof_pertotal2010=ac_male_prof2010/all_staff2010
gen maleprof_pertotal2011=ac_male_prof2011/all_staff2011
gen maleprof_pertotal2012=ac_male_prof2012/all_staff2012
gen maleprof_pertotal2013=ac_male_prof2013/all_staff2013
gen maleprof_pertotal2014=ac_male_prof2014/all_staff2014

gen femseniormanager_pertotal2006= admin_fem_seniormanager2006/all_staff2006
gen femseniormanager_pertotal2012= admin_fem_seniormanager2012/all_staff2012
gen femseniormanager_pertotal2004= admin_fem_seniormanager2004/all_staff2004
gen femseniormanager_pertotal2005= admin_fem_seniormanager2005/all_staff2005
gen femseniormanager_pertotal2007= admin_fem_seniormanager2007/all_staff2007
gen femseniormanager_pertotal2008= admin_fem_seniormanager2008/all_staff2008
gen femseniormanager_pertotal2009= admin_fem_seniormanager2009/all_staff2009
gen femseniormanager_pertotal2010= admin_fem_seniormanager2010/all_staff2010
gen femseniormanager_pertotal2011= admin_fem_seniormanager2011/all_staff2011
gen femseniormanager_pertotal2013= admin_fem_seniormanager2013/all_staff2013
gen femseniormanager_pertotal2014= admin_fem_seniormanager2014/all_staff2014
gen femseniormanager_pertotal2015= admin_fem_seniormanager2015/all_staff2015

gen adminmale_fixed_pertotal2006= admin_male_fixed2006/all_staff2006
gen adminmale_fixed_pertotal2012= admin_male_fixed2012/all_staff2012
gen adminmale_fixed_pertotal2004= admin_male_fixed2004/all_staff2004
gen adminmale_fixed_pertotal2005= admin_male_fixed2005/all_staff2005
gen adminmale_fixed_pertotal2007= admin_male_fixed2007/all_staff2007
gen adminmale_fixed_pertotal2008= admin_male_fixed2008/all_staff2008
gen adminmale_fixed_pertotal2009= admin_male_fixed2009/all_staff2009
gen adminmale_fixed_pertotal2010= admin_male_fixed2010/all_staff2010
gen adminmale_fixed_pertotal2011= admin_male_fixed2011/all_staff2011
gen adminmale_fixed_pertotal2013= admin_male_fixed2013/all_staff2013
gen adminmale_fixed_pertotal2014= admin_male_fixed2014/all_staff2014
gen adminmale_fixed_pertotal2015= admin_male_fixed2015/all_staff2015

gen acmale_fixed_pertotal2006= ac_male_fixed2006/all_staff2006
gen acmale_fixed_pertotal2012= ac_male_fixed2012/all_staff2012
gen acmale_fixed_pertotal2004= ac_male_fixed2004/all_staff2004
gen acmale_fixed_pertotal2005= ac_male_fixed2005/all_staff2005
gen acmale_fixed_pertotal2007= ac_male_fixed2007/all_staff2007
gen acmale_fixed_pertotal2008= ac_male_fixed2008/all_staff2008
gen acmale_fixed_pertotal2009= ac_male_fixed2009/all_staff2009
gen acmale_fixed_pertotal2010= ac_male_fixed2010/all_staff2010
gen acmale_fixed_pertotal2011= ac_male_fixed2011/all_staff2011
gen acmale_fixed_pertotal2013= ac_male_fixed2013/all_staff2013
gen acmale_fixed_pertotal2014= ac_male_fixed2014/all_staff2014
gen acmale_fixed_pertotal2015= ac_male_fixed2015/all_staff2015


/* RHS variables are in the year before the latest OMP was implemented */
gen year_bcomp=year-1
gen all_staff_bcomp=.
gen acadminfem_ratio_bcomp=.
gen femprof_pertotal_bcomp=.
gen ac_femu40_perall_bcomp=.
gen studentstaff_ratio_bcomp=.
gen maleprof_pertotal_bcomp=.
gen femseniormanager_pertotal_bcomp=.
gen fem_pertotal_bcomp=.
gen admin_femu40_perall_bcomp=.
gen ucu_density_bcomp=.

replace ucu_density_bcomp= ucu_density2007 if year_bcomp<2013
replace ucu_density_bcomp= ucu_density2013 if year_bcomp>2012 & year_bcomp<2015
replace ucu_density_bcomp= ucu_density2015 if year_bcomp>2014 & year_bcomp<2018
replace ucu_density_bcomp= ucu_density2018 if year_bcomp>2017

replace all_staff_bcomp=all_staff2004 if year_bcomp<2005
replace all_staff_bcomp=all_staff2005 if year_bcomp==2005
replace all_staff_bcomp=all_staff2006 if year_bcomp==2006
replace all_staff_bcomp=all_staff2007 if year_bcomp==2007
replace all_staff_bcomp=all_staff2008 if year_bcomp==2008
replace all_staff_bcomp=all_staff2009 if year_bcomp==2009
replace all_staff_bcomp=all_staff2010 if year_bcomp==2010
replace all_staff_bcomp=all_staff2011 if year_bcomp==2011
replace all_staff_bcomp=all_staff2012 if year_bcomp==2012
replace all_staff_bcomp=all_staff2013 if year_bcomp==2013
replace all_staff_bcomp=all_staff2014 if year_bcomp==2014
replace all_staff_bcomp=all_staff2015 if year_bcomp==2015

replace acadminfem_ratio_bcomp=acadminfem_ratio2004 if year_bcomp<2005
replace acadminfem_ratio_bcomp=acadminfem_ratio2005 if year_bcomp==2005
replace acadminfem_ratio_bcomp=acadminfem_ratio2006 if year_bcomp==2006
replace acadminfem_ratio_bcomp=acadminfem_ratio2007 if year_bcomp==2007
replace acadminfem_ratio_bcomp=acadminfem_ratio2008 if year_bcomp==2008
replace acadminfem_ratio_bcomp=acadminfem_ratio2009 if year_bcomp==2009
replace acadminfem_ratio_bcomp=acadminfem_ratio2010 if year_bcomp==2010
replace acadminfem_ratio_bcomp=acadminfem_ratio2011 if year_bcomp==2011
replace acadminfem_ratio_bcomp=acadminfem_ratio2012 if year_bcomp==2012
replace acadminfem_ratio_bcomp=acadminfem_ratio2013 if year_bcomp==2013
replace acadminfem_ratio_bcomp=acadminfem_ratio2014 if year_bcomp==2014
replace acadminfem_ratio_bcomp=acadminfem_ratio2015 if year_bcomp==2015

replace femprof_pertotal_bcomp=femprof_pertotal2004 if year_bcomp<2005
replace femprof_pertotal_bcomp=femprof_pertotal2005 if year_bcomp==2005
replace femprof_pertotal_bcomp=femprof_pertotal2006 if year_bcomp==2006
replace femprof_pertotal_bcomp=femprof_pertotal2007 if year_bcomp==2007
replace femprof_pertotal_bcomp=femprof_pertotal2008 if year_bcomp==2008
replace femprof_pertotal_bcomp=femprof_pertotal2009 if year_bcomp==2009
replace femprof_pertotal_bcomp=femprof_pertotal2010 if year_bcomp==2010
replace femprof_pertotal_bcomp=femprof_pertotal2011 if year_bcomp==2011
replace femprof_pertotal_bcomp=femprof_pertotal2012 if year_bcomp==2012
replace femprof_pertotal_bcomp=femprof_pertotal2013 if year_bcomp==2013
replace femprof_pertotal_bcomp=femprof_pertotal2014 if year_bcomp==2014
replace femprof_pertotal_bcomp=femprof_pertotal2015 if year_bcomp==2015

replace ac_femu40_perall_bcomp=ac_femu40_perall2004 if year_bcomp<2005
replace ac_femu40_perall_bcomp=ac_femu40_perall2005 if year_bcomp==2005
replace ac_femu40_perall_bcomp=ac_femu40_perall2006 if year_bcomp==2006
replace ac_femu40_perall_bcomp=ac_femu40_perall2007 if year_bcomp==2007
replace ac_femu40_perall_bcomp=ac_femu40_perall2008 if year_bcomp==2008
replace ac_femu40_perall_bcomp=ac_femu40_perall2009 if year_bcomp==2009
replace ac_femu40_perall_bcomp=ac_femu40_perall2010 if year_bcomp==2010
replace ac_femu40_perall_bcomp=ac_femu40_perall2011 if year_bcomp==2011
replace ac_femu40_perall_bcomp=ac_femu40_perall2012 if year_bcomp==2012
replace ac_femu40_perall_bcomp=ac_femu40_perall2013 if year_bcomp==2013
replace ac_femu40_perall_bcomp=ac_femu40_perall2014 if year_bcomp==2014
replace ac_femu40_perall_bcomp=ac_femu40_perall2015 if year_bcomp==2015

replace studentstaff_ratio_bcomp=studentstaff_ratio2004 if year_bcomp<2005
replace studentstaff_ratio_bcomp=studentstaff_ratio2005 if year_bcomp==2005
replace studentstaff_ratio_bcomp=studentstaff_ratio2006 if year_bcomp==2006
replace studentstaff_ratio_bcomp=studentstaff_ratio2007 if year_bcomp==2007
replace studentstaff_ratio_bcomp=studentstaff_ratio2008 if year_bcomp==2008
replace studentstaff_ratio_bcomp=studentstaff_ratio2009 if year_bcomp==2009
replace studentstaff_ratio_bcomp=studentstaff_ratio2010 if year_bcomp==2010
replace studentstaff_ratio_bcomp=studentstaff_ratio2011 if year_bcomp==2011
replace studentstaff_ratio_bcomp=studentstaff_ratio2012 if year_bcomp==2012
replace studentstaff_ratio_bcomp=studentstaff_ratio2013 if year_bcomp==2013
replace studentstaff_ratio_bcomp=studentstaff_ratio2014 if year_bcomp==2014
replace studentstaff_ratio_bcomp=studentstaff_ratio2015 if year_bcomp==2015

replace maleprof_pertotal_bcomp=maleprof_pertotal2004 if year_bcomp<2005
replace maleprof_pertotal_bcomp=maleprof_pertotal2005 if year_bcomp==2005
replace maleprof_pertotal_bcomp=maleprof_pertotal2006 if year_bcomp==2006
replace maleprof_pertotal_bcomp=maleprof_pertotal2007 if year_bcomp==2007
replace maleprof_pertotal_bcomp=maleprof_pertotal2008 if year_bcomp==2008
replace maleprof_pertotal_bcomp=maleprof_pertotal2009 if year_bcomp==2009
replace maleprof_pertotal_bcomp=maleprof_pertotal2010 if year_bcomp==2010
replace maleprof_pertotal_bcomp=maleprof_pertotal2011 if year_bcomp==2011
replace maleprof_pertotal_bcomp=maleprof_pertotal2012 if year_bcomp==2012
replace maleprof_pertotal_bcomp=maleprof_pertotal2013 if year_bcomp==2013
replace maleprof_pertotal_bcomp=maleprof_pertotal2014 if year_bcomp==2014
replace maleprof_pertotal_bcomp=maleprof_pertotal2015 if year_bcomp==2015

replace femseniormanager_pertotal_bcomp=femseniormanager_pertotal2004 if year_bcomp<2005
replace femseniormanager_pertotal_bcomp=femseniormanager_pertotal2005 if year_bcomp==2005
replace femseniormanager_pertotal_bcomp=femseniormanager_pertotal2006 if year_bcomp==2006
replace femseniormanager_pertotal_bcomp=femseniormanager_pertotal2007 if year_bcomp==2007
replace femseniormanager_pertotal_bcomp=femseniormanager_pertotal2008 if year_bcomp==2008
replace femseniormanager_pertotal_bcomp=femseniormanager_pertotal2009 if year_bcomp==2009
replace femseniormanager_pertotal_bcomp=femseniormanager_pertotal2010 if year_bcomp==2010
replace femseniormanager_pertotal_bcomp=femseniormanager_pertotal2011 if year_bcomp==2011
replace femseniormanager_pertotal_bcomp=femseniormanager_pertotal2012 if year_bcomp==2012
replace femseniormanager_pertotal_bcomp=femseniormanager_pertotal2013 if year_bcomp==2013
replace femseniormanager_pertotal_bcomp=femseniormanager_pertotal2014 if year_bcomp==2014
replace femseniormanager_pertotal_bcomp=femseniormanager_pertotal2015 if year_bcomp==2015

replace fem_pertotal_bcomp=fem_pertotal2004 if year_bcomp<2005
replace fem_pertotal_bcomp=fem_pertotal2005 if year_bcomp==2005
replace fem_pertotal_bcomp=fem_pertotal2006 if year_bcomp==2006
replace fem_pertotal_bcomp=fem_pertotal2007 if year_bcomp==2007
replace fem_pertotal_bcomp=fem_pertotal2008 if year_bcomp==2008
replace fem_pertotal_bcomp=fem_pertotal2009 if year_bcomp==2009
replace fem_pertotal_bcomp=fem_pertotal2010 if year_bcomp==2010
replace fem_pertotal_bcomp=fem_pertotal2011 if year_bcomp==2011
replace fem_pertotal_bcomp=fem_pertotal2012 if year_bcomp==2012
replace fem_pertotal_bcomp=fem_pertotal2013 if year_bcomp==2013
replace fem_pertotal_bcomp=fem_pertotal2014 if year_bcomp==2014
replace fem_pertotal_bcomp=fem_pertotal2015 if year_bcomp==2015

replace admin_femu40_perall_bcomp=admin_femu40_perall2004 if year_bcomp<2005
replace admin_femu40_perall_bcomp=admin_femu40_perall2005 if year_bcomp==2005
replace admin_femu40_perall_bcomp=admin_femu40_perall2006 if year_bcomp==2006
replace admin_femu40_perall_bcomp=admin_femu40_perall2007 if year_bcomp==2007
replace admin_femu40_perall_bcomp=admin_femu40_perall2008 if year_bcomp==2008
replace admin_femu40_perall_bcomp=admin_femu40_perall2009 if year_bcomp==2009
replace admin_femu40_perall_bcomp=admin_femu40_perall2010 if year_bcomp==2010
replace admin_femu40_perall_bcomp=admin_femu40_perall2011 if year_bcomp==2011
replace admin_femu40_perall_bcomp=admin_femu40_perall2012 if year_bcomp==2012
replace admin_femu40_perall_bcomp=admin_femu40_perall2013 if year_bcomp==2013
replace admin_femu40_perall_bcomp=admin_femu40_perall2014 if year_bcomp==2014
replace admin_femu40_perall_bcomp=admin_femu40_perall2015 if year_bcomp==2015

gen all_staff000_bcomp=all_staff_bcomp/1000
gen all_staff000_2006=all_staff2006/1000
gen all_staff000_2005=all_staff2005/1000
gen all_staff000_2004=all_staff2004/1000

*/

********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

/* main tables and figures in text */

/*descriptive stats*/ /* https://www.ssc.wisc.edu/sscc/pubs/stata_tables.htm */

*table 1
estpost tab weeks_full_salrep_ml
esttab using table1.rtf, replace modelwidth(20 15) cell( (b(label(Number of packages)) pct(label(percent) fmt(%9.1f)))) label nomtitle nonumber noobs
*table 2
estpost sum weeks_full_salrep_ml weeksfull_equivalent2 salrep_weeks_overall_ml
esttab using table2.rtf, replace modelwidth(10 15 15 15 15) cell( (count(label(N)) mean(label(Mean) fmt(%9.1f)) sd(label(SD) fmt(%9.1f)) min(label(Minimum) fmt(%9.1f)) max(label(Maximum)))) label nomtitle nonumber noobs
*table 3
estpost sum all_staff000_bcomp fem_pertotal_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 maleprof_pertotal_bcomp femseniormanager_pertotal_bcomp  admin_femu40_perall_bcomp ucu_density_bcomp
esttab using table3.rtf, replace modelwidth(10 15 15 15 15) cell( (count(label(N)) mean(label(Mean) fmt(%9.2f)) sd(label(SD) fmt(%9.2f)) min(label(Minimum) fmt(%9.2f)) max(label(Maximum) fmt(%9.2f)))) label nomtitle nonumber noobs

corr weeks_full_salrep_ml weeksfull_equivalent2 salrep_weeks_overall_ml

/*baseline table 4*/

nbreg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales, robust
est store nb_bc_base
nbreg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales
est store nb_bc_base_alpha

*figure 1
margins, at(raescore_2008=(50(50)250) studentstaff_ratio_bcomp=(2 29)) level(90)
marginsplot, name(figure1, replace) plotopts(msymbol(i) ytitle(weeks of full salary replacement) xtitle(RAE Score 2008) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) graphregion(margin(zero))) recastci(rline) ciopts(lpattern(dash))
graph save figure1, replace 
*figure 2
margins, at(femprof_pertotal_bcomp=(0(0.005)0.04) ac_femu40_perall_bcomp=(0 0.25)  studentstaff_ratio_bcomp=(28) raescore_2008=50) level(90)
marginsplot, name(figure2, replace) plotopts(msymbol(i) ytitle(weeks of full salary replacement) xtitle(previous share of female professors) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) graphregion(margin(zero))) recastci(rline) ciopts(lpattern(dash))
graph save figure2, replace
 
poisson weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales, robust
est store p_bc_base
reg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales, robust
est store r_bc_base

nbreg weeks_full_salrep_ml all_staff000_bcomp fem_pertotal_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales, robust
est store nb_bc_base2

nbreg weeks_full_salrep_ml all_staff000_bcomp fem_pertotal_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml ucu_density_bcomp sc ni wales, robust
est store nb_bc_union

/* peer group */
gnbreg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml newuni_92nonpoly, robust lnalpha(russellgroup goldentriangle)
est store gnb_bc_base

estout1 nb_bc_base_alpha nb_bc_base p_bc_base r_bc_base nb_bc_union gnb_bc_base using table4.txt, b(%9.3f) star(0.1 0.05 0.01) se(%9.3f  par) stats(N r2 r2_p F chi2 p alpha chi2_c) delimiter("") prehead("") posthead("") prefoot("") postfoot("") conslbl(Intercept) varwidth(16) modelwidth(12) style(tab) label replace

/*robustness main model: in footnote, all results carry through if academics at child rearing age is not included into RHS*/
nbreg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales, robust


/* alternative generosity measures: table 5 */

nbreg weeksfull_equivalent2 all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales, robust
est store nb_altdv1
nbreg salrep_weeks_overall_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales, robust
est store nb_altdv2

reg weeksfull_equivalent2 all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales, robust
est store r_altdv1
reg salrep_weeks_overall_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales, robust
est store r_altdv2

nbreg weeksfull_equivalent2 all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml ucu_density_bcomp sc ni wales, robust
est store nb_altdv1_ucu
nbreg salrep_weeks_overall_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml ucu_density_bcomp sc ni wales, robust
est store nb_altdv2_ucu

reg weeksfull_equivalent2 all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml ucu_density_bcomp sc ni wales, robust
est store r_altdv1_ucu
reg salrep_weeks_overall_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml ucu_density_bcomp sc ni wales, robust
est store r_altdv2_ucu

estout1 nb_altdv1 nb_altdv1_ucu nb_altdv2 nb_altdv2_ucu using table5.txt, b(%9.3f) star(0.1 0.05 0.01) se(%9.3f  par) stats(N r2 r2_p F chi2 p alpha chi2_c) delimiter("") prehead("") posthead("") prefoot("") postfoot("") conslbl(Intercept) varwidth(16) modelwidth(12) style(tab) label replace


/* placebo - male profs, ademin senior manager, female staff: table 6 */ 

nbreg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp  ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 maleprof_pertotal_bcomp differentpackages_ml sc ni wales, robust
est store nb_plac1
reg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp  ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 maleprof_pertotal_bcomp differentpackages_ml sc ni wales, robust
nbreg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 maleprof_pertotal_bcomp femseniormanager_pertotal_bcomp differentpackages_ml sc ni wales, robust
est store nb_plac2
reg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 maleprof_pertotal_bcomp femseniormanager_pertotal_bcomp differentpackages_ml sc ni wales, robust
nbreg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 maleprof_pertotal_bcomp femseniormanager_pertotal_bcomp  admin_femu40_perall_bcomp differentpackages_ml sc ni wales, robust
est store nb_plac3
reg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 maleprof_pertotal_bcomp femseniormanager_pertotal_bcomp  admin_femu40_perall_bcomp differentpackages_ml sc ni wales, robust
nbreg weeks_full_salrep_ml all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 maleprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008  maleprof_pertotal2006 differentpackages_ml sc ni wales, robust
est store nb_plac4
nbreg weeks_full_salrep_ml all_staff000_2006 fem_pertotal2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 maleprof_pertotal2006 admin_femu40_perall2006 differentpackages_ml sc ni wales, robust
est store nb_plac5

estout1 nb_plac1 nb_plac2 nb_plac3 using table6.txt, b(%9.3f) star(0.1 0.05 0.01) se(%9.3f  par) stats(N r2 r2_p chi2 p alpha chi2_c) delimiter("") prehead("") posthead("") prefoot("") postfoot("") conslbl(Intercept) varwidth(16) modelwidth(12) style(tab) label replace

********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

/* ONLINE APPENDIX */

/* Appendix B*/

/* generosity by HEI*/

xcontract differentpackages_ml weeks_full_salrep_ml id_inst institution, saving(table_b1, replace)


/* Appendix C*/

/* exclude outliers*/

histogram raescore_2008, percent
graph save figure_c1, replace
hist femprof_pertotal_bcomp, percent
graph save figure_c2, replace
hist ac_femu40_perall_bcomp, percent
graph save figure_c3, replace
nbreg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales  if raescore_2008>99 & raescore_2008<201 & femprof_pertotal_bcomp<0.4 & ac_femu40_perall_bcomp<0.25
margins, at(raescore_2008=(100(10)200) femprof_pertotal_bcomp=(0 0.025)) level(90)
marginsplot, plotopts(msymbol(i) ytitle(weeks of full salary replacement) xtitle(RAE Score 2008) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) graphregion(margin(zero))) recastci(rline) ciopts(lpattern(dash))
graph save figure_c4, replace

nbreg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales  if raescore_2008>99 & raescore_2008<201 & femprof_pertotal_bcomp<0.4 & ac_femu40_perall_bcomp<0.25, robust
est store app_nb_noout
poisson weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales  if raescore_2008>99 & raescore_2008<201 & femprof_pertotal_bcomp<0.4 & ac_femu40_perall_bcomp<0.25, robust
est store app_p_noout
reg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales  if raescore_2008>99 & raescore_2008<201 & femprof_pertotal_bcomp<0.4 & ac_femu40_perall_bcomp<0.25, robust
est store app_r_noout

estout1 app_nb_noout app_p_noout app_r_noout using table_c1.txt, b(%9.3f) star(0.1 0.05 0.01) se(%9.3f  par) stats(N r2 r2_p F chi2 p alpha chi2_c) delimiter("") prehead("") posthead("") prefoot("") postfoot("") conslbl(Intercept) varwidth(16) modelwidth(12) style(tab) label replace

nbreg weeks_full_salrep_ml all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml sc ni wales, robust
est store nb_y6
nbreg weeks_full_salrep_ml all_staff000_2005 acadminfem_ratio2005 femprof_pertotal2005 ac_femu40_perall2005 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2005 raescore_2008 differentpackages_ml sc ni wales, robust
est store nb_y5
nbreg weeks_full_salrep_ml all_staff000_2004 acadminfem_ratio2004 femprof_pertotal2004 ac_femu40_perall2004 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2004 raescore_2008 differentpackages_ml sc ni wales, robust
est store nb_y4

nbreg weeksfull_equivalent2 all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml sc ni wales, robust
est store nb_altdv1_y6
nbreg salrep_weeks_overall_ml all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml sc ni wales, robust
est store nb_altdv2_y6

estout1 nb_y6 nb_y5 nb_y4 nb_altdv1_y6 nb_altdv2_y6 using table_c2.txt, b(%9.3f) star(0.1 0.05 0.01) se(%9.3f  par) stats(N r2 r2_p chi2 p alpha chi2_c) delimiter("") prehead("") posthead("") prefoot("") postfoot("") conslbl(Intercept) varwidth(16) modelwidth(12) style(tab) label replace


/* Appendix D*/

/* Multicollinearity and endogeneity*/

reg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales

/*table D1*/
estat vif 

*corr all_staff000_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13

nbreg weeks_full_salrep_ml all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales, robust
est store nb_inc1
nbreg weeks_full_salrep_ml acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13  studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales, robust
est store nb_inc2
nbreg weeks_full_salrep_ml acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml sc ni wales, robust
est store nb_inc3

estout1 nb_inc1 nb_inc2 nb_inc3 using table_d2.txt, b(%9.3f) star(0.1 0.05 0.01) se(%9.3f  par) stats(N r2 r2_p chi2 p alpha chi2_c) delimiter("") prehead("") posthead("") prefoot("") postfoot("") conslbl(Intercept) varwidth(16) modelwidth(12) style(tab) label replace

reg all_staff000_bcomp totalincome_inmills_13
est store d3_1
reg ratio_staffcosts_perincome_13 totalincome_inmills_13
est store d3_2
reg income_researchgrants_inmills_13 totalincome_inmills_13
est store d3_3
reg raescore_2008 totalincome_inmills_13
est store d3_4

estout1 d3_1 d3_2 d3_3 d3_4 using table_d3.txt, b(%9.3f) star(0.1 0.05 0.01) se(%9.3f  par) stats(N r2) delimiter("") prehead("") posthead("") prefoot("") postfoot("") conslbl(Intercept) varwidth(16) modelwidth(12) style(tab) label replace


/* Appendix E*/

/* Including Spatial Lags*/

reg weeks_full_salrep_ml SL_salrep_russell SL_salrep_goldent SL_salrep_group94 SL_salrep_newuni92p SL_salrep_newuni92np SL_salrep_pgorig SL_salrep_plateglass SL_salrep_red SL_salrep_cath SL_salrep_guildhe SL_salrep_million SL_salrep_ua SL_salrep_ncuk SL_salrep_uniscot all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml, robust
est store r_sl

nbreg weeks_full_salrep_ml SL_salrep_russell SL_salrep_goldent SL_salrep_group94 SL_salrep_newuni92p SL_salrep_newuni92np SL_salrep_pgorig SL_salrep_plateglass SL_salrep_red SL_salrep_cath SL_salrep_guildhe SL_salrep_million SL_salrep_ua SL_salrep_ncuk SL_salrep_uniscot all_staff000_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml, robust
est store nb_sl

estout1 r_sl nb_sl using table_e1.txt, b(%9.3f) star(0.1 0.05 0.01) se(%9.3f  par) stats(N r2 r2_p chi2 p alpha chi2_c) delimiter("") prehead("") posthead("") prefoot("") postfoot("") conslbl(Intercept) varwidth(16) modelwidth(12) style(tab) label replace


/* Appendix F*/

/* Union density, robustness*/

corr ucu_density_bcomp ucu_density2007 ucu_density2013 ucu_density2015 ucu_density2018

nbreg weeks_full_salrep_ml all_staff000_bcomp fem_pertotal_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml ucu_density2007 sc ni wales, robust
est store nb_ud07
nbreg weeks_full_salrep_ml all_staff000_bcomp fem_pertotal_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml ucu_density2013 sc ni wales, robust
est store nb_ud13
nbreg weeks_full_salrep_ml all_staff000_bcomp fem_pertotal_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml ucu_density2015 sc ni wales, robust
est store nb_ud15
nbreg weeks_full_salrep_ml all_staff000_bcomp fem_pertotal_bcomp acadminfem_ratio_bcomp femprof_pertotal_bcomp ac_femu40_perall_bcomp ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio_bcomp raescore_2008 differentpackages_ml ucu_density2018 sc ni wales, robust
est store nb_ud18

estout1 nb_ud07 nb_ud13 nb_ud15 nb_ud18 using table_f1.txt, b(%9.3f) star(0.1 0.05 0.01) se(%9.3f  par) stats(N r2 r2_p chi2 p alpha chi2_c) delimiter("") prehead("") posthead("") prefoot("") postfoot("") conslbl(Intercept) varwidth(16) modelwidth(12) style(tab) label replace




nbreg weeks_full_salrep_ml all_staff000_2006 fem_pertotal2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml sc ni wales, robust

poisson weeks_full_salrep_ml all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml sc ni wales, robust
reg weeks_full_salrep_ml all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml sc ni wales, robust



/* appendix, additional robustness */

/* generalized nbreg, peer group */

gnbreg weeks_full_salrep_ml all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml newuni_92nonpoly, robust lnalpha(russellgroup goldentriangle)

/* alternative measures for generosity of maternity pay */

nbreg salrep_weeks_overall_ml all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml sc ni wales, robust
nbreg weeksfull_equivalent2 all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml sc ni wales, robust
poisson salrep_weeks_overall_ml all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml sc ni wales, robust
poisson weeksfull_equivalent2 all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml sc ni wales, robust
reg salrep_weeks_overall_ml all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml sc ni wales, robust
reg weeksfull_equivalent2 all_staff000_2006 acadminfem_ratio2006 femprof_pertotal2006 ac_femu40_perall2006 ratio_staffcosts_perincome_13 income_researchgrants_inmills_13 totalincome_inmills_13 studentstaff_ratio2006 raescore_2008 differentpackages_ml sc ni wales, robust


/* Revisions */



/* 2. spatial lag models */



/* 3. union denisty */

