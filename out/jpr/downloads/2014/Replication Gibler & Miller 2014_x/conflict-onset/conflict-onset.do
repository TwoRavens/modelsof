label variable hadispute "Territorial Claim"
label variable hadpeaceyr "Territorial Claim Peace Year"
label variable posthad0 "Post-Territorial Claim, Year 0"
label variable posthad0to9 "Post-Territorial Claim, Years 0-9"
label variable posthad1to9 "Post-Territorial Claim, Years 1-9"
label variable posthad10to19 "Post-Territorial Claim, Years 10-19"
label variable posthad20plus "Post-Territorial Claim, Years 20+"
label variable posthad1to5 "Post-Territorial Claim, Years 1-5"
label variable posthad6to10 "Post-Territorial Claim, Years 6-10"
label variable posthad1to10 "Post-Territorial Claim, Years 1-10"
label variable posthad11plus "Post-Territorial Claim, Years 11+"
label variable posthad1to15 "Post-Territorial Claim, Years 1-15"
label variable posthad16to30 "Post-Territorial Claim, Years 16-30"
label variable posthad31plus "Post-Territorial Claim, Years 31+"
label variable udsmean "UDS Democracy Score"
label variable udsinstab "Political Instability"
label variable udsmean2 "UDS Democracy Score$^2$"
label variable oil "Oil"
label variable ethfrac "Ethnic Fractionalization"
label variable relfrac "Religious Fractionalization"
label variable ncontig "Non-Contiguous State"
label variable nwstate "New State"
label variable newlmtnest "Mountainous Terrain"
label variable ethnic "Ethnic Fractionalization (Alesina et al.)"
label variable religion "Religious Fractionalization (Alesina et al.)"
label variable ucdpterrconf "UCDP Territorial Conflict"
label variable exprgdpols "GDP (lagged)"
label variable logtpop "Population (lagged)"
label variable logeconaid "U.S. Economic Aid"
label variable logmilitaid "U.S. Military Aid"

btscs  ucdpgovintraconflict year ccode, gen(ucdppeaceyr) nspline(3)
rename _spline* ucdpspline*



xtset ccode year


logit cowcw4onset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if L1.cowcw4ongoing == 0 , cluster(ccode)
est sto m1
logit cowcw4onset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute posthad1to15 posthad16to30 cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if L1.cowcw4ongoing == 0, cluster(ccode)
est sto m2

logit ucdpgovintraonset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3 if L1.ucdpgovintraconflict == 0, cluster(ccode)
est sto m3
logit ucdpgovintraonset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute posthad1to15 posthad16to30 ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3 if L1.ucdpgovintraconflict == 0, cluster(ccode)
est sto m4

esttab m1 m2 m3 m4 using "tables/table2.tex", starlevels($\dagger$ 0.10 * 0.05 ** 0.01 *** 0.001) label tex replace b(%10.3f) se title("The Effects of External Territorial Threat on Intrastate Conflict Onset")

estsimp logit cowcw4onset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute posthad1to15 posthad16to30 cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if L1.cowcw4ongoing == 0, cluster(ccode) genname(cowb)

setx mean
simqi, listx level(90)

setx mean
setx L1.hadispute 0
simqi, listx level(90)
simqi, fd(pr) changex(L1.hadispute mean 0) level(90)

setx mean
setx L1.hadispute 1
simqi, listx level(90)
simqi, fd(pr) changex(L1.hadispute mean 1) level(90)

setx mean
setx posthad1to15 1
simqi, listx level(90)
simqi, fd(pr) changex(posthad1to15 mean 1) level(90)


setx mean
setx posthad16to30 1
simqi, listx level(90)
simqi, fd(pr) changex(posthad16to30 mean 1) level(90)



estsimp logit  ucdpgovintraonset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute posthad1to15 posthad16to30 ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3 if L1.ucdpgovintraconflict == 0, cluster(ccode) genname(ucdpb)

setx mean
simqi, listx level(90)

setx mean
setx L1.hadispute 0
simqi, listx level(90)
simqi, fd(pr) changex(L1.hadispute mean 0) level(90)

setx mean
setx L1.hadispute 1
simqi, listx level(90)
simqi, fd(pr) changex(L1.hadispute mean 1) level(90)

setx mean
setx posthad1to15 1
simqi, listx level(90)
simqi, fd(pr) changex(posthad1to15 mean 1) level(90)


setx mean
setx posthad16to30 1
simqi, listx level(90)
simqi, fd(pr) changex(posthad16to30 mean 1) level(90)









by ccode: gen l1cowcw4ongoing =cowcw4ongoing[_n-1]
by ccode: gen l1exprgdpols=exprgdpols[_n-1]
by ccode: gen l1logtpop =logtpop[_n-1]
by ccode: gen l1udsmean =udsmean[_n-1]
by ccode: gen l1udsmean2 =udsmean2[_n-1]
by ccode: gen l1hadispute=hadispute[_n-1]
by ccode: gen l1logeconaid =logeconaid[_n-1]
by ccode: gen l1logmilitaid =logmilitaid[_n-1]

label variable l1cowcw4ongoing "Ongoing Civil War (lagged)"
label variable l1exprgdpols "GDP (lagged)"
label variable l1logtpop "Population (lagged)"
label variable l1udsmean "UDS Democracy Score (lagged)"
label variable l1udsmean2 "UDS Democracy Score$^2$ (lagged)"
label variable l1hadispute "Territorial Claim"
label variable l1logeconaid "U.S. Economic Aid (lagged)"
label variable l1logmilitaid "U.S. Military Aid (lagged)"


