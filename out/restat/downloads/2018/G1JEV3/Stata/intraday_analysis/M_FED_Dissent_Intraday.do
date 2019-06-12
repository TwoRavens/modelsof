/* 1)   the S&P 500 cash index back to 1983 (symbol SP)
2)      futures data for the U.S. 10-year T-note back to 1983 (symbol TY)
3)      futures data for the U.S. 5-year T-note back to 1988 (symbol FV)
4)      futures data for the U.S. 2-year T-note back to 1991 (symbol TU)
5)      volume on E-mini S&P500 futures (ES?)
6)      data for the VIX index back to 2003 (symbol IAP)
7)   	data on the Eurodollar futures contract (symbol is ED). */

set more off
global sw_op 3 // size of -sw(1)sw window
global std_op 1 // 0 exc-return first day is -4,   1 reference day is -3
global graph_op 0 // 1 - With Titles,   0 - No Titles
global TBill_rfree "TBill_3M0"  //USA_TB10y_p TBill_3M0 TBill_3M YTM_3M DGS3MO_TBill3m_cmr DTB3_Tbill3m_smr Libor_3m_p USA_TB10y_p
global path0 "D:\Docs2\CM_JM\RESTAT_newcodes\\"
global path1 "$path0\Data_other\\"
global path2 "$path0\TickData\\"
global path3 "$path0\Data_work\\"
global path0T0 "$path0\tables\\"
global path0T "$path0\tables_intraday\\"
global path0T1 "$path0T\1min\"
global path0T2 "$path0T\5min\"
global path0T1R "$path0T\1minR\"
global path0T2R "$path0T\5minR\"
global path0T3 "$path0T\both\"
global path0T3R "$path0T\bothR\"
global path0T1B "$path0T\1minB\"
global path0T2B "$path0T\5minB\"
global path0T3B "$path0T\bothB\"

global path0T1_2 "$path0T1\Oregs\\"
global path0T2_2 "$path0T2\Oregs\\"
global path0T3_2 "$path0T3\Oregs\\"
global path0T1R_2 "$path0T1R\Oregs\\"
global path0T2R_2 "$path0T2R\Oregs\\"
global path0T3R_2 "$path0T3R\Oregs\\"

global path0G "$path0\graphs\\"
global path_d "$path1\"
global path_g "$path0G\"  /* */
global Breps = 5000 //50 or 5000
global Lyear = 2018 //2015 2016 

do "$path0\\tick_5min_events.do" 
do "$path0\\tick_1min_events.do"
do "$path0\\previous_day_data.do"
do "$path0\\previous_day_data_Minutes.do"
do "$path0\\intraday_windows_regs.do" 
do "$path0\\intraday_spread_vol_tick_regs.do"   
do "$path0\\intraday_windows_MoreRegs.do"  
do "$path0\\intraday_windows_Minutes_regs.do"
do "$path0\\intraday_summary.do" 
do "$path0\\votes_summary.do" 
do "$path0\\tick_1min_events90_2002.do"
do "$path0\\intraday_windows_regs90.do"  
do "$path0\\regressions.do" //Additional analysis and result checking for Table 4
clear
