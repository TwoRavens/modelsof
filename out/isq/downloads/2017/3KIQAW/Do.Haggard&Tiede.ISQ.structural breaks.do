*/Structural break do file
*/recode fh_pr(1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1), pre(new) test
*/recode fh_cl (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1), pre(new) test
*/recode ciri_kill (0=2) (1=1) (2=0), pre(new) test

*/rename cname country
*/sort country year
*/keep country ccode year p_polity2 newfh_cl newfh_pr h_polcon5 h_j ti_cpi wbgi_cce wbgi_rle hf_prights fi_legprop
*/keep if country=="Argentina" | country=="Azerbaijan" |  country=="Bangladesh" | country=="Bosnia and Herzegovina" | country=="Cambodia" |  country=="Central African Republic" | country=="Chad" |  country=="Congo"  | country=="Croatia" | country=="Djibouti" |  country=="Egypt" |  country=="El Salvador"  | country=="Ethiopia" | country=="Georgia" |  country=="Guatemala" |  country=="Guinea-Bissau" |  country=="Haiti" |  country=="Iran" |  country=="Iraq" |  country=="Jordan" |  country=="Kenya" |  country=="Laos" |  country=="Lebanon" |  country=="Mali" |  country=="Moldova" |  country=="Morocco" |  country=="Mozambique" |  country=="Myanmar" |  country=="Namibia" |  country=="Nicaragua" |  country=="Nigeria" |  country=="Oman" |  country=="Pakistan" |  country=="Papua New Guinea" |  country=="Peru" |  country=="Rwanda" |  country=="Senegal" |  country=="South Africa" |  country=="Syria" |  country=="Tajikistan" |  country=="Thailand" |  country=="Turkey" |  country=="Vietnam" |  country=="Yemen" |  country=="Yemen People's Republic" |  country=="Zimbabwe" | country=="Yugoslavia"
 
*/For each country determine range of variables and if any missing for each variable as well as AO and IO for each variable
clemao1 p_polity2 if country=="Argentina", maxlag(2)
clemao1 newfh_cl  if country=="Argentina", maxlag(2)
clemao1 newfh_pr if country=="Argentina", maxlag(2)
clemao1 h_polcon5 if country=="Argentina", maxlag(2)
clemao1 h_j if country=="Argentina", maxlag(2)


clemao1 p_polity2 if country=="Azerbaijan", maxlag(2)
clemao1 newfh_cl  if country=="Azerbaijan", maxlag(2)
clemao1 newfh_pr if country=="Azerbaijan", maxlag(2)
clemao1 wbgi_cce if country=="Azerbaijan", maxlag(2)
clemao1 wbgi_rle if country=="Azerbaijan", maxlag(2)


clemao1 p_polity2 if country=="Bangladesh" , maxlag(2)
clemao1 newfh_cl if country=="Bangladesh" , maxlag(2)
clemao1 newfh_pr if country=="Bangladesh" , maxlag(2)
clemao1 h_polcon5 if country=="Bangladesh"  , maxlag(2)
clemao1 wbgi_cce if country=="Bangladesh" , maxlag(2)
clemao1 wbgi_rle if country=="Bangladesh" , maxlag(2)



clemao1 newfh_cl if country=="Bosnia and Herzegovina" , maxlag(2) 
clemao1 newfh_pr if country=="Bosnia and Herzegovina" , maxlag(2) 
clemao1 ti_cpi  if country=="Bosnia and Herzegovina" , maxlag(2)
clemao1 wbgi_cce  if country=="Bosnia and Herzegovina" , maxlag(2)
clemao1 wbgi_rle  if country=="Bosnia and Herzegovina" , maxlag(2)




clemao1 newfh_cl if country=="Cambodia"  , maxlag(2) 
clemao1 newfh_pr if country=="Cambodia"  , maxlag(2) 
clemao1 h_polcon5  if country=="Cambodia"  , maxlag(2)



clemao1 p_polity2 if country=="Central African Republic"  , maxlag(2)
clemao1 newfh_cl if country=="Central African Republic"  , maxlag(2)
clemao1 newfh_pr if country=="Central African Republic"  , maxlag(2)
clemao1 h_polcon5  if country=="Central African Republic"  , maxlag(2)
clemao1 wbgi_cce  if country=="Central African Republic"  , maxlag(2)
clemao1 wbgi_rle  if country=="Central African Republic"  , maxlag(2)


