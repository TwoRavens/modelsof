#delimit;
clear;
set memory 200m;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist";

/********1970*******/
use "native and immigrants\census70.dta";
rename bpl bpl1;
generate bpl=bpl1;
replace bpl=bpld if 	bpld== 	52110	| 
	bpld== 	26046	| 
	bpld== 	26041	| 
	bpld== 	26042	| 
	bpld== 	26071	| 
	bpld== 	26043	| 
	bpld== 	26044	| 
	bpld== 	21010	| 
	bpld== 	52120	| 
	bpld== 	26073	| 
	bpld== 	60091	| 
	bpld== 	26045	| 
	bpld== 	60041	| 
	bpld== 	26053	| 
	bpld== 	60074	| 
	bpld== 	60042	| 
	bpld== 	60075	| 
	bpld== 	26047	| 
	bpld== 	21020	| 
	bpld== 	26074	| 
	bpld== 	60043	| 
	bpld== 	26054	| 
	bpld== 	26010	| 
	bpld== 	26075	| 
	bpld== 	21030	| 
	bpld== 	60044	| 
	bpld== 	26080	| 
	bpld== 	60077	| 
	bpld== 	60022	| 
	bpld== 	60023	| 
	bpld== 	26055	| 
	bpld== 	26081	| 
	bpld== 	21040	| 
	bpld== 	60024	| 
	bpld== 	60025	| 
	bpld== 	26020	| 
	bpld== 	21050	| 
	bpld== 	60026	| 
	bpld== 	26030	| 
	bpld== 	26048	| 
	bpld== 	60045	| 
	bpld== 	60092	| 
	bpld== 	60027	| 
	bpld== 	60046	| 
	bpld== 	60047	| 
	bpld== 	60028	| 
	bpld== 	26082	| 
	bpld== 	60029	| 
	bpld== 	60048	| 
	bpld== 	26056	| 
	bpld== 	60049	| 
	bpld== 	52130	| 
	bpld== 	60093	| 
	bpld== 	26072	| 
	bpld== 	21060	| 
	bpld== 	60030	| 
	bpld== 	60031	| 
	bpld== 	52140	| 
	bpld== 	21070	| 
	bpld== 	26049	| 
	bpld== 	60051	| 
	bpld== 	26076	| 
	bpld== 	60032	| 
	bpld== 	60052	| 
	bpld== 	60033	| 
	bpld== 	60053	| 
	bpld== 	60094	| 
	bpld== 	52150	| 
	bpld== 	26083	| 
	bpld== 	26077	| 
	bpld== 	26057	| 
	bpld== 	26058	| 
	bpld== 	26059	| 
	bpld== 	60095	| 
	bpld== 	60054	| 
	bpld== 	60034	| 
	bpld== 	26050	| 
	bpld== 	26060	| 
	bpld== 	26061	| 
	bpld== 	60055	| 
	bpld== 	26051	| 
	bpld== 	60079	| 
	bpld== 	60056	| 
	bpld== 	60057	| 
	bpld== 	30005	| 
	bpld== 	30010	| 
	bpld== 	30015	| 
	bpld== 	30020	| 
	bpld== 	30025	| 
	bpld== 	30030	| 
	bpld== 	30035	| 
	bpld== 	30040	| 
	bpld== 	30045	| 
	bpld== 	30050	| 
	bpld== 	30055	| 
	bpld== 	30060	| 
	bpld== 	30065	| 
	bpld== 	60011	| 
	bpld== 	60012	| 
	bpld== 	60013	| 
	bpld== 	60014	| 
	bpld== 	60015	| 
	bpld== 	60016	| 
	bpld== 	60017	| 
	bpld== 	60020	| 
	bpld== 	60021	|
bpld== 	50210	| 
bpld== 	50220	| 
bpld== 	53440	| 
bpld== 	53410	| 
bpld== 	53430	| 
bpld== 	60065	| 
bpld== 	60071	| 
bpld== 	60072	| 
bpld== 	60073	| 
bpld== 	60076	| 
bpld== 	71021	| 
bpld== 	71023	| 
bpld== 	71025	| 
bpld== 	71029	| 
bpld== 	71012	; 

replace bpl=	71029	 if bpld==	71029	|	
		bpld==	71020	|	
		bpld==	71022	|	
		 bpld==	71024	|	
		 bpld==	71025	;	
					
replace bpl=	71039	 if bpld>=71030 & bpld<=71039			;
replace bpl=	71040	 if bpld>=71040 & bpld<=71049			;



