clear																						

*****Do file from Steven Li loads ICPSR data up to 1975

version	9.2																				
set memory 400m														
use "$startdir/$inputdata/hsb4.dta"																				
rename	V1	year																				
rename	V2	partyofgovConnecticut																				
rename	V3	upphsedemseatsConnecticut																				
rename	V4	upphsewrseatsConnecticut																				
rename	V5	upphseoneothseatsConnecticut																				
rename	V6	upphsetwoothseatsConnecticut																				
rename	V7	upphsetotalseatsConnecticut																				
rename	V8	lowhsedemseatsConnecticut																				
rename	V9	lowhsewrseatsConnecticut																				
rename	V10	lowhseoneothseatsConnecticut																				
rename	V11	lowhsetwoothseatsConnecticut																				
rename	V12	lowhsetotalseatsConnecticut																				
rename	V13	partyofgovMaine																				
rename	V14	upphsedemseatsMaine																				
rename	V15	upphsewrseatsMaine																				
rename	V16	upphseoneothseatsMaine																				
rename	V17	upphsetwoothseatsMaine																				
rename	V18	upphsetotalseatsMaine																				
rename	V19	lowhsedemseatsMaine																				
rename	V20	lowhsewrseatsMaine																				
rename	V21	lowhseoneothseatsMaine																				
rename	V22	lowhsetwoothseatsMaine																				
rename	V23	lowhsetotalseatsMaine																				
rename	V24	partyofgovMassachusetts																				
rename	V25	upphsedemseatsMassachusetts																				
rename	V26	upphsewrseatsMassachusetts																				
rename	V27	upphseoneothseatsMassachusetts																				
rename	V28	upphsetwoothseatsMassachusetts																				
rename	V29	upphsetotalseatsMassachusetts																				
rename	V30	lowhsedemseatsMassachusetts																				
rename	V31	lowhsewrseatsMassachusetts																				
rename	V32	lowhseoneothseatsMassachusetts																				
rename	V33	lowhsetwoothseatsMassachusetts																				
rename	V34	lowhsetotalseatsMassachusetts																				
rename	V35	partyofgovNewHampshire																				
rename	V36	upphsedemseatsNewHampshire																				
rename	V37	upphsewrseatsNewHampshire																				
rename	V38	upphseoneothseatsNewHampshire																				
rename	V39	upphsetwoothseatsNewHampshire																				
rename	V40	upphsetotalseatsNewHampshire																				
rename	V41	lowhsedemseatsNewHampshire																				
rename	V42	lowhsewrseatsNewHampshire																				
rename	V43	lowhseoneothseatsNewHampshire																				
rename	V44	lowhsetwoothseatsNewHampshire																				
rename	V45	lowhsetotalseatsNewHampshire																				
rename	V46	partyofgovRhodeIsland																				
rename	V47	upphsedemseatsRhodeIsland																				
rename	V48	upphsewrseatsRhodeIsland																				
rename	V49	upphseoneothseatsRhodeIsland																				
rename	V50	upphsetwoothseatsRhodeIsland																				
rename	V51	upphsetotalseatsRhodeIsland																				
rename	V52	lowhsedemseatsRhodeIsland																				
rename	V53	lowhsewrseatsRhodeIsland																				
rename	V54	lowhseoneothseatsRhodeIsland																				
rename	V55	lowhsetwoothseatsRhodeIsland																				
rename	V56	lowhsetotalseatsRhodeIsland																				
rename	V57	partyofgovVermont																				
rename	V58	upphsedemseatsVermont																				
rename	V59	upphsewrseatsVermont																				
rename	V60	upphseoneothseatsVermont																				
rename	V61	upphsetwoothseatsVermont																				
rename	V62	upphsetotalseatsVermont																				
rename	V63	lowhsedemseatsVermont																				
rename	V64	lowhsewrseatsVermont																				
rename	V65	lowhseoneothseatsVermont																				
rename	V66	lowhsetwoothseatsVermont																				
rename	V67	lowhsetotalseatsVermont																				
rename	V68	partyofgovDelaware																				
rename	V69	upphsedemseatsDelaware																				
rename	V70	upphsewrseatsDelaware																				
rename	V71	upphseoneothseatsDelaware																				
rename	V72	upphsetwoothseatsDelaware																				
rename	V73	upphsetotalseatsDelaware																				
rename	V74	lowhsedemseatsDelaware																				
rename	V75	lowhsewrseatsDelaware																				
rename	V76	lowhseoneothseatsDelaware																				
rename	V77	lowhsetwoothseatsDelaware																				
rename	V78	lowhsetotalseatsDelaware																				
rename	V79	partyofgovNewJersey																				
rename	V80	upphsedemseatsNewJersey																				
rename	V81	upphsewrseatsNewJersey																				
rename	V82	upphseoneothseatsNewJersey																				
rename	V83	upphsetwoothseatsNewJersey																				
rename	V84	upphsetotalseatsNewJersey																				
rename	V85	lowhsedemseatsNewJersey																				
rename	V86	lowhsewrseatsNewJersey																				
rename	V87	lowhseoneothseatsNewJersey																				
rename	V88	lowhsetwoothseatsNewJersey																				
rename	V89	lowhsetotalseatsNewJersey																				
rename	V90	partyofgovNewYork																				
rename	V91	upphsedemseatsNewYork																				
rename	V92	upphsewrseatsNewYork																				
rename	V93	upphseoneothseatsNewYork																				
rename	V94	upphsetwoothseatsNewYork																				
rename	V95	upphsetotalseatsNewYork																				
rename	V96	lowhsedemseatsNewYork																				
rename	V97	lowhsewrseatsNewYork																				
rename	V98	lowhseoneothseatsNewYork																				
rename	V99	lowhsetwoothseatsNewYork																				
rename	V100	lowhsetotalseatsNewYork																				
rename	V101	partyofgovPennsylvania																				
rename	V102	upphsedemseatsPennsylvania																				
rename	V103	upphsewrseatsPennsylvania																				
rename	V104	upphseoneothseatsPennsylvania																				
rename	V105	upphsetwoothseatsPennsylvania																				
rename	V106	upphsetotalseatsPennsylvania																				
rename	V107	lowhsedemseatsPennsylvania																				
rename	V108	lowhsewrseatsPennsylvania																				
rename	V109	lowhseoneothseatsPennsylvania																				
rename	V110	lowhsetwoothseatsPennsylvania																				
rename	V111	lowhsetotalseatsPennsylvania																				
rename	V112	partyofgovIllinois																				
rename	V113	upphsedemseatsIllinois																				
rename	V114	upphsewrseatsIllinois																				
rename	V115	upphseoneothseatsIllinois																				
rename	V116	upphsetwoothseatsIllinois																				
rename	V117	upphsetotalseatsIllinois																				
rename	V118	lowhsedemseatsIllinois																				
rename	V119	lowhsewrseatsIllinois																				
rename	V120	lowhseoneothseatsIllinois																				
rename	V121	lowhsetwoothseatsIllinois																				
rename	V122	lowhsetotalseatsIllinois																				
rename	V123	partyofgovIndiana																				
rename	V124	upphsedemseatsIndiana																				
rename	V125	upphsewrseatsIndiana																				
rename	V126	upphseoneothseatsIndiana																				
rename	V127	upphsetwoothseatsIndiana																				
rename	V128	upphsetotalseatsIndiana																				
rename	V129	lowhsedemseatsIndiana																				
rename	V130	lowhsewrseatsIndiana																				
rename	V131	lowhseoneothseatsIndiana																				
rename	V132	lowhsetwoothseatsIndiana																				
rename	V133	lowhsetotalseatsIndiana																				
rename	V134	partyofgovMichigan																				
rename	V135	upphsedemseatsMichigan																				
rename	V136	upphsewrseatsMichigan																				
rename	V137	upphseoneothseatsMichigan																				
rename	V138	upphsetwoothseatsMichigan																				
rename	V139	upphsetotalseatsMichigan																				
rename	V140	lowhsedemseatsMichigan																				
rename	V141	lowhsewrseatsMichigan																				
rename	V142	lowhseoneothseatsMichigan																				
rename	V143	lowhsetwoothseatsMichigan																				
rename	V144	lowhsetotalseatsMichigan																				
rename	V145	partyofgovOhio																				
rename	V146	upphsedemseatsOhio																				
rename	V147	upphsewrseatsOhio																				
rename	V148	upphseoneothseatsOhio																				
rename	V149	upphsetwoothseatsOhio																				
rename	V150	upphsetotalseatsOhio																				
rename	V151	lowhsedemseatsOhio																				
rename	V152	lowhsewrseatsOhio																				
rename	V153	lowhseoneothseatsOhio																				
rename	V154	lowhsetwoothseatsOhio																				
rename	V155	lowhsetotalseatsOhio																				
rename	V156	partyofgovWisconsin																				
rename	V157	upphsedemseatsWisconsin																				
rename	V158	upphsewrseatsWisconsin																				
rename	V159	upphseoneothseatsWisconsin																				
rename	V160	upphsetwoothseatsWisconsin																				
rename	V161	upphsetotalseatsWisconsin																				
rename	V162	lowhsedemseatsWisconsin																				
rename	V163	lowhsewrseatsWisconsin																				
rename	V164	lowhseoneothseatsWisconsin																				
rename	V165	lowhsetwoothseatsWisconsin																				
rename	V166	lowhsetotalseatsWisconsin																				
rename	V167	partyofgovIowa																				
rename	V168	upphsedemseatsIowa																				
rename	V169	upphsewrseatsIowa																				
rename	V170	upphseoneothseatsIowa																				
rename	V171	upphsetwoothseatsIowa																				
rename	V172	upphsetotalseatsIowa																				
rename	V173	lowhsedemseatsIowa																				
rename	V174	lowhsewrseatsIowa																				
rename	V175	lowhseoneothseatsIowa																				
rename	V176	lowhsetwoothseatsIowa																				
rename	V177	lowhsetotalseatsIowa																				
rename	V178	partyofgovKansas																				
rename	V179	upphsedemseatsKansas																				
rename	V180	upphsewrseatsKansas																				
rename	V181	upphseoneothseatsKansas																				
rename	V182	upphsetwoothseatsKansas																				
rename	V183	upphsetotalseatsKansas																				
rename	V184	lowhsedemseatsKansas																				
rename	V185	lowhsewrseatsKansas																				
rename	V186	lowhseoneothseatsKansas																				
rename	V187	lowhsetwoothseatsKansas																				
rename	V188	lowhsetotalseatsKansas																				
rename	V189	partyofgovMinnesota																				
rename	V190	upphsedemseatsMinnesota																				
rename	V191	upphsewrseatsMinnesota																				
rename	V192	upphseoneothseatsMinnesota																				
rename	V193	upphsetwoothseatsMinnesota																				
rename	V194	upphsetotalseatsMinnesota																				
rename	V195	lowhsedemseatsMinnesota																				
rename	V196	lowhsewrseatsMinnesota																				
rename	V197	lowhseoneothseatsMinnesota																				
rename	V198	lowhsetwoothseatsMinnesota																				
rename	V199	lowhsetotalseatsMinnesota																				
rename	V200	partyofgovMissouri																				
rename	V201	upphsedemseatsMissouri																				
rename	V202	upphsewrseatsMissouri																				
rename	V203	upphseoneothseatsMissouri																				
rename	V204	upphsetwoothseatsMissouri																				
rename	V205	upphsetotalseatsMissouri																				
rename	V206	lowhsedemseatsMissouri																				
rename	V207	lowhsewrseatsMissouri																				
rename	V208	lowhseoneothseatsMissouri																				
rename	V209	lowhsetwoothseatsMissouri																				
rename	V210	lowhsetotalseatsMissouri																				
rename	V211	partyofgovNebraska																				
rename	V212	upphsedemseatsNebraska																				
rename	V213	upphsewrseatsNebraska																				
rename	V214	upphseoneothseatsNebraska																				
rename	V215	upphsetwoothseatsNebraska																				
rename	V216	upphsetotalseatsNebraska																				
rename	V217	lowhsedemseatsNebraska																				
rename	V218	lowhsewrseatsNebraska																				
rename	V219	lowhseoneothseatsNebraska																				
rename	V220	lowhsetwoothseatsNebraska																				
rename	V221	lowhsetotalseatsNebraska																				
rename	V222	partyofgovNorthDakota																				
rename	V223	upphsedemseatsNorthDakota																				
rename	V224	upphsewrseatsNorthDakota																				
rename	V225	upphseoneothseatsNorthDakota																				
rename	V226	upphsetwoothseatsNorthDakota																				
rename	V227	upphsetotalseatsNorthDakota																				
rename	V228	lowhsedemseatsNorthDakota																				
rename	V229	lowhsewrseatsNorthDakota																				
rename	V230	lowhseoneothseatsNorthDakota																				
rename	V231	lowhsetwoothseatsNorthDakota																				
rename	V232	lowhsetotalseatsNorthDakota																				
rename	V233	partyofgovSouthDakota																				
rename	V234	upphsedemseatsSouthDakota																				
rename	V235	upphsewrseatsSouthDakota																				
rename	V236	upphseoneothseatsSouthDakota																				
rename	V237	upphsetwoothseatsSouthDakota																				
rename	V238	upphsetotalseatsSouthDakota																				
rename	V239	lowhsedemseatsSouthDakota																				
rename	V240	lowhsewrseatsSouthDakota																				
rename	V241	lowhseoneothseatsSouthDakota																				
rename	V242	lowhsetwoothseatsSouthDakota																				
rename	V243	lowhsetotalseatsSouthDakota																				
rename	V244	partyofgovVirginia																				
rename	V245	upphsedemseatsVirginia																				
rename	V246	upphsewrseatsVirginia																				
rename	V247	upphseoneothseatsVirginia																				
rename	V248	upphsetwoothseatsVirginia																				
rename	V249	upphsetotalseatsVirginia																				
rename	V250	lowhsedemseatsVirginia																				
rename	V251	lowhsewrseatsVirginia																				
rename	V252	lowhseoneothseatsVirginia																				
rename	V253	lowhsetwoothseatsVirginia																				
rename	V254	lowhsetotalseatsVirginia																				
rename	V255	partyofgovAlabama																				
rename	V256	upphsedemseatsAlabama																				
rename	V257	upphsewrseatsAlabama																				
rename	V258	upphseoneothseatsAlabama																				
rename	V259	upphsetwoothseatsAlabama																				
rename	V260	upphsetotalseatsAlabama																				
rename	V261	lowhsedemseatsAlabama																				
rename	V262	lowhsewrseatsAlabama																				
rename	V263	lowhseoneothseatsAlabama																				
rename	V264	lowhsetwoothseatsAlabama																				
rename	V265	lowhsetotalseatsAlabama																				
rename	V266	partyofgovArkansas																				
rename	V267	upphsedemseatsArkansas																				
rename	V268	upphsewrseatsArkansas																				
rename	V269	upphseoneothseatsArkansas																				
rename	V270	upphsetwoothseatsArkansas																				
rename	V271	upphsetotalseatsArkansas																				
rename	V272	lowhsedemseatsArkansas																				
rename	V273	lowhsewrseatsArkansas																				
rename	V274	lowhseoneothseatsArkansas																				
rename	V275	lowhsetwoothseatsArkansas																				
rename	V276	lowhsetotalseatsArkansas																				
rename	V277	partyofgovFlorida																				
rename	V278	upphsedemseatsFlorida																				
rename	V279	upphsewrseatsFlorida																				
rename	V280	upphseoneothseatsFlorida																				
rename	V281	upphsetwoothseatsFlorida																				
rename	V282	upphsetotalseatsFlorida																				
rename	V283	lowhsedemseatsFlorida																				
rename	V284	lowhsewrseatsFlorida																				
rename	V285	lowhseoneothseatsFlorida																				
rename	V286	lowhsetwoothseatsFlorida																				
rename	V287	lowhsetotalseatsFlorida																				
rename	V288	partyofgovGeorgia																				
rename	V289	upphsedemseatsGeorgia																				
rename	V290	upphsewrseatsGeorgia																				
rename	V291	upphseoneothseatsGeorgia																				
rename	V292	upphsetwoothseatsGeorgia																				
rename	V293	upphsetotalseatsGeorgia																				
rename	V294	lowhsedemseatsGeorgia																				
rename	V295	lowhsewrseatsGeorgia																				
rename	V296	lowhseoneothseatsGeorgia																				
rename	V297	lowhsetwoothseatsGeorgia																				
rename	V298	lowhsetotalseatsGeorgia																				
rename	V299	partyofgovLouisiana																				
rename	V300	upphsedemseatsLouisiana																				
rename	V301	upphsewrseatsLouisiana																				
rename	V302	upphseoneothseatsLouisiana																				
rename	V303	upphsetwoothseatsLouisiana																				
rename	V304	upphsetotalseatsLouisiana																				
rename	V305	lowhsedemseatsLouisiana																				
rename	V306	lowhsewrseatsLouisiana																				
rename	V307	lowhseoneothseatsLouisiana																				
rename	V308	lowhsetwoothseatsLouisiana																				
rename	V309	lowhsetotalseatsLouisiana																				
rename	V310	partyofgovMississippi																				
rename	V311	upphsedemseatsMississippi																				
rename	V312	upphsewrseatsMississippi																				
rename	V313	upphseoneothseatsMississippi																				
rename	V314	upphsetwoothseatsMississippi																				
rename	V315	upphsetotalseatsMississippi																				
rename	V316	lowhsedemseatsMississippi																				
rename	V317	lowhsewrseatsMississippi																				
rename	V318	lowhseoneothseatsMississippi																				
rename	V319	lowhsetwoothseatsMississippi																				
rename	V320	lowhsetotalseatsMississippi																				
rename	V321	partyofgovNorthCarolina																				
rename	V322	upphsedemseatsNorthCarolina																				
rename	V323	upphsewrseatsNorthCarolina																				
rename	V324	upphseoneothseatsNorthCarolina																				
rename	V325	upphsetwoothseatsNorthCarolina																				
rename	V326	upphsetotalseatsNorthCarolina																				
rename	V327	lowhsedemseatsNorthCarolina																				
rename	V328	lowhsewrseatsNorthCarolina																				
rename	V329	lowhseoneothseatsNorthCarolina																				
rename	V330	lowhsetwoothseatsNorthCarolina																				
rename	V331	lowhsetotalseatsNorthCarolina																				
rename	V332	partyofgovSouthCarolina																				
rename	V333	upphsedemseatsSouthCarolina																				
rename	V334	upphsewrseatsSouthCarolina																				
rename	V335	upphseoneothseatsSouthCarolina																				
rename	V336	upphsetwoothseatsSouthCarolina																				
rename	V337	upphsetotalseatsSouthCarolina																				
rename	V338	lowhsedemseatsSouthCarolina																				
rename	V339	lowhsewrseatsSouthCarolina																				
rename	V340	lowhseoneothseatsSouthCarolina																				
rename	V341	lowhsetwoothseatsSouthCarolina																				
rename	V342	lowhsetotalseatsSouthCarolina																				
rename	V343	partyofgovTexas																				
rename	V344	upphsedemseatsTexas																				
rename	V345	upphsewrseatsTexas																				
rename	V346	upphseoneothseatsTexas																				
rename	V347	upphsetwoothseatsTexas																				
rename	V348	upphsetotalseatsTexas																				
rename	V349	lowhsedemseatsTexas																				
rename	V350	lowhsewrseatsTexas																				
rename	V351	lowhseoneothseatsTexas																				
rename	V352	lowhsetwoothseatsTexas																				
rename	V353	lowhsetotalseatsTexas																				
rename	V354	partyofgovKentucky																				
rename	V355	upphsedemseatsKentucky																				
rename	V356	upphsewrseatsKentucky																				
rename	V357	upphseoneothseatsKentucky																				
rename	V358	upphsetwoothseatsKentucky																				
rename	V359	upphsetotalseatsKentucky																				
rename	V360	lowhsedemseatsKentucky																				
rename	V361	lowhsewrseatsKentucky																				
rename	V362	lowhseoneothseatsKentucky																				
rename	V363	lowhsetwoothseatsKentucky																				
rename	V364	lowhsetotalseatsKentucky																				
rename	V365	partyofgovMaryland																				
rename	V366	upphsedemseatsMaryland																				
rename	V367	upphsewrseatsMaryland																				
rename	V368	upphseoneothseatsMaryland																				
rename	V369	upphsetwoothseatsMaryland																				
rename	V370	upphsetotalseatsMaryland																				
rename	V371	lowhsedemseatsMaryland																				
rename	V372	lowhsewrseatsMaryland																				
rename	V373	lowhseoneothseatsMaryland																				
rename	V374	lowhsetwoothseatsMaryland																				
rename	V375	lowhsetotalseatsMaryland																				
rename	V376	partyofgovOklahoma																				
rename	V377	upphsedemseatsOklahoma																				
rename	V378	upphsewrseatsOklahoma																				
rename	V379	upphseoneothseatsOklahoma																				
rename	V380	upphsetwoothseatsOklahoma																				
rename	V381	upphsetotalseatsOklahoma																				
rename	V382	lowhsedemseatsOklahoma																				
rename	V383	lowhsewrseatsOklahoma																				
rename	V384	lowhseoneothseatsOklahoma																				
rename	V385	lowhsetwoothseatsOklahoma																				
rename	V386	lowhsetotalseatsOklahoma																				
rename	V387	partyofgovTennessee																				
rename	V388	upphsedemseatsTennessee																				
rename	V389	upphsewrseatsTennessee																				
rename	V390	upphseoneothseatsTennessee																				
rename	V391	upphsetwoothseatsTennessee																				
rename	V392	upphsetotalseatsTennessee																				
rename	V393	lowhsedemseatsTennessee																				
rename	V394	lowhsewrseatsTennessee																				
rename	V395	lowhseoneothseatsTennessee																				
rename	V396	lowhsetwoothseatsTennessee																				
rename	V397	lowhsetotalseatsTennessee																				
rename	V398	partyofgovWestVirginia																				
rename	V399	upphsedemseatsWestVirginia																				
rename	V400	upphsewrseatsWestVirginia																				
rename	V401	upphseoneothseatsWestVirginia																				
rename	V402	upphsetwoothseatsWestVirginia																				
rename	V403	upphsetotalseatsWestVirginia																				
rename	V404	lowhsedemseatsWestVirginia																				
rename	V405	lowhsewrseatsWestVirginia																				
rename	V406	lowhseoneothseatsWestVirginia																				
rename	V407	lowhsetwoothseatsWestVirginia																				
rename	V408	lowhsetotalseatsWestVirginia																				
rename	V409	partyofgovArizona																				
rename	V410	upphsedemseatsArizona																				
rename	V411	upphsewrseatsArizona																				
rename	V412	upphseoneothseatsArizona																				
rename	V413	upphsetwoothseatsArizona																				
rename	V414	upphsetotalseatsArizona																				
rename	V415	lowhsedemseatsArizona																				
rename	V416	lowhsewrseatsArizona																				
rename	V417	lowhseoneothseatsArizona																				
rename	V418	lowhsetwoothseatsArizona																				
rename	V419	lowhsetotalseatsArizona																				
rename	V420	partyofgovColorado																				
rename	V421	upphsedemseatsColorado																				
rename	V422	upphsewrseatsColorado																				
rename	V423	upphseoneothseatsColorado																				
rename	V424	upphsetwoothseatsColorado																				
rename	V425	upphsetotalseatsColorado																				
rename	V426	lowhsedemseatsColorado																				
rename	V427	lowhsewrseatsColorado																				
rename	V428	lowhseoneothseatsColorado																				
rename	V429	lowhsetwoothseatsColorado																				
rename	V430	lowhsetotalseatsColorado																				
rename	V431	partyofgovIdaho																				
rename	V432	upphsedemseatsIdaho																				
rename	V433	upphsewrseatsIdaho																				
rename	V434	upphseoneothseatsIdaho																				
rename	V435	upphsetwoothseatsIdaho																				
rename	V436	upphsetotalseatsIdaho																				
rename	V437	lowhsedemseatsIdaho																				
rename	V438	lowhsewrseatsIdaho																				
rename	V439	lowhseoneothseatsIdaho																				
rename	V440	lowhsetwoothseatsIdaho																				
rename	V441	lowhsetotalseatsIdaho																				
rename	V442	partyofgovMontana																				
rename	V443	upphsedemseatsMontana																				
rename	V444	upphsewrseatsMontana																				
rename	V445	upphseoneothseatsMontana																				
rename	V446	upphsetwoothseatsMontana																				
rename	V447	upphsetotalseatsMontana																				
rename	V448	lowhsedemseatsMontana																				
rename	V449	lowhsewrseatsMontana																				
rename	V450	lowhseoneothseatsMontana																				
rename	V451	lowhsetwoothseatsMontana																				
rename	V452	lowhsetotalseatsMontana																				
rename	V453	partyofgovNevada																				
rename	V454	upphsedemseatsNevada																				
rename	V455	upphsewrseatsNevada																				
rename	V456	upphseoneothseatsNevada																				
rename	V457	upphsetwoothseatsNevada																				
rename	V458	upphsetotalseatsNevada																				
rename	V459	lowhsedemseatsNevada																				
rename	V460	lowhsewrseatsNevada																				
rename	V461	lowhseoneothseatsNevada																				
rename	V462	lowhsetwoothseatsNevada																				
rename	V463	lowhsetotalseatsNevada																				
rename	V464	partyofgovNewMexico																				
rename	V465	upphsedemseatsNewMexico																				
rename	V466	upphsewrseatsNewMexico																				
rename	V467	upphseoneothseatsNewMexico																				
rename	V468	upphsetwoothseatsNewMexico																				
rename	V469	upphsetotalseatsNewMexico																				
rename	V470	lowhsedemseatsNewMexico																				
rename	V471	lowhsewrseatsNewMexico																				
rename	V472	lowhseoneothseatsNewMexico																				
rename	V473	lowhsetwoothseatsNewMexico																				
rename	V474	lowhsetotalseatsNewMexico																				
rename	V475	partyofgovUtah																				
rename	V476	upphsedemseatsUtah																				
rename	V477	upphsewrseatsUtah																				
rename	V478	upphseoneothseatsUtah																				
rename	V479	upphsetwoothseatsUtah																				
rename	V480	upphsetotalseatsUtah																				
rename	V481	lowhsedemseatsUtah																				
rename	V482	lowhsewrseatsUtah																				
rename	V483	lowhseoneothseatsUtah																				
rename	V484	lowhsetwoothseatsUtah																				
rename	V485	lowhsetotalseatsUtah																				
rename	V486	partyofgovWyoming																				
rename	V487	upphsedemseatsWyoming																				
rename	V488	upphsewrseatsWyoming																				
rename	V489	upphseoneothseatsWyoming																				
rename	V490	upphsetwoothseatsWyoming																				
rename	V491	upphsetotalseatsWyoming																				
rename	V492	lowhsedemseatsWyoming																				
rename	V493	lowhsewrseatsWyoming																				
rename	V494	lowhseoneothseatsWyoming																				
rename	V495	lowhsetwoothseatsWyoming																				
rename	V496	lowhsetotalseatsWyoming																				
rename	V497	partyofgovCalifornia																				
rename	V498	upphsedemseatsCalifornia																				
rename	V499	upphsewrseatsCalifornia																				
rename	V500	upphseoneothseatsCalifornia																				
rename	V501	upphsetwoothseatsCalifornia																				
rename	V502	upphsetotalseatsCalifornia																				
rename	V503	lowhsedemseatsCalifornia																				
rename	V504	lowhsewrseatsCalifornia																				
rename	V505	lowhseoneothseatsCalifornia																				
rename	V506	lowhsetwoothseatsCalifornia																				
rename	V507	lowhsetotalseatsCalifornia																				
rename	V508	partyofgovOregon																				
rename	V509	upphsedemseatsOregon																				
rename	V510	upphsewrseatsOregon																				
rename	V511	upphseoneothseatsOregon																				
rename	V512	upphsetwoothseatsOregon																				
rename	V513	upphsetotalseatsOregon																				
rename	V514	lowhsedemseatsOregon																				
rename	V515	lowhsewrseatsOregon																				
rename	V516	lowhseoneothseatsOregon																				
rename	V517	lowhsetwoothseatsOregon																				
rename	V518	lowhsetotalseatsOregon																				
rename	V519	partyofgovWashington																				
rename	V520	upphsedemseatsWashington																				
rename	V521	upphsewrseatsWashington																				
rename	V522	upphseoneothseatsWashington																				
rename	V523	upphsetwoothseatsWashington																				
rename	V524	upphsetotalseatsWashington																				
rename	V525	lowhsedemseatsWashington																				
rename	V526	lowhsewrseatsWashington																				
rename	V527	lowhseoneothseatsWashington																				
rename	V528	lowhsetwoothseatsWashington																				
rename	V529	lowhsetotalseatsWashington																				
rename	V530	partyofgovAlaska																				
rename	V531	upphsedemseatsAlaska																				
rename	V532	upphsewrseatsAlaska																				
rename	V533	upphseoneothseatsAlaska																				
rename	V534	upphsetwoothseatsAlaska																				
rename	V535	upphsetotalseatsAlaska																				
rename	V536	lowhsedemseatsAlaska																				
rename	V537	lowhsewrseatsAlaska																				
rename	V538	lowhseoneothseatsAlaska																				
rename	V539	lowhsetwoothseatsAlaska																				
rename	V540	lowhsetotalseatsAlaska																				
rename	V541	partyofgovHawaii																				
rename	V542	upphsedemseatsHawaii																				
rename	V543	upphsewrseatsHawaii																				
rename	V544	upphseoneothseatsHawaii																				
rename	V545	upphsetwoothseatsHawaii																				
rename	V546	upphsetotalseatsHawaii																				
rename	V547	lowhsedemseatsHawaii																				
rename	V548	lowhsewrseatsHawaii																				
rename	V549	lowhseoneothseatsHawaii																				
rename	V550	lowhsetwoothseatsHawaii																				
rename	V551	lowhsetotalseatsHawaii																				
rename	V552	upphsepdemseatConnecticut																				
rename	V553	upphsepwrseatConnecticut																				
rename	V554	upphseponeothseatConnecticut																				
rename	V555	upphseptwoothseatConnecticut																				
rename	V556	lowhsepdemseatConnecticut																				
rename	V557	lowhsepwrseatConnecticut																				
rename	V558	lowhseponeothseatConnecticut																				
rename	V559	lowhseptwoothseatConnecticut																				
rename	V560	upphsepdemseatMaine																				
rename	V561	upphsepwrseatMaine																				
rename	V562	upphseponeothseatMaine																				
rename	V563	upphseptwoothseatMaine																				
rename	V564	lowhsepdemseatMaine																				
rename	V565	lowhsepwrseatMaine																				
rename	V566	lowhseponeothseatMaine																				
rename	V567	lowhseptwoothseatMaine																				
rename	V568	upphsepdemseatMassachusetts																				
rename	V569	upphsepwrseatMassachusetts																				
rename	V570	upphseponeothseatMassachusetts																				
rename	V571	upphseptwoothseatMassachusetts																				
rename	V572	lowhsepdemseatMassachusetts																				
rename	V573	lowhsepwrseatMassachusetts																				
rename	V574	lowhseponeothseatMassachusetts																				
rename	V575	lowhseptwoothseatMassachusetts																				
rename	V576	upphsepdemseatNewHampshire																				
rename	V577	upphsepwrseatNewHampshire																				
rename	V578	upphseponeothseatNewHampshire																				
rename	V579	upphseptwoothseatNewHampshire																				
rename	V580	lowhsepdemseatNewHampshire																				
rename	V581	lowhsepwrseatNewHampshire																				
rename	V582	lowhseponeothseatNewHampshire																				
rename	V583	lowhseptwoothseatNewHampshire																				
rename	V584	upphsepdemseatRhodeIsland																				
rename	V585	upphsepwrseatRhodeIsland																				
rename	V586	upphseponeothseatRhodeIsland																				
rename	V587	upphseptwoothseatRhodeIsland																				
rename	V588	lowhsepdemseatRhodeIsland																				
rename	V589	lowhsepwrseatRhodeIsland																				
rename	V590	lowhseponeothseatRhodeIsland																				
rename	V591	lowhseptwoothseatRhodeIsland																				
rename	V592	upphsepdemseatVermont																				
rename	V593	upphsepwrseatVermont																				
rename	V594	upphseponeothseatVermont																				
rename	V595	upphseptwoothseatVermont																				
rename	V596	lowhsepdemseatVermont																				
rename	V597	lowhsepwrseatVermont																				
rename	V598	lowhseponeothseatVermont																				
rename	V599	lowhseptwoothseatVermont																				
rename	V600	upphsepdemseatDelaware																				
rename	V601	upphsepwrseatDelaware																				
rename	V602	upphseponeothseatDelaware																				
rename	V603	upphseptwoothseatDelaware																				
rename	V604	lowhsepdemseatDelaware																				
rename	V605	lowhsepwrseatDelaware																				
rename	V606	lowhseponeothseatDelaware																				
rename	V607	lowhseptwoothseatDelaware																				
rename	V608	upphsepdemseatNewJersey																				
rename	V609	upphsepwrseatNewJersey																				
rename	V610	upphseponeothseatNewJersey																				
rename	V611	upphseptwoothseatNewJersey																				
rename	V612	lowhsepdemseatNewJersey																				
rename	V613	lowhsepwrseatNewJersey																				
rename	V614	lowhseponeothseatNewJersey																				
rename	V615	lowhseptwoothseatNewJersey																				
rename	V616	upphsepdemseatNewYork																				
rename	V617	upphsepwrseatNewYork																				
rename	V618	upphseponeothseatNewYork																				
rename	V619	upphseptwoothseatNewYork																				
rename	V620	lowhsepdemseatNewYork																				
rename	V621	lowhsepwrseatNewYork																				
rename	V622	lowhseponeothseatNewYork																				
rename	V623	lowhseptwoothseatNewYork																				
rename	V624	upphsepdemseatPennsylvania																				
rename	V625	upphsepwrseatPennsylvania																				
rename	V626	upphseponeothseatPennsylvania																				
rename	V627	upphseptwoothseatPennsylvania																				
rename	V628	lowhsepdemseatPennsylvania																				
rename	V629	lowhsepwrseatPennsylvania																				
rename	V630	lowhseponeothseatPennsylvania																				
rename	V631	lowhseptwoothseatPennsylvania																				
rename	V632	upphsepdemseatIllinois																				
rename	V633	upphsepwrseatIllinois																				
rename	V634	upphseponeothseatIllinois																				
rename	V635	upphseptwoothseatIllinois																				
rename	V636	lowhsepdemseatIllinois																				
rename	V637	lowhsepwrseatIllinois																				
rename	V638	lowhseponeothseatIllinois																				
rename	V639	lowhseptwoothseatIllinois																				
rename	V640	upphsepdemseatIndiana																				
rename	V641	upphsepwrseatIndiana																				
rename	V642	upphseponeothseatIndiana																				
rename	V643	upphseptwoothseatIndiana																				
rename	V644	lowhsepdemseatIndiana																				
rename	V645	lowhsepwrseatIndiana																				
rename	V646	lowhseponeothseatIndiana																				
rename	V647	lowhseptwoothseatIndiana																				
rename	V648	upphsepdemseatMichigan																				
rename	V649	upphsepwrseatMichigan																				
rename	V650	upphseponeothseatMichigan																				
rename	V651	upphseptwoothseatMichigan																				
rename	V652	lowhsepdemseatMichigan																				
rename	V653	lowhsepwrseatMichigan																				
rename	V654	lowhseponeothseatMichigan																				
rename	V655	lowhseptwoothseatMichigan																				
rename	V656	upphsepdemseatOhio																				
rename	V657	upphsepwrseatOhio																				
rename	V658	upphseponeothseatOhio																				
rename	V659	upphseptwoothseatOhio																				
rename	V660	lowhsepdemseatOhio																				
rename	V661	lowhsepwrseatOhio																				
rename	V662	lowhseponeothseatOhio																				
rename	V663	lowhseptwoothseatOhio																				
rename	V664	upphsepdemseatWisconsin																				
rename	V665	upphsepwrseatWisconsin																				
rename	V666	upphseponeothseatWisconsin																				
rename	V667	upphseptwoothseatWisconsin																				
rename	V668	lowhsepdemseatWisconsin																				
rename	V669	lowhsepwrseatWisconsin																				
rename	V670	lowhseponeothseatWisconsin																				
rename	V671	lowhseptwoothseatWisconsin																				
rename	V672	upphsepdemseatIowa																				
rename	V673	upphsepwrseatIowa																				
rename	V674	upphseponeothseatIowa																				
rename	V675	upphseptwoothseatIowa																				
rename	V676	lowhsepdemseatIowa																				
rename	V677	lowhsepwrseatIowa																				
rename	V678	lowhseponeothseatIowa																				
rename	V679	lowhseptwoothseatIowa																				
rename	V680	upphsepdemseatKansas																				
rename	V681	upphsepwrseatKansas																				
rename	V682	upphseponeothseatKansas																				
rename	V683	upphseptwoothseatKansas																				
rename	V684	lowhsepdemseatKansas																				
rename	V685	lowhsepwrseatKansas																				
rename	V686	lowhseponeothseatKansas																				
rename	V687	lowhseptwoothseatKansas																				
rename	V688	upphsepdemseatMinnesota																				
rename	V689	upphsepwrseatMinnesota																				
rename	V690	upphseponeothseatMinnesota																				
rename	V691	upphseptwoothseatMinnesota																				
rename	V692	lowhsepdemseatMinnesota																				
rename	V693	lowhsepwrseatMinnesota																				
rename	V694	lowhseponeothseatMinnesota																				
rename	V695	lowhseptwoothseatMinnesota																				
rename	V696	upphsepdemseatMissouri																				
rename	V697	upphsepwrseatMissouri																				
rename	V698	upphseponeothseatMissouri																				
rename	V699	upphseptwoothseatMissouri																				
rename	V700	lowhsepdemseatMissouri																				
rename	V701	lowhsepwrseatMissouri																				
rename	V702	lowhseponeothseatMissouri																				
rename	V703	lowhseptwoothseatMissouri																				
rename	V704	upphsepdemseatNebraska																				
rename	V705	upphsepwrseatNebraska																				
rename	V706	upphseponeothseatNebraska																				
rename	V707	upphseptwoothseatNebraska																				
rename	V708	lowhsepdemseatNebraska																				
rename	V709	lowhsepwrseatNebraska																				
rename	V710	lowhseponeothseatNebraska																				
rename	V711	lowhseptwoothseatNebraska																				
rename	V712	upphsepdemseatNorthDakota																				
rename	V713	upphsepwrseatNorthDakota																				
rename	V714	upphseponeothseatNorthDakota																				
rename	V715	upphseptwoothseatNorthDakota																				
rename	V716	lowhsepdemseatNorthDakota																				
rename	V717	lowhsepwrseatNorthDakota																				
rename	V718	lowhseponeothseatNorthDakota																				
rename	V719	lowhseptwoothseatNorthDakota																				
rename	V720	upphsepdemseatSouthDakota																				
rename	V721	upphsepwrseatSouthDakota																				
rename	V722	upphseponeothseatSouthDakota																				
rename	V723	upphseptwoothseatSouthDakota																				
rename	V724	lowhsepdemseatSouthDakota																				
rename	V725	lowhsepwrseatSouthDakota																				
rename	V726	lowhseponeothseatSouthDakota																				
rename	V727	lowhseptwoothseatSouthDakota																				
rename	V728	upphsepdemseatVirginia																				
rename	V729	upphsepwrseatVirginia																				
rename	V730	upphseponeothseatVirginia																				
rename	V731	upphseptwoothseatVirginia																				
rename	V732	lowhsepdemseatVirginia																				
rename	V733	lowhsepwrseatVirginia																				
rename	V734	lowhseponeothseatVirginia																				
rename	V735	lowhseptwoothseatVirginia																				
rename	V736	upphsepdemseatAlabama																				
rename	V737	upphsepwrseatAlabama																				
rename	V738	upphseponeothseatAlabama																				
rename	V739	upphseptwoothseatAlabama																				
rename	V740	lowhsepdemseatAlabama																				
rename	V741	lowhsepwrseatAlabama																				
rename	V742	lowhseponeothseatAlabama																				
rename	V743	lowhseptwoothseatAlabama																				
rename	V744	upphsepdemseatArkansas																				
rename	V745	upphsepwrseatArkansas																				
rename	V746	upphseponeothseatArkansas																				
rename	V747	upphseptwoothseatArkansas																				
rename	V748	lowhsepdemseatArkansas																				
rename	V749	lowhsepwrseatArkansas																				
rename	V750	lowhseponeothseatArkansas																				
rename	V751	lowhseptwoothseatArkansas																				
rename	V752	upphsepdemseatFlorida																				
rename	V753	upphsepwrseatFlorida																				
rename	V754	upphseponeothseatFlorida																				
rename	V755	upphseptwoothseatFlorida																				
rename	V756	lowhsepdemseatFlorida																				
rename	V757	lowhsepwrseatFlorida																				
rename	V758	lowhseponeothseatFlorida																				
rename	V759	lowhseptwoothseatFlorida																				
rename	V760	upphsepdemseatGeorgia																				
rename	V761	upphsepwrseatGeorgia																				
rename	V762	upphseponeothseatGeorgia																				
rename	V763	upphseptwoothseatGeorgia																				
rename	V764	lowhsepdemseatGeorgia																				
rename	V765	lowhsepwrseatGeorgia																				
rename	V766	lowhseponeothseatGeorgia																				
rename	V767	lowhseptwoothseatGeorgia																				
rename	V768	upphsepdemseatLouisiana																				
rename	V769	upphsepwrseatLouisiana																				
rename	V770	upphseponeothseatLouisiana																				
rename	V771	upphseptwoothseatLouisiana																				
rename	V772	lowhsepdemseatLouisiana																				
rename	V773	lowhsepwrseatLouisiana																				
rename	V774	lowhseponeothseatLouisiana																				
rename	V775	lowhseptwoothseatLouisiana																				
rename	V776	upphsepdemseatMississippi																				
rename	V777	upphsepwrseatMississippi																				
rename	V778	upphseponeothseatMississippi																				
rename	V779	upphseptwoothseatMississippi																				
rename	V780	lowhsepdemseatMississippi																				
rename	V781	lowhsepwrseatMississippi																				
rename	V782	lowhseponeothseatMississippi																				
rename	V783	lowhseptwoothseatMississippi																				
rename	V784	upphsepdemseatNorthCarolina																				
rename	V785	upphsepwrseatNorthCarolina																				
rename	V786	upphseponeothseatNorthCarolina																				
rename	V787	upphseptwoothseatNorthCarolina																				
rename	V788	lowhsepdemseatNorthCarolina																				
rename	V789	lowhsepwrseatNorthCarolina																				
rename	V790	lowhseponeothseatNorthCarolina																				
rename	V791	lowhseptwoothseatNorthCarolina																				
rename	V792	upphsepdemseatSouthCarolina																				
rename	V793	upphsepwrseatSouthCarolina																				
rename	V794	upphseponeothseatSouthCarolina																				
rename	V795	upphseptwoothseatSouthCarolina																				
rename	V796	lowhsepdemseatSouthCarolina																				
rename	V797	lowhsepwrseatSouthCarolina																				
rename	V798	lowhseponeothseatSouthCarolina																				
rename	V799	lowhseptwoothseatSouthCarolina																				
rename	V800	upphsepdemseatTexas																				
rename	V801	upphsepwrseatTexas																				
rename	V802	upphseponeothseatTexas																				
rename	V803	upphseptwoothseatTexas																				
rename	V804	lowhsepdemseatTexas																				
rename	V805	lowhsepwrseatTexas																				
rename	V806	lowhseponeothseatTexas																				
rename	V807	lowhseptwoothseatTexas																				
rename	V808	upphsepdemseatKentucky																				
rename	V809	upphsepwrseatKentucky																				
rename	V810	upphseponeothseatKentucky																				
rename	V811	upphseptwoothseatKentucky																				
rename	V812	lowhsepdemseatKentucky																				
rename	V813	lowhsepwrseatKentucky																				
rename	V814	lowhseponeothseatKentucky																				
rename	V815	lowhseptwoothseatKentucky																				
rename	V816	upphsepdemseatMaryland																				
rename	V817	upphsepwrseatMaryland																				
rename	V818	upphseponeothseatMaryland																				
rename	V819	upphseptwoothseatMaryland																				
rename	V820	lowhsepdemseatMaryland																				
rename	V821	lowhsepwrseatMaryland																				
rename	V822	lowhseponeothseatMaryland																				
rename	V823	lowhseptwoothseatMaryland																				
rename	V824	upphsepdemseatOklahoma																				
rename	V825	upphsepwrseatOklahoma																				
rename	V826	upphseponeothseatOklahoma																				
rename	V827	upphseptwoothseatOklahoma																				
rename	V828	lowhsepdemseatOklahoma																				
rename	V829	lowhsepwrseatOklahoma																				
rename	V830	lowhseponeothseatOklahoma																				
rename	V831	lowhseptwoothseatOklahoma																				
rename	V832	upphsepdemseatTennessee																				
rename	V833	upphsepwrseatTennessee																				
rename	V834	upphseponeothseatTennessee																				
rename	V835	upphseptwoothseatTennessee																				
rename	V836	lowhsepdemseatTennessee																				
rename	V837	lowhsepwrseatTennessee																				
rename	V838	lowhseponeothseatTennessee																				
rename	V839	lowhseptwoothseatTennessee																				
rename	V840	upphsepdemseatWestVirginia																				
rename	V841	upphsepwrseatWestVirginia																				
rename	V842	upphseponeothseatWestVirginia																				
rename	V843	upphseptwoothseatWestVirginia																				
rename	V844	lowhsepdemseatWestVirginia																				
rename	V845	lowhsepwrseatWestVirginia																				
rename	V846	lowhseponeothseatWestVirginia																				
rename	V847	lowhseptwoothseatWestVirginia																				
rename	V848	upphsepdemseatArizona																				
rename	V849	upphsepwrseatArizona																				
rename	V850	upphseponeothseatArizona																				
rename	V851	upphseptwoothseatArizona																				
rename	V852	lowhsepdemseatArizona																				
rename	V853	lowhsepwrseatArizona																				
rename	V854	lowhseponeothseatArizona																				
rename	V855	lowhseptwoothseatArizona																				
rename	V856	upphsepdemseatColorado																				
rename	V857	upphsepwrseatColorado																				
rename	V858	upphseponeothseatColorado																				
rename	V859	upphseptwoothseatColorado																				
rename	V860	lowhsepdemseatColorado																				
rename	V861	lowhsepwrseatColorado																				
rename	V862	lowhseponeothseatColorado																				
rename	V863	lowhseptwoothseatColorado																				
rename	V864	upphsepdemseatIdaho																				
rename	V865	upphsepwrseatIdaho																				
rename	V866	upphseponeothseatIdaho																				
rename	V867	upphseptwoothseatIdaho																				
rename	V868	lowhsepdemseatIdaho																				
rename	V869	lowhsepwrseatIdaho																				
rename	V870	lowhseponeothseatIdaho																				
rename	V871	lowhseptwoothseatIdaho																				
rename	V872	upphsepdemseatMontana																				
rename	V873	upphsepwrseatMontana																				
rename	V874	upphseponeothseatMontana																				
rename	V875	upphseptwoothseatMontana																				
rename	V876	lowhsepdemseatMontana																				
rename	V877	lowhsepwrseatMontana																				
rename	V878	lowhseponeothseatMontana																				
rename	V879	lowhseptwoothseatMontana																				
rename	V880	upphsepdemseatNevada																				
rename	V881	upphsepwrseatNevada																				
rename	V882	upphseponeothseatNevada																				
rename	V883	upphseptwoothseatNevada																				
rename	V884	lowhsepdemseatNevada																				
rename	V885	lowhsepwrseatNevada																				
rename	V886	lowhseponeothseatNevada																				
rename	V887	lowhseptwoothseatNevada																				
rename	V888	upphsepdemseatNewMexico																				
rename	V889	upphsepwrseatNewMexico																				
rename	V890	upphseponeothseatNewMexico																				
rename	V891	upphseptwoothseatNewMexico																				
rename	V892	lowhsepdemseatNewMexico																				
rename	V893	lowhsepwrseatNewMexico																				
rename	V894	lowhseponeothseatNewMexico																				
rename	V895	lowhseptwoothseatNewMexico																				
rename	V896	upphsepdemseatUtah																				
rename	V897	upphsepwrseatUtah																				
rename	V898	upphseponeothseatUtah																				
rename	V899	upphseptwoothseatUtah																				
rename	V900	lowhsepdemseatUtah																				
rename	V901	lowhsepwrseatUtah																				
rename	V902	lowhseponeothseatUtah																				
rename	V903	lowhseptwoothseatUtah																				
rename	V904	upphsepdemseatWyoming																				
rename	V905	upphsepwrseatWyoming																				
rename	V906	upphseponeothseatWyoming																				
rename	V907	upphseptwoothseatWyoming																				
rename	V908	lowhsepdemseatWyoming																				
rename	V909	lowhsepwrseatWyoming																				
rename	V910	lowhseponeothseatWyoming																				
rename	V911	lowhseptwoothseatWyoming																				
rename	V912	upphsepdemseatCalifornia																				
rename	V913	upphsepwrseatCalifornia																				
rename	V914	upphseponeothseatCalifornia																				
rename	V915	upphseptwoothseatCalifornia																				
rename	V916	lowhsepdemseatCalifornia																				
rename	V917	lowhsepwrseatCalifornia																				
rename	V918	lowhseponeothseatCalifornia																				
rename	V919	lowhseptwoothseatCalifornia																				
rename	V920	upphsepdemseatOregon																				
rename	V921	upphsepwrseatOregon																				
rename	V922	upphseponeothseatOregon																				
rename	V923	upphseptwoothseatOregon																				
rename	V924	lowhsepdemseatOregon																				
rename	V925	lowhsepwrseatOregon																				
rename	V926	lowhseponeothseatOregon																				
rename	V927	lowhseptwoothseatOregon																				
rename	V928	upphsepdemseatWashington																				
rename	V929	upphsepwrseatWashington																				
rename	V930	upphseponeothseatWashington																				
rename	V931	upphseptwoothseatWashington																				
rename	V932	lowhsepdemseatWashington																				
rename	V933	lowhsepwrseatWashington																				
rename	V934	lowhseponeothseatWashington																				
rename	V935	lowhseptwoothseatWashington																				
rename	V936	upphsepdemseatAlaska																				
rename	V937	upphsepwrseatAlaska																				
rename	V938	upphseponeothseatAlaska																				
rename	V939	upphseptwoothseatAlaska																				
rename	V940	lowhsepdemseatAlaska																				
rename	V941	lowhsepwrseatAlaska																				
rename	V942	lowhseponeothseatAlaska																				
rename	V943	lowhseptwoothseatAlaska																				
rename	V944	upphsepdemseatHawaii																				
rename	V945	upphsepwrseatHawaii																				
rename	V946	upphseponeothseatHawaii																				
rename	V947	upphseptwoothseatHawaii																				
rename	V948	lowhsepdemseatHawaii																				
rename	V949	lowhsepwrseatHawaii																				
rename	V950	lowhseponeothseatHawaii																				
rename	V951	lowhseptwoothseatHawaii	


																																												
reshape	long partyofgov	upphsedemseats	upphsewrseats	upphseoneothseats	upphsetwoothseats	upphsetotalseats	lowhsedemseats	lowhsewrseats	lowhseoneothseats	lowhsetwoothseats	lowhsetotalseats	upphsepdemseat	upphsepwrseat	upphseponeothseat	upphseptwoothseat	lowhsepdemseat	lowhsepwrseat	lowhseponeothseat	lowhseptwoothseat,	i(year) j(state) string
sort state year	
recode partyofgov 9999=.
recode partyofgov (100 = 1 "democrat") (200 29 = 2 "whig/republican") (nonmissing=3 "other party"), pre(new) label(newpartyofgov)
move newpartyofgov partyofgov

