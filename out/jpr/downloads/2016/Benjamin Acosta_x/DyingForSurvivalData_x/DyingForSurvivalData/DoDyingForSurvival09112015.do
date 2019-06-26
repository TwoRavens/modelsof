*load static dataset
*Survival Analysis
stset age, failure (dead) id (org)

*Model 1
stcox onethousand tenthousand islamist leftist nsd as ks sa safe sponsors ties polity gdp uf hegemonic, r

stcurve, survival range(0 40) at1(sa=0) at2(sa=1)

*Model 2 
reg ties age onethousand tenthousand islamist leftist nsd as ks sa safe sponsors polity gdp uf hegemonic, r

*Model 3
stcox onethousand tenthousand islamist leftist nsd as ks jointsas safe sponsors ties polity gdp uf hegemonic, r

*Model 4
stcox onethousand tenthousand islamist leftist nsd as ks jointsas jointas ties sponsors safe polity gdp uf hegemonic, r

*Model A
logit sa age onethousand tenthousand islamist leftist nsd as ks ties safe sponsors polity gdp uf hegemonic, r
estat class

*political Islam with averages
mfx, at(21.0881 0 0 1 0 0 151 388 3 0 1 13 11.3087 0 0)
*no political Islam with averages
mfx, at(21.0881 0 0 0 0 0 151 388 3 0 1 13 11.3087 0 0)

*Model B
stcox onethousand tenthousand islamist leftist nsd as ks sa safe sponsors ties polity gdp uf hegemonic civilwar iraq afghan, r

*Model C
reg ties age onethousand tenthousand islamist leftist nsd as ks sa safe sponsors polity gdp uf hegemonic civilwar iraq afghan, r


*Summary Statistics (Static)
summarize ks
summarize ks if sa==1
summarize ks if sa==0
summarize age
summarize age if sa==1
summarize age if sa==0
summarize islamist
summarize islamist if sa==1
summarize islamist if sa==0
summarize as
summarize as if sa==1
summarize as if sa==0
summarize ties
summarize ties if sa==1
summarize ties if sa==0
summarize sponsors 
summarize sponsors if sa==1
summarize sponsors if sa==0
summarize safe
summarize safe if sa==1
summarize safe if sa==0
summarize polity
summarize polity if sa==1
summarize polity if sa==0
summarize GDP
summarize GDP if sa==1
summarize GDP if sa==0


*Load dynamic dataset
*Model D
xtset id t
xtreg ties age sas polity, fe

*Model E
xtreg ties age as ks sas polity, fe
estimates store FE
xtreg ties age as ks sas polity, re
estimates store RE
hausman FE RE

*Model F

tsset id t
prais ties age as ks sas polity

*Model G
prais ties age as ks sa polity


*Summary Statistics (Dynamic)
summarize ties
summarize ties if sa==1
summarize ties if sa==0
summarize age
summarize age if sa==1
summarize age if sa==0
summarize as
summarize as if sa==1
summarize as if sa==0
summarize ks
summarize ks if sa==1
summarize ks if sa==0
summarize polity
summarize polity if sa==1
summarize polity if sa==0

