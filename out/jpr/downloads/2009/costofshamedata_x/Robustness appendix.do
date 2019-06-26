
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
drop if WBPOP==.

xtreg BIPOP l.BIPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE)

outreg using test.doc, nolabel replace


xtreg MUPOP l.MUPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE)

outreg using test.doc, nolabel append


xtreg BIPOP l.BIPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , fe i(CCODE)robust

outreg using test.doc, nolabel replace


xtreg MUPOP l.MUPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , fe i(CCODE) robust

outreg using test.doc, nolabel append

use "F:\UNHRC\JPRFinalrevision\jprworkdatanew.dta", clear


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
drop if EVERSHAM==0

xtreg BIPOP l.BIPOP PUBRES   l.GDPPOP l.LNPOP l.USAGREE WAR linear quad , mle i(CCODE)

outreg using test.doc, nolabel replace


xtreg MUPOP l.MUPOP PUBRES l.GDPPOP l.LNPOP l.USAGREE WAR linear quad , mle i(CCODE)

outreg using test.doc, nolabel append

xtreg WBPOP l.WBPOP PUBRES dl.GDPPOP l.LNPOP l.USAGREE WAR linear quad  , mle i(CCODE)

outreg using test.doc, nolabel append


xtreg BIPOP l.BIPOP PUBRES  l.GDPPOP l.LNPOP l.USAGREE WAR linear quad , fe i(CCODE)robust

outreg using test.doc, nolabel replace


xtreg MUPOP l.MUPOP PUBRES  l.GDPPOP l.LNPOP l.USAGREE WAR  linear quad , fe i(CCODE) robust

outreg using test.doc, nolabel append

xtreg WBPOP l.WBPOP PUBRES  l.GDPPOP l.LNPOP l.USAGREE WAR   linear quad  , fe i(CCODE) robust

outreg using test.doc, nolabel append


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

xtreg BIPOP l.BIPOP PUBRES   linear quad , fe i(CCODE)robust

outreg using test.doc, nolabel replace


xtreg MUPOP l.MUPOP PUBRES  linear quad , fe i(CCODE) robust

outreg using test.doc, nolabel append

xtreg WBPOP l.WBPOP PUBRES  linear quad  , fe i(CCODE) robust

outreg using test.doc, nolabel append


use "F:\UNHRC\JPRFinalrevision\jprworkdatanew2.dta", clear


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

xtreg BIPOP l.BIPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB COL RIVAL linear quad , mle i(CCODE)

outreg using test.doc, nolabel replace


xtreg MUPOP l.MUPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB COL RIVAL linear quad , mle i(CCODE)

outreg using test.doc, nolabel append

xtreg WBPOP l.WBPOP PUBRES d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB COL RIVAL linear quad  , mle i(CCODE)

outreg using test.doc, nolabel append


xtreg BIPOP l.BIPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB COL RIVAL linear quad , fe i(CCODE)robust

outreg using test.doc, nolabel replace


xtreg MUPOP l.MUPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB COL RIVAL linear quad , fe i(CCODE) robust

outreg using test.doc, nolabel append

xtreg WBPOP l.WBPOP PUBRES d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB COL RIVAL  linear quad  , fe i(CCODE) robust

outreg using test.doc, nolabel append



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

replace PUBRES=1 if Y2>1


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




use "F:\UNHRC\iJPRrevisionanalysis\jprworkdatanew.dta", clear



tsset CCODE YEAR



gen X=YEAR-1990
gen linear=2*X
gen quad=(4*(X*X))-2
gen tri=8*(X*X*X)-12*X

replace WBCOMMIT=WBCOMMIT*1000000
replace BILATCOM=BILATCOM*1000000
replace MULTCOM=MULTCOM*1000000

gen lnWB=ln(WBCOMMIT+1)
gen lnMU=ln(MULTCOM+1)
gen lnBI=ln(BILATCOM+1)

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


xtreg lnBI l.lnBI PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.LNGDP l.LNPOP  l.LNPOP2 l.USAGREE WAR linear quad , mle i(CCODE)

outreg using test.doc, nolabel replace


xtreg lnMU l.lnMU PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.LNGDP l.LNPOP l.LNPOP2 l.USAGREE WAR linear quad , mle i(CCODE)

outreg using test.doc, nolabel append


xtreg lnWB l.lnWB PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.LNGDP l.LNPOP l.LNPOP2 l.USAGREE WAR linear quad , mle i(CCODE)

outreg using test.doc, nolabel append


xtreg lnBI l.lnBI PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.LNGDP l.LNPOP  l.LNPOP2 l.USAGREE WAR linear quad , fe i(CCODE) robust

outreg using test.doc, nolabel replace


xtreg lnMU l.lnMU PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.LNGDP l.LNPOP l.LNPOP2 l.USAGREE WAR linear quad , fe i(CCODE) robust


outreg using test.doc, nolabel append


xtreg lnWB l.lnWB PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.LNGDP l.LNPOP l.LNPOP2 l.USAGREE WAR linear quad , fe i(CCODE) robust


outreg using test.doc, nolabel append






















