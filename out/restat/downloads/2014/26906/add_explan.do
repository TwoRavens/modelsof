capture g ctlong=""
replace ct=upper(ct)
replace ctlong="KENT" if upper(ct)=="KEN"
replace ctlong="SURREY" if upper(ct)=="SUR"
replace ctlong="HEREFORDSHIRE" if upper(ct)=="HER"
replace ctlong="HERTFORDSHIRE" if upper(ct)=="HRT"
replace ctlong="ROSS AND CROMARTY" if upper(ct)=="ROC"
replace ctlong="HUNTINGDONSHIRE" if upper(ct)=="HUN"
replace ctlong="INVERNESS-SHIRE" if upper(ct)=="INV"
replace ctlong="ABERDEENSHIRE" if upper(ct)=="ABD"
replace ctlong="ANGLESEY" if upper(ct)=="AGY"
replace ctlong="ARGYLLSHIRE" if upper(ct)=="ARL"
replace ctlong="AYRSHIRE" if upper(ct)=="AYR"
replace ctlong="BANFFSHIRE" if upper(ct)=="BAN"
replace ctlong="BEDFORDSHIRE" if upper(ct)=="BDF"
replace ctlong="BERKSHIRE" if upper(ct)=="BRK"
replace ctlong="BERKSHIRE" if upper(ct)=="BEK"
replace ctlong="BERWICKSHIRE" if upper(ct)=="BEW"
replace ctlong="BRECKNOCKSHIRE" if upper(ct)=="BRE"
replace ctlong="BUCKINGHAMSHIRE" if upper(ct)=="BUK"
replace ctlong="CAMBRIDGESHIRE" if upper(ct)=="CAM"
replace ctlong="CARDIGANSHIRE" if upper(ct)=="CGN"
replace ctlong="CARMARTHENSHIRE" if upper(ct)=="CHH"
replace ctlong="CARNARVONSHIRE" if upper(ct)=="CAE"
replace ctlong="CHESHIRE" if upper(ct)=="CHS"
replace ctlong="CORNWALL" if upper(ct)=="CON"
replace ctlong="CUMBERLAND" if upper(ct)=="CUL"
replace ctlong="DENBIGHSHIRE" if upper(ct)=="DBG"
replace ctlong="DERBYSHIRE" if upper(ct)=="DBY"
replace ctlong="DEVONSHIRE" if upper(ct)=="DEV"
replace ctlong="DORSETSHIRE" if upper(ct)=="DOR"
replace ctlong="DURHAM" if upper(ct)=="DUR"
replace ctlong="EDINBURGHSHIRE" if upper(ct)=="EDI"
replace ctlong="ESSEX" if upper(ct)=="ESS"
replace ctlong="FIFESHIRE" if upper(ct)=="FIF"
replace ctlong="FORFARSHIRE" if upper(ct)=="FOR"
replace ctlong="GLAMORGANSHIRE" if upper(ct)=="GLA"
replace ctlong="GLOUCESTERSHIRE" if upper(ct)=="GLS"
replace ctlong="HAMPSHIRE" if upper(ct)=="HAM"
replace ctlong="KINCARDINESHIRE" if upper(ct)=="KCD"
replace ctlong="LANARKSHIRE" if upper(ct)=="LKS"
replace ctlong="LANCASHIRE" if upper(ct)=="LAN"
replace ctlong="LEICESTERSHIRE" if upper(ct)=="LEI"
replace ctlong="LINCOLNSHIRE" if upper(ct)=="LIN"
replace ctlong="LINLITHGOWSHIRE" if upper(ct)=="LGO"
replace ctlong="MERIONETHSHIRE" if upper(ct)=="MER"
replace ctlong="MIDDLESEX" if upper(ct)=="MDX"
replace ctlong="MONMOUTHSHIRE" if upper(ct)=="MNM"
replace ctlong="MONTGOMERYSHIRE" if upper(ct)=="MNT"
replace ctlong="NAIRNSHIRE" if upper(ct)=="NAI"
replace ctlong="NORFOLK" if upper(ct)=="NFK"
replace ctlong="NORTHAMTONSHIRE" if upper(ct)=="NTH"
replace ctlong="NORTHUMBERLAND" if upper(ct)=="NBL"
replace ctlong="NOTTINGHAMSHIRE" if upper(ct)=="NTT"
replace ctlong="ORKNEY" if upper(ct)=="OKI"
replace ctlong="OXFORDSHIRE" if upper(ct)=="OXF"
replace ctlong="PEMBROKESHIRE" if upper(ct)=="PEM"
replace ctlong="PERTHSHIRE" if upper(ct)=="PER"
replace ctlong="RADNORSHIRE" if upper(ct)=="RAD"
replace ctlong="RUTLANDSHIRE" if upper(ct)=="RUT"
replace ctlong="SHETLAND" if upper(ct)=="SHI"
replace ctlong="SHROPSHIRE" if upper(ct)=="SAL"
replace ctlong="SOMERSETSHIRE" if upper(ct)=="SOM"
replace ctlong="STAFFORDSHIRE" if upper(ct)=="STA"
replace ctlong="SUFFOLK" if upper(ct)=="SUF"
replace ctlong="SUSSEX" if upper(ct)=="SUS"
replace ctlong="WARWICKSHIRE" if upper(ct)=="WAR"
replace ctlong="WESTMORLAND" if upper(ct)=="WLN"
replace ctlong="WILTSHIRE" if upper(ct)=="WIL"
replace ctlong="WORCERSTERSHIRE" if upper(ct)=="WOR"
replace ctlong="YORKSHIRE" if upper(ct)=="YKS"
replace ctlong="UNKNOWN" if upper(ct)=="YYY"