///Change missing values to .
recode partyofgov upphsedemseats	upphsewrseats	upphseoneothseats	upphsetwoothseats	upphsetotalseats	lowhsedemseats	lowhsewrseats	lowhseoneothseats	lowhsetwoothseats	lowhsetotalseats	upphsepdemseat	upphsepwrseat	upphseponeothseat	upphseptwoothseat	lowhsepdemseat	lowhsepwrseat	lowhseponeothseat	lowhseptwoothseat (999 999.9 9999 9999.9=.)

///Following to fill in missing years.

forvalues i=1/7050 {
local iminusone = `i'-1
local iplusone = `i'+1
if partyofgov==. in `i'  {
if partyofgov!=. in `iminusone' {
if partyofgov!=. in `iplusone' {
/// Check whether or not the year above and below are nonmissing. If they are nonmissing, fill in the year in between.
if state[`iminusone']==state[`iplusone']{
foreach name in newpartyofgov partyofgov upphsedemseats	upphsewrseats	upphseoneothseats	upphsetwoothseats	upphsetotalseats	lowhsedemseats	lowhsewrseats	lowhseoneothseats	lowhsetwoothseats	lowhsetotalseats	upphsepdemseat	upphsepwrseat	upphseponeothseat	upphseptwoothseat	lowhsepdemseat	lowhsepwrseat	lowhseponeothseat	lowhseptwoothseat {
quietly replace `name'=`name'[`iminusone'] in `i'
}
}
}
}
}
}


forvalues i=1/7050 {
local im = `i'-1
///Since Mississippi, Maryland, and Louisiana are more than every other year, use special code for them:
if state=="Mississippi" or state=="Maryland" or state=="Louisiana"
if partyofgov==. in `i' {
if state[`i']==state[`im'] {
if partyofgov!=. in `im' {

if state[`im']==state[`i']{
foreach name in newpartyofgov partyofgov upphsedemseats	upphsewrseats	upphseoneothseats	upphsetwoothseats	upphsetotalseats	lowhsedemseats	lowhsewrseats	lowhseoneothseats	lowhsetwoothseats	lowhsetotalseats	upphsepdemseat	upphsepwrseat	upphseponeothseat	upphseptwoothseat	lowhsepdemseat	lowhsepwrseat	lowhseponeothseat	lowhseptwoothseat {
quietly replace `name'=`name'[`im'] in `i'

}
}
}
}
}
}

replace state="New Hampshire" if state=="NewHampshire"
replace state="New York" if state=="NewYork"
replace state="New Jersey" if state=="NewJersey"
replace state="North Carolina" if state=="NorthCarolina"
replace state="South Carolina" if state=="SouthCarolina"
replace state="North Dakota" if state=="NorthDakota"
replace state="South Dakota" if state=="SouthDakota"
replace state="District of Columbia" if state=="DistrictofColumbia"
replace state="New Mexico" if state=="NewMexico"
replace state="Rhode Island" if state=="RhodeIsland"
replace state="West Virginia" if state=="WestVirginia"


drop upphsedemseats upphsewrseats upphseoneothseats upphsetwoothseats lowhsedemseats lowhsewrseats
drop lowhseoneothseats lowhsetwoothseats upphseponeothseat upphseptwoothseat lowhseponeothseat
drop lowhseptwoothseat partyofgov


*standardize the names
rename lowhsepwrseat perrepubslow
rename lowhsepdemseat perdemslow
rename upphsepwrseat perrepubsupp
rename upphsepdemseat perdemsupp
replace perrepubslow=.01* perrepubslow
replace perrepubsupp=.01* perrepubsupp
replace perdemslow=.01* perdemslow
replace perdemsupp=.01* perdemsupp

rename lowhsetotalseats numlowhouse
rename upphsetotalseats numupphouse
gen govisdem=1 if newpartyofgov==1
replace govisdem=0 if govisdem==.
gen govisrep=1 if newpartyofgov==2
replace govisrep=0 if govisrep==.
gen govisoth=1 if newpartyofgov==3
replace govisoth=0 if govisoth==.
drop newpartyofgov

sort state


merge state using "$startdir/$outputdata/fipscodes.dta", sort uniqusing
drop if _merge==2
drop _merge
replace year=year+1000
destring fips, replace
recast int fips
sort fips year
save "$startdir/$outputdata/stategov.dta", replace
clear






***********Governors;
#delimit;
clear;

insheet using "$startdir/$inputdata/governors.csv";
rename v1 name;
egen govid=seq();
rename v2 state;
rename v3 years;
rename v4 party;

replace state=substr(state,3,.);
replace state=reverse(state);
replace state=substr(state,3,.);
replace state=reverse(state);
compress state;

replace party=substr(party,3,.);
replace party=reverse(party);
replace party=substr(party,3,.);
replace party=reverse(party);
compress party;

gen yearsorig=years;

gen length=length(years);
*four values: 11 (no end date), 15 (normal), 28 (two terms), 45 (three terms);

replace years=substr(years, 4, 4) if length==11;
replace years=substr(years, 4, 9) if length==15;
replace years=substr(years, 4, 22) if length==28;
replace years=substr(years, 4, 35) if length==41;

gen firstyear=years if length==11;
replace firstyear=substr(years, 1,4) if length>11;

gen endyear="" if length==11;
replace endyear=substr(years,6,4) if length>11;

gen firstyear2=substr(years, 14, 4) if length>11;
gen endyear2=substr(years,19,4) if length>11;

gen firstyear3=substr(years,27, 4) if length>28;
gen endyear3=substr(years,32, 4) if length>28;

destring firstyear endyear firstyear2 endyear2 firstyear3 endyear3, replace;

drop length;

list if endyear<firstyear;
*typo in the data: MN governor;
replace firstyear=1934 if firstyear==1937 & endyear==1936 & state=="Minnesota";



*prep for reshape;
rename firstyear firstyear1;
rename endyear endyear1;

reshape long endyear firstyear, i(govid) j(term);

*if endyear and firstyear are empty, it's because the gov didn't do three terms;
drop if endyear==. & firstyear==.;

*get rid of governors whose first year was before 1880;
drop if firstyear<1880;

replace party="D" if party=="Democrat" | party=="Democrat, Independent" | party=="Democrat; Progressive" | party=="Democrat, Prohibition"
| party=="Democratic-Populist" | party=="Democratic" | party=="Popular Democrat" | party=="Democratic-Farmer-Labor" | party=="Democrat, Republican";

replace party="R" if party=="Republican" | party=="Repubican" | party=="Republic" | party=="Republican (Nonpartisan League)" |
party=="Republican (Independent Voters Association)" | party=="Republican, Democrat" | party=="Republlican" | party=="Republican, Progressive"
| party=="Republican Organizing Committee";

replace party="D" if party=="Democrat (first term), Republican (second term)" & term==1;
replace party="R" if party=="Democrat (first term), Republican (second term)" & term==2;

replace party="D" if party=="Populist (first term); Democrat (second term)" & term==2;
*above guy only served one term acc. to the data;

replace party="R" if party=="Republican 1st term; Progressive 2nd and 3rd terms" & term==1;

replace party="O" if party!="R" & party!="D";

gen mygovisdem=0;
gen mygovisrep=0;
gen mygovisoth=0;
replace mygovisdem=1 if party=="D";
replace mygovisrep=1 if party=="R";
replace mygovisoth=1 if party=="O";



merge state using "$startdir/$outputdata/fipscodes.dta", sort uniqusing;
drop if _merge<3;
drop _merge;

*weird cases where two or more governors are associated with the same year and have different parties:
*1905 in CO is going to McDonald based on Wiki research;
drop if govid==205 & firstyear==1905 & state=="Colorado" & term==1;
drop if govid==202 & firstyear==1905 & state=="Colorado" & term==1;
*1959 in ME R guy was in for five days;
drop if govid==792 & firstyear==1959 & state=="Maine";
*1900 in KY D guy died after two days;
drop if govid==700 & state=="Kentucky" & firstyear==1900;
*1935 in ND D guy served for one month;
drop if govid==1564 & state=="North Dakota" & firstyear==1935;



*****on the assumption that elections take place in November,
*****if governor A is listed as (1906-1910) and governor B is listed as (1910-1914),
*****we give 1910 to governor A
*****unless governor B's started and ended in the same year e.g. (1910-1910) in which case he gets 1910;
sort state firstyear;
by state: gen lastguysendyear=endyear[_n-1];
replace firstyear=firstyear+1 if firstyear==lastguysendyear & firstyear!=endyear;


gen termlength=endyear-firstyear +1;
tab termlength;

gen year=firstyear;
collapse mygovisdem mygovisrep mygovisoth, by(fips censusregion year);

fillin fips year;
*looks good to me!
sort fips year;
by fips: replace censusregion=censusregion[_n-1] if _fillin==1 & censusregion==.;
by fips: replace mygovisdem=mygovisdem[_n-1] if _fillin==1 & mygovisdem==.;
by fips: replace mygovisoth=mygovisoth[_n-1] if _fillin==1 & mygovisoth==.;
by fips: replace mygovisrep=mygovisrep[_n-1] if _fillin==1 & mygovisrep==.;

drop _fillin;
destring fips, replace;
recast int fips;

sort fips year;
save "$startdir/$outputdata/governors.dta", replace;







#delimit cr

clear


******data since 1975


/**************************************************************************
 |
 |                    STATA SETUP FILE FOR ICPSR 21480
 |             STATE LEGISLATIVE ELECTION RETURNS, 1967-2003
 |
 |
 |  Please edit this file as instructed below.
 |  To execute, start Stata, change to the directory containing:
 |       - this do file
 |       - the ASCII data file
 |       - the dictionary file
 |
 |  Then execute the do file (e.g., do 21480-0001-statasetup.do)
 |
 **************************************************************************/

set mem 200m  /* Allocating 200 megabyte(s) of RAM for Stata SE to read the
                 data file into memory. */


set more off  /* This prevents the Stata output viewer from pausing the
                 process */

/****************************************************

Section 1: File Specifications
   This section assigns local macros to the necessary files.
   Please edit:
        "data-filename" ==> The name of data file downloaded from ICPSR
        "dictionary-filename" ==> The name of the dictionary file downloaded.
        "stata-datafile" ==> The name you wish to call your Stata data file.

   Note:  We assume that the raw data, dictionary, and setup (this do file) all
          reside in the same directory (or folder).  If that is not the case
          you will need to include paths as well as filenames in the macros.

********************************************************/

local raw_data "$startdir/$inputdata/ICPSR_post1975_data.txt"
local dict "$startdir/$inputdata/ICPSR_post1975_dict.dct"
local outfile "$startdir/$outputdata/ICPSR_post1975.dta"

/********************************************************

Section 2: Infile Command

This section reads the raw data into Stata format.  If Section 1 was defined
properly, there should be no reason to modify this section.  These macros
should inflate automatically.

**********************************************************/

infile using "`dict'", using ("`raw_data'") clear


/*********************************************************

Section 3: Value Label Definitions
This section defines labels for the individual values of each variable.
We suggest that users do not modify this section.

**********************************************************/


label data "State Legislative Election Returns, 1967-2003, Dataset 0001"

#delimit ;
label define V1        8907 "icpsr study no." ;
label define V2        1 "spring,1988 release" 2 "winter,1989 release"
                       3 "fall,1989 release" 4 "sept,1990 release"
                       5 "Jan,1992 release" ;
label define V3        1 "icpsr part no." ;
label define V5        1 "ct -1788-" 2 "maine -1820-" 3 "ma -1788-"
                       4 "nh -1788-" 5 "ri -1790-" 6 "vermont -1791-"
                       11 "delaware -1787-" 12 "nj -1787-"
                       13 "new york -1788-" 14 "pa -1787-"
                       21 "illinois -1818-" 22 "indiana -1816-"
                       23 "michigan -1837-" 24 "ohio -1803-"
                       25 "wisconsin -1848-" 31 "iowa -1846-"
                       32 "kansas -1861-" 33 "minnesota -1858-"
                       34 "missouri -1821-" 35 "nebraska -1867-"
                       36 "nd -1889-" 37 "sd -1889-" 40 "virginia -1788-"
                       41 "alabama -1819-" 42 "arkansas -1836-"
                       43 "florida -1845-" 44 "georgia -1788-"
                       45 "louisiana -1812-" 46 "ms -1817-" 47 "nc -1789-"
                       48 "sc -1788-" 49 "texas -1845-" 51 "kentucky -1792-"
                       52 "maryland -1788-" 53 "oklahoma -1907-"
                       54 "tennessee -1796-" 55 "washington, d.c."
                       56 "wv -1863-" 61 "arizona -1912-"
                       62 "colorado -1876-" 63 "idaho -1890-"
                       64 "montana -1889-" 65 "nevada -1864-" 66 "nm -1912-"
                       67 "utah -1896-" 68 "wyoming -1890-" 71 "ca -1850-"
                       72 "oregon -1859-" 73 "wa -1889-" 81 "alaska -1959-"
                       82 "hawaii -1959-" ;
label define V7        8 "senate and nebr" 9 "house of rep" ;
label define V8        999 "missing data -di" ;
label define V10       1 "single-member dt" 2 "mm dt positions"
                       3 "mm free-for-all" 4 "mm alternating"
                       5 "floterial sm" 6 "floterial mm-p"
                       7 "floterial mm-ff" ;
label define V12       1 "january" 2 "february" 3 "march" 4 "april" 5 "may"
                       6 "june" 7 "july" 8 "august" 9 "september"
                       10 "october" 11 "november" 12 "december" 99 "unknown" ;
label define V13       -9 "missing data -re" ;
label define V15       0 "Not Incumbent" 1 "Incumbent" ;
label define V31       0 "otherwise" 1 "Candidate won the election" ;
label define V33       0 "no" 1 "yes" ;


#delimit cr

/********************************************************************

 Section 4: Save Outfile

  This section saves out a Stata system format file.  There is no reason to
  modify it if the macros in Section 1 were specified correctly.

*********************************************************************/
display("`outfile'")
save "`outfile'", replace



#delimit;
set more off;

clear;
use "$startdir/$outputdata/ICPSR_post1975.dta";


****additional coding for above data;
rename V6 year;
rename V35 fips;
tostring fips, replace;
forvalues k=1/9{;
replace fips="0`k'" if fips=="`k'";
};

merge fips using "$startdir/$outputdata/fipscodes.dta", sort uniqusing;
drop _merge;

destring fips, replace;
recast int fips;

drop V1 V2;  *V1 and V2: whether it comes from earlier study ICPSR 8907;
drop V3;  *V3 designates that it has the Part 1 variables from 8907;
drop V4;  *V4 assigns a sequence of numbers to the groups of candidates in an election;
drop V5;  *ICPSR state code;
rename V7 whichhouse;
rename V8 district;
rename V9 post;
rename V10 districttype;
rename V11 electiontype;
rename V12 month;
rename V13 votesreceived;
rename V14 ICPSRparty;
rename V15 incumbent;
rename V16 name; *V16 is name, keep to doublecheck stuff;
rename V17 numcands;
rename V18 numDemcands;
rename V19 numRepubcands;
rename V20 numOthercands;
rename V21 numwinners;
rename V22 votescast;
rename V23 votesanyDem;
rename V24 votesanyRepub;
rename V25 votesanyOther;
rename V26 winningpercent;
rename V27 winningpercent2;
drop V28; *margin of victory;
rename V29 percentreceived;
rename V30 diffpercents;
rename V31 candwon;
rename V32 nameadj;
rename V33 namewasadj;
rename TERMLENG termlength;



*remove the primary elections, except LA (fips 22) which has a crazy system;
*special elections replace an unknown individual, so i'm going to ignore them;

keep if electiontype=="G" | electiontype=="R"  & fips==22 | electiontype=="Z" & fips==22;


keep if candwon==1;

*missing months: fill in according to
*1) the same month as that fips whichhouse district in another year;
sort fips whichhouse district month year;
by fips whichhouse district: replace month=month[_n-1] if month==.;

