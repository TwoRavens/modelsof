clear
set mem 300m
infile using "mainfile.dct"
#delimit ;
keep if  (r3sample == 1 | 
       r3sample == 0); 
   keep if (r4r2schg == 1 | 
       r4r2schg == 2 | 
       r4r2schg == 3 | 
       r4r2schg == 4 | 
       r4r2schg == 5 | 
       r4r2schg == 6 | 
       r4r2schg == -1 | 
       r4r2schg == -9 | 
       r4r2schg == .); 
   keep if (r5r4schg == 1 | 
       r5r4schg == 2 | 
       r5r4schg == 3 | 
       r5r4schg == 4 | 
       r5r4schg == 5 | 
       r5r4schg == 6 | 
       r5r4schg == -1 | 
       r5r4schg == -9 | 
       r5r4schg == .); 
   keep if (p1firkdg == 1 | 
       p1firkdg == 2 | 
       p1firkdg == -8 | 
       p1firkdg == -9 | 
       p1firkdg == .); 
   keep if (t5glvl == 1 | 
       t5glvl == 2 | 
       t5glvl == 3 | 
       t5glvl == 4 | 
       t5glvl == 5 | 
       t5glvl == 6 | 
       t5glvl == 7 | 
       t5glvl == -9 | 
       t5glvl == .);
   label define tf
      1  "true"  
      0  "false"  
;
   label define kurban
      1  "central city"  
      2  "urban fringe and large town"  
      3  "small town and rural"  
;
   label define r4urban
      1  "large and mid-size city"  
      2  "large and mid-size suburb and large town"  
      3  "small town and rural"  
;
   label define urban
      1  "large and mid-size city"  
      2  "large and mid-size suburb and large town"  
      3  "small town and rural"  
;
   label define tf19f
      1  "true"  
      0  "false"  
;
   label define gender
      1  "male"  
      2  "female"  
;
   label define race
      1  "white, non-hispanic"  
      2  "black or african american, non-hispanic"  
      3  "hispanic, race specified"  
      4  "hispanic, race not specified"  
      5  "asian"  
      6  "native hawaiian, other pacific islander"  
      7  "american indian or alaska native"  
      8  "more than one race, non hispanic"  
;
   label define r5age
      1  "less than 105"  
      2  "105 to less than 108"  
      3  "108 to less than 111"  
      4  "111 to less than 114"  
      5  "114 to less than 117"  
      6  "117 or more"  
;
   label define schg
      1  "child did not change school"  
      2  "child transferred from public school to public school"  
      3  "child transferred from private school to private school"  
      4  "child transferred from public school to private school"  
      5  "child transferred from private school to public school"  
      6  "child transferred, other"  
;
   label define pc018f
      1  "35 hours or more per week"  
      2  "less than 35 hours per week"  
      3  "looking for work"  
      4  "not in the labor force"  
;
   label define pc013f
      1  "35 hours or more per week"  
      2  "less than 35 hours per week"  
      3  "looking for work"  
      4  "not in the labor force"  
;
   label define yn19f
      1  "yes"  
      2  "no"  
;
   label define pc048f
      1  "8th grade or below"  
      2  "9th - 12th grade"  
      3  "high school diploma/equivalent"  
      4  "voc/tech program"  
      5  "some college"  
      6  "bachelor's degree"  
      7  "graduate/professional school-no degree"  
      8  "master's degree (ma, ms)"  
      9  "doctorate or professional degree"  
;
   label define pc030f
      0  "no non-parental care"  
      1  "relative care, child's home"  
      2  "relative care, other's home"  
      3  "non-rel care, child's home"  
      4  "non-rel care, other home"  
      5  "center-based program"  
      6  "2 or more programs"  
      7  "location varies"  
;
   label define pc019f
      1  "never speaks non-english language"  
      2  "sometimes speaks non-english language"  
      3  "often speaks non-english language"  
      4  "very often speaks non-english language"  
;
   label define pc024f
      1  "both only speak english language"  
      2  "1 (of 2) speaks non-english language"  
      3  "both only speak non-english language"  
;
   label define pc020f
      1  "biological"  
      2  "adoptive"  
      3  "step"  
      4  "foster"  
      5  "partner"  
      6  "don't know type"  
      7  "no resident mother"  
;
   label define pc011f
      1  "biological"  
      2  "adoptive"  
      3  "step"  
      4  "foster"  
      5  "partner"  
      6  "don't know type"  
      7  "no resident father"  
;
   label define pc010f
      1  "biological"  
      2  "other"  
      3  "none"  
;
   label define yn89f
      1  "yes"  
      2  "no"  
;
   label define pc052f
      0  "no non-parental care"  
      1  "relative care, child's home"  
      2  "relative care, other's home"  
      3  "non-rel care, child's home"  
      4  "non-rel care, other home"  
      5  "head start program"  
      6  "center-based program"  
      7  "2 or more programs"  
      8  "location varies"  
;
   label define pc034f
      1  "biological"  
      2  "adoptive"  
      3  "step"  
      4  "foster"  
      5  "partner"  
      6  "don't know type"  
      7  "no resident mother"  
