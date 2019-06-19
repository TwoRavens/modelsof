/*  This program (Table3) was run in STATA IC 12.
    This program does the analysis reported in
	Table 3 in the text - robustness checks.
		
	The cd line below should be changed to run the code.
*/
	
	
cd ""	


/*  Table 3  Column 1  Additional Instruments  */
	clear
	use Table3_1.dta
	xtset state year
	
	xi: newey2 vol (share=birth20 birth30 birth40 birth50) growth i.state i.year, lag(2) i(state) t(year)
	/*  This next regression is identical except it calculates standard errors clustered by state  */
	xi: ivregress 2sls vol (share=birth20 birth30 birth40 birth50) growth i.state i.year, robust cluster(state)
	
	/*  Note, I incorrectly reported the sample size as 1200 in Table 3.  The correct number should
		be 1152 because the 24 observations from both Texas and Hawaii are dropped from this sample.  */


/*  Table 3  Column 2  5-year window */
	clear
	use Table3_2.dta

	xtset state year
	xi: newey2         vol (share=birth) growth i.state i.year, lag(2) i(state) t(year)
	xi: ivregress 2sls vol (share=birth) growth i.state i.year, robust cluster(state)
	xi: newey2 share birth       growth i.state i.year, lag(2) i(state) t(year)  /* 1st stage */


/*  Table 3  Column 3  5-year window  Omit post-1997 data */
	clear
	use Table3_3.dta
	xtset state year

	xi: newey2 vol (share=birth) growth i.state i.year, lag(2) i(state) t(year)
	xi: newey2 share birth       growth i.state i.year, lag(2) i(state) t(year)  /* 1st stage */


/*  Table 3  Column 4  5-year interval */
	/* 	Note, for columns 4 and 5, the year variable
		keeps track of the interval rather than the
		actual year. */
	clear
	use Table3_4.dta
	xtset state year

	xi: newey2         vol (share=birth)  i.state i.year, lag(2) i(state) t(year)
	xi: ivregress 2sls vol (share=birth)  i.state i.year, robust cluster(state)
	xi: newey2 				share birth   i.state i.year, lag(2) i(state) t(year)  /* 1st stage */
	
	
/*  Table 3  Column 5  10-year interval */
	/* 	Note, for columns 4 and 5, the year variable
		keeps track of the interval rather than the
		actual year. */
	clear
	use Table3_5.dta
	xtset state year

	xi: newey2         vol (share=birth)  i.state i.year, lag(2) i(state) t(year)
	xi: ivregress 2sls vol (share=birth)  i.state i.year, robust cluster(state)
	xi: newey2 				share birth   i.state i.year, lag(2) i(state) t(year)  /* 1st stage */
	

/*  Table 3  Column 6  Stock & Watson (2002) */
	/*  I used the code from Jaimovich and Siu (AER 2009) as provided by Seth Pruitt (thanks!).
		Since it is not my code, I do not provide it here.  */
