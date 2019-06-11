//* Minority Languages in Dictatorships: A New Measure of Group Recognition *//
//* Amy H. Liu, Jennifer Gandhi, and Curtis Bell *//
//* Political Science Research and Methods *//
//* Date: November 4, 2015 *//





//* Table 1: Effects of Minority Parties in Legislatures on Language Recognition *//
use "PSRM Dyad.dta"



/* Model 1: Baseline */
ologit educ_dj gdppc10k majsize lnumlang legalbrit legalfra lparty2 minsize immigrant ecdifxx educ_dj1, cluster(c1mincode)

Iteration 0:   log pseudolikelihood = -1636.1812  
Iteration 1:   log pseudolikelihood = -463.85163  
Iteration 2:   log pseudolikelihood = -230.58799  
Iteration 3:   log pseudolikelihood = -106.45588  
Iteration 4:   log pseudolikelihood = -98.807592  
Iteration 5:   log pseudolikelihood = -97.016599  
Iteration 6:   log pseudolikelihood =  -96.99381  
Iteration 7:   log pseudolikelihood = -96.993794  
Iteration 8:   log pseudolikelihood = -96.993794  

Ordered logistic regression                       Number of obs   =       2392
                                                  Wald chi2(10)   =     511.56
                                                  Prob > chi2     =     0.0000
Log pseudolikelihood = -96.993794                 Pseudo R2       =     0.9407

                            (Std. Err. adjusted for 177 clusters in c1mincode)
------------------------------------------------------------------------------
             |               Robust
     educ_dj |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
    gdppc10k |  -.0870545   .1499534    -0.58   0.562    -.3809578    .2068488
     majsize |  -4.606235   1.115486    -4.13   0.000    -6.792548   -2.419922
    lnumlang |  -.0246048   .6114967    -0.04   0.968    -1.223116    1.173907
   legalbrit |  -.0455475     .73401    -0.06   0.951    -1.484181    1.393086
    legalfra |    1.33049   .4190513     3.18   0.001     .5091645    2.151815
     lparty2 |   1.394991   .4097259     3.40   0.001     .5919432    2.198039
     minsize |   2.305777   2.186939     1.05   0.292    -1.980545    6.592098
   immigrant |  -.8392997   .4892431    -1.72   0.086    -1.798199    .1195991
     ecdifxx |   1.609945    .412678     3.90   0.000     .8011111    2.418779
    educ_dj1 |   10.19227   1.464043     6.96   0.000     7.322795    13.06174
-------------+----------------------------------------------------------------
       /cut1 |   4.265589   1.935539                      .4720024    8.059176
       /cut2 |   13.86909   3.828687                      6.364997    21.37317
------------------------------------------------------------------------------



/* Model 2: Sans lagged DV */
ologit educ_dj gdppc10k majsize lnumlang legalbrit legalfra lparty2 minsize immigrant ecdifxx, cluster(c1mincode)

Iteration 0:   log pseudolikelihood = -1730.9993  
Iteration 1:   log pseudolikelihood =  -1340.191  
Iteration 2:   log pseudolikelihood = -1298.7407  
Iteration 3:   log pseudolikelihood = -1297.0812  
Iteration 4:   log pseudolikelihood = -1297.0781  
Iteration 5:   log pseudolikelihood = -1297.0781  

Ordered logistic regression                       Number of obs   =       2540
                                                  Wald chi2(9)    =      40.69
                                                  Prob > chi2     =     0.0000
Log pseudolikelihood = -1297.0781                 Pseudo R2       =     0.2507

                            (Std. Err. adjusted for 177 clusters in c1mincode)
------------------------------------------------------------------------------
             |               Robust
     educ_dj |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
    gdppc10k |  -.2345262   .1362197    -1.72   0.085    -.5015119    .0324596
     majsize |    -3.3197   1.602031    -2.07   0.038    -6.459623   -.1797773
    lnumlang |  -2.351091   .9042774    -2.60   0.009    -4.123442   -.5787397
   legalbrit |  -.3555957   .6467783    -0.55   0.582    -1.623258    .9120663
    legalfra |   1.138755   .5540181     2.06   0.040     .0528992     2.22461
     lparty2 |   .6839736   .3622567     1.89   0.059    -.0260366    1.393984
     minsize |   8.393339   3.914752     2.14   0.032     .7205662    16.06611
   immigrant |  -.1041185   .5144425    -0.20   0.840    -1.112407    .9041702
     ecdifxx |   1.413219   .5934124     2.38   0.017      .250152    2.576286
-------------+----------------------------------------------------------------
       /cut1 |    -3.8515    2.59301                     -8.933707    1.230707
       /cut2 |  -3.200117   2.573607                     -8.244295     1.84406
------------------------------------------------------------------------------



/* Model 3: Geddes */
ologit educ_dj gdppc10k majsize lnumlang legalbrit legalfra mon mil part pers part_pers lparty2 minsize immigrant ecdifxx educ_dj1, cluster(c1mincode)

Iteration 0:   log pseudolikelihood = -1318.6379  
Iteration 1:   log pseudolikelihood =  -359.0028  
Iteration 2:   log pseudolikelihood = -185.00504  
Iteration 3:   log pseudolikelihood = -87.258434  
Iteration 4:   log pseudolikelihood =  -80.24396  
Iteration 5:   log pseudolikelihood = -77.621448  
Iteration 6:   log pseudolikelihood = -77.559533  
Iteration 7:   log pseudolikelihood = -77.555034  
Iteration 8:   log pseudolikelihood = -77.553835  
Iteration 9:   log pseudolikelihood = -77.553562  
Iteration 10:  log pseudolikelihood = -77.553498  
Iteration 11:  log pseudolikelihood = -77.553483  
Iteration 12:  log pseudolikelihood =  -77.55348  

Ordered logistic regression                       Number of obs   =       1725
                                                  Wald chi2(15)   =    3284.56
                                                  Prob > chi2     =     0.0000
Log pseudolikelihood =  -77.55348                 Pseudo R2       =     0.9412

                            (Std. Err. adjusted for 136 clusters in c1mincode)