*catch most of them this way, but 1301 left;
*2) the same month as other districts in the same fips whichhouse year;
sort fips whichhouse year month district;
by fips whichhouse year: replace month=month[_n-1] if month==.;

*327 left, all in AK, VT, and WY;
*3) the same month as that fips whichhouse in another year;
sort fips whichhouse month year;
by fips whichhouse: replace month=month[_n-1] if month==.;

gen electiontime=ym(year, month);

sort fips whichhouse electiontime termlength electiontype;


*count up the winning candidates of each party and other parties for each fips-whichhouse-electiontime-termlength-electiontype;
by fips whichhouse electiontime termlength electiontype: egen numdemswon=total(candwon) if ICPSRparty==100;
by fips whichhouse electiontime termlength electiontype: egen numrepubswon=total(candwon) if ICPSRparty==200;
by fips whichhouse electiontime termlength electiontype: egen numotherswon=total(candwon) if ICPSRparty!=100 & ICPSRparty!=200;
by fips whichhouse electiontime termlength electiontype: egen numwinning=total(candwon);

save "$startdir/$outputdata/ICPSR_post1975a.dta",replace;




use "$startdir/$outputdata/ICPSR_post1975a.dta", clear;

collapse (mean) numdemswon
         (mean) numrepubswon
         (mean) numotherswon
         (mean) numwinning
         (mean) year
         (mean) month
