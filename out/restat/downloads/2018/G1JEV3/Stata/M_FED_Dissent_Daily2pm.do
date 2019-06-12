/* 1)   the S&P 500 cash index back to 1983 (symbol SP)
2)      futures data for the U.S. 10-year T-note back to 1983 (symbol TY)
3)      futures data for the U.S. 5-year T-note back to 1988 (symbol FV)
4)      futures data for the U.S. 2-year T-note back to 1991 (symbol TU)
5)      volume on E-mini S&P500 futures (ES?)
6)      data for the VIX index back to 2003 (symbol IAP)
7)   	data on the Eurodollar futures contract (symbol is ED). */

set more off
global c_op 1 
global sw_op 3 // size of -sw(1)sw window
global std_op 1 // 0 exc-return first day is -4,   1 reference day is -3
global graph_op 0 // 1 - With Titles,   0 - No Titles
global TBill_rfree "TBill_3M0"  //USA_TB10y_p TBill_3M0 TBill_3M YTM_3M DGS3MO_TBill3m_cmr DTB3_Tbill3m_smr Libor_3m_p USA_TB10y_p
global path0 "D:\Docs2\CM_JM\RESTAT_newcodes\\"
global path1 "$path0\Data_other\\"
global path2 "$path0\TickData\\"
global path3 "$path0\Data_work\\"
global path0T "$path0\tables\\"
global path0T1 "$path0T\\original\\"
global path0T2 "$path0T\\robust\\"
global path0T3 "$path0T\\bootstrap\\"

global path0T_2 "$path0\tables\Oregs\\"
global path0T1_2 "$path0T_2\original\\"
global path0T2_2 "$path0T_2\robust\\"
global path0T3_2 "$path0T_2\bootstrap\\"

global path0G "$path0\graphs\\"
global path_d "$path1\"
global path_g "$path0G\" 
global year_min = 1994 //drop observations before this year  
global Breps = 5000 //50 or 5000
global tick_daily_op = 1 // 0=daily data provided by Reuters, 1=daily data built directly from 13.00 and 15.00 data

do "$path0\\tick_daily_2pm.do"
do "$path0\fed_votes_2pm_sample.do" 
do "$path0\fed_votes_2pm_analysis2_01.do"  
do "$path0\fed_votes_2pm_analysis2_pers.do" 
do "$path0\fed_votes_2pm_analysis2_allW_regs.do" //Table A.2 
do "$path0\fed_votes_2pm_analysis2_Oregs_W3.do"  // Table A.3 
do "$path0\T5YIFR_CAR3_graph.do"
do "$path0\VES_CAR3_graph.do"
do "$path0\SQ_Abs_CAR3_graph.do"
do "$path0\excess_returns_analysis_2pm.do" // -1,0,+1 days // reg_exr_x_ally.xls and qreg_exr_x_ally.xls: first regression gives table A.7
do "$path0\excess_returns_analysis_2pm_Oregs.do"  
do "$path0\excess_returns_analysis_2pm_MoreRegs.do" // -1,0,+1 days // Table A.8: regs 1-3 in reg_exr_x_MoreR.xls/qreg_(..)R 
do "$path0\excess_returns_analysis_2pm_MoreRegs_2days.do" //-1,0 days, Table A.6?: regs 1,5 in reg_exr_x_MoreR2.xls/qreg_(..)R2 //Table 5: OLS-1 and OLS-2 are regs 1 and 5 in reg_exr_x_MoreR3.xls, MQ-2 is reg 5 in qreg_exr_x_MoreR3.xls
do "$path0\excess_returns_analysis_2pm_MoreRegs_2days_factors.do" 
do "$path0\TIPS_analysis.do" // Table A.10, part of A.12
do "$path0\Yields_exr.do" // Table A.12
do "$path0\excess_returns_analysis_2pm_MinutesPre2002.do" 
do "$path0\fed_votes_bloomberg_analysis2_1_ITV.do"  
*do "$path0\sp_daily_graphs.do"
*do "$path0\fed_votes_2pm_analysis2_allW_regsREPO.do" // Results with Repo alternative
clear