g density	=.
replace density=.3135634	if ctlong=="KENT"
replace density=.2657594	if ctlong=="SUSSEX"
replace density=.752694	if ctlong=="ESSEX"
replace density=.3677596	if ctlong=="SUFFOLK"
replace density=.2740896	if ctlong=="CAMBRIDGESHIRE"
replace density=.3606406	if ctlong=="NORFOLK"
replace density=.2530424	if ctlong=="BEDFORDSHIRE"
replace density=.2850559	if ctlong=="BERKSHIRE"
replace density=.3256073	if ctlong=="BUCKINGHAMSHIRE"
replace density=.4057923	if ctlong=="HEREFORDSHIRE"
replace density=.2464478	if ctlong=="HUNTINGDONSHIRE"
replace density=.409513	if ctlong=="SURREY"
replace density=.2977535	if ctlong=="HAMPSHIRE"
replace density=.7630534	if ctlong=="WILTSHIRE"
replace density=.3555246	if ctlong=="OXFORDSHIRE"
replace density=.2281069	if ctlong=="DORSETSHIRE"
replace density=.3795076	if ctlong=="SOMERSETSHIRE"
replace density=.4648837	if ctlong=="DEVONSHIRE"
replace density=1.553241	if ctlong=="GLOUCESTERSHIRE"
replace density=.2245737	if ctlong=="CORNWALL"


g grain	=.
replace grain=13.64756	if ctlong=="KENT"
replace grain=11.44244	if ctlong=="SUSSEX"
replace grain=17.03483	if ctlong=="ESSEX"
replace grain=18.97795	if ctlong=="SUFFOLK"
replace grain=19.08522	if ctlong=="CAMBRIDGESHIRE"
replace grain=15.61328	if ctlong=="NORFOLK"
replace grain=15.53614	if ctlong=="BEDFORDSHIRE"
replace grain=14.38004	if ctlong=="BERKSHIRE"
replace grain=13.82809	if ctlong=="BUCKINGHAMSHIRE"
replace grain=13.68991	if ctlong=="HEREFORDSHIRE"
replace grain=11.90363	if ctlong=="HUNTINGDONSHIRE"
replace grain=11.14759	if ctlong=="SURREY"
replace grain=14.29408	if ctlong=="HAMPSHIRE"
replace grain=10.14362	if ctlong=="WILTSHIRE"
replace grain=14.59961	if ctlong=="OXFORDSHIRE"
replace grain=7.371398	if ctlong=="DORSETSHIRE"
replace grain=4.476939	if ctlong=="SOMERSETSHIRE"
replace grain=6.951324	if ctlong=="DEVONSHIRE"
replace grain=7.14378	if ctlong=="GLOUCESTERSHIRE"
replace grain=7.234149	if ctlong=="CORNWALL"

g wealth	=.
replace wealth=4.319466	if ctlong=="KENT"
replace wealth=3.818488	if ctlong=="SUSSEX"
replace wealth=4.207257	if ctlong=="ESSEX"
replace wealth=5.780763	if ctlong=="SUFFOLK"
replace wealth=4.907123	if ctlong=="CAMBRIDGESHIRE"
replace wealth=5.039505	if ctlong=="NORFOLK"
replace wealth=4.19376	if ctlong=="BEDFORDSHIRE"
replace wealth=5.532763	if ctlong=="BERKSHIRE"
replace wealth=4.339387	if ctlong=="BUCKINGHAMSHIRE"
replace wealth=4.287027	if ctlong=="HEREFORDSHIRE"
replace wealth=7.825278	if ctlong=="HUNTINGDONSHIRE"
replace wealth=4.433768	if ctlong=="SURREY"
replace wealth=4.462814	if ctlong=="HAMPSHIRE"
replace wealth=4.502394	if ctlong=="WILTSHIRE"
replace wealth=4.082205	if ctlong=="OXFORDSHIRE"
replace wealth=3.909531	if ctlong=="DORSETSHIRE"
replace wealth=4.782697	if ctlong=="SOMERSETSHIRE"
replace wealth=4.345588	if ctlong=="DEVONSHIRE"
replace wealth=8.103901	if ctlong=="GLOUCESTERSHIRE"
replace wealth=4.794369	if ctlong=="CORNWALL"

g cottind	=.
replace cottind=.0416667	if ctlong=="KENT"
replace cottind=0	if ctlong=="SUSSEX"
replace cottind=.1428571	if ctlong=="ESSEX"
replace cottind=0	if ctlong=="SUFFOLK"
replace cottind=.1	if ctlong=="CAMBRIDGESHIRE"
replace cottind=.0666667	if ctlong=="NORFOLK"
replace cottind=1	if ctlong=="BEDFORDSHIRE"
replace cottind=.2666667	if ctlong=="BERKSHIRE"
replace cottind=.8235294	if ctlong=="BUCKINGHAMSHIRE"
replace cottind=.5555556	if ctlong=="HEREFORDSHIRE"
replace cottind=.1428571	if ctlong=="HUNTINGDONSHIRE"
replace cottind=.1538462	if ctlong=="SURREY"
replace cottind=.1034483	if ctlong=="HAMPSHIRE"
replace cottind=.4	if ctlong=="WILTSHIRE"
replace cottind=.8571429	if ctlong=="OXFORDSHIRE"
replace cottind=1	if ctlong=="DORSETSHIRE"
replace cottind=.5	if ctlong=="SOMERSETSHIRE"
replace cottind=.4444444	if ctlong=="DEVONSHIRE"
replace cottind=.1666667	if ctlong=="GLOUCESTERSHIRE"
replace cottind=.2142857	if ctlong=="CORNWALL"

