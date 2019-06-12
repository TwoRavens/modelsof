* Table 2

reg edu1816_pri_enrol pop1849_young pop1849_old area1816_qkm pop1816_cities_pc indu1819_texti_pc steam1849_mining_pc vieh1816_schaf_landvieh_pc occ1816_farm_laborer_t_pc buil1816_publ_pc chausseedummy trans1816_freight_pc land1849_ineq beeline_berlin beeline_london beeline_pcapital poland rel1816_prot_pc rel1816_jew_pc annexed posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed westphalenXannexed rheinXannexed, vce(cluster max_kreiskey1800)

* Marginal effects for annexed and provinces
lincom annexed + posenXannexed*.0778443 + brandenburgXannexed*.0988024 + pommernXannexed*.0778443 + sachsenXannexed*.1227545 + schlesienXannexed*.1706587 + westphalenXannexed*.1047904 + rheinXannexed*.1766467
lincom posen + posenXannexed*1.787346
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom sachsen + sachsenXannexed*1.74761
lincom schlesien + schlesienXannexed*1.744596
lincom westphalen + westphalenXannexed*1.752314
lincom rhein + rheinXannexed*1.802051

reg edu1816_pri_enrol pop1882_young pop1882_old area1816_qkm pop1816_cities_pc indu1819_texti_pc steam1849_mining_pc vieh1816_schaf_landvieh_pc occ1816_farm_laborer_t_pc buil1816_publ_pc chausseedummy trans1816_freight_pc land1849_ineq beeline_berlin beeline_london beeline_pcapital poland rel1816_prot_pc rel1816_jew_pc annexed posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed westphalenXannexed rheinXannexed, vce(cluster max_kreiskey1800)

* Marginal effects for annexed and provinces
lincom annexed + posenXannexed*.0778443 + brandenburgXannexed*.0988024 + pommernXannexed*.0778443 + sachsenXannexed*.1227545 + schlesienXannexed*.1706587 + westphalenXannexed*.1047904 + rheinXannexed*.1766467
lincom posen + posenXannexed*1.787346
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom sachsen + sachsenXannexed*1.74761
lincom schlesien + schlesienXannexed*1.744596
lincom westphalen + westphalenXannexed*1.752314
lincom rhein + rheinXannexed*1.802051

reg edu1816_pri_enrol pop1882_young pop1882_old fac1849_total_pc area1816_qkm pop1816_cities_pc indu1819_texti_pc steam1849_mining_pc vieh1816_schaf_landvieh_pc occ1816_farm_laborer_t_pc buil1816_publ_pc chausseedummy trans1816_freight_pc land1849_ineq beeline_berlin beeline_london beeline_pcapital poland rel1816_prot_pc rel1816_jew_pc annexed posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed westphalenXannexed rheinXannexed, vce(cluster max_kreiskey1800)

* Marginal effects for annexed and provinces
lincom annexed + posenXannexed*.0778443 + brandenburgXannexed*.0988024 + pommernXannexed*.0778443 + sachsenXannexed*.1227545 + schlesienXannexed*.1706587 + westphalenXannexed*.1047904 + rheinXannexed*.1766467
lincom posen + posenXannexed*1.787346
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom sachsen + sachsenXannexed*1.74761
lincom schlesien + schlesienXannexed*1.744596
lincom westphalen + westphalenXannexed*1.752314
lincom rhein + rheinXannexed*1.802051

* Table 3

* IV

ivreg2 fac1849_total_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed ( edu1849_adult_yos = edu1816_pri_enrol), cluster( max_kreiskey1800) endog( edu1849_adult_yos)

* Marginal effects for provinces
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom schlesien + schlesienXannexed*1.744596
lincom westphalenXannexed*1.752314

ivreg2 fac1849_other_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed ( edu1849_adult_yos = edu1816_pri_enrol), cluster( max_kreiskey1800) endog( edu1849_adult_yos)

* Marginal effects for provinces
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom schlesien + schlesienXannexed*1.744596
lincom westphalenXannexed*1.752314

ivreg2 fac1849_metal_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed ( edu1849_adult_yos = edu1816_pri_enrol), cluster( max_kreiskey1800) endog( edu1849_adult_yos)

* Marginal effects for provinces
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom schlesien + schlesienXannexed*1.744596
lincom westphalenXannexed*1.752314

ivreg2 fac1849_texti_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed ( edu1849_adult_yos = edu1816_pri_enrol), cluster( max_kreiskey1800) endog( edu1849_adult_yos)

