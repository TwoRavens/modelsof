*** Open the locality dataset in Stata

***Model 1
btscs attackdummy monthcount OBJECTID, g(peaceyrs) nspline(3)
nbreg unamidattack  civtarget pkbase armedclash disputed mountain majortown peaceyrs, vce(cluster OBJECTID)

*** Open the locality dataset in Stata

***Model 2
btscs intimidationobstructiondummy monthcount OBJECTID, g(peaceyrs) nspline(3)
nbreg intimidationobstruction civtarget pkbase armedclash disputed mountain majortown peaceyrs, vce(cluster OBJECTID)
margins, at(civtarget=(0(1)10))

***Model 3
logit intimidationobstructiondummy civtarget pkbase armedclash disputed mountain majortown peaceyrs, vce(cluster OBJECTID)
margins, at(civtarget=(0(1)10))

***Model 4
imb pkbase armedclash disputed mountain majortown peaceyrs, treatment(civtargetdummy)
cem pkbase armedclash disputed mountain majortown peaceyrs, treatment(civtargetdummy)
nbreg intimidationobstruction civtargetdummy pkbase armedclash disputed mountain majortown peaceyrs [iweight=cem_weights], vce(cluster OBJECTID)

***Robustness check - fixed effects
xtset OBJECTID monthcount
xtnbreg intimidationobstruction civtarget pkbase armedclash disputed mountain majortown, fe

***Robustness check - El Malha
drop OBJECTID 101
btscs intimidationobstructiondummy monthcount OBJECTID, g(peaceyrs) nspline(3)
nbreg intimidationobstruction civtarget pkbase armedclash disputed mountain majortown peaceyrs, vce(cluster OBJECTID)

***Robustness check - impact on resistance in general
replace resistance = unamidattack + intimidationobstruction
btscs resistance monthcount OBJECTID, g(peaceyrs) nspline(3)
nbreg resistance civtarget pkbase armedclash disputed mountain majortown peaceyrs, vce(cluster OBJECTID)

*** Open the GRID dataset in Stata

*** Model 5
btscs intimidationobstructiondummy monthcount gid, g(peaceyrs) nspline(3)
nbreg intimidationobstruction civtarget pkbase armedclash mountains urban peaceyrs, vce(cluster gid)

*** Open the Duration dataset in Stata

*** Model 6
stset futureintimidationobstructionday, failure(futureintimidationobstruction)
stcox civtarget pkbase armedclash disputed mountain majortown, vce(cluster OBJECTID) nohr
graph set window fontface "Times New Roman"
sts graph, by(civtarget) saving(6)
sts list, by(civtarget)
sts gen surv = s, by(civtarget)

*** Model 7
stset futurecivtargetdays, failure(futurecivtarget)
stcox  intimidationobstruction pkbase armedclash disputed mountain majortown, vce(cluster OBJECTID) nohr
graph set window fontface "Times New Roman"
sts graph, by(intimidationobstruction) saving(7)
sts list, by(intimidationobstruction)
sts gen surv = s, by(intimidationobstruction)
gr combine 6.gph 7.gph 

***Robustness check - time
btscs intimidationobstruction date OBJECTID, g(peaceyrs) nspline(3)
gen peaceyrs2 = peaceyrs^2
gen peaceyrs3 = peaceyrs^3
gen civtargetXpeaceyrs = civtarget*peaceyrs
gen pkbaseXpeaceyrs = pkbase*peaceyrs
gen armedclashXpeaceyrs = armedclash*peaceyrs
gen disputedXpeaceyrs = disputed*peaceyrs
gen mountainXpeaceyrs = mountain*peaceyrs
gen majortownXpeaceyrs = majortown*peaceyrs
stset futureintimidationobstructionday, failure(futureintimidationobstruction)
stcox civtarget pkbase armedclash disputed mountain majortown civtargetXpeaceyrs pkbaseXpeaceyrs armedclashXpeaceyrs disputedXpeaceyrs mountainXpeaceyrs majortownXpeaceyrs peaceyrs peaceyrs2 peaceyrs3, vce(cluster OBJECTID) nohr

***Robustness check - time
btscs civtarget date OBJECTID, g(peaceyrs) nspline(3)
gen peaceyrs2 = peaceyrs^2
gen peaceyrs3 = peaceyrs^3
gen intimidationobstructionXpeaceyrs = intimidationobstruction*peaceyrs
gen pkbaseXpeaceyrs = pkbase*peaceyrs
gen armedclashXpeaceyrs = armedclash*peaceyrs
gen disputedXpeaceyrs = disputed*peaceyrs
gen mountainXpeaceyrs = mountain*peaceyrs
gen majortownXpeaceyrs = majortown*peaceyrs
stset futurecivtargetdays, failure(futurecivtarget)
stcox  intimidationobstruction pkbase armedclash disputed mountain majortown intimidationobstructionXpeaceyrs pkbaseXpeaceyrs armedclashXpeaceyrs disputedXpeaceyrs mountainXpeaceyrs majortownXpeaceyrs peaceyrs peaceyrs2 peaceyrs3, vce(cluster OBJECTID) nohr