;
   label define pc060f
      1  "biological"  
      2  "adoptive"  
      3  "step"  
      4  "foster"  
      5  "partner"  
      6  "don't know type"  
      7  "no resident father"  
;
   label define pc042f
      1  "yes"  
      2  "no"  
      3  "mother has never married"  
;
   label define pc047f
      1  "non-english"  
      2  "english"  
;
   label define w1povrty
      1  "below poverty threshold"  
      2  "at or above poverty threshold"  
;
   label define pc230f
      0  "no non-parental care"  
      1  "relative care, child's home"  
      2  "relative care, other's home"  
      3  "non-rel care, child's home"  
      4  "non-rel care, other home"  
      5  "center-based program"  
      6  "2 or more programs"  
      7  "location varies"  
;
   label define p4primnw
      0  "no non-parental care"  
      1  "relative care, child's home"  
      2  "relative care, other's home"  
      3  "non-rel care, child's home"  
      4  "non-rel care, other home"  
      5  "center-based program"  
      6  "2 or more programs"  
      7  "location varies"  
;
   label define pc234f
      1  "biological"  
      2  "adoptive"  
      3  "step"  
      4  "foster"  
      5  "partner"  
      6  "don't know type"  
      7  "no resident mother"  
;
   label define pc260f
      1  "biological"  
      2  "adoptive"  
      3  "step"  
      4  "foster"  
      5  "partner"  
      6  "don't know type"  
      7  "no resident father"  
;
   label define pc210f
      1  "biological"  
      2  "other"  
      3  "none"  
;
   label define pc248f
      1  "8th grade or below"  
      2  "9th - 12th grade"  
      3  "high school diploma/equivalent"  
      4  "voc/tech program"  
      5  "some college"  
      6  "bachelor's degree"  
      7  "graduate/professional school-no degree"  
      8  "master's degree (ma, ms)"  
      9  "doctorate or professional degree"  
;
   label define pc250f
      1  "8th grade or below"  
      2  "9th - 12th grade"  
      3  "high school diploma/equivalent"  
      4  "voc/tech program"  
      5  "some college"  
      6  "bachelor's degree"  
      7  "graduate/professional school-no degree"  
      8  "master's degree (ma, ms)"  
      9  "doctorate or professional degree"  
;
   label define w1langst
      1  "non-english"  
      2  "english"  
;
   label define w1inccat
      1  "$5,000 or less"  
      2  "$5,001 to $10,000"  
      3  "$10,001 to $15,000"  
      4  "$15,001 to $20,000"  
      5  "$20,001 to $25,000"  
      6  "$25,001 to $30,000"  
      7  "$30,001 to $35,000"  
      8  "$35,001 to $40,000"  
      9  "$40,001 to $50,000"  
      10  "$50,001 to $75,000"  
      11  "$75,001 to $100,000"  
      12  "$100,001 to $200,000"  
      13  "$200,001 or more"  
;
   label define p5primnw
      0  "no non-parental care"  
      1  "relative care, child's home"  
      2  "relative care, other's home"  
      3  "non-rel care, child's home"  
      4  "non-rel care, other home"  
      5  "center-based program"  
      6  "2 or more programs"  
      7  "location varies"  
;
   label define pc5008f
      1  "biological"  
      2  "adoptive"  
      3  "step"  
      4  "foster"  
      5  "partner"  
      6  "don't know type"  
      7  "no resident mother"  
;
   label define pc5012f
      1  "biological"  
      2  "adoptive"  
      3  "step"  
      4  "foster"  
      5  "partner"  
      6  "don't know type"  
      7  "no resident father"  
;
   label define pc5009f
      1  "8th grade or below"  
      2  "9th - 12th grade"  
      3  "high school diploma/equivalent"  
      4  "voc/tech program"  
      5  "some college"  
      6  "bachelor's degree"  
      7  "graduate/professional school-no degree"  
      8  "master's degree (ma, ms)"  
      9  "doctorate or professional degree"  
;
   label define pc5011f
      1  "8th grade or below"  
      2  "9th - 12th grade"  
      3  "high school diploma/equivalent"  
      4  "voc/tech program"  
      5  "some college"  
      6  "bachelor's degree"  
      7  "graduate/professional school-no degree"  
      8  "master's degree (ma, ms)"  
      9  "doctorate or professional degree"  
;
   label define w3povrty
      1  "below poverty threshold"  
      2  "at or above poverty threshold"  
;
   label define w3inccat
      1  "$5,000 or less"  
      2  "$5,001 to $10,000"  
      3  "$10,001 to $15,000"  
      4  "$15,001 to $20,000"  
      5  "$20,001 to $25,000"  
      6  "$25,001 to $30,000"  
      7  "$30,001 to $35,000"  
      8  "$35,001 to $40,000"  
      9  "$40,001 to $50,000"  
      10  "$50,001 to $75,000"  
      11  "$75,001 to $100,000"  
      12  "$100,001 to $200,000"  
      13  "$200,001 or more"  
;
   label define t501f
      1  "kindergarten"  
      2  "first grade"  
      3  "second grade"  
      4  "third grade"  
      5  "fourth grade"  
      6  "fifth grade"  
      7  "ungraded classroom"  
