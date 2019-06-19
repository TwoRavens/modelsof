******************************************************************************************************************************************
*MANUSCRIPT: Authorized Generic Entry prior to Patent Expiry: Reassessing Incentives for Independent Generic Entry 
*AUTHOR:     Silvia Appelt, University of Munich, silvia.appelt@lrz.uni-muenchen.de

******************************************************************************************************************************************
				                    *** MATCHING of NPI DB 2005, DB 2006 and DB 2007 & DATA CLEANING ***
						            		* Date last edit:  11 January 2015 * 
******************************************************************************************************************************************   
version 13.0
set more off
cap log close
clear

***** (I) DATA MATCHING
*Match using "pzn_id_string pzn_diff hst_hist_id" as identifier [pzn_id_string pzn_diff equivalent to pzn_id_mod]
use "NPI_DB07\hist_db07.dta", clear
sort pzn_id_string pzn_diff hst_hist_id_string
merge pzn_id_string pzn_diff hst_hist_id_string using "NPI_DB06\hist_db06.dta"
tab _m
drop _m
save npi_hist.dta, replace
sort pzn_id_string pzn_diff hst_hist_id_string
merge pzn_id_string pzn_diff hst_hist_id_string using "NPI_DB05\hist_db05.dta"
tab _m
drop _m

drop pzn_id
destring pzn_id_string, generate(pzn_id)
count if pzn_id!=key_id
format pzn_id %10.0g
save npi_hist.dta, replace

drop prod_change   
by pzn_id_mod, sort: egen pzn_mod_index=count(pzn_id_mod)
tab pzn_mod_index
generate prod_change=0 
replace prod_change=1 if pzn_mod_index!=1
tab prod_change
drop pzn_mod_index

sort pzn_id_mod
egen pzn_no=group(pzn_id_mod)
sum pzn_no
save npi_hist.dta, replace


***** (II) DATA CLEANING based on a stepwise data cleaning routine applied to the matched NPI data
*Harmonization of names (strings) and numeric ids across NPI DB05, DB06 and DB07 due to name spelling inconsistencies or use of multiple ids
*Harmonization and update of qualitative (time-variant) information on pharmaceutical retail forms (e.g. drug type: gen_id) across NPI DB05, DB06 and DB07
*The reuse of pzn id related to product exits/entries and phase outs requires generation of modified version of pzn id (pzn_id_mod)

**1st round data cleaning
use npi_hist.dta, clear

**(1) Harmonize producer names/ids across across NPI DB05, DB06 and DB07 
*Spelling inconsistencies
*Producer
replace hersteller="Albrecht" if hersteller=="Albrecht 1"

*Previous producer: Hersteller_hist
replace hersteller_hist="Albrecht" if hersteller_hist=="Albrecht 1"
replace hersteller_hist="Hoheisel" if hersteller_hist=="Hoheisel 1"

*Hersteller vs. Hersteller_hist
replace hersteller="Hameln Ph." if hersteller=="Hameln Ph" 
replace hersteller_hist="Pfizer Pharma" if hersteller_hist=="Pfizer" 

*Parent Firms: Konzern
replace konzern="Albrecht" if konzern=="Albrecht 1"
replace konzern="Bionorica AG" if konzern=="Popp"
replace konzern="Graesler Pharma" if konzern=="Gräsler"
replace konzern="Abbott" if konzern=="Abbott "

*Duplicate firm IDs and names
*producer ID
replace hst_id=10839 if hersteller=="Hansa Pharm"

*duplicate producer name (spelling/name change)
replace hersteller="Wilhelm Horn" if hst_id==637
replace hersteller="Meda Pharma" if hst_id==928
replace hersteller="Ethicon AWC" if hst_id==931
replace hersteller="Ethicon EPD" if hst_id==7705
replace hersteller="BionoricaEthics" if hst_id==1380
replace hersteller="Biomedica" if hst_id==3308
replace hersteller="Allergan" if hst_id==5040
replace hersteller="Dima Gesellschaft" if hst_id==6006
replace hersteller="Emra-Med        >" if hst_id==7741
replace hersteller="Gero-Lab" if hst_id==9473
replace hersteller="Daiichi-Sankyo" if hst_id==18160
replace hersteller="Marien-A.Saarw." if hst_id==18793
replace hersteller="PE Products" if hst_id==23232
replace hersteller="Roche" if hst_id==25960
replace hersteller="Evonik Stockhausen" if hst_id==30220
replace hersteller="Procter Gamble" if hst_id==39712
replace hersteller="Berlin-Chemie" if hst_id==48010
replace hersteller="Eurim           >" if hst_id==72670

*previous producer ID
replace hst_hist_id=10839 if hersteller_hist=="Hansa Pharm"

*duplicate historic producer name (spelling/name change)
replace hersteller_hist="Wilhelm Horn" if hst_hist_id==637
replace hersteller_hist="Meda Pharma" if hst_hist_id==928
replace hersteller_hist="Ethicon AWC" if hst_hist_id==931
replace hersteller_hist="Ethicon EPD" if hst_hist_id==7705
replace hersteller_hist="Ethicon ASP" if hst_hist_id==14050
replace hersteller_hist="BionoricaEthics" if hst_hist_id==1380
replace hersteller_hist="Biomedica" if hst_hist_id==3308
replace hersteller_hist="Allergan" if hst_hist_id==5040
replace hersteller_hist="Dima Gesellschaft" if hst_hist_id==6006
replace hersteller_hist="Emra-Med        >" if hst_hist_id==7741
replace hersteller_hist="Gero-Lab" if hst_hist_id==9473
replace hersteller_hist="Daiichi-Sankyo" if hst_hist_id==18160
replace hersteller_hist="Marien-A.Saarw." if hst_hist_id==18793
replace hersteller_hist="PE Products" if hst_hist_id==23232
replace hersteller_hist="Roche" if hst_hist_id==25960
replace hersteller_hist="Evonik Stockhausen" if hst_hist_id==30220
replace hersteller_hist="Procter Gamble" if hst_hist_id==39712
replace hersteller_hist="Berlin-Chemie" if hst_hist_id==48010
replace hersteller_hist="Eurim           >" if hst_hist_id==72670

*duplicate parent firm ID
replace konz_id=10839 if konzern=="Hansa Pharm"
replace konz_id=1000146 if konzern=="Holtsch"
replace konz_id=1000421 if konzern=="Regena"
replace konz_id=1000324 if konzern=="Synthera"

*duplicate parent firm name (spelling/name change)
replace konzern="Wilhelm Horn" if konz_id==637
replace konzern="Biomedica" if konz_id==3308
replace konzern="Dima Gesellschaft" if konz_id==6006
replace konzern="Gero-Lab" if konz_id==9473
replace konzern="Almirall" if konz_id==1000013
replace konzern="Daiichi-Sankyo" if konz_id==1000279
replace konzern="Marien-A.Saarw." if konz_id==18793
replace konzern="Procter Gamble" if konz_id==39712
replace konzern="Allergy Therapeutics" if konz_id==1000040
replace konzern="Celesio" if konz_id==1000116
replace konzern="Merck KGaA" if konz_id==1000206
replace konzern="PlasmaSelect" if konz_id==1000248
replace konzern="Robugen" if konz_id==1000272
replace konzern="Stada AG" if konz_id==1000308
replace konzern="Dermapharm" if konz_id==1000363
replace konzern="Axicorp Pharma" if konzern=="Axicorp"  

replace konzern="Acis" if konzern=="Dermapharm" & hst_id==43
replace konzern="Teva" if konzern=="Dermapharm" & hst_id==31051
replace konzern="Giulini Chemie" if konzern=="Dermapharm" & hst_id==48180
replace konzern="Remy & Geiser" if konzern=="Ph.Wernigerode" & hst_id==48190
replace konzern="Johnson & Johnson" if konzern=="J&J Wound" & hst_id==931
replace konzern="Stada AG" if konzern=="Stadapharm" & hst_id==29650
replace konzern="PlasmaSelect" if konzern=="DeltaSelect" & hst_id==417
replace konzern="Bionorica AG" if konzern=="PlasmaSelect" & hst_id==1380
replace konzern="PlasmaSelect" if konzern=="DeltaSelect" & hst_id==25930

*Correct Reimport Classifications (">")
*Reimport Classification: Hersteller      
replace hersteller="ME Pharma       >" if hersteller=="ME Pharma >     >"  

*Reimport Classification: Hersteller_hist      
replace hersteller_hist="ME Pharma       >" if hersteller_hist=="ME Pharma >     >"

*Reimport Classification Parent Firm        
replace konzern="ME Pharma" if konzern=="ME Pharma >"


**(2) Harmonize and update drug-type classification (product and retail form/PZN level) across NPI DB05, DB06 and DB07 
replace gen_id=4 if pzn_id_mod==8556
replace gen_id=4 if pzn_id_mod==8562
replace gen_id=2 if pzn_id_mod==630729
replace gen_id=2 if pzn_id_mod==630735
replace gen_id=2 if pzn_id_mod==709862
replace gen_id=4 if pzn_id_mod==948638
replace gen_id=4 if pzn_id_mod==948644
replace gen_id=4 if pzn_id_mod==948650
replace gen_id=4 if pzn_id_mod==948667
replace gen_id=4 if pzn_id_mod==948673
replace gen_id=4 if pzn_id_mod==948696
replace gen_id=4 if pzn_id_mod==948704
replace gen_id=4 if pzn_id_mod==948710
replace gen_id=4 if pzn_id_mod==948727
replace gen_id=2 if pzn_id_mod==1746227
replace gen_id=3 if pzn_id_mod==1851740
replace gen_id=3 if pzn_id_mod==1851823
replace gen_id=2 if pzn_id_mod==2744615
replace gen_id=3 if pzn_id_mod==2886396
replace gen_id=2 if pzn_id_mod==3829905
replace gen_id=2 if pzn_id_mod==3830021
replace gen_id=2 if pzn_id_mod==3830044
replace gen_id=2 if pzn_id_mod==4677403
replace gen_id=4 if pzn_id_mod==4916701
replace gen_id=2 if pzn_id_mod==4945111
replace gen_id=4 if pzn_id_mod==4965237
replace gen_id=4 if pzn_id_mod==4998917
replace gen_id=4 if pzn_id_mod==4998998
replace gen_id=4 if pzn_id_mod==6648392

replace gen_id=1 if prd_id==283600
replace gen_id=1 if prd_id==415373
replace gen_id=1 if prd_id==212807
replace gen_id=1 if prd_id==278701
replace gen_id=1 if prd_id==30703
replace gen_id=1 if prd_id==1924
replace gen_id=1 if prd_id==198625
replace gen_id=1 if prd_id==171893
replace gen_id=1 if prd_id==263691
replace gen_id=1 if prd_id==100007
replace gen_id=1 if prd_id==100458
replace gen_id=1 if prd_id==297558
replace gen_id=1 if prd_id==152502
replace gen_id=1 if prd_id==147035
replace gen_id=1 if prd_id==355089
replace gen_id=1 if prd_id==32263
replace gen_id=1 if prd_id==120418
replace gen_id=1 if prd_id==120920
replace gen_id=1 if prd_id==146247
replace gen_id=1 if prd_id==170813
replace gen_id=1 if prd_id==181208
replace gen_id=1 if prd_id==29121
replace gen_id=1 if prd_id==55326
replace gen_id=1 if prd_id==147429
replace gen_id=1 if prd_id==172459
replace gen_id=1 if prd_id==288122
replace gen_id=1 if prd_id==342898
replace gen_id=1 if prd_id==206245
replace gen_id=1 if prd_id==119938
replace gen_id=1 if prd_id==215038
replace gen_id=1 if prd_id==2307
replace gen_id=1 if prd_id==11869
replace gen_id=1 if prd_id==26883
replace gen_id=1 if prd_id==47738
replace gen_id=1 if prd_id==55635
replace gen_id=1 if prd_id==86547
replace gen_id=1 if prd_id==88702
replace gen_id=1 if prd_id==105786
replace gen_id=1 if prd_id==105788
replace gen_id=1 if prd_id==168889
replace gen_id=1 if prd_id==175673
replace gen_id=1 if prd_id==177455
replace gen_id=1 if prd_id==193831
replace gen_id=1 if prd_id==204299
replace gen_id=1 if prd_id==259232
replace gen_id=1 if prd_id==17201
replace gen_id=1 if prd_id==59378
replace gen_id=1 if prd_id==136623
replace gen_id=1 if prd_id==2701
replace gen_id=1 if prd_id==16673
replace gen_id=1 if prd_id==16708
replace gen_id=1 if prd_id==40180
replace gen_id=1 if prd_id==68779
replace gen_id=1 if prd_id==129584
replace gen_id=1 if prd_id==187468
replace gen_id=1 if prd_id==189357
replace gen_id=1 if prd_id==265015
replace gen_id=1 if prd_id==286585
replace gen_id=1 if prd_id==151617
replace gen_id=1 if prd_id==252496
replace gen_id=1 if prd_id==88536
replace gen_id=1 if prd_id==135331
replace gen_id=1 if prd_id==143299
replace gen_id=1 if prd_id==174224
replace gen_id=1 if prd_id==262799
replace gen_id=1 if prd_id==100264
replace gen_id=1 if prd_id==6360
replace gen_id=1 if prd_id==16716
replace gen_id=1 if prd_id==41864
replace gen_id=1 if prd_id==49094
replace gen_id=1 if prd_id==55934
replace gen_id=1 if prd_id==75054
replace gen_id=1 if prd_id==98848
replace gen_id=1 if prd_id==100705
replace gen_id=1 if prd_id==105796
replace gen_id=1 if prd_id==113420
replace gen_id=1 if prd_id==117134
replace gen_id=1 if prd_id==133265
replace gen_id=1 if prd_id==136112
replace gen_id=1 if prd_id==138610
replace gen_id=1 if prd_id==140873
replace gen_id=1 if prd_id==141572
replace gen_id=1 if prd_id==141658
replace gen_id=1 if prd_id==147409
replace gen_id=1 if prd_id==147414
replace gen_id=1 if prd_id==169055
replace gen_id=1 if prd_id==169317
replace gen_id=1 if prd_id==170351
replace gen_id=1 if prd_id==170824
replace gen_id=1 if prd_id==179113
replace gen_id=1 if prd_id==187514
replace gen_id=1 if prd_id==188898
replace gen_id=1 if prd_id==249245
replace gen_id=1 if prd_id==259588
replace gen_id=1 if prd_id==403917
replace gen_id=1 if prd_id==413097
replace gen_id=1 if prd_id==120483
replace gen_id=1 if prd_id==16250
replace gen_id=1 if prd_id==45105
replace gen_id=1 if prd_id==140116
replace gen_id=1 if prd_id==184454
replace gen_id=1 if prd_id==17282
replace gen_id=1 if prd_id==65545
replace gen_id=1 if prd_id==70654
replace gen_id=1 if prd_id==87449
replace gen_id=1 if prd_id==140451
replace gen_id=1 if prd_id==171043
replace gen_id=1 if prd_id==187765
replace gen_id=1 if prd_id==191425
replace gen_id=1 if prd_id==255087
replace gen_id=1 if prd_id==259712
replace gen_id=1 if prd_id==88746
replace gen_id=1 if prd_id==93052
replace gen_id=1 if prd_id==276340
replace gen_id=1 if prd_id==99809
replace gen_id=1 if prd_id==100673
replace gen_id=1 if prd_id==41156
replace gen_id=1 if prd_id==325859
replace gen_id=1 if prd_id==258582
replace gen_id=1 if prd_id==2709
replace gen_id=1 if prd_id==7077
replace gen_id=2 if prd_id==9294
replace gen_id=2 if prd_id==12274
replace gen_id=2 if prd_id==17114
replace gen_id=2 if prd_id==17131
replace gen_id=2 if prd_id==17147
replace gen_id=2 if prd_id==17196
replace gen_id=2 if prd_id==17198
replace gen_id=2 if prd_id==21083
replace gen_id=2 if prd_id==22060
replace gen_id=2 if prd_id==23600
replace gen_id=2 if prd_id==26957
replace gen_id=2 if prd_id==47918
replace gen_id=1 if prd_id==55323
replace gen_id=1 if prd_id==55792
replace gen_id=2 if prd_id==56893
replace gen_id=2 if prd_id==56899
replace gen_id=2 if prd_id==57450
replace gen_id=2 if prd_id==58459
replace gen_id=1 if prd_id==65593
replace gen_id=2 if prd_id==70601
replace gen_id=1 if prd_id==70655
replace gen_id=2 if prd_id==70672
replace gen_id=1 if prd_id==71344
replace gen_id=1 if prd_id==73367
replace gen_id=2 if prd_id==75106
replace gen_id=2 if prd_id==75134
replace gen_id=2 if prd_id==75578
replace gen_id=2 if prd_id==79036
replace gen_id=2 if prd_id==79286
replace gen_id=2 if prd_id==84962
replace gen_id=1 if prd_id==88549
replace gen_id=2 if prd_id==88766
replace gen_id=2 if prd_id==89041
replace gen_id=1 if prd_id==92221
replace gen_id=2 if prd_id==94620
replace gen_id=2 if prd_id==94761
replace gen_id=2 if prd_id==98843
replace gen_id=2 if prd_id==99770
replace gen_id=2 if prd_id==100708
replace gen_id=2 if prd_id==120973
replace gen_id=2 if prd_id==128288
replace gen_id=2 if prd_id==128953
replace gen_id=2 if prd_id==129250
replace gen_id=2 if prd_id==135323
replace gen_id=2 if prd_id==137172
replace gen_id=2 if prd_id==139166
replace gen_id=2 if prd_id==141735
replace gen_id=2 if prd_id==144489
replace gen_id=2 if prd_id==149406
replace gen_id=2 if prd_id==150374
replace gen_id=2 if prd_id==152694
replace gen_id=2 if prd_id==153190
replace gen_id=2 if prd_id==154513
replace gen_id=2 if prd_id==155548
replace gen_id=2 if prd_id==155844
replace gen_id=2 if prd_id==155868
replace gen_id=2 if prd_id==155869
replace gen_id=2 if prd_id==157218
replace gen_id=2 if prd_id==161223
replace gen_id=2 if prd_id==166706
replace gen_id=2 if prd_id==169569
replace gen_id=2 if prd_id==172958
replace gen_id=2 if prd_id==173815
replace gen_id=2 if prd_id==179100
replace gen_id=2 if prd_id==179112
replace gen_id=2 if prd_id==180633
replace gen_id=2 if prd_id==185614
replace gen_id=2 if prd_id==185783
replace gen_id=2 if prd_id==185819
replace gen_id=2 if prd_id==187773
replace gen_id=2 if prd_id==188868
replace gen_id=2 if prd_id==188893
replace gen_id=2 if prd_id==189356
replace gen_id=2 if prd_id==206137
replace gen_id=2 if prd_id==224577
replace gen_id=2 if prd_id==258173
replace gen_id=2 if prd_id==259299
replace gen_id=2 if prd_id==264269
replace gen_id=2 if prd_id==265361
replace gen_id=2 if prd_id==267171
replace gen_id=2 if prd_id==277207
replace gen_id=2 if prd_id==301568
replace gen_id=2 if prd_id==301800
replace gen_id=2 if prd_id==306886
replace gen_id=1 if prd_id==314144
replace gen_id=2 if prd_id==322986
replace gen_id=2 if prd_id==325860
replace gen_id=2 if prd_id==338301
replace gen_id=2 if prd_id==343880
replace gen_id=2 if prd_id==344851
replace gen_id=1 if prd_id==354980
replace gen_id=2 if prd_id==355033
replace gen_id=1 if prd_id==391376
replace gen_id=2 if prd_id==407030
replace gen_id=2 if prd_id==408128
replace gen_id=2 if prd_id==428377
replace gen_id=2 if prd_id==447062
replace gen_id=2 if prd_id==475999
replace gen_id=2 if prd_id==55305
replace gen_id=2 if prd_id==31548
replace gen_id=2 if prd_id==92516
replace gen_id=2 if prd_id==120412
replace gen_id=2 if prd_id==487252
replace gen_id=2 if prd_id==15966
replace gen_id=2 if prd_id==30837
replace gen_id=2 if prd_id==32407
replace gen_id=2 if prd_id==45681
replace gen_id=2 if prd_id==47790
replace gen_id=2 if prd_id==111235
replace gen_id=2 if prd_id==74350
replace gen_id=2 if prd_id==100759
replace gen_id=2 if prd_id==16333
replace gen_id=2 if prd_id==17166
replace gen_id=2 if prd_id==18729
replace gen_id=2 if prd_id==31163
replace gen_id=2 if prd_id==43169
replace gen_id=2 if prd_id==47876
replace gen_id=2 if prd_id==55521
replace gen_id=2 if prd_id==103552
replace gen_id=2 if prd_id==105814
replace gen_id=2 if prd_id==131426
replace gen_id=2 if prd_id==147468
replace gen_id=2 if prd_id==176742
replace gen_id=2 if prd_id==197995
replace gen_id=2 if prd_id==253104
replace gen_id=2 if prd_id==310853
replace gen_id=2 if prd_id==314998
replace gen_id=2 if prd_id==411628
replace gen_id=2 if prd_id==501280
replace gen_id=2 if prd_id==1695
replace gen_id=2 if prd_id==32836
replace gen_id=2 if prd_id==35073
replace gen_id=2 if prd_id==185647
replace gen_id=2 if prd_id==2420
replace gen_id=2 if prd_id==2424
replace gen_id=2 if prd_id==16772
replace gen_id=2 if prd_id==17217
replace gen_id=2 if prd_id==31695
replace gen_id=2 if prd_id==42994
replace gen_id=2 if prd_id==48933
replace gen_id=2 if prd_id==55311
replace gen_id=2 if prd_id==60133
replace gen_id=2 if prd_id==69185
replace gen_id=2 if prd_id==112849
replace gen_id=2 if prd_id==117216
replace gen_id=2 if prd_id==123352
replace gen_id=2 if prd_id==141569
replace gen_id=2 if prd_id==151462
replace gen_id=2 if prd_id==155667
replace gen_id=2 if prd_id==158031
replace gen_id=2 if prd_id==169311
replace gen_id=2 if prd_id==173952
replace gen_id=2 if prd_id==185552
replace gen_id=2 if prd_id==187509
replace gen_id=2 if prd_id==187754
replace gen_id=2 if prd_id==190749
replace gen_id=2 if prd_id==219724
replace gen_id=2 if prd_id==243093
replace gen_id=2 if prd_id==246307
replace gen_id=2 if prd_id==246676
replace gen_id=2 if prd_id==259354
replace gen_id=2 if prd_id==305397
replace gen_id=2 if prd_id==332485
replace gen_id=2 if prd_id==344635
replace gen_id=2 if prd_id==348349
replace gen_id=2 if prd_id==355477
replace gen_id=2 if prd_id==432551
replace gen_id=2 if prd_id==501256
replace gen_id=2 if prd_id==501243
replace gen_id=2 if prd_id==31716
replace gen_id=2 if prd_id==128252
replace gen_id=2 if prd_id==167580
replace gen_id=2 if prd_id==173954
replace gen_id=2 if prd_id==2331
replace gen_id=2 if prd_id==15616
replace gen_id=2 if prd_id==16688
replace gen_id=2 if prd_id==50210
replace gen_id=2 if prd_id==65499
replace gen_id=2 if prd_id==74416
replace gen_id=2 if prd_id==74978
replace gen_id=2 if prd_id==75203
replace gen_id=2 if prd_id==96358
replace gen_id=2 if prd_id==96582
replace gen_id=1 if prd_id==119365
replace gen_id=2 if prd_id==170175
replace gen_id=2 if prd_id==185792
replace gen_id=2 if prd_id==188222
replace gen_id=2 if prd_id==200101
replace gen_id=2 if prd_id==207583
replace gen_id=2 if prd_id==249316
replace gen_id=1 if prd_id==252956
replace gen_id=2 if prd_id==345513
replace gen_id=2 if prd_id==355898
replace gen_id=2 if prd_id==165887
replace gen_id=2 if prd_id==167572
replace gen_id=2 if prd_id==426760
replace gen_id=2 if prd_id==41896
replace gen_id=2 if prd_id==71302
replace gen_id=2 if prd_id==96569
replace gen_id=2 if prd_id==151614
replace gen_id=2 if prd_id==188575
replace gen_id=2 if prd_id==188907
replace gen_id=2 if prd_id==191736
replace gen_id=2 if prd_id==275987
replace gen_id=2 if prd_id==480889
replace gen_id=2 if prd_id==76403
replace gen_id=2 if prd_id==128951
replace gen_id=2 if prd_id==158053
replace gen_id=2 if prd_id==127324
replace gen_id=2 if prd_id==117222
replace gen_id=2 if prd_id==33722
replace gen_id=1 if prd_id==69109
replace gen_id=2 if prd_id==81818
replace gen_id=1 if prd_id==119366
replace gen_id=2 if prd_id==170416
replace gen_id=1 if prd_id==198507
replace gen_id=1 if prd_id==224325
replace gen_id=3 if prd_id==263692
replace gen_id=3 if prd_id==308208
replace gen_id=1 if prd_id==439725
replace gen_id=1 if prd_id==308784
replace gen_id=2 if prd_id==79921
replace gen_id=3 if prd_id==208315
replace gen_id=3 if prd_id==208316
replace gen_id=3 if prd_id==208317
replace gen_id=3 if prd_id==447995
replace gen_id=2 if prd_id==450134
replace gen_id=3 if prd_id==501267
replace gen_id=3 if prd_id==136150
replace gen_id=3 if prd_id==263531
replace gen_id=3 if prd_id==263354
replace gen_id=3 if prd_id==355626
replace gen_id=2 if prd_id==65761
replace gen_id=3 if prd_id==62840
replace gen_id=3 if prd_id==24142
replace gen_id=3 if prd_id==28114
replace gen_id=3 if prd_id==33592
replace gen_id=3 if prd_id==55877
replace gen_id=2 if prd_id==58199
replace gen_id=3 if prd_id==62621
replace gen_id=1 if prd_id==87745
replace gen_id=3 if prd_id==180635
replace gen_id=3 if prd_id==181287
replace gen_id=3 if prd_id==190742
replace gen_id=3 if prd_id==223124
replace gen_id=3 if prd_id==246230
replace gen_id=1 if prd_id==302225
replace gen_id=2 if prd_id==316054
replace gen_id=3 if prd_id==332138
replace gen_id=4 if prd_id==447119
replace gen_id=3 if prd_id==262310
replace gen_id=3 if prd_id==501352
replace gen_id=3 if prd_id==43329
replace gen_id=2 if prd_id==31669
replace gen_id=3 if prd_id==156253
replace gen_id=3 if prd_id==57122
replace gen_id=2 if prd_id==80125
replace gen_id=3 if prd_id==281816
replace gen_id=1 if prd_id==125731
replace gen_id=3 if prd_id==15067
replace gen_id=2 if prd_id==129651
replace gen_id=3 if prd_id==181292
replace gen_id=3 if prd_id==282691
replace gen_id=3 if prd_id==114486
replace gen_id=3 if prd_id==219828
replace gen_id=3 if prd_id==65974
replace gen_id=3 if prd_id==161175
replace gen_id=3 if prd_id==234636
replace gen_id=3 if prd_id==174697
replace gen_id=3 if prd_id==140754
replace gen_id=4 if prd_id==184860
replace gen_id=3 if prd_id==309697
replace gen_id=3 if prd_id==181291
replace gen_id=3 if prd_id==181293
replace gen_id=3 if prd_id==258267
replace gen_id=3 if prd_id==2646
replace gen_id=3 if prd_id==224411
replace gen_id=3 if prd_id==60895
replace gen_id=3 if prd_id==500903
replace gen_id=3 if prd_id==127699
replace gen_id=3 if prd_id==135627
replace gen_id=3 if prd_id==65973
replace gen_id=3 if prd_id==65975
replace gen_id=3 if prd_id==127396
replace gen_id=3 if prd_id==217654
replace gen_id=3 if prd_id==308734
replace gen_id=3 if prd_id==414125
replace gen_id=3 if prd_id==191074
replace gen_id=3 if prd_id==142844
replace gen_id=3 if prd_id==136410
replace gen_id=3 if prd_id==241520
replace gen_id=3 if prd_id==81366
replace gen_id=3 if prd_id==136409
replace gen_id=3 if prd_id==136412
replace gen_id=3 if prd_id==419314
replace gen_id=1 if prd_id==344405
replace gen_id=3 if prd_id==209214
replace gen_id=4 if prd_id==355238
replace gen_id=4 if prd_id==24642
replace gen_id=3 if prd_id==447635
replace gen_id=3 if prd_id==443705
replace gen_id=4 if prd_id==251197
replace gen_id=4 if prd_id==319687