clemao1 p_polity2 if country=="Chad", maxlag(2)
clemao1 p_polity2 if country=="Chad", maxlag(2)
clemao1 newfh_cl  if country=="Chad", maxlag(2)
clemao1 newfh_pr if country=="Chad", maxlag(2)
clemao1 wbgi_cce  if country=="Chad", maxlag(2)
clemao1 wbgi_rle if country=="Chad", maxlag(2)



clemio1 p_polity2 if country=="Chad", maxlag(2)
clemio1 newfh_cl if country=="Chad", maxlag(2)
clemio1 newfh_pr if country=="Chad", maxlag(2)
clemio1 wbgi_cce  if country=="Chad", maxlag(2)
clemio1 wbgi_rle  if country=="Chad", maxlag(2)




clemao1 p_polity2 if country=="Congo", maxlag(2)
clemao1 newfh_cl if country=="Congo", maxlag(2)
clemao1 newfh_pr if country=="Congo", maxlag(2)
clemao1 h_polcon5 if country=="Congo", maxlag(2)
clemao1 wbgi_cce  if country=="Congo", maxlag(2)
clemao1 wbgi_rle  if country=="Congo", maxlag(2)
clemao1 hf_prights  if country=="Congo", maxlag(2)
clemao1 fi_legprop  if country=="Congo", maxlag(2)


clemio1 p_polity2 if country=="Congo", maxlag(2)
clemio1 newfh_cl if country=="Congo", maxlag(2)
clemio1 newfh_pr if country=="Congo", maxlag(2)
clemio1 h_polcon5 if country=="Congo", maxlag(2)
clemio1 wbgi_cce  if country=="Congo", maxlag(2)
clemio1 wbgi_rle  if country=="Congo", maxlag(2)
clemio1 hf_prights  if country=="Congo", maxlag(2)

clemao1 p_polity2 if country=="Croatia", maxlag(2)
clemao1 newfh_cl if country=="Croatia", maxlag(2)
clemao1 newfh_pr if country=="Croatia", maxlag(2)
clemao1 h_polcon5 if country=="Croatia", maxlag(2)
clemao1 h_j  if country=="Croatia", maxlag(2)
clemao1 ti_cpi if country=="Croatia", maxlag(2)
clemao1 wbgi_cce  if country=="Croata", maxlag(2)
clemao1 wbgi_rle  if country=="Croatia", maxlag(2)
clemao1 hf_prights  if country=="Croatia", maxlag(2)
clemao1 fi_legprop  if country=="Croatia", maxlag(2)


clemio1 p_polity2 if country=="Croatia", maxlag(2)
clemio1 newfh_cl if country=="Croatia", maxlag(2)
clemio1 newfh_pr if country=="Croatia", maxlag(2)
clemio1 h_polcon5 if country=="Croatia", maxlag(2)
clemio1 h_j  if country=="Croatia", maxlag(2)
clemio1 ti_cpi if country=="Croatia", maxlag(2)
clemio1 hf_prights  if country=="Croatia", maxlag(2)


clemao1 p_polity2 if country=="Djibouti", maxlag(2)
clemao1 newfh_cl if country=="Djibouti", maxlag(2)
clemao1 newfh_pr if country=="Djibouti", maxlag(2)
clemao1 wbgi_cce  if country=="Djibouti", maxlag(2)
clemao1 wbgi_rle  if country=="Djibouti", maxlag(2)
clemao1 hf_prights  if country=="Djibouti", maxlag(2)

clemio1 p_polity2 if country=="Djibouti", maxlag(2)
clemio1 newfh_cl if country=="Djibouti", maxlag(2)
clemio1 newfh_pr if country=="Djibouti", maxlag(2)
clemio1 wbgi_cce  if country=="Djibouti", maxlag(2)
clemio1 wbgi_rle  if country=="Djibouti", maxlag(2)
clemio1 hf_prights  if country=="Djibouti", maxlag(2)


clemao1 p_polity2 if country=="Egypt", maxlag(2)
clemao1 newfh_cl  if country=="Egypt", maxlag(2)
clemao1 newfh_pr if country=="Egypt", maxlag(2)
clemao1 h_polcon5 if country=="Egypt", maxlag(2)
clemao1 h_j if country=="Egypt", maxlag(2)
clemao1 wbgi_cce if country=="Egypt", maxlag(2)
clemao1 wbgi_rle if country=="Egypt", maxlag(2)

