*Calculating CRI
*Mihaly Fazekas
*Gabor Kocsis
*****************

use "..\data\bjpols_replication_micro.dta", clear


*****generating CRI variables*****

tab ca_procedure, gen(ca_procedure)
tab nocft_new, gen(new_nocft)


***combined EU-wide CRI***

gen corr_submp=.
replace corr_submp=4 if subm_p>=0 & subm_p<=23
replace corr_submp=3 if subm_p>23 & subm_p<=51
replace corr_submp=2 if subm_p>51 & subm_p<=59
replace corr_submp=1 if subm_p>59 & subm_p<=1000 
replace corr_submp=5 if subm_p==.
replace corr_submp=6 if nocft==1
gen corr_decp=.
replace corr_decp=1 if dec_p>=0 & dec_p<=26
replace corr_decp=2 if dec_p>26 & dec_p<=176
replace corr_decp=3 if dec_p>176 & dec_p<=1000
replace corr_decp=4 if dec_p==.
replace corr_decp=5 if nocft==1
gen corr_wnonpr=.
replace corr_wnonpr=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=10
replace corr_wnonpr=2 if cft_nonprice_weight>10 & cft_nonprice_weight<=35
replace corr_wnonpr=3 if cft_nonprice_weight>35 & cft_nonprice_weight<=75
replace corr_wnonpr=4 if cft_nonprice_weight>75 & cft_nonprice_weight<=100
replace corr_wnonpr=5 if cft_nonprice_weight==.
replace corr_wnonpr=1 if ca_criterion==1


***national cri calculations***

gen corr_submp_it=. if anb_country=="IT"
replace corr_submp_it=4 if subm_p>=0 & subm_p<=33 & anb_country=="IT"
replace corr_submp_it=3 if subm_p>33 & subm_p<=47 & anb_country=="IT"
replace corr_submp_it=2 if subm_p>47 & subm_p<=62 & anb_country=="IT"
replace corr_submp_it=1 if subm_p>62 & subm_p<=1000 & anb_country=="IT"
replace corr_submp_it=5 if subm_p==. & anb_country=="IT"
replace corr_submp_it=6 if nocft==1 & anb_country=="IT"
gen corr_decp_it=. if anb_country=="IT"
replace corr_decp_it=1 if dec_p>=0 & dec_p<=114 & anb_country=="IT"
replace corr_decp_it=2 if dec_p>114 & dec_p<=200 & anb_country=="IT"
replace corr_decp_it=3 if dec_p>200 & dec_p<=10000 & anb_country=="IT"
replace corr_decp_it=4 if dec_p==. & anb_country=="IT"
replace corr_decp_it=5 if nocft==1 & anb_country=="IT"
gen corr_wnonpr_it=. if anb_country=="IT"
replace corr_wnonpr_it=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=40 & anb_country=="IT"
replace corr_wnonpr_it=2 if cft_nonprice_weight>40 & cft_nonprice_weight<=65 & anb_country=="IT"
replace corr_wnonpr_it=3 if cft_nonprice_weight>65 & cft_nonprice_weight<=100 & anb_country=="IT"
replace corr_wnonpr_it=4 if cft_nonprice_weight==. & anb_country=="IT"
replace corr_wnonpr_it=1 if ca_criterion==1 & anb_country=="IT"
gen corr_submp_uk=. if anb_country=="UK"
replace corr_submp_uk=4 if subm_p>=0 & subm_p<=27 & anb_country=="UK"
replace corr_submp_uk=3 if subm_p>27 & subm_p<=43 & anb_country=="UK"
replace corr_submp_uk=2 if subm_p>43 & subm_p<=53 & anb_country=="UK"
replace corr_submp_uk=1 if subm_p>53 & subm_p<=1000 & anb_country=="UK"
replace corr_submp_uk=5 if subm_p==. & anb_country=="UK"
replace corr_submp_uk=6 if nocft==1 & anb_country=="UK"
gen corr_decp_uk=. if anb_country=="UK"
replace corr_decp_uk=1 if dec_p>=0 & dec_p<=35 & anb_country=="UK"
replace corr_decp_uk=2 if dec_p>35 & dec_p<=164 & anb_country=="UK"
replace corr_decp_uk=3 if dec_p>164 & dec_p<=304 & anb_country=="UK"
replace corr_decp_uk=4 if dec_p>304 & dec_p<=10000 & anb_country=="UK"
replace corr_decp_uk=5 if dec_p==. & anb_country=="UK"
replace corr_decp_uk=6 if nocft==1 & anb_country=="UK"
gen corr_wnonpr_uk=. if anb_country=="UK"
replace corr_wnonpr_uk=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=10 & anb_country=="UK"
replace corr_wnonpr_uk=2 if cft_nonprice_weight>=10 & cft_nonprice_weight<=45 & anb_country=="UK"
replace corr_wnonpr_uk=3 if cft_nonprice_weight>45 & cft_nonprice_weight<=70 & anb_country=="UK"
replace corr_wnonpr_uk=4 if cft_nonprice_weight>70 & cft_nonprice_weight<=100 & anb_country=="UK"
replace corr_wnonpr_uk=5 if cft_nonprice_weight==. & anb_country=="UK"
replace corr_wnonpr_uk=1 if ca_criterion==1 & anb_country=="UK"
gen corr_submp_sk=. if anb_country=="SK"
replace corr_submp_sk=4 if subm_p>=0 & subm_p<=41 & anb_country=="SK"
replace corr_submp_sk=3 if subm_p>41 & subm_p<=48 & anb_country=="SK"
replace corr_submp_sk=2 if subm_p>48 & subm_p<=52 & anb_country=="SK"
replace corr_submp_sk=1 if subm_p>52 & subm_p<=1000 & anb_country=="SK"
replace corr_submp_sk=5 if subm_p==. & anb_country=="SK"
replace corr_submp_sk=6 if nocft==1 & anb_country=="SK"
gen corr_decp_sk=. if anb_country=="SK"
replace corr_decp_sk=1 if dec_p>=0 & dec_p<=39 & anb_country=="SK"
replace corr_decp_sk=2 if dec_p>39 & dec_p<=55 & anb_country=="SK"
replace corr_decp_sk=3 if dec_p>55 & dec_p<=68 & anb_country=="SK"
replace corr_decp_sk=4 if dec_p>68 & dec_p<=91 & anb_country=="SK"
replace corr_decp_sk=5 if dec_p>91 & dec_p<=10000 & anb_country=="SK"
replace corr_decp_sk=6 if dec_p==. & anb_country=="SK"
replace corr_decp_sk=7 if nocft==1 & anb_country=="SK"
gen corr_wnonpr_sk=. if anb_country=="SK"
replace corr_wnonpr_sk=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=25 & anb_country=="SK"
replace corr_wnonpr_sk=2 if cft_nonprice_weight>25 & cft_nonprice_weight<=45 & anb_country=="SK"
replace corr_wnonpr_sk=3 if cft_nonprice_weight>45 & cft_nonprice_weight<=66 & anb_country=="SK"
replace corr_wnonpr_sk=4 if cft_nonprice_weight>66 & cft_nonprice_weight<=100 & anb_country=="SK"
replace corr_wnonpr_sk=5 if cft_nonprice_weight==. & anb_country=="SK"
replace corr_wnonpr_sk=1 if ca_criterion==1 & anb_country=="SK"
gen corr_submp_ro=. if anb_country=="RO"
replace corr_submp_ro=4 if subm_p>=0 & subm_p<=25 & anb_country=="RO"
replace corr_submp_ro=3 if subm_p>25 & subm_p<=40 & anb_country=="RO"
replace corr_submp_ro=2 if subm_p>40 & subm_p<=50 & anb_country=="RO"
replace corr_submp_ro=1 if subm_p>50 & subm_p<=1000 & anb_country=="RO"
replace corr_submp_ro=5 if subm_p==. & anb_country=="RO"
replace corr_submp_ro=6 if nocft==1 & anb_country=="RO"
gen corr_decp_ro=. if anb_country=="RO"
replace corr_decp_ro=1 if dec_p>=0 & dec_p<=17 & anb_country=="RO"
replace corr_decp_ro=2 if dec_p>17 & dec_p<=25 & anb_country=="RO"
replace corr_decp_ro=3 if dec_p>25 & dec_p<=56 & anb_country=="RO"
replace corr_decp_ro=4 if dec_p>56 & dec_p<=10000 & anb_country=="RO"
replace corr_decp_ro=5 if dec_p==. & anb_country=="RO"
replace corr_decp_ro=6 if nocft==1 & anb_country=="RO"
gen corr_wnonpr_ro=. if anb_country=="RO"
replace corr_wnonpr_ro=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=20 & anb_country=="RO"
replace corr_wnonpr_ro=2 if cft_nonprice_weight>20 & cft_nonprice_weight<=49 & anb_country=="RO"
replace corr_wnonpr_ro=3 if cft_nonprice_weight>49 & cft_nonprice_weight<=100 & anb_country=="RO"
replace corr_wnonpr_ro=4 if cft_nonprice_weight==. & anb_country=="RO"
replace corr_wnonpr_ro=1 if ca_criterion==1 & anb_country=="RO"
gen corr_submp_bg=. if anb_country=="BG"
replace corr_submp_bg=4 if subm_p>=0 & subm_p<=28 & anb_country=="BG" 
replace corr_submp_bg=3 if subm_p>28 & subm_p<=34 & anb_country=="BG"
replace corr_submp_bg=2 if subm_p>34 & subm_p<=41 & anb_country=="BG"
replace corr_submp_bg=1 if subm_p>41 & subm_p<=1000 & anb_country=="BG" 
replace corr_submp_bg=5 if subm_p==. & anb_country=="BG" 
replace corr_submp_bg=6 if nocft==1 & anb_country=="BG"
gen corr_decp_bg=. if anb_country=="BG"
replace corr_decp_bg=1 if dec_p>=0 & dec_p<=27 & anb_country=="BG"
replace corr_decp_bg=2 if dec_p>27 & dec_p<=68 & anb_country=="BG"
replace corr_decp_bg=3 if dec_p>68 & dec_p<=91 & anb_country=="BG"
replace corr_decp_bg=4 if dec_p>91 & dec_p<=119 & anb_country=="BG"
replace corr_decp_bg=5 if dec_p>119 & dec_p<=10000 & anb_country=="BG"
replace corr_decp_bg=6 if dec_p==. & anb_country=="BG"
replace corr_decp_bg=7 if nocft==1 & anb_country=="BG"
gen corr_wnonpr_bg=. if anb_country=="BG"
replace corr_wnonpr_bg=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=100 & anb_country=="BG"
replace corr_wnonpr_bg=2 if cft_nonprice_weight==. & anb_country=="BG"
replace corr_wnonpr_bg=1 if ca_criterion==1 & anb_country=="BG"
gen corr_submp_de=. if anb_country=="DE"
replace corr_submp_de=3 if subm_p>=0 & subm_p<=37 & anb_country=="DE" 
replace corr_submp_de=2 if subm_p>37 & subm_p<=48 & anb_country=="DE" 
replace corr_submp_de=1 if subm_p>48 & subm_p<=1000 & anb_country=="DE" 
replace corr_submp_de=4 if subm_p==. & anb_country=="DE" 
replace corr_submp_de=5 if nocft==1 & anb_country=="DE" 
gen corr_decp_de=. if anb_country=="DE"
replace corr_decp_de=1 if dec_p>=0 & dec_p<=36 & anb_country=="DE"
replace corr_decp_de=2 if dec_p>36 & dec_p<=53 & anb_country=="DE"
replace corr_decp_de=3 if dec_p>53 & dec_p<=75 & anb_country=="DE"
replace corr_decp_de=4 if dec_p>75 & dec_p<=10000 & anb_country=="DE"
replace corr_decp_de=5 if dec_p==. & anb_country=="DE"
replace corr_decp_de=6 if nocft==1 & anb_country=="DE"
gen corr_wnonpr_de=. if anb_country=="DE"
replace corr_wnonpr_de=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=17 & anb_country=="DE"
replace corr_wnonpr_de=2 if cft_nonprice_weight>17 & cft_nonprice_weight<=47 & anb_country=="DE"
replace corr_wnonpr_de=3 if cft_nonprice_weight>47 & cft_nonprice_weight<=65 & anb_country=="DE"
replace corr_wnonpr_de=4 if cft_nonprice_weight>65 & cft_nonprice_weight<=100 & anb_country=="DE"
replace corr_wnonpr_de=5 if cft_nonprice_weight==. & anb_country=="DE"
replace corr_wnonpr_de=1 if ca_criterion==1 & anb_country=="DE"
gen corr_submp_es=. if anb_country=="ES"
replace corr_submp_es=4 if subm_p>=0 & subm_p<=38 & anb_country=="ES" 
replace corr_submp_es=3 if subm_p>38 & subm_p<=42 & anb_country=="ES"
replace corr_submp_es=2 if subm_p>42 & subm_p<=51 & anb_country=="ES" 
replace corr_submp_es=1 if subm_p>51 & subm_p<=1000 & anb_country=="ES" 
replace corr_submp_es=5 if subm_p==. & anb_country=="ES" 
replace corr_submp_es=6 if nocft==1 & anb_country=="ES" 
gen corr_decp_es=. if anb_country=="ES"
replace corr_decp_es=1 if dec_p>=0 & dec_p<=43 & anb_country=="ES"
replace corr_decp_es=2 if dec_p>43 & dec_p<=76 & anb_country=="ES"
replace corr_decp_es=3 if dec_p>76 & dec_p<=118 & anb_country=="ES"
replace corr_decp_es=4 if dec_p>118 & dec_p<=10000 & anb_country=="ES"
replace corr_decp_es=5 if dec_p==. & anb_country=="ES"
replace corr_decp_es=6 if nocft==1 & anb_country=="ES"
gen corr_wnonpr_es=. if anb_country=="ES"
replace corr_wnonpr_es=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=30 & anb_country=="ES"
replace corr_wnonpr_es=2 if cft_nonprice_weight>30 & cft_nonprice_weight<=45 & anb_country=="ES"
replace corr_wnonpr_es=3 if cft_nonprice_weight>45 & cft_nonprice_weight<=60 & anb_country=="ES"
replace corr_wnonpr_es=4 if cft_nonprice_weight>60 & cft_nonprice_weight<=85 & anb_country=="ES"
replace corr_wnonpr_es=5 if cft_nonprice_weight>85 & cft_nonprice_weight<=100 & anb_country=="ES"
replace corr_wnonpr_es=6 if cft_nonprice_weight==. & anb_country=="ES"
replace corr_wnonpr_es=1 if ca_criterion==1 & anb_country=="ES"
gen corr_submp_fr=. if anb_country=="FR"
replace corr_submp_fr=3 if subm_p>=0 & subm_p<=40 & anb_country=="FR" 
replace corr_submp_fr=2 if subm_p>40 & subm_p<=50 & anb_country=="FR" 
replace corr_submp_fr=1 if subm_p>50 & subm_p<=1000 & anb_country=="FR" 
replace corr_submp_fr=4 if subm_p==. & anb_country=="FR" 
replace corr_submp_fr=5 if nocft==1 & anb_country=="FR" 
gen corr_decp_fr=. if anb_country=="FR"
replace corr_decp_fr=1 if dec_p>=0 & dec_p<=46 & anb_country=="FR"
replace corr_decp_fr=2 if dec_p>46 & dec_p<=66 & anb_country=="FR"
replace corr_decp_fr=3 if dec_p>66 & dec_p<=155 & anb_country=="FR"
replace corr_decp_fr=4 if dec_p>155 & dec_p<=10000 & anb_country=="FR"
replace corr_decp_fr=5 if dec_p==. & anb_country=="FR"
replace corr_decp_fr=6 if nocft==1 & anb_country=="FR"
gen corr_wnonpr_fr=. if anb_country=="FR"
replace corr_wnonpr_fr=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=25 & anb_country=="FR"
replace corr_wnonpr_fr=2 if cft_nonprice_weight>25 & cft_nonprice_weight<=35 & anb_country=="FR"
replace corr_wnonpr_fr=3 if cft_nonprice_weight>35 & cft_nonprice_weight<=75 & anb_country=="FR"
replace corr_wnonpr_fr=4 if cft_nonprice_weight>75 & cft_nonprice_weight<=100 & anb_country=="FR"
replace corr_wnonpr_fr=5 if cft_nonprice_weight==. & anb_country=="FR"
replace corr_wnonpr_fr=1 if ca_criterion==1 & anb_country=="FR"
gen corr_submp_pl=. if anb_country=="PL"
replace corr_submp_pl=3 if subm_p>=0 & subm_p<=25 & anb_country=="PL" 
replace corr_submp_pl=2 if subm_p>25 & subm_p<=42 & anb_country=="PL" 
replace corr_submp_pl=1 if subm_p>42 & subm_p<=1000 & anb_country=="PL" 
replace corr_submp_pl=4 if subm_p==. & anb_country=="PL" 
replace corr_submp_pl=5 if nocft==1 & anb_country=="PL" 
gen corr_decp_pl=. if anb_country=="PL"
replace corr_decp_pl=1 if dec_p>=0 & dec_p<=18 & anb_country=="PL"
replace corr_decp_pl=2 if dec_p>18 & dec_p<=29 & anb_country=="PL"
replace corr_decp_pl=3 if dec_p>29 & dec_p<=63 & anb_country=="PL"
replace corr_decp_pl=4 if dec_p>63 & dec_p<=10000 & anb_country=="PL"
replace corr_decp_pl=5 if dec_p==. & anb_country=="PL"
replace corr_decp_pl=6 if nocft==1 & anb_country=="PL"
gen corr_wnonpr_pl=. if anb_country=="PL"
replace corr_wnonpr_pl=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=5 & anb_country=="PL"
replace corr_wnonpr_pl=2 if cft_nonprice_weight>5 & cft_nonprice_weight<=20 & anb_country=="PL"
replace corr_wnonpr_pl=3 if cft_nonprice_weight>20 & cft_nonprice_weight<=40 & anb_country=="PL"
replace corr_wnonpr_pl=4 if cft_nonprice_weight>40 & cft_nonprice_weight<=67 & anb_country=="PL"
replace corr_wnonpr_pl=5 if cft_nonprice_weight>67 & cft_nonprice_weight<=100 & anb_country=="PL"
replace corr_wnonpr_pl=6 if cft_nonprice_weight==. & anb_country=="PL"
replace corr_wnonpr_pl=1 if ca_criterion==1 & anb_country=="PL"
gen corr_submp_nl=. if anb_country=="NL"
replace corr_submp_nl=4 if subm_p>=0 & subm_p<=38 & anb_country=="NL" 
replace corr_submp_nl=3 if subm_p>38 & subm_p<=47 & anb_country=="NL" 
replace corr_submp_nl=2 if subm_p>47 & subm_p<=56 & anb_country=="NL" 
replace corr_submp_nl=1 if subm_p>56 & subm_p<=1000 & anb_country=="NL" 
replace corr_submp_nl=5 if subm_p==. & anb_country=="NL" 
replace corr_submp_nl=6 if nocft==1 & anb_country=="NL" 
gen corr_decp_nl=. if anb_country=="NL"
replace corr_decp_nl=1 if dec_p>=0 & dec_p<=34 & anb_country=="NL"
replace corr_decp_nl=2 if dec_p>34 & dec_p<=57 & anb_country=="NL"
replace corr_decp_nl=3 if dec_p>57 & dec_p<=87 & anb_country=="NL"
replace corr_decp_nl=4 if dec_p>87 & dec_p<=10000 & anb_country=="NL"
replace corr_decp_nl=5 if dec_p==. & anb_country=="NL"
replace corr_decp_nl=6 if nocft==1 & anb_country=="NL"
gen corr_wnonpr_nl=. if anb_country=="NL"
replace corr_wnonpr_nl=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=25 & anb_country=="NL"
replace corr_wnonpr_nl=2 if cft_nonprice_weight>25 & cft_nonprice_weight<=55 & anb_country=="NL"
replace corr_wnonpr_nl=3 if cft_nonprice_weight>55 & cft_nonprice_weight<=75 & anb_country=="NL"
replace corr_wnonpr_nl=4 if cft_nonprice_weight>75 & cft_nonprice_weight<=100 & anb_country=="NL"
replace corr_wnonpr_nl=5 if cft_nonprice_weight==. & anb_country=="NL"
replace corr_wnonpr_nl=1 if ca_criterion==1 & anb_country=="NL"
gen corr_submp_gr=. if anb_country=="GR"
replace corr_submp_gr=4 if subm_p>=0 & subm_p<=44 & anb_country=="GR" 
replace corr_submp_gr=3 if subm_p>44 & subm_p<=54 & anb_country=="GR"
replace corr_submp_gr=2 if subm_p>54 & subm_p<=65 & anb_country=="GR"
replace corr_submp_gr=1 if subm_p>65 & subm_p<=1000 & anb_country=="GR" 
replace corr_submp_gr=5 if subm_p==. & anb_country=="GR" 
replace corr_submp_gr=6 if nocft==1 & anb_country=="GR" 
gen corr_decp_gr=. if anb_country=="GR"
replace corr_decp_gr=1 if dec_p>=0 & dec_p<=78 & anb_country=="GR"
replace corr_decp_gr=2 if dec_p>78 & dec_p<=170 & anb_country=="GR"
replace corr_decp_gr=3 if dec_p>170 & dec_p<=290 & anb_country=="GR"
replace corr_decp_gr=4 if dec_p>290 & dec_p<=435 & anb_country=="GR"
replace corr_decp_gr=5 if dec_p>435 & dec_p<=10000 & anb_country=="GR"
replace corr_decp_gr=6 if dec_p==. & anb_country=="GR"
replace corr_decp_gr=7 if nocft==1 & anb_country=="GR"
gen corr_wnonpr_gr=. if anb_country=="GR"
replace corr_wnonpr_gr=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=5 & anb_country=="GR"
replace corr_wnonpr_gr=2 if cft_nonprice_weight>5 & cft_nonprice_weight<=20 & anb_country=="GR"
replace corr_wnonpr_gr=3 if cft_nonprice_weight>20 & cft_nonprice_weight<=40 & anb_country=="GR"
replace corr_wnonpr_gr=4 if cft_nonprice_weight>40 & cft_nonprice_weight<=67 & anb_country=="GR"
replace corr_wnonpr_gr=5 if cft_nonprice_weight>67 & cft_nonprice_weight<=100 & anb_country=="GR"
replace corr_wnonpr_gr=6 if cft_nonprice_weight==. & anb_country=="GR"
replace corr_wnonpr_gr=1 if ca_criterion==1 & anb_country=="GR"
gen corr_submp_dk=. if anb_country=="DK"
replace corr_submp_dk=5 if subm_p>=0 & subm_p<=35 & anb_country=="DK" 
replace corr_submp_dk=4 if subm_p>35 & subm_p<=43 & anb_country=="DK" 
replace corr_submp_dk=3 if subm_p>43 & subm_p<=51 & anb_country=="DK"
replace corr_submp_dk=2 if subm_p>51 & subm_p<=61 & anb_country=="DK"
replace corr_submp_dk=1 if subm_p>61 & subm_p<=1000 & anb_country=="DK" 
replace corr_submp_dk=6 if subm_p==. & anb_country=="DK" 
replace corr_submp_dk=7 if nocft==1 & anb_country=="DK" 
gen corr_decp_dk=. if anb_country=="DK"
replace corr_decp_dk=1 if dec_p>=0 & dec_p<=19 & anb_country=="DK"
replace corr_decp_dk=2 if dec_p>19 & dec_p<=39 & anb_country=="DK"
replace corr_decp_dk=3 if dec_p>39 & dec_p<=73 & anb_country=="DK"
replace corr_decp_dk=4 if dec_p>73 & dec_p<=123 & anb_country=="DK"
replace corr_decp_dk=5 if dec_p>123 & dec_p<=168 & anb_country=="DK"
replace corr_decp_dk=6 if dec_p>168 & dec_p<=10000 & anb_country=="DK"
replace corr_decp_dk=7 if dec_p==. & anb_country=="DK"
replace corr_decp_dk=8 if nocft==1 & anb_country=="DK"
gen corr_wnonpr_dk=. if anb_country=="DK"
replace corr_wnonpr_dk=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=15 & anb_country=="DK"
replace corr_wnonpr_dk=2 if cft_nonprice_weight>15 & cft_nonprice_weight<=45 & anb_country=="DK"
replace corr_wnonpr_dk=3 if cft_nonprice_weight>45 & cft_nonprice_weight<=65 & anb_country=="DK"
replace corr_wnonpr_dk=4 if cft_nonprice_weight>65 & cft_nonprice_weight<=100 & anb_country=="DK"
replace corr_wnonpr_dk=5 if cft_nonprice_weight==. & anb_country=="DK"
replace corr_wnonpr_dk=1 if ca_criterion==1 & anb_country=="DK"
gen corr_submp_at=. if anb_country=="AT"
replace corr_submp_at=4 if subm_p>=0 & subm_p<=20 & anb_country=="AT" 
replace corr_submp_at=3 if subm_p>20 & subm_p<=33 & anb_country=="AT"
replace corr_submp_at=2 if subm_p>33 & subm_p<=47 & anb_country=="AT" 
replace corr_submp_at=1 if subm_p>47 & subm_p<=1000 & anb_country=="AT" 
replace corr_submp_at=5 if subm_p==. & anb_country=="AT" 
replace corr_submp_at=6 if nocft==1 & anb_country=="AT" 
gen corr_decp_at=. if anb_country=="AT"
replace corr_decp_at=1 if dec_p>=0 & dec_p<=35 & anb_country=="AT"
replace corr_decp_at=2 if dec_p>35 & dec_p<=56 & anb_country=="AT"
replace corr_decp_at=3 if dec_p>56 & dec_p<=80 & anb_country=="AT"
replace corr_decp_at=4 if dec_p>80 & dec_p<=162 & anb_country=="AT"
replace corr_decp_at=5 if dec_p>162 & dec_p<=10000 & anb_country=="AT"
replace corr_decp_at=6 if dec_p==. & anb_country=="AT"
replace corr_decp_at=7 if nocft==1 & anb_country=="AT"
gen corr_wnonpr_at=. if anb_country=="AT"
replace corr_wnonpr_at=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=12 & anb_country=="AT"
replace corr_wnonpr_at=2 if cft_nonprice_weight>12 & cft_nonprice_weight<=39 & anb_country=="AT"
replace corr_wnonpr_at=3 if cft_nonprice_weight>39 & cft_nonprice_weight<=60 & anb_country=="AT"
replace corr_wnonpr_at=4 if cft_nonprice_weight>60 & cft_nonprice_weight<=100 & anb_country=="AT"
replace corr_wnonpr_at=5 if cft_nonprice_weight==. & anb_country=="AT"
replace corr_wnonpr_at=1 if ca_criterion==1 & anb_country=="AT"
gen corr_submp_be=. if anb_country=="BE"
replace corr_submp_be=4 if subm_p>=0 & subm_p<=17 & anb_country=="BE" 
replace corr_submp_be=3 if subm_p>17 & subm_p<=34 & anb_country=="BE"
replace corr_submp_be=2 if subm_p>34 & subm_p<=77 & anb_country=="BE" 
replace corr_submp_be=1 if subm_p>77 & subm_p<=1000 & anb_country=="BE" 
replace corr_submp_be=5 if subm_p==. & anb_country=="BE" 
replace corr_submp_be=6 if nocft==1 & anb_country=="BE" 
gen corr_decp_be=. if anb_country=="BE"
replace corr_decp_be=1 if dec_p>=0 & dec_p<=22 & anb_country=="BE"
replace corr_decp_be=2 if dec_p>22 & dec_p<=64 & anb_country=="BE"
replace corr_decp_be=3 if dec_p>64 & dec_p<=124 & anb_country=="BE"
replace corr_decp_be=4 if dec_p>124 & dec_p<=266 & anb_country=="BE"
replace corr_decp_be=5 if dec_p>266 & dec_p<=10000 & anb_country=="BE"
replace corr_decp_be=6 if dec_p==. & anb_country=="BE"
replace corr_decp_be=7 if nocft==1 & anb_country=="BE"
gen corr_wnonpr_be=. if anb_country=="BE"
replace corr_wnonpr_be=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=30 & anb_country=="BE"
replace corr_wnonpr_be=2 if cft_nonprice_weight>30 & cft_nonprice_weight<=58 & anb_country=="BE"
replace corr_wnonpr_be=3 if cft_nonprice_weight>58 & cft_nonprice_weight<=70 & anb_country=="BE"
replace corr_wnonpr_be=4 if cft_nonprice_weight>70 & cft_nonprice_weight<=100 & anb_country=="BE"
replace corr_wnonpr_be=5 if cft_nonprice_weight==. & anb_country=="BE"
replace corr_wnonpr_be=1 if ca_criterion==1 & anb_country=="BE"
gen corr_submp_si=. if anb_country=="SI"
replace corr_submp_si=4 if subm_p>=0 & subm_p<=38 & anb_country=="SI" 
replace corr_submp_si=3 if subm_p>38 & subm_p<=43 & anb_country=="SI" 
replace corr_submp_si=2 if subm_p>43 & subm_p<=50 & anb_country=="SI" 
replace corr_submp_si=1 if subm_p>50 & subm_p<=1000 & anb_country=="SI" 
replace corr_submp_si=5 if subm_p==. & anb_country=="SI" 
replace corr_submp_si=6 if nocft==1 & anb_country=="SI" 
gen corr_decp_si=. if anb_country=="SI"
replace corr_decp_si=1 if dec_p>=0 & dec_p<=23 & anb_country=="SI"
replace corr_decp_si=2 if dec_p>23 & dec_p<=30 & anb_country=="SI"
replace corr_decp_si=3 if dec_p>30 & dec_p<=51 & anb_country=="SI"
replace corr_decp_si=4 if dec_p>51 & dec_p<=76 & anb_country=="SI"
replace corr_decp_si=5 if dec_p>76 & dec_p<=10000 & anb_country=="SI"
replace corr_decp_si=6 if dec_p==. & anb_country=="SI"
replace corr_decp_si=7 if nocft==1 & anb_country=="SI"
gen corr_wnonpr_si=. if anb_country=="SI"
replace corr_wnonpr_si=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=15 & anb_country=="SI"
replace corr_wnonpr_si=2 if cft_nonprice_weight>15 & cft_nonprice_weight<=25 & anb_country=="SI"
replace corr_wnonpr_si=3 if cft_nonprice_weight>25 & cft_nonprice_weight<=60 & anb_country=="SI"
replace corr_wnonpr_si=4 if cft_nonprice_weight>60 & cft_nonprice_weight<=100 & anb_country=="SI"
replace corr_wnonpr_si=5 if cft_nonprice_weight==. & anb_country=="SI"
replace corr_wnonpr_si=1 if ca_criterion==1 & anb_country=="SI"

