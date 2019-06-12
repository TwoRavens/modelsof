
******************************************************************
***FIGURE 3
******************************************************************

capture log close
clear 
cd "C:\Users\jenny\Desktop\Replication Office-selling\Main"

use coef_table2.dta, clear

sort parmid

eclplot coef lb ub parmid, eplottype(connected) 
