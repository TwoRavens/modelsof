#delimit ;
clear ;
set memory 300m ;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\";

/*******2000*******/
#delimit;
use "native and immigrants\census00_5pc_all.dta", clear;

drop empstatd;



generate ciscobinsmo=301 if bpld	 == 	43000	 |
bpld	 == 	42111	 |
bpld	 == 	42110	 |
bpld	 == 	43100	 |
bpld	 == 	45341	 |
bpld	 == 	46540	 |
bpld	 == 	45000	 |
bpld	 == 	45020	 |
bpld	 == 	45010	 |
bpld	 == 	45070	 |
bpld	 == 	45030	 |
bpld	 == 	45510	 |
bpld	 == 	45080	 |
bpld	 == 	45040	 |
bpld	 == 	45050	 |
bpld	 == 	45060	 |
bpld	 == 	46541	 |
bpld	 == 	43610	 |
bpld	 == 	45311	 |
bpld	 == 	46300	 |
bpld	 == 	45312	 |
bpld	 == 	42000	 |
bpld	 == 	45301	 |
bpld	 == 	46521	 |
bpld	 == 	45210	 |
bpld	 == 	45211	 |
bpld	 == 	45740	 |
bpld	 == 	45342	 |
bpld	 == 	45313	 |
bpld	 == 	45314	 |
bpld	 == 	45100	 |
bpld	 == 	46510	 |
bpld	 == 	43630	 |
bpld	 == 	45770	 |
bpld	 == 	45800	 |
bpld	 == 	41010	 |
bpld	 == 	45710	 |
bpld	 == 	45213	 |
bpld	 == 	45200	 |
bpld	 == 	45750	 |
bpld	 == 	40000	 |
bpld	 == 	43310	 |
bpld	 == 	45343	 |
bpld	 == 	45340	 |
bpld	 == 	45521	 |
bpld	 == 	45900	 |
bpld	 == 	46000	 |
bpld	 == 	49900	 |
bpld	 == 	40010	 |
bpld	 == 	40100	 |
bpld	 == 	42100	 |
bpld	 == 	45331	 |
bpld	 == 	45511	 |
bpld	 == 	46542	 |
bpld	 == 	45520	 |
bpld	 == 	45300	 |
bpld	 == 	43200	 |
bpld	 == 	43300	 |
bpld	 == 	41011	 |
bpld	 == 	45315	 |
bpld	 == 	45316	 |
bpld	 == 	45318	 |
bpld	 == 	45317	 |
bpld	 == 	45361	 |
bpld	 == 	45319	 |
bpld	 == 	45400	 |
bpld	 == 	40200	 |
bpld	 == 	41400	 |
bpld	 == 	41020	 |
bpld	 == 	43400	 |
bpld	 == 	40412	 |
bpld	 == 	41012	 |
bpld	 == 	46543	 |
bpld	 == 	46544	 |
bpld	 == 	45790	 |
bpld	 == 	40300	 |
bpld	 == 	46100	 |
bpld	 == 	42200	 |
bpld	 == 	45320	 |
bpld	 == 	46200	 |
bpld	 == 	42112	 |
bpld	 == 	45321	 |
bpld	 == 	42300	 |
bpld	 == 	43330	 |
bpld	 == 	43620	 |
bpld	 == 	43500	 |
bpld	 == 	45344	 |
bpld	 == 	46520	 |
bpld	 == 	42400	 |
bpld	 == 	45720	 |
bpld	 == 	42500	 |
bpld	 == 	45362	 |
bpld	 == 	45333	 |
bpld	 == 	41900	 |
bpld	 == 	40400	 |
bpld	 == 	45322	 |
bpld	 == 	45522	 |
bpld	 == 	43600	 |
bpld	 == 	45523	 |
bpld	 == 	45360	 |
bpld	 == 	45524	 |
bpld	 == 	45323	 |
bpld	 == 	45600	 |
bpld	 == 	45530	 |
bpld	 == 	45332	 |
bpld	 == 	45345	 |
bpld	 == 	45346	 |
bpld	 == 	45347	 |
bpld	 == 	45348	 |
bpld	 == 	45349	 |
bpld	 == 	43700	 |
bpld	 == 	45350	 |
bpld	 == 	45324	 |
bpld	 == 	45325	 |
bpld	 == 	45326	 |
bpld	 == 	45351	 |
bpld	 == 	45730	 |
bpld	 == 	46548	 |
bpld	 == 	45525	 |
bpld	 == 	45212	 |
bpld	 == 	45780	 |
bpld	 == 	45760	 |
bpld	 == 	44000	 |
bpld	 == 	43800	 |
bpld	 == 	43640	 |
bpld	 == 	45352	 |
bpld	 == 	40410	 |
bpld	 == 	40411	 |
bpld	 == 	40500	 |
bpld	 == 	42600	 |
bpld	 == 	46545	 |
bpld	 == 	45353	 |
bpld	 == 	45610	 |
bpld	 == 	43320	 |
bpld	 == 	46546	 |
bpld	 == 	41300	 |
bpld	 == 	46547	 |
bpld	 == 	43900	 |
bpld	 == 	45327	 |
bpld	 == 	45328	 |
bpld	 == 	45310	 |
bpld	 == 	45526	 |
bpld	 == 	42900	 |
bpld	 == 	45329	 |
bpld	 == 	45330	 |
bpld	 == 	45700	 ;


replace ciscobinsmo=302 if bpld	 == 	52000	 |
bpld	 == 	54900	 |
bpld	 == 	59900	 |
bpld	 == 	52110	 |
bpld	 == 	52120	 |
bpld	 == 	51000	 |
bpld	 == 	52130	 |
bpld	 == 	51100	 |
bpld	 == 	50900	 |
bpld	 == 	51210	 |
bpld	 == 	51220	 |
bpld	 == 	50010	 |
bpld	 == 	51910	 |
bpld	 == 	51200	 |
bpld	 == 	50100	 |
bpld	 == 	51300	 |
bpld	 == 	50020	 |
bpld	 == 	51400	 |
bpld	 == 	52300	 |
bpld	 == 	50030	 |
bpld	 == 	52400	 |
bpld	 == 	52140	 |
bpld	 == 	51600	 |
bpld	 == 	55000	 |
bpld	 == 	51900	 |
bpld	 == 	52150	 |
bpld	 == 	50040	 |
bpld	 == 	51700	 ;


replace ciscobinsmo=304 if bpld == 	10000	 |
bpld	 == 	10010	 |
bpld	 == 	10500	 |
bpld	 == 	11000	 |
bpld	 == 	11500	 |
bpld	 == 	11510	 |
bpld	 == 	11520	 |
bpld	 == 	11530	 |
bpld	 == 	12000	 |
bpld	 == 	12010	 |
bpld	 == 	12020	 |
bpld	 == 	12030	 |
bpld	 == 	12040	 |
bpld	 == 	12041	 |
bpld	 == 	12050	 |
bpld	 == 	12051	 |
bpld	 == 	12052	 |
bpld	 == 	12053	 |
bpld	 == 	12054	 |
bpld	 == 	12055	 |
bpld	 == 	12060	 |
bpld	 == 	12090	 |
bpld	 == 	12091	 |
bpld	 == 	12092	 ;



replace ciscobinsmo=305 if bpld	 == 	29999	|
bpld	 == 	26046	|
bpld	 == 	26041	|
bpld	 == 	26042	|
bpld	 == 	26090	|
bpld	 == 	30005	|
bpld	 == 	26071	|
bpld	 == 	16000	|
bpld	 == 	26043	|
bpld	 == 	26044	|
bpld	 == 	21010	|
bpld	 == 	16010	|
bpld	 == 	30010	|
bpld	 == 	26073	|
bpld	 == 	26052	|
bpld	 == 	30015	|
bpld	 == 	26045	|
bpld	 == 	26040	|
bpld	 == 	26069	|
bpld	 == 	21071	|
bpld	 == 	16060	|
bpld	 == 	16020	|
bpld	 == 	26091	|
bpld	 == 	26053	|
bpld	 == 	21000	|
bpld	 == 	21090	|
bpld	 == 	30020	|
bpld	 == 	26047	|
bpld	 == 	21020	|
bpld	 == 	26074	|
bpld	 == 	26054	|
bpld	 == 	26079	|
bpld	 == 	26075	|
bpld	 == 	30030	|
bpld	 == 	16030	|
bpld	 == 	26089	|
bpld	 == 	30035	|
bpld	 == 	26080	|
bpld	 == 	16040	|
bpld	 == 	26055	|
bpld	 == 	26081	|
bpld	 == 	30040	|
bpld	 == 	21050	|
bpld	 == 	26048	|
bpld	 == 	26092	|
bpld	 == 	26093	|
bpld	 == 	26082	|
bpld	 == 	26056	|
bpld	 == 	26072	|
bpld	 == 	19900	|
bpld	 == 	26070	|
bpld	 == 	21070	|
bpld	 == 	30045	|
bpld	 == 	26049	|
bpld	 == 	26076	|
bpld	 == 	30000	|
bpld	 == 	30090	|
bpld	 == 	30091	|
bpld	 == 	26083	|
bpld	 == 	26077	|
bpld	 == 	16050	|
bpld	 == 	26057	|
bpld	 == 	26058	|
bpld	 == 	15500	|
bpld	 == 	26059	|
bpld	 == 	30055	|
bpld	 == 	26050	|
bpld	 == 	26060	|
bpld	 == 	26061	|
bpld	 == 	30060	|
bpld	 == 	30065	|
bpld	 == 	26051	|
bpld	 == 	26000	|
bpld	 == 	26094	|
bpld	 == 	26095	;

replace ciscobinsmo=306 if bpld	 == 	60000	|
bpld	 == 	60099	|
bpld	 == 	60071	|
bpld	 == 	60058	|
bpld	 == 	60020	|
bpld	 == 	60091	|
bpld	 == 	60040	|
bpld	 == 	60021	|
bpld	 == 	60041	|
bpld	 == 	60072	|
bpld	 == 	60070	|
bpld	 == 	60080	|
bpld	 == 	60073	|
bpld	 == 	60074	|
bpld	 == 	60042	|
bpld	 == 	60075	|
bpld	 == 	60043	|
bpld	 == 	60064	|
bpld	 == 	60081	|
bpld	 == 	60076	|
bpld	 == 	60065	|
bpld	 == 	60059	|
bpld	 == 	60082	|
bpld	 == 	60039	|
bpld	 == 	60077	|
bpld	 == 	60022	|
bpld	 == 	60023	|
bpld	 == 	60060	|
bpld	 == 	60024	|
bpld	 == 	60025	|
bpld	 == 	60026	|
bpld	 == 	60061	|
bpld	 == 	60045	|
bpld	 == 	60092	|
bpld	 == 	60027	|
bpld	 == 	60046	|
bpld	 == 	60047	|
bpld	 == 	60028	|
bpld	 == 	60029	|
bpld	 == 	60048	|
bpld	 == 	60062	|
bpld	 == 	60049	|
bpld	 == 	60093	|
bpld	 == 	60030	|
bpld	 == 	60031	|
bpld	 == 	60019	|
bpld	 == 	60050	|
bpld	 == 	60051	|
bpld	 == 	60078	|
bpld	 == 	60032	|
bpld	 == 	60052	|
bpld	 == 	60033	|
bpld	 == 	60053	|
bpld	 == 	60094	|
bpld	 == 	60096	|
bpld	 == 	60090	|
bpld	 == 	60015	|
bpld	 == 	60095	|
bpld	 == 	60054	|
bpld	 == 	60034	|
bpld	 == 	60063	|
bpld	 == 	60055	|
bpld	 == 	60038	|
bpld	 == 	60017	|
bpld	 == 	60079	|
bpld	 == 	60056	|
bpld	 == 	60057	;


replace ciscobinsmo=307 if bpld	 == 	52200	|
bpld	 == 	53000	|
bpld	 == 	53100	|
bpld	 == 	53200	|
bpld	 == 	53210	|
bpld	 == 	53300	|
bpld	 == 	53400	|
bpld	 == 	53410	|
bpld	 == 	53420	|
bpld	 == 	53430	|
bpld	 == 	53440	|
bpld	 == 	53500	|
bpld	 == 	53600	|
bpld	 == 	53700	|
bpld	 == 	53800	|
bpld	 == 	53900	|
bpld	 == 	54000	|
bpld	 == 	54100	|
bpld	 == 	54200	|
bpld	 == 	54210	|
bpld	 == 	54220	|
bpld	 == 	54300	|
bpld	 == 	54400	|
bpld	 == 	54500	|
bpld	 == 	54600	|
bpld	 == 	54700	|
bpld	 == 	54800	|
bpld	 == 	60010	|
bpld	 == 	60011	|
bpld	 == 	60012	|
bpld	 == 	60013	|
bpld	 == 	60014	|
bpld	 == 	60016	;

replace ciscobinsmo=308 if bpld	 == 	70000	|
bpld	 == 	70010	|
bpld	 == 	70011	|
bpld	 == 	70012	|
bpld	 == 	70020	|
bpld	 == 	71000	|
bpld	 == 	71010	|
bpld	 == 	71011	|
bpld	 == 	71012	|
bpld	 == 	71013	|
bpld	 == 	71014	|
bpld	 == 	71019	|
bpld	 == 	71020	|
bpld	 == 	71021	|
bpld	 == 	71022	|
bpld	 == 	71023	|
bpld	 == 	71024	|
bpld	 == 	71025	|
bpld	 == 	71029	|
bpld	 == 	71030	|
bpld	 == 	71031	|
bpld	 == 	71032	|
bpld	 == 	71033	|
bpld	 == 	71034	|
bpld	 == 	71035	|
bpld	 == 	71036	|
bpld	 == 	71037	|
bpld	 == 	71038	|
bpld	 == 	71039	|
bpld	 == 	71040	|
bpld	 == 	71041	|
bpld	 == 	71042	|
bpld	 == 	71043	|
bpld	 == 	71044	|
bpld	 == 	71045	|
bpld	 == 	71046	|
bpld	 == 	71047	|
bpld	 == 	71048	|
bpld	 == 	71049	|
bpld	 == 	71050	|
bpld	 == 	71090	;

replace ciscobinsmo=308 if bpld	 == 	80000	|
bpld	 == 	80010	|
bpld	 == 	80020	|
bpld	 == 	80030	|
bpld	 == 	80040	|
bpld	 == 	80050	|
bpld	 == 	90000	|
bpld	 == 	90010	|
bpld	 == 	90011	|
bpld	 == 	90020	|
bpld	 == 	90021	|
bpld	 == 	90022	;



replace 	ciscobinsmo	 = 	38	 if 	bpld	 == 	15000	|	bpld	 == 	15010	|	bpld	 == 	15011	|	bpld	 == 	15013	| bpld == 	15015	| bpld == 	15017| bpld == 15019| bpld == 15020	| bpld == 15021	| bpld == 15030	| bpld == 15031	| bpld == 15032	| bpld == 15040	| bpld == 15050	| bpld == 15051	| bpld == 15052	| bpld == 15060	| bpld == 15070	| bpld == 15080;
replace 	ciscobinsmo	 = 	44	 if 	bpld	 == 	50000	;																																			
replace 	ciscobinsmo	 = 	47	 if 	bpld	 == 	30025	;																																			
replace 	ciscobinsmo	 = 	55	 if 	bpld	 == 	25000	;																																			
replace 	ciscobinsmo	 = 	62	 if 	bpld	 == 	26010	;																																			
replace 	ciscobinsmo	 = 	65	 if 	bpld	 == 	21030	;																																			
replace 	ciscobinsmo	 = 	69	 if 	bpld	 == 	60044	;																																			
replace 	ciscobinsmo	 = 	88	 if 	bpld	 == 	21040	;																																			
replace 	ciscobinsmo	 = 	92	 if 	bpld	 == 	26020	;																																			
replace 	ciscobinsmo	 = 	98	 if 	bpld	 == 	52100	;																																			
replace 	ciscobinsmo	 = 	105	 if 	bpld	 == 	26030	;																																			
replace 	ciscobinsmo	 = 	111	 if 	bpld	 == 	50200	|	bpld	 == 	50210	|	bpld	 == 	50220;																												
replace 	ciscobinsmo	 = 	135	 if 	bpld	 == 	20000	;																																			
replace 	ciscobinsmo	 = 	152	 if 	bpld	 == 	21060	;																																			
replace 	ciscobinsmo	 = 	163	 if 	bpld	 == 	30050	;																																			
replace 	ciscobinsmo	 = 	164	 if 	bpld	 == 	51500	;																																			
replace 	ciscobinsmo	 = 	166	 if 	bpld	 == 	45500	;																																			
replace 	ciscobinsmo	 = 	172	 if 	bpld	 == 	46500	|	bpld	 == 	46590	;																															
replace 	ciscobinsmo	 = 	215	 if 	bpld	 == 	46530	;																																			
replace 	ciscobinsmo	 = 	217	 if 	bpld	 == 	41200	|	bpld	 == 	41000	|	bpld	 == 	41410	|	bpld	 == 	41100	;																							
replace 	ciscobinsmo	 = 	224	 if 	bpld	 == 	51800	;			
																															
																																											




label define country
38	"CANADA"
44	"CHINA, PEOPLES REPUBLIC"
47	"COLOMBIA"
55	"CUBA"
62	"DOMINICAN REPUBLIC"
65	"EL SALVADOR"
69	"ETHIOPIA"
88	"GUATEMALA"
92	"HAITI"
98	"INDIA"
105	"JAMAICA"
111	"KOREA"
135	"MEXICO"
152	"NIGERIA"
163	"PERU"
164	"PHILIPPINES"
166	"POLAND"
172	"RUSSIA"
215	"UKRAINE"
217	"UNITED KINGDOM"
218	"UNITED STATES"
219	"UNKNOWN"
224	"VIETNAM"
301	"EUROPE & CENTRAL ASIA"
302	"EAST ASIA, SOUTH ASIA & THE PACIFIC"
304	"OTHER NORTH AMERICA"
305	"LATIN AMERICA & THE CARIBBEAN"
306	"AFRICAN SUB-SAHARAN"
307	"MIDDLE EAST & NORTH AFRICA"
308	"OCEANIA"
310	"ARCTIC REGION";

label values ciscobinsmo country; 


/** create state variables **/

generate 	state 	 = 	1	 if 	statefip	 == 	4	;
replace 	state 	 = 	2	 if 	statefip	 == 	9	;
replace 	state 	 = 	3	 if 	statefip	 == 	13	;
replace 	state 	 = 	4	 if 	statefip	 == 	30	;
replace 	state 	 = 	5	 if 	statefip	 == 	32	;
replace 	state 	 = 	6	 if 	statefip	 == 	42	;
replace 	state 	 = 	7	 if 	statefip	 == 	6 | statefip==19 | statefip==21 | statefip==29	;
replace 	state 	 = 	8	 if 	statefip	 == 	38 |statefip==44|statefip==46	;
replace 	state 	 = 	9	 if 	statefip	 == 	7|statefip==8|statefip==10|statefip==20|statefip==33|statefip==39	;
replace 	state 	 = 	10	 if 	statefip	 == 	1|statefip==17|statefip==24|statefip==41	;
replace 	state 	 = 	11	 if 	statefip	 == 	14|statefip==22|statefip==35|statefip==47	;
replace 	state 	 = 	12	 if 	statefip	 == 	15|statefip==16|statefip==23|statefip==25|statefip==27|statefip==34|statefip==40	;
replace 	state 	 = 	13	 if 	statefip	 == 	3|statefip==18|statefip==36	;
replace 	state 	 = 	14	 if 	statefip	 == 	2|statefip==5|statefip==12|statefip==26|statefip==28|statefip==31|statefip==43|statefip==48	;
replace 	state 	 = 	15	 if 	statefip	 == 	11|statefip==37|statefip==45	;


label define state 
1	"California"
2	"Florida"
3	"Illinois"
4	"New Jersey"
5	"New York"
6	"Texas"
7	"New England"
8	"Middle Atlantic"
9	"South Atlantic"
10	"East South Central"
11	"East North Central"
12	"West North Central"
13	"West South Central"
14	"Mountain"
15	"Pacific" ;

label values state state;
drop if state >20;

replace ciscobinsmo=1 if bpl>=1 & bpl<=99;
generate pop_unwght=1;
generate pop_wght=perwt;
collapse (sum) pop_unwght pop_wght, by (state occ1990 ciscobinsmo);

/*state population (total immigrant)*/
by  state, sort: egen statpop_imm1=sum( pop_unwght) if ciscobinsmo!=1;
by  state, sort: egen statpop_imm=median(statpop_imm1);
by  state, sort: egen statpop_imm_wt1=sum( pop_wght) if ciscobinsmo!=1;
by  state, sort: egen statpop_imm_wt=median(statpop_imm_wt1);
by  state, sort: egen statpop_total_wt=sum( pop_wght);
by  state, sort: egen statpop_total=sum( pop_unwght);
by  state, sort: generate p_imm=statpop_imm/statpop_total;
by  state, sort: generate p_imm_wt=statpop_imm_wt/statpop_total_wt;
drop statpop_imm1 statpop_imm_wt1;

/*state populaiton by country and percent of each country in state immigrant population*/
by  state  ciscobinsmo, sort: egen statpop_country=sum( pop_unwght);
by  state  ciscobinsmo, sort: egen statpop_country_wt=sum( pop_wght);
by  state  ciscobinsmo, sort: generate p_statpop_imm_wt= statpop_country_wt/ statpop_imm_wt if ciscobinsmo!=1;
by  state  ciscobinsmo, sort: generate p_statpop_imm= statpop_country/ statpop_imm if ciscobinsmo!=1;
by  state  ciscobinsmo, sort: generate p_statpop_total_wt= statpop_country_wt/ statpop_total_wt if ciscobinsmo!=1;
by  state  ciscobinsmo, sort: generate p_statpop_total= statpop_country/ statpop_total if ciscobinsmo!=1;

/*state population by occupation*/
by  state occ1990, sort: egen statoccpop_imm1=sum( pop_unwght) if ciscobinsmo!=1;
by  state occ1990, sort: egen statoccpop_imm=median(statoccpop_imm1);
by  state occ1990, sort: egen statoccpop_imm_wt1=sum( pop_wght) if ciscobinsmo!=1;
by  state occ1990, sort: egen statoccpop_imm_wt=median(statoccpop_imm_wt1);
by  state occ1990, sort: egen statoccpop_total_wt=sum( pop_wght);
by  state occ1990, sort: egen statoccpop_total=sum( pop_unwght);
drop statoccpop_imm1  statoccpop_imm_wt1;

/*percent of each ethnicity in the occupation by state*/
by  state occ1990 ciscobinsmo, sort: generate p_country_imm_occstat_wt= pop_wght/statoccpop_imm_wt ;
by  state occ1990 ciscobinsmo, sort: generate p_country_total_occstat_wt= pop_wght/statoccpop_total_wt ;
by  state occ1990 ciscobinsmo, sort: generate p_country_imm_occstat= pop_unwght/statoccpop_imm ;
by  state occ1990 ciscobinsmo, sort: generate p_country_total_occstat= pop_unwght/statoccpop_total ;

by  state occ1990 ciscobinsmo, sort: generate nat1_p_country_total_occstat=p_country_total_occstat if ciscobinsmo==1;
by  state occ1990, sort: egen p_native_total_occstat=mean(nat1_p_country_total_occstat);
by  state occ1990, sort: generate p_imm_total_occstat=1-p_native_total_occstat;
by  state occ1990 ciscobinsmo, sort: generate nat1_p_country_total_occstat_wt=p_country_total_occstat_wt if ciscobinsmo==1;
by  state occ1990, sort: egen p_native_total_occstat_wt=mean(nat1_p_country_total_occstat_wt);
by  state occ1990, sort: generate p_imm_total_occstat_wt=1-p_native_total_occstat_wt;
drop nat1_p_country_total_occstat nat1_p_country_total_occstat_wt;

by  state occ1990 ciscobinsmo, sort: generate p_occ_nat_stat_wt1=pop_wght/statpop_country_wt if ciscobinsmo==1;
by  state occ1990, sort: egen p_occ_nat_stat_wt=median(p_occ_nat_stat_wt1);
by  state occ1990 ciscobinsmo, sort: generate p_occ_nat_stat1=pop_unwght/statpop_country if ciscobinsmo==1;
by  state occ1990, sort: egen p_occ_nat_stat=median(p_occ_nat_stat1);
drop p_occ_nat_stat_wt1 p_occ_nat_stat1;

/* immigrant breakdown */

by  state occ1990 ciscobinsmo, sort: generate p_occ_old_countrystat_wt=pop_wght/statpop_country_wt;
by  state occ1990 ciscobinsmo, sort: generate p_occ_old_countrystat=pop_unwght/statpop_country;

by  state occ1990, sort: generate p_immold_occstat_wt=statoccpop_imm_wt/statoccpop_total_wt;
by  state occ1990, sort: generate p_immold_occstat=statoccpop_imm/statoccpop_total;

by  state occ1990, sort: generate p_occ_old_imm_stat_wt=(statoccpop_imm_wt-pop_wght)/(statpop_imm_wt-statpop_country_wt);
by  state occ1990, sort: generate p_occ_old_imm_stat=(statoccpop_imm-pop_unwght)/(statpop_imm-statpop_country);


/*percent of occupation that is native */
by  state occ1990, sort: egen statoccpop_nat1=sum( pop_unwght) if ciscobinsmo==1;
by  state occ1990, sort: egen statoccpop_nat=median(statoccpop_nat1);
by  state occ1990, sort: egen statoccpop_nat_wt1=sum( pop_wght) if ciscobinsmo==1;
by  state occ1990, sort: egen statoccpop_nat_wt=median(statoccpop_nat_wt1);
drop  statoccpop_nat1 statoccpop_nat_wt1;
by  state, sort: egen statpop_nat1=sum( pop_unwght) if ciscobinsmo==1;
by  state, sort: egen statpop_nat=median(statpop_nat1);
by  state, sort: egen statpop_nat_wt1=sum( pop_wght) if ciscobinsmo==1;
by  state, sort: egen statpop_nat_wt=median(statpop_nat_wt1);
drop  statpop_nat1  statpop_nat_wt1;
generate p_native_occ=statoccpop_nat/statoccpop_total;
generate p_native_occ_wt=statoccpop_nat_wt/statoccpop_total_wt;

/*percent of occupation in metroarea, excluding the new immigrants*/
generate p_occ_stat=(statoccpop_total)/(statpop_total);
generate p_occ_stat_wt=(statoccpop_total_wt)/(statpop_total_wt);


generate year=2000;

sort ciscobinsmo occ1990 state;


save "reg4 NIS\census00_5pc_occstate.dta", replace;

/*******1990*******/
#delimit;
use "native and immigrants\census90_5pc_all.dta", clear;

drop empstatd;


generate ciscobinsmo=301 if bpld	 == 	43000	 |
bpld	 == 	42111	 |
bpld	 == 	42110	 |
bpld	 == 	43100	 |
bpld	 == 	45341	 |
bpld	 == 	46540	 |
bpld	 == 	45000	 |
bpld	 == 	45020	 |
bpld	 == 	45010	 |
bpld	 == 	45070	 |
bpld	 == 	45030	 |
bpld	 == 	45510	 |
bpld	 == 	45080	 |
bpld	 == 	45040	 |
bpld	 == 	45050	 |
bpld	 == 	45060	 |
bpld	 == 	46541	 |
bpld	 == 	43610	 |
bpld	 == 	45311	 |
bpld	 == 	46300	 |
bpld	 == 	45312	 |
bpld	 == 	42000	 |
bpld	 == 	45301	 |
bpld	 == 	46521	 |
bpld	 == 	45210	 |
bpld	 == 	45211	 |
bpld	 == 	45740	 |
bpld	 == 	45342	 |
bpld	 == 	45313	 |
bpld	 == 	45314	 |
bpld	 == 	45100	 |
bpld	 == 	46510	 |
bpld	 == 	43630	 |
bpld	 == 	45770	 |
bpld	 == 	45800	 |
bpld	 == 	41010	 |
bpld	 == 	45710	 |
bpld	 == 	45213	 |
bpld	 == 	45200	 |
bpld	 == 	45750	 |
bpld	 == 	40000	 |
bpld	 == 	43310	 |
bpld	 == 	45343	 |
bpld	 == 	45340	 |
bpld	 == 	45521	 |
bpld	 == 	45900	 |
bpld	 == 	46000	 |
bpld	 == 	49900	 |
bpld	 == 	40010	 |
bpld	 == 	40100	 |
bpld	 == 	42100	 |
bpld	 == 	45331	 |
bpld	 == 	45511	 |
bpld	 == 	46542	 |
bpld	 == 	45520	 |
bpld	 == 	45300	 |
bpld	 == 	43200	 |
bpld	 == 	43300	 |
bpld	 == 	41011	 |
bpld	 == 	45315	 |
bpld	 == 	45316	 |
bpld	 == 	45318	 |
bpld	 == 	45317	 |
bpld	 == 	45361	 |
bpld	 == 	45319	 |
bpld	 == 	45400	 |
bpld	 == 	40200	 |
bpld	 == 	41400	 |
bpld	 == 	41020	 |
bpld	 == 	43400	 |
bpld	 == 	40412	 |
bpld	 == 	41012	 |
bpld	 == 	46543	 |
bpld	 == 	46544	 |
bpld	 == 	45790	 |
bpld	 == 	40300	 |
bpld	 == 	46100	 |
bpld	 == 	42200	 |
bpld	 == 	45320	 |
bpld	 == 	46200	 |
bpld	 == 	42112	 |
bpld	 == 	45321	 |
bpld	 == 	42300	 |
bpld	 == 	43330	 |
bpld	 == 	43620	 |
bpld	 == 	43500	 |
bpld	 == 	45344	 |
bpld	 == 	46520	 |
bpld	 == 	42400	 |
bpld	 == 	45720	 |
bpld	 == 	42500	 |
bpld	 == 	45362	 |
bpld	 == 	45333	 |
bpld	 == 	41900	 |
bpld	 == 	40400	 |
bpld	 == 	45322	 |
bpld	 == 	45522	 |
bpld	 == 	43600	 |
bpld	 == 	45523	 |
bpld	 == 	45360	 |
bpld	 == 	45524	 |
bpld	 == 	45323	 |
bpld	 == 	45600	 |
bpld	 == 	45530	 |
bpld	 == 	45332	 |
bpld	 == 	45345	 |
bpld	 == 	45346	 |
bpld	 == 	45347	 |
bpld	 == 	45348	 |
bpld	 == 	45349	 |
bpld	 == 	43700	 |
bpld	 == 	45350	 |
bpld	 == 	45324	 |
bpld	 == 	45325	 |
bpld	 == 	45326	 |
bpld	 == 	45351	 |
bpld	 == 	45730	 |
bpld	 == 	46548	 |
bpld	 == 	45525	 |
bpld	 == 	45212	 |
bpld	 == 	45780	 |
bpld	 == 	45760	 |
bpld	 == 	44000	 |
bpld	 == 	43800	 |
bpld	 == 	43640	 |
bpld	 == 	45352	 |
bpld	 == 	40410	 |
bpld	 == 	40411	 |
bpld	 == 	40500	 |
bpld	 == 	42600	 |
bpld	 == 	46545	 |
bpld	 == 	45353	 |
bpld	 == 	45610	 |
bpld	 == 	43320	 |
bpld	 == 	46546	 |
bpld	 == 	41300	 |
bpld	 == 	46547	 |
bpld	 == 	43900	 |
bpld	 == 	45327	 |
bpld	 == 	45328	 |
bpld	 == 	45310	 |
bpld	 == 	45526	 |
bpld	 == 	42900	 |
bpld	 == 	45329	 |
bpld	 == 	45330	 |
bpld	 == 	45700	 ;


replace ciscobinsmo=302 if bpld	 == 	52000	 |
bpld	 == 	54900	 |
bpld	 == 	59900	 |
bpld	 == 	52110	 |
bpld	 == 	52120	 |
bpld	 == 	51000	 |
bpld	 == 	52130	 |
bpld	 == 	51100	 |
bpld	 == 	50900	 |
bpld	 == 	51210	 |
bpld	 == 	51220	 |
bpld	 == 	50010	 |
bpld	 == 	51910	 |
bpld	 == 	51200	 |
bpld	 == 	50100	 |
bpld	 == 	51300	 |
bpld	 == 	50020	 |
bpld	 == 	51400	 |
bpld	 == 	52300	 |
bpld	 == 	50030	 |
bpld	 == 	52400	 |
bpld	 == 	52140	 |
bpld	 == 	51600	 |
bpld	 == 	55000	 |
bpld	 == 	51900	 |
bpld	 == 	52150	 |
bpld	 == 	50040	 |
bpld	 == 	51700	 ;


replace ciscobinsmo=304 if bpld == 	10000	 |
bpld	 == 	10010	 |
bpld	 == 	10500	 |
bpld	 == 	11000	 |
bpld	 == 	11500	 |
bpld	 == 	11510	 |
bpld	 == 	11520	 |
bpld	 == 	11530	 |
bpld	 == 	12000	 |
bpld	 == 	12010	 |
bpld	 == 	12020	 |
bpld	 == 	12030	 |
bpld	 == 	12040	 |
bpld	 == 	12041	 |
bpld	 == 	12050	 |
bpld	 == 	12051	 |
bpld	 == 	12052	 |
bpld	 == 	12053	 |
bpld	 == 	12054	 |
bpld	 == 	12055	 |
bpld	 == 	12060	 |
bpld	 == 	12090	 |
bpld	 == 	12091	 |
bpld	 == 	12092	 ;



replace ciscobinsmo=305 if bpld	 == 	29999	|
bpld	 == 	26046	|
bpld	 == 	26041	|
bpld	 == 	26042	|
bpld	 == 	26090	|
bpld	 == 	30005	|
bpld	 == 	26071	|
bpld	 == 	16000	|
bpld	 == 	26043	|
bpld	 == 	26044	|
bpld	 == 	21010	|
bpld	 == 	16010	|
bpld	 == 	30010	|
bpld	 == 	26073	|
bpld	 == 	26052	|
bpld	 == 	30015	|
bpld	 == 	26045	|
bpld	 == 	26040	|
bpld	 == 	26069	|
bpld	 == 	21071	|
bpld	 == 	16060	|
bpld	 == 	16020	|
bpld	 == 	26091	|
bpld	 == 	26053	|
bpld	 == 	21000	|
bpld	 == 	21090	|
bpld	 == 	30020	|
bpld	 == 	26047	|
bpld	 == 	21020	|
bpld	 == 	26074	|
bpld	 == 	26054	|
bpld	 == 	26079	|
bpld	 == 	26075	|
bpld	 == 	30030	|
bpld	 == 	16030	|
bpld	 == 	26089	|
bpld	 == 	30035	|
bpld	 == 	26080	|
bpld	 == 	16040	|
bpld	 == 	26055	|
bpld	 == 	26081	|
bpld	 == 	30040	|
bpld	 == 	21050	|
bpld	 == 	26048	|
bpld	 == 	26092	|
bpld	 == 	26093	|
bpld	 == 	26082	|
bpld	 == 	26056	|
bpld	 == 	26072	|
bpld	 == 	19900	|
bpld	 == 	26070	|
bpld	 == 	21070	|
bpld	 == 	30045	|
bpld	 == 	26049	|
bpld	 == 	26076	|
bpld	 == 	30000	|
bpld	 == 	30090	|
bpld	 == 	30091	|
bpld	 == 	26083	|
bpld	 == 	26077	|
bpld	 == 	16050	|
bpld	 == 	26057	|
bpld	 == 	26058	|
bpld	 == 	15500	|
bpld	 == 	26059	|
bpld	 == 	30055	|
bpld	 == 	26050	|
bpld	 == 	26060	|
bpld	 == 	26061	|
bpld	 == 	30060	|
bpld	 == 	30065	|
bpld	 == 	26051	|
bpld	 == 	26000	|
bpld	 == 	26094	|
bpld	 == 	26095	;

replace ciscobinsmo=306 if bpld	 == 	60000	|
bpld	 == 	60099	|
bpld	 == 	60071	|
bpld	 == 	60058	|
bpld	 == 	60020	|
bpld	 == 	60091	|
bpld	 == 	60040	|
bpld	 == 	60021	|
bpld	 == 	60041	|
bpld	 == 	60072	|
bpld	 == 	60070	|
bpld	 == 	60080	|
bpld	 == 	60073	|
bpld	 == 	60074	|
bpld	 == 	60042	|
bpld	 == 	60075	|
bpld	 == 	60043	|
bpld	 == 	60064	|
bpld	 == 	60081	|
bpld	 == 	60076	|
bpld	 == 	60065	|
bpld	 == 	60059	|
bpld	 == 	60082	|
bpld	 == 	60039	|
bpld	 == 	60077	|
bpld	 == 	60022	|
bpld	 == 	60023	|
bpld	 == 	60060	|
bpld	 == 	60024	|
bpld	 == 	60025	|
bpld	 == 	60026	|
bpld	 == 	60061	|
bpld	 == 	60045	|
bpld	 == 	60092	|
bpld	 == 	60027	|
bpld	 == 	60046	|
bpld	 == 	60047	|
bpld	 == 	60028	|
bpld	 == 	60029	|
bpld	 == 	60048	|
bpld	 == 	60062	|
bpld	 == 	60049	|
bpld	 == 	60093	|
bpld	 == 	60030	|
bpld	 == 	60031	|
bpld	 == 	60019	|
bpld	 == 	60050	|
bpld	 == 	60051	|
bpld	 == 	60078	|
bpld	 == 	60032	|
bpld	 == 	60052	|
bpld	 == 	60033	|
bpld	 == 	60053	|
bpld	 == 	60094	|
bpld	 == 	60096	|
bpld	 == 	60090	|
bpld	 == 	60015	|
bpld	 == 	60095	|
bpld	 == 	60054	|
bpld	 == 	60034	|
bpld	 == 	60063	|
bpld	 == 	60055	|
bpld	 == 	60038	|
bpld	 == 	60017	|
bpld	 == 	60079	|
bpld	 == 	60056	|
bpld	 == 	60057	;


replace ciscobinsmo=307 if bpld	 == 	52200	|
bpld	 == 	53000	|
bpld	 == 	53100	|
bpld	 == 	53200	|
bpld	 == 	53210	|
bpld	 == 	53300	|
bpld	 == 	53400	|
bpld	 == 	53410	|
bpld	 == 	53420	|
bpld	 == 	53430	|
bpld	 == 	53440	|
bpld	 == 	53500	|
bpld	 == 	53600	|
bpld	 == 	53700	|
bpld	 == 	53800	|
bpld	 == 	53900	|
bpld	 == 	54000	|
bpld	 == 	54100	|
bpld	 == 	54200	|
bpld	 == 	54210	|
bpld	 == 	54220	|
bpld	 == 	54300	|
bpld	 == 	54400	|
bpld	 == 	54500	|
bpld	 == 	54600	|
bpld	 == 	54700	|
bpld	 == 	54800	|
bpld	 == 	60010	|
bpld	 == 	60011	|
bpld	 == 	60012	|
bpld	 == 	60013	|
bpld	 == 	60014	|
bpld	 == 	60016	;

replace ciscobinsmo=308 if bpld	 == 	70000	|
bpld	 == 	70010	|
bpld	 == 	70011	|
bpld	 == 	70012	|
bpld	 == 	70020	|
bpld	 == 	71000	|
bpld	 == 	71010	|
bpld	 == 	71011	|
bpld	 == 	71012	|
bpld	 == 	71013	|
bpld	 == 	71014	|
bpld	 == 	71019	|
bpld	 == 	71020	|
bpld	 == 	71021	|
bpld	 == 	71022	|
bpld	 == 	71023	|
bpld	 == 	71024	|
bpld	 == 	71025	|
bpld	 == 	71029	|
bpld	 == 	71030	|
bpld	 == 	71031	|
bpld	 == 	71032	|
bpld	 == 	71033	|
bpld	 == 	71034	|
bpld	 == 	71035	|
bpld	 == 	71036	|
bpld	 == 	71037	|
bpld	 == 	71038	|
bpld	 == 	71039	|
bpld	 == 	71040	|
bpld	 == 	71041	|
bpld	 == 	71042	|
bpld	 == 	71043	|
bpld	 == 	71044	|
bpld	 == 	71045	|
bpld	 == 	71046	|
bpld	 == 	71047	|
bpld	 == 	71048	|
bpld	 == 	71049	|
bpld	 == 	71050	|
bpld	 == 	71090	;

replace ciscobinsmo=308 if bpld	 == 	80000	|
bpld	 == 	80010	|
bpld	 == 	80020	|
bpld	 == 	80030	|
bpld	 == 	80040	|
bpld	 == 	80050	|
bpld	 == 	90000	|
bpld	 == 	90010	|
bpld	 == 	90011	|
bpld	 == 	90020	|
bpld	 == 	90021	|
bpld	 == 	90022	;



replace 	ciscobinsmo	 = 	38	 if 	bpld	 == 	15000	|	bpld	 == 	15010	|	bpld	 == 	15011	|	bpld	 == 	15013	| bpld == 	15015	| bpld == 	15017| bpld == 15019| bpld == 15020	| bpld == 15021	| bpld == 15030	| bpld == 15031	| bpld == 15032	| bpld == 15040	| bpld == 15050	| bpld == 15051	| bpld == 15052	| bpld == 15060	| bpld == 15070	| bpld == 15080;
replace 	ciscobinsmo	 = 	44	 if 	bpld	 == 	50000	;																																			
replace 	ciscobinsmo	 = 	47	 if 	bpld	 == 	30025	;																																			
replace 	ciscobinsmo	 = 	55	 if 	bpld	 == 	25000	;																																			
replace 	ciscobinsmo	 = 	62	 if 	bpld	 == 	26010	;																																			
replace 	ciscobinsmo	 = 	65	 if 	bpld	 == 	21030	;																																			
replace 	ciscobinsmo	 = 	69	 if 	bpld	 == 	60044	;																																			
replace 	ciscobinsmo	 = 	88	 if 	bpld	 == 	21040	;																																			
replace 	ciscobinsmo	 = 	92	 if 	bpld	 == 	26020	;																																			
replace 	ciscobinsmo	 = 	98	 if 	bpld	 == 	52100	;																																			
replace 	ciscobinsmo	 = 	105	 if 	bpld	 == 	26030	;																																			
replace 	ciscobinsmo	 = 	111	 if 	bpld	 == 	50200	|	bpld	 == 	50210	|	bpld	 == 	50220;																												
replace 	ciscobinsmo	 = 	135	 if 	bpld	 == 	20000	;																																			
replace 	ciscobinsmo	 = 	152	 if 	bpld	 == 	21060	;																																			
replace 	ciscobinsmo	 = 	163	 if 	bpld	 == 	30050	;																																			
replace 	ciscobinsmo	 = 	164	 if 	bpld	 == 	51500	;																																			
replace 	ciscobinsmo	 = 	166	 if 	bpld	 == 	45500	;																																			
replace 	ciscobinsmo	 = 	172	 if 	bpld	 == 	46500	|	bpld	 == 	46590	;																															
replace 	ciscobinsmo	 = 	215	 if 	bpld	 == 	46530	;																																			
replace 	ciscobinsmo	 = 	217	 if 	bpld	 == 	41200	|	bpld	 == 	41000	|	bpld	 == 	41410	|	bpld	 == 	41100	;																							
replace 	ciscobinsmo	 = 	224	 if 	bpld	 == 	51800	;																																			
																																												




label define country
38	"CANADA"
44	"CHINA, PEOPLES REPUBLIC"
47	"COLOMBIA"
55	"CUBA"
62	"DOMINICAN REPUBLIC"
65	"EL SALVADOR"
69	"ETHIOPIA"
88	"GUATEMALA"
92	"HAITI"
98	"INDIA"
105	"JAMAICA"
111	"KOREA"
135	"MEXICO"
152	"NIGERIA"
163	"PERU"
164	"PHILIPPINES"
166	"POLAND"
172	"RUSSIA"
215	"UKRAINE"
217	"UNITED KINGDOM"
218	"UNITED STATES"
219	"UNKNOWN"
224	"VIETNAM"
301	"EUROPE & CENTRAL ASIA"
302	"EAST ASIA, SOUTH ASIA & THE PACIFIC"
304	"OTHER NORTH AMERICA"
305	"LATIN AMERICA & THE CARIBBEAN"
306	"AFRICAN SUB-SAHARAN"
307	"MIDDLE EAST & NORTH AFRICA"
308	"OCEANIA"
310	"ARCTIC REGION";

label values ciscobinsmo country; 


/** create state variables **/

generate 	state 	 = 	1	 if 	statefip	 == 	4	;
replace 	state 	 = 	2	 if 	statefip	 == 	9	;
replace 	state 	 = 	3	 if 	statefip	 == 	13	;
replace 	state 	 = 	4	 if 	statefip	 == 	30	;
replace 	state 	 = 	5	 if 	statefip	 == 	32	;
replace 	state 	 = 	6	 if 	statefip	 == 	42	;
replace 	state 	 = 	7	 if 	statefip	 == 	6 | statefip==19 | statefip==21 | statefip==29	;
replace 	state 	 = 	8	 if 	statefip	 == 	38 |statefip==44|statefip==46	;
replace 	state 	 = 	9	 if 	statefip	 == 	7|statefip==8|statefip==10|statefip==20|statefip==33|statefip==39	;
replace 	state 	 = 	10	 if 	statefip	 == 	1|statefip==17|statefip==24|statefip==41	;
replace 	state 	 = 	11	 if 	statefip	 == 	14|statefip==22|statefip==35|statefip==47	;
replace 	state 	 = 	12	 if 	statefip	 == 	15|statefip==16|statefip==23|statefip==25|statefip==27|statefip==34|statefip==40	;
replace 	state 	 = 	13	 if 	statefip	 == 	3|statefip==18|statefip==36	;
replace 	state 	 = 	14	 if 	statefip	 == 	2|statefip==5|statefip==12|statefip==26|statefip==28|statefip==31|statefip==43|statefip==48	;
replace 	state 	 = 	15	 if 	statefip	 == 	11|statefip==37|statefip==45	;


label define state 
1	"California"
2	"Florida"
3	"Illinois"
4	"New Jersey"
5	"New York"
6	"Texas"
7	"New England"
8	"Middle Atlantic"
9	"South Atlantic"
10	"East South Central"
11	"East North Central"
12	"West North Central"
13	"West South Central"
14	"Mountain"
15	"Pacific" ;

label values state state;
drop if state >20;

replace ciscobinsmo=1 if bpl>=1 & bpl<=99;
generate pop_unwght=1;
generate pop_wght=perwt;
collapse (sum) pop_unwght pop_wght, by (state occ1990 ciscobinsmo);

/*state population (total immigrant)*/
by  state, sort: egen statpop_imm1=sum( pop_unwght) if ciscobinsmo!=1;
by  state, sort: egen statpop_imm=median(statpop_imm1);
by  state, sort: egen statpop_imm_wt1=sum( pop_wght) if ciscobinsmo!=1;
by  state, sort: egen statpop_imm_wt=median(statpop_imm_wt1);
by  state, sort: egen statpop_total_wt=sum( pop_wght);
by  state, sort: egen statpop_total=sum( pop_unwght);
by  state, sort: generate p_imm=statpop_imm/statpop_total;
by  state, sort: generate p_imm_wt=statpop_imm_wt/statpop_total_wt;
drop statpop_imm1 statpop_imm_wt1;

/*state populaiton by country and percent of each country in state immigrant population*/
by  state  ciscobinsmo, sort: egen statpop_country=sum( pop_unwght);
by  state  ciscobinsmo, sort: egen statpop_country_wt=sum( pop_wght);
by  state  ciscobinsmo, sort: generate p_statpop_imm_wt= statpop_country_wt/ statpop_imm_wt if ciscobinsmo!=1;
by  state  ciscobinsmo, sort: generate p_statpop_imm= statpop_country/ statpop_imm if ciscobinsmo!=1;
by  state  ciscobinsmo, sort: generate p_statpop_total_wt= statpop_country_wt/ statpop_total_wt if ciscobinsmo!=1;
by  state  ciscobinsmo, sort: generate p_statpop_total= statpop_country/ statpop_total if ciscobinsmo!=1;

/*state population by occupation*/
by  state occ1990, sort: egen statoccpop_imm1=sum( pop_unwght) if ciscobinsmo!=1;
by  state occ1990, sort: egen statoccpop_imm=median(statoccpop_imm1);
by  state occ1990, sort: egen statoccpop_imm_wt1=sum( pop_wght) if ciscobinsmo!=1;
by  state occ1990, sort: egen statoccpop_imm_wt=median(statoccpop_imm_wt1);
by  state occ1990, sort: egen statoccpop_total_wt=sum( pop_wght);
by  state occ1990, sort: egen statoccpop_total=sum( pop_unwght);
drop statoccpop_imm1  statoccpop_imm_wt1;

/*percent of each ethnicity in the occupation by state*/
by  state occ1990 ciscobinsmo, sort: generate p_country_imm_occstat_wt= pop_wght/statoccpop_imm_wt ;
by  state occ1990 ciscobinsmo, sort: generate p_country_total_occstat_wt= pop_wght/statoccpop_total_wt ;
by  state occ1990 ciscobinsmo, sort: generate p_country_imm_occstat= pop_unwght/statoccpop_imm ;
by  state occ1990 ciscobinsmo, sort: generate p_country_total_occstat= pop_unwght/statoccpop_total ;

by  state occ1990 ciscobinsmo, sort: generate nat1_p_country_total_occstat=p_country_total_occstat if ciscobinsmo==1;
by  state occ1990, sort: egen p_native_total_occstat=mean(nat1_p_country_total_occstat);
by  state occ1990, sort: generate p_imm_total_occstat=1-p_native_total_occstat;
by  state occ1990 ciscobinsmo, sort: generate nat1_p_country_total_occstat_wt=p_country_total_occstat_wt if ciscobinsmo==1;
by  state occ1990, sort: egen p_native_total_occstat_wt=mean(nat1_p_country_total_occstat_wt);
by  state occ1990, sort: generate p_imm_total_occstat_wt=1-p_native_total_occstat_wt;
drop nat1_p_country_total_occstat nat1_p_country_total_occstat_wt;

by  state occ1990 ciscobinsmo, sort: generate p_occ_nat_stat_wt1=pop_wght/statpop_country_wt if ciscobinsmo==1;
by  state occ1990, sort: egen p_occ_nat_stat_wt=median(p_occ_nat_stat_wt1);
by  state occ1990 ciscobinsmo, sort: generate p_occ_nat_stat1=pop_unwght/statpop_country if ciscobinsmo==1;
by  state occ1990, sort: egen p_occ_nat_stat=median(p_occ_nat_stat1);
drop p_occ_nat_stat_wt1 p_occ_nat_stat1;

/* immigrant breakdown */

by  state occ1990 ciscobinsmo, sort: generate p_occ_old_countrystat_wt=pop_wght/statpop_country_wt;
by  state occ1990 ciscobinsmo, sort: generate p_occ_old_countrystat=pop_unwght/statpop_country;

by  state occ1990, sort: generate p_immold_occstat_wt=statoccpop_imm_wt/statoccpop_total_wt;
by  state occ1990, sort: generate p_immold_occstat=statoccpop_imm/statoccpop_total;

by  state occ1990, sort: generate p_occ_old_imm_stat_wt=(statoccpop_imm_wt-pop_wght)/(statpop_imm_wt-statpop_country_wt);
by  state occ1990, sort: generate p_occ_old_imm_stat=(statoccpop_imm-pop_unwght)/(statpop_imm-statpop_country);


/*percent of occupation that is native */
by  state occ1990, sort: egen statoccpop_nat1=sum( pop_unwght) if ciscobinsmo==1;
by  state occ1990, sort: egen statoccpop_nat=median(statoccpop_nat1);
by  state occ1990, sort: egen statoccpop_nat_wt1=sum( pop_wght) if ciscobinsmo==1;
by  state occ1990, sort: egen statoccpop_nat_wt=median(statoccpop_nat_wt1);
drop  statoccpop_nat1 statoccpop_nat_wt1;
by  state, sort: egen statpop_nat1=sum( pop_unwght) if ciscobinsmo==1;
by  state, sort: egen statpop_nat=median(statpop_nat1);
by  state, sort: egen statpop_nat_wt1=sum( pop_wght) if ciscobinsmo==1;
by  state, sort: egen statpop_nat_wt=median(statpop_nat_wt1);
drop  statpop_nat1  statpop_nat_wt1;
generate p_native_occ=statoccpop_nat/statoccpop_total;
generate p_native_occ_wt=statoccpop_nat_wt/statoccpop_total_wt;

/*percent of occupation in metroarea, excluding the new immigrants*/
generate p_occ_stat=(statoccpop_total)/(statpop_total);
generate p_occ_stat_wt=(statoccpop_total_wt)/(statpop_total_wt);

generate year=1990;

sort ciscobinsmo occ1990 state;


save "reg4 NIS\census90_5pc_occstate.dta", replace;

/*******1980*******/
#delimit;
use "native and immigrants\census80_5pc_all.dta", clear;

drop empstatd;


generate ciscobinsmo=301 if bpld	 == 	43000	 |
bpld	 == 	42111	 |
bpld	 == 	42110	 |
bpld	 == 	43100	 |
bpld	 == 	45341	 |
bpld	 == 	46540	 |
bpld	 == 	45000	 |
bpld	 == 	45020	 |
bpld	 == 	45010	 |
bpld	 == 	45070	 |
bpld	 == 	45030	 |
bpld	 == 	45510	 |
bpld	 == 	45080	 |
bpld	 == 	45040	 |
bpld	 == 	45050	 |
bpld	 == 	45060	 |
bpld	 == 	46541	 |
bpld	 == 	43610	 |
bpld	 == 	45311	 |
bpld	 == 	46300	 |
bpld	 == 	45312	 |
bpld	 == 	42000	 |
bpld	 == 	45301	 |
bpld	 == 	46521	 |
bpld	 == 	45210	 |
bpld	 == 	45211	 |
bpld	 == 	45740	 |
bpld	 == 	45342	 |
bpld	 == 	45313	 |
bpld	 == 	45314	 |
bpld	 == 	45100	 |
bpld	 == 	46510	 |
bpld	 == 	43630	 |
bpld	 == 	45770	 |
bpld	 == 	45800	 |
bpld	 == 	41010	 |
bpld	 == 	45710	 |
bpld	 == 	45213	 |
bpld	 == 	45200	 |
bpld	 == 	45750	 |
bpld	 == 	40000	 |
bpld	 == 	43310	 |
bpld	 == 	45343	 |
bpld	 == 	45340	 |
bpld	 == 	45521	 |
bpld	 == 	45900	 |
bpld	 == 	46000	 |
bpld	 == 	49900	 |
bpld	 == 	40010	 |
bpld	 == 	40100	 |
bpld	 == 	42100	 |
bpld	 == 	45331	 |
bpld	 == 	45511	 |
bpld	 == 	46542	 |
bpld	 == 	45520	 |
bpld	 == 	45300	 |
bpld	 == 	43200	 |
bpld	 == 	43300	 |
bpld	 == 	41011	 |
bpld	 == 	45315	 |
bpld	 == 	45316	 |
bpld	 == 	45318	 |
bpld	 == 	45317	 |
bpld	 == 	45361	 |
bpld	 == 	45319	 |
bpld	 == 	45400	 |
bpld	 == 	40200	 |
bpld	 == 	41400	 |
bpld	 == 	41020	 |
bpld	 == 	43400	 |
bpld	 == 	40412	 |
bpld	 == 	41012	 |
bpld	 == 	46543	 |
bpld	 == 	46544	 |
bpld	 == 	45790	 |
bpld	 == 	40300	 |
bpld	 == 	46100	 |
bpld	 == 	42200	 |
bpld	 == 	45320	 |
bpld	 == 	46200	 |
bpld	 == 	42112	 |
bpld	 == 	45321	 |
bpld	 == 	42300	 |
bpld	 == 	43330	 |
bpld	 == 	43620	 |
bpld	 == 	43500	 |
bpld	 == 	45344	 |
bpld	 == 	46520	 |
bpld	 == 	42400	 |
bpld	 == 	45720	 |
bpld	 == 	42500	 |
bpld	 == 	45362	 |
bpld	 == 	45333	 |
bpld	 == 	41900	 |
bpld	 == 	40400	 |
bpld	 == 	45322	 |
bpld	 == 	45522	 |
bpld	 == 	43600	 |
bpld	 == 	45523	 |
bpld	 == 	45360	 |
bpld	 == 	45524	 |
bpld	 == 	45323	 |
bpld	 == 	45600	 |
bpld	 == 	45530	 |
bpld	 == 	45332	 |
bpld	 == 	45345	 |
bpld	 == 	45346	 |
bpld	 == 	45347	 |
bpld	 == 	45348	 |
bpld	 == 	45349	 |
bpld	 == 	43700	 |
bpld	 == 	45350	 |
bpld	 == 	45324	 |
bpld	 == 	45325	 |
bpld	 == 	45326	 |
bpld	 == 	45351	 |
bpld	 == 	45730	 |
bpld	 == 	46548	 |
bpld	 == 	45525	 |
bpld	 == 	45212	 |
bpld	 == 	45780	 |
bpld	 == 	45760	 |
bpld	 == 	44000	 |
bpld	 == 	43800	 |
bpld	 == 	43640	 |
bpld	 == 	45352	 |
bpld	 == 	40410	 |
bpld	 == 	40411	 |
bpld	 == 	40500	 |
bpld	 == 	42600	 |
bpld	 == 	46545	 |
bpld	 == 	45353	 |
bpld	 == 	45610	 |
bpld	 == 	43320	 |
bpld	 == 	46546	 |
bpld	 == 	41300	 |
bpld	 == 	46547	 |
bpld	 == 	43900	 |
bpld	 == 	45327	 |
bpld	 == 	45328	 |
bpld	 == 	45310	 |
bpld	 == 	45526	 |
bpld	 == 	42900	 |
bpld	 == 	45329	 |
bpld	 == 	45330	 |
bpld	 == 	45700	 ;


replace ciscobinsmo=302 if bpld	 == 	52000	 |
bpld	 == 	54900	 |
bpld	 == 	59900	 |
bpld	 == 	52110	 |
bpld	 == 	52120	 |
bpld	 == 	51000	 |
bpld	 == 	52130	 |
bpld	 == 	51100	 |
bpld	 == 	50900	 |
bpld	 == 	51210	 |
bpld	 == 	51220	 |
bpld	 == 	50010	 |
bpld	 == 	51910	 |
bpld	 == 	51200	 |
bpld	 == 	50100	 |
bpld	 == 	51300	 |
bpld	 == 	50020	 |
bpld	 == 	51400	 |
bpld	 == 	52300	 |
bpld	 == 	50030	 |
bpld	 == 	52400	 |
bpld	 == 	52140	 |
bpld	 == 	51600	 |
bpld	 == 	55000	 |
bpld	 == 	51900	 |
bpld	 == 	52150	 |
bpld	 == 	50040	 |
bpld	 == 	51700	 ;


replace ciscobinsmo=304 if bpld == 	10000	 |
bpld	 == 	10010	 |
bpld	 == 	10500	 |
bpld	 == 	11000	 |
bpld	 == 	11500	 |
bpld	 == 	11510	 |
bpld	 == 	11520	 |
bpld	 == 	11530	 |
bpld	 == 	12000	 |
bpld	 == 	12010	 |
bpld	 == 	12020	 |
bpld	 == 	12030	 |
bpld	 == 	12040	 |
bpld	 == 	12041	 |
bpld	 == 	12050	 |
bpld	 == 	12051	 |
bpld	 == 	12052	 |
bpld	 == 	12053	 |
bpld	 == 	12054	 |
bpld	 == 	12055	 |
bpld	 == 	12060	 |
bpld	 == 	12090	 |
bpld	 == 	12091	 |
bpld	 == 	12092	 ;



replace ciscobinsmo=305 if bpld	 == 	29999	|
bpld	 == 	26046	|
bpld	 == 	26041	|
bpld	 == 	26042	|
bpld	 == 	26090	|
bpld	 == 	30005	|
bpld	 == 	26071	|
bpld	 == 	16000	|
bpld	 == 	26043	|
bpld	 == 	26044	|
bpld	 == 	21010	|
bpld	 == 	16010	|
bpld	 == 	30010	|
bpld	 == 	26073	|
bpld	 == 	26052	|
bpld	 == 	30015	|
bpld	 == 	26045	|
bpld	 == 	26040	|
bpld	 == 	26069	|
bpld	 == 	21071	|
bpld	 == 	16060	|
bpld	 == 	16020	|
bpld	 == 	26091	|
bpld	 == 	26053	|
bpld	 == 	21000	|
bpld	 == 	21090	|
bpld	 == 	30020	|
bpld	 == 	26047	|
bpld	 == 	21020	|
bpld	 == 	26074	|
bpld	 == 	26054	|
bpld	 == 	26079	|
bpld	 == 	26075	|
bpld	 == 	30030	|
bpld	 == 	16030	|
bpld	 == 	26089	|
bpld	 == 	30035	|
bpld	 == 	26080	|
bpld	 == 	16040	|
bpld	 == 	26055	|
bpld	 == 	26081	|
bpld	 == 	30040	|
bpld	 == 	21050	|
bpld	 == 	26048	|
bpld	 == 	26092	|
bpld	 == 	26093	|
bpld	 == 	26082	|
bpld	 == 	26056	|
bpld	 == 	26072	|
bpld	 == 	19900	|
bpld	 == 	26070	|
bpld	 == 	21070	|
bpld	 == 	30045	|
bpld	 == 	26049	|
bpld	 == 	26076	|
bpld	 == 	30000	|
bpld	 == 	30090	|
bpld	 == 	30091	|
bpld	 == 	26083	|
bpld	 == 	26077	|
bpld	 == 	16050	|
bpld	 == 	26057	|
bpld	 == 	26058	|
bpld	 == 	15500	|
bpld	 == 	26059	|
bpld	 == 	30055	|
bpld	 == 	26050	|
bpld	 == 	26060	|
bpld	 == 	26061	|
bpld	 == 	30060	|
bpld	 == 	30065	|
bpld	 == 	26051	|
bpld	 == 	26000	|
bpld	 == 	26094	|
bpld	 == 	26095	;

replace ciscobinsmo=306 if bpld	 == 	60000	|
bpld	 == 	60099	|
bpld	 == 	60071	|
bpld	 == 	60058	|
bpld	 == 	60020	|
bpld	 == 	60091	|
bpld	 == 	60040	|
bpld	 == 	60021	|
bpld	 == 	60041	|
bpld	 == 	60072	|
bpld	 == 	60070	|
bpld	 == 	60080	|
bpld	 == 	60073	|
bpld	 == 	60074	|
bpld	 == 	60042	|
bpld	 == 	60075	|
bpld	 == 	60043	|
bpld	 == 	60064	|
bpld	 == 	60081	|
bpld	 == 	60076	|
bpld	 == 	60065	|
bpld	 == 	60059	|
bpld	 == 	60082	|
bpld	 == 	60039	|
bpld	 == 	60077	|
bpld	 == 	60022	|
bpld	 == 	60023	|
bpld	 == 	60060	|
bpld	 == 	60024	|
bpld	 == 	60025	|
bpld	 == 	60026	|
bpld	 == 	60061	|
bpld	 == 	60045	|
bpld	 == 	60092	|
bpld	 == 	60027	|
bpld	 == 	60046	|
bpld	 == 	60047	|
bpld	 == 	60028	|
bpld	 == 	60029	|
bpld	 == 	60048	|
bpld	 == 	60062	|
bpld	 == 	60049	|
bpld	 == 	60093	|
bpld	 == 	60030	|
bpld	 == 	60031	|
bpld	 == 	60019	|
bpld	 == 	60050	|
bpld	 == 	60051	|
bpld	 == 	60078	|
bpld	 == 	60032	|
bpld	 == 	60052	|
bpld	 == 	60033	|
bpld	 == 	60053	|
bpld	 == 	60094	|
bpld	 == 	60096	|
bpld	 == 	60090	|
bpld	 == 	60015	|
bpld	 == 	60095	|
bpld	 == 	60054	|
bpld	 == 	60034	|
bpld	 == 	60063	|
bpld	 == 	60055	|
bpld	 == 	60038	|
bpld	 == 	60017	|
bpld	 == 	60079	|
bpld	 == 	60056	|
bpld	 == 	60057	;


replace ciscobinsmo=307 if bpld	 == 	52200	|
bpld	 == 	53000	|
bpld	 == 	53100	|
bpld	 == 	53200	|
bpld	 == 	53210	|
bpld	 == 	53300	|
bpld	 == 	53400	|
bpld	 == 	53410	|
bpld	 == 	53420	|
bpld	 == 	53430	|
bpld	 == 	53440	|
bpld	 == 	53500	|
bpld	 == 	53600	|
bpld	 == 	53700	|
bpld	 == 	53800	|
bpld	 == 	53900	|
bpld	 == 	54000	|
bpld	 == 	54100	|
bpld	 == 	54200	|
bpld	 == 	54210	|
bpld	 == 	54220	|
bpld	 == 	54300	|
bpld	 == 	54400	|
bpld	 == 	54500	|
bpld	 == 	54600	|
bpld	 == 	54700	|
bpld	 == 	54800	|
bpld	 == 	60010	|
bpld	 == 	60011	|
bpld	 == 	60012	|
bpld	 == 	60013	|
bpld	 == 	60014	|
bpld	 == 	60016	;

replace ciscobinsmo=308 if bpld	 == 	70000	|
bpld	 == 	70010	|
bpld	 == 	70011	|
bpld	 == 	70012	|
bpld	 == 	70020	|
bpld	 == 	71000	|
bpld	 == 	71010	|
bpld	 == 	71011	|
bpld	 == 	71012	|
bpld	 == 	71013	|
bpld	 == 	71014	|
bpld	 == 	71019	|
bpld	 == 	71020	|
bpld	 == 	71021	|
bpld	 == 	71022	|
bpld	 == 	71023	|
bpld	 == 	71024	|
bpld	 == 	71025	|
bpld	 == 	71029	|
bpld	 == 	71030	|
bpld	 == 	71031	|
bpld	 == 	71032	|
bpld	 == 	71033	|
bpld	 == 	71034	|
bpld	 == 	71035	|
bpld	 == 	71036	|
bpld	 == 	71037	|
bpld	 == 	71038	|
bpld	 == 	71039	|
bpld	 == 	71040	|
bpld	 == 	71041	|
bpld	 == 	71042	|
bpld	 == 	71043	|
bpld	 == 	71044	|
bpld	 == 	71045	|
bpld	 == 	71046	|
bpld	 == 	71047	|
bpld	 == 	71048	|
bpld	 == 	71049	|
bpld	 == 	71050	|
bpld	 == 	71090	;

replace ciscobinsmo=308 if bpld	 == 	80000	|
bpld	 == 	80010	|
bpld	 == 	80020	|
bpld	 == 	80030	|
bpld	 == 	80040	|
bpld	 == 	80050	|
bpld	 == 	90000	|
bpld	 == 	90010	|
bpld	 == 	90011	|
bpld	 == 	90020	|
bpld	 == 	90021	|
bpld	 == 	90022	;



replace 	ciscobinsmo	 = 	38	 if 	bpld	 == 	15000	|	bpld	 == 	15010	|	bpld	 == 	15011	|	bpld	 == 	15013	| bpld == 	15015	| bpld == 	15017| bpld == 15019| bpld == 15020	| bpld == 15021	| bpld == 15030	| bpld == 15031	| bpld == 15032	| bpld == 15040	| bpld == 15050	| bpld == 15051	| bpld == 15052	| bpld == 15060	| bpld == 15070	| bpld == 15080;
replace 	ciscobinsmo	 = 	44	 if 	bpld	 == 	50000	;																																			
replace 	ciscobinsmo	 = 	47	 if 	bpld	 == 	30025	;																																			
replace 	ciscobinsmo	 = 	55	 if 	bpld	 == 	25000	;																																			
replace 	ciscobinsmo	 = 	62	 if 	bpld	 == 	26010	;																																			
replace 	ciscobinsmo	 = 	65	 if 	bpld	 == 	21030	;																																			
replace 	ciscobinsmo	 = 	69	 if 	bpld	 == 	60044	;																																			
replace 	ciscobinsmo	 = 	88	 if 	bpld	 == 	21040	;																																			
replace 	ciscobinsmo	 = 	92	 if 	bpld	 == 	26020	;																																			
replace 	ciscobinsmo	 = 	98	 if 	bpld	 == 	52100	;																																			
replace 	ciscobinsmo	 = 	105	 if 	bpld	 == 	26030	;																																			
replace 	ciscobinsmo	 = 	111	 if 	bpld	 == 	50200	|	bpld	 == 	50210	|	bpld	 == 	50220;																												
replace 	ciscobinsmo	 = 	135	 if 	bpld	 == 	20000	;																																			
replace 	ciscobinsmo	 = 	152	 if 	bpld	 == 	21060	;																																			
replace 	ciscobinsmo	 = 	163	 if 	bpld	 == 	30050	;																																			
replace 	ciscobinsmo	 = 	164	 if 	bpld	 == 	51500	;																																			
replace 	ciscobinsmo	 = 	166	 if 	bpld	 == 	45500	;																																			
replace 	ciscobinsmo	 = 	172	 if 	bpld	 == 	46500	|	bpld	 == 	46590	;																															
replace 	ciscobinsmo	 = 	215	 if 	bpld	 == 	46530	;																																			
replace 	ciscobinsmo	 = 	217	 if 	bpld	 == 	41200	|	bpld	 == 	41000	|	bpld	 == 	41410	|	bpld	 == 	41100	;																							
replace 	ciscobinsmo	 = 	224	 if 	bpld	 == 	51800	;																																			
																																											




