global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/"

# delimit ;

capture log close;
clear;
set mem 1400m;
set more off;

use ${x}wagetables.dta;

keep if year==1983|year==1984|year==2001|year==2002;
keep lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_lrpiship79 age female union exper nonwhite _Iyear* _Ieduc* _Iman7090_o* year ihwt man7090_orig;

log using ${z}figure1.log, replace;
*****************;
* 1983 and 1984 *;
*****************;
reg lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_lrpiship79 age female union exper nonwhite _Iyear* _Ieduc* _Iman7090_o* if year==1983|year==1984 [weight=ihwt], robust cluster(man7090_orig);

******************************;
* Dropped from regression:   *;
* _Iman7090_o_11		 *;
******************************;
global numlist "2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 60 61 62 63 64 65 66 67 68 69 70";

foreach j of global numlist{ ;
	gen m`j'=_b[_Iman7090_o_`j'];
};

egen mean8384=rowmean(m2 m3 m4 m5 m6 m7 m8 m9 m10 m12 m13 m14 m15 m16 m17 m18 m19 m20 m21 m22 m23 m24 m25 m26 m27 m29 m30 m31 m32 m33 m34 m35 m36 m37 m38 m39 m40 m41 m42 m43 m44 m45 m46 m47 m48 m49 m50 m51 m52 m53 m54 m55 m56 m57 m58 m60 m61 m62 m63 m64 m65 m66 m67 m68 m69 m70);

foreach j of global numlist{ ;
	gen dev`j'_8384=m`j'-mean8384;
};

*****************;
* 2001 and 2002 *;
*****************;
reg lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_lrpiship79 age female union exper nonwhite _Iyear* _Ieduc* _Iman7090_o* if year==2001|year==2002 [weight=ihwt], robust cluster(man7090_orig);


*************************************************************;
* Dropped from regression:   				     *;
* _Iman7090_o_5, 11, 20, 25, 35, 53, 62, 68 		     *;
*************************************************************;
global numlist2 "2 3 4 6 7 8 9 10 12 13 14 15 16 17 18 19 21 22 23 24 26 27 29 30 31 32 33 34 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 54 55 56 57 58 60 61 63 64 65 66 67 69 70";

foreach j of global numlist2{ ;
	gen n`j'=_b[_Iman7090_o_`j'];
};

egen mean0102=rowmean(n2 n3 n4 n6 n7 n8 n9 n10 n12 n13 n14 n15 n16 n17 n18 n19 n21 n22 n23 n24 n26 n27 n29 n30 n31 n32 n33 n34 n36 n37 n38 n39 n40 n41 n42 n43 n44 n45 n46 n47 n48 n49 n50 n51 n52 n54 n55 n56 n57 n58 n60 n61 n63 n64 n65 n66 n67 n69 n70);

foreach j of global numlist2{ ;
	gen dev`j'_0102=n`j'-mean0102;
};


keep man7090_orig dev*_8384 dev*_0102;

*************************************************************;
* Keep industries included in both regressions:   	     *;
*************************************************************;
global numlist3 "2 3 4 6 7 8 9 10 12 13 14 15 16 17 18 19 21 22 23 24 26 27 30 31 32 33 34 36 37 38 39 40 41 43 44 45 46 47 48 49 50 51 52 54 55 56 57 58 60 61 63 64 65 66 67 69 70";

drop dev5_8384 dev20_8384 dev25_8384 dev35_8384 dev53_8384 dev62_8384 dev68_8384;

bysort man7090_orig: keep if _n==1;

gen dev_8384=.;
gen dev_0102=.;
foreach j of global numlist3 {;
	replace dev_8384=dev`j'_8384 if man7090_orig==`j'; 
	replace dev_0102=dev`j'_0102 if man7090_orig==`j';
};

drop if dev_8384==. & dev_0102==.;

keep man7090_orig dev_8384 dev_0102; 

