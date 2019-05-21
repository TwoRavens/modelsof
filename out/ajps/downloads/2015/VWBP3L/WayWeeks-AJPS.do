
clear matrix
clear
set memory 80m

set more off

cd "/Users/jweeks/Dropbox/Nuclear Proliferation/Conditional Accept/Final Versions"
use WayWeeksAJPS.dta
log using sept5log, text replace

* Figure 1*

sum pursueonly if persdumjlw_lag==0
sum pursueonly if persdumjlw_lag==1
tab persdumjlw_lag, sum(pursueonly)

sum gjprog if persdumjlw_lag==0
sum gjprog if persdumjlw_lag==1
tab persdumjlw_lag, sum(gjprog)

xtset ccode year 


* Table 1 - using Singh and Way data *

btscs pursueonly year ccode, g(time)
gen time2=time*time
gen time3=time2*time

xtlogit pursueonly persdumjlw_lag land time time2 time3, nolog
xtlogit pursueonly persdumjlw_lag land lpop time time2 time3, nolog
xtlogit pursueonly persdumjlw_lag land cap time time2 time3, nolog
xtlogit pursueonly persdumjlw_lag land gdppercap time time2 time3, nolog

drop time time2 time3


* Table 2 - using Gartzke Jo data *

btscs gjprog year ccode, g(time)
gen time2=time*time
gen time3=time2*time

xtlogit gjprog persdumjlw_lag land time time2 time3, nolog
xtlogit gjprog persdumjlw_lag land lpop time time2 time3, nolog
xtlogit gjprog persdumjlw_lag land cap time time2 time3, nolog
xtlogit gjprog persdumjlw_lag land gdppercap time time2 time3, nolog


* Table 3 - Event History Models *

* Singh and Way
stset timesw2, fail(failsw) exit(timesw2==.)  enter(time0sw2)

streg persdumjlw_lag land, dist(w) nohr nolog cluster(ccode) strata(stratsw)
streg persdumjlw_lag land lpop, dist(w) nohr nolog cluster(ccode) strata(stratsw)
streg persdumjlw_lag land cap, dist(w) nohr nolog cluster(ccode) strata(stratsw)
streg persdumjlw_lag land gdppercap, dist(w) nohr nolog cluster(ccode) strata(stratsw)

* Jo and Gartzke
stset timejg3, fail(failjg2) exit(timejg3==.)  enter(time0jg3)

streg persdumjlw_lag land, dist(w) nohr nolog cluster(ccode) strata(stratjg2)
streg persdumjlw_lag land lpop, dist(w) nohr nolog cluster(ccode) strata(stratjg2)
streg persdumjlw_lag land cap, dist(w) nohr nolog cluster(ccode) strata(stratjg2)
streg persdumjlw_lag land gdppercap, dist(w) nohr nolog cluster(ccode) strata(stratjg2)

log close


* APPENDIX *
log using WayWeeksAppendix, replace text

*Table A.2, including both explore and pursue codings*
drop time time2 time3

btscs exppur year ccode, g(time)
gen time2=time*time
gen time3=time2*time

xtlogit exppur persdumjlw_lag land time time2 time3, nolog
xtlogit exppur persdumjlw_lag land lpop time time2 time3, nolog
xtlogit exppur persdumjlw_lag land cap time time2 time3, nolog
xtlogit exppur persdumjlw_lag land gdppercap time time2 time3, nolog
xtlogit exppur persdumjlw_lag land lpop cap gdppercap time time2 time3, nolog


*** Figure A.1. - Singh and Way
drop time time2 time3
btscs pursueonly year ccode, g(time)
gen time2=time*time
gen time3=time2*time

* for the basic model
xtlogit pursueonly persdumjlw_lag land time time2 time3 if ccode!=731, nolog
xtlogit pursueonly persdumjlw_lag land time time2 time3 if ccode!=630, nolog
xtlogit pursueonly persdumjlw_lag land time time2 time3 if ccode!=645, nolog
xtlogit pursueonly persdumjlw_lag land time time2 time3 if ccode!=770, nolog
xtlogit pursueonly persdumjlw_lag land time time2 time3 if ccode!=620, nolog
xtlogit pursueonly persdumjlw_lag land time time2 time3 if ccode!=652, nolog