------------------------------------------------------------------------------
             |               Robust
     educ_dj |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
    gdppc10k |  -.1493153   .3428895    -0.44   0.663    -.8213664    .5227358
     majsize |  -5.113913   2.117552    -2.42   0.016    -9.264239   -.9635876
    lnumlang |   .1279377    .500963     0.26   0.798    -.8539316    1.109807
   legalbrit |  -1.233666   1.907123    -0.65   0.518    -4.971559    2.504227
    legalfra |   .6910488   .5346743     1.29   0.196    -.3568935    1.738991
         mon |   .5845136   .7428954     0.79   0.431    -.8715345    2.040562
         mil |   -37.0558   3.656882   -10.13   0.000    -44.22316   -29.88845
        part |  -.8777416   .6930907    -1.27   0.205    -2.236174    .4806912
        pers |  -1.664971   .8298415    -2.01   0.045     -3.29143   -.0385117
   part_pers |  -1.669589   .9036342    -1.85   0.065    -3.440679    .1015017
     lparty2 |   2.041771    .278851     7.32   0.000     1.495233    2.588309
     minsize |  -2.171053   2.396455    -0.91   0.365    -6.868018    2.525913
   immigrant |  -.7237215   .7574664    -0.96   0.339    -2.208328    .7608854
     ecdifxx |    13.5112   .9919643    13.62   0.000     11.56698    15.45541
    educ_dj1 |   11.72112   2.187125     5.36   0.000     7.434428     16.0078
-------------+----------------------------------------------------------------
       /cut1 |   3.727069   2.295801                     -.7726188    8.226757
       /cut2 |   15.42574    2.47188                      10.58094    20.27053
------------------------------------------------------------------------------



/* Model 4: Multilevel */
mixed educ_dj gdppc10k majsize lnumlang legalbrit legalfra lparty2 minsize immigrant ecdifxx educ_dj1 || c1mincode: || country: , vce(robust)

Iteration 0:   log pseudolikelihood =  2182.4692  
Iteration 1:   log pseudolikelihood =  2191.6721  
Iteration 2:   log pseudolikelihood =   2191.679  
Iteration 3:   log pseudolikelihood =   2191.679  

Computing standard errors:

Mixed-effects regression                        Number of obs      =      2392

-----------------------------------------------------------
                |   No. of       Observations per Group
 Group Variable |   Groups    Minimum    Average    Maximum
----------------+------------------------------------------
      c1mincode |      177          2       13.5         19
        country |      177          2       13.5         19
-----------------------------------------------------------

                                                Wald chi2(10)      = 492041.23
Log pseudolikelihood =   2191.679               Prob > chi2        =    0.0000

                            (Std. Err. adjusted for 177 clusters in c1mincode)
------------------------------------------------------------------------------
             |               Robust
     educ_dj |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
    gdppc10k |   .0007558   .0010263     0.74   0.461    -.0012556    .0027673
     majsize |  -.0541726   .0244984    -2.21   0.027    -.1021885   -.0061566
    lnumlang |  -.0028649   .0081932    -0.35   0.727    -.0189232    .0131934
   legalbrit |  -.0004087   .0055717    -0.07   0.942    -.0113291    .0105117
    legalfra |   .0123385   .0040286     3.06   0.002     .0044425    .0202345
     lparty2 |   .0133369   .0076959     1.73   0.083    -.0017467    .0284206
     minsize |   .0452421   .0609986     0.74   0.458    -.0743131    .1647972
   immigrant |    -.00698   .0025332    -2.76   0.006    -.0119449    -.002015
     ecdifxx |   .0121652   .0051507     2.36   0.018     .0020701    .0222603
    educ_dj1 |   .9858214   .0048154   204.72   0.000     .9763834    .9952595
       _cons |   .0338236   .0291895     1.16   0.247    -.0233867     .091034
------------------------------------------------------------------------------

------------------------------------------------------------------------------
                             |               Robust           
  Random-effects Parameters  |   Estimate   Std. Err.     [95% Conf. Interval]
-----------------------------+------------------------------------------------
c1mincode: Identity          |
                  var(_cons) |   1.62e-26   8.13e-25      3.90e-69    6.76e+16
-----------------------------+------------------------------------------------
country: Identity            |
                  var(_cons) |   6.11e-26   2.70e-24      1.41e-63    2.64e+12
-----------------------------+------------------------------------------------
               var(Residual) |   .0093687   .0034892      .0045151    .0194397
------------------------------------------------------------------------------





/* Table 2: Institutional Effects on Minority Language Recognition */
use "PSRM Monad.dta"



/* Model 5: Baseline */
ologit educ_dj3 lparty gdppc10k majority lnumlang legalbrit legalfra gw_mon gw_mil gw_part gw_pers gw_mil_part gw_mil_pers gw_part_pers leduc_dj3, cluster(prz) 

Iteration 0:   log pseudolikelihood = -2103.9626  
Iteration 1:   log pseudolikelihood = -560.50495  
Iteration 2:   log pseudolikelihood = -371.92844  
Iteration 3:   log pseudolikelihood = -297.02227  
Iteration 4:   log pseudolikelihood = -293.61428  
Iteration 5:   log pseudolikelihood = -293.57348  
Iteration 6:   log pseudolikelihood = -293.57347  

Ordered logistic regression                       Number of obs   =       2834
                                                  Wald chi2(14)   =     406.93
                                                  Prob > chi2     =     0.0000
Log pseudolikelihood = -293.57347                 Pseudo R2       =     0.8605

                                  (Std. Err. adjusted for 108 clusters in prz)
------------------------------------------------------------------------------
             |               Robust
    educ_dj3 |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
      lparty |   .3313983   .1352312     2.45   0.014     .0663499    .5964466
    gdppc10k |  -.0249774   .0974306    -0.26   0.798    -.2159378    .1659831
    majority |  -.7045854   .6244173    -1.13   0.259    -1.928421      .51925
    lnumlang |  -.0493197   .1895583    -0.26   0.795    -.4208471    .3222078
   legalbrit |  -.2738895    .379141    -0.72   0.470    -1.016992    .4692132
    legalfra |  -.0892389   .3900177    -0.23   0.819    -.8536595    .6751816
      gw_mon |  -.6695397   .9756432    -0.69   0.493    -2.581765    1.242686
      gw_mil |   1.056656    .816479     1.29   0.196    -.5436137    2.656925
     gw_part |   .2153733   .5652712     0.38   0.703    -.8925378    1.323284
     gw_pers |   .4219978   .5770645     0.73   0.465    -.7090278    1.553023
 gw_mil_part |   .2409962   .6515283     0.37   0.711    -1.035976    1.517968
 gw_mil_pers |  -.5203041   .6742766    -0.77   0.440    -1.841862    .8012539
