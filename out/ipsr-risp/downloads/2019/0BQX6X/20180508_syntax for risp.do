
findit polychoric
findit factortest

*TAB 1*
polychoric fidparl fidgius fidpart fidpoli if anno2>=1996 & AGE>=18
display r(sum_w)
global N = r(sum_w) 
matrix r = r(R) 
factormat r, n(317549) factors(3) ml
factortest fidgius fidpoli fidparl fidpart if anno2>=1996 & AGE>=18
rotate, horst blanks(.3)
predict factor_1 
rename factor_1 confidence 

alpha fidparl fidgius fidpart fidpoli if anno2>=1996 & AGE>=18, std item

* FIG 1 NATIONAL CONGRESS/PARLIAMENT*
tabulate fidparl2 if anno2==1996 & AGE>=18
tabulate fidparl2 if anno2==1997 & AGE>=18
tabulate fidparl2 if anno2==1998 & AGE>=18
tabulate fidparl2 if anno2==1999 & AGE>=18
tabulate fidparl2 if anno2==2000 & AGE>=18
tabulate fidparl2 if anno2==2001 & AGE>=18
tabulate fidparl2 if anno2==2002 & AGE>=18
tabulate fidparl2 if anno2==2003 & AGE>=18
tabulate fidparl2 if anno2==2004 & AGE>=18
tabulate fidparl2 if anno2==2005 & AGE>=18
tabulate fidparl2 if anno2==2006 & AGE>=18
tabulate fidparl2 if anno2==2007 & AGE>=18
tabulate fidparl2 if anno2==2008 & AGE>=18
tabulate fidparl2 if anno2==2009 & AGE>=18
tabulate fidparl2 if anno2==2010 & AGE>=18
tabulate fidparl2 if anno2==2011 & AGE>=18
tabulate fidparl2 if anno2==2013 & AGE>=18

* FIG 2 PARTIES*
tabulate fidpart2 if anno2==1996 & AGE>=18
tabulate fidpart2 if anno2==1997 & AGE>=18
tabulate fidpart2 if anno2==1998 & AGE>=18
tabulate fidpart2 if anno2==1999 & AGE>=18
tabulate fidpart2 if anno2==2000 & AGE>=18
tabulate fidpart2 if anno2==2001 & AGE>=18
tabulate fidpart2 if anno2==2002 & AGE>=18
tabulate fidpart2 if anno2==2003 & AGE>=18
tabulate fidpart2 if anno2==2004 & AGE>=18
tabulate fidpart2 if anno2==2005 & AGE>=18
tabulate fidpart2 if anno2==2006 & AGE>=18
tabulate fidpart2 if anno2==2007 & AGE>=18
tabulate fidpart2 if anno2==2008 & AGE>=18
tabulate fidpart2 if anno2==2009 & AGE>=18
tabulate fidpart2 if anno2==2010 & AGE>=18
tabulate fidpart2 if anno2==2011 & AGE>=18
tabulate fidpart2 if anno2==2013 & AGE>=18

* FIG 2 Judiciary*
tabulate fidgius2 if anno2==1996 & AGE>=18
tabulate fidgius2 if anno2==1997 & AGE>=18
tabulate fidgius2 if anno2==1998 & AGE>=18
tabulate fidgius2 if anno2==1999 & AGE>=18
tabulate fidgius2 if anno2==2000 & AGE>=18
tabulate fidgius2 if anno2==2001 & AGE>=18
tabulate fidgius2 if anno2==2002 & AGE>=18
tabulate fidgius2 if anno2==2003 & AGE>=18
tabulate fidgius2 if anno2==2004 & AGE>=18
tabulate fidgius2 if anno2==2005 & AGE>=18
tabulate fidgius2 if anno2==2006 & AGE>=18
tabulate fidgius2 if anno2==2007 & AGE>=18
tabulate fidgius2 if anno2==2008 & AGE>=18
tabulate fidgius2 if anno2==2009 & AGE>=18
tabulate fidgius2 if anno2==2010 & AGE>=18
tabulate fidgius2 if anno2==2011 & AGE>=18
tabulate fidgius2 if anno2==2013 & AGE>=18