,by(fips censusregion postal whichhouse electiontime termlength electiontype);
*this collapse leaves us with a dataset where each observation is a fips-whichhouse-electiontime-termlength-electiontype;
*1815 observations;
*the idea is that each one of these is an election, but of course it's not that simple;

*set aside the cases that are weird for now: that is,
*      different electiontypes at the same time (all these turn out to be Louisiana);
*      different term lengths for the same house at the same time,
*      Louisiana;
duplicates tag fips whichhouse electiontime termlength, generate(funnyelectiontype);
duplicates tag fips whichhouse electiontime electiontype, generate(funnyterm);
gen funnystate=1 if fips==22;
replace funnystate=0 if fips!=22;



replace numdemswon=0 if numdemswon==.;
replace numrepubswon=0 if numrepubswon==.;
replace numotherswon=0 if numotherswon==.;


save "$startdir/$outputdata/ICPSR_post1975b.dta",replace;







use "$startdir/$outputdata/ICPSR_post1975b.dta", clear;

***************DEAL WITH LOUISIANA!;
sort whichhouse electiontime;
*Z:open party primary;
*R:open party runoff primary;
*still not totally sure what's happening here;
*105 member house elected for four year terms in 68,72,75,79,83,87;
*39 member senate elected for four year terms in 68,72,75,79,83,87;
drop if numwinning!=39 & whichhouse==8 & year<1990 & fips==22;
drop if numwinning!=105 & whichhouse==9 &  year<1990 & fips==22;
*then in 91,95,99 we have two elections (a G, and then an R) right after one another that add up to a bit more than 39.;
*collapse (sum) numwinning (sum) numdemswon (sum) numrepubswon (sum) numotherswon, by(whichhouse year) if fips==22;
sort whichhouse year electiontime;
by whichhouse year: replace numwinning=numwinning[_n-1] if year>1990 & fips==22;
by whichhouse year: replace numrepubswon=numrepubswon[_n-1] if year>1990 & fips==22;
by whichhouse year: replace numotherswon=numotherswon[_n-1] if year>1990 & fips==22;
by whichhouse year: replace numdemswon=numdemswon[_n-1] if year>1990 & fips==22;
gen numhouse=numwinning if fips==22;
gen perdemswon=numdemswon/numhouse if fips==22;
gen perrepubswon=numrepubswon/numhouse if fips==22;



