#delimit;

set more off;

capture log close;

local t1="specify here the folder path where the data are stored";
local t2="specify here the folder path where you want the output data to be stored";

*Programme for selecting the parents with midlife daughters. This is the second sample;

log using `t1'educode2, replace;

drop _all;

set mem 400m;

use `t1'mergewave2_rel231_ext;

sort mergeid;

*It codes according to the ISCED categorization the variables for the level of education of children in Wave 2;
**ATTENTION: I IMPUTED THE VALUE 8 TO THOSE OBSERVATIONS WITH 97 IN FURTHER EDUCATION TO DISTINGUISH THEM FROM THOSE WITH 97 IN BASIC EDUCATION;

gen ch018_1=1 if ch018d1_1==1;
replace ch018_1=2 if ch018d2_1==1;
replace ch018_1=3 if ch018d3_1==1;
replace ch018_1=4 if ch018d4_1==1;
replace ch018_1=5 if ch018d5_1==1;
replace ch018_1=6 if ch018d6_1==1;
replace ch018_1=7 if ch018d7_1==1;
replace ch018_1=8 if ch018d8_1==1;
replace ch018_1=9 if ch018d9_1==1;
replace ch018_1=10 if ch018d10_1==1;
replace ch018_1=11 if ch018d11_1==1;
replace ch018_1=12 if ch018d12_1==1;
replace ch018_1=13 if ch018d13_1==1;
replace ch018_1=95 if ch018d95_1==1;
replace ch018_1=96 if ch018dno_1==1;
replace ch018_1=97 if ch018dot_1==1;
replace ch018_1=-2 if ch018d1_1==-2;
replace ch018_1=-1 if ch018d1_1==-1;

gen ch018_2=1 if ch018d1_2==1;
replace ch018_2=2 if ch018d2_2==1;
replace ch018_2=3 if ch018d3_2==1;
replace ch018_2=4 if ch018d4_2==1;
replace ch018_2=5 if ch018d5_2==1;
replace ch018_2=6 if ch018d6_2==1;
replace ch018_2=7 if ch018d7_2==1;
replace ch018_2=8 if ch018d8_2==1;
replace ch018_2=9 if ch018d9_2==1;
replace ch018_2=10 if ch018d10_2==1;
replace ch018_2=11 if ch018d11_2==1;
replace ch018_2=12 if ch018d12_2==1;
replace ch018_2=13 if ch018d13_2==1;
replace ch018_2=95 if ch018d95_2==1;
replace ch018_2=96 if ch018dno_2==1;
replace ch018_2=97 if ch018dot_2==1;
replace ch018_2=-2 if ch018d1_2==-2;
replace ch018_2=-1 if ch018d1_2==-1;


gen ch018_3=1 if ch018d1_3==1;
replace ch018_3=2 if ch018d2_3==1;
replace ch018_3=3 if ch018d3_3==1;
replace ch018_3=4 if ch018d4_3==1;
replace ch018_3=5 if ch018d5_3==1;
replace ch018_3=6 if ch018d6_3==1;
replace ch018_3=7 if ch018d7_3==1;
replace ch018_3=8 if ch018d8_3==1;
replace ch018_3=9 if ch018d9_3==1;
replace ch018_3=10 if ch018d10_3==1;
replace ch018_3=11 if ch018d11_3==1;
replace ch018_3=12 if ch018d12_3==1;
replace ch018_3=13 if ch018d13_3==1;
replace ch018_3=95 if ch018d95_3==1;
replace ch018_3=96 if ch018dno_3==1;
replace ch018_3=97 if ch018dot_3==1;
replace ch018_3=-2 if ch018d1_3==-2;
replace ch018_3=-1 if ch018d1_3==-1;


gen ch018_4=1 if ch018d1_4==1;
replace ch018_4=2 if ch018d2_4==1;
replace ch018_4=3 if ch018d3_4==1;
replace ch018_4=4 if ch018d4_4==1;
replace ch018_4=5 if ch018d5_4==1;
replace ch018_4=6 if ch018d6_4==1;
replace ch018_4=7 if ch018d7_4==1;
replace ch018_4=8 if ch018d8_4==1;
replace ch018_4=9 if ch018d9_4==1;
replace ch018_4=10 if ch018d10_4==1;
replace ch018_4=11 if ch018d11_4==1;
replace ch018_4=12 if ch018d12_4==1;
replace ch018_4=13 if ch018d13_4==1;
replace ch018_4=95 if ch018d95_4==1;
replace ch018_4=96 if ch018dno_4==1;
replace ch018_4=97 if ch018dot_4==1;
replace ch018_4=-2 if ch018d1_4==-2;
replace ch018_4=-1 if ch018d1_4==-1;

/* AUSTRIA: 
dn010_&dn021_ (highest education)
	1) Volksschule (2; 8)
	2) Hauptschule (2; 8)
	3) Gymnasium (öffentlich) mit Matura (3; 12)
	4) Gymnasium (privat) mit Matura (3; 12)
	5) Berufsbildende Schule mit Matura (HAK, HTL,...) (3; 13)
	6) Berufsbildende Schule ohne Matura (3; 11)
	95) Noch kein Abschluss/noch in Ausbildung
	96) Kein Schulabschluss
	97) Anderer Schulabschluss (auch Ausland)

dn012_&dn023_ (further education)
	1) Lehrabschlussprüfung (3;11)
	2) Meisterprüfung (3,11)
	3) Fachakademie (Sozialakademie, Krankenpflegeausbildung, Pädagog. Ausbildung, ...) (5; 15)
	4) Fachhochschulabschluss (5; 17)
	5) Universität (5; 17)
	95) Noch in Ausbildung
96) Kein Berufsabschluss
97) Anderer Abschluss (auch Ausland)
*/

