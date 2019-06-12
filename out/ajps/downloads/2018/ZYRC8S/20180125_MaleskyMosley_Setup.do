
use "PCI_FDI_TPP_2015_v13.dta", clear
sort id pci_id
set more off


/*Generate Treatment Variable*/
generate India=1 if form=="B"
replace India=0 if form=="A"
generate Europe=1 if form=="A"
replace Europe=0 if form=="B"
lab var India "Treatment=India=1"
lab var Europe "Treatment=Europe=1"
label values India treatment
label define treatment 1 "India" 0"Europe", modify 
label values India treatment2
label define treatment2 0 "India" 1"Europe", modify 

tabstat exporter, by(sector)
lab var exporter "Firm Currently Engages in Direct or Indirect Export"
label values exporter yesno
label define yesno 1 "Yes" 0"No", modify 

lab var importer "Firm Imports Goods from Oversead Directly or Indirectly"
label values importer yesno
label define yesno 1 "Yes" 0"No", modify 

generate export_potential=1 if sector=="A" |sector=="B"|sector=="C"|sector=="G"|sector=="M"|sector=="H"|sector=="J"
replace export_potential=0 if export_potential==.
lab var export_potential "Firm Operates in Industry with Potential to Export"
label values export_potential yesno
label define yesno 1 "Yes" 0"No", modify 


/*Clean Country Name and Code OECD*/
replace companycountry=managercountry if companycountry==""
replace companycountry="Austria" if companycountry=="Ao"
replace companycountry="Australia" if companycountry=="Úc"
replace companycountry="Belgium" if companycountry=="Bi"
replace companycountry="China" if companycountry=="Thuong Hai, Trung Quoc" | companycountry=="Trung Quoc"
replace companycountry="Cayman Islands" if companycountry=="Island"
replace companycountry="Denmark" if companycountry=="Dan Mach" | companycountry=="Dan mach"
replace companycountry="France" if companycountry=="Phap" | companycountry=="French Polinesia"| companycountry=="French"
replace companycountry="Germany" if companycountry=="Duc" | companycountry=="germany"
replace companycountry="Hong Kong" if companycountry=="HongKong" | companycountry=="Hongkong" | companycountry=="Hong Hong"
replace companycountry="Hungary" if companycountry=="Hungari"
replace companycountry="India" if companycountry=="An Do" | companycountry=="AnDo"
replace companycountry="Indonesia" if companycountry=="Indonexia"
replace companycountry="Israel" if companycountry=="Isarel"
replace companycountry="Italy" if companycountry=="Italia"
replace companycountry="Japan" if companycountry=="Nhat" | companycountry=="NHat" | companycountry=="Nhat Ban" | companycountry=="Nhat ban" | companycountry=="Tokyo-Nhat Ban"
replace companycountry="Malaysia" if companycountry=="malaysia"
replace companycountry="South Korea" if companycountry=="HAN QUOC" | companycountry=="Han Quoc" | companycountry=="HAN QUỐC" | companycountry=="Korea" | companycountry=="Soul, Korea" | companycountry=="HᮠQu?c" |companycountry=="Korea (Republic)"
replace companycountry="Netherlands" if companycountry=="Ha Lan" | companycountry=="Ha lan"
replace companycountry="Norway" if companycountry=="Na Uy" | companycountry=="Nauy" | companycountry=="Nauy (Chau Au)"
replace companycountry="Philippines" if companycountry=="Philippin"
replace companycountry="Singapore" if companycountry=="SINGAPORE" | companycountry=="singapore"
replace companycountry="Spain" if companycountry=="Tay Ban Nha"
replace companycountry="Sweden" if companycountry=="Thuy Dien"
replace companycountry="Taiwan" if companycountry=="Dai Loan" | companycountry=="Taipei" | companycountry=="?A?I LOAN" | companycountry=="?᩠Loan" | companycountry=="dai loan"
replace companycountry="Thailand" if companycountry=="THai Lan" | companycountry=="Thai Lan" | companycountry=="Thai lan" | companycountry=="thai lan"
replace companycountry="Turkey" if companycountry=="Tho Nhi Ky"
replace companycountry="United Kingdom" if companycountry=="Anh" | companycountry=="Anh Quoc"| companycountry=="British Virgin Islands"
replace companycountry="United States" if companycountry=="USA" | companycountry=="Hoa Ki" | companycountry=="My" | companycountry=="my" | companycountry=="Hoa Ky" |companycountry=="American Samoa"| companycountry=="United States" | companycountry=="United States of America" 
replace companycountry="Vietnam" if companycountry=="Viet Nam"  | companycountry== "V?봠Nam" | companycountry=="VI?T NAM" | companycountry=="Vi?t Nam" | companycountry=="Viet nam" | companycountry=="Vi뀴 Nam"
replace companycountry="Finland" if companycountry=="Phan Lan"
replace companycountry="United Kingdom" if companycountry=="England"
replace companycountry="Virgin Islands" if companycountry=="Islands"