g gp=.
replace ct=lower(ct)
replace gp=67.65	if ct=="bdf"	& year10==1770
replace gp=64.84	if ct=="bdf"	& year10==1780
replace gp=81.256	if ct=="bdf"	& year10==1790
replace gp=120.751	if ct=="bdf"	& year10==1800
replace gp=128.77	if ct=="bdf"	& year10==1810
replace gp=93.945	if ct=="bdf"	& year10==1820
replace gp=85.624	if ct=="bdf"	& year10==1830
replace gp=98.095	if ct=="bdf"	& year10==1840
replace gp=68.70111	if ct=="bek"	& year10==1770
replace gp=66.539	if ct=="bek"	& year10==1780
replace gp=85.287	if ct=="bek"	& year10==1790
replace gp=128.993	if ct=="bek"	& year10==1800
replace gp=139.975	if ct=="bek"	& year10==1810
replace gp=98.06	if ct=="bek"	& year10==1820
replace gp=92.591	if ct=="bek"	& year10==1830
replace gp=105.11	if ct=="bek"	& year10==1840
replace gp=69.38556	if ct=="buk"	& year10==1770
replace gp=65.681	if ct=="buk"	& year10==1780
replace gp=83.728	if ct=="buk"	& year10==1790
replace gp=123.502	if ct=="buk"	& year10==1800
replace gp=136.109	if ct=="buk"	& year10==1810
replace gp=95.75999	if ct=="buk"	& year10==1820
replace gp=85.009	if ct=="buk"	& year10==1830
replace gp=96.72	if ct=="buk"	& year10==1840
replace gp=64.50111	if ct=="cam"	& year10==1770
replace gp=63.253	if ct=="cam"	& year10==1780
replace gp=76.386	if ct=="cam"	& year10==1790
replace gp=115.663	if ct=="cam"	& year10==1800
replace gp=123.787	if ct=="cam"	& year10==1810
replace gp=80.425	if ct=="cam"	& year10==1820
replace gp=80.726	if ct=="cam"	& year10==1830
replace gp=94.32	if ct=="cam"	& year10==1840
replace gp=72.46223	if ct=="chs"	& year10==1770
replace gp=72.609	if ct=="chs"	& year10==1780
replace gp=85.237	if ct=="chs"	& year10==1790
replace gp=120.932	if ct=="chs"	& year10==1800
replace gp=130.104	if ct=="chs"	& year10==1810
replace gp=87.2925	if ct=="chs"	& year10==1820
replace gp=85.649	if ct=="chs"	& year10==1830
replace gp=95.795	if ct=="chs"	& year10==1840
replace gp=65.81333	if ct=="con"	& year10==1770
replace gp=70.734	if ct=="con"	& year10==1780
replace gp=84.985	if ct=="con"	& year10==1790
replace gp=123.888	if ct=="con"	& year10==1800
replace gp=137.653	if ct=="con"	& year10==1810
replace gp=91.56	if ct=="con"	& year10==1820
replace gp=90.158	if ct=="con"	& year10==1830
replace gp=96.615	if ct=="con"	& year10==1840
replace gp=67.35333	if ct=="cul"	& year10==1770
replace gp=68.221	if ct=="cul"	& year10==1780
replace gp=86.955	if ct=="cul"	& year10==1790
replace gp=126.518	if ct=="cul"	& year10==1800
replace gp=127.038	if ct=="cul"	& year10==1810
replace gp=90.135	if ct=="cul"	& year10==1820
replace gp=87.926	if ct=="cul"	& year10==1830
replace gp=94.465	if ct=="cul"	& year10==1840
replace gp=73.2	if ct=="dby"	& year10==1770
replace gp=71.7	if ct=="dby"	& year10==1780
replace gp=91.882	if ct=="dby"	& year10==1790
replace gp=131.035	if ct=="dby"	& year10==1800
replace gp=134.937	if ct=="dby"	& year10==1810
replace gp=96.775	if ct=="dby"	& year10==1820
replace gp=90.846	if ct=="dby"	& year10==1830
replace gp=103.635	if ct=="dby"	& year10==1840
replace gp=68.87666	if ct=="dev"	& year10==1770
replace gp=72.292	if ct=="dev"	& year10==1780
replace gp=89.625	if ct=="dev"	& year10==1790
replace gp=127.579	if ct=="dev"	& year10==1800
replace gp=143.662	if ct=="dev"	& year10==1810
replace gp=92.93125	if ct=="dev"	& year10==1820
replace gp=90.492	if ct=="dev"	& year10==1830
replace gp=100.18	if ct=="dev"	& year10==1840
replace gp=70.87444	if ct=="dor"	& year10==1770
replace gp=70.396	if ct=="dor"	& year10==1780
replace gp=87.185	if ct=="dor"	& year10==1790
replace gp=126.359	if ct=="dor"	& year10==1800
replace gp=140.455	if ct=="dor"	& year10==1810
replace gp=88.47	if ct=="dor"	& year10==1820
replace gp=85.372	if ct=="dor"	& year10==1830
replace gp=95.62	if ct=="dor"	& year10==1840
replace gp=64.78	if ct=="dur"	& year10==1770
replace gp=66.848	if ct=="dur"	& year10==1780
replace gp=81.437	if ct=="dur"	& year10==1790
replace gp=122.424	if ct=="dur"	& year10==1800
replace gp=125.381	if ct=="dur"	& year10==1810
replace gp=86.41	if ct=="dur"	& year10==1820
replace gp=84.861	if ct=="dur"	& year10==1830
replace gp=97.22	if ct=="dur"	& year10==1840
replace gp=63.83222	if ct=="ess"	& year10==1770
replace gp=62.984	if ct=="ess"	& year10==1780
replace gp=82.729	if ct=="ess"	& year10==1790
replace gp=125.324	if ct=="ess"	& year10==1800
replace gp=130.279	if ct=="ess"	& year10==1810
replace gp=88.205	if ct=="ess"	& year10==1820
replace gp=88.044	if ct=="ess"	& year10==1830
replace gp=100.78	if ct=="ess"	& year10==1840
replace gp=74.10555	if ct=="gls"	& year10==1770
replace gp=68.604	if ct=="gls"	& year10==1780
replace gp=88.576	if ct=="gls"	& year10==1790
replace gp=129.862	if ct=="gls"	& year10==1800
replace gp=144.11	if ct=="gls"	& year10==1810
replace gp=88.47625	if ct=="gls"	& year10==1820
replace gp=84.95	if ct=="gls"	& year10==1830
replace gp=97.05	if ct=="gls"	& year10==1840
replace gp=65.39111	if ct=="ham"	& year10==1770
replace gp=64.454	if ct=="ham"	& year10==1780
replace gp=84.065	if ct=="ham"	& year10==1790
replace gp=126.293	if ct=="ham"	& year10==1800
replace gp=136.939	if ct=="ham"	& year10==1810
replace gp=86.23625	if ct=="ham"	& year10==1820
replace gp=85.813	if ct=="ham"	& year10==1830
replace gp=97.565	if ct=="ham"	& year10==1840
replace gp=68.80556	if ct=="hrt"	& year10==1770
replace gp=66.939	if ct=="hrt"	& year10==1780
replace gp=82.598	if ct=="hrt"	& year10==1790
replace gp=118.784	if ct=="hrt"	& year10==1800
replace gp=127.061	if ct=="hrt"	& year10==1810
replace gp=90.355	if ct=="hrt"	& year10==1820
replace gp=86.475	if ct=="hrt"	& year10==1830
replace gp=96.95	if ct=="hrt"	& year10==1840
replace gp=65.59666	if ct=="ken"	& year10==1770
replace gp=64.175	if ct=="ken"	& year10==1780
replace gp=81.809	if ct=="ken"	& year10==1790
replace gp=125.038	if ct=="ken"	& year10==1800
replace gp=132.317	if ct=="ken"	& year10==1810
replace gp=88.16875	if ct=="ken"	& year10==1820
replace gp=88.838	if ct=="ken"	& year10==1830
replace gp=101.085	if ct=="ken"	& year10==1840
replace gp=73.37334	if ct=="lan"	& year10==1770
replace gp=74.426	if ct=="lan"	& year10==1780
replace gp=87.446	if ct=="lan"	& year10==1790
replace gp=128.344	if ct=="lan"	& year10==1800
replace gp=135.613	if ct=="lan"	& year10==1810
replace gp=87.11625	if ct=="lan"	& year10==1820
replace gp=81.079	if ct=="lan"	& year10==1830
replace gp=94.37	if ct=="lan"	& year10==1840
replace gp=72.48444	if ct=="lei"	& year10==1770
replace gp=68.007	if ct=="lei"	& year10==1780
replace gp=86.753	if ct=="lei"	& year10==1790
replace gp=120.708	if ct=="lei"	& year10==1800
replace gp=132.225	if ct=="lei"	& year10==1810
replace gp=95.32	if ct=="lei"	& year10==1820
replace gp=88.587	if ct=="lei"	& year10==1830
replace gp=99.91	if ct=="lei"	& year10==1840
replace gp=64.77888	if ct=="lin"	& year10==1770
replace gp=62.383	if ct=="lin"	& year10==1780
replace gp=79.598	if ct=="lin"	& year10==1790
replace gp=116.554	if ct=="lin"	& year10==1800
replace gp=123.629	if ct=="lin"	& year10==1810
replace gp=81.95375	if ct=="lin"	& year10==1820
replace gp=83.086	if ct=="lin"	& year10==1830
replace gp=95.035	if ct=="lin"	& year10==1840
replace gp=64.90556	if ct=="lnd"	& year10==1770
replace gp=63.956	if ct=="lnd"	& year10==1780
replace gp=68.21667	if ct=="lnd"	& year10==1790
replace gp=90.26625	if ct=="lnd"	& year10==1820
replace gp=89.257	if ct=="lnd"	& year10==1830
replace gp=103.515	if ct=="lnd"	& year10==1840
replace gp=69.38333	if ct=="mdx"	& year10==1770
replace gp=67.09	if ct=="mdx"	& year10==1780
replace gp=86.244	if ct=="mdx"	& year10==1790
replace gp=129.571	if ct=="mdx"	& year10==1800
replace gp=138.168	if ct=="mdx"	& year10==1810
replace gp=95.945	if ct=="mdx"	& year10==1820
replace gp=94.457	if ct=="mdx"	& year10==1830
replace gp=107.05	if ct=="mdx"	& year10==1840
replace gp=70.87778	if ct=="mnm"	& year10==1770
replace gp=72.656	if ct=="mnm"	& year10==1780
replace gp=89.793	if ct=="mnm"	& year10==1790
replace gp=134.074	if ct=="mnm"	& year10==1800
replace gp=150.642	if ct=="mnm"	& year10==1810
replace gp=91.31875	if ct=="mnm"	& year10==1820
replace gp=87.287	if ct=="mnm"	& year10==1830
replace gp=100.495	if ct=="mnm"	& year10==1840
replace gp=61.02777	if ct=="nbl"	& year10==1770
replace gp=61.44	if ct=="nbl"	& year10==1780
replace gp=74.88499	if ct=="nbl"	& year10==1790
replace gp=112.74	if ct=="nbl"	& year10==1800
replace gp=115.307	if ct=="nbl"	& year10==1810
replace gp=83.31375	if ct=="nbl"	& year10==1820
replace gp=80.908	if ct=="nbl"	& year10==1830
replace gp=90.135	if ct=="nbl"	& year10==1840
replace gp=63.56556	if ct=="nfk"	& year10==1770
replace gp=63.175	if ct=="nfk"	& year10==1780
replace gp=76.565	if ct=="nfk"	& year10==1790
replace gp=115.423	if ct=="nfk"	& year10==1800
replace gp=125.364	if ct=="nfk"	& year10==1810
replace gp=81.74375	if ct=="nfk"	& year10==1820
replace gp=83.451	if ct=="nfk"	& year10==1830
replace gp=96.755	if ct=="nfk"	& year10==1840
replace gp=71.20333	if ct=="nth"	& year10==1770
replace gp=66.566	if ct=="nth"	& year10==1780
replace gp=82.306	if ct=="nth"	& year10==1790
replace gp=117.709	if ct=="nth"	& year10==1800
replace gp=129.683	if ct=="nth"	& year10==1810
replace gp=92.805	if ct=="nth"	& year10==1820
replace gp=85.209	if ct=="nth"	& year10==1830
replace gp=97.17	if ct=="nth"	& year10==1840
replace gp=66.51111	if ct=="ntt"	& year10==1770
replace gp=65.751	if ct=="ntt"	& year10==1780
replace gp=89.328	if ct=="ntt"	& year10==1790
replace gp=128.988	if ct=="ntt"	& year10==1800
replace gp=134.548	if ct=="ntt"	& year10==1810
replace gp=94.27	if ct=="ntt"	& year10==1820
replace gp=88.739	if ct=="ntt"	& year10==1830
replace gp=101.38	if ct=="ntt"	& year10==1840
replace gp=71.49222	if ct=="oxf"	& year10==1770
replace gp=67.014	if ct=="oxf"	& year10==1780
replace gp=86.263	if ct=="oxf"	& year10==1790
replace gp=124.688	if ct=="oxf"	& year10==1800
replace gp=137.053	if ct=="oxf"	& year10==1810
replace gp=93.71	if ct=="oxf"	& year10==1820
replace gp=86.204	if ct=="oxf"	& year10==1830
replace gp=97.57	if ct=="oxf"	& year10==1840
replace gp=69.94	if ct=="sal"	& year10==1770
replace gp=70.59	if ct=="sal"	& year10==1780
replace gp=88.02	if ct=="sal"	& year10==1790
replace gp=128.434	if ct=="sal"	& year10==1800
replace gp=143.456	if ct=="sal"	& year10==1810
replace gp=75.34	if ct=="sal"	& year10==1820
replace gp=72.48222	if ct=="som"	& year10==1770
replace gp=70.561	if ct=="som"	& year10==1780
replace gp=90.717	if ct=="som"	& year10==1790
replace gp=129.994	if ct=="som"	& year10==1800
replace gp=147.971	if ct=="som"	& year10==1810
replace gp=91.065	if ct=="som"	& year10==1820
replace gp=85.523	if ct=="som"	& year10==1830
replace gp=99.08	if ct=="som"	& year10==1840
replace gp=72.63556	if ct=="sta"	& year10==1770
replace gp=71.179	if ct=="sta"	& year10==1780
replace gp=89.608	if ct=="sta"	& year10==1790
replace gp=130.943	if ct=="sta"	& year10==1800
replace gp=139.117	if ct=="sta"	& year10==1810
replace gp=82.01	if ct=="sta"	& year10==1820
replace gp=62.06111	if ct=="suf"	& year10==1770
replace gp=60.786	if ct=="suf"	& year10==1780
replace gp=79.864	if ct=="suf"	& year10==1790
replace gp=120.951	if ct=="suf"	& year10==1800
replace gp=130.141	if ct=="suf"	& year10==1810
replace gp=85.0275	if ct=="suf"	& year10==1820
replace gp=85.426	if ct=="suf"	& year10==1830
replace gp=98.645	if ct=="suf"	& year10==1840
replace gp=68.05666	if ct=="sur"	& year10==1770
replace gp=67.469	if ct=="sur"	& year10==1780
replace gp=85.998	if ct=="sur"	& year10==1790
replace gp=133.253	if ct=="sur"	& year10==1800
replace gp=139.875	if ct=="sur"	& year10==1810
replace gp=100.345	if ct=="sur"	& year10==1820
replace gp=96.007	if ct=="sur"	& year10==1830
replace gp=107.89	if ct=="sur"	& year10==1840
replace gp=61.48667	if ct=="sus"	& year10==1770
replace gp=63.566	if ct=="sus"	& year10==1780
replace gp=79.803	if ct=="sus"	& year10==1790
replace gp=125.089	if ct=="sus"	& year10==1800
replace gp=135.738	if ct=="sus"	& year10==1810
replace gp=85.53625	if ct=="sus"	& year10==1820
replace gp=85.777	if ct=="sus"	& year10==1830
replace gp=97.33	if ct=="sus"	& year10==1840
replace gp=74.20111	if ct=="war"	& year10==1770
replace gp=66.966	if ct=="war"	& year10==1780
replace gp=90.265	if ct=="war"	& year10==1790
replace gp=133.385	if ct=="war"	& year10==1800
replace gp=142.601	if ct=="war"	& year10==1810
replace gp=93.48	if ct=="war"	& year10==1820
replace gp=89.432	if ct=="war"	& year10==1830
replace gp=102.165	if ct=="war"	& year10==1840
replace gp=68.09444	if ct=="wil"	& year10==1770
replace gp=66.55	if ct=="wil"	& year10==1780
replace gp=85.326	if ct=="wil"	& year10==1790
replace gp=122.71	if ct=="wil"	& year10==1800
replace gp=132.299	if ct=="wil"	& year10==1810
replace gp=88.445	if ct=="wil"	& year10==1820
replace gp=86.425	if ct=="wil"	& year10==1830
replace gp=97.01	if ct=="wil"	& year10==1840
replace gp=71.49667	if ct=="wor"	& year10==1770
replace gp=69.558	if ct=="wor"	& year10==1780
replace gp=88.553	if ct=="wor"	& year10==1790
replace gp=129.644	if ct=="wor"	& year10==1800
replace gp=141.017	if ct=="wor"	& year10==1810
replace gp=91.735	if ct=="wor"	& year10==1820
replace gp=87.434	if ct=="wor"	& year10==1830
replace gp=99.605	if ct=="wor"	& year10==1840
replace gp=65.45778	if ct=="yks"	& year10==1770
replace gp=65.805	if ct=="yks"	& year10==1780
replace gp=78.878	if ct=="yks"	& year10==1790
replace gp=115.085	if ct=="yks"	& year10==1800
replace gp=122.696	if ct=="yks"	& year10==1810
replace gp=82.3525	if ct=="yks"	& year10==1820
replace gp=83.969	if ct=="yks"	& year10==1830
replace gp=97.04	if ct=="yks"	& year10==1840

