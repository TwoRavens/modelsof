quietly tab year, gen(yr)


**MINIMAL**

xtreg binding l.binding ally ally_atc atc yr* if wto==1, cluster(ccode)

prais binding ally ally_atc atc yr* if wto==1, cluster(ccode)



**FULL MODEL**

xtreg binding l.binding ally ally_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1, cluster(ccode)

prais binding ally ally_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1, cluster(ccode)



**NETWORK MEASURE**

xtreg binding l.binding portfolio portfolio_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1, cluster(ccode)

prais binding portfolio portfolio_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1, cluster(ccode)



**DEFENSE PACTS**

xtreg binding l.binding defense defense_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1, cluster(ccode)

prais binding defense defense_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1, cluster(ccode)



**DEFENSE PACTS, NO POSTCOMM**

xtreg binding l.binding defense defense_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1 & postcomm==0, cluster(ccode)

prais binding defense defense_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1 & postcomm==0, cluster(ccode)



**NONAGGRESSION PACTS**

xtreg binding l.binding nonagg nonagg_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1, cluster(ccode)

prais binding nonagg nonagg_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1, cluster(ccode)



**NO POSTCOMMUNIST COUNTRIES**

xtreg binding l.binding ally ally_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1 & postcomm==0, cluster(ccode)

prais binding ally ally_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1 & postcomm==0, cluster(ccode)



**CONSTANT WTO MEMBERSHIP**

xtreg binding l.binding ally ally_atc pta atc gdppc gdp democ xrover comlang yr* if wto_preatc==1, cluster(ccode)

prais binding ally ally_atc pta atc gdppc gdp democ xrover comlang yr* if wto_preatc==1, cluster(ccode)



**ALL AVAILABLE DATA**

xtreg binding l.binding ally ally_atc pta atc gdppc gdp democ xrover comlang wto yr*, cluster(ccode)

prais binding ally ally_atc pta atc gdppc gdp democ xrover comlang wto yr*, cluster(ccode)



**.75 BINDING THRESHOLD**

xtreg binding2 l.binding2 ally ally_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1, cluster(ccode)

prais binding2 ally ally_atc pta atc gdppc gdp democ xrover comlang yr* if wto==1, cluster(ccode)