twoway scatter dev_8384 dev_0102, subtitle("Inter-Industry Wage Differentials") ytitle("1982 and 1983") ylabel(#3, labsize(small)) xtitle("2001 and 2002") scheme(sj) 
text(-.0568104	-.2483624	"Dairy products", place(e))
text(-.0158898	-.13804	"Canned and preserved fuits and vegetables", place(e))
text(.0343248		-.0326184	"Gain mill products", place(e))
text(.0094774		.152774	"Sugar and confectionary products", place(e))
text(.0196339		-.0703789	"Beverage industries", place(e))
text(-.0559583	-.0525184	"Misc. food preparations and kindred products", place(e))
text(.1722197		.0472415	"Tobacco manufactures", place(e))
text(-.1526951	.0842476	"Knitting mills", place(e))
text(-.0916393	-.0601678	"Floor coverings, except hard surfaces", place(e))
text(-.118448		.073676	"Yarn, thread, and fabric mills", place(e))
text(-.0214307	.3285664	"Misc. textile mill products", place(e))
text(-.2464573	.0035672	"Apparel and accessories, except knit", place(e))
text(-.1461847	-.0101321	"Misc. fabricated textile products", place(e))
text(.0456292		-.2539896	"Pulp, paper, and paperboard mills", place(e))
text(.0612084		.1260056	"Misc. paper and pulp products", place(e))
text(.0193792		-.0666156	"Paperboard containers and boxes", place(e))
text(-.0048658	.6269574	"Printing/publishing/allied industries except newspapers", place(e))
text(-.1002323	-.0316569	"Plastics, synthetics, and resins", place(e))
text(.0441618		-.0212873	"Drugs", place(e))
text(.0649613		-.0024465	"Soaps and cosmetics", place(e))
text(.0594001		-.0194449	"Agricultural chemicals", place(e))
text(-.0621035	-.091186	"Industrial and miscellaneous chemicals", place(e))
text(.0669599		.001037	"Other rubber products/plastics footwear/belting + Tires/Inner tubes", place(e))
text(-.1046491	-.4255499	"Misc. plastic products", place(e))
text(.1859383		-.1099851	"Leather tanning and finishing", place(e))
text(-.0667363	.0573317	"Footwear, except rubber and plastic", place(e))
text(.0548074		.2502517	"Leather products, except footwear", place(e))
text(-.1494533	-.1521649	"Sawmills, planning mills, and millwork", place(e))
text(-.1871694	.0176669	"Misc. wood products", place(e))
text(.0393824		.04601		"Furniture and fixtures", place(e))
text(.0750684		-.0177969	"Glass and glass products", place(e))
text(.0079443		-.087074	"Cement, concrete, and gypsum, and plaster products", place(e))
text(.0171457		.2337569	"Structural clay products", place(e))
text(.1101419		.2045642	"Misc. nonmetallic mineral and stone products", place(e))
text(.0302853		-.3100261	"Blast furnaces, steelworks, rolling and finishing mills", place(e))
text(.1031813		-.0324833	"Iron and stell foundaries", place(e))
text(.0677148		-.02661	"Primary aluminum industries", place(e))
text(-.0029187	-.0784904	"Cutlery, handtools, and other hardware", place(e))
text(-.0448946	-.0063233	"Fabricated structural metal products", place(e))
text(.0363048		-.0236238	"Screw machine products", place(e))
text(.0023515		-.1149921	"Metal forgings and stampings", place(e))
text(-.0217556	.0553219	"Misc. fabricated metal products", place(e))
text(.1852965		-.106209	"Engines and turbines", place(e))
text(.0663873		.2097888	"Construction and material handling machines", place(e))
text(.1332375		.0264439	"Metalworking machinery", place(e))
text(-.1027923	-.1969873	"Office and accounting machines", place(e))
text(-.0366081	.0304277	"Machinery, except electrical, n.e.c.", place(e))
text(.1003957		.1036174	"Household appliances", place(e))
text(-.1005404	-.1853053	"Eletrical machinery, equipment, and supplies, n.e.c.", place(e))
text(-.2023269	-.293541	"Transporation equipment", place(e))
text(.2425323		-.0446395	"Railroad locamotives and equipment", place(e))
text(.1175803		-.1252153	"Guided missiles/space veh./parts,Ordinance/Aircraft/parts", place(e))
text(.0164619		.0057026	"Cycles & misc. transp. equip. & Wood buildings/mobile homes", place(e))
text(-.0528677	.053341	"Radio, T.V. and communication equipment", place(e))
text(.077888		.0500931	"Optical and health services supplies", place(e))
text(-.3416987	.4208111	"Watches, clocks, and clockwork operated devices", place(e))
text(-.0678436	.0698717	"Misc. mfg industries and toys, amusement and sporting goods", place(e));


log close;
exit;
