ologit Run Empfant01-Empdist01 i.Negbase i.Negbase#c.Empfant01 i.Negbase#c.Emppers01 i.Negbase#c.Empconc01 i.Negbase#c.Empdist01 PIDext SES Male Hisp Black Other age
margins, at(Emppers01=(0(.10)1) Negbase=(0(1)2) Male=0 Black=0 Hisp=0 Other=0) predict(outcome(1))

matrix list r(b)
matrix PT=r(b)'
matrix value=(0\.1\.2\.3\.4\.5\.6\.7\.8\.9\1)#(1\1\1)
matrix treat=(1\1\1\1\1\1\1\1\1\1\1)#(0\1\2)
matrix pvt=value, treat, PT
svmat pvt, names(pvt)
gen ptgraph=1-pvt3


twoway (line ptgraph pvt1 if pvt2==0, sort) (line ptgraph pvt1 if pvt2==1, sort) (line ptgraph pvt1 if pvt2==2, sort)


ologit Run Empfant01-Empdist01 i.Negbase i.Negbase#c.Empfant01 i.Negbase#c.Emppers01 i.Negbase#c.Empconc01 i.Negbase#c.Empdist01 PIDext SES Male Hisp Black Other age
margins, at(Empdist01=(0(.10)1) Negbase=(0(1)2) Male=0 Black=0 Hisp=0 Other=0) predict(outcome(1))

matrix list r(b)
matrix PD=r(b)'
matrix dvt=value, treat, PD
svmat dvt, names(dvt)
gen pdgraph=1-dvt3


twoway (line pdgraph dvt1 if dvt2==0, sort) (line pdgraph dvt1 if dvt2==1, sort) (line pdgraph dvt1 if dvt2==2, sort)


ologit Run Empfant01-Empdist01 i.Negbase i.Negbase#c.Empfant01 i.Negbase#c.Emppers01 i.Negbase#c.Empconc01 i.Negbase#c.Empdist01 PIDext SES Male Hisp Black Other age
margins, at(Empconc01=(0(.10)1) Negbase=(0(1)2) Male=0 Black=0 Hisp=0 Other=0) predict(outcome(1))

matrix list r(b)
matrix EC=r(b)'
matrix value=(0\.1\.2\.3\.4\.5\.6\.7\.8\.9\1)#(1\1\1)
matrix treat=(1\1\1\1\1\1\1\1\1\1\1)#(0\1\2)
matrix evt=value, treat, EC
svmat evt, names(evt)
gen ecgraph=1-evt3


twoway (line ecgraph evt1 if evt2==0, sort) (line ecgraph evt1 if evt2==1, sort) (line ecgraph evt1 if evt2==2, sort)

//edited in graph editor and merged using grc1leg//