*Northumberland NTM wie hier, oder NBL wie in anderer Liste?
capture g relief=.
replace ct=upper(ct)
replace relief=0.1625	if ct=="AGY" & year10<=1800
replace relief=0.647619048	if ct=="BDF" & year10<=1800
replace relief=0.720833333	if ct=="BEK" & year10<=1800
replace relief=0.924869792	if ct=="BRE" & year10<=1800
replace relief=0.946547619	if ct=="BUK" & year10<=1800
replace relief=0.63624031	if ct=="CAM" & year10<=1800
replace relief=0.1625	if ct=="CGN" & year10<=1800
replace relief=0.211111111	if ct=="CHH" & year10<=1800
replace relief=0.190277778	if ct=="CAE" & year10<=1800
replace relief=0.444117647	if ct=="CHS" & year10<=1800
replace relief=0.271111111	if ct=="CON" & year10<=1800
replace relief=0.250886525	if ct=="CUL" & year10<=1800
replace relief=0.341666667	if ct=="DBG" & year10<=1800
replace relief=0.260714286	if ct=="DBY" & year10<=1800
replace relief=0.464409722	if ct=="DEV" & year10<=1800
replace relief=0.58515625	if ct=="DOR" & year10<=1800
replace relief=0.368530702	if ct=="DUR" & year10<=1800
replace relief=0.789666667	if ct=="ESS" & year10<=1800
replace relief=0.211111111	if ct=="FLN" & year10<=1800
replace relief=0.433333333	if ct=="GLA" & year10<=1800
replace relief=0.585119048	if ct=="GLS" & year10<=1800
replace relief=0.713596491	if ct=="HER" & year10<=1800
replace relief=0.663657407	if ct=="HRT" & year10<=1800
replace relief=0.701923077	if ct=="HUN" & year10<=1800
replace relief=0.961184211	if ct=="KEN" & year10<=1800
replace relief=0.435416667	if ct=="LAN" & year10<=1800
replace relief=0.693125	if ct=="LIN" & year10<=1800
replace relief=0.4		if ct=="MER" & year10<=1800
replace relief=0.541666667	if ct=="MDX" & year10<=1800
replace relief=0.452777778	if ct=="MNM" & year10<=1800
replace relief=0.369871795	if ct=="MNT" & year10<=1800
replace relief=0.779471545	if ct=="NFK" & year10<=1800
replace relief=0.870833333	if ct=="NTH" & year10<=1800
replace relief=0.471626984	if ct=="NBL" & year10<=1800
replace relief=0.384821429	if ct=="NTT" & year10<=1800
replace relief=0.916927083	if ct=="OXF" & year10<=1800
replace relief=0.215277778	if ct=="PEM" & year10<=1800
replace relief=0.864583333	if ct=="RAD" & year10<=1800
replace relief=0.536458333	if ct=="RUT" & year10<=1800
replace relief=0.370454545	if ct=="SAL" & year10<=1800
replace relief=0.4515625	if ct=="SOM" & year10<=1800
replace relief=0.778448276	if ct=="HAM" & year10<=1800
replace relief=0.4475	if ct=="STA" & year10<=1800
replace relief=0.566352201	if ct=="SUF" & year10<=1800
replace relief=0.838472222	if ct=="SUR" & year10<=1800
replace relief=1.298859127	if ct=="SUS" & year10<=1800
replace relief=0.789144737	if ct=="WAR" & year10<=1800
replace relief=0.336309524	if ct=="WLN" & year10<=1800
replace relief=0.657682292	if ct=="WIL" & year10<=1800
replace relief=0.540833333	if ct=="WOR" & year10<=1800
replace relief=0.318541667	if ct=="YKS" & year10<=1800

