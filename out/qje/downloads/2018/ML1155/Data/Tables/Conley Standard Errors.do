**************************************
*Replication files for "The Mission"
*Felipe Valencia Caicedo (2018)
*Conley Standard Errors
**************************************

*Make sure that you have installed or first run the Conley x_ols ado file
*Available at: http://economics.uwo.ca/faculty/conley/data_GMMWithCross_99/x_ols.ado
*Conley.do


*Table II

*use Argentina Brazil Paraguay Spatial.dta
*drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distmiss lati longi corr ita mis mis1 one, coord(2) xreg (8)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distmiss lati longi area tempe alti preci rugg river coast corr ita mis mis1 one, coord(2) xreg (15)

*use Brazil Literacy Spatial.dta
*drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distmiss lati longi meso one, coord(2) xreg (5)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distmiss lati longi area tempe alti preci rugg river coast meso, coord(2) xreg (11)

*use Argentina Literacy Spatial.dta
*drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distmiss lati longi corr one, coord(2) xreg (5)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distmiss lati longi area tempe alti preci rugg river coast corr one, coord(2) xreg (12)

*use Paraguay Literacy Spatial.dta
*drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distmiss ita one, coord(2) xreg (3)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distmiss area tempe alti preci rugg river coast ita one, coord(2) xreg (10)


*Table III

*use Median Years of Schooling Brazil Spatial.dta
*drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 edumedyr distmiss meso lat1 long1 one, coord(2) xreg (5)
drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 edumedyr  distmiss lat1 long1 area river slope rugg alt tempe rain coast meso one, coord(2) xreg (13)

*use Income Brazil Paraguay Spatial.dta
*drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 lnincome distmiss lati longi  par one, coord(2) xreg (5)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 lnincome distmiss lati longi area river slope rugg alti tempe preci landlocked coast par one, coord(2) xreg (14)

*use Poverty Argentina Paraguay Spatial.dta
*drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 pnbiper distmiss lati lon par one, coord(2) xreg (5)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 pnbiper distmiss  coast river alti tempe area preci lati lon par one, coord(2) xreg (11)


*Table IV

*use Placebo Literacy Spatial.dta
*drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distpar distfran lati longi area alti tempe  preci river rugg coast landlocked ita mis1 corr mis one, coord(2) xreg (17)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distgua distfran lati longi area alti tempe  preci river rugg coast landlocked ita mis1 corr mis one, coord(2) xreg (17)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distita distfran lati longi area alti tempe  preci river rugg coast landlocked ita mis1 corr mis one, coord(2) xreg (17)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distpar distgua distita  lati longi par arg one, coord(2) xreg (8)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distpar distgua distita distfran lati longi area alti tempe  preci river rugg coast landlocked ita mis1 corr mis one, coord(2) xreg (19)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distpar distgua distita distmiss  lati longi par arg one, coord(2) xreg (9)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1  illiteracy distpar distgua distita distmiss distfran lati longi area alti tempe  preci river rugg coast landlocked ita mis1 corr mis one, coord(2) xreg (20)


*Table V

*use Median Years of Schooling Brazil Spatial.dta
drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 edumedyr distpar distgua distita  distfran long1 area temp alt rain tordist1 rugg river coast meso one, coord(2) xreg (15)
drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 edumedyr distpar distgua distita distmiss  distfran long1 area temp alt rain tordist1 rugg river coast meso one, coord(2) xreg (16)

*use Placebo Income Spatial.dta
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 lnincome distpar distgua distita distfran lati longi area alt temp preci river rugg coast slope par one, coord(2) xreg (16)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 lnincome distpar distgua distitaa distmiss distfran lati longi area alt temp preci river rugg coast slope par one, coord(2) xreg (17)

*use Poverty Argentina Paraguay Spatial.dta
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 pnbiper distpar distgua distita distfran coast river alti tempe area preci rugg distord1 longi par one, coord(2) xreg (15)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 pnbiper distpar distgua distita distmiss distfran coast river alti tempe area preci rugg distord1 longi par one, coord(2) xreg (16)


*Table VI

*use Argentina Brazil Paraguay Spatial.dta
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 illiteracy distfran lati longi arg par one, coord(2) xreg (6)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 illiteracy distfran lati longi area river slope rugg alti tempe preci landlocked coast par arg one, coord(2) xreg (15)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 illiteracy distfran distmiss lati longi arg par one, coord(2) xreg (7)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 illiteracy distfran distmiss lati longi area river slope rugg alti tempe preci landlocked coast par arg one, coord(2) xreg (16)

*use Brazil Literacy Spatial.dta
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 illiteracy  distfran distmiss lati longi area tempe alti preci rugg river  slope landlocked coast meso one, coord(2) xreg (15)

*use Argentina Literacy Spatial.dta
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 illiteracy  distfran distmiss  lati longi area tempe alti preci rugg river slope coast corr one, coord(2) xreg (14)

*use Paraguay Literacy Spatial.dta
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 illiteracy  distfran distmiss  area river slope rugg alti tempe preci coast ita one, coord(2) xreg (12)