clemio1 p_polity2 if country=="Egypt", maxlag(2)
clemio1 newfh_cl  if country=="Egypt", maxlag(2)
clemio1 newfh_pr if country=="Egypt", maxlag(2)
clemio1 h_polcon5 if country=="Egypt", maxlag(2)
clemio1 h_j if country=="Egypt", maxlag(2)
clemio1 wbgi_cce if country=="Egypt", maxlag(2)
clemio1 wbgi_rle if country=="Egypt", maxlag(2)




clemao1 p_polity2 if country=="El Salvador", maxlag(2)
clemao1 newfh_cl  if country=="El Salvador", maxlag(2)
clemao1 newfh_pr if country=="El Salvador", maxlag(2)
clemao1 h_polcon5 if country=="El Salvador", maxlag(2)

clemio1 p_polity2 if country=="El Salvador", maxlag(2)
clemio1 newfh_cl  if country=="El Salvador", maxlag(2)
clemio1 newfh_pr if country=="El Salvador", maxlag(2)
clemio1 h_polcon5 if country=="El Salvador", maxlag(2)


clemao1 newfh_cl  if country=="Ethiopia (1993-)", maxlag(2)
clemao1 newfh_pr if country=="Ethiopia (1993-)", maxlag(2)
clemao1 h_polcon5 if country=="Ethiopia (1993-)", maxlag(2)

clemio1 newfh_cl  if country=="Ethiopia (1993-)", maxlag(2)
clemio1 newfh_pr if country=="Ethiopia (1993-)", maxlag(2)
clemio1 h_polcon5 if country=="Ethiopia (1993-)", maxlag(2)



clemao1 newfh_cl  if country=="Georgia", maxlag(2)
clemao1 newfh_pr if country=="Georgia", maxlag(2)
clemao1 h_polcon5 if country=="Georgia", maxlag(2)
clemao1 wbgi_cce if country=="Georgia", maxlag(2)
clemao1 wbgi_rle if country=="Georgia", maxlag(2)
clemao1 wbgi_cce if country=="Georgia", maxlag(2)
clemao1 wbgi_rle if country=="Georgia", maxlag(2)
clemao1 hf_prights if country=="Georgia", maxlag(2)



clemio1 newfh_cl  if country=="Georgia", maxlag(2)
clemio1 newfh_pr if country=="Georgia", maxlag(2)
clemio1 h_polcon5 if country=="Georgia", maxlag(2)
clemio1 wbgi_cce if country=="Georgia", maxlag(2)
clemio1 wbgi_rle if country=="Georgia", maxlag(2)
clemio1 hf_prights if country=="Georgia", maxlag(2)
clemio1 wbgi_cce if country=="Georgia", maxlag(2)
clemio1 wbgi_rle if country=="Georgia", maxlag(2)
clemio1 hf_prights if country=="Georgia", maxlag(2)


clemao1 p_polity2 if country=="Guatemala", maxlag(2)
clemao1 newfh_cl  if country=="Guatemala", maxlag(2)
clemao1 newfh_pr if country=="Guatemala", maxlag(2)
clemao1 h_polcon5 if country=="Guatemala", maxlag(2)
clemao1 wbgi_cce if country=="Guatemala", maxlag(2)
clemao1 wbgi_rle if country=="Guatemala", maxlag(2)
clemao1 hf_prights if country=="Guatemala", maxlag(2)

clemio1 p_polity2 if country=="Guatemala", maxlag(2)
clemio1 newfh_cl  if country=="Guatemala", maxlag(2)
clemio1 newfh_pr if country=="Guatemala", maxlag(2)
clemio1 h_polcon5 if country=="Guatemala", maxlag(2)
clemio1 wbgi_cce if country=="Guatemala", maxlag(2)
clemio1 wbgi_rle if country=="Guatemala", maxlag(2)
clemio1 hf_prights if country=="Guatemala", maxlag(2)

clemao1 p_polity2 if country=="Guinea-Bissau", maxlag(2)
clemao1 newfh_cl  if country=="Guinea-Bissau", maxlag(2)
clemao1 newfh_pr if country=="Guinea-Bissau", maxlag(2)
clemao1 h_polcon5 if country=="Guinea-Bissau", maxlag(2)


clemio1 p_polity2 if country=="Guinea-Bissau", maxlag(2)
clemio1 newfh_cl  if country=="Guinea-Bissau", maxlag(2)
clemio1 newfh_pr if country=="Guinea-Bissau", maxlag(2)
clemio1 h_polcon5 if country=="Guinea-Bissau", maxlag(2)