tab generika if gen_id==1
replace generika="keine Generikasituation" if gen_id==1

tab generika if gen_id==2
replace generika="Generika" if gen_id==2

tab generika if gen_id==3
replace generika="Originalprodukt" if gen_id==3

tab generika if gen_id==4
replace generika="Patent" if gen_id==4

*Correct Reimport/Parallel-Import Classifications  
count if gen_id==1 & reimport==">"
count if reimport==">"
replace reimport="O" if prd_id==383208

	
** (3) Harmonize and update substance/drug names across NPI DB05, DB06 and DB07 -1
replace substanzen="Algeldrat" if substanzen=="Aluminiumhydroxid" 
replace sub_id=10809 if sub_id==776 & substanzen=="Algeldrat"
replace substanzen="Paromomycin sulfat" if substanzen=="Paromomycin" 
replace sub_id=15455 if sub_id==7128 & substanzen=="Paromomycin sulfat"
replace substanzen="Trinkwasser (20W)" if substanzen=="Wirkstoff unbekannt" & pzn_id_mod==568901
replace sub_id=10526 if sub_id==1 & pzn_id_mod==568901
replace substanzen="Arnica montana HOM (15W)" if substanzen=="Acidum silicicum (15W)" 
replace sub_id=15075 if sub_id==11140 & substanzen=="Arnica montana HOM (15W)"
replace substanzen="Calcium phosphoricum (20W)" if substanzen=="Magnesium phosphoricum (20W)" 
replace sub_id=15786 if sub_id==14499 & substanzen=="Calcium phosphoricum (20W)"
replace substanzen="4-Hexylresorcin + Dequalinium-Kation + Salvia officinalis L." if substanzen=="4-Hexylresorcin + Dequalinium-Kation + Salbeiblätter-Fluidextrakt, ethanolisch" 
replace sub_id=14319 if sub_id==15722 & substanzen=="4-Hexylresorcin + Dequalinium-Kation + Salvia officinalis L."
replace substanzen="Zeolith" if substanzen=="Klinoptilolith" 
replace sub_id=15620 if sub_id==14922 & substanzen=="Zeolith"
replace substanzen="Ricinus communis L." if substanzen=="Rizinusöl" 
replace sub_id=15606 if sub_id==14203 & substanzen=="Ricinus communis L."
replace substanzen="Poly(styrol-co-divinylbenzol)sulfonsäure (92:8), Calciumsalz" if substanzen=="Poly(styrol-co-divinylbenzol)sulfonsäure, Calciumsalz" 
replace sub_id=15370 if sub_id==12947 & substanzen=="Poly(styrol-co-divinylbenzol)sulfonsäure (92:8), Calciumsalz"
replace substanzen="Methacrylsäuremethylester (5W)" if substanzen=="Methyl 2-methylacrylat (5W)" 
replace sub_id=15541 if sub_id==6327 & substanzen=="Methacrylsäuremethylester (5W)"
replace substanzen="Peginterferon alfa-2b" if substanzen=="Peginterferon alfa" 
replace sub_id=15548 if sub_id==13791 & substanzen=="Peginterferon alfa-2b"
replace substanzen="Magnesium carbonat, leichtes, basisches + DL-alpha-Tocopherol" if sub_id==14097 
replace sub_id=15350 if sub_id==14097 & substanzen=="Magnesium carbonat, leichtes, basisches + DL-alpha-Tocopherol"
replace substanzen="Magnesiumoxid + DL-alpha-Tocopherol" if sub_id==6055 
replace sub_id=15352 if sub_id==6055 & substanzen=="Magnesiumoxid + DL-alpha-Tocopherol"


** (4) Harmonize and update product names/ids across NPI DB05, DB06 and DB07
**** Duplicate product IDs
replace prd_id=14449 if produkt=="ASS ABZ"
replace prd_id=14459 if produkt=="ASS CT (N02B2)"
replace prd_id=452181 if produkt=="Acidum hydrochloricum"
replace prd_id=454949 if produkt=="Acidum hydrofluoricum"
replace prd_id=3437 if produkt=="Acidum lacticum"
replace prd_id=456985 if produkt=="Acidum salicylicum"
replace prd_id=454275 if produkt=="Adonis vernalis"
replace prd_id=456787 if produkt=="Aralia racemosa"
replace prd_id=485455 if produkt=="Axicarb"
replace prd_id=501424 if produkt=="Biosan Vitamin E HEX"
replace prd_id=501431 if produkt=="Blausiegel MA-"
replace prd_id=355600 if produkt=="Bronchoforton Solinat"
replace prd_id=452885 if produkt=="Ceanothus americanus"
replace prd_id=452039 if produkt=="Chimaphila umbellata"
replace prd_id=452468 if produkt=="Chininum sulfuricum"
replace prd_id=281972 if produkt=="Chlamydia Test LBK"
replace prd_id=243716 if produkt=="Combur 9 Test E-M"
replace prd_id=457230 if produkt=="Cuprum aceticum"
replace prd_id=355210 if produkt=="Cystinol akut"
replace prd_id=454962 if produkt=="Dioscorea villosa"
replace prd_id=455599 if produkt=="Equisetum arvense"
replace prd_id=259117 if produkt=="Fenistil NV- (R06A)"
replace prd_id=501557 if produkt=="Freka Steril"
replace prd_id=348568 if produkt=="Ginkgo Sandoz"
replace prd_id=474828 if produkt=="Ginseng Gelee Royale"
replace prd_id=206281 if produkt=="Glucomen Sensor B/M"
replace prd_id=501387 if produkt=="Guarana HAP"
replace prd_id=78868 if produkt=="Horphagen"
replace prd_id=436365 if produkt=="Insulin Spritze"
replace prd_id=456678 if produkt=="Kalium bromatum"
replace prd_id=501410 if produkt=="Laxoberal"
replace prd_id=99994 if produkt=="Maaloxan WTP"
replace prd_id=456462 if produkt=="Magnesium chloratum"
replace prd_id=101870 if produkt=="Mar Plus"
replace prd_id=501381 if produkt=="Minirin FER"
replace prd_id=456812 if produkt=="Myristica sebifera"
replace prd_id=501495 if produkt=="Neo Gilurytmal"
replace prd_id=120458 if produkt=="Neurogrisevit"
replace prd_id=501373 if produkt=="Noctamid AII"
replace prd_id=448420 if produkt=="Norvir GER"
replace prd_id=501432 if produkt=="Nuk Beruh MA-"
replace prd_id=501425 if produkt=="Nuk Silik MA-"
replace prd_id=125705 if produkt=="Omnipaque SHG"
replace prd_id=125854 if produkt=="One Touch EUP"
replace prd_id=126859 if produkt=="Orimeten PWT"
replace prd_id=133200 if produkt=="PK Merz KHP"
replace prd_id=454532 if produkt=="Passiflora incarnata"
replace prd_id=136662 if produkt=="Prothazin RDB"
replace prd_id=355462 if produkt=="Pyromed S"
replace prd_id=355392 if produkt=="Rheumasan WTP"
replace prd_id=161175 if produkt=="Staphylex GSK"
replace prd_id=165522 if produkt=="Survanta"
replace prd_id=451910 if produkt=="Teucrium scorodonia"
replace prd_id=452164 if produkt=="Thymus vulgaris"
replace prd_id=184861 if produkt=="Viramune GER (J05C3)"
replace prd_id=456559 if produkt=="Zincum sulfuricum"

replace prdo_id=487141 if produkt_pi=="ASS ABZ"
replace prdo_id=14459 if produkt_pi=="ASS CT (N02B2)"
replace prdo_id=452181 if produkt_pi=="Acidum hydrochloricum"
replace prdo_id=454949 if produkt_pi=="Acidum hydrofluoricum"
replace prdo_id=3437 if produkt_pi=="Acidum lacticum"
replace prdo_id=456985 if produkt_pi=="Acidum salicylicum"
replace prdo_id=454275 if produkt_pi=="Adonis vernalis"
replace prdo_id=456787 if produkt_pi=="Aralia racemosa"
replace prdo_id=485455 if produkt_pi=="Axicarb"
replace prdo_id=501424 if produkt_pi=="Biosan Vitamin E HEX"
replace prdo_id=501431 if produkt_pi=="Blausiegel MA-"
replace prdo_id=355600 if produkt_pi=="Bronchoforton Solinat"
replace prdo_id=452885 if produkt_pi=="Ceanothus americanus"
replace prdo_id=452039 if produkt_pi=="Chimaphila umbellata"
replace prdo_id=452468 if produkt_pi=="Chininum sulfuricum"
replace prdo_id=281972 if produkt_pi=="Chlamydia Test LBK"
replace prdo_id=457230 if produkt_pi=="Cuprum aceticum"
replace prdo_id=355210 if produkt_pi=="Cystinol akut"
replace prdo_id=454962 if produkt_pi=="Dioscorea villosa"
replace prdo_id=455599 if produkt_pi=="Equisetum arvense"
replace prdo_id=259117 if produkt_pi=="Fenistil NV- (R06A) *"
replace prdo_id=501557 if produkt_pi=="Freka Steril"
replace prdo_id=348568 if produkt_pi=="Ginkgo Sandoz"
replace prdo_id=474828 if produkt_pi=="Ginseng Gelee Royale"
replace prdo_id=501387 if produkt_pi=="Guarana HAP"
replace prdo_id=78868 if produkt_pi=="Horphagen"
replace prdo_id=436365 if produkt_pi=="Insulin Spritze"
replace prdo_id=456678 if produkt_pi=="Kalium bromatum"
replace prdo_id=501410 if produkt_pi=="Laxoberal *"
replace prdo_id=99994  if produkt=="Maaloxan WTP"
replace produkt_pi="Maaloxan WTP *" if produkt=="Maaloxan WTP"
replace prdo_id=456462 if produkt_pi=="Magnesium chloratum"
replace prdo_id=101870 if produkt_pi=="Mar Plus"
replace prdo_id=501381 if produkt_pi=="Minirin FER *"
replace prdo_id=456812 if produkt_pi=="Myristica sebifera"
replace prdo_id=501495 if produkt_pi=="Neo Gilurytmal *"
replace prdo_id=120458 if produkt_pi=="Neurogrisevit"
replace prdo_id=501373 if produkt_pi=="Noctamid AII"
replace prdo_id=501432 if produkt_pi=="Nuk Beruh MA-"
replace prdo_id=501425 if produkt_pi=="Nuk Silik MA-"
replace prdo_id=454532 if produkt_pi=="Passiflora incarnata"
replace prdo_id=501481 if produkt_pi=="Prothazin RDB"
replace prdo_id=355462 if produkt_pi=="Pyromed S"
replace prdo_id=355392 if produkt_pi=="Rheumasan WTP"
replace prdo_id=161175 if produkt_pi=="Staphylex GSK"
replace prdo_id=165522 if produkt_pi=="Survanta"
replace prdo_id=451910 if produkt_pi=="Teucrium scorodonia"
replace prdo_id=452164 if produkt_pi=="Thymus vulgaris"
replace prdo_id=456559 if produkt_pi=="Zincum sulfuricum"