label define bpllbl 	52110	" Bangladesh"	, modify;
label define bpllbl 	26046	"Anegada"	, modify;
label define bpllbl 	26041	"Anguilla"	, modify;
label define bpllbl 	26042	"Antigua-Barbuda"	, modify;
label define bpllbl 	26071	"Aruba"	, modify;
label define bpllbl 	26043	"Bahamas"	, modify;
label define bpllbl 	26044	"Barbados"	, modify;
label define bpllbl 	21010	"Belize"	, modify;
label define bpllbl 	52120	"Bhutan"	, modify;
label define bpllbl 	26073	"Bonaire"	, modify;
label define bpllbl 	60091	"Botswana"	, modify;
label define bpllbl 	26045	"British Virgin Islands"	, modify;
label define bpllbl 	60041	"Burundi"	, modify;
label define bpllbl 	26053	"Cayman Isles"	, modify;
label define bpllbl 	60074	"Chad"	, modify;
label define bpllbl 	60042	"Comoros"	, modify;
label define bpllbl 	60075	"Congo"	, modify;
label define bpllbl 	26047	"Cooper"	, modify;
label define bpllbl 	21020	"Costa Rica"	, modify;
label define bpllbl 	26074	"Curacao"	, modify;
label define bpllbl 	60043	"Djibouti"	, modify;
label define bpllbl 	26054	"Dominica"	, modify;
label define bpllbl 	26010	"Dominican Republic"	, modify;
label define bpllbl 	26075	"Dutch St. Maarten"	, modify;
label define bpllbl 	21030	"El Salvador"	, modify;
label define bpllbl 	60044	"Ethiopia"	, modify;
label define bpllbl 	26080	"French St. Maarten"	, modify;
label define bpllbl 	60077	"Gabon"	, modify;
label define bpllbl 	60022	"Gambia"	, modify;
label define bpllbl 	60023	"Ghana"	, modify;
label define bpllbl 	26055	"Grenada"	, modify;
label define bpllbl 	26081	"Guadeloupe"	, modify;
label define bpllbl 	21040	"Guatemala"	, modify;
label define bpllbl 	60024	"Guinea"	, modify;
label define bpllbl 	60025	"Guinea-Bissau"	, modify;
label define bpllbl 	26020	"Haiti"	, modify;
label define bpllbl 	21050	"Honduras"	, modify;
label define bpllbl 	60026	"Ivory Coast"	, modify;
label define bpllbl 	26030	"Jamaica"	, modify;
label define bpllbl 	26048	"Jost Van Dyke"	, modify;
label define bpllbl 	60045	"Kenya"	, modify;
label define bpllbl 	60092	"Lesotho"	, modify;
label define bpllbl 	60027	"Liberia"	, modify;
label define bpllbl 	60046	"Madagascar"	, modify;
label define bpllbl 	60047	"Malawi"	, modify;
label define bpllbl 	60028	"Mali"	, modify;
label define bpllbl 	26082	"Martinique"	, modify;
label define bpllbl 	60029	"Mauritania"	, modify;
label define bpllbl 	60048	"Mauritius"	, modify;
label define bpllbl 	26056	"Montserrat"	, modify;
label define bpllbl 	60049	"Mozambique"	, modify;
label define bpllbl 	52130	"Myanmar"	, modify;
label define bpllbl 	60093	"Namibia"	, modify;
label define bpllbl 	26072	"Netherlands Antilles"	, modify;
label define bpllbl 	21060	"Nicaragua"	, modify;
label define bpllbl 	60030	"Niger"	, modify;
label define bpllbl 	60031	"Nigeria"	, modify;
label define bpllbl 	52140	"Pakistan"	, modify;
label define bpllbl 	21070	"Panama"	, modify;
label define bpllbl 	26049	"Peter"	, modify;
label define bpllbl 	60051	"Rwanda"	, modify;
label define bpllbl 	26076	"Saba"	, modify;
label define bpllbl 	60032	"Senegal"	, modify;
label define bpllbl 	60052	"Seychelles"	, modify;
label define bpllbl 	60033	"Sierra Leone"	, modify;
label define bpllbl 	60053	"Somalia"	, modify;
label define bpllbl 	60094	"South Africa "	, modify;
label define bpllbl 	52150	"Sri Lanka "	, modify;
label define bpllbl 	26083	"St. Barthelemy"	, modify;
label define bpllbl 	26077	"St. Eustatius"	, modify;
label define bpllbl 	26057	"St. Kitts-Nevis"	, modify;
label define bpllbl 	26058	"St. Lucia"	, modify;
label define bpllbl 	26059	"St. Vincent"	, modify;
label define bpllbl 	60095	"Swaziland"	, modify;
label define bpllbl 	60054	"Tanzania"	, modify;
label define bpllbl 	60034	"Togo"	, modify;
label define bpllbl 	26050	"Tortola"	, modify;
label define bpllbl 	26060	"Trinidad and Tobago"	, modify;
label define bpllbl 	26061	"Turks and Caicos"	, modify;
label define bpllbl 	60055	"Uganda"	, modify;
label define bpllbl 	26051	"Virgin Gorda"	, modify;
label define bpllbl 	60079	"Zaire"	, modify;
label define bpllbl 	60056	"Zambia"	, modify;
label define bpllbl 	60057	"Zimbabwe"	, modify;
label define bpllbl 	30005	"Argentina"	, modify;
label define bpllbl 	30010	"Bolivia"	, modify;
label define bpllbl 	30015	"Brazil"	, modify;
label define bpllbl 	30020	"Chile"	, modify;
label define bpllbl 	30025	"Colombia"	, modify;
label define bpllbl 	30030	"Ecuador"	, modify;
label define bpllbl 	30035	"French Guiana"	, modify;
label define bpllbl 	30040	"Guyana/British Guiana"	, modify;
label define bpllbl 	30045	"Paraguay"	, modify;
label define bpllbl 	30050	"Peru"	, modify;
label define bpllbl 	30055	"Suriname"	, modify;
label define bpllbl 	30060	"Uruguay"	, modify;
label define bpllbl 	30065	"Venezuela"	, modify;
label define bpllbl 	60011	"Algeria"	, modify;
label define bpllbl 	60012	"Egypt"	, modify;
label define bpllbl 	60013	"Libya"	, modify;
label define bpllbl 	60014	"Morocco"	, modify;
label define bpllbl 	60015	"Sudan"	, modify;
label define bpllbl 	60016	"Tunisia"	, modify;
label define bpllbl 	60017	"Western Sahara"	, modify;
label define bpllbl 	60020	"Benin"	, modify;
label define bpllbl 	60021	"Burkina Faso"	, modify;

