/****************************************************
  MAAK INFO OVER PREVIOUS WERK, GEEN WERK EN MIGRATIE

NB after SET_STSET 
*****************************************************/

/****************************
 PREVIOUS unemployed info while currently employed
*****************************/
gen prevonben_werk =  0
by rin: replace prevonben_werk = (SECa1[_n-1] >=3 & SECa1[_n-1] <=8) ///
    if repwerk &  numwerk > numwerk[_n-1] & indnwmigper==0
by rin: replace prevonben_werk = prevonben_werk[_n-1] if repwerk & ///
     numwerk == numwerk[_n-1] & indnwmigper==0
replace prevonben_werk = (t_werk > 0)*(t_werk < .)*prevonben_werk 

/*******************************************
  INFO ON PREVIOUS LENGTH 
********************************************/
/* length of previous employement spell when unemployed */
gen prevEmpdur_Gwerk = 0
by rin: replace prevEmpdur_Gwerk =  t_werk[_n-1] if ///
   t_Gwerk > 0 &  t0_Gwerk==0 & indGwerk
by rin: replace prevEmpdur_Gwerk = prevEmpdur_Gwerk[_n-1] if ///
     indGwerk & prevEmpdur_Gwerk ==0
gen byte prevEmpdur3m_Gwerk = (prevEmpdur_Gwerk > 0)*(prevEmpdur_Gwerk <= 3)
gen byte prevEmpdur6m_Gwerk = (prevEmpdur_Gwerk > 3)*(prevEmpdur_Gwerk <= 6)
gen byte prevEmpdur1j_Gwerk = (prevEmpdur_Gwerk > 6)*(prevEmpdur_Gwerk <= 12)

/* length of previous employement spell when employed */
gen prevUNdur_werk = 0
by rin: replace prevUNdur_werk =  t_Gwerk[_n-1] if ///
      t_werk > 0 &  t0_werk==0 & indwerk
by rin: replace prevUNdur_werk = prevUNdur_werk[_n-1] if  ///
    indwerk & prevUNdur_werk ==0
gen byte prevUNdur1m_werk = (prevUNdur_werk > 0)*(prevUNdur_werk <= 1)
gen byte prevUNdur2m_werk = (prevUNdur_werk > 1)*(prevUNdur_werk <= 2)
gen byte prevUNdur3m_werk = (prevUNdur_werk > 2)*(prevUNdur_werk <= 3)
gen byte prevUNdur6m1j_werk = (prevUNdur_werk >6)*(prevUNdur_werk <= 12)
gen byte prevUNdur1j_werk = (prevUNdur_werk > 0)*(prevUNdur_werk > 12)

/*******************************************
  ORDER OF RE-EMPLOYMENT?UNEMPLOYMENT 
********************************************/
gen byte repreemp = indwerk*(numwerk > 2)
gen byte numreemp = indwerk*(numwerk-2)  /* # re-emp minus first employment spell */
gen byte numunemp = indGwerk*(numGwerk-1) /* # unemp minus first unemployment spell */

