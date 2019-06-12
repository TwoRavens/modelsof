********************************************************************************
**Using the results produced by the programs "Program-CPS-aggregate.do" and
** "Program-CPS-OLS.do", this code generates the results at Table 4.
******************************************************************************



clear *

cap cd "XXXX define path to folders XXXX/CPS/"

foreach x in 1 3 5 7 {
append using "Results/CPS_OLS_employed_`x'.dta"
append using "Results/CPS_OLS_l_wage_`x'.dta"

append using "Results/CPS_Bootstrap_employed_`x'_5000.dta"
append using "Results/CPS_Bootstrap_l_wage_`x'_5000.dta"
}

drop above below

********************************************************
prog define Store, rclass
args Y Range row
{

cap reg reject_OLS if Range==`Range' & Y=="`Y'", robust cluster(S)
cap mat R[`row',1]=_b[_cons]
cap mat R[`row'+1,1]=_se[_cons]

cap reg reject_OLS above  if Range==`Range' & Y=="`Y'", robust cluster(S) 
cap mat R[`row',2]=_b[above]
cap mat R[`row'+1,2]=_se[above]


reg reject_without if Range==`Range' & Y=="`Y'", robust cluster(S)
mat R[`row',4]=_b[_cons]
mat R[`row'+1,4]=_se[_cons]

reg reject_without above  if Range==`Range' & Y=="`Y'", robust cluster(S) 
mat R[`row',5]=_b[above]
mat R[`row'+1,5]=_se[above]



reg reject_FP if Range==`Range' & Y=="`Y'", robust cluster(S) 
mat R[`row',7]=_b[_cons]
mat R[`row'+1,7]=_se[_cons]

reg reject_FP above if Range==`Range' & Y=="`Y'", robust cluster(S) 
mat R[`row',8]=_b[above]
mat R[`row'+1,8]=_se[above]




}
end

************************************


gen above=M_bin2==2

summ re*
set more off

mat R=J(28,8,.)


cap Store "employed" 1 1

cap Store  "l_wage" 1 4

cap Store "employed" 3 8

cap Store  "l_wage" 3 11

cap Store "employed" 5 15

cap Store  "l_wage" 5 18

cap Store "employed" 7 22

cap Store  "l_wage" 7 25



mat li R



