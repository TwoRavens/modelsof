**these commands produce the results in Table 1

foreach suf in arr rel wor exp tor liv pro ass sla {
tab h3`suf' year if age>=20 & age<=59 [aw=vec], col nof
}

tab f3elec year if age>=18 & age<=49 [aw=vec], col nof
tab f3env year if age>=18 & age<=49 [aw=vec], col nof

**these commands produce the results in Table 2
factor h3* if age>=20&age<=59 [aw=vec], pcf
rotate

**these commands produce the results in Table 3
mlogit civil3 vuz ssuz ptu less woman age20 hhintop3 hhinmis selfemp milpol notwork  moscow spb othlrg rural hhsize vuzxy0 age20xy0 mosxy0 spbxy0  ib2004.year if age>=20&age<=59 & year>=2001 [pw=vec], robust base(2)
mlogit mat3 vuz ssuz ptu less woman age20 i.hhinquin selfemp milpol notwork  moscow spb othlrg rural hhsize ib2004.year vuzxy0 age20xy0 mosxy0  if age>=20&age<=59 & year>=2001 [pw=vec], robust base(2)

**these commands produce the results in Table 4
mlogit f3elec vuz ssuz ptu less woman age18 i.hhinquin selfemp milpol  notwork  moscow spb othlrg rural hhsize i.year if age>=18&age<=49 [pw=vec], base(2)
margins, dydx(*)

mlogit f3env vuz ssuz ptu less woman age18 i.hhinquin selfemp milpol  notwork  moscow spb othlrg rural hhsize i.year if age>=18&age<=49 [pw=vec], base(2)
margins, dydx(*)

**these commands produce the raw data for Figures 1 and 2
tab civil3 year if age>=20&age<=59 [aw=vec], col nof
tab mat3 year if age>=20&age<=59 [aw=vec], col nof

**these commands produce the results in Table A2
mlogit civil3 vuz ssuz ptu less woman age20 i.hhinquin selfemp milpol notwork  moscow spb othlrg rural hhsize ib2004.year if age>=20&age<=59 & year>=2001 [pw=vec], robust base(2)
mlogit mat3 vuz ssuz ptu less woman age20 i.hhinquin selfemp milpol notwork  moscow spb othlrg rural hhsize ib2004.year if age>=20&age<=59 & year>=2001 [pw=vec], robust base(2)