gen corr_submp_ee=. if anb_country=="EE"
replace corr_submp_ee=6 if subm_p>=0 & subm_p<=32 & anb_country=="EE" 
replace corr_submp_ee=5 if subm_p>32 & subm_p<=39 & anb_country=="EE" 
replace corr_submp_ee=4 if subm_p>=39 & subm_p<=43 & anb_country=="EE" 
replace corr_submp_ee=3 if subm_p>43 & subm_p<=49 & anb_country=="EE" 
replace corr_submp_ee=2 if subm_p>49 & subm_p<57 & anb_country=="EE" 
replace corr_submp_ee=1 if subm_p>=57 & subm_p<=118 & anb_country=="EE" 
replace corr_submp_ee=7 if subm_p==. & anb_country=="EE" 
replace corr_submp_ee=8 if nocft==1 & anb_country=="EE" 
gen corr_decp_ee=. if anb_country=="EE"
replace corr_decp_ee=1 if dec_p>=0 & dec_p<=28 & anb_country=="EE"
replace corr_decp_ee=2 if dec_p>28 & dec_p<=41 & anb_country=="EE"
replace corr_decp_ee=3 if dec_p>41 & dec_p<=63 & anb_country=="EE"
replace corr_decp_ee=4 if dec_p>63 & dec_p<=85 & anb_country=="EE"
replace corr_decp_ee=5 if dec_p>85 & dec_p<=10000 & anb_country=="EE"
replace corr_decp_ee=6 if dec_p==. & anb_country=="EE"
replace corr_decp_ee=7 if nocft==1 & anb_country=="EE"
gen corr_wnonpr_ee=. if anb_country=="EE"
replace corr_wnonpr_ee=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=10 & anb_country=="EE"
replace corr_wnonpr_ee=2 if cft_nonprice_weight>10 & cft_nonprice_weight<=40 & anb_country=="EE"
replace corr_wnonpr_ee=3 if cft_nonprice_weight>40 & cft_nonprice_weight<=70 & anb_country=="EE"
replace corr_wnonpr_ee=4 if cft_nonprice_weight>70 & cft_nonprice_weight<=100 & anb_country=="EE"
replace corr_wnonpr_ee=5 if cft_nonprice_weight==. & anb_country=="EE"
replace corr_wnonpr_ee=1 if ca_criterion==1 & anb_country=="EE"
gen corr_submp_se=. if anb_country=="SE"
replace corr_submp_se=4 if subm_p>=0 & subm_p<=39 & anb_country=="SE"  
replace corr_submp_se=3 if subm_p>39 & subm_p<=45 & anb_country=="SE"
replace corr_submp_se=2 if subm_p>45 & subm_p<=60 & anb_country=="SE" 
replace corr_submp_se=1 if subm_p>60 & subm_p<=1000 & anb_country=="SE" 
replace corr_submp_se=5 if subm_p==. & anb_country=="SE" 
replace corr_submp_se=6 if nocft==1 & anb_country=="SE"
gen corr_decp_se=. if anb_country=="SE"
replace corr_decp_se=1 if dec_p>=0 & dec_p<=21 & anb_country=="SE"
replace corr_decp_se=2 if dec_p>21 & dec_p<=44 & anb_country=="SE"
replace corr_decp_se=3 if dec_p>44 & dec_p<=88 & anb_country=="SE"
replace corr_decp_se=4 if dec_p>88 & dec_p<=10000 & anb_country=="SE"
replace corr_decp_se=5 if dec_p==. & anb_country=="SE"
replace corr_decp_se=6 if nocft==1 & anb_country=="SE"
gen corr_wnonpr_se=. if anb_country=="SE"
replace corr_wnonpr_se=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=19 & anb_country=="SE"
replace corr_wnonpr_se=2 if cft_nonprice_weight>19 & cft_nonprice_weight<=30 & anb_country=="SE"
replace corr_wnonpr_se=3 if cft_nonprice_weight>30 & cft_nonprice_weight<=50 & anb_country=="SE"
replace corr_wnonpr_se=4 if cft_nonprice_weight>50 & cft_nonprice_weight<=75 & anb_country=="SE"
replace corr_wnonpr_se=5 if cft_nonprice_weight>75 & cft_nonprice_weight<=100 & anb_country=="SE"
replace corr_wnonpr_se=6 if cft_nonprice_weight==. & anb_country=="SE"
replace corr_wnonpr_se=1 if ca_criterion==1 & anb_country=="SE"
gen corr_submp_ie=. if anb_country=="IE"
replace corr_submp_ie=4 if subm_p>=0 & subm_p<=33 & anb_country=="IE"  
replace corr_submp_ie=3 if subm_p>33 & subm_p<=40 & anb_country=="IE"
replace corr_submp_ie=2 if subm_p>40 & subm_p<=45 & anb_country=="IE"
replace corr_submp_ie=1 if subm_p>45 & subm_p<=1000 & anb_country=="IE" 
replace corr_submp_ie=5 if subm_p==. & anb_country=="IE" 
replace corr_submp_ie=6 if nocft==1 & anb_country=="IE" 
gen corr_decp_ie=. if anb_country=="IE"
replace corr_decp_ie=1 if dec_p>=0 & dec_p<=50 & anb_country=="IE"
replace corr_decp_ie=2 if dec_p>50 & dec_p<=86 & anb_country=="IE"
replace corr_decp_ie=3 if dec_p>86 & dec_p<=128 & anb_country=="IE"
replace corr_decp_ie=4 if dec_p>128 & dec_p<=196 & anb_country=="IE"
replace corr_decp_ie=5 if dec_p>196 & dec_p<=10000 & anb_country=="IE"
replace corr_decp_ie=6 if dec_p==. & anb_country=="IE"
replace corr_decp_ie=7 if nocft==1 & anb_country=="IE"
gen corr_wnonpr_ie=. if anb_country=="IE"
replace corr_wnonpr_ie=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=20 & anb_country=="IE"
replace corr_wnonpr_ie=2 if cft_nonprice_weight>20 & cft_nonprice_weight<=40 & anb_country=="IE"
replace corr_wnonpr_ie=3 if cft_nonprice_weight>40 & cft_nonprice_weight<=65 & anb_country=="IE"
replace corr_wnonpr_ie=4 if cft_nonprice_weight>65 & cft_nonprice_weight<=75 & anb_country=="IE"
replace corr_wnonpr_ie=5 if cft_nonprice_weight>75 & cft_nonprice_weight<=100 & anb_country=="IE"
replace corr_wnonpr_ie=6 if cft_nonprice_weight==. & anb_country=="IE"
replace corr_wnonpr_ie=1 if ca_criterion==1 & anb_country=="IE"
gen corr_submp_cz=. if anb_country=="CZ"
replace corr_submp_cz=4 if subm_p>=0 & subm_p<=43 & anb_country=="CZ"  
replace corr_submp_cz=3 if subm_p>43 & subm_p<=50 & anb_country=="CZ"
replace corr_submp_cz=2 if subm_p>50 & subm_p<=58 & anb_country=="CZ"
replace corr_submp_cz=1 if subm_p>58 & subm_p<=1000 & anb_country=="CZ" 
replace corr_submp_cz=5 if subm_p==. & anb_country=="CZ" 
replace corr_submp_cz=6 if nocft==1 & anb_country=="CZ"
gen corr_decp_cz=. if anb_country=="CZ"
replace corr_decp_cz=1 if dec_p>=0 & dec_p<=33 & anb_country=="CZ"
replace corr_decp_cz=2 if dec_p>33 & dec_p<=55 & anb_country=="CZ"
replace corr_decp_cz=3 if dec_p>55 & dec_p<=79 & anb_country=="CZ"
replace corr_decp_cz=4 if dec_p>79 & dec_p<=147 & anb_country=="CZ"
replace corr_decp_cz=5 if dec_p>147 & dec_p<=10000 & anb_country=="CZ"
replace corr_decp_cz=6 if dec_p==. & anb_country=="CZ"
replace corr_decp_cz=7 if nocft==1 & anb_country=="CZ"
gen corr_wnonpr_cz=. if anb_country=="CZ"
replace corr_wnonpr_cz=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=10 & anb_country=="CZ"
replace corr_wnonpr_cz=2 if cft_nonprice_weight>10 & cft_nonprice_weight<=30 & anb_country=="CZ"
replace corr_wnonpr_cz=3 if cft_nonprice_weight>30 & cft_nonprice_weight<=60 & anb_country=="CZ"
replace corr_wnonpr_cz=4 if cft_nonprice_weight>60 & cft_nonprice_weight<=80 & anb_country=="CZ"
replace corr_wnonpr_cz=5 if cft_nonprice_weight>80 & cft_nonprice_weight<=100 & anb_country=="CZ"
replace corr_wnonpr_cz=6 if cft_nonprice_weight==. & anb_country=="CZ"
replace corr_wnonpr_cz=1 if ca_criterion==1 & anb_country=="CZ"
gen corr_submp_fi=. if anb_country=="FI"
replace corr_submp_fi=4 if subm_p>=0 & subm_p<=28 & anb_country=="FI"  
replace corr_submp_fi=3 if subm_p>28 & subm_p<=39 & anb_country=="FI"
replace corr_submp_fi=2 if subm_p>39 & subm_p<=51 & anb_country=="FI"
replace corr_submp_fi=1 if subm_p>51 & subm_p<=1000 & anb_country=="FI" 
replace corr_submp_fi=5 if subm_p==. & anb_country=="FI" 
replace corr_submp_fi=6 if nocft==1 & anb_country=="FI"
gen corr_decp_fi=. if anb_country=="FI"
replace corr_decp_fi=1 if dec_p>=0 & dec_p<=18 & anb_country=="FI"
replace corr_decp_fi=2 if dec_p>18 & dec_p<=42 & anb_country=="FI"
replace corr_decp_fi=3 if dec_p>42 & dec_p<=65 & anb_country=="FI"
replace corr_decp_fi=4 if dec_p>65 & dec_p<=91 & anb_country=="FI"
replace corr_decp_fi=5 if dec_p>91 & dec_p<=127 & anb_country=="FI"
replace corr_decp_fi=6 if dec_p>127 & dec_p<=10000 & anb_country=="FI"
replace corr_decp_fi=7 if dec_p==. & anb_country=="FI"
replace corr_decp_fi=8 if nocft==1 & anb_country=="FI"
gen corr_wnonpr_fi=. if anb_country=="FI"
replace corr_wnonpr_fi=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=20 & anb_country=="FI"
replace corr_wnonpr_fi=2 if cft_nonprice_weight>20 & cft_nonprice_weight<=55 & anb_country=="FI"
replace corr_wnonpr_fi=3 if cft_nonprice_weight>55 & cft_nonprice_weight<=79 & anb_country=="FI"
replace corr_wnonpr_fi=4 if cft_nonprice_weight>79 & cft_nonprice_weight<=100 & anb_country=="FI"
replace corr_wnonpr_fi=5 if cft_nonprice_weight==. & anb_country=="FI"
replace corr_wnonpr_fi=1 if ca_criterion==1 & anb_country=="FI"
gen corr_submp_hu=. if anb_country=="HU"
replace corr_submp_hu=5 if subm_p>=0 & subm_p<=31 & anb_country=="HU"
replace corr_submp_hu=4 if subm_p>31 & subm_p<=43 & anb_country=="HU"
replace corr_submp_hu=3 if subm_p>43 & subm_p<=49 & anb_country=="HU"
replace corr_submp_hu=2 if subm_p>49 & subm_p<=52 & anb_country=="HU"
replace corr_submp_hu=1 if subm_p>52 & subm_p<=1000 & anb_country=="HU" 
replace corr_submp_hu=6 if subm_p==. & anb_country=="HU" 
replace corr_submp_hu=7 if nocft==1 & anb_country=="HU"
gen corr_decp_hu=. if anb_country=="HU"
replace corr_decp_hu=1 if dec_p>=0 & dec_p<=29 & anb_country=="HU"
replace corr_decp_hu=2 if dec_p>29 & dec_p<=46 & anb_country=="HU"
replace corr_decp_hu=3 if dec_p>46 & dec_p<=72 & anb_country=="HU"
replace corr_decp_hu=4 if dec_p>72 & dec_p<=104 & anb_country=="HU"
replace corr_decp_hu=5 if dec_p>104 & dec_p<=10000 & anb_country=="HU"
replace corr_decp_hu=6 if dec_p==. & anb_country=="HU"
replace corr_decp_hu=7 if nocft==1 & anb_country=="HU"
gen corr_wnonpr_hu=. if anb_country=="HU"
replace corr_wnonpr_hu=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=14 & anb_country=="HU"
replace corr_wnonpr_hu=2 if cft_nonprice_weight>14 & cft_nonprice_weight<=35 & anb_country=="HU"
replace corr_wnonpr_hu=3 if cft_nonprice_weight>35 & cft_nonprice_weight<=59 & anb_country=="HU"
replace corr_wnonpr_hu=4 if cft_nonprice_weight>59 & cft_nonprice_weight<=92 & anb_country=="HU"
replace corr_wnonpr_hu=5 if cft_nonprice_weight>92 & cft_nonprice_weight<=100 & anb_country=="HU"
replace corr_wnonpr_hu=6 if cft_nonprice_weight==. & anb_country=="HU"
replace corr_wnonpr_hu=1 if ca_criterion==1 & anb_country=="HU"
gen corr_submp_no=. if anb_country=="NO"
replace corr_submp_no=5 if subm_p>=0 & subm_p<=35 & anb_country=="NO" 
replace corr_submp_no=4 if subm_p>35 & subm_p<=42 & anb_country=="NO"
replace corr_submp_no=3 if subm_p>42 & subm_p<=49 & anb_country=="NO"
replace corr_submp_no=2 if subm_p>49 & subm_p<=56 & anb_country=="NO"
replace corr_submp_no=1 if subm_p>56 & subm_p<=1000 & anb_country=="NO" 
replace corr_submp_no=6 if subm_p==. & anb_country=="NO" 
replace corr_submp_no=7 if nocft==1 & anb_country=="NO"
gen corr_decp_no=. if anb_country=="NO"
replace corr_decp_no=1 if dec_p>=0 & dec_p<=28 & anb_country=="NO"
replace corr_decp_no=2 if dec_p>28 & dec_p<=70 & anb_country=="NO"
replace corr_decp_no=3 if dec_p>70 & dec_p<=97 & anb_country=="NO"
replace corr_decp_no=4 if dec_p>97 & dec_p<=229 & anb_country=="NO"
replace corr_decp_no=5 if dec_p>229 & dec_p<=10000 & anb_country=="NO"
replace corr_decp_no=6 if dec_p==. & anb_country=="NO"
replace corr_decp_no=7 if nocft==1 & anb_country=="NO"
gen corr_wnonpr_no=. if anb_country=="NO"
replace corr_wnonpr_no=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=20 & anb_country=="NO"
replace corr_wnonpr_no=2 if cft_nonprice_weight>20 & cft_nonprice_weight<=50 & anb_country=="NO"
replace corr_wnonpr_no=3 if cft_nonprice_weight>50 & cft_nonprice_weight<=65 & anb_country=="NO"
replace corr_wnonpr_no=4 if cft_nonprice_weight>65 & cft_nonprice_weight<=100 & anb_country=="NO"
replace corr_wnonpr_no=5 if cft_nonprice_weight==. & anb_country=="NO"
replace corr_wnonpr_no=1 if ca_criterion==1 & anb_country=="NO"
gen corr_submp_pt=. if anb_country=="PT"
replace corr_submp_pt=3 if subm_p>=0 & subm_p<=30 & anb_country=="PT"
replace corr_submp_pt=2 if subm_p>=30 & subm_p<=42 & anb_country=="PT"
replace corr_submp_pt=2 if subm_p>42 & subm_p<=48 & anb_country=="PT"
replace corr_submp_pt=1 if subm_p>48 & subm_p<=1000 & anb_country=="PT" 
replace corr_submp_pt=5 if subm_p==. & anb_country=="PT" 
replace corr_submp_pt=6 if nocft==1 & anb_country=="PT"
gen corr_decp_pt=. if anb_country=="PT"
replace corr_decp_pt=1 if dec_p>=0 & dec_p<=37 & anb_country=="PT"
replace corr_decp_pt=2 if dec_p>37 & dec_p<=63 & anb_country=="PT"
replace corr_decp_pt=3 if dec_p>63 & dec_p<=81 & anb_country=="PT"
replace corr_decp_pt=3 if dec_p>81 & dec_p<=157 & anb_country=="PT"
replace corr_decp_pt=3 if dec_p>157 & dec_p<=242 & anb_country=="PT"
replace corr_decp_pt=4 if dec_p>242 & dec_p<=10000 & anb_country=="PT"
replace corr_decp_pt=5 if dec_p==. & anb_country=="PT"
replace corr_decp_pt=6 if nocft==1 & anb_country=="PT"
gen corr_submp_lt=. if anb_country=="LT"
replace corr_submp_lt=4 if subm_p>=0 & subm_p<=39 & anb_country=="LT" 
replace corr_submp_lt=3 if subm_p>39 & subm_p<=42 & anb_country=="LT"
replace corr_submp_lt=2 if subm_p>42 & subm_p<=47 & anb_country=="LT"
replace corr_submp_lt=1 if subm_p>47 & subm_p<=1000 & anb_country=="LT" 
replace corr_submp_lt=5 if subm_p==. & anb_country=="LT" 
replace corr_submp_lt=6 if nocft==1 & anb_country=="LT" 
gen corr_decp_lt=. if anb_country=="LT"
replace corr_decp_lt=1 if dec_p>=0 & dec_p<=22 & anb_country=="LT"
replace corr_decp_lt=2 if dec_p>22 & dec_p<=32 & anb_country=="LT"
replace corr_decp_lt=3 if dec_p>32 & dec_p<=48 & anb_country=="LT"
replace corr_decp_lt=4 if dec_p>48 & dec_p<=66 & anb_country=="LT"
replace corr_decp_lt=5 if dec_p>66 & dec_p<=96 & anb_country=="LT"
replace corr_decp_lt=6 if dec_p>96 & dec_p<=10000 & anb_country=="LT"
replace corr_decp_lt=7 if dec_p==. & anb_country=="LT"
replace corr_decp_lt=8 if nocft==1 & anb_country=="LT"
gen corr_wnonpr_lt=. if anb_country=="LT"
replace corr_wnonpr_lt=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=40 & anb_country=="LT"
replace corr_wnonpr_lt=2 if cft_nonprice_weight>40 & cft_nonprice_weight<=60 & anb_country=="LT"
replace corr_wnonpr_lt=3 if cft_nonprice_weight>60 & cft_nonprice_weight<=80 & anb_country=="LT"
replace corr_wnonpr_lt=4 if cft_nonprice_weight>80 & cft_nonprice_weight<=100 & anb_country=="LT"
replace corr_wnonpr_lt=5 if cft_nonprice_weight==. & anb_country=="LT"
replace corr_wnonpr_lt=1 if ca_criterion==1 & anb_country=="LT"
gen corr_submp_lv=. if anb_country=="LV"
replace corr_submp_lv=5 if subm_p>=0 & subm_p<=40 & anb_country=="LV" 
replace corr_submp_lv=4 if subm_p>40 & subm_p<=45 & anb_country=="LV"
replace corr_submp_lv=3 if subm_p>45 & subm_p<=50 & anb_country=="LV"
replace corr_submp_lv=2 if subm_p>50 & subm_p<=57 & anb_country=="LV"
replace corr_submp_lv=1 if subm_p>57 & subm_p<=1000 & anb_country=="LV" 
replace corr_submp_lv=6 if subm_p==. & anb_country=="LV" 
replace corr_submp_lv=7 if nocft==1 & anb_country=="LV"
gen corr_decp_lv=. if anb_country=="LV"
replace corr_decp_lv=1 if dec_p>=0 & dec_p<=20 & anb_country=="LV"
replace corr_decp_lv=2 if dec_p>20 & dec_p<=35 & anb_country=="LV"
replace corr_decp_lv=3 if dec_p>35 & dec_p<=56 & anb_country=="LV"
replace corr_decp_lv=4 if dec_p>56 & dec_p<=105 & anb_country=="LV"
replace corr_decp_lv=5 if dec_p>105 & dec_p<=10000 & anb_country=="LV"
replace corr_decp_lv=6 if dec_p==. & anb_country=="LV"
replace corr_decp_lv=7 if nocft==1 & anb_country=="LV"
gen corr_wnonpr_lv=. if anb_country=="LV"
replace corr_wnonpr_lv=1 if cft_nonprice_weight>=0 & cft_nonprice_weight<=20 & anb_country=="LV"
replace corr_wnonpr_lv=2 if cft_nonprice_weight>20 & cft_nonprice_weight<=60 & anb_country=="LV"
replace corr_wnonpr_lv=3 if cft_nonprice_weight>60 & cft_nonprice_weight<=80 & anb_country=="LV"
replace corr_wnonpr_lv=4 if cft_nonprice_weight>80 & cft_nonprice_weight<=100 & anb_country=="LV"
replace corr_wnonpr_lv=5 if cft_nonprice_weight==. & anb_country=="LV"
replace corr_wnonpr_lv=1 if ca_criterion==1 & anb_country=="LV"
gen corr_submp_cy=. if anb_country=="CY"
replace corr_submp_cy=5 if subm_p>=0 & subm_p<=42 & anb_country=="CY"
replace corr_submp_cy=4 if subm_p>42 & subm_p<=46 & anb_country=="CY"
replace corr_submp_cy=3 if subm_p>46 & subm_p<=52 & anb_country=="CY"
replace corr_submp_cy=2 if subm_p>52 & subm_p<=60 & anb_country=="CY"
replace corr_submp_cy=1 if subm_p>60 & subm_p<=1000 & anb_country=="CY"
replace corr_submp_cy=6 if subm_p==. & anb_country=="CY"
replace corr_submp_cy=7 if nocft==1 & anb_country=="CY"
gen corr_decp_cy=. if anb_country=="CY"
replace corr_decp_cy=1 if dec_p>=0 & dec_p<=58 & anb_country=="CY"
replace corr_decp_cy=2 if dec_p>58 & dec_p<=70 & anb_country=="CY"
replace corr_decp_cy=3 if dec_p>70 & dec_p<=90 & anb_country=="CY"
replace corr_decp_cy=4 if dec_p>90 & dec_p<=105 & anb_country=="CY"
replace corr_decp_cy=5 if dec_p>105 & dec_p<=10000 & anb_country=="CY"
replace corr_decp_cy=6 if dec_p==. & anb_country=="CY"
replace corr_decp_cy=7 if nocft==1 & anb_country=="CY"
gen corr_submp_lu=. if anb_country=="LU"
replace corr_submp_lu=4 if subm_p>=0 & subm_p<=50 & anb_country=="LU"
replace corr_submp_lu=3 if subm_p>50 & subm_p<=54 & anb_country=="LU"
replace corr_submp_lu=2 if subm_p>54 & subm_p<=85 & anb_country=="LU"
replace corr_submp_lu=1 if subm_p>85 & subm_p<1000 & anb_country=="LU"
replace corr_submp_lu=5 if subm_p==. & anb_country=="LU"
replace corr_submp_lu=6 if nocft_new==1 & anb_country=="LU"
gen corr_decp_lu=. if anb_country=="LU"
replace corr_decp_lu=1 if dec_p>=0 & dec_p<=52 & anb_country=="LU"
replace corr_decp_lu=2 if dec_p>52 & dec_p<=100 & anb_country=="LU"
replace corr_decp_lu=3 if dec_p>100 & dec_p<=10000 & anb_country=="LU"
replace corr_decp_lu=4 if dec_p==. & anb_country=="LU"
replace corr_decp_lu=5 if nocft_new==1 & anb_country=="LU"
gen corr_submp_ch=. if anb_country=="CH"
replace corr_submp_ch=4 if subm_p>=0 & subm_p<=30 & anb_country=="CH" 
replace corr_submp_ch=3 if subm_p>30 & subm_p<=42 & anb_country=="CH"
replace corr_submp_ch=2 if subm_p>42 & subm_p<=48 & anb_country=="CH"
replace corr_submp_ch=1 if subm_p>48 & subm_p<=1000 & anb_country=="CH" 
replace corr_submp_ch=5 if subm_p==. & anb_country=="CH" 
replace corr_submp_ch=6 if nocft==1 & anb_country=="CH"
gen corr_decp_ch=. if anb_country=="CH"
replace corr_decp_ch=1 if dec_p>=0 & dec_p<=40 & anb_country=="CH"
replace corr_decp_ch=2 if dec_p>40 & dec_p<=64 & anb_country=="CH"
replace corr_decp_ch=3 if dec_p>64 & dec_p<=85 & anb_country=="CH"
replace corr_decp_ch=4 if dec_p>85 & dec_p<=105 & anb_country=="CH"
replace corr_decp_ch=5 if dec_p>105 & dec_p<=10000 & anb_country=="CH"
replace corr_decp_ch=6 if dec_p==. & anb_country=="CH"
replace corr_decp_ch=7 if nocft==1 & anb_country=="CH"
gen corr_submp_hr=. if anb_country=="HR"
replace corr_submp_hr=3 if subm_p>=0 & subm_p<=40 & anb_country=="HR" 
replace corr_submp_hr=2 if subm_p>40 & subm_p<=48 & anb_country=="HR"
replace corr_submp_hr=1 if subm_p>48 & subm_p<=1000 & anb_country=="HR" 
replace corr_submp_hr=4 if subm_p==. & anb_country=="HR" 
replace corr_submp_hr=5 if nocft==1 & anb_country=="HR"
gen corr_decp_hr=. if anb_country=="HR"
replace corr_decp_hr=1 if dec_p>=0 & dec_p<=26 & anb_country=="HR"
replace corr_decp_hr=2 if dec_p>26 & dec_p<=59 & anb_country=="HR"
replace corr_decp_hr=3 if dec_p>59 & dec_p<=86 & anb_country=="HR"
replace corr_decp_hr=4 if dec_p>86 & dec_p<=125 & anb_country=="HR"
replace corr_decp_hr=5 if dec_p>125 & dec_p<=10000 & anb_country=="HR"
replace corr_decp_hr=6 if dec_p==. & anb_country=="HR"
replace corr_decp_hr=7 if nocft==1 & anb_country=="HR"