* FIG 2 Police*
tabulate fidpoli2 if anno2==1996 & AGE>=18
tabulate fidpoli2 if anno2==1997 & AGE>=18
tabulate fidpoli2 if anno2==1998 & AGE>=18
tabulate fidpoli2 if anno2==1999 & AGE>=18
tabulate fidpoli2 if anno2==2000 & AGE>=18
tabulate fidpoli2 if anno2==2001 & AGE>=18
tabulate fidpoli2 if anno2==2002 & AGE>=18
tabulate fidpoli2 if anno2==2003 & AGE>=18
tabulate fidpoli2 if anno2==2004 & AGE>=18
tabulate fidpoli2 if anno2==2005 & AGE>=18
tabulate fidpoli2 if anno2==2006 & AGE>=18
tabulate fidpoli2 if anno2==2007 & AGE>=18
tabulate fidpoli2 if anno2==2008 & AGE>=18
tabulate fidpoli2 if anno2==2009 & AGE>=18
tabulate fidpoli2 if anno2==2010 & AGE>=18
tabulate fidpoli2 if anno2==2011 & AGE>=18
tabulate fidpoli2 if anno2==2013 & AGE>=18

*TAB 2*
tabulate paese1  if anno2==1996 & AGE>=18, summarize(confidence)
tabulate paese1  if anno2==2000 & AGE>=18, summarize(confidence)
tabulate paese1  if anno2==2005 & AGE>=18, summarize(confidence)
tabulate paese1  if anno2==2010 & AGE>=18, summarize(confidence)
tabulate paese1  if anno2==2013 & AGE>=18, summarize(confidence)

xtset countca

*TAB 3 model 4*
xtreg confidence i.ecopers##i.econaz c.lgdppp1##i.ecopers c.gdpgr1##i.econaz sex i.soddord fidsoc crisic i.edu2 income approval Giniindex controlofcorruption c.AGE##c.AGE if anno2>=1996 & AGE>=18, re vce(cluster countca)
generate sample = e(sample)

*TAB 3 model 1*
xtreg confidence i.ecopers##i.econaz i.soddord fidsoc crisic sex i.edu2 income approval Giniindex controlofcorruption c.AGE##c.AGE if sample==1 , re vce(cluster countca)

*TAB 3 model 2*
xtreg confidence c.ecopers##c.lgdppp1 i.soddord fidsoc crisic sex i.edu2 income approval Giniindex controlofcorruption c.AGE##c.AGE if sample==1, re vce(cluster countca)

*TAB 3 model 3*
xtreg confidence i.econaz##c.gdpgr1 i.soddord fidsoc crisic sex i.edu2 income approval Giniindex controlofcorruption c.AGE##c.AGE if sample==1, re vce(cluster countca)

*FIG 2*
sum ecopers econaz
xtreg confidence i.ecopers##i.econaz c.lgdppp1##i.ecopers c.gdpgr1##i.econaz sex i.soddord fidsoc crisic i.edu2 income approval Giniindex controlofcorruption c.AGE##c.AGE if anno2>=1996 & AGE>=18, re vce(cluster countca)
margins, at (ecopers=(0 (1) 1))
margins, dydx(econaz) at (ecopers=(0 (1) 1)) vsquish post
marginsplot, level (90) yline(0)

sum gdpgr1 econaz
*FIG 3*
xtreg confidence i.ecopers##i.econaz c.lgdppp1##i.ecopers c.gdpgr1##i.econaz sex i.soddord fidsoc crisic i.edu2 income approval Giniindex controlofcorruption c.AGE##c.AGE if anno2>=1996 & AGE>=18, re vce(cluster countca)
margins, at (gdpgr1=(-13.380 (3) 18.287))
margins, dydx(econaz) at (gdpgr1=(-13.380 (3) 18.287)) vsquish post
marginsplot, level (90) yline(0)