*****dealing with the funnyterm people;
*****these are cases where a candidate runs for a two year or four year term for the same fips-whichhouse-year;
*****termlengths are either two or four;
*****if two, do nothing;
*****if four, add their numbers to the two year term people directly above them;
*****then also add their numbers to the election two years later;

sort fips whichhouse year termlength;
by fips whichhouse year: replace numwinning=numwinning+numwinning[_n+1] if funnyterm==1 & termlength==2;
by fips whichhouse: replace numwinning=numwinning+numwinning[_n-1] if funnyterm[_n-1]==1 & termlength[_n-1]==4 & year==year[_n-1]+2;
by fips whichhouse year: replace numdemswon=numdemswon+numdemswon[_n+1] if funnyterm==1 & termlength==2;
by fips whichhouse: replace numdemswon=numdemswon+numdemswon[_n-1] if funnyterm[_n-1]==1 & termlength[_n-1]==4 & year==year[_n-1]+2;
by fips whichhouse year: replace numrepubswon=numrepubswon+numrepubswon[_n+1] if funnyterm==1 & termlength==2;
by fips whichhouse: replace numrepubswon=numrepubswon+numrepubswon[_n-1] if funnyterm[_n-1]==1 & termlength[_n-1]==4 & year==year[_n-1]+2;
by fips whichhouse year: replace numotherswon=numotherswon+numotherswon[_n+1] if funnyterm==1 & termlength==2;
by fips whichhouse: replace numotherswon=numotherswon+numotherswon[_n-1] if funnyterm[_n-1]==1 & termlength[_n-1]==4 & year==year[_n-1]+2;
drop if funnyterm==1 & termlength==4;