label define bpllbl 	50210	"North Korea"	, modify;
label define bpllbl 	50220	"South Korea"	, modify;
label define bpllbl 	53440	"Israel"	, modify;
label define bpllbl 	53410	"Gaza Strip"	, modify;
label define bpllbl 	53430	"West Bank"	, modify;
label define bpllbl 	60065	"Eritrea"	, modify;
label define bpllbl 	60071	"Angola"	, modify;
label define bpllbl 	60072	"Cameroon"	, modify;
label define bpllbl 	60073	"Central African Republic"	, modify;
label define bpllbl 	60076	"Equatorial Guinea"	, modify;
label define bpllbl 	71021	"Fiji"	, modify;
label define bpllbl 	71023	"Tonga"	, modify;
label define bpllbl 	71025	"Western Samoa"	, modify;
label define bpllbl 	71029	"Polynesia, n.s."	, modify;
label define bpllbl 	71012	"Papua New Guinea"	, modify;
label define bpllbl 	71029	"Polynesia"	, modify;
label define bpllbl 	71039	"Micronesia"	, modify;
label define bpllbl 	71040	"Oceania/Usterritories"	, modify;
label values bpl bpllbl;

drop if empstatd>=20 & empstatd<35;
drop if occ1990>900;
drop if metaread==0;

replace bpl=1 if bpl>=1 & bpl<=99;
generate pop_unwght=1;
generate pop_wght=perwt;
collapse (sum) pop_unwght pop_wght, by (metaread occ1990 bpl);

/*metroarea population (total immigrant)*/
by  metaread, sort: egen metpop_imm1=sum( pop_unwght) if bpl!=1;
by  metaread, sort: egen metpop_imm=median(metpop_imm1);
by  metaread, sort: egen metpop_imm_wt1=sum( pop_wght) if bpl!=1;
by  metaread, sort: egen metpop_imm_wt=median(metpop_imm_wt1);
by  metaread, sort: egen metpop_nat1=sum( pop_unwght) if bpl==1;
by  metaread, sort: egen metpop_nat=median(metpop_nat1);
by  metaread, sort: egen metpop_nat_wt1=sum( pop_wght) if bpl==1;
by  metaread, sort: egen metpop_nat_wt=median(metpop_nat_wt1);
by  metaread, sort: egen metpop_total=sum( pop_unwght);
by  metaread, sort: egen metpop_total_wt=sum( pop_wght);
drop metpop_imm1 metpop_imm_wt1 metpop_nat1 metpop_nat_wt1;

