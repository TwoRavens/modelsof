/*Checking the existence of an Ashenfelter dip*/
/*Concentrate on people who emigrate the fourth quarter and check the evolution of their wages*/
clear
capture log close
set matsize 1000
set memory 4g
set more off
log using ashenfelter.log, replace

/*Calculate wages with respect to the quarter average*/
use wageearner paro laborforce schoolyears edad binmigr houseid FAC PER mujer rhwage fiveint binmigr2 binmigr3 binmigr4 using datasetash
ren binmigr binmigr1
gen include = 1 if edad > 15 & edad < 66
svyset, clear
svyset houseid [pweight=FAC]
local concepts "edad schoolyears laborforce wageearner paro rhwage"
local quarters "200 300 400 101 201 301 401 102 202 302 402 103 203 303 403"
foreach concept of local concepts {
	gen qmean`concept' = .
	foreach quarter of local quarters {
		svy, subpop(if mujer == 0 & real(PER) == `quarter' & include == 1): mean `concept'
		mat define B = e(b)
		replace qmean`concept' = B[1,1] if mujer == 0 & real(PER) == `quarter' & include == 1 
	}
}
/*Standardized wages (real wage divided by quarter average)*/
foreach concept of local concepts {
	gen `concept'st = `concept'/qmean`concept'
}
/*Create wage variables 1 quarter before emigrating, 2 quarters before emigrating, 3 quarters before emigrating and 4 quarters before emigrating*/
foreach concept of local concepts {
	forvalues n = 1/4 {
		gen `concept'`n' = `concept'st if binmigr`n' == 1 & fiveint == 1 & include == 1
		codebook `concept'`n'
		svy: mean `concept'`n'
	}
}

/*Women*/
foreach concept of local concepts {
	gen wqmean`concept' = .
	foreach quarter of local quarters {
		svy, subpop(if mujer == 1 & real(PER) == `quarter' & include == 1): mean `concept'
		mat define B = e(b)
		replace wqmean`concept' = B[1,1] if mujer == 1 & real(PER) == `quarter' & include == 1 
	}
}
foreach concept of local concepts {
	gen w`concept'st = `concept'/wqmean`concept'
}
foreach concept of local concepts {
	forvalues n = 1/4 {
		gen w`concept'`n' = w`concept'st if binmigr`n' == 1 & fiveint == 1
		codebook w`concept'`n'
		svy: mean w`concept'`n'
	}
}