gw_part_pers |   .2773474    .670714     0.41   0.679    -1.037228    1.591923
   leduc_dj3 |   6.428279    .438249    14.67   0.000     5.569326    7.287231
-------------+----------------------------------------------------------------
       /cut1 |    4.41302   1.157868                      2.143641      6.6824
       /cut2 |   8.540274     1.4297                      5.738114    11.34243
------------------------------------------------------------------------------



/* Model 6: Region */
ologit educ_dj3 lparty gdppc10k majority lnumlang legalbrit legalfra gw_mon gw_mil gw_part gw_pers gw_mil_part gw_mil_pers gw_part_pers whemisphere seurope eeurope safrica mena leduc_dj3, cluster(prz) 

Iteration 0:   log pseudolikelihood = -2103.9626  
Iteration 1:   log pseudolikelihood = -560.50353  
Iteration 2:   log pseudolikelihood = -370.20821  
Iteration 3:   log pseudolikelihood =  -291.4586  
Iteration 4:   log pseudolikelihood = -287.94561  
Iteration 5:   log pseudolikelihood =  -287.8887  
Iteration 6:   log pseudolikelihood = -287.87755  
Iteration 7:   log pseudolikelihood = -287.87587  
Iteration 8:   log pseudolikelihood = -287.87567  
Iteration 9:   log pseudolikelihood = -287.87563  
Iteration 10:  log pseudolikelihood = -287.87562  

Ordered logistic regression                       Number of obs   =       2834
                                                  Wald chi2(19)   =     999.10
                                                  Prob > chi2     =     0.0000
Log pseudolikelihood = -287.87562                 Pseudo R2       =     0.8632

                                  (Std. Err. adjusted for 108 clusters in prz)
------------------------------------------------------------------------------
             |               Robust
    educ_dj3 |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
      lparty |   .3505133   .1472286     2.38   0.017     .0619506     .639076
    gdppc10k |    -.02104   .1243484    -0.17   0.866    -.2647585    .2226784
    lnumlang |   .3103905   .2006408     1.55   0.122    -.0828583    .7036392
    majority |  -.8267809   .5780794    -1.43   0.153    -1.959796    .3062339
   legalbrit |   .5054801   .5435031     0.93   0.352    -.5597665    1.570727
    legalfra |   .3816401   .5926494     0.64   0.520    -.7799313    1.543212
      gw_mon |  -.6296522   1.067038    -0.59   0.555    -2.721007    1.461703
      gw_mil |   1.154617   .7426401     1.55   0.120    -.3009309    2.610165
     gw_part |   .3237395    .572734     0.57   0.572    -.7987986    1.446278
     gw_pers |   .8190522   .5761584     1.42   0.155    -.3101974    1.948302
 gw_mil_part |   .4068959   .6637559     0.61   0.540    -.8940418    1.707834
 gw_mil_pers |  -.4891626   .6524913    -0.75   0.453    -1.768022    .7896968
gw_part_pers |   .2370923   .7347312     0.32   0.747    -1.202954    1.677139
 whemisphere |   1.142609   .4666368     2.45   0.014     .2280178      2.0572
     seurope |  -12.08247   .7931573   -15.23   0.000    -13.63703   -10.52791
     eeurope |   1.628441   .6464288     2.52   0.012      .361464    2.895418
     safrica |  -.3443299   .3586694    -0.96   0.337    -1.047309    .3586491
        mena |   .4013519   .4383006     0.92   0.360    -.4577016    1.260405
   leduc_dj3 |   6.331099   .4266931    14.84   0.000     5.494796    7.167402
-------------+----------------------------------------------------------------
       /cut1 |   5.910101   1.026544                      3.898112     7.92209
       /cut2 |   10.05651   1.354176                      7.402376    12.71065
------------------------------------------------------------------------------



/* Model 7: Multinomial */
mlogit educ_dj3 lparty gdppc10k majority lnumlang legalbrit legalfra gw_mon gw_mil gw_part gw_pers gw_mil_part gw_mil_pers gw_part_pers whemisphere seurope eeurope safrica mena leduc_dj3, cluster(prz) baseoutcome(1)

Iteration 0:   log pseudolikelihood = -2103.9626  
Iteration 1:   log pseudolikelihood = -623.74458  
Iteration 2:   log pseudolikelihood = -446.57066  
Iteration 3:   log pseudolikelihood = -310.39509  
Iteration 4:   log pseudolikelihood = -301.45107  
Iteration 5:   log pseudolikelihood = -297.69864  
Iteration 6:   log pseudolikelihood = -297.56504  
Iteration 7:   log pseudolikelihood =  -297.5448  
Iteration 8:   log pseudolikelihood = -297.54114  
Iteration 9:   log pseudolikelihood = -297.54029  
Iteration 10:  log pseudolikelihood = -297.54015  
Iteration 11:  log pseudolikelihood = -297.54014  

Multinomial logistic regression                   Number of obs   =       2834
                                                  Wald chi2(38)   =    5852.98
                                                  Prob > chi2     =     0.0000
Log pseudolikelihood = -297.54014                 Pseudo R2       =     0.8586

                                  (Std. Err. adjusted for 108 clusters in prz)
------------------------------------------------------------------------------
             |               Robust
    educ_dj3 |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
0            |
      lparty |   -.521549    .227039    -2.30   0.022    -.9665372   -.0765608
    gdppc10k |  -.2723177   .2622381    -1.04   0.299     -.786295    .2416596
    majority |  -.5844261    .908607    -0.64   0.520    -2.365263    1.196411
    lnumlang |  -1.132506   .4820648    -2.35   0.019    -2.077335    -.187676
   legalbrit |  -5.499162   1.286146    -4.28   0.000    -8.019961   -2.978363
    legalfra |  -5.415819   1.174489    -4.61   0.000    -7.717774   -3.113863
      gw_mon |   .9145848   1.672734     0.55   0.585    -2.363914    4.193084
      gw_mil |  -.6392029   1.246465    -0.51   0.608    -3.082229    1.803823
     gw_part |  -.6964799   1.103277    -0.63   0.528    -2.858863    1.465904
     gw_pers |  -.8687678   1.095113    -0.79   0.428     -3.01515    1.277614
 gw_mil_part |  -1.375928   1.234288    -1.11   0.265    -3.795088    1.043232
 gw_mil_pers |   16.48299   1.328123    12.41   0.000     13.87991    19.08606