gen edu1 = 0 if (ch017_1==96)&country==11; /* None */
replace edu1=2 if (ch017_1==1|ch017_1==2)&country==11; 
replace edu1=3 if (ch017_1==3|ch017_1==4|ch017_1==5|ch017_1==6)&country==11;
replace edu1=95 if (ch017_1==95)&country==11; /*Still in School */
replace edu1=97 if (ch017_1==97)&country==11; /*Other or abroad*/
replace edu1=3 if (ch018_1==1)&country==11; 
replace edu1=5 if (ch018_1==2|ch018_1==3|ch018_1==4|ch018_1==5)&country==11;
replace edu1=4 if (ch018_1==97)&country==11; /*Other or abroad*/

gen edu2 = 0 if (ch017_2==96)&country==11; /* None */
replace edu2=2 if (ch017_2==1|ch017_2==2)&country==11; 
replace edu2=3 if (ch017_2==3|ch017_2==4|ch017_2==5|ch017_2==6)&country==11;
replace edu2=95 if (ch017_2==95)&country==11; /*Still in School */
replace edu2=97 if (ch017_2==97)&country==11; /*Other or abroad*/
replace edu2=3 if (ch018_2==1)&country==11; 
replace edu2=5 if (ch018_2==2|ch018_2==3|ch018_2==4|ch018_2==5)&country==11;
replace edu2=4 if (ch018_2==97)&country==11; /*Other or abroad*/

gen edu3 = 0 if (ch017_3==96)&country==11; /* None */
replace edu3=2 if (ch017_3==1|ch017_3==2)&country==11; 
replace edu3=3 if (ch017_3==3|ch017_3==4|ch017_3==5|ch017_3==6)&country==11;
replace edu3=95 if (ch017_3==95)&country==11; /*Still in School */
replace edu3=97 if (ch017_3==97)&country==11; /*Other or abroad*/
replace edu3=3 if (ch018_3==1)&country==11; 
replace edu3=5 if (ch018_3==2|ch018_3==3|ch018_3==4|ch018_3==5)&country==11;
replace edu3=4 if (ch018_3==97)&country==11; /*Other or abroad*/

gen edu4 = 0 if (ch017_4==96)&country==11; /* None */
replace edu4=2 if (ch017_4==1|ch017_4==2)&country==11; 
replace edu4=3 if (ch017_4==3|ch017_4==4|ch017_4==5|ch017_4==6)&country==11;
replace edu4=95 if (ch017_4==95)&country==11; /*Still in School */
replace edu4=97 if (ch017_4==97)&country==11; /*Other or abroad*/
replace edu4=3 if (ch018_4==1)&country==11; 
replace edu4=5 if (ch018_4==2|ch018_4==3|ch018_4==4|ch018_4==5)&country==11;
replace edu4=4 if (ch018_4==97)&country==11; /*Other or abroad*/

/* 
BELGIUM-FRANCE-NL: 
dn010_&dn021_ (highest education)
11)	Enseignement primaire (1; 6)
12)	Enseignement secondaire inférieur général (2; 9)
13)	Enseignement secondaire inférieur artistique (2; 9)
14)	Enseignement secondaire inférieur technique (2; 9)
15)	Enseignement secondaire inférieur professionnel (2; 9)
16)	Enseignement secondaire supérieur général (3; 12)
17)	Enseignement secondaire supérieur artistique (3; 12)
18)	Enseignement secondaire supérieur technique (3; 12)
19)	Enseignement secondaire supérieur professionnel (3; 12)
95) Pas encore de diplôme/encore aux études
96) Aucun enseignement
97) Autre type (également diplôme obtenu à l'étranger)

dn012_&dn023_ (further education)
	11) Enseignement supérieur non-universitaire de type court (5 ; 15) 
	12) Enseignement supérieur non-universitaire de type long (5 ; 16)
	13) Enseignement universitaire (5 ; 16.5)
95) Encore aux études supérieures ou en formation professionnelle
96) Aucun
97) Autre type (également diplôme obtenu à l'étranger)
	 
*/

replace edu1=0 if (ch017_1==96)&country==23; 
replace edu1=1 if (ch017_1==11)&country==23; 
replace edu1=2 if (ch017_1==12|ch017_1==13|ch017_1==14|ch017_1==15)&country==23; 
replace edu1=3 if (ch017_1==16|ch017_1==17|ch017_1==18|ch017_1==19)&country==23; 
replace edu1=95 if (ch017_1==95)&country==23; /* Still in School */
replace edu1=97 if (ch017_1==97)&country==23; /* Other or abroad*/
replace edu1=5 if (ch018_1==11|ch018_1==12|ch018_1==13)&country==23; 
replace edu1=8 if (ch018_1==97)&country==23; /*Other or abroad*/

replace edu2=0 if (ch017_2==96)&country==23; 
replace edu2=1 if (ch017_2==11)&country==23; 
replace edu2=2 if (ch017_2==12|ch017_2==13|ch017_2==14|ch017_2==15)&country==23; 
replace edu2=3 if (ch017_2==16|ch017_2==17|ch017_2==18|ch017_2==19)&country==23; 
replace edu2=95 if (ch017_2==95)&country==23; /* Still in School */
replace edu2=97 if (ch017_2==97)&country==23; /* Other or abroad*/
replace edu2=5 if (ch018_2==11|ch018_2==12|ch018_2==13)&country==23; 
replace edu2=8 if (ch018_2==97)&country==23; /*Other or abroad*/

replace edu3=0 if (ch017_3==96)&country==23; 
replace edu3=1 if (ch017_3==11)&country==23; 
replace edu3=2 if (ch017_3==12|ch017_3==13|ch017_3==14|ch017_3==15)&country==23; 
replace edu3=3 if (ch017_3==16|ch017_3==17|ch017_3==18|ch017_3==19)&country==23; 
replace edu3=95 if (ch017_3==95)&country==23; /* Still in School */
replace edu3=97 if (ch017_3==97)&country==23; /* Other or abroad*/
replace edu3=5 if (ch018_3==11|ch018_3==12|ch018_3==13)&country==23; 
replace edu3=8 if (ch018_3==97)&country==23; /*Other or abroad*/