tab corr_submp, gen(corr_submp)
tab corr_submp_at, gen(corr_submp_at)
tab corr_submp_be, gen(corr_submp_be)
tab corr_submp_bg, gen(corr_submp_bg)
tab corr_submp_ch, gen(corr_submp_ch)
tab corr_submp_cy, gen(corr_submp_cy)
tab corr_submp_cz, gen(corr_submp_cz)
tab corr_submp_de, gen(corr_submp_de)
tab corr_submp_dk, gen(corr_submp_dk)
tab corr_submp_ee, gen(corr_submp_ee)
tab corr_submp_es, gen(corr_submp_es)
tab corr_submp_fi, gen(corr_submp_fi)
tab corr_submp_fr, gen(corr_submp_fr)
tab corr_submp_gr, gen(corr_submp_gr)
tab corr_submp_hr, gen(corr_submp_hr)
tab corr_submp_hu, gen(corr_submp_hu)
tab corr_submp_ie, gen(corr_submp_ie)
tab corr_submp_it, gen(corr_submp_it)
tab corr_submp_lt, gen(corr_submp_lt)
tab corr_submp_lu, gen(corr_submp_lu)
tab corr_submp_lv, gen(corr_submp_lv)
tab corr_submp_nl, gen(corr_submp_nl)
tab corr_submp_no, gen(corr_submp_no)
tab corr_submp_pl, gen(corr_submp_pl)
tab corr_submp_pt, gen(corr_submp_pt)
tab corr_submp_ro, gen(corr_submp_ro)
tab corr_submp_se, gen(corr_submp_se)
tab corr_submp_si, gen(corr_submp_si)
tab corr_submp_sk, gen(corr_submp_sk)
tab corr_submp_uk, gen(corr_submp_uk)
tab corr_decp, gen(corr_decp)
tab corr_decp_at, gen(corr_decp_at)
tab corr_decp_be, gen(corr_decp_be)
tab corr_decp_bg, gen(corr_decp_bg)
tab corr_decp_ch, gen(corr_decp_ch)
tab corr_decp_cy, gen(corr_decp_cy)
tab corr_decp_cz, gen(corr_decp_cz)
tab corr_decp_de, gen(corr_decp_de)
tab corr_decp_dk, gen(corr_decp_dk)
tab corr_decp_ee, gen(corr_decp_ee)
tab corr_decp_es, gen(corr_decp_es)
tab corr_decp_fi, gen(corr_decp_fi)
tab corr_decp_fr, gen(corr_decp_fr)
tab corr_decp_gr, gen(corr_decp_gr)
tab corr_decp_hr, gen(corr_decp_hr)
tab corr_decp_hu, gen(corr_decp_hu)
tab corr_decp_ie, gen(corr_decp_ie)
tab corr_decp_it, gen(corr_decp_it)
tab corr_decp_lt, gen(corr_decp_lt)
tab corr_decp_lu, gen(corr_decp_lu)
tab corr_decp_lv, gen(corr_decp_lv)
tab corr_decp_nl, gen(corr_decp_nl)
tab corr_decp_no, gen(corr_decp_no)
tab corr_decp_pl, gen(corr_decp_pl)
tab corr_decp_pt, gen(corr_decp_pt)
tab corr_decp_ro, gen(corr_decp_ro)
tab corr_decp_se, gen(corr_decp_se)
tab corr_decp_si, gen(corr_decp_si)
tab corr_decp_sk, gen(corr_decp_sk)
tab corr_decp_uk, gen(corr_decp_uk)
tab corr_wnonpr, gen(corr_wnonpr)
tab corr_wnonpr_at, gen(corr_wnonpr_at)
tab corr_wnonpr_be, gen(corr_wnonpr_be)
tab corr_wnonpr_bg, gen(corr_wnonpr_bg)
tab corr_wnonpr_cz, gen(corr_wnonpr_cz)
tab corr_wnonpr_de, gen(corr_wnonpr_de)
tab corr_wnonpr_dk, gen(corr_wnonpr_dk)
tab corr_wnonpr_ee, gen(corr_wnonpr_ee)
tab corr_wnonpr_es, gen(corr_wnonpr_es)
tab corr_wnonpr_fi, gen(corr_wnonpr_fi)
tab corr_wnonpr_fr, gen(corr_wnonpr_fr)
tab corr_wnonpr_gr, gen(corr_wnonpr_gr)
tab corr_wnonpr_hu, gen(corr_wnonpr_hu)
tab corr_wnonpr_ie, gen(corr_wnonpr_ie)
tab corr_wnonpr_it, gen(corr_wnonpr_it)
tab corr_wnonpr_lt, gen(corr_wnonpr_lt)
tab corr_wnonpr_lv, gen(corr_wnonpr_lv)
tab corr_wnonpr_nl, gen(corr_wnonpr_nl)
tab corr_wnonpr_no, gen(corr_wnonpr_no)
tab corr_wnonpr_pl, gen(corr_wnonpr_pl)
tab corr_wnonpr_ro, gen(corr_wnonpr_ro)
tab corr_wnonpr_se, gen(corr_wnonpr_se)
tab corr_wnonpr_si, gen(corr_wnonpr_si)
tab corr_wnonpr_sk, gen(corr_wnonpr_sk)
tab corr_wnonpr_uk, gen(corr_wnonpr_uk)
gen x=(ca_criterion*-1)+1