;
   label define s2ksctyp
      1  "catholic"  
      2  "other religious"  
      3  "other private"  
      4  "public"  
;
   label define s3sctyp
      1  "catholic"  
      2  "other religious"  
      3  "other private"  
      4  "public"  
;
   label define s4sctyp
      1  "catholic"  
      2  "other religious"  
      3  "other private"  
      4  "public"  
;
   label define s510f
      1  "catholic"  
      2  "other religious"  
      3  "other private"  
      4  "public"  
;
   label define hsattend
      1  "center not locatable"  
      2  "center did not respond"  
      3  "center head start, child attended 1997-98"  
      4  "center head start, child attended, not 1997-98"  
      5  "center head start, child never attended"  
      6  "center not head start, child did attend"  
      7  "center hs & non-hs, child in non-hs 1997-98"  
;
   label define hscheck
      1  "yes"  
      2  "no"  
;
   label define c1screen
      1  "speak non-english language at home"  
      2  "speak english at home"  
;
   label define c3screen
      1  "speak non-english language at home"  
      2  "speak english at home"  
;
   label define p1026f
      1  "not at all"  
      2  "once or twice a week"  
      3  "3 to 6 times a week"  
      4  "everyday"  
;
   label define p1040f
      1  "yes"  
      2  "no"  
;
   label define p1043f
      0  "none"  
      1  "one"  
      2  "two"  
      3  "three"  
      4  "four"  
      5  "more than four"  
;
   label define p1044f
      0  "none"  
      1  "one"  
      2  "two"  
      3  "three"  
      4  "four"  
      5  "more than four"  
;
   label define p1045f
      1  "yes"  
      2  "no"  
;
   label define p1052f
      1  "one to two months"  
      2  "three to five months"  
      3  "six to eight months"  
      4  "nine to twelve months"  
;
   label define p1077f
      1  "full-day"  
      2  "part-day"  
;
   label define p1083f
      1  "per hour"  
      2  "per day"  
      3  "per week"  
      4  "per month"  
      5  "per year"  
      6  "other (specify)"  
;
   label define p1106f
      1  "yes"  
      2  "no"  
;
   label define p1120f
      1  "excellent"  
      2  "very good"  
      3  "good"  
      4  "fair"  
      5  "poor"  
;
   label define p1192f
      1  "yes"  
      2  "no"  
;
   label define p1194f
      1  "yes"  
      2  "no"  
;
   label define p1195f
      1  "english"  
      2  "spanish"  
      3  "other european languages"  
      4  "asian, pacif island or native amer languages"  
      5  "other languages or cannot choose"  
;
   label define p2002f
      1  "yes"  
      2  "no"  
;
   label define p2005f
      1  "yes"  
      2  "no"  
;
   label define p2013f
      1  "english"  
      2  "spanish"  
      3  "other european languages"  
      4  "asian, pacif islander or native amer languages"  
      5  "other languages or cannot choose"  
;
   label define p2032f
      1  "yes"  
      2  "no"  
;
   label define p2045f
      1  "never"  
      2  "almost never"  
      3  "several times a year"  
      4  "several times a month"  
      5  "several times a week or more"  
;
   label define p2048f
      1  "often"  
      2  "sometimes"  
      3  "hardly ever"  
      4  "never"  
;
   label define p2083f
      1  "never"  
      2  "less than 6 months"  
      3  "6 months to 1 year"  
      4  "1 - 2 years"  
      5  "more than 2 years"  
;
   label define p2084f
      1  "yes"  
      2  "no"  
;
   label define p2086f
      1  "more than other children"  
      2  "less than other children"  
      3  "about the same as other children"  
;
   label define p2091f
      1  "excellent"  
      2  "very good"  
      3  "good"  
      4  "fair"  
      5  "poor"  
;
   label define p2097f
      1  "yes"  
      2  "no"  
;
   label define p2100f
      1  "yes"  
      2  "no"  
;
   label define p2101f
      1  "free lunch"  
      2  "reduced price lunch"  
;
   label define p3001f
      1  "yes"  
      2  "no"  
;
   label define p3009f
      1  "english"  
      2  "spanish"  
      3  "other european languages"  
      4  "asian, pacif island or native amer languages"  
      5  "other languages or cannot choose"  
;
   label define p4001f
      1  "yes"  
      2  "no"  
;
   label define p4002f
      1  "yes"  
      2  "no"  
