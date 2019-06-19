/* This file makes table 1*/
/*Variable Creation is now entirely in the two "create extract" files */

log using table1_restat.txt, text replace

use mergedcleaned00, clear
append using mergedcleaned04

/*Output for the tables */

/*Full Sample*/
sum reject
matrix define means = [r(mean), r(N)]

/*Grade Level*/
forval i = 1/4{
sum reject if uglvl2 == `i'
matrix define means = [means\r(mean), r(N)]
}

/*Race*/

forval i = 1/4{
sum reject if race == `i'
matrix define means = [means\r(mean), r(N)]
}

sum reject if race > 4
matrix define means = [means\r(mean), r(N)]

/*Gender*/
forval i = 1/2{
sum reject if gender == `i'
matrix define means = [means\r(mean), r(N)]
}

/*Parental Support*/
forval i = 0/1{
sum reject if parhelpd == `i'
matrix define means = [means\r(mean), r(N)]
}

/*Parental Income*/
forval i = 0/1{
sum reject if highinc == `i'
matrix define means = [means\r(mean), r(N)]
}

/*Cost of Attendance*/
forval i = 0/1{
sum reject if highcost == `i'
matrix define means = [means\r(mean), r(N)]
}

/*Parental Education*/
forval i = 0/1{
sum reject if smartparent == `i'
matrix define means = [means\r(mean), r(N)]
}

/*Test Scores*/
forval i = 0/1{
sum reject if abovemedtest == `i'
matrix define means = [means\r(mean), r(N)]
}

/*Survey year*/
forval year = 2000(4)2004{
sum reject if year == `year'
matrix define means = [means\r(mean), r(N)]
}

matrix list means

log close



