#delimit;
clear;
set more off;
capture log close;

cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm";

/*****************************************************
Part 1: Creates Stata data set of CPSC recalls with recall as level of observation
Part 2: Prepare recall data to merge with sales data
Part 2: Prepare recall data to merge with stock data

Part 3: Data set of recall characteristics. 
		originally from program recall-characteristics.do
		output: recall-characteristics.dta
*****************************************************/

**********************************;
**PART 1** Create Stata data set of CPSC recalls;
**********************************;

insheet using ..\data\raw-data\recall-info.csv, c;

/*each recall can have up to 6 retailers, separated by # in the retailer variable.
split this variable so i have a separate variable for each retailer*/
split retailer, p(#);
drop retailer;

/*each recall can have up to 2 manufacturers, separated by # in the retailer variable.
split this variable so i have a separate variable for each retailer*/
split manufacturer, p(#);
drop manufacturer;

/*each recall can have up to 4 importers, separated by # in the retailer variable.
split this variable so i have a separate variable for each retailer*/
split importer, p(#);
drop importer;

gen rec_id = _n; /*create an id for each recall*/

gen recall_date = date(date, "MDY");
format recall_date %d;
drop date;
order recall_date;
sort recall_date;



save ..\data\recall-info, replace;

**********************************;
**PART 2** Prepare recall data to merge with sales data;
**********************************;

use ..\data\recall-info, clear;
/*Create variables to input the product, manufacturer, brand, and license names for merging.
Note: Some recalls have more than one product.  We will create separate variables for each product.  
Later, data will be reshaped so that we have one observation for each recall-product pair.*/
gen product_merge1 = "";
gen product_merge2 = "";
gen product_merge3 = "";
gen product_merge4 = "";
gen product_merge5 = "";
gen product_merge6 = "";
gen product_merge7 = "";
gen product_merge8 = "";
gen product_merge9 = "";
gen product_merge10 = "";
gen product_merge11 = "";
gen product_merge12 = "";
gen product_merge13 = "";
gen product_merge14 = "";
gen product_merge15 = "";
gen product_merge16 = "";
gen product_merge17 = "";
gen product_merge18 = "";
gen product_merge19 = "";
gen product_merge20 = "";
gen product_merge21 = "";
gen product_merge22 = "";
gen product_merge23 = "";
gen product_merge24 = "";
gen product_merge25 = "";
gen product_merge26 = "";
gen product_merge27 = "";
gen product_merge28 = "";
gen product_merge29 = "";
gen product_merge30 = "";
gen product_merge31 = "";
gen product_merge32 = "";
gen manufacturer_merge1 = "";
gen brand_merge1 = "";
gen license_merge1 = "";
gen license_merge2 = "";
gen license_merge3 = "";
gen license_merge4 = "";
gen license_merge5 = "";
gen license_merge6 = "";
gen license_merge7 = "";
gen license_merge8 = "";
gen license_merge9 = "";
gen license_merge10 = "";
gen license_merge11 = "";
gen license_merge12 = "";
gen license_merge13 = "";
gen license_merge14 = "";
gen license_merge15 = "";
gen license_merge16 = "";
gen license_merge17 = "";
gen license_merge18 = "";
gen license_merge19 = "";
gen license_merge20 = "";
gen license_merge21 = "";
gen license_merge22 = "";
gen license_merge23 = "";
gen license_merge24 = "";
gen license_merge25 = "";
gen license_merge26 = "";
gen license_merge27 = "";
gen license_merge28 = "";
gen license_merge29 = "";
gen license_merge30 = "";
gen license_merge31 = "";
gen license_merge32 = "";
order rec_id;
sort rec_id;

/*Creating product merge equal to the name of the product if it doesn't match any product in the toy data. 
If it does match, creating a name that will match sales data exactly*/
replace product_merge1=product if rec_id==31;
replace product_merge1=product if rec_id==32;
replace product_merge1=product if rec_id==33;
replace product_merge1=product if rec_id==34;
replace product_merge1=product if rec_id==35;
replace product_merge1=product if rec_id==36;
replace product_merge1=product if rec_id==37;
replace product_merge1=product if rec_id==38;
replace product_merge1=product if rec_id==39;
replace product_merge1=product if rec_id==40;
replace product_merge1=product if rec_id==41;
replace product_merge1=product if rec_id==42;
replace product_merge1="LIL WAGSTER DRAGSTER" if rec_id==43; 
replace product_merge1=product if rec_id==44;
replace product_merge1=product if rec_id==45;
replace product_merge1=product if rec_id==46;
replace product_merge1=product if rec_id==47;
replace product_merge1=product if rec_id==48;
replace product_merge1=product if rec_id==49;
replace product_merge1=product if rec_id==50;
replace product_merge1=product if rec_id==51;
replace product_merge1=product if rec_id==52;
replace product_merge1=product if rec_id==53;
replace product_merge1=product if rec_id==54;
replace product_merge1=product if rec_id==55;
replace product_merge1=product if rec_id==56;
replace product_merge1="CHUBBIES VEHICLES ASST" if rec_id==57;
replace product_merge1=product if rec_id==58;
replace product_merge1=product if rec_id==59;
replace product_merge1="LEARNING MINI CUBE" if rec_id==60;
replace product_merge1="LAUGH & LEARN MUSIC CHAIR" if rec_id==61;
replace product_merge1=product if rec_id==62;
replace product_merge1=product if rec_id==63;
replace product_merge1="MY FIRST MOBILE PHONE" if rec_id==64;
replace product_merge1="GLOWIN DINO FLASHLIGHT" if rec_id==65;
replace product_merge2="GLOWIN DOG FLASHLIGHT" if rec_id==65;
replace product_merge1=product if rec_id==66;
replace product_merge1=product if rec_id==67; /*There are other pull along toys, but no pull along snail.*/
replace product_merge1="BUSY BABY PLIERS" if rec_id==68;
replace product_merge1=product if rec_id==69;
replace product_merge1=product if rec_id==70;
replace product_merge1=product if rec_id==71;
replace product_merge1=product if rec_id==72;
replace product_merge1=product if rec_id==73;
replace product_merge1=product if rec_id==74;
replace product_merge1=product if rec_id==75;
replace product_merge1="IQ BABY VROOM VROOM VEHIC" if rec_id==76;
replace product_merge1=product if rec_id==77;
replace product_merge1="KITCHEN WEAR COOKING SET" if rec_id==78;
replace product_merge1=product if rec_id==79;
replace product_merge1=product if rec_id==80;
replace product_merge1=product if rec_id==81;
replace product_merge1=product if rec_id==82;
replace product_merge1=product if rec_id==83;
replace product_merge1="LEARN AROUND PLAYGROUND" if rec_id==84;
replace product_merge1=product if rec_id==85;
replace product_merge1=product if rec_id==86;
replace product_merge1=product if rec_id==87;
replace product_merge1=product if rec_id==88;
replace product_merge1="SHAKE N JINGLE KEYS" if rec_id==89;
replace product_merge1=product if rec_id==90;
replace product_merge1=product if rec_id==91;
replace product_merge1=product if rec_id==92; /*There are other Kool toyz, but not sure if any matched the ones that were recalled.*/
replace product_merge1=product if rec_id==93;
replace product_merge1=product if rec_id==94;
replace product_merge1=product if rec_id==95;
replace product_merge1=product if rec_id==96;
replace product_merge1=product if rec_id==97;
replace product_merge1=product if rec_id==98;
replace product_merge1=product if rec_id==99;
replace product_merge1=product if rec_id==100;
replace product_merge1=product if rec_id==101;
replace product_merge1="LAUGH & LEARN BUNNY" if rec_id==102;
replace product_merge2="LAUGH/LRN BUNNY GIFT PACK" if rec_id==102;
replace product_merge1=product if rec_id==103;
replace product_merge1=product if rec_id==104;
replace product_merge1=product if rec_id==105;
replace product_merge1=product if rec_id==106;
replace product_merge1=product if rec_id==107;
replace product_merge1=product if rec_id==108;
replace product_merge1=product if rec_id==109;
replace product_merge1=product if rec_id==110;
replace product_merge1=product if rec_id==111;
replace product_merge1=product if rec_id==112;
replace product_merge1=product if rec_id==113;
replace product_merge1="RECORD A VOICE CELL PHONE" if rec_id==114;
replace product_merge1=product if rec_id==115;
replace product_merge1=product if rec_id==116;
replace product_merge1=product if rec_id==117;
replace product_merge1=product if rec_id==118;
replace product_merge1=product if rec_id==119;
replace product_merge1=product if rec_id==120;
replace product_merge1=product if rec_id==121;
replace product_merge1="TT JAMES THE RED ENGINE" if rec_id==122;
replace product_merge2="TT SODOR LINE CABOOSE" if rec_id==122;
replace product_merge3="TT MUSICAL CABOOSE" if rec_id==122;
replace product_merge4="TT SMELTING YARD" if rec_id==122; /*There were several thomas and friends toys listed under various thomas toys. Difficult to tell if any others were exact matches.*/
replace product_merge1=product if rec_id==123;
replace product_merge1="SHAPE SORTING CASTLE" if rec_id==124;
replace product_merge1=product if rec_id==125;
replace product_merge1=product if rec_id==126;
replace product_merge1=product if rec_id==127;
replace product_merge1=product if rec_id==128;
replace product_merge1="SS LIGHT UP ELMO PAL" if rec_id==129;
replace product_merge2="SS LIGHT UP PAL" if rec_id==129;
replace product_merge3="SS MUSICAL PALS BIG BIRD" if rec_id==129;
replace product_merge4="SS SHAPE SORTER FUN" if rec_id==129;
replace product_merge5="SS ERNIES TRIKE" if rec_id==129;
replace product_merge6="SS COLLECTIBLE" if rec_id==129;
replace product_merge7="SS BIG BIRD COLLECTIBLE" if rec_id==129;
replace product_merge8="SS CONSTRUCTION SET" if rec_id==129;
replace product_merge9="SS SUPER BOOM BOX" if rec_id==129;
replace product_merge10="SS ACTION FIRE ENGINE" if rec_id==129;
replace product_merge11="SS REV & GO ELMO" if rec_id==129;
replace product_merge12="SS SPLASHIN FUN PUZZLE" if rec_id==129;
replace product_merge13="SS MUSICAL LIGHTS PHONE" if rec_id==129;
replace product_merge14="SS COUNT TO THE BEAT ELMO" if rec_id==129;
replace product_merge15="SS SHAKE GIGGLE/ROLL" if rec_id==129;
replace product_merge16="SS ELMO IN THE GIGGLE BOX" if rec_id==129;
replace product_merge17="SS SILLY PARTS TALKN ELMO" if rec_id==129;
replace product_merge18="DORA VAMANOS VAN" if rec_id==129;
replace product_merge19="SS SING W/ELMO GREAT HITS" if rec_id==129;
replace product_merge20="SS ELMO AND PALS ASST" if rec_id==129;
replace product_merge21="DORA FIGURES 3PK" if rec_id==129;
replace product_merge22="SS TUB TOYS TOTE" if rec_id==129;
replace product_merge23="GO DIEGO GO FIELD JOURNAL" if rec_id==129;
replace product_merge24="GO DIEGO TALKIN RSCUE 4X4" if rec_id==129;
replace product_merge25="SS TUB POTS & PANS" if rec_id==129;
replace product_merge26="SS GIGGLE DRILL" if rec_id==129;
replace product_merge27="DORA PONY STABLE" if rec_id==129;
replace product_merge28="DIEGO GADGET BELT" if rec_id==129;
replace product_merge29="DIEGO TALK MOBILE RESCUE" if rec_id==129;
replace product_merge30="DORA FIGURES" if rec_id==129;
replace product_merge31="LICENSED BIRTHDAY ASST" if rec_id==129;
replace product_merge32="DORA BIRTHDAY FIGURE" if rec_id==129; /*There were many toys listed under the same recall. Not all were found.*/
replace product_merge1=product if rec_id==130;
replace product_merge1=product if rec_id==131;
replace product_merge1=product if rec_id==132;
replace product_merge1=product if rec_id==133;
replace product_merge1=product if rec_id==134;
replace product_merge1=product if rec_id==135;
replace product_merge1=product if rec_id==136;
replace product_merge1=product if rec_id==137;
replace product_merge1=product if rec_id==138;
replace product_merge1="GEOTRAX TRACKPK W/STORAGE" if rec_id==139; 
replace product_merge1=product if rec_id==140;
replace product_merge1=product if rec_id==141;
replace product_merge1=product if rec_id==142;
replace product_merge1=product if rec_id==143;
replace product_merge1="THOMAS & FRIENDS TOAD" if rec_id==144; /*Not sure if this is the same as the recalled toy, which is called toad vehicle with brake lever.*/
replace product_merge2="TT CARGO CAR TRANSFER" if rec_id==144; /*Same as above - recalled toy is called all black cargo car.*/
replace product_merge1=product if rec_id==145;
replace product_merge1=product if rec_id==146;
replace product_merge1=product if rec_id==147;
replace product_merge1=product if rec_id==148;
replace product_merge1="PULL ALONG BLOCKS" if rec_id==149;
replace product_merge2="WOODEN ACTIVITY 10IN1" if rec_id==149;
replace product_merge1="DISCOVER & PLAY BLOCKS" if rec_id==150;
replace product_merge1=product if rec_id==151;
replace product_merge1=product if rec_id==152;
replace product_merge1=product if rec_id==153;
replace product_merge1=product if rec_id==154;
replace product_merge1="DIEGO ANIMAL RESCUE BOAT" if rec_id==155;
replace product_merge1=product if rec_id==156;
replace product_merge1=product if rec_id==157;
replace product_merge1=product if rec_id==158;
replace product_merge1=product if rec_id==159;
replace product_merge1="LNL 2IN1 LEARNING KITCHEN" if rec_id==160;
replace product_merge1=product if rec_id==161;
replace product_merge1=product if rec_id==162;
replace product_merge1=product if rec_id==163;
replace product_merge1=product if rec_id==164;
replace product_merge1=product if rec_id==165; /*Not sure if this is the same as Pop Up Music box*/
replace product_merge1=product if rec_id==166;
replace product_merge1=product if rec_id==167;
replace product_merge1=product if rec_id==168;
replace product_merge1=product if rec_id==169;
replace product_merge1=product if rec_id==170;
replace product_merge1=product if rec_id==171;
replace product_merge1=product if rec_id==172;
replace product_merge1=product if rec_id==173;
replace product_merge1=product if rec_id==174;
replace product_merge1=product if rec_id==175;
replace product_merge1=product if rec_id==176;
replace product_merge1=product if rec_id==177;
replace product_merge1="BABY THINGS TOWER" if rec_id==178; /*Not positive this is the same as Tot tower toy blocks.*/
assert product_merge1!="" if rec_id>=31;

/*Creating manufacturer_merge equal to the name of the manufacturer if it doesn't match any product in the toy data.
If it does match, creating a name that will match sales data exactly*/
replace manufacturer_merge1=manufacturer1 if rec_id==31;
replace manufacturer_merge1="KIDS STATION" if rec_id==32;
replace manufacturer_merge1=importer1 if rec_id==33;
replace manufacturer_merge1="WAL-MART" if rec_id==34;
replace manufacturer_merge1="DOLLAR GENERAL" if rec_id==35;
replace manufacturer_merge1=manufacturer1 if rec_id==36;
replace manufacturer_merge1="OCEAN DESERT SALES" if rec_id==37;
replace manufacturer_merge1=distributor if rec_id==38;
replace manufacturer_merge1=manufacturer1 if rec_id==39;
replace manufacturer_merge1="WAL-MART" if rec_id==40;
replace manufacturer_merge1=distributor if rec_id==41;
replace manufacturer_merge1=importer1 if rec_id==42;
replace manufacturer_merge1="FISHER-PRICE" if rec_id==43;
replace manufacturer_merge1="FISHER-PRICE" if rec_id==44;
replace manufacturer_merge1=manufacturer1 if rec_id==45;
replace manufacturer_merge1="INFANTINO" if rec_id==46; /*Also matched to WAL-MART*/
replace manufacturer_merge1=distributor if rec_id==47;
replace manufacturer_merge1=importer1 if rec_id==48;
replace manufacturer_merge1="TARGET" if rec_id==49;
replace manufacturer_merge1="STORK CRAFT" if rec_id==50;
replace manufacturer_merge1=distributor if rec_id==51;
replace manufacturer_merge1=importer1 if rec_id==52;
replace manufacturer_merge1=distributor if rec_id==53;
replace manufacturer_merge1= "DOREL" if rec_id==54; /*Is this the same as Dorel?*/
replace manufacturer_merge1="AMERICAN GREETINGS" if rec_id==55;
replace manufacturer_merge1="INTERNATIONAL PLAYTHINGS" if rec_id==56;
replace manufacturer_merge1="INTERNATIONAL PLAYTHINGS" if rec_id==57;
replace manufacturer_merge1="WAL-MART" if rec_id==58;
replace manufacturer_merge1=manufacturer1 if rec_id==59;
replace manufacturer_merge1="MAXIM" if rec_id==60;
replace manufacturer_merge1="FISHER-PRICE" if rec_id==61;
replace manufacturer_merge1="HASBRO" if rec_id==62; /*Milton Bradley is a brand of Hasbro*/
replace manufacturer_merge1="CREATIVE INNOVATIONS" if rec_id==63;
replace manufacturer_merge1="INTERNATIONAL PLAYTHINGS" if rec_id==64;
replace manufacturer_merge1="LITTLE TIKES" if rec_id==65;
replace manufacturer_merge1=importer1 if rec_id==66;
replace manufacturer_merge1="BRIO" if rec_id==67;
replace manufacturer_merge1="CHILD GUIDANCE" if rec_id==68;
replace manufacturer_merge1="CREATIVE INNOVATIONS" if rec_id==69;
replace manufacturer_merge1="MATTEL" if rec_id==70;
replace manufacturer_merge1="KIDS PREFERRED" if rec_id==71;
replace manufacturer_merge1="ROSE ART" if rec_id==72;
replace manufacturer_merge1=distributor if rec_id==73; /*should match to marvel?*/
replace manufacturer_merge1=distributor if rec_id==74;
replace manufacturer_merge1=importer1 if rec_id==75;
replace manufacturer_merge1="SMALL WORLD IMPORT" if rec_id==76;
replace manufacturer_merge1=manufacturer1 if rec_id==77;
replace manufacturer_merge1="ALEX-PANLINE" if rec_id==78;
replace manufacturer_merge1="ORIENTAL TRADING" if rec_id==79;
replace manufacturer_merge1=manufacturer1 if rec_id==80;
replace manufacturer_merge1="SPIN MASTER" if rec_id==81;
replace manufacturer_merge1=distributor if rec_id==82;
replace manufacturer_merge1="WILD PLANET TOYS" if rec_id==83;
replace manufacturer_merge1="LEAPFROG" if rec_id==84;
replace manufacturer_merge1="TOYS R' US" if rec_id==85;
replace manufacturer_merge1="HASBRO" if rec_id==86; /*Playskool is a brand of Hasbro*/
replace manufacturer_merge1="ALMAR SALES" if rec_id==87;
replace manufacturer_merge1="WAL-MART" if rec_id==88;
replace manufacturer_merge1="THE FIRST YEARS (RC2)" if rec_id==89;
replace manufacturer_merge1="GUND" if rec_id==90;
replace manufacturer_merge1="SPIN MASTER" if rec_id==91;
replace manufacturer_merge1="TARGET" if rec_id==92;
replace manufacturer_merge1="TARGET" if rec_id==93;
replace manufacturer_merge1="MATTEL" if rec_id==94;
replace manufacturer_merge1="WAL-MART" if rec_id==95;
replace manufacturer_merge1=distributor if rec_id==96;
replace manufacturer_merge1=distributor if rec_id==97;
replace manufacturer_merge1=distributor if rec_id==98;
replace manufacturer_merge1="TARGET" if rec_id==99;
replace manufacturer_merge1="HASBRO" if rec_id==100;
replace manufacturer_merge1="JAKKS PACIFIC" if rec_id==101;
replace manufacturer_merge1="FISHER-PRICE" if rec_id==102;
replace manufacturer_merge1=importer1 if rec_id==103;
replace manufacturer_merge1=distributor if rec_id==104;
replace manufacturer_merge1="TOYS R' US" if rec_id==105;
replace manufacturer_merge1=distributor if rec_id==106;
replace manufacturer_merge1="REGENT PRODUCTS" if rec_id==107;
replace manufacturer_merge1=importer1 if rec_id==108;
replace manufacturer_merge1="TARGET" if rec_id==109;
replace manufacturer_merge1="SMALL WORLD IMPORT" if rec_id==110;
replace manufacturer_merge1="ROSE ART" if rec_id==111;
replace manufacturer_merge1="GRACO" if rec_id==112;
replace manufacturer_merge1="HAPE INTERNATIONAL" if rec_id==113;
replace manufacturer_merge1="BATTAT" if rec_id==114;
replace manufacturer_merge1="SMALL WORLD IMPORT" if rec_id==115;
replace manufacturer_merge1=distributor if rec_id==116;
replace manufacturer_merge1=distributor if rec_id==117;
replace manufacturer_merge1=manufacturer1 if rec_id==118;
replace manufacturer_merge1="TRISTAR INTERNATIONAL" if rec_id==119;
replace manufacturer_merge1=importer1 if rec_id==120;
replace manufacturer_merge1="GEMMY" if rec_id==121;
replace manufacturer_merge1="RC2" if rec_id==122;
replace manufacturer_merge1="TARGET" if rec_id==123;
replace manufacturer_merge1="INFANTINO (DOREL)" if rec_id==124;
replace manufacturer_merge1=distributor if rec_id==125;
replace manufacturer_merge1=manufacturer1 if rec_id==126;
replace manufacturer_merge1="HASBRO" if rec_id==127;
replace manufacturer_merge1=distributor if rec_id==128;
replace manufacturer_merge1="FISHER-PRICE" if rec_id==129;
replace manufacturer_merge1=distributor if rec_id==130;
replace manufacturer_merge1="MATTEL" if rec_id==131;
replace manufacturer_merge1="MATTEL" if rec_id==132;
replace manufacturer_merge1="MATTEL" if rec_id==133;
replace manufacturer_merge1="MATTEL" if rec_id==134;
replace manufacturer_merge1="MATTEL" if rec_id==135;
replace manufacturer_merge1=importer1 if rec_id==136;
replace manufacturer_merge1="SCHYLLING ASSOCIATES" if rec_id==137;
replace manufacturer_merge1="FISHER-PRICE" if rec_id==138;
replace manufacturer_merge1="FISHER-PRICE" if rec_id==139;
replace manufacturer_merge1="MATTEL" if rec_id==140;
replace manufacturer_merge1="GUIDECRAFT" if rec_id==141;
replace manufacturer_merge1=importer1 if rec_id==142;
replace manufacturer_merge1="LEARNING CURVE TOYS (RC2)" if rec_id==143;
replace manufacturer_merge1="RC2" if rec_id==144;
replace manufacturer_merge1="TARGET" if rec_id==145;
replace manufacturer_merge1=manufacturer1 if rec_id==146;
replace manufacturer_merge1="TOYS R' US" if rec_id==147;
replace manufacturer_merge1="EVEREADY" if rec_id==148;
replace manufacturer_merge1=importer1 if rec_id==149;
replace manufacturer_merge1="KIDS II" if rec_id==150;
replace manufacturer_merge1="JC PENNEY" if rec_id==151;
replace manufacturer_merge1=distributor if rec_id==152;
replace manufacturer_merge1=distributor if rec_id==153;
replace manufacturer_merge1=manufacturer1 if rec_id==154;
replace manufacturer_merge1="FISHER-PRICE" if rec_id==155;
replace manufacturer_merge1=manufacturer1 if rec_id==156;
replace manufacturer_merge1=distributor if rec_id==157;
replace manufacturer_merge1=distributor if rec_id==158;
replace manufacturer_merge1="TOYS R' US" if rec_id==159;
replace manufacturer_merge1="FISHER-PRICE" if rec_id==160;
replace manufacturer_merge1="SWIMWAYS" if rec_id==161;
replace manufacturer_merge1="DOLLAR GENERAL" if rec_id==162;
replace manufacturer_merge1=importer1 if rec_id==163;
replace manufacturer_merge1="SCHYLLING ASSOCIATES" if rec_id==164;
replace manufacturer_merge1="SCHYLLING ASSOCIATES" if rec_id==165;
replace manufacturer_merge1="SCHYLLING ASSOCIATES" if rec_id==166;
replace manufacturer_merge1="SCHYLLING ASSOCIATES" if rec_id==167;
replace manufacturer_merge1="SPIN MASTER" if rec_id==168;
replace manufacturer_merge1=manufacturer1 if rec_id==169;
replace manufacturer_merge1=manufacturer1 if rec_id==170;
replace manufacturer_merge1=importer1 if rec_id==171;
replace manufacturer_merge1=distributor if rec_id==172;
replace manufacturer_merge1="GREENBRIER" if rec_id==173;
replace manufacturer_merge1=importer1 if rec_id==174;
replace manufacturer_merge1=manufacturer1 if rec_id==175;
replace manufacturer_merge1=manufacturer1 if rec_id==176;
replace manufacturer_merge1=importer1 if rec_id==177;
replace manufacturer_merge1="EEBOO" if rec_id==178;

/*Creating brand variable that will match sales data exactly.
This is basically done by inspecting the name of the toy and identifying those that fall into brands in the sales data*/
replace brand_merge1="LAUGH & LEARN" if rec_id==61;
replace brand_merge1="LITTLE TIKES" if rec_id==65;
replace brand_merge1="LEARN & GROOVE" if rec_id==84;
replace brand_merge1="PLAYSKOOL" if rec_id==86;
replace brand_merge1="LAUGH & LEARN" if rec_id==102;
replace brand_merge1="BABY EINSTEIN" if rec_id==112;
replace brand_merge1="BARBIE" if rec_id==133;
replace brand_merge1="GEOTRAX" if rec_id==139;
replace brand_merge1="BARBIE" if rec_id==140;
replace brand_merge1="BABY EINSTEIN" if rec_id==150;
replace brand_merge1="LAUGH & LEARN" if rec_id==160;

/*Creating license variable that will match sales data exactly.
This is basically done by inspecting the name of the toy and identifying those that fall into licenses in the sales data*/
replace license_merge1="BABY EINSTEIN" if rec_id==112;
replace license_merge1="THOMAS AND FRIENDS" if rec_id==122;
replace license_merge2="THOMAS AND FRIENDS" if rec_id==122;
replace license_merge3="THOMAS AND FRIENDS" if rec_id==122;
replace license_merge4="THOMAS AND FRIENDS" if rec_id==122;
replace license_merge1="SESAME STREET" if rec_id==129;
replace license_merge2="SESAME STREET" if rec_id==129;
replace license_merge3="SESAME STREET" if rec_id==129;
replace license_merge4="SESAME STREET" if rec_id==129;
replace license_merge5="SESAME STREET" if rec_id==129;
replace license_merge6="SESAME STREET" if rec_id==129;
replace license_merge7="SESAME STREET" if rec_id==129;
replace license_merge8="SESAME STREET" if rec_id==129;
replace license_merge9="SESAME STREET" if rec_id==129;
replace license_merge10="SESAME STREET" if rec_id==129;
replace license_merge11="SESAME STREET" if rec_id==129;
replace license_merge12="SESAME STREET" if rec_id==129;
replace license_merge13="SESAME STREET" if rec_id==129;
replace license_merge14="SESAME STREET" if rec_id==129;
replace license_merge15="SESAME STREET" if rec_id==129;
replace license_merge16="SESAME STREET" if rec_id==129;
replace license_merge17="SESAME STREET" if rec_id==129;
replace license_merge18="DORA THE EXPLORER" if rec_id==129;
replace license_merge19="SESAME STREET" if rec_id==129;
replace license_merge20="SESAME STREET" if rec_id==129;
replace license_merge21="DORA THE EXPLORER" if rec_id==129;
replace license_merge22="SESAME STREET" if rec_id==129;
replace license_merge23="GO DIEGO GO!" if rec_id==129;
replace license_merge24="GO DIEGO GO!" if rec_id==129;
replace license_merge25="SESAME STREET" if rec_id==129;
replace license_merge26="SESAME STREET" if rec_id==129;
replace license_merge27="DORA THE EXPLORER" if rec_id==129;
replace license_merge28="GO DIEGO GO!" if rec_id==129;
replace license_merge29="GO DIEGO GO!" if rec_id==129;
replace license_merge30="DORA THE EXPLORER" if rec_id==129;
replace license_merge31="DORA THE EXPLORER" if rec_id==129;
replace license_merge32="DORA THE EXPLORER" if rec_id==129;
replace license_merge1="BATMAN" if rec_id==135;
replace license_merge1="BARBIE" if rec_id==133;
replace license_merge1="BARBIE" if rec_id==140; 
replace license_merge1="THOMAS AND FRIENDS" if rec_id==137;
replace license_merge1="GEOTRAX" if rec_id==139;
replace license_merge1="THOMAS AND FRIENDS" if rec_id==144;
replace license_merge1="BABY EINSTEIN" if rec_id==150; /*This wasn't actually the license listed.*/
replace license_merge1="WINNIE THE POOH & FRIENDS" if rec_id==151;
replace license_merge2="DISNEY ALL OTHER" if rec_id==151; /*toy was not found, but looks like it would match license of disney and winnie the pooh.*/
replace license_merge1="GO DIEGO GO!" if rec_id==155;
replace license_merge1="WINNIE THE POOH & FRIENDS" if rec_id==166; 
replace license_merge1="PLAYSKOOL" if rec_id==86;
gen month = month(recall_date);
gen year = year(recall_date);
gen year_month = ym(year, month);
format year_month %tm;
compress;
/*	Create ID for merging news article data
	merging news articles for all recalls in 2007 and all recalls for which the firm is in the sales data	*/
gen news_comp="";
replace news_comp = 	"almar"	if rec_id==	87	;
replace news_comp = 	"americangreeting"	if rec_id==	55	;
replace news_comp = 	"armyair"	if rec_id==	175	;
replace news_comp = 	"armyair"	if rec_id==	118	;
replace news_comp = 	"armyair"	if rec_id==	126	;
replace news_comp = 	"battat"	if rec_id==	114	;
replace news_comp = 	"bookspan"	if rec_id==	117	;
replace news_comp = 	"bookspan"	if rec_id==	116	;
replace news_comp = 	"boydscollection"	if rec_id==	120	;
replace news_comp = 	"brio"	if rec_id==	67	;
replace news_comp = 	"creativeinov"	if rec_id==	63	;
replace news_comp = 	"creativeinov"	if rec_id==	69	;
replace news_comp = 	"dollargeneral"	if rec_id==	35	;
replace news_comp = 	"dollargeneral"	if rec_id==	162	;
replace news_comp = 	"dorel"	if rec_id==	46	;
replace news_comp = 	"dorel"	if rec_id==	124	;
replace news_comp = 	"dorel"	if rec_id==	54	;
replace news_comp = 	"dunkindonuts"	if rec_id==	153	;
replace news_comp = 	"eeboo"	if rec_id==	178	;
replace news_comp = 	"estescox"	if rec_id==	106	;
replace news_comp = 	"estescox"	if rec_id==	128	;
replace news_comp = 	"eveready"	if rec_id==	148	;
replace news_comp = 	"fareast"	if rec_id==	172	;
replace news_comp = 	"gemmy"	if rec_id==	121	;
replace news_comp = 	"geometrix"	if rec_id==	98	;
replace news_comp = 	"graco"	if rec_id==	112	;
replace news_comp = 	"greenbrier"	if rec_id==	173	;
replace news_comp = 	"guidecraft"	if rec_id==	141	;
replace news_comp = 	"gund"	if rec_id==	90	;
replace news_comp = 	"gymboree"	if rec_id==	154	;
replace news_comp = 	"hamptondirect"	if rec_id==	136	;
replace news_comp = 	"hape"	if rec_id==	113	;
replace news_comp = 	"hasbroall"	if rec_id==	100	;
replace news_comp = 	"hasbroall"	if rec_id==	127	;
replace news_comp = 	"hasbroall"	if rec_id==	86	;
replace news_comp = 	"hasbroall"	if rec_id==	62	;
replace news_comp = 	"henrygordy"	if rec_id==	157	;
replace news_comp = 	"internationalplaythings"	if rec_id==	56	;
replace news_comp = 	"internationalplaythings"	if rec_id==	57	;
replace news_comp = 	"internationalplaythings"	if rec_id==	64	;
replace news_comp = 	"internationalsourcing"	if rec_id==	163	;
replace news_comp = 	"jakkspacific"	if rec_id==	68	;
replace news_comp = 	"jakkspacific"	if rec_id==	101	;
replace news_comp = 	"jazzwares"	if rec_id==	103	;
replace news_comp = 	"jcpenney"	if rec_id==	151	;
replace news_comp = 	"joann"	if rec_id==	142	;
replace news_comp = 	"joann"	if rec_id==	174	;
replace news_comp = 	"joann"	if rec_id==	156	;
replace news_comp = 	"kbtoys"	if rec_id==	149	;
replace news_comp = 	"kidsii"	if rec_id==	150	;
replace news_comp = 	"kidspreferred"	if rec_id==	71	;
replace news_comp = 	"kidsstation"	if rec_id==	32	;
replace news_comp = 	"kippbrothers"	if rec_id==	125	;
replace news_comp = 	"kippbrothers"	if rec_id==	152	;
replace news_comp = 	"leapfrog"	if rec_id==	84	;
replace news_comp = 	"manstrading"	if rec_id==	177	;
replace news_comp = 	"manstrading"	if rec_id==	66	;
replace news_comp = 	"marveltoys"	if rec_id==	169	;
replace news_comp = 	"mattelall"	if rec_id==	44	;
replace news_comp = 	"mattelall"	if rec_id==	43	;
replace news_comp = 	"mattelall"	if rec_id==	61	;
replace news_comp = 	"mattelall"	if rec_id==	70	;
replace news_comp = 	"mattelall"	if rec_id==	94	;
replace news_comp = 	"mattelall"	if rec_id==	102	;
replace news_comp = 	"mattelall"	if rec_id==	129	;
replace news_comp = 	"mattelall"	if rec_id==	134	;
replace news_comp = 	"mattelall"	if rec_id==	131	;
replace news_comp = 	"mattelall"	if rec_id==	135	;
replace news_comp = 	"mattelall"	if rec_id==	132	;
replace news_comp = 	"mattelall"	if rec_id==	133	;
replace news_comp = 	"mattelall"	if rec_id==	138	;
replace news_comp = 	"mattelall"	if rec_id==	139	;
replace news_comp = 	"mattelall"	if rec_id==	140	;
replace news_comp = 	"mattelall"	if rec_id==	155	;
replace news_comp = 	"mattelall"	if rec_id==	160	;
replace news_comp = 	"maximenterprise"	if rec_id==	60	;
replace news_comp = 	"megabrands"	if rec_id==	72	;
replace news_comp = 	"megabrands"	if rec_id==	111	;
replace news_comp = 	"mgaent"	if rec_id==	65	;
replace news_comp = 	"oceandesertsales"	if rec_id==	37	;
replace news_comp = 	"okktrading"	if rec_id==	108	;
replace news_comp = 	"orientaltrading"	if rec_id==	79	;
replace news_comp = 	"orviscompany"	if rec_id==	130	;
replace news_comp = 	"rc2"	if rec_id==	89	;
replace news_comp = 	"rc2"	if rec_id==	122	;
replace news_comp = 	"rc2"	if rec_id==	144	;
replace news_comp = 	"rc2"	if rec_id==	143	;
replace news_comp = 	"schyllingassociates"	if rec_id==	137	;
replace news_comp = 	"schyllingassociates"	if rec_id==	165	;
replace news_comp = 	"schyllingassociates"	if rec_id==	167	;
replace news_comp = 	"schyllingassociates"	if rec_id==	164	;
replace news_comp = 	"schyllingassociates"	if rec_id==	166	;
replace news_comp = 	"simplyfun"	if rec_id==	158	;
replace news_comp = 	"smallworldimport"	if rec_id==	76	;
replace news_comp = 	"smallworldimport"	if rec_id==	110	;
replace news_comp = 	"smallworldimport"	if rec_id==	115	;
replace news_comp = 	"spinmaster"	if rec_id==	81	;
replace news_comp = 	"spinmaster"	if rec_id==	91	;
replace news_comp = 	"spinmaster"	if rec_id==	168	;
replace news_comp = 	"sportcraft"	if rec_id==	104	;
replace news_comp = 	"storkcraft"	if rec_id==	50	;
replace news_comp = 	"swimways"	if rec_id==	161	;
replace news_comp = 	"toysrus"	if rec_id==	85	;
replace news_comp = 	"toysrus"	if rec_id==	105	;
replace news_comp = 	"toysrus"	if rec_id==	147	;
replace news_comp = 	"toysrus"	if rec_id==	159	;
replace news_comp = 	"victoria"	if rec_id==	176	;
replace news_comp = 	"walmart"	if rec_id==	34	;
replace news_comp = 	"walmart"	if rec_id==	40	;
replace news_comp = 	"walmart"	if rec_id==	58	;
replace news_comp = 	"walmart"	if rec_id==	88	;
replace news_comp = 	"walmart"	if rec_id==	95	;
replace news_comp = 	"wildplanettoys"	if rec_id==	83	;

gen date = recall_date;
sort news_comp date;
merge news_comp date using ../data/newsdata, keep(articles_*) nokeep;
ta rec_id _merge;
replace articles_0to30=0 if _merge==1;
replace articles_neg30toneg1=0 if _merge==1;
drop _merge date;

replace datesold=	"6/2003"	if datesold=="3-Jun";
replace datesold=	"10/2003"	if datesold=="3-Oct";
replace datesold=	"7/2004"	if datesold=="4-Jul";
replace datesold=	"5/2004"	if datesold=="4-May";
replace datesold=	"7/2005"	if datesold=="5-Jul";
replace datesold=	"1/2006"	if datesold=="6-Jan";
replace datesold=	"3/2006"	if datesold=="6-Mar";
replace datesold=	"11/2006"	if datesold=="6-Nov";
replace datesold=	"11/2007"	if datesold=="7-Nov";
replace datesold=	"10/2007"	if datesold=="7-Oct";
split datesold;

gen solduntil = datesold9;
foreach var of varlist datesold8 datesold7 datesold6 datesold5 datesold4 datesold3 datesold2 datesold1 {;
	replace solduntil = `var' if solduntil == "" | solduntil=="-";
};
ta solduntil, missing;
replace solduntil = "8/2007" if solduntil=="8/20/07";
replace solduntil = "3/2006" if solduntil=="pre-3/31/2006";
drop datesold1-datesold9;
gen sold_until = monthly(solduntil, "my");
format sold_until %tm;
drop solduntil;
gen recall_month=mofd(recall_date);
format recall_month %tm;
gen on_market_recdate = sold_until >= recall_month;
ta on_market_recdate;
gen on_market_q4 = month(dofm(sold_until ))>=10;
ta on_market_q4;

/*Save this data set - This is now ready to merge with the sales data at either the product, manufacturer, brand, or license level*/
save ..\data\recall-for-merge-sales, replace;


**********************************;
**PART 3** Prepare recall data to merge with stock data;
**********************************;

/*right now we have one observation per recall.  each recall can be associated with multiple firms
(manufacturer, distributor, importer, retailer).  want to reshape data so we have one observation per
recall/firm*/
gen companymanuf1 = manufacturer1;
gen companymanuf2 = manufacturer2;
gen companydist = distributor;
gen companyimport1 = importer1;
gen companyimport2 = importer2;
gen companyimport3 = importer3;
gen companyimport4 = importer4;
gen companyret1 = retailer1;
gen companyret2 = retailer2;
gen companyret3 = retailer3;
gen companyret4 = retailer4;
gen companyret5 = retailer5;
gen companyret6 = retailer6;


reshape long company, i(rec_id) j(company_type) string;
drop if company==""; /*each recall has less than 10 firms - drop observations when recall doesn't have a particular firm type*/
replace company_type = "ret" if substr(company_type, 1, 3)=="ret";
replace company_type = "manuf" if substr(company_type, 1, 3)=="man";
replace company_type = "import" if substr(company_type, 1, 3)=="imp";

replace company = trim(company);
ta company;

*Reconcile firm names to be consistent;
replace company = "AAFES" if substr(company,1,5)=="AAFES";
replace company = "AAFES" if substr(company,1,6)=="Army &";
replace company = "American Girl" if substr(company,1,13)=="American Girl";
replace company = "Bell Racing" if substr(company,1,4)=="Bell";
replace company = "Brand Imports LLC" if substr(company,1,13)=="Brand Imports";
replace company = "BRIO AB" if substr(company,1,4)=="BRIO";
replace company = "Cunill Orfebres" if substr(company,1,6)=="Cunill";
replace company = "Dollar Bills" if substr(company,1,11)=="Dollar Bill";
replace company = "Dollar General" if substr(company,1,14)=="Dollar General" | substr(company,1,18)=="The Dollar General";
replace company = "Dollar Tree" if substr(company,1,11)=="Dollar Tree";
replace company = "Dunkin’ Donuts LLC" if substr(company,1,6)=="Dunkin";
replace company = "Easy-Bake" if substr(company,1,9)=="Easy-Bake";
replace company = "Far East Brokers and Consulting Inc." if substr(company,1,15)=="Far East Broker";
replace company = "Fisher-Price Inc." if substr(company,1,12)=="Fisher-Price";
replace company = "Fun Express Inc." if substr(company,1,11)=="Fun Express";
replace company = "HearthSong Inc." if substr(company,1,10)=="HearthSong";
replace company = "JCPenney" if substr(company,1,11)=="J.C. Penney";
replace company = "Jo-Ann Stores Inc." if substr(company,1,6)=="Jo-Ann";
replace company = "KB Toys Inc." if substr(company,1,7)=="KB Toys";
replace company = "Kindermusik International Inc." if substr(company,1,11)=="Kindermusik";
replace company = "Kipp Brothers" if substr(company,1,13)=="Kipp Brothers";
replace company = "Mattel Inc." if substr(company,1,6)=="Mattel";
replace company = "Man's Trading Company" if substr(company,1,3)=="MTC";
replace company = "Meijers" if substr(company,1,6)=="Meijer";
replace company = "Nintendo" if substr(company,1,8)=="Nintendo";
replace company = "Only $1" if substr(company,1,4)=="Only";
replace company = "ALEX" if substr(company,1,7)=="Panline";
replace company = "Pokemon" if substr(company,1,7)=="Pokemon";
replace company = "PlayWell Toy Company" if substr(company,1,8)=="Playwell";
replace company = "RC2 Corp." if substr(company,1,3)=="RC2";
replace company = "RadioShack Corp." if substr(company,1,10)=="RadioShack";
replace company = "The Ruby Restaurant Group" if substr(company,1,6)=="Ruby's";
replace company = "The Ruby Restaurant Group" if substr(company,1,8)=="The Ruby";
replace company = "Schylling Associates Inc." if substr(company,1,9)=="Schylling";
replace company = "SimplyFun LLC" if substr(company,1,9)=="SimplyFun";
replace company = "Sino Trading Group, LLC" if substr(company,1,4)=="Sino";
replace company = "Spin Master Toys" if substr(company,1,11)=="Spin Master";
replace company = "The Boyds Collections Ltd." if substr(company,1,9)=="The Boyds";
replace company = "The Gymboree Corp." if substr(company,1,8)=="Gymboree";
replace company = "The Orvis Company" if substr(company,1,5)=="Orvis";
replace company = "ThinkGeek Inc." if substr(company,1,9)=="ThinkGeek";
replace company = "Toys R Us Inc." if substr(company,1,9)=="Toys R Us";
replace company = "Wal-Mart Stores Inc." if substr(company,1,8)=="Wal-Mart";

ta company;

/*Do the same algorithm below for the "named" variables so they match the company names*/
replace named1 = "AAFES" if substr(named1,1,5)=="AAFES";
replace named1 = "AAFES" if substr(named1,1,6)=="Army &";
replace named1 = "American Girl" if substr(named1,1,13)=="American Girl";
replace named1 = "Bell Racing" if substr(named1,1,4)=="Bell";
replace named1 = "Brand Imports LLC" if substr(named1,1,13)=="Brand Imports";
replace named1 = "BRIO AB" if substr(named1,1,4)=="BRIO";
replace named1 = "Cunill Orfebres" if substr(named1,1,6)=="Cunill";
replace named1 = "Dollar Bills" if substr(named1,1,11)=="Dollar Bill";
replace named1 = "Dollar General" if substr(named1,1,14)=="Dollar General" | substr(named1,1,18)=="The Dollar General";
replace named1 = "Dollar Tree" if substr(named1,1,11)=="Dollar Tree";
replace named1 = "Dunkin’ Donuts LLC" if substr(named1,1,6)=="Dunkin";
replace named1 = "Easy-Bake" if substr(named1,1,9)=="Easy-Bake";
replace named1 = "Far East Brokers and Consulting Inc." if substr(named1,1,15)=="Far East Broker";
replace named1 = "Fisher-Price Inc." if substr(named1,1,12)=="Fisher-Price";
replace named1 = "Fun Express Inc." if substr(named1,1,11)=="Fun Express";
replace named1 = "HearthSong Inc." if substr(named1,1,10)=="HearthSong";
replace named1 = "JCPenney" if substr(named1,1,11)=="J.C. Penney";
replace named1 = "Jo-Ann Stores Inc." if substr(named1,1,6)=="Jo-Ann";
replace named1 = "KB Toys Inc." if substr(named1,1,7)=="KB Toys";
replace named1 = "Kindermusik International Inc." if substr(named1,1,11)=="Kindermusik";
replace named1 = "Kipp Brothers" if substr(named1,1,13)=="Kipp Brothers";
replace named1 = "Mattel Inc." if substr(named1,1,6)=="Mattel";
replace named1 = "Man's Trading named1" if substr(named1,1,3)=="MTC";
replace named1 = "Meijers" if substr(named1,1,6)=="Meijer";
replace named1 = "Nintendo" if substr(named1,1,8)=="Nintendo";
replace named1 = "Only $1" if substr(named1,1,4)=="Only";
replace named1 = "ALEX" if substr(named1,1,7)=="Panline";
replace named1 = "Pokemon" if substr(named1,1,7)=="Pokemon";
replace named1 = "PlayWell Toy Company" if substr(named1,1,8)=="Playwell";
replace named1 = "RC2 Corp." if substr(named1,1,3)=="RC2";
replace named1 = "RadioShack Corp." if substr(named1,1,10)=="RadioShack";
replace named1 = "The Ruby Restaurant Group" if substr(named1,1,6)=="Ruby's";
replace named1 = "The Ruby Restaurant Group" if substr(named1,1,8)=="The Ruby";
replace named1 = "Schylling Associates Inc." if substr(named1,1,9)=="Schylling";
replace named1 = "SimplyFun LLC" if substr(named1,1,9)=="SimplyFun";
replace named1 = "Sino Trading Group, LLC" if substr(named1,1,4)=="Sino";
replace named1 = "Spin Master Toys" if substr(named1,1,11)=="Spin Master";
replace named1 = "The Boyds Collections Ltd." if substr(named1,1,9)=="The Boyds";
replace named1 = "The Gymboree Corp." if substr(named1,1,8)=="Gymboree";
replace named1 = "The Orvis named1" if substr(named1,1,5)=="Orvis";
replace named1 = "ThinkGeek Inc." if substr(named1,1,9)=="ThinkGeek";
replace named1 = "Toys R Us Inc." if substr(named1,1,9)=="Toys R Us";
replace named1 = "Wal-Mart Stores Inc." if substr(named1,1,8)=="Wal-Mart";
replace named1 = "Mega Brands America, Inc." if substr(named1,1,8)=="Magnetix"; /*Magnetix is a brand of Mega Brands*/
replace named1 = "W.C. Bradley/Zebco Holdings Inc. doing business as Zebco" if substr(named1,1,5)=="Zebco"; /*change to be consistent with company variable*/


replace named2 = "AAFES" if substr(named2,1,5)=="AAFES";
replace named2 = "AAFES" if substr(named2,1,6)=="Army &";
replace named2 = "American Girl" if substr(named2,1,13)=="American Girl";
replace named2 = "Bell Racing" if substr(named2,1,4)=="Bell";
replace named2 = "Brand Imports LLC" if substr(named2,1,13)=="Brand Imports";
replace named2 = "BRIO AB" if substr(named2,1,4)=="BRIO";
replace named2 = "Cunill Orfebres" if substr(named2,1,6)=="Cunill";
replace named2 = "Dollar Bills" if substr(named2,1,11)=="Dollar Bill";
replace named2 = "Dollar General" if substr(named2,1,14)=="Dollar General" | substr(named2,1,18)=="The Dollar General";
replace named2 = "Dollar Tree" if substr(named2,1,11)=="Dollar Tree";
replace named2 = "Dunkin’ Donuts LLC" if substr(named2,1,6)=="Dunkin";
replace named2 = "Easy-Bake" if substr(named2,1,9)=="Easy-Bake";
replace named2 = "Far East Brokers and Consulting Inc." if substr(named2,1,15)=="Far East Broker";
replace named2 = "Fisher-Price Inc." if substr(named2,1,12)=="Fisher-Price";
replace named2 = "Fun Express Inc." if substr(named2,1,11)=="Fun Express";
replace named2 = "HearthSong Inc." if substr(named2,1,10)=="HearthSong";
replace named2 = "JCPenney" if substr(named2,1,11)=="J.C. Penney";
replace named2 = "Jo-Ann Stores Inc." if substr(named2,1,6)=="Jo-Ann";
replace named2 = "KB Toys Inc." if substr(named2,1,7)=="KB Toys";
replace named2 = "Kindermusik International Inc." if substr(named2,1,11)=="Kindermusik";
replace named2 = "Kipp Brothers" if substr(named2,1,13)=="Kipp Brothers";
replace named2 = "Mattel Inc." if substr(named2,1,6)=="Mattel";
replace named2 = "Man's Trading named2" if substr(named2,1,3)=="MTC";
replace named2 = "Meijers" if substr(named2,1,6)=="Meijer";
replace named2 = "Nintendo" if substr(named2,1,8)=="Nintendo";
replace named2 = "Only $1" if substr(named2,1,4)=="Only";
replace named2 = "ALEX" if substr(named2,1,7)=="Panline";
replace named2 = "Pokemon" if substr(named2,1,7)=="Pokemon";
replace named2 = "PlayWell Toy Company" if substr(named2,1,8)=="Playwell";
replace named2 = "RC2 Corp." if substr(named2,1,3)=="RC2";
replace named2 = "RadioShack Corp." if substr(named2,1,10)=="RadioShack";
replace named2 = "The Ruby Restaurant Group" if substr(named2,1,6)=="Ruby's";
replace named2 = "The Ruby Restaurant Group" if substr(named2,1,8)=="The Ruby";
replace named2 = "Schylling Associates Inc." if substr(named2,1,9)=="Schylling";
replace named2 = "SimplyFun LLC" if substr(named2,1,9)=="SimplyFun";
replace named2 = "Sino Trading Group, LLC" if substr(named2,1,4)=="Sino";
replace named2 = "Spin Master Toys" if substr(named2,1,11)=="Spin Master";
replace named2 = "The Boyds Collections Ltd." if substr(named2,1,9)=="The Boyds";
replace named2 = "The Gymboree Corp." if substr(named2,1,8)=="Gymboree";
replace named2 = "The Orvis named2" if substr(named2,1,5)=="Orvis";
replace named2 = "ThinkGeek Inc." if substr(named2,1,9)=="ThinkGeek";
replace named2 = "Toys R Us Inc." if substr(named2,1,9)=="Toys R Us";
replace named2 = "Wal-Mart Stores Inc." if substr(named2,1,8)=="Wal-Mart";
replace named2 = "Infantino LLC" if substr(named2,1,9)=="Infantino";



/*We can in some cases have more than one observation for each recall/firm combination.  This would happen if for example,
a firm was the importer and retailer of a product.  Want to reshape the data again so we have one observation per recall/firm and dummy variables for company type*/
gen recall_ = 1; /*when i reshape this variable, i will have indicators for company type*/
reshape wide recall_, i(rec_id company) j(company_type) string;
replace recall_dist = 0 if recall_dist==.;
replace recall_import = 0 if recall_import==.;
replace recall_manuf = 0 if recall_manuf==.;
replace recall_ret = 0 if recall_ret==.;



replace malfunctions = 0 if malfunctions==.;
replace dang_incidents = 0 if dang_incidents==.;
replace injuries = 0 if injuries == .;
replace deaths = 0 if deaths==.;
/*Malfunctions indicates the number of reports of the defect occuring, such as the toy breaking, or magnets coming loose*/
/*Dangerous incidents indicates the number of reports of a child doing something dangerous w/ the toy without injury, such as getting finger caught or mouthing loose pieces*/
/*Injuries and Deaths indicate the number of injuries or deaths reported*/
/*When Malfunctions>0 it should be inclusive of the other 3 variables*/




gen namedinrecall = company==named1 | company==named2;


preserve;

/*Companies from this list were put into excel.  I then looked up information on their tickers and if they are a subsidiary - 
this was put into recall-companies.csv, which I will now merge back into the recall-info-long file.*/

insheet using ..\data\raw-data\recall-companies.csv, c clear;
sort company;
save ..\data\recall-companies, replace;

restore;

sort company;
merge company using ..\data\recall-companies;
assert _merge==3;
drop _merge;
replace publicly_traded = 0 if publicly_traded==.;
replace subsid_or_division = 0 if subsid_or_division==.;

replace ticker = "EXX" if substr(ticker,1,3) == "EXX";/*for consistency w/ stock data - when we figure out exactly what we want to do with A and B stocks, we should probably merge the recall to both classes*/
replace ticker = "SPCH" if substr(ticker,1,4) == "SPCH";/*for consistency w/ stock data - when we figure out exactly what we want to do with A and B stocks, we should probably merge the recall to both classes*/
replace ticker = "DG" if ticker == "DOLR"; /*See company-comparison.xls*/
replace ticker = "SHLD" if ticker=="KMRT"; /*Kmart merges w/ Sears Holding Company in 2005 and changes ticker to SHLD.  In stock data I will replace all tickers with most recent tickers, so we want to merge on SHLD*/

sort ticker recall_date;
save ..\data\recall-for-merge-stock, replace;

/*	IDENTIFY THE RECALLING FIRM.  For most recalls, we have done this in the raw recall data.  Just 
deal with ones where there is no named firm in the recall text. */

/*	At this point, we still have multiple firms associated with each recall (and
an onbservation for each in the data).  How many on average?	*/
bysort rec_id: gen N=_N;
tab N;

/*	Make a "recaller" variable initially set to missing	*/
gen recaller = .;

/*	Set it equal to 1 for obs that have the "namedinrecall" variable turned on	*/
replace recaller=1 if namedinrecall==1;

/*	Now deal with recalls that have no named firm.  Make a flag to identify these recalls	*/
bysort rec_id: egen max_name=max(namedinrecall);
gen no_name=max_name==0;

/*	For no-name recalls with a manufacturer and no distributor or importer, make the manufacturer the recalling firm.  Turn
off recaller dummy for retailers associated with these recalls	*/
replace recaller = 1 if no_name==1 & manufacturer1~="" & distributor=="" & importer1=="" & company==manufacturer1; 
bysort rec_id: egen max_recaller = max(recaller); 
replace recaller = 0 if max_recaller==1 & recaller==.; 
drop max_rec;

/*	For recalls with a distributor and no manufacturer or importer, make the distributor the recalling firm.  Turn
off recaller dummy for retailers associated wtih these recalls	*/
replace recaller = 1 if no_name==1 & recaller==. & recall_dist==1 & manufacturer1=="" & importer1==""; 
bysort rec_id: egen max_recaller = max(recaller); 
replace recaller = 0 if max_recaller==1 & recaller==.; 
drop max_recaller; 

/*	For recalls with a named importer and no named manufacturer or distributor, make the importer (importer #1) the recalling firm.  Turn off
recaller dummy for retailers associated with these recalls	*/
replace recaller = 1 if no_name==1 & recaller==. & importer1~="" & manufacturer1=="" & distributor=="" & company==importer1; 
bysort rec_id: egen max_recaller = max(recaller); 
replace recaller = 0 if max_recaller==1 & recaller==.;
drop max_rec;

/*	How many recalls are left with still no "recaller" firm identified?	*/
replace recaller=-1 if recaller==.;
bysort rec_id: egen max_temp=max(recaller);
tab rec_id if max_temp==-1;
/*	5 recalls left	*/


/*	Now just left with recalls that have more than one firm named from among the manufacturer/distributor/importer or where previous code didn't work
for very idiosyncratic reason	*/

/*	when we have both a named distributor and importer - have 2 cases of this and its the same firm in both fields	*/
replace recaller=1 if no_name==1 & recaller==-1 & manufacturer1=="" & distributor~="" & importer1~="" & distributor==importer1 & company==distributor; 
bysort rec_id: egen max_recaller = max(recaller); 
replace recaller = 0 if max_recaller==1 & recaller==-1;
drop max_rec;

/*	Check again	*/
drop max_temp;
bysort rec_id: egen max_temp=max(recaller);
tab rec_id if max_temp==-1;

/*	3 left that didn't get picked up by earlier code b/c name under "company" isn't identical
to name under "manufacturer1" or "importer1" and code required this.  Fix those here - note
that each of these only have one company associated with them so just make this company
the recalling firm	*/
replace recaller=1 if recaller==-1;

/*	Now, keep only recalling firms	*/
keep if recaller==1;
count;

/*	188 recall-firm observations, 178 separate recalls.  means we have 10 recalls that are associated
with 2 named firms.  Looking it these, it's apparent that in each case, the "second" named firm
is the exclusive retailers.  Drop these.	*/
capture drop N;
bysort rec_id: gen N=_N;
drop if N==2 & recall_ret==1;
/*Number of units recalled*/
gen units_recalled = numberofunitsrecalled;
replace units_recalled = "500,000" if units_recalled=="500,000 (additionaly 700,000 worldwide)"; /*want a numeric variable for number recalled.  for now will replace this one observation w/ the number of domestic units recalled*/
destring units_recalled, replace ignore(",");

/*Price of good*/
gen price_raw = price;
replace price = "0" if price == "Free";
split price, p(-) ignore($) destring;
rename price1 price_min;
rename price2 price_max;
replace price_max = price_min if price_max==.; /*for prices without a range, price_min = price_max*/
gen price_avg = (price_min+price_max)/2;

/*Recall Value - Price X units*/
gen recall_value = price_avg*units_recalled;

/*Hazard Type*/
gen lead = prim_hazard=="Lead";
gen magnets = prim_hazard == "Magnets";


/*Made in China Dummy*/
gen made_in_china = made_in=="China";

/*	Now collapse to ticker-recall level so recalls by the same firm on same day get put togheter as one event.
Note that since we still have recalls by non-publicly traded firms in here - which have ticker=="" - 
these will get combined into a single observation (or a single day's recall).  We eventually drop these.
Note that for the recall characteristics, i am summing them up - so that if Mattel
has two recalls on same day, the  recalled is the sum of the units from each recall not
the average, same with injuries etc...	*/


collapse  (count) nannounce=rec_id (sum) malf (sum) death (sum) dang (sum) injuries lead magnets recall_value made_in_china (mean) articles* publicly_traded, by(ticker recall_date); 


/*	Drop if not publicly traded	*/
drop if publicly_traded==0;  /* get rid of recalls to non publicly traded companies*/
drop if ticker == "BRIO-B.STO" | ticker == "NTDO Y" | ticker == "MB"; /*these companies not traded in the US*/
drop if ticker == "SMWK"; /*small world toys is traded over the counter*/

/*	Drop recalls that firms have after they stop being publicly traded	*/
drop if ticker == "TOY" & recall_date>d(21jul2005); /*Stops trading on July 12, 2005*/ 
drop if ticker == "DG" & recall_date>d(6jul2007); /*Stops trading on July 6, 2007*/

/*	Drop Kmart Recall - when recall occured on july 21, 2004, Kmart was not publicly traded until purchased by Sears in 2005	*/
drop if ticker=="SHLD";

/*	Now summarize the dataset	*/
count; /*  56 recalls by publicly traded firms 	*/

egen t=group(ticker);
sum t;
/*	24 firms involved	*/
sum;

/*	Label the events for each firm*/
gen recallnumber = _n;
bysort ticker: gen set = _n; 
sort ticker set;
count;
rename recall_date event_date;

/*	Make a top 15 dummy	*/
gen top15 = ticker == "HAS" | ticker == "JAKK" | ticker == "LF" | ticker == "MAT" | ticker == "MVL" | ticker == "RCRC" | ticker == "KNM";

/*	save dataset of publicly traded recalls	*/
save ../data/pubtraded_recall_dates, replace;
/*	56 events	*/

/*	Make a dataset that has # of events for each firm	*/
sort ticker event_date;
by ticker: gen eventcount=_N; 
by ticker: keep if _n==1;
sort ticker;
keep ticker eventcount;
save ../data/eventcount, replace;
clear;


