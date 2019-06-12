*************************************************************
* Michael M. Bechtel & Jale Tosun							*
* "Changing Economic Openness for Environmental Policy      *
* Convergence: When Can Bilateral Trade Agreements Induce   *
* Convergence of Environmental Regulation?"                 *
* INTERNATIONAL STUDIES QUARTERLY							*
*************************************************************

* REPLICATION INSTRUCTION
* To replicate the box-plots copy the
* dataset (enforcement.dta) to your working directory
* Then run this do-file

clear
set more off
use enforcement.dta

label variable reg_state "Regulation Level"
label variable enf_score "Enforcement Level"

* Boxplot
#delimit;
graph box enf_score, 
by(reg_state)
ylabel(1(1)7, labsize(medium) nogrid)
graphregion(fcolor(white))
box(1, fcolor(white) lwidth(medthin))
plotregion(fcolor(white))
medtype(cline) medline(lcolor(black)
lwidth(medthick) lpattern(solid))
marker(1, msize(small))
;
#delimit cr
su enf_score
bysort reg_state: su enf_score

* Test for homogeneity of variances
robvar enf_score, by(reg_state)

clear 
exit