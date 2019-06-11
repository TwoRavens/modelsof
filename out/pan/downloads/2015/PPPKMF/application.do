


xtreg d.scaledideal l.scaledideal d.ennstransform lc.ennstransform##i.preelection lc.ennstransform##i.retireyear i.fips if selection==1,
estimates store m1

xtreg d.scaledideal l.scaledideal d.ennstransform lc.ennstransform##i.preelection lc.ennstransform##i.retireyear i.fips if selection==2,

estimates store m2


xtreg d.scaledideal l.scaledideal d.ennstransform lc.ennstransform##i.preelection lc.ennstransform##i.retireyear i.fips if selection==3,

estimates store m3

xtreg d.scaledideal l.scaledideal d.ennstransform lc.ennstransform##i.retireyear i.fips if selection==4,
estimates store m4



