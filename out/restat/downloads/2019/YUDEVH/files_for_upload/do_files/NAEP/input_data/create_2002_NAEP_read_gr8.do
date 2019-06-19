version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA3\NAEP 2003\NAEP 2003 Reading G4\stata\LABELDEF.do"
label data "2002 National Reading Assessment: Grade  8 Student & Teacher Data"

infile using "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2002\2002_read_g8.DCT", clear

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

*NOTE - I don't bring in student replicate weights, but I can add them into dictionary files if I want to

gen year=2002
gen grade=8
gen subject=2
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2002\naep_read_gr8_2002", replace