/*metroarea populaiton by country and percent of each country in metro immigrant population*/
by  metaread  bpl, sort: egen metpop_country=sum( pop_unwght);
by  metaread  bpl, sort: egen metpop_country_wt=sum( pop_wght);
by  metaread  bpl, sort: generate p_metpop_imm_wt= metpop_country_wt/ metpop_imm_wt;
by  metaread  bpl, sort: generate p_metpop_total_wt= metpop_country_wt/ metpop_total_wt;
by  metaread  bpl, sort: generate p_metpop_total= metpop_country/ metpop_total;

/*metroarea population by occupation*/
by  metaread occ1990, sort: egen metoccpop_imm1=sum( pop_unwght) if bpl!=1;
by  metaread occ1990, sort: egen metoccpop_imm=median(metoccpop_imm1);
by  metaread occ1990, sort: egen metoccpop_imm_wt1=sum( pop_wght) if bpl!=1;
by  metaread occ1990, sort: egen metoccpop_imm_wt=median(metoccpop_imm_wt1);
by  metaread occ1990, sort: egen metoccpop_nat1=sum( pop_unwght) if bpl==1;
by  metaread occ1990, sort: egen metoccpop_nat=median(metoccpop_nat1);
by  metaread occ1990, sort: egen metoccpop_nat_wt1=sum( pop_wght) if bpl==1;
by  metaread occ1990, sort: egen metoccpop_nat_wt=median(metoccpop_nat_wt1);
by  metaread occ1990, sort: egen metoccpop_total=sum( pop_unwght);
by  metaread occ1990, sort: egen metoccpop_total_wt=sum( pop_wght);
drop metoccpop_imm1 metoccpop_imm_wt1 metoccpop_nat1 metoccpop_nat_wt1;

/* percent of occupation by ethnicity */
by  metaread occ1990 bpl, sort: generate p_occ_countrymet70=pop_unwght/metpop_country;
by  metaread occ1990 bpl, sort: generate p_occ_countrymet70_wt=pop_wght/metpop_country_wt;

/*percent of occupation by immigrant vs. native */
by metaread occ1990, sort: generate p_occ_imm_met70=metoccpop_imm/metpop_imm;
by metaread occ1990, sort: generate p_occ_imm_met70_wt=metoccpop_imm_wt/metpop_imm_wt;
by metaread occ1990, sort: generate p_occ_nat_met70=metoccpop_nat/metpop_nat;
by metaread occ1990, sort: generate p_occ_nat_met70_wt=metoccpop_nat_wt/metpop_nat_wt;

/*percent of occupation that is native */
generate p_native_occ70=metoccpop_nat/metoccpop_total;
generate p_native_occ70_wt=metoccpop_nat_wt/metoccpop_total_wt;

/*percent of occupation in metroarea*/
generate p_occ_met70=metoccpop_total/metpop_total;
generate p_occ_met70_wt=metoccpop_total_wt/metpop_total_wt;

rename metaread pwmetro;
keep pwmetro occ1990 bpl p_occ_countrymet70 p_occ_countrymet70_wt p_occ_imm_met70 p_occ_imm_met70_wt p_occ_nat_met70 p_occ_nat_met70_wt p_native_occ70 p_native_occ70_wt p_occ_met70 p_occ_met70_wt;

label define bpllbl 1 "US", modify;

 sort occ1990 pwmetro bpl;
save "reg1\census70_occdist.dta", replace;



/********** 1980 *********/

use "native and immigrants\census80_5pc_all";
replace bpl=1 if bpl>=1 & bpl<=99;
label define bpllbl 1 "US", modify;
generate pop_unwght=1;
generate pop_wght=perwt;
collapse (sum) pop_unwght pop_wght, by (pwmetro occ1990 bpl);