gen cri_eu_new=(singleb+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure5*0.5+ca_procedure3*0.25+ ///
corr_wnonpr2*1+corr_wnonpr5*0.66+corr_wnonpr1*0.33+ ///
corr_submp2*1+corr_submp4*0.66+corr_submp3*0.33+ ///
corr_decp1*1+corr_decp4*0.66+corr_decp2*0.33)/6
replace cri_eu_new=(singleb+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure5*0.5+ca_procedure3*0.25+ ///
corr_wnonpr2*1+corr_wnonpr5*0.66+corr_wnonpr1*0.33)/4 if nocft==1

gen cri_aeu_new=(prop_bidnr+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure5*0.5+ca_procedure3*0.25+ ///
corr_wnonpr2*1+corr_wnonpr5*0.66+corr_wnonpr1*0.33+ ///
corr_submp2*1+corr_submp4*0.66+corr_submp3*0.33+ ///
corr_decp1*1+corr_decp4*0.66+corr_decp2*0.33)/6
replace cri_aeu_new=(prop_bidnr+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure5*0.5+ca_procedure3*0.25+ ///
corr_wnonpr2*1+corr_wnonpr5*0.66+corr_wnonpr1*0.33)/4 if nocft==1

gen cri_it=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.75+ca_procedure1*0.5+ca_procedure8*0.25+ ///
corr_wnonpr_it1*1+corr_wnonpr_it3*0.5+ ///
corr_submp_it4*1+corr_submp_it3*0.5+ ///
corr_decp_it1*1+corr_decp_it2*0.5)/6 if anb_country=="IT"
replace cri_it=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.75+ca_procedure1*0.5+ca_procedure8*0.25+ ///
corr_wnonpr_it1*1+corr_wnonpr_it3*0.5)/4 if nocft==1 & anb_country=="IT"

gen cri_uk=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.75+ca_procedure5*0.5+ca_procedure2*0.25+ ///
corr_wnonpr_uk1*1+corr_wnonpr_uk2*0.66+corr_wnonpr_uk4*0.33+ ///
corr_submp_uk4*1+corr_submp_uk2*0.66+corr_submp_uk3*0.33+ ///
corr_decp_uk1*1+corr_decp_uk3*0.5)/6 if anb_country=="UK"
replace cri_uk=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.75+ca_procedure5*0.5+ca_procedure2*0.25+ ///
corr_wnonpr_uk1*1+corr_wnonpr_uk2*0.66+corr_wnonpr_uk4*0.33)/4 if nocft==1 & anb_country=="UK"

gen cri_sk=(singleb+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure5*0.5+ca_procedure2*0.25+ ///
ca_criterion + ///
corr_submp_sk2*1+ ///
corr_decp_sk3*1+corr_decp_sk1*0.66+corr_decp_sk2*0.33)/6 if anb_country=="SK"
replace cri_sk=(singleb+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure5*0.5+ca_procedure2*0.25+ca_criterion)/4 if nocft==1 & anb_country=="SK"

gen cri_ro=(singleb+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure4*0.5+ca_procedure2*0.25+ ///
corr_wnonpr_ro1*1+corr_wnonpr_ro2*0.5+ ///
corr_submp_ro2*1+ ///
corr_decp_ro1*1+corr_decp_ro2*0.66+corr_decp_ro5*0.66+corr_decp_ro3*0.33)/6  if anb_country=="RO"
replace cri_ro=(singleb+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure4*0.5+ca_procedure2*0.25+ ///
corr_wnonpr_ro1*1+corr_wnonpr_ro2*0.5)/4 if nocft==1 & anb_country=="RO"

gen cri_bg=(singleb+ca_procedure6*1+ca_procedure8*0.75+ca_procedure5*0.5+ca_procedure3*0.25+ ///
ca_criterion + ///
corr_submp_bg4*1+corr_submp_bg1*0.66+corr_submp_bg2*0.33+ ///
corr_decp_bg1*1+corr_decp_bg5*0.5)/5 if anb_country=="BG"
replace cri_bg=(singleb+ca_procedure6*1+ca_procedure8*0.75+ca_procedure5*0.5+ca_procedure3*0.25+ca_criterion)/3 if nocft==1 & anb_country=="BG"

gen cri_de=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.75+ca_procedure2*0.5+ca_procedure5*0.25+ ///
corr_wnonpr_de4*1+corr_wnonpr_de1*0.66+corr_wnonpr_de2*0.33+ ///
corr_decp_de1*1+corr_decp_de5*0.5)/6  if anb_country=="DE"
replace cri_de=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.75+ca_procedure2*0.5+ca_procedure5*0.25+ ///
corr_wnonpr_de4*1+corr_wnonpr_de1*0.66+corr_wnonpr_de2*0.33)/4 if nocft==1 & anb_country=="DE"

gen cri_es=(singleb+ca_procedure6*1+ca_procedure3*0.75+ca_procedure1*0.5+ca_procedure5*0.25+ ///
ca_criterion + ///
corr_submp_es1*1+corr_submp_es3*0.5+ ///
corr_decp_es1*1)/5  if anb_country=="ES"
replace cri_es=(singleb+ca_procedure6*1+ca_procedure3*0.75+ca_procedure1*0.5+ca_procedure5*0.25+ca_criterion)/3 if nocft==1 & anb_country=="ES"

gen cri_fr=(singleb+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure2*0.5+ca_procedure5*0.25+ ///
corr_wnonpr_fr1*1+corr_wnonpr_fr2*0.5+ ///
corr_submp_fr3*1+ ///
corr_decp_fr1*1+corr_decp_fr2*0.66+corr_decp_fr4*0.33)/6 if anb_country=="FR"
replace cri_fr=(singleb+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure2*0.5+ca_procedure5*0.25+ ///
corr_wnonpr_fr1*1+corr_wnonpr_fr2*0.5)/4 if nocft==1 & anb_country=="FR"

gen cri_pl=(singleb+new_nocft3+ca_procedure3*1+ca_procedure1*0.75+ca_procedure6*0.5+ca_procedure8*0.25+ca_procedure5*0.25+ ///
corr_wnonpr_pl2*1+corr_wnonpr_pl3*0.66+corr_wnonpr_pl1*0.33+ ///
corr_submp_pl1*1+corr_submp_pl3*0.5+ ///
corr_decp_pl1*1+corr_decp_pl5*0.75+corr_decp_pl2*0.5+corr_decp_pl3*0.25)/6  if anb_country=="PL"
replace cri_pl=(singleb+new_nocft3+ca_procedure3*1+ca_procedure1*0.75+ca_procedure6*0.5+ca_procedure8*0.25+ca_procedure5*0.25+ ///
corr_wnonpr_pl2*1+corr_wnonpr_pl3*0.66+corr_wnonpr_pl1*0.33)/4 if nocft==1 & anb_country=="PL"

gen cri_nl=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.66+ca_procedure1*0.33+ ///
corr_wnonpr_nl1*1+corr_wnonpr_nl2*0.5+ ///
corr_submp_nl4*1+corr_submp_nl2*0.5+ /// 
corr_decp_nl1*1+corr_decp_nl3*0.66+corr_decp_nl4*0.33)/6  if anb_country=="NL"
replace cri_nl=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.66+ca_procedure1*0.33+ ///
corr_wnonpr_nl1*1+corr_wnonpr_nl2*0.5)/4 if nocft==1 & anb_country=="NL"

gen cri_gr=(singleb+new_nocft3+ ///
x+ ///
corr_submp_gr3*1+corr_submp_gr4*0.5+ ///
corr_decp_gr1*1+corr_decp_gr2*0.5)/5  if anb_country=="GR"
replace cri_gr=(singleb+new_nocft3+x)/3 if nocft==1 & anb_country=="GR"

gen cri_dk=(singleb+ca_procedure3*1+ca_procedure6*0.75+ca_procedure5*0.5+ca_procedure4*0.25+ ///
corr_wnonpr_dk4*1+  ///
corr_submp_dk2*1+ ///
corr_decp_dk5*1+corr_decp_dk2*0.66+corr_decp_dk1*0.33)/5  if anb_country=="DK"
replace cri_dk=(singleb+ca_procedure3*1+ca_procedure6*0.75+ca_procedure5*0.5+ca_procedure4*0.25+ ///
corr_wnonpr_dk4*1)/3 if nocft==1 & anb_country=="DK"

gen cri_at=(singleb+new_nocft3+ca_procedure3*1+ca_procedure6*0.75+ca_procedure4*0.5+ca_procedure1*0.25+ ///
corr_wnonpr_at2*1+corr_wnonpr_at4*0.66+corr_wnonpr_at1*0.33+ ///
corr_submp_at2*1+corr_submp_at4*0.5+ ///
corr_decp_at1*1+corr_decp_at2*0.66+corr_decp_at6*0.33)/6 if anb_country=="AT"
replace cri_at=(singleb+new_nocft3+ca_procedure3*1+ca_procedure6*0.75+ca_procedure4*0.5+ca_procedure1*0.25+ ///
corr_wnonpr_at2*1+corr_wnonpr_at4*0.66+corr_wnonpr_at1*0.33)/4 if nocft==1 & anb_country=="AT"

gen cri_be=(singleb+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure3*0.5+ca_procedure5*0.25+ ///
corr_wnonpr_be1*1+corr_wnonpr_be4*0.5+ ///
corr_submp_be3*1+corr_submp_be5*0.66+corr_submp_be1*0.33+ ///
corr_decp_be1*1)/6 if anb_country=="BE"
replace cri_be=(singleb+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure3*0.5+ca_procedure5*0.25+ ///
corr_wnonpr_be1*1+corr_wnonpr_be4*0.5)/4 if nocft==1 & anb_country=="BE"

gen cri_si=(singleb+new_nocft3+ca_procedure6*1+ca_procedure4*0.75+ca_procedure1*0.5+ca_procedure3*0.25+ ///
corr_wnonpr_si3*1+corr_wnonpr_si1*0.5+ ///
corr_submp_si1*1+ ///
corr_decp_si1*1+corr_decp_si3*0.75+corr_decp_si2*0.5+corr_decp_si5*0.25)/6 if anb_country=="SI"
replace cri_si=(singleb+new_nocft3+ca_procedure6*1+ca_procedure4*0.75+ca_procedure1*0.5+ca_procedure3*0.25+ ///
corr_wnonpr_si3*1+corr_wnonpr_si1*0.5)/4 if nocft==1 & anb_country=="SI"

gen cri_ee=(singleb+ca_procedure6*1+ca_procedure3*0.75+ca_procedure9*0.5+ca_procedure1*0.25+ca_procedure4*0.25+ ///
corr_wnonpr_ee5*1+corr_wnonpr_ee2*0.5+ ///
corr_submp_ee6*1+corr_submp_ee2*0.5+ ///
corr_decp_ee6*1+corr_decp_ee1*1+corr_decp_ee2*0.5)/5 if anb_country=="EE"
replace cri_ee=(singleb+ca_procedure6*1+ca_procedure3*0.75+ca_procedure9*0.5+ca_procedure1*0.25+ca_procedure4*0.25+ ///
corr_wnonpr_ee5*1+corr_wnonpr_ee2*0.5)/3 if nocft==1 & anb_country=="EE"

gen cri_se=(singleb+new_nocft3+ca_procedure6*1+ ///
corr_wnonpr_se2*1+ ///
corr_decp_se1*1+corr_decp_se2*0.66+corr_decp_se4*0.33)/5 if anb_country=="SE"
replace cri_se=(singleb+new_nocft3+ca_procedure6*1+ ///
corr_wnonpr_se2*1)/4 if nocft==1 & anb_country=="SE"

gen cri_ie=(singleb+new_nocft3+ca_procedure4*1+ca_procedure5*0.5+ ///
corr_wnonpr_ie2*1+ ///
corr_submp_ie2*1+corr_submp_ie1*0.5+ ///
corr_decp_ie1*1+corr_decp_ie5*0.75+corr_decp_ie4*0.5+corr_decp_ie3*0.25)/6 if anb_country=="IE"
replace cri_ie=(singleb+new_nocft3+ca_procedure4*1+ca_procedure5*0.5+ ///
corr_wnonpr_ie2*1)/4 if nocft==1 & anb_country=="IE"

gen cri_cz=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.75+ca_procedure1*0.5+ca_procedure4*0.25+ ///
x+ ///
corr_submp_cz3*1+corr_submp_cz4*0.5+ ///
corr_decp_cz1*1+corr_decp_cz2*0.75+corr_decp_cz3*0.5+corr_decp_cz5*0.25)/6 if anb_country=="CZ"
replace cri_cz=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.75+ca_procedure1*0.5+ca_procedure4*0.25+x)/4 if nocft==1 & anb_country=="CZ"

gen cri_fi=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.75+ca_procedure2*0.5+ca_procedure5*0.25+ ///
corr_wnonpr_fi1*1+corr_wnonpr_fi3*0.66+corr_wnonpr_fi4*0.33+ ///
corr_submp_fi3*1+corr_submp_fi4*0.66+corr_submp_fi1*0.33+ ///
corr_decp_fi1*1+corr_decp_fi3*0.75+corr_decp_fi2*0.5+corr_decp_fi5*0.25)/6 if anb_country=="FI"
replace cri_fi=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.75+ca_procedure2*0.5+ca_procedure5*0.25+ ///
corr_wnonpr_fi1*1+corr_wnonpr_fi3*0.66+corr_wnonpr_fi4*0.33)/4 if nocft==1 & anb_country=="FI"

gen cri_hu=(singleb+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure2*0.5+ca_procedure5*0.25+ ///
corr_wnonpr_hu4*1+ ///
corr_decp_hu1*1+corr_decp_hu2*0.66+corr_decp_hu4*0.33)/5 if anb_country=="HU"
replace cri_hu=(singleb+new_nocft3+ca_procedure6*1+ca_procedure1*0.75+ca_procedure2*0.5+ca_procedure5*0.25+ ///
corr_wnonpr_hu4*1)/4 if nocft==1 & anb_country=="HU"

gen cri_no=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.75+ca_procedure1*0.5+ca_procedure5*0.25+ ///
corr_wnonpr_no1*1+ ///
corr_submp_no2*1+corr_submp_no4*0.5+ ///
corr_decp_no1*1+corr_decp_no2*0.66+corr_decp_no4*0.33)/6 if anb_country=="NO"
replace cri_no=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.75+ca_procedure1*0.5+ca_procedure5*0.25+ ///
corr_wnonpr_no1*1)/4 if nocft==1 & anb_country=="NO"

gen cri_pt=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.66+ca_procedure9*0.33+ ///
ca_criterion + ///
corr_submp_pt2*1+corr_submp_pt3*0.5+ ///
corr_decp_pt2*1+corr_decp_pt4*0.66+corr_decp_pt1*0.33)/6 if anb_country=="PT"
replace cri_pt=(singleb+new_nocft3*1+ca_procedure6*1+ca_procedure3*0.66+ca_procedure9*0.33+ca_criterion)/4 if nocft==1 & anb_country=="PT"

gen cri_lt=(singleb+ca_procedure6*1+ca_procedure5*0.5+ ///
corr_wnonpr_lt4*1+corr_wnonpr_lt3*0.66+corr_wnonpr_lt1*0.33+ ///
corr_submp_lt3*1+corr_submp_lt1*0.5+ ///
corr_decp_lt1*1+corr_decp_lt2*0.5)/5 if anb_country=="LT"
replace cri_lt=(singleb+ca_procedure6*1+ca_procedure5*0.5+ ///
corr_wnonpr_lt4*1+corr_wnonpr_lt3*0.66+corr_wnonpr_lt1*0.33)/3 if nocft==1 & anb_country=="LT"

gen cri_lv=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.66+ca_procedure5*0.33+ ///
corr_wnonpr_lv3*1+corr_wnonpr_lv4*0.5+ ///
corr_submp_lv5*1+corr_submp_lv2*0.5+ ///
corr_decp_lv1*1+corr_decp_lv5*0.5)/6 if anb_country=="LV"
replace cri_lv=(singleb+new_nocft3+ca_procedure6*1+ca_procedure3*0.66+ca_procedure5*0.33+ ///
corr_wnonpr_lv3*1+corr_wnonpr_lv4*0.5)/4 if nocft==1 & anb_country=="LV"

gen cri_cy=(singleb+new_nocft3+ ///
corr_submp_cy5*1+corr_submp_cy4*0.66+corr_submp_cy2*0.33+ ///
corr_decp_cy2*1+corr_decp_cy1*0.66+corr_decp_cy3*0.33)/4 if anb_country=="CY"
replace cri_cy=(singleb+new_nocft3)/2 if nocft==1 & anb_country=="CY"

gen cri_lu=(singleb+new_nocft3+ ///
ca_criterion + ///
corr_submp_lu1*1+corr_submp_lu3*0.5+ ///
corr_decp_lu1*1)/5 if anb_country=="LU"
replace cri_lu=(singleb+new_nocft3+ca_criterion)/3 if nocft_new==1 & anb_country=="LU"

gen cri_ch=(singleb+ ///
corr_submp_ch1*1+corr_submp_ch3*0.66+corr_submp_ch4*0.33+ ///
corr_decp_ch3*1+corr_decp_ch1*0.75+corr_decp_ch2*0.5+corr_decp_ch5*0.25)/3 if anb_country=="CH"
replace cri_ch=singleb if nocft==1 & anb_country=="CH"

gen cri_hr=(singleb+new_nocft3+ca_procedure8*1+ ///
ca_criterion + ///
corr_submp_hr3*1+corr_submp_hr1*0.5+ ///
corr_decp_hr1*1)/6 if anb_country=="HR"
replace cri_hr=(singleb+new_nocft3+ca_procedure8*1+ca_criterion)/4 if nocft==1 & anb_country=="HR"

gen cri_neu_new=cri_at
replace cri_neu_new=cri_be if cri_neu_new==.
replace cri_neu_new=cri_bg if cri_neu_new==.
replace cri_neu_new=cri_cy if cri_neu_new==.
replace cri_neu_new=cri_cz if cri_neu_new==.
replace cri_neu_new=cri_de if cri_neu_new==.
replace cri_neu_new=cri_dk if cri_neu_new==.
replace cri_neu_new=cri_ee if cri_neu_new==.
replace cri_neu_new=cri_es if cri_neu_new==.
replace cri_neu_new=cri_fi if cri_neu_new==.
replace cri_neu_new=cri_fr if cri_neu_new==.
replace cri_neu_new=cri_gr if cri_neu_new==.
replace cri_neu_new=cri_hu if cri_neu_new==.
replace cri_neu_new=cri_ie if cri_neu_new==.
replace cri_neu_new=cri_it if cri_neu_new==.
replace cri_neu_new=cri_lt if cri_neu_new==.
replace cri_neu_new=cri_lu if cri_neu_new==.
replace cri_neu_new=cri_lv if cri_neu_new==.
replace cri_neu_new=cri_nl if cri_neu_new==.
replace cri_neu_new=cri_no if cri_neu_new==.
replace cri_neu_new=cri_pl if cri_neu_new==.
replace cri_neu_new=cri_pt if cri_neu_new==.
replace cri_neu_new=cri_ro if cri_neu_new==.
replace cri_neu_new=cri_se if cri_neu_new==.
replace cri_neu_new=cri_si if cri_neu_new==.
replace cri_neu_new=cri_sk if cri_neu_new==.
replace cri_neu_new=cri_uk if cri_neu_new==.
replace cri_neu_new=cri_eu if cri_neu_new==.
replace cri_neu_new=cri_ch if cri_neu_new==.
replace cri_neu_new=cri_hr if cri_neu_new==.