* check results if Syria coded as not pursuing
recode pursueonly 1=0 if ccode==652&year>1999
drop time time2 time3
btscs pursueonly year ccode, g(time)
gen time2=time*time
gen time3=time2*time
xtlogit pursueonly persdumjlw_lag land  time time2 time3, nolog

* now change Syria back, and change Argentina to not pursuing instead
recode pursueonly 0=1 if ccode==652&year>1999
recode pursueonly 1=0 if ccode==160

drop time time2 time3
btscs pursueonly year ccode, g(time)
gen time2=time*time
gen time3=time2*time
xtlogit pursueonly persdumjlw_lag land  time time2 time3, nolog

* change Argentina back to normal
recode pursueonly 0=1 if ccode==160&year>1977&year<1991

* check if Yugoslavia coded personalist 
recode persdumjlw_lag 0=1 if ccode==345&year>1952&year<1980
xtlogit pursueonly persdumjlw_lag land time time2 time3, nolog
recode persdumjlw_lag 1=0 if ccode==345&year>1952&year<1980

*** Figure A.2 - Jo and Gartzke
* Note that Syria has to be treated differently 
drop time time2 time3
btscs gjprog year ccode, g(time)
gen time2=time*time
gen time3=time2*time

xtlogit gjprog persdumjlw_lag land  time time2 time3 if ccode!=731, nolog
xtlogit gjprog persdumjlw_lag land  time time2 time3 if ccode!=630, nolog
xtlogit gjprog persdumjlw_lag land  time time2 time3 if ccode!=645, nolog
xtlogit gjprog persdumjlw_lag land  time time2 time3 if ccode!=770, nolog
xtlogit gjprog persdumjlw_lag land  time time2 time3 if ccode!=620, nolog
xtlogit gjprog persdumjlw_lag land  time time2 time3 if ccode!=652, nolog

*** Syria coded as pursuing rather than not pursuing***
recode gjprog 0=1 if ccode==652&year>1999
drop time time2 time3
btscs gjprog year ccode, g(time)
gen time2=time*time
gen time3=time2*time
xtlogit gjprog persdumjlw_lag land  time time2 time3, nolog

* change Syria back to not and change Argentina to not instead
recode gjprog 1=0 if ccode==652&year>1999
recode gjprog 1=0 if ccode==160
drop time time2 time3
btscs gjprog year ccode, g(time)
gen time2=time*time
gen time3=time2*time
xtlogit gjprog persdumjlw_lag land  time time2 time3, nolog

*** change Argentina back to normal ***
recode gjprog 0=1 if ccode==160&year>1977&year<1991
drop time time2 time3
btscs gjprog year ccode, g(time)
gen time2=time*time
gen time3=time2*time


*** Figure A.3 ***
** starting with JG**
*** Yugo and Tito ***
recode persdumjlw_lag 0=1 if ccode==345&year>1952&year<1980
xtlogit gjprog persdumjlw_lag land  time time2 time3, nolog
recode persdumjlw_lag 1=0 if ccode==345&year>1952&year<1980

* updating through 2009 using GWF data*
xtlogit gjprog persdum2009_lag land time time2 time3, nolog
xtlogit gjprog persdum2009_lag land lpop time time2 time3, nolog
xtlogit gjprog persdum2009_lag land cap time time2 time3, nolog
xtlogit gjprog persdum2009_lag land gdppercap time time2 time3, nolog

*** now with SW ***
drop time time2 time3
btscs pursueonly year ccode, g(time)
gen time2=time*time
gen time3=time2*time

*** Yugo and Tito ***
recode persdumjlw_lag 0=1 if ccode==345&year>1952&year<1980
xtlogit pursueonly persdumjlw_lag land  time time2 time3, nolog
recode persdumjlw_lag 1=0 if ccode==345&year>1952&year<1980

* updating through 2009 using GWF data*
xtlogit pursueonly persdum2009_lag land time time2 time3, nolog
xtlogit pursueonly persdum2009_lag land lpop time time2 time3, nolog
xtlogit pursueonly persdum2009_lag land cap time time2 time3, nolog
xtlogit pursueonly persdum2009_lag land gdppercap time time2 time3, nolog

*** Table A.5 - Success of Aquisition 
drop time time2 time3
btscs gjnukes year ccode if gjprogpos==1, g(time)
gen time2=time*time
gen time3=time2*time

