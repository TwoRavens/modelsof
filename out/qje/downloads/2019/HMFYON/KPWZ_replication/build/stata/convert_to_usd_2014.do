
*********************************************************
* Convert to 2014 US Dollars Program
*********************************************************
capture program drop usd2014

program usd2014
syntax, var(varname) yr(varname) 


* BEA Table 1.1.4. Price Indexes for Gross Domestic Product
/*
year	1/cpi2014
1993	1.503062988
1994	1.47180133
1995	1.441698831
1996	1.415894851
1997	1.391942424
1998	1.377006398
1999	1.357571973
2000	1.327317133
2001	1.297761328
2002	1.278151458
2003	1.253173459
2004	1.219663817
2005	1.181649182
2006	1.146416065
2007	1.116642696
2008	1.095506864
2009	1.08694
2010	1.073775512
2011	1.052064076
2012	1.033016537
2013	1.016449245
2014	1
*/


replace `var'= `var'*1.503062988  if `yr'==1993 & `var'!=.
replace `var'= `var'*1.47180133   if `yr'==1994 & `var'!=.
replace `var'= `var'*1.441698831  if `yr'==1995 & `var'!=.
replace `var'= `var'*1.415894851  if `yr'==1996 & `var'!=.
replace `var'= `var'*1.391942424  if `yr'==1997 & `var'!=.
replace `var'= `var'*1.377006398  if `yr'==1998 & `var'!=.
replace `var'= `var'*1.357571973  if `yr'==1999 & `var'!=.
replace `var'= `var'*1.327317133  if `yr'==2000 & `var'!=.
replace `var'= `var'*1.297761328  if `yr'==2001 & `var'!=.
replace `var'= `var'*1.278151458  if `yr'==2002 & `var'!=.
replace `var'= `var'*1.253173459  if `yr'==2003 & `var'!=.
replace `var'= `var'*1.219663817  if `yr'==2004 & `var'!=.
replace `var'= `var'*1.181649182  if `yr'==2005 & `var'!=.
replace `var'= `var'*1.146416065  if `yr'==2006 & `var'!=.
replace `var'= `var'*1.116642696  if `yr'==2007 & `var'!=.
replace `var'= `var'*1.095506864  if `yr'==2008 & `var'!=.
replace `var'= `var'*1.08694      if `yr'==2009 & `var'!=.
replace `var'= `var'*1.073775512  if `yr'==2010 & `var'!=.
replace `var'= `var'*1.052064076  if `yr'==2011 & `var'!=.
replace `var'= `var'*1.033016537  if `yr'==2012 & `var'!=.
replace `var'= `var'*1.016449245  if `yr'==2013 & `var'!=.
replace `var'= `var'*1            if `yr'==2014 & `var'!=.

end 