;
   label define p4006f
      0  "not on list"  
      1  "united states"  
      2  "afghanistan"  
      3  "albania"  
      4  "algeria"  
      5  "american samoa"  
      6  "andorra"  
      7  "angola"  
      8  "anguilla"  
      9  "antarctica"  
      10  "antigua and barbuda"  
      11  "argentina"  
      12  "armenia"  
      13  "aruba"  
      14  "ashmore and cartier islands"  
      15  "australia"  
      16  "austria"  
      17  "azerbaijan"  
      18  "bahamas, the"  
      19  "bahrain"  
      20  "baker island"  
      21  "bangladesh"  
      22  "barbados"  
      23  "bassas de india"  
      24  "belarus"  
      25  "belgium"  
      26  "belize"  
      27  "benin"  
      28  "bermuda"  
      29  "bhutan"  
      30  "bolivia"  
      31  "bosnia and herzegovina"  
      32  "botswana"  
      33  "bouvet island"  
      34  "brazil"  
      35  "british indian ocean territory"  
      36  "british virgin islands"  
      37  "brunei"  
      38  "bulgaria"  
      39  "burkina faso"  
      40  "burma"  
      41  "burundi"  
      42  "cambodia"  
      43  "cameroon"  
      44  "canada"  
      45  "cape verde"  
      46  "cayman islands"  
      47  "central african republic"  
      48  "chad"  
      49  "chile"  
      50  "china"  
      51  "christmas island"  
      52  "clipperton island"  
      53  "cocos (keeling) islands"  
      54  "colombia"  
      55  "comoros"  
      56  "congo, democratic republic of the"  
      57  "congo, republic of the"  
      58  "cook islands"  
      59  "coral sea islands"  
      60  "costa rica"  
      61  "cote d'ivoire"  
      62  "croatia"  
      63  "cuba"  
      64  "cyprus"  
      65  "czech republic"  
      66  "democratic republic of the congo"  
      67  "denmark"  
      68  "djibouti"  
      69  "dominica"  
      70  "dominican republic"  
      71  "ecuador"  
      72  "egypt"  
      73  "el salvador"  
      74  "equatorial guinea"  
      75  "eritrea"  
      76  "estonia"  
      77  "ethiopia"  
      78  "europa island"  
      79  "falkland islands (islas malvinas)"  
      80  "faroe islands"  
      81  "fiji"  
      82  "finland"  
      83  "france"  
      84  "french guiana"  
      85  "french polynesia"  
      86  "french southern and antarctic lands"  
      87  "gabon"  
      88  "gambia, the"  
      89  "georgia"  
      90  "germany"  
      91  "ghana"  
      92  "gibraltar"  
      93  "glorioso islands"  
      94  "greece"  
      95  "greenland"  
      96  "grenada"  
      97  "guadeloupe"  
      98  "guam"  
      99  "guatemala"  
      100  "guernsey"  
      101  "guinea"  
      102  "guinea-bissau"  
      103  "guyana"  
      104  "haiti"  
      105  "heard island and mcdonald islands"  
      106  "honduras"  
      107  "hong kong"  
      108  "howland island"  
      109  "hungary"  
      110  "iceland"  
      111  "india"  
      112  "indonesia"  
      113  "iran"  
      114  "iraq"  
      115  "ireland"  
      116  "israel"  
      117  "italy"  
      118  "jamaica"  
      119  "jan mayen"  
      120  "japan"  
      121  "jarvis island"  
      122  "jersey"  
      123  "johnston atoll"  
      124  "jordan"  
      125  "juan de nova island"  
      126  "kazakhstan"  
      127  "kenya"  
      128  "kingman reef"  
      129  "kiribati"  
      130  "korea, north"  
      131  "korea, south"  
      132  "kuwait"  
      133  "kyrgyzstan"  
      134  "laos"  
      135  "latvia"  
      136  "lebanon"  
      137  "lesotho"  
      138  "liberia"  
      139  "libya"  
      140  "liechtenstein"  
      141  "lithuania"  
      142  "luxembourg"  
      143  "macau"  
      144  "macedonia, the former yugoslav republic of"  
      145  "madagascar"  
      146  "malawi"  
      147  "malaysia"  
      148  "maldives"  
      149  "mali"  
      150  "malta"  
      151  "man, isle of"  
      152  "mariana island"  
      153  "marshall islands"  
      154  "martinique"  
      155  "mauritania"  
      156  "mauritius"  
      157  "mayotte"  
      158  "mexico"  
      159  "micronesia, federated states of"  
      160  "midway islands"  
      161  "moldova"  
      162  "monaco"  
      163  "mongolia"  
      164  "montserrat"  
      165  "morocco"  
      166  "mozambique"  
      167  "namibia"  
      168  "nauru"  
      169  "navassa island"  
      170  "nepal"  
      171  "netherlands"  
      172  "netherlands antilles"  
      173  "new caledonia"  
      174  "new zealand"  
      175  "nicaragua"  
      176  "niger"  
      177  "nigeria"  
      178  "niue"  
      179  "norfolk island"  
      180  "northern mariana islands"  
      181  "norway"  
      182  "oman"  
      183  "pakistan"  
      184  "palau"  
      185  "palmyra atoll"  
      186  "panama"  
      187  "papua new guinea"  
      188  "paracel islands"  
      189  "paraguay"  
      190  "peru"  
      191  "philippines"  
      192  "pitcairn islands"  
      193  "poland"  
      194  "portugal"  
      195  "puerto rico"  
      196  "qatar"  
      197  "reunion"  
      198  "romania"  
      199  "russia"  
      200  "rwanda"  
      201  "saint helena"  
      202  "saint kitts and nevis"  
      203  "saint lucia"  
      204  "saint pierra and miquelon"  
      205  "saint vincent and the grenadines"  
      206  "samoa"  
      207  "san marino"  
      208  "sao tome and principe"  
      209  "saudi arabia"  
      210  "senegal"  
      211  "serbia and montenegro"  
      212  "seychelles"  
      213  "sierra leone"  
      214  "singapore"  
      215  "slovakia"  
      216  "slovenia"  
      217  "solomon islands"  
      218  "somalia"  
      219  "south africa"  
      220  "south georgia and the south sandwich islands"  
      221  "spain"  
      222  "spratly islands"  
      223  "sri lanka"  
      224  "sudan"  
      225  "suriname"  
      226  "svalbard"  
      227  "swaziland"  
      228  "sweden"  
      229  "switzerland"  
      230  "syria"  
      231  "taiwan"  
      232  "tajikistan"  
      233  "tanzania"  
      234  "thailand"  
      235  "togo"  
      236  "tokelau"  
      237  "tonga"  
      238  "trinidad and tobago"  
      239  "tromelin island"  
      240  "tunisia"  
      241  "turkey"  
      242  "turkmenistan"  
      243  "turks and caicos islands"  
      244  "tuvalu"  
      245  "uganda"  
      246  "ukraine"  
      247  "united arab emirates"  
      248  "united kingdom"  
      249  "u.s. virgin islands"  
      250  "uruguay"  
      251  "uzbekistan"  
      252  "vanuatu"  
      253  "vatican city"  
      254  "venezuela"  
      255  "vietnam"  
      256  "wake atoll"  
      257  "wallis and futuna"  
      258  "western sahara"  
      259  "yemen"  
      260  "zambia"  
      261  "zimbabwe"  