drop cri_at cri_be cri_bg cri_cy cri_cz cri_de cri_dk cri_ee cri_es cri_fi cri_fr cri_gr cri_hu cri_ie cri_it cri_lt cri_lu cri_lv cri_nl cri_no ///
cri_pl cri_pt cri_ro cri_se cri_si cri_sk cri_uk cri_ch cri_hr



******************************************components*******************************************


gen cri_euc1_new=singleb
gen cri_euc2_new=new_nocft3
gen cri_euac1_new=prop_bidnr
gen cri_euc3_new   =	ca_procedure6*1+ca_procedure1*0.75+ca_procedure5*0.5+ca_procedure3*0.25
gen cri_euc4_new   =	corr_wnonpr2*1+corr_wnonpr5*0.66+corr_wnonpr1*0.33
gen cri_euc5_new   =	corr_submp2*1+corr_submp4*0.66+corr_submp3*0.33
gen cri_euc6_new   =	corr_decp1*1+corr_decp4*0.66+corr_decp2*0.33
	
gen cri_itc3_new   =	ca_procedure6*1+ca_procedure3*0.75+ca_procedure1*0.5+ca_procedure8*0.25
gen cri_itc4_new   =	corr_wnonpr_it1*1+corr_wnonpr_it3*0.5
gen cri_itc5_new   =	corr_submp_it4*1+corr_submp_it3*0.5
gen cri_itc6_new   =	corr_decp_it1*1+corr_decp_it2*0.5
	
gen cri_ukc3_new   =	ca_procedure6*1+ca_procedure3*0.75+ca_procedure5*0.5+ca_procedure2*0.25
gen cri_ukc4_new   =	corr_wnonpr_uk1*1+corr_wnonpr_uk2*0.66+corr_wnonpr_uk4*0.33
gen cri_ukc5_new   =	corr_submp_uk4*1+corr_submp_uk2*0.66+corr_submp_uk3*0.33
gen cri_ukc6_new   =	corr_decp_uk1*1+corr_decp_uk3*0.5
	
gen cri_skc3_new   =	ca_procedure6*1+ca_procedure1*0.75+ca_procedure5*0.5+ca_procedure2*0.25
gen cri_skc4_new   =	ca_criterion
gen cri_skc5_new   =	corr_submp_sk2*1
gen cri_skc6_new   =	corr_decp_sk3*1+corr_decp_sk1*0.66+corr_decp_sk2*0.33
	
gen cri_roc3_new   =	ca_procedure6*1+ca_procedure1*0.75+ca_procedure4*0.5+ca_procedure2*0.25
gen cri_roc4_new   =	corr_wnonpr_ro1*1+corr_wnonpr_ro2*0.5
gen cri_roc5_new   =	corr_submp_ro2*1
gen cri_roc6_new   =	corr_decp_ro1*1+corr_decp_ro2*0.66+corr_decp_ro5*0.66+corr_decp_ro3*0.33
	
gen cri_bgc3_new   =	ca_procedure6*1+ca_procedure8*0.75+ca_procedure5*0.5+ca_procedure3*0.25
gen cri_bgc4_new   =	ca_criterion
gen cri_bgc5_new   =	corr_submp_bg4*1+corr_submp_bg1*0.66+corr_submp_bg2*0.33
gen cri_bgc6_new   =	corr_decp_bg1*1+corr_decp_bg5*0.5
	
gen cri_dec3_new   =	ca_procedure6*1+ca_procedure3*0.75+ca_procedure2*0.5+ca_procedure5*0.25
gen cri_dec4_new   =	corr_wnonpr_de4*1+corr_wnonpr_de1*0.66+corr_wnonpr_de2*0.33
gen cri_dec5_new   =	.
gen cri_dec6_new   =	corr_decp_de1*1+corr_decp_de5*0.5
	
gen cri_esc3_new   =	ca_procedure6*1+ca_procedure3*0.75+ca_procedure1*0.5+ca_procedure5*0.25
gen cri_esc4_new   =	ca_criterion
gen cri_esc5_new   =	corr_submp_es1*1+corr_submp_es3*0.5
gen cri_esc6_new   =	corr_decp_es1*1
	
gen cri_frc3_new   =	ca_procedure6*1+ca_procedure1*0.75+ca_procedure2*0.5+ca_procedure5*0.25
gen cri_frc4_new   =	corr_wnonpr_fr1*1+corr_wnonpr_fr2*0.5
gen cri_frc5_new   =	corr_submp_fr3*1
gen cri_frc6_new   =	corr_decp_fr1*1+corr_decp_fr2*0.66+corr_decp_fr4*0.33
	
gen cri_plc3_new   =	ca_procedure3*1+ca_procedure1*0.75+ca_procedure6*0.5+ca_procedure8*0.25+ca_procedure5*0.25
gen cri_plc4_new   =	corr_wnonpr_pl2*1+corr_wnonpr_pl3*0.66+corr_wnonpr_pl1*0.33
gen cri_plc5_new   =	corr_submp_pl1*1+corr_submp_pl3*0.5
gen cri_plc6_new   =	corr_decp_pl1*1+corr_decp_pl5*0.75+corr_decp_pl2*0.5+corr_decp_pl3*0.25
	
gen cri_nlc3_new   =	ca_procedure6*1+ca_procedure3*0.66+ca_procedure1*0.33
gen cri_nlc4_new   =	corr_wnonpr_nl1*1+corr_wnonpr_nl2*0.5
gen cri_nlc5_new   =	corr_submp_nl4*1+corr_submp_nl2*0.5
gen cri_nlc6_new   =	corr_decp_nl1*1+corr_decp_nl3*0.66+corr_decp_nl4*0.33
	
gen cri_grc3_new   =	.
gen cri_grc4_new   =	x
gen cri_grc5_new   =	corr_submp_gr3*1+corr_submp_gr4*0.5
gen cri_grc6_new   =	corr_decp_gr1*1+corr_decp_gr2*0.5
	
gen cri_dkc3_new   =	ca_procedure3*1+ca_procedure6*0.75+ca_procedure5*0.5+ca_procedure4*0.25
gen cri_dkc4_new   =	corr_wnonpr_dk4*1
gen cri_dkc5_new   =	corr_submp_dk2*1
gen cri_dkc6_new   =	corr_decp_dk5*1+corr_decp_dk2*0.66+corr_decp_dk1*0.33
	
gen cri_atc3_new   =	ca_procedure3*1+ca_procedure6*0.75+ca_procedure4*0.5+ca_procedure1*0.25
gen cri_atc4_new   =	corr_wnonpr_at2*1+corr_wnonpr_at4*0.66+corr_wnonpr_at1*0.33
gen cri_atc5_new   =	corr_submp_at2*1+corr_submp_at4*0.5
gen cri_atc6_new   =	corr_decp_at1*1+corr_decp_at2*0.66+corr_decp_at6*0.33
	
gen cri_bec3_new   =	ca_procedure6*1+ca_procedure1*0.75+ca_procedure3*0.5+ca_procedure5*0.25
gen cri_bec4_new   =	corr_wnonpr_be1*1+corr_wnonpr_be4*0.5
gen cri_bec5_new   =	corr_submp_be3*1+corr_submp_be5*0.66+corr_submp_be1*0.33
gen cri_bec6_new   =	corr_decp_be1*1
	
gen cri_sic3_new   =	ca_procedure6*1+ca_procedure4*0.75+ca_procedure1*0.5+ca_procedure3*0.25
gen cri_sic4_new   =	corr_wnonpr_si3*1+corr_wnonpr_si1*0.5
gen cri_sic5_new   =	corr_submp_si1*1
gen cri_sic6_new   =	corr_decp_si1*1+corr_decp_si3*0.75+corr_decp_si2*0.5+corr_decp_si5*0.25
	
gen cri_eec3_new   =	ca_procedure6*1+ca_procedure3*0.75+ca_procedure9*0.5+ca_procedure1*0.25+ca_procedure4*0.25
gen cri_eec4_new   =	corr_wnonpr_ee5*1+corr_wnonpr_ee2*0.5
gen cri_eec5_new   =	corr_submp_ee6*1+corr_submp_ee2*0.5
gen cri_eec6_new   =	corr_decp_ee6*1+corr_decp_ee1*1+corr_decp_ee2*0.5
	
gen cri_sec3_new   =	ca_procedure6*1
gen cri_sec4_new   =	corr_wnonpr_se2*1
gen cri_sec5_new   =	.
gen cri_sec6_new   =	corr_decp_se1*1+corr_decp_se2*0.66+corr_decp_se4*0.33
	
gen cri_iec3_new   =	ca_procedure4*1+ca_procedure5*0.5
gen cri_iec4_new   =	corr_wnonpr_ie2*1
gen cri_iec5_new   =	corr_submp_ie2*1+corr_submp_ie1*0.5
gen cri_iec6_new   =	corr_decp_ie1*1+corr_decp_ie5*0.75+corr_decp_ie4*0.5+corr_decp_ie3*0.25
	
gen cri_czc3_new   =	ca_procedure6*1+ca_procedure3*0.75+ca_procedure1*0.5+ca_procedure4*0.25
gen cri_czc4_new   =	x
gen cri_czc5_new   =	corr_submp_cz3*1+corr_submp_cz4*0.5
gen cri_czc6_new   =	corr_decp_cz1*1+corr_decp_cz2*0.75+corr_decp_cz3*0.5+corr_decp_cz4*0.25
	
gen cri_fic3_new   =	ca_procedure6*1+ca_procedure3*0.75+ca_procedure2*0.5+ca_procedure5*0.25
gen cri_fic4_new   =	corr_wnonpr_fi1*1+corr_wnonpr_fi3*0.66+corr_wnonpr_fi4*0.33
gen cri_fic5_new   =	corr_submp_fi3*1+corr_submp_fi4*0.66+corr_submp_fi1*0.33
gen cri_fic6_new   =	corr_decp_fi1*1+corr_decp_fi3*0.75+corr_decp_fi2*0.5+corr_decp_fi5*0.25
	
gen cri_huc3_new   =	ca_procedure6*1+ca_procedure1*0.75+ca_procedure2*0.5+ca_procedure5*0.25
gen cri_huc4_new   =	corr_wnonpr_hu4*1
gen cri_huc5_new   =	.
gen cri_huc6_new   =	corr_decp_hu1*1+corr_decp_hu2*0.66+corr_decp_hu4*0.33
	
gen cri_noc3_new   =	ca_procedure6*1+ca_procedure3*0.75+ca_procedure1*0.5+ca_procedure5*0.25
gen cri_noc4_new   =	corr_wnonpr_no1*1
gen cri_noc5_new   =	corr_submp_no2*1+corr_submp_no4*0.5
gen cri_noc6_new   =	corr_decp_no1*1+corr_decp_no2*0.66+corr_decp_no4*0.33
	
gen cri_ptc3_new   =	ca_procedure6*1+ca_procedure3*0.66+ca_procedure9*0.33
gen cri_ptc4_new   =	ca_criterion
gen cri_ptc5_new   =	corr_submp_pt2*1+corr_submp_pt3*0.5
gen cri_ptc6_new   =	corr_decp_pt2*1+corr_decp_pt4*0.66+corr_decp_pt1*0.33
	
gen cri_ltc3_new   =	ca_procedure6*1+ca_procedure5*0.5
gen cri_ltc4_new   =	corr_wnonpr_lt4*1+corr_wnonpr_lt3*0.66+corr_wnonpr_lt1*0.33
gen cri_ltc5_new   =	corr_submp_lt3*1+corr_submp_lt1*0.5
gen cri_ltc6_new   =	corr_decp_lt1*1+corr_decp_lt2*0.5
	
gen cri_lvc3_new   =	ca_procedure6*1+ca_procedure3*0.66+ca_procedure5*0.33
gen cri_lvc4_new   =	corr_wnonpr_lv3*1+corr_wnonpr_lv4*0.5
gen cri_lvc5_new   =	corr_submp_lv5*1+corr_submp_lv2*0.5
gen cri_lvc6_new   =	corr_decp_lv1*1+corr_decp_lv5*0.5
	
gen cri_cyc3_new   =	.
gen cri_cyc4_new   =	.
gen cri_cyc5_new   =	corr_submp_cy5*1+corr_submp_cy4*0.66+corr_submp_cy2*0.33
gen cri_cyc6_new   =	corr_decp_cy1*1+corr_decp_cy2*0.66+corr_decp_cy3*0.33
	
gen cri_luc3_new   =	.
gen cri_luc4_new   =	ca_criterion
gen cri_luc5_new   =	corr_submp_lu1*1+corr_submp_lu3*0.5
gen cri_luc6_new   =	corr_decp_lu1*1
	
gen cri_chc3_new   =	.
gen cri_chc4_new   =	.
gen cri_chc5_new   =	corr_submp_ch1*1+corr_submp_ch3*0.66+corr_submp_ch4*0.33
gen cri_chc6_new   =	corr_decp_ch3*1+corr_decp_ch1*0.75+corr_decp_ch2*0.5+corr_decp_ch5*0.25
	
gen cri_hrc3_new   =	ca_procedure8*1
gen cri_hrc4_new   =	ca_criterion
gen cri_hrc5_new   =	corr_submp_hr3*1+corr_submp_hr1*0.5
gen cri_hrc6_new   =	corr_decp_hr1*1

gen cri_neuc1_new=cri_euc1_new
gen cri_neuc2_new=new_nocft3
replace cri_neuc2_new=0 if anb_country=="BG" | anb_country=="ES" | anb_country=="DK" | anb_country=="EE" | anb_country=="LT" | anb_country=="CH"

gen cri_neuc3_new =	cri_atc3_new	
replace cri_neuc3_new =	cri_bec3_new if anb_country=="BE"
replace cri_neuc3_new =	cri_bgc3_new if anb_country=="BG"
replace cri_neuc3_new =	cri_cyc3_new if anb_country=="CY"
replace cri_neuc3_new =	cri_czc3_new if anb_country=="CZ"
replace cri_neuc3_new =	cri_dec3_new if anb_country=="DE"
replace cri_neuc3_new =	cri_dkc3_new if anb_country=="DK"
replace cri_neuc3_new =	cri_eec3_new if anb_country=="EE"
replace cri_neuc3_new =	cri_esc3_new if anb_country=="ES"
replace cri_neuc3_new =	cri_fic3_new if anb_country=="FI"
replace cri_neuc3_new =	cri_frc3_new if anb_country=="FR"
replace cri_neuc3_new =	cri_grc3_new if anb_country=="GR"
replace cri_neuc3_new =	cri_huc3_new if anb_country=="HU"
replace cri_neuc3_new =	cri_iec3_new if anb_country=="IE"
replace cri_neuc3_new =	cri_itc3_new if anb_country=="IT"
replace cri_neuc3_new =	cri_ltc3_new if anb_country=="LT"
replace cri_neuc3_new =	cri_luc3_new if anb_country=="LU"
replace cri_neuc3_new =	cri_lvc3_new if anb_country=="LV"
replace cri_neuc3_new =	cri_nlc3_new if anb_country=="NL"
replace cri_neuc3_new =	cri_noc3_new if anb_country=="NO"
replace cri_neuc3_new =	cri_plc3_new if anb_country=="PL"
replace cri_neuc3_new =	cri_ptc3_new if anb_country=="PT"
replace cri_neuc3_new =	cri_roc3_new if anb_country=="RO"
replace cri_neuc3_new =	cri_sec3_new if anb_country=="SE"
replace cri_neuc3_new =	cri_sic3_new if anb_country=="SI"
replace cri_neuc3_new =	cri_skc3_new if anb_country=="SK"
replace cri_neuc3_new =	cri_ukc3_new if anb_country=="UK"
replace cri_neuc3_new =	cri_euc3_new if country==.
replace cri_neuc3_new =	cri_chc3_new if anb_country=="CH"
replace cri_neuc3_new =	cri_hrc3_new if anb_country=="HR"

drop cri_atc3_new cri_bec3_new cri_bgc3_new cri_cyc3_new cri_czc3_new cri_dec3_new cri_dkc3_new cri_eec3_new cri_esc3_new cri_fic3_new cri_frc3_new ///
cri_grc3_new cri_huc3_new cri_iec3_new cri_itc3_new cri_ltc3_new cri_luc3_new cri_lvc3_new cri_nlc3_new cri_noc3_new cri_plc3_new cri_ptc3_new ///
cri_roc3_new cri_sec3_new cri_sic3_new cri_skc3_new cri_ukc3_new cri_chc3_new cri_hrc3_new

gen cri_neuc4_new =	cri_atc4_new	
replace cri_neuc4_new =	cri_bec4_new if anb_country=="BE"
replace cri_neuc4_new =	cri_bgc4_new if anb_country=="BG"
replace cri_neuc4_new =	cri_cyc4_new if anb_country=="CY"
replace cri_neuc4_new =	cri_czc4_new if anb_country=="CZ"
replace cri_neuc4_new =	cri_dec4_new if anb_country=="DE"
replace cri_neuc4_new =	cri_dkc4_new if anb_country=="DK"
replace cri_neuc4_new =	cri_eec4_new if anb_country=="EE"
replace cri_neuc4_new =	cri_esc4_new if anb_country=="ES"
replace cri_neuc4_new =	cri_fic4_new if anb_country=="FI"
replace cri_neuc4_new =	cri_frc4_new if anb_country=="FR"
replace cri_neuc4_new =	cri_grc4_new if anb_country=="GR"
replace cri_neuc4_new =	cri_huc4_new if anb_country=="HU"
replace cri_neuc4_new =	cri_iec4_new if anb_country=="IE"
replace cri_neuc4_new =	cri_itc4_new if anb_country=="IT"
replace cri_neuc4_new =	cri_ltc4_new if anb_country=="LT"
replace cri_neuc4_new =	cri_luc4_new if anb_country=="LU"
replace cri_neuc4_new =	cri_lvc4_new if anb_country=="LV"
replace cri_neuc4_new =	cri_nlc4_new if anb_country=="NL"
replace cri_neuc4_new =	cri_noc4_new if anb_country=="NO"
replace cri_neuc4_new =	cri_plc4_new if anb_country=="PL"
replace cri_neuc4_new =	cri_ptc4_new if anb_country=="PT"
replace cri_neuc4_new =	cri_roc4_new if anb_country=="RO"
replace cri_neuc4_new =	cri_sec4_new if anb_country=="SE"
replace cri_neuc4_new =	cri_sic4_new if anb_country=="SI"
replace cri_neuc4_new =	cri_skc4_new if anb_country=="SK"
replace cri_neuc4_new =	cri_ukc4_new if anb_country=="UK"
replace cri_neuc4_new =	cri_euc4_new if anb_country==""
replace cri_neuc4_new =	cri_chc4_new if anb_country=="CH"
replace cri_neuc4_new =	cri_hrc4_new if anb_country=="HR"

drop cri_atc4_new cri_bec4_new cri_bgc4_new cri_cyc4_new cri_czc4_new cri_dec4_new cri_dkc4_new cri_eec4_new cri_esc4_new cri_fic4_new cri_frc4_new ///
cri_grc4_new cri_huc4_new cri_iec4_new cri_itc4_new cri_ltc4_new cri_luc4_new cri_lvc4_new cri_nlc4_new cri_noc4_new ///
cri_plc4_new cri_ptc4_new cri_roc4_new cri_sec4_new cri_sic4_new cri_skc4_new cri_ukc4_new cri_chc4_new cri_hrc4_new

