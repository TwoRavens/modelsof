
*Table 1

*Minimum, maximum, and mean months since previous election, sorted by provincial election type:

bysort fixed: tabstat months_since, stat(mean n sd min max)

*Significance of difference in mean months since previous election:

ttest months_since, by(fixed)

*Significance of diffence in variance in months since previous election:

robvar months_since , by(fixed)



*Figure 2 

*Significance of difference in mean change in incumbent support - initial election under fixed date legislation versus elections prior to fixed date legislation:

ttest vote_change if not_first==0, by(first_fixed)

*Significance of difference in mean change in incumbent support - subsequent elections under fixed date legislation versus elections prior to fixed date legislation:

ttest vote_change if first_fixed==0, by(not_first)

*Significance of difference in mean change in incumbent support - initial election under fixed date legislation versus subsequent elections:

ttest vote_change if fixed==1, by(not_first)


*Table 3

regress vote_change months_since months_since2 if fixed==0
regress vote_change months_since months_since2 if fixed==1


*Figure 3

qui regress vote_change months_since months_since2 if fixed==0

prvalue, x(months_since=	32	months_since2=	1024	)
prvalue, x(months_since=	36	months_since2=	1296	)
prvalue, x(months_since=	40	months_since2=	1600	)
prvalue, x(months_since=	44	months_since2=	1936	)
prvalue, x(months_since=	48	months_since2=	2304	)
prvalue, x(months_since=	52	months_since2=	2704	)
prvalue, x(months_since=	56	months_since2=	3136	)
prvalue, x(months_since=	60	months_since2=	3600	)
