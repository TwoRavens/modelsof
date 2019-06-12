clear 
import delimited "01_data/cleaned_data/congress.csv"

gen post_appalplayz = post * appalplayz

label var post_appalplayz "Shale*Post-boom"
label var appalplayz "Shale"
label var post "Post-boom"

keep if appalrdplayincludebw1 == 1

set seed 1

estsimp logit republican appalplayz post post_appalplayz if year != 2004 [pw=observed_propensity], cluster(distid) /* Note that you need to the clarify package via ssc install clarify, replace */

matrix prediction = J(4,4,.)

* Predicted Probability for Shale in Pre-Boom Period

setx appalplayz 1 post 0 post_appalplayz 0 
simqi, genpr(shale_pre) prval(1)

sum shale_pre
matrix prediction[1,1] =  r(mean)

_pctile shale_pre, p(2.5)
matrix prediction[2,1] =  r(r1)

_pctile shale_pre, p(97.5)
matrix prediction[2,2] =  r(r1)

* Predicted Probability for Non-Shale in Pre-Boom Period

setx appalplayz 0 post 0 post_appalplayz 0 
simqi, genpr(non_shale_pre) prval(1)

sum non_shale_pre
matrix prediction[3,1] =  r(mean)

_pctile non_shale_pre, p(2.5)
matrix prediction[4,1] =  r(r1)

_pctile non_shale_pre, p(97.5)
matrix prediction[4,2] =  r(r1)

* Predicted Probability for Shale in Post-Boom Period

setx appalplayz 1 post 1 post_appalplayz 1
simqi, genpr(shale_post) prval(1)

sum shale_post
matrix prediction[1,3] =  r(mean)

_pctile shale_post, p(2.5)
matrix prediction[2,3] =  r(r1)

_pctile shale_post, p(97.5)
matrix prediction[2,4] =  r(r1)

* Predicted Probability for Non-Shale in Post-Boom Period

setx appalplayz 0 post 1 post_appalplayz 0 
simqi, genpr(non_shale_post) prval(1)

sum non_shale_post
matrix prediction[3,3] =  r(mean)

_pctile non_shale_post, p(2.5)
matrix prediction[4,3] =  r(r1)

_pctile non_shale_post, p(97.5)
matrix prediction[4,4] =  r(r1)

matrix rownames prediction = Shale - Non-Shale -
matrix colnames prediction = Pre-Boom - Post-Boom -

esttab matrix(prediction, fmt(2)) using "02_tables/table_A15_logit_prediction_party.tex", replace nomtitles

