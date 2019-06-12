/*use illexp.dta for analyses below*/

/*************************************************

gender = dummy variable, 1= males
race = dummy variable, 1=blacks
auth = authoritarianism
illpol = opposition to illegal immigration scale
illcan = treatment, illegal canadians cued
illmex = treatment, illegal mexicans cued
ages = age
edu = education
inc = income
authblack = auth x race
authillmex = auth x illmex
authillcan = auth x illcan
illmexblk = illmex x race
illcanblk = illcan x race
authmexblk = auth x illmex x race
authcanblk = auth x illcan x race

***************************************************/

/*Figure 2, marginal effects of authoritarianism, illegal immigration experiment*/

reg illpol auth illmex illcan race authillmex authillcan authblack illmexblk illcanblk authmexblk authcanblk gender ages inc edu, robust level(90)

lincom auth + authblack*0 + authillmex*0 + authmexblk*0*0 + authillcan*0 + authcanblk*0*0, level(90)
lincom auth + authblack*1 + authillmex*0 + authmexblk*0*1 + authillcan*0 + authcanblk*0*1, level(90)

lincom auth + authblack*0 + authillmex*1 + authmexblk*1*0 + authillcan*0 + authcanblk*0*0, level(90)
lincom auth + authblack*1 + authillmex*1 + authmexblk*1*1 + authillcan*0 + authcanblk*0*1, level(90)

lincom auth + authblack*0 + authillmex*0 + authmexblk*0*0 + authillcan*1 + authcanblk*1*0, level(90)
lincom auth + authblack*1 + authillmex*0 + authmexblk*0*1 + authillcan*1 + authcanblk*1*1, level(90)


/*Table F, supporting information, comparison of experimental models with and without covariates

reg illpol auth illmex illcan race authillmex authillcan authblack illmexblk illcanblk authmexblk authcanblk gender ages inc edu, robust level(90)
reg illpol auth illmex illcan race authillmex authillcan authblack illmexblk illcanblk authmexblk authcanblk, robust level(90)