replace relief=0.295833333	if ct=="AGY" & year10==1810
replace relief=0.819940476	if ct=="BDF" & year10==1810
replace relief=0.933333333	if ct=="BEK" & year10==1810
replace relief=1.698958333	if ct=="BRE" & year10==1810
replace relief=1.220595238	if ct=="BUK" & year10==1810
replace relief=0.969089147	if ct=="CAM" & year10==1810
replace relief=0.305555556	if ct=="CGN" & year10==1810
replace relief=0.325		if ct=="CHH" & year10==1810
replace relief=0.261111111	if ct=="CAE" & year10==1810
replace relief=0.599264706	if ct=="CHS" & year10==1810
replace relief=0.472638889	if ct=="CON" & year10==1810
replace relief=0.414716312	if ct=="CUL" & year10==1810
replace relief=0.440277778	if ct=="DBG" & year10==1810
replace relief=0.526785714	if ct=="DBY" & year10==1810
replace relief=0.623263889	if ct=="DEV" & year10==1810
replace relief=0.83046875	if ct=="DOR" & year10==1810
replace relief=0.489583333	if ct=="DUR" & year10==1810
replace relief=1.352666667	if ct=="ESS" & year10==1810
replace relief=0.254166667	if ct=="FLN" & year10==1810
replace relief=0.14375	if ct=="GLA" & year10==1810
replace relief=0.832886905	if ct=="GLS" & year10==1810
replace relief=1.128289474	if ct=="HER" & year10==1810
replace relief=1.124537037	if ct=="HRT" & year10==1810
replace relief=0.932051282	if ct=="HUN" & year10==1810
replace relief=1.446564327	if ct=="KEN" & year10==1810
replace relief=0.54122807	if ct=="LAN" & year10==1810
replace relief=0.694583333	if ct=="LIN" & year10==1810
replace relief=0.533333333	if ct=="MER" & year10==1810
replace relief=0.768055556	if ct=="MDX" & year10==1810
replace relief=0.461574074	if ct=="MNM" & year10==1810
replace relief=1.228205128	if ct=="MNT" & year10==1810
replace relief=1.156504065	if ct=="NFK" & year10==1810
replace relief=1.092361111	if ct=="NTH" & year10==1810
replace relief=0.44484127	if ct=="NBL" & year10==1810
replace relief=0.58735119	if ct=="NTT" & year10==1810
replace relief=1.302473958	if ct=="OXF" & year10==1810
replace relief=0.359722222	if ct=="PEM" & year10==1810
replace relief=1.104166667	if ct=="RAD" & year10==1810
replace relief=0.741666667	if ct=="RUT" & year10==1810
replace relief=0.540151515	if ct=="SAL" & year10==1810
replace relief=0.771484375	if ct=="SOM" & year10==1810
replace relief=1.663864943	if ct=="HAM" & year10==1810
replace relief=0.6275	if ct=="STA" & year10==1810
replace relief=1.003301887	if ct=="SUF" & year10==1810
replace relief=1.196527778	if ct=="SUR" & year10==1810
replace relief=2.012946429	if ct=="SUS" & year10==1810
replace relief=1.065131579	if ct=="WAR" & year10==1810
replace relief=0.473611111	if ct=="WLN" & year10==1810
replace relief=1.343619792	if ct=="WIL" & year10==1810
replace relief=0.666875	if ct=="WOR" & year10==1810
replace relief=0.47203125	if ct=="YKS" & year10==1810

