* Figure 1
* Post-electoral violent events after election day

set more off
clear
version 13.0

use "AnalysisData180days_JPR.dta", clear


gen Days05=Days+0.5 // do see both opp and gov-sponsored violence
#delimit ;
twoway bar RepressionPost Days, color(gs8)||
bar OppViolPost Days05, color(gs0)
xline(90)
xtitle("Days after election")
xlabel(1 30 60 90 120 150 180)
ytitle("Count of violent events")
legend(label(1 "Government violence") label(2 "Opposition violence"))
scheme(s3mono) graphregion(fcolor(white));
#delimit cr

*title("Violent Events after Election Day")


** "79 percent of the overall post-electoral violence occurs within 90 days 
** of election day and events of post-electoral violence steadily decline afterwards."
gen DayCut = 1 if Days<=90
replace DayCut = 0 if DayCut==.

gen OppViolPostD = 1 if OppViolPost>0
replace OppViolPostD = 0 if OppViolPost==0
tab OppViolPostD DayCut, row // 81.03

gen RepressionPostD = 1 if RepressionPost>0
replace RepressionPostD = 0 if RepressionPost==0
tab RepressionPostD DayCut, row //80.74

gen PostViolenceD = 1 if RepressionPost>0 | OppViolPostD>0
replace PostViolenceD=0 if PostViolenceD==.
tab PostViolenceD DayCut, row // 79.38