gw_part_pers |   .2740687   1.587465     0.17   0.863    -2.837305    3.385442
 whemisphere |  -1.881311   1.203534    -1.56   0.118    -4.240195    .4775723
     seurope |   14.71552   1.500182     9.81   0.000     11.77521    17.65582
     eeurope |  -8.516781   2.106148    -4.04   0.000    -12.64476   -4.388806
     safrica |   .0275299   .9602967     0.03   0.977    -1.854617    1.909677
        mena |  -.7100255   1.004457    -0.71   0.480    -2.678726    1.258675
   leduc_dj3 |  -6.637203   .8583556    -7.73   0.000    -8.319549   -4.954857
       _cons |   14.08346   2.543282     5.54   0.000     9.098716     19.0682
-------------+----------------------------------------------------------------
1            |  (base outcome)
-------------+----------------------------------------------------------------
2            |
      lparty |   .5503106   .2141446     2.57   0.010     .1305949    .9700264
    gdppc10k |  -2.009593   .7526839    -2.67   0.008    -3.484827   -.5343599
    majority |  -2.356928   1.365272    -1.73   0.084    -5.032811    .3189562
    lnumlang |  -2.518841   .8169689    -3.08   0.002     -4.12007   -.9176109
   legalbrit |  -.9466514   1.276295    -0.74   0.458    -3.448143     1.55484
    legalfra |  -2.068548   1.356641    -1.52   0.127    -4.727516     .590419
      gw_mon |   2.141541   1.743078     1.23   0.219    -1.274829    5.557911
      gw_mil |    1.52202   1.922705     0.79   0.429    -2.246412    5.290452
     gw_part |  -.2054822   1.749924    -0.12   0.907    -3.635269    3.224305
     gw_pers |   .8898157   1.611035     0.55   0.581    -2.267754    4.047386
 gw_mil_part |  -20.40909   2.453103    -8.32   0.000    -25.21708   -15.60109
 gw_mil_pers |   13.74412   1.949921     7.05   0.000     9.922343    17.56589
gw_part_pers |   .3419356   1.678444     0.20   0.839    -2.947753    3.631625
 whemisphere |  -.1892711   1.632086    -0.12   0.908    -3.388101    3.009559
     seurope |   2.515304   2.228598     1.13   0.259    -1.852667    6.883276
     eeurope |  -2.524861   1.210349    -2.09   0.037    -4.897103   -.1526197
     safrica |  -1.500399   .7710006    -1.95   0.052    -3.011532    .0107346
        mena |   -1.00901   1.152858    -0.88   0.381    -3.268569     1.25055
   leduc_dj3 |   4.201619   .5533038     7.59   0.000     3.117163    5.286074
       _cons |   4.362183   3.743815     1.17   0.244    -2.975559    11.69992
------------------------------------------------------------------------------





//* Table 3: The Effects of State Vulnerability *//
use "PSRM Monad.dta"

xtset prz year

gen change=1 if l.leadershipchanges~=leadershipchanges
forval i =  1(1)70 {
replace change = `i'+1 if l.change==`i' & change==.
}
gen logchange = ln(change)
gen lparty_dum2 = 0 if lparty~=.
replace lparty_dum2=1 if lparty==2

save "PSRM Monad.dta", replace


/* Model 8: Multiparty in Legislature */
ologit lparty gdppc10k growth1 logchange purges leadershipchange year resources civiliandict militarydict lnumlang majority legalbrit legalfra, cluster(prz) 

Iteration 0:   log pseudolikelihood = -3015.2834  
Iteration 1:   log pseudolikelihood = -2573.8672  
Iteration 2:   log pseudolikelihood = -2565.7966  
Iteration 3:   log pseudolikelihood = -2565.7384  
Iteration 4:   log pseudolikelihood = -2565.7384  

Ordered logistic regression                       Number of obs   =       2755
                                                  Wald chi2(13)   =     106.88
                                                  Prob > chi2     =     0.0000
Log pseudolikelihood = -2565.7384                 Pseudo R2       =     0.1491

                                       (Std. Err. adjusted for 113 clusters in prz)
-----------------------------------------------------------------------------------
                  |               Robust
           lparty |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
------------------+----------------------------------------------------------------
         gdppc10k |  -.3537553   .2659419    -1.33   0.183    -.8749918    .1674812
          growth1 |   .2741908   .2124928     1.29   0.197    -.1422876    .6906691
        logchange |   .4740597    .124907     3.80   0.000     .2292464     .718873
           purges |  -.0841672   .0922766    -0.91   0.362    -.2650261    .0966916
leadershipchanges |    .137527   .0591012     2.33   0.020     .0216907    .2533633
             year |   .0009348   .0114461     0.08   0.935    -.0214992    .0233687
        resources |   -.533182   .2551633    -2.09   0.037    -1.033293   -.0330711
 civiliandictator |   2.918198   .8177123     3.57   0.000     1.315511    4.520885
 militarydictator |   1.372491   .8137305     1.69   0.092    -.2223911    2.967374
         lnumlang |  -.0652471   .2238018    -0.29   0.771    -.5038905    .3733963
         majority |    .477704   .7073358     0.68   0.499    -.9086488    1.864057
        legalbrit |   .5097813    .474012     1.08   0.282    -.4192651    1.438828
         legalfra |   .0801528   .4327012     0.19   0.853     -.767926    .9282316
------------------+----------------------------------------------------------------
            /cut1 |   4.383059   22.51009                      -39.7359    48.50202
            /cut2 |   6.347396   22.53708                     -37.82446    50.51926
-----------------------------------------------------------------------------------