relogit cowcw4onset  l1exprgdpols l1logtpop newlmtnest ncontig oil l1udsmean l1udsmean2 udsinstab ethnic religion  l1hadispute cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if l1cowcw4ongoing == 0, cluster(ccode)
est sto m5
relogit cowcw4onset l1exprgdpols l1logtpop newlmtnest ncontig oil l1udsmean l1udsmean2 udsinstab ethnic religion l1hadispute posthad1to15 posthad16to30 cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if l1cowcw4ongoing == 0, cluster(ccode)
est sto m6
relogit ucdpgovintraonset l1exprgdpols l1logtpop newlmtnest ncontig oil l1udsmean l1udsmean2 udsinstab ethnic religion l1hadispute ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3  if L1.ucdpgovintraconflict == 0, cluster(ccode)
est sto m7
relogit ucdpgovintraonset l1exprgdpols l1logtpop newlmtnest ncontig oil l1udsmean l1udsmean2 udsinstab ethnic religion l1hadispute posthad1to15 posthad16to30 ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3  if L1.ucdpgovintraconflict == 0, cluster(ccode)
est sto m8

esttab m5 m6 m7 m8 using "tables/table1appendix.tex", starlevels($\dagger$ 0.10 * 0.05 ** 0.01 *** 0.001) label tex replace b(%10.3f) se title("The Effects of External Territorial Threat on Intrastate Conflict Onset (Rare Events Logit)")



logit cowcw4onset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethfrac relfrac L1.hadispute cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if L1.cowcw4ongoing == 0 , cluster(ccode)
est sto m9
logit cowcw4onset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethfrac relfrac L1.hadispute posthad1to15 posthad16to30 cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if L1.cowcw4ongoing == 0, cluster(ccode)
est sto m10

logit ucdpgovintraonset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethfrac relfrac L1.hadispute ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3 if L1.ucdpgovintraconflict == 0, cluster(ccode)
est sto m11
logit ucdpgovintraonset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethfrac relfrac L1.hadispute posthad1to15 posthad16to30 ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3 if L1.ucdpgovintraconflict == 0, cluster(ccode)
est sto m12

esttab m9 m10 m11 m12 using "tables/table2appendix.tex", starlevels($\dagger$ 0.10 * 0.05 ** 0.01 *** 0.001) label tex replace b(%10.3f) se title("The Effects of External Territorial Threat on Intrastate Conflict Onset")



logit cowcw4onset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute posthad20plus cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if L1.cowcw4ongoing == 0 , cluster(ccode)
est sto m13
logit cowcw4onset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute posthad31plus cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if L1.cowcw4ongoing == 0 , cluster(ccode)
est sto m14

logit ucdpgovintraonset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute posthad20plus ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3 if L1.ucdpgovintraconflict == 0, cluster(ccode)
est sto m15
logit ucdpgovintraonset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute posthad31plus ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3 if L1.ucdpgovintraconflict == 0, cluster(ccode)
est sto m16

esttab m13 m14 m15 m16 using "tables/table3appendix.tex", starlevels($\dagger$ 0.10 * 0.05 ** 0.01 *** 0.001) label tex replace b(%10.3f) se title("The Effects of External Territorial Threat on Intrastate Conflict Onset")

logit cowcw4onset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if L1.cowcw4ongoing == 0 & ccode > 400 & ccode < 600, cluster(ccode)
est sto m17
logit cowcw4onset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute posthad1to15 posthad16to30 cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if L1.cowcw4ongoing == 0 & ccode > 400 & ccode < 600, cluster(ccode)
est sto m18

logit ucdpgovintraonset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3 if L1.ucdpgovintraconflict == 0 & ccode > 400 & ccode < 600, cluster(ccode)
est sto m19
logit ucdpgovintraonset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.hadispute posthad1to15 posthad16to30 ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3 if L1.ucdpgovintraconflict == 0 & ccode > 400 & ccode < 600, cluster(ccode)
est sto m20

esttab m17 m18 m19 m20 using "tables/table4appendix.tex", starlevels($\dagger$ 0.10 * 0.05 ** 0.01 *** 0.001) label tex replace b(%10.3f) se title("The Effects of External Territorial Threat on Intrastate Conflict Onset in Sub-Saharan Africa")


logit cowcw4onset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.logeconaid L1.logmilitaid L1.hadispute cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if L1.cowcw4ongoing == 0 & ccode != 2, cluster(ccode)
est sto m21
logit cowcw4onset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.logeconaid L1.logmilitaid L1.hadispute posthad1to15 posthad16to30 cowcw4peaceyr cowcw4spline1 cowcw4spline2 cowcw4spline3 if L1.cowcw4ongoing == 0 & ccode != 2, cluster(ccode)
est sto m22

logit ucdpgovintraonset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.logeconaid L1.logmilitaid L1.hadispute ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3 if L1.ucdpgovintraconflict == 0 & ccode != 2, cluster(ccode)
est sto m23
logit ucdpgovintraonset L1.exprgdpols L1.logtpop newlmtnest ncontig oil L1.udsmean L1.udsmean2 udsinstab ethnic religion L1.logeconaid L1.logmilitaid L1.hadispute posthad1to15 posthad16to30 ucdppeaceyr ucdpspline1 ucdpspline2 ucdpspline3 if L1.ucdpgovintraconflict == 0 & ccode != 2, cluster(ccode)
est sto m24

esttab m21 m22 m23 m24 using "tables/table5appendix.tex", starlevels($\dagger$ 0.10 * 0.05 ** 0.01 *** 0.001) label tex replace b(%10.3f) se title("The Effects of External Territorial Threat on Intrastate Conflict Onset")



