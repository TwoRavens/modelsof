clear all
* Set root path of replication archieve here 
local path = "~/Box Sync/Shared_EffectofIncarceration_Pennslyvania/Replication Data/"

cd "`path'/Arrests SA Table 06"
cap log close
log using "Arrests.log", replace

clear all 
set more off

// Gets distribution of prior arrests. probabation, minor crimes, conditional on no previous conviction

infix str priorarrests 3179-3181 str probation 3214-3215 /*
*/ str minor1 3363-3367 str major1 3380-3385 str weight 8588-8596 /*
*/ using "04572-0002-Data.txt", clear

// S6Q1a
tab priorarrests 

// Categories of Arrests: 0, 1, 2, 3+
destring priorarrests, force replace
gen priorarrests2 = priorarrests
replace priorarrests2 = 3 if priorarrests >= 3 & priorarrests <= 996
tab priorarrests2 

/* S6Q2a: Have you ever been placed on probation by a court, either as a
juvenile or an adult? Include any sentence by a court to both probation 
and a correctional facility 

S6Q2b. Have you ever been placed on probation by a court, either as a
juvenile or an adult, before your probation for (Insert FILL offense)?
Include any sentence by a court to both probation and a correctional facility. */

// Prior conviction = 1 if answer is yes to either 
tab probation
gen priorprobation = (regexm(probation, "1"))
tab priorprobation

/* S6Q3a. The following questions are about any times before your admission 
on (Insert date in Storage Item 2D) that you were sentenced and served time 
in prison, jail, or another correctional facility.

___ Drunkenness? (Exclude DWI and DUI)
___ Vagrancy?
___ Loitering?
___ Disorderly conduct?
___ Minor traffic crimes?(Exclude driving while intoxicated and hit and run) */

tab minor1
gen priorminor = (regexm(minor1, "1"))
tab priorminor

/* S6Q3c. Before your current admission to prison on 
(Insert date in Storage Item 2D), were you ever sentenced to serve
time in prison or jail for ANYTHING other than drunkenness, vagrancy, 
loitering, disorderly conduct, or minor traffic crimes?

S6Q3d. Before your sentence for (Insert offense from Storage Item 2B) 
for which you were admitted to incarceration on 
(Insert admission date from Storage Item 2D), were you ever sentenced to 
serve time for ANYTHING other than drunkenness, vagrancy, loitering, 
disorderly conduct, or minor traffic crimes?

S6Q3e. Before your sentence for (Insert offense from Storage Item 2E) for which 
you were admitted to incarceration on 
(Insert admission date from Storage Item 2F), were you ever sentenced to serve 
time for ANYTHING other than drunkenness, vagrancy, loitering, disorderly 
conduct, or minor traffic crimes?

S6Q3f. Before your sentence to probation for the 
(Insert offenses from Storage Item 2E) were you ever sentenced to
serve time for ANYTHING other than drunkenness, vagrancy, loitering, 
disorderly conduct, or minor traffic crimes?

S6Q3g. Before your sentence to probation for the 
(Insert offenses from Storage Item 2B) were you ever sentenced to
serve time for ANYTHING other than drunkenness, vagrancy, loitering, 
disorderly conduct, or minor traffic crimes? 

S6Q3h. Before your admission to prison on (Insert date in Storage Item 2D), 
were you ever sentenced to serve time for ANYTHING other than drunkenness, 
vagrancy, loitering, disorderly conduct, or minor traffic crimes? */

tab major1
gen priormajor = (regexm(major1, "1"))
tab priormajor

// Adds weights
destring weight, force replace
gen id = _n
svyset id [pweight=weight]

matrix values = J(3, 7, -9)

// No Prior Major Imprisonment 
svy: mean priormajor
matrix temp = e(b)
matrix values[1, 1] = 1 - temp[1, 1]
svy: mean priorminor if priormajor == 0
matrix temp = e(b)
matrix values[1, 2] = temp[1, 1]
svy: mean priorprobation if priormajor == 0
matrix temp = e(b)
matrix values[1, 3] = temp[1, 1]
forvalues i = 0(1)3 {
gen temp = (priorarrests2 == `i')
svy: mean temp if priormajor == 0
matrix temp = e(b)
matrix values[1, 4 + `i'] = temp[1, 1]
drop temp
}

// No Prior Major or Minor Imprisonment 
gen temp = (priormajor | priorminor)
svy: mean temp
drop temp
matrix temp = e(b)
matrix values[2, 1] = 1 - temp[1, 1]
svy: mean priorminor if priormajor == 0 & priorminor == 0
matrix temp = e(b)
matrix values[2, 2] = temp[1, 1]
svy: mean priorprobation if priormajor == 0 & priorminor == 0
matrix temp = e(b)
matrix values[2, 3] = temp[1, 1]
forvalues i = 0(1)3 {
gen temp = (priorarrests2 == `i')
svy: mean temp if priormajor == 0 & priorminor == 0
matrix temp = e(b)
matrix values[2, 4 + `i'] = temp[1, 1]
drop temp
}

// No Prior Major or Minor Imprisonment or Probation
gen temp = (priormajor | priorminor | priorprobation)
svy: mean temp
drop temp
matrix temp = e(b)
matrix values[3, 1] = 1 - temp[1, 1]
svy: mean priorminor if priormajor == 0 & priorminor == 0 & priorprobation == 0
matrix temp = e(b)
matrix values[3, 2] = temp[1, 1]
svy: mean priorprobation if priormajor == 0 & priorminor == 0 & priorprobation == 0
matrix temp = e(b)
matrix values[3, 3] = temp[1, 1]
forvalues i = 0(1)3 {
gen temp = (priorarrests2 == `i')
svy: mean temp if priormajor == 0 & priorminor == 0 & priorprobation == 0
matrix temp = e(b)
matrix values[3, 4 + `i'] = temp[1, 1]
drop temp
}

* This is Table SA 06
matlist values

log close