sort fips whichhouse electiontime;
by fips whichhouse: gen monthssincelastelection=electiontime-electiontime[_n-1];
gen yearssincelastelection=monthssincelastelection/12;



replace numhouse=numwinning;
sort fips whichhouse electiontime;

*****trying to account for overlappingterms;

by fips whichhouse: replace numhouse=numwinning+numwinning[_n-1] if yearssincelastelection==termlength[_n-1]/2 & numwinning[_n-1]!=.;



fillin fips whichhouse year;
*we now have 33 years * 2 houses * 50 states=3234;
*each year has 100 obs;
*each state has 66 obs, which is the 33 years times the two houses;

*****Here I fix a few egregious issues by hand;
*****NE fips 31 is a special case: unicameral;
replace numhouse=0 if whichhouse==9 & fips==31;
*****VA fips 51 has mode of one, but by inspection it's pretty clear it should be 40, and wiki confirms;
replace numhouse=40 if fips==51 & whichhouse==8;
****AK data is incomplete, so it fails to account for the staggering of Senate elections;
replace numhouse=20 if fips==2 & whichhouse==8;
****AR data is incomplete;
replace numhouse=35 if fips==5 & whichhouse==8;
****VT also has problems, but nothing to be done, there's just no data;
****my measures disagree with steven's for DE
****I have no data on 68 & 69, more dems won in 70, so I give it to them for, but Steven disagrees.
****Maybe not enough won to tip the balance
****We get no new information about 73 and 74;


