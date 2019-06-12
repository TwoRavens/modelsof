/*	This makes world bank regions */


gen WB_region="World Bank Region"
replace WB_region="Europe & Central Asia" if countryname=="Andorra"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Latin America & Caribbean" if countryname=="Antigua & Barbuda"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Latin America & Caribbean" if countryname=="Antilles"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Latin America & Caribbean" if countryname=="Aruba"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="Australia"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Austria"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Latin America & Caribbean" if countryname=="Bahamas"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Middle East & North Africa" if countryname=="Bahrain"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Latin America & Caribbean" if countryname=="Barbados"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Belgium"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Latin America & Caribbean" if countryname=="Bermuda"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="Brunei"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="North America" if countryname=="Canada"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Latin America & Caribbean" if countryname=="Cayman Islands"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Channel Islands"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Cyprus"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Czech Republic"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Denmark"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Estonia"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Faeroe Islands"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Finland"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="France"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="French Polynesia"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="German Federal Republic"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Greece"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Greenland"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="Guam"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="Hong Kong"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Iceland"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Ireland"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Isle Of Man"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Middle East & North Africa" if countryname=="Israel"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Italy/Sardinia"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="Japan"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="Korea, Republic of"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Middle East & North Africa" if countryname=="Kuwait"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Liechtenstein"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Luxembourg"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="Macao"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Malta"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Monaco"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Netherlands"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="New Caledonia"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="New Zealand"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Norway"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Portugal"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Latin America & Caribbean" if countryname=="Puerto Rico"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Middle East & North Africa" if countryname=="Qatar"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="San Marino"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Middle East & North Africa" if countryname=="Saudi Arabia"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="Singapore"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Slovenia"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Spain"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Sweden"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Switzerland"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Latin America & Caribbean" if countryname=="Trinidad and Tobago"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Middle East & North Africa" if countryname=="United Arab Emirates"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="United Kingdom"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="North America" if countryname=="United States of America"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="Tibet" /* I added this */
replace WB_region="Latin America & Caribbean" if countryname=="Virgin Islands"/* High income: Not assigned a world bank region--I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="Czechoslovakia" /*I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="German Democratic Republic" /*I made the assignment */
replace WB_region="Europe & Central Asia" if countryname=="" /*I made the assignment */
replace WB_region="East Asia & Pacific" if countryname=="Taiwan" /* I added this */

replace WB_region="East Asia & Pacific" if countryname=="Tuvalu" /* I added this--not sure */

replace WB_region="East Asia & Pacific" if countryname=="Vietnam, Republic of" /* I added this*/
replace WB_region="Middle East & North Africa" if countryname=="Yemen, People's Republic of" /* I added this*/
replace WB_region="Sub-Saharan Africa" if countryname=="Zanzibar" /* I added this*/
replace WB_region="East Asia & Pacific" if countryname=="Nauru" /* I added this--not sure */


