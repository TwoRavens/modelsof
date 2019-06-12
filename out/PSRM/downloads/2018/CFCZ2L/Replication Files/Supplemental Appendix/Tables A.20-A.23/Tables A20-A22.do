*create log of session
log using "\Replication Files\Supplemental Appendix\Tables A.20-A.23\TablesA20-A22log", text replace

*clear stata-session
clear

*set seed
set seed 300

*read in Colombian municipality-year level dataset
use Colombia_Muni_Combined.dta, clear

*Table A.20: this calculates all quantities reported in Table A.20 *except* "Total Conflict Cases" (obtained further below)
summarize CINEP_hrv icewsreuthrv gedreuthrv icewsefehrv gedefehrv
pwcorr CINEP_hrv icewsreuthrv gedreuthrv icewsefehrv gedefehrv 

*Table A.21
tabulate CINEP_hrv icewsreuthrv, chi2
tabulate CINEP_hrv gedreuthrv, chi2
tabulate CINEP_hrv icewsefehrv, chi2
tabulate CINEP_hrv gedefehrv, chi2

*Table A.22
tabulate icewsreuthrv icewsefehrv, chi2
tabulate icewsreuthrv gedreuthrv, chi2
tabulate icewsefehrv gedefehrv, chi2
tabulate gedreuthrv gedefehrv, chi2

*get "Total Conflict Cases" for Table A.20
collapse (sum) CINEP_hrv icewsreuthrv gedreuthrv icewsefehrv gedefehrv
summarize

*close log
log close
