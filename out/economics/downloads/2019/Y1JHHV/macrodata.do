use "C:\Users\Administrator\Desktop\Macrodata.dta", clear


tsset num year 
xtdescribe
 
  ***********************Table 1*******************
  
sum gdp pergdp firmnumber0 firmnumber1 pilot investment labor government Open industry Education Save 
	

 ***********************Table 2*******************	   
xtreg gdp pilot_time  i.year,fe 
est store A_1
xtreg gdp pilot_time  investment labor government Open   industry Education Save  i.year,fe  
est store A_2
xtreg pergdp pilot_time  i.year,fe 
est store A_3
xtreg pergdp pilot_time investment labor government Open   industry Education Save  i.year,fe 
est store A_4	
xtreg  gdp  h10-h13 i.year,fe 
est store A_5
xtreg  gdp h10-h13  investment labor government Open   industry Education Save i.year ,fe
est store A_6	
xtreg  pergdp h10-h13 i.year,fe 
est store A_7
xtreg  pergdp h10-h13 investment labor government  Open  industry Education Save i.year,fe 
est store A_8

est table A_*,   b(%6.3f)  star( 0.1 0.05  0.01)  /*
	*/stats(N ll F r2)

 


 

 ***********************Table 3*******************
 
xtreg  gdp pilot_time h2-h8   i.year,fe 
est store C_1
xtreg  gdp pilot_time h2-h8 investment labor government Open   industry Education Save i.year,fe
est store C_2	
xtreg  gdp pilot_time h2-h8 investment labor government Open  industry Education Save i.year if east!=1,fe
est store C_3
xtreg  pergdp pilot_time h2-h8 i.year,fe 
est store C_4
xtreg  pergdp pilot_time h2-h8 investment labor government Open industry Education Save i.year,fe 
est store C_5
xtreg  pergdp pilot_time h2-h8 investment labor government Open  industry Education Save i.year if east!=1,fe 
est store C_6

est table C_*,   b(%6.3f)  star( 0.1 0.05  0.01)  /*
	*/stats(N ll F r2)	
	

	
	
 ******************Figure 2
 xtreg  gdp h2-h13  investment labor government Open   industry Education Save i.year ,fe
est store reg	
 
 coefplot reg, keep(h*) vertical recast(connect) yline(0) xline(9, lp(dash))
	
 ******************Figure 3
 
 xtreg  pergdp h2-h13 investment labor government  Open  industry Education Save i.year,fe 
est store reg1

 coefplot reg1, keep(h*) vertical recast(connect) yline(0) xline(9, lp(dash))

 
 ***********************Table 4*******************  
 ************************PSM-DID
 

psmatch2 pilot investment labor government Open  industry  Education Save ,out(gdp) ai(1) neighbor(1) ate
psmatch2 pilot investment labor government Open  industry Education Save ,out(pergdp) ai(1) neighbor(1) ate


  
 ***********************Table 5******************* 
xtreg gdp pilot_time  i.year if east==0 ,fe 
est store G_1
xtreg gdp pilot_time  investment labor government Open  industry  Education Save i.year if east==0,fe  
est store G_2
xtreg pergdp pilot_time  i.year if east==0,fe 
est store G_3
xtreg pergdp pilot_time investment labor government Open  industry  Education Save  i.year if east==0,fe 
est store G_4
xtreg gdp pilot_time  i.year if west==0,fe 
est store G_5
xtreg gdp pilot_time  investment labor government Open  industry  Education Save i.year if west==0,fe  
est store G_6
xtreg pergdp pilot_time  i.year if west==0,fe 
est store G_7
xtreg pergdp pilot_time investment labor government Open  industry  Education Save  i.year if west==0,fe 
est store G_8

 est table G_*,   b(%6.3f)  star( 0.1 0.05  0.01)  /*
	*/stats(N ll F r2_a)

 
 
 ***********************Table 6******************* 
 
xtreg gdp random1  i.year,fe 
est store D_1
xtreg gdp random1 investment labor government Open   industry Education Save  i.year,fe  
est store D_2
xtreg pergdp random1  i.year,fe 
est store D_3
xtreg pergdp random1 investment labor government Open   industry Education Save  i.year,fe  
est store D_4
xtreg gdp random2  i.year,fe 
est store D_5
xtreg gdp random2 investment labor government Open   industry Education Save  i.year,fe  
est store D_6
xtreg pergdp random2  i.year,fe 
est store D_7
xtreg pergdp random2 investment labor government Open   industry Education Save  i.year,fe 
est store D_8
 
 est table D_*,   b(%6.3f)  star( 0.1 0.05  0.01)  /*
	*/stats(N ll F r2_a)  
 
 
	


 ***********************Table 7*******************	  
 
xtreg gdp pilot_time  investment labor government  Open industry Education Save  i.year if year>2007&year<2012,fe  
est store E_1
xtreg pergdp pilot_time investment labor government  Open industry Education Save  i.year if year>2007&year<2012,fe 
est store E_2
xtreg gdp pilot_time  investment labor government  Open industry Education Save  i.year if year>2006&year<2013,fe  
est store E_3
xtreg pergdp pilot_time investment labor government Open  industry Education Save  i.year if year>2006&year<2013,fe 
est store E_4
xtreg gdp pilot_time  investment labor government Open  industry Education Save  i.year if year>2005&year<2014,fe  
est store E_5
xtreg pergdp pilot_time investment labor government Open  industry Education Save  i.year if year>2005&year<2014,fe 
est store E_6

 est table E_*,   b(%6.3f)  star( 0.1 0.05  0.01)  /*
	*/stats(N ll F r2_a)  
	

	  
 

 ***********************Table 8*******************
 
xtreg  gdp pilot_time K*  i.year,fe 
est store F_1
xtreg  gdp pilot_time K* investment labor government Open industry Education Save i.year,fe 
est store F_2	
xtreg  pergdp pilot_time K* i.year,fe 
est store F_3
xtreg  pergdp pilot_time K*  investment labor government Open industry  Education Save i.year,fe  
est store F_4
xtreg  gdp pilot_time M* investment labor government Open industry Education Save i.year,fe 
est store F_5	
xtreg  gdp pilot_time M* N* investment labor government Open industry Education Save i.year,fe 
est store F_6
xtreg  pergdp pilot_time M*  investment labor government Open industry  Education Save i.year,fe  
est store F_7
xtreg  pergdp pilot_time M* N* investment labor government Open industry  Education Save i.year,fe  
est store F_8		
	
	
est table F_*,   b(%6.3f)  star( 0.1 0.05  0.01)  /*
	*/stats(N ll F r2)	
	

 
 ***********************Table 11*******************
 
 
xtreg firmnumber0 pilot_time  i.year,fe 
est store H_1
xtreg firmnumber0 pilot_time  investment labor government    i.year,fe  
est store H_2
xtreg firmnumber0 pilot_time  investment labor government Open  industry Education Save  i.year,fe  
est store H_3
xtreg firmnumber1 pilot_time  i.year,fe 
est store H_4
xtreg firmnumber1 pilot_time investment labor government    i.year,fe 
est store H_5
xtreg firmnumber1 pilot_time investment labor government Open  industry Education Save  i.year,fe 
est store H_6

 est table H_*,   b(%6.3f)  star( 0.1 0.05  0.01)  /*
	*/stats(N ll F r2_a)  

   