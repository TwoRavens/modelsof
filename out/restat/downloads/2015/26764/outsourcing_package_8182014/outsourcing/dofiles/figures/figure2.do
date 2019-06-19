global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/"

# delimit ;

capture log close;
clear;
set mem 1400m;
set more off;
set matsize 800;

use ${x}table6_norpiship.dta;

keep if year==1984|year==1985|year==2001|year==2002;

xi I.year I.educ I.ind7090;

keep lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite year _Iyear* _Ieduc* _Iind7090* ihwt ind7090;

log using figure2.log, replace;
*****************;
* 1984 and 1985 *;
*****************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* if year==1984|year==1985 [weight=ihwt], robust cluster(ind7090);

global numlist "20 21 30 31 40 41 42 50 60 100 101 102 110 111 112 120 121 122 130 132 140 141 142 150 151 152 160 161 162 171 172 180 181 182 190 191 192 200 201 211 212 220 221 222 230 231 241 242 250 251 252 261 262 270 271 272 280 281 282 290 291 300 301 310 311 312 320 321 322 331 332 340 341 342 350 351 360 361 362 370 371 372 380 381 391 392 400 401 402 410 411 412 420 421 422 432 441 442 460 461 462 470 471 472 500 502 511 512 521 531 540 541 542 550 551 552 560 561 562 571 580 581 591 592 600 601 602 610 611 612 620 621 622 630 631 632 640 641 642 650 660 670 671 672 681 682 691 700 702 710 711 712 721 722 731 732 740 741 742 750 752 760 761 762 770 771 772 780 782 790 800 801 802 812 820 821 822 831 832 840 841 842 850 852 860 870 871 872 880 881 882 890 901";

foreach j of global numlist{ ;
	gen m`j'=_b[_Iind7090_`j'];
};

egen mean8485=rowmean(m20 m21 m30 m31 m40 m41 m42 m50 m60 m100 m101 m102 m110 m111 m112 m120 m121 m122 m130 m132 m140 m141 m142 m150 m151 m152 m160 m161 m162 m171 m172 m180 m181 m182 m190 m191 m192 m200 m201 m211 m212 m220 m221 m222 m230 m231 m241 m242 m250 m251 m252 m261 m262 m270 m271 m272 m280 m281 m282 m290 m291 m300 m301 m310 m311 m312 m320 m321 m322 m331 m332 m340 m341 m342 m350 m351 m360 m361 m362 m370 m371 m372 m380 m381 m391 m392 m400 m401 m402 m410 m411 m412 m420 m421 m422 m432 m441 m442 m460 m461 m462 m470 m471 m472 m500 m502 m511 m512 m521 m531 m540 m541 m542 m550 m551 m552 m560 m561 m562 m571 m580 m581 m591 m592 m600 m601 m602 m610 m611 m612 m620 m621 m622 m630 m631 m632 m640 m641 m642 m650 m660 m670 m671 m672 m681 m682 m691 m700 m702 m710 m711 m712 m721 m722 m731 m732 m740 m741 m742 m750 m752 m760 m761 m762 m770 m771 m772 m780 m782 m790 m800 m801 m802 m812 m820 m821 m822 m831 m832 m840 m841 m842 m850 m852 m860 m870 m871 m872 m880 m881 m882 m890 m901);

foreach j of global numlist{ ;
	gen dev`j'_8485=m`j'-mean8485;
};
drop mean8485 m20 m21 m30 m31 m40 m41 m42 m50 m60 m100 m101 m102 m110 m111 m112 m120 m121 m122 m130 m132 m140 m141 m142 m150 m151 m152 m160 m161 m162 m171 m172 m180 m181 m182 m190 m191 m192 m200 m201 m211 m212 m220 m221 m222 m230 m231 m241 m242 m250 m251 m252 m261 m262 m270 m271 m272 m280 m281 m282 m290 m291 m300 m301 m310 m311 m312 m320 m321 m322 m331 m332 m340 m341 m342 m350 m351 m360 m361 m362 m370 m371 m372 m380 m381 m391 m392 m400 m401 m402 m410 m411 m412 m420 m421 m422 m432 m441 m442 m460 m461 m462 m470 m471 m472 m500 m502 m511 m512 m521 m531 m540 m541 m542 m550 m551 m552 m560 m561 m562 m571 m580 m581 m591 m592 m600 m601 m602 m610 m611 m612 m620 m621 m622 m630 m631 m632 m640 m641 m642 m650 m660 m670 m671 m672 m681 m682 m691 m700 m702 m710 m711 m712 m721 m722 m731 m732 m740 m741 m742 m750 m752 m760 m761 m762 m770 m771 m772 m780 m782 m790 m800 m801 m802 m812 m820 m821 m822 m831 m832 m840 m841 m842 m850 m852 m860 m870 m871 m872 m880 m881 m882 m890 m901;

