

use michigan_data

*Appendix Table A7

sum ice income age male white black married numkid numadt realincup inex finnowbad more_expenses_debt [aw=wt]


*Table 4

*PANEL A

xi:areg realincup lma380  $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg realincup lma380 lma350 lma320 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg realincup lma390 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg realincup lma390 lma350 lma320 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)

*PANEL  B

xi:areg inex lma380  $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg inex lma380 lma350 lma320 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg inex lma390 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg inex lma390 lma350 lma320 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)

*PANEL  C

xi:areg ice lma380  $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg ice lma380 lma350 lma320 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg ice lma390 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg ice lma390 lma350 lma320 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)



*Appendix Table B2

*PANEL A


xi:areg finnowbad lma380  $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg finnowbad lma380 lma350 lma320 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg finnowbad lma390 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg finnowbad lma390 lma350 lma320 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)

*PANEL B

xi:areg more_expenses_debt lma380  $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg more_expenses_debt lma380 lma350 lma320 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg more_expenses_debt lma390 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)
xi:areg more_expenses_debt lma390 lma350 lma320 $controls i.state i.year  [aw=wt],a(inc_buck) cluster(state)