;
   label define p4008f
      1  "yes"  
      2  "no"  
;
   label define p4017f
      1  "not at all"  
      2  "once or twice a week"  
      3  "3 to 6 times a week"  
      4  "everyday"  
;
   label define p4021f
      1  "yes"  
      2  "no"  
;
   label define p4033f
      1  "never or almost never"  
      2  "several times a year"  
      3  "several times a month"  
      4  "once a week"  
      5  "several times a week"  
;
   label define p4105f
      1  "excellent"  
      2  "very good"  
      3  "good"  
      4  "fair"  
      5  "poor"  
;
   label define p4108f
      1  "never"  
      2  "less than 6 months"  
      3  "6 months to 1 year"  
      4  "1 - 2 years"  
      5  "more than 2 years"  
;
   label define p4123f
      1  "yes"  
      2  "no"  
;
   label define p4126f
      1  "yes"  
      2  "no"  
;
   label define p4127f
      1  "free lunch"  
      2  "reduced price lunch"  
;
   label define p4131f
      1  "$5,000 or less"  
      2  "$5,001 to $10,000"  
      3  "$10,001 to $15,000"  
      4  "$15,001 to $20,000"  
      5  "$20,001 to $25,000"  
      6  "$25,001 to $30,000"  
      7  "$30,001 to $35,000"  
      8  "$35,001 to $40,000"  
      9  "$40,001 to $50,000"  
      10  "$50,001 to $75,000"  
      11  "$75,001 to $100,000"  
      12  "$100,001 to $200,000"  
      13  "$200,001 or more"  
;
   label define pyesno
      1  "yes"  
      2  "no"  
;
   label define pyesno1f
      1  "yes"  
      2  "no"  
;
   label define pnotatal
      1  "not at all"  
      2  "once or twice"  
      3  "3-6 times"  
      4  "every day"  
;
   label define phowwe2f
      1  "excellent"  
      2  "very good"  
      3  "good"  
      4  "fair"  
      5  "poor"  
;
   label define ptimetot
      1  "never"  
      2  "less than 6 months"  
      3  "6 months to one year"  
      4  "1 to 2 years"  
      5  "more than 2 years"  
;
   label define phowacti
      1  "more than other boys/girls"  
      2  "less than other boys/girls"  
      3  "about the same as other boys/girls"  
;
   label define pe_130f
      1  "excellent"  
      2  "verygood"  
      3  "good"  
      4  "fair"  
      5  "poor"  
;
   label define pschooll
      1  "free"  
      2  "reduced price"  
;
   label define p5inccat
      1  "$5,000 or less"  
      2  "$5,001 to $10,000"  
      3  "$10,001 to $15,000"  
      4  "$15,001 to $20,000"  
      5  "$20,001 to $25,000"  
      6  "$25,001 to $30,000"  
      7  "$30,001 to $35,000"  
      8  "$35,001 to $40,000"  
      9  "$40,001 to $50,000"  
      10  "$50,001 to $75,000"  
      11  "$75,001 to $100,000"  
      12  "$100,001 to $200,000"  
      13  "$200,001 or more"  
;
   label define pmarital
      1  "married"  
      2  "separated"  
      3  "divorced"  
      4  "widowed"  
      5  "never married"  
