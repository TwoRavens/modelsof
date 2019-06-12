/* Note: the directory is set in the "Environmental Engel Curves.do" file, which calls on this
	program, and does not need to be set here unless the program is running independently.
	To run this program separetly, be sure to set the directory here." */

/* This .do file is meant to import the Economic Census from CSV (the raw file
is available in the "Other Raw Data" folder.  The raw data were downloaded from
American Fact Finder.


The main issues that require cleaning are:
Frequently missing value shipped data due to too few establishments
classification into tax classes that aren't necessary
Some 5-digit codes and 6-digit codes are identical, except for a trailing zero
	(this is not a problem, per se, but something to be aware of)
*/



/* A note about scale:
The Agricultural census lists "market value of agricultural product sold ($1,000)"
The Economic Census lists "Value of sales, shipments, receipts, revenue, or business done ($1,000)"
*/

/* Insheet the Economic Census */
insheet using "Other Raw Files\2002 Economic Census.csv", clear names
drop geo* tax_status status_meaning payroll employees year
rename value_shipped shipped
replace naics = "48-49" if naics=="48-49(002)"
replace naics = "481" if naics=="481(001)"
replace naics = "4811" if naics=="4811(001)"
replace naics = "48111" if naics=="48111(001)"
replace naics = "481111" if naics=="481111(001)"

gen length=length(naics)
drop if length>6
sort naics

/* According to Economic Census, there was 1,208,731,383 (in $1,000) in
"value of business done" for NAICS 23.  See file
"ECN_2002_US_23SG104 Construction Value" in "Other Raw Files" folder.  This file
was downloaded from AFF. */
replace shipped = "1208731383" if substr(naics,1,2)=="23"
replace naics_name="Construction" if substr(naics,1,2)=="23"
replace naics="23" if substr(naics,1,2)=="23"
duplicates drop


/* Some 6-digit industries don't report value shipped becuase the number of
firms is too small.  For these, I will allocate the 5-digit output based on
the number of establishments.  There are two main issues complicating this:
1) some of the 6-digit codes are just 5-digit codes with a trailing zero
2) Occasionally there are 6-digit codes with missing data AND 6-digit codes
with non-missing data, both under the same 5-digit family.
I am going to start with the non-trailing-zero 6-digit codes, find the value of the
5-digit industry minus any existing 6-digit values, then allocate the remaining
value across the missing 6-digit NAICS in proportion to number of firms.
Problem 1, above, can be solved by doing this process for 3-, digit codes, then 4-digit,
etc, rather than starting from 6-digit codes */
destring shipped establishments, ignore("D" "(r)") replace
/* Calculate the total shipped based on 3-digit codes: */
preserve
keep if length==3
keep naics shipped
rename naics naics3
rename shipped shipped3
collapse (sum) shipped3, by(naics3)
save "Compiled Data Files\naics3_output.dta", replace
restore
/* in the 3-digit output */
gen naics3 = substr(naics,1,3) if length==4
merge m:1 naics3 using "Compiled Data Files\naics3_output.dta"
drop _merge
/* Calculate the total value that is *already* accounted
for at the 4-digit level*/
egen shipped4=total(shipped) if length==4, by(naics3)
/* Calulate the total number of establishments that are missing data for each naics */
egen estab4 = total(establishments) if length==4&shipped==., by(naics3)
/* Replace value shipped */
replace shipped = (shipped3-shipped4)*(establishments/estab4) if length==4&shipped==.
drop naics3 shipped3 shipped4 estab4

/* Now repeat that exact code for missing 5-digit values */
preserve
keep if length==4
keep naics shipped
rename naics naics4
rename shipped shipped4
collapse (sum) shipped4, by(naics4)
save "Compiled Data Files\naics4_output.dta", replace
restore
/* in the 3-digit output */
gen naics4 = substr(naics,1,4) if length==5
merge m:1 naics4 using "Compiled Data Files\naics4_output.dta"
drop _merge
/* Calculate the total value that is *already* accounted
for at the 4-digit level*/
egen shipped5=total(shipped) if length==5, by(naics4)
/* Calulate the total number of establishments that are missing data for each naics */
egen estab5 = total(establishments) if length==5&shipped==., by(naics4)
/* Replace value shipped */
replace shipped = (shipped4-shipped5)*(establishments/estab5) if length==5&shipped==.
drop naics4 shipped4 shipped5 estab5



/* Now, update the missing shipped data for 6-digit NAICS with trailing zero by,
i) make a list of 5-digit NAICS and shipped, then add trailing zero ii) merge back in
and update shipped.  Note, you have to merge based on naics and establishments,
to make sure they the correct records line up. */
preserve
keep if length==5
replace naics=naics+"0"
drop length naics_name
save "Compiled Data Files\naics6_output.dta", replace
restore
merge 1:1 naics establishments using "Compiled Data Files\naics6_output.dta", update
drop if _merge==2
drop _merge

/* Finally, update the missing for the 6-digit NAICS that don't have a trailing zero.
Doing the exaxt same procedure as above */
/* Now repeat that exact code for missing 6-digit values */
preserve
keep if length==5
keep naics shipped
rename naics naics5
rename shipped shipped5
collapse (sum) shipped5, by(naics5)
save "Compiled Data Files\naics5_output.dta", replace
restore
/* in the 5-digit output */
gen naics5 = substr(naics,1,5) if length==6
merge m:1 naics5 using "Compiled Data Files\naics5_output.dta"
drop if _merge==2
drop _merge
/* Calculate the total value that is *already* accounted
for at the 5-digit level*/
egen shipped6=total(shipped) if length==6, by(naics5)
/* Calulate the total number of establishments that are missing data for each naics */
egen estab6 = total(establishments) if length==6&shipped==., by(naics5)
/* Replace value shipped */
replace shipped = (shipped5-shipped6)*(establishments/estab6) if length==6&shipped==.
drop naics5 shipped5 shipped6 estab6


/* replace all 42000 NAICS */
drop if substr(naics,1,2)=="42"&length!=6
replace naics = "420000" if substr(naics,1,2)=="42"
replace naics_name="Wholesale Trade" if substr(naics,1,2)=="42"


/*Replace NAICS_NAME for 56131 because it is inconsistent */
replace naics_name = "Employment placement agencies" if naics=="56131"


/* now collapse to find total value shipped by NAICS */
collapse (sum) shipped, by(naics naics_name)


/* The NEI files sometimes have 5-digit codes that add a trailing zero to become
6-digit codes.  I am going to duplicate the 5-digit codes in the census and make
them into 6-digit codes so that they can be merged if necessary into the NEI */
preserve
gen length=length(naics)
keep if length==5
replace naics=naics+"0"
drop length
tempfile econ_naics5
save `econ_naics5'
restore
append using `econ_naics5'


duplicates drop
drop if naics=="44-45"
drop if naics=="44-450"

sort naics
save "Compiled Data Files\2002 Economic Census.dta", replace


