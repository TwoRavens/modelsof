*********************************************************
**Use the results obtained by running "Run_simulation" to 
**generate Table 1.
*********************************************************
 
 
cd "XXXX define path to folders XXXX/MC"


clear *
set more off
set mem 2000m


gen Round=.
forvalues R = 1(1)200 {

foreach B in 500 {
foreach N in 25 100       {

	foreach a_b in  "50_200" { 

		foreach c in 0.01  0.1 0.2   {
		
			 cap append using Results/`N'_`a_b'_`c'_0_Round`R'.dta
			 
		}
	}	
}
}
}

tab Round N 


gen obs=1
collapse (mean) reject* (sum) obs, by(N a b c M_bin10) 



********************************************************
prog define Store, rclass
args N a b c sig row
{

reg reject_OLS if N==`N' & a==`a' & b==`b' & inrange(c,`c'-0.0001,`c'+0.0001), robust
mat R[`row',1]=_b[_cons]

predict residual  if N==`N' & a==`a' & b==`b' & inrange(c,`c'-0.0001,`c'+0.0001), residual
replace residual=-residual if residual<0 & N==`N' & a==`a' & b==`b' & inrange(c,`c'-0.0001,`c'+0.0001)
summ residual
mat R[`row',2]=r(mean)
drop residual





reg reject_without_5 if N==`N' & a==`a' & b==`b' & inrange(c,`c'-0.0001,`c'+0.0001), robust
mat R[`row',10]=_b[_cons]

predict residual  if N==`N' & a==`a' & b==`b' & inrange(c,`c'-0.0001,`c'+0.0001), residual
replace residual=-residual if residual<0 & N==`N' & a==`a' & b==`b' & inrange(c,`c'-0.0001,`c'+0.0001)
summ residual
mat R[`row',11]=r(mean)
drop residual


reg reject_FP_5 if N==`N' & a==`a' & b==`b' & inrange(c,`c'-0.0001,`c'+0.0001), robust
mat R[`row',13]=_b[_cons]

predict residual  if N==`N' & a==`a' & b==`b' & inrange(c,`c'-0.0001,`c'+0.0001), residual
replace residual=-residual if residual<0 & N==`N' & a==`a' & b==`b' & inrange(c,`c'-0.0001,`c'+0.0001)
summ residual
mat R[`row',14]=r(mean)
drop residual


}
end

************************************

summ re*
set more off


mat R=J(20,17,.)


local N=100
local sig=5

cap Store `N' 50 200  0.01 `sig' 1

cap Store `N' 50 200  0.1 `sig' 3

cap Store `N' 50 200  0.2 `sig' 5



local N=25
local sig=5

cap Store `N' 50 200  0.01 `sig' 8

cap Store `N' 50 200  0.1 `sig' 10

cap Store `N' 50 200  0.2 `sig' 12


mat li R









