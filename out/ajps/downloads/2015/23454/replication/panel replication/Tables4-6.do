version 12.1
*Primary Panels
use panel_data, clear


*Table 4
*Michigan gubernatorial Democrat
for num 1/2: sum ideo_bernero_X  ideo_dillon_X  if  state =="MI"  & party =="D"  & race_type =="G"
*Michigan gubernatorial Republican
for num 1/2: sum ideo_snyder_X ideo_cox_X ideo_bouchard_X ideo_hoekstra_X  ideo_dillon_X  if  state =="MI"  & party =="R"  & race_type =="G"
*New Hampshire gubernatorial Republican
for num 1/2: sum ideo_testerman_X ideo_stephen_X ideo_kimball_X if  state =="NH"  & party =="R"  & race_type =="G"
*New Hampshire senate Republican
for num 1/2: sum ideo_binnie_X ideo_bender_X ideo_ayotte_X ideo_lamontagne_X if  state =="NH"  & party =="R"  & race_type =="S"
*Pennsylvania gubernatorial Democrat
for num 1/2: sum ideo_hoeffel_X ideo_onorato_X ideo_wagner_X if state =="PA" & party =="D" & race_type =="G"
*Pennsylvania gubernatorial Republican
for var  rg_r_* rg_l_*: replace X = X*6+1 
for num 1/2: sum rg_l_X rg_r_X if state =="PA" & party =="R" & race_type =="G"
*Pennsylvania Senate Democratic 
for var  ds_r_* ds_l_*: replace X = X*6+1 
for num 1/2: sum ds_l_X ds_r_X if state =="PA" & party =="D" & race_type =="S"
*Pennsylvania Senate Republican
for var rs_r_* rs_l_*: replace X = X*6+1 
for num 1/2: sum rs_l_X rs_r_X  if  state =="PA" & party =="R" & race_type =="S"
*Sample sizes
table state party race_type  if  dv_2!=.  , c(freq)  

 
*Table 5 
 *learning *% and significance tests on learning
   by state party race_type , sort:ttest k_1 = k_2 if dv_1!=. & dv_2!=. &  dv_2!=.5 & ideo_1 !=. & ideo_2!=.  

*Table 6 
*extreme only
  for num 1/2: replace ideo_X =.  if ideo_X >.5 & ideo_X <.8  & party == "R"
  for num 1/2: replace ideo_X =1 if ideo_X > .8 &  ideo_X <.  & party == "R"  
  for num 1/2: replace ideo_X = 0 if ideo_X > 0 & ideo_X <.51  & party == "R"
  for num 1/2: replace ideo_X =1  if ideo_X >.49 & ideo_X <1  & party == "D"
  for num 1/2: replace ideo_X =. if ideo_X > .2 & ideo_X <.5  & party == "D"
  for num 1/2: replace ideo_X =0 if ideo_X < .2 & party == "D"

*create interactions between ideology and learning, knowing
for var kn_*: g ideo_1_X =ideo_1*X
for var kn_*: g dv_1_X =dv_1*X

*Drop placebo and incumbent cases before estimation
 *New Hampshire gubernatorial Republican primary (Kimball versus Stephen)
  drop if state == "NH" & party == "R" & race_type == "G"
 *drop Pennsylvania because Specter ran
  drop if state == "PA" & party == "D" & race_type == "S"
  drop if state == "PA" & party == "R" & race_type == "S"

saveold panel_data_extreme, replace

*indicator variable for surviving panel waves and expressing a vote intent and ideology in both waves
generate panel_sample =  dv_1!=. & dv_2!=. & dv_1!=.5 & dv_2!=.5 & ideo_1 !=. & ideo_2!=.
               
****Column 1 Cross-section estimate
reshape long   ideo_ dv_ k_, i(primary_code id) j(post) /*reshaped to estimate interaction*/
  replace post = post -1
  g idXpri = (id *100 )+primary_code 
  g ideoXpost = ideo_ *post
  g postXkn_0_1 = post*kn_0_1
  lab var ideo_ "Conserv. indicator" 
  lab var post "Post-election indicator" 
  lab var ideoXpost "Conserv. $\times$ Post" 
****cross-section estimate 
reg dv_ ideo_ post ideoXpost sample_* if  dv_!=.5, cluster(id) 
    outreg2 using table_6,ctitle(Base cs) se auto(2) e(rmse) replace noaster tex label
****cross-section estimate among panel respondents
reg dv_ ideo_ post ideoXpost sample_* if  panel_sample == 1, cluster(id) 
    outreg2 using table_6,ctitle(Base pn) se auto(2) e(rmse) append noaster tex label
****Estimates based on measures of ideology only from the earlier interview
use panel_data_extreme, clear
  lab var ideo_1 "Prior Conserv." 
  lab var kn_0_1 "Learning indicator" 
  lab var ideo_1_kn_0_1 "Prior Conserv. $\times$ Learning" 
  lab var dv_1 "Prior vote" 
  lab var dv_1_kn_0_1 "Prior vote $\times$ Learning" 
****lag specification
areg dv_2 ideo_1  dv_1 sample_* if  dv_1!=. & dv_2!=. & dv_1!=.5 & dv_2!=.5 & ideo_1 !=. & ideo_2!=.  , cluster(id) absorb(primary_code)
    outreg2 using table_6,ctitle(Lagg) se auto(2) e(rmse) append noaster tex label
****lag specification among learners and never learners
areg dv_2 ideo_1  dv_1 sample_* if (kn_0_1 == 1 | kn_0_0 == 1 ) & dv_1!=. & dv_2!=. & dv_1!=.5 & dv_2!=.5 & ideo_1 !=. & ideo_2!=., cluster(id) absorb(primary_code)
    outreg2 using table_6,ctitle(Lagg) se auto(2) e(rmse) append noaster tex label sortvar(ideo_ post ideoXpost ideo_1 ideo_2 ideo_1_kn_0_1  kn_0_1 dv_1 dv_1_kn_0_1 sample_* ) 
****lagged with learner interactions
areg dv_2 ideo_1 kn_0_1 ideo_1_kn_0_1  dv_1 dv_1_kn_0_1 sample_* if (kn_0_1 == 1 | kn_0_0 == 1 ) & dv_1!=. & dv_2!=. & dv_1!=.5 & dv_2!=.5 & ideo_1 !=. & ideo_2!=. , cluster(id) absorb(primary_code)  
    outreg2 using table_6,ctitle(Lagg) se auto(2) e(rmse) append noaster tex label sortvar(ideo_ post ideoXpost ideo_1 ideo_2 ideo_1_kn_0_1  kn_0_1 dv_1 dv_1_kn_0_1 sample_*)
****lagged specification with their interactions and undecideds
areg dv_2 ideo_1 kn_0_1 ideo_1_kn_0_1 dv_1 dv_1_kn_0_1 sample_* if (kn_0_1 == 1 | kn_0_0 == 1 ) & dv_1!=. & dv_2!=. &  dv_2!=.5 & ideo_1 !=. & ideo_2!=. , cluster(id) absorb(primary_code)
    outreg2 using table_6,ctitle(Lagg) se auto(2) e(rmse) append noaster tex label sortvar(ideo_ post ideoXpost ideo_1 ideo_2 ideo_1_kn_0_1  kn_0_1 dv_1 dv_1_kn_0_1 sample_* ) 



