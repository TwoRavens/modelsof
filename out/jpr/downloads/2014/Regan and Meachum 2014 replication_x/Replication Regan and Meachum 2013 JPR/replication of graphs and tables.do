***********************************************************************
**********Do-file for Figures 1, 2, 3, and Appendix materials**********
*****************All Figures were created using Excel******************
*********user can cut and paste the output into an Excel sheet and graph****
***********************************************************************

*Load full dataset from user's directory

*Figure 1 describes the number of at-risk states per year, thus year-at-risk is the unit of observation

*This command collapses the data to the country-year level
collapse (sum)military_intervention (sum)economic_intervention (sum)diplomatic_intervention, by(country ccode year)

*Figure 1 - "At-risk states by year"
tab year
clear

****************************************************************
*****Reopen full data from user's directory. The user must reopen the original file in order to retain the complete list of variables.
****************************************************************

*The first two steps merely rename some variables for use later

rename country country_abb
rename ccode cowcode

*Add in the full country name based on COW code
gen country=""

replace country="USA" if cowcode==2
replace country="Canada" if cowcode==20
replace country="Bahamas" if cowcode==31
replace country="Cuba" if cowcode==40
replace country="Haiti" if cowcode==41
replace country="Dominican Republic" if cowcode==42
replace country="Jamaica" if cowcode==51
replace country="Trinidad" if cowcode==52
replace country="Barbados" if cowcode==53
replace country="Dominica" if cowcode==54
replace country="Grenada" if cowcode==55
replace country="St. Lucia" if cowcode==56
replace country="St. Vincent and Grenadines" if cowcode==57
replace country="Antigua" if cowcode==58
replace country="St. Kitts and Nevis" if cowcode==60

replace country="Mexico" if cowcode==70
replace country="Belize" if cowcode==80
replace country="Guatemala" if cowcode==90
replace country="Honduras" if cowcode==91
replace country="El Salvador" if cowcode==92
replace country="Nicaragua" if cowcode==93
replace country="Costa Rica" if cowcode==94
replace country="Panama" if cowcode==95

replace country="Colombia" if cowcode==100
replace country="Venezuela" if cowcode==101
replace country="Guyana" if cowcode==110
replace country="Suriname" if cowcode==115
replace country="Ecuador" if cowcode==130
replace country="Peru" if cowcode==135
replace country="Brazil" if cowcode==140
replace country="Bolivia" if cowcode==145
replace country="Paraguay" if cowcode==150
replace country="Chile" if cowcode==155
replace country="Argentina" if cowcode==160
replace country="Uruguay" if cowcode==165

replace country="UK" if cowcode==200
replace country="Ireland" if cowcode==205
replace country="Netherlands" if cowcode==210
replace country="Belgium" if cowcode==211
replace country="Luxembourg" if cowcode==212
replace country="France" if cowcode==220
replace country="Monaco" if cowcode==221
replace country="Liechtenstein" if cowcode==223
replace country="Switzerland" if cowcode==225
replace country="Spain" if cowcode==230
replace country="Andorra" if cowcode==232
replace country="Portugal" if cowcode==235
replace country="Germany" if cowcode==255
replace country="Germany Federal Republic" if cowcode==260
replace country="German Democratic Republic" if cowcode==265

replace country="Poland" if cowcode==290
replace country="Austria" if cowcode==305
replace country="Hungary" if cowcode==310
replace country="Czechoslovakia" if cowcode==315
replace country="Czech Republic" if cowcode==316
replace country="Slovakia" if cowcode==317
replace country="Italy" if cowcode==325
replace country="Vatican" if cowcode==327
replace country="San Marino" if cowcode==331
replace country="Malta" if cowcode==338
replace country="Albania" if cowcode==339
replace country="Macedonia" if cowcode==343
replace country="Croatia" if cowcode==344
replace country="Yugoslavia" if cowcode==345
replace country="Bosnia" if cowcode==346
replace country="Slovenia" if cowcode==349
replace country="Greece" if cowcode==350
replace country="Cyprus" if cowcode==352

replace country="Bulgaria" if cowcode==355
replace country="Moldova" if cowcode==359
replace country="Romania" if cowcode==360
replace country="Russia" if cowcode==365
replace country="Estonia" if cowcode==366
replace country="Latvia" if cowcode==367
replace country="Lithuania" if cowcode==368
replace country="Ukraine" if cowcode==369
replace country="Belarus" if cowcode==370
replace country="Armenia" if cowcode==371
replace country="Georgia" if cowcode==372
replace country="Azerbaijan" if cowcode==373

