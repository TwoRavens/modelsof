label var turn2 "Turnout"
label var year "Year"
label var age "Age"
label var sex "Sex"
label var pol_diff "Policy difference between parties"
label var trend "Time trend"
label var rclass4 "Social class"
label var poll "Expected closeness of the race"
label var lab_policy "Labour policy position"
label var tenure2 "Housing tenure"
label var age_sq "Age squared"
label var tu2 "Trade Union member"
label var soc_lag2 "Social difference between parties"

* model 1
xtmelogit turn2 i.rclass4 pol_diff lab_policy poll age age_sq sex tu2 tenure2 || year:, mle variance
estimate stats

* model 2 (policy diff interactions)
xtmelogit turn2 i.rclass4 pol_diff i.rclass4#c.pol_diff lab_policy poll age age_sq sex tu2 tenure2 || year:, mle variance
estimate stats
margins, dydx(rclass4) at(pol_diff=(0(10)100)) predict(mu fixedonly) vsquish

* model 3 (labour policy interactions)
xtmelogit turn2 i.rclass4 pol_diff i.rclass4#c.lab_policy lab_policy poll age age_sq sex tu2 tenure2 || year:, mle variance
estimate stats
margins, dydx(rclass4) at(lab_policy=(-50(10)10)) predict(mu fixedonly) vsquish

* model 4 (social lag interactions)
xtmelogit turn2 i.rclass4 soc_lag2 pol_diff i.rclass4#c.soc_lag2 lab_policy poll age age_sq sex tu2 tenure2 || year:, mle variance
estimate stats
margins, dydx(rclass4) at(soc_lag2=(0(10)40)) predict(mu fixedonly) vsquish

* model 5 (soc lag and lab policy interactions)
xtmelogit turn2 i.rclass4 soc_lag2 pol_diff i.rclass4#c.soc_lag2 i.rclass4#c.lab_policy lab_policy poll age age_sq sex tu2 tenure2 || year:, mle variance
estimate stats

margins, dydx(rclass4) at(soc_lag2=(0(10)40)) predict(mu fixedonly) vsquish



* appendix using BES6410 recoded

* Appendix A: linear time trend interaction

xtmelogit turn2 i.rclass4 trend i.rclass4#c.trend poll age age_sq sex tu2 tenure2 || year:, mle variance
estimate stats