replace edu4=0 if (ch017_4==96)&country==23; 
replace edu4=1 if (ch017_4==11)&country==23; 
replace edu4=2 if (ch017_4==12|ch017_4==13|ch017_4==14|ch017_4==15)&country==23; 
replace edu4=3 if (ch017_4==16|ch017_4==17|ch017_4==18|ch017_4==19)&country==23; 
replace edu4=95 if (ch017_4==95)&country==23; /* Still in School */
replace edu4=97 if (ch017_4==97)&country==23; /* Other or abroad*/
replace edu4=5 if (ch018_4==11|ch018_4==12|ch018_4==13)&country==23; 
replace edu4=8 if (ch018_4==97)&country==23; /*Other or abroad*/

/* DENMARK: 
dn010_&dn021_ (highest education)
1)	klasse eller kortere  (2; 7)
2)	klasse eller kortere  (2; 8)
3)	klasse, mellemskoleeksamen (2; 9)
4)	klasse, realeksamen (2; 10)
5)	Studentereksamen eller HF (3; 12)
6)	Højere Handelseksamen (HH, HF, HHX) eller højere teknisk eksamen (HTX) (3; 12)
95) Går stadig  skole (Still in school)
96) Ingen (None)
97) Anden skole (også skole I udlandet) (Other, abroad)

dn012_&dn023_ (further education)
	1)   Specialarbejderuddannelse (3; 10,5)
	2)   Laerlinge- elev eller EFG-uddannelse (3; 14)
	3)   Anden faglig uddannelse på mindst 1 år (3; 11) 
	4)   Kort videregående uddannelse under 3 år (5; 15)
	5)   Mellemlang videregående uddannelse  på 3-4 år (5; 16)
	6)   Lang videregående uddannelse over 4 år (5; 17,5)
	95) Er stadig under videregående eller faglig uddannelse
	96) Ingen (None)
	97) Anden erhvervsuddannelse (også eksamen/uddannelse I udlandet (Other, abroad) 
*/

replace edu1=0 if (ch017_1==96)&country==18; 
replace edu1=2 if (ch017_1==1|ch017_1==2|ch017_1==3|ch017_1==4)&country==18; 
replace edu1=3 if (ch017_1==5|ch017_1==6)&country==18; 
replace edu1=95 if (ch017_1==95)&country==18; /* Still in School */
replace edu1=97 if (ch017_1==97)&country==18; /* Other or abroad*/
replace edu1=3 if (ch018_1==1|ch018_1 ==2|ch018_1 ==3)&country==18; 
replace edu1=5 if (ch018_1==4|ch018_1==5|ch018_1==6)&country==18; 
replace edu1=8 if (ch018_1==97)&country==18; /*Other or abroad*/

replace edu2=0 if (ch017_2==96)&country==18; 
replace edu2=2 if (ch017_2==1|ch017_2==2|ch017_2==3|ch017_2==4)&country==18; 
replace edu2=3 if (ch017_2==5|ch017_2==6)&country==18; 
replace edu2=95 if (ch017_2==95)&country==18; /* Still in School */
replace edu2=97 if (ch017_2==97)&country==18; /* Other or abroad*/
replace edu2=3 if (ch018_2==1|ch018_2 ==2|ch018_2 ==3)&country==18; 
replace edu2=5 if (ch018_2==4|ch018_2==5|ch018_2==6)&country==18; 
replace edu2=8 if (ch018_2==97)&country==18; /*Other or abroad*/

replace edu3=0 if (ch017_3==96)&country==18; 
replace edu3=2 if (ch017_3==1|ch017_3==2|ch017_3==3|ch017_3==4)&country==18; 
replace edu3=3 if (ch017_3==5|ch017_3==6)&country==18; 
replace edu3=95 if (ch017_3==95)&country==18; /* Still in School */
replace edu3=97 if (ch017_3==97)&country==18; /* Other or abroad*/
replace edu3=3 if (ch018_3==1|ch018_3 ==2|ch018_3 ==3)&country==18; 
replace edu3=5 if (ch018_3==4|ch018_3==5|ch018_3==6)&country==18; 
replace edu3=8 if (ch018_3==97)&country==18; /*Other or abroad*/

replace edu4=0 if (ch017_4==96)&country==18; 
replace edu4=2 if (ch017_4==1|ch017_4==2|ch017_4==3|ch017_4==4)&country==18; 
replace edu4=3 if (ch017_4==5|ch017_4==6)&country==18; 
replace edu4=95 if (ch017_4==95)&country==18; /* Still in School */
replace edu4=97 if (ch017_4==97)&country==18; /* Other or abroad*/
replace edu4=3 if (ch018_4==1|ch018_4 ==2|ch018_4 ==3)&country==18; 
replace edu4=5 if (ch018_4==4|ch018_4==5|ch018_4==6)&country==18; 
replace edu4=8 if (ch018_4==97)&country==18; /*Other or abroad*/


/* FRANCE: 
dn010_&dn021_ (highest education)
1)   Certificat d'études primaires (CEP) (1;5)
2)   Brevet des collèges, BEPC, brevet élémentaire (2;9 )
3)   CAP, BEP, ou diplôme de ce niveau (3;10.5 )
4)   Baccalauréat technologique ou professionnel (3;12 )
5)   Baccalauréat général (3; 12)
95) Encore scolarisé dans l'enseignement primaire ou secondaire
	96) Aucun diplôme
	97) Autre (incluant diplômes étrangers)

dn012_&dn023_ (further education)
	1)   Diplôme de premier cycle universitaire (5; 14 )
	2)   BTS, DUT ou équivalent (5; 14 )
	3)   Diplôme des professions sociales et de la santé de niveau Bac+2 (5; 14) 
	4)   Autre diplôme de niveau Bac+2 (5; 14 )
5)   Diplôme de 2eme cycle universitaire (5; 16 )
6)   Diplôme d'ingénieur, de grande école (5; 18 )
7)   Diplôme de 3eme cycle universitaire (y compris médecine, pharmacie, dentaire), doctorat ( 6;20)
8)   Autre diplôme de niveau supérieur à Bac+2 (5 ; 17)
	95) Encore en cours d'études supérieures ou professionnelles
	96) Aucun
	97) Autre (y compris formation à l'étranger)
*/

