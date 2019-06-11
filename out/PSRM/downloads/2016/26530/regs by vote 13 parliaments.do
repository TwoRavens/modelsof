
***** This do file will run vote-by-vote regression (Table 2) of vote as a function of left-right and government-opposition variables.

***** First Part OLS Regressions with robust or clustered variance.

****Note that we did not vote-by-vote regressions for two-party systems Australia, New Zealand, and USA. 


** Note to the Editor: To count the number of significant coefficients we also used
** the Stata "SIGCOEF.ado" code. The numbers are different from what we report in Table 2
** but the proportions and qualitative conclusions do not change.  Because the outputs differ, 
**we prefer to report the numbers we obtained using 'manual calculations'.
 

***** Canada 9497 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/Canada_reg.dta", clear

keep deputy coalition ord mp party lr soclr go lr_stdev nlr v1	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v15	v16	v17	v18	v19	v21	v22	v23	v24	v25	v26	v27	v28	v29	v31	v32	v35	v36	v37	v38	v40	v41	v42	v43	v44	v45	v46	v47	v48	v49	v50	v51	v52	v53	v54	v55	v56	v57	v58	v59	v60	v61	v62	v63	v64	v65	v66	v67	v68	v69	v70	v71	v72	v73	v74	v75	v77	v78	v79	v80	v81	v82	v83	v84	v85	v86	v87	v88	v89	v91	v92	v93	v94	v95	v96	v97	v99	v100	v101	v102	v103	v104	v105	v106	v107	v108	v110	v111	v112	v113	v115	v116	v117	v118	v120	v121	v124	v125	v126	v128	v130	v131	v132	v133	v134	v136	v138	v139	v140	v141	v143	v145	v150	v153	v154	v157	v158	v160	v161	v162	v163	v164	v165	v166	v168	v170	v173	v174	v175	v176	v177	v180	v183	v185	v190	v193	v194	v197	v198	v200	v201	v202	v203	v204	v205	v206	v208	v210	v213	v214	v215	v216	v217	v220	v223	v226	v228	v233	v236	v237	v240	v241	v243	v244	v245	v246	v247	v248	v249	v251	v253	v256	v257	v258	v259	v260	v263	v266	v268	v273	v276	v277	v280	v281	v283	v284	v285	v286	v287	v288	v289	v291	v293	v296	v297	v298	v299	v300	v303	v306	v309	v311	v316	v319	v320	v323	v324	v326	v327	v328	v329	v330	v331	v332	v334	v336	v339	v340	v341	v342	v343	v346	v349	v351	v356	v359	v360	v363	v364	v366	v367	v368	v369	v370	v371	v372	v374	v376	v379	v380	v381	v382	v383	v386	v389	v392	v394	v399	v402		v404	v405	v406	v408	v413	v415	v417	v418	v419	v420	v421	v422	v423	v424	v425	v426	v427	v428	v429	v430	v432	v433	v434	v435	v436	v437	v438	v439	v440	v441	v443	v444	v446	v447	v448	v449	v450	v453	v454	v457	v458	v459	v460		v463	v464	v465	v466	v467	v468	v469	v470	v471	v472	v473	v474	v475	v476	v477	v478	v480	v481	v483	v484	v485	v486	v487	v489	v490	v491	v492	v493	v494	v495	v496	v497	v498	v499	v500	v501	v502	v503	v504	v505	v508	v509	v510	v511	v512	v514	v516	v519	v520	v521	v522	v523	v524	v526	v527	v528	v530	v532	v534	v535	v536	v537	v538	v539	v540	v541	v542	v543	v544	v545	v546	v547	v548	v549	v550	v551	v552	v553	v554	v555	v557	v558	v559	v560	v561	v562	v565	v566	v567	v568	v569	v570	v571	v572	v573	v574	v576	v577	v580	v582	v583	v584	v587	v588	v589	v590	v591	v592	v593	v594	v595	v596	v597	v598	v599	v600	v601	v602	v603	v604	v605	v606	v607	v608	v609	v610	v612	v614	v616	v621	v624	v625	v628	v629	v631	v632	v633	v634	v635	v636	v637	v639	v641	v644	v645	v646	v647	v648	v651	v654	v656	v661	v664	v665	v668	v669	v671	v672	v673	v674	v675	v676	v677	v679	v681	v684	v685	v686	v687	v688	v691	v694	v696	v701	v704	v705	v708	v709	v711	v712	v713	v714	v715	v716	v717	v719	v721	v724	v725	v726	v727	v728	v731	v734




