******CODES for generating results reported in "Do smoking bans always hurt gaming industry? Differentiated impacts on the market value of casino firms in Macao (China)"
***AUTHOR:  Jing Hua Zhang
***Email:   jhuzhang@must.edu.mo
***Macao University of Science and Technology
***Macao, China
***2015/05/18
 
 
use "C:\Users\Administrator\Dropbox\1-asmokingban\1-EconomicsOpenAccess\dataset\smokingban_submission2016",clear
    	   
	cd D:\smokingban\output20160311
	
  
                ****Part I  test abnormal returns ( results in TABLE 4) 
				
 **** 1.  Gen test windows.
   *1.1 2011 partial ban
	gen d20110215=0
	replace d20110215=1 if date2== 18673
 
 
   *1.2 2014 Macao gov. accept proposal of total ban
        gen d20140319=0
	replace d20140319=1 if date2== 19801
       
   *1.3  January 29, 2015, A full smoking ban proposal was announced 
        gen d20150129=0
	replace d20150129=1 if date2== 20117
   
 	 save,replace



*++++++++++++++++++++++++++++++++++++++++++++
**2. test abnoarmal return on   smoking ban *
  **genearate results in "Table 4 The Daily abnormal returns during Macao smoking ban events"
**-------------------------------------------


    *2.1 1st partial ban (before 2011/02/28), BOOTSTRAP, 
      *test period is from January 1st, 2010 to February 15th, 2011
  foreach r in   PIPE_r SJMH_r SNDC_r WYNN_r   {

bootstrap, reps(1000): reg `r' hangsengp_r hangsengp_rl  d20110215  if date2<18686
outreg2 using final20160311, excel ctitle(`r' )  
}


 
 
 * 2.2  test Mass market ban (  Mar. 19, 2014)
   *testing period 2010.01.01~ 2014.03.20
   
     foreach r in  {  PIPE_r SJMH_r SNDC_r WYNN_r  MCHL_r

bootstrap, reps(1000): reg `r' hangsengp_r hangsengp_rl   d20140319 if date2<19802 
outreg2 using final201610311, excel ctitle(`r' )  
}



 * 2.3  test Total ban (  Jan. 29, 2015)
   *January 1st, 2012 (date=18994) to January 29th, 2015 
  
     foreach r in  {  PIPE_r SJMH_r SNDC_r WYNN_r  MCHL_r
bootstrap, reps(1000): reg `r' hangsengp_r hangsengp_rl   d20150130 if date2>18994 
outreg2 using final201610311, excel ctitle(`r' )  
}

       *****TEST Melco international on Nasdaq seperately
 	 
 use "D:\smokingban\2015\melco2015.dta",clear
 
    *generate event dummies ( only two events)
   gen d20140319=0
	replace d20140319=1 if date2==19801
	
   gen d20150129=0
	replace d20150129=1 if date2== 20117
	
	*generate rate of return
		foreach i in    KMCELP NASDAQ{
gen `i'l=`i'[_n-1]
gen `i'_r=( `i'-`i'l)/ `i'l
}
 * gen NASDAQ lagged index
gen  NASDAQ_rlag=  NASDAQ_r[_n-1]
save,replace

   ***  *NOTE: generate regression results of MELCO stock in Table 4 

bootstrap, reps(1000): reg   KMCELP_r NASDAQ_r NASDAQ_rlag   d20140319  if date2<19802
outreg2 using meclo2015,  excel ctitle( mcel ) 

reg   KMCELP_r NASDAQ_r NASDAQ_rlag    d20150129  
bootstrap, reps(1000): reg   KMCELP_r NASDAQ_r NASDAQ_rlag  d20150129   if if date2>18994 
outreg2 using meclo2015,  excel ctitle( mcel ) 




					********PART  II  ****** *
					*________________________*
				
   ****NOTE: Generate the results in Table 6. Regressions on Abnormal Returns (OLS)
 
use "C:\....\1-asmokingban\1-EconomicsOpenAccess\resultreg20150227.dta" 
 
	cd D:\smokingban
**1)using the sub-smaple (the stock market may make stronger reactions to the first two bans than to the full ban later.\
   
 
 	local output  ARreg0304bs
	foreach v in  poorairTable gaming_ratio FDI {
 
	bootstrap, reps(3000):  reg AR `v' if event3==0 
  outreg2 using `output', excel bdec(3)
  }
 

 ****2) using the full sample (abnormal returns from all three sudden announcemenet of the smoking bans.)	

	local output  ARreg0304bs
	foreach v in  poorairTable gaming_ratio FDI {
	
	bootstrap, reps(3000):  reg AR `v' 
  outreg2 using `output', excel bdec(3)
  
	  }
	  
	

 