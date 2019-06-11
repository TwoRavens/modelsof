set mem 1000M
use "anes data.dta"

** Table 2 **

reg affective_polarization  c.polarization education pid7 ideology  age female same_party i.race i.cong,cl(cluster)
reg affective_polarization  c.polarization##c.extreme education pid7 ideology  age female same_party i.race i.cong,cl(cluster)
reg affective_polarization  c.polarization##i.interest education pid7 ideology  age female same_party i.race i.cong,cl(cluster)
