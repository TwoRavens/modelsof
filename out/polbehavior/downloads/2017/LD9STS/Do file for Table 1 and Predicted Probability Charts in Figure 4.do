ext_emo totml totwords_ads /*
   */ age male educ faminc_imp white partyad rep dem ideo3 sadmusic neg_scholar newsint2 strpart if sponopp2==0 [pw=weight_ct], || video: 

/*Table 1*/

melogit ext_emo totml totwords_ad /*
   */ age male educ faminc_imp white partyad rep dem ideo3 sadmusic neg_scholar newsint2 strpart if sponopp2==0 [pw=weight_ct], || video: 
outreg2 using test2.doc, dec(2) se paren(se) excel replace

melogit ext_emo totml totwords_ad /*
   */ age male educ faminc_imp white partyad rep dem ideo3 sadmusic neg_scholar newsint2 strpart if sponopp2==1 [pw=weight_ct], || video: 
outreg2 using test2.doc, dec(2) se paren(se) excel

meologit memorable ext_emo /*
   */ age male educ faminc_imp white partyad rep dem ideo3 sadmusic neg_scholar newsint2 strpart [pw=weight_ct], || video: 
outreg2 using test2.doc, dec(2) se paren(se) excel

menbreg  totwords_rec ext_emo /*
   */ age male educ faminc_imp white partyad rep dem ideo3 sadmusic neg_scholar newsint2 strpart [pw=weight_ct], || video: 
outreg2 using test2.doc, dec(2) se paren(se) excel


/*Predicted Probabilites Based on Table1*/
set scheme s1mono
quietly melogit ext_emo totml totwords_ad /*
   */ age male educ faminc_imp white partyad rep dem ideo3 sadmusic neg_scholar newsint2 strpart if sponopp2==0 [pw=weight_ct], || video: 
margins, at(totml=(0 2 4 6))

   
quietly melogit ext_emo totml totwords_ad /*
   */ age male educ faminc_imp white partyad rep dem ideo3 sadmusic neg_scholar newsint2 strpart if sponopp2==1 [pw=weight_ct], || video: 
margins, at(totml=(0 2 4 6))

quietly meologit memorable i.ext_emo /*
   */ age male educ faminc_imp white partyad rep dem ideo3 sadmusic neg_scholar newsint2 strpart [pw=weight_ct], || video: 
margins, at(ext_emo=(0 1))

menbreg  totwords_rec i.ext_emo /*
   */ age male educ faminc_imp white partyad rep dem ideo3 sadmusic neg_scholar newsint2 strpart [pw=weight_ct], || video: 
margins, at(ext_emo=(0 1))
