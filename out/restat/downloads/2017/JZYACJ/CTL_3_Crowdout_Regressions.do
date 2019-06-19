
local inout Census_Tax_Linkage\Data

use "`inout'\CensusTax_Crowdout.dta", clear

gen othinc=totinc-(empinc+cqppympe)
gen hsgrad_plus_gen=(hsgrad_plus_hat>0.75)

local covars age agesq female married i.province i.naics othinc value disability

*--------------------------------------
*0) Descriptive statistics by education
*--------------------------------------

sort hsgrad_plus
by hsgrad_plus: summarize age married othinc

*----------------
*1) Unconditional
*----------------

qui reg rspcont empinc empinc_kink `covars'
est store savreg
qui reg penadj empinc empinc_kink `covars'
est store rppreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

*----------------------------------------------------
*2) Conditional on low actual and predicted education
*----------------------------------------------------

preserve

keep if hsgrad_plus==0
qui reg rspcont empinc empinc_kink `covars'
est store savreg
qui reg penadj empinc empinc_kink `covars'
est store rppreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

restore
preserve

keep if hsgrad_plus_gen==0
qui reg rspcont empinc empinc_kink `covars'
est store savreg
qui reg penadj empinc empinc_kink `covars'
est store rppreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

restore

*-----------------------------------------------------
*3) Conditional on high actual and predicted education
*-----------------------------------------------------

preserve

keep if hsgrad_plus==1
qui reg rspcont empinc empinc_kink `covars'
est store savreg
qui reg penadj empinc empinc_kink `covars'
est store rppreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

restore
preserve

keep if hsgrad_plus==1
qui reg rspcont empinc empinc_kink `covars'
est store savreg
qui reg penadj empinc empinc_kink `covars'
est store rppreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

restore

*--------------------------------------------
*4) Various levels of higher actual education
*--------------------------------------------

gen somepse=(((hlos>=8 & hlos<=17) & lwfcen91==1) | ((hcdd>=5 & hcdd<=8) & nhscen06==1))

preserve

keep if somepse==1
qui reg rspcont empinc empinc_kink `covars'
est store savreg
qui reg penadj empinc empinc_kink `covars'
est store rppreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

restore
preserve

keep if univgrad_plus==1
qui reg rspcont empinc empinc_kink `covars'
est store savreg
qui reg penadj empinc empinc_kink `covars'
est store rppreg
suest savreg rppreg, cl(id)
nlcom (ratio: [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]), post
test _b[ratio]=-1

exit