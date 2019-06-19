/*Calculating non-parametrically the evolution of the return to skills in the US*/
clear
capture log close
set matsize 800
set memory 900m
set more off
log using usdataset.log, replace

/*Opening the data*/
do jfxxx006

/*Survey commands*/
svyset, clear(all)
svyset [pweight=perwt]

/*Sexo*/
gen mujer = 0
replace mujer = 1 if sex == 2
/*Year*/
replace year = year + 2000
/*Creating schooling years*/
gen schoolyears = 0
replace schoolyears = . if educrec == 0
replace schoolyears = 2.5 if educrec == 2
replace schoolyears = 6.5 if educrec == 3
replace schoolyears = 9 if educrec == 4
replace schoolyears = 10 if educrec == 5
replace schoolyears = 11 if educrec == 6
replace schoolyears = 12 if educrec == 7
replace schoolyears = 14 if educrec == 8
replace schoolyears = 17 if educrec == 9
/*Age groups*/
ren age edad
gen agegroup = .
replace agegroup = 1 if (edad >= 12 & edad < 16)
replace agegroup = 2 if (edad > 15 & edad < 21)
replace agegroup = 3 if (edad > 20 & edad < 26)
replace agegroup = 4 if (edad > 25 & edad < 31)
replace agegroup = 5 if (edad > 30 & edad < 36)
replace agegroup = 6 if (edad > 35 & edad < 41)
replace agegroup = 7 if (edad > 40 & edad < 46)
replace agegroup = 8 if (edad > 45 & edad < 51)
replace agegroup = 9 if (edad > 50 & edad < 56)
replace agegroup = 10 if (edad > 55 & edad < 61)
replace agegroup = 11 if (edad > 60 & edad < 66)
replace agegroup = 12 if (edad > 65 & edad < 99)
/*Married*/
gen married = 0
replace married = 1 if marst < 3
/*State*/
ren stateicp nent
/*Household size*/
ren famsize hhsize

/*Wages*/
/*Creating the wage variable as hourly wages following Chiquiar and Hanson (2005)*/
gen hwage = .
replace hwage = incwage/(uhrswork*wkswork1) if (incwage < 999999 & incwage > 0 & wkswork1 > 0 & uhrswork > 0)
/*Erase people who work less than 20 or more than 84 hours a week*/
replace hwage = . if uhrswork < 20
replace hwage = . if uhrswork > 84

/*Limit observations to migrants who arrived in the previous year*/
replace hwage = . if migplac1 ~= 200

/*Create real wage series (1 January 2006 dollars)*/
/*Use inflation data from the IFS (base 2000) and bring them to December 2005=114.286*/
gen rhwage = 0
replace rhwage = (hwage*114.286)/100 if year == 2000
replace rhwage = (hwage*114.286)/102.826 if year == 2001
replace rhwage = (hwage*114.286)/104.457 if year == 2002
replace rhwage = (hwage*114.286)/106.828 if year == 2003
replace rhwage = (hwage*114.286)/109.688 if year == 2004

_pctile rhwage [pw=perwt], percentiles(.5 99.5)

/* Suppressing the .5% largest and smallest values following Hanson (2006)*/
replace rhwage = . if rhwage < r(r1)
replace rhwage = . if rhwage > r(r2)

gen lhwage = log(rhwage)

gen edad2 = edad*edad
gen schoolyears2 = schoolyears*schoolyears

/*Generating wages relative to the average yearly wage*/
gen include = 1 if edad > 15 & edad < 66 & rhwage ~= .
gen ymeanwage = .
forvalues y = 2000/2004 {
	svymean rhwage, subpop(if year == `y' & include == 1)
	mat define B = e(b)
	replace ymeanwage = B[1,1] if year == `y' & include == 1
}
/*Standardized wages (real wage divided by yearly average)*/
gen wagest = rhwage/ymeanwage
gen lwage = log(wagest)

save usdataset, replace