/* Model 9: Language Recognition */
ologit educ_dj3 gdppc10k growth1 logchange purges leadershipchange year resources civiliandict militarydict lnumlang majority legalbrit legalfra, cluster(prz) 

Iteration 0:   log pseudolikelihood = -1951.7799  
Iteration 1:   log pseudolikelihood = -1729.4483  
Iteration 2:   log pseudolikelihood = -1699.3385  
Iteration 3:   log pseudolikelihood = -1694.4451  
Iteration 4:   log pseudolikelihood = -1694.1073  
Iteration 5:   log pseudolikelihood =  -1694.105  
Iteration 6:   log pseudolikelihood =  -1694.105  

Ordered logistic regression                       Number of obs   =       2695
                                                  Wald chi2(13)   =      34.96
                                                  Prob > chi2     =     0.0009
Log pseudolikelihood =  -1694.105                 Pseudo R2       =     0.1320

                                       (Std. Err. adjusted for 111 clusters in prz)
-----------------------------------------------------------------------------------
                  |               Robust
         educ_dj3 |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
------------------+----------------------------------------------------------------
         gdppc10k |    .581345   .3368013     1.73   0.084    -.0787735    1.241464
          growth1 |  -.2683944   .3077238    -0.87   0.383     -.871522    .3347333
        logchange |  -.0877473   .1485639    -0.59   0.555    -.3789272    .2034326
           purges |   .1041408   .0930639     1.12   0.263     -.078261    .2865427
leadershipchanges |   .1008309   .0704914     1.43   0.153    -.0373296    .2389914
             year |   .0277053   .0137432     2.02   0.044     .0007691    .0546415
        resources |   -.266037   .5228777    -0.51   0.611    -1.290859    .7587845
 civiliandictator |   5.536593    2.73254     2.03   0.043     .1809128    10.89227
 militarydictator |   5.330438   2.843449     1.87   0.061    -.2426199     10.9035
         lnumlang |   .2883376   .2859175     1.01   0.313    -.2720503    .8487256
         majority |  -.6437041    .985385    -0.65   0.514    -2.575023    1.287615
        legalbrit |   .1055912   .7167778     0.15   0.883    -1.299268     1.51045
         legalfra |  -.9576347   .6897799    -1.39   0.165    -2.309578     .394309
------------------+----------------------------------------------------------------
            /cut1 |   61.05069   26.47486                      9.160913    112.9405
            /cut2 |   61.42834   26.47811                      9.532192    113.3245
-----------------------------------------------------------------------------------





//* Table 4: Vulnerability With/Without Multiparties *//
use "PSRM Monad.dta"


/* Model 10: With Multiparties */
ologit educ_dj3 gdppc10k growth1 logchange purges leadershipchange year resources civiliandict militarydict lnumlang majority legalbrit legalfra if lparty_dum2==1, cluster(prz) 

Iteration 0:   log pseudolikelihood = -649.20094  
Iteration 1:   log pseudolikelihood = -525.71158  
Iteration 2:   log pseudolikelihood =  -520.5419  
Iteration 3:   log pseudolikelihood = -519.78435  
Iteration 4:   log pseudolikelihood =  -519.6088  
Iteration 5:   log pseudolikelihood = -519.56834  
Iteration 6:   log pseudolikelihood =    -519.56  
Iteration 7:   log pseudolikelihood = -519.55865  
Iteration 8:   log pseudolikelihood = -519.55832  
Iteration 9:   log pseudolikelihood = -519.55825  
Iteration 10:  log pseudolikelihood = -519.55823  

Ordered logistic regression                       Number of obs   =        782
                                                  Wald chi2(13)   =     603.71
                                                  Prob > chi2     =     0.0000
Log pseudolikelihood = -519.55823                 Pseudo R2       =     0.1997

                                        (Std. Err. adjusted for 78 clusters in prz)
-----------------------------------------------------------------------------------
                  |               Robust
         educ_dj3 |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
------------------+----------------------------------------------------------------
         gdppc10k |   1.032611   .5756374     1.79   0.073    -.0956179    2.160839
          growth1 |  -1.191679   .4785262    -2.49   0.013    -2.129574   -.2537853
        logchange |  -.1162753   .2042775    -0.57   0.569    -.5166518    .2841013
           purges |   .3114399   .1160353     2.68   0.007     .0840148    .5388649
leadershipchanges |   .2493445   .1230134     2.03   0.043     .0082426    .4904463
             year |   .0063142   .0213039     0.30   0.767    -.0354407    .0480691
        resources |  -1.720574   .8405382    -2.05   0.041    -3.367999   -.0731494
 civiliandictator |   14.50435   .8300384    17.47   0.000      12.8775    16.13119
 militarydictator |    13.9393   .8581991    16.24   0.000     12.25726    15.62134
         lnumlang |   .6019136   .4381846     1.37   0.170    -.2569124     1.46074
         majority |  -1.626059    1.27185    -1.28   0.201    -4.118839     .866721
        legalbrit |  -1.079023   1.197172    -0.90   0.367    -3.425438    1.267392
         legalfra |  -1.595441   1.062822    -1.50   0.133    -3.678533    .4876516
------------------+----------------------------------------------------------------
            /cut1 |   27.02632   41.76735                     -54.83618    108.8888
            /cut2 |   27.38205   41.75269                     -54.45171    109.2158
-----------------------------------------------------------------------------------



/* Model 11: No Multiparties */
ologit educ_dj3 gdppc10k growth1 logchange purges leadershipchange year resources civiliandict militarydict lnumlang majority legalbrit legalfra if lparty_dum2==0, cluster(prz) 

Iteration 0:   log pseudolikelihood = -1261.9095  
Iteration 1:   log pseudolikelihood = -1133.9891  
Iteration 2:   log pseudolikelihood = -1112.4753  
Iteration 3:   log pseudolikelihood = -1109.9821  
Iteration 4:   log pseudolikelihood =  -1109.878  
Iteration 5:   log pseudolikelihood =  -1109.878  

Ordered logistic regression                       Number of obs   =       1913
                                                  Wald chi2(13)   =      30.72
                                                  Prob > chi2     =     0.0037
Log pseudolikelihood =  -1109.878                 Pseudo R2       =     0.1205

                                       (Std. Err. adjusted for 101 clusters in prz)
-----------------------------------------------------------------------------------
                  |               Robust
         educ_dj3 |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
