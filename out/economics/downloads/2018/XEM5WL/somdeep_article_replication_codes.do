
*import excel "/Users/somdeepchatterjee/Dropbox/Grameen Bhandaran/Data and Results/coverage_master_final (edited).xls", sheet("Sheet1") firstrow
import excel "C:\Users\IIM\Dropbox\Grameen Bhandaran\Data and Results\coverage_master_final (edited).xls", sheet("Sheet1") firstrow
set more off
sum YEAR
sum BANK
sum BANK, detail

*Generating the Cross Section Variation in Banks
gen bankabovemedian = .
replace bankabo = 1 if BANKBRA >36
replace bankabo = 0 if BANKBRA <=36
sum bankabove

*Genetrating Cross Section Dummy for time (before vs after intervention)
gen after = .
replace after = 1 if YEAR>2002
replace after=0 if YEAR<=2002
sum after

*Generating Cross Section Variation in Number of Godowns at State Level 
sum Total_New_Num
sum Total_New_Num, detail
gen moregodowns = .
replace morego = 1 if Total_New_N >224
replace morego = 0 if Total_New_N <=224

*Generating Interaction Dummies
sum after bank more
gen triple = after*bank*more
gen double1 = after*more
gen dobule2 = after*bankab
gen double3 = morego*bankab
rename dobule2 double2
xi i.YEAR*double3

*Generating Dependent Variables
gen yield =  RICE_TQ/RICE_TA
gen wyield =  WHT_TQ/WHT_TA
gen fertiliz = NPK_TC/1000

*Actual paper regressions

*The coefficient of Interest is the triple interaction term described in the paper. Here it is the variable "triple"

*Replicating Table 2 of the Main paper (Each of the following 4 regressions replicated the 4 columns)

reg yield triple RICE_TA  double* after morego bankab  if yield>=0 & YEAR>=1990 , robust cluster(DISTNAME) 
reg yield triple RICE_TA  double* after morego bankab GIA GCA PTMRKT  RICE_TAI   ANNUAL  if yield>=0 & YEAR>=1990 , robust cluster(DISTNAME) 
areg yield triple RICE_TA  double* after morego bankab GIA GCA PTMRKT  RICE_TAI   ANNUAL  if yield>=0 & YEAR>=1990 , robust cluster(DISTNAME) absorb(YEAR)
xi: areg yield triple RICE_TA  double* after morego bankab GIA GCA PTMRKT  RICE_TAI   ANNUAL i.YEAR if yield>=0 & YEAR>=1990 , robust cluster(DISTNAME) absorb(DISTNAME)
 
 
 *Replicating the Table 3 from the Paper
 areg wyield triple WHT_TA  double* after morego bankab GIA GCA PTMRKT  WHT_TAI   ANNUAL  if wyield>=0 & YEAR>=1990 , robust cluster(DISTNAME) absorb(YEAR)
 xi: areg wyield triple WHT_TA  double* after morego bankab GIA GCA PTMRKT  WHT_TAI   ANNUAL i.YEAR if wyield>=0 & YEAR>=1990 , robust cluster(DISTNAME) absorb(DISTNAME)
 areg fertiliz triple   double* after morego bankab GIA GCA PTMRKT    ANNUAL  if YEAR>=1990 , robust cluster(DISTNAME) absorb(YEAR)
 xi: areg fertiliz triple   double* after morego bankab GIA GCA PTMRKT    ANNUAL i.YEAR if YEAR>=1990 , robust cluster(DISTNAME) absorb(DISTNAME)
 
 *Replicating Table 4 from the Paper

 areg BARREN triple   double* after morego bankab GIA GCA PTMRKT    ANNUAL  if YEAR>=1990 & BARREN>-1 , robust cluster(DISTNAME) absorb(YEAR)
 xi: areg BARREN triple   double* after morego bankab GIA GCA PTMRKT    ANNUAL i.YEAR if YEAR>=1990 & BARREN>-1 , robust cluster(DISTNAME) absorb(DISTNAME)
 areg NONAGRI triple   double* after morego bankab GIA GCA PTMRKT    ANNUAL  if YEAR>=1990 & NONAGRI>-1 , robust cluster(DISTNAME) absorb(YEAR)
 xi: areg NONAGRI triple   double* after morego bankab GIA GCA PTMRKT    ANNUAL i.YEAR if YEAR>=1990 & NONAGRI>-1 , robust cluster(DISTNAME) absorb(DISTNAME)