replace edu1=0 if (ch017_1==96)&country==17; 
replace edu1=1 if (ch017_1==1)&country==17; 
replace edu1=2 if (ch017_1==2)&country==17; 
replace edu1=3 if (ch017_1==3|ch017_1==4|ch017_1==5)&country==17; 
replace edu1=95 if (ch017_1==95)&country==17; /* Still in School */
replace edu1=97 if (ch017_1==97)&country==17; /* Other or abroad*/
replace edu1=5 if (ch018_1==1|ch018_1 ==2|ch018_1 ==3|ch018_1==4| ch018_1==5|ch018_1==6| ch018_1==8)&country==17; 
replace edu1=6 if (ch018_1==7)&country==17; 
replace edu1=8 if (ch018_1==97)&country==17; /*Other or abroad*/

replace edu2=0 if (ch017_2==96)&country==17; 
replace edu2=1 if (ch017_2==1)&country==17; 
replace edu2=2 if (ch017_2==2)&country==17; 
replace edu2=3 if (ch017_2==3|ch017_2==4|ch017_2==5)&country==17; 
replace edu2=95 if (ch017_2==95)&country==17; /* Still in School */
replace edu2=97 if (ch017_2==97)&country==17; /* Other or abroad*/
replace edu2=5 if (ch018_2==1|ch018_2 ==2|ch018_2 ==3|ch018_2==4| ch018_2==5|ch018_2==6| ch018_2==8)&country==17; 
replace edu2=6 if (ch018_2==7)&country==17; 
replace edu2=8 if (ch018_2==97)&country==17; /*Other or abroad*/

replace edu3=0 if (ch017_3==96)&country==17; 
replace edu3=1 if (ch017_3==1)&country==17; 
replace edu3=2 if (ch017_3==2)&country==17; 
replace edu3=3 if (ch017_3==3|ch017_3==4|ch017_3==5)&country==17; 
replace edu3=95 if (ch017_3==95)&country==17; /* Still in School */
replace edu3=97 if (ch017_3==97)&country==17; /* Other or abroad*/
replace edu3=5 if (ch018_3==1|ch018_3 ==2|ch018_3 ==3|ch018_3==4| ch018_3==5|ch018_3==6| ch018_3==8)&country==17; 
replace edu3=6 if (ch018_3==7)&country==17; 
replace edu3=8 if (ch018_3==97)&country==17; /*Other or abroad*/

replace edu4=0 if (ch017_4==96)&country==17; 
replace edu4=1 if (ch017_4==1)&country==17; 
replace edu4=2 if (ch017_4==2)&country==17; 
replace edu4=3 if (ch017_4==3|ch017_4==4|ch017_4==5)&country==17; 
replace edu4=95 if (ch017_4==95)&country==17; /* Still in School */
replace edu4=97 if (ch017_4==97)&country==17; /* Other or abroad*/
replace edu4=5 if (ch018_4==1|ch018_4 ==2|ch018_4 ==3|ch018_4==4| ch018_4==5|ch018_4==6| ch018_4==8)&country==17; 
replace edu4=6 if (ch018_4==7)&country==17; 
replace edu4=8 if (ch018_4==97)&country==17; /*Other or abroad*/

/* 
GERMANY: 
dn010_&dn021_ (highest education)
1)	Volks- oder Hauptschulabschluss; Klasse Polytechnische Oberschule (POS) (2; 9)
2)	Realschulabschluss; 10. Klasse POS (2; 10)
3)	Fachhochschulreife (3; 12)
4)	Abitur (3; 13)

dn012_&dn023_ (further education)
	1) Lehre (4; 16)
	2) Berufsfachschule (5; 16)
	3) Fachschule (5; 16)
	4) Fachhochschulabschluss (5; 17.5)
	5) Hochschulabschluss (5; 17.5)
*/

replace edu1=0 if (ch017_1==96)&country==12; 
replace edu1=2 if (ch017_1==1 | ch017_1==2) & country==12; 
replace edu1=3 if (ch017_1==3 | ch017_1==4) & country==12; 
replace edu1=95 if (ch017_1==96) & country==12; 
replace edu1=97 if (ch017_1==97) & country==12; 
replace edu1=4 if (ch018_1==1) & country==12; 
replace edu1=5 if (ch018_1==2 | ch018_1==3 | ch018_1==4 | ch018_1==5 ) & country==12; 
replace edu1=8 if (ch018_1==97) & country==12; 

replace edu2=0 if (ch017_2==96)&country==12; 
replace edu2=2 if (ch017_2==1 | ch017_2==2) & country==12; 
replace edu2=3 if (ch017_2==3 | ch017_2==4) & country==12; 
replace edu2=95 if (ch017_2==96) & country==12; 
replace edu2=97 if (ch017_2==97) & country==12; 
replace edu2=4 if (ch018_2==1) & country==12; 
replace edu2=5 if (ch018_2==2 | ch018_2==3 | ch018_2==4 | ch018_2==5 ) & country==12; 
replace edu2=8 if (ch018_2==97) & country==12; 

replace edu3=0 if (ch017_3==96)&country==12; 
replace edu3=2 if (ch017_3==1 | ch017_3==2) & country==12; 
replace edu3=3 if (ch017_3==3 | ch017_3==4) & country==12; 
replace edu3=95 if (ch017_3==96) & country==12; 
replace edu3=97 if (ch017_3==97) & country==12; 
replace edu3=4 if (ch018_3==1) & country==12; 
replace edu3=5 if (ch018_3==2 | ch018_3==3 | ch018_3==4 | ch018_3==5 ) & country==12; 
replace edu3=8 if (ch018_3==97) & country==12; 