sort fips whichhouse year;
by fips: replace censusregion=censusregion[_n-1] if censusregion==.;
by fips whichhouse: replace numhouse=numhouse[_n-1] if _fillin==1 & numhouse==.;
by fips whichhouse: replace numhouse=numhouse[_n+1] if _fillin==1 & numhouse==.;
*deal with the beginning of the data;
by fips whichhouse: replace numhouse=numhouse[_n+2] if year==1968;
by fips whichhouse: replace numhouse=numhouse[_n+1] if year==1969;


sort fips whichhouse electiontype year;

by fips whichhouse electiontype: egen modenumhouse=mode(numhouse), maxmode;
by fips whichhouse: egen sdnumhouse=sd(numhouse);
*using this to catch anomalies, we can see that a lot of the problems crop up for special elections,which I have fixed with the above;
tab modenumhouse;
tab sdnumhouse;





*****let's generate some percentages;
sort fips whichhouse year;
gen overlappingterms=1 if termlength[_n-2]==2*yearssincelastelection & termlength[_n-2]!=.;
replace overlappingterms=0 if overlappingterms==.;
replace overlappingterms=0 if numwinning==numhouse;
*Arkansas has something weird going on where it looks like overlapping terms but can't be.;
replace overlappingterms=0 if fips==5 & (year==1976|year==1986|year==1996);