xtlogit gjnukes persdumjlw_lag time time2 time3 if gjprogpos==1, nolog
xtlogit gjnukes persdumjlw_lag rcvdsens time time2 time3 if gjprogpos==1, nolog
xtlogit gjnukes persdumjlw_lag industry2 time time2 time3 if gjprogpos==1, nolog
xtlogit gjnukes persdumjlw_lag rcvdsens industry2 time time2 time3 if gjprogpos==1, nolog

drop time time2 time3
btscs swnukes year ccode if swpurpos==1, g(time)
gen time2=time*time
gen time3=time2*time

xtlogit swnukes persdumjlw_lag time time2 time3 if swpurpos==1, nolog
xtlogit swnukes persdumjlw_lag rcvdsens time time2 time3 if swpurpos==1, nolog
xtlogit swnukes persdumjlw_lag industry2 time time2 time3 if swpurpos==1, nolog

drop time time2 time3
btscs swnukes year ccode if swexppos==1, g(time)
gen time2=time*time
gen time3=time2*time

xtlogit swnukes persdumjlw_lag time time2 time3 if swexppos==1, nolog
xtlogit swnukes persdumjlw_lag rcvdsens time time2 time3 if swexppos==1, nolog
xtlogit swnukes persdumjlw_lag industry2 time time2 time3 if swexppos==1, nolog

drop time time2 time3


*** Table A.7 - including additional controls
btscs pursueonly year ccode, g(time)
gen time2=time*time
gen time3=time2*time

xtlogit pursueonly persdumjlw_lag land time time2 time3, fe

drop time time2 time3
btscs swpurpos year ccode, g(time)
gen time2=time*time
gen time3=time2*time

xtlogit swpurpos persdumjlw_lag land time time2 time3, nolog

drop time time2 time3
btscs pursueonly year ccode, g(time)
gen time2=time*time
gen time3=time2*time

xtlogit pursueonly persdumjlw_lag rivalryben land time time2 time3, nolog
xtlogit pursueonly persdumjlw_lag rivalrygd land time time2 time3, nolog
xtlogit pursueonly persdumjlw_lag rivalryth land time time2 time3, nolog
xtlogit pursueonly persdumjlw_lag disputes land time time2 time3, nolog
xtlogit pursueonly persdumjlw_lag rivalrygd disputes land time time2 time3, nolog
xtlogit pursueonly persdumjlw_lag ally land time time2 time3, nolog
xtlogit pursueonly persdumjlw_lag industry2 land time time2 time3, nolog
xtlogit pursueonly persdumjlw_lag rcvdsens land time time2 time3, nolog

* control for democracy
gen demjlw=.
replace demjlw=1 if polity>=6
replace demjlw=0 if polity<6 & polity>-66
replace demjlw=. if polity==.
tab demjlw
bysort ccode (year): gen demjlw_lag=demjlw[_n-1]

xtlogit pursueonly persdumjlw_lag demjlw_lag land time time2 time3, nolog

test persdumjlw_lag=demjlw_lag


* now with the GJ data
xtlogit gjprog persdumjlw_lag land time time2 time3, fe

drop time time2 time3
btscs gjprogpos year ccode, g(time)
gen time2=time*time
gen time3=time2*time

xtlogit gjprogpos persdumjlw_lag land time time2 time3, nolog 

drop time time2 time3
btscs gjprog year ccode, g(time)
gen time2=time*time
gen time3=time2*time

xtlogit gjprog persdumjlw_lag rivalryben land time time2 time3, nolog
xtlogit gjprog persdumjlw_lag rivalrygd land time time2 time3, nolog
xtlogit gjprog persdumjlw_lag rivalryth land time time2 time3, nolog
xtlogit gjprog persdumjlw_lag rivalryhew land time time2 time3, nolog
xtlogit gjprog persdumjlw_lag disputes land time time2 time3, nolog
xtlogit gjprog persdumjlw_lag rivalrygd disputes land time time2 time3, nolog
xtlogit gjprog persdumjlw_lag ally land time time2 time3, nolog
xtlogit gjprog persdumjlw_lag industry2 land time time2 time3, nolog
xtlogit gjprog persdumjlw_lag rcvdsens land time time2 time3, nolog
xtlogit gjprog persdumjlw_lag demjlw_lag land time time2 time3, nolog

test persdumjlw_lag=demjlw_lag


log close