replace country="Finland" if cowcode==375
replace country="Sweden" if cowcode==380
replace country="Norway" if cowcode==385
replace country="Denmark" if cowcode==390
replace country="Iceland" if cowcode==395

replace country="Cape Verde" if cowcode==402
replace country="Sao Tome" if cowcode==403
replace country="Guinea-Bisau" if cowcode==404
replace country="Equatorial Guinea" if cowcode==411
replace country="Gambia" if cowcode==420
replace country="Mali" if cowcode==432
replace country="Senegal" if cowcode==433
replace country="Benin" if cowcode==434
replace country="Mauritania" if cowcode==435
replace country="Niger" if cowcode==436
replace country="Ivory Coast" if cowcode==437
replace country="Guinea" if cowcode==438
replace country="Burkina Faso" if cowcode==439
replace country="Liberia" if cowcode==450
replace country="Sierra Leone" if cowcode==451
replace country="Ghana" if cowcode==452
replace country="Togo" if cowcode==461
replace country="Cameroon" if cowcode==471
replace country="Nigeria" if cowcode==475
replace country="Gabon" if cowcode==481

replace country="Central African Republic" if cowcode==482
replace country="Republic of Congo" if cowcode==483
replace country="Republic of Congo" if cowcode==484
replace country="Democratic Republic of Congo" if cowcode==490
replace country="Uganda" if cowcode==500
replace country="Kenya" if cowcode==501
replace country="Tanzania" if cowcode==510
replace country="Zanzibar" if cowcode==511
replace country="Burundi" if cowcode==516
replace country="Rwanda" if cowcode==517
replace country="Somalia" if cowcode==520
replace country="Djibouti" if cowcode==522
replace country="Ethiopia" if cowcode==530
replace country="Eritrea" if cowcode==531

replace country="Angola" if cowcode==540
replace country="Mozambique" if cowcode==541
replace country="Zambia" if cowcode==551
replace country="Zimbabwe" if cowcode==552
replace country="Malawi" if cowcode==553
replace country="South Africa" if cowcode==560
replace country="Namibia" if cowcode==565
replace country="Lesotho" if cowcode==570
replace country="Botswana" if cowcode==571
replace country="Swaziland" if cowcode==572
replace country="Madagascar" if cowcode==580
replace country="Comoros" if cowcode==581
replace country="Mauritius" if cowcode==590
replace country="Seychelles" if cowcode==591

replace country="Morocco" if cowcode==600
replace country="Algeria" if cowcode==615
replace country="Tunisia" if cowcode==616
replace country="Libya" if cowcode==620
replace country="Sudan" if cowcode==625
replace country="Iran" if cowcode==630
replace country="Turkey" if cowcode==640
replace country="Iraq" if cowcode==645
replace country="Egypt" if cowcode==651
replace country="Syria" if cowcode==652
replace country="Lebanon" if cowcode==660
replace country="Jordan" if cowcode==663
replace country="Israel" if cowcode==666
replace country="Saudi Arabia" if cowcode==670
replace country="Yemen Arab Republic" if cowcode==678
replace country="Yemen" if cowcode==679
replace country="Yemen People's Republic" if cowcode==680
replace country="Kuwait" if cowcode==690
replace country="Bahrain" if cowcode==692
replace country="Qatar" if cowcode==694
replace country="United Arab Emirates" if cowcode==696
replace country="Oman" if cowcode==698

replace country="Afghanistan" if cowcode==700
replace country="Turkmenistan" if cowcode==701
replace country="Tajikistan" if cowcode==702
replace country="Kyrgyzstan" if cowcode==703
replace country="Uzbekistan" if cowcode==704
replace country="Kazakhstan" if cowcode==705
replace country="China" if cowcode==710
replace country="Tibet" if cowcode==711
replace country="Mongolia" if cowcode==712
replace country="Taiwan" if cowcode==713
replace country="Korea" if cowcode==730
replace country="North Korea" if cowcode==731
replace country="South Korea" if cowcode==732
replace country="Japan" if cowcode==740
replace country="India" if cowcode==750
replace country="Bhutan" if cowcode==760
replace country="Pakistan" if cowcode==770
replace country="Bangladesh" if cowcode==771
replace country="Myanmar" if cowcode==775
replace country="Sri Lanka" if cowcode==780
replace country="Maldives" if cowcode==781
replace country="Nepal" if cowcode==790

