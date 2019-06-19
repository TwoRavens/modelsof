*This program creates the internal P&S tax-unit comparison.  For the MI-GB2 file use left_truncated_gb2_MI_Method_April_15
* which is also in the PS_comparison folder

*Version 2: Remove group quarters, replace zero incomes with $1
*Version 3: Remove single individuals under age 20, remove HH comparison since not accurate after this removal, add simpleshares matrix

clear
set mem 450m
sysdir set PERSONAL "/rdcprojects/co1/co00524/statacode/"

**********
*FIRST CALCULATE INCOME SHARES USING THE TAX-UNIT DEFINITION
*USES DATA FROM THE LEFT_TRUNCATED_GB2_file


use "/rdcprojects/co1/co00524/data/data_out/int_PS_comparison_working", clear

*Now just calculate percentile statistics
 
global rows = "67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07"

matrix shares = J(10,41,.)
matrix colnames shares = $rows
matrix rownames shares = p90+ p91+ p92+ p93+ p94+ p95+ p96+ p97+ p98+ p99+

forvalues yr = 1968/2008 {
   preserve
      keep if year==`yr'  & fwgt>0 & fwgt<. 
      local i = `yr' - 1967

      replace finc = 1 if finc<1
      
      quietly sumdist finc [aw=fwgt], ngp(100)
      
      tempname Q
      matrix Q = (r(sh91), r(sh92), r(sh93), r(sh94), r(sh95), r(sh96), r(sh97), r(sh98), r(sh99), r(sh100))'
      
      matrix R = J(10,1,.)
      
      matrix R[10,1] = Q[10,1]
      forvalues j = 1/9 {
         local k = 10 - `j'
         local l = 11 - `j' 
         
         matrix R[`k',1] = R[`l',1] + Q[`k',1]
      }
      
      forvalues j = 1/10 {
         matrix shares[`j',`i'] = R[`j',1]
      }
   restore
   noi disp "`yr'"
}

*******************


matrix simpleshares = J(41,3,.)
matrix colnames simpleshares = P90to95 P90to99 P90to100
matrix rownames simpleshares = $rows

forvalues i = 1/41 {
   matrix simpleshares[`i',1] = shares[1,`i'] - shares[6,`i']
   matrix simpleshares[`i',2] = shares[1,`i'] - shares[10,`i']
   matrix simpleshares[`i',3] = shares[1,`i']
 }  


**********
*THEN CALCULATE INCOME SHARES USING THE HOUSEHOLD INCOME DEFINITION
*USES DATA FROM THE LEFT_TRUNCATED_GB2_file


use "/rdcprojects/co1/co00524/data/data_out/temp_int", clear

*Now just calculate percentile statistics
 
global rows = "67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07"

matrix shares_int = J(10,41,.)
matrix colnames shares_int = $rows
matrix rownames shares_int = p90+ p91+ p92+ p93+ p94+ p95+ p96+ p97+ p98+ p99+

forvalues yr = 1968/2008 {
   preserve
      keep if year==`yr'  & pwgt>0 & pwgt<. 
      local i = `yr' - 1967

      replace hinc_reg = 1 if hinc<reg<1
      replace hinc_reg = hinc_reg/(sqrt(hhsize)*10000)
      
      quietly sumdist hinc_reg [aw=pwgt], ngp(100)
      
      tempname Q
      matrix Q = (r(sh91), r(sh92), r(sh93), r(sh94), r(sh95), r(sh96), r(sh97), r(sh98), r(sh99), r(sh100))'
      
      matrix R = J(10,1,.)
      
      matrix R[10,1] = Q[10,1]
      forvalues j = 1/9 {
         local k = 10 - `j'
         local l = 11 - `j' 
         
         matrix R[`k',1] = R[`l',1] + Q[`k',1]
      }
      
      forvalues j = 1/10 {
         matrix shares_int[`j',`i'] = R[`j',1]
      }
   restore
   noi disp "`yr'"
}

*******************

matrix simpleshares_int = J(41,3,.)
matrix colnames simpleshares_int = P90to95 P90to99 P90to100
matrix rownames simpleshares_int = $rows

forvalues i = 1/41 {
   matrix simpleshares_int[`i',1] = shares_int[1,`i'] - shares_int[6,`i']
   matrix simpleshares_int[`i',2] = shares_int[1,`i'] - shares_int[10,`i']
   matrix simpleshares_int[`i',3] = shares_int[1,`i']
 }  

*Shares using the internal unadjusted data for households
matrix list shares_int
matrix list simpleshares_int

*Share using the internal unadjusted data for tax-units
matrix list shares
matrix list simpleshares

*****************

*Now calculate the Gini coefficients using the tax unit definition


capture program drop runPSgini
program define runPSgini
syntax [namelist]    
   quietly {  
      local incvar:  word 1 of `namelist' 
      local matused: word 2 of `namelist' 
   
      tempvar settoone 
      
      * get datasource 
      if "`incvar'"=="finc" {
         use "/rdcprojects/co1/co00524/data/data_out/int_PS_comparison_working", clear
         local wgt = "fwgt"
         local id = "subfamid"
      }
      else if "`incvar'"=="hinc_reg" {
         use "/rdcprojects/co1/co00524/data/data_out/temp_int", clear
         local wgt = "pwgt"
         local id = "h_id"
      }
noi disp "`incvar'"

      matrix `matused' = J(41,1,.)
      matrix rownames `matused' = $rows
      matrix colnames `matused' = Gini

      noi di in gr "Year:" 
      noi di in gr "1---5----5----5----5----5----30"  
      forvalues yr=1968/2008 { 
         preserve 
            local i=`yr'-1967 
            keep if year==`yr' & `wgt'>0 & `wgt'<. 
            
            * set into survey data mode... 
            version 8: svyset [pw=`wgt'], psu(`id') 

            * set the value to one if <=1 
            gen     `settoone' = `incvar' 
            replace `settoone' = 1 if `incvar' < 1 

            if "`incvar'"=="hinc_reg" {
               replace `settoone' = `settoone'/(sqrt(hhsize)*10000)
            }
            
            * get sample sizes  
            count 
             
            * keep only necessary variables  
            quietly ineqdeco `settoone' [aw = `wgt']
            matrix `matused'[`i',1]=r(gini) 
        
         restore     
         noisily display in gr _continue "." 
      } 
   
     
         noisily matrix list `matused', title("Internal Unadjusted Gini for `matused'") 
   }    
end 
* program runreggini 

runPSgini finc taxunitGini
runPSgini hinc_reg hhGini

***************************************************************


 
