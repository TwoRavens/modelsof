*
*This file formats the input data that are needed for the creation of Figure 1 in
*"Droughts, Land Appropriation, and Rebel Violence in The Developing World"
*by Benjamin E. Bagozzi, Ore Koren, and Bumba Mukherjee
*

*clear stata, set working directory
clear
set more off
cd "\JOP Replication Files\Figure 1\"

*read in PRIO-GRID data
use "full.grid.dta", clear 

*subset sample to only include developing countries included within analysis
keep if cname=="Afghanistan" |	cname=="Guinea" | cname=="Panama" | cname=="Albania" | cname=="Guinea-Bissau" | cname=="Papua New Guinea" | cname=="Algeria" | cname=="Guyana" | cname=="Paraguay" | cname=="Haiti" | cname=="Peru" | cname=="Angola" | cname=="Honduras" | cname=="Philippines" | cname=="Argentina" | cname=="India" | cname=="Rumania" | cname=="Armenia" | cname=="Indonesia" | cname=="Russian (Soviet Union)" | cname=="Azerbaijan" | cname=="Iran (Persia)" | cname=="Rwanda" | cname=="Bangladesh" | cname=="Iraq" | cname=="Samoa/Western Samoa" | cname=="Belarus (Byelorussia)" | cname=="Jamaica" | cname=="São Tomé and Principe" | cname=="Belize" | cname=="Jordan" | cname=="Senegal" | cname=="Benin" | cname=="Kazakhstan" | cname=="Serbia" | cname=="Bhutan" | cname=="Kenya" | cname=="Seychelles" | cname=="Bolivia" | cname=="Kiribati" | cname=="Sierra Leone" | cname=="Bosnia-Herzegovina" | cname=="Korea, People's Republic of" | cname=="Solomon Islands" | cname=="Botswana" | cname=="Kosovo" | cname=="Somalia" | cname=="Brazil" | cname=="Kyrgyz Republic" | cname=="South Africa" | cname=="Bulgaria" | cname=="Laos" | cname=="South Sudan" | cname=="Burkina Faso (Upper Volta)" | cname=="Latvia" | cname=="Sri Lanka (Ceylon)" | cname=="Burundi" | cname=="Lebanon" | cname=="Saint Kitts and Nevis" | cname=="Cambodia (Kampuchea)" | cname=="Lesotho" | cname=="Saint Lucia" | cname=="Cameroon" | cname=="Liberia" | cname=="Saint Vincent and the Grenadines" | cname=="Cape Verde" | cname=="Libya" | cname=="Sudan" | cname=="Central African Republic" | cname=="Lithuania" | cname=="Suriname" | cname=="Chad" | cname=="Macedonia (Former Yugoslav Republic of)" | cname=="Swaziland" | cname=="Chile" | cname=="Madagascar (Malagasy)" | cname=="Syria" | cname=="China" | cname=="Malawi" | cname=="Tajikistan" | cname=="Colombia" | cname=="Malaysia" | cname=="Tanzania/Tanganyika" | cname=="Comoros" | cname=="Maldives" | cname=="Thailand" | cname=="Congo, Democratic Republic of (Zaire)" | cname=="Mali" | cname=="East Timor" | cname=="Congo" | cname=="Marshall Islands" | cname=="Togo" | cname=="Costa Rica" | cname=="Mauritania" | cname=="Tonga" | cname=="Cote D’Ivoire" | cname=="Mauritius" | cname=="Tunisia" | cname=="Cuba" | cname=="Mexico" | cname=="Turkey (Ottoman Empire)" | cname=="Djibouti" | cname=="Federated States of Micronesia" | cname=="Turkmenistan" | cname=="Dominica" | cname=="Moldova" | cname=="Tuvalu" | cname=="Dominican Republic" | cname=="Mongolia" | cname=="Uganda" | cname=="Ecuador" | cname=="Montenegro" | cname=="Ukraine" | cname=="Egypt" | cname=="Morocco" | cname=="Uruguay" | cname=="El Salvador" | cname=="Mozambique" | cname=="Uzbekistan" | cname=="Eritrea" | cname=="Myanmar (Burma)" | cname=="Vanuatu" | cname=="Ethiopia" | cname=="Namibia" | cname=="Venezuela" | cname=="Fiji" | cname=="Nepal" | cname=="Vietnam, Democratic Republic of" | cname=="Gabon" | cname=="Nicaragua" | cname=="Gambia" | cname=="Niger" | cname=="Yemen (Arab Republic of Yemen)" | cname=="Georgia" | cname=="Nigeria" | cname=="Zambia" | cname=="Ghana" | cname=="Pakistan" | cname=="Zimbabwe (Rhodesia)" | cname=="Grenada" | cname=="Palau" | cname=="Guatemala"

*drop years that are not included in the analysis
drop if year>2008
drop if year<1995

*collapse mean level of cropland, by grid/lat/long
collapse (mean) cropland, by(gid longitude latitude)

*save dataset in old format for analysis in R
saveold  "collapsed.grid.dta", replace