*duplicate product names 
replace produkt="Kraeuteroel " if prd_id==1011
replace produkt="Accutrend Sensor" if prd_id==2701
replace produkt="Acesal" if prd_id==2819
replace produkt="Acidum carbolicum" if prd_id==3197
replace produkt="Acidum Hydrofluor" if prd_id==3395
replace produkt="Acidum Lactic." if prd_id==3432
replace produkt="Acid.Phosphor." if prd_id==3554
replace produkt="Acidum phosphoricum SFP" if prd_id==3575
replace produkt="Actovegin " if prd_id==4051
replace produkt="Complex Praeparate " if prd_id==4371
replace produkt="Adriblastin" if prd_id==4443
replace produkt="Akineton" if prd_id==5502
replace produkt="Aleima" if prd_id==6085
replace produkt="Aletris" if prd_id==6321
replace produkt="Alovisa" if prd_id==7428
replace produkt="Alveofact" if prd_id==7941
replace produkt="Ampuwa (K05A1)" if prd_id==8845
replace produkt="Anco" if prd_id==9170
replace produkt="Antodox" if prd_id==10332
replace produkt="Apocynum" if prd_id==11088
replace produkt="Arelix ACE" if prd_id==12016
replace produkt="Aristochol" if prd_id==12298
replace produkt="Arthrex SZP" if prd_id==13358
replace produkt="Arthrex 1AP" if prd_id==13362
replace produkt="Arubendol" if prd_id==13724
replace produkt="Asche Basis" if prd_id==13930
replace produkt="Aspirin protect" if prd_id==14388
replace produkt="ASS Hexal" if prd_id==14437
replace produkt="ASS CT" if prd_id==14439
replace produkt="ASS Stada" if prd_id==14465
replace produkt="Atemur" if prd_id==15067
replace produkt="Axe Duschgel" if prd_id==16156
replace produkt="Bad Heilbrunner Melisse" if prd_id==16739
replace produkt="Batrafen " if prd_id==17996
replace produkt="Benalapril" if prd_id==20492
replace produkt="Bendigon" if prd_id==20509
replace produkt="Bergischer Kraeutertee" if prd_id==20917
replace produkt="Berotec" if prd_id==21025
replace produkt="Beta Acetyldigoxin" if prd_id==21190
replace produkt="Billy Boy" if prd_id==22082
replace produkt="Biochemie 1 PFG" if prd_id==22354
replace produkt="Biochemie 10 PFG" if prd_id==22366
replace produkt="Biochemie 11 PFG" if prd_id==22378
replace produkt="Biochemie 15 PFG" if prd_id==22417
replace produkt="Biochemie 3 PFG" if prd_id==22496
replace produkt="Biochemie 5 PFG" if prd_id==22521
replace produkt="Biochemie 6 PFG" if prd_id==22533
replace produkt="Biochemie 7 PFG" if prd_id==22545
replace produkt="Biochemie 9 PFG" if prd_id==22569
replace produkt="Bisolvonat" if prd_id==23849
replace produkt="Blemaren " if prd_id==24057
replace produkt="Bm Test " if prd_id==24416
replace produkt="Bondronat" if prd_id==24642
replace produkt="Borgon " if prd_id==24785
replace produkt="Borretsch Oel " if prd_id==24834
replace produkt="Brassica" if prd_id==26438
replace produkt="Buscopan plus" if prd_id==27890
replace produkt="Butler Gum" if prd_id==27914
replace produkt="Calcipot" if prd_id==28508
replace produkt="Calycast Injektopas" if prd_id==29420
replace produkt="Campral" if prd_id==29606
replace produkt="Cholo Injektopas" if prd_id==33909
replace produkt="Cimicifuga comp" if prd_id==34546
replace produkt="Cisplatin" if prd_id==34872
replace produkt="Citrusfasertabletten" if prd_id==35001
replace produkt="Claire Fisher" if prd_id==35073
replace produkt="Clearblue WIC" if prd_id==35330
replace produkt="Colchicum Dispert" if prd_id==36298
replace produkt="Collomack" if prd_id==36511
replace produkt="Commenfrey" if prd_id==38502
replace produkt="Contimit" if prd_id==40138
replace produkt="Convallaria Majal" if prd_id==40213
replace produkt="Crataegus Syxyl" if prd_id==41864
replace produkt="Crinone" if prd_id==42019
replace produkt="Denan" if prd_id==45172
replace produkt="Depuran" if prd_id==45414
replace produkt="Descofix" if prd_id==45682
replace produkt="Det Ms" if prd_id==45744
replace produkt="Detartrine" if prd_id==45747
replace produkt="Dibenzyran" if prd_id==46294
replace produkt="Dignodolin" if prd_id==46696
replace produkt="Dipiperon" if prd_id==47067
replace produkt="Dolormin" if prd_id==47754
replace produkt="Dopergin" if prd_id==47854
replace produkt="Doxorubicin" if prd_id==48066
replace produkt="DR Aloe" if prd_id==48164
replace produkt="Diclofenac Dura" if prd_id==49737
replace produkt="Durex Kondome" if prd_id==49768
replace produkt="Dysurgal " if prd_id==50260
replace produkt="Effortil" if prd_id==51492
replace produkt="Elanosol" if prd_id==52385
replace produkt="Elantan" if prd_id==52387
replace produkt="Eleutherococcus " if prd_id==55311
replace produkt="Ems Salin" if prd_id==55806
replace produkt="Eufusol" if prd_id==57875
replace produkt="Excitans" if prd_id==58644
replace produkt="Exneural" if prd_id==58682
replace produkt="Fango Rubriment" if prd_id==59558
replace produkt="Fibraflex (N02B2)" if prd_id==60828
replace produkt="Fibraflex (M01A1)" if prd_id==60829
replace produkt="First Test HCG " if prd_id==61503
replace produkt="Fissan Baby Pflege" if prd_id==61538
replace produkt="Flexurat" if prd_id==62020
replace produkt="Fluimucil" if prd_id==62707
replace produkt="Fragmin" if prd_id==63500
replace produkt="Fraxiparin" if prd_id==63613
replace produkt="Fromms FF" if prd_id==63876
replace produkt="Fumaderm" if prd_id==64366
replace produkt="Gabitril" if prd_id==64707
replace produkt="Gastrografin" if prd_id==65102
replace produkt="Gelatine Toepfer" if prd_id==65596
replace produkt="Gencin" if prd_id==65953
replace produkt="Gilurytmal" if prd_id==67688
replace produkt="Glandol Borretsch Oel" if prd_id==68099
replace produkt="Glimidstada" if prd_id==68389
replace produkt="Glucofilm" if prd_id==68573
replace produkt="Glucostix" if prd_id==68803
replace produkt="Gonal" if prd_id==69092
replace produkt="Grindelia Robusta" if prd_id==69763
replace produkt="Grippostad " if prd_id==69804
replace produkt="Guarana GNW" if prd_id==70014
replace produkt="Gutron" if prd_id==70275
replace produkt="Hamamelis Komplex" if prd_id==71282
replace produkt="Hestia" if prd_id==75134
replace produkt="Hexoraletten" if prd_id==75490
replace produkt="Ilomedin" if prd_id==81285
replace produkt="Imeron" if prd_id==81349
replace produkt="Infusionszubehoer " if prd_id==81800
replace produkt="Infi Tabacum" if prd_id==81894
replace produkt="Infi Thyreoidinum" if prd_id==81895
replace produkt="Infus" if prd_id==82004
replace produkt="Inhalationshilfe" if prd_id==82158
replace produkt="Instrumenten" if prd_id==82498
replace produkt="Inzolen infantibus" if prd_id==83087
replace produkt="ISMO" if prd_id==84177
replace produkt="Isovist (T01A)" if prd_id==84390
replace produkt="Jatrox HP Test" if prd_id==84587
replace produkt="Jonosteril (K01A3)" if prd_id==85046
replace produkt="Juniperus communis" if prd_id==85267
replace produkt="Kalium carb." if prd_id==85775
replace produkt="Kalium nitricum" if prd_id==86002
replace produkt="Kamille Oelbad Resana " if prd_id==86455
replace produkt="Katheter Set " if prd_id==87550
replace produkt="Kinder Em Eukal" if prd_id==88062
replace produkt="Kompensan" if prd_id==90249
replace produkt="Kremo Baerlauch" if prd_id==91695
replace produkt="Kytta Cor" if prd_id==92503
replace produkt="Lactopriv" if prd_id==93117
replace produkt="Lanitop" if prd_id==93496
replace produkt="Lanzor" if prd_id==93540
replace produkt="Larylin " if prd_id==93639
replace produkt="Lassel" if prd_id==93747
replace produkt="Levodopa comp." if prd_id==95731
replace produkt="Lonta Heilkraeuter" if prd_id==98795
replace produkt="Luecke Badekonzentrat" if prd_id==99070
replace produkt="Luma" if prd_id==99273
replace produkt="Lysmina Coll" if prd_id==99884
replace produkt="Magnesium sulfuricum" if prd_id==100683
replace produkt="Magnesiumorotat" if prd_id==100729
replace produkt="Magnevist" if prd_id==100765
replace produkt="Mapa" if prd_id==101748
replace produkt="Medisense MS. (W01X)" if prd_id==105735
replace produkt="Medisense Precision Plus E-M" if prd_id==105737
replace produkt="Medisense Precision Plus MS." if prd_id==105738
replace produkt="Medisense MS. (T02X9)" if prd_id==105746
replace produkt="Medisense Precision Plus PWT" if prd_id==105780
replace produkt="Medisense Sensor Elektrode BRA" if prd_id==105783
replace produkt="Medisense Precision Plus A+S" if prd_id==105795
replace produkt="Medisense Sensor Elektrode EUP" if prd_id==105796
replace produkt="Medisense Precision Plus MVT" if prd_id==105803
replace produkt="Mentopin " if prd_id==111716
replace produkt="Metifex" if prd_id==112909
replace produkt="Mibrox" if prd_id==113197
replace produkt="Mikruvid" if prd_id==113471
replace produkt="Minirin " if prd_id==113922
replace produkt="Mydriaticum Stulln" if prd_id==117219
replace produkt="Natriumhydrogencarbonat " if prd_id==119038
replace produkt="Neorecormon" if prd_id==119709
replace produkt="Neotri" if prd_id==119763
replace produkt="Neuranidal" if prd_id==120377
replace produkt="Neysplen" if prd_id==120799
replace produkt="Nisita" if prd_id==121334
replace produkt="Nobistrip " if prd_id==122280
replace produkt="Nona Präparate" if prd_id==122364
replace produkt="Norditropin" if prd_id==122464
replace produkt="Nortase" if prd_id==122669
replace produkt="Nuk Janosch" if prd_id==123543
replace produkt="Nuk Kunstst" if prd_id==123559
replace produkt="Nuk Pc" if prd_id==123574
replace produkt="Nuk Schr" if prd_id==123582
replace produkt="Nuk Ventilsaug" if prd_id==123612
replace produkt="Oenanthe Crocata" if prd_id==124457
replace produkt="Omnipaque" if prd_id==125705
replace produkt="Optipen " if prd_id==126303
replace produkt="Oralpaedon" if prd_id==126519
replace produkt="Otriven H" if prd_id==127406
replace produkt="Paisalen" if prd_id==127975
replace produkt="Palacos" if prd_id==127978
replace produkt="Paraffinum" if prd_id==128513
replace produkt="Parodontax" if prd_id==128887
replace produkt="Pepdul" if prd_id==129776
replace produkt="PH5 Eucerin" if prd_id==131426
replace produkt="Pix Liquida" if prd_id==133137
replace produkt="Precision Xtra" if prd_id==135419
replace produkt="Prednisolon Ferring" if prd_id==135451
replace produkt="Presselin " if prd_id==135645
replace produkt="Prothazin " if prd_id==136662
replace produkt="Rentibloc" if prd_id==140724
replace produkt="Rentylin" if prd_id==140728
replace produkt="Revitolan" if prd_id==141382
replace produkt="Rheum" if prd_id==141624
replace produkt="Ricola Menthol Eucalyptus" if prd_id==142412
replace produkt="Ricola Zitronenmelisse" if prd_id==142428
replace produkt="Rilutek" if prd_id==142460
replace produkt="Ringer Spuel" if prd_id==142571
replace produkt="Ringerloesung Fresenius (K05A9)" if prd_id==142581
replace produkt="Ringerloesung BME" if prd_id==142582
replace produkt="Ringerloesung BCP (K05A9)" if prd_id==142609
replace produkt="Rulid" if prd_id==146241
replace produkt="Salbulair 3MM " if prd_id==147150
replace produkt="Salvi Cal GX" if prd_id==147526
replace produkt="Sanasepton (D10A)" if prd_id==147812
replace produkt="Schlangengiftimmunserum" if prd_id==150094
replace produkt="Sedonium" if prd_id==151639
replace produkt="Semi Euglucon" if prd_id==152075
replace produkt="Servo SVP" if prd_id==152835
replace produkt="Sewo" if prd_id==152989
replace produkt="Siofor" if prd_id==154458
replace produkt="Softasept" if prd_id==155442
replace produkt="Solosin" if prd_id==155799
replace produkt="Solugastril" if prd_id==155823
replace produkt="Solutrast" if prd_id==155898
replace produkt="Sonicare" if prd_id==155993
replace produkt="Spagyrische Essenz " if prd_id==156283
replace produkt="Spasman" if prd_id==156370
replace produkt="Spasmex" if prd_id==156376
replace produkt="Spasuret" if prd_id==156420
replace produkt="Spender" if prd_id==156573
replace produkt="Sportupac " if prd_id==158053
replace produkt="Staphylex " if prd_id==161175
replace produkt="Steinberger Saft" if prd_id==161428
replace produkt="Sterofundin" if prd_id==161765
replace produkt="Strychninum Nitricum" if prd_id==163285
replace produkt="Sulfolitruw" if prd_id==163829
replace produkt="Sympathik " if prd_id==165887
replace produkt="Tarivid " if prd_id==167405
replace produkt="Tavanic " if prd_id==167512
replace produkt="Taxotere" if prd_id==167585
replace produkt="Teltonal" if prd_id==168153
replace produkt="Terpestrol Inhalat" if prd_id==168689
replace produkt="Tetagam" if prd_id==168833
replace produkt="Thym Uvocal" if prd_id==170133
replace produkt="Topisolon SAN " if prd_id==171568
replace produkt="Triquilar" if prd_id==173211
replace produkt="Udrik" if prd_id==174224
replace produkt="Ultraplex " if prd_id==174474
replace produkt="Ultravist" if prd_id==174639
replace produkt="Uralyt MAD" if prd_id==175430
replace produkt="Urion" if prd_id==176636
replace produkt="Viramune GER" if prd_id==184861
replace produkt="Weiche Zinkpaste C&L" if prd_id==187418
replace produkt="Wenenwohl" if prd_id==187936
replace produkt="Wind und Wetterbad" if prd_id==188406
replace produkt="Wofasteril" if prd_id==188622
replace produkt="Wolona" if prd_id==188662
replace produkt="Xylit Pfrimmer" if prd_id==189123
replace produkt="Visine Yxin" if prd_id==189681
replace produkt="Zentropil" if prd_id==190178
replace produkt="Zinacef" if prd_id==190305
replace produkt="Zovirax A+S" if prd_id==190880
replace produkt="Penisex" if prd_id==193831
replace produkt="Kamillentee" if prd_id==197070
replace produkt="Phoenix Homoeopathie (V03X5)" if prd_id==197912
replace produkt="Zeel Comp" if prd_id==198610
replace produkt="Sagittaproct" if prd_id==198998
replace produkt="Bio Line Comp" if prd_id==200079
replace produkt="Ulnor" if prd_id==203921
replace produkt="Glucose Baxter" if prd_id==204167
replace produkt="Tri S Zym" if prd_id==205181
replace produkt="Beta Turfa Gamma" if prd_id==206077
replace produkt="Glucomen Sensor B/M" if prd_id==206281
replace produkt="Macoperf Glucose" if prd_id==206396
replace produkt="Salmix" if prd_id==206621
replace produkt="Panax Ginseng" if prd_id==207230
replace produkt="Grippe Impfstoff Chiron" if prd_id==207747
replace produkt="Glucosteril (K01B3)" if prd_id==216344
replace produkt="Jonosteril (K01A1)" if prd_id==216370
replace produkt="Dolviran" if prd_id==218862
replace produkt="After 10 " if prd_id==219402
replace produkt="Alupent" if prd_id==219414
replace produkt="Aqua ad injectabilia Lichtenstein" if prd_id==219443
replace produkt="Cefaktivon" if prd_id==219509
replace produkt="Isovist (T01X)" if prd_id==219657
replace produkt="Presinol" if prd_id==219759
replace produkt="Hexoral" if prd_id==220331
replace produkt="Klosterfrau Aktiv " if prd_id==231332
replace produkt="Prothrombinkomplex" if prd_id==239917
replace produkt="Septocoll" if prd_id==241180
replace produkt="Truw Composita " if prd_id==244737
replace produkt="Carisano" if prd_id==246744
replace produkt="Haes Steril" if prd_id==251197
replace produkt="Aluminium" if prd_id==254966
replace produkt="Antimonium crudum " if prd_id==255008
replace produkt="Barium carbonicum " if prd_id==255098
replace produkt="Berberis vulgaris " if prd_id==255154
replace produkt="Cimicifuga racemosa " if prd_id==255314
replace produkt="Conium maculatum " if prd_id==255346
replace produkt="Cyclamen europaeum" if prd_id==255404
replace produkt="Digitalis purpurea " if prd_id==255427
replace produkt="Ferrum phosphoricum GJS" if prd_id==255529
replace produkt="Hamamelis virginiana" if prd_id==255614
replace produkt="Kalmia latifolia " if prd_id==255770
replace produkt="Plumbum metallicum" if prd_id==256164
replace produkt="Viburnum opulus " if prd_id==256951
replace produkt="Glucosteril (K01C3)" if prd_id==258369
replace produkt="Phoenix Homoeopathie (V03X1)" if prd_id==258549
replace produkt="Fenistil " if prd_id==259117
replace produkt="Kardiaca Herztropfen" if prd_id==259365
replace produkt="Osteobolan" if prd_id==259624
replace produkt="Wurzelsepp Zinnkraut " if prd_id==259998
replace produkt="Zyplast Collagen Implant" if prd_id==260015
replace produkt="Palatol " if prd_id==260038
replace produkt="Helicobacter pylori Test" if prd_id==282400
replace produkt="Olynth" if prd_id==286069
replace produkt="PSA Test" if prd_id==286176
replace produkt="Klacid" if prd_id==287663
replace produkt="Sagittaproct S" if prd_id==290433
replace produkt="Buscopan" if prd_id==294192
replace produkt="Myoglobin Test" if prd_id==294860
replace produkt="Acyclovir Denk" if prd_id==297585
replace produkt="Drogentest Multi" if prd_id==301942
replace produkt="Viaflex Glucose BCP" if prd_id==302217
replace produkt="Gastroloc" if prd_id==304781
replace produkt="Surgicoll" if prd_id==311542
replace produkt="Viaflex Glucose DLT" if prd_id==314116
replace produkt="Vitamin C Performax" if prd_id==315236
replace produkt="Milgamma" if prd_id==317810
replace produkt="Glycin Spuel" if prd_id==324747
replace produkt="Spilan" if prd_id==332127
replace produkt="Hepar ASN" if prd_id==332987
replace produkt="Synocrom" if prd_id==341272
replace produkt="Neynerin" if prd_id==347075
replace produkt="Stannum metallicum " if prd_id==350356
replace produkt="Kalium arsenicosum " if prd_id==352010
replace produkt="Acetylcystein Basics" if prd_id==354937
replace produkt="Ginkgo Syxyl" if prd_id==354966
replace produkt="Gumbix" if prd_id==354969
replace produkt="ILA Med" if prd_id==354970
replace produkt="Sanasepton (J01F)" if prd_id==354990
replace produkt="Amagesan" if prd_id==355003
replace produkt="Ampuwa (K04D)" if prd_id==355004
replace produkt="Antra" if prd_id==355005
replace produkt="Cholosan" if prd_id==355011
replace produkt="Emla" if prd_id==355017
replace produkt="Granocyte" if prd_id==355022
replace produkt="Ketosteril" if prd_id==355026
replace produkt="Sotalol Basics" if prd_id==355055
replace produkt="Epidropal" if prd_id==355087
replace produkt="Mangan" if prd_id==355095
replace produkt="Sedotussin" if prd_id==355116
replace produkt="Elohaest" if prd_id==355146
replace produkt="Enzynorm" if prd_id==355147
replace produkt="Gallosyx" if prd_id==355158
replace produkt="Ampuwa (K01B4)" if prd_id==355195
replace produkt="Marly Skin" if prd_id==355228
replace produkt="Methiotrans" if prd_id==355230
replace produkt="Plasmasteril" if prd_id==355238
replace produkt="Ringerloesung Fresenius (K01A7)" if prd_id==355244
replace produkt="Rovamycine" if prd_id==355246
replace produkt="Aminosteril (K01E4)" if prd_id==355261
replace produkt="Bespar" if prd_id==355264
replace produkt="Diclofenac PB" if prd_id==355273
replace produkt="Erythro Hefa" if prd_id==355276
replace produkt="Jonosteril (K01A2)" if prd_id==355289
replace produkt="Prostaneurin" if prd_id==355308
replace produkt="Sensodyne SB6" if prd_id==355313
replace produkt="Trama Dorsch" if prd_id==355317
replace produkt="Zorac" if prd_id==355331
replace produkt="Doxorubicin Hexal" if prd_id==355351
replace produkt="Metoclopramid PB" if prd_id==355376
replace produkt="Aminosteril (K01E1)" if prd_id==355406
replace produkt="Doxy " if prd_id==355424
replace produkt="Glucosteril (K01C1)" if prd_id==355440
replace produkt="Purisole" if prd_id==355461
replace produkt="Risinetten" if prd_id==355466
replace produkt="Sigamucil" if prd_id==355471
replace produkt="Trigastril" if prd_id==355476
replace produkt="Doloject" if prd_id==355492
replace produkt="Dopamin Fresenius" if prd_id==355493
replace produkt="Fibraflex (M02A)" if prd_id==355498
replace produkt="Jonosteril (K01A4)" if prd_id==355507
replace produkt="Acetyst" if prd_id==355537
replace produkt="Frenopect" if prd_id==355563
replace produkt="Jonosteril (K01A5)" if prd_id==355569
replace produkt="Respi Jet" if prd_id==355582
replace produkt="Rubicolan" if prd_id==355583
replace produkt="Teveten " if prd_id==355639
replace produkt="Wydora" if prd_id==355647
replace produkt="Neyathos" if prd_id==358582
replace produkt="Cosmoderma Basis" if prd_id==363066
replace produkt="Sonotemp" if prd_id==395385
replace produkt="Medisense Precision Xtra AT/" if prd_id==403447
replace produkt="Chininum arsenicosum " if prd_id==412564
replace produkt="Fentanyl Hexal " if prd_id==413306
replace produkt="Adrenalinum" if prd_id==428298
replace produkt="Spongostan" if prd_id==432669
replace produkt="Dermabond" if prd_id==432753
replace produkt="Ammonium carbonicum" if prd_id==452511
replace produkt="Scrophularia nodosa" if prd_id==454070
replace produkt="Bisolvon" if prd_id==500922
replace produkt="Bupivacain " if prd_id==501023
replace produkt="Meaverin (N01B1)" if prd_id==501031
replace produkt="Meaverin (N01B3)" if prd_id==501065
replace produkt="Meaverin (N01B2)" if prd_id==501066
replace produkt="L Thyroxin Henning " if prd_id==501231
replace produkt="Colo Pleon " if prd_id==501245