replace edu4=0 if (ch017_4==96)&country==12; 
replace edu4=2 if (ch017_4==1 | ch017_4==2) & country==12; 
replace edu4=3 if (ch017_4==3 | ch017_4==4) & country==12; 
replace edu4=95 if (ch017_4==96) & country==12; 
replace edu4=97 if (ch017_4==97) & country==12; 
replace edu4=4 if (ch018_4==1) & country==12; 
replace edu4=5 if (ch018_4==2 | ch018_4==3 | ch018_4==4 | ch018_4==5 ) & country==12; 
replace edu4=8 if (ch018_4==97) & country==12; 


/* 
GREECE: 
dn010_&dn021_ (highest education)
1)	???????? (1; 6)
2)	???????? (3?????) (2; 9)
3)	?????? ? ????????????? ?????? (???,???,???????????) ? 6????? ???????? (3; 12)
4)	??? (4; 12)
95)	????? ??? ??????? (Still in school)
96)	?????? (0,0)
97)	???? ???? (? ??? ?????????) (Other, abroad)

dn012_&dn023_ (further education)
	1) (?????? ) ??????????? ????? (4; 14)
	2) ??? (5; 15.5)
	3) ???, ???????? ???????????? (5; 17)
	4) ???????????? (MSC, MBA) (5; 18)
5)	??????????? PhD (6; 20.5)
95) ????? ???? ??????? ?????????? ? ??? ????????????? ????????? (Still in school)
96) ?????? (0)
97) ???? (Other, abroad)
*/

replace edu1=0 if (ch017_1==96)& country==19;
replace edu1=1 if (ch017_1==1)&country==19;
replace edu1=2 if (ch017_1==2)&country==19 ;
replace edu1=3 if (ch017_1==3)&country==19 ;
replace edu1=4 if (ch017_1==4| ch018_1==1)&country==19; 
replace edu1=95 if (ch017_1==95)& country==19;
replace edu1=97 if (ch017_1==97)& country==19;
replace edu1=5 if (ch018_1==2| ch018_1==3| ch018_1==4)&country==19; 
replace edu1=6 if (ch018_1==5)&country==19 ;
replace edu1=8 if (ch018_1==97)& country==19;

replace edu2=0 if (ch017_2==96)& country==19;
replace edu2=1 if (ch017_2==1)&country==19;
replace edu2=2 if (ch017_2==2)&country==19 ;
replace edu2=3 if (ch017_2==3)&country==19 ;
replace edu2=4 if (ch017_2==4| ch018_2==1)&country==19; 
replace edu2=95 if (ch017_2==95)& country==19;
replace edu2=97 if (ch017_2==97)& country==19;
replace edu2=5 if (ch018_2==2| ch018_2==3| ch018_2==4)&country==19; 
replace edu2=6 if (ch018_2==5)&country==19 ;
replace edu2=8 if (ch018_2==97)& country==19;


replace edu3=0 if (ch017_3==96)& country==19;
replace edu3=1 if (ch017_3==1)&country==19;
replace edu3=2 if (ch017_3==2)&country==19 ;
replace edu3=3 if (ch017_3==3)&country==19 ;
replace edu3=4 if (ch017_3==4| ch018_3==1)&country==19;
replace edu3=95 if (ch017_3==95)& country==19;
replace edu3=97 if (ch017_3==97)& country==19;
 replace edu3=5 if (ch018_3==2| ch018_3==3| ch018_3==4)&country==19; 
replace edu3=6 if (ch018_3==5)&country==19 ;
replace edu3=8 if (ch018_3==97)& country==19;

replace edu4=0 if (ch017_4==96)& country==19;
replace edu4=1 if (ch017_4==1)&country==19;
replace edu4=2 if (ch017_4==2)&country==19 ;
replace edu4=3 if (ch017_4==3)&country==19 ;
replace edu4=4 if (ch017_4==4| ch018_4==1)&country==19;
replace edu4=95 if (ch017_4==95)& country==19;
replace edu4=97 if (ch017_4==97)& country==19;
 replace edu4=5 if (ch018_4==2| ch018_4==3| ch018_4==4)&country==19; 
replace edu4=6 if (ch018_4==5)&country==19 ;
replace edu4=8 if (ch018_4==97)& country==19;





/* 
ITALY: 
dn010_&dn021_ (highest education)
1)	 Esame di seconda elementare (1; 2)
2)	 Licenza elementare (1; 5)
3)	 Scuola media o avviamento professionale (2; 8)
4)	 Diploma ginnasiale (3; 10)
5)	 Diploma di scuola professionale, scuola magistrale o istituto d'arte (3 anni) (3; 11)
6)	 Diploma di scuola magistrale o liceo artistico (4 anni) (3; 12)
7)	 Maturità liceale (classico, scientifico, linguistico, artistico) (3; 13)
8)	 Maturità tecnica, professionale o istituto d'arte (5 anni) (3; 13)
95)  Nessun titolo ancora ottenuto / Va ancora a scuola
96)  Nessun titolo
97)  Altro titolo di studio non post-secondario (conseguito anche all'estero)

dn012_&dn023_ (further education)
	1)    Scuole di formazione paramediche (4;16)
	2)    Scuole di formazione professionale post-maturità (inclusi assistenti sociali) (4;16)
	3)    ISEF, accademie artistiche o conservatorio (5;17)
	4)    Università: laurea, laurea breve, diploma universitario, scuole dirette a fini speciali (5;17)
5)    Università post-laurea: scuole di specializzazione, corsi di perfezionamento, dottorati di ricerca (6;22)
95)  Frequenta attualmente un'istituzione post-secondaria o professionale
96)  Nessuna
97)  Altra istituzione post-secondaria o professionale (anche all'estero)
*/

