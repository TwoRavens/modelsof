*******************************************************
*Rider, Findley, and Diehl, "Just Part of the Game?:  Arms Races, Rivalry and War"
*
*
*Includes commands to execute all analyses in Tables 1, 2, 4, and 5.
*
*
*
*
*
*******************************************************

clear
cd "C:\Documents and Settings\mfindley\Desktop\may2010\research\arrivalry-data\R,F,D_ReplicationData"

use "r,f,d_ReplicationData.dta"
set more off
/*H1 TESTS, TABLE 1: population comparisons for arms race onset*/tab arOnsettab arOnset KGDnoconflict, chi exptab arOnset KGDIsolated, chi exptab arOnset KGDongoing, chi exptab arOnset KGDnonrivyrs, chi exp

/*H2 TESTS, TABLE 2: Predicting arms race onset based on rivalry life cycle using number of militarized disputes */
/*TABLE 2, MODEL 1*/
probit arOnset  rivmidcnt contiguity jtdem lncaprat if KGDongoing==1, cluster(kgdrivid) nolog
/*TABLE 2, MODEL 2*/probit arOnset  rivmidcnt rivmidcnt_sq rivmidcnt_cube contiguity jtdem lncaprat if KGDongoing==1, cluster(kgdrivid) nolog


/*H3 TESTS, TABLE 4:  Probit Models and Probit w/ Selection*//*Rivalry and War onset if arms race in last 10 years*/
/*TABLE 4, MODEL 3*/probit KGDongoing contiguity jtpolity jtsat lncaprat systemshock domesticshock, cluster(dyad) nolog
/*TABLE 4, MODEL 4*/probit waronset contiguity jtpolity jtsat lncaprat ar_10 if KGDongoing==1, cluster(kgdrivid) nolog
/*TALBE 4, MODEL 5*/heckprob waronset contiguity jtpolity jtsat lncaprat ar_10 , select(KGDongoing=contiguity jtpolity jtsat lncaprat domesticshock systemshock) cluster(dyad) nolog

/*H3 TESTS, TABLE 5:  Rivalry and War onset, accounting for rivalry phase and arms race in last 10 years*/
/*TABLE 5, MODEL 6*/
probit KGDongoing contiguity jtpolity jtsat lncaprat systemshock domesticshock, cluster(dyad) nolog
/*TABLE 5, MODEL 7*/probit waronset contiguity jtpolity jtsat lncaprat phase2 phase3 ar10Xphase2 ar10Xphase3 ar_10 if KGDongoing==1, cluster(kgdrivid) nolog
/*TABLE 5, MODEL 8*/heckprob waronset contiguity jtpolity jtsat lncaprat phase2 phase3 ar10Xphase2 ar10Xphase3 ar_10 , select(KGDongoing=contiguity jtpolity jtsat lncaprat domesticshock systemshock) cluster(dyad) nolog
/*Predicted Probabilities for Model 4*/
quietly: probit waronset contiguity jtpolity jtsat lncaprat ar_10 if KGDongoing==1, cluster(kgdrivid) nolog
prvalue, x(contiguity=1 jtpolity=mean jtsat=mean lncaprat=mean ar_10=0) prvalue, x(contiguity=1 jtpolity=mean jtsat=mean lncaprat=mean ar_10=1)
/*Predicted Probabilities for Model 7*/
quietly: probit waronset contiguity jtpolity jtsat lncaprat phase2 phase3 ar10Xphase2 ar10Xphase3 ar_10 if KGDongoing==1, cluster(kgdrivid) nologprvalue, x(contiguity=1 jtpolity=mean jtsat=mean lncaprat=mean phase2=0 phase3=0 ar10Xphase2=0 ar10Xphase3=0 ar_10=0) prvalue, x(contiguity=1 jtpolity=mean jtsat=mean lncaprat=mean phase2=0 phase3=0 ar10Xphase2=0 ar10Xphase3=0 ar_10=1)prvalue, x(contiguity=1 jtpolity=mean jtsat=mean lncaprat=mean phase2=1 phase3=0 ar10Xphase2=0 ar10Xphase3=0 ar_10=0)  prvalue, x(contiguity=1 jtpolity=mean jtsat=mean lncaprat=mean phase2=1 phase3=0 ar10Xphase2=1 ar10Xphase3=0 ar_10=1) prvalue, x(contiguity=1 jtpolity=mean jtsat=mean lncaprat=mean phase2=0 phase3=1 ar10Xphase2=0 ar10Xphase3=0 ar_10=0) prvalue, x(contiguity=1 jtpolity=mean jtsat=mean lncaprat=mean phase2=0 phase3=1 ar10Xphase2=0 ar10Xphase3=1 ar_10=1) prvalue, x(contiguity=1 jtpolity=mean jtsat=mean lncaprat=mean phase2=0 phase3=0 ar10Xphase2=0 ar10Xphase3=0 ar_10=0) 