replace WB_region="East Asia & Pacific" if countryname=="American Samoa"
replace WB_region="East Asia & Pacific" if countryname=="Cambodia (Kampuchea)"
replace WB_region="East Asia & Pacific" if countryname=="China"
replace WB_region="East Asia & Pacific" if countryname=="East Timor"
replace WB_region="East Asia & Pacific" if countryname=="Federated States of Micronesia"
replace WB_region="East Asia & Pacific" if countryname=="Fiji"
replace WB_region="East Asia & Pacific" if countryname=="Indonesia"
replace WB_region="East Asia & Pacific" if countryname=="Kiribati"
replace WB_region="East Asia & Pacific" if countryname=="Korea, People's Republic of"
replace WB_region="East Asia & Pacific" if countryname=="Laos"
replace WB_region="East Asia & Pacific" if countryname=="Malaysia"
replace WB_region="East Asia & Pacific" if countryname=="Marshall Islands"
replace WB_region="East Asia & Pacific" if countryname=="Mongolia"
replace WB_region="East Asia & Pacific" if countryname=="Myanmar (Burma)"
replace WB_region="East Asia & Pacific" if countryname=="Northern Marianas"
replace WB_region="East Asia & Pacific" if countryname=="Palau"
replace WB_region="East Asia & Pacific" if countryname=="Papua New Guinea"
replace WB_region="East Asia & Pacific" if countryname=="Philippines"
replace WB_region="East Asia & Pacific" if countryname=="Samoa/Western Samoa"
replace WB_region="East Asia & Pacific" if countryname=="Solomon Islands"
replace WB_region="East Asia & Pacific" if countryname=="Thailand"
replace WB_region="East Asia & Pacific" if countryname=="Tonga"
replace WB_region="East Asia & Pacific" if countryname=="Vanuatu"
replace WB_region="East Asia & Pacific" if countryname=="Vietnam, Democratic Republic of"
replace WB_region="Europe & Central Asia" if countryname=="Albania"
replace WB_region="Europe & Central Asia" if countryname=="Armenia"
replace WB_region="Europe & Central Asia" if countryname=="Azerbaijan"
replace WB_region="Europe & Central Asia" if countryname=="Belarus (Byelorussia)"
replace WB_region="Europe & Central Asia" if countryname=="Bosnia-Herzegovina"
replace WB_region="Europe & Central Asia" if countryname=="Bulgaria"
replace WB_region="Europe & Central Asia" if countryname=="Croatia"
replace WB_region="Europe & Central Asia" if countryname=="Georgia"
replace WB_region="Europe & Central Asia" if countryname=="Hungary"
replace WB_region="Europe & Central Asia" if countryname=="Kazakhstan"
replace WB_region="Europe & Central Asia" if countryname=="Kyrgyz Republic"
replace WB_region="Europe & Central Asia" if countryname=="Latvia"
replace WB_region="Europe & Central Asia" if countryname=="Lithuania"
replace WB_region="Europe & Central Asia" if countryname=="Macedonia (Former Yugoslav Republic of)"
replace WB_region="Europe & Central Asia" if countryname=="Moldova"
replace WB_region="Europe & Central Asia" if countryname=="Montenegro"
replace WB_region="Europe & Central Asia" if countryname=="Poland"
replace WB_region="Europe & Central Asia" if countryname=="Rumania"
replace WB_region="Europe & Central Asia" if countryname=="Russia (Soviet Union)"
replace WB_region="Europe & Central Asia" if countryname=="Slovakia"
replace WB_region="Europe & Central Asia" if countryname=="Tajikistan"
replace WB_region="Europe & Central Asia" if countryname=="Turkey/Ottoman Empire"
replace WB_region="Europe & Central Asia" if countryname=="Turkmenistan"
replace WB_region="Europe & Central Asia" if countryname=="Ukraine"
replace WB_region="Europe & Central Asia" if countryname=="Uzbekistan"
replace WB_region="Europe & Central Asia" if countryname=="Yugoslavia (Serbia)"
replace WB_region="Latin America & Caribbean" if countryname=="Argentina"
replace WB_region="Latin America & Caribbean" if countryname=="Belize"
replace WB_region="Latin America & Caribbean" if countryname=="Bolivia"
replace WB_region="Latin America & Caribbean" if countryname=="Brazil"
replace WB_region="Latin America & Caribbean" if countryname=="Chile"
replace WB_region="Latin America & Caribbean" if countryname=="Colombia"
replace WB_region="Latin America & Caribbean" if countryname=="Costa Rica"
replace WB_region="Latin America & Caribbean" if countryname=="Cuba"
replace WB_region="Latin America & Caribbean" if countryname=="Dominica"
replace WB_region="Latin America & Caribbean" if countryname=="Dominican Republic"
replace WB_region="Latin America & Caribbean" if countryname=="Ecuador"
replace WB_region="Latin America & Caribbean" if countryname=="El Salvador"
replace WB_region="Latin America & Caribbean" if countryname=="Grenada"
replace WB_region="Latin America & Caribbean" if countryname=="Guatemala"
replace WB_region="Latin America & Caribbean" if countryname=="Guyana"
replace WB_region="Latin America & Caribbean" if countryname=="Haiti"
replace WB_region="Latin America & Caribbean" if countryname=="Honduras"
replace WB_region="Latin America & Caribbean" if countryname=="Jamaica"
replace WB_region="Latin America & Caribbean" if countryname=="Mexico"
replace WB_region="Latin America & Caribbean" if countryname=="Nicaragua"
replace WB_region="Latin America & Caribbean" if countryname=="Panama"
replace WB_region="Latin America & Caribbean" if countryname=="Paraguay"
replace WB_region="Latin America & Caribbean" if countryname=="Peru"
replace WB_region="Latin America & Caribbean" if countryname=="Saint Kitts and Nevis"
replace WB_region="Latin America & Caribbean" if countryname=="Saint Lucia"
replace WB_region="Latin America & Caribbean" if countryname=="Saint Vincent and the Grenadines"
replace WB_region="Latin America & Caribbean" if countryname=="Surinam"
replace WB_region="Latin America & Caribbean" if countryname=="Uruguay"
replace WB_region="Latin America & Caribbean" if countryname=="Venezuela"
replace WB_region="Middle East & North Africa" if countryname=="Algeria"
replace WB_region="Middle East & North Africa" if countryname=="Djibouti"
replace WB_region="Middle East & North Africa" if countryname=="Egypt"
replace WB_region="Middle East & North Africa" if countryname=="Iran (Persia)"
replace WB_region="Middle East & North Africa" if countryname=="Iraq"
replace WB_region="Middle East & North Africa" if countryname=="Jordan"
replace WB_region="Middle East & North Africa" if countryname=="Lebanon"
replace WB_region="Middle East & North Africa" if countryname=="Libya"
replace WB_region="Middle East & North Africa" if countryname=="Morocco"
replace WB_region="Middle East & North Africa" if countryname=="Oman"
replace WB_region="Middle East & North Africa" if countryname=="Palestine"
replace WB_region="Middle East & North Africa" if countryname=="Syria"
replace WB_region="Middle East & North Africa" if countryname=="Tunisia"
replace WB_region="Middle East & North Africa" if countryname=="Yemen (Arab Republic of Yemen)"
replace WB_region="South Asia" if countryname=="Afghanistan"
replace WB_region="South Asia" if countryname=="Bangladesh"
replace WB_region="South Asia" if countryname=="Bhutan"
replace WB_region="South Asia" if countryname=="India"
replace WB_region="South Asia" if countryname=="Maldives"
replace WB_region="South Asia" if countryname=="Nepal"
replace WB_region="South Asia" if countryname=="Pakistan"
replace WB_region="South Asia" if countryname=="Sri Lanka (Ceylon)"
replace WB_region="Sub-Saharan Africa" if countryname=="Angola"
replace WB_region="Sub-Saharan Africa" if countryname=="Benin"
replace WB_region="Sub-Saharan Africa" if countryname=="Botswana"
replace WB_region="Sub-Saharan Africa" if countryname=="Burkina Faso (Upper Volta)"
replace WB_region="Sub-Saharan Africa" if countryname=="Burundi"
replace WB_region="Sub-Saharan Africa" if countryname=="Cameroon"
replace WB_region="Sub-Saharan Africa" if countryname=="Cape Verde"
replace WB_region="Sub-Saharan Africa" if countryname=="Central African Republic"
replace WB_region="Sub-Saharan Africa" if countryname=="Chad"
replace WB_region="Sub-Saharan Africa" if countryname=="Comoros"
replace WB_region="Sub-Saharan Africa" if countryname=="Congo"
replace WB_region="Sub-Saharan Africa" if countryname=="Congo, Democratic Republic of (Zaire)"
replace WB_region="Sub-Saharan Africa" if countryname=="Cote D'Ivoire"
replace WB_region="Sub-Saharan Africa" if countryname=="Equatorial Guinea"
replace WB_region="Sub-Saharan Africa" if countryname=="Eritrea"
replace WB_region="Sub-Saharan Africa" if countryname=="Ethiopia"
replace WB_region="Sub-Saharan Africa" if countryname=="Gabon"
replace WB_region="Sub-Saharan Africa" if countryname=="Gambia"
replace WB_region="Sub-Saharan Africa" if countryname=="Ghana"
replace WB_region="Sub-Saharan Africa" if countryname=="Guinea"
replace WB_region="Sub-Saharan Africa" if countryname=="Guinea-Bissau"
replace WB_region="Sub-Saharan Africa" if countryname=="Kenya"
replace WB_region="Sub-Saharan Africa" if countryname=="Lesotho"
replace WB_region="Sub-Saharan Africa" if countryname=="Liberia"
replace WB_region="Sub-Saharan Africa" if countryname=="Madagascar (Malagasy)"
replace WB_region="Sub-Saharan Africa" if countryname=="Malawi"
replace WB_region="Sub-Saharan Africa" if countryname=="Mali"
replace WB_region="Sub-Saharan Africa" if countryname=="Mauritania"
replace WB_region="Sub-Saharan Africa" if countryname=="Mauritius"
replace WB_region="Sub-Saharan Africa" if countryname=="Mayotte"
replace WB_region="Sub-Saharan Africa" if countryname=="Mozambique"
replace WB_region="Sub-Saharan Africa" if countryname=="Namibia"
replace WB_region="Sub-Saharan Africa" if countryname=="Niger"
replace WB_region="Sub-Saharan Africa" if countryname=="Nigeria"
replace WB_region="Sub-Saharan Africa" if countryname=="Rwanda"
replace WB_region="Sub-Saharan Africa" if countryname=="Sao Tome and Principe"
replace WB_region="Sub-Saharan Africa" if countryname=="Senegal"
replace WB_region="Sub-Saharan Africa" if countryname=="Seychelles"
replace WB_region="Sub-Saharan Africa" if countryname=="Sierra Leone"
replace WB_region="Sub-Saharan Africa" if countryname=="Somalia"
replace WB_region="Sub-Saharan Africa" if countryname=="South Africa"
replace WB_region="Sub-Saharan Africa" if countryname=="Sudan"
replace WB_region="Sub-Saharan Africa" if countryname=="Swaziland"
replace WB_region="Sub-Saharan Africa" if countryname=="Tanzania/Tanganyika"
replace WB_region="Sub-Saharan Africa" if countryname=="Togo"
replace WB_region="Sub-Saharan Africa" if countryname=="Uganda"
replace WB_region="Sub-Saharan Africa" if countryname=="Zambia"
replace WB_region="Sub-Saharan Africa" if countryname=="Zimbabwe (Rhodesia)"

gen region_SSA=1 if WB_region=="Sub-Saharan Africa"
replace region_SSA=0 if region_SSA!=1
gen region_SoAsia=1 if WB_region=="South Asia"
replace region_SoAsia=0 if region_SoAsia!=1
gen region_MENA=1 if WB_region=="Middle East & North Africa"
replace region_MENA=0 if region_MENA!=1
gen region_Latin=1 if WB_region=="Latin America & Caribbean"
replace region_Latin=0 if region_Latin!=1
gen region_EAsiaPac=1 if WB_region=="East Asia & Pacific"
replace region_EAsiaPac=0 if region_EAsiaPac!=1
gen region_EurCentAsia=1 if WB_region=="Europe & Central Asia"
replace region_EurCentAsia=0 if region_EurCentAsia!=1
gen region_NoAmer=1 if WB_region=="North America"
replace region_NoAmer=0 if region_NoAmer!=1