replace edu1=0 if (ch017_1==96)&country==16; 
replace edu1=1 if (ch017_1==1|ch017_1==2)&country==16; 
replace edu1=2 if (ch017_1==3)&country==16; 
replace edu1=3 if (ch017_1==4|ch017_1==5|ch017_1==6|ch017_1==7|ch017_1==8)&country==16 ;
replace edu1=95 if (ch017_1==95)&country==16 ;
replace edu1=97 if (ch017_1==97)&country==16;
replace edu1=4 if (ch018_1==1|ch018_1==2)&country==16; 
replace edu1=5 if (ch018_1==3|ch018_1==4)&country==16 ;
replace edu1=6 if (ch018_1==5)&country==16;
replace edu1=8 if (ch018_1==97)&country==16;

replace edu2=0 if (ch017_2==96)&country==16; 
replace edu2=1 if (ch017_2==1|ch017_2==2)&country==16; 
replace edu2=2 if (ch017_2==3)&country==16; 
replace edu2=3 if (ch017_2==4|ch017_2==5|ch017_2==6|ch017_2==7|ch017_2==8)&country==16 ;
replace edu2=95 if (ch017_2==95)&country==16 ;
replace edu2=97 if (ch017_2==97)&country==16;
replace edu2=4 if (ch018_2==1|ch018_2==2)&country==16; 
replace edu2=5 if (ch018_2==3|ch018_2==4)&country==16 ;
replace edu2=6 if (ch018_2==5)&country==16;
replace edu2=8 if (ch018_2==97)&country==16;

replace edu3=0 if (ch017_3==96)&country==16; 
replace edu3=1 if (ch017_3==1|ch017_3==2)&country==16; 
replace edu3=2 if (ch017_3==3)&country==16; 
replace edu3=3 if (ch017_3==4|ch017_3==5|ch017_3==6|ch017_3==7|ch017_3==8)&country==16 ;
replace edu3=95 if (ch017_3==95)&country==16 ;
replace edu3=97 if (ch017_3==97)&country==16;
replace edu3=4 if (ch018_3==1|ch018_3==2)&country==16; 
replace edu3=5 if (ch018_3==3|ch018_3==4)&country==16 ;
replace edu3=6 if (ch018_3==5)&country==16;
replace edu3=8 if (ch018_3==97)&country==16;

replace edu4=0 if (ch017_4==96)&country==16; 
replace edu4=1 if (ch017_4==1|ch017_4==2)&country==16; 
replace edu4=2 if (ch017_4==3)&country==16; 
replace edu4=3 if (ch017_4==4|ch017_4==5|ch017_4==6|ch017_4==7|ch017_4==8)&country==16 ;
replace edu4=95 if (ch017_4==95)&country==16 ;
replace edu4=97 if (ch017_4==97)&country==16;
replace edu4=4 if (ch018_4==1|ch018_4==2)&country==16; 
replace edu4=5 if (ch018_4==3|ch018_4==4)&country==16 ;
replace edu4=6 if (ch018_4==5)&country==16;
replace edu4=8 if (ch018_4==97)&country==16;




/* NETHERLANDS:
dn010_&dn021_ (highest education)
1) Basisonderwijs (1; 6)
2) VGLO of LAVO (2; 10)
3) Voortgezet (speciaal) onderwijs (b.v. MLK, VSO, LOM, MAVO of
MULO) (2; 10)
4) HAVO, VWO, Atheneum, Gymnasium, HBS, MMS, Lyceum (3; 12)
5) Lager beroepsonderwijs (b.v. LTS, LEAO, Lagere Land- en
Tuinbouwschool) (2; 10)
6) Middelbaar beroepsonderwijs (b.v. MTS, MEAO, Middelbare Land- en
Tuinbouwschool) (3; 14)
7) Hoger beroepsonderwijs (b.v. HTS, HEAO, opleidingen MO-akten) (5; 15)
8) Hoger beroepsonderwijs 2e fase (b.v. accountant NIVRA, opleidingen
MO-B-akten) (5; 15)
9) Wetenschappelijk onderwijs (universiteit) (5; 16)
10) Speciaal onderwijs (0; 0)
11) Leerlingwezen (2; 10)
95) Nog geen diploma / volgt nu onderwijs (?; ?)
96) Geen (0; 0)
97) Andere opleiding (?; ?)

dn012_&dn023_ (further education) NOT RELEVANT
*/

replace edu1=0 if (ch017_1==10| ch017_1==96)&country==14;
replace edu1=1 if (ch017_1==1)&country==14;
replace edu1=2 if (ch017_1==2| ch017_1==3|ch017_1==5|ch017_1==11)&country==14;
replace edu1=3 if (ch017_1==4 |ch017_1==6)&country==14;
replace edu1=5 if (ch017_1==7| ch017_1==8|ch017_1==9)&country==14;
replace edu1=95 if (ch017_1==95)&country==14 ;
replace edu1=97 if (ch017_1==97)&country==14;

replace edu2=0 if (ch017_2==10| ch017_2==96)&country==14;
replace edu2=1 if (ch017_2==1)&country==14;
replace edu2=2 if (ch017_2==2| ch017_2==3|ch017_2==5|ch017_2==11)&country==14;
replace edu2=3 if (ch017_2==4 |ch017_2==6)&country==14;
replace edu2=5 if (ch017_2==7| ch017_2==8|ch017_2==9)&country==14;
replace edu2=95 if (ch017_2==95)&country==14 ;
replace edu2=97 if (ch017_2==97)&country==14;

replace edu3=0 if (ch017_3==10| ch017_3==96)&country==14;
replace edu3=1 if (ch017_3==1)&country==14;
replace edu3=2 if (ch017_3==2| ch017_3==3|ch017_3==5|ch017_3==11)&country==14;
replace edu3=3 if (ch017_3==4 |ch017_3==6)&country==14;
replace edu3=5 if (ch017_3==7| ch017_3==8|ch017_3==9)&country==14;
replace edu3=95 if (ch017_3==95)&country==14 ;
replace edu3=97 if (ch017_3==97)&country==14;

