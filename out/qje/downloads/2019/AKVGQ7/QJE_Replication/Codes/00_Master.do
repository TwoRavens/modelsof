**These packages are needed
*ssc install unique
*ssc install estout
*ssc install reghdfe


clear all
set more off
set matsize 10000
******************************
*** SET  PREFERENCES ***
******************************
	

***YOU NEED TO SET THE APPROPIATE PATH HERE
	*** Mauricio's desktop
	if "`c(username)'" == "MROMEROLO"  {
		global mipath "C:/Users/mromerolo/Box Sync/01_KiuFunza/QJE_Replication"
		
	}
	
	if "`c(username)'" == "Mauricio"  {
		global mipath "C:/Users/mauricio/Box Sync/01_KiuFunza/QJE_Replication"
		
	}
	
*** Path tree
	global dir_do     "$mipath/Codes"
	global latexcodesfinals "$mipath/Output/tables"
	global graphs      "$mipath/Output/graphs"
	global basein 	"$mipath/Data"
	
	

	
	
*** Globals controls and outcomes

	global AggregateDep_Karthik 	Z_hisabati Z_kiswahili Z_kiingereza  Z_ScoreFocal
	global AggregateDep_int 	Z_hisabati Z_kiswahili Z_kiingereza
	global subjects 	hisabati kiswahili kiingereza ScoreFocal
	
	global treatmentlist TreatmentCG TreatmentCOD TreatmentBoth
	global treatmentlist_int TreatmentCOD TreatmentBoth
	
	

	global schoolcontrol  PTR_T1  SingleShift_T1 IndexDistancia_T1 InfrastructureIndex_T1 IndexFacilities_T1 s108_T1 
	global studentcontrol LagseenUwezoTests LagpreSchoolYN Lagmale LagAge i.LagGrade LagGrade#(c.LagZ_kiswahili##c.LagZ_kiswahili) LagGrade#(c.LagZ_hisabati##c.LagZ_hisabati)  LagGrade#(c.LagZ_kiingereza##c.LagZ_kiingereza)
	global HHcontrol c.HHSize#c.MissingHHSize c.IndexPoverty#c.MissingIndexPoverty c.IndexPoverty c.IndexEngagement#c.MissingIndexEngagement c.IndexEngagement  c.LagExpenditure#c.MissingLagExpenditure c.LagExpenditure  
	
	
*** TABLES AND FIGURES
	do "$dir_do/01_Table1_Balance"
	do "$dir_do/02_Table2_HowGrantIsSpent"
	do "$dir_do/03_Table3_TE_Expenditure" /*This also creates table A2*/
	do "$dir_do/04_Table4_TE_TestScores"
	do "$dir_do/05_Table5_Spillovers"
	do "$dir_do/06_Table6_TextBooks"
	do "$dir_do/07_Table7_Heterogeneity"
	do "$dir_do/08_FigureA1_NonParametric"	
	do "$dir_do/09_TablesA1A11_LeeBounds_HighStakes" /*Both A1 and A11*/
	/*Table A2 is estimated in 03_Table3_TE_Expenditure*/
	do "$dir_do/10_TableA3_GradeRetention"
	do "$dir_do/11_TableA4_PassRateHighStakes"	
	do "$dir_do/12_TableA5_NoControls"	
	do "$dir_do/13_TableA6_SameSchools"	
	do "$dir_do/14_TableA7_HeterogeneityDate"	/*Also creates Figures in Appendix C*/
	do "$dir_do/15_TableA8_WeekFE"
	do "$dir_do/16_TableA9_LowBeforeHigh"
	do "$dir_do/17_TableA10_FixedCohort"	
	/*Table A11 is estimated in 10_TablesA1A11_LeeBounds_HighStakes*/
	do "$dir_do/18_TableA12_DistancePassing"
	do "$dir_do/19_TableA13_TeacherEffort"	
	/*Table A14 is not the result of a statistical procedure*/
	do "$dir_do/20_TableC2_BottomTopCoding"
	do "$dir_do/21_pvalues_CE" /*This p-values are shown in the CE section. They are not part of any table*/