label define country
38	"CANADA"
44	"CHINA, PEOPLES REPUBLIC"
47	"COLOMBIA"
55	"CUBA"
62	"DOMINICAN REPUBLIC"
65	"EL SALVADOR"
69	"ETHIOPIA"
88	"GUATEMALA"
92	"HAITI"
98	"INDIA"
105	"JAMAICA"
111	"KOREA"
135	"MEXICO"
152	"NIGERIA"
163	"PERU"
164	"PHILIPPINES"
166	"POLAND"
172	"RUSSIA"
215	"UKRAINE"
217	"UNITED KINGDOM"
218	"UNITED STATES"
219	"UNKNOWN"
224	"VIETNAM"
301	"EUROPE & CENTRAL ASIA"
302	"EAST ASIA, SOUTH ASIA & THE PACIFIC"
304	"OTHER NORTH AMERICA"
305	"LATIN AMERICA & THE CARIBBEAN"
306	"AFRICAN SUB-SAHARAN"
307	"MIDDLE EAST & NORTH AFRICA"
308	"OCEANIA"
310	"ARCTIC REGION";

label values ciscobinsmo country; 


/** create state variables **/

generate 	state 	 = 	1	 if 	statefip	 == 	4	;
replace 	state 	 = 	2	 if 	statefip	 == 	9	;
replace 	state 	 = 	3	 if 	statefip	 == 	13	;
replace 	state 	 = 	4	 if 	statefip	 == 	30	;
replace 	state 	 = 	5	 if 	statefip	 == 	32	;
replace 	state 	 = 	6	 if 	statefip	 == 	42	;
replace 	state 	 = 	7	 if 	statefip	 == 	6 | statefip==19 | statefip==21 | statefip==29	;
replace 	state 	 = 	8	 if 	statefip	 == 	38 |statefip==44|statefip==46	;
replace 	state 	 = 	9	 if 	statefip	 == 	7|statefip==8|statefip==10|statefip==20|statefip==33|statefip==39	;
replace 	state 	 = 	10	 if 	statefip	 == 	1|statefip==17|statefip==24|statefip==41	;
replace 	state 	 = 	11	 if 	statefip	 == 	14|statefip==22|statefip==35|statefip==47	;
replace 	state 	 = 	12	 if 	statefip	 == 	15|statefip==16|statefip==23|statefip==25|statefip==27|statefip==34|statefip==40	;
replace 	state 	 = 	13	 if 	statefip	 == 	3|statefip==18|statefip==36	;
replace 	state 	 = 	14	 if 	statefip	 == 	2|statefip==5|statefip==12|statefip==26|statefip==28|statefip==31|statefip==43|statefip==48	;
replace 	state 	 = 	15	 if 	statefip	 == 	11|statefip==37|statefip==45	;


label define state 
1	"California"
2	"Florida"
3	"Illinois"
4	"New Jersey"
5	"New York"
6	"Texas"
7	"New England"
8	"Middle Atlantic"
9	"South Atlantic"
10	"East South Central"
11	"East North Central"
12	"West North Central"
13	"West South Central"
14	"Mountain"
15	"Pacific" ;

label values state state;
drop if state >20;

replace ciscobinsmo=1 if bpl>=1 & bpl<=99;
generate pop_unwght=1;
generate pop_wght=perwt;
collapse (sum) pop_unwght pop_wght, by (state occ1990 ciscobinsmo);

/*state population (total immigrant)*/
by  state, sort: egen statpop_imm1=sum( pop_unwght) if ciscobinsmo!=1;
by  state, sort: egen statpop_imm=median(statpop_imm1);
by  state, sort: egen statpop_imm_wt1=sum( pop_wght) if ciscobinsmo!=1;
by  state, sort: egen statpop_imm_wt=median(statpop_imm_wt1);
by  state, sort: egen statpop_total_wt=sum( pop_wght);
by  state, sort: egen statpop_total=sum( pop_unwght);
by  state, sort: generate p_imm=statpop_imm/statpop_total;
by  state, sort: generate p_imm_wt=statpop_imm_wt/statpop_total_wt;
drop statpop_imm1 statpop_imm_wt1;

/*state populaiton by country and percent of each country in state immigrant population*/
by  state  ciscobinsmo, sort: egen statpop_country=sum( pop_unwght);
by  state  ciscobinsmo, sort: egen statpop_country_wt=sum( pop_wght);
by  state  ciscobinsmo, sort: generate p_statpop_imm_wt= statpop_country_wt/ statpop_imm_wt if ciscobinsmo!=1;
by  state  ciscobinsmo, sort: generate p_statpop_imm= statpop_country/ statpop_imm if ciscobinsmo!=1;
by  state  ciscobinsmo, sort: generate p_statpop_total_wt= statpop_country_wt/ statpop_total_wt if ciscobinsmo!=1;
by  state  ciscobinsmo, sort: generate p_statpop_total= statpop_country/ statpop_total if ciscobinsmo!=1;

/*state population by occupation*/
by  state occ1990, sort: egen statoccpop_imm1=sum( pop_unwght) if ciscobinsmo!=1;
by  state occ1990, sort: egen statoccpop_imm=median(statoccpop_imm1);
by  state occ1990, sort: egen statoccpop_imm_wt1=sum( pop_wght) if ciscobinsmo!=1;
by  state occ1990, sort: egen statoccpop_imm_wt=median(statoccpop_imm_wt1);
by  state occ1990, sort: egen statoccpop_total_wt=sum( pop_wght);
by  state occ1990, sort: egen statoccpop_total=sum( pop_unwght);
drop statoccpop_imm1  statoccpop_imm_wt1;

/*percent of each ethnicity in the occupation by state*/
by  state occ1990 ciscobinsmo, sort: generate p_country_imm_occstat_wt= pop_wght/statoccpop_imm_wt ;
by  state occ1990 ciscobinsmo, sort: generate p_country_total_occstat_wt= pop_wght/statoccpop_total_wt ;
by  state occ1990 ciscobinsmo, sort: generate p_country_imm_occstat= pop_unwght/statoccpop_imm ;
by  state occ1990 ciscobinsmo, sort: generate p_country_total_occstat= pop_unwght/statoccpop_total ;

by  state occ1990 ciscobinsmo, sort: generate nat1_p_country_total_occstat=p_country_total_occstat if ciscobinsmo==1;
by  state occ1990, sort: egen p_native_total_occstat=mean(nat1_p_country_total_occstat);
by  state occ1990, sort: generate p_imm_total_occstat=1-p_native_total_occstat;
by  state occ1990 ciscobinsmo, sort: generate nat1_p_country_total_occstat_wt=p_country_total_occstat_wt if ciscobinsmo==1;
by  state occ1990, sort: egen p_native_total_occstat_wt=mean(nat1_p_country_total_occstat_wt);
by  state occ1990, sort: generate p_imm_total_occstat_wt=1-p_native_total_occstat_wt;
drop nat1_p_country_total_occstat nat1_p_country_total_occstat_wt;

by  state occ1990 ciscobinsmo, sort: generate p_occ_nat_stat_wt1=pop_wght/statpop_country_wt if ciscobinsmo==1;
by  state occ1990, sort: egen p_occ_nat_stat_wt=median(p_occ_nat_stat_wt1);
by  state occ1990 ciscobinsmo, sort: generate p_occ_nat_stat1=pop_unwght/statpop_country if ciscobinsmo==1;
by  state occ1990, sort: egen p_occ_nat_stat=median(p_occ_nat_stat1);
drop p_occ_nat_stat_wt1 p_occ_nat_stat1;

/* immigrant breakdown */

by  state occ1990 ciscobinsmo, sort: generate p_occ_old_countrystat_wt=pop_wght/statpop_country_wt;
by  state occ1990 ciscobinsmo, sort: generate p_occ_old_countrystat=pop_unwght/statpop_country;

by  state occ1990, sort: generate p_immold_occstat_wt=statoccpop_imm_wt/statoccpop_total_wt;
by  state occ1990, sort: generate p_immold_occstat=statoccpop_imm/statoccpop_total;

by  state occ1990, sort: generate p_occ_old_imm_stat_wt=(statoccpop_imm_wt-pop_wght)/(statpop_imm_wt-statpop_country_wt);
by  state occ1990, sort: generate p_occ_old_imm_stat=(statoccpop_imm-pop_unwght)/(statpop_imm-statpop_country);

/*percent of occupation that is native */
by  state occ1990, sort: egen statoccpop_nat1=sum( pop_unwght) if ciscobinsmo==1;
by  state occ1990, sort: egen statoccpop_nat=median(statoccpop_nat1);
by  state occ1990, sort: egen statoccpop_nat_wt1=sum( pop_wght) if ciscobinsmo==1;
by  state occ1990, sort: egen statoccpop_nat_wt=median(statoccpop_nat_wt1);
drop  statoccpop_nat1 statoccpop_nat_wt1;
by  state, sort: egen statpop_nat1=sum( pop_unwght) if ciscobinsmo==1;
by  state, sort: egen statpop_nat=median(statpop_nat1);
by  state, sort: egen statpop_nat_wt1=sum( pop_wght) if ciscobinsmo==1;
by  state, sort: egen statpop_nat_wt=median(statpop_nat_wt1);
drop  statpop_nat1  statpop_nat_wt1;
generate p_native_occ=statoccpop_nat/statoccpop_total;
generate p_native_occ_wt=statoccpop_nat_wt/statoccpop_total_wt;

/*percent of occupation in metroarea, excluding the new immigrants*/
generate p_occ_stat=(statoccpop_total)/(statpop_total);
generate p_occ_stat_wt=(statoccpop_total_wt)/(statpop_total_wt);

generate year=1980;

sort ciscobinsmo occ1990 state;


save "reg4 NIS\census80_5pc_occstate.dta", replace;

append using "reg4 NIS\census90_5pc_occstate.dta";
append using "reg4 NIS\census00_5pc_occstate.dta";

sort ciscobinsmo occ1990 state year;

save "reg4 NIS\census_5pc_occstate.dta", replace;


