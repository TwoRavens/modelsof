***********************************************************************
**This program organizes the results obtained obtained using 
**“Program – ACS – Bootstrap – PUMA”, “Program – ACS – Bootstrap – State”, 
**“Program – ACS – OLS robust – PUMA” and “Program – ACS – OLS robust – State”
** to generate Table3. 
*****************************************************************************

 

clear *

cd "XXXX define path to folders XXXX/Results"

append using "ACS_OLS_robust_State_employed.dta"
append using "ACS_OLS_robust_State_l_wage.dta"
append using "ACS_OLS_robust_PUMA_employed.dta"
append using "ACS_OLS_robust_PUMA_l_wage.dta"


append using "ACS_Bootstrap_PUMA_l_wage_5000.dta"
append using "ACS_Bootstrap_PUMA_employed_5000.dta"
append using "ACS_Bootstrap_State_employed_5000.dta"
append using "ACS_Bootstrap_State_l_wage_5000.dta"


********************************************************
prog define Store, rclass
args G Y row
{


cap reg reject_OLS if Group=="`G'" & Y=="`Y'", robust cluster(id)
cap mat R[`row',1]=_b[_cons]
cap mat R[`row'+1,1]=_se[_cons]

cap reg reject_OLS above  if Group=="`G'" & Y=="`Y'", robust  cluster(id)
cap mat R[`row',2]=_b[above]
cap mat R[`row'+1,2]=_se[above]
*/

reg reject_without if Group=="`G'" & Y=="`Y'", robust cluster(id)
mat R[`row',4]=_b[_cons]
mat R[`row'+1,4]=_se[_cons]

reg reject_without above  if Group=="`G'" & Y=="`Y'", robust  cluster(id)
mat R[`row',5]=_b[above]
mat R[`row'+1,5]=_se[above]



reg reject_FP if Group=="`G'" & Y=="`Y'", robust  cluster(id)
mat R[`row',7]=_b[_cons]
mat R[`row'+1,7]=_se[_cons]

reg reject_FP above if Group=="`G'" & Y=="`Y'", robust  cluster(id)
mat R[`row',8]=_b[above]
mat R[`row'+1,8]=_se[above]




}
end

************************************


drop above below
gen above=M_bin2==2

summ re*
set more off

mat R=J(20,8,.)


cap Store "PUMA" "employed" 1

cap Store "PUMA" "l_wage" 4

cap Store "State" "employed" 8

cap Store "State" "l_wage" 11

mat li R