clemao1 ti_cpi  if country=="Haiti", maxlag(2)
clemao1 wbgi_cce if country=="Haiti", maxlag(2)
clemao1 wbgi_rle if country=="Haiti", maxlag(2)
clemao1 ti_cpi  if country=="Haiti", maxlag(2)
clemao1 wbgi_cce if country=="Haiti", maxlag(2)
clemao1 wbgi_rle if country=="Haiti", maxlag(2)


clemio1 ti_cpi  if country=="Haiti", maxlag(2)
clemio1 wbgi_cce if country=="Haiti", maxlag(2)
clemio1 wbgi_rle if country=="Haiti", maxlag(2)
clemio1 ti_cpi  if country=="Haiti", maxlag(2)
clemio1 wbgi_cce if country=="Haiti", maxlag(2)
clemio1 wbgi_rle if country=="Haiti", maxlag(2)

clemao1 p_polity2 if country=="Iran", maxlag(2)
clemao1 newfh_cl  if country=="Iran", maxlag(2)
clemao1 newfh_pr if country=="Iran", maxlag(2)
clemao1 h_polcon5 if country=="Iran", maxlag(2)


clemio1 p_polity2 if country=="Iran", maxlag(2)
clemio1 newfh_cl  if country=="Iran", maxlag(2)
clemio1 newfh_pr if country=="Iran", maxlag(2)
clemio1 h_polcon5 if country=="Iran", maxlag(2)


clemao1 p_polity2 if country=="Iraq", maxlag(2)
clemao1 newfh_cl  if country=="Iraq", maxlag(2)
clemao1 newfh_pr if country=="Iraq", maxlag(2)
clemao1 wbgi_cce if country=="Iraq", maxlag(2)
clemao1 wbgi_rle if country=="Iraq", maxlag(2)


clemio1 p_polity2 if country=="Iraq", maxlag(2)
clemio1 newfh_cl  if country=="Iraq", maxlag(2)
clemio1 newfh_pr if country=="Iraq", maxlag(2)
clemio1 wbgi_cce if country=="Iraq", maxlag(2)
clemio1 wbgi_rle if country=="Iraq", maxlag(2)



clemao1 p_polity2 if country=="Jordan", maxlag(2)
clemao1 newfh_cl  if country=="Jordan", maxlag(2)
clemao1 newfh_pr if country=="Jordan", maxlag(2)
clemao1 h_polcon5 if country=="Jordan", maxlag(2)
clemao1 h_j if country=="Jordan", maxlag(2)


clemio1 p_polity2 if country=="Jordan", maxlag(2)
clemio1 newfh_cl  if country=="Jordan", maxlag(2)
clemio1 newfh_pr if country=="Jordan", maxlag(2)
clemio1 h_polcon5 if country=="Jordan", maxlag(2)
clemio1 h_j if country=="Jordan", maxlag(2)



clemao1 p_polity2 if country=="Kenya", maxlag(2)
clemao1 newfh_cl  if country=="Kenya", maxlag(2)
clemao1 newfh_pr if country=="Kenya", maxlag(2)
clemao1 h_polcon5 if country=="Kenya", maxlag(2)
clemao1 h_j if country=="Kenya", maxlag(2)


clemio1 p_polity2 if country=="Kenya", maxlag(2)
clemio1 newfh_cl  if country=="Kenya", maxlag(2)
clemio1 newfh_pr if country=="Kenya", maxlag(2)
clemio1 h_polcon5 if country=="Kenya", maxlag(2)
clemio1 h_j if country=="Kenya", maxlag(2)



clemao1 p_polity2 if country=="Laos", maxlag(2)
clemao1 newfh_cl  if country=="Laos", maxlag(2)
clemao1 newfh_pr if country=="Laos", maxlag(2)
clemao1 h_polcon5 if country=="Laos", maxlag(2)

clemio1 p_polity2 if country=="Laos", maxlag(2)
clemio1 newfh_cl  if country=="Laos", maxlag(2)
clemio1 newfh_pr if country=="Laos", maxlag(2)
clemio1 h_polcon5 if country=="Laos", maxlag(2)


clemao1 newfh_cl  if country=="Lebanon", maxlag(2)
clemao1 newfh_pr if country=="Lebanon", maxlag(2)
clemao1 h_polcon5 if country=="Lebanon", maxlag(2)



