
clear
clear matrix
set mem 500m
use ecological_footprint_restat_deforestation_data.dta, clear

************ GENERATING TABLE 2: SIMPLEST APPROACH *****************
reg treat eligible99 indice95 perforestK lnarea lnpob lnslope lcarcon ecoregNEW6 ecoregNEW7 ecoregNEW9, robust


tobit pctdefor eligible99 indice95 perforestK lnpob lnarea lcarcon lnslope   ecoregNEW6 ecoregNEW7 ecoregNEW9, ll(0) 
est2vec simple, replace e(ll F) vars(eligible99 indice95 ind2 ind3 ind4 perforestK lnarea lnpob lnslope lcarcon)
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))

tobit pctdefor eligible99 indice95 ind2 ind3 ind4 perforestK lnpob lnarea lcarcon  lnslope ecoregNEW6 ecoregNEW7 ecoregNEW9, ll(0) 
est2vec simple, addto(simple) name(fourth)
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))

tobit pctdefor eligible99 indice95 perforestK lnpob lnarea lnslope lcarcon ecoregNEW6 ecoregNEW7 ecoregNEW9 if smallsample == 1, ll(0) 
est2vec simple, addto(simple) name(smallfull)
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))

reg d eligible99 indice95 ind2 ind3 ind4 perforestK lnpob lnarea lcarcon lnslope ecoregNEW6 ecoregNEW7 ecoregNEW9, robust
est2vec simple, addto(simple) name(olsd)

reg pctdefor eligible99 indice95 ind2 ind3 ind4 perforestK lnpob lnarea lcarcon  lnslope ecoregNEW6 ecoregNEW7 ecoregNEW9 if d == 1, robust
est2vec simple, addto(simple) name(olspos)

est2tex simple, replace mark(stars) fancy preserve levels(90 95 99) label


******** TABLE 3:  FIRST STAGES*****

reg treat eligible99 indice95 perforestK lnarea lnpob lnslope lcarcon ecoregNEW6 ecoregNEW7 ecoregNEW9, robust
est2vec instrument, replace e(ll F r2_a) vars(eligible98 eligible99 elig98_ind elig99_ind indice95 ind2 ind3 ind4 perforestK lnarea lnpob lnslope lcarcon)

reg treat eligible98 eligible99 elig98_ind elig99_ind indice95 perforestK lnarea lnpob lnslope lcarcon ecoregNEW6 ecoregNEW7 ecoregNEW9, robust
est2vec instrument, addto(instrument) name(fuzzy)
test eligible98 = eligible99 = elig98_ind = elig99_ind ==0

reg treat eligible98 eligible99 elig98_ind elig99_ind indice95 ind2 ind3 ind4 perforestK lnarea lnpob lnslope lcarcon ecoregNEW6 ecoregNEW7 ecoregNEW9, robust
est2vec instrument, addto(instrument) name(fourth)
test eligible98 = eligible99 = elig98_ind = elig99_ind ==0

reg treat eligible98 eligible99 elig98_ind elig99_ind indice95 perforestK lnarea lnpob lnslope ecoregNEW6 lcarcon ecoregNEW7 ecoregNEW9 if smallsample == 1, robust
est2vec instrument, addto(instrument) name(small)
test eligible98 = eligible99 = elig98_ind = elig99_ind ==0

reg treatpct9702 eligible98 eligible99 elig98_ind elig99_ind indice95 ind2 ind3 ind4 perforestK lnarea lnpob lnslope lcarcon ecoregNEW6 ecoregNEW7 ecoregNEW9, robust
est2vec instrument, addto(instrument) name(continuous)
test eligible98 = eligible99 = elig98_ind = elig99_ind ==0

est2tex instrument, replace mark(stars) fancy preserve levels(90 95 99) label

********* SIMPLE IV *********************

ivtobit pctdefor (treat = eligible99 ) indice95 perforestK lnarea lcarcon ///
lnslope lnpob ecoregNEW6 ecoregNEW7 ecoregNEW9, ll(0) 
est2vec simpleiv, replace e(ll F) vars(treat treatpct9702 indice95 ind2 ind3 ind4 perforestK lnarea lnpob lnslope lcarcon)
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))

ivtobit pctdefor (treat = eligible99 ) indice95 ind2 ind3 ind4 perforestK lnpob lnarea  lcarcon ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9, ll(0) 
est2vec simpleiv, addto(simpleiv) name(fullfourth)
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))

ivtobit pctdefor (treatpct9702 = eligible99 ) indice95 ind2 ind3 ind4 perforestK lnpob lnarea  lcarcon ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9, ll(0) 
est2vec simpleiv, addto(simpleiv) name(continuous)
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))

ivtobit pctdefor (treat  = eligible99 ) indice95 perforestK lnpob lnarea ///
lnslope lcarcon ecoregNEW6 ecoregNEW7 ecoregNEW9 if smallsample == 1, ll(0) 
est2vec simpleiv, addto(simpleiv) name(smallfull)
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))

ivreg d (treat = eligible99 ) indice95 ind2 ind3 ind4 perforestK lnpob lnarea  lcarcon ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9, robust
est2vec simpleiv, addto(simpleiv) name(olsd)

ivreg pctdefor (treat = eligible99 ) indice95 ind2 ind3 ind4 perforestK lnpob lnarea  lcarcon ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9 if d == 1, robust
est2vec simpleiv, addto(simpleiv) name(olspos)

est2tex simpleiv, replace mark(stars) fancy preserve levels(90 95 99) label




********* FUZZY DISCONTINUITY *********************