replace produkt_pi="Kraeuteroel" if prdo_id==1011
replace produkt_pi="Accutrend Sensor *" if prdo_id==2701
replace produkt_pi="Acesal" if prdo_id==2819
replace produkt_pi="Acidum carbolicum" if prdo_id==3197
replace produkt_pi="Acidum Hydrofluor" if prdo_id==3395
replace produkt_pi="Acidum Lactic." if prdo_id==3432
replace produkt_pi="Acid.Phosphor." if prdo_id==3554
replace produkt_pi="Acidum phosphoricum SFP" if prdo_id==3575
replace produkt_pi="Actovegin " if prdo_id==4051
replace produkt_pi="Complex Praeparate " if prdo_id==4371
replace produkt_pi="Adriblastin *" if prdo_id==4443
replace produkt_pi="Akineton *" if prdo_id==5502
replace produkt_pi="Aleima" if prdo_id==6085
replace produkt_pi="Aletris" if prdo_id==6321
replace produkt_pi="Alovisa" if prdo_id==7428
replace produkt_pi="Alveofact" if prdo_id==7941
replace produkt_pi="Amoxihexal *" if prdo_id==8760
replace produkt_pi="Ampuwa (K05A1)" if prdo_id==8845
replace produkt_pi="Anco" if prdo_id==9170
replace produkt_pi="Antodox" if prdo_id==10332
replace produkt_pi="Apocynum " if prdo_id==11088
replace produkt_pi="Arelix ACE *" if prdo_id==12016
replace produkt_pi="Aristochol" if prdo_id==12298
replace produkt_pi="Arthrex SZP" if prdo_id==13358
replace produkt_pi="Arthrex 1AP" if prdo_id==13362
replace produkt_pi="Arubendol" if prdo_id==13724
replace produkt_pi="Asche Basis" if prdo_id==13930
replace produkt_pi="Aspirin protect *" if prdo_id==14388
replace produkt_pi="ASS Hexal" if prdo_id==14437
replace produkt_pi="ASS CT " if prdo_id==14439
replace produkt_pi="ASS Stada" if prdo_id==14465
replace produkt_pi="Atemur" if prdo_id==15067
replace produkt_pi="Axe Duschgel" if prdo_id==16156
replace produkt_pi="Bad Heilbrunner Melisse" if prdo_id==16739
replace produkt_pi="Batrafen *" if prdo_id==17996
replace produkt_pi="Benalapril" if prdo_id==20492
replace produkt_pi="Bendigon" if prdo_id==20509
replace produkt_pi="Berotec *" if prdo_id==21025
replace produkt_pi="Beta Acetyldigoxin" if prdo_id==21190
replace produkt_pi="Billy Boy" if prdo_id==22082
replace produkt_pi="Biochemie 1 PFG" if prdo_id==22354
replace produkt_pi="Biochemie 10 PFG" if prdo_id==22366
replace produkt_pi="Biochemie 11 PFG" if prdo_id==22378
replace produkt_pi="Biochemie 15 PFG" if prdo_id==22417
replace produkt_pi="Biochemie 3 PFG" if prdo_id==22496
replace produkt_pi="Biochemie 5 PFG" if prdo_id==22521
replace produkt_pi="Biochemie 6 PFG" if prdo_id==22533
replace produkt_pi="Biochemie 7 PFG" if prdo_id==22545
replace produkt_pi="Biochemie 9 PFG" if prdo_id==22569
replace produkt_pi="Bisolvon Linctus *" if prdo_id==23846
replace produkt_pi="Bisolvonat" if prdo_id==23849
replace produkt_pi="Blemaren" if prdo_id==24057
replace produkt_pi="Bm Test " if prdo_id==24416
replace produkt_pi="Bondronat *" if prdo_id==24642
replace produkt_pi="Borgon " if prdo_id==24785
replace produkt_pi="Borretsch Oel" if prdo_id==24834
replace produkt_pi="Brassica" if prdo_id==26438
replace produkt_pi="Bricanyl ASZ *" if prdo_id==26591
replace produkt_pi="Bricanyl comp. *" if prdo_id==26600
replace produkt_pi="Buscopan plus *" if prdo_id==27890
replace produkt_pi="Butler Gum" if prdo_id==27914
replace produkt_pi="Calcipot" if prdo_id==28508
replace produkt_pi="Calcium Sandoz *" if prdo_id==29038
replace produkt_pi="Calycast Injektopas" if prdo_id==29420
replace produkt_pi="Campral *" if prdo_id==29606
replace produkt_pi="Cardular *" if prdo_id==30672
replace produkt_pi="Ceporexin *" if prdo_id==32135
replace produkt_pi="Cholo Injektopas" if prdo_id==33909
replace produkt_pi="Cimicifuga comp" if prdo_id==34546
replace produkt_pi="Cisplatin" if prdo_id==34872
replace produkt_pi="Citrusfasertabletten" if prdo_id==35001
replace produkt_pi="Claire Fisher" if prdo_id==35073
replace produkt_pi="Clearblue WIC *" if prdo_id==35330
replace produkt_pi="Colchicum Dispert" if prdo_id==36298
replace produkt_pi="Collomack" if prdo_id==36511
replace produkt_pi="Commenfrey" if prdo_id==38502
replace produkt_pi="Contimit" if prdo_id==40138
replace produkt_pi="Convallaria Majal" if prdo_id==40213
replace produkt_pi="Crataegus Syxyl" if prdo_id==41864
replace produkt_pi="Crinone *" if prdo_id==42019
replace produkt_pi="Dansac Soft *" if prdo_id==44069
replace produkt_pi="Decoderm comp. *" if prdo_id==44788
replace produkt_pi="Decoderm *" if prdo_id==44790
replace produkt_pi="Delmuno *" if prdo_id==44973
replace produkt_pi="Denan" if prdo_id==45172
replace produkt_pi="Depuran" if prdo_id==45414
replace produkt_pi="Descofix" if prdo_id==45682
replace produkt_pi="Det Ms" if prdo_id==45744
replace produkt_pi="Detartrine" if prdo_id==45747
replace produkt_pi="Dexa Rhinospray *" if prdo_id==45859
replace produkt_pi="Dibenzyran *" if prdo_id==46294
replace produkt_pi="Dignodolin" if prdo_id==46696
replace produkt_pi="Dipiperon *" if prdo_id==47067
replace produkt_pi="Dolormin" if prdo_id==47754
replace produkt_pi="Dopergin *" if prdo_id==47854
replace produkt_pi="Doxorubicin" if prdo_id==48066
replace produkt_pi="DR Aloe" if prdo_id==48164
replace produkt_pi="Diclofenac Dura" if prdo_id==49737
replace produkt_pi="Durex Kondome" if prdo_id==49768
replace produkt_pi="Dysurgal " if prdo_id==50260
replace produkt_pi="Effortil *" if prdo_id==51492
replace produkt_pi="Elanosol" if prdo_id==52385
replace produkt_pi="Elantan *" if prdo_id==52387
replace produkt_pi="Eleutherococcus" if prdo_id==55311
replace produkt_pi="Ems Salin" if prdo_id==55806
replace produkt_pi="Encepur *" if prdo_id==55894
replace produkt_pi="Engerix *" if prdo_id==56028
replace produkt_pi="Epogam *" if prdo_id==56449
replace produkt_pi="Eufusol" if prdo_id==57875
replace produkt_pi="Excitans" if prdo_id==58644
replace produkt_pi="Exneural" if prdo_id==58682
replace produkt_pi="Fango Rubriment" if prdo_id==59558
replace produkt_pi="Fibraflex  (N02B2)" if prdo_id==60828
replace produkt_pi="Fibraflex  (M01A1)" if prdo_id==60829
replace produkt_pi="Finalgon " if prdo_id==61157
replace produkt_pi="First Test HCG " if prdo_id==61503
replace produkt_pi="Fissan Baby Pflege" if prdo_id==61538
replace produkt_pi="Flexurat" if prdo_id==62020
replace produkt_pi="Fluimucil *" if prdo_id==62707
replace produkt_pi="Fragmin *" if prdo_id==63500
replace produkt_pi="Fraxiparin *" if prdo_id==63613
replace produkt_pi="Fromms FF" if prdo_id==63876
replace produkt_pi="Fumaderm" if prdo_id==64366
replace produkt_pi="Gabitril *" if prdo_id==64707
replace produkt_pi="Gastrografin" if prdo_id==65102
replace produkt_pi="Gelatine Toepfer" if prdo_id==65596
replace produkt_pi="Gencin" if prdo_id==65953
replace produkt_pi="Gilurytmal" if prdo_id==67688
replace produkt_pi="Glandol Borretsch Oel" if prdo_id==68099
replace produkt_pi="Glaucotat *" if prdo_id==68330
replace produkt_pi="Glimidstada" if prdo_id==68389
replace produkt_pi="Globocef *" if prdo_id==68438
replace produkt_pi="Glucofilm *" if prdo_id==68573
replace produkt_pi="Glucostix *" if prdo_id==68803
replace produkt_pi="Gluketur *" if prdo_id==68830
replace produkt_pi="Gonal *" if prdo_id==69092
replace produkt_pi="Grindelia Robusta" if prdo_id==69763
replace produkt_pi="Grippostad (R05A)" if prdo_id==69804
replace produkt_pi="Grippostad (N02B2)" if prdo_id==69806
replace produkt_pi="Guarana GNW" if prdo_id==70014
replace produkt_pi="Gutron *" if prdo_id==70275
replace produkt_pi="Haemoccult BCG" if prdo_id==70674
replace produkt_pi="Hamamelis Komplex" if prdo_id==71282
replace produkt_pi="Hametum *" if prdo_id==71349
replace produkt_pi="Hestia" if prdo_id==75134
replace produkt_pi="Hexoraletten" if prdo_id==75490
replace produkt_pi="Hyalofill *" if prdo_id==79458
replace produkt_pi="Hycamtin *" if prdo_id==79473
replace produkt_pi="Ilomedin *" if prdo_id==81285
replace produkt_pi="Imeron" if prdo_id==81349
replace produkt_pi="Imodium *" if prdo_id==81427
replace produkt_pi="Infusionszubehoer " if prdo_id==81800
replace produkt_pi="Infi Tabacum" if prdo_id==81894
replace produkt_pi="Infi Thyreoidinum" if prdo_id==81895
replace produkt_pi="Infus" if prdo_id==82004
replace produkt_pi="Inhalationshilfe " if prdo_id==82158
replace produkt_pi="Instrumenten " if prdo_id==82498
replace produkt_pi="Inzolen infantibus" if prdo_id==83087
replace produkt_pi="Iruxol *" if prdo_id==83434
replace produkt_pi="ISMO *" if prdo_id==84177
replace produkt_pi="Isovist (T01A)" if prdo_id==84390
replace produkt_pi="Jatrox HP Test *" if prdo_id==84587
replace produkt_pi="Jonosteril (K01A3)" if prdo_id==85046
replace produkt_pi="Juniperus communis" if prdo_id==85267
replace produkt_pi="Kalium carb." if prdo_id==85775
replace produkt_pi="Kalium nitricum" if prdo_id==86002
replace produkt_pi="Kamille Oelbad Resana GGY" if prdo_id==86455
replace produkt_pi="Katheter Set " if prdo_id==87550
replace produkt_pi="Keto Diabur *" if prdo_id==87877
replace produkt_pi="Kinder Em Eukal (W01F2)" if prdo_id==88062
replace produkt_pi="Kompensan *" if prdo_id==90249
replace produkt_pi="Kremo Baerlauch" if prdo_id==91695
replace produkt_pi="Kytta Cor" if prdo_id==92503
replace produkt_pi="Lactopriv" if prdo_id==93117
replace produkt_pi="Lanitop *" if prdo_id==93496
replace produkt_pi="Lanzor *" if prdo_id==93540
replace produkt_pi="Larylin " if prdo_id==93639
replace produkt_pi="Lassel" if prdo_id==93747
replace produkt_pi="Lentaron *" if prdo_id==95397
replace produkt_pi="Leponex *" if prdo_id==95424
replace produkt_pi="Leustatin *" if prdo_id==95647
replace produkt_pi="Levodopa comp." if prdo_id==95731
replace produkt_pi="Linola Fett *" if prdo_id==96372
replace produkt_pi="Locabiosol *" if prdo_id==98354
replace produkt_pi="Lonta Heilkraeuter" if prdo_id==98795
replace produkt_pi="Luecke Badekonzentrat" if prdo_id==99070
replace produkt_pi="Luma" if prdo_id==99273
replace produkt_pi="Lysmina Coll" if prdo_id==99884
replace produkt_pi="Magnesium sulfuricum" if prdo_id==100683
replace produkt_pi="Magnesiumorotat" if prdo_id==100729
replace produkt_pi="Magnevist *" if prdo_id==100765
replace produkt_pi="Mapa" if prdo_id==101748
replace produkt_pi="Medisense MS. (W01X)" if prdo_id==105735
replace produkt_pi="Medisense Precision Plus MS. *" if prdo_id==105738
replace produkt_pi="Medisense MS. (T02X9)" if prdo_id==105746
replace produkt_pi="Mentopin " if prdo_id==111716
replace produkt_pi="Methotrexat Lederle *" if prdo_id==112829
replace produkt_pi="Metifex" if prdo_id==112909
replace produkt_pi="Mibrox" if prdo_id==113197
replace produkt_pi="Microklist *" if prdo_id==113307
replace produkt_pi="Mikruvid" if prdo_id==113471
replace produkt_pi="Minirin" if prdo_id==113922
replace produkt_pi="Multihance *" if prdo_id==116659
replace produkt_pi="Multistix *" if prdo_id==116719
replace produkt_pi="Mydriaticum Stulln" if prdo_id==117219
replace produkt_pi="Natriumhydrogencarbonat" if prdo_id==119038
replace produkt_pi="Neorecormon *" if prdo_id==119709
replace produkt_pi="Neotri" if prdo_id==119763
replace produkt_pi="Neuranidal" if prdo_id==120377
replace produkt_pi="Neysplen" if prdo_id==120799
replace produkt_pi="Nicorette TAY" if prdo_id==120924
replace produkt_pi="Nisita" if prdo_id==121334
replace produkt_pi="Nobistrip " if prdo_id==122280
replace produkt_pi="Nona Präparate" if prdo_id==122364
replace produkt_pi="Norditropin" if prdo_id==122464
replace produkt_pi="Nortase" if prdo_id==122669
replace produkt_pi="Novalgin *" if prdo_id==123294
replace produkt_pi="Nuk Janosch" if prdo_id==123543
replace produkt_pi="Nuk Kunstst" if prdo_id==123559
replace produkt_pi="Nuk Pc" if prdo_id==123574
replace produkt_pi="Nuk Schr" if prdo_id==123582
replace produkt_pi="Nuk Ventilsaug" if prdo_id==123612
replace produkt_pi="Oenanthe Crocata" if prdo_id==124457
replace produkt_pi="Omnipaque *" if prdo_id==125705
replace produkt_pi="Lifescan onetouch *" if prdo_id==125844
replace produkt_pi="Optipen " if prdo_id==126303
replace produkt_pi="Oralpaedon" if prdo_id==126519
replace produkt_pi="Otriven H" if prdo_id==127406
replace produkt_pi="Paisalen" if prdo_id==127975
replace produkt_pi="Palacos" if prdo_id==127978
replace produkt_pi="Paraffinum" if prdo_id==128513
replace produkt_pi="Parodontax" if prdo_id==128887
replace produkt_pi="Pepdul" if prdo_id==129776
replace produkt_pi="Persantin *" if prdo_id==130166
replace produkt_pi="PH5 Eucerin" if prdo_id==131426
replace produkt_pi="Pix Liquida" if prdo_id==133137
replace produkt_pi="Precision Xtra" if prdo_id==135419
replace produkt_pi="Prednisolon Ferring" if prdo_id==135451
replace produkt_pi="Pregnesin *" if prdo_id==135555
replace produkt_pi="Presinol BAY *" if prdo_id==135613
replace produkt_pi="Presselin " if prdo_id==135645
replace produkt_pi="Primolut Nor *" if prdo_id==135848
replace produkt_pi="Progynova *" if prdo_id==136144
replace produkt_pi="Proluton *" if prdo_id==136159
replace produkt_pi="Prothazin " if prdo_id==136662
replace produkt_pi="Rentibloc" if prdo_id==140724
replace produkt_pi="Rentylin" if prdo_id==140728
replace produkt_pi="Revitolan" if prdo_id==141382
replace produkt_pi="Rheum" if prdo_id==141624
replace produkt_pi="Ricola Menthol Eucalyptus" if prdo_id==142412
replace produkt_pi="Ricola Zitronenmelisse" if prdo_id==142428
replace produkt_pi="Rilutek *" if prdo_id==142460
replace produkt_pi="Ringer Spuel" if prdo_id==142571
replace produkt_pi="Ringerloesung Fresenius (K05A9)" if prdo_id==142581
replace produkt_pi="Ringerloesung BME" if prdo_id==142582
replace produkt_pi="Ringerloesung BCP (K05A9)" if prdo_id==142609
replace produkt_pi="Rulid *" if prdo_id==146241
replace produkt_pi="Saizen *" if prdo_id==147054
replace produkt_pi="Salbulair 3MM " if prdo_id==147150
replace produkt_pi="Salvi Cal GX" if prdo_id==147526
replace produkt_pi="Sanasepton (D10A)" if prdo_id==147812
replace produkt_pi="Sandoglobulin *" if prdo_id==148036
replace produkt_pi="Schlangengiftimmunserum" if prdo_id==150094
replace produkt_pi="Sedonium" if prdo_id==151639
replace produkt_pi="Semi Euglucon" if prdo_id==152075
replace produkt_pi="Servo SVP" if prdo_id==152835
replace produkt_pi="Sewo" if prdo_id==152989
replace produkt_pi="Siofor" if prdo_id==154458
replace produkt_pi="Softasept" if prdo_id==155442
replace produkt_pi="Solosin " if prdo_id==155799
replace produkt_pi="Solugastril *" if prdo_id==155823
replace produkt_pi="Solutrast" if prdo_id==155898
replace produkt_pi="Soluvit *" if prdo_id==155908
replace produkt_pi="Sonicare" if prdo_id==155993
replace produkt_pi="Spagyrische Essenz " if prdo_id==156283
replace produkt_pi="Spasman" if prdo_id==156370
replace produkt_pi="Spasmex" if prdo_id==156376
replace produkt_pi="Spasuret" if prdo_id==156420
replace produkt_pi="Spender" if prdo_id==156573
replace produkt_pi="Sportupac " if prdo_id==158053
replace produkt_pi="Staphylex AL/" if prdo_id==161175
replace produkt_pi="Steinberger Saft" if prdo_id==161428
replace produkt_pi="Sterofundin " if prdo_id==161765
replace produkt_pi="Strychninum Nitricum" if prdo_id==163285
replace produkt_pi="Sulfolitruw" if prdo_id==163829
replace produkt_pi="Sympathik " if prdo_id==165887
replace produkt_pi="Tagamet *" if prdo_id==166658
replace produkt_pi="Tarivid *" if prdo_id==167405
replace produkt_pi="Tasmar *" if prdo_id==167474
replace produkt_pi="Tavanic *" if prdo_id==167512
replace produkt_pi="Taxotere *" if prdo_id==167585
replace produkt_pi="Teldane *" if prdo_id==168071
replace produkt_pi="Teltonal" if prdo_id==168153
replace produkt_pi="Terpestrol Inhalat" if prdo_id==168689
replace produkt_pi="Tetagam" if prdo_id==168833
replace produkt_pi="Thym Uvocal" if prdo_id==170133
replace produkt_pi="Topisolon *" if prdo_id==171568
replace produkt_pi="Torrat *" if prdo_id==171758
replace produkt_pi="Trigoa *" if prdo_id==172984
replace produkt_pi="Triquilar *" if prdo_id==173211
replace produkt_pi="Udrik" if prdo_id==174224
replace produkt_pi="Ultraplex" if prdo_id==174474
replace produkt_pi="Ultravist *" if prdo_id==174639
replace produkt_pi="Uralyt MAD *" if prdo_id==175430
replace produkt_pi="Urion *" if prdo_id==176636
replace produkt_pi="Weiche Zinkpaste C&L" if prdo_id==187418
replace produkt_pi="Wenenwohl" if prdo_id==187936
replace produkt_pi="Wind und Wetterbad" if prdo_id==188406
replace produkt_pi="Wofasteril " if prdo_id==188622
replace produkt_pi="Wolona" if prdo_id==188662
replace produkt_pi="Xylit Pfrimmer" if prdo_id==189123
replace produkt_pi="Yermonil *" if prdo_id==189349
replace produkt_pi="Visine Yxin" if prdo_id==189681
replace produkt_pi="Zentropil" if prdo_id==190178
replace produkt_pi="Zinacef" if prdo_id==190305
replace produkt_pi="Zovirax GSK *" if prdo_id==190885
replace produkt_pi="Penisex" if prdo_id==193831
replace produkt_pi="Kamillentee" if prdo_id==197070
replace produkt_pi="Phoenix Homoeopathie (V03X5)" if prdo_id==197912
replace produkt_pi="Zeel Comp" if prdo_id==198610
replace produkt_pi="Sagittaproct" if prdo_id==198998
replace produkt_pi="Bio Line Comp" if prdo_id==200079
replace produkt_pi="Ulnor" if prdo_id==203921
replace produkt_pi="Glucose Baxter" if prdo_id==204167
replace produkt_pi="Refacto *" if prdo_id==204403
replace produkt_pi="Tri S Zym" if prdo_id==205181
replace produkt_pi="Beta Turfa Gamma" if prdo_id==206077
replace produkt_pi="Glucomen Sensor B/M *" if prdo_id==206281
replace produkt_pi="Macoperf Glucose" if prdo_id==206396
replace produkt_pi="Salmix" if prdo_id==206621
replace produkt_pi="Panax Ginseng" if prdo_id==207230
replace produkt_pi="Grippe Impfstoff Chiron" if prdo_id==207747
replace produkt_pi="Amoclav *" if prdo_id==214843
replace produkt_pi="Glucosteril (K01B3)" if prdo_id==216344
replace produkt_pi="Jonosteril (K01A1)" if prdo_id==216370
replace produkt_pi="Dolviran" if prdo_id==218862
replace produkt_pi="After 10 " if prdo_id==219402
replace produkt_pi="Alupent *" if prdo_id==219414
replace produkt_pi="Aqua ad injectabilia Lichtenstein" if prdo_id==219443
replace produkt_pi="Cefaktivon" if prdo_id==219509
replace produkt_pi="Combur 4 Test *" if prdo_id==219523
replace produkt_pi="Isovist (T01X)" if prdo_id==219657
replace produkt_pi="Presinol *" if prdo_id==219759
replace produkt_pi="Hexoral *" if prdo_id==220331
replace produkt_pi="Klosterfrau Aktiv " if prdo_id==231332
replace produkt_pi="Prothrombinkomplex" if prdo_id==239917
replace produkt_pi="Septocoll" if prdo_id==241180
replace produkt_pi="Suplasyn *" if prdo_id==241250
replace produkt_pi="Combur 5 Test *" if prdo_id==243698
replace produkt_pi="Kogenate Bayer *" if prdo_id==244227
replace produkt_pi="Truw Composita " if prdo_id==244737
replace produkt_pi="Bocatriol *" if prdo_id==245514
replace produkt_pi="Disoprivan *" if prdo_id==245597
replace produkt_pi="Herceptin *" if prdo_id==245716
replace produkt_pi="Carisano" if prdo_id==246744
replace produkt_pi="Drogentest GBM *" if prdo_id==248054
replace produkt_pi="Haes Steril" if prdo_id==251197
replace produkt_pi="Aluminium" if prdo_id==254966
replace produkt_pi="Antimonium crudum" if prdo_id==255008
replace produkt_pi="Barium carbonicum " if prdo_id==255098
replace produkt_pi="Berberis vulgaris " if prdo_id==255154
replace produkt_pi="Cimicifuga racemosa " if prdo_id==255314
replace produkt_pi="Conium maculatum" if prdo_id==255346
replace produkt_pi="Cyclamen europaeum " if prdo_id==255404
replace produkt_pi="Digitalis purpurea " if prdo_id==255427
replace produkt_pi="Ferrum phosphoricum" if prdo_id==255529
replace produkt_pi="Hamamelis virginiana " if prdo_id==255614
replace produkt_pi="Kalmia latifolia " if prdo_id==255770
replace produkt_pi="Plumbum metallicum " if prdo_id==256164
replace produkt_pi="Viburnum opulus" if prdo_id==256951
replace produkt_pi="Glucosteril (K01C3)" if prdo_id==258369
replace produkt_pi="Phoenix Homoeopathie (V03X1)" if prdo_id==258549
replace produkt_pi="Fenistil " if prdo_id==259117
replace produkt_pi="Kamillosan *" if prdo_id==259364
replace produkt_pi="Kardiaca Herztropfen" if prdo_id==259365
replace produkt_pi="Metalyse *" if prdo_id==259489
replace produkt_pi="Osteobolan" if prdo_id==259624
replace produkt_pi="Wurzelsepp Zinnkraut" if prdo_id==259998
replace produkt_pi="Zyplast Collagen Implant" if prdo_id==260015
replace produkt_pi="Palatol " if prdo_id==260038
replace produkt_pi="Starlix *" if prdo_id==262268
replace produkt_pi="Helicobacter pylori Test" if prdo_id==282400
replace produkt_pi="Olynth" if prdo_id==286069
replace produkt_pi="PSA Test" if prdo_id==286176
replace produkt_pi="Klacid *" if prdo_id==287663
replace produkt_pi="Vorina *" if prdo_id==288075
replace produkt_pi="Sagittaproct S" if prdo_id==290433
replace produkt_pi="Buscopan *" if prdo_id==294192
replace produkt_pi="Myoglobin Test" if prdo_id==294860
replace produkt_pi="Tracleer *" if prdo_id==297491
replace produkt_pi="Acyclovir Denk" if prdo_id==297585
replace produkt_pi="Lorzaar Plus *" if prdo_id==301602
replace produkt_pi="Drogentest Multi" if prdo_id==301942
replace produkt_pi="Viaflex Glucose BCP" if prdo_id==302217
replace produkt_pi="Gastroloc" if prdo_id==304781
replace produkt_pi="Surgicoll" if prdo_id==311542
replace produkt_pi="Viaflex Glucose DLT" if prdo_id==314116
replace produkt_pi="Vitamin C Performax" if prdo_id==315236
replace produkt_pi="Omacor *" if prdo_id==315688
replace produkt_pi="Milgamma" if prdo_id==317810
replace produkt_pi="Glycin Spuel" if prdo_id==324747
replace produkt_pi="Fuzeon *" if prdo_id==325337
replace produkt_pi="Spilan" if prdo_id==332127
replace produkt_pi="Hepar ASN" if prdo_id==332987
replace produkt_pi="Synocrom" if prdo_id==341272
replace produkt_pi="Neynerin" if prdo_id==347075
replace produkt_pi="Stannum metallicum " if prdo_id==350356
replace produkt_pi="Kalium arsenicosum " if prdo_id==352010
replace produkt_pi="Acetylcystein Basics" if prdo_id==354937
replace produkt_pi="Ginkgo Syxyl" if prdo_id==354966
replace produkt_pi="Gumbix" if prdo_id==354969
replace produkt_pi="ILA Med" if prdo_id==354970
replace produkt_pi="Oxysept ALL *" if prdo_id==354980
replace produkt_pi="Sanasepton (J01F)" if prdo_id==354990
replace produkt_pi="Amagesan" if prdo_id==355003
replace produkt_pi="Ampuwa (K04D)" if prdo_id==355004
replace produkt_pi="Antra" if prdo_id==355005
replace produkt_pi="Cholosan" if prdo_id==355011
replace produkt_pi="Emla" if prdo_id==355017
replace produkt_pi="Granocyte *" if prdo_id==355022
replace produkt_pi="Ketosteril" if prdo_id==355026
replace produkt_pi="Sotalol Basics" if prdo_id==355055
replace produkt_pi="Epidropal" if prdo_id==355087
replace produkt_pi="Mangan" if prdo_id==355095
replace produkt_pi="Sedotussin" if prdo_id==355116
replace produkt_pi="Elohaest" if prdo_id==355146
replace produkt_pi="Enzynorm *" if prdo_id==355147
replace produkt_pi="Gallosyx" if prdo_id==355158
replace produkt_pi="Ampuwa (K01B4)" if prdo_id==355195
replace produkt_pi="Marly Skin" if prdo_id==355228
replace produkt_pi="Methiotrans" if prdo_id==355230
replace produkt_pi="Plasmasteril" if prdo_id==355238
replace produkt_pi="Ringerloesung Fresenius (K01A7)" if prdo_id==355244
replace produkt_pi="Rovamycine" if prdo_id==355246
replace produkt_pi="Aminosteril (K01E4)" if prdo_id==355261
replace produkt_pi="Bespar *" if prdo_id==355264
replace produkt_pi="Diclofenac PB" if prdo_id==355273
replace produkt_pi="Erythro Hefa" if prdo_id==355276
replace produkt_pi="Jonosteril (K01A2)" if prdo_id==355289
replace produkt_pi="Prostaneurin" if prdo_id==355308
replace produkt_pi="Sensodyne SB6" if prdo_id==355313
replace produkt_pi="Trama Dorsch" if prdo_id==355317
replace produkt_pi="Zorac *" if prdo_id==355331
replace produkt_pi="Doxorubicin Hexal" if prdo_id==355351
replace produkt_pi="Metoclopramid PB" if prdo_id==355376
replace produkt_pi="Aminosteril (K01E1)" if prdo_id==355406
replace produkt_pi="Doxy HP" if prdo_id==355424
replace produkt_pi="Glucosteril (K01C1)" if prdo_id==355440
replace produkt_pi="Purisole" if prdo_id==355461
replace produkt_pi="Risinetten" if prdo_id==355466
replace produkt_pi="Sigamucil" if prdo_id==355471
replace produkt_pi="Testoviron  *" if prdo_id==355473
replace produkt_pi="Trigastril" if prdo_id==355476
replace produkt_pi="Augmentan SB- *" if prdo_id==355485
replace produkt_pi="Doloject" if prdo_id==355492
replace produkt_pi="Dopamin Fresenius" if prdo_id==355493
replace produkt_pi="Fibraflex (M02A)" if prdo_id==355498
replace produkt_pi="Jonosteril (K01A4)" if prdo_id==355507
replace produkt_pi="Acetyst" if prdo_id==355537
replace produkt_pi="Frenopect" if prdo_id==355563
replace produkt_pi="Jonosteril (K01A5)" if prdo_id==355569
replace produkt_pi="Respi Jet" if prdo_id==355582
replace produkt_pi="Rubicolan" if prdo_id==355583
replace produkt_pi="Teveten *" if prdo_id==355639
replace produkt_pi="Wydora" if prdo_id==355647
replace produkt_pi="Neyathos" if prdo_id==358582
replace produkt_pi="Gingium *" if prdo_id==362199
replace produkt_pi="Cosmoderma Basis" if prdo_id==363066
replace produkt_pi="Actimax *" if prdo_id==380784
replace produkt_pi="Sonotemp" if prdo_id==395385
replace produkt_pi="Medisense Precision Xtra AT/" if prdo_id==403447
replace produkt_pi="Fortzaar *" if prdo_id==409692
replace produkt_pi="Chininum arsenicosum " if prdo_id==412564
replace produkt_pi="Fentanyl Hexal" if prdo_id==413306
replace produkt_pi="Sertralin Hexal *" if prdo_id==422485
replace produkt_pi="Lansoprazol Stada *" if prdo_id==424695
replace produkt_pi="Adrenalinum" if prdo_id==428298
replace produkt_pi="Spongostan" if prdo_id==432669
replace produkt_pi="Dermabond" if prdo_id==432753
replace produkt_pi="Femranette AL *" if prdo_id==435029
replace produkt_pi="Ondansetron Hexal *" if prdo_id==441975
replace produkt_pi="Acomplia *" if prdo_id==446139
replace produkt_pi="Ammonium carbonicum" if prdo_id==452511
replace produkt_pi="Scrophularia nodosa" if prdo_id==454070
replace produkt_pi="Bisolvon *" if prdo_id==500922
replace produkt_pi="Bupivacain HOE" if prdo_id==501023
replace produkt_pi="Meaverin HOE (N01B1)" if prdo_id==501031
replace produkt_pi="Meaverin HOE (N01B3)" if prdo_id==501065
replace produkt_pi="Meaverin HOE (N01B2)" if prdo_id==501066
replace produkt_pi="L Thyroxin Henning " if prdo_id==501231
replace produkt_pi="Colo Pleon " if prdo_id==501245


***(5) Harmonize and update substance/drug names across NPI DB05, DB06 and DB07 - 2
*duplicate substance IDs
replace sub_id=14942 if substanzen=="Absinthium artemisia HOM"
replace sub_id=10183 if substanzen=="Acidum arsenicosum + Sulfur + Strychnos nux-vomica HOM"
replace sub_id=15624 if substanzen=="Acidum formicicum e formica rufa"
replace sub_id=10185 if substanzen=="Aconitum napellus HOM + Atropa belladonna HOM + Strychnos nux-vomica HOM"
replace sub_id=13350 if substanzen=="Aconitum napellus HOM + Echinacea angustifolia HOM + Hydrargyrum cyanatum"
replace sub_id=15627 if substanzen=="Agropyron repens HOM (9W)"
replace sub_id=15188 if substanzen=="Alexandriner- und Tinnevelly-Sennesfrüchte-Trockenextrakt (3-4:1) (Alexandriner:Tinnevelly 5:1), Auszugsmittel: Wasser"
replace substanzen="Alexandriner- und Tinnevelly-Sennesfruechte-Trockenextrakt (3-4:1) (Alexandriner:Tinnevelly 5:1), Auszugsmittel: Wasser" if substanzen=="Alexandriner- und Tinnevelly-Sennesfrüchte-Trockenextrakt (3-4:1) (Alexandriner:Tinnevelly 5:1), Auszugsmittel: Wasser"

replace sub_id=14325 if substanzen=="Amethyst"
replace sub_id=11074 if substanzen=="Anamirta cocculus HOM + Strychnos nux-vomica HOM"
replace sub_id=15636 if substanzen=="Apis HOM + Atropa belladonna HOM + Formica rufa HOM"
replace sub_id=15644 if substanzen=="Arteria ophthalmica bovis-Glycerolauszug"
replace sub_id=15492 if substanzen=="Ascorbinsäure + Calcium lactogluconat + Calcium phosphinat"
replace substanzen="Ascorbinsaeure + Calcium lactogluconat + Calcium phosphinat" if substanzen=="Ascorbinsäure + Calcium lactogluconat + Calcium phosphinat"

replace sub_id=10205 if substanzen=="Atropa belladonna HOM + Robinia HOM + Strychnos nux-vomica HOM"
replace sub_id=15191 if substanzen=="Aurum iodatum (5W)"
replace sub_id=15931 if substanzen=="Benzodiazepin-Testzone (4W)"
replace sub_id=11329 if substanzen=="Berberis vulgaris HOM + Colchicum autumnale HOM + Formica rufa HOM"
replace sub_id=13407 if substanzen=="Berberis vulgaris HOM + Juniperus communis HOM + Solidago virgaurea HOM"
replace sub_id=15495 if substanzen=="Calcium lactogluconat + Calciumcarbonat"
replace sub_id=15304 if substanzen=="Calciumcarbonat (10W)"
replace sub_id=13477 if substanzen=="Carglumsäure"
replace substanzen="Carglumsaeure" if substanzen=="Carglumsäure"

replace sub_id=11731 if substanzen=="Chamomilla recutita HOM + Gentiana lutea HOM + Strychnos nux-vomica HOM"
replace sub_id=15205 if substanzen=="D-Campher + Methyl salicylat + Benzyl nicotinat"
replace sub_id=14760 if substanzen=="Daptomycin"
replace sub_id=15317 if substanzen=="Dexrazoxan"
replace sub_id=15319 if substanzen=="Dihydrogenperoxid"
replace sub_id=3775 if substanzen=="Drosera HOM (4W)"
replace sub_id=15507 if substanzen=="Eisen(II)-D-gluconat"
replace sub_id=15514 if substanzen=="Eisen(II)-D-gluconat + Folsäure"
replace substanzen="Eisen(II)-D-gluconat + Folsaeure" if substanzen=="Eisen(II)-D-gluconat + Folsäure"

replace sub_id=15516 if substanzen=="Eisen(III)-Natrium-D-gluconat-sucrose-Komplex"
replace sub_id=15325 if substanzen=="Eleutherococcus senticosus Rupr. et. Maxim ex (10W)"
replace sub_id=15517 if substanzen=="Eptotermin alfa"
replace sub_id=15669 if substanzen=="Eucalyptus globulus Labill. + Mentha piperita L."
replace sub_id=15670 if substanzen=="Formica rufa HOM"
replace sub_id=15677 if substanzen=="Gentiana lutea HOM + Myristica fragrans HOM + Strychnos nux-vomica HOM"
replace sub_id=15219 if substanzen=="Juniperus communis L. + Pinus-Arten + Methyl salicylat"
replace sub_id=15955 if substanzen=="Kaliumchlorid (7W)"
replace sub_id=15226 if substanzen=="Methyl salicylat"
replace sub_id=15228 if substanzen=="Methyl salicylat (7W)"
replace sub_id=15229 if substanzen=="Methyl salicylat + Benzyl nicotinat"
replace sub_id=15231 if substanzen=="Methyl salicylat + Benzyl nicotinat + Methyl nicotinat"
replace sub_id=6529 if substanzen=="Nabumeton"
replace sub_id=15814 if substanzen=="Neisseria gonorrhoeae-Testzone"
replace sub_id=13788 if substanzen=="Papain + Trypsin (Schwein) + Chymotrypsin"
replace sub_id=15241 if substanzen=="Picea abies (L.) Karst. + Methyl salicylat"
replace sub_id=15242 if substanzen=="Picea abies (L.) Karst. + Pinus-Arten + Methyl salicylat"
replace sub_id=7767 if substanzen=="Protein-Testzone + Glucose-Testzone + Blut-Testzone"
replace sub_id=8154 if substanzen=="Salicylsäure (4W)"
replace substanzen="Salicylsaeure (4W)" if substanzen=="Salicylsäure (4W)"
replace sub_id=8166 if substanzen=="Salicylsäure + Dithranol"
replace substanzen="Salicylsaeure + Dithranol" if substanzen=="Salicylsäure + Dithranol"