clemio1 newfh_cl  if country=="Lebanon", maxlag(2)
clemio1 newfh_pr if country=="Lebanon", maxlag(2)
clemio1 h_polcon5 if country=="Lebanon", maxlag(2)




clemao1 p_polity2 if country=="Mali", maxlag(2)
clemao1 newfh_cl  if country=="Mali", maxlag(2)
clemao1 newfh_pr if country=="Mali", maxlag(2)
clemao1 h_polcon5 if country=="Mali", maxlag(2)
clemao1 wbgi_cce if country=="Mali", maxlag(2)
clemao1 wbgi_rle if country=="Mali", maxlag(2)
clemao1 hf_prights if country=="Mali", maxlag(2)



clemio1 p_polity2 if country=="Mali", maxlag(2)
clemio1 newfh_cl  if country=="Mali", maxlag(2)
clemio1 newfh_pr if country=="Mali", maxlag(2)
clemio1 h_polcon5 if country=="Mali", maxlag(2)
clemio1 wbgi_cce if country=="Mali", maxlag(2)
clemio1 wbgi_rle if country=="Mali", maxlag(2)
clemio1 hf_prights if country=="Mali", maxlag(2)


clemao1 p_polity2 if country=="Moldova", maxlag(2)
clemao1 newfh_cl  if country=="Moldova", maxlag(2)
clemao1 newfh_pr if country=="Moldova", maxlag(2)

clemio1 p_polity2 if country=="Moldova", maxlag(2)
clemio1 newfh_cl  if country=="Moldova", maxlag(2)
clemio1 newfh_pr if country=="Moldova", maxlag(2)

clemao1 p_polity2 if country=="Morocco", maxlag(2)
clemao1 newfh_cl  if country=="Morocco", maxlag(2)
clemao1 newfh_pr if country=="Morocco", maxlag(2)
clemao1 h_polcon5 if country=="Morocco", maxlag(2)
clemao1 h_j if country=="Morocco", maxlag(2)

clemio1 p_polity2 if country=="Morocco", maxlag(2)
clemio1 newfh_cl  if country=="Morocco", maxlag(2)
clemio1 newfh_pr if country=="Morocco", maxlag(2)
clemio1 h_polcon5 if country=="Morocco", maxlag(2)
clemio1 h_j if country=="Morocco", maxlag(2)


clemao1 p_polity2 if country=="Mozambique", maxlag(2)
clemao1 newfh_cl  if country=="Mozambique", maxlag(2)
clemao1 newfh_pr if country=="Mozambique", maxlag(2)
clemao1 h_polcon5 if country=="Mozambique", maxlag(2)
clemio1 p_polity2 if country=="Mozambique", maxlag(2)
clemio1 newfh_cl  if country=="Mozambique", maxlag(2)
clemio1 newfh_pr if country=="Mozambique", maxlag(2)
clemio1 h_polcon5 if country=="Mozambique", maxlag(2)

clemao1 p_polity2 if country=="Myanmar", maxlag(2)
clemao1 newfh_cl  if country=="Myanmar", maxlag(2)
clemao1 newfh_pr if country=="Myanmar", maxlag(2)
clemao1 wbgi_cce if country=="Myanmar", maxlag(2)
clemao1 wbgi_rle if country=="Myanmar", maxlag(2)
clemao1 hf_prights if country=="Myanmar", maxlag(2)

clemio1 p_polity2 if country=="Myanmar", maxlag(2)
clemio1 newfh_cl  if country=="Myanmar", maxlag(2)
clemio1 newfh_pr if country=="Myanmar", maxlag(2)
clemio1 wbgi_cce if country=="Myanmar", maxlag(2)
clemio1 wbgi_rle if country=="Myanmar", maxlag(2)
clemio1 hf_prights if country=="Myanmar", maxlag(2)



clemao1 newfh_cl  if country=="Namibia", maxlag(2)
clemao1 newfh_pr if country=="Namibia", maxlag(2)
clemao1 h_polcon5 if country=="Namibia", maxlag(2)


clemio1 newfh_cl  if country=="Namibia", maxlag(2)
clemio1 newfh_pr if country=="Namibia", maxlag(2)
clemio1 h_polcon5 if country=="Namibia", maxlag(2)



