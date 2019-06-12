/*Replication file for Rider 2013 ISQ,
"Uncertainty, Salient Stakes and the Causes of Conventional Arms Races"*/


/*Replication code for estimating Models 1-3 in Table 1 and generating predicted probabilities*/
/*Use dta file "Rider2013ISQ_Table1Replication"*/
/*Table 1:  Politically Relevant dyads-years, Klein et al. rivalry and Huth and Allee territorial claims*/

/*Table 1, Model 1*/
probit arOnset KGDongoing jtpolity jtally caprat landcontig peaceyrs _prefail _spline1 _spline2 _spline3 if ar_drop==0, nolog
/*Table 1, Model 2*/
probit arOnset ha_claim jtpolity jtally caprat landcontig peaceyrs _prefail _spline1 _spline2 _spline3 if ar_drop==0, nolog
/*Table 1, Model 3*/
probit arOnset KGDongoing ha_claim KGDrivXha jtpolity jtally caprat landcontig peaceyrs _prefail _spline1 _spline2 _spline3 if ar_drop==0, nolog
/*Table 1, Model 3, Predicted Probabilities*/
quietly probit arOnset KGDongoing ha_claim KGDrivXha jtpolity jtally caprat landcontig peaceyrs _prefail _spline1 _spline2 _spline3 if ar_drop==0, nolog
prvalue, x(KGDrivXha 0 ha_claim 0 KGDongoing 0 jtpolity mean jtally 0 caprat mean landcontig 0)
prvalue, x(KGDrivXha 0 ha_claim 1 KGDongoing 0 jtpolity mean jtally 0 caprat mean landcontig 0)
prvalue, x(KGDrivXha 0 ha_claim 0 KGDongoing 1 jtpolity mean jtally 0 caprat mean landcontig 0)
prvalue, x(KGDrivXha 1 ha_claim 1 KGDongoing 1 jtpolity mean jtally 0 caprat mean landcontig 0)



/*Replication code for estimating Models 4-6 in Table 2 and generating predicted probabilities*/
/*Use dta file "Rider2013ISQ_Table2Replication" */
/*Table 2:  Klein et al. Rivalry dyad-years, Huth & Allee Territorial Claims and MID Revision Type */

/*Table 2, Model 4*/
probit arOnset ha_claim jtpolity jtally caprat landcontig peaceyrs _prefail _spline1 _spline2 _spline3 if ar_drop==0, nolog
/*Table 2, Model 5*/
probit arOnset terr_5 policy_5 regime_5 other_5 norev_5 jtpolity jtally caprat landcontig peaceyrs _prefail _spline1 _spline2 _spline3 if ar_drop==0, nolog
/*Table 2, Model 6*/
probit arOnset ha_claim terr_5 policy_5 regime_5 other_5 norev_5 claimXterrmid5  jtpolity jtally caprat landcontig peaceyrs _prefail _spline1 _spline2 _spline3 if ar_drop==0, nolog
/*Table 2, Model 6, Predicted Probabilities*/
quietly: probit arOnset claimXterrmid5 ha_claim terr_5 policy_5 regime_5 other_5 norev_5 jtpolity jtally caprat landcontig peaceyrs _prefail _spline1 _spline2 _spline3 if ar_drop==0, nolog
prvalue, x(claimXterrmid5 0 ha_claim 0 terr_5 0 policy_5 0 regime_5 0 other_5 0 norev_5 0 jtpolity mean jtally 0 caprat mean landcontig 1)
prvalue, x(claimXterrmid5 0 ha_claim 1 terr_5 0 policy_5 0 regime_5 0 other_5 0 norev_5 0 jtpolity mean jtally 0 caprat mean landcontig 1)
prvalue, x(claimXterrmid5 0 ha_claim 0 terr_5 1 policy_5 0 regime_5 0 other_5 0 norev_5 0 jtpolity mean jtally 0 caprat mean landcontig 1)
prvalue, x(claimXterrmid5 1 ha_claim 1 terr_5 1 policy_5 0 regime_5 0 other_5 0 norev_5 0 jtpolity mean jtally 0 caprat mean landcontig 1)



/*Replication code for estimating Models 7-10 in Table 3*/

/*Use dta file "Rider2013ISQ_Table3Replication" */
/*Table 3:  Leadership change and Huth & Allee Territorial Claims */
/*Raw Leadership change count variable*/
/*Table 3, Model 7*/
probit arOnset to_cnt jtpolity jtally caprat landcontig peaceyrs _prefail _spline1 _spline2 _spline3 if ar_drop ==0
/*Table 3, Model 8*/
/*Conroling for Territory w/ Raw Leadership change count variable */
probit arOnset to_cnt ha_claim jtpolity jtally caprat landcontig peaceyrs _prefail _spline1 _spline2 _spline3 if ar_drop ==0

*****************************
*Arms Race Onset
*Leadership Change and Regime Type
*
*Rivaly and Non-Rivalry Split populations
*
*
*
******************************
/*Table 3, Model 9, Non-Rivalry*/
probit arOnset to_cnt ha_claim jtpolity jtally caprat landcontig peaceyrs _prefail _spline1 _spline2 _spline3 if ar_drop ==0 & KGDongoing==0, nolog
/*Table 3, Model 9, Rivalry*/
probit arOnset to_cnt ha_claim jtpolity jtally caprat landcontig peaceyrs _prefail _spline1 _spline2 _spline3 if ar_drop ==0 & KGDongoing==1, nolog