ivtobit pctdefor (treat =eligible98 eligible99 elig98_ind elig99_ind) indice95 perforestK lnarea lcarcon ///
lnslope lnpob ecoregNEW6 ecoregNEW7 ecoregNEW9, ll(0) 
est2vec fuzzy, replace e(ll F) vars(treat treatpct9702 indice95 ind2 ind3 ind4 perforestK lnarea lnpob lnslope lcarcon)
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))

ivtobit pctdefor (treat =eligible98 eligible99 elig98_ind elig99_ind) indice95 ind2 ind3 ind4 perforestK lnpob lnarea  lcarcon ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9, ll(0) 
est2vec fuzzy, addto(fuzzy) name(fullfourth)
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))

ivtobit pctdefor (treatpct9702 =eligible98 eligible99 elig98_ind elig99_ind) indice95 ind2 ind3 ind4 perforestK lnpob lnarea  lcarcon ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9, ll(0) 
est2vec fuzzy, addto(fuzzy) name(continuous )
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))


ivtobit pctdefor (treat =eligible98 eligible99 elig98_ind elig99_ind) indice95 perforestK lnpob lnarea ///
lnslope lcarcon ecoregNEW6 ecoregNEW7 ecoregNEW9 if smallsample == 1, ll(0) 
est2vec fuzzy, addto(fuzzy) name(smallfull)
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))


ivreg d (treat =eligible98 eligible99 elig98_ind elig99_ind) indice95 ind2 ind3 ind4 perforestK lnpob lnarea  lcarcon ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9, robust
est2vec fuzzy, addto(fuzzy) name(olsd)

ivreg pctdefor (treat =eligible98 eligible99 elig98_ind elig99_ind) indice95 ind2 ind3 ind4 perforestK lnpob lnarea  lcarcon ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9 if d == 1, robust
est2vec fuzzy, addto(fuzzy) name(olspos)

est2tex fuzzy, replace mark(stars) fancy preserve levels(90 95 99) label

******* INTERACTION OF TREATMENT WITH POPULATION***

gen eligpob = eligible99*lnpob

ivtobit pctdefor (numtreat = eligible99 eligpob ) indice95 ind2 ind3 ind4 perforestK lnpob lnarea  lcarcon ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9, ll(0)

ivreg d (numtreat = eligible99 eligpob ) indice95 ind2 ind3 ind4 perforestK lnpob lnarea  lcarcon ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9, robust

ivreg pctdefor (numtreat = eligible99 eligpob) indice95 ind2 ind3 ind4 perforestK lnpob lnarea  lcarcon ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9 if d == 1, robust

************** EXPLORE EFFECTS CONTROLLING FOR CONNECTEDNESS *********

****************
** TABLE 5: CONNECTEDNESS

sum carrconlkm
egen rdlen2 = cut(carrconlkm), group(3)

ivtobit pctdefor (treat =eligible98 eligible99 elig98_ind elig99_ind) indice95 ind2 ind3 ind4 perforestK  lnarea lnpob ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9 if rdlen2==0, ll(0) 
est2vec roads2, replace e(ll) vars(treat treatinv lowdensity )
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))

ivreg d (treat =eligible98 eligible99 elig98_ind elig99_ind) indice95 ind2 ind3 ind4 perforestK  lnarea lnpob ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9 if rdlen2==0, robust 
est2vec roads2, addto(roads2) name(ols0)

ivtobit pctdefor (treat =eligible98 eligible99 elig98_ind elig99_ind) ind2 ind3 ind4 ///
indice95 perforestK  lnarea lnslope lnpob  ecoregNEW6 ecoregNEW7 ecoregNEW9 if rdlen2==1,  ll(0)  
est2vec roads2, addto(roads2) name(rdlen21)
mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))

ivreg d (treat =eligible98 eligible99 elig98_ind elig99_ind) indice95 ind2 ind3 ind4 perforestK  lnarea lnpob ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9 if rdlen2==1, robust 
est2vec roads2, addto(roads2) name(ols1)

ivtobit pctdefor (treat =eligible98 eligible99 elig98_ind elig99_ind) ind2 ind3 ind4 ///
	indice95 perforestK lnarea lnpob lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9 if rdlen2==2,  ll(0) 
est2vec roads2, addto(roads2) name(rdlen22)

mfx compute, predict(pr(0,.))
mfx compute, predict(e(0,.))


ivreg d (treat =eligible98 eligible99 elig98_ind elig99_ind) indice95 ind2 ind3 ind4 perforestK  lnarea lnpob ///
lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9 if rdlen2==2, robust 
est2vec roads2, addto(roads2) name(ols2)

gen lowdensity = rdlen2 == 0
gen eliglow = eligible99*lowdensity
gen treatinv = treat*lowdensity
gen elig98low = eligible98*lowdensity
gen ind98low = elig98_ind*lowdensity
gen ind99low = elig99_ind*lowdensity

ivtobit pctdefor (treat  treatinv = eligible99 eliglow elig98_ind elig99_ind elig98low ind98low ind99low ) indice95 ind2 ind3 ind4 lowdensity perforestK  lnarea lnpob ///
 lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9, twostep ll(0)
 est2vec roads2, addto(roads2) name(tobitinteract)

ivreg d (treat  treatinv =eligible98 eligible99 elig98_ind elig99_ind eliglow elig98low ind98low ind99low) indice95 ind2 ind3 ind4 lowdensity perforestK  lnarea lnpob ///
 lnslope  ecoregNEW6 ecoregNEW7 ecoregNEW9, robust
est2vec roads2, addto(roads2) name(olsinteract)
 
est2tex roads2, replace mark(stars) fancy preserve levels(90 95 99) label




log close  