clemao1 p_polity2 if country=="Nicaragua", maxlag(2)
clemao1 newfh_cl  if country=="Nicaragua", maxlag(2)
clemao1 newfh_pr if country=="Nicaragua", maxlag(2)
clemao1 h_polcon5 if country=="Nicaragua", maxlag(2)
clemao1 h_j if country=="Nicaragua", maxlag(2)

clemio1 p_polity2 if country=="Nicaragua", maxlag(2)
clemio1 newfh_cl  if country=="Nicaragua", maxlag(2)
clemio1 newfh_pr if country=="Nicaragua", maxlag(2)
clemio1 h_polcon5 if country=="Nicaragua", maxlag(2)
clemio1 h_j if country=="Nicaragua", maxlag(2)


clemao1 p_polity2 if country=="Nigeria", maxlag(2)
clemao1 newfh_cl  if country=="Nigeria", maxlag(2)
clemao1 newfh_pr if country=="Nigeria", maxlag(2)
clemao1 h_polcon5 if country=="Nigeria", maxlag(2)

clemio1 p_polity2 if country=="Nigeria", maxlag(2)
clemio1 newfh_cl  if country=="Nigeria", maxlag(2)
clemio1 newfh_pr if country=="Nigeria", maxlag(2)
clemio1 h_polcon5 if country=="Nigeria", maxlag(2)

clemao1 p_polity2 if country=="Oman", maxlag(2)
clemao1 newfh_cl  if country=="Oman", maxlag(2)
clemao1 newfh_pr if country=="Oman", maxlag(2)

clemio1 p_polity2 if country=="Oman", maxlag(2)
clemio1 newfh_cl  if country=="Oman", maxlag(2)
clemio1 newfh_pr if country=="Oman", maxlag(2)


clemao1 newfh_cl  if country=="Pakistan (1972-)", maxlag(2)
clemao1 newfh_pr if country=="Pakistan (1972-)", maxlag(2)
clemao1 h_polcon5 if country=="Pakistan (1972-)", maxlag(2)
clemao1 h_j if country=="Pakistan (1972-)", maxlag(2)
clemao1 wbgi_cce if country=="Pakistan (1972-)", maxlag(2)
clemao1 wbgi_rle if country=="Pakistan (1972-)", maxlag(2)
clemao1 hf_prights if country=="Pakistan (1972-)", maxlag(2)



clemio1 newfh_cl  if country=="Pakistan (1972-)", maxlag(2)
clemio1 newfh_pr if country=="Pakistan (1972-)", maxlag(2)
clemio1 h_polcon5 if country=="Pakistan (1972-)", maxlag(2)
clemio1 hf_prights if country=="Pakistan (1972-)", maxlag(2)
clemio1 h_j if country=="Pakistan (1972-)", maxlag(2)
clemio1 wbgi_cce if country=="Pakistan", maxlag(2)
clemio1 wbgi_rle if country=="Pakistan", maxlag(2)
clemio1 hf_prights if country=="Pakistan", maxlag(2)



clemao1 newfh_cl  if country=="Papua New Guinea", maxlag(2)
clemao1 newfh_pr if country=="Papua New Guinea", maxlag(2)
clemao1 h_polcon5 if country=="Papua New Guinea", maxlag(2)
clemao1 h_j if country=="Papua New Guinea", maxlag(2)
clemao1 wbgi_cce if country=="Papua New Guinea", maxlag(2)
clemao1 wbgi_rle if country=="Papua New Guinea", maxlag(2)

clemio1 newfh_cl  if country=="Papua New Guinea", maxlag(2)
clemio1 newfh_pr if country=="Papua New Guinea", maxlag(2)
clemio1 h_polcon5 if country=="Papua New Guinea", maxlag(2)
clemio1 h_j if country=="Papua New Guinea", maxlag(2)
clemio1 wbgi_cce if country=="Papua New Guinea", maxlag(2)
clemio1 wbgi_rle if country=="Papua New Guinea", maxlag(2)

clemao1 p_polity2 if country=="Peru", maxlag(2)
clemao1 newfh_cl  if country=="Peru", maxlag(2)
clemao1 newfh_pr if country=="Peru", maxlag(2)
clemao1 h_polcon5 if country=="Peru", maxlag(2)
clemao1 wbgi_cce if country=="Peru", maxlag(2)
clemao1 wbgi_rle if country=="Peru", maxlag(2)
clemao1 hf_prights if country=="Peru", maxlag(2)

