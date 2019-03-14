* Regression tables to Latex (http://repec.sowi.unibe.ch/stata/estout/)

ssc install estout, replace


*See Logit Random Effects Models https://www.stata.com/manuals13/xtxtlogit.pdf

use "/Users/wooaesil/Dropbox/UC Merced/WooCon - JOP/JOP/Final Submission/Replication Files/woocon16forclustering.dta"

* Running Random Effects Models with Cluster SEs

* Unmatched sample
xtset ccode

xtlogit CoupsBi lpartyBi grgdpch rgdpch openk nmil comm ColdWar, re vce(cluster ccode)
est sto m1

xtlogit AntiGovDemBi lpartyBi grgdpch rgdpch openk nmil comm ColdWar, re vce(cluster ccode)
est sto m2

xtlogit RiotsBi lpartyBi grgdpch rgdpch openk nmil comm ColdWar, re vce(cluster ccode)
est sto m3

* Matched sample (using weights from the CEM)

xtlogit CoupsBi lpartyBi grgdpch rgdpch openk nmil comm ColdWar weight, re vce(cluster ccode)
est sto m4

xtlogit AntiGovDemBi lpartyBi grgdpch rgdpch openk nmil comm ColdWar weight, re vce(cluster ccode)
est sto m5

xtlogit RiotsBi lpartyBi grgdpch rgdpch openk nmil comm ColdWar weight, re vce(cluster ccode)
est sto m6

esttab m1 m2 m3 m4 m5 m6, se aic obslast scalar(F) bic r2

esttab m1 m2 m3 m4 m5 m6 using "you directory/file.tex", se title("The Relationship Between Dictatorial Legislatures and Dissent") unstack replace