------------------+----------------------------------------------------------------
         gdppc10k |    .406482   .3756704     1.08   0.279    -.3298185    1.142783
          growth1 |    .020546   .2952616     0.07   0.945     -.558156    .5992481
        logchange |  -.1232376   .1777331    -0.69   0.488    -.4715881    .2251129
           purges |   .0672438   .0584524     1.15   0.250    -.0473208    .1818084
leadershipchanges |    .002436   .0862879     0.03   0.977    -.1666853    .1715572
             year |   .0398334   .0146758     2.71   0.007     .0110694    .0685973
        resources |   .0668466   .5501459     0.12   0.903     -1.01142    1.145113
 civiliandictator |   4.822531   2.140643     2.25   0.024     .6269485    9.018114
 militarydictator |   4.715753   2.243619     2.10   0.036     .3183413    9.113166
         lnumlang |   .1740498   .3091249     0.56   0.573    -.4318239    .7799235
         majority |  -.4267578   1.147788    -0.37   0.710    -2.676381    1.822865
        legalbrit |   .3985384   .7713403     0.52   0.605    -1.113261    1.910338
         legalfra |  -.7845109   .7354472    -1.07   0.286    -2.225961    .6569391
------------------+----------------------------------------------------------------
            /cut1 |   84.30162   28.94152                      27.57728    141.0259
            /cut2 |   84.72887   28.96552                       27.9575    141.5002
-----------------------------------------------------------------------------------





//* Figure 1: Minority Language Recognition in Dictatorships 1940-2000 *//
use "PSRM Monad.dta"

tab educ_dj3 if year<1950
tab educ_dj3 if year>1949 & year<1960
tab educ_dj3 if year>1959 & year<1970
tab educ_dj3 if year>1969 & year<1980
tab educ_dj3 if year>1979 & year<1990
tab educ_dj3 if year>1989
tab educ_dj3





//* Figure 2: Language Recognition of Minority Groups in Asian Dictatorships */
use "PSRM Dyad.dta"

tab educ_dj if year==1980
tab educ_dj if year==1981
tab educ_dj if year==1982
tab educ_dj if year==1983
tab educ_dj if year==1984
tab educ_dj if year==1985
tab educ_dj if year==1986
tab educ_dj if year==1987
tab educ_dj if year==1988
tab educ_dj if year==1989
tab educ_dj if year==1990
tab educ_dj if year==1991
tab educ_dj if year==1992
tab educ_dj if year==1993
tab educ_dj if year==1994
tab educ_dj if year==1995
tab educ_dj if year==1996
tab educ_dj if year==1997
tab educ_dj if year==1998
tab educ_dj if year==1999
tab educ_dj if year==2000





//* Figure 3: Predicted Probabilities of Recognition by Party Representation *//
use "PSRM Dyad.dta"

estsimp ologit educ_dj gdppc10k majsize lnumlang legalbrit legalfra lparty2 minsize immigrant ecdifxx, cluster(c1mincode)


setx (gdppc10k majsize lnumlang legalbrit legalfra) mean lparty2 0 (minsize immigrant ecdifxx) mean
simqi

      Quantity of Interest |     Mean       Std. Err.    [95% Conf. Interval]
---------------------------+--------------------------------------------------
             Pr(educ_dj=0) |   .8854289     .0304311      .818202    .9345576
             Pr(educ_dj=1) |   .0507387     .0186007     .0189955    .0903892
             Pr(educ_dj=2) |   .0638324     .0184579     .0348375    .1069204

			 
setx (gdppc10k majsize lnumlang legalbrit legalfra) mean lparty2 1 (minsize immigrant ecdifxx) mean
simqi

      Quantity of Interest |     Mean       Std. Err.    [95% Conf. Interval]
---------------------------+--------------------------------------------------
             Pr(educ_dj=0) |   .7990363     .0390385     .7185212    .8652338
             Pr(educ_dj=1) |   .0836413     .0258264     .0339778     .136816
             Pr(educ_dj=2) |   .1173224     .0273054     .0716596    .1752351

			 
setx (gdppc10k majsize lnumlang legalbrit legalfra) mean lparty2 2 (minsize immigrant ecdifxx) mean
simqi

      Quantity of Interest |     Mean       Std. Err.    [95% Conf. Interval]
---------------------------+--------------------------------------------------
             Pr(educ_dj=0) |   .6618889     .1173549     .4068435    .8555271
             Pr(educ_dj=1) |   .1201731     .0418213     .0443635    .2085979
             Pr(educ_dj=2) |    .217938     .0943035     .0799433    .4327447



			 
			 
//* Figure 4: Predicted Probabilities of Recognition by Institutionalization *//
use "PSRM Monad.dta"
estsimp ologit educ_dj3 lparty gdppc10k majority lnumlang legalbrit legalfra gw_mon gw_mil gw_part gw_pers gw_mil_part gw_mil_pers gw_part_pers whemisphere seurope eeurope safrica mena, cluster(prz)


setx lparty 0 (gdppc10k majority lnumlang) mean (legalbrit legalfra gw_mon gw_mil gw_part gw_pers gw_mil_part gw_mil_pers gw_part_pers whemisphere seurope eeurope safrica mena) median
simqi

      Quantity of Interest |     Mean       Std. Err.    [95% Conf. Interval]
---------------------------+--------------------------------------------------
            Pr(educ_dj3=0) |     .80404     .1406931     .4200299    .9679977
            Pr(educ_dj3=1) |   .0528878     .0336456      .007931    .1286384
            Pr(educ_dj3=2) |   .1430722     .1151137     .0206858    .4587566

			
setx lparty 1 (gdppc10k majority lnumlang) mean (legalbrit legalfra gw_mon gw_mil gw_part gw_pers gw_mil_part gw_mil_pers gw_part_pers whemisphere seurope eeurope safrica mena) median
simqi

      Quantity of Interest |     Mean       Std. Err.    [95% Conf. Interval]
---------------------------+--------------------------------------------------
            Pr(educ_dj3=0) |   .7674918     .1441607     .4013289    .9518245
            Pr(educ_dj3=1) |   .0610298     .0340405      .012963    .1350072
            Pr(educ_dj3=2) |   .1714785     .1198374     .0331555    .4781426

			
setx lparty 2 (gdppc10k majority lnumlang) mean (legalbrit legalfra gw_mon gw_mil gw_part gw_pers gw_mil_part gw_mil_pers gw_part_pers whemisphere seurope eeurope safrica mena) median
simqi

      Quantity of Interest |     Mean       Std. Err.    [95% Conf. Interval]
---------------------------+--------------------------------------------------
            Pr(educ_dj3=0) |    .722669     .1506431      .361416    .9303327
            Pr(educ_dj3=1) |   .0696287     .0343718     .0181119    .1457314
            Pr(educ_dj3=2) |   .2077023     .1283552     .0451068    .5418434


			

		
//* Figure 5: Marginal Effects of Multiparty with 90% Confidence Interval *//
use "PSRM Monad.dta"



/* GDP/Capita (10,000) */
ologit educ_dj3 i.lparty_dum2##c.gdp growth1 logchange  purges leadershipchange resources  lnumlang majority legalbrit legalfra civiliandict militarydict year, cluster(prz) 
margins, dydx(lparty_dum2) at(gdp=(0(1)9)) level(90)

Average marginal effects                          Number of obs   =       2695
Model VCE    : Robust

Expression   : Pr(educ_dj3==0), predict()
dy/dx w.r.t. : 1.lparty_dum2

1._at        : gdppc10k        =           0
2._at        : gdppc10k        =           1
3._at        : gdppc10k        =           2
4._at        : gdppc10k        =           3
5._at        : gdppc10k        =           4
6._at        : gdppc10k        =           5
7._at        : gdppc10k        =           6
8._at        : gdppc10k        =           7
9._at        : gdppc10k        =           8
10._at       : gdppc10k        =           9

--------------------------------------------------------------------------------
               |            Delta-method
               |      dy/dx   Std. Err.      z    P>|z|     [90% Conf. Interval]
---------------+----------------------------------------------------------------
1.lparty_dum2  |
           _at |
            1  |  -.0829323   .7167291    -0.12   0.908    -1.261847    1.095982
            2  |  -.0781361   .1106339    -0.71   0.480    -.2601128    .1038405
            3  |  -.0643218   .2337299    -0.28   0.783    -.4487732    .3201297
            4  |  -.0449751   .3429446    -0.13   0.896    -.6090688    .5191186
            5  |  -.0250031   .4098371    -0.06   0.951    -.6991252     .649119
            6  |  -.0084585   .4261601    -0.02   0.984    -.7094295    .6925125
            7  |   .0027799   .4010531     0.01   0.994    -.6568937    .6624535
            8  |   .0090303   .3541792     0.03   0.980    -.5735426    .5916032
            9  |   .0119645     .30626     0.04   0.969    -.4917883    .5157173
           10  |   .0134787    .271372     0.05   0.960    -.4328886    .4598459
--------------------------------------------------------------------------------
Note: dy/dx for factor levels is the discrete change from the base level.

marginsplot, level(90)



/* Growth (t-1) */
ologit educ_dj3 i.lparty_dum2##c.growth1 logchange  purges leadershipchange gdppc10k resources lnumlang majority legalbrit legalfra civiliandict militarydict year, cluster(prz) 
margins, dydx(lparty_dum2) at(growth1=(-.5(.1).5)) level(90)

Average marginal effects                          Number of obs   =       2695
Model VCE    : Robust

Expression   : Pr(educ_dj3==0), predict()
dy/dx w.r.t. : 1.lparty_dum2

1._at        : growth1         =         -.5
2._at        : growth1         =         -.4
3._at        : growth1         =         -.3
4._at        : growth1         =         -.2
5._at        : growth1         =         -.1
6._at        : growth1         =           0
7._at        : growth1         =          .1
8._at        : growth1         =          .2
9._at        : growth1         =          .3
10._at       : growth1         =          .4
11._at       : growth1         =          .5

--------------------------------------------------------------------------------
               |            Delta-method
               |      dy/dx   Std. Err.      z    P>|z|     [90% Conf. Interval]
---------------+----------------------------------------------------------------
1.lparty_dum2  |
           _at |
            1  |  -.1739508   .0715559    -2.43   0.015    -.2916498   -.0562518
            2  |  -.1565111   .0658405    -2.38   0.017     -.264809   -.0482131
            3  |  -.1392008   .0614444    -2.27   0.023    -.2402678   -.0381337
            4  |  -.1220666   .0586518    -2.08   0.037    -.2185402    -.025593
            5  |  -.1051538   .0576313    -1.82   0.068    -.1999488   -.0103587
            6  |  -.0885057   .0583659    -1.52   0.129     -.184509    .0074976
            7  |  -.0721637   .0606482    -1.19   0.234    -.1719211    .0275937
            8  |  -.0561661   .0641491    -0.88   0.381     -.161682    .0493498
            9  |  -.0405487   .0685091    -0.59   0.554    -.1532361    .0721388
           10  |  -.0253437   .0734034    -0.35   0.730    -.1460816    .0953941
           11  |  -.0105803   .0785687    -0.13   0.893    -.1398143    .1186537
--------------------------------------------------------------------------------
Note: dy/dx for factor levels is the discrete change from the base level.

marginsplot, level(90)



/* (log) Years in Power */
ologit educ_dj3 i.lparty_dum2##c.logchange  growth1 purges leadershipchange gdppc10k resources lnumlang majority legalbrit legalfra civiliandict militarydict year , cluster(prz) 
margins, dydx(lparty_dum2) at(logchange=(0(.25)3.5)) level(90)

Average marginal effects                          Number of obs   =       2695
Model VCE    : Robust

Expression   : Pr(educ_dj3==0), predict()
dy/dx w.r.t. : 1.lparty_dum2

1._at        : logchange       =           0
2._at        : logchange       =         .25
3._at        : logchange       =          .5
4._at        : logchange       =         .75
5._at        : logchange       =           1
6._at        : logchange       =        1.25
7._at        : logchange       =         1.5
8._at        : logchange       =        1.75
9._at        : logchange       =           2
10._at       : logchange       =        2.25
11._at       : logchange       =         2.5
12._at       : logchange       =        2.75
13._at       : logchange       =           3
14._at       : logchange       =        3.25
15._at       : logchange       =         3.5

