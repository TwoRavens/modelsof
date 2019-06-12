***For all models below, the tables report significance levels based on p-values from one-tailed tests where there is a directional hypothesis***
***Table 1. Event History Models of Same-Sex Marriage Ban Adoption, 1994-2006***
stset year, id(statecode) failure(ban==1) scale(1)

***Model 1 - Direct Democracy Dummy***
stcox  ssm  ddssm selfideo ddself dd rgov dgov comp2 border2 plang lgbtpop pop2, exactp level(80)
lincom ssm+ddssm

***Calculating p-values from one tailed signifance tests for directional hypotheses***
test _b[ssm]=0
local sign_ssm = sign(_b[ssm])
display "one-tailed p-value = " normal(`sign_ssm'*sqrt(r(chi2)))
test _b[ddssm]=0
local sign_ddssm = sign(_b[ddssm])
display "one-tailed p-value = " normal(`sign_ddssm'*sqrt(r(chi2)))
test _b[selfideo]=0
local sign_selfideo = sign(_b[selfideo])
display "one-tailed p-value = " normal(`sign_selfideo'*sqrt(r(chi2)))
test _b[ddself]=0
local sign_ddself = sign(_b[ddself])
display "one-tailed p-value = " normal(`sign_ddself'*sqrt(r(chi2)))
test _b[rgov]=0
local sign_rgov = sign(_b[rgov])
display "one-tailed p-value = " 1-normal(`sign_rgov'*sqrt(r(chi2)))
test _b[dgov]=0
local sign_dgov = sign(_b[dgov])
display "one-tailed p-value = " normal(`sign_dgov'*sqrt(r(chi2)))
test _b[border2]=0
local sign_border2 = sign(_b[border2])
display "one-tailed p-value = " 1-normal(`sign_border2'*sqrt(r(chi2)))
test _b[plang]=0
local sign_plang = sign(_b[plang])
display "one-tailed p-value = " normal(`sign_plang'*sqrt(r(chi2)))
test _b[lgbtpop]=0
local sign_lgbtpop = sign(_b[lgbtpop])
display "one-tailed p-value = " normal(`sign_lgbtpop'*sqrt(r(chi2)))

***Model 2 - Direct Democracy Impact***
stcox  ssm  impact13ssm selfideo impact13self ddimpact13a rgov dgov comp2 border2 plang lgbtpop pop2, exactp level(80)

***Coefficients, combined coefficients, and corresponding confidence intervals saved and used to plot Figure 2.***
lincom ssm+impact13ssm, hr level(80)
lincom ssm+impact13ssm*2, hr level(80)
lincom ssm+impact13ssm*3, hr level(80)
lincom ssm+impact13ssm*4, hr level(80)
lincom ssm+impact13ssm*5, hr level(80)

***Calculating p-values from one tailed signifance tests for directional hypotheses***
test _b[ssm]=0
local sign_ssm = sign(_b[ssm])
display "one-tailed p-value = " normal(`sign_ssm'*sqrt(r(chi2)))
test _b[impact13ssm]=0
local sign_impact13ssm = sign(_b[impact13ssm])
display "one-tailed p-value = " normal(`sign_impact13ssm'*sqrt(r(chi2)))
test _b[selfideo]=0
local sign_selfideo = sign(_b[selfideo])
display "one-tailed p-value = " normal(`sign_selfideo'*sqrt(r(chi2)))
test _b[impact13self]=0
local sign_impact13self = sign(_b[impact13self])
display "one-tailed p-value = " normal(`sign_impact13self'*sqrt(r(chi2)))
test _b[rgov]=0
local sign_rgov = sign(_b[rgov])
display "one-tailed p-value = " 1-normal(`sign_rgov'*sqrt(r(chi2)))
test _b[dgov]=0
local sign_dgov = sign(_b[dgov])
display "one-tailed p-value = " normal(`sign_dgov'*sqrt(r(chi2)))
test _b[border2]=0
local sign_border2 = sign(_b[border2])
display "one-tailed p-value = " 1-normal(`sign_border2'*sqrt(r(chi2)))
test _b[plang]=0
local sign_plang = sign(_b[plang])
display "one-tailed p-value = " normal(`sign_plang'*sqrt(r(chi2)))
test _b[lgbtpop]=0
local sign_lgbtpop = sign(_b[lgbtpop])
display "one-tailed p-value = " normal(`sign_lgbtpop'*sqrt(r(chi2)))

***Table 2. Event History Models of Same-Sex Relationship Recognition Policies, 1994-2013***
stset year, id(statecode) failure(recognition==1) scale(1)

***Model 3 - Direct Democracy Dummy***
stcox  ssm  ddssm selfideo ddself dd dgov comp2 diffusionrr2 lgbtpop pop2, exactp level(80)
lincom ssm+ddssm

***Calculating p-values from one tailed signifance tests for directional hypotheses***
test _b[ssm]=0
local sign_ssm = sign(_b[ssm])
display "one-tailed p-value = " 1-normal(`sign_ssm'*sqrt(r(chi2)))
test _b[ddssm]=0
local sign_ddssm = sign(_b[ddssm])
display "one-tailed p-value = " 1-normal(`sign_ddssm'*sqrt(r(chi2)))
test _b[selfideo]=0
local sign_selfideo = sign(_b[selfideo])
display "one-tailed p-value = " 1-normal(`sign_selfideo'*sqrt(r(chi2)))
test _b[ddself]=0
local sign_ddself = sign(_b[ddself])
display "one-tailed p-value = " 1-normal(`sign_ddself'*sqrt(r(chi2)))
test _b[dgov]=0
local sign_dgov = sign(_b[dgov])
display "one-tailed p-value = " 1-normal(`sign_dgov'*sqrt(r(chi2)))
test _b[diffusionrr2]=0
local sign_diffusionrr2 = sign(_b[diffusionrr2])
display "one-tailed p-value = " 1-normal(`sign_diffusionrr2'*sqrt(r(chi2)))
test _b[lgbtpop]=0
local sign_lgbtpop = sign(_b[lgbtpop])
display "one-tailed p-value = " 1-normal(`sign_lgbtpop'*sqrt(r(chi2)))

***Model 4 - Direct Democracy Impact***
stcox  ssm  impact13ssm selfideo impact13self ddimpact13a dgov comp2 diffusionrr2 lgbtpop pop2, exactp level(80)

***Coefficients, combined coefficients, and corresponding confidence intervals saved and used to plot Figure 3.***
lincom ssm+impact13ssm, hr level(80)
lincom ssm+impact13ssm*2, hr level(80)
lincom ssm+impact13ssm*3, hr level(80)
lincom ssm+impact13ssm*4, hr level(80)
lincom ssm+impact13ssm*5, hr level(80)

***Calculating p-values from one tailed signifance tests for directional hypotheses***
test _b[ssm]=0
local sign_ssm = sign(_b[ssm])
display "one-tailed p-value = " 1-normal(`sign_ssm'*sqrt(r(chi2)))
test _b[impact13ssm]=0
local sign_impact13ssm = sign(_b[impact13ssm])
display "one-tailed p-value = " 1-normal(`sign_impact13ssm'*sqrt(r(chi2)))
test _b[selfideo]=0
local sign_selfideo = sign(_b[selfideo])
display "one-tailed p-value = " 1-normal(`sign_selfideo'*sqrt(r(chi2)))
test _b[impact13self]=0
local sign_impact13self = sign(_b[impact13self])
display "one-tailed p-value = " 1-normal(`sign_impact13self'*sqrt(r(chi2)))
test _b[dgov]=0
local sign_dgov = sign(_b[dgov])
display "one-tailed p-value = " 1-normal(`sign_dgov'*sqrt(r(chi2)))
test _b[diffusionrr2]=0
local sign_diffusionrr2 = sign(_b[diffusionrr2])
display "one-tailed p-value = " 1-normal(`sign_diffusionrr2'*sqrt(r(chi2)))
test _b[lgbtpop]=0
local sign_lgbtpop = sign(_b[lgbtpop])
display "one-tailed p-value = " 1-normal(`sign_lgbtpop'*sqrt(r(chi2)))

***Table 3. Event History Models of Same-Sex Marriage Recognition, 1994-2013; Models 5 & 6 - Legislative Policy Adoptions Only***
stset year, id(statecode) failure(marriage==1) exit(marriage==1 2)

***Model 5 - Direct Democracy Dummy***
stcox  ssm  ddssm selfideo ddself dd dgov comp2 diffusionssm2 lgbtpop pop2, exactp level(80)
lincom ssm+ddssm

***Calculating p-values from one tailed signifance tests for directional hypotheses***
test _b[ssm]=0
local sign_ssm = sign(_b[ssm])
display "one-tailed p-value = " 1-normal(`sign_ssm'*sqrt(r(chi2)))
test _b[ddssm]=0
local sign_ddssm = sign(_b[ddssm])
display "one-tailed p-value = " 1-normal(`sign_ddssm'*sqrt(r(chi2)))
test _b[selfideo]=0
local sign_selfideo = sign(_b[selfideo])
display "one-tailed p-value = " 1-normal(`sign_selfideo'*sqrt(r(chi2)))
test _b[ddself]=0
local sign_ddself = sign(_b[ddself])
display "one-tailed p-value = " 1-normal(`sign_ddself'*sqrt(r(chi2)))
test _b[dgov]=0
local sign_dgov = sign(_b[dgov])
display "one-tailed p-value = " 1-normal(`sign_dgov'*sqrt(r(chi2)))
test _b[diffusionssm2]=0
local sign_diffusionssm2 = sign(_b[diffusionssm2])
display "one-tailed p-value = " 1-normal(`sign_diffusionssm2'*sqrt(r(chi2)))
test _b[lgbtpop]=0
local sign_lgbtpop = sign(_b[lgbtpop])
display "one-tailed p-value = " 1-normal(`sign_lgbtpop'*sqrt(r(chi2)))

***Model 6 - Direct Democracy Impact***
stcox  ssm  impact13ssm selfideo impact13self ddimpact13a dgov comp2 diffusionssm2 lgbtpop pop2, exactp level(80)

***Coefficients, combined coefficients, and corresponding confidence intervals saved and used to plot the first graph in Figure 4.***
lincom ssm+impact13ssm, hr level(80)
lincom ssm+impact13ssm*2, hr level(80)
lincom ssm+impact13ssm*3, hr level(80)
lincom ssm+impact13ssm*4, hr level(80)
lincom ssm+impact13ssm*5, hr level(80)

***Calculating p-values from one tailed signifance tests for directional hypotheses***
test _b[ssm]=0
local sign_ssm = sign(_b[ssm])
display "one-tailed p-value = " 1-normal(`sign_ssm'*sqrt(r(chi2)))
test _b[impact13ssm]=0
local sign_impact13ssm = sign(_b[impact13ssm])
display "one-tailed p-value = " 1-normal(`sign_impact13ssm'*sqrt(r(chi2)))
test _b[selfideo]=0
local sign_selfideo = sign(_b[selfideo])
display "one-tailed p-value = " 1-normal(`sign_selfideo'*sqrt(r(chi2)))
test _b[impact13self]=0
local sign_impact13self = sign(_b[impact13self])
display "one-tailed p-value = " 1-normal(`sign_impact13self'*sqrt(r(chi2)))
test _b[dgov]=0
local sign_dgov = sign(_b[dgov])
display "one-tailed p-value = " 1-normal(`sign_dgov'*sqrt(r(chi2)))
test _b[diffusionssm2]=0
local sign_diffusionssm2 = sign(_b[diffusionssm2])
display "one-tailed p-value = " 1-normal(`sign_diffusionssm2'*sqrt(r(chi2)))
test _b[lgbtpop]=0
local sign_lgbtpop = sign(_b[lgbtpop])
display "one-tailed p-value = " 1-normal(`sign_lgbtpop'*sqrt(r(chi2)))

***Models 7 & 8 - Both Legislative and Judicial Policy Adoptions***
stset year, id(statecode) failure(marriage==1 2)

***Model 7 - Direct Democracy Dummy***
stcox  ssm  ddssm selfideo ddself dd dgov comp2 diffusionssm2 lgbtpop pop2, exactp level(80)
lincom ssm+ddssm

***Calculating p-values from one tailed signifance tests for directional hypotheses***
test _b[ssm]=0
local sign_ssm = sign(_b[ssm])
display "one-tailed p-value = " 1-normal(`sign_ssm'*sqrt(r(chi2)))
test _b[ddssm]=0
local sign_ddssm = sign(_b[ddssm])
display "one-tailed p-value = " 1-normal(`sign_ddssm'*sqrt(r(chi2)))
test _b[selfideo]=0
local sign_selfideo = sign(_b[selfideo])
display "one-tailed p-value = " 1-normal(`sign_selfideo'*sqrt(r(chi2)))
test _b[ddself]=0
local sign_ddself = sign(_b[ddself])
display "one-tailed p-value = " 1-normal(`sign_ddself'*sqrt(r(chi2)))
test _b[dgov]=0
local sign_dgov = sign(_b[dgov])
display "one-tailed p-value = " 1-normal(`sign_dgov'*sqrt(r(chi2)))
test _b[diffusionssm2]=0
local sign_diffusionssm2 = sign(_b[diffusionssm2])
display "one-tailed p-value = " 1-normal(`sign_diffusionssm2'*sqrt(r(chi2)))
test _b[lgbtpop]=0
local sign_lgbtpop = sign(_b[lgbtpop])
display "one-tailed p-value = " 1-normal(`sign_lgbtpop'*sqrt(r(chi2)))

***Model 8 - Direct Democracy Impact***
stcox  ssm  impact13ssm selfideo impact13self ddimpact13a dgov comp2 diffusionssm2 lgbtpop pop2, exactp level(80)

***Coefficients, combined coefficients, and corresponding confidence intervals saved and used to plot the second graph in Figure 4.***
lincom ssm+impact13ssm, hr level(80)
lincom ssm+impact13ssm*2, hr level(80)
lincom ssm+impact13ssm*3, hr level(80)
lincom ssm+impact13ssm*4, hr level(80)
lincom ssm+impact13ssm*5, hr level(80)

***Calculating p-values from one tailed signifance tests for directional hypotheses***
test _b[ssm]=0
local sign_ssm = sign(_b[ssm])
display "one-tailed p-value = " 1-normal(`sign_ssm'*sqrt(r(chi2)))
test _b[impact13ssm]=0
local sign_impact13ssm = sign(_b[impact13ssm])
display "one-tailed p-value = " 1-normal(`sign_impact13ssm'*sqrt(r(chi2)))
test _b[selfideo]=0
local sign_selfideo = sign(_b[selfideo])
display "one-tailed p-value = " 1-normal(`sign_selfideo'*sqrt(r(chi2)))
test _b[impact13self]=0
local sign_impact13self = sign(_b[impact13self])
display "one-tailed p-value = " 1-normal(`sign_impact13self'*sqrt(r(chi2)))
test _b[dgov]=0
local sign_dgov = sign(_b[dgov])
display "one-tailed p-value = " 1-normal(`sign_dgov'*sqrt(r(chi2)))
test _b[diffusionssm2]=0
local sign_diffusionssm2 = sign(_b[diffusionssm2])
display "one-tailed p-value = " 1-normal(`sign_diffusionssm2'*sqrt(r(chi2)))
test _b[lgbtpop]=0
local sign_lgbtpop = sign(_b[lgbtpop])
display "one-tailed p-value = " 1-normal(`sign_lgbtpop'*sqrt(r(chi2)))

***Table 4. Logistic Regression Model of Policy Congruence, 1995-2013***
tsset statecode year

***Model 9 - Direct Democracy Dummy***
xtlogit congruent d.ssm ssm2 dd comp2 squire2 i.year, re or

***Calculating p-values from one tailed signifance tests for directional hypotheses***
test _b[d.ssm]=0
local sign_dssm = sign(_b[d.ssm])
display "one-tailed p-value = " normal(`sign_dssm'*sqrt(r(chi2)))
test _b[ssm2]=0
local sign_ssm2 = sign(_b[ssm2])
display "one-tailed p-value = " 1-normal(`sign_ssm2'*sqrt(r(chi2)))
test _b[dd]=0
local sign_dd = sign(_b[dd])
display "one-tailed p-value = " 1-normal(`sign_dd'*sqrt(r(chi2)))
test _b[comp2]=0
local sign_comp2 = sign(_b[comp2])
display "one-tailed p-value = " 1-normal(`sign_comp2'*sqrt(r(chi2)))
test _b[squire2]=0
local sign_squire2 = sign(_b[squire2])
display "one-tailed p-value = " 1-normal(`sign_squire2'*sqrt(r(chi2)))

***Model 10 - Direct Democracy Impact***
xtlogit congruent d.ssm ssm2 ddimpact13a comp2 squire2 i.year, re or

***Calculating p-values from one tailed signifance tests for directional hypotheses***
test _b[d.ssm]=0
local sign_dssm = sign(_b[d.ssm])
display "one-tailed p-value = " normal(`sign_dssm'*sqrt(r(chi2)))
test _b[ssm2]=0
local sign_ssm2 = sign(_b[ssm2])
display "one-tailed p-value = " 1-normal(`sign_ssm2'*sqrt(r(chi2)))
test _b[ddimpact13a]=0
local sign_ddimpact13a = sign(_b[ddimpact13a])
display "one-tailed p-value = " 1-normal(`sign_ddimpact13a'*sqrt(r(chi2)))
test _b[comp2]=0
local sign_comp2 = sign(_b[comp2])
display "one-tailed p-value = " 1-normal(`sign_comp2'*sqrt(r(chi2)))
test _b[squire2]=0
local sign_squire2 = sign(_b[squire2])
display "one-tailed p-value = " 1-normal(`sign_squire2'*sqrt(r(chi2)))

***Table B - Measures of Direct Democracy***
***The command below produces mean values for each variable by state for all direct democracy states.  There is no variation in the values across time***
table state if dd==1, contents(mean lindex mean qindex mean ddimpact13a )

***Table D - Summary Statistics for Independent Variables***
sum  ssm  selfideo dd ddimpact13a rgov dgov comp2 border2 diffusionrr2 diffusionssm2 plang lgbtpop pop2