replace sub_id=15384 if substanzen=="Salvia HOM + Arum maculatum HOM + Tropaeolum HOM"
replace sub_id=15703 if substanzen=="Strychnos nux-vomica HOM"
replace sub_id=15704 if substanzen=="Strychnos nux-vomica HOM (10W)"
replace sub_id=15708 if substanzen=="Strychnos nux-vomica HOM (4W)"
replace sub_id=15715 if substanzen=="Strychnos nux-vomica HOM + Carbo vegetabilis + Citrullus colocynthis HOM"
replace sub_id=15718 if substanzen=="Trypanblau"
replace sub_id=15280 if substanzen=="Ubidecarenonum (10W)"
replace sub_id=15406 if substanzen=="Zinkoxid + Salicylsäure"
replace substanzen="Zinkoxid + Salicylsaeure" if substanzen=="Zinkoxid + Salicylsäure"
replace sub_id=15660 if substanzen=="Chamomilla recutita HOM + Strychnos nux-vomica HOM + Tartarus stibiatus"
replace sub_id=15716 if substanzen=="Strychnos nux-vomica HOM + Magnesium phosphoricum + Artemisia absinthium HOM"

*duplicate substance names
replace substanzen="2-Aminoethyldihydrogenphosphat" if sub_id==46
replace substanzen="Aminomethylbenzoesaeure" if sub_id==63
replace substanzen="Acmella ciliata" if sub_id==383
replace substanzen="Aluminiumphosphat" if sub_id==772
replace substanzen="Ammi visnaga HOM" if sub_id==858
replace substanzen="Ammi visnaga HOM (10W)" if sub_id==859
replace substanzen="Ammi visnaga HOM (4W)" if sub_id==864
replace substanzen="Ammi visnaga HOM (9W)" if sub_id==869
replace substanzen="Ammi HOM + Strychnos ignatii HOM + Urginea HOM" if sub_id==871
replace substanzen="Baldrianwurzeloel, synthetisch" if sub_id==1632
replace substanzen="Bismutoxidsalicylat" if sub_id==1908
replace substanzen="Canrenonsaeure" if sub_id==2320
replace substanzen="Centaurium erythraea Rafn." if sub_id==2529
replace substanzen="Wasserstoffperoxid" if sub_id==3604
replace substanzen="Wasserstoffperoxid + Catalase" if sub_id==3607
replace substanzen="Wasserstoffperoxid + Catalase + Cyanocobalamin" if sub_id==3608
replace substanzen="Wasserstoffperoxid + Natriumchlorid" if sub_id==3610
replace substanzen="Diisopropylammoniumchlorid" if sub_id==3614
replace substanzen="Diisopropylammoniumdichloracetat" if sub_id==3615
replace substanzen="Diisopropylammoniumdichloracetat + Procain" if sub_id==3617
replace substanzen="Disci intervertebrales bovis (cervicales, thoracici et lumbales) (6W)" if sub_id==3701
replace substanzen="Disci intervertebrales bovis (cervicales, thoracici et lumbales) (8W)" if sub_id==3703
replace substanzen="DL-alpha-Tocopherol" if sub_id==3716
replace substanzen="DL-alpha-Tocopherol (4W)" if sub_id==3719
replace substanzen="Emser Salz, natuerlich" if sub_id==3965
replace substanzen="Erythromycin + Zinkdiacetat" if sub_id==4068
replace substanzen="Ethanol + Wasserstoffperoxid + Chlorhexidin" if sub_id==4126
replace substanzen="Ethyl 3-(butylacetylamino)propionat" if sub_id==4146
replace substanzen="Hexakalium-Hexanatrium-Trihydrogen-pentacitrat" if sub_id==5022
replace substanzen="Isopropylalkohol + Chlorhexidin + Wasserstoffperoxid" if sub_id==5425
replace substanzen="k-Strophanthin" if sub_id==5480
replace substanzen="Koniferenoele, aetherisch (6W)" if sub_id==5613
replace substanzen="Magnesium trisilicat, wasserfrei" if sub_id==6063
replace substanzen="Lecithin" if sub_id==7314
replace substanzen="Pulsatilla pratensis HOM + Atropa belladonna HOM + Zincum isovalerianicum" if sub_id==7831
replace substanzen="(R,R,R)-alpha-Tocopherol" if sub_id==8085
replace substanzen="Valeriana officinalis L. + Baldrianwurzeloel, synthetisch + Bornyl isovalerat" if sub_id==9358
replace substanzen="Zincum isovalerianicum" if sub_id==9591
replace substanzen="Zinksulfat" if sub_id==9609
replace substanzen="Croton nivens HOM" if sub_id==9963
replace substanzen="Kalium DL-hydrogenaspartat-0,5-Wasser + Magnesium-DL-hydrogenaspartat-4-Wasser" if sub_id==10925
replace substanzen="Magnesium DL-hydrogenaspartat-4-Wasser (4W)" if sub_id==10965
replace substanzen="Calciumdiacetat" if sub_id==11553
replace substanzen="Hypericum perforatum HOM + Zincum isovalerianicum" if sub_id==11823
replace substanzen="DL-alpha-Liponsaeure" if sub_id==12100
replace substanzen="Selenicereus grandiflorus HOM + Crataegus laevigata HOM + Ammi visnaga HOM" if sub_id==12249
replace substanzen="Zincum isovalerianicum + Coffea arabica HOM + Helleborus niger HOM" if sub_id==12275
replace substanzen="Natriumfluorid" if sub_id==12733
replace substanzen="Phospholipide, essentiell" if sub_id==13568
replace substanzen="Lens cristallina lysat. bovis fetal. extractum lyophilisatum aquosum" if sub_id==13664
replace substanzen="Natrium citrat + Natrium-O-dodecylsulfoacetat + Sorbitol" if sub_id==13919
replace substanzen="Dimeticon + Triglyceride, mittelkettige + Buxus chinensis sic." if sub_id==14761
replace substanzen="DL-alpha-Tocopherol (10W)" if sub_id==14915
replace substanzen="DL-alpha-Tocopherol (12W)" if sub_id==14916
replace substanzen="Fischkoerperoel + Glycerol + Lecithin (Ei)" if sub_id==14973
replace substanzen="Glycine max (L.) Merr. + Glycerol + Lecithin (Ei)" if sub_id==14982
replace substanzen="Allantoin + Dexpanthenol + (Z,Z)-Octadeca-9,12-diensaeureethylester" if sub_id==15109

tab gen_id
save npi_hist_clean.dta, replace



**2nd round data cleaning
use npi_hist_clean.dta, clear

** (1) Harmonize and update producer names/ids across NPI DB05, DB06 and DB07
*Spelling inconsistencies 
*Producer: Hersteller
replace hersteller="Spieker" if hersteller=="Laborin.Spieker"
replace hst_id=27810 if hst_id==3699 & hersteller=="Spieker"

*Previous producer: Hersteller_hist
replace hersteller_hist="Anto Ph.Q-Phar." if hersteller_hist=="Anto"
replace hst_hist_id=50033 if hst_hist_id==747 & hersteller_hist=="Anto Ph.Q-Phar."
replace hersteller_hist="Spieker" if hersteller_hist=="Laborin.Spieker"
replace hst_hist_id=27810 if hst_hist_id==3699 & hersteller=="Spieker"

*Parent firms: Konzern
replace konzern="Spieker" if konzern=="Laborin.Spieker"
replace konz_id=27810 if konz_id==3699 & konzern=="Spieker"

*duplicate firm IDs
replace hst_id=12290 if hersteller=="Medex"
replace hst_id=20425 if hersteller=="ME Pharma       >"

replace hst_hist_id=20425 if hersteller_hist=="ME Pharma       >"
replace hst_hist_id=2566 if hersteller_hist=="Pfizer Pharma"

replace konz_id=43 if konzern=="Acis"
replace konz_id=1000252 if konzern=="Bionorica AG"
replace konz_id=1000121 if konzern=="Giulini Chemie"
replace konz_id=1000161 if konzern=="Johnson & Johnson"
replace konz_id=20425 if konzern=="ME Pharma       >"
replace konz_id=1000248 if konzern=="PlasmaSelect"
replace konz_id=1000308 if konzern=="Stada AG"
replace konz_id=1000328 if konzern=="Teva"

replace konz_id=10003130 if konzern=="Steiner"
replace konz_id=10003540 if konzern=="Zambon"
replace konz_id=10003570 if konzern=="ALK + Schering AG"
replace konz_id=10003790 if konzern=="Industrial Chemical + MIP-Holding"
replace konz_id=10003840 if konzern=="Logosys + Swedish Orphan"
replace konz_id=10003970 if konzern=="3i Group"

*duplicate parent firn name
replace konzern="Allergan" if hersteller=="Allergan"
replace konzern="Bayer Schering" if hersteller=="Jenapharm" & konzern=="Bayer"
replace konzern="Remy & Geiser" if hersteller=="Ph.Wernigerode" 


** (2) Harmonize and update product names/ids across NPI DB05, DB06 and DB07
*duplicate IDs and names
replace prd_id=161773 if produkt=="Sterofundin"
replace prdo_id=202952 if produkt=="Noctamide MVT"
replace produkt_pi="Noctamid SHG *" if produkt=="Noctamide MVT"

replace produkt="Actovegin (S01X2)" if prd_id==4063
replace produkt="Grippostad (N02B2)" if prd_id==69806
replace produkt="Medisense MTK" if prd_id==105788
replace produkt="Glucosteril (K04C)" if prd_id==355439

replace produkt="Mapa MA" if prd_id==501436
replace hersteller="Mapa" if pzn_id==4952513
replace hst_id=36909 if pzn_id==4952513
replace konzern="Mapa" if pzn_id==4952513
replace konz_id=36909 if pzn_id==4952513

replace produkt="Mapa" if produkt=="Mapa MA-" | produkt=="Mapa MA"
replace produkt_pi="Mapa" if produkt_pi=="Mapa MA-" | produkt_pi=="Mapa MA"
replace prd_id=101748 if produkt=="Mapa" | produkt=="Mapa MA"
replace prdo_id=101748 if produkt_pi=="Mapa" | produkt_pi=="Mapa MA"

replace produkt_pi="Actovegin (S01X2)" if prdo_id==4063
replace produkt_pi="Bergischer Kraeutertee" if prdo_id==20917
replace produkt_pi="Requip *" if prdo_id==140781
replace produkt_pi="Glucosteril (K04C)" if prdo_id==355439


**duplicates product name/prd_id (PZN-level) (exempt are duplicates as a result of mergers & acquisitions) 
replace produkt="Alpha Lipon Stada" if pzn_id_mod==113299 | pzn_id_mod==113307 | pzn_id_mod==113313 | pzn_id_mod==6172191
replace prd_id=501021 if pzn_id_mod==113299 | pzn_id_mod==113307 | pzn_id_mod==113313 | pzn_id_mod==6172191
replace produkt_pi="Alpha Lipon Stada" if pzn_id_mod==113299 | pzn_id_mod==113307 | pzn_id_mod==113313 | pzn_id_mod==6172191
replace prdo_id=501021 if pzn_id_mod==113299 | pzn_id_mod==113307 | pzn_id_mod==113313 | pzn_id_mod==6172191

replace produkt="Levodopa comp B Stada" if pzn_id_mod==243978 | pzn_id_mod==244009 | pzn_id_mod==244015 | pzn_id_mod==244021 | pzn_id_mod==244038 | pzn_id_mod==244067 | pzn_id_mod==244073
replace prd_id=489590 if pzn_id_mod==243978 | pzn_id_mod==244009 | pzn_id_mod==244015 | pzn_id_mod==244021 | pzn_id_mod==244038 | pzn_id_mod==244067 | pzn_id_mod==244073
replace produkt_pi="Levodopa comp B Stada" if pzn_id_mod==243978 | pzn_id_mod==244009 | pzn_id_mod==244015 | pzn_id_mod==244021 | pzn_id_mod==244038 | pzn_id_mod==244067 | pzn_id_mod==244073
replace prdo_id=489590 if pzn_id_mod==243978 | pzn_id_mod==244009 | pzn_id_mod==244015 | pzn_id_mod==244021 | pzn_id_mod==244038 | pzn_id_mod==244067 | pzn_id_mod==244073

replace produkt="Fraxiparin" if pzn_id_mod==351314 | pzn_id_mod==351320 | pzn_id_mod==3431746 | pzn_id_mod==4794540 | pzn_id_mod==6182574 | pzn_id_mod==7522291 | pzn_id_mod==8656125 | pzn_id_mod==8656131 | pzn_id_mod==8656148 | pzn_id_mod==8656154 | pzn_id_mod==8656160 | pzn_id_mod==8690145 | pzn_id_mod==8690151 | pzn_id_mod==8690168 | pzn_id_mod==8690174 | pzn_id_mod==8743864 | pzn_id_mod==8810980 | pzn_id_mod==8810997
replace prd_id=63613 if pzn_id_mod==351314 | pzn_id_mod==351320 | pzn_id_mod==3431746 | pzn_id_mod==4794540 | pzn_id_mod==6182574 | pzn_id_mod==7522291 | pzn_id_mod==8656125 | pzn_id_mod==8656131 | pzn_id_mod==8656148 | pzn_id_mod==8656154 | pzn_id_mod==8656160 | pzn_id_mod==8690145 | pzn_id_mod==8690151 | pzn_id_mod==8690168 | pzn_id_mod==8690174 | pzn_id_mod==8743864 | pzn_id_mod==8810980 | pzn_id_mod==8810997
replace produkt_pi="Fraxiparin *" if pzn_id_mod==351314 | pzn_id_mod==351320 | pzn_id_mod==3431746 | pzn_id_mod==4794540 | pzn_id_mod==6182574 | pzn_id_mod==7522291 | pzn_id_mod==8656125 | pzn_id_mod==8656131 | pzn_id_mod==8656148 | pzn_id_mod==8656154 | pzn_id_mod==8656160 | pzn_id_mod==8690145 | pzn_id_mod==8690151 | pzn_id_mod==8690168 | pzn_id_mod==8690174 | pzn_id_mod==8743864 | pzn_id_mod==8810980 | pzn_id_mod==8810997
replace prdo_id=63613 if pzn_id_mod==351314 | pzn_id_mod==351320 | pzn_id_mod==3431746 | pzn_id_mod==4794540 | pzn_id_mod==6182574 | pzn_id_mod==7522291 | pzn_id_mod==8656125 | pzn_id_mod==8656131 | pzn_id_mod==8656148 | pzn_id_mod==8656154 | pzn_id_mod==8656160 | pzn_id_mod==8690145 | pzn_id_mod==8690151 | pzn_id_mod==8690168 | pzn_id_mod==8690174 | pzn_id_mod==8743864 | pzn_id_mod==8810980 | pzn_id_mod==8810997

replace produkt="Actovegin (C04A1)" if pzn_id_mod==1925473 | pzn_id_mod==1925504 | pzn_id_mod==1925556 | pzn_id_mod==1925562 | pzn_id_mod==2398024 | pzn_id_mod==2499742 | pzn_id_mod==6171211 | pzn_id_mod==6171228 | pzn_id_mod==6171234 | pzn_id_mod==6171240 | pzn_id_mod==6171257 | pzn_id_mod==6171263 | pzn_id_mod==6171300 | pzn_id_mod==6171317 | pzn_id_mod==6171323 | pzn_id_mod==6171352 | pzn_id_mod==6171369 | pzn_id_mod==6171398 | pzn_id_mod==6171406 | pzn_id_mod==6171429 | pzn_id_mod==6171435 | pzn_id_mod==6171441 | pzn_id_mod==6171458
replace prd_id=4051 if pzn_id_mod==1925473 | pzn_id_mod==1925504 | pzn_id_mod==1925556 | pzn_id_mod==1925562 | pzn_id_mod==2398024 | pzn_id_mod==2499742 | pzn_id_mod==6171211 | pzn_id_mod==6171228 | pzn_id_mod==6171234 | pzn_id_mod==6171240 | pzn_id_mod==6171257 | pzn_id_mod==6171263 | pzn_id_mod==6171300 | pzn_id_mod==6171317 | pzn_id_mod==6171323 | pzn_id_mod==6171352 | pzn_id_mod==6171369 | pzn_id_mod==6171398 | pzn_id_mod==6171406 | pzn_id_mod==6171429 | pzn_id_mod==6171435 | pzn_id_mod==6171441 | pzn_id_mod==6171458
replace produkt_pi="Actovegin (C04A1)" if pzn_id_mod==1925473 | pzn_id_mod==1925504 | pzn_id_mod==1925556 | pzn_id_mod==1925562 | pzn_id_mod==2398024 | pzn_id_mod==2499742 | pzn_id_mod==6171211 | pzn_id_mod==6171228 | pzn_id_mod==6171234 | pzn_id_mod==6171240 | pzn_id_mod==6171257 | pzn_id_mod==6171263 | pzn_id_mod==6171300 | pzn_id_mod==6171317 | pzn_id_mod==6171323 | pzn_id_mod==6171352 | pzn_id_mod==6171369 | pzn_id_mod==6171398 | pzn_id_mod==6171406 | pzn_id_mod==6171429 | pzn_id_mod==6171435 | pzn_id_mod==6171441 | pzn_id_mod==6171458
replace prdo_id=4051 if pzn_id_mod==1925473 | pzn_id_mod==1925504 | pzn_id_mod==1925556 | pzn_id_mod==1925562 | pzn_id_mod==2398024 | pzn_id_mod==2499742 | pzn_id_mod==6171211 | pzn_id_mod==6171228 | pzn_id_mod==6171234 | pzn_id_mod==6171240 | pzn_id_mod==6171257 | pzn_id_mod==6171263 | pzn_id_mod==6171300 | pzn_id_mod==6171317 | pzn_id_mod==6171323 | pzn_id_mod==6171352 | pzn_id_mod==6171369 | pzn_id_mod==6171398 | pzn_id_mod==6171406 | pzn_id_mod==6171429 | pzn_id_mod==6171435 | pzn_id_mod==6171441 | pzn_id_mod==6171458

replace produkt="Actovegin (D03A9)" if pzn_id_mod==6171085 | pzn_id_mod==6171091 | pzn_id_mod==6171139 | pzn_id_mod==6171145 | pzn_id_mod==6171174 | pzn_id_mod==6171180 
replace prd_id=4057 if pzn_id_mod==6171085 | pzn_id_mod==6171091 | pzn_id_mod==6171139 | pzn_id_mod==6171145 | pzn_id_mod==6171174 | pzn_id_mod==6171180 
replace produkt_pi="Actovegin (D03A9)" if pzn_id_mod==6171085 | pzn_id_mod==6171091 | pzn_id_mod==6171139 | pzn_id_mod==6171145 | pzn_id_mod==6171174 | pzn_id_mod==6171180 
replace prdo_id=4057 if pzn_id_mod==6171085 | pzn_id_mod==6171091 | pzn_id_mod==6171139 | pzn_id_mod==6171145 | pzn_id_mod==6171174 | pzn_id_mod==6171180 

replace produkt="Gutron" if pzn_id_mod==1999520 | pzn_id_mod==2067385 | pzn_id_mod==2494130
replace prd_id=70275 if pzn_id_mod==1999520 | pzn_id_mod==2067385 | pzn_id_mod==2494130
replace produkt_pi="Gutron *" if pzn_id_mod==1999520 | pzn_id_mod==2067385 | pzn_id_mod==2494130
replace prdo_id=70275 if pzn_id_mod==1999520 | pzn_id_mod==2067385 | pzn_id_mod==2494130

replace produkt="Elantan" if pzn_id_mod==2396999 | pzn_id_mod==2399940 | pzn_id_mod==2796635 | pzn_id_mod==4901728 | pzn_id_mod==4901734 | pzn_id_mod==4901740 | pzn_id_mod==4901757 | pzn_id_mod==4901763 | pzn_id_mod==4901786
replace prd_id=52387 if pzn_id_mod==2396999 | pzn_id_mod==2399940 | pzn_id_mod==2796635 | pzn_id_mod==4901728 | pzn_id_mod==4901734 | pzn_id_mod==4901740 | pzn_id_mod==4901757 | pzn_id_mod==4901763 | pzn_id_mod==4901786
replace produkt_pi="Elantan *" if pzn_id_mod==2396999 | pzn_id_mod==2399940 | pzn_id_mod==2796635 | pzn_id_mod==4901728 | pzn_id_mod==4901734 | pzn_id_mod==4901740 | pzn_id_mod==4901757 | pzn_id_mod==4901763 | pzn_id_mod==4901786
replace prdo_id=52387 if pzn_id_mod==2396999 | pzn_id_mod==2399940 | pzn_id_mod==2796635 | pzn_id_mod==4901728 | pzn_id_mod==4901734 | pzn_id_mod==4901740 | pzn_id_mod==4901757 | pzn_id_mod==4901763 | pzn_id_mod==4901786

replace produkt="Glimidstada" if pzn_id_mod==2718405 | pzn_id_mod==2718411 | pzn_id_mod==2718440 
replace prd_id=68389 if pzn_id_mod==2718405 | pzn_id_mod==2718411 | pzn_id_mod==2718440 
replace produkt_pi="Glimidstada" if pzn_id_mod==2718405 | pzn_id_mod==2718411 | pzn_id_mod==2718440 
replace prdo_id=68389 if pzn_id_mod==2718405 | pzn_id_mod==2718411 | pzn_id_mod==2718440 

replace prd_id=7428 if pzn_id_mod==3916461
replace produkt_pi="Alovisa" if pzn_id_mod==3916461
replace prdo_id=7428 if pzn_id_mod==3916461

replace produkt="Prostaneurin" if pzn_id_mod==4568068 | pzn_id_mod==4916523
replace prd_id=355308 if pzn_id_mod==4568068 | pzn_id_mod==4916523
replace produkt_pi="Prostaneurin" if pzn_id_mod==4568068 | pzn_id_mod==4916523
replace prdo_id=355308 if pzn_id_mod==4568068 | pzn_id_mod==4916523

replace produkt="Dolviran" if pzn_id_mod==4573566 | pzn_id_mod==4573572
replace prd_id=218862 if pzn_id_mod==4573566  | pzn_id_mod==4573572
replace produkt_pi="Dolviran" if pzn_id_mod==4573566  | pzn_id_mod==4573572
replace prdo_id=218862 if pzn_id_mod==4573566  | pzn_id_mod==4573572

replace produkt="Sonicare PLS" if produkt=="Sonicare"
replace prd_id=501405 if produkt=="Sonicare PLS"
replace produkt_pi="Sonicare PLS" if produkt_pi=="Sonicare"
replace prdo_id=501405 if produkt_pi=="Sonicare"

replace produkt="ASS Stada (B01C1)" if pzn_id_mod==7382275 | pzn_id_mod==7382281 | pzn_id_mod==7394433
replace prd_id=468306 if pzn_id_mod==7382275 | pzn_id_mod==7382281 | pzn_id_mod==7394433
replace produkt_pi="ASS Stada (B01C1)" if pzn_id_mod==7382275 | pzn_id_mod==7382281 | pzn_id_mod==7394433
replace prdo_id=468306 if pzn_id_mod==7382275 | pzn_id_mod==7382281 | pzn_id_mod==7394433

replace produkt="Fumaderm FUM" if pzn_id_mod==8707302
replace prd_id=501459 if pzn_id_mod==8707302
replace produkt_pi="Fumaderm FUM" if pzn_id_mod==8707302
replace prdo_id=501459 if pzn_id_mod==8707302

replace produkt="Crinone" if pzn_id_mod==8819018
replace prd_id=42019 if pzn_id_mod==8819018
replace produkt_pi="Crinone" if pzn_id_mod==8819018
replace prdo_id=42019 if pzn_id_mod==8819018

*Update drug-type classifications  
replace gen_id=1 if prd_id==1426
replace gen_id=1 if prd_id==1690
replace gen_id=2 if prd_id==78868
replace gen_id=2 if prd_id==133607
replace gen_id=2 if prd_id==135329
replace gen_id=3 if prd_id==136411
replace gen_id=1 if prd_id==179104
replace gen_id=3 if prd_id==181282
replace gen_id=3 if prd_id==181284
replace gen_id=3 if prd_id==181290
replace gen_id=3 if prd_id==181294
replace gen_id=3 if prd_id==239113
replace gen_id=3 if prd_id==451251
replace gen_id=3 if prd_id==479068

tab generika if gen_id==1
replace generika="keine Generikasituation" if gen_id==1

tab generika if gen_id==2
replace generika="Generika" if gen_id==2

tab generika if gen_id==3
replace generika="Originalprodukt" if gen_id==3

tab generika if gen_id==4
replace generika="Patent" if gen_id==4


** (3) Harmonize and update substance names/ids across NPI DB05, DB06 and DB07
*Spelling inconsistencies
replace substanzen="Dihydrogenperoxid" if substanzen=="Wasserstoffperoxid"
replace sub_id=15319 if substanzen=="Dihydrogenperoxid" & sub_id==3604
replace substanzen="Wirkstoff unbekannt" if substanzen=="kein Wirkstoff"
replace sub_id=1 if substanzen=="Wirkstoff unbekannt" & sub_id==5576

**duplicates
replace sub_id=15196 if substanzen=="Capsicum-Arten + Methyl salicylat"
replace sub_id=15709 if substanzen=="Strychnos nux-vomica HOM (5W)"

replace substanzen="Aluminiumtrichlorid" if sub_id==773
replace substanzen="Koniferenöl, ätherisch" if sub_id==5612
replace substanzen="Magnesium-DL-hydrogenaspartat-4-Wasser" if sub_id==10963