--------------------------------------------------------------------------------
               |            Delta-method
               |      dy/dx   Std. Err.      z    P>|z|     [90% Conf. Interval]
---------------+----------------------------------------------------------------
1.lparty_dum2  |
           _at |
            1  |  -.1455964   .0899332    -1.62   0.105    -.2935234    .0023306
            2  |  -.1368698   .0815962    -1.68   0.093    -.2710836    -.002656
            3  |  -.1281886    .074121    -1.73   0.084    -.2501069   -.0062704
            4  |   -.119564   .0677694    -1.76   0.078    -.2310348   -.0080931
            5  |  -.1110067   .0628394    -1.77   0.077    -.2143682   -.0076451
            6  |  -.1025274   .0596205    -1.72   0.085    -.2005944   -.0044603
            7  |  -.0941365   .0583148    -1.61   0.106    -.1900558    .0017828
            8  |  -.0858441   .0589528    -1.46   0.145    -.1828129    .0111247
            9  |    -.07766   .0613686    -1.27   0.206    -.1786023    .0232823
           10  |  -.0695935   .0652552    -1.07   0.286    -.1769287    .0377418
           11  |  -.0616535   .0702591    -0.88   0.380    -.1772194    .0539124
           12  |  -.0538486   .0760526    -0.71   0.479     -.178944    .0712468
           13  |  -.0461868   .0823661    -0.56   0.575    -.1816669    .0892934
           14  |  -.0386756   .0889914    -0.43   0.664    -.1850534    .1077021
           15  |  -.0313222   .0957724    -0.33   0.744    -.1888537    .1262093
--------------------------------------------------------------------------------
Note: dy/dx for factor levels is the discrete change from the base level.

marginsplot, level(90)



/* Purges */
ologit educ_dj3 i.lparty_dum2##c.purges  growth1 logchange leadershipchange gdppc10k resources lnumlang majority legalbrit legalfra civiliandict militarydict year, cluster(prz) 
margins, dydx(lparty_dum2) at(purges=(0(1)10)) level(90)

Average marginal effects                          Number of obs   =       2695
Model VCE    : Robust

Expression   : Pr(educ_dj3==0), predict()
dy/dx w.r.t. : 1.lparty_dum2

1._at        : purges          =           0
2._at        : purges          =           1
3._at        : purges          =           2
4._at        : purges          =           3
5._at        : purges          =           4
6._at        : purges          =           5
7._at        : purges          =           6
8._at        : purges          =           7
9._at        : purges          =           8
10._at       : purges          =           9
11._at       : purges          =          10

--------------------------------------------------------------------------------
               |            Delta-method
               |      dy/dx   Std. Err.      z    P>|z|     [90% Conf. Interval]
---------------+----------------------------------------------------------------
1.lparty_dum2  |
           _at |
            1  |  -.0704145   .0588449    -1.20   0.231    -.1672057    .0263767
            2  |  -.1281085   .0653265    -1.96   0.050     -.235561    -.020656
            3  |  -.1884617   .0867967    -2.17   0.030    -.3312295   -.0456938
            4  |  -.2486181   .1127666    -2.20   0.027    -.4341027   -.0631335
            5  |   -.305813   .1351027    -2.26   0.024    -.5280371   -.0835889
            6  |  -.3577562   .1496675    -2.39   0.017    -.6039373   -.1115751
            7  |  -.4028819   .1553247    -2.59   0.009    -.6583684   -.1473955
            8  |  -.4404344    .153226    -2.87   0.004    -.6924687   -.1884001
            9  |  -.4704087   .1460949    -3.22   0.001    -.7107134   -.2301041
           10  |  -.4933929   .1373877    -3.59   0.000    -.7193756   -.2674103
           11  |  -.5103582   .1303292    -3.92   0.000    -.7247307   -.2959857
--------------------------------------------------------------------------------
Note: dy/dx for factor levels is the discrete change from the base level.

marginsplot, level(90)



/* # Leadership Changes */
ologit educ_dj3 i.lparty_dum2##c.leadershipchange  growth1 logchange purges gdppc10k resources lnumlang majority legalbrit legalfra civiliandict militarydict year, cluster(prz) 
margins, dydx(lparty_dum2) at(leadershipchange=(0(1)10)) level(90)

Average marginal effects                          Number of obs   =       2695
Model VCE    : Robust

Expression   : Pr(educ_dj3==0), predict()
dy/dx w.r.t. : 1.lparty_dum2

1._at        : leadership~s    =           0
2._at        : leadership~s    =           1
3._at        : leadership~s    =           2
4._at        : leadership~s    =           3
5._at        : leadership~s    =           4
6._at        : leadership~s    =           5
7._at        : leadership~s    =           6
8._at        : leadership~s    =           7
9._at        : leadership~s    =           8
10._at       : leadership~s    =           9
11._at       : leadership~s    =          10

--------------------------------------------------------------------------------
               |            Delta-method
               |      dy/dx   Std. Err.      z    P>|z|     [90% Conf. Interval]
---------------+----------------------------------------------------------------
1.lparty_dum2  |
           _at |
            1  |   .0091067   .0672144     0.14   0.892     -.101451    .1196645
            2  |  -.0207728   .0620465    -0.33   0.738    -.1228303    .0812847
            3  |  -.0527028   .0596911    -0.88   0.377     -.150886    .0454803
            4  |  -.0864023   .0615126    -1.40   0.160    -.1875816     .014777
            5  |  -.1215264   .0679851    -1.79   0.074    -.2333519   -.0097008
            6  |  -.1576779   .0783788    -2.01   0.044    -.2865997   -.0287562
            7  |  -.1944225   .0913706    -2.13   0.033    -.3447137   -.0441312
            8  |  -.2313053   .1056729    -2.19   0.029    -.4051217   -.0574888
            9  |  -.2678704   .1202613    -2.23   0.026    -.4656827   -.0700581
           10  |  -.3036796   .1343923    -2.26   0.024    -.5247352   -.0826239
           11  |  -.3383296   .1475784    -2.29   0.022    -.5810744   -.0955847
--------------------------------------------------------------------------------
Note: dy/dx for factor levels is the discrete change from the base level.

marginsplot, level(90)