replace edu4=0 if (ch017_4==10| ch017_4==96)&country==14;
replace edu4=1 if (ch017_4==1)&country==14;
replace edu4=2 if (ch017_4==2| ch017_4==3|ch017_4==5|ch017_4==11)&country==14;
replace edu4=3 if (ch017_4==4 |ch017_4==6)&country==14;
replace edu4=5 if (ch017_4==7| ch017_4==8|ch017_4==9)&country==14;
replace edu4=95 if (ch017_4==95)&country==14 ;
replace edu4=97 if (ch017_4==97)&country==14;


/* SPAIN: 
dn010_&dn021_ (highest education)
1)	Enseñanza primaria, o primera etapa de la EGB, o equivalente (1; 4.5)
2)	Bachillerato elemental, EGB, Graduado escolar, o equivalente (2; 8)
3)	Bachillerato superior, BUP, o equivalente (3; 10.5)
4)	Pre-universitario o COU (3; 11.5)
5)	Estudios técnicos no superiores, FP, o equivalente (3; 11.5)
95). Aún sin estudios no superiores/ cursando estudios no superiores
96). Ninguna.
97). Otro tipo (también en el extranjero).

dn012_&dn023_ (further education)
1. Magisterio, ATS, diplomado de Escuela universitaria, o equivalente. (5;15.5)
2. Aparejador, ingeniero técnico, o equivalente.(5; 15.5)
3. Licenciado.(5; 16.5)
4. Ingeniero superior, arquitecto, o equivalente.(5; 17.5)
5. Otros estudios de tercer grado no universitarios.(5; 13.5)
95. Aún sin estudios superiores/ cursando estudios superiores.
96. Ninguna.
97. Otra titulación (también en el extranjero).*/

replace edu1=0 if (ch017_1==96)& country==15;
replace edu1=1 if (ch017_1==1)&country==15;
replace edu1=2 if (ch017_1==2)& country==15;
replace edu1=3 if (ch017_1==3 | ch017_1==4| ch017_1==5)& country==15;
replace edu1=95 if (ch017_1==95)&country==15;
replace edu1=97 if (ch017_1==97)&country==15;
replace edu1=5 if (ch018_1>=1 & ch018_1<=5) & country==15;
replace edu1=8 if (ch018_1==97)&country==15;

replace edu2=0 if (ch017_2==96)& country==15;
replace edu2=1 if (ch017_2==1)&country==15;
replace edu2=2 if (ch017_2==2)& country==15;
replace edu2=3 if (ch017_2==3 | ch017_2==4| ch017_2==5)& country==15;
replace edu2=95 if (ch017_2==95)&country==15;
replace edu2=97 if (ch017_2==97)&country==15;
replace edu2=5 if (ch018_2>=1 & ch018_2<=5) & country==15;
replace edu2=8 if (ch018_2==97)&country==15;

replace edu3=0 if (ch017_3==96)& country==15;
replace edu3=1 if (ch017_3==1)&country==15;
replace edu3=2 if (ch017_3==2)& country==15;
replace edu3=3 if (ch017_3==3 | ch017_3==4| ch017_3==5)& country==15;
replace edu3=95 if (ch017_3==95)&country==15;
replace edu3=97 if (ch017_3==97)&country==15;
replace edu3=5 if (ch018_3>=1 & ch018_3<=5) & country==15;
replace edu3=8 if (ch018_3==97)&country==15;

replace edu4=0 if (ch017_4==96)& country==15;
replace edu4=1 if (ch017_4==1)&country==15;
replace edu4=2 if (ch017_4==2)& country==15;
replace edu4=3 if (ch017_4==3 | ch017_4==4| ch017_4==5)& country==15;
replace edu4=95 if (ch017_4==95)&country==15;
replace edu4=97 if (ch017_4==97)&country==15;
replace edu4=5 if (ch018_4>=1 & ch018_4<=5) & country==15;
replace edu4=8 if (ch018_4==97)&country==15;

/* 
SWEDEN: 
dn010_&dn021_ (highest education)
1)	Folkskola (motsvarande) mindre än sex år (1; 6)
2)	Folkskola 6-8 år (1; 7)
3)	Folkskoleexamen och yrkesutbildning minst ett år (2; 8)
4)	Folkskola och läroverk åtta år (1; 8)
5)	Avgångsbetyg från nioårig grundskola (2; 9)
6)	Realexamen (2; 9)
7)	Avgångsbetyg från grundskola eller realexamen, samt  yrkesutbildning minst ett år (2; 10)
95) … (Still in School)
96) Ingen utbildning (No educ) (0,0)
97) Annan grundutbildning (även utomlands) Other

dn012_&dn023_ (further education)
	1) Normalskolekompetens (flickskola) (3,12)
	2) Tvåårigt gymnasium (3,11)
	3) Tre- eller fyraårigt gymnasium (3,12)
	4) Utbildning minst ett år utöver gymnasium eller flickskola, men EJ   fullständig högskoleexamen (4,13)
5) Examen från universitet/högskola efter minst tre års studier (5,15)
95) ... (Still in school)
96) Ingen gymnasial eller högre utbildning
97) Annan utbildning (även utomlands)
*/

replace edu1=0 if(ch017_1==96)& country==13;
replace edu1=1 if (ch017_1==1|ch017_1==2|ch017_1==4)&country==13;
replace edu1=2 if (ch017_1==3|ch017_1==5|ch017_1==6|ch017_1==7)& country==13;
replace edu1=95 if (ch017_1==95)& country==13;
replace edu1=97 if (ch017_1==97)& country==13;
replace edu1=3 if (ch018_1==1|ch018_1==2|ch018_1==3)& country==13;
replace edu1=4 if (ch018_1==4)& country==13;
replace edu1=5 if (ch018_1==5)& country==13;
replace edu1=8 if (ch018_1==97)& country==13;