*complement missing information (due to spelling differences/mistakes)
replace substanzen="Trinkwasser (9W)" if prd_id==1695
replace sub_id=13239 if prd_id==1695
replace prd_id=1711 if prd_id==1711 | prd_id==1720 | prd_id==1727 | prd_id==1736 | prd_id==1743 | prd_id==1751 | prd_id==1759	| prd_id==1767 | prd_id==1775
replace substanzen="Viscum album HOM" if prd_id==1711 | prd_id==256965
replace sub_id=10750 if prd_id==1711 | prd_id==256965
replace substanzen="Calciumhydrogenphosphat + Calcium citrat + Ascorbinsäure" if prd_id==2292
replace sub_id=13883 if prd_id==2292
replace substanzen="Eucalyptus globulus Labill. + D-Campher + Picea abies (L.) Karst." if prd_id==2305
replace sub_id=10269 if prd_id==2305
replace substanzen="Kieselerde, gereinigt" if prd_id==2345
replace sub_id=10941 if prd_id==2345
replace substanzen="Ascorbinsäure" if prd_id==2420
replace sub_id=1404 if prd_id==2420
*6 replacements/obersevtaions (ok)
replace substanzen="(R,R,R)-alpha-Tocopherol" if prd_id==2424
replace sub_id=8085 if prd_id==2424
replace substanzen="Cholesterin-Testzone" if prd_id==2673
replace sub_id=2794 if prd_id==2673
replace substanzen="Malpighia punicifolia L." if prd_id==2790
replace sub_id=6078 if prd_id==2790
replace substanzen="Aconitum napellus HOM" if prd_id==3851
replace sub_id=388 if prd_id==3851
replace substanzen="Chamomilla recutita (L.) Rauschert + Commiphora molmol Engl." if prd_id==4083
replace sub_id=2631 if prd_id==4083
replace substanzen="Ginkgo biloba L. (5W)" if prd_id==5480
replace sub_id=4636 if prd_id==5480
replace substanzen="Bienenköniginnen-Futtersaft + (R,R,R)-alpha-Tocopherol + Panax ginseng C. A. Meyer" if prd_id==7591
replace sub_id=15299 if prd_id==7591
replace substanzen="Algeldrat" if prd_id==7718
replace sub_id=10809 if prd_id==7718

replace substanzen="Calcium pantothenat (7W)" if prd_id==8292
replace sub_id=12778 if prd_id==8292
replace substanzen="Ammoniaklösung 33% + Isopropylalkohol + Lavandula angustifolia Mill." if prd_id==8427
replace sub_id=15725 if prd_id==8427
replace substanzen="Trinkwasser" if prd_id==8845 | prd_id==11349 | prd_id==11351 | prd_id==11356 | prd_id==11358 | prd_id==11375 | prd_id==11376 | prd_id==187031 | prd_id==219443 | prd_id==219445 | prd_id==219447 | prd_id==355004 | prd_id==355195
replace sub_id=13942 if prd_id==8845 | prd_id==11349 | prd_id==11351 | prd_id==11356 | prd_id==11358 | prd_id==11375 | prd_id==11376 | prd_id==187031 | prd_id==219443 | prd_id==219445 | prd_id==219447 | prd_id==355004 | prd_id==355195
replace substanzen="Artemisia absinthium L. + Gentiana lutea L. + Angelica archangelica L." if prd_id==9645
replace sub_id=1328 if prd_id==9645
replace substanzen="Dialuminiumchloridpentahydroxid + Triclocarban" if prd_id==9651
replace sub_id=3550 if prd_id==9651
replace substanzen="Glyoxal + Lauralkonium chlorid + Miristalkonium chlorid" if prd_id==10041
replace sub_id=4775 if prd_id==10041
replace substanzen="Bienenköniginnen-Futtersaft" if prd_id==10826 | prd_id==65639
replace sub_id=1862 if prd_id==10826 | prd_id==65639
replace substanzen="Arnica montana HOM (14W)" if prd_id==12723
replace sub_id=11139 if prd_id==12723
replace substanzen="Fette + Enzacamen + Ensulizol" if prd_id==13910
replace sub_id=4342 if prd_id==13910
replace substanzen="Macrogolglycerolstearate (12W)" if prd_id==13930
replace sub_id=12486 if prd_id==13930
replace substanzen="Chlortetracyclin" if prd_id==15601
replace sub_id=2790 if prd_id==15601
replace substanzen="Arnica montana HOM (8W)" if prd_id==15622
replace sub_id=11150 if prd_id==15622
replace substanzen="Eucalyptus globulus Labill. + Picea abies (L.) Karst." if prd_id==16357
replace sub_id=4198 if prd_id==16357
replace substanzen="Urtica-Arten" if prd_id==16688 | prd_id==188868
replace sub_id=9311 if prd_id==16688 | prd_id==188868
replace substanzen="Calciumcarbonat + Colecalciferol" if prd_id==17114
replace sub_id=2181 if prd_id==17114
replace substanzen="Calciumcarbonat + Colecalciferol + Ascorbinsäure" if prd_id==17115
replace sub_id=15658 if prd_id==17115
replace substanzen="Magnesium carbonat" if prd_id==17131
replace sub_id=6018 if prd_id==17131
replace substanzen="Magnesium carbonat + Ascorbinsäure" if prd_id==17132
replace sub_id=15349 if prd_id==17132
replace substanzen="(R,R,R)-alpha-Tocopherol" if prd_id==17147
replace sub_id=8085 if prd_id==17147
replace substanzen="Dimethylbenzylkokosfettalkylammoniumchlorid" if prd_id==22030
replace sub_id=15942 if prd_id==22030
replace substanzen="Magnesiumoxid + DL-alpha-Tocopherol" if prd_id==22051
replace sub_id=15352 if prd_id==22051
replace substanzen="Biotinum" if prd_id==23113
replace sub_id=1886 if prd_id==23113
replace substanzen="Protein (18W)" if prd_id==24277
replace sub_id=7749 if prd_id==24277

replace substanzen="Glucose-Testzone" if prd_id==2676 | prd_id==24398 | prd_id==104952 | prd_id==105738 | prd_id==125745 | prd_id==152502 | prd_id==191425 | prd_id==323324 | prd_id==344488 | prd_id==355687 | prd_id==372504 | prd_id==382404 | prd_id==428259 | prd_id==437529 | prd_id==438724 | prd_id==462652 | prd_id==474367 | prd_id==482972
replace sub_id=4692 if prd_id==2676 | prd_id==24398 | prd_id==104952 | prd_id==105738 | prd_id==125745 | prd_id==152502 | prd_id==191425 | prd_id==323324 | prd_id==344488 | prd_id==355687 | prd_id==372504 | prd_id==382404 | prd_id==428259 | prd_id==437529 | prd_id==438724 | prd_id==462652 | prd_id==474367 | prd_id==482972

replace substanzen="Ascorbinsäure (15W)" if prd_id==26438
replace sub_id=1407 if prd_id==26438
replace substanzen="Valeriana officinalis L. + Kaliumbromid" if prd_id==26700
replace sub_id=9373 if prd_id==26700
replace substanzen="Foeniculum vulgare Mill. ssp. vulgare var. vulgare" if prd_id==26957
replace sub_id=4420 if prd_id==26957
replace substanzen="D-Campher + Picea abies (L.) Karst. + Ethanol" if prd_id==28311
replace sub_id=9995 if prd_id==28311
replace substanzen="Calcium phosphoricum" if prd_id==29031
replace sub_id=2154 if prd_id==29031
replace substanzen="Poly(styrol-co-divinylbenzol)sulfonsäure (92:8), Calciumsalz" if prd_id==29036
replace sub_id=15370 if prd_id==29036
replace substanzen="Calcium lactogluconat + Calciumcarbonat" if prd_id==29040 | prd_id==29043 | prd_id==29044 | prd_id==29046 | prd_id==29048 | prd_id==29049 | prd_id==29053
replace sub_id=15495 if substanzen=="Calcium lactogluconat + Calciumcarbonat"
replace substanzen="Crataegus laevigata (Poir.) DC. (14W)" if prd_id==30604
replace sub_id=3215 if prd_id==30604
replace substanzen="Moxaverin" if prd_id==32407
replace sub_id=6449 if prd_id==32407
replace substanzen="Chinolin-8-ol-hemisulfat-Kaliumsulfat (2:1)" if prd_id==33592
replace sub_id=10856 if prd_id==33592
replace substanzen="Ochsengalle" if prd_id==33831
replace sub_id=6847 if prd_id==33831
replace substanzen="Onopordum acanthium L. (6W)" if prd_id==34546
replace sub_id=14505 if prd_id==34546
replace substanzen="Lutropin-Testzone (MAB) + Estron-3-glucuronid-Testzone (MAB)" if prd_id==35333
replace sub_id=5953 if prd_id==35333
replace substanzen="Ubidecarenon + DL-alpha-Tocopherol" if prd_id==36037
replace sub_id=15397 if prd_id==36037
replace substanzen="Rosmarinus officinalis L. + Salicylsäure + Thymol" if prd_id==42013
replace sub_id=8078 if prd_id==42013
replace substanzen="Delphinium staphisagria-spagyrische Essenz (6W)" if prd_id==45171
replace sub_id=15752 if prd_id==45171
replace substanzen="Formaldehyd + Glutaral" if prd_id==45692
replace sub_id=4456 if prd_id==45692
replace substanzen="Formaldehyd (4W)" if prd_id==45737
replace sub_id=4454 if prd_id==45737
replace substanzen="Aconitum napellus HOM (32W)" if prd_id==45981
replace sub_id=12281 if prd_id==45981
replace substanzen="Glucoseoxidase + Peroxidase" if prd_id==46249
replace sub_id=4703 if prd_id==46249
replace substanzen="Dolomitmehl" if prd_id==47735
replace sub_id=3751 if prd_id==47735
replace substanzen="Hexetidin" if prd_id==47918
replace sub_id=5025 if prd_id==47918
replace substanzen="Eisen(II)-D-gluconat" if prd_id==52220
replace sub_id=15507 if substanzen=="Eisen(II)-D-gluconat"
replace substanzen="Zinkoxid + Salicylsäure" if prd_id==52330
replace sub_id=15406 if substanzen=="Zinkoxid + Salicylsäure"
replace substanzen="Eleutherococcus senticosus Rupr. et. Maxim ex" if prd_id==55316
replace sub_id=3951 if prd_id==55316
replace substanzen="Eleutherococcus senticosus Rupr. et. Maxim ex (10W)" if prd_id==55326
replace sub_id=15325 if prd_id==55326
replace substanzen="Protein (31W)" if prd_id==56064
replace sub_id=7756 if prd_id==56064
replace substanzen="Bauchspeicheldrüse (8W)" if prd_id==56218
replace sub_id=1678 if prd_id==56218
replace substanzen="Trinkwasser (18W)" if prd_id==57375 | prd_id==166716
replace sub_id=15178 if prd_id==57375 | prd_id==166716
replace substanzen="Trinkwasser (8W)" if prd_id==57845
replace sub_id=13265 if prd_id==57845
replace substanzen="Trinkwasser (5W)" if prd_id==58675
replace sub_id=9159 if prd_id==58675
replace substanzen="Eisen(II)-sulfat + Folsäure" if prd_id==60285
replace sub_id=3929 if prd_id==60285
replace substanzen="Alginsäure + Poly(vinylacetat)" if prd_id==61597
replace sub_id=12772 if prd_id==61597
replace substanzen="D-Campher (7W)" if prd_id==62912
replace sub_id=9970 if prd_id==62912
replace substanzen="Eisen(II)-D-gluconat + Folsäure" if prd_id==63185
replace sub_id=15514 if prd_id==63185
replace substanzen="Melissa officinalis L. + Crataegus laevigata (Poir.) DC." if prd_id==63597
replace sub_id=11577 if prd_id==63597
replace substanzen="Ethanol (4W)" if prd_id==63722 | prd_id==147025
replace sub_id=4117 if prd_id==63722 | prd_id==147025
replace substanzen="Rubus idaeus L. (8W)" if prd_id==64123
replace sub_id=8102 if prd_id==64123
replace substanzen="Ethanol, vergällt" if prd_id==64347
replace sub_id=4131 if prd_id==64347
replace substanzen="Gentiana lutea L. + Artemisia absinthium L. + Zingiber officinale (Willd.) Rosc." if prd_id==66336
replace sub_id=4619 if prd_id==66336
replace substanzen="Viscum album L." if prd_id==66521 | prd_id==188890
replace sub_id=9497 if prd_id==66521 | prd_id==188890
replace substanzen="Butandial + 2,5-Dimethoxytetrahydrofuran" if prd_id==66778
replace sub_id=2064 if prd_id==66778
replace substanzen="Panax ginseng C. A. Meyer + DL-alpha-Tocopherol + Phospholipide (Sojabohne)" if prd_id==67979
replace sub_id=15365 if prd_id==67979
replace substanzen="Panax ginseng C. A. Meyer" if prd_id==68001 | prd_id==81174 | prd_id==144253 | prd_id==147642
replace sub_id=7023 if prd_id==68001 | prd_id==81174 | prd_id==144253 | prd_id==147642
replace substanzen="Borago officinalis L." if prd_id==68099
replace sub_id=1961 if prd_id==68099
replace substanzen="Salicylsäure" if prd_id==69185 | prd_id==348349
replace sub_id=8153 if prd_id==69185 | prd_id==348349
replace substanzen="Paullinia cupana Kunth ex H.B.K. var. sorbilis (Mart.) Duke + Coffein" if prd_id==70013
replace sub_id=7148 if prd_id==70013
replace substanzen="Hamamelis virginiana L." if prd_id==71302
replace sub_id=4867 if prd_id==71302
replace substanzen="Crataegus laevigata (Poir.) DC." if prd_id==75106 | prd_id==258939
replace sub_id=3212 if prd_id==75106 | prd_id==258939
replace substanzen="Selenicereus grandiflorus HOM (6W)" if prd_id==75591
replace sub_id=10334 if prd_id==75591
replace substanzen="Hypromellose" if prd_id==79036
replace sub_id=5255 if prd_id==79036
replace substanzen="Hylan B (Vogelproteine)" if prd_id==79985
replace sub_id=13907 if prd_id==79985
replace substanzen="Hypothalamus" if prd_id==80355
replace sub_id=5254 if prd_id==80355
replace substanzen="Tyrothricin + Dequalinium-Kation + Benzocain" if prd_id==82471
replace sub_id=14447 if prd_id==82471
replace substanzen="Echinacea HOM (5W)" if prd_id==85297
replace sub_id=3839 if prd_id==85297
replace substanzen="Kalium phosphoricum" if prd_id==86059
replace sub_id=5524 if prd_id==86059
replace substanzen="Kalium sulfuricum" if prd_id==86113
replace sub_id=5530 if prd_id==86113
replace substanzen="Lidocain + Chlorhexidin" if prd_id==87449
replace sub_id=5838 if prd_id==87449
replace substanzen="Trinkwasser (17W)" if prd_id==87707
replace sub_id=12811 if prd_id==87707
replace substanzen="Cynara scolymus L." if prd_id==88766
replace sub_id=3383 if prd_id==88766
replace substanzen="Hibiscus sabdariffa L. (7W)" if prd_id==88785
replace sub_id=5030 if prd_id==88785

replace substanzen="Pimpinella anisum L. + Foeniculum vulgare Mill. ssp. vulgare var. vulgare + Carum carvi L." if prd_id==88936
replace sub_id=7411 if prd_id==88936
replace substanzen="Calcium-Magnesium-Carbonat" if prd_id==88939
replace sub_id=2171 if prd_id==88939
replace substanzen="Melissa officinalis L." if prd_id==88950 | prd_id==260031
replace sub_id=6187 if prd_id==88950 | prd_id==260031
replace substanzen="Crataegus laevigata (Poir.) DC." if prd_id==89041
replace sub_id=3212 if prd_id==89041
replace substanzen="Methylrosanilinium chlorid" if prd_id==91936
replace sub_id=6353 if prd_id==91936
replace substanzen="Kaliumchlorid (6W)" if prd_id==92215
replace sub_id=5542 if prd_id==92215
replace substanzen="Cucurbita pepo L." if prd_id==92221
replace sub_id=3271 if prd_id==92221
replace substanzen="Magnesiumoxid + DL-alpha-Tocopherol" if substanzen=="Magnesiumoxid + DL-Â-Tocopherol"
replace sub_id=15352 if substanzen=="Magnesiumoxid + DL-alpha-Tocopherol"
replace substanzen="Magnesiumoxid + DL-alpha-Tocopherol" if prd_id==93690
replace sub_id=15352 if prd_id==93690
replace substanzen="D-Campher (4W)" if prd_id==94209
replace sub_id=9967 if prd_id==94209
replace substanzen="Salicylsäure + Milchsäure" if prd_id==94761
replace sub_id=8176 if prd_id==94761
replace substanzen="Natriumchlorid" if prd_id==95371
replace sub_id=6641 if prd_id==95371
replace substanzen="Lilium lancifolium HOM" if prd_id==96184
replace sub_id=5858 if prd_id==96184
replace substanzen="Aesculus hippocastanum L. + Troxerutin" if prd_id==96317
replace sub_id=522 if prd_id==96317
replace substanzen="Tuberculini bovini derivatum proteinosum purificatum Nosode" if prd_id==96777
replace sub_id=9209 if prd_id==96777
replace substanzen="Lycopus virginicus HOM + Valeriana officinalis HOM + Selenicereus grandiflorus HOM" if prd_id==99764
replace sub_id=13778 if prd_id==99764
replace substanzen="Dexpanthenol" if prd_id==99770 | prd_id==263531 | prd_id==263692
replace sub_id=3527 if prd_id==99770 | prd_id==263531 | prd_id==263692
replace substanzen="Pinus mugo Turra (4W)" if prd_id==99988
replace sub_id=14181 if prd_id==99988
replace substanzen="Magnesiumhydroxid + Algeldrat" if substanzen=="Algeldrat + Magnesiumhydroxid"
replace sub_id=10968 if substanzen=="Magnesiumhydroxid + Algeldrat"
replace substanzen="Ascorbinsäure + Calcium lactogluconat + Calcium phosphinat" if prd_id==100005
replace sub_id=15492 if substanzen=="Ascorbinsäure + Calcium lactogluconat + Calcium phosphinat"
replace substanzen="Carum carvi HOM (7W)" if prd_id==100233
replace sub_id=11666 if prd_id==100233
replace substanzen="Magnesium carbonat, leichtes, basisches + DL-alpha-Tocopherol" if substanzen=="Magnesium carbonat, leichtes, basisches + DL-Â-Tocopherol"
replace sub_id=15350 if substanzen=="Magnesium carbonat, leichtes, basisches + DL-alpha-Tocopherol"
replace substanzen="Magnesium carbonat, leichtes, basisches + DL-alpha-Tocopherol" if prd_id==100701
replace sub_id=15350 if prd_id==100701
replace substanzen="Magnesiumoxid, schweres" if prd_id==100759
replace sub_id=13912 if prd_id==100759
replace substanzen="Chamomilla recutita (L.) Rauschert + Lactose" if prd_id==101974
replace sub_id=2637 if prd_id==101974
replace substanzen="Paraffin, dünnflüssiges + Simmondsia chinensis (Link) C.K. Schneider" if prd_id==103456
replace sub_id=15872 if prd_id==103456
replace substanzen="Propan-1-ol + Glyoxal" if prd_id==111235
replace sub_id=14049 if prd_id==111235
replace substanzen="Anti-HCG-Immunglobulin" if prd_id==113193 | prd_id==138812 | prd_id==278799
replace sub_id=1005 if prd_id==113193  | prd_id==138812 | prd_id==278799
replace substanzen="Candida albicans-Testzone" if prd_id==113351
replace sub_id=13212 if prd_id==113351
replace substanzen="Ethanol + Propan-1-ol" if prd_id==113463
replace sub_id=14023 if prd_id==113463
replace substanzen="Glycine max (L.) Merr. + Cocamidopropyl betain + Natrium laureth sulfat" if prd_id==115477
replace sub_id=15041 if prd_id==115477
replace substanzen="Natriumfluorid + Olaflur + Dectaflur" if prd_id==116649
replace sub_id=12738 if prd_id==116649
replace substanzen="Phytosterol" if prd_id==117134
replace sub_id=7360 if prd_id==117134
replace substanzen="Cyclaminsäure + Saccharin" if prd_id==118447
replace sub_id=11209 if prd_id==118447
replace substanzen="Natrium chloratum" if prd_id==118644
replace sub_id=6576 if prd_id==118644
replace substanzen="Natrium phosphoricum" if prd_id==118846
replace sub_id=6598 if prd_id==118846
replace substanzen="Natriumchlorid" if prd_id==118996
replace sub_id=6641 if prd_id==118996
replace substanzen="Methyl salicylat" if prd_id==119554
replace sub_id=15226 if prd_id==119554

replace substanzen="Achillea millefolium L. (9W)" if prd_id==119941
replace sub_id=167 if prd_id==119941
replace substanzen="Pulmo + Glandula thymi suis" if prd_id==120607
replace sub_id=13799 if prd_id==120607
replace substanzen="Heilmoor, Neydharting" if prd_id==120641
replace sub_id=14767 if prd_id==120641
replace substanzen="Mucosa intestinalis tenuis + Mucosa intestinalis crassi" if prd_id==120644
replace sub_id=13668 if prd_id==120644
replace substanzen="Medulla ossis" if prd_id==120703
replace sub_id=6147 if prd_id==120703
replace substanzen="Cerebrum" if prd_id==120774
replace sub_id=2562 if prd_id==120774
replace substanzen="Testes" if substanzen=="Keimdrüsen, männliche"
replace sub_id=8864 if substanzen=="Testes"
replace substanzen="Lien" if substanzen=="Milz"
replace sub_id=5851 if substanzen=="Lien"
replace substanzen="Pulmo" if substanzen=="Lunge"
replace sub_id=7807 if substanzen=="Pulmo"
replace substanzen="Glandula suprarenalis suis" if substanzen=="Nebennieren"
replace sub_id=13751 if substanzen=="Glandula suprarenalis suis"
replace substanzen="Corpus luteum" if substanzen=="Gelbkörper"
replace sub_id=3174 if substanzen=="Corpus luteum"
replace substanzen="Epiphysis" if substanzen=="Zirbeldrüse"
replace sub_id=4013 if substanzen=="Epiphysis"
replace substanzen="Glandula parathyreoidea" if substanzen=="Nebenschilddrüsen"
replace sub_id=4647 if substanzen=="Glandula parathyreoidea"
replace substanzen="Ren" if substanzen=="Nieren"
replace sub_id=7921 if substanzen=="Ren"
replace substanzen="Mucosa intestinalis tenuis" if substanzen=="Dünndarmschleimhaut"
replace sub_id=13844 if substanzen=="Mucosa intestinalis tenuis"
replace substanzen="Mucosa intestinalis crassi" if substanzen=="Dickdarmschleimhaut"
replace sub_id=14694 if substanzen=="Mucosa intestinalis crassi"
replace substanzen="Vesica urinaria" if substanzen=="Harnblase"
replace sub_id=9450 if substanzen=="Vesica urinaria"
replace substanzen="Diencephalon" if substanzen=="Zwischenhirn"
replace sub_id=3576 if substanzen=="Diencephalon"
replace substanzen="Cornea" if substanzen=="Hornhaut"
replace sub_id=3172 if substanzen=="Cornea"
replace substanzen="Ovarium + Corpus luteum" if substanzen=="Follikel + Gelbkörper"
replace sub_id=13548 if substanzen=="Ovarium + Corpus luteum"
replace substanzen="Corpus luteum + Testes" if substanzen=="GelbkÃ¶rper + Keimdrüsen, männliche"
replace sub_id=13413 if substanzen=="Corpus luteum + Testes"
replace substanzen="Lingua" if substanzen=="Zunge"
replace sub_id=5866 if substanzen=="Lingua"
replace substanzen="Funiculus umbilicalis" if substanzen=="Nabelschnur"
replace sub_id=4512 if substanzen=="Funiculus umbilicalis"
replace substanzen="Amnion bovis" if substanzen=="Schafshaut"
replace sub_id=923 if substanzen=="Amnion bovis"
replace substanzen="Glandula lymphatica" if substanzen=="Lymphknoten"
replace sub_id=4646 if substanzen=="Glandula lymphatica"
replace substanzen="Mucosa nasalis" if substanzen=="Nasenschleimhaut"
replace sub_id=6464 if substanzen=="Mucosa nasalis"
replace substanzen="Hypophysinum" if substanzen=="Hirnanhangdrüse"
replace sub_id=5250 if substanzen=="Hypophysinum"
replace substanzen="Panax ginseng C. A. Meyer (11W)" if prd_id==123379
replace sub_id=7025 if prd_id==123379
replace substanzen="Ocimum basilicum HOM (12W)" if prd_id==123434
replace sub_id=12209 if prd_id==123434
replace substanzen="Strychnos nux-vomica HOM" if prd_id==123911 | prd_id==123970
replace sub_id=15703 if prd_id==123911 | prd_id==123970
replace sub_id=15703 if substanzen=="Strychnos nux-vomica HOM"
replace substanzen="Retinol (22W)" if prd_id==127151
replace sub_id=7958 if prd_id==127151
replace substanzen="Retinol (24W)" if prd_id==127188
replace sub_id=7959 if prd_id==127188
replace substanzen="Ascorbinsäure + Citrusfrucht-Extrakt" if prd_id==127210
replace sub_id=15843 if prd_id==127210
replace substanzen="Zinkoxid" if prd_id==128252
replace sub_id=9620 if prd_id==128252
replace substanzen="Populus-Arten" if prd_id==128392
replace sub_id=7608 if prd_id==128392
replace substanzen="Salix-Arten (29W)" if prd_id==128960
replace sub_id=10515 if prd_id==128960
replace substanzen="Betacaroten (10W)" if prd_id==128961
replace sub_id=12524 if prd_id==128961
replace substanzen="Heilerde + Schwefeldioxid" if prd_id==129533
replace sub_id=13374 if prd_id==129533
replace substanzen="Lutropin-Testzone (MAB) + Estron-3-glucuronid-Testzone (MAB)" if prd_id==130191
replace sub_id=5953 if prd_id==130191
replace substanzen="Trinkwasser (32W)" if prd_id==132326
replace sub_id=15565 if prd_id==132326
replace substanzen="Zinkoxid" if prd_id==132329 | prd_id==219877
replace sub_id=9620 if prd_id==132329 | prd_id==219877
replace substanzen="Valeriana officinalis L. + Melissa officinalis L. + Passiflora incarnata L." if substanzen=="Melissa officinalis L. + Passiflora incarnata L. + Valeriana officinalis L."
replace sub_id=9376 if substanzen=="Valeriana officinalis L. + Melissa officinalis L. + Passiflora incarnata L."
replace substanzen="Eucalyptus globulus Labill. + Pinus sylvestris L. + Levomenthol" if prd_id==132702
replace sub_id=4205 if prd_id==132702
replace substanzen="Thymus vulgaris L. (4W)" if prd_id==132727
replace sub_id=8968 if prd_id==132727
replace substanzen="Picea abies (L.) Karst. + Methyl salicylat" if prd_id==132739
replace sub_id=15241 if substanzen=="Picea abies (L.) Karst. + Methyl salicylat"
replace substanzen="Chlorhexidin" if prd_id==133265
replace sub_id=2743 if prd_id==133265
replace substanzen="Thymus vulgaris L." if prd_id==133292 | prd_id==198676
replace sub_id=8966 if prd_id==133292 | prd_id==198676
replace substanzen="Mentha piperita L. + Citrus aurantium L. ssp. aurantium + DL-alpha-Tocopherol" if sub_id==6246
replace substanzen="Mentha piperita L. + Citrus aurantium L. ssp. aurantium + DL-alpha-Tocopherol" if prd_id==133862
replace sub_id=6246 if prd_id==133862
replace substanzen="Poloxamer + Lauroamphoacetat + Isopropylalkohol" if prd_id==135579
replace sub_id=7558 if prd_id==135579