/*metroarea population (total immigrant)*/
by  pwmetro, sort: egen metpop_imm1=sum( pop_unwght) if bpl!=1;
by  pwmetro, sort: egen metpop_imm=median(metpop_imm1);
by  pwmetro, sort: egen metpop_imm_wt1=sum( pop_wght) if bpl!=1;
by  pwmetro, sort: egen metpop_imm_wt=median(metpop_imm_wt1);
by  pwmetro, sort: egen metpop_nat1=sum( pop_unwght) if bpl==1;
by  pwmetro, sort: egen metpop_nat=median(metpop_nat1);
by  pwmetro, sort: egen metpop_nat_wt1=sum( pop_wght) if bpl==1;
by  pwmetro, sort: egen metpop_nat_wt=median(metpop_nat_wt1);
by  pwmetro, sort: egen metpop_total=sum( pop_unwght);
by  pwmetro, sort: egen metpop_total_wt=sum( pop_wght);
drop metpop_imm1 metpop_imm_wt1 metpop_nat1 metpop_nat_wt1;

/*metroarea populaiton by country and percent of each country in metro immigrant population*/
by  pwmetro  bpl, sort: egen metpop_country=sum( pop_unwght);
by  pwmetro  bpl, sort: egen metpop_country_wt=sum( pop_wght);
by  pwmetro  bpl, sort: generate p_metpop_imm_wt= metpop_country_wt/ metpop_imm_wt;
by  pwmetro  bpl, sort: generate p_metpop_total_wt= metpop_country_wt/ metpop_total_wt;
by  pwmetro  bpl, sort: generate p_metpop_total= metpop_country/ metpop_total;

/*metroarea population by occupation*/
by  pwmetro occ1990, sort: egen metoccpop_imm1=sum( pop_unwght) if bpl!=1;
by  pwmetro occ1990, sort: egen metoccpop_imm=median(metoccpop_imm1);
by  pwmetro occ1990, sort: egen metoccpop_imm_wt1=sum( pop_wght) if bpl!=1;
by  pwmetro occ1990, sort: egen metoccpop_imm_wt=median(metoccpop_imm_wt1);
by  pwmetro occ1990, sort: egen metoccpop_nat1=sum( pop_unwght) if bpl==1;
by  pwmetro occ1990, sort: egen metoccpop_nat=median(metoccpop_nat1);
by  pwmetro occ1990, sort: egen metoccpop_nat_wt1=sum( pop_wght) if bpl==1;
by  pwmetro occ1990, sort: egen metoccpop_nat_wt=median(metoccpop_nat_wt1);
by  pwmetro occ1990, sort: egen metoccpop_total=sum( pop_unwght);
by  pwmetro occ1990, sort: egen metoccpop_total_wt=sum( pop_wght);
drop metoccpop_imm1 metoccpop_imm_wt1 metoccpop_nat1 metoccpop_nat_wt1;

/* percent of occupation by ethnicity */
by  pwmetro occ1990 bpl, sort: generate p_occ_countrymet80=pop_unwght/metpop_country;
by  pwmetro occ1990 bpl, sort: generate p_occ_countrymet80_wt=pop_wght/metpop_country_wt;

/*percent of occupation by immigrant vs. native */
by pwmetro occ1990, sort: generate p_occ_imm_met80=metoccpop_imm/metpop_imm;
by pwmetro occ1990, sort: generate p_occ_imm_met80_wt=metoccpop_imm_wt/metpop_imm_wt;
by pwmetro occ1990, sort: generate p_occ_nat_met80=metoccpop_nat/metpop_nat;
by pwmetro occ1990, sort: generate p_occ_nat_met80_wt=metoccpop_nat_wt/metpop_nat_wt;

/*percent of occupation that is native */
generate p_native_occ80=metoccpop_nat/metoccpop_total;
generate p_native_occ80_wt=metoccpop_nat_wt/metoccpop_total_wt;

/*percent of occupation in metroarea*/
generate p_occ_met80=metoccpop_total/metpop_total;
generate p_occ_met80_wt=metoccpop_total_wt/metpop_total_wt;


keep pwmetro occ1990 bpl p_occ_countrymet80 p_occ_countrymet80_wt p_occ_imm_met80 p_occ_imm_met80_wt p_occ_nat_met80 p_occ_nat_met80_wt  p_native_occ80  p_native_occ80_wt  p_occ_met80 p_occ_met80_wt;

label define bpllbl 1 "US", modify;

 sort occ1990 pwmetro bpl;
save "reg1\census80_occdist.dta", replace;



/********1990 *********/
use "native and immigrants\census90_5pc_all";
replace bpl=1 if bpl>=1 & bpl<=99;
label define bpllbl 1 "US", modify;
generate pop_unwght=1;
generate pop_wght=perwt;
collapse (sum) pop_unwght pop_wght, by (pwmetro occ1990 bpl);