clemio1 p_polity2 if country=="Peru", maxlag(2)
clemio1 newfh_cl  if country=="Peru", maxlag(2)
clemio1 newfh_pr if country=="Peru", maxlag(2)
clemio1 h_polcon5 if country=="Peru", maxlag(2)
clemio1 wbgi_cce if country=="Peru", maxlag(2)
clemio1 wbgi_rle if country=="Peru", maxlag(2)
clemio1 hf_prights if country=="Peru", maxlag(2)


clemao1 p_polity2 if country=="Rwanda", maxlag(2)
clemao1 newfh_cl  if country=="Rwanda", maxlag(2)
clemao1 newfh_pr if country=="Rwanda", maxlag(2)
clemao1 h_polcon5 if country=="Rwanda", maxlag(2)
clemao1 wbgi_cce if country=="Rwanda", maxlag(2)
clemao1 wbgi_rle if country=="Rwanda", maxlag(2)
clemao1 hf_prights if country=="Rwanda", maxlag(2)

clemio1 p_polity2 if country=="Rwanda", maxlag(2)
clemio1 newfh_cl  if country=="Rwanda", maxlag(2)
clemio1 newfh_pr if country=="Rwanda", maxlag(2)
clemio1 h_polcon5 if country=="Rwanda", maxlag(2)
clemio1 wbgi_cce if country=="Rwanda", maxlag(2)
clemio1 wbgi_rle if country=="Rwanda", maxlag(2)
clemio1 hf_prights if country=="Rwanda", maxlag(2)

clemao1 p_polity2 if country=="Senegal", maxlag(2)
clemao1 newfh_cl  if country=="Senegal", maxlag(2)
clemao1 newfh_pr if country=="Senegal", maxlag(2)
clemao1 h_polcon5 if country=="Senegal", maxlag(2)
clemao1 wbgi_cce if country=="Senegal", maxlag(2)
clemao1 wbgi_rle if country=="Senegal", maxlag(2)

clemio1 p_polity2 if country=="Senegal", maxlag(2)
clemio1 newfh_cl  if country=="Senegal", maxlag(2)
clemio1 newfh_pr if country=="Senegal", maxlag(2)
clemio1 h_polcon5 if country=="Senegal", maxlag(2)
clemio1 wbgi_cce if country=="Senegal", maxlag(2)
clemio1 wbgi_rle if country=="Senegal", maxlag(2)




clemao1 newfh_cl  if country=="South Africa", maxlag(2)
clemao1 newfh_pr if country=="South Africa", maxlag(2)
clemao1 h_polcon5 if country=="South Africa", maxlag(2)
clemao1 h_j if country=="South Africa", maxlag(2)
clemao1 wbgi_cce if country=="South Africa", maxlag(2)
clemao1 wbgi_rle if country=="South Africa", maxlag(2)
clemio1 newfh_cl  if country=="South Africa", maxlag(2)
clemio1 newfh_pr if country=="South Africa", maxlag(2)
clemio1 h_polcon5 if country=="South Africa", maxlag(2)
clemio1 h_j if country=="South Africa", maxlag(2)
clemio1 wbgi_cce if country=="South Africa", maxlag(2)
clemio1 wbgi_rle if country=="South Africa", maxlag(2)



clemao1 p_polity2 if country=="Syria", maxlag(2)
clemao1 newfh_cl  if country=="Syria", maxlag(2)
clemao1 newfh_pr if country=="Syria", maxlag(2)
clemao1 h_polcon5 if country=="Syria", maxlag(2)
clemao1 h_j if country=="Syria", maxlag(2)

clemio1 p_polity2 if country=="Syria", maxlag(2)
clemio1 newfh_cl  if country=="Syria", maxlag(2)
clemio1 newfh_pr if country=="Syria", maxlag(2)
clemio1 h_polcon5 if country=="Syria", maxlag(2)
clemio1 h_j if country=="Syria", maxlag(2)



clemao1 p_polity2 if country=="Tajikistan" , maxlag(2)
clemao1 newfh_cl  if country=="Tajikistan" , maxlag(2)
clemao1 h_polcon5 if country=="Tajikistan" , maxlag(2)
clemao1 ti_cpi  if country=="Tajikistan" , maxlag(2)
clemao1 wbgi_cce if country=="Tajikistan" , maxlag(2)
clemao1 wbgi_rle if country=="Tajikistan" , maxlag(2)