replace substanzen="Phosphorsäure (20W)" if prd_id==135703
replace sub_id=15695 if prd_id==135703
replace substanzen="Trinkwasser (11W)" if prd_id==135751
replace sub_id=11591 if prd_id==135751
replace substanzen="Promethazin" if prd_id==136177
replace sub_id=7704 if prd_id==136177
replace substanzen="Protein (21W)" if prd_id==136653
replace sub_id=7751 if prd_id==136653
replace substanzen="Trinkwasser (17W)" if prd_id==136824
replace sub_id=12811 if prd_id==136824
replace substanzen="Ubidecarenon" if prd_id==137948
replace sub_id=9251 if prd_id==137948
replace substanzen="Poliglusam" if prd_id==139449
replace sub_id=13389 if prd_id==139449
replace substanzen="Poly(styrol-co-divinylbenzol)sulfonsäure (92:8), Natriumsalz" if substanzen=="Poly(styrol-co-divinylbenzol)sulfonsäure, Natriumsalz"
replace sub_id=15371 if substanzen=="Poly(styrol-co-divinylbenzol)sulfonsäure (92:8), Natriumsalz"
replace substanzen="Levomenthol + Cocamidopropyl betain + Natrium laureth sulfat" if prd_id==141081
replace sub_id=15059 if prd_id==141081
replace substanzen="Citronensäure, wasserfreie (6W)" if prd_id==141083
replace sub_id=2914 if prd_id==141083
replace substanzen="Placenta" if substanzen=="Plazenta"
replace sub_id=7475 if substanzen=="Placenta"
replace substanzen="Ovarium" if substanzen=="Follikel"
replace sub_id=6958 if substanzen=="Ovarium"
replace substanzen="Musculi lysat. bovis fetal. extractum lyophilisatum aquosum" if prd_id==141221
replace sub_id=13231 if prd_id==141221
replace substanzen="Auris interna lysat. bovis fetal. extractum lyophilisatum" if prd_id==141256
replace sub_id=13405 if prd_id==141256
replace substanzen="Lens lysat. bovis fetal. extractum lyophilisatum aquosum" if prd_id==141266
replace sub_id=13664 if prd_id==141266
replace substanzen="Aorta bovis tota" if prd_id==141271
replace sub_id=1019 if prd_id==141271
replace substanzen="Cor lysat. bovis fetal. extractum lyophilistaum aquosum + Ren + Aorta bovis tota" if prd_id==141280
replace sub_id=13303 if prd_id==141280
replace substanzen="Spinnwebenhaut + Adergeflecht + Gehirn-Rückenmark-Flüssigkeit" if prd_id==141285
replace sub_id=8580 if prd_id==141285
replace substanzen="Vesica fellea lysat. bovis juvenil extractum lyophilisatum aquosum" if prd_id==141304
replace sub_id=13240 if prd_id==141304
replace substanzen="Mamma lactans lysat. bovis maternal extractum lyophilisatum aquosum" if prd_id==141311
replace sub_id=14240 if prd_id==141311
replace substanzen="Vasa lysat. bovis fetal. extractum lyophilisatum aquosum" if prd_id==141321
replace sub_id=13639 if prd_id==141321
replace substanzen="Corpus vitreum" if prd_id==141352
replace sub_id=3177 if prd_id==141352
replace substanzen="Conjunctiva bovis" if prd_id==141372
replace sub_id=3139 if prd_id==141372
replace substanzen="Glycyrrhiza glabra L. + Ammoniumchlorid" if prd_id==141507
replace sub_id=4764 if prd_id==141507
replace substanzen="Methyl salicylat" if prd_id==141668
replace sub_id=15226 if substanzen=="Methyl salicylat" 

replace substanzen="Capsicum-Arten" if prd_id==141678
replace sub_id=2335 if prd_id==141678
replace substanzen="Spironolacton + Hydrochlorothiazid" if substanzen=="Hydrochlorothiazid + Spironolacton"
replace sub_id=8587 if substanzen=="Spironolacton + Hydrochlorothiazid"
replace substanzen="Rosa canina L. (5W)" if prd_id==144252
replace sub_id=8049 if prd_id==144252
replace substanzen="Cytisus scoparius HOM (5W)" if prd_id==144389
replace sub_id=3406 if prd_id==144389
replace substanzen="Methyl salicylat (7W)" if prd_id==147247
replace sub_id=15228 if substanzen=="Methyl salicylat (7W)"
replace substanzen="Natrium salicylat + Braunkohle-Extrakt + Picea abies (L.) Karst." if prd_id==147356
replace sub_id=10982 if prd_id==147356
replace substanzen="Pimpinella anisum L. (11W)" if prd_id==147433
replace sub_id=7398 if prd_id==147433
replace substanzen="Valeriana officinalis L. (4W)" if prd_id==147435
replace sub_id=9352 if prd_id==147435
replace substanzen="Foeniculum vulgare Mill. ssp. vulgare var. vulgare (5W)" if prd_id==147446
replace sub_id=12617 if prd_id==147446
replace substanzen="Betula pendula Roth (5W)" if prd_id==147459
replace sub_id=1840 if prd_id==147459
replace substanzen="Retinol (39W)" if prd_id==147596
replace sub_id=7961 if prd_id==147596
replace substanzen="Allium sativum L. + Viscum album L. + Crataegus laevigata (Poir.) DC." if substanzen=="Allium sativum L. + Crataegus laevigata (Poir.) DC. + Viscum album L."
replace sub_id=675 if substanzen=="Allium sativum L. + Viscum album L. + Crataegus laevigata (Poir.) DC."
replace substanzen="Lebertran + Hippoglossus hippoglossus L." if prd_id==148409
replace sub_id=5740 if prd_id==148409
replace substanzen="Mentha piperita L. (15W)" if prd_id==148969
replace sub_id=6233 if prd_id==148969
replace substanzen="Larix decidua Mill. (5W)" if prd_id==150736
replace sub_id=5688 if prd_id==150736
replace substanzen="Fettsäurealkylolamid (4W)" if prd_id==151386
replace sub_id=4343 if prd_id==151386
replace substanzen="Aminosäure (4W)" if prd_id==151402
replace sub_id=849 if prd_id==151402
replace substanzen="Aminosäure (6W)" if prd_id==151409
replace sub_id=850 if prd_id==151409
replace substanzen="Fettsäureester (6W)" if prd_id==151419 | prd_id==151430
replace sub_id=4344 if prd_id==151419 | prd_id==151430
replace substanzen="Siliciumdioxid" if prd_id==153388
replace sub_id=8439 if prd_id==153388
replace substanzen="Acidum silicicum" if prd_id==153561
replace sub_id=344 if prd_id==153561
replace substanzen="Isopropylalkohol (5W)" if prd_id==153947
replace sub_id=5416 if prd_id==153947
replace substanzen="Ethanol + Isopropylalkohol" if prd_id==155442
replace sub_id=	4127 if prd_id==155442
replace substanzen="Kalbsmilz-Ultrafiltrat, getrocknet, eiweißfrei" if prd_id==155586
replace sub_id=5483 if prd_id==155586
replace substanzen="Spirulina" if prd_id==156965
replace sub_id=8588 if prd_id==156965
replace substanzen="Plantago lanceolata L." if prd_id==157056
replace sub_id=7482 if prd_id==157056
replace substanzen="Hydroxyethylsalicylat + Arnica montana L." if prd_id==158031
replace sub_id=5175 if prd_id==158031
replace substanzen="Flucloxacillin" if prd_id==161175
replace sub_id=4366 if prd_id==161175
replace substanzen="Natrium benzoat (5W)" if prd_id==162525
replace sub_id=10979 if prd_id==162525
replace substanzen="Aloe vera (L.) Burm. f." if prd_id==162850
replace sub_id=14115 if prd_id==162850
replace substanzen="(R,R,R)-alpha-Tocopherol + Ascorbinsäure" if substanzen=="(R,R,R)-Â-Tocopherol + Ascorbinsäure"
replace sub_id=15284 if substanzen=="(R,R,R)-alpha-Tocopherol + Ascorbinsäure"
replace substanzen="Eucalyptus globulus Labill. + Mentha piperita L." if substanzen=="Mentha piperita L. + Eucalyptus globulus Labill."
replace sub_id=15669 if substanzen=="Eucalyptus globulus Labill. + Mentha piperita L."
replace substanzen="Polidocanol" if prd_id==169720
replace sub_id=12990 if prd_id==169720
replace substanzen="Tilidin + Naloxon" if prd_id==170416
replace sub_id=9017 if prd_id==170416

replace substanzen="Pinus sylvestris L. + Eucalyptus globulus Labill." if prd_id==173952
replace sub_id=7439 if prd_id==173952
replace substanzen="Harnstoff + DL-alpha-Tocopherol" if prd_id==175673
replace sub_id=4889 if prd_id==175673
replace substanzen="Aesculus hippocastanum L. (6W)" if prd_id==178807
replace sub_id=498 if prd_id==178807
replace substanzen="Allergen-Extrakte" if prd_id==181208
replace sub_id=641 if prd_id==181208
replace substanzen="Natriumchlorid" if prd_id==184114
replace sub_id=6641 if prd_id==184114
replace substanzen="Retinol + DL-alpha-Tocopherol + Betacaroten" if substanzen=="Retinol + DL-Â-Tocopherol + Betacaroten"
replace sub_id=15379 if substanzen=="Retinol + DL-alpha-Tocopherol + Betacaroten"
replace substanzen="Malpighia punicifolia L." if prd_id==185672
replace sub_id=6078 if prd_id==185672
replace substanzen="(R,R,R)-alpha-Tocopherol + Triticum aestivum L. emend. Fiori et Paol." if substanzen=="(R,R,R)-Â-Tocopherol + Triticum aestivum L. emend. Fiori et Paol."
replace sub_id=15288 if substanzen=="(R,R,R)-alpha-Tocopherol + Triticum aestivum L. emend. Fiori et Paol."
replace substanzen="Gentiana lutea L. (16W)" if prd_id==185941
replace sub_id=4612 if prd_id==185941
replace substanzen="Zinkoxid + Salicylsäure" if prd_id==186935
replace sub_id=15406 if substanzen=="Zinkoxid + Salicylsäure"
replace substanzen="Salicylsäure (4W)" if prd_id==186936
replace sub_id=15381 if substanzen=="Salicylsäure (4W)"
replace substanzen="Salicylsäure + Dithranol" if prd_id==186942
replace sub_id=15382 if substanzen=="Salicylsäure + Dithranol"
replace substanzen="Triticum aestivum L. emend. Fiori et Paol." if prd_id==187600 | prd_id==187613
replace sub_id=9166 if prd_id==187600 | prd_id==187613
replace substanzen="Calendula officinalis L. + Allantoin + DL-alpha-Tocopherol" if prd_id==187642
replace sub_id=15306 if prd_id==187642
replace substanzen="Trinkwasser (15W)" if prd_id==187754
replace sub_id=15147 if prd_id==187754
replace substanzen="Simmondsia chinensis (Link) C.K. Schneider (11W)" if prd_id==187773
replace sub_id=15115 if prd_id==187773
replace substanzen="Peressigsäure" if prd_id==188622
replace sub_id=7202 if prd_id==188622
replace substanzen="Pinus mugo Turra (9W)" if prd_id==188873
replace sub_id=14185 if prd_id==188873
replace substanzen="Chamomilla recutita (L.) Rauschert" if prd_id==188879
replace sub_id=2616 if prd_id==188879
replace substanzen="Mentha piperita L." if prd_id==188893 | prd_id==333756
replace sub_id=6229 if prd_id==188893 | prd_id==333756
replace substanzen="Salvia officinalis L." if prd_id==188898
replace sub_id=8223 if prd_id==188898
replace substanzen="Achillea millefolium L." if prd_id==188900
replace sub_id=159 if prd_id==188900
replace substanzen="Crataegus laevigata (Poir.) DC." if prd_id==188907
replace sub_id=3212 if prd_id==188907
replace substanzen="Zwiebel-Ã–lmazerat" if substanzen=="Allium cepa L."
replace sub_id=15774 if substanzen=="Zwiebel-Ã–lmazerat"
replace substanzen="Secretin (Schwein)" if prd_id==202140
replace sub_id=15828 if prd_id==202140
replace substanzen="Trypsin" if prd_id==202266
replace sub_id=13010 if prd_id==202266
replace substanzen="Berberis vulgaris HOM + Colchicum autumnale HOM + Formica rufa HOM" if prd_id==203510
replace sub_id=15650 if substanzen=="Berberis vulgaris HOM + Colchicum autumnale HOM + Formica rufa HOM"
replace substanzen="Salmo salar L." if prd_id==204318
replace sub_id=14931 if prd_id==204318
replace substanzen="Hypromellose (5W)" if prd_id==205658
replace sub_id=5256 if prd_id==205658

*HERE
replace substanzen="Benzalkonium-Kation" if prd_id==206391
replace sub_id=14334 if prd_id==206391
replace substanzen="Glycyrrhiza glabra L. + Ammoniumchlorid" if prd_id==206621
replace sub_id=4764 if prd_id==206621
replace substanzen="Carmellose (5W)" if prd_id==211970
replace sub_id=11360 if prd_id==211970
replace substanzen="Mentha piperita L. (4W)" if prd_id==214502
replace sub_id=6234 if prd_id==214502
replace substanzen="Ethanol (5W)" if prd_id==219455
replace sub_id=4118 if prd_id==219455
replace substanzen="Pollen" if prd_id==219483
replace sub_id=14198 if prd_id==219483
replace substanzen="Chamomilla recutita (L.) Rauschert" if prd_id==219511
replace sub_id=2616 if prd_id==219511
replace substanzen="Lavandula angustifolia Mill." if prd_id==219746
replace sub_id=5719 if prd_id==219746
replace substanzen="Ascorbinsäure (21W)" if prd_id==222284
replace sub_id=15490 if prd_id==222284
replace substanzen="Zink gluconat-x-Wasser + Ascorbinsäure" if prd_id==222478
replace sub_id=15567 if prd_id==222478
replace substanzen="Jojobaester + Aloe vera (L.) Burm. f." if prd_id==223670
replace sub_id=14770 if prd_id==223670
replace substanzen="Salicylsäure" if prd_id==224577
replace sub_id=8153 if prd_id==224577
replace substanzen="Siliciumdioxid" if prd_id==231332
replace sub_id=8439 if prd_id==231332
replace substanzen="Troponin I-Testzone" if prd_id==235204
replace sub_id=9189 if prd_id==235204
replace substanzen="Glycine max (L.) Merr." if prd_id==239255
replace sub_id=4737 if prd_id==239255
replace substanzen="Blut-Testmedium" if prd_id==240633 | prd_id==284561
replace sub_id=12819 if prd_id==240633 | prd_id==284561
replace substanzen="Ascorbinsäure (18W)" if prd_id==241073
replace sub_id=1408 if prd_id==241073
replace substanzen="Biotin" if prd_id==246676
replace sub_id=1883 if prd_id==246676
replace substanzen="Kalium chloratum" if prd_id==251260
replace sub_id=5504 if prd_id==251260
replace substanzen="Corallium rubrum HOM" if prd_id==255349
replace sub_id=12048 if prd_id==255349
replace substanzen="Cyclamen europaeum HOM" if prd_id==255402
replace sub_id=12089 if prd_id==255402
replace substanzen="Drosera HOM" if prd_id==255469
replace sub_id=3772 if prd_id==255469
replace substanzen="Gelsemium sempervirens HOM" if prd_id==255586
replace sub_id=11445 if prd_id==255586
replace substanzen="Hamamelis virginiana HOM" if prd_id==255612
replace sub_id=11469 if prd_id==255612
replace substanzen="Propolis HOM" if prd_id==256205
replace sub_id=7716 if prd_id==256205
replace substanzen="Rumex crispus HOM" if prd_id==256300
replace sub_id=10142 if prd_id==256300
replace substanzen="Urtica urens HOM" if prd_id==256826
replace sub_id=9301 if prd_id==256826
replace substanzen="Viola tricolor HOM" if prd_id==256964
replace sub_id=9481 if prd_id==256964
replace substanzen="Mentha piperita L. (5W)" if prd_id==258535
replace sub_id=6235 if prd_id==258535
replace substanzen="Pinus mugo Turra (5W)" if prd_id==258763
replace sub_id=14182 if prd_id==258763
replace substanzen="Ledum palustre HOM (10W)" if prd_id==259186
replace sub_id=11882 if prd_id==259186
replace substanzen="Gentiana lutea HOM + Myristica fragrans HOM + Strychnos nux-vomica HOM" if prd_id==259582
replace sub_id=15677 if substanzen=="Gentiana lutea HOM + Myristica fragrans HOM + Strychnos nux-vomica HOM"
replace substanzen="Calciumcarbonat (10W)" if prd_id==259619
replace sub_id=15304 if prd_id==259619
replace substanzen="DL-alpha-Tocopherol" if prd_id==264269
replace sub_id=3716 if prd_id==264269
replace substanzen="Diclofenac" if prd_id==264857
replace sub_id=3563 if prd_id==264857
replace substanzen="Dimethylether" if prd_id==264858
replace sub_id=14722 if prd_id==264858

replace substanzen="Polidocanol + 4-Hexylresorcin" if prd_id==265000
replace sub_id=12993 if prd_id==265000
replace substanzen="Salvia officinalis L." if prd_id==267171
replace sub_id=8223 if prd_id==267171
replace substanzen="Lavandula angustifolia Mill." if prd_id==275163
replace sub_id=5719 if prd_id==275163
replace substanzen="Natriumfluorid" if prd_id==275987
replace sub_id=12733 if prd_id==275987
replace substanzen="Macrogol (4W)" if prd_id==276591
replace sub_id=6008 if prd_id==276591
replace substanzen="Panax ginseng C. A. Meyer + Bienenköniginnen-Futtersaft + (R,R,R)-alpha-Tocopherol" if prd_id==279338
replace sub_id=15363 if prd_id==279338
replace substanzen="Glucose" if prd_id==284345 | prd_id==284351
replace sub_id=4680  if prd_id==284345 | prd_id==284351
replace substanzen="Vitamin D-Hefe-Extrakt, ethanolisch, wässrig (4W)" if prd_id==286784
replace sub_id=11937 if prd_id==286784
replace substanzen="Calciumcarbonat (22W)" if prd_id==290002
replace sub_id=14865 if prd_id==290002
replace substanzen="Chrom(III)-chlorid (10W)" if prd_id==294883
replace sub_id=14757 if prd_id==294883
replace substanzen="Retinol (12W)" if prd_id==297463
replace sub_id=7949 if prd_id==297463
replace substanzen="Valeriana officinalis L." if prd_id==301568
replace sub_id=9349 if prd_id==301568
replace substanzen="Streptococcus haemolyticus ß Gruppe A-Testzone" if prd_id==302174
replace sub_id=8634 if prd_id==302174
replace substanzen="Zink gluconat-x-Wasser + Histidin" if prd_id==309563
replace sub_id=15569 if prd_id==309563
replace substanzen="Trifolium pratense L. + Malpighia punicifolia L." if prd_id==310587
replace sub_id=12810 if prd_id==310587
replace substanzen="Sulfur" if prd_id==310799
replace sub_id=8717 if prd_id==310799
replace substanzen="Folsäure + Pyridoxin + Cyanocobalamin" if prd_id==310859
replace sub_id=13280 if prd_id==310859
replace substanzen="Cassia angustifolia Vahl" if prd_id==314144
replace sub_id=2445 if prd_id==314144
replace substanzen="Harpagophytum procumbens (Burch.) DC." if prd_id==333964
replace sub_id=4907 if prd_id==333964
replace substanzen="Salicylsäure" if prd_id==342898
replace sub_id=8153 if prd_id==342898
replace substanzen="Insulin-Isophan (human)" if substanzen=="Insulin-Isophan"
replace sub_id=13533 if substanzen=="Insulin-Isophan (human)"
replace substanzen="Insulin, normal (human) + Insulin-Isophan (human)" if prd_id==344637
replace sub_id=13527 if prd_id==344637
replace substanzen="Insulin, normal (human) + Insulin-Isophan (human)" if substanzen=="Insulin, normal + Insulin-Isophan"
replace sub_id=13527 if substanzen=="Insulin, normal (human) + Insulin-Isophan (human)"
replace substanzen="Insulin, normal (human)" if prd_id==344838
replace sub_id=13526 if prd_id==344838
replace substanzen="Coffein" if prd_id==344851
replace sub_id=3056 if prd_id==344851
replace substanzen="Olivenöl, natives" if substanzen=="Olea europaea L."
replace sub_id=13132 if substanzen=="Olivenöl, natives"
replace substanzen="Cor lysat. bovis fetal. extractum lyophilistaum aquosum" if prd_id==347751
replace sub_id=13159 if prd_id==347751
replace substanzen="Cutis lysat. bovis fetal. extractum lyophilisatum aquosum" if prd_id==354303
replace sub_id=13220 if prd_id==354303
replace substanzen="Retina + Chorioidea + Nervus opticus" if prd_id==354801
replace sub_id=13235 if prd_id==354801
replace substanzen="Edetinsäure (4W)" if prd_id==355397
replace sub_id=3872 if prd_id==355397
replace substanzen="Edetinsäure + 2-(Ethylmercurithio)benzoesäure + Puffer" if prd_id==355523
replace sub_id=3875 if prd_id==355523
replace substanzen="Lutropin-Testzone" if prd_id==355680
replace sub_id=5952 if prd_id==355680
replace substanzen="Glandula suprarenalis suis (4W)" if substanzen=="Milz (4W)"
replace sub_id=13752 if substanzen=="Glandula suprarenalis suis (4W)"
replace substanzen="Mucosa ventriculi" if prd_id==357522
replace sub_id=13255 if prd_id==357522
replace substanzen="Humulus lupulus L. (5W)" if prd_id==361566
replace sub_id=5071 if prd_id==361566
replace substanzen="Amorphophallus konjac Koch" if prd_id==361572
replace sub_id=15726 if prd_id==361572
replace substanzen="Trinkwasser (20W)" if prd_id==362486
replace sub_id=10526 if prd_id==362486
replace substanzen="Hydroxyethylsalicylat (5W)" if prd_id==363959
replace sub_id=5174 if prd_id==363959
replace substanzen="Escherichia coli (5W)" if prd_id==375396
replace sub_id=4071 if prd_id==375396
replace substanzen="Subtilisine A" if prd_id==380678
replace sub_id=12439 if prd_id==380678
replace substanzen="Acetylsalicylsäure" if prd_id==391376
replace sub_id=123 if prd_id==391376
replace substanzen="Koagulations-Testzone" if prd_id==399728
replace sub_id=5603 if prd_id==399728
replace substanzen="Glycine max (L.) Merr. + Triglyceride, mittelkettige + Omega-3-Säurentriglyceride" if substanze=="Glycine max (L.) Merr. + Omega-3-Säurentriglyceride + Triglyceride, mittelkettige"
replace sub_id=13984 if substanzen=="Glycine max (L.) Merr. + Triglyceride, mittelkettige + Omega-3-Säurentriglyceride"
replace substanzen="Meerwasser" if prd_id==400350
replace sub_id=6160 if prd_id==400350
replace substanzen="Zinkoxid (26W)" if prd_id==402117
replace sub_id=15621 if prd_id==402117
replace substanzen="Apis HOM + Atropa belladonna HOM + Formica rufa HOM" if prd_id==404269
replace sub_id=15636 if substanzen=="Apis HOM + Atropa belladonna HOM + Formica rufa HOM"
replace substanzen="Thymus vulgaris L. (7W)" if prd_id==415508
replace sub_id=8971 if prd_id==415508
replace substanzen="Mentha piperita L. + Syzygium aromaticum (L.) Merr. et L. M. Perry" if prd_id==415577
replace sub_id=6255 if prd_id==415577
replace substanzen="Solesalz, Bad Reichenhall + Dexpanthenol" if prd_id==418828
replace sub_id=15103 if prd_id==418828
replace substanzen="Retinol" if prd_id==422595
replace sub_id=7946 if prd_id==422595
replace substanzen="Arnica montana L." if prd_id==426760
replace sub_id=1259 if prd_id==426760
replace substanzen="Ascorbinsäure (19W)" if prd_id==429304
replace sub_id=1409 if prd_id==429304
replace substanzen="Aloe vera (L.) Burm. f. + Milchsäure" if prd_id==431526
replace sub_id=14744 if prd_id==431526
replace substanzen="Chondroitinsulfat aus Fisch (6W)" if prd_id==434473
replace sub_id=15082 if prd_id==434473
replace substanzen="Daptomycin" if prd_id==436025
replace sub_id=15427 if substanzen=="Daptomycin"
replace substanzen="Peginterferon alfa-2b" if prd_id==443048
replace sub_id=15548 if prd_id==443048
replace substanzen="Ricinus communis L." if substanzen=="Rizinusöl"
replace sub_id=15606 if substanzen=="Ricinus communis L."
replace substanzen="Zeolith" if substanzen=="Klinoptilolith" 
replace sub_id=15620 if substanzen=="Zeolith"
replace substanzen="Eupatorium perfoliatum HOM + Aconitum napellus HOM + Gelsemium sempervirens HOM" if prd_id==446396
replace sub_id=14971 if prd_id==446396
replace substanzen="Chlorhexidin" if prd_id==447062
replace sub_id=2743 if prd_id==447062
replace substanzen="Dexrazoxan" if prd_id==448569
replace sub_id=15037 if substanzen=="Dexrazoxan"
replace substanzen="Zinkoxid" if prd_id==462807
replace sub_id=9620 if prd_id==462807
replace substanzen="Trimagnesium dicitrat + Riboflavin" if prd_id==465522
replace sub_id=15614 if prd_id==465522
replace substanzen="Vitis vinifera L." if prd_id==484499
replace sub_id=9538 if prd_id==484499
replace substanzen="(S)-Milchsäure" if prd_id==501314
replace sub_id=20 if prd_id==501314
replace substanzen="Ethacridin" if prd_id==501352
replace sub_id=4111 if prd_id==501352
replace substanzen="D-Campher + Methyl salicylat + Benzyl nicotinat" if prd_id==501357
replace sub_id=15205 if substanzen=="D-Campher + Methyl salicylat + Benzyl nicotinat"
replace substanzen="Magnesium-Ion (7W)" if prd_id==501402
replace sub_id=14806 if prd_id==501402

