*use "RP_replication_country.dta"
set more off

* TABLE 1 MODEL 1 (any purge)
logit recur anypurge victory duration battledeaths peacekeepers milregime leadertenure population gdp imr postcold peaceyears peaceyears2 peaceyears3, cluster(ccode)

* TABLE 1 MODEL 2 (high-level officer purge w/o cabinet reshuffling)
logit recur toppurge victory duration battledeaths peacekeepers milregime leadertenure population gdp imr postcold peaceyears peaceyears2 peaceyears3, cluster(ccode)
estat ic

* FIGURE 1
coefplot, nolabels drop(_cons) xline(0) graphregion(color(white)) 

* predicted probabilities
estsimp logit recur toppurge victory duration battledeaths peacekeepers milregime leadertenure population gdp imr postcold peaceyears peaceyears2 peaceyears3, cluster(ccode)
setx toppurge 0 (victory peacekeepers milregime postcold) median (duration battledeaths leadertenure population gdp imr postcold peaceyears*) mean
simqi
setx toppurge 1 (victory peacekeepers milregime postcold) median (duration battledeaths leadertenure population gdp imr postcold peaceyears*) mean
simqi
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15


**** APPENDIX

* TABLE A1 (summary stats)
sutex toppurge anypurge purget2 purget3 purget4 purgedecay victory duration battledeaths peacekeepers milregime leadertenure population gdp imr postcold peaceyears peaceyears2 peaceyears3, minmax

* TABLE A2 MODEL 3 (Cox)
stset peaceyears, failure(recur)
stcox toppurge victory duration battledeaths peacekeepers milregime leadertenure population gdp imr postcold, nohr cluster(ccode)
estat ic

* TABLE A3 MODEL 4 (2 years after purge)
logit recur purget2 victory duration battledeaths peacekeepers milregime leadertenure population gdp imr postcold peaceyears peaceyears2 peaceyears3, cluster(ccode)
estat ic 

* TABLE A3 MODEL 5 (3 years after purge)
logit recur purget3 victory duration battledeaths peacekeepers milregime leadertenure population gdp imr postcold peaceyears peaceyears2 peaceyears3, cluster(ccode)
estat ic

* TABLE A3 MODEL 6 (4 years after purge)
logit recur purget4 victory duration battledeaths peacekeepers milregime leadertenure population gdp imr postcold peaceyears peaceyears2 peaceyears3, cluster(ccode)
estat ic

* TABLE A3 MODEL 7 (1-4 years after purge)
logit recur toppurge purget2 purget3 purget4 victory duration battledeaths peacekeepers milregime leadertenure population gdp imr postcold peaceyears peaceyears2 peaceyears3, cluster(ccode)
estat ic

* TABLE A4 MODEL 8 (purge decay fn)
logit recur purgedecay victory duration battledeaths peacekeepers milregime leadertenure population gdp imr postcold peaceyears peaceyears2 peaceyears3, cluster(ccode)
estat ic


*use "RP_replication_conflict.dta"

* TABLE A5 MODEL 9 (high level officer purge, conflict-year unit of analysis)
logit recur toppurge victory duration battledeaths peacekeepers milregime leadertenure population gdp imr postcold peaceyears*, cluster(country)

* TABLE A5 MODEL 10 (purge decay fn, conflict-year unit of analysis)
logit recur purgedecay victory duration battledeaths peacekeepers milregime leadertenure population gdp imr postcold peaceyears*, cluster(country)