replace perdemswon=numdemswon/numhouse if overlappingterms==0;
replace perrepubswon=numrepubswon/numhouse if overlappingterms==0;


sort fips whichhouse year;
by fips whichhouse: gen numdemsin=numdemswon+numdemswon[_n-2] if overlappingterms==1;
by fips whichhouse: gen numrepubsin=numrepubswon+numrepubswon[_n-2] if overlappingterms==1;
replace perdemswon=numdemsin/numhouse if overlappingterms==1 & numdemsin!=.;
replace perrepubswon=numrepubsin/numhouse if overlappingterms==1 & numrepubsin!=.;



sort fips whichhouse year;
by fips whichhouse: replace perdemswon=perdemswon[_n-1] if perdemswon==.;
by fips whichhouse: replace perrepubswon=perrepubswon[_n-1] if perrepubswon==.;
by fips whichhouse: replace numhouse=numhouse[_n-1] if numhouse==.;



sort fips year;
by fips year: gen numupphouse=numhouse if whichhouse==8;
by fips year: gen numlowhouse=numhouse if whichhouse==9;
by fips year: gen perdemsupp=perdemswon if whichhouse==8;
by fips year: gen perdemslow=perdemswon if whichhouse==9;
by fips year: gen perrepubsupp=perrepubswon if whichhouse==8;
by fips year: gen perrepubslow=perrepubswon if whichhouse==9;


sort fips year whichhouse;
by fips year: replace numupphouse=numupphouse[_n-1] if numupphouse==.;
by fips year: replace numlowhouse=numlowhouse[_n+1] if numlowhouse==.;
by fips year: replace perdemsupp=perdemsupp[_n-1] if perdemsupp==.;
by fips year: replace perdemslow=perdemslow[_n+1] if perdemslow==.;
by fips year: replace perrepubsupp=perrepubsupp[_n-1] if perrepubsupp==.;
by fips year: replace perrepubslow=perrepubslow[_n+1] if perrepubslow==.;

sort fips censusregion year;

collapse numupphouse numlowhouse perdemsupp perdemslow perrepubsupp perrepubslow
, by(fips censusregion year);


save "$startdir/$outputdata/stategov_post1975.dta", replace;






#delimit;

**********MERGING!!!;
!erase "$startdir/$outputdata/ICPSR_post1975a";
!erase "$startdir/$outputdata/ICPSR_post1975b";

use "$startdir/$outputdata/stategov_post1975.dta",clear;
rename numupphouse mynumupphouse ;
rename numlowhouse mynumlowhouse;
rename perdemsupp myperdemsupp ;
rename perdemslow myperdemslow;
rename perrepubsupp myperrepubsupp ;
rename perrepubslow myperrepubslow;

sort fips censusregion year;
merge fips censusregion year using "$startdir/$outputdata/stategov.dta", sort unique;
rename _merge S_C_merge;

merge fips censusregion year using "$startdir/$outputdata/governors.dta", sort unique;
*drop years before 1880 and 2001;

drop if _merge<3;
drop _merge;
gen testupp=perdemsupp+perrepubsupp;
gen testlow=perdemslow+perrepubslow;
gen mytestupp=myperdemsupp+myperrepubsupp;
gen mytestlow=myperdemslow+myperrepubslow;
sum *test*, detail;


****with the below, we use Steven's values over mine for years that exist for both of us;
replace perdemslow=myperdemslow if perdemslow==. & myperdemslow!=.;
replace perrepubslow=myperrepubslow if perrepubslow==. & myperrepubslow!=.;
replace perdemsupp=myperdemsupp if perdemsupp==. & myperdemsupp!=.;
replace perrepubsupp=myperrepubsupp if perrepubsupp==. & myperrepubsupp!=.;
replace numupphouse=mynumupphouse if numupphouse==. & mynumupphouse!=.;
replace numlowhouse=mynumlowhouse if numlowhouse==. & mynumlowhouse!=.;
replace govisdem=mygovisdem if govisdem==. & mygovisdem!=.;
replace govisrep=mygovisrep if govisrep==. & mygovisrep!=.;
replace govisoth=mygovisoth if govisoth==. & mygovisoth!=.;

drop my* *test*;

gen govdemcontrol=govisdem;
gen uppdemcontrol=1 if perdemsupp>perrepubsupp & perdemsupp!=. & perrepubsupp!=.;
replace uppdemcontrol=0 if perdemsupp<=perrepubsupp & perrepubsupp!=. & perdemsupp!=.;
gen lowdemcontrol=1 if perdemslow>perrepubslow & perdemslow!=. & perrepubslow!=.;
replace lowdemcontrol=0 if perdemslow<=perrepubslow & perrepubslow!=. & perdemslow!=.;

drop govisdem govisrep govisoth numupphouse numlowhouse bpl S_C_merge postal state;

sort fips year;
by fips year: gen statepolicy=(govdemcontrol+uppdemcontrol+lowdemcontrol)/3;

drop if year<1890;
fillin fips year;
gsort +fips -year;
by fips: replace censusregion=censusregion[_n-1] if censusregion==.;
drop _fillin;

sort fips year;
save "$startdir/$outputdata/state_polconditions.dta", replace;

!erase "$startdir/$outputdata/stategov";
!erase "$startdir/$outputdata/governors";
!erase "$startdir/$outputdata/stategov_post1975";


use "$startdir/$outputdata/stategov_post1975.dta",clear;

**********TESTING AGAINST STEVEN'S DATA********;
rename numupphouse mynumupphouse ;
rename numlowhouse mynumlowhouse;
rename perdemsupp myperdemsupp ;
rename perdemslow myperdemslow;
rename perrepubsupp myperrepubsupp ;
rename perrepubslow myperrepubslow;

sort fips censusregion year;
merge fips censusregion year using "$startdir/$outputdata/stategov.dta", sort unique;
drop if _merge<3;
drop _merge;

gen govdemcontrol=govisdem;
gen uppdemcontrol=1 if perdemsupp>perrepubsupp & perdemsupp!=. & perrepubsupp!=.;
replace uppdemcontrol=0 if perdemsupp<=perrepubsupp & perrepubsupp!=. & perdemsupp!=.;
gen lowdemcontrol=1 if perdemslow>perrepubslow & perdemslow!=. & perrepubslow!=.;
replace lowdemcontrol=0 if perdemslow<=perrepubslow & perrepubslow!=. & perdemslow!=.;

gen myuppdemcontrol=1 if myperdemsupp>myperrepubsupp & myperdemsupp!=. & myperrepubsupp!=.;
replace myuppdemcontrol=0 if myperdemsupp<=myperrepubsupp & myperrepubsupp!=. & myperdemsupp!=.;
gen mylowdemcontrol=1 if myperdemslow>myperrepubslow & myperdemslow!=. & myperrepubslow!=.;
replace mylowdemcontrol=0 if myperdemslow<=myperrepubslow & myperrepubslow!=. & myperdemslow!=.;


gen uppagree=0;
gen lowagree=0;
sort fips year;
by fips year: replace uppagree=1 if uppdemcontrol==myuppdemcontrol;
by fips year: replace uppagree=. if uppdemcontrol==. | myuppdemcontrol==.;
by fips year: replace lowagree=1 if lowdemcontrol==mylowdemcontrol;
by fips year: replace lowagree=. if lowdemcontrol==. | mylowdemcontrol==.;
by fips: egen alluppagree=total(uppagree);
by fips: egen alllowagree=total(lowagree);

tab1 uppagree lowagree;
*then we have ~95% agreement;

tab1 uppagree lowagree, missing;
*mostly driven by missingness;

list fips postal year *demcontrol if alluppagree<5 | alllowagree<5, separator(7);
list postal year  myperdemsupp perdemsupp myperdemslow perdemslow, separator(7);

********************