replace edu2=0 if(ch017_2==96)& country==13;
replace edu2=1 if (ch017_2==1|ch017_2==2|ch017_2==4)&country==13;
replace edu2=2 if (ch017_2==3|ch017_2==5|ch017_2==6|ch017_2==7)& country==13;
replace edu2=95 if (ch017_2==95)& country==13;
replace edu2=97 if (ch017_2==97)& country==13;
replace edu2=3 if (ch018_2==1|ch018_2==2|ch018_2==3)& country==13;
replace edu2=4 if (ch018_2==4)& country==13;
replace edu2=5 if (ch018_2==5)& country==13;
replace edu2=8 if (ch018_2==97)& country==13;

replace edu3=0 if(ch017_3==96)& country==13;
replace edu3=1 if (ch017_3==1|ch017_3==2|ch017_3==4)&country==13;
replace edu3=2 if (ch017_3==3|ch017_3==5|ch017_3==6|ch017_3==7)& country==13;
replace edu3=95 if (ch017_3==95)& country==13;
replace edu3=97 if (ch017_3==97)& country==13;
replace edu3=3 if (ch018_3==1|ch018_3==2|ch018_3==3)& country==13;
replace edu3=4 if (ch018_3==4)& country==13;
replace edu3=5 if (ch018_3==5)& country==13;
replace edu3=8 if (ch018_3==97)& country==13;

replace edu4=0 if(ch017_4==96)& country==13;
replace edu4=1 if (ch017_4==1|ch017_4==2|ch017_4==4)&country==13;
replace edu4=2 if (ch017_4==3|ch017_4==5|ch017_4==6|ch017_4==7)& country==13;
replace edu4=95 if (ch017_4==95)& country==13;
replace edu4=97 if (ch017_4==97)& country==13;
replace edu4=3 if (ch018_4==1|ch018_4==2|ch018_4==3)& country==13;
replace edu4=4 if (ch018_4==4)& country==13;
replace edu4=5 if (ch018_4==5)& country==13;
replace edu4=8 if (ch018_4==97)& country==13;

/* 
SWITZERLAND: 
dn010_&dn021_ (highest education)
8)	?, ?, ? (?; ?) 
9)	?, ?, ? (?; ?) 
10)	Ecole primaire privée, Abschluss der primarschule, Scuola elementare privato (1; 5) 
11)	?, ?, ? (?; ?)
12)	Certificat d'études secondaires obtenu dans une école privée, Sekundarchuldabschluss, Certificato di studi ottenuto in una scuola privata(Fine delle medie) (2; 7)
13)	Ecole primaire publique, Abschluss der primarschule, Scuola elementare pubblica (1; 5)
14)	Certificats d'études secondaires obtenu dans une école publique, Sekundarchuldabschluss, Certificato di studi ottenuto in una scuola pubblica (Fine delle medie) (2; 7)
15)	Ecole des métiers ou apprentissage, Teknische schule, Apprendistato o scuola dei mestieri (3; 3)
16)	?, ?, ? (?; ?)
95) Encore aux études, ?, Studia ancora

dn012_&dn023_ (further education)
	1) 
	2)
	3)  
	4)  
	5)  

*/
replace edu1=0 if(ch017_1==96)& country==20;
replace edu1=1 if (ch017_1==1)&(country==20);
replace edu1=2 if (ch017_1==2|ch017_1==3)& (country==20);
replace edu1=3 if (ch017_1==4 | ch017_1==5 | ch017_1==6 | ch018_1==1 )& (country==20);
replace edu1=95 if (ch017_1==95)& (country==20);
replace edu1=97 if (ch017_1==97)& (country==20);
replace edu1=5 if (ch018_1==2 | ch018_1==3 | ch018_1==4 )& (country==20);
replace edu1=8 if (ch018_1==97)& (country==20);


replace edu2=0 if(ch017_2==96)& country==20;
replace edu2=1 if (ch017_2==1)&(country==20);
replace edu2=2 if (ch017_2==2|ch017_2==3)& (country==20);
replace edu2=3 if (ch017_2==4 | ch017_2==5 | ch017_2==6 | ch018_2==1 )& (country==20);
replace edu2=95 if (ch017_2==95)& (country==20);
replace edu2=97 if (ch017_2==97)& (country==20);
replace edu2=5 if (ch018_2==2 | ch018_2==3 | ch018_2==4 )& (country==20);
replace edu2=8 if (ch018_2==97)& (country==20);

replace edu3=0 if(ch017_3==96)& country==20;
replace edu3=1 if (ch017_3==1)&(country==20);
replace edu3=2 if (ch017_3==2|ch017_3==3)& (country==20);
replace edu3=3 if (ch017_3==4 | ch017_3==5 | ch017_3==6 | ch018_3==1 )& (country==20);
replace edu3=95 if (ch017_3==95)& (country==20);
replace edu3=97 if (ch017_3==97)& (country==20);
replace edu3=5 if (ch018_3==2 | ch018_3==3 | ch018_3==4 )& (country==20);
replace edu3=8 if (ch018_3==97)& (country==20);

replace edu4=0 if(ch017_4==96)& country==20;
replace edu4=1 if (ch017_4==1)&(country==20);
replace edu4=2 if (ch017_4==2|ch017_4==3)& (country==20);
replace edu4=3 if (ch017_4==4 | ch017_4==5 | ch017_4==6 | ch018_4==1 )& (country==20);
replace edu4=95 if (ch017_4==95)& (country==20);
replace edu4=97 if (ch017_4==97)& (country==20);
replace edu4=5 if (ch018_4==2 | ch018_4==3 | ch018_4==4 )& (country==20);
replace edu4=8 if (ch018_4==97)& (country==20);



keep mergeid wave country edu1-edu4;

sort mergeid wave;

save `t2'educode2rel231, replace;

log close;

