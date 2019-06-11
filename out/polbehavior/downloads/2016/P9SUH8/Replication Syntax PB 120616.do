*Replication Code: Panagopoulos, Leighley and Hamel: “Are Voters Mobilized by a ‘Friend-and-Neighbor’ on the Ballot? Evidence from a Field Experiment” (Political Behavior, forthcoming)

*Table 1*
bys attleboro: oneway male treatment, tab sch
bys attleboro: oneway voted12 treatment, tab sch
bys attleboro: oneway age treatment, tab sch

*Table 2*
oneway voted_ treatment if attleboro==0, tab sch
oneway voted_ treatment if Attleboro==1, tab sch
oneway voted_ treatment, tab sch

*Table 3*
xi: reg voted_n i.treatment if attleboro==0, rob
xi: reg voted_n i.treatment age male voted12 if attleboro==0, rob
xi: reg voted_n i.treatment if attleboro==1, rob
xi: reg voted_n i.treatment if age male voted12 if attleboro==1, rob
xi: reg voted_n i.treatment#attleboro, rob
xi: reg voted_n i.treatment if attleboro==0, rob
gen  _Itreatment_1Xattle= _Itreatment_1*attle, rob
gen  _Itreatment_2Xattle= _Itreatment_2*attle, rob
gen  _Itreatment_3Xattle= _Itreatment_3*attle, rob
xi: reg voted_n i.treatment attle  _Itreatment_1Xattle _Itreatment_2Xattle _Itreatment_3Xattle, rob
xi: reg voted_n i.treatment attle  _Itreatment_1Xattle _Itreatment_2Xattle _Itreatment_3Xattle age male voted12, rob