replace country="Thailand" if cowcode==800
replace country="Cambodia" if cowcode==811
replace country="Laos" if cowcode==812
replace country="Vietnam" if cowcode==816
replace country="Republic of Vietnam" if cowcode==817
replace country="Malaysia" if cowcode==820
replace country="Singapore" if cowcode==830
replace country="Brunei" if cowcode==835
replace country="Philippines" if cowcode==840
replace country="Indonesia" if cowcode==850
replace country="East Timor" if cowcode==860
replace country="Australia" if cowcode==900
replace country="Papua New Guinea" if cowcode==910
replace country="New Zealand" if cowcode==920
replace country="Vanuatu" if cowcode==935
replace country="Solomon Islands" if cowcode==940
replace country="Kiribati" if cowcode==946
replace country="Tuvalu" if cowcode==947
replace country="Fiji" if cowcode==950
replace country="Tonga" if cowcode==955
replace country="Nauru" if cowcode==970
replace country="Marshall Islands" if cowcode==983
replace country="Palau" if cowcode==986
replace country="Micronesia" if cowcode==987
replace country="Samoa" if cowcode==990

order country, before (country_abb)

*Add region variable
gen region=0
replace region=1 if cowcode < 200
replace region=2 if cowcode > 199 & cowcode < 400
replace region=3 if cowcode > 399 & cowcode < 600
replace region=4 if cowcode > 599 & cowcode < 700
replace region=5 if cowcode > 699 & cowcode < 900
replace region=6 if cowcode > 899 & cowcode < 1000 

gen country_year=((cowcode*10000) + (year)) 
codebook country country_year year

*Figures 2 and 3 use interventions as the unit of analysis, therefore we drop observations without interventions
*This leaves us with 449 total interventions
drop if intervention_date==.

*generate a total number of interventions variable for Figure 2
gen tot_inter=military_intervention+economic_intervention+diplomatic_intervention

*generate a single manner of intervention variable (to indicate miltary, economic, diplomatic) for Figure 3
gen manner_inter=.
replace manner_inter=1 if diplomatic_intervention==1
replace manner_inter=2 if economic_intervention==1
replace manner_inter=3 if military_intervention==1
 
*Figure 2 - "Interventions by year"
table year tot_inter

*Figure 3 - "Interventions by region"
table region manner_inter

*The second table in the Appendix lists the intervener and the frequency of those interventions
tab intervener

*************************************************************************************
***This portion of the do-file recreates Tables IV and V in the empirical analysis***
*************************************************************************************

******use "duration analysis replication.dta" for the analysis in Tables IV and V******

*Load dataset with additional variables

*Generate lag and lead variables 
sort ccode year moco
by ccode: gen lagx = x[_n-1]
sort ccode year moco
by ccode: gen deltarisk=1 if x==0 & (lagx>0 & lagx~=.)
replace deltarisk=0 if deltarisk==.
by ccode: gen internawarlead=internalwar[_n+1]


*ongoingwar creates a variable equal to zero when internal war is one, because the two are coded as happening at the same time.  
*war starts and is also ongoing that month.  We then generate a variable that reflects only onsets (when ongoingwar==0). These variables are already in the 
*replication data but these commands show how they were created. 

****run the 'competing risk' commands below. 

replace ongoingwar=1 if internalwar==1 & onset==0
sort ccode year moco
by ccode: gen died=0
replace died=1 if onset==1 | deltarisk==1
gen diedII=1 if died==1 & onset~=1
replace diedII=0 if diedII==.

*Generate risk variables

gen inrisk=1 if risk>.29 & risk~=.
gen outrisk=1 if risk <.3 & risk~=.
replace inrisk=0 if inrisk==.
replace outrisk=0 if outrisk==.
replace inrisk=1 if inrisk==0 & inrisk[_n-1]==1 & inrisk[_n+1]==1


*these commands replicate the  duration models

gen competerisk=0
replace competerisk=1 if onset==1
replace competerisk=2 if stability==1

stset group, failure(stability)
stset, clear
stset group, failure(onset)
stset group, failure (competerisk==2) 

*This is the model to run for the duration part of the analysis
*Employ the stcox command to use the cox estimation in the paper - Table IV
stcox polity2 politysq aveelf avegdp mtnest1 aclagei aveopen dipdecay mildecay econdecay if riskID==1& ongoingwar==0 & popns>500000, robust cluster (ccode)

*For Table V, simply change the risk from onset to stability


