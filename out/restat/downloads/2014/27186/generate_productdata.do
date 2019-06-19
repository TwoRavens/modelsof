/*-----------------------------------------------------------------------------				GENERATE PRODUCT DATA------------------------------------------------------------------------------*//*This do-file generates the product data used in the empirical analysis.*/cd  "~/work/bergrato_export/data"** RELATION-SPECIFICITY proxied by INDUSTRY-CONTRACT INTENSITY developed by Nunn (2007)** "Relationship-Specificity, Incomplete contracts, and the Pattern of Trade" 2007. Quarterly Journal of Economics, 122 (2): 569-600. Data are currently available at http://scholar.harvard.edu/nunn/pages/data-0**---------------------------------------------------------------------------------------*Nunn's data are classified according to the industry classification of the US I-O table compiled by the Bureau of Economic Activity. We match each I-O industry to an HS6 product**STEP 1: Use the concordance between HS and NAICS2002 Industries developed by Pierce and Schott (2012)use hs_naics7_exports_02.dta, clearegen num_hs= group(hs)collapse num_hs , by( hs naicsbaseroot)sort naicsbaserootsave temp.dta, replace**STEP 2: Convert the Nunn's data from NAICS1997 to NAICS2002use nunndata.dta, clearsort naics1997merge m:m naics1997 using naics97_naics02.dtakeep if _merge==3drop _mergerename naics2002 naicsbaserootcollapse frac_lib_diff frac_lib_not_homog lib_org_exch lib_ref_price lib_diff cons_org_exch cons_ref_price cons_diff total_value_used, by (naicsbaseroot )tostring naicsbaseroot, replacesort naicsbaserootmerge naicsbaseroot using temp.dtakeep if _merge==3drop _mergegen hs6 = hsrecast str6 hs6, forcedrop hs num_hsegen contrac1= mean( frac_lib_diff), by(hs6)egen contrac2= mean( frac_lib_not_homog), by(hs6)unique hs6 if frac_lib_diff !=contrac1collapse contrac1 contrac2, by(hs6)destring hs6, gen (sh6)sort hs6save CONTRACT.dta, replaceerase temp.dta** PRODUCT DIFFERENTIATION proxied by the COEFFICIENT OF PRICE DISPERSION**-----------------------------------------------------------------------use coe2003fcp_exp.dta, clearkeep if manuf==1 | whol==1egen disp_vmu_A=sd(VMUE), by (sh6)egen meand_disp=mean(VMUE), by(sh6)gen disp_vmu= disp_vmu_A/meand_dispcollapse disp_vmu, by(sh6)drop if disp_vmu==.sort sh6save DISP.dta, replace** PRODUCT SUNK-COSTS OF ENTRY proxied by the LEVEL OF ENTRY-EXIT IN THE EXPORT MARKET**------------------------------------------------------------------------------------** STEP 1: Generate firm-product datasetforeach j in 2003 2007 {	use coe`j'fcp.dta, clear	keep if export!=.	keep if manuf==1 | whol==1	keep codiceasia sh6 country export whol manuf 	sort codiceasia sh6 country export	egen export_fp=sum(export), by(codiceasia sh6)	collapse export_fp whol manuf, by(codiceasia sh6)	keep codiceasia sh6	sort codiceasia sh6	gen pres_`j'=1	save exp_fp`j'.dta, replace}** STEP 2: Generate min(entry, exit) rateforeach t in 2003 {	use exp_fp`t'.dta, replace	local t1=`t'+4	merge codiceasia sh6 using exp_fp`t1'.dta	gen cont=1 if pres_`t'==1 & pres_`t1'==1	gen entr=1 if pres_`t'==. & pres_`t1'==1	gen exit=1 if pres_`t'==1 & pres_`t1'==.	sort sh6	egen entry_fp=sum(entr), by(sh6)	egen exit_fp =sum(exit), by(sh6)	egen cont_fp =sum(cont), by(sh6)	egen numb_`t'=sum(pres_`t'), by(sh6)	egen numb_`t1'=sum(pres_`t1'), by(sh6)	drop pres_`t' pres_`t1'	sort sh6	collapse cont_fp entry_fp exit_fp numb_`t' numb_`t1', by(sh6)	gen entry_rate = entry_fp/(1/2*(numb_`t'+numb_`t1'))	gen exit_rate = exit_fp/(1/2*(numb_`t'+numb_`t1'))	egen minA=rowmin(entry_rate exit_rate)	drop cont_fp entry_fp exit_fp numb_`t' numb_`t1' entry_rate exit_rate 	sort sh6	save ENTRYEXIT.dta, replace	}foreach j in 2003 2007 {	erase exp_fp`j'.dta	}** POLICIES BARRIERS proxied by TARIFF taken from World Integrated Trade System (WITS)**------------------------------------------------------------------------------------use Alltariff2_TRN.dta, cleardrop partner partner_name partner_namedrop native_nomen selected_nomenrename reporter_name countrydrop trade_sourcedrop rownumdestring simple_average- simple_tariff_line_average, replacerename simple_tariff_line_average tariffgen year=2003replace country="The Bahamas" if country=="Bahamas, The"replace country="Democratic Republic of Congo" if country=="Congo, Dem. Rep."replace country="Republic of Congo" if country=="Congo, Rep."replace country="Egypt" if country=="Egypt, Arab Rep."replace country="Ethiopia" if country=="Ethiopia(excludes Eritrea)"replace country="The Gambia" if country=="Gambia, The"replace country="GuineaBissau" if country=="Guinea-Bissau"replace country="Hong Kong" if country=="Hong Kong, China"replace country="Iran" if country=="Iran, Islamic Rep."replace country="Korea, Republic of" if country=="Korea, Rep."replace country="Laos" if country=="Lao PDR"replace country="Macedonia" if country=="Macedonia, FYR"replace country="The Philippines" if country=="Philippines"replace country="Russia" if country=="Russian Federation"replace country="Slovakia" if country=="Slovak Republic"replace country="Saint Vincent and the Grenadines" if country=="St. Vincent and the Grenadines"replace country="Saint Lucia" if country=="St. Lucia"replace country="St. Kitts & Nevis" if country=="St. Kitts and Nevis"replace country="Slovakia" if country=="Slovak Republic"replace country="Cote Ivoire" if country=="Cote d'Ivoire"replace country="Syria" if country=="Syrian Arab Republic"replace country="Taiwan" if country=="Taiwan, China"replace country="Myanmair" if country=="Myanmar"gen col4=.replace  col4=660 if country=="Afghanistan"	& year==2003replace 	col4=70	if	country=="Albania"	& year==2003replace 	col4=208 if	country=="Algeria"	& year==2003replace 	col4=330 if	country=="Angola"	& year==2003replace 	col4=459	if	country=="Antigua and Barbuda" & year==2003replace 	col4=528	if	country=="Argentina" & year==2003replace 	col4=77	if	country=="Armenia" & year==2003replace 	col4=800	if	country=="Australia" & year==2003replace 	col4=38	if	country=="Austria" & year==2003replace 	col4=78	if	country=="Azerbaijan" & year==2003replace 	col4=640	if	country=="Bahrain" & year==2003replace 	col4=666	if	country=="Bangladesh" & year==2003replace 	col4=469	if	country=="Barbados"& year==2003replace 	col4=73	if	country=="Belarus" & year==2003replace 	col4=17	if	country=="Belgium" & year==2003replace 	col4=421	if	country=="Belize" & year==2003replace 	col4=284	if	country=="Benin" & year==2003replace 	col4=675	if	country=="Bhutan" & year==2003replace 	col4=516	if	country=="Bolivia" & year==2003replace 	col4=93	if	country=="Bosnia and Herzegovina" & year==2003replace 	col4=391	if	country=="Botswana" & year==2003replace 	col4=508	if	country=="Brazil" & year==2003replace 	col4=68	if	country=="Bulgaria" & year==2003replace 	col4=236	if	country=="Burkina Faso" & year==2003replace 	col4=328	if	country=="Burundi" & year==2003replace 	col4=413	if	country=="Bermuda"& year==2003replace 	col4=703	if	country=="Brunei" & year==2003replace 	col4=696	if	country=="Cambodia" & year==2003replace 	col4=302	if	country=="Cameroon" & year==2003replace 	col4=404	if	country=="Canada" & year==2003replace 	col4=247	if	country=="Cape Verde" & year==2003replace 	col4=306	if	country=="Central African Republic" & year==2003replace 	col4=244	if	country=="Chad" & year==2003replace 	col4=512	if	country=="Chile" & year==2003replace 	col4=720	if	country=="China" & year==2003replace 	col4=480	if	country=="Colombia" & year==2003replace 	col4=375	if	country=="Comoros" & year==2003replace 	col4=436	if	country=="Costa Rica" & year==2003replace 	col4=272	if	country=="Cote Ivoire" & year==2003replace 	col4=92	if	country=="Croatia" & year==2003replace 	col4=448	if	country=="Cuba"  & year==2003replace 	col4=600	if	country=="Cyprus" & year==2003replace 	col4=61	if	country=="Czech Republic" & year==2003replace  col4=322 if country=="Democratic Republic of Congo" & year==2003replace 	col4	=8	if	country=="Denmark" & year==2003replace 	col4	=338	if	country ==	"Djibouti"	 & year==2003replace 	col4	=460	if	country 	=="Dominica" & year==2003replace 	col4	=456	if	country 	=="Dominican Republic" & year==2003replace 	col4	=500	if	country 	=="Ecuador" & year==2003replace 	col4	=220	if	country 	=="Egypt" & year==2003replace 	col4	=428	if	country 	=="El Salvador" & year==2003replace 	col4	=310	if	country ==	"Equatorial Guinea" & year==2003replace 	col4	=336	if	country 	=="Eritrea" & year==2003replace 	col4	=53	if	country 	=="Estonia" & year==2003replace 	col4	=334	if	country =="Ethiopia" & year==2003replace 	col4	=815	if	country ==	"Fiji" & year==2003replace 	col4	=32	if	country ==	"Finland" & year==2003replace 	col4	=1	if	country ==	"France" & year==2003replace 	col4	=314	if	country ==	"Gabon" & year==2003replace 	col4	=76		if	country 	=="Georgia" & year==2003replace 	col4	=4		if	country 	=="Germany"  & year==2003replace 	col4	=276	if	country ==	"Ghana" & year==2003replace 	col4	=9		if	country ==	"Greece" & year==2003replace 	col4	=416	if	country ==	"Guatemala" & year==2003replace 	col4	=260	if	country ==	"Guinea" & year==2003replace 	col4	=257	if	country ==	"GuineaBissau" & year==2003replace 	col4	=488	if	country 	=="Guyana" & year==2003replace 	col4	=452	if	country ==	"Haiti" & year==2003replace 	col4	=424	if	country==	"Honduras" & year==2003replace 	col4	=740	if	country ==	"Hong Kong" & year==2003replace 	col4	=64	if	country ==	"Hungary"	 & year==2003replace 	col4	=24	if	country 	=="Iceland" & year==2003replace 	col4	=664	if	country ==	"India" & year==2003replace 	col4	=700	if	country ==	"Indonesia" & year==2003replace 	col4	=616	if	country ==	"Iran" & year==2003replace 	col4	=612	if	country 	=="Iraq" & year==2003replace 	col4	=7	if	country ==	"Ireland" & year==2003replace 	col4	=624	if	country== 	"Israel" & year==2003replace 	col4	=5	if	country== 	"Italy" & year==2003replace 	col4	=464	if	country 	=="Jamaica" & year==2003replace 	col4	=732	if	country ==	"Japan" & year==2003replace 	col4	=628	if	country ==	"Jordan" & year==2003replace 	col4	=473	if	country ==	"Grenada" & year==2003replace 	col4	=79	if	country ==	"Kazakhstan" & year==2003replace 	col4	=346	if	country ==	"Kenya" & year==2003replace 	col4	=812	if	country ==	"Kiribati" & year==2003replace 	col4	=636	if	country ==	"Kuwait" & year==2003replace 	col4	=83	if	country ==	"Kyrgyz Republic" & year==2003replace 	col4	=684	if	country ==	"Laos" & year==2003replace 	col4	=54	if	country ==	"Latvia" & year==2003replace 	col4	=604	if	country 	=="Lebanon" & year==2003replace 	col4	=395	if	country ==	"Lesotho" & year==2003replace 	col4	=268	if	country ==	"Liberia" & year==2003replace 	col4	=216	if	country 	=="Libya" & year==2003replace 	col4	=55	if	country ==	"Lithuania" & year==2003replace 	col4	=18		if	country ==	"Luxembourg" & year==2003								replace 	col4	=743	if	country ==	"Macau" & year==2003replace 	col4	=96	if	country ==	"Macedonia" & year==2003replace 	col4	=370	if	country ==	"Madagascar" & year==2003replace 	col4	=386	if	country ==	"Malawi" & year==2003replace 	col4	=701	if	country ==	"Malaysia" & year==2003replace 	col4	=667	if	country ==	"Maldives" & year==2003replace 	col4	=232	if	country ==	"Mali" & year==2003replace 	col4=	46	if	country 	=="Malta" & year==2003replace 	col4	=228	if	country 	=="Mauritania" & year==2003replace 	col4	=373	if	country ==	"Mauritius" & year==2003replace 	col4	=412	if	country 	=="Mexico" & year==2003replace 	col4	=823	if	country ==	"Micronesia" & year==2003replace 	col4	=74	if	country ==	"Moldova" & year==2003replace 	col4	=716	if	country ==	"Mongolia" & year==2003replace 	col4	=204	if	country ==	"Morocco" & year==2003replace 	col4	=366	if	country ==	"Mozambique" & year==2003replace 	col4	=824	if	country ==	"Marshall Islands" & year==2003replace 	col4	=389	if	country ==	"Namibia" & year==2003replace 	col4	=672	if	country ==	"Nepal" & year==2003replace 	col4	=804	if	country== 	"New Zealand" & year==2003replace 	col4	=432	if	country ==	"Nicaragua" & year==2003replace 	col4	=240	if	country ==	"Niger" & year==2003replace 	col4	=288	if	country =="Nigeria" & year==2003replace 	col4	=724	if	country 	=="North Korea" & year==2003replace 	col4	=728	if	country 	=="Korea, Republic of" & year==2003replace 	col4	=28	if	country ==	"Norway" & year==2003replace 	col4	=95	if	country ==	"Kosowo" & year==2003replace 	col4	=649	if	country ==	"Oman" & year==2003replace 	col4	=662	if	country ==	"Pakistan" & year==2003replace 	col4	=442	if	country ==	"Panama" & year==2003replace 	col4	=801	if	country 	=="Papua New Guinea" & year==2003replace 	col4	=520	if	country ==	"Paraguay" & year==2003replace 	col4	=504	if	country ==	"Peru" & year==2003replace 	col4	=60	if	country ==	"Poland" & year==2003replace 	col4	=10		if	country 	=="Portugal" & year==2003replace 	col4	=644	if	country ==	"Qatar" & year==2003replace 	col4	=318	if	country ==	"Republic of Congo" & year==2003replace 	col4	=66		if	country ==	"Romania" & year==2003replace 	col4	=75		if	country== 	"Russia" & year==2003replace 	col4	=324	if	country 	=="Rwanda" & year==2003replace 	col4	=465	if	country 	=="Saint Lucia" & year==2003replace 	col4	=467	if	country 	=="Saint Vincent and the Grenadines" & year==2003replace 	col4	=819	if	country 	=="Samoa" & year==2003replace 	col4	=311	if	country ==	"Sao Tome and Principe" & year==2003replace 	col4	=632	if	country ==	"Saudi Arabia" & year==2003replace 	col4	=248	if	country 	=="Senegal" & year==2003replace 	col4	=94		if	country 	=="Serbia"	 & year==2003replace 	col4	=355	if	country ==	"Seychelles" & year==2003replace 	col4	=264	if	country ==	"Sierra Leone"	 & year==2003replace 	col4	=706	if	country ==	"Singapore"	 & year==2003replace 	col4	=63		if	country ==	"Slovakia"	 & year==2003replace 	col4	=91		if	country 	=="Slovenia"	 & year==2003replace    	col4	=806 	if country=="Solomon Islands" & year==2003replace 	col4	=388	if	country ==	"South Africa" & year==2003replace 	col4	=11		if	country ==	"Spain"	 & year==2003replace 	col4	=669	if	country 	=="Sri Lanka"	 & year==2003replace 	col4	=224	if	country 	=="Sudan"	 & year==2003replace 	col4	=492	if	country 	=="Suriname"	 & year==2003replace 	col4	=393	if	country 	=="Swaziland"	 & year==2003replace 	col4	=30		if	country 	=="Sweden"	 & year==2003replace 	col4	=39		if	country 	=="Switzerland"	 & year==2003replace 	col4	=608	if	country 	=="Syria"	 & year==2003replace 	col4	=736	if	country 	=="Taiwan"	 & year==2003replace 	col4	=82		if	country 	=="Tajikistan"	 & year==2003replace 	col4	=352	if	country 	=="Tanzania"	 & year==2003replace 	col4	=680	if	country 	=="Thailand"	 & year==2003replace 	col4	=252	if	country 	=="The Gambia" & year==2003replace 	col4	=3	if	country =="The Netherlands" & year==2003replace 	col4	=708	if	country ==	"The Philippines" & year==2003replace 	col4	=453	if	country ==	"The Bahamas" & year==2003replace     col4	=626 	if country =="TimorLeste" & year==2003replace 	col4	=280	if	country 	=="Togo"	 & year==2003replace 	col4	=817	if	country =="Tonga"	 & year==2003replace 	col4	=472	if	country 	=="Trinidad and Tobago"	 & year==2003replace 	col4	=212	if	country 	=="Tunisia"	 & year==2003replace 	col4	=52	if	country ==	"Turkey"	 & year==2003replace 	col4	=80	if	country ==	"Turkmenistan"	 & year==2003replace 	col4	=350	if	country 	=="Uganda"	 & year==2003replace 	col4	=72	if	country ==	"Ukraine"	 & year==2003replace 	col4	=647	if	country 	=="United Arab Emirates" & year==2003replace 	col4	=6		if	country 	=="United Kingdom" & year==2003replace 	col4	=400	if	country 	=="United States"	 & year==2003replace 	col4	=524	if	country ==	"Uruguay"	 & year==2003replace 	col4	=81	if	country =="Uzbekistan"	 & year==2003replace 	col4	=816	if	country ==	"Vanuatu"	 & year==2003replace 	col4	=484	if	country ==	"Venezuela"	 & year==2003replace 	col4	=690	if	country ==	"Vietnam"	 & year==2003replace 	col4	=653	if	country ==	"Yemen"	 & year==2003replace 	col4	=378	if	country ==	"Zambia"	 & year==2003replace 	col4	=382	if	country ==	"Zimbabwe"	 & year==2003replace 	col4	=825	if	country ==	"Palau" & year==2003replace 	col4	=342	if	country 	=="Somalia"	 & year==2003replace 	col4	=449	if	country 	=="St. Kitts & Nevis" & year==2003replace 	col4	=446	if	country 	=="Anguilla" & year==2003replace col4=474 if country=="Aruba"	& year==2003replace col4=463 if country=="Cayman"	& year==2003replace col4=837 if country=="Cook"	& year==2003replace col4=95 if country=="Kosowo"	& year==2003replace col4=37 if country=="Liechtenstein"	& year==2003replace col4=462 if country=="Martinique"	& year==2003replace col4=94 if country=="Montenegro"	& year==2003replace col4=676 if country=="Myanmair"	& year==2003replace col4=803 if country=="Nauru"	& year==2003replace col4=809 if country=="New Caledonia"	& year==2003replace col4=838 if country=="Niue"	& year==2003replace col4=807 if country=="Tuvalu"	& year==2003replace col4=831 if country=="Guam"	& year==2003replace 	col4=743	if	country=="Macao"	& year==2003replace 	col4=377	if	country=="Mayotte"	& year==2003replace 	col4=736	if	country=="Taiwan"	& year==2003drop if col4==.rename col4 numcountryrename product hs6keep if dutytype=="AHS"keep numcountry tariff hs6rename numcountry countrysort country hs6save TARIFF.dta, replace