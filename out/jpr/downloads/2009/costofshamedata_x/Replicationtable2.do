
use "F:\UNHRC\iJPRrevisionanalysis\jprworkdatanew.dta", clear


tsset CCODE YEAR


gen X=YEAR-1990
gen linear=2*X
gen quad=(4*(X*X))-2
gen tri=8*(X*X*X)-12*X

replace WBCOMMIT=WBCOMMIT*1000000
replace BILATCOM=BILATCOM*1000000
replace MULTCOM=MULTCOM*1000000



gen WBPOP=WBCOMMIT/POPULATI
gen BIPOP=BILATCOM/POPULATI
gen MUPOP=MULTCOMM/POPULATI
gen GDPPOP=GDP/POPULATI


replace WBPOP=1 if WBPOP<1
replace WBPOP=ln(WBPOP) 
replace BIPOP=1 if BIPOP<1
replace BIPOP=ln(BIPOP) 
replace MUPOP=1 if MUPOP<1
replace MUPOP=ln(MUPOP) 
replace GDPPOP=ln(GDPPOP)


drop if YEAR>2002

xtreg BIPOP l.BIPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE)

outreg using test.doc, nolabel replace


xtreg MUPOP l.MUPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE)

outreg using test.doc, nolabel append

xtreg WBPOP l.WBPOP PUBRES d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad  , mle i(CCODE)

outreg using test.doc, nolabel append


xtreg BIPOP l.BIPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , fe i(CCODE)robust

outreg using test.doc, nolabel replace


xtreg MUPOP l.MUPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , fe i(CCODE) robust

outreg using test.doc, nolabel append

xtreg WBPOP l.WBPOP PUBRES d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB  linear quad  , fe i(CCODE) robust

outreg using test.doc, nolabel append
