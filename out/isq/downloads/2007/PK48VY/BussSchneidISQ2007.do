/* analyses reported in "When Globalization Discontent Turns Violent", ISQ 2007*/

use Analysen\CivilWar\BussmannSchneiderISQ2007



*TESTS REPORTED IN TABLE 2 OF THE ARTICLE

logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade Lprotecttrade , robust cluster(state)
	estat ic
	estat clas

logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc LibTRADE, robust cluster(state)
	estat ic
	estat clas

logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade Linflowpgdp , robust cluster(state)
	estat ic
	estat clas

logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade Linflowpgdp if OECD==0, robust cluster(state)
	estat ic
	estat clas


*TESTS REPORTED IN TABLE 3 OF THE ARTICLE

logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Legini  Lopenc Lliberaltrade, robust cluster(state)
 	estat ic
	estat clas

logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lgovtcsmp Lgrgovtcsmp Lopenc Lliberaltrade, robust cluster(state)
	estat ic
	estat clas


logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade LcIMFflows LncIMFflows , robust cluster(state)
	estat ic
	estat clas

logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade Loda , robust cluster(state)
	estat ic
	estat clas


*CALCULATION OF SUBSTANTIVE EFFECTS WITH CLARIFY
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade Linflowpgdp, robust cluster(state)
sum Lopenc if e(sample), detail
sum Lliberaltrade if e(sample), detail
sum Linflowpgdp  if e(sample), detail
sum Llrgdpch if e(sample), detail

estsimp logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade Linflowpgdp, robust cluster(state)
setx mean
setx Lpriecwdum 0
simqi
simqi, fd(prval(1)) changex(Lopenc p25 p75)
simqi, fd(prval(1)) changex(Lliberaltrade p25 p75)

simqi, fd(prval(1)) changex(Lliberaltrade 0 0.1 Lopenc 67 73.7)
simqi, fd(prval(1)) changex(Lliberaltrade 0 0.1 Lopenc 41 45.1) /* Lopenc from 25th %*/
simqi, fd(prval(1)) changex(Lliberaltrade 0 0.1 Lopenc 83 91.3)  /* Lopenc from 75th %*/

simqi, fd(prval(1)) changex(Linflowpgdp p25 p75)
simqi, fd(prval(1)) changex(Llrgdpch p25 p75)


* ADDITIONAL TESTS REPORTED IN FOOTNOTES OR IN THE TEXT BUT WITHOUT TABLES

*FOOTNOTE 5
xtlogit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade, re
xtlogit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade, fe
xtgee onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade, family(bin) link(logit) corr(ar1) force robust nolog

*FOOTNOTE 12 
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lcliberaltrade , robust cluster(state)

*FOOTNOTE 15
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade if year>1979, robust cluster(state)

*FOOTNOTE 16
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum  nowaryrs _spline* Linflowpgdp Lliberalfdi, robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum  nowaryrs _spline* Linflowpgdp Lprotectfdi, robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum  nowaryrs _spline* Linflowpgdp LibCAPITAL, robust cluster(state)

*FOOTNOTE 18
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lgini  Lopenc Lliberaltrade, robust cluster(state)

*FOOTNOTE 19
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lgovtcsmp Lopenc Lliberaltrade, robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lgrgovtcsmp Lopenc Lliberaltrade, robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lgovtcsmp Lgrgovtcsmp Lmilexgdp Lopenc Lliberaltrade, robust cluster(state)
 
*FOOTNOTE 20
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade LncIMFflows , robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade LcIMFflows , robust cluster(state)

*TESTS WITH LONGER LAGS
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* L3openc L3liberaltrade, robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* L5openc L5liberaltrade, robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* L10openc L10liberaltrade, robust cluster(state)

*INFLUENTIAL POINTS
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade, robust cluster(state)
sum Lopenc Lliberaltrade if e(sample), detail
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade if Lliberaltrade <3, robust cluster(state)


*TESTS REPORTED IN THE WEB APPENDIX
*TESTS FOR COLLINEARITY
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade , robust cluster(state)
logit onset  Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade , robust cluster(state)
logit onset Ldemo Ldemo2 lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade , robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade , robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade , robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 nowaryrs _spline* Lopenc Lliberaltrade , robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum Lopenc Lliberaltrade , robust cluster(state)

*TESTS WITH ADDITIONAL CONTROL VARIABLES
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade mtnest, robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade ethfrac, robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade DURABLE , robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade Lmilper, robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade instab, robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade inflat, robust cluster(state)

*TESTS WITH REGIONAL DUMMIES AND SPLIT SAMPLE
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade LatinAmerica Africa MiddleEast Asia, robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade if year<1974, robust cluster(state)
logit onset Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowaryrs _spline* Lopenc Lliberaltrade if year>1973, robust cluster(state)

*TESTS WITH VARIOUS LEVELS OF CIVIL WAR
drop _spline*
btscs civwarmed year state, gen (nowarmedyrs) nspline(3)
logit onsetmed Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowarmedyrs _spline* Lopenc Lliberaltrade , robust cluster(state)

drop _spline*
btscs civwarwar year state, gen (nowarwaryrs) nspline(3)
logit onsetwar Ldemo Ldemo2 Llrgdpch lpop growth1 Lpriecwdum nowarwaryrs _spline* Lopenc Lliberaltrade , robust cluster(state)

drop _spline* nowaryrs
btscs civwar year state, gen (nowaryrs) nspline(3)