generate substanzen2=subinstr(substanzen,"Â","alpha", .)
replace substanzen=substanzen2 if substanzen!=substanzen2
drop substanzen2

save npi_hist_clean.dta, replace




**3rd round data cleaning
use npi_hist_clean.dta, clear

**(1) Harmonize producer names/ids across across NPI DB05, DB06 and DB07
replace hersteller="Abbott" if hersteller=="Abbott alt"
replace hst_id=1166 if hersteller=="Abbott"
replace hersteller="Anthroposan" if hersteller=="Anthroposan Hm."
replace hst_id=48295 if hersteller=="Anthroposan"
replace hersteller="Biomonde" if hersteller=="Biomonde 1"
replace hst_id=2309 if hersteller=="Biomonde"
replace hersteller="Bock Pharma" if hersteller=="Bock"
replace hst_id=1096 if hersteller=="Bock Pharma"
replace hersteller="Care Diagnostic" if hersteller=="Care Diagnost."
replace hst_id=4555 if hersteller=="Care Diagnostic"
replace hersteller="Cephalon Ph." if hersteller=="Cephalon"
replace hst_id=7002 if hersteller=="Cephalon Ph."
replace hersteller="Eurim           >" if hersteller=="Eurim Ph.       >"
replace hst_id=72670 if hersteller=="Eurim           >"
replace hersteller="Concentra Cosm." if hersteller=="Concentra"
replace hst_id=2399 if hersteller=="Concentra Cosm."
replace hersteller="Dibropharm" if hersteller=="Dibropharm Arzn"
replace hst_id=497 if hersteller=="Dibropharm"
replace hst_id=8650 if hersteller=="Fresenius Kabi"
replace hersteller="Haemato-Ph.H." if hersteller=="Haemato Pharm"
replace hst_id=3071 if hersteller=="Haemato-Ph.H."
replace hersteller="Kern-Pharma" if hersteller=="Kern Pharma     >"
replace hst_id=14790 if hersteller=="Kern-Pharma"
replace hersteller="Klatt Aktiv B." if hersteller=="Klatt"
replace hst_id=2502 if hersteller=="Klatt Aktiv B."
replace hersteller="Knoll" if hersteller=="Knoll Deutschl."
replace hst_id=15505 if hersteller=="Knoll"
replace hersteller="Kuenzle" if hersteller=="Kuenzle Kraeut."
replace hst_id=16472 if hersteller=="Kuenzle"
replace hersteller="Meda Pharma" if hersteller=="Meda"
replace hst_id=928 if hersteller=="Meda Pharma"
replace hersteller="Novapharm" if hersteller=="Novapharm 1"
replace hst_id=21140 if hersteller=="Novapharm"
replace hersteller="Omnimed" if hersteller=="Omnimed 1"
replace hst_id=664 if hersteller=="Omnimed"
replace hersteller="Novapharm" if hersteller=="Novapharm 1"
replace hst_id=21140 if hersteller=="Novapharm"
replace hersteller="Paesel+Lor." if hersteller=="Paesel+Lorei,P."
replace hst_id=22315 if hersteller=="Paesel+Lor."
replace hersteller="Reform Oelm.H." if hersteller=="Reform Oelmuehl"
replace hst_id=1857 if hersteller=="Reform Oelm.H."
replace hersteller="Serumw.Bernburg" if hersteller=="Serumw.Bernb.V."
replace hst_id=48110 if hersteller=="Serumw.Bernburg"
replace hersteller="Shire" if hersteller=="Shire Human"
replace hst_id=333 if hersteller=="Shire"
replace hersteller="The Ortho Comp." if hersteller=="The Ortho Comp"
replace hst_id=31209 if hersteller=="The Ortho Comp."

replace hersteller="Stada" if hersteller=="Stadapharm"
replace hersteller="Stada" if hersteller=="Stada Arzneim."
replace hst_id=50042 if hersteller=="Stada"
replace hersteller="Baxter" if hersteller=="Baxter Medicat."
replace hersteller="Baxter" if hersteller=="Baxter Oncolog."
replace hersteller="Baxter" if hersteller=="Baxter/Biosc."
replace hst_id=31462 if hersteller=="Baxter"
replace hersteller="Bayer" if hersteller=="Bayer Selbstm."
replace hersteller="Bayer" if hersteller=="Bayer Vital"
replace hst_id=2530 if hersteller=="Bayer"
replace hersteller="B.Braun" if hersteller=="Braun Mels."
replace hersteller="Kade" if hersteller=="Kade Konstanz"

replace hersteller_hist="Abbott" if hersteller_hist=="Abbott alt"
replace hst_hist_id=1166 if hersteller_hist=="Abbott"
replace hersteller_hist="Anthroposan" if hersteller_hist=="Anthroposan Hm."
replace hst_hist_id=48295 if hersteller_hist=="Anthroposan"
replace hersteller_hist="Astellas" if hersteller_hist=="Astellas,Yman."
replace hst_hist_id=2919 if hersteller_hist=="Astellas"
replace hersteller_hist="Biomonde" if hersteller_hist=="Biomonde 1"
replace hst_hist_id=2309 if hersteller_hist=="Biomonde"
replace hersteller_hist="Biomet Merck" if hersteller_hist=="Biomet Merck B."
replace hst_hist_id=449 if hersteller_hist=="Biomet Merck"
replace hersteller_hist="Bock Pharma" if hersteller_hist=="Bock"
replace hst_hist_id=1096 if hersteller_hist=="Bock Pharma"
replace hersteller_hist="Care Diagnostic" if hersteller_hist=="Care Diagnost."
replace hst_hist_id=4555 if hersteller_hist=="Care Diagnostic"
replace hersteller_hist="Cephalon Ph." if hersteller_hist=="Cephalon"
replace hst_hist_id=7002 if hersteller_hist=="Cephalon Ph."
replace hersteller_hist="Eurim" if hersteller_hist=="Eurim Ph."
replace hersteller_hist="Eurim" if hersteller_hist=="Eurim           >"
replace hst_hist_id=72670 if hersteller_hist=="Eurim"
replace hersteller_hist="Concentra Cosm." if hersteller_hist=="Concentra"
replace hst_hist_id=2399 if hersteller_hist=="Concentra Cosm."
replace hersteller_hist="Dibropharm" if hersteller_hist=="Dibropharm Arzn"
replace hst_hist_id=497 if hersteller_hist=="Dibropharm"
replace hersteller_hist="Emra-Med" if hersteller_hist=="Emra-Med        >"
replace hst_hist_id=8650 if hersteller_hist=="Fresenius Kabi"
replace hersteller_hist="Haemato-Ph.H." if hersteller_hist=="Haemato Pharm"
replace hst_hist_id=3071 if hersteller_hist=="Haemato-Ph.H."
replace hersteller_hist="Fujisawa Dtl." if hersteller_hist=="Fujisawa"
replace hst_hist_id=15250 if hersteller_hist=="Fujisawa Dtl."
replace hersteller_hist="G&M Naturw." if hersteller_hist=="G&M"
replace hst_hist_id=3593 if hersteller_hist=="G&M Naturw."
replace hersteller_hist="Hoffmann-La Roche SM" if hersteller_hist=="Hoffm.LarocheSm"
replace hersteller_hist="Innothera CH" if hersteller_hist=="Innothera"
replace hst_hist_id=2397 if hersteller_hist=="Innothera CH"
replace hersteller_hist="Kern-Pharma" if hersteller_hist=="Kern Pharma"
replace hst_hist_id=14790 if hersteller_hist=="Kern-Pharma"
replace hersteller_hist="Klatt Aktiv B." if hersteller_hist=="Klatt"
replace hst_hist_id=2502 if hersteller_hist=="Klatt Aktiv B."
replace hersteller_hist="Knoll" if hersteller_hist=="Knoll Deutschl."
replace hst_hist_id=15505 if hersteller_hist=="Knoll"
replace hersteller_hist="Kuenzle" if hersteller_hist=="Kuenzle Kraeut."
replace hst_hist_id=16472 if hersteller_hist=="Kuenzle"
replace hersteller_hist="Lever Faberge" if hersteller_hist=="Lever,Hbg."
replace hst_hist_id=7280 if hersteller_hist=="Lever Faberge"
replace hersteller_hist="MW Ph.Q Pharm" if hersteller_hist=="MW Ph."
replace hst_hist_id=50038 if hersteller_hist=="MW Ph.Q Pharm"
replace hersteller_hist="Meda Pharma" if hersteller_hist=="Meda"
replace hst_hist_id=928 if hersteller_hist=="Meda Pharma"
replace hersteller_hist="Micro-Medic.In." if hersteller_hist=="Micro Medic.Hbg"
replace hst_hist_id=19657 if hersteller_hist=="Micro-Medic.In."
replace hersteller_hist="Novapharm" if hersteller_hist=="Novapharm 1"
replace hst_hist_id=21140 if hersteller_hist=="Novapharm"
replace hersteller_hist="Omnimed" if hersteller_hist=="Omnimed 1"
replace hst_hist_id=664 if hersteller_hist=="Omnimed"
replace hersteller_hist="Novapharm" if hersteller_hist=="Novapharm 1"
replace hst_hist_id=21140 if hersteller_hist=="Novapharm"
replace hersteller_hist="Paesel+Lor." if hersteller_hist=="Paesel+Lorei,P."
replace hst_hist_id=22315 if hersteller_hist=="Paesel+Lor."
replace hersteller_hist="Pharma Dessau" if hersteller_hist=="Pharma Dessau a"
replace hst_hist_id=842 if hersteller_hist=="Pharma Dessau"
replace hersteller_hist="Rabe Wulf" if hersteller_hist=="Rabe, Wulf"
replace hst_hist_id=199 if hersteller_hist=="Rabe Wulf"
replace hersteller_hist="Rauscher" if hersteller_hist=="Rauscher,Patt."
replace hst_hist_id=48327 if hersteller_hist=="Rauscher"
replace hersteller_hist="Reform Oelm.H." if hersteller_hist=="Reform Oelmuehl"
replace hst_hist_id=1857 if hersteller_hist=="Reform Oelm.H."
replace hersteller_hist="Serumw.Bernburg" if hersteller_hist=="Serumw.Bernb.V."
replace hst_hist_id=48110 if hersteller_hist=="Serumw.Bernburg"
replace hersteller_hist="Shire" if hersteller_hist=="Shire Human"
replace hst_hist_id=333 if hersteller_hist=="Shire"
replace hersteller_hist="The Ortho Comp." if hersteller_hist=="The Ortho Comp"
replace hst_hist_id=31209 if hersteller_hist=="The Ortho Comp."
replace hersteller_hist="Truw AM Vertr." if hersteller_hist=="Truw Arzneim."
replace hst_hist_id=542 if hersteller_hist=="Truw AM Vertr."

replace hersteller_hist="Stada" if hersteller_hist=="Stadapharm"
replace hersteller_hist="Stada" if hersteller_hist=="Stada Arzneim."
replace hst_hist_id=50042 if hersteller_hist=="Stada"
replace hersteller_hist="Baxter" if hersteller_hist=="Baxter Medicat."
replace hersteller_hist="Baxter" if hersteller_hist=="Baxter Oncolog."
replace hersteller_hist="Baxter" if hersteller_hist=="Baxter/Biosc."
replace hst_hist_id=31462 if hersteller_hist=="Baxter"
replace hersteller_hist="Bayer" if hersteller_hist=="Bayer Selbstm."
replace hersteller_hist="Bayer" if hersteller_hist=="Bayer Vital"
replace hst_hist_id=2530 if hersteller_hist=="Bayer"
replace hersteller_hist="B.Braun" if hersteller_hist=="Braun Mels."
replace hersteller_hist="Kade" if hersteller_hist=="Kade Konstanz"

replace konzern="Anthroposan" if konzern=="Anthroposan Hm."
replace konz_id=48295 if konzern=="Anthroposan"
replace konzern="Biomonde" if konzern=="Biomonde 1"
replace konz_id=2309 if konzern=="Biomonde"
replace konzern="Bock Pharma" if konzern=="Bock"
replace konz_id=1096 if konzern=="Bock Pharma"
replace konzern="Care Diagnostic" if konzern=="Care Diagnost."
replace konz_id=4555 if konzern=="Care Diagnostic"
replace konzern="Concentra Cosm." if konzern=="Concentra"
replace konz_id=2399 if konzern=="Concentra Cosm."
replace konzern="Curasan AG" if konzern=="Curasan" | konzern=="Curasan Benelux"
replace konz_id=1000079 if konzern=="Curasan AG"
replace konzern="Dibropharm" if konzern=="Dibropharm Arzn"
replace konz_id=497 if konzern=="Dibropharm"
replace konzern="Haemato-Ph.H." if konzern=="Haemato Pharm"
replace konz_id=3071 if konzern=="Haemato-Ph.H."
replace konzern="Johnson & Johnson" if konzern=="Johnson&J.OTC" 
replace konz_id=1000161 if konzern=="Johnson & Johnson"
replace konzern="Kern-Pharma" if konzern=="Kern Pharma"
replace konz_id=14790 if konzern=="Kern-Pharma"
replace konzern="Klatt Aktiv B." if konzern=="Klatt"
replace konz_id=2502 if konzern=="Klatt Aktiv B."
replace konzern="Novapharm" if konzern=="Novapharm 1"
replace konz_id=21140 if konzern=="Novapharm"
replace konzern="Omnimed" if konzern=="Omnimed 1"
replace konz_id=664 if konzern=="Omnimed"
replace konzern="Novapharm" if konzern=="Novapharm 1"
replace konz_id=21140 if konzern=="Novapharm"
replace konzern="Paesel+Lor." if konzern=="Paesel+Lorei,P."
replace konz_id=22315 if konzern=="Paesel+Lor."
replace konzern="Reform Oelm.H." if konzern=="Reform Oelmuehl"
replace konz_id=1857 if konzern=="Reform Oelm.H."
replace konzern="The Ortho Comp." if konzern=="The Ortho Comp"
replace konz_id=31209 if konzern=="The Ortho Comp."

**** duplicate parent firm IDs
replace konz_id=1000011 if konzern=="Allergan"
replace konz_id=20425 if konzern=="ME Pharma"
replace konz_id=1000267 if konzern=="Remy & Geiser"

**** correct parent Firm
generate year_form_launch=year(einfuehrung)
replace konzern="Schering AG" if konzern=="Bayer Schering" & year_form_launch!=2006 & hersteller=="Schering"
replace konzern="Schering AG" if konzern=="Bayer Schering" & year_form_launch!=2006 & hersteller=="Jenapharm"
replace konz_id=1000285 if konzern=="Schering AG" 
drop year_form_launch


**(2) Harmonize product names/ids across across NPI DB05, DB06 and DB07
replace prdo_id=206281 if produkt_pi=="Glucomen Sensor B/M"

replace produkt_pi="Maaloxan WTP *" if produkt=="Maaloxan WTP"
replace produkt_pi="Maaloxan WTP *" if produkt=="Maalox E-M"
replace produkt_pi="Maaloxan WTP *"  if produkt=="Maalox EUP"
replace produkt_pi="Maaloxan WTP *"  if produkt=="Maalox KHP"
replace produkt_pi="Maaloxan WTP *"  if produkt=="Maaloxan CCA "
replace produkt_pi="Maaloxan WTP *"  if produkt=="Maaloxan EUP"
replace produkt_pi="Maaloxan WTP *"  if produkt=="Maaloxan GER"
replace produkt_pi="Maaloxan WTP *"  if produkt=="Maaloxan KHP"
replace produkt_pi="Maaloxan WTP *"  if produkt=="Maaloxan MTK"
replace produkt_pi="Maaloxan WTP *"  if produkt=="Maaloxan PWT"

replace produkt_pi="Omnipaque *" if produkt=="Omnipaque BRA"
replace produkt_pi="Omnipaque *" if produkt=="Omnipaque KHP"
replace produkt_pi="Omnipaque *" if produkt=="Omnipaque MAP"
replace produkt_pi="Omnipaque *" if produkt=="Omnipaque MTK"
replace produkt_pi="Omnipaque *" if produkt=="Omnipaque SVP"
replace prdo_id=125709 if produkt=="Omnipaque *"

replace prdo_id=127576 if produkt=="Ovysmen *"
replace prdo_id=259727 if produkt_pi=="Pulmicort Topinasal *"
replace prdo_id=1156296 if produkt_pi=="Spalt *"
replace produkt_pi="Persantin KHP" if produkt=="Persantin KHP" 
replace prdo_id=130171 if produkt_pi=="Persantin KHP"

replace prd_id=1711 if produkt=="Abnobaviscum Abietis"
replace prd_id=1720 if produkt=="Abnobaviscum Aceris"
replace prd_id=1727 if produkt=="Abnobaviscum Amygdali"
replace prd_id=1736 if produkt=="Abnobaviscum Betulae"
replace prd_id=1743 if produkt=="Abnobaviscum Crataegi"
replace prd_id=1751 if produkt=="Abnobaviscum Fraxini"
replace prd_id=1759 if produkt=="Abnobaviscum Mali"
replace prd_id=1767 if produkt=="Abnobaviscum Pini"
replace prd_id=1775 if produkt=="Abnobaviscum Quercus"
replace produkt="Actovegin (C04A1)" if prd_id==4051
replace prd_id=501390 if produkt=="Maaloxan WTP"
replace prdo_id=501390 if produkt_pi=="Maaloxan WTP"
replace prdo_id=5013900 if produkt_pi=="Maaloxan WTP*"
replace prdo_id=99994 if produkt_pi=="Maaloxan KLS*"
replace produkt="Alpha Lipon Stada" if prd_id==501021
replace produkt_pi="Alpha Lipon Stada" if prdo_id==501021
replace prdo_id=501405 if produkt_pi=="Sonicare PLS"


replace prdo_id=474449 if produkt_pi=="Tysabri E-M"
replace produkt_pi="Actovegin (C04A1)" if prdo_id==4051
replace produkt_pi="Antra ATR *" if prdo_id==10337
replace produkt_pi="Arimidex *" if prdo_id==12292
replace produkt_pi="Berotec B.I (R03A4) *" if prdo_id==21025
replace produkt_pi="Crinone *" if prdo_id==42019
replace produkt_pi="Finalgon B.I" if prdo_id==61157 & hersteller=="Boehringer Ing."
replace produkt_pi="Finalgon B.I *" if prdo_id==61157 & hersteller=="Eurim           >"
replace prdo_id=61158 if produkt_pi=="Finalgon B.I *"
replace produkt_pi="Hismanal *" if prdo_id==75952
replace produkt_pi="Imodium J-C *" if prdo_id==81412
replace produkt_pi="Lyndiol *" if prdo_id==99829
replace produkt_pi="Ortho Novum *" if prdo_id==127163
replace produkt_pi="Resaltex *" if prdo_id==140797
replace produkt_pi="Stediril WYE (G03A1) *" if prdo_id==161367
replace produkt_pi="Yermonil *" if prdo_id==189349
replace produkt_pi="Yermonil" if prdo_id==189349 & hersteller=="Novartis Pharma"
replace prdo_id=1893490 if produkt_pi=="Yermonil"
replace produkt_pi="Suplasyn MKL" if prdo_id==241250 & hersteller=="Merckle Record."
replace produkt_pi="Suplasyn MKL *" if prdo_id==241250 & hersteller=="Actipart        >"
replace prdo_id=2412500 if produkt_pi=="Suplasyn MKL *"
replace produkt_pi="Finalgon THO *" if prdo_id==500900

**(3) Harmonize substance names/ids across across NPI DB05, DB06 and DB07
replace substanzen="(S)-Milchsäure" if sub_id==20 
replace substanzen="Acetylsalicylsäure" if sub_id==123 
replace substanzen="Aminosäure (6W)" if sub_id==850 
replace substanzen="Ascorbinsäure" if sub_id==1404
replace substanzen="Ascorbinsäure (15W)" if sub_id==1407 
replace substanzen="Bienenköniginnen-Futtersaft" if sub_id==1862 
replace substanzen="Citronensäure, wasserfreie (6W)" if sub_id==2914 
replace substanzen="Edetinsäure (4W)" if sub_id==3872 
replace substanzen="Edetinsäure + 2-(Ethylmercurithio)benzoesäure + Puffer" if sub_id==3875 
replace substanzen="Eisen(II)-sulfat + Folsäure" if sub_id==3929 
replace substanzen="Ethanol, vergällt" if sub_id==4131 
replace substanzen="Fettsäureester (6W)" if sub_id==4344 
replace substanzen="Peressigsäure" if sub_id==7202 
replace substanzen="Salicylsäure" if sub_id==8153 
replace substanzen="Salicylsäure + Milchsäure" if sub_id==8176 
replace substanzen="Streptococcus haemolyticus ß Gruppe A-Testzone" if sub_id==8634 
replace substanzen="Cyclaminsäure + Saccharin" if sub_id==11209 
replace substanzen="Olivenöl, natives" if sub_id==13132 
replace substanzen="Poly(styrol-co-divinylbenzol)sulfonsäure (92:8), Calciumsalz" if sub_id==15370 
replace substanzen="Eisen(II)-D-gluconat + Folsäure" if sub_id==15514 
replace substanzen="Zwiebel-Ã–lmazerat" if sub_id==15774 

replace sub_id=13477 if substanzen=="Carglumsäure"
replace sub_id=15188 if substanzen=="Alexandriner- und Tinnevelly-Sennesfrüchte-Trockenextrakt (3-4:1) (Alexandriner:Tinnevelly 5:1), Auszugsmittel: Wasser"

replace substanzen="Ascorbinsäure (18W)" if sub_id==1408
replace substanzen="Ascorbinsäure + Calcium lactogluconat + Calcium phosphinat" if sub_id==15492
replace substanzen="Methacrylsäuremethylester (5W)" if sub_id==15541

*correct drug type classification
tab gen_id
tab generika
replace gen_id=3 if substanzen=="Tamsulosin" & hersteller=="Astellas" & gen_id==2 & einfuehrung>=16833
replace generika="Originalprodukt" if substanzen=="Tamsulosin" & hersteller=="Astellas" & gen_id==3 & generika=="Generika" & einfuehrung>=16833
tab gen_id
tab generika

save npi_hist_clean.dta, replace



*** end of do file


