clear all

// This program just cuts teh original tables in two, for memory concerns

use data/export0603
gen indiv = substr(identep,1,8)
bys indiv inddtns (datedeb): gen first = (_n == 1)
gen u = uniform() if first == 1
bys indiv inddtns (datedeb): replace u = u[1]
preserve
keep if u <= .5
drop u
save data/fna2006_q1_h1
restore
keep if u > .5
drop u
save data/fna2006_q1_h2

use data/export0606
gen indiv = substr(identep,1,8)
bys indiv inddtns (datedeb): gen first = (_n == 1)
gen u = uniform() if first == 1
bys indiv inddtns (datedeb): replace u = u[1]
preserve
keep if u <= .5
drop u
save data/fna2006_q2_h1
restore
keep if u > .5
drop u
save data/fna2006_q2_h2

use data/export0609
gen indiv = substr(identep,1,8)
bys indiv inddtns (datedeb): gen first = (_n == 1)
gen u = uniform() if first == 1
bys indiv inddtns (datedeb): replace u = u[1]
preserve
keep if u <= .5
drop u
save data/fna2006_q3_h1
restore
keep if u > .5
drop u
save data/fna2006_q3_h2

use data/export0612
gen indiv = substr(identep,1,8)
bys indiv inddtns (datedeb): gen first = (_n == 1)
gen u = uniform() if first == 1
bys indiv inddtns (datedeb): replace u = u[1]
preserve
keep if u <= .5
drop u
save data/fna2006_q4_h1
restore
keep if u > .5
drop u
save data/fna2006_q4_h2

use data/export0703
gen indiv = substr(identep,1,8)
bys indiv inddtns (datedeb): gen first = (_n == 1)
gen u = uniform() if first == 1
bys indiv inddtns (datedeb): replace u = u[1]
preserve
keep if u <= .5
drop u
save data/fna2007_q1_h1
restore
keep if u > .5
drop u
save data/fna2007_q1_h2

use data/export0706
gen indiv = substr(identep,1,8)
bys indiv inddtns (datedeb): gen first = (_n == 1)
gen u = uniform() if first == 1
bys indiv inddtns (datedeb): replace u = u[1]
preserve
keep if u <= .5
drop u
save data/fna2007_q2_h1
restore
keep if u > .5
drop u
save data/fna2007_q2_h2

use data/export0709
gen indiv = substr(identep,1,8)
bys indiv inddtns (datedeb): gen first = (_n == 1)
gen u = uniform() if first == 1
bys indiv inddtns (datedeb): replace u = u[1]
preserve
keep if u <= .5
drop u
save data/fna2007_q3_h1
restore
keep if u > .5
drop u
save data/fna2007_q3_h2

use data/export0712
gen indiv = substr(identep,1,8)
bys indiv inddtns (datedeb): gen first = (_n == 1)
gen u = uniform() if first == 1
bys indiv inddtns (datedeb): replace u = u[1]
preserve
keep if u <= .5
drop u
save data/fna2007_q4_h1
restore
keep if u > .5
drop u
save data/fna2007_q4_h2