;
   label values c1screen c1screen;
   label values c2screen c1screen;
   label values c3screen c3screen;
   label values c4screen c3screen;
   label values gender gender;
   label values hsattend hsattend;
   label values hscheck hscheck;
   label values kurban_r kurban;
   label values p1readbo p1026f;
   label values p1afdc p1040f;
   label values p1fstamp p1040f;
   label values p1hsever p1040f;
   label values p1wicchd p1040f;
   label values p1lvgran p1043f;
   label values p1clsgrn p1044f;
   label values p1anyaid p1045f;
   label values p1cever p1045f;
   label values p1fstam2 p1045f;
   label values p1hsfee p1045f;
   label values p1wicmom p1045f;
   label values p1whenaf p1052f;
   label values p1whenfs p1052f;
   label values p1hstype p1077f;
   label values p1hsunit p1083f;
   label values p1weigh5 p1106f;
   label values p1weigh6 p1106f;
   label values p1hscale p1120f;
   label values p1anylng p1192f;
   label values p1langs1 p1194f;
   label values p1langs3 p1194f;
   label values p1langs4 p1194f;
   label values p1prmlng p1195f;
   label values p2chplac p2002f;
   label values p2anylng p2005f;
   label values p2wicchd p2005f;
   label values p2wicmom p2005f;
   label values p2prmlng p2013f;
   label values p2homecm p2032f;
   label values p2relig p2045f;
   label values p2argrel p2048f;
   label values p2dentis p2083f;
   label values p2doctor p2083f;
   label values p2church p2084f;
   label values p2cover p2084f;
   label values p2cubsct p2084f;
   label values p2frmclb p2084f;
   label values p2hlthcl p2084f;
   label values p2pubprk p2084f;
   label values p2spteam p2084f;
   label values p2typac7 p2084f;
   label values p2ymca p2084f;
   label values p2aerobi p2086f;
   label values p2health p2091f;
   label values p2afdc p2097f;
   label values p2fstamp p2097f;
   label values p2schllu p2097f;
   label values p2lunchs p2100f;
   label values p2rlunch p2100f;
   label values p2freerd p2101f;
   label values p3anylng p3001f;
   label values p3wicchd p3001f;
   label values p3wicmom p3001f;
   label values p3prmlng p3009f;
   label values p4prmlng p3009f;
   label values p4anylng p4001f;
   label values p4hsbefk p4001f;
   label values p4wicchd p4001f;
   label values p4wicmom p4001f;
   label values p4immfam p4002f;
   label values p4milfam p4002f;
   label values p4cbirth p4006f;
   label values p4dadcob p4006f;
   label values p4momcob p4006f;
   label values p5dadcob p4006f;
   label values p5momcob p4006f;
   label values p4agovpg p4008f;
   label values p4chip p4008f;
   label values p4medaid p4008f;
   label values p4milhea p4008f;
   label values p4noinsu p4008f;
   label values p4priins p4008f;
   label values p4readbo p4017f;
   label values p4homecm p4021f;
   label values p4rrelsv p4033f;
   label values p4hscale p4105f;
   label values p4dentis p4108f;
   label values p4doctor p4108f;
   label values p4afdc p4123f;
   label values p4fstamp p4123f;
   label values p4schllu p4123f;
   label values p4lunchs p4126f;
   label values p4rlunch p4126f;
   label values p4freerd p4127f;
   label values p4inccat p4131f;
   label values p4primnw p4primnw;
   label values p5inccat p5inccat;
   label values p5primnw p5primnw;
   label values p1dadtyp pc010f;
   label values p2dadtyp pc010f;
   label values p1hdad pc011f;
   label values p1hdemp pc013f;
   label values p1hmemp pc018f;
   label values p1hdlang pc019f;
   label values p1hdltod pc019f;
   label values p1hmlang pc019f;
   label values p1hmltom pc019f;
   label values p1hmom pc020f;
   label values p1langug pc024f;
   label values p1primnw pc030f;
   label values p2hmom pc034f;
   label values wkhmomar pc042f;
   label values wklangst pc047f;
   label values wkdaded pc048f;
   label values wkmomed pc048f;
   label values wkpared pc048f;
   label values p1primpk pc052f;
   label values p2hdad pc060f;
   label values p4dadtyp pc210f;
   label values p3primnw pc230f;
   label values p4hmom pc234f;
   label values w1daded pc248f;
   label values w1momed pc248f;
   label values w1pared pc250f;
   label values p4hdad pc260f;
   label values p5hmom pc5008f;
   label values w3daded pc5009f;
   label values w3momed pc5009f;
   label values w3pared pc5011f;
   label values p5hdad pc5012f;
   label values p5health pe_130f;
   label values p5aerobi phowacti;
   label values p5hscale phowwe2f;
   label values p2curmar pmarital;
   label values p3curmar pmarital;
   label values p4curmar pmarital;
   label values p5curmar pmarital;
   label values p5readbo pnotatal;
   label values p5freerd pschooll;
   label values p5dentis ptimetot;
   label values p5doctor ptimetot;
   label values p5chieat pyesno;
   label values p5lunchs pyesno;
   label values p5reqfs pyesno;
   label values p5rlunch pyesno;
   label values p5typac7 pyesno;
   label values p5afdc pyesno1f;
   label values p5agovpg pyesno1f;
   label values p5chip pyesno1f;
   label values p5church pyesno1f;
   label values p5cubsct pyesno1f;
   label values p5frmclb pyesno1f;
   label values p5fstamp pyesno1f;
   label values p5hlthcl pyesno1f;
   label values p5homecm pyesno1f;
   label values p5medaid pyesno1f;
   label values p5milhea pyesno1f;
   label values p5noinsu pyesno1f;
   label values p5priins pyesno1f;
   label values p5pubprk pyesno1f;
   label values p5schlbk pyesno1f;
   label values p5schllu pyesno1f;
   label values p5spteam pyesno1f;
   label values p5ymca pyesno1f;
   label values r3urban r4urban;
   label values r4urban r4urban;
   label values r5age r5age;
   label values race race;
   label values s2ksctyp s2ksctyp;
   label values s3sctyp s3sctyp;
   label values s4sctyp s4sctyp;
   label values s5sctyp s510f;
   label values r4r2schg schg;
   label values r5r4schg schg;
   label values p1lang1 suppress;
   label values p1lang10 suppress;
   label values p1lang11 suppress;
   label values p1lang12 suppress;
   label values p1lang13 suppress;
   label values p1lang14 suppress;
   label values p1lang15 suppress;
   label values p1lang18 suppress;
   label values p1lang2 suppress;
   label values p1lang3 suppress;
   label values p1lang4 suppress;
   label values p1lang5 suppress;
   label values p1lang6 suppress;
   label values p1lang7 suppress;
   label values p1lang8 suppress;
   label values p1lang9 suppress;
   label values p2cntryb suppress;
   label values p4chplac suppress;
   label values p5frered suppress;
   label values t5glvl t501f;
   label values c5sdqflg tf;
   label values r3dest tf;
   label values r3sample tf;
   label values r4dest tf;
   label values r5dest tf19f;
   label values r5urban urban;
   label values w1inccat w1inccat;
   label values w1langst w1langst;
   label values w1povrty w1povrty;
   label values wkpov_r w1povrty;
   label values w3inccat w3inccat;
   label values w3povrty w3povrty;
   label values p1carnow yn19f;
   label values p1center yn19f;
   label values p1disabl yn19f;
   label values p3carnow yn19f;
   label values p4carnow yn19f;
   label values p4disabl yn19f;
   label values p5carnow yn19f;
   label values p5disabl yn19f;
   label values w1hearly yn19f;
   label values w1momar yn19f;
   label values wkcarepk yn19f;
   label values wkhearly yn19f;
   label values p1firkdg yn89f;
