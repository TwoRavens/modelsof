* This do file will replicate the analysis in "Who Wants to be a Major Power?"
* It should be run on the data in the accompanying data file using Stata 11

* The full dataset is used for the analysis of overall military capability
* and power projection.

xtset statenum year
* Table II, first column
xtregar lnmilshare lntbdeaths lncwdeaths lneconshare1, fe
* Table II, second column
xtregar powerproj lntbdeaths lncwdeaths lneconshare1, fe

* Table II, fourth column
xtregar lnmilshare lntbdeaths lncwdeaths lneconshare1 lneconshare21, fe
test lneconshare1 lneconshare21
* Table II, fifth column
xtregar powerproj lntbdeaths lncwdeaths lneconshare1 lneconshare21, fe


* Table II, seventh column
xtregar lnmilshare lntbdeaths lncwdeaths lneconshare1 lneconrank1, fe
* Table II, eighth column
xtregar powerproj lntbdeaths lncwdeaths lneconshare1 lneconrank1, fe

* Note that replication code for Table II, columns 3, 6, and 9 is below

* Table III, column 1
xtregar lnmilshare lntbdeaths lncwdeaths lneconshare1 lnopen1 interactlno1 lnatopthreat1 interactat1, fe
test lnopen1 interactlno1
test lnatopthreat1 interactat1

* Table III, column 2
xtregar powerproj lntbdeaths lncwdeaths lneconshare1 lnopen1 interactlno1 lnatopthreat1 interactat1, fe
test lnopen1 interactlno1
test lnatopthreat1 interactat1

* Note that replication code for Table III, column 3 is below


* Only a portion of the dataset is used for the analysis of diplomatic activism
gen time=year
recode time (1817=1) (1824=2) (1827=3) (1832=4) (1836=5) (1840=6) (1844=7) (1849=8) (1854=9) (1859=10) (1864=11) (1869=12) (1874=13) (1879=14) (1884=15) (1889=16) (1894=17) (1899=18) (1904=19) (1909=20) (1914=21) (1920=22) (1925=23) (1930=24) (1935=25) (1940=26) (1950=27) (1955=28) (1960=29) (1965=30) (1970=31) (1975=32) (1980=33) (1985=34) (1990=35) (1995=36) (2000=37) (2005=38)
drop if time>100
xtset statenum time

* Table II, column 3
xtregar lnrepprop lneconshare1, fe

* Table II, column 6
xtregar lnrepprop lneconshare1 lneconshare21, fe
test lneconshare1 lneconshare21

* Table II, column 9
xtregar lnrepprop lneconshare1 lneconrank1, fe

* Table III, column 3
xtregar lnrepprop lneconshare1 lnopen1 interactlno1 lnatopthreat1 interactat1, fe
test lnopen1 interactlno1
test lnatopthreat1 interactat1 
