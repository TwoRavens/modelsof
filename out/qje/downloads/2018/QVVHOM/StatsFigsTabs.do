
/* globals for file paths */
global PostEst_Output <filepath>
global TableStats_Output <filepath>

/*************************************************************************/
/* Joint distribution employment counts by worker and firm fixed effects */
/*************************************************************************/
insheet using ${PostEst_Output}\S100P_JointDist_1_0_DEFLATE_520hr_Male.csv, comma clear
/* industry and firm size restrictions */
keep if ((ind>=1 & ind<=9) | ind==-9) & (fsize_g>=2 & fsize_g<=5)
/* collapse to firm effect and worker effect deciles */
collapse (rawsum) n_wkryears (mean) m_y m_pe m_fe m_xb m_r m_age m_njobs m_fsize ///
		[aw=n_wkryears], by(interval pe_dec fe_dec)
format n_wkryears %12.0f
/* export */
outsheet using ${TableStats_Output}\JointFEDist.txt, comma replace

/*************************************************************************/
/* Employment counts by worker fixed effects and firm size distribution  */
/*************************************************************************/
insheet using ${PostEst_Output}\S100P_JointDist_1_0_DEFLATE_520hr_Male.csv, comma clear
/* industry restrictions */
keep if ((ind>=1 & ind<=9) | ind==-9)
/* collapse to worker effect decile and firm size group levels */
collapse (rawsum) n_wkryears (mean) m_y m_pe m_fe m_xb m_r m_age m_njobs m_fsize ///
		[aw=n_wkryears], by(interval pe_dec fsize_g)
format n_wkryears %12.0f
/* export */
outsheet using ${TableStats_Output}\WFE_FSize_Dist.txt, comma replace

/*************************************************************************/
/* Employment counts by firm fixed effects and firm size distribution    */
/*************************************************************************/
insheet using ${PostEst_Output}\S100P_JointDist_1_0_DEFLATE_520hr_Male.csv, comma clear
/* industry restrictions */
keep if ((ind>=1 & ind<=9) | ind==-9)
/* collapse to firm effect decile and firm size group levels */
collapse (rawsum) n_wkryears (mean) m_y m_pe m_fe m_xb m_r m_age m_njobs m_fsize ///
		[aw=n_wkryears], by(interval fe_dec fsize_g)
format n_wkryears %12.0f
/* export */
outsheet using ${TableStats_Output}\FFE_FSize_Dist.txt, comma replace

/*************************************************************************/
/* BT/WI Firm AKM Decomp by firm size group                              */
/*************************************************************************/
insheet using ${PostEst_Output}\S100P_BT_WI_Firm_Mmnts_1_0_DEFLATE_520hr_Male.csv, comma clear
/* industry restrictions */
keep if ((ind>=1 & ind<=9) | ind==-9)
/* collapse to firm size group level */
collapse (rawsum) n_wrkyear (mean) m* [aw=n_wrkyear], by(interval fsize_g)
format n_wrkyear %12.0f
/* export */
outsheet using ${TableStats_Output}\BTWI_Decomp_byFSize.txt, comma replace

/*************************************************************************/
/* BT/WI Firm AKM Decomp by industry                                     */
/*************************************************************************/
insheet using ${PostEst_Output}\S100P_BT_WI_Firm_Mmnts_1_0_DEFLATE_520hr_Male.csv, comma clear
/* firm size group restrictions */
keep if (fsize_g>=2 & fsize_g<=5)
cap drop if ind>11
/* collapse to industry level */
collapse (rawsum) n_wrkyear (mean) m* [aw=n_wrkyear], by(interval ind)
format n_wrkyear %12.0f
/* export */
outsheet using ${TableStats_Output}\BTWI_Decomp_byInd.txt, comma replace