gen cri_neuc5_new =	cri_atc5_new	
replace cri_neuc5_new =	cri_bec5_new if anb_country=="BE"
replace cri_neuc5_new =	cri_bgc5_new if anb_country=="BG"
replace cri_neuc5_new =	cri_cyc5_new if anb_country=="CY"
replace cri_neuc5_new =	cri_czc5_new if anb_country=="CZ"
replace cri_neuc5_new =	cri_dec5_new if anb_country=="DE"
replace cri_neuc5_new =	cri_dkc5_new if anb_country=="DK"
replace cri_neuc5_new =	cri_eec5_new if anb_country=="EE"
replace cri_neuc5_new =	cri_esc5_new if anb_country=="ES"
replace cri_neuc5_new =	cri_fic5_new if anb_country=="FI"
replace cri_neuc5_new =	cri_frc5_new if anb_country=="FR"
replace cri_neuc5_new =	cri_grc5_new if anb_country=="GR"
replace cri_neuc5_new =	cri_huc5_new if anb_country=="HU"
replace cri_neuc5_new =	cri_iec5_new if anb_country=="IE"
replace cri_neuc5_new =	cri_itc5_new if anb_country=="IT"
replace cri_neuc5_new =	cri_ltc5_new if anb_country=="LT"
replace cri_neuc5_new =	cri_luc5_new if anb_country=="LU"
replace cri_neuc5_new =	cri_lvc5_new if anb_country=="LV"
replace cri_neuc5_new =	cri_nlc5_new if anb_country=="NL"
replace cri_neuc5_new =	cri_noc5_new if anb_country=="NO"
replace cri_neuc5_new =	cri_plc5_new if anb_country=="PL"
replace cri_neuc5_new =	cri_ptc5_new if anb_country=="PT"
replace cri_neuc5_new =	cri_roc5_new if anb_country=="RO"
replace cri_neuc5_new =	cri_sec5_new if anb_country=="SE"
replace cri_neuc5_new =	cri_sic5_new if anb_country=="SI"
replace cri_neuc5_new =	cri_skc5_new if anb_country=="SK"
replace cri_neuc5_new =	cri_ukc5_new if anb_country=="UK"
replace cri_neuc5_new =	cri_euc5_new if country==.
replace cri_neuc5_new =	cri_chc5_new if anb_country=="CH"
replace cri_neuc5_new =	cri_hrc5_new if anb_country=="HR"

drop cri_atc5_new cri_bec5_new cri_bgc5_new cri_cyc5_new cri_czc5_new cri_dec5_new cri_dkc5_new cri_eec5_new cri_esc5_new cri_fic5_new cri_frc5_new ///
cri_grc5_new cri_huc5_new cri_iec5_new cri_itc5_new cri_ltc5_new cri_luc5_new cri_lvc5_new cri_nlc5_new cri_noc5_new ///
cri_plc5_new cri_ptc5_new cri_roc5_new cri_sec5_new cri_sic5_new cri_skc5_new cri_ukc5_new cri_chc5_new cri_hrc5_new

gen	cri_neuc6_new = cri_atc6_new	
replace	cri_neuc6_new = cri_bec6_new if anb_country=="BE"
replace	cri_neuc6_new = cri_bgc6_new if anb_country=="BG"
replace	cri_neuc6_new = cri_cyc6_new if anb_country=="CY"
replace	cri_neuc6_new = cri_czc6_new if anb_country=="CZ"
replace	cri_neuc6_new = cri_dec6_new if anb_country=="DE"
replace	cri_neuc6_new = cri_dkc6_new if anb_country=="DK"
replace	cri_neuc6_new = cri_eec6_new if anb_country=="EE"
replace	cri_neuc6_new = cri_esc6_new if anb_country=="ES"
replace	cri_neuc6_new = cri_fic6_new if anb_country=="FI"
replace	cri_neuc6_new = cri_frc6_new if anb_country=="FR"
replace	cri_neuc6_new = cri_grc6_new if anb_country=="GR"
replace	cri_neuc6_new = cri_huc6_new if anb_country=="HU"
replace	cri_neuc6_new = cri_iec6_new if anb_country=="IE"
replace	cri_neuc6_new = cri_itc6_new if anb_country=="IT"
replace	cri_neuc6_new = cri_ltc6_new if anb_country=="LT"
replace	cri_neuc6_new = cri_luc6_new if anb_country=="LU"
replace	cri_neuc6_new = cri_lvc6_new if anb_country=="LV"
replace	cri_neuc6_new = cri_nlc6_new if anb_country=="NL"
replace	cri_neuc6_new = cri_noc6_new if anb_country=="NO"
replace	cri_neuc6_new = cri_plc6_new if anb_country=="PL"
replace	cri_neuc6_new = cri_ptc6_new if anb_country=="PT"
replace	cri_neuc6_new = cri_roc6_new if anb_country=="RO"
replace	cri_neuc6_new = cri_sec6_new if anb_country=="SE"
replace	cri_neuc6_new = cri_sic6_new if anb_country=="SI"
replace	cri_neuc6_new = cri_skc6_new if anb_country=="SK"
replace	cri_neuc6_new = cri_ukc6_new if anb_country=="UK"
replace	cri_neuc6_new = cri_euc6_new if country==.
replace cri_neuc6_new =	cri_chc6_new if anb_country=="CH"
replace cri_neuc6_new =	cri_hrc6_new if anb_country=="HR"

drop cri_atc6_new cri_bec6_new cri_bgc6_new cri_cyc6_new cri_czc6_new cri_dec6_new cri_dkc6_new cri_eec6_new cri_esc6_new cri_fic6_new cri_frc6_new ///
cri_grc6_new cri_huc6_new cri_iec6_new cri_itc6_new cri_ltc6_new cri_luc6_new cri_lvc6_new cri_nlc6_new cri_noc6_new ///
cri_plc6_new cri_ptc6_new cri_roc6_new cri_sec6_new cri_sic6_new cri_skc6_new cri_ukc6_new cri_chc6_new cri_hrc6_new

replace cri_neuc5_new =. if nocft==1
replace cri_neuc6_new =. if nocft==1



********************************binary (without weighting components)********************************



gen cri_eu_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure5+ca_procedure3+ ///
corr_wnonpr2+corr_wnonpr5+corr_wnonpr1+ ///
corr_submp2+corr_submp4+corr_submp3+ ///
corr_decp1+corr_decp4+corr_decp2)/6
replace cri_eu_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure5+ca_procedure3+ ///
corr_wnonpr2+corr_wnonpr5+corr_wnonpr1)/4 if nocft==1

gen cri_aeu_bi_new=(prop_bidnr+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure5+ca_procedure3+ ///
corr_wnonpr2+corr_wnonpr5+corr_wnonpr1+ ///
corr_submp2+corr_submp4+corr_submp3+ ///
corr_decp1+corr_decp4+corr_decp2)/6
replace cri_aeu_bi_new=(prop_bidnr+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure5+ca_procedure3+ ///
corr_wnonpr2+corr_wnonpr5+corr_wnonpr1)/4 if nocft==1

gen cri_it_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure1+ca_procedure8+ ///
corr_wnonpr_it1+corr_wnonpr_it3+ ///
corr_submp_it4+corr_submp_it3+ ///
corr_decp_it1+corr_decp_it2)/6 if anb_country=="IT"
replace cri_it_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure1+ca_procedure8+ ///
corr_wnonpr_it1+corr_wnonpr_it3)/4 if nocft==1 & anb_country=="IT"

gen cri_uk_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure5+ca_procedure2+ ///
corr_wnonpr_uk1+corr_wnonpr_uk2+corr_wnonpr_uk4+ ///
corr_submp_uk4+corr_submp_uk2+corr_submp_uk3+ ///
corr_decp_uk1+corr_decp_uk3)/6 if anb_country=="UK"
replace cri_uk_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure5+ca_procedure2+ ///
corr_wnonpr_uk1+corr_wnonpr_uk2+corr_wnonpr_uk4)/4 if nocft==1 & anb_country=="UK"

gen cri_sk_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure5+ca_procedure2+ ///
ca_criterion + ///
corr_decp_sk3+corr_decp_sk1+corr_decp_sk2)/5 if anb_country=="SK"
replace cri_sk_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure5+ca_procedure2+ca_criterion)/4 if nocft==1 & anb_country=="SK"

gen cri_ro_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure4+ca_procedure2+ ///
corr_wnonpr_ro1+corr_wnonpr_ro2+ ///
corr_submp_ro2+ ///
corr_decp_ro1+corr_decp_ro2+corr_decp_ro5+corr_decp_ro3)/6  if anb_country=="RO"
replace cri_ro_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure4+ca_procedure2+ ///
corr_wnonpr_ro1+corr_wnonpr_ro2)/4 if nocft==1 & anb_country=="RO"

gen cri_bg_bi_new=(singleb+ca_procedure6+ca_procedure8+ca_procedure5+ca_procedure3+ ///
ca_criterion + ///
corr_submp_bg4+ ///
corr_decp_bg1+corr_decp_bg5)/5 if anb_country=="BG"
replace cri_bg_bi_new=(singleb+ca_procedure6+ca_procedure8+ca_procedure5+ca_procedure3+ca_criterion)/3 if nocft==1 & anb_country=="BG"

gen cri_de_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure2+ca_procedure5+ ///
corr_wnonpr_de4+corr_wnonpr_de1+corr_wnonpr_de2+ ///
corr_decp_de1+corr_decp_de5)/6  if anb_country=="DE"
replace cri_de_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure2+ca_procedure5+ ///
corr_wnonpr_de4+corr_wnonpr_de1+corr_wnonpr_de2)/4 if nocft==1 & anb_country=="DE"

gen cri_es_bi_new=(singleb+ca_procedure6+ca_procedure3+ca_procedure1+ca_procedure5+ ///
ca_criterion + ///
corr_submp_es3+ ///
corr_decp_es1)/5  if anb_country=="ES"
replace cri_es_bi_new=(singleb+ca_procedure6+ca_procedure3+ca_procedure1+ca_procedure5+ca_criterion)/3 if nocft==1 & anb_country=="ES"

gen cri_fr_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure2+ca_procedure5+ ///
corr_wnonpr_fr1+corr_wnonpr_fr2+ ///
corr_submp_fr3+ ///
corr_decp_fr1+corr_decp_fr2+corr_decp_fr4)/6 if anb_country=="FR"
replace cri_fr_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure2+ca_procedure5+ ///
corr_wnonpr_fr1+corr_wnonpr_fr2)/4 if nocft==1 & anb_country=="FR"

gen cri_pl_bi_new=(singleb+new_nocft3+ca_procedure3+ca_procedure1+ca_procedure6+ca_procedure8+ca_procedure5+ ///
corr_wnonpr_pl2+corr_wnonpr_pl3+corr_wnonpr_pl1+ ///
corr_submp_pl3+ ///
corr_decp_pl1+corr_decp_pl5+corr_decp_pl2+corr_decp_pl3)/6  if anb_country=="PL"
replace cri_pl_bi_new=(singleb+new_nocft3+ca_procedure3+ca_procedure1+ca_procedure6+ca_procedure8+ca_procedure5+ ///
corr_wnonpr_pl2+corr_wnonpr_pl3+corr_wnonpr_pl1)/4 if nocft==1 & anb_country=="PL"

gen cri_nl_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure1+ ///
corr_wnonpr_nl1+corr_wnonpr_nl2+ ///
corr_submp_nl4+ /// 
corr_decp_nl1+corr_decp_nl3+corr_decp_nl4)/6  if anb_country=="NL"
replace cri_nl_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure1+ ///
corr_wnonpr_nl1+corr_wnonpr_nl2)/4 if nocft==1 & anb_country=="NL"

gen cri_gr_bi_new=(singleb+new_nocft3+ ///
x+ ///
corr_submp_gr3+corr_submp_gr4+ ///
corr_decp_gr1+corr_decp_gr2)/5  if anb_country=="GR"
replace cri_gr_bi_new=(singleb+new_nocft3+x)/3 if nocft==1 & anb_country=="GR"

gen cri_dk_bi_new=(singleb+ca_procedure3+ca_procedure6+ca_procedure5+ca_procedure4+ ///
corr_wnonpr_dk4+  ///
corr_decp_dk5+corr_decp_dk2+corr_decp_dk1)/4  if anb_country=="DK"
replace cri_dk_bi_new=(singleb+ca_procedure3+ca_procedure6+ca_procedure5+ca_procedure4+ ///
corr_wnonpr_dk4)/3 if nocft==1 & anb_country=="DK"

gen cri_at_bi_new=(singleb+new_nocft3+ca_procedure3+ca_procedure6+ca_procedure4+ca_procedure1+ ///
corr_wnonpr_at2+corr_wnonpr_at4+corr_wnonpr_at1+ ///
corr_submp_at4+ ///
corr_decp_at1+corr_decp_at2+corr_decp_at6)/6 if anb_country=="AT"
replace cri_at_bi_new=(singleb+new_nocft3+ca_procedure3+ca_procedure6+ca_procedure4+ca_procedure1+ ///
corr_wnonpr_at2+corr_wnonpr_at4+corr_wnonpr_at1)/4 if nocft==1 & anb_country=="AT"

gen cri_be_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure3+ca_procedure5+ ///
corr_wnonpr_be1+corr_wnonpr_be4+ ///
corr_submp_be3+corr_submp_be5+ ///
corr_decp_be1)/6 if anb_country=="BE"
replace cri_be_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure3+ca_procedure5+ ///
corr_wnonpr_be1+corr_wnonpr_be4)/4 if nocft==1 & anb_country=="BE"

gen cri_si_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure4+ca_procedure1+ca_procedure3+ ///
corr_wnonpr_si3+corr_wnonpr_si1+ ///
corr_decp_si1+corr_decp_si3+corr_decp_si2+corr_decp_si5)/5 if anb_country=="SI"
replace cri_si_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure4+ca_procedure1+ca_procedure3+ ///
corr_wnonpr_si3+corr_wnonpr_si1)/4 if nocft==1 & anb_country=="SI"

gen cri_ee_bi_new=(singleb+ca_procedure6+ca_procedure3+ca_procedure9+ca_procedure1+ca_procedure4+ ///
corr_wnonpr_ee5+corr_wnonpr_ee2+ ///
corr_submp_ee6+ ///
corr_decp_ee6+corr_decp_ee1+corr_decp_ee2)/5 if anb_country=="EE"
replace cri_ee_bi_new=(singleb+ca_procedure6+ca_procedure3+ca_procedure9+ca_procedure1+ca_procedure4+ ///
corr_wnonpr_ee5+corr_wnonpr_ee2)/3 if nocft==1 & anb_country=="EE"

gen cri_se_bi_new=(singleb+new_nocft3+ca_procedure6+ ///
corr_wnonpr_se2+ ///
corr_decp_se1+corr_decp_se2+corr_decp_se4)/5 if anb_country=="SE"
replace cri_se_bi_new=(singleb+new_nocft3+ca_procedure6+ ///
corr_wnonpr_se2)/4 if nocft==1 & anb_country=="SE"

gen cri_ie_bi_new=(singleb+new_nocft3+ca_procedure4+ca_procedure5+ ///
corr_wnonpr_ie2+ ///
corr_decp_ie1+corr_decp_ie5+corr_decp_ie4+corr_decp_ie3)/5 if anb_country=="IE"
replace cri_ie_bi_new=(singleb+new_nocft3+ca_procedure4+ca_procedure5+ ///
corr_wnonpr_ie2)/4 if nocft==1 & anb_country=="IE"

gen cri_cz_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure1+ca_procedure4+ ///
x+ ///
corr_submp_cz3+corr_submp_cz4+ ///
corr_decp_cz1+corr_decp_cz2+corr_decp_cz3+corr_decp_cz4)/6 if anb_country=="CZ"
replace cri_cz_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure1+ca_procedure4+x)/4 if nocft==1 & anb_country=="CZ"

gen cri_fi_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure2+ca_procedure5+ ///
corr_wnonpr_fi1+corr_wnonpr_fi3+corr_wnonpr_fi4+ ///
corr_submp_fi3+corr_submp_fi4+ ///
corr_decp_fi1+corr_decp_fi3+corr_decp_fi2+corr_decp_fi5)/6 if anb_country=="FI"
replace cri_fi_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure2+ca_procedure5+ ///
corr_wnonpr_fi1+corr_wnonpr_fi3+corr_wnonpr_fi4)/4 if nocft==1 & anb_country=="FI"

gen cri_hu_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure2+ca_procedure5+ ///
corr_wnonpr_hu4+ ///
corr_decp_hu1+corr_decp_hu2+corr_decp_hu4)/5 if anb_country=="HU"
replace cri_hu_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure1+ca_procedure2+ca_procedure5+ ///
corr_wnonpr_hu4)/4 if nocft==1 & anb_country=="HU"

gen cri_no_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure1+ca_procedure5+ ///
corr_wnonpr_no1+ ///
corr_submp_no4+ ///
corr_decp_no1+corr_decp_no2+corr_decp_no4)/6 if anb_country=="NO"
replace cri_no_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure1+ca_procedure5+ ///
corr_wnonpr_no1)/4 if nocft==1 & anb_country=="NO"

gen cri_pt_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure9+ ///
ca_criterion + ///
corr_submp_pt2+corr_submp_pt3+ ///
corr_decp_pt2+corr_decp_pt4+corr_decp_pt1)/6 if anb_country=="PT"
replace cri_pt_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure9+ca_criterion)/4 if nocft==1 & anb_country=="PT"

gen cri_lt_bi_new=(singleb+ca_procedure6+ca_procedure5+ ///
corr_wnonpr_lt4+corr_wnonpr_lt3+corr_wnonpr_lt1+ ///
corr_submp_lt3+ ///
corr_decp_lt1+corr_decp_lt2)/5 if anb_country=="LT"
replace cri_lt_bi_new=(singleb+ca_procedure6+ca_procedure5+ ///
corr_wnonpr_lt4+corr_wnonpr_lt3+corr_wnonpr_lt1)/3 if nocft==1 & anb_country=="LT"

gen cri_lv_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure5+ ///
corr_wnonpr_lv3+corr_wnonpr_lv4+ ///
corr_submp_lv5+ ///
corr_decp_lv1+corr_decp_lv5)/6 if anb_country=="LV"
replace cri_lv_bi_new=(singleb+new_nocft3+ca_procedure6+ca_procedure3+ca_procedure5+ ///
corr_wnonpr_lv3+corr_wnonpr_lv4)/4 if nocft==1 & anb_country=="LV"

gen cri_cy_bi_new=(singleb+new_nocft3+ ///
corr_submp_cy5+corr_submp_cy4+ ///
corr_decp_cy2+corr_decp_cy1+corr_decp_cy3)/4 if anb_country=="CY"
replace cri_cy_bi_new=(singleb+new_nocft3)/2 if nocft==1 & anb_country=="CY"

gen cri_lu_bi_new=(singleb+new_nocft3+ ///
ca_criterion + ///
corr_submp_lu3+ ///
corr_decp_lu1)/5 if anb_country=="LU"
replace cri_lu_bi_new=(singleb+new_nocft3+ca_criterion)/3 if nocft_new==1 & anb_country=="LU"

gen cri_ch_bi_new=(singleb+ ///
corr_submp_ch1+corr_submp_ch3+corr_submp_ch4+ ///
corr_decp_ch3+corr_decp_ch1+corr_decp_ch2+corr_decp_ch5)/3 if anb_country=="CH"
replace cri_ch=singleb if nocft==1 & anb_country=="CH"

gen cri_hr_bi_new=(singleb+new_nocft3+ca_procedure8+ ///
ca_criterion + ///
corr_submp_hr3+ ///
corr_decp_hr1)/6 if anb_country=="HR"
replace cri_hr_bi_new=(singleb+new_nocft3+ca_procedure8+ca_criterion)/4 if nocft==1 & anb_country=="HR"

gen cri_neu_bi_new=cri_at_bi_new
replace cri_neu_bi_new=cri_be_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_bg_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_cy_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_cz_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_de_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_dk_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_ee_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_es_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_fi_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_fr_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_gr_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_hu_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_ie_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_it_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_lt_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_lu_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_lv_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_nl_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_no_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_pl_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_pt_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_ro_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_se_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_si_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_sk_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_uk_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_eu_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_ch_bi_new if cri_neu_bi_new==.
replace cri_neu_bi_new=cri_hr_bi_new if cri_neu_bi_new==.

drop cri_at_bi_new cri_be_bi_new cri_bg_bi_new cri_cy_bi_new cri_cz_bi_new cri_de_bi_new cri_dk_bi_new cri_ee_bi_new cri_es_bi_new cri_fi_bi_new ///
cri_fr_bi_new cri_gr_bi_new cri_hu_bi_new cri_ie_bi_new cri_it_bi_new cri_lt_bi_new cri_lu_bi_new cri_lv_bi_new cri_nl_bi_new cri_no_bi_new ///
cri_pl_bi_new cri_pt_bi_new cri_ro_bi_new cri_se_bi_new cri_si_bi_new cri_sk_bi_new cri_uk_bi_new cri_ch_bi_new cri_hr_bi_new

