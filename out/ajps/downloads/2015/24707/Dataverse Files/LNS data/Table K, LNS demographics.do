/*Open 2006lns.dta*/ 

/*Mexican origin respondents*/

tab ancestry

/*age*/

summ age, detail

/*education, higher values = more education*/

tab educ 
tab educ, nolabel
summ educ, detail

/*sex 1=male*/

tab male, nolabel

/*foreign-born dummy, where foreign-born = 1*/

tab foreign

/*citizenship status dummy, where citizens = 1*/

tab citiz, nolabel