save "mainfile.dta", replace;
use "mainfile.dta";
tabulate kurban_r;
tabulate r3urban;
tabulate r3dest;
tabulate r4urban;
tabulate r4dest;
tabulate r5urban;
tabulate r5dest;
tabulate gender;
tabulate race;
tabulate r3sample;
tabulate r5age;
tabulate r4r2schg;
tabulate r5r4schg;
tabulate c5sdqflg;
tabulate p1hmemp;
tabulate p1hdemp;
tabulate p1carnow;
tabulate p1primnw;
tabulate p1center;
tabulate p1disabl;
tabulate p1hmlang;
tabulate p1hmltom;
tabulate p1hdlang;
tabulate p1hdltod;
tabulate p1langug;
tabulate p1hmom;
tabulate p1hdad;
tabulate p1dadtyp;
tabulate p1firkdg;
tabulate p1primpk;
tabulate p2hmom;
tabulate p2hdad;
tabulate p2dadtyp;
tabulate wkmomed;
tabulate wkdaded;
tabulate wkhearly;
tabulate wkpared;
tabulate wkhmomar;
tabulate wkcarepk;
tabulate wklangst;
tabulate wkpov_r;
tabulate p3carnow;
tabulate p3primnw;
tabulate p4carnow;
tabulate p4primnw;
tabulate p4disabl;
tabulate p4hmom;
tabulate p4hdad;
tabulate p4dadtyp;
tabulate w1momed;
tabulate w1daded;
tabulate w1hearly;
tabulate w1pared;
tabulate w1momar;
tabulate w1langst;
tabulate w1povrty;
tabulate w1inccat;
tabulate p5carnow;
tabulate p5primnw;
tabulate p5disabl;
tabulate p5hmom;
tabulate p5hdad;
tabulate w3momed;
tabulate w3daded;
tabulate w3pared;
tabulate w3povrty;
tabulate w3inccat;
tabulate t5glvl;
tabulate s2ksctyp;
tabulate s3sctyp;
tabulate s4sctyp;
tabulate s5sctyp;
tabulate hsattend;
tabulate hscheck;
tabulate c1screen;
tabulate c2screen;
tabulate c3screen;
tabulate c4screen;
tabulate p1readbo;
tabulate p1lvgran;
tabulate p1clsgrn;
tabulate p1hsever;
tabulate p1hstype;
tabulate p1hsfee;
tabulate p1hsunit;
tabulate p1cever;
tabulate p1weigh5;
tabulate p1weigh6;
tabulate p1hscale;
tabulate p1anylng;
tabulate p1lang1;
tabulate p1lang2;
tabulate p1lang3;
tabulate p1lang4;
tabulate p1lang5;
tabulate p1lang6;
tabulate p1lang7;
tabulate p1lang8;
tabulate p1lang9;
tabulate p1lang10;
tabulate p1lang11;
tabulate p1lang12;
tabulate p1lang13;
tabulate p1lang14;
tabulate p1lang15;
tabulate p1lang18;
tabulate p1langs1;
tabulate p1langs3;
tabulate p1langs4;
tabulate p1prmlng;
tabulate p1wicmom;
tabulate p1wicchd;
tabulate p1afdc;
tabulate p1whenaf;
tabulate p1anyaid;
tabulate p1fstamp;
tabulate p1whenfs;
tabulate p1fstam2;
tabulate p2curmar;
tabulate p2chplac;
tabulate p2cntryb;
tabulate p2anylng;
tabulate p2prmlng;
tabulate p2wicmom;
tabulate p2wicchd;
tabulate p2homecm;
tabulate p2relig;
tabulate p2argrel;
tabulate p2dentis;
tabulate p2doctor;
tabulate p2cover;
tabulate p2aerobi;
tabulate p2pubprk;
tabulate p2church;
tabulate p2spteam;
tabulate p2ymca;
tabulate p2hlthcl;
tabulate p2cubsct;
tabulate p2frmclb;
tabulate p2typac7;
tabulate p2health;
tabulate p2afdc;
tabulate p2fstamp;
tabulate p2schllu;
tabulate p2rlunch;
tabulate p2lunchs;
tabulate p2freerd;
tabulate p3curmar;
tabulate p3anylng;
tabulate p3prmlng;
tabulate p3wicmom;
tabulate p3wicchd;
tabulate p4momcob;
tabulate p4dadcob;
tabulate p4curmar;
tabulate p4milfam;
tabulate p4immfam;
tabulate p4hsbefk;
tabulate p4anylng;
tabulate p4prmlng;
tabulate p4chplac;
tabulate p4cbirth;
tabulate p4wicmom;
tabulate p4wicchd;
tabulate p4readbo;
tabulate p4homecm;
tabulate p4rrelsv;
tabulate p4hscale;
tabulate p4dentis;
tabulate p4doctor;
tabulate p4priins;
tabulate p4medaid;
tabulate p4chip;
tabulate p4milhea;
tabulate p4agovpg;
tabulate p4noinsu;
tabulate p4afdc;
tabulate p4fstamp;
tabulate p4schllu;
tabulate p4rlunch;
tabulate p4lunchs;
tabulate p4freerd;
tabulate p4inccat;
tabulate p5momcob;
tabulate p5dadcob;
tabulate p5curmar;
tabulate p5readbo;
tabulate p5homecm;
tabulate p5hscale;
tabulate p5dentis;
tabulate p5doctor;
tabulate p5priins;
tabulate p5medaid;
tabulate p5chip;
tabulate p5milhea;
tabulate p5agovpg;
tabulate p5noinsu;
tabulate p5aerobi;
tabulate p5pubprk;
tabulate p5church;
tabulate p5spteam;
tabulate p5ymca;
tabulate p5hlthcl;
tabulate p5cubsct;
tabulate p5frmclb;
tabulate p5typac7;
tabulate p5health;
tabulate p5afdc;
tabulate p5fstamp;
tabulate p5reqfs;
tabulate p5schllu;
tabulate p5rlunch;
tabulate p5lunchs;
tabulate p5freerd;
tabulate p5schlbk;
tabulate p5chieat;
tabulate p5frered;
tabulate p5inccat;
summarize r1_kage r2_kage r3age r4age c23cw0 c123cw0 c24cw0 c124cw0 c1_4cw0 c23pw0 c123pw0 c24pw0 c124pw0 c1_4pw0 c245cw0 c45cw0 c1_5fc0 c1_5sc0 c245pw0 c45pw0 c1_5fp0 c1_5sp0 c1r2rscl c1r2rtsc c1r2mscl c1r2mtsc c2r2rscl c2r2rtsc c2r2mscl c2r2mtsc c3r2rscl c3r2rtsc c3r2mscl c3r2mtsc c4r2rscl c4r2rtsc c4r2mscl c4r2mtsc c5r2rscl c5r2rtsc c5r2mscl c5r2mtsc c5sscale c5stscor c5sdqrdc c5sdqmtc c5sdqsbc c5sdqprc c5sdqext c5sdqint t1rarsli t1rarsma t1rarsge t1learn t1contro t1interp t1extern t1intern t2rarsli t2rarsma t2rarsge t2learn t2contro t2interp t2extern t2intern t4karsli t4karsma t4karsge t4arslit t4arsmat t4arsgen t4learn t4contro t4interp t4extern t4intern t5arslit t5arsmat t5arssci t5arssoc t5learn t5contro t5interp t5extern t5intern t5scint c1bmi c2bmi c3bmi c4bmi c5bmi p1hmafb p1agefrs p1numnow p1hrsnow p1numsib p1hrsprk p1costpk p2numsib wknumprk wkincome p3numnow p3hrsnow p4numnow p4hrsnow p4numsib w1income p5numnow p5hrsnow p5numsib p1chlboo p1chlaud p1hsdays p1hshrs p1hscost p1cageyr p1cagemo p1weighp p1weigho p1yrsliv p1mthliv p2rapid p2whenaf p2mofdst p2numlnc p2income p4chlboo p4whenaf p4mofdst p4numlnc p5chlboo p5rapid p5whenaf p5mofdst p5numlnc p5numbkf;
