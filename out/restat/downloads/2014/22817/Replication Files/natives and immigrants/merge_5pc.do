#delimit;
clear;
set memory 500m;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\native and immigrants\";

use census00_5pc_1a_all.dta;
sort datanum serial pernum;
save census00_5pc_1a_all.dta, replace;
clear;
use census00_5pc_2c_all.dta;
sort datanum serial pernum;
save census00_5pc_2c_all.dta, replace;
clear;

use census00_5pc_1b_all.dta;
sort datanum serial pernum;
merge datanum serial pernum using census00_5pc_1a_all.dta;
drop _merge;
sort datanum serial pernum;
merge datanum serial pernum using census00_5pc_2c_all.dta;
drop pwcity;
keep if _merge==3;
drop _merge;
drop if empstatd>=20 & empstatd<35;
drop if occ1990>900;
drop if pwmetro==0;
save census00_5pc_all.dta, replace;

#delimit;
use census00_5pc_all.dta, replace;
sort datanum serial pernum;
merge datanum serial pernum using census00_5pc_gender_all.dta;
keep if _merge==3;
drop _merge;
save census00_5pc_all.dta, replace;


/*******1990*********/
clear;
use census90_5pc_2c_all.dta;
sort datanum serial pernum;
save census90_5pc_2c_all.dta, replace;
clear;

use census90_5pc_1_all.dta;
sort datanum serial pernum;
merge datanum serial pernum using census90_5pc_2c_all.dta;
drop pwcity;
keep if _merge==3;
drop _merge;
drop if empstatd>=20 & empstatd<35;
drop if occ1990>900;
drop if pwmetro==0;
save census90_5pc_all.dta, replace;

#delimit;
use census90_5pc_all.dta, replace;
sort datanum serial pernum;
merge datanum serial pernum using census90_5pc_gender_all.dta;
keep if _merge==3;
drop _merge;
save census90_5pc_all.dta, replace;



/*********1980**********/
use census80_5pc_2c_all.dta;
sort datanum serial pernum;
save census80_5pc_2c_all.dta, replace;
clear;

use census80_5pc_1_all.dta;
sort datanum serial pernum;
merge datanum serial pernum using census80_5pc_2c_all.dta;
drop pwcity;
keep if _merge==3;
drop _merge;
drop if empstatd>=20 & empstatd<35;
drop if occ1990>900;
drop if pwmetro==0;
save census80_5pc_all.dta, replace;

/***************2000*****************/
#delimit;
clear;
use census00_3a.dta;
sort datanum serial pernum;
save census00_3a.dta, replace;
clear;
use census00_5pc_all.dta;
sort datanum serial pernum;
merge datanum serial pernum using census00_3a.dta;
drop _merge;
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
save census00_5pc_all.dta, replace;


/***************1990*****************/
#delimit;
clear;
use census90_3a.dta;
sort datanum serial pernum;
save census90_3a.dta, replace;
clear;
use census90_5pc_all.dta;
sort datanum serial pernum;
merge datanum serial pernum using census90_3a.dta;
drop _merge;
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
save census90_5pc_all.dta, replace;


/***************1980*****************/
#delimit;
clear;
use census80_3a.dta;
sort datanum serial pernum;
save census80_3a.dta, replace;
clear;
use census80_5pc_all.dta;
sort datanum serial pernum;
merge datanum serial pernum using census80_3a.dta;
drop _merge;
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
label define bpllbl 	71040	"Oceania/Usterritories"	, modify;label values bpl bpllbl;

save census80_5pc_all.dta, replace;

#delimit;
use census80_5pc_all.dta, replace;
sort datanum serial pernum;
merge datanum serial pernum using census80_5pc_gender_all.dta;
keep if _merge==3;
drop _merge;
save census80_5pc_all.dta, replace;





