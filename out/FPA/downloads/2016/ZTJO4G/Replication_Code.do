*Replication File, Bell and Keys (2015)

use "BellKeys_Data.dta"

*FIG 1: MEAN PDSI BY STATE
sort ccode year
by ccode: sum cspdsi

*TAB 1: CORRELATION MATRIX OF DROUGHT DATA USED IN AFRICAN CONFLICT RESEARCH
corr cspdsi gpcp CRED spi

*TAB 2: DESCRIPTIVE STATISTICS (double check table)
sum onset2 l.cspdsi l.cal_day l.imr l.exclpop l.xpolity peaceyrs l.logdurable l.urban l.logpop l.loggdp lmtnest l.incid if complete~=.

****TABLE 3/FIG 2***

*MODEL 1 (unconditional effect)
logit onset2 cspdsi l.cal_day lagcspdsi lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, cluster(ccode) robust or

*MODEL 2 (food supply)
centile cal_day, centile(10 90)
logit onset2 c.cspdsi##c.l.cal_day lagcspdsi lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, cluster(ccode) robust or
*FIG 2 (left)
margins, dydx(cspdsi) at(l.cal_day=(1718(27)2528) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

*MODEL 3 (infant mortality)
logit onset2 c.cspdsi##c.l.imr lagcspdsi lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, cluster(ccode) robust or
*FIG 2 (right)
margins, dydx(cspdsi) at(l.imr=(60(5)165) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

***TABLE 4/FIG 3***

*MODEL 4 (ethnic exclusion)
logit onset2 c.cspdsi##c.l.exclpop lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.logpop peaceyrs l.incid t t2 t3, cluster(ccode) robust or
*FIG 3 (left)
margins, dydx(cspdsi) at(l.exclpop=(0(.02).8) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

*MODEL 5 (democracy, all)
logit onset2 c.cspdsi##c.l.xpolity lagcspdsi l.cal_day l.loggdp lmtnest l.urban l.logpop peaceyrs l.incid t t2 t3, cluster(ccode) robust or
*FIG 3 (center)
margins, dydx(cspdsi) at(l.xpolity=(-7(.5)5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

*MODEL 6 (democracy, stable)
logit onset2 c.cspdsi##c.l.xpolity lagcspdsi l.cal_day l.loggdp lmtnest l.urban l.logpop peaceyrs l.incid t t2 t3 if durable>3, cluster(ccode) robust or
*FIG 3 (right)
margins, dydx(cspdsi) at(l.xpolity=(-7(.5)5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

***TABLE 5/FIG 4***

*MODEL 7 (Peace Years)
logit onset2 c.cspdsi##c.peaceyrs l.cal_day l.loggdp lagcspdsi lmtnest l.exclpop l.urban l.logpop l.incid t t2 t3, cluster(ccode) robust or
*FIG 4 (left)
margins, dydx(cspdsi) at(peaceyrs=(0(1)30) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

*MODEL 8 (Political Stability)
logit onset2 c.cspdsi##c.l.logdurable lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.exclpop l.urban l.logpop l.incid t t2 t3, cluster(ccode) robust or
*FIG 4 (center)
margins, dydx(cspdsi) at(l.logdurable=(0(.25)3.5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

*MODEL 9 (Urbanization)
logit onset2 c.cspdsi##c.l.urban l.cal_day l.loggdp lagcspdsi lmtnest l.exclpop l.logpop l.incid t t2 t3, cluster(ccode) robust or
*FIG 4(right)
margins, dydx(cspdsi) at(l.urban=(0(.01).3) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

*ROBUSTNESS TESTS (Used for Figure 5)
*for each IV, the following code includes (1) the main model presented in tables 3-5, (2) xtgee model (3) time dummies, (4) interaction with no controls, (5) SPI drought data, (6) GPCP drought data, (7) CRED natural disaster data.


*LAGGED CALORIES PER DAY
centile cal_day, centile(10 90)
logit onset2 c.cspdsi##c.l.cal_day lagcspdsi lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, cluster(ccode) robust
margins, dydx(cspdsi) at(l.cal_day=(1718(27)2528) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.cspdsi##c.l.cal_day lagcspdsi lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(cspdsi) at(l.cal_day=(1718(27)2528) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.cal_day lagcspdsi lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs time1-time51, i(ccode) family(binomial) link(logit) robust
margins, dydx(cspdsi) at(l.cal_day=(1718(27)2528)) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.cal_day lagcspdsi, cluster(ccode) robust
margins, dydx(cspdsi) at(l.cal_day=(1718(27)2528)) vsquish level(90)
marginsplot, ylin(0)

gen logfood = ln(l.cal_day)
centile logfood, centile(10 90)
logit onset2 c.cspdsi##c.logfood lagcspdsi lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, cluster(ccode) robust
margins, dydx(cspdsi) at(logfood=(7.44(.02)7.84) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.spi##c.l.cal_day l.spi lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(spi) at(l.cal_day=(1718(27)2528) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.gpcp##c.l.cal_day l.gpcp lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(gpcp) at(l.cal_day=(1718(27)2528) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.CRED##c.l.cal_day l.CRED lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(CRED) at(l.cal_day=(1718(27)2528) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

*LAGGED IMR
centile imr, centile(10 90)
logit onset2 c.cspdsi##c.l.imr lagcspdsi lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, cluster(ccode) robust
margins, dydx(cspdsi) at(l.imr=(60(5)165) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.cspdsi##c.l.imr lagcspdsi lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(cspdsi) at(l.imr=(60(5)165) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.imr lagcspdsi lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs time1-time51, cluster(ccode) robust
margins, dydx(cspdsi) at(l.imr=(60(5)165)) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.imr lagcspdsi, cluster(ccode) robust
margins, dydx(cspdsi) at(l.imr=(60(5)165)) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.spi##c.l.imr l.spi lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(spi) at(l.imr=(60(5)165) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.gpcp##c.l.imr l.gpcp lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(gpcp) at(l.imr=(60(5)165) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.CRED##c.l.imr l.CRED lmtnest l.exclpop l.urban l.logpop l.loggdp l.incid peaceyrs t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(CRED) at(l.imr=(60(5)165) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

*ETHNIC EXCLUSION
logit onset2 c.cspdsi##c.l.exclpop lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.logpop peaceyrs l.incid t t2 t3, cluster(ccode) robust
margins, dydx(cspdsi) at(l.exclpop=(0(.02).8) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.cspdsi##c.l.exclpop lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.logpop peaceyrs l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(cspdsi) at(l.exclpop=(0(.02).8) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.exclpop lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.logpop peaceyrs l.incid time1-time51, cluster(ccode) robust
margins, dydx(cspdsi) at(l.exclpop=(0(.02).8)) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.exclpop lagcspdsi, cluster(ccode) robust
margins, dydx(cspdsi) at(l.exclpop=(0(.02).8)) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.spi##c.l.exclpop l.spi l.urban l.cal_day l.loggdp lmtnest l.logpop peaceyrs l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(spi) at(l.exclpop=(0(.02).8) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.gpcp##c.l.exclpop l.gpcp l.urban l.cal_day l.loggdp lmtnest l.logpop peaceyrs l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(gpcp) at(l.exclpop=(0(.02).8) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.CRED##c.l.exclpop l.CRED l.urban l.cal_day l.loggdp lmtnest l.logpop peaceyrs l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(CRED) at(l.exclpop=(0(.02).8) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

*DEMOCRACY, ALL
logit onset2 c.cspdsi##c.l.xpolity lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.urban l.logpop peaceyrs l.incid t t2 t3, cluster(ccode) robust or
margins, dydx(cspdsi) at(l.xpolity=(-7(.5)5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.cspdsi##c.l.xpolity lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.urban l.logpop peaceyrs l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(cspdsi) at(l.xpolity=(-7(.5)5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.xpolity lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.urban l.logpop peaceyrs l.incid time1-time51, cluster(ccode) robust or
margins, dydx(cspdsi) at(l.xpolity=(-7(.5)5)) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.xpolity lagcspdsi, cluster(ccode) robust or
margins, dydx(cspdsi) at(l.xpolity=(-7(.5)5)) vsquish level(90)
marginsplot, ylin(0)

*DEMOCRACY, STABLE
logit onset2 c.cspdsi##c.l.xpolity lagcspdsi l.cal_day l.loggdp lmtnest l.urban l.logpop peaceyrs l.incid t t2 t3 if durable>3, cluster(ccode) robust or
margins, dydx(cspdsi) at(l.xpolity=(-7(.5)5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.cspdsi##c.l.xpolity lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.urban l.logpop peaceyrs l.incid t t2 t3 if durable>3, i(ccode) family(binomial) link(logit) robust
margins, dydx(cspdsi) at(l.xpolity=(-7(.5)5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.xpolity lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.urban l.logpop peaceyrs l.incid time1-time51 if durable>3, cluster(ccode) robust or
margins, dydx(cspdsi) at(l.xpolity=(-7(.5)5)) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.xpolity lagcspdsi if durable>3, cluster(ccode) robust or
margins, dydx(cspdsi) at(l.xpolity=(-7(.5)5)) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.spi##c.l.xpolity l.spi l.urban l.cal_day l.loggdp lmtnest l.urban l.logpop peaceyrs l.incid t t2 t3 if durable>3, i(ccode) family(binomial) link(logit) robust
margins, dydx(spi) at(l.xpolity=(-7(.5)5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.gpcp##c.l.xpolity l.gpcp l.urban l.cal_day l.loggdp lmtnest l.urban l.logpop peaceyrs l.incid t t2 t3 if durable>3, i(ccode) family(binomial) link(logit) robust
margins, dydx(gpcp) at(l.xpolity=(-7(.5)5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.CRED##c.l.xpolity l.CRED l.urban l.cal_day l.loggdp lmtnest l.urban l.logpop peaceyrs l.incid t t2 t3 if durable>3, i(ccode) family(binomial) link(logit) robust
margins, dydx(CRED) at(l.xpolity=(-7(.5)5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

* PEACE YEARS
centile peaceyrs, centile(10 90)
logit onset2 c.cspdsi##c.peaceyrs l.cal_day l.loggdp lagcspdsi lmtnest l.exclpop l.urban l.logpop l.incid t t2 t3, cluster(ccode) robust
margins, dydx(cspdsi) at(peaceyrs=(0(1)30) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

centile peaceyrs, centile(10 90)
xtgee onset2 c.cspdsi##c.peaceyrs l.cal_day l.loggdp lagcspdsi lmtnest l.exclpop l.urban l.logpop l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(cspdsi) at(peaceyrs=(0(1)30) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.peaceyrs l.cal_day l.loggdp lagcspdsi lmtnest l.exclpop l.urban l.logpop l.incid time1-time51, cluster(ccode) robust
margins, dydx(cspdsi) at(peaceyrs=(0(1)30)) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.peaceyrs l.cal_day, cluster(ccode) robust
margins, dydx(cspdsi) at(peaceyrs=(0(1)30)) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.spi##c.peaceyrs l.cal_day l.loggdp l.spi lmtnest l.exclpop l.urban l.logpop l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(spi) at(peaceyrs=(0(1)30) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.gpcp##c.peaceyrs l.cal_day l.loggdp l.gpcp lmtnest l.exclpop l.urban l.logpop l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(gpcp) at(peaceyrs=(0(1)30) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.CRED##c.peaceyrs l.cal_day l.loggdp l.CRED lmtnest l.exclpop l.urban l.logpop l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(CRED) at(peaceyrs=(0(1)30) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

*Durability
logit onset2 c.cspdsi##c.l.logdurable lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.exclpop l.urban l.logpop l.incid t t2 t3, cluster(ccode) robust
margins, dydx(cspdsi) at(l.logdurable=(0(.25)3.5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.cspdsi##c.l.logdurable lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.exclpop l.urban l.logpop l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(cspdsi) at(l.logdurable=(0(.25)3.5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.logdurable lagcspdsi l.urban l.cal_day l.loggdp lmtnest l.exclpop l.urban l.logpop l.incid time1-time51, cluster(ccode) robust
margins, dydx(cspdsi) at(l.logdurable=(0(.25)3.5)) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.logdurable lagcspdsi, cluster(ccode) robust
margins, dydx(cspdsi) at(l.logdurable=(0(.25)3.5)) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.spi##c.l.logdurable l.spi l.urban l.cal_day l.loggdp lmtnest l.exclpop l.urban l.logpop l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(spi) at(l.logdurable=(0(.25)3.5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.gpcp##c.l.logdurable l.gpcp l.urban l.cal_day l.loggdp lmtnest l.exclpop l.urban l.logpop l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(gpcp) at(l.logdurable=(0(.25)3.5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.CRED##c.l.logdurable l.CRED l.urban l.cal_day l.loggdp lmtnest l.exclpop l.urban l.logpop l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(CRED) at(l.logdurable=(0(.25)3.5) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

* URBANIZATION
centile urban, centile(10 90)
logit onset2 c.cspdsi##c.l.urban l.cal_day l.loggdp lagcspdsi lmtnest l.exclpop l.logpop l.incid t t2 t3, cluster(ccode) robust
margins, dydx(cspdsi) at(l.urban=(0(.01).3) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.cspdsi##c.l.urban l.cal_day l.loggdp lagcspdsi lmtnest l.exclpop l.logpop l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(cspdsi) at(l.urban=(0(.01).3) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.urban l.cal_day l.loggdp lagcspdsi lmtnest l.exclpop l.logpop l.incid time1-time51, cluster(ccode) robust
margins, dydx(cspdsi) at(l.urban=(0(.01).3)) vsquish level(90)
marginsplot, ylin(0)

logit onset2 c.cspdsi##c.l.urban lagcspdsi, cluster(ccode) robust
margins, dydx(cspdsi) at(l.urban=(0(.01).3)) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.spi##c.l.urban l.cal_day l.loggdp l.spi lmtnest l.exclpop l.logpop l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(cspdsi) at(l.urban=(0(.01).3) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.gpcp##c.l.urban l.cal_day l.loggdp l.gpcp lmtnest l.exclpop l.logpop l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(cspdsi) at(l.urban=(0(.01).3) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

xtgee onset2 c.CRED##c.l.urban l.cal_day l.loggdp l.CRED lmtnest l.exclpop l.logpop l.incid t t2 t3, i(ccode) family(binomial) link(logit) robust
margins, dydx(CRED) at(l.urban=(0(.01).3) t=25 t2=625 t3=15625) vsquish level(90)
marginsplot, ylin(0)