*****************;
* 2001 and 2002 *;
*****************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* if year==2001|year==2002 [weight=ihwt], robust cluster(ind7090);

bysort ind7090: keep if _n==1;

foreach j of global numlist{ ;
	gen n`j'=_b[_Iind7090_`j'];
};

egen mean0102=rowmean(n20 n21 n30 n31 n40 n41 n42 n50 n60 n100 n101 n102 n110 n111 n112 n120 n121 n122 n130 n132 n140 n141 n142 n150 n151 n152 n160 n161 n162 n171 n172 n180 n181 n182 n190 n191 n192 n200 n201 n211 n212 n220 n221 n222 n230 n231 n241 n242 n250 n251 n252 n261 n262 n270 n271 n272 n280 n281 n282 n290 n291 n300 n301 n310 n311 n312 n320 n321 n322 n331 n332 n340 n341 n342 n350 n351 n360 n361 n362 n370 n371 n372 n380 n381 n391 n392 n400 n401 n402 n410 n411 n412 n420 n421 n422 n432 n441 n442 n460 n461 n462 n470 n471 n472 n500 n502 n511 n512 n521 n531 n540 n541 n542 n550 n551 n552 n560 n561 n562 n571 n580 n581 n591 n592 n600 n601 n602 n610 n611 n612 n620 n621 n622 n630 n631 n632 n640 n641 n642 n650 n660 n670 n671 n672 n681 n682 n691 n700 n702 n710 n711 n712 n721 n722 n731 n732 n740 n741 n742 n750 n752 n760 n761 n762 n770 n771 n772 n780 n782 n790 n800 n801 n802 n812 n820 n821 n822 n831 n832 n840 n841 n842 n850 n852 n860 n870 n871 n872 n880 n881 n882 n890 n901);

foreach j of global numlist{ ;
	gen dev`j'_0102=n`j'-mean0102;
	drop n`j';
};


keep ind7090 dev*_8485 dev*_0102;

gen dev_8485=.;
gen dev_0102=.;
foreach j of global numlist {;
	replace dev_8485=dev`j'_8485 if ind7090==`j'; 
	replace dev_0102=dev`j'_0102 if ind7090==`j';
};

drop if dev_8485==. & dev_0102==.;

keep ind7090 dev_8485 dev_0102; 

