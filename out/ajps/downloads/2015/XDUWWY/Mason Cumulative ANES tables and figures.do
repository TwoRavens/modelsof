***Cumulative ANES Tables and Figures - Mason AJPS
egen miss=rmiss(attend evangelical thermbias likebias pastactiv angercand pidstr issuestr idcomplexity educ male white age south urban)

***Table 1
///Thermometer Bias
reg thermbias idcomplexity issuestr2 educ male white age south urban attend evangelical if miss==0, cluster(year)
reg thermbias pidstr ideostr issuestr2 educ male white age south urban attend evangelical if miss==0, cluster(year)

///Like Bias
reg likebias idcomplexity issuestr2 educ male white age south urban attend evangelical if miss==0, cluster(year)
reg likebias pidstr ideostr issuestr2 educ male white age south urban attend evangelical if miss==0, cluster(year)

///Activism
reg pastactiv idcomplexity issuestr2 educ male white age south urban attend evangelical if miss==0, cluster(year)
reg pastactiv pidstr ideostr issuestr2 educ male white age south urban attend evangelical if miss==0, cluster(year)

///Anger
logit angercand idcomplexity issuestr2 educ male white age south urban attend evangelical if miss==0, cluster(year)
logit angercand pidstr ideostr issuestr2 educ male white age south urban attend evangelical if miss==0, cluster(year)

***Figure 1
tab pidstr, over(year)

tab pidstr if year==1972
tab pidstr if year==1974
tab pidstr if year==1976
tab pidstr if year==1978
tab pidstr if year==1980
tab pidstr if year==1982
tab pidstr if year==1984
tab pidstr if year==1986
tab pidstr if year==1988
tab pidstr if year==1990
tab pidstr if year==1992
tab pidstr if year==1994
tab pidstr if year==1996
tab pidstr if year==1998
tab pidstr if year==2000
tab pidstr if year==2002
tab pidstr if year==2004

mean idcomplexity, over(year)

***Figure 2
mean issuestr2 if miss==0, over(year)
mean issconstraint2 if miss==0, over(year)


***Figure 3
***PID vs sorting
reg thermbias idcomplexity pidstr issuestr2 educ male white age south urban attend evangelical if miss==0, cluster(year)
margins, at(pidstr=(1) idcomplexity=(.0857143)) vsquish
margins, at(pidstr=(1) idcomplexity=(1)) vsquish

reg likebias idcomplexity pidstr issuestr2 educ male white age south urban attend evangelical if miss==0, cluster(year)
margins, at(pidstr=(1) idcomplexity=(.0857143)) vsquish
margins, at(pidstr=(1) idcomplexity=(1)) vsquish

reg pastactiv idcomplexity pidstr issuestr2 educ male white age south urban attend evangelical if miss==0, cluster(year)
margins, at(pidstr=(1) idcomplexity=(.0857143)) vsquish
margins, at(pidstr=(1) idcomplexity=(1)) vsquish

logit angercand idcomplexity pidstr issuestr2 educ male white age south urban attend evangelical if miss==0, cluster(year)
margins, at(pidstr=(1) idcomplexity=(.0857143)) vsquish
margins, at(pidstr=(1) idcomplexity=(1)) vsquish

logit angercand idcomplexity pidstr issuestr2 educ male white age south urban attend evangelical if miss==0 & year==1992
margins, at(pidstr=(1) idcomplexity=(.0857143)) vsquish
margins, at(pidstr=(1) idcomplexity=(1)) vsquish

***Figures 4 and 5
***Cut sorting measure at approximate median
gen sortingcats2=0 if idcomplexity<.15
replace sortingcats2=1 if idcomplexity>.15

***Match on party with controls: using coarsened exact matching
cem pid issuestr2 educ male white age south urban attend evangelical, treatment(sortingcats2)

mean thermbias [iweight=cem_weights], over(sortingcats2) 
mean likebias [iweight=cem_weights], over(sortingcats2)
mean pastactiv [iweight=cem_weights], over(sortingcats2)
mean angercand [iweight=cem_weights], over(sortingcats2)

***Match on ideology with controls: using coarsened exact matching
cem ideo issuestr2 educ male white age south urban attend evangelical, treatment(sortingcats2)

mean thermbias [iweight=cem_weights], over(sortingcats2)
mean likebias [iweight=cem_weights], over(sortingcats2)
mean pastactiv [iweight=cem_weights], over(sortingcats2)
mean angercand [iweight=cem_weights], over(sortingcats2)

***Figure 6
reg issuestr2 idcomplexity educ male white age south urban attend evangelical if miss==0, cluster(year)
margins, at(idcomplexity=(0)) vsquish
margins, at(idcomplexity=(1)) vsquish

reg thermbias idcomplexity educ male white age south urban attend evangelical if miss==0, cluster(year)
margins, at(idcomplexity=(0)) vsquish
margins, at(idcomplexity=(1)) vsquish

reg likebias idcomplexity educ male white age south urban attend evangelical if miss==0, cluster(year)
margins, at(idcomplexity=(0)) vsquish
margins, at(idcomplexity=(1)) vsquish

reg pastactiv idcomplexity educ male white age south urban attend evangelical if miss==0, cluster(year)
margins, at(idcomplexity=(0)) vsquish
margins, at(idcomplexity=(1)) vsquish

logit angercand idcomplexity educ male white age south urban attend evangelical if miss==0, cluster(year)
margins, at(idcomplexity=(0)) vsquish
margins, at(idcomplexity=(1)) vsquish