clemio1 p_polity2 if country=="Tajikistan" , maxlag(2)
clemio1 newfh_cl  if country=="Tajikistan" , maxlag(2)
clemio1 h_polcon5 if country=="Tajikistan" , maxlag(2)
clemio1 ti_cpi  if country=="Tajikistan" , maxlag(2)
clemio1 wbgi_cce if country=="Tajikistan" , maxlag(2)
clemio1 wbgi_rle if country=="Tajikistan" , maxlag(2)

clemao1 p_polity2 if country=="Thailand" , maxlag(2)
clemao1 newfh_cl  if country=="Thailand" , maxlag(2)
clemao1 h_polcon5 if country=="Thailand" , maxlag(2)
clemao1 newfh_pr if country=="Thailand" , maxlag(2)
clemao1 h_j if country=="Thailand" , maxlag(2)


clemio1 p_polity2 if country=="Thailand" , maxlag(2)
clemio1 newfh_cl  if country=="Thailand" , maxlag(2)
clemio1 h_polcon5 if country=="Thailand" , maxlag(2)
clemio1 newfh_pr if country=="Thailand" , maxlag(2)
clemio1 h_j if country=="Thailand" , maxlag(2)

clemao1 p_polity2 if country=="Turkey" , maxlag(2)
clemao1 newfh_cl  if country=="Turkey" , maxlag(2)
clemao1 h_polcon5 if country=="Turkey" , maxlag(2)
clemao1 h_j if country=="Turkey", maxlag(2)
clemao1 wbgi_cce if country=="Turkey", maxlag(2)
clemao1 wbgi_rle if country=="Turkey", maxlag(2)
clemao1 hf_prights if country=="Turkey", maxlag(2)

clemio1 p_polity2 if country=="Turkey" , maxlag(2)
clemio1 newfh_cl  if country=="Turkey" , maxlag(2)
clemio1 h_polcon5 if country=="Turkey" , maxlag(2)
clemio1 h_j if country=="Turkey", maxlag(2)

clemio1 wbgi_cce if country=="Turkey", maxlag(2)
clemio1 wbgi_rle if country=="Turkey", maxlag(2)
clemio1 hf_prights if country=="Turkey", maxlag(2)


clemao1 newfh_cl  if country=="Vietnam", maxlag(2)
clemao1 newfh_pr if country=="Vietnam", maxlag(2)
clemao1 h_polcon5 if country=="Vietnam", maxlag(2)
clemao1 h_j if country=="Vietnam", maxlag(2)


clemio1 newfh_cl  if country=="Vietnam", maxlag(2)
clemio1 newfh_pr if country=="Vietnam", maxlag(2)
clemio1 h_polcon5 if country=="Vietnam", maxlag(2)
clemio1 h_j if country=="Vietnam", maxlag(2)

clemao1 p_polity2 if country=="Yemen", maxlag(2)
clemao1 newfh_cl  if country=="Yemen", maxlag(2)
clemao1 newfh_pr if country=="Yemen", maxlag(2)

clemio1 p_polity2 if country=="Yemen", maxlag(2)
clemio1 newfh_cl  if country=="Yemen", maxlag(2)
clemio1 newfh_pr if country=="Yemen", maxlag(2)





clemao1 newfh_cl  if country=="Serbia and Montenegro", maxlag(2)
clemao1 newfh_pr if country=="Serbia and Montenegro", maxlag(2)
clemao1 h_polcon5 if country=="Serbia and Montenegro", maxlag(2)

clemio1 newfh_cl  if country=="Serbia and Montenegro", maxlag(2)
clemio1 newfh_pr if country=="Serbia and Montenegro", maxlag(2)
clemio1 h_polcon5 if country=="Serbia and Montenegro", maxlag(2)

clemao1 p_polity2 if country=="Zimbabwe", maxlag(2)
clemao1 newfh_cl  if country=="Zimbabwe", maxlag(2)
clemao1 newfh_pr if country=="Zimbabwe", maxlag(2)
clemao1 h_polcon5 if country=="Zimbabwe", maxlag(2)
clemao1 h_j if country=="Zimbabwe", maxlag(2)



clemio1 p_polity2 if country=="Zimbabwe", maxlag(2)
clemio1 newfh_cl  if country=="Zimbabwe", maxlag(2)
clemio1 newfh_pr if country=="Zimbabwe", maxlag(2)
clemio1 h_polcon5 if country=="Zimbabwe", maxlag(2)
clemio1 h_j if country=="Zimbabwe", maxlag(2)

