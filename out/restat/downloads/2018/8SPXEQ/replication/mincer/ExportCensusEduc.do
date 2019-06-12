clear
use census00.dta

keep educ logwk age
order educ logwk age
sort educ
export delimited using "educwage.csv", novarnames nolabel replace