replace relief=0.225	if ct=="AGY" & year10==1820
replace relief=1.041071429	if ct=="BDF" & year10==1820
replace relief=0.429166667	if ct=="BEK" & year10==1820
replace relief=0.912369792	if ct=="BRE" & year10==1820
replace relief=1.016547619	if ct=="BUK" & year10==1820
replace relief=0.788372093	if ct=="CAM" & year10==1820
replace relief=0.293055556	if ct=="CGN" & year10==1820
replace relief=0.3875	if ct=="CHH" & year10==1820
replace relief=0.283333333	if ct=="CAE" & year10==1820
replace relief=0.49754902	if ct=="CHS" & year10==1820
replace relief=0.43	if ct=="CON" & year10==1820
replace relief=0.408687943	if ct=="CUL" & year10==1820
replace relief=0.529166667	if ct=="DBG" & year10==1820
replace relief=0.354166667	if ct=="DBY" & year10==1820
replace relief=0.558333333	if ct=="DEV" & year10==1820
replace relief=0.591666667	if ct=="DOR" & year10==1820
replace relief=0.487061404	if ct=="DUR" & year10==1820
replace relief=0.980833333	if ct=="ESS" & year10==1820
replace relief=0.301388889	if ct=="FLN" & year10==1820
replace relief=0.45625	if ct=="GLA" & year10==1820
replace relief=0.609077381	if ct=="GLS" & year10==1820
replace relief=0.799561404	if ct=="HER" & year10==1820
replace relief=0.895601852	if ct=="HRT" & year10==1820
replace relief=0.692307692	if ct=="HUN" & year10==1820
replace relief=1.362646199	if ct=="KEN" & year10==1820
replace relief=0.55120614	if ct=="LAN" & year10==1820
replace relief=0.83		if ct=="LIN" & year10==1820
replace relief=0.508333333	if ct=="MER" & year10==1820
replace relief=0.640277778	if ct=="MDX" & year10==1820
replace relief=0.433796296	if ct=="MNM" & year10==1820
replace relief=0.554487179	if ct=="MNT" & year10==1820
replace relief=1.021036585	if ct=="NFK" & year10==1820
replace relief=1.063425926	if ct=="NTH" & year10==1820
replace relief=0.521031746	if ct=="NBL" & year10==1820
replace relief=0.577678571	if ct=="NTT" & year10==1820
replace relief=0.996875	if ct=="OXF" & year10==1820
replace relief=0.273611111	if ct=="PEM" & year10==1820
replace relief=1.078125	if ct=="RAD" & year10==1820
replace relief=0.55625	if ct=="RUT" & year10==1820
replace relief=0.491098485	if ct=="SAL" & year10==1820
replace relief=0.6171875	if ct=="SOM" & year10==1820
replace relief=0.934267241	if ct=="HAM" & year10==1820
replace relief=0.567777778	if ct=="STA" & year10==1820
replace relief=0.910062893	if ct=="SUF" & year10==1820
replace relief=0.986111111	if ct=="SUR" & year10==1820
replace relief=1.490724206	if ct=="SUS" & year10==1820
replace relief=0.793859649	if ct=="WAR" & year10==1820
replace relief=0.544444444	if ct=="WLN" & year10==1820
replace relief=0.726171875	if ct=="WIL" & year10==1820
replace relief=0.5675	if ct=="WOR" & year10==1820
replace relief=0.416614583	if ct=="YKS" & year10==1820


