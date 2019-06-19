*** this file prepares quartely CPI-U indices for deflating NBER data.
*** it uses the file CPIAUCNS.csv (CPI All items, Urban Consumers, Not Seasonally adjusted) which is downloaded
*** (for example, today, 12/24/2009) from http://research.stlouisfed.org/fred2/series/CPIAUCNS/downloaddata?cid=9 .

* NOTICE: last few quarters are NOT to be used, b/c data for, e.g., December 2009 do not exist yet and so quarterly 
* average (cpi_q) for 2009:4 is incorrect. similarly, when averaging over the four consequtive quarters (cpi_q_a), 
* averages for 2009:1 and on are incorrect.

global mypath="U:/User6/oh33/stlouisfed/"
insheet using  ${mypath}CPIAUCNS.csv, names clear
gen year=real(substr(date,1,4))
gen month = real(substr(date,6,2))
recode month (1/3 = 1)(4/6 = 2)(7/9 = 3)(10/12 = 4), gen(q)
gen yearq = year*10 + q
byso yearq: egen cpi_q = mean(value)
keep yearq cpi_q
byso yearq: keep if _n==1
sort yearq // just to be on the safe side
gen cpi_q_a = (cpi_q[_n]+cpi_q[_n+1]+cpi_q[_n+2]+cpi_q[_n+3])/4 // this variable contains for each quarter the average of the four quarters (i.e. the full year) that started with that quarter. this makes it comparable with NBER CEX data, where full-year annual data are given by quarter of 1st interview.
save ${mypath}CPIAUCNS_processed.dta, replace