sigcoef lr go, replace 
foreach y of varlist v* {*simex (`y'=go)(w:lr), bstrap suuinit(suu)regress `y' lr go, cluster(party)sigcoef lr go, append l(96)
 outreg2 using out_canada_n, excel pvalue  noaster noparen dec(2)}
mac list signumlr signumgo




  
***** Brazil 9598 *****
use "/Users/anoury/Documents/Data/comp. votes data/LRGO_REGS/Brazil_reg.dta", clear

keep mp party party_name lr soclr go lr_stdev vote1	vote2	vote3	vote4	vote5	vote6	vote7	vote8	vote9	vote10	vote11	vote12	vote13	vote14	vote15	vote16	vote17	vote18	vote19	vote20	vote21	vote22	vote23	vote24	vote25	vote26	vote27	vote28	vote29	vote30	vote31	vote32	vote33	vote34	vote35	vote36	vote37	vote38	vote39	vote40	vote41	vote42	vote43	vote44	vote45	vote46	vote47	vote48	vote49	vote50	vote51	vote52	vote53	vote54	vote55	vote56	vote57	vote58	vote59	vote60	vote61	vote62	vote63	vote64	vote65	vote66	vote67	vote68	vote69	vote70	vote71	vote72	vote73	vote74	vote75	vote76	vote77	vote78	vote79	vote80	vote81	vote82	vote83	vote84	vote85	vote86	vote87	vote88	vote89	vote90	vote91	vote92	vote93	vote94	vote95	vote96	vote97	vote98	vote99	vote100	vote101	vote102	vote103	vote104	vote105	vote106	vote107	vote108	vote109	vote110	vote111	vote112	vote113	vote114	vote115	vote116	vote117	vote118	vote119	vote120	vote121	vote122	vote123	vote124	vote125	vote126	vote127	vote128	vote129	vote130	vote131	vote132	vote133	vote134	vote135	vote136	vote137	vote138	vote139	vote140	vote141	vote142	vote143	vote144	vote145	vote146	vote147	vote148	vote149	vote150	vote151	vote152	vote153	vote154	vote155	vote156	vote157	vote158	vote159	vote160	vote161	vote162	vote163	vote164	vote165	vote166	vote167	vote168	vote169	vote170	vote171	vote172	vote173	vote174	vote175	vote176	vote177	vote178	vote179	vote180	vote181	vote182	vote183	vote184	vote185	vote186	vote187	vote189	vote190	vote191	vote192	vote194	vote195	vote196	vote197	vote198	vote199	vote200	vote201	vote202	vote203	vote204	vote205	vote206	vote207	vote208	vote209	vote210	vote211	vote212	vote213	vote214	vote215	vote220	vote221	vote223	vote224	vote225	vote226	vote227	vote228	vote229	vote230	vote231	vote232	vote233	vote234	vote235	vote236	vote237	vote238	vote239	vote240	vote241	vote242	vote243	vote244	vote245	vote246	vote248	vote249	vote250	vote251	vote252	vote253	vote254	vote255	vote256	vote257	vote258	vote259	vote260	vote261	vote262	vote263	vote264	vote265	vote266	vote267	vote268	vote269	vote270	vote271	vote272	vote273	vote274	vote275	vote276	vote277	vote278	vote279	vote280	vote281	vote282	vote283	vote284	vote285	vote286	vote287	vote289	vote290	vote291	vote292	vote293	vote294	vote295	vote296	vote297	vote298	vote299	vote300	vote301	vote302	vote303	vote304	vote305	vote306	vote307	vote308	vote309	vote310	vote311	vote312	vote313	vote314	vote315	vote316	vote317	vote318	vote319	vote320	vote321	vote322	vote323	vote324	vote325	vote326	vote327	vote328	vote329	vote330	vote331	vote332	vote333	vote334	vote335	vote336	vote337	vote338	vote339	vote340	vote341	vote342	vote343	vote344	vote345	vote346	vote347	vote348	vote349	vote350	vote351	vote352	vote353	vote354	vote355	vote356	vote357	vote358	vote359	vote360	vote361	vote362	vote363	vote364	vote365	vote366	vote367	vote368	vote369	vote370	vote371	vote372	vote373	vote374	vote375	vote376	vote377	vote378	vote379	vote380	vote381	vote382	vote383	vote384	vote385	vote386	vote387	vote388	vote389	vote390	vote391	vote392	vote393	vote394	vote395	vote396	vote397	vote398	vote399	vote400	vote401	vote402	vote403	vote404	vote405	vote406	vote407	vote408	vote409	vote410	vote411	vote412	vote413	vote414	vote415	vote416	vote417	vote418	vote419	vote420	vote421	vote422	vote423	vote424	vote425	vote426	vote427	vote428	vote429	vote430	vote431	vote432	vote433	vote434	vote435	vote436	vote437	vote438	vote439	vote440	vote441	vote442	vote443	vote444	vote445	vote446	vote447	vote448	vote449	vote450	vote451	vote452



foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

desc
di r(k)

sigcoef lr go, replace   foreach y of varlist vote* {*simex (`y'=go)(w:lr), bstrap suuinit(suu)reg `y' lr go, cluster(party)sigcoef lr go, append
outreg2 using out_brazil_n, excel pvalue  noaster noparen }
mac list signumlr signumgo



***** Chile 9800 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/Chile_reg.dta", clear

*foreach y of varlist vote* {*summarize `y', meanonly *if r(mean)<0.05|r(mean)>0.95|r(N)<5 {*drop `y'*}*}
  
keep ord mp partyid party_name lr soclr go lr_stdev vote1	vote3	vote5	vote7	vote11	vote17	vote19	vote24	vote32	vote41	vote44	vote46	vote47	vote49	vote52	vote53	vote56	vote62	vote67	vote69	vote70	vote71	vote72	vote73	vote74	vote76	vote77	vote81	vote82	vote83	vote85	vote88	vote90	vote91	vote93	vote97	vote102	vote103	vote104	vote107	vote109	vote111	vote113	vote114	vote115	vote120	vote126	vote127	vote129	vote136	vote137	vote139	vote140	vote142	vote153	vote160	vote172	vote173	vote178	vote181	vote183	vote184	vote186	vote187	vote188	vote189	vote190	vote191	vote193	vote194	vote195	vote196	vote199	vote209	vote216	vote217	vote218	vote220	vote223	vote224	vote225	vote226	vote231	vote237	vote238	vote240	vote241	vote243	vote251	vote256	vote268	vote275	vote280	vote291	vote304	vote305	vote306	vote308	vote314	vote318	vote321	vote322	vote323	vote325	vote326	vote327	vote329	vote332	vote334	vote337	vote340	vote343	vote347	vote351	vote352	vote359	vote361	vote362	vote366	vote379	vote381	vote382	vote399	vote403	vote406	vote409	vote410	vote416	vote422	vote432	vote441	vote457	vote458	vote460	vote461	vote464	vote465	vote466	vote467	vote499	vote502	vote504	vote509	vote513	vote514	vote515	vote518	vote519	vote520 
 
   
sigcoef lr go, replace
   foreach y of varlist vote* {*simex (`y'=go)(w:lr), bstrap suuinit(suu)reg `y' lr go, cluster(partyid)sigcoef lr go, append 
 outreg2 using out_chile_n, excel pvalue  noaster noparen}
mac list signumlr signumgo


***** France 9702 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/France11_reg.dta", clear


foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}


sigcoef lr go, replace

foreach y of varlist vote* {*simex (`y'=go)(w:soclr), bstrap suuinit(suu) seed(1)reg `y' lr go, cluster(party_id)sigcoef lr go, append 
outreg2 using out_france_n, excel pvalue  noaster noparen}
mac list signumlr signumgo
***** Czech 98 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/czp98dreg.dta", clear

foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sigcoef lr go, replace
   foreach y of varlist vote* {*simex (`y'=go)(w:lr), bstrap suuinit(suu)reg `y' lr go, cluster(party1)sigcoef lr go, append 
outreg2 using out_czech98_n, excel pvalue  noaster noparen }mac list signumlr signumgo


***** Czech02 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/czech0206reg.dta", clear

foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sigcoef lr go, replace
   foreach y of varlist vote* {*simex (`y'=go)(w:lr), bstrap suuinit(suu)reg `y' lr go, cluster(party)sigcoef lr go, append 
 }mac list signumlr signumgo*outreg2 using out_czech02_n, excel pvalue  noaster noparen*}


***** Belgium 51th *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/Bel51a_reg.dta", clear

recode vote* (9=.)

foreach y of varlist vote* {summarize `y', meanonly if r(N)<5 |r(mean)<0.05|r(mean)>0.95{drop `y'}}

keep ord id partytok party lang lr soclr go lr_stdev vote6	vote7	vote9	vote10	vote11	vote12	vote13	vote15	vote19	vote20	vote23	vote24	vote25	vote26	vote27	vote28	vote29	vote31	vote32	vote33	vote34	vote35	vote37	vote38	vote39	vote42	vote43	vote44	vote45	vote46	vote47	vote48	vote51	vote53	vote54	vote59	vote60	vote61	vote66	vote67	vote69	vote70	vote71	vote72	vote73	vote74	vote76	vote77	vote78	vote79	vote80	vote81	vote82	vote83	vote84	vote85	vote91	vote92	vote93	vote97	vote98	vote99	vote100	vote101	vote102	vote103	vote104	vote105	vote106	vote107	vote108	vote109	vote111	vote112	vote113	vote115	vote116	vote117	vote118	vote119	vote122	vote123	vote124	vote125	vote127	vote128	vote129	vote131	vote132	vote133	vote134	vote135	vote136	vote137	vote138	vote139	vote140	vote141	vote142	vote143	vote144	vote145	vote147	vote148	vote149	vote150	vote151	vote153	vote154	vote155	vote156	vote157	vote158	vote160	vote161	vote163	vote164	vote165	vote166	vote167	vote169	vote170	vote171	vote172	vote173	vote174	vote175	vote176	vote177	vote178	vote183	vote184	vote185	vote186	vote187	vote196	vote198	vote199	vote200	vote201	vote202	vote210	vote211	vote214	vote215	vote216	vote217	vote218	vote219	vote220	vote222	vote224	vote225	vote227	vote228	vote229	vote231	vote233	vote234	vote235	vote236	vote239	vote240	vote241	vote242	vote243	vote244	vote245	vote246	vote247	vote248	vote250	vote251	vote252	vote253	vote254	vote255	vote256	vote257	vote259	vote260	vote261	vote262	vote265	vote266	vote267	vote268	vote269	vote270	vote271	vote275	vote276	vote278	vote279	vote280	vote281	vote282	vote283	vote284	vote285	vote286	vote287	vote288	vote289	vote290	vote293	vote295	vote296	vote297	vote298	vote299	vote300	vote303	vote304	vote305	vote306	vote307	vote309	vote312	vote313	vote314	vote316	vote321	vote322	vote326	vote327	vote331	vote332	vote333	vote336	vote340	vote344	vote345	vote346	vote348	vote349	vote350	vote352	vote353	vote356	vote357	vote358	vote359	vote360	vote361	vote362	vote363	vote364	vote366	vote368	vote371	vote372	vote373	vote374	vote377	vote378	vote379	vote384	vote385	vote386	vote387	vote388	vote389	vote390	vote391	vote392	vote394	vote395	vote396	vote404	vote407	vote414	vote415	vote421	vote422	vote423	vote424	vote427	vote429	vote430	vote431	vote432	vote433	vote434	vote435	vote436	vote437	vote438	vote440	vote441	vote442	vote443	vote444	vote445	vote446	vote447	vote448	vote449	vote450	vote451	vote452	vote453	vote454	vote455	vote456	vote457	vote461	vote462	vote464	vote465	vote466	vote475	vote476	vote479	vote480	vote481	vote482	vote483	vote484	vote485	vote491	vote492	vote493	vote494	vote497	vote498	vote499	vote500	vote501	vote502	vote503	vote505	vote506	vote507	vote508	vote509	vote510	vote511	vote512	vote513	vote514	vote515	vote516	vote517	vote519	vote521	vote522	vote523	vote524	vote525	vote527	vote528	vote529	vote530	vote531	vote532	vote533	vote534	vote535	vote536	vote537	vote538	vote541	vote543	vote544	vote545	vote546	vote548	vote550	vote553	vote556	vote557	vote558	vote560	vote561	vote562	vote563	vote564	vote565	vote566	vote567	vote568	vote569	vote570	vote571	vote572	vote573	vote574	vote575	vote576	vote577	vote578	vote579	vote580	vote581	vote582	vote583	vote584	vote585	vote586	vote587	vote588	vote589	vote590	vote591	vote592	vote593	vote594	vote595	vote596	vote597	vote598	vote599	vote600	vote601	vote602	vote603	vote604	vote605	vote606	vote613	vote615	vote616	vote617	vote618	vote619	vote621	vote623	vote625	vote626	vote627	vote628	vote633	vote635	vote637	vote638	vote639	vote640	vote641	vote642	vote643	vote644	vote645	vote646	vote647	vote648	vote649	vote650	vote651	vote656	vote657	vote658	vote659	vote660	vote661	vote662	vote663	vote665	vote666	vote667	vote669	vote670	vote671	vote673	vote676	vote677	vote678	vote679	vote680	vote681	vote682	vote686	vote694	vote695	vote697	vote699	vote701	vote702	vote706	vote707	vote708	vote711	vote712	vote713	vote714	vote715	vote716	vote717	vote719	vote720	vote722	vote723	vote724	vote725	vote728	vote729	vote730	vote731	vote732	vote733	vote734	vote735	vote738	vote743	vote745	vote750	vote751	vote752	vote753	vote754	vote758	vote759	vote760	vote762	vote764	vote765	vote766	vote767	vote768	vote769	vote770	vote771	vote772	vote773	vote774	vote775	vote776	vote778	vote781	vote782	vote783	vote784	vote785	vote786	vote787	vote789	vote792	vote794	vote795	vote796	vote797	vote799	vote800	vote801	vote802	vote809	vote811	vote812	vote813	vote817	vote818	vote820	vote821	vote826	vote827	vote828	vote829	vote830	vote831	vote834	vote836	vote837	vote840	vote841	vote842	vote844	vote845	vote846	vote847	vote848	vote849	vote864	vote865	vote866	vote867	vote872	vote878	vote879	vote880	vote883	vote884	vote885	vote886	vote887	vote888	vote889	vote890	vote891	vote892	vote894	vote895	vote897	vote899	vote900	vote901	vote902	vote905	vote906	vote907	vote908	vote909	vote910	vote911	vote912	vote913	vote914	vote915	vote916	vote919	vote921	vote922	vote923	vote924	vote925	vote926	vote928	vote930	vote934	vote935	vote939	vote940	vote941	vote949	vote950	vote952	vote953	vote955	vote956	vote958	vote959	vote960	vote961	vote962	vote970	vote971	vote972	vote973	vote975	vote976	vote977	vote978	vote980	vote981	vote982	vote989	vote991	vote993	vote995	vote996	vote997	vote998	vote999	vote1000	vote1001	vote1002	vote1003	vote1004	vote1005	vote1006	vote1007	vote1009	vote1010	vote1012	vote1013	vote1014	vote1022	vote1028	vote1029	vote1031	vote1032	vote1034	vote1035	vote1036	vote1037	vote1038	vote1042	vote1043	vote1044	vote1046	vote1049	vote1050	vote1051	vote1052	vote1053	vote1054	vote1059	vote1060	vote1061	vote1062	vote1063	vote1066	vote1069	vote1070	vote1071	vote1077	vote1078	vote1079	vote1080	vote1081	vote1082	vote1084	vote1085	vote1086	vote1087	vote1091	vote1092	vote1098	vote1099	vote1101	vote1104	vote1105	vote1112	vote1113	vote1114	vote1115	vote1116	vote1117	vote1118	vote1119	vote1120	vote1121	vote1122	vote1123	vote1124	vote1125	vote1126	vote1127	vote1128	vote1129	vote1130	vote1131	vote1132	vote1133	vote1134	vote1135	vote1136	vote1137	vote1138	vote1139	vote1140	vote1141	vote1142	vote1143	vote1144	vote1145	vote1146	vote1147	vote1148	vote1149	vote1150	vote1151	vote1161	vote1162	vote1163	vote1169	vote1173	vote1177	vote1178	vote1179	vote1181	vote1182	vote1183	vote1185	vote1186	vote1190	vote1191	vote1196	vote1197	vote1198	vote1203	vote1204	vote1205	vote1206	vote1209	vote1214	vote1223	vote1224	vote1225	vote1227	vote1228	vote1229	vote1232	vote1233	vote1234	vote1235	vote1236	vote1238	vote1241	vote1245	vote1250	vote1251	vote1252	vote1253	vote1254	vote1255	vote1258	vote1259	vote1261	vote1262	vote1263	vote1264	vote1265	vote1266	vote1267	vote1268	vote1273	vote1278	vote1279	vote1280	vote1284	vote1285	vote1287	vote1288	vote1289	vote1290	vote1291	vote1292	vote1293	vote1294	vote1295	vote1296	vote1297	vote1298	vote1299	vote1300	vote1301	vote1302	vote1303	vote1304	vote1305	vote1306	vote1307	vote1308	vote1309	vote1310	vote1311	vote1312	vote1313	vote1314	vote1315	vote1316	vote1317	vote1318	vote1320	vote1321	vote1322	vote1323	vote1324	vote1325	vote1326	vote1327	vote1328	vote1329	vote1330	vote1331	vote1332	vote1333	vote1334	vote1335	vote1339	vote1340	vote1341	vote1342	vote1343	vote1344	vote1345	vote1346	vote1347	vote1348	vote1349	vote1350	vote1351	vote1352	vote1353	vote1354	vote1355	vote1356	vote1357	vote1360	vote1361	vote1362	vote1363	vote1364	vote1365	vote1366	vote1367	vote1368	vote1369	vote1370	vote1371	vote1372	vote1373	vote1375	vote1376	vote1390	vote1391	vote1399	vote1401	vote1402	vote1403	vote1404	vote1405	vote1406	vote1407	vote1408	vote1409	vote1410	vote1411	vote1412	vote1413	vote1415	vote1419	vote1420	vote1421	vote1424	vote1425	vote1427	vote1428	vote1434	vote1438	vote1439	vote1449	vote1450	vote1451	vote1452	vote1453	vote1454	vote1455	vote1456	vote1457	vote1458	vote1459	vote1460	vote1461	vote1462	vote1463	vote1464	vote1465	vote1466	vote1467	vote1468	vote1469	vote1470	vote1471	vote1472	vote1473	vote1474	vote1475	vote1476	vote1477	vote1478	vote1479	vote1482	vote1488	vote1489	vote1490	vote1491	vote1492	vote1494	vote1495	vote1496	vote1497	vote1498	vote1499	vote1500	vote1501	vote1502	vote1503	vote1504	vote1505	vote1506	vote1507	vote1508	vote1509	vote1510	vote1511	vote1512	vote1513	vote1514	vote1515	vote1516	vote1520	vote1522	vote1524	vote1526	vote1527	vote1528	vote1529	vote1534	vote1535	vote1536	vote1537	vote1538	vote1544	vote1546	vote1550	vote1551	vote1552	vote1553	vote1556	vote1557	vote1558	vote1559	vote1565	vote1570	vote1571	vote1572	vote1575	vote1576	vote1577	vote1587	vote1588	vote1589	vote1590	vote1591	vote1593	vote1596	vote1597	vote1599	vote1600	vote1601	vote1602	vote1603	vote1604	vote1605	vote1606	vote1607	vote1613	vote1614	vote1615	vote1616	vote1617	vote1618	vote1620	vote1621	vote1622	vote1623	vote1631	vote1632	vote1633	vote1634	vote1635	vote1636	vote1643	vote1646	vote1649	vote1651	vote1652	vote1654	vote1655	vote1665	vote1670	vote1671	vote1672	vote1673	vote1674	vote1677	vote1680	vote1681	vote1683	vote1685	vote1689	vote1690	vote1700	vote1702	vote1703	vote1705	vote1707	vote1708	vote1715	vote1716	vote1722	vote1723	vote1724	vote1725	vote1726	vote1727	vote1728	vote1729	vote1731	vote1732	vote1735	vote1738	vote1739	vote1740	vote1741	vote1742	vote1744	vote1745	vote1746	vote1748	vote1749	vote1750	vote1751	vote1752	vote1753	vote1754	vote1755	vote1756	vote1757	vote1758	vote1759	vote1760	vote1761	vote1762	vote1763	vote1764	vote1765	vote1766	vote1767	vote1768	vote1769	vote1770	vote1771	vote1772	vote1773	vote1775	vote1776	vote1777	vote1778	vote1779	vote1780	vote1781	vote1783	vote1784	vote1785	vote1786	vote1788	vote1789	vote1790	vote1791	vote1792	vote1793	vote1795	vote1796	vote1797	vote1798	vote1799	vote1800	vote1801	vote1802	vote1803	vote1804	vote1805	vote1806	vote1808	vote1809	vote1810	vote1811	vote1812	vote1813	vote1814	vote1815	vote1816	vote1818	vote1819	vote1820	vote1830	vote1832 
  sigcoef lr go, replaceforeach y of varlist vote* {*simex (`y'=go)(w:lr),  bstrap suuinit(suu) reg `y' lr go, cluster(party)sigcoef lr go, append l(95)
 }
mac list signumlr signumgo
*outreg2 using out_bel51_n3, excel pvalue  noaster noparen*}

***** Israel 1999 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/Israel99_reg.dta", clear

foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sigcoef lr go, replace   foreach y of varlist vote* {*simex (`y'=go)(w:lr), bstrap suuinit(suu)reg `y' lr go, cluster(party)sigcoef lr go, append l(95)
}
mac list signumlr signumgo*outreg2 using out_israel99_n, excel pvalue  noaster noparen*}

***** Mexico 0306 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/Mexico59_reg.dta", clear

foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sigcoef lr go, replace   foreach y of varlist vote* {*simex (`y'=go)(w:lr), bstrap suuinit(suu)reg `y' lr go, cluster(electedparty)
sigcoef lr go, append l(95)
}mac list signumlr signumgo*outreg2 using out_mexico59_n, excel pvalue  noaster noparen
*}
***** Peru99 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/peru99_reg.dta", clear

keep  ord mp party party_name lr soclr go lr_stdev     vote8	vote12	vote15	vote40	vote47	vote56	vote58	vote69	vote72	vote74	vote75	vote76	vote85	vote87	vote89	vote101	vote104	vote106	vote120	vote125	vote130	vote133	vote135	vote145	vote148	vote155	vote157	vote174	vote175	vote177	vote178	vote180	vote183	vote184	vote185	vote189	vote190	vote194	vote203	vote204	vote209	vote220	vote221	vote224	vote233	vote234	vote245	vote246	vote247	vote248	vote249	vote250	vote251	vote258	vote261	vote262	vote264	vote272	vote275	vote289	vote290	vote291	vote294	vote314	vote321	vote334	vote343	vote346	vote347	vote348	vote359	vote362	vote364	vote393	vote408	vote412	vote415	vote440	vote441	vote455	vote464	vote469	vote475	vote476	vote477	vote478	vote481	vote482	vote485	vote489	vote490	vote492	vote493	vote494	vote505	vote525	vote527	vote530	vote531	vote546	vote547	vote554	vote556	vote570	vote574	vote576	vote587	vote590	vote618	vote625	vote638	vote647	vote648	vote653	vote657	vote659	vote663	vote664	vote665	vote668	vote672	vote673	vote676	vote679	vote683	vote684	vote685


sigcoef lr go, replace   foreach y of varlist vote* {*simex (`y'=go)(w:lr), bstrap suuinit(suu)reg `y' lr go, cluster(party)sigcoef lr go, append l(95)
}mac list signumlr signumgo*outreg2 using out_peru_n, excel pvalue  noaster noparen
*}

***** Poland 9397*****
use "/Users/anoury/Documents/Data/comp. votes data/LRGO_REGS/poland_reg.dta", clear

foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sigcoef lr go, replace   foreach y of varlist vote* {*simex (`y'=go)(w:lr), bstrap suuinit(suu)reg `y' lr go, cluster(party_id)sigcoef lr go, append l(95)
}
mac list signumlr signumgo*outreg2 using out_poland_n, excel pvalue  noaster noparen
*}

***** UK 9701 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/UK_Reg.dta", clear

sigcoef lr go, replace
foreach y of varlist vote* {summarize `y', meanonly if r(mean)<=0.05|r(mean)>=0.95|r(N)<=5 {drop `y'}}

   foreach y of varlist vote* {*simex (`y'=go)(w:lr), bstrap suuinit(suu)reg `y' lr go, cluster(party)sigcoef lr go, append
 }
mac list signumlr signumgo
*outreg2 using out_uk_n, excel pvalue  noaster noparen
*}

***** European Parliament 6th *****use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/ep6_reg.dta", clearforeach y of varlist vote* {summarize `y', meanonly if r(mean)<=0.05|r(mean)>=0.95|r(N)<=5 {drop `y'}}

sigcoef lr go, replace   foreach y of varlist vote* {*simex (`y'=go)(w:lr), bstrap suuinit(suu)reg `y' lr go, cluster(party)sigcoef lr go, append
 }
mac list signumlr signumgo*outreg2 using out_ep6_n, excel pvalue  noaster noparen
*}**** South Korea 17th ****use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/korea17_reg.dta"foreach y of varlist vote* {summarize `y', meanonly if r(mean)<=0.05|r(mean)>=0.95|r(N)<=5 {drop `y'}}

sigcoef lr go, replace
   foreach y of varlist vote* {*simex (`y'=go)(w:lr), bstrap suuinit(suu)reg `y' lr go, cluster(pid_17)sigcoef lr go, append
 }
mac list signumlr signumgo*outreg2 using out_skorea_n, excel pvalue  noaster noparen
*}***** Second Part: SIMEX Regressions to take into account the measurement error problems
*************************************************************************************

***** Canada 9497 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/Canada_reg.dta", clear

*recode v* (7=.)*drop in 1


foreach y of varlist v* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sum lr_stdev
mat suu = r(mean)
   foreach y of varlist v* {simex (`y'=go)(w:lr), bstrap suuinit(suu)*reg `y' lr go, cluster(party)outreg2 using out_canada_n1, excel pvalue  noaster noparen}


***** Brazil 9598 *****

use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/Brazil_reg.dta", clear


foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sum lr_stdev
mat suu = r(mean)
   foreach y of varlist vote* {simex (`y'=go)(w:lr), bstrap suuinit(suu)*reg `y' lr go, cluster(party)outreg2 using out_brazil_n1, excel pvalue  noaster noparen}


***** Chile 9800 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/Chile_reg.dta", clear

foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sum lr_stdev
mat suu = r(mean)
   foreach y of varlist vote* {simex (`y'=go)(w:lr), bstrap suuinit(suu)*reg `y' lr go, cluster(party)outreg2 using out_chile_n1, excel pvalue  noaster noparen}

***** France 9702 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/France11_reg.dta", clear

foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sum soclr_stdev
mat suu = r(mean)
   foreach y of varlist vote* {simex (`y'=go)(w:soclr), bstrap suuinit(suu) seed(1)*reg `y' lr go, cluster(party)outreg2 using out_france_n1, excel pvalue  noaster noparen}

***** Czech 9698 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/czp98dreg.dta", clear

foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sum lr_stdev
mat suu = r(mean)
   foreach y of varlist vote* {simex (`y'=go)(w:lr), bstrap suuinit(suu)*reg `y' lr go, cluster(party)outreg2 using out_czech98_n1, excel pvalue  noaster noparen}

***** Czech 0206 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/czech0206reg.dta", clear

foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sum lr_stdev
mat suu = r(mean)
   foreach y of varlist vote* {simex (`y'=go)(w:lr), bstrap suuinit(suu)*reg `y' lr go, cluster(party)outreg2 using out_czech02_n1, excel pvalue  noaster noparen}

***** Belgium 51th *****

use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/Bel51a_reg.dta", clear

recode vote* (9=.)

foreach y of varlist vote* {summarize `y', meanonly if r(N)<5 |r(mean)<0.05|r(mean)>0.95{drop `y'}}

sum lr_stdev
mat suu =r(mean)
   foreach y of varlist vote* {simex (`y'=go)(w:lr),  bstrap suuinit(suu) *reg `y' lr go, cluster(party)outreg2 using out_bel51_n1, excel pvalue  noaster noparen}

***** Israel 1999 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/Israel99_reg.dta", clear

foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sum lr_stdev
mat suu = r(mean)
   foreach y of varlist vote* {simex (`y'=go)(w:lr), bstrap suuinit(suu)*reg `y' lr go, cluster(party)outreg2 using out_israel99_n1, excel pvalue  noaster noparen}

***** Mexico 0306/59th *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/Mexico59_reg.dta", clear

foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sum lr_stdev
mat suu = r(mean)
   foreach y of varlist vote* {simex (`y'=go)(w:lr), bstrap suuinit(suu)*reg `y' lr go, cluster(party)outreg2 using out_mexico59_n1, excel pvalue  noaster noparen
}

***** Peru 9900 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/peru99_reg.dta", clear
foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sum lr_stdev
mat suu = r(mean)
   foreach y of varlist vote* {simex (`y'=go)(w:lr), bstrap suuinit(suu)*reg `y' lr go, cluster(party)outreg2 using out_peru_n1, excel pvalue  noaster noparen
}

***** Poland 9397 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/poland_reg.dta", clear

foreach y of varlist vote* {summarize `y', meanonly if r(mean)<0.05|r(mean)>0.95|r(N)<5 {drop `y'}}

sum lr_stdev
mat suu = r(mean)
   foreach y of varlist vote* {simex (`y'=go)(w:lr), bstrap suuinit(suu)*reg `y' lr go, cluster(party)outreg2 using out_poland_n1, excel pvalue  noaster noparen
}

***** UK 9701 *****
use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/UK_Reg.dta", clear


foreach y of varlist vote* {summarize `y', meanonly if r(mean)<=0.05|r(mean)>=0.95|r(N)<=5 {drop `y'}}

sum lr_stdev
mat suu = r(mean)
   foreach y of varlist vote* {simex (`y'=go)(w:lr), bstrap suuinit(suu)*reg `y' lr go, cluster(party)outreg2 using out_uk_n1, excel pvalue  noaster noparen
}

***** European Parliament 0409/6th *****use "/Users/anoury/Documents/Data/comp. votes data/PSRM/Data for replication/ep6_reg.dta", clearforeach y of varlist vote* {summarize `y', meanonly if r(mean)<=0.05|r(mean)>=0.95|r(N)<=5 {drop `y'}}

sum lr_stdev
mat suu = r(mean)
   foreach y of varlist vote* {simex (`y'=go)(w:lr), bstrap suuinit(suu)*reg `y' lr go, cluster(party)outreg2 using out_ep6_n1, excel pvalue  noaster noparen
}