generate European=1 if companycountry=="Austria"|companycountry=="Belgium"|companycountry=="Denmark"|companycountry=="England"|companycountry=="France"|companycountry=="Germany"|companycountry=="Ireland"|companycountry==" Italy"|companycountry=="Netherlands"|companycountry=="Monaco"|companycountry=="Netherlands"|companycountry=="Norway"|companycountry=="Spain"|companycountry=="Sweden"|companycountry=="Switzerland"|companycountry=="United Kingdom"
replace European=0 if European==.
lab var European "Home Country is In Europe=1"
label values European yesno


generate indian=1 if companycountry=="India"
replace indian=0 if companycountry !="India"
lab var indian "Home Country is In India=1"
label values indian yesno


encode companycountry, gen(country_id)
lab var country_id "Home Country ID"


/*******************************************************************************************************************************************/

/*Generate Binned Dependent Variable*/
#delimit;
gen heap=1 if g13>0 & g13<=4;
replace heap=2 if g13>4 & g13<=9;
replace heap=3 if g13>9 & g13<=14;
replace heap=4 if g13>15 & g13<=16;

label variable heap "Operating Costs Binned";
label values heap heap;
label define heap 1 "0-4" 2 "5-9" 3"10-14" 4">15";

gen heap2=1.2 if g13>0 & g13<=4;
replace heap2=2.2 if g13>4 & g13<=9;
replace heap2=3.2 if g13>9 & g13<=14;
replace heap2=4.2 if g13>=15 & g13<=16;
label variable heap2 "Operating Costs Binned (adjusted by .2 for graphing)";


/*Create Strata for Clustered Errors*/
egen strata=group(sector_plus pci_id companycountry);
lab var strata "Stratifications for Clustering: Sector, Country, Province";

#delimit;
egen strata2=group(pci_id companycountry);
lab var strata2 "Alternative Strata: Sector-Country";


/*Sales Destination*/
	
#delimit;	
split export_country, generate(destination_) parse(,);
generate destination_India=1 if destination_1=="India";
generate destination_Europe=1 if destination_1=="Austria"|destination_1=="Belgium"|destination_1=="Denmark"|destination_1=="England"|
	destination_1=="France"|destination_1=="Germany"|destination_1=="Ireland"|destination_1=="Italy"|destination_1=="Netherlands"|destination_1=="Monaco"|destination_1=="Netherlands"|
	destination_1=="Norway"|destination_1=="Spain"|destination_1=="Sweden"|destination_1=="Switzerland"|destination_1=="United Kingdom"|destination_1=="Europe";