* Marginal effects for provinces
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom schlesien + schlesienXannexed*1.744596
lincom westphalenXannexed*1.752314

* OLS

ivreg2 fac1849_total_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed edu1849_adult_yos, cluster( max_kreiskey1800)

* Marginal effects for provinces
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom schlesien + schlesienXannexed*1.744596
lincom westphalenXannexed*1.752314

ivreg2 fac1849_other_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed edu1849_adult_yos, cluster( max_kreiskey1800)

* Marginal effects for provinces
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom schlesien + schlesienXannexed*1.744596
lincom westphalenXannexed*1.752314

ivreg2 fac1849_metal_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed edu1849_adult_yos, cluster( max_kreiskey1800)

* Marginal effects for provinces
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom schlesien + schlesienXannexed*1.744596
lincom westphalenXannexed*1.752314

ivreg2 fac1849_texti_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed edu1849_adult_yos, cluster( max_kreiskey1800)

* Marginal effects for provinces
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom schlesien + schlesienXannexed*1.744596
lincom westphalenXannexed*1.752314

* Table 4

* Critical (absolute) value of DFBETA for identifying influential observations is 2/sqrt(334)

* IV

ivreg2 fac1849_total_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed (edu1849_adult_yos = edu1816_pri_enrol) if dfbeta49<2/sqrt(334) & dfbeta49>-2/sqrt(334), cluster(max_kreiskey1800) endog( edu1849_adult_yos)

ivreg2 fac1849_other_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed (edu1849_adult_yos = edu1816_pri_enrol) if dfbeta49<2/sqrt(334) & dfbeta49>-2/sqrt(334), cluster(max_kreiskey1800) endog( edu1849_adult_yos)

ivreg2 fac1849_metal_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed (edu1849_adult_yos = edu1816_pri_enrol) if dfbeta49<2/sqrt(334) & dfbeta49>-2/sqrt(334), cluster(max_kreiskey1800) endog( edu1849_adult_yos)

ivreg2 fac1849_texti_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed (edu1849_adult_yos = edu1816_pri_enrol) if dfbeta49<2/sqrt(334) & dfbeta49>-2/sqrt(334), cluster(max_kreiskey1800) endog( edu1849_adult_yos)

* OLS

ivreg2 fac1849_total_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed edu1849_adult_yos if dfbeta49<2/sqrt(334) & dfbeta49>-2/sqrt(334), cluster(max_kreiskey1800)

ivreg2 fac1849_other_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed edu1849_adult_yos if dfbeta49<2/sqrt(334) & dfbeta49>-2/sqrt(334), cluster(max_kreiskey1800)

ivreg2 fac1849_metal_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed edu1849_adult_yos if dfbeta49<2/sqrt(334) & dfbeta49>-2/sqrt(334), cluster(max_kreiskey1800)

ivreg2 fac1849_texti_pc beeline_berlin beeline_london rel1816_prot_pc pop1816_cities_pc indu1819_texti_pc occ1816_farm_laborer_t_pc buil1816_publ_pc brandenburg pommern schlesien rhein brandenburgXannexed pommernXannexed schlesienXannexed westphalenXannexed edu1849_adult_yos if dfbeta49<2/sqrt(334) & dfbeta49>-2/sqrt(334), cluster(max_kreiskey1800)

* Table 5

* IV

ivreg2 occ1882_total_pc fac1849_total_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed (edu1871_lit = edu1816_pri_enrol), cluster(max_kreiskey1800) endog( edu1871_lit)

* Marginal effects for provinces
lincom posen + posenXannexed*1.787346
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom sachsen + sachsenXannexed*1.74761
lincom schlesien + schlesienXannexed*1.744596
lincom rhein + rheinXannexed*1.802051

ivreg2 occ1882_other_pc fac1849_other_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed (edu1871_lit = edu1816_pri_enrol), cluster(max_kreiskey1800) endog( edu1871_lit)

* Marginal effects for provinces
lincom posen + posenXannexed*1.787346
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom sachsen + sachsenXannexed*1.74761
lincom schlesien + schlesienXannexed*1.744596
lincom rhein + rheinXannexed*1.802051

ivreg2 occ1882_metal_pc fac1849_metal_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed (edu1871_lit = edu1816_pri_enrol), cluster(max_kreiskey1800) endog( edu1871_lit)

* Marginal effects for provinces
lincom posen + posenXannexed*1.787346
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom sachsen + sachsenXannexed*1.74761
lincom schlesien + schlesienXannexed*1.744596
lincom rhein + rheinXannexed*1.802051