gen cri_euc3_bi_new   =	ca_procedure6+ca_procedure1+ca_procedure5+ca_procedure3
gen cri_euc4_bi_new   =	corr_wnonpr2+corr_wnonpr5+corr_wnonpr1
gen cri_euc5_bi_new   =	corr_submp2+corr_submp4+corr_submp3
gen cri_euc6_bi_new   =	corr_decp1+corr_decp4+corr_decp2
	
gen cri_itc3_bi_new   =	ca_procedure6+ca_procedure3+ca_procedure1+ca_procedure8
gen cri_itc4_bi_new   =	corr_wnonpr_it1+corr_wnonpr_it3
gen cri_itc5_bi_new   =	corr_submp_it4+corr_submp_it3
gen cri_itc6_bi_new   =	corr_decp_it1+corr_decp_it2
	
gen cri_ukc3_bi_new   =	ca_procedure6+ca_procedure3+ca_procedure5+ca_procedure2
gen cri_ukc4_bi_new   =	corr_wnonpr_uk1+corr_wnonpr_uk2+corr_wnonpr_uk4
gen cri_ukc5_bi_new   =	corr_submp_uk4+corr_submp_uk2+corr_submp_uk3
gen cri_ukc6_bi_new   =	corr_decp_uk1+corr_decp_uk3
	
gen cri_skc3_bi_new   =	ca_procedure6+ca_procedure1+ca_procedure5+ca_procedure2
gen cri_skc4_bi_new   =	ca_criterion
gen cri_skc5_bi_new   =	.
gen cri_skc6_bi_new   =	corr_decp_sk3+corr_decp_sk1+corr_decp_sk2
	
gen cri_roc3_bi_new   =	ca_procedure6+ca_procedure1+ca_procedure4+ca_procedure2
gen cri_roc4_bi_new   =	corr_wnonpr_ro1+corr_wnonpr_ro2
gen cri_roc5_bi_new   =	corr_submp_ro2
gen cri_roc6_bi_new   =	corr_decp_ro1+corr_decp_ro2+corr_decp_ro5+corr_decp_ro3
	
gen cri_bgc3_bi_new   =	ca_procedure6+ca_procedure8+ca_procedure5+ca_procedure3
gen cri_bgc4_bi_new   =	ca_criterion
gen cri_bgc5_bi_new   =	corr_submp_bg4
gen cri_bgc6_bi_new   =	corr_decp_bg1+corr_decp_bg5
	
gen cri_dec3_bi_new   =	ca_procedure6+ca_procedure3+ca_procedure2+ca_procedure5
gen cri_dec4_bi_new   =	corr_wnonpr_de4+corr_wnonpr_de1+corr_wnonpr_de2
gen cri_dec5_bi_new   =	.
gen cri_dec6_bi_new   =	corr_decp_de1+corr_decp_de5
	
gen cri_esc3_bi_new   =	ca_procedure6+ca_procedure3+ca_procedure1+ca_procedure5
gen cri_esc4_bi_new   =	ca_criterion
gen cri_esc5_bi_new   =	corr_submp_es3
gen cri_esc6_bi_new   =	corr_decp_es1
	
gen cri_frc3_bi_new   =	ca_procedure6+ca_procedure1+ca_procedure2+ca_procedure5
gen cri_frc4_bi_new   =	corr_wnonpr_fr1+corr_wnonpr_fr2
gen cri_frc5_bi_new   =	corr_submp_fr3
gen cri_frc6_bi_new   =	corr_decp_fr1+corr_decp_fr2+corr_decp_fr4
	
gen cri_plc3_bi_new   =	ca_procedure3+ca_procedure1+ca_procedure6+ca_procedure8+ca_procedure5
gen cri_plc4_bi_new   =	corr_wnonpr_pl2+corr_wnonpr_pl3+corr_wnonpr_pl1
gen cri_plc5_bi_new   =	corr_submp_pl3
gen cri_plc6_bi_new   =	corr_decp_pl1+corr_decp_pl5+corr_decp_pl2+corr_decp_pl3
	
gen cri_nlc3_bi_new   =	ca_procedure6+ca_procedure3+ca_procedure1
gen cri_nlc4_bi_new   =	corr_wnonpr_nl1+corr_wnonpr_nl2
gen cri_nlc5_bi_new   =	corr_submp_nl4
gen cri_nlc6_bi_new   =	corr_decp_nl1+corr_decp_nl3+corr_decp_nl4
	
gen cri_grc3_bi_new   =	.
gen cri_grc4_bi_new   =	x
gen cri_grc5_bi_new   =	corr_submp_gr3+corr_submp_gr4
gen cri_grc6_bi_new   =	corr_decp_gr1+corr_decp_gr2
	
gen cri_dkc3_bi_new   =	ca_procedure3+ca_procedure6+ca_procedure5+ca_procedure4
gen cri_dkc4_bi_new   =	corr_wnonpr_dk4
gen cri_dkc5_bi_new   =	.
gen cri_dkc6_bi_new   =	corr_decp_dk5+corr_decp_dk2+corr_decp_dk1
	
gen cri_atc3_bi_new   =	ca_procedure3+ca_procedure6+ca_procedure4+ca_procedure1
gen cri_atc4_bi_new   =	corr_wnonpr_at2+corr_wnonpr_at4+corr_wnonpr_at1
gen cri_atc5_bi_new   =	corr_submp_at4
gen cri_atc6_bi_new   =	corr_decp_at1+corr_decp_at2+corr_decp_at6
	
gen cri_bec3_bi_new   =	ca_procedure6+ca_procedure1+ca_procedure3+ca_procedure5
gen cri_bec4_bi_new   =	corr_wnonpr_be1+corr_wnonpr_be4
gen cri_bec5_bi_new   =	corr_submp_be3+corr_submp_be5
gen cri_bec6_bi_new   =	corr_decp_be1
	
gen cri_sic3_bi_new   =	ca_procedure6+ca_procedure4+ca_procedure1+ca_procedure3
gen cri_sic4_bi_new   =	corr_wnonpr_si3+corr_wnonpr_si1
gen cri_sic5_bi_new   =	.
gen cri_sic6_bi_new   =	corr_decp_si1+corr_decp_si3+corr_decp_si2+corr_decp_si5
	
gen cri_eec3_bi_new   =	ca_procedure6+ca_procedure3+ca_procedure9+ca_procedure1+ca_procedure4
gen cri_eec4_bi_new   =	corr_wnonpr_ee5+corr_wnonpr_ee2
gen cri_eec5_bi_new   =	corr_submp_ee6
gen cri_eec6_bi_new   =	corr_decp_ee6+corr_decp_ee1+corr_decp_ee2
	
gen cri_sec3_bi_new   =	ca_procedure6
gen cri_sec4_bi_new   =	corr_wnonpr_se2
gen cri_sec5_bi_new   =	.
gen cri_sec6_bi_new   =	corr_decp_se1+corr_decp_se2+corr_decp_se4
	
gen cri_iec3_bi_new   =	ca_procedure4+ca_procedure5
gen cri_iec4_bi_new   =	corr_wnonpr_ie2
gen cri_iec5_bi_new   =	.
gen cri_iec6_bi_new   =	corr_decp_ie1+corr_decp_ie5+corr_decp_ie4+corr_decp_ie3
	
gen cri_czc3_bi_new   =	ca_procedure6+ca_procedure3+ca_procedure1+ca_procedure4
gen cri_czc4_bi_new   =	x
gen cri_czc5_bi_new   =	corr_submp_cz3+corr_submp_cz4
gen cri_czc6_bi_new   =	corr_decp_cz1+corr_decp_cz2+corr_decp_cz3+corr_decp_cz4
	
gen cri_fic3_bi_new   =	ca_procedure6+ca_procedure3+ca_procedure2+ca_procedure5
gen cri_fic4_bi_new   =	corr_wnonpr_fi1+corr_wnonpr_fi3+corr_wnonpr_fi4
gen cri_fic5_bi_new   =	corr_submp_fi3+corr_submp_fi4
gen cri_fic6_bi_new   =	corr_decp_fi1+corr_decp_fi3+corr_decp_fi2+corr_decp_fi5
	
gen cri_huc3_bi_new   =	ca_procedure6+ca_procedure1+ca_procedure2+ca_procedure5
gen cri_huc4_bi_new   =	corr_wnonpr_hu4
gen cri_huc5_bi_new   =	.
gen cri_huc6_bi_new   =	corr_decp_hu1+corr_decp_hu2+corr_decp_hu4
	
gen cri_noc3_bi_new   =	ca_procedure6+ca_procedure3+ca_procedure1+ca_procedure5
gen cri_noc4_bi_new   =	corr_wnonpr_no1
gen cri_noc5_bi_new   =	corr_submp_no4
gen cri_noc6_bi_new   =	corr_decp_no1+corr_decp_no2+corr_decp_no4
	
gen cri_ptc3_bi_new   =	ca_procedure6+ca_procedure3+ca_procedure9
gen cri_ptc4_bi_new   =	ca_criterion
gen cri_ptc5_bi_new   =	corr_submp_pt2+corr_submp_pt3
gen cri_ptc6_bi_new   =	corr_decp_pt2+corr_decp_pt4+corr_decp_pt1
	
gen cri_ltc3_bi_new   =	ca_procedure6+ca_procedure5
gen cri_ltc4_bi_new   =	corr_wnonpr_lt4+corr_wnonpr_lt3+corr_wnonpr_lt1
gen cri_ltc5_bi_new   =	corr_submp_lt3
gen cri_ltc6_bi_new   =	corr_decp_lt1+corr_decp_lt2

gen cri_lvc3_bi_new   =	ca_procedure6+ca_procedure3+ca_procedure5
gen cri_lvc4_bi_new   =	corr_wnonpr_lv3+corr_wnonpr_lv4
gen cri_lvc5_bi_new   =	corr_submp_lv5
gen cri_lvc6_bi_new   =	corr_decp_lv1+corr_decp_lv5
	
gen cri_cyc3_bi_new   =	.
gen cri_cyc4_bi_new   =	.
gen cri_cyc5_bi_new   =	corr_submp_cy5+corr_submp_cy4
gen cri_cyc6_bi_new   =	corr_decp_cy1+corr_decp_cy2+corr_decp_cy3
	
gen cri_luc3_bi_new   =	.
gen cri_luc4_bi_new   =	ca_criterion
gen cri_luc5_bi_new   =	corr_submp_lu3
gen cri_luc6_bi_new   =	corr_decp_lu1
	
gen cri_chc3_bi_new   =	.
gen cri_chc4_bi_new   =	.
gen cri_chc5_bi_new   =	corr_submp_ch3+corr_submp_ch4
gen cri_chc6_bi_new   =	corr_decp_ch3+corr_decp_ch1+corr_decp_ch2+corr_decp_ch5
	
gen cri_hrc3_bi_new   =	ca_procedure8
gen cri_hrc4_bi_new   =	ca_criterion
gen cri_hrc5_bi_new   =	corr_submp_hr3
gen cri_hrc6_bi_new   =	corr_decp_hr1

gen cri_neuc1_bi_new=cri_euc1_new
gen cri_neuc2_bi_new=new_nocft3
replace cri_neuc2_bi_new=0 if anb_country=="BG" | anb_country=="ES" | anb_country=="DK" | anb_country=="EE" | anb_country=="LT" | anb_country=="CH"

gen cri_neuc3_bi_new =	cri_atc3_bi_new	
replace cri_neuc3_bi_new =	cri_bec3_bi_new if anb_country=="BE"
replace cri_neuc3_bi_new =	cri_bgc3_bi_new if anb_country=="BG"
replace cri_neuc3_bi_new =	cri_cyc3_bi_new if anb_country=="CY"
replace cri_neuc3_bi_new =	cri_czc3_bi_new if anb_country=="CZ"
replace cri_neuc3_bi_new =	cri_dec3_bi_new if anb_country=="DE"
replace cri_neuc3_bi_new =	cri_dkc3_bi_new if anb_country=="DK"
replace cri_neuc3_bi_new =	cri_eec3_bi_new if anb_country=="EE"
replace cri_neuc3_bi_new =	cri_esc3_bi_new if anb_country=="ES"
replace cri_neuc3_bi_new =	cri_fic3_bi_new if anb_country=="FI"
replace cri_neuc3_bi_new =	cri_frc3_bi_new if anb_country=="FR"
replace cri_neuc3_bi_new =	cri_grc3_bi_new if anb_country=="GR"
replace cri_neuc3_bi_new =	cri_huc3_bi_new if anb_country=="HU"
replace cri_neuc3_bi_new =	cri_iec3_bi_new if anb_country=="IE"
replace cri_neuc3_bi_new =	cri_itc3_bi_new if anb_country=="IT"
replace cri_neuc3_bi_new =	cri_ltc3_bi_new if anb_country=="LT"
replace cri_neuc3_bi_new =	cri_luc3_bi_new if anb_country=="LU"
replace cri_neuc3_bi_new =	cri_lvc3_bi_new if anb_country=="LV"
replace cri_neuc3_bi_new =	cri_nlc3_bi_new if anb_country=="NL"
replace cri_neuc3_bi_new =	cri_noc3_bi_new if anb_country=="NO"
replace cri_neuc3_bi_new =	cri_plc3_bi_new if anb_country=="PL"
replace cri_neuc3_bi_new =	cri_ptc3_bi_new if anb_country=="PT"
replace cri_neuc3_bi_new =	cri_roc3_bi_new if anb_country=="RO"
replace cri_neuc3_bi_new =	cri_sec3_bi_new if anb_country=="SE"
replace cri_neuc3_bi_new =	cri_sic3_bi_new if anb_country=="SI"
replace cri_neuc3_bi_new =	cri_skc3_bi_new if anb_country=="SK"
replace cri_neuc3_bi_new =	cri_ukc3_bi_new if anb_country=="UK"
replace cri_neuc3_bi_new =	cri_euc3_bi_new if country==.
replace cri_neuc3_bi_new =	cri_chc3_bi_new if anb_country=="CH"
replace cri_neuc3_bi_new =	cri_hrc3_bi_new if anb_country=="HR"

drop cri_atc3_bi_new cri_bec3_bi_new cri_bgc3_bi_new cri_cyc3_bi_new cri_czc3_bi_new cri_dec3_bi_new cri_dkc3_bi_new cri_eec3_bi_new cri_esc3_bi_new ///
cri_fic3_bi_new cri_frc3_bi_new cri_grc3_bi_new cri_huc3_bi_new cri_iec3_bi_new cri_itc3_bi_new cri_ltc3_bi_new cri_luc3_bi_new cri_lvc3_bi_new ///
cri_nlc3_bi_new cri_noc3_bi_new cri_plc3_bi_new cri_ptc3_bi_new cri_roc3_bi_new cri_sec3_bi_new cri_sic3_bi_new cri_skc3_bi_new cri_ukc3_bi_new ///
cri_chc3_bi_new cri_hrc3_bi_new

gen cri_neuc4_bi_new =	cri_atc4_bi_new	
replace cri_neuc4_bi_new =	cri_bec4_bi_new if anb_country=="BE"
replace cri_neuc4_bi_new =	cri_bgc4_bi_new if anb_country=="BG"
replace cri_neuc4_bi_new =	cri_cyc4_bi_new if anb_country=="CY"
replace cri_neuc4_bi_new =	cri_czc4_bi_new if anb_country=="CZ"
replace cri_neuc4_bi_new =	cri_dec4_bi_new if anb_country=="DE"
replace cri_neuc4_bi_new =	cri_dkc4_bi_new if anb_country=="DK"
replace cri_neuc4_bi_new =	cri_eec4_bi_new if anb_country=="EE"
replace cri_neuc4_bi_new =	cri_esc4_bi_new if anb_country=="ES"
replace cri_neuc4_bi_new =	cri_fic4_bi_new if anb_country=="FI"
replace cri_neuc4_bi_new =	cri_frc4_bi_new if anb_country=="FR"
replace cri_neuc4_bi_new =	cri_grc4_bi_new if anb_country=="GR"
replace cri_neuc4_bi_new =	cri_huc4_bi_new if anb_country=="HU"
replace cri_neuc4_bi_new =	cri_iec4_bi_new if anb_country=="IE"
replace cri_neuc4_bi_new =	cri_itc4_bi_new if anb_country=="IT"
replace cri_neuc4_bi_new =	cri_ltc4_bi_new if anb_country=="LT"
replace cri_neuc4_bi_new =	cri_luc4_bi_new if anb_country=="LU"
replace cri_neuc4_bi_new =	cri_lvc4_bi_new if anb_country=="LV"
replace cri_neuc4_bi_new =	cri_nlc4_bi_new if anb_country=="NL"
replace cri_neuc4_bi_new =	cri_noc4_bi_new if anb_country=="NO"
replace cri_neuc4_bi_new =	cri_plc4_bi_new if anb_country=="PL"
replace cri_neuc4_bi_new =	cri_ptc4_bi_new if anb_country=="PT"
replace cri_neuc4_bi_new =	cri_roc4_bi_new if anb_country=="RO"
replace cri_neuc4_bi_new =	cri_sec4_bi_new if anb_country=="SE"
replace cri_neuc4_bi_new =	cri_sic4_bi_new if anb_country=="SI"
replace cri_neuc4_bi_new =	cri_skc4_bi_new if anb_country=="SK"
replace cri_neuc4_bi_new =	cri_ukc4_bi_new if anb_country=="UK"
replace cri_neuc4_bi_new =	cri_euc4_bi_new if country==.
replace cri_neuc4_bi_new =	cri_chc4_bi_new if anb_country=="CH"
replace cri_neuc4_bi_new =	cri_hrc4_bi_new if anb_country=="HR"

drop cri_atc4_bi_new cri_bec4_bi_new cri_bgc4_bi_new cri_cyc4_bi_new cri_czc4_bi_new cri_dec4_bi_new cri_dkc4_bi_new cri_eec4_bi_new cri_esc4_bi_new ///
cri_fic4_bi_new cri_frc4_bi_new cri_grc4_bi_new cri_huc4_bi_new cri_iec4_bi_new cri_itc4_bi_new cri_ltc4_bi_new cri_luc4_bi_new cri_lvc4_bi_new ///
cri_nlc4_bi_new cri_noc4_bi_new cri_plc4_bi_new cri_ptc4_bi_new cri_roc4_bi_new cri_sec4_bi_new cri_sic4_bi_new cri_skc4_bi_new cri_ukc4_bi_new ///
cri_chc4_bi_new cri_hrc4_bi_new

gen cri_neuc5_bi_new =	cri_atc5_bi_new	
replace cri_neuc5_bi_new =	cri_bec5_bi_new if anb_country=="BE"
replace cri_neuc5_bi_new =	cri_bgc5_bi_new if anb_country=="BG"
replace cri_neuc5_bi_new =	cri_cyc5_bi_new if anb_country=="CY"
replace cri_neuc5_bi_new =	cri_czc5_bi_new if anb_country=="CZ"
replace cri_neuc5_bi_new =	cri_dec5_bi_new if anb_country=="DE"
replace cri_neuc5_bi_new =	cri_dkc5_bi_new if anb_country=="DK"
replace cri_neuc5_bi_new =	cri_eec5_bi_new if anb_country=="EE"
replace cri_neuc5_bi_new =	cri_esc5_bi_new if anb_country=="ES"
replace cri_neuc5_bi_new =	cri_fic5_bi_new if anb_country=="FI"
replace cri_neuc5_bi_new =	cri_frc5_bi_new if anb_country=="FR"
replace cri_neuc5_bi_new =	cri_grc5_bi_new if anb_country=="GR"
replace cri_neuc5_bi_new =	cri_huc5_bi_new if anb_country=="HU"
replace cri_neuc5_bi_new =	cri_iec5_bi_new if anb_country=="IE"
replace cri_neuc5_bi_new =	cri_itc5_bi_new if anb_country=="IT"
replace cri_neuc5_bi_new =	cri_ltc5_bi_new if anb_country=="LT"
replace cri_neuc5_bi_new =	cri_luc5_bi_new if anb_country=="LU"
replace cri_neuc5_bi_new =	cri_lvc5_bi_new if anb_country=="LV"
replace cri_neuc5_bi_new =	cri_nlc5_bi_new if anb_country=="NL"
replace cri_neuc5_bi_new =	cri_noc5_bi_new if anb_country=="NO"
replace cri_neuc5_bi_new =	cri_plc5_bi_new if anb_country=="PL"
replace cri_neuc5_bi_new =	cri_ptc5_bi_new if anb_country=="PT"
replace cri_neuc5_bi_new =	cri_roc5_bi_new if anb_country=="RO"
replace cri_neuc5_bi_new =	cri_sec5_bi_new if anb_country=="SE"
replace cri_neuc5_bi_new =	cri_sic5_bi_new if anb_country=="SI"
replace cri_neuc5_bi_new =	cri_skc5_bi_new if anb_country=="SK"
replace cri_neuc5_bi_new =	cri_ukc5_bi_new if anb_country=="UK"
replace cri_neuc5_bi_new =	cri_chc5_bi_new if anb_country=="CH"
replace cri_neuc5_bi_new =	cri_hrc5_bi_new if anb_country=="HR"
replace cri_neuc5_bi_new =	cri_euc5_bi_new if country==.