forval num= 2(1)21 {;
display `num';
replace destination_India=1 if destination_`num'=="India";
replace destination_India=0 if destination_India==.;
replace destination_Europe=1 if destination_`num'=="Austria"|destination_`num'=="Belgium"|destination_`num'=="Denmark"|destination_`num'=="England"|
	destination_`num'=="France"|destination_`num'=="Germany"|destination_`num'=="Ireland"|destination_`num'=="Italy"|destination_`num'=="Netherlands"|destination_`num'=="Monaco"|destination_`num'=="Netherlands"|
	destination_`num'=="Norway"|destination_`num'=="Spain"|destination_`num'=="Sweden"|destination_`num'=="Switzerland"|destination_`num'=="United Kingdom"|destination_`num'=="Europe";
replace destination_Europe=0 if destination_Europe==.;
drop destination_`num';
};


lab var destination_India "Firm Exports to India=1";
label values destination_India yesno;
lab var destination_Europe "Firm Exports to Europe=1";
label values destination_Europe yesno;


/*Merge in Industrial Destination Data - Data from PCI-Vietnam Raw*/
#delimit;
drop _merge;
sort destination_1;
merge m:1 destination_1 using "destination_developed_v13.dta";
lab var destination_1 "Primary Export Destination";
lab var destination_developed "Firm Exports to Developed Country";
label values destination_developed yesno;

/*Label Industry*/
#delimit;
encode sector_plus, gen(sector_id);
label values sector_id sector_id2;
label define sector_id2 1 "Agriculture/Aquaculture" 2 "Mining"  3 "M:Food Processing" 4 "M:Textiles" 5 "M:Garments" 6 "M:Leather" 7 "M:Wood Products"
8 "M:Paper Products" 9 "M:Chemicals" 10 "M:Rubber/Plastics" 11 "M:Basic Metals" 12 "M:Fabricated Metals" 13 "M:Computers/Electronics"     
14 "M:Electronic Equip." 15 "M:Machinery" 16 "M:Motor Vehicles" 17 "M:Furniture" 18 "M: Other" 19 "Electricity/Gas/AC" 20 "Construction"
21 "Wholesale/Retail" 22 "Information/Communication" 23 "Financial/Insurance" 24 "Real Estate" 25 "Professional Services" 26 "Other Services";



/*Creation of and Labeling of Covariates for Balance Check*/
#delimit;
generate male_CEO=gender;
replace male_CEO=0 if gender==2;
lab var male_CEO "Male CEO";
generate age=(2016-year_registered);
lab var age  "Years Since Entry into Vietnam";
generate ln_age=ln(age);
lab var ln_age  "Years Since Entry into Vietnam (ln)";

generate nr=1  if g13==.b;
replace nr=0 if g13!=.b;
lab var nr "Non-Response to Survey Experiment";

generate ln_contract=ln(g1_3+1);
lab var ln_contract "Workers with Formal Contract (ln)";

generate expand2=1 if expand<=2;
replace expand2=0 if expand>2;
lab var expand2 "Plan to Expand Business in Next 2 Years";


generate hundred=1 if fdi_form==1;
replace hundred=0 if fdi_form>1;
lab var hundred "MNC is 100% Foreign Owned";

/*Create Continuous Measure of Labor for Balance Check*/
generate labor=2.5 if lsize_2014==1;
replace labor=5 if lsize_2014==2;
replace labor=25 if lsize_2014==3;
replace labor=125 if lsize_2014==4;
replace labor=250 if lsize_2014==5;
replace labor=400 if lsize_2014==6;
replace labor=750 if lsize_2014==7;
replace labor=1500 if lsize_2014==8;
lab var labor "Number of Employees in Firm";


/*Create Continuous Measure of Capital for Balance Check*/
replace ksize_2014=ksize_2013 if ksize_2014==.;
replace ksize_2014=ksize_est if ksize_2014==.;
generate capital=.25 if ksize_2014==1;
replace capital=.75 if ksize_2014==2;
replace capital=3 if ksize_2014==3;
replace capital=7.5 if ksize_2014==4;
replace capital=30 if ksize_2014==5;
replace capital= 125 if ksize_2014==6;
replace capital=350 if ksize_2014==7;
replace capital=500 if ksize_2014==8;
lab var capital "Investment Size of Firm in USD $100,000";


sum capital labor, detail;
display (30*1000000000)/21340.00;

/*Create Measures of Profitability and Losing Firms for Balance Table*/
generate profitable=1 if  performance_2014>=5 & performance_2014 !=. &  performance_2014 !=.a &  performance_2014 !=.b;
replace profitable=0 if performance_2014< 5;
sum profitable;
lab var profitable "Firm was Profitable in 2014";

generate losing=1 if  performance_2014<=3;
replace losing=0 if  performance_2014>3  &  performance_2014 !=. &  performance_2014 !=.a &  performance_2014 !=.b;
sum losing ;
lab var losing "Firm Lost Money in 2014";


/*Save Working Data*/
saveold "20171204_AJPS_MaleskyMosely.dta", version(13) replace;




