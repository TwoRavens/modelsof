* Table 1

* Model 1:
logit uppin2 grwthnew denspnew grdennew totpopln dep imr polity politysq polmiss py3 if !(uppin2==0 & uppwar==1)

* Model 2:
logit uppin2 grwthnew denspnew grdennew totpopln imr polity politysq polmiss py3 if sscntr==1 & !(uppin2==0 & uppwar==1)

* Model 3
logit uppin2 grwthnew denspnew grdennew totpopln dep pwt_gdp_pc_ln pwtmiss polity politysq polmiss py3 if !(uppin2==0 & uppwar==1)

* Model 4:
logit uppinall2 grwthnew denspnew grdennew totplnne dep imr polity politysq polmiss brevityconflict proxcone proxcontotpop

* Model 5
logit uppin2 grwthnew denspnew grdennew urbangrowth totpopln dep imr polity politysq polmiss pwtecgrowth_5 pwtgrowth_miss py3 if !(uppin2==0 & uppwar==1)

* Model 6:
logit uppin5 grwthnew denspnew grdennew totpopln dep imr polity politysq polmiss py3 if !(uppin5==0 & uppwar==1)


* Table 2:

* Model 6
logit uppin2 grwthnew denspnew grdennew totpopln dep imr polity politysq polmiss py3 if decade==1 & !(uppin2==0 & uppwar==1)

* Model 7
logit uppin2 grwthnew denspnew grdennew totpopln dep imr polity politysq polmiss py3 if decade==2 & !(uppin2==0 & uppwar==1)

* Model 8
logit uppin2 grwthnew denspnew grdennew totpopln dep imr polity politysq polmiss py3 if decade==3 & !(uppin2==0 & uppwar==1)

* Model 9
logit uppin2 grwthnew denspnew grdennew totpopln imr polity politysq polmiss py3 if decade==4 & !(uppin2==0 & uppwar==1)

* Model 10
logit uppin2 grwthnew denspnew grdennew urbangrowth reflagge totpopln imr polity politysq polmiss py3 if decade==5 & !(uppin2==0 & uppwar==1)

* All decades:
logit uppin2 grwthnew denspnew grdennew totpopln dep imr polity politysq polmiss py3 if !(uppin2==0 & uppwar==1)


