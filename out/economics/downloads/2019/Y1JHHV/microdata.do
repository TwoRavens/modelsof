

use "C:\Users\Administrator\Desktop\Microdata.dta", clear
tab year,missing

xtset Firm year 

 ***********************Table 1******************* 
 sum income revenue profit
 sum salestax salesfee tax paytax wage
 sum managemcosts laborprofitratio capitalprofitratio
 sum newproduct newproductrate exportsize
sum size Age labor debt Right subsidy

 
 ***********************Table 9******************* 
 
xtreg income  pilot_time  size Age labor debt Right subsidy  i.year   ,fe     
est store a_1
xtreg revenue pilot_time  size Age labor debt Right subsidy i.year   ,fe    
est store a_2
xtreg profit pilot_time  size Age labor debt Right subsidy i.year   ,fe    
est store a_3
xtreg income  pilot_time  size Age labor debt Right subsidy i.year if year>2005  ,fe     
est store a_4
xtreg revenue pilot_time  size Age labor debt Right subsidy i.year if year>2005  ,fe    
est store a_5
xtreg profit  pilot_time size Age labor debt Right subsidy i.year if year>2005  ,fe    
est store a_6


 est table a_*,   b(%6.3f)  star( 0.1 0.05  0.01)  /*
	*/stats(N ll F r2)
 
 
 
 
 
 ***********************Table 10******************* 
 
xtreg salestax pilot_time size Age labor debt Right subsidy i.year    ,fe    
est store c_1
xtreg salesfee pilot_time  size Age labor debt Right subsidy i.year   ,fe    
est store c_2
xtreg tax  pilot_time size Age labor debt Right subsidy i.year   ,fe    
est store c_3
xtreg paytax pilot_time  size Age labor debt Right subsidy i.year   ,fe    
est store c_4
xtreg wage pilot_time  size Age labor debt Right subsidy i.year   ,fe    
est store c_5

 est table c_*,   b(%6.3f)  star( 0.1 0.05  0.01)  /*
	*/stats(N ll F r2)
 
 
 
***********************Table 12******************* 
 
 xtreg managemcosts  pilot_time  i.year    ,fe     
est store y_1
xtreg managemcosts pilot_time  size Age labor debt Right subsidy i.year    ,fe    
est store y_2
xtreg laborprofitratio pilot_time  i.year   ,fe     
est store y_3
xtreg laborprofitratio pilot_time  size Age labor debt Right subsidy i.year   ,fe    
est store y_4
xtreg capitalprofitratio pilot_time  i.year   ,fe     
est store y_5
xtreg capitalprofitratio pilot_time  size Age labor debt Right subsidy i.year   ,fe    
est store y_6

 est table y_*,   b(%6.3f)  star( 0.1 0.05  0.01)  /*
	*/stats(N ll F r2)
 
 
 
 ***********************Table 13******************* 
 
xtreg  newproduct pilot_time  size Age labor debt Right subsidy i.year   ,fe     
est store x_1
xtreg newproductrate pilot_time  size Age labor debt Right subsidy i.year    ,fe    
est store x_2
xtreg  exportsize pilot_time size Age labor debt Right subsidy i.year    ,fe    
est store x_3
xtreg  newproduct  pilot_time  size Age labor debt Right subsidy i.year if year>2005  ,fe     
est store x_4
xtreg newproductrate pilot_time size Age labor debt Right subsidy i.year if year>2005  ,fe    
est store x_5
xtreg  exportsize pilot_time size Age labor debt Right subsidy i.year if year>2005  ,fe    
est store x_6


 est table x_*,   b(%6.3f)  star( 0.1 0.05  0.01)  /*
	*/stats(N ll F r2)
 
   
 
 