


* Create a foreign population variable for each GSS year

gen forpop1=.
replace forpop1=forpop if essround==1

gen forpop2=.
replace forpop2=forpop if essround==2

gen forpop3=.
replace forpop3=forpop if essround==3

gen forpop4=.
replace forpop4=forpop if essround==4

gen forpop5=.
replace forpop5=forpop if essround==5

gen forpop6=.
replace forpop6=forpop if essround==6

* Figure for foreign population, country-year

graph bar (mean) forpop1 forpop2 forpop3 forpop4 forpop5 forpop6, legend(label(1 "2002") label(2 "2004") ///
label(3 "2006") label(4 "2008") label(5 "2010") label(6 "2012") rows(1)) over(country) ///
 plotregion(fcolor(white)) graphregion(fcolor(white)) scheme(sj)
graph export graph02.pdf, replace




* Correlation between foreign poor (from survey) and foreign population (from OECD) for footnote

corr forpop forperpoor
