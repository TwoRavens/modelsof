#delimit;
gen str15 country=" ";
replace country="Canada" if cnum==100;
replace country="Argentina" if cnum==200;
replace country="Bolivia" if cnum==201;
replace country="Brazil" if cnum==202;
replace country="Chile" if cnum==203;
replace country="Colombia" if cnum==204;
replace country="Costa Rica" if cnum==205;
replace country="Cuba" if cnum==206;
replace country="Dominican Republic" if cnum==207;
replace country="Ecuador" if cnum==208;
replace country="El Salvador" if cnum==209;
replace country="Guatemala" if cnum==210;
replace country="Haiti" if cnum==211;
replace country="Honduras" if cnum==212;
replace country="Mexico" if cnum==213;
replace country="Nicaragua" if cnum==214;
replace country="Panama" if cnum==215;
replace country="Paraguay" if cnum==216;
replace country="Peru" if cnum==217;
replace country="Uruguay" if cnum==218;
replace country="Venezuela" if cnum==219;
replace country="Bahamas" if cnum==250;
replace country="Barbados" if cnum==251;
replace country="Bermuda" if cnum==252;
replace country="Belize" if cnum==254;
replace country="French Islands, Caribbean" if cnum==255;
replace country="French Guiana" if cnum==256;
replace country="Guyana" if cnum==257;
replace country="Jamaica" if cnum==258;
replace country="Netherlands Antilles" if cnum==259;
replace country="Suriname" if cnum==260;
replace country="Trinidad and Tobago" if cnum==261;
replace country="St. Pierre and Miquelon" if cnum==263;
replace country="Grenada" if cnum==265;
replace country="United Kingdom Islands, Caribbean" if cnum==266;
replace country="St. Christopher and Nevis" if cnum==267;
replace country="United Kindgom Islands, Atlantic (OWH)" if cnum==268;
replace country="Dominica" if cnum==269;
replace country="St. Lucia" if cnum==270;
replace country="St. Vincent and the Grenadines" if cnum==271;
replace country="Anguilla" if cnum==272;
replace country="Antigua and Barbuda" if cnum==273;
replace country="Aruba" if cnum==274;
replace country="Andorra" if cnum==300;
replace country="Austria" if cnum==301;
replace country="Belgium" if cnum==302;
replace country="Cyprus" if cnum==304;
replace country="Denmark" if cnum==305;
replace country="Finland" if cnum==306;
replace country="France" if cnum==307;
replace country="Germany" if cnum==308;
replace country="Gibraltar" if cnum==309;
replace country="Greece" if cnum==310;
replace country="Greenland" if cnum==311;
replace country="Iceland" if cnum==312;
replace country="Ireland" if cnum==313;
replace country="Italy" if cnum==314;
replace country="Liechtenstein" if cnum==315;
replace country="Luxembourg" if cnum==316;
replace country="Malta" if cnum==317;
replace country="Monaco" if cnum==318;
replace country="Netherlands" if cnum==319;
replace country="Norway" if cnum==320;
replace country="Portugal" if cnum==321;
replace country="San Marino" if cnum==322;
replace country="Spain" if cnum==323;
replace country="Sweden" if cnum==324;
replace country="Switzerland" if cnum==325;
replace country="Turkey" if cnum==326;
replace country="United Kingdom" if cnum==327;
replace country="Yugoslavia" if cnum==328;
replace country="Vatican City" if cnum==330;
replace country="Estonia" if cnum==331;
replace country="Latvia" if cnum==332;
replace country="Lithuania" if cnum==333;
replace country="Armenia" if cnum==334;
replace country="Azerbaijan" if cnum==335;
replace country="Byelarus" if cnum==336;
replace country="Georgia" if cnum==337;
replace country="Kazakhstan" if cnum==338;
replace country="Kyrgyzstan" if cnum==339;
replace country="Moldova" if cnum==340;
replace country="Russia" if cnum==341;
replace country="Tajikistan" if cnum==342;
replace country="Turkmenistan" if cnum==343;
replace country="Ukraine" if cnum==344;
replace country="Uzbekistan" if cnum==345;
replace country="Albania" if cnum==350;
replace country="Bulgaria" if cnum==351;
replace country="Czechoslovakia" if cnum==352;
replace country="East Germany" if cnum==353;
replace country="Hungary" if cnum==354;
replace country="Poland" if cnum==355;
replace country="Romania" if cnum==356;
replace country="Union of Soviet Socialist Republics" if cnum==357;
replace country="Bosnia and Herzegovina" if cnum==358;
replace country="Croatia" if cnum==359;
replace country="Macedonia" if cnum==360;
replace country="Montenegro" if cnum==361;
replace country="Serbia" if cnum==362;
replace country="Slovinia" if cnum==363;
replace country="Czech Republic" if cnum==364;
replace country="Slovakia" if cnum==365;
replace country="Algeria" if cnum==400;
replace country="Angola" if cnum==401;
replace country="Botswana" if cnum==402;
replace country="Burundi" if cnum==403;
replace country="Cameroon" if cnum==404;
replace country="Central African Republic" if cnum==405;
replace country="Chad" if cnum==406;
replace country="Congo" if cnum==407;
replace country="Zaire" if cnum==408;
replace country="Benin" if cnum==409;
replace country="Egypt" if cnum==410;
replace country="Ethiopia" if cnum==411;
replace country="Djibouti" if cnum==412;
replace country="Gabon" if cnum==413;
replace country="Gambia" if cnum==414;
replace country="Ghana" if cnum==415;
replace country="Guinea" if cnum==416;
replace country="Ivory Coast" if cnum==417;
replace country="Kenya" if cnum==418;
replace country="Lesotho" if cnum==419;
replace country="Liberia" if cnum==420;
replace country="Libya" if cnum==421;
replace country="Madagascar" if cnum==422;
replace country="Malawi" if cnum==423;
replace country="Mali" if cnum==424;
replace country="Mauritania" if cnum==425;
replace country="Morocco" if cnum==426;
replace country="Mozambique" if cnum==427;
replace country="Niger" if cnum==428;
replace country="Nigeria" if cnum==429;
replace country="Guinea-Bissau" if cnum==430;
replace country="Zimbabwe" if cnum==431;
replace country="Rwanda" if cnum==432;
replace country="Senegal" if cnum==433;
replace country="Sierra Leone" if cnum==434;
replace country="Somalia" if cnum==435;
replace country="South Africa" if cnum==436;
replace country="Namibia" if cnum==437;
replace country="Equatorial Guinea" if cnum==438;
replace country="Western Sahara" if cnum==440;
replace country="Sudan" if cnum==441;
replace country="Swaziland" if cnum==442;
replace country="Tanzania" if cnum==443;
replace country="Togo" if cnum==444;
replace country="Tunisia" if cnum==445;
replace country="Uganda" if cnum==446;
replace country="Burkina Faso" if cnum==447;
replace country="Zambia" if cnum==448;
replace country="Cape Verde" if cnum==450;
replace country="Sao Tome Et Principe" if cnum==451;
replace country="Mauritius" if cnum==453;
replace country="Seychelles" if cnum==454;
replace country="United Kingdom Islands, Atlantic (Africa)" if cnum==455;
replace country="Comoros" if cnum==456;
replace country="Eritrea" if cnum==457;
replace country="Yemen (Aden)" if cnum==500;
replace country="Bahrain" if cnum==501;
replace country="Iran" if cnum==502;
replace country="Iraq" if cnum==503;
replace country="Israel" if cnum==504;
replace country="Jordan" if cnum==505;
replace country="Kuwait" if cnum==506;
replace country="Lebanon" if cnum==507;
replace country="Oman" if cnum==508;
replace country="Neutral Zone" if cnum==509;
replace country="Qatar" if cnum==510;
replace country="Saudi Arabia" if cnum==511;
replace country="Syria" if cnum==512;
replace country="United Arab Emirates" if cnum==513;
replace country="Yemen (Sanaa)" if cnum==514;
replace country="Afghanistan" if cnum==600;
replace country="Australia" if cnum==601;
replace country="Bhutan" if cnum==602;
replace country="Brunei" if cnum==603;
replace country="United Kingdom Islands, Pacific" if cnum==604;
replace country="United Kingdom Islands, Indian Ocean" if cnum==605;
replace country="Burma" if cnum==606;
replace country="Cambodia" if cnum==607;
replace country="Sri Lanka" if cnum==608;
replace country="French Islands, Indian Ocean" if cnum==609;
replace country="French Islands, Pacific" if cnum==610;
replace country="Hong Kong" if cnum==611;
replace country="India" if cnum==612;
replace country="Indonesia" if cnum==613;
replace country="Japan" if cnum==614;
replace country="Laos" if cnum==615;
replace country="Macau" if cnum==616;
replace country="Malaysia" if cnum==617;
replace country="Nepal" if cnum==618;
replace country="Papua New Guinea" if cnum==619;
replace country="New Zealand" if cnum==620;
replace country="Pakistan" if cnum==622;
replace country="Philippines" if cnum==623;
replace country="Singapore" if cnum==625;
replace country="Korea, Republic of" if cnum==626;
replace country="Taiwan" if cnum==628;
replace country="Thailand" if cnum==629;
replace country="Bangladesh" if cnum==631;
replace country="Fiji" if cnum==632;
replace country="Maldives" if cnum==633;
replace country="Nauru" if cnum==635;
replace country="Vanuatu" if cnum==636;
replace country="Western Samoa" if cnum==637;
replace country="Tonga" if cnum==638;
replace country="China" if cnum==650;
replace country="Mongolia" if cnum==651;
replace country="North Korea" if cnum==652;
replace country="Vietnam" if cnum==653;
replace country="Solomon Islands" if cnum==654;
replace country="Kiribati" if cnum==655;
replace country="Tuvalu" if cnum==656;
replace country="Micronesia" if cnum==657;
replace country="Marshall Islands" if cnum==658;
replace country="Palau" if cnum==659;
replace country="International--Shipping" if cnum==700;
replace country="International--Drilling" if cnum==701;
replace country="International Organizations" if cnum==703;