*Table VII

*use Median Years of Schooling Brazil Spatial.dta
drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 edumedyr  distfran lat1 long1 area river slope rugg alt tempe rain coast meso one, coord(2) xreg (13)
drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 edumedyr  distfran distmiss lat1 long1 area river slope rugg alt tempe rain coast meso one, coord(2) xreg (14)

*use Income Brazil Paraguay Spatial.dta
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 lnincome distfran lati longi area river slope rugg alti tempe preci landlocked coast par one, coord(2) xreg (14)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 lnincome distfran distmiss lati longi area river slope rugg alti tempe preci landlocked coast par one, coord(2) xreg (15)

*use Poverty Argentina Paraguay Spatial.dta
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 pnbiper distfran coast river alti tempe area preci rugg lati longi ita mis corr one, coord(2) xreg (14)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 pnbiper distfran distmiss coast river alti tempe area preci rugg lati longi ita mis corr one, coord(2) xreg (15)


*Table IX

*use Structural Transformation Brazil.dta
*drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 agroper distmiss one lat1 long1  meso , coord(2) xreg (5)
drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 induper distmiss one lat1 long1  meso , coord(2) xreg (5)
drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 commper distmiss one lat1 long1  meso , coord(2) xreg (5)

*use Structural Transformation Brazil Spatial.dta
*drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 agroper distmiss distfran  one lat1 long1 area temp alt rain rugg river coast slope meso , coord(2) xreg (14)
drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 induper distmiss distfran  one lat1 long1 area temp alt rain rugg river coast slope meso , coord(2) xreg (14)
drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 commper distmiss distfran  one lat1 long1 area temp alt rain rugg river coast slope meso , coord(2) xreg (14)


*Table XI

*use Soy Spatial.dta
*drop  epsilon window dis1 dis2
x_ols latitude longitude cutoff1 cutoff1 soy_TA distmiss distfran time latitude longitude micro dA_soy one , coord(2) xreg (8)

*use Soy Spa2.dta
*drop  epsilon window dis1 dis2
x_ols latitude longitude cutoff1 cutoff1 dgsoy_TA distmiss distfran dA_soy latitude longitude micro one , coord(2) xreg (7)

*use Soy Spa3.dta
*drop  epsilon window dis1 dis2
x_ols latitude longitude cutoff1 cutoff1 dnsoy_TA distmiss distfran dA_soy latitude longitude micro one , coord(2) xreg (7)

*use Soy Spa4.dta
*drop  epsilon window dis1 dis2
x_ols latitude longitude cutoff1 cutoff1 log_PQ_LA  distmiss distfran dA_soy latitude longitude micro one , coord(2) xreg (7)

*use Soy Spa5.dta
*drop  epsilon window dis1 dis2
x_ols latitude longitude cutoff1 cutoff1 La_L distmiss distfran time latitude longitude micro one , coord(2) xreg (7)
drop  epsilon window dis1 dis2
x_ols latitude longitude cutoff1 cutoff1 Lm_L distmiss distfran time latitude longitude micro one , coord(2) xreg (7)
drop  epsilon window dis1 dis2
x_ols latitude longitude cutoff1 cutoff1 Ls_L distmiss distfran time latitude longitude micro one , coord(2) xreg (7)


*Table XII

*Panel A
*use Argentina Brazil Paraguay Spatial.dta
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 popd distmiss distfran area river slope rugg alti tempe preci landlocked coast arg par lati longi one , coord(2) xreg (16)

drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 roads distmiss distfran lati longi area tempe alti preci rugg slope river coast corr ita mis mis1 one, coord(2) xreg (17)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 rail distmiss distfran lati longi area tempe alti preci rugg slope river coast corr ita mis mis1 one, coord(2) xreg (17)

*Panel B
*use Median Years of Schooling Brazil.dta
drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 ifdmhea100 distmiss distfran area river slope rugg alti tempe preci landlocked meso coast lat lon one , coord(2) xreg (15)

*use Culture Brazil Spatial.dta
*drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 turismo distmiss distfran  alt area temp rain meso lat1 long1 one , coord(2) xreg (10)

*use Culture Paraguay Spatial.dta
*drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 museum distmiss distfran itapua area coast river slope rugg alti tempe preci one , coord(2) xreg (12)
drop  epsilon window dis1 dis2
x_ols lati longi cutoff1 cutoff1 visited distmiss distfran itapua area coast river slope rugg alti tempe preci lati longi one , coord(2) xreg (14)

*use Median Years of Schooling Brazil Resident.dta
*drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 edumedyr  distmiss area river slope rugg alti tempe preci landlocked coast meso one , coord(2) xreg (12)

*use Median Years of Schooling Brazil Non-resident.dta
*drop  epsilon window dis1 dis2
x_ols lat1 long1 cutoff1 cutoff1 edumedyr  distmiss area river slope rugg alti tempe preci landlocked coast meso one , coord(2) xreg (12)