drop cri_atc5_bi_new cri_bec5_bi_new cri_bgc5_bi_new cri_cyc5_bi_new cri_czc5_bi_new cri_dec5_bi_new cri_dkc5_bi_new cri_eec5_bi_new cri_esc5_bi_new ///
cri_fic5_bi_new cri_frc5_bi_new cri_grc5_bi_new cri_huc5_bi_new cri_iec5_bi_new cri_itc5_bi_new cri_ltc5_bi_new cri_luc5_bi_new cri_lvc5_bi_new ///
cri_nlc5_bi_new cri_noc5_bi_new cri_plc5_bi_new cri_ptc5_bi_new cri_roc5_bi_new cri_sec5_bi_new cri_sic5_bi_new cri_skc5_bi_new cri_ukc5_bi_new ///
cri_chc5_bi_new cri_hrc5_bi_new

gen	cri_neuc6_bi_new = cri_atc6_bi_new	
replace	cri_neuc6_bi_new = cri_bec6_bi_new if anb_country=="BE"
replace	cri_neuc6_bi_new = cri_bgc6_bi_new if anb_country=="BG"
replace	cri_neuc6_bi_new = cri_cyc6_bi_new if anb_country=="CY"
replace	cri_neuc6_bi_new = cri_czc6_bi_new if anb_country=="CZ"
replace	cri_neuc6_bi_new = cri_dec6_bi_new if anb_country=="DE"
replace	cri_neuc6_bi_new = cri_dkc6_bi_new if anb_country=="DK"
replace	cri_neuc6_bi_new = cri_eec6_bi_new if anb_country=="EE"
replace	cri_neuc6_bi_new = cri_esc6_bi_new if anb_country=="ES"
replace	cri_neuc6_bi_new = cri_fic6_bi_new if anb_country=="FI"
replace	cri_neuc6_bi_new = cri_frc6_bi_new if anb_country=="FR"
replace	cri_neuc6_bi_new = cri_grc6_bi_new if anb_country=="GR"
replace	cri_neuc6_bi_new = cri_huc6_bi_new if anb_country=="HU"
replace	cri_neuc6_bi_new = cri_iec6_bi_new if anb_country=="IE"
replace	cri_neuc6_bi_new = cri_itc6_bi_new if anb_country=="IT"
replace	cri_neuc6_bi_new = cri_ltc6_bi_new if anb_country=="LT"
replace	cri_neuc6_bi_new = cri_luc6_bi_new if anb_country=="LU"
replace	cri_neuc6_bi_new = cri_lvc6_bi_new if anb_country=="LV"
replace	cri_neuc6_bi_new = cri_nlc6_bi_new if anb_country=="NL"
replace	cri_neuc6_bi_new = cri_noc6_bi_new if anb_country=="NO"
replace	cri_neuc6_bi_new = cri_plc6_bi_new if anb_country=="PL"
replace	cri_neuc6_bi_new = cri_ptc6_bi_new if anb_country=="PT"
replace	cri_neuc6_bi_new = cri_roc6_bi_new if anb_country=="RO"
replace	cri_neuc6_bi_new = cri_sec6_bi_new if anb_country=="SE"
replace	cri_neuc6_bi_new = cri_sic6_bi_new if anb_country=="SI"
replace	cri_neuc6_bi_new = cri_skc6_bi_new if anb_country=="SK"
replace	cri_neuc6_bi_new = cri_ukc6_bi_new if anb_country=="UK"
replace	cri_neuc6_bi_new = cri_euc6_bi_new if country==.
replace cri_neuc6_bi_new = cri_chc6_bi_new if anb_country=="CH"
replace cri_neuc6_bi_new = cri_hrc6_bi_new if anb_country=="HR"

drop cri_atc6_bi_new cri_bec6_bi_new cri_bgc6_bi_new cri_cyc6_bi_new cri_czc6_bi_new cri_dec6_bi_new cri_dkc6_bi_new cri_eec6_bi_new cri_esc6_bi_new ///
cri_fic6_bi_new cri_frc6_bi_new cri_grc6_bi_new cri_huc6_bi_new cri_iec6_bi_new cri_itc6_bi_new cri_ltc6_bi_new cri_luc6_bi_new cri_lvc6_bi_new ///
cri_nlc6_bi_new cri_noc6_bi_new cri_plc6_bi_new cri_ptc6_bi_new cri_roc6_bi_new cri_sec6_bi_new cri_sic6_bi_new cri_skc6_bi_new cri_ukc6_bi_new ///
cri_chc6_bi_new cri_hrc6_bi_new

replace cri_neuc5_bi_new =. if nocft==1
replace cri_neuc6_bi_new =. if nocft==1


gen cri_neuac1_new=cri_euac1_new
gen cri_aneu_new=.
replace cri_aneu_new=cri_neu_new-(cri_neuc1_new)/6+(cri_neuac1_new)/6 if nocft==0
replace cri_aneu_new=cri_neu_new-(cri_neuc1_new)/5+(cri_neuac1_new)/5 if nocft==0 & (anb_country=="BG" | anb_country=="DE" | anb_country=="ES" | anb_country=="GR" | anb_country=="DK" | anb_country=="EE" | anb_country=="LT" | anb_country=="LU" | anb_country=="SE" | anb_country=="HU")
replace cri_aneu_new=cri_neu_new-(cri_neuc1_new)/3+(cri_neuac1_new)/3 if nocft==0 & anb_country=="CH"
replace cri_aneu_new=cri_neu_new-(cri_neuc1_new)/4+(cri_neuac1_new)/4 if nocft==0 & anb_country=="CY"
replace cri_aneu_new=cri_neu_new-(cri_neuc1_new)/4+(cri_neuac1_new)/4 if nocft==1
replace cri_aneu_new=cri_neu_new-(cri_neuc1_new)/3+(cri_neuac1_new)/3 if nocft==1 & (anb_country=="BG" | anb_country=="ES" | anb_country=="GR" | anb_country=="DK" | anb_country=="EE" | anb_country=="LT" | anb_country=="LU" | anb_country=="SE")
replace cri_aneu_new=cri_neu_new-(cri_neuc1_new)/1+(cri_neuac1_new)/1 if nocft==1 & anb_country=="CH"
replace cri_aneu_new=cri_neu_new-(cri_neuc1_new)/2+(cri_neuac1_new)/2 if nocft==1 & anb_country=="CY"

gen cri_aneu_bi_new=.
replace cri_aneu_bi_new=cri_neu_bi_new-(cri_neuc1_new)/6+(cri_neuac1_new)/6 if nocft==0
replace cri_aneu_bi_new=cri_neu_bi_new-(cri_neuc1_new)/5+(cri_neuac1_new)/5 if nocft==0 & (anb_country=="BG" | anb_country=="DE" | anb_country=="ES" | anb_country=="GR" | anb_country=="DK" | anb_country=="EE" | anb_country=="LT" | anb_country=="LU" | anb_country=="SE" | anb_country=="HU")
replace cri_aneu_bi_new=cri_neu_bi_new-(cri_neuc1_new)/4+(cri_neuac1_new)/4 if nocft==0 & anb_country=="CY"
replace cri_aneu_bi_new=cri_neu_bi_new-(cri_neuc1_new)/3+(cri_neuac1_new)/3 if nocft==0 & anb_country=="CH"
replace cri_aneu_bi_new=cri_neu_bi_new-(cri_neuc1_new)/4+(cri_neuac1_new)/4 if nocft==1
replace cri_aneu_bi_new=cri_neu_bi_new-(cri_neuc1_new)/3+(cri_neuac1_new)/3 if nocft==1 & (anb_country=="BG" | anb_country=="ES" | anb_country=="GR" | anb_country=="DK" | anb_country=="EE" | anb_country=="LT" | anb_country=="LU" | anb_country=="SE")
replace cri_aneu_bi_new=cri_neu_bi_new-(cri_neuc1_new)/2+(cri_neuac1_new)/2 if nocft==1 & anb_country=="CY"
replace cri_aneu_bi_new=cri_neu_bi_new-(cri_neuc1_new)/1+(cri_neuac1_new)/1 if nocft==1 & anb_country=="CH"


*generating new three-level dummy for main binary regression

gen new_procedure = cri_neuc3_bi_new
replace new_procedure = 2 if cri_neuc3_bi_new==0
replace new_procedure = 0 if ca_procedure==7
replace new_procedure =2 if new_procedure==.
tab new_procedure, missing

tab nocft_new cri_neuc2_new, missing
gen new_corr_nocft=cri_neuc2_new
replace new_corr_nocft=2 if nocft_new==1
tab new_corr_nocft, missing

gen new_wnonpr = cri_neuc4_bi_new
replace new_wnonpr = 2 if cri_neuc4_bi_new==0
replace new_wnonpr = 0 if cri_neuc4_bi_new==0 & (anb_country == "BG" | anb_country == "CH" | anb_country == "CY" | anb_country == "CZ" | anb_country == "ES" | anb_country == "GR" | anb_country == "HR" | anb_country == "LU" | anb_country == "PT" | anb_country == "SK")
replace new_wnonpr = 0 if corr_wnonpr_at == 3 & anb_country=="AT"
replace new_wnonpr = 0 if corr_wnonpr_be == 2 & anb_country=="BE"
replace new_wnonpr = 0 if corr_wnonpr_de == 3 & anb_country=="DE"
replace new_wnonpr = 0 if corr_wnonpr_dk == 3 & anb_country=="DK"
replace new_wnonpr = 0 if corr_wnonpr_ee == 1 & anb_country=="EE"
replace new_wnonpr = 0 if corr_wnonpr_fi == 2 & anb_country=="FI"
replace new_wnonpr = 0 if corr_wnonpr_fr == 3 & anb_country=="FR"
replace new_wnonpr = 0 if corr_wnonpr_hu == 2 & anb_country=="HU"
replace new_wnonpr = 0 if corr_wnonpr_ie == 2 & anb_country=="IE"
replace new_wnonpr = 0 if corr_wnonpr_it == 2 & anb_country=="IT"
replace new_wnonpr = 0 if corr_wnonpr_lt == 2 & anb_country=="LT"
replace new_wnonpr = 0 if corr_wnonpr_lv == 2 & anb_country=="LV"
replace new_wnonpr = 0 if corr_wnonpr_nl == 3 & anb_country=="NL"
replace new_wnonpr = 0 if corr_wnonpr_no == 2 & anb_country=="NO"
replace new_wnonpr = 0 if corr_wnonpr_pl == 4 & anb_country=="PL"
replace new_wnonpr = 0 if corr_wnonpr_ro == 3 & anb_country=="RO"
replace new_wnonpr = 0 if corr_wnonpr_se == 3 & anb_country=="SE"
replace new_wnonpr = 0 if corr_wnonpr_si == 2 & anb_country=="SI"
replace new_wnonpr = 0 if corr_wnonpr_uk == 3 & anb_country=="UK"
tab new_wnonpr, missing

gen new_submp = cri_neuc5_bi_new
replace new_submp = 2 if cri_neuc5_bi_new==0
replace new_submp = 0 if corr_submp_at == 3 & anb_country=="AT"
replace new_submp = 0 if corr_submp_be == 2 & anb_country=="BE"
replace new_submp = 0 if corr_submp_bg == 3 & anb_country=="BG"
replace new_submp = 0 if corr_submp_ch == 2 & anb_country=="CH"
replace new_submp = 0 if corr_submp_cy == 3 & anb_country=="CY"
replace new_submp = 0 if corr_submp_cz == 2 & anb_country=="CZ"
replace new_submp = 0 if corr_submp_de == 3 & anb_country=="DE"
replace new_submp = 0 if corr_submp_dk == 3 & anb_country=="DK"
replace new_submp = 0 if corr_submp_ee == 4 & anb_country=="EE"
replace new_submp = 0 if corr_submp_es == 2 & anb_country=="ES"
replace new_submp = 0 if corr_submp_fi == 2 & anb_country=="FI"
replace new_submp = 0 if corr_submp_fr == 2 & anb_country=="FR"
replace new_submp = 0 if corr_submp_gr == 2 & anb_country=="GR"
replace new_submp = 0 if corr_submp_hr == 2 & anb_country=="HR"
replace new_submp = 0 if corr_submp_hu == 3 & anb_country=="HU"
replace new_submp = 0 if corr_submp_ie == 3 & anb_country=="IE"
replace new_submp = 0 if corr_submp_it == 1 & anb_country=="IT"
replace new_submp = 0 if corr_submp_lt == 2 & anb_country=="LT"
replace new_submp = 0 if corr_submp_lu == 2 & anb_country=="LU"
replace new_submp = 0 if corr_submp_lv == 3 & anb_country=="LV"
replace new_submp = 0 if corr_submp_nl == 3 & anb_country=="NL"
replace new_submp = 0 if corr_submp_no == 3 & anb_country=="NO"
replace new_submp = 0 if corr_submp_pl == 2 & anb_country=="PL"
replace new_submp = 0 if corr_submp_pt == 1 & anb_country=="PT"
replace new_submp = 0 if corr_submp_ro == 1 & anb_country=="RO"
replace new_submp = 0 if corr_submp_se == 3 & anb_country=="SE"
replace new_submp = 0 if corr_submp_si == 3 & anb_country=="SI"
replace new_submp = 0 if corr_submp_sk == 3 & anb_country=="SK"
replace new_submp = 0 if corr_submp_uk == 1 & anb_country=="UK"
tab new_submp, missing

gen new_decp = cri_neuc6_bi_new
replace new_decp = 2 if cri_neuc6_bi_new==0
replace new_decp = 0 if corr_decp_at == 3 & anb_country=="AT"
replace new_decp = 0 if corr_decp_be == 3 & anb_country=="BE"
replace new_decp = 0 if corr_decp_bg == 3 & anb_country=="BG"
replace new_decp = 0 if corr_decp_ch == 4 & anb_country=="CH"
replace new_decp = 0 if corr_decp_cy == 4 & anb_country=="CY"
replace new_decp = 0 if corr_decp_cz == 4 & anb_country=="CZ"
replace new_decp = 0 if corr_decp_de == 3 & anb_country=="DE"
replace new_decp = 0 if corr_decp_dk == 3 & anb_country=="DK"
replace new_decp = 0 if corr_decp_ee == 3 & anb_country=="EE"
replace new_decp = 0 if corr_decp_es == 2 & anb_country=="ES"
replace new_decp = 0 if corr_decp_fi == 4 & anb_country=="FI"
replace new_decp = 0 if corr_decp_fr == 3 & anb_country=="FR"
replace new_decp = 0 if corr_decp_gr == 3 & anb_country=="GR"
replace new_decp = 0 if corr_decp_hr == 3 & anb_country=="HR"
replace new_decp = 0 if corr_decp_hu == 3 & anb_country=="HU"
replace new_decp = 0 if corr_decp_ie == 2 & anb_country=="IE"
replace new_decp = 0 if corr_decp_it == 3 & anb_country=="IT"
replace new_decp = 0 if corr_decp_lt == 4 & anb_country=="LT"
replace new_decp = 0 if corr_decp_lu == 2 & anb_country=="LU"
replace new_decp = 0 if corr_decp_lv == 4 & anb_country=="LV"
replace new_decp = 0 if corr_decp_nl == 2 & anb_country=="NL"
replace new_decp = 0 if corr_decp_no == 3 & anb_country=="NO"
replace new_decp = 0 if corr_decp_pl == 4 & anb_country=="PL"
replace new_decp = 0 if corr_decp_pt == 3 & anb_country=="PT"
replace new_decp = 0 if corr_decp_ro == 4 & anb_country=="RO"
replace new_decp = 0 if corr_decp_se == 3 & anb_country=="SE"
replace new_decp = 0 if corr_decp_si == 4 & anb_country=="SI"
replace new_decp = 0 if corr_decp_sk == 4 & anb_country=="SK"
replace new_decp = 0 if corr_decp_uk == 2 & anb_country=="UK"
tab new_decp, missing

drop corr_submp corr_decp corr_wnonpr corr_submp_it corr_decp_it corr_wnonpr_it corr_submp_uk corr_decp_uk corr_wnonpr_uk corr_submp_sk corr_decp_sk ///
corr_wnonpr_sk corr_submp_ro corr_decp_ro corr_wnonpr_ro corr_submp_bg corr_decp_bg corr_wnonpr_bg corr_submp_de corr_decp_de corr_wnonpr_de corr_submp_es ///
corr_decp_es corr_wnonpr_es corr_submp_fr corr_decp_fr corr_wnonpr_fr corr_submp_pl corr_decp_pl corr_wnonpr_pl corr_submp_nl corr_decp_nl corr_wnonpr_nl ///
corr_submp_gr corr_decp_gr corr_wnonpr_gr corr_submp_dk corr_decp_dk corr_wnonpr_dk corr_submp_at corr_decp_at corr_wnonpr_at corr_submp_be corr_decp_be ///
corr_wnonpr_be corr_submp_si corr_decp_si corr_wnonpr_si corr_submp_ee corr_decp_ee corr_wnonpr_ee corr_submp_se corr_decp_se corr_wnonpr_se corr_submp_ie ///
corr_decp_ie corr_wnonpr_ie corr_submp_cz corr_decp_cz corr_wnonpr_cz corr_submp_fi corr_decp_fi corr_wnonpr_fi corr_submp_hu corr_decp_hu corr_wnonpr_hu ///
corr_submp_no corr_decp_no corr_wnonpr_no corr_submp_pt corr_decp_pt corr_submp_lt corr_decp_lt corr_wnonpr_lt corr_submp_lv corr_decp_lv corr_wnonpr_lv ///
corr_submp_cy corr_decp_cy corr_submp_lu corr_decp_lu corr_submp_ch corr_decp_ch corr_submp_hr corr_decp_hr

sum singleb new_corr_nocft new_procedure new_wnonpr new_submp new_decp
sum anb_csector anb_type year country ca_cpv_div lca_contract_value mcvfilter_ok
*lot of missing for submp and decp
replace new_submp=2 if new_submp==.
replace new_decp=2 if new_decp==.

*alternative with two categories only
gen binew_corr_nocft=0
replace binew_corr_nocft=1 if new_corr_nocft==1
gen binew_procedure=0
replace binew_procedure=1 if new_procedure==1
gen binew_wnonpr =0
replace binew_wnonpr=1 if new_wnonpr==1
gen binew_submp =0
replace binew_submp=1 if new_submp==1
gen binew_decp=0
replace binew_decp=1 if new_decp==1

keep year id_notice anb_country id_award id mcvfilter_ok singleb ///
 cri_eu_new cri_aeu_new cri_euc1_new cri_euac1_new cri_euc2_new cri_euc3_new cri_euc4_new cri_euc5_new cri_euc6_new ///
 cri_neu_new cri_aneu_new cri_neuc1_new cri_neuac1_new cri_neuc2_new cri_neuc3_new cri_neuc4_new cri_neuc5_new cri_neuc6_new ///
 cri_eu_bi_new cri_aeu_bi_new cri_euc3_bi_new cri_euc4_bi_new cri_euc5_bi_new cri_euc6_bi_new ///
 cri_neu_bi_new cri_aneu_bi_new cri_neuc3_bi_new cri_neuc4_bi_new cri_neuc5_bi_new cri_neuc6_bi_new ///
 binew_corr_nocft binew_procedure binew_wnonpr binew_submp binew_decp

save "..\data\cri_data.dta", replace

