set more off
global sw_op 3 // size of -sw(1)sw window
global std_op 1 // 0 exc-return first day is -4,   1 reference day is -3
global TBill_rfree "TBill_3M0"  //USA_TB10y_p TBill_3M0 TBill_3M YTM_3M DGS3MO_TBill3m_cmr DTB3_Tbill3m_smr Libor_3m_p USA_TB10y_p
global pathF "D:\Docs2\CM_JM\RESTAT_newcodes\new_data\\"
global pathF2 "D:\Docs2\CM_JM\RESTAT_newcodes\new_data\fed_votes_data\\"
global pathF4 "D:\Docs2\CM_JM\RESTAT_newcodes\new_data\yields\\"
global path0 "D:\Docs2\CM_JM\RESTAT_newcodes\\"
global path1 "$path0\Data_other\\"
global path3 "$path0\Data_work\\"

// This work studies the impact of Dissent (meaning if one or more individuals disagree with the majority)
// format 1993-2013 vote data: final result is data file FED_votes93_13f.dta
do "$pathF\fed_votes_format90.do" 
do "$pathF\fed_votes_format.do" 
do "$pathF\fed_dissent_format.do" // format 1993-2013 dissent data: final results are data files FED_dissent_date.dta (dates only), 
do "$pathF\fed_dissent_format_pers.do" // FED_dissent_date_governors.dta (dates and governors dissent data), FED_dissent_governors.dta (governors only)
do "$pathF\fed_surprise.do" // Calculates Kuttner-FED surprise series 

// format bloomberg financial series data: final result is data file bloomberg2.dta 
do "$pathF\bloomberg_format0.do"  //Bloomberg data
do "$pathF\yields_format.do"   // files yields_fed2.xlsx, DTB3.xls, DGS3MO.xls, USATB.dta 
do "$pathF\fed_votes_bloomberg_sample.do" // "FED_dissent_6dayW.dta": Join dissent votes and Bloomberg Financial series around window of votes 

do "$pathF\\GSS2005_factors.do" // Factor data

global tick_daily_op = 1 // 0=daily data provided by Reuters, 1=daily data built directly from 13.00 and 15.00 data
do "$pathF\\serial_dissent_vars.do"
do "$pathF\\fed_pastdissent_members_date.do"
do "$pathF\\FOMC_XVars.do"
clear
