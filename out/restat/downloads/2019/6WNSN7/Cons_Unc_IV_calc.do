*set trace on
         
global l3 ${treat} ${l2}         
local nl3: word count ${l3} _cons         
assert `nl3' == ${nc}         

*Saving matrix of regression results as a text file            
matrix A_sp${k}_t${tv}_o${on}=J(${nc${nsp}}+2+${nb}+${naddsc}+1,${ncol}+1,.)            
         
*Putting in the coefficients and std errors of the estimation        
local nn = ${nc${nsp}}+2      
forvalues m=1/`nn' {         

      if `m'<=${nc}-1 {      
         local l=`m'      
      }      
      else if `m'==`nn' {      
         local l=${nc}      
      }      
         
      if (`m'<=${nc}-1 | `m'==`nn') {      
         matrix A_sp${k}_t${tv}_o${on}[`m',1] = olco[1,`l']         
         matrix A_sp${k}_t${tv}_o${on}[`m',2] = sqrt(olvar[`l',`l'])         
         matrix A_sp${k}_t${tv}_o${on}[`m',3] = ///      
            A_sp${k}_t${tv}_o${on}[`m',1]/A_sp${k}_t${tv}_o${on}[`m',2]         
         matrix A_sp${k}_t${tv}_o${on}[`m',4] = ///      
            2*ttail(nobs - ${nc},abs(A_sp${k}_t${tv}_o${on}[`m',3]))         
         matrix A_sp${k}_t${tv}_o${on}[`m',5] = ///      
            A_sp${k}_t${tv}_o${on}[`m',1] - invttail(nobs - ${nc},sigl/2)*A_sp${k}_t${tv}_o${on}[`m',2]         
         matrix A_sp${k}_t${tv}_o${on}[`m',6] = ///      
            A_sp${k}_t${tv}_o${on}[`m',1] + invttail(nobs - ${nc},sigl/2)*A_sp${k}_t${tv}_o${on}[`m',2]         
      }      
}         

*Adding various additional estimates      
forvalues ad=1/$naddsc {      
   local adv: word `ad' of ${addsc}      
   matrix A_sp${k}_t${tv}_o${on}[${nc${nsp}}+2+${nb}+`ad',1]=`adv'        
}      
*Labels of matrix of regression output   
*Column labels       
local cnn ""         
foreach nm in $col {         
   local cnn `cnn' `nm'_${mth}_sp${k}         
}         
         
matrix colnames A_sp${k}_t${tv}_o${on} = `cnn' blank             
         
*Row labels         
local bl 
forvalues bbl=1/$nb {         
   local bl `bl' blank         
}

local rn ${treat} ${spf${nsp}} _cons `bl' ${addsc}
local rn2 ""
foreach var in `rn' {
   local rn2 `rn2' ${ol}_`var'
}
matrix rownames A_sp${k}_t${tv}_o${on} = `rn2' blank         
         