ivreg2 occ1882_texti_pc fac1849_texti_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed (edu1871_lit = edu1816_pri_enrol), cluster(max_kreiskey1800) endog( edu1871_lit)

* Marginal effects for provinces
lincom posen + posenXannexed*1.787346
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom sachsen + sachsenXannexed*1.74761
lincom schlesien + schlesienXannexed*1.744596
lincom rhein + rheinXannexed*1.802051

* OLS

ivreg2 occ1882_total_pc fac1849_total_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed edu1871_lit, cluster(max_kreiskey1800)

* Marginal effects for provinces
lincom posen + posenXannexed*1.787346
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom sachsen + sachsenXannexed*1.74761
lincom schlesien + schlesienXannexed*1.744596
lincom rhein + rheinXannexed*1.802051

ivreg2 occ1882_other_pc fac1849_other_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed edu1871_lit, cluster(max_kreiskey1800)

* Marginal effects for provinces
lincom posen + posenXannexed*1.787346
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom sachsen + sachsenXannexed*1.74761
lincom schlesien + schlesienXannexed*1.744596
lincom rhein + rheinXannexed*1.802051

ivreg2 occ1882_metal_pc fac1849_metal_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed edu1871_lit, cluster(max_kreiskey1800)

* Marginal effects for provinces
lincom posen + posenXannexed*1.787346
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom sachsen + sachsenXannexed*1.74761
lincom schlesien + schlesienXannexed*1.744596
lincom rhein + rheinXannexed*1.802051

ivreg2 occ1882_texti_pc fac1849_texti_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed edu1871_lit, cluster(max_kreiskey1800)

* Marginal effects for provinces
lincom posen + posenXannexed*1.787346
lincom brandenburg + brandenburgXannexed*1.650788
lincom pommern + pommernXannexed*1.688154
lincom sachsen + sachsenXannexed*1.74761
lincom schlesien + schlesienXannexed*1.744596
lincom rhein + rheinXannexed*1.802051

* Table 6

* Critical (absolute) value of DFBETA for identifying influential observations is 2/sqrt(334)

* IV

ivreg2 occ1882_total_pc fac1849_total_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed (edu1871_lit = edu1816_pri_enrol) if dfbeta4982<2/sqrt(334) & dfbeta4982>-2/sqrt(334), cluster(max_kreiskey1800) endog(edu1871_lit)

ivreg2 occ1882_other_pc fac1849_other_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed (edu1871_lit = edu1816_pri_enrol) if dfbeta4982<2/sqrt(334) & dfbeta4982>-2/sqrt(334), cluster(max_kreiskey1800) endog(edu1871_lit)

ivreg2 occ1882_metal_pc fac1849_metal_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed (edu1871_lit = edu1816_pri_enrol) if dfbeta4982<2/sqrt(334) & dfbeta4982>-2/sqrt(334), cluster(max_kreiskey1800) endog(edu1871_lit)

ivreg2 occ1882_texti_pc fac1849_texti_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed (edu1871_lit = edu1816_pri_enrol) if dfbeta4982<2/sqrt(334) & dfbeta4982>-2/sqrt(334), cluster(max_kreiskey1800) endog(edu1871_lit)

* OLS

ivreg2 occ1882_total_pc fac1849_total_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed edu1871_lit if dfbeta4982<2/sqrt(334) & dfbeta4982>-2/sqrt(334), cluster(max_kreiskey1800)

ivreg2 occ1882_other_pc fac1849_other_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed edu1871_lit if dfbeta4982<2/sqrt(334) & dfbeta4982>-2/sqrt(334), cluster(max_kreiskey1800)

ivreg2 occ1882_metal_pc fac1849_metal_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed edu1871_lit if dfbeta4982<2/sqrt(334) & dfbeta4982>-2/sqrt(334), cluster(max_kreiskey1800)

ivreg2 occ1882_texti_pc fac1849_texti_pc beeline_london rel1816_prot_pc area1816_qkm land1849_ineq steam1849_mining_pc pop1816_cities_pc indu1819_texti_pc vieh1816_schaf_landvieh_pc buil1816_publ_pc posen brandenburg pommern sachsen schlesien westphalen rhein posenXannexed brandenburgXannexed pommernXannexed schlesienXannexed sachsenXannexed rheinXannexed edu1871_lit if dfbeta4982<2/sqrt(334) & dfbeta4982>-2/sqrt(334), cluster(max_kreiskey1800)