replace relief=0.2125	if ct=="AGY" & year10>=1830
replace relief=1.032738095	if ct=="BDF" & year10>=1830
replace relief=1.06875	if ct=="BEK" & year10>=1830
replace relief=0.812109375	if ct=="BRE" & year10>=1830
replace relief=0.89702381	if ct=="BUK" & year10>=1830
replace relief=0.666182171	if ct=="CAM" & year10>=1830
replace relief=0.283333333	if ct=="CGN" & year10>=1830
replace relief=0.351388889	if ct=="CHH" & year10>=1830
replace relief=0.316666667	if ct=="CAE" & year10>=1830
replace relief=0.418382353	if ct=="CHS" & year10>=1830
replace relief=0.390833333	if ct=="CON" & year10>=1830
replace relief=0.32641844	if ct=="CUL" & year10>=1830
replace relief=0.498611111	if ct=="DBG" & year10>=1830
replace relief=0.296428571	if ct=="DBY" & year10>=1830
replace relief=0.486458333	if ct=="DEV" & year10>=1830
replace relief=0.51328125	if ct=="DOR" & year10>=1830
replace relief=0.437719298	if ct=="DUR" & year10>=1830
replace relief=0.891083333	if ct=="ESS" & year10>=1830
replace relief=0.188888889	if ct=="FLN" & year10>=1830
replace relief=0.304166667	if ct=="GLA" & year10>=1830
replace relief=0.50297619	if ct=="GLS" & year10>=1830
replace relief=0.614473684	if ct=="HER" & year10>=1830
replace relief=0.709722222	if ct=="HRT" & year10>=1830
replace relief=0.694230769	if ct=="HUN" & year10>=1830
replace relief=1.016374269	if ct=="KEN" & year10>=1830
replace relief=0.497368421	if ct=="LAN" & year10>=1830
replace relief=0.732083333	if ct=="LIN" & year10>=1830
replace relief=0.395833333	if ct=="MER" & year10>=1830
replace relief=0.433333333	if ct=="MDX" & year10>=1830
replace relief=0.455555556	if ct=="MNM" & year10>=1830
replace relief=0.578205128	if ct=="MNT" & year10>=1830
replace relief=0.883536585	if ct=="NFK" & year10>=1830
replace relief=0.947685185	if ct=="NTH" & year10>=1830
replace relief=0.434722222	if ct=="NBL" & year10>=1830
replace relief=0.451934524	if ct=="NTT" & year10>=1830
replace relief=0.958854167	if ct=="OXF" & year10>=1830
replace relief=0.355555556	if ct=="PEM" & year10>=1830
replace relief=0.672916667	if ct=="RAD" & year10>=1830
replace relief=0.490625	if ct=="RUT" & year10>=1830
replace relief=0.388257576	if ct=="SAL" & year10>=1830
replace relief=0.496484375	if ct=="SOM" & year10>=1830
replace relief=0.888002874	if ct=="HAM" & year10>=1830
replace relief=0.405		if ct=="STA" & year10>=1830
replace relief=1.05668239	if ct=="SUF" & year10>=1830
replace relief=0.783472222	if ct=="SUR" & year10>=1830
replace relief=1.330704365	if ct=="SUS" & year10>=1830
replace relief=0.628947368	if ct=="WAR" & year10>=1830
replace relief=0.485714286	if ct=="WLN" & year10>=1830
replace relief=0.773567708	if ct=="WIL" & year10>=1830
replace relief=0.434375	if ct=="WOR" & year10>=1830
replace relief=0.362864583	if ct=="YKS" & year10>=1830