/*metroarea population (total immigrant)*/
by  pwmetro, sort: egen metpop_imm1=sum( pop_unwght) if bpl!=1;
by  pwmetro, sort: egen metpop_imm=median(metpop_imm1);
by  pwmetro, sort: egen metpop_imm_wt1=sum( pop_wght) if bpl!=1;
by  pwmetro, sort: egen metpop_imm_wt=median(metpop_imm_wt1);
by  pwmetro, sort: egen metpop_nat1=sum( pop_unwght) if bpl==1;
by  pwmetro, sort: egen metpop_nat=median(metpop_nat1);
by  pwmetro, sort: egen metpop_nat_wt1=sum( pop_wght) if bpl==1;
by  pwmetro, sort: egen metpop_nat_wt=median(metpop_nat_wt1);
by  pwmetro, sort: egen metpop_total=sum( pop_unwght);
by  pwmetro, sort: egen metpop_total_wt=sum( pop_wght);
drop metpop_imm1 metpop_imm_wt1 metpop_nat1 metpop_nat_wt1;

/*metroarea populaiton by country and percent of each country in metro immigrant population*/
by  pwmetro  bpl, sort: egen metpop_country=sum( pop_unwght);
by  pwmetro  bpl, sort: egen metpop_country_wt=sum( pop_wght);
by  pwmetro  bpl, sort: generate p_metpop_imm_wt= metpop_country_wt/ metpop_imm_wt;
by  pwmetro  bpl, sort: generate p_metpop_total_wt= metpop_country_wt/ metpop_total_wt;
by  pwmetro  bpl, sort: generate p_metpop_total= metpop_country/ metpop_total;

/*metroarea population by occupation*/
by  pwmetro occ1990, sort: egen metoccpop_imm1=sum( pop_unwght) if bpl!=1;
by  pwmetro occ1990, sort: egen metoccpop_imm=median(metoccpop_imm1);
by  pwmetro occ1990, sort: egen metoccpop_imm_wt1=sum( pop_wght) if bpl!=1;
by  pwmetro occ1990, sort: egen metoccpop_imm_wt=median(metoccpop_imm_wt1);
by  pwmetro occ1990, sort: egen metoccpop_nat1=sum( pop_unwght) if bpl==1;
by  pwmetro occ1990, sort: egen metoccpop_nat=median(metoccpop_nat1);
by  pwmetro occ1990, sort: egen metoccpop_nat_wt1=sum( pop_wght) if bpl==1;
by  pwmetro occ1990, sort: egen metoccpop_nat_wt=median(metoccpop_nat_wt1);
by  pwmetro occ1990, sort: egen metoccpop_total=sum( pop_unwght);
by  pwmetro occ1990, sort: egen metoccpop_total_wt=sum( pop_wght);
drop metoccpop_imm1 metoccpop_imm_wt1 metoccpop_nat1 metoccpop_nat_wt1;

/* percent of occupation by ethnicity */
by  pwmetro occ1990 bpl, sort: generate p_occ_countrymet90=pop_unwght/metpop_country;
by  pwmetro occ1990 bpl, sort: generate p_occ_countrymet90_wt=pop_wght/metpop_country_wt;

/*percent of occupation by immigrant vs. native */
by pwmetro occ1990, sort: generate p_occ_imm_met90=metoccpop_imm/metpop_imm;
by pwmetro occ1990, sort: generate p_occ_imm_met90_wt=metoccpop_imm_wt/metpop_imm_wt;
by pwmetro occ1990, sort: generate p_occ_nat_met90=metoccpop_nat/metpop_nat;
by pwmetro occ1990, sort: generate p_occ_nat_met90_wt=metoccpop_nat_wt/metpop_nat_wt;

/*percent of occupation that is native */
generate p_native_occ90=metoccpop_nat/metoccpop_total;
generate p_native_occ90_wt=metoccpop_nat_wt/metoccpop_total_wt;

/*percent of occupation in metroarea*/
generate p_occ_met90=metoccpop_total/metpop_total;
generate p_occ_met90_wt=metoccpop_total_wt/metpop_total_wt;



keep pwmetro occ1990 bpl p_occ_countrymet90 p_occ_countrymet90_wt p_occ_imm_met90 p_occ_imm_met90_wt p_occ_nat_met90 p_occ_nat_met90_wt  p_native_occ90  p_native_occ90_wt  p_occ_met90 p_occ_met90_wt;

label define bpllbl 1 "US", modify;

 sort occ1990 pwmetro bpl;
save "reg1\census90_occdist.dta", replace;

