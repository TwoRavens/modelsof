/*  This program (Table1) was run in STATA IC 12.
    The program uses the variables contained
	in the STATA data file Table.dta to create
	Table 1 in the text - the main results.
	
	Table.dta is a state by year panel.
	
	The program calls the command "newey2", which
	can be downloaded and installed within STATA
	(type 'ssc install newey2' at the command line).
	
	The cd line below should be changed to run the code. */	
	
cd ""	
clear
use Table.dta
xtset state year

/*  Table 1  Column 1  OLS  */
	xi: newey2 vol share i.state i.year, lag(2) i(state) t(year)

/*  Table 1  Column 2  2SLS */
	xi: newey2 vol (share=birth) i.state i.year, lag(2) i(state) t(year)
	xi: newey2 share birth       i.state i.year, lag(2) i(state) t(year)  /* 1st stage */

/*  Table 1  Column 3  Reduced Form */
	xi: newey2 vol birth i.state i.year, lag(2) i(state) t(year)

/*  Table 1  Column 2  2SLS with GROWTH */
	xi: newey2 vol (share=birth) growth i.state i.year, lag(2) i(state) t(year)
	xi: newey2 share birth       growth i.state i.year, lag(2) i(state) t(year)  /* 1st stage */
