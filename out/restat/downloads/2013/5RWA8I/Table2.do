/*  This program (Table2) was run in STATA IC 12.
    This program does the analysis reported in
	Table 2 in the text - robustness checks.
	
	Each (.dta) file used is a state by year panel.
	Table2_3.dta omits the post-1997 data.
	Table2_4.dta includes BEA employment data.
	
	The cd line below should be changed to run the code.
*/
	
	
cd ""
	

/*  Table 2  Column 1  Omit Utah  */
	clear
	use Table.dta
	xtset state year
	drop if state==45  /* drops Utah */

	xi: newey2 vol (share=birth) growth i.state i.year, lag(2) i(state) t(year)
	xi: newey2 share birth       growth i.state i.year, lag(2) i(state) t(year)  /* 1st stage */


/*  Table 2  Column 2  Omit Endpoints */
	clear
	use Table.dta
	xtset state year
	drop if year==2004
	drop if year==1981
	
	xi: newey2 vol (share=birth) growth i.state i.year, lag(2) i(state) t(year)
	xi: newey2 share birth       growth i.state i.year, lag(2) i(state) t(year)  /* 1st stage */


/*  Table 2  Column 3  Omit post-1997 data */
	clear
	use Table2_3.dta
	xtset state year

	xi: newey2 vol (share=birth) growth i.state i.year, lag(2) i(state) t(year)
	xi: newey2 share birth       growth i.state i.year, lag(2) i(state) t(year)  /* 1st stage */


/*  Table 2  Column 4  Total Employment */
	clear
	use Table2_4.dta
	xtset state year

	xi: newey2 empvol (share=birth)  i.state i.year, lag(2) i(state) t(year)
	xi: newey2 share birth           i.state i.year, lag(2) i(state) t(year)  /* 1st stage */