twoway scatter dev_8485 dev_0102, subtitle("Inter-Industry Wage Differentials") ytitle("1984 and 1985") ylabel(#3, labsize(small)) xtitle("2001 and 2002") scheme(sj);
/*
text(-.2518107	-.2001558	"Ag services, except horticultural", place(e))
text(-.166945	-.1552925	"Horticultural services", place(e))
text(-.0552854	-.0656435	"Forestry", place(e))
text(-.2195957	-.2917368	"Fishing, hunting and trapping", place(e))
text(.3106757	.2218112	"Metal mining", place(e))
text(.3402806	.2187901	"Coal mining", place(e))
text(.2776479	.1596447	"Crude petroleum and natural gas extraction", place(e))
text(.0796164	.0597322	"Nonmetallic mining and quarrying, except fuel", place(e))
text(.1091084	.0924273	"Construction", place(e))
text(-.0412989	-.0885999	"Meat products", place(e))
text(.031957	.0853415	"Dairy products", place(e))
text(.0255852	-.0307397	"Canned and preserved fuits and vegetables", place(e))
text(.1044997	.0758311	"Gain mill products", place(e))
text(.0218552	-.0287031	"Bakery products", place(e))
text(.0676021	.1076644	"Sugar and confectionary products", place(e))
text(.1245743	.1428447	"Beverage industries", place(e))
text(-.0020631	-.0315875	"Misc. food preparations and kindred products", place(e))
text(.1972962	.1124716	"Not specified food industries", place(e))
text(.2185811	.1707993	"Tobacco manufactures", place(e))
text(-.0898548	-.1624809	"Knitting mills", place(e))
text(-.0095077	-.1226885	"Dyeing and finishing textiles, except wool and knit goods", place(e))
text(.0094404	-.0268561	"Floor coverings, except hard surfaces", place(e))
text(-.0216047	-.0494207	"Yarn, thread, and fabric mills", place(e))
text(-.0164894	.0196422	"Misc. textile mill products", place(e))
text(-.1069557	-.0761298	"Apparel and accessories, except knit", place(e))
text(-.066366	-.0564336	"Misc. fabricated textile products", place(e))
text(.1918739	.0964381	"Pulp, paper, and paperboard mills", place(e))
text(.114528	.1235902	"Misc. paper and pulp products", place(e))
text(.0736189	.029426	"Paperboard containers and boxes", place(e))
text(-.0222379	-.0573001	"Newspaper publishing and printing", place(e))
text(.1004808	.1059803	"Printing, publishing, and allied industries except newspapers", place(e))
text(.140226	.068537	"Plastics, synthetics, and resins", place(e))
text(.2690509	.2480084	"Drugs", place(e))
text(.1929186	.1281226	"Soaps and cosmetics", place(e))
text(.1658392	.0517777	"Paints, varnishes, and related products", place(e))
text(.0986724	.0483942	"Agricultural chemicals", place(e))
text(.2534741	.1864446	"Industrial and miscellaneous chemicals", place(e))
text(.3248678	.2692896	"Petroleum refining", place(e))
text(.2199322	.1164347	"Misc. petroleum and coal products", place(e))
text(.1539993	.0736138	"Other rubber products, and plastics footwear and belting + Tires & Inner tubes", place(e))
text(.0193618	.0177169	"Misc. plastic products", place(e))
text(-.0637106	-.0897501	"Leather tanning and finishing", place(e))
text(.0595352	.066075	"Footwear, except rubber and plastic", place(e))
text(-.0904014	-.0103461	"Leather products, except footwear", place(e))
text(-.1829863	-.0549181	"Logging", place(e))
text(-.0312808	.0028218	"Sawmills, planning mills, and millwork", place(e))
text(-.167805	-.0467082	"Misc. wood products", place(e))
text(-.0833792	.0253304	"Furniture and fixtures", place(e))
text(.1207146	.0150785	"Glass and glass products", place(e))
text(.0408238	.0734718	"Cement, concrete, and gypsum, and plaster products", place(e))
text(-.0503798	-.0300342	"Structural clay products", place(e))
text(-.0766212	-.0967103	"Pottery and related products", place(e))
text(.1100865	.0618926	"Misc. nonmetallic mineral and stone products", place(e))
text(.1702468	.0633137	"Blast furnaces, steelworks, rolling and finishing mills", place(e))
text(.090638	.0202771	"Iron and stell foundaries", place(e))
text(.1353911	.0516343	"Primary aluminum industries", place(e))
text(.0944763	.080237	"Other primary metal industries", place(e))
text(.033589	.0009191	"Cutlery, handtools, and other hardware", place(e))
text(.0489507	.0117332	"Fabricated structural metal products", place(e))
text(.0744758	.0568809	"Screw machine products", place(e))
text(.1038281	.0481477	"Metal forgings and stampings", place(e))
text(.0455354	.0137137	"Misc. fabricated metal products", place(e))
text(.0441538	.3161889	"Not specified metal industries", place(e))
text(.2351539	.0791813	"Engines and turbines", place(e))
text(.1356436	-.0087754	"Farm machinery and equipment", place(e))
text(.1849577	.0994153	"Construction and material handling machines", place(e))
text(.1086358	.1078257	"Metalworking machinery", place(e))
text(.1926836	.0808525	"Office and accounting machines", place(e))
text(.2704741	.2754984	"Electronic computing equipment", place(e))
text(.0825928	.051784	"Machinery, except electrical, n.e.c.", place(e))
text(.1828803	.0714684	"Not specified machinery", place(e))
text(.1034991	.0159283	"Household appliances", place(e))
text(.1880197	.160179	"Radio, T.V. and communication equipment", place(e))
text(.1035906	.1107411	"Eletrical machinery, equipment, and supplies, n.e.c.", place(e))
text(.0431139	.0782668	"Not specified eletrical machinery, equipment, and supplies", place(e))
text(.1800827	.1132207	"Transporation equipment", place(e))
text(.1390542	.0433076	"Ship and boat building and repairing", place(e))
text(.2318268	.0082026	"Railroad locamotives and equipment", place(e))
text(.1962966	.1571668	"Guided missiles, space vehicles, and parts, Ordnance, and Aircraft and parts", place(e))
text(-.0115821	.0254738	"Cycles and misc. transporation equipment & Wood buildings and mobile homes", place(e))
text(.151892	.1767119	"Scientific and controlling instruments", place(e))
text(.1142431	.1221395	"Optical and health services supplies", place(e))
text(.2854437	.1910828	"Photographic equipment and supplies", place(e))
text(-.101705	-.0142732	"Watches, clocks, and clockwork operated devices", place(e))
text(-.0287309	.0067886	"Misc. manufacturing industries and toys, amusement and sporting goods", place(e))
text(-.1153471	-.0512246	"Not specified manufacturing industries", place(e))
text(.2650007	.1126569	"Railroads", place(e))
text(.0016153	-.0726508	"Bus service and urban transit", place(e))
text(-.396124	-.3759896	"Taxicab service", place(e))
text(.066392	.0201232	"Trucking service", place(e))
text(-.0183575	-.0390531	"Warehousing and storage", place(e))
text(.1608398	.0558487	"U.S. Postal Service", place(e))
text(.1128327	.0782935	"Water transportation", place(e))
text(.2335956	.0626953	"Air transportation", place(e))
text(.3387193	.3462514	"Pipe lines, except natural gas", place(e))
text(-.0197907	.0157484	"Services incidental to transportation", place(e))
text(.3294441	.1977617	"Telephone (wire and radio)", place(e))
text(.0873234	.104301	"Telegraph and misc. communication services & Radio television and broadcasting", place(e))
text(.266955	.2069159	"Electric light and power", place(e))
text(.2619683	.1498873	"Gas and steam supply systems", place(e))
text(.3013458	.2284459	"Eletric and gas, and other combinations", place(e))
text(.0164708	.0620224	"Water supply and irrigation", place(e))
text(-.0199226	.0709856	"Sanitary services", place(e))
text(.2393014	.2167835	"Not specified utilities", place(e))
text(.0574022	-.0253279	"Motor vehicles and equipment", place(e))
text(.0758484	.0287043	"Lumber and construction materials", place(e))
text(.1754067	.0546686	"Metals and minerals, except petroleum", place(e))
text(.1314957	.1337143	"Electrical goods", place(e))
text(.0012652	.0580542	"Hardware, plumbing and heating supplies", place(e))
text(-.1390824	-.0613874	"Scrap and waste materials", place(e))
text(.0789976	.0761284	"Paper and paper products", place(e))
text(.096497	.1663048	"Drugs, chemicals, and allied products", place(e))
text(.0997163	.0390368	"Apparel, fabrics, and notions", place(e))
text(.0031008	.0169129	"Groceries and related products", place(e))
text(-.0929903	-.0652166	"Farm products, raw materials", place(e))
text(.1224048	.0892414	"Petroleum products", place(e))
text(.1049988	.0406432	"Alcoholic beverages", place(e))
text(-.173455	-.1375179	"Farm supplies & Retail nurseries and garden stores", place(e))
text(.0871678	.0760155	"Misc. wholesale, durable AND non-durable goods; Sporting goods, toys, and hobby goods; Furniture and home furnishings; Machinery, equipment and supplies.", place(e))
text(-.087356	-.0675402	"Not specified wholesale trade", place(e))
text(-.1195352	-.0732371	"Lumber and building material retailing", place(e))
text(-.2595552	-.1490028	"Hardware stores", place(e))
text(-.1867054	-.1704637	"Deparment stores & Mail order houses", place(e))
text(-.2843548	-.2503437	"Variety stores", place(e))
text(-.2863183	-.2425024	"Misc. general merchandise stores and Sewing, needlework, and piece good stores", place(e))
text(-.1251332	-.2028345	"Grocery stores", place(e))
text(-.2351241	-.0933033	"Diary product stores", place(e))
text(-.2289786	-.1819416	"Retail bakeries", place(e))
text(-.2038717	-.151894	"Food stores, n.e.c", place(e))
text(-.0102435	.0616034	"Motor vehicle dealers", place(e))
text(-.1777764	-.122693	"Auto and home supply stores", place(e))
text(-.3394358	-.2420543	"Gasoline service stations", place(e))
text(-.1071153	-.0595249	"Misc. vehicle dealers and Mobile home dealers", place(e))
text(-.2203507	-.1061207	"Apparel and accessory stores, except shoe", place(e))
text(-.2095648	-.1419224	"Shoe stores", place(e))
text(-.1200145	-.1116195	"Furniture and home furnishings stores", place(e))
text(-.1130165	-.0059409	"Household appliances, TV, and radio stores", place(e))
text(-.3962828	-.2677585	"Eating and drinking places", place(e))
text(-.1488727	-.0650778	"Drug stores", place(e))
text(-.3307224	-.2436526	"Liquor stores", place(e))
text(-.066605	-.0888946	"Jewelry stores", place(e))
text(-.0839349	-.0702908	"Vending machine operators", place(e))
text(-.1214367	-.1393618	"Direct selling establishments", place(e))
text(-.0900949	-.0205687	"Fuel and ice dealers", place(e))
text(-.26025	-.243798	"Retail florists", place(e))
text(-.2210587	-.1579836	"Misc. retail stores; Sporting goods, bicycles, hobby; Book, stationery stores", place(e))
text(.037145	-.1586687	"Not specified retail trade", place(e))
text(.0900119	.0921895	"Banking", place(e))
text(.1099872	.1441672	"Credit agencies, n.e.c.; Savings and Loan associations", place(e))
text(.2680028	.2712815	"Security, commodity brokerage, and investment companies", place(e))
text(.1371772	.1318271	"Insurance", place(e))
text(-.016599	.0271725	"Real estate; including real estate-insurance-law offices", place(e))
text(.1560062	.1837758	"Advertising", place(e))
text(-.2227984	-.209561	"Services to dwellings and other buildings", place(e))
text(-.1063389	-.0222244	"Personlle supply services", place(e))
text(.0861138	.1342195	"Misc. personal services; Bus. mngt/consulting; Commercial research, dev't/testing labs; Funeral services and creamtories; Misc. prof'l and related services; Noncommercial educ./scientific research", place(e))
text(.2355703	.2618642	"Computer and data processing services", place(e))
text(-.3077066	-.1033292	"Detective and protective services", place(e))
text(-.0499201	.0122425	"Business services, n.e.c.", place(e))
text(-.0803007	-.0589419	"Automotive repair shops; automotive services, except repair", place(e))
text(.0423429	.0510556	"Electrical repair shops", place(e))
text(-.0128739	.0008863	"Misc. repair services", place(e))
text(-.6828644	-.4590186	"Private households", place(e))
text(-.274393	-.1784936	"Hotels and motels", place(e))
text(-.642059	-.3323173	"Lodging places, except hotels and motels", place(e))
text(-.2120646	-.1749533	"Laundry, cleaning, and garment services", place(e))
text(-.21815	-.1988643	"Beauty shops", place(e))
text(-.176491	-.2815492	"Barber shops", place(e))
text(-.0960199	-.104587	"Shoe repair shops", place(e))
text(-.3357308	.0824239	"Dressmaking shops", place(e))
text(-.0192541	.006192	"Theaters and motion pictures", place(e))
text(-.2704191	-.2178556	"Bowling alleys, billiard and pool parlors", place(e))
text(-.2299009	-.1474321	"Misc. entertainment and recreation services", place(e))
text(.0002766	.0500272	"Offices of physicians", place(e))
text(.0409358	.0703143	"Offices of dentists", place(e))
text(-.1444675	-.1190683	"Offices of chiropractors", place(e))
text(-.0563702	-.0875901	"Offices of health practitioners, n.e.c.; offices of optometrists", place(e))
text(.0589993	.0595743	"Hospitals", place(e))
text(-.2229482	-.1201732	"Nursing and personal care facillities", place(e))
text(-.0270683	-.0194538	"Heath services, n.e.c.; Job training and voc rehab services", place(e))
text(.1398641	.1699225	"Legal services", place(e))
text(-.1768331	-.1861528	"Elementary and secondary schools; child day care services", place(e))
text(-.1302169	-.1271532	"Colleges and universities", place(e))
text(-.1538396	-.2585625	"Libraries", place(e))
text(-.0430348	-.1013139	"Educational services, n.e.c.; Busines, trade, and vocational schools", place(e))
text(-.3683742	-.1862973	"Residential care facillities, without nursing", place(e))
text(-.1315675	-.1212868	"Social services, n.e.c", place(e))
text(-.1000695	-.1444083	"Museums, art galleries, and zoos", place(e))
text(-.4965048	-.3545364	"Religious organizations", place(e))
text(-.0623555	.0047069	"Membership organizations", place(e))
text(.1748528	.1392842	"Engineering, architectural, and surveying services", place(e))
text(.1272477	.1420785	"Accounting, auditing, andd bookkeeping services", place(e))
text(.0741748	.0490888	"All public administration", place(e));
*/

log close;
exit;
