/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 int     year                                 1-4 ///
 byte    datanum                              5-6 ///
 double  serial                               7-14 ///
 int     hhwt                                15-18 ///
 byte    region                              19-20 ///
 byte    stateicp                            21-22 ///
 byte    statefip                            23-24 ///
 byte    urban                               25 ///
 byte    metro                               26 ///
 int     metaread                            27-30 ///
 int     city                                31-34 ///
 byte    gq                                  35 ///
 int     perwt                               36-39 ///
 int     relate                              40-41 ///
 int     related                             42-45 ///
 int     race                                46 ///
 int     raced                               47-49 ///
 long    ftotinc                             50-56 ///
 using usa_00011.dat

label var year `"Census year"'
label var datanum `"Data set number"'
label var serial `"Household serial number"'
label var hhwt `"Household weight"'
label var region `"Census region and division"'
label var stateicp `"State (ICPSR code)"'
label var statefip `"State (FIPS code)"'
label var urban `"Urban/rural status"'
label var metro `"Metropolitan status"'
label var metaread `"Metropolitan area [detailed version]"'
label var city `"City"'
label var gq `"Group quarters status"'
label var perwt `"Person weight"'
label var relate `"Relationship to household head [general version]"'
label var related `"Relationship to household head [detailed version]"'
label var race `"Race [general version]"'
label var raced `"Race [detailed version]"'
label var ftotinc `"Total family income"'

label define yearlbl 1850 `"1850"'
label define yearlbl 1860 `"1860"', add
label define yearlbl 1870 `"1870"', add
label define yearlbl 1880 `"1880"', add
label define yearlbl 1900 `"1900"', add
label define yearlbl 1910 `"1910"', add
label define yearlbl 1920 `"1920"', add
label define yearlbl 1930 `"1930"', add
label define yearlbl 1940 `"1940"', add
label define yearlbl 1950 `"1950"', add
label define yearlbl 1960 `"1960"', add
label define yearlbl 1970 `"1970"', add
label define yearlbl 1980 `"1980"', add
label define yearlbl 1990 `"1990"', add
label define yearlbl 2000 `"2000"', add
label define yearlbl 2001 `"2001"', add
label define yearlbl 2002 `"2002"', add
label define yearlbl 2003 `"2003"', add
label define yearlbl 2004 `"2004"', add
label define yearlbl 2005 `"2005"', add
label define yearlbl 2006 `"2006"', add
label define yearlbl 2007 `"2007"', add
label define yearlbl 2008 `"2008"', add
label values year yearlbl

label define regionlbl 11 `"New England Division"', add
label define regionlbl 12 `"Middle Atlantic Division"', add
label define regionlbl 13 `"Mixed Northeast Divisions (1970 Metro)"', add
label define regionlbl 21 `"East North Central Div."', add
label define regionlbl 22 `"West North Central Div."', add
label define regionlbl 23 `"Mixed Midwest Divisions (1970 Metro)"', add
label define regionlbl 31 `"South Atlantic Division"', add
label define regionlbl 32 `"East South Central Div."', add
label define regionlbl 33 `"West South Central Div."', add
label define regionlbl 34 `"Mixed Southern Divisions (1970 Metro)"', add
label define regionlbl 41 `"Mountain Division"', add
label define regionlbl 42 `"Pacific Division"', add
label define regionlbl 43 `"Mixed Western Divisions (1970 Metro)"', add
label define regionlbl 91 `"Military/Military reservations"', add
label define regionlbl 92 `"PUMA boundaries cross state lines-1% sample"', add
label define regionlbl 97 `"State not identified"', add
label define regionlbl 99 `"Not identified"', add
label values region regionlbl

label define stateicplbl 01 `"Connecticut"'
label define stateicplbl 02 `"Maine"', add
label define stateicplbl 03 `"Massachusetts"', add
label define stateicplbl 04 `"New Hampshire"', add
label define stateicplbl 05 `"Rhode Island"', add
label define stateicplbl 06 `"Vermont"', add
label define stateicplbl 11 `"Delaware"', add
label define stateicplbl 12 `"New Jersey"', add
label define stateicplbl 13 `"New York"', add
label define stateicplbl 14 `"Pennsylvania"', add
label define stateicplbl 21 `"Illinois"', add
label define stateicplbl 22 `"Indiana"', add
label define stateicplbl 23 `"Michigan"', add
label define stateicplbl 24 `"Ohio"', add
label define stateicplbl 25 `"Wisconsin"', add
label define stateicplbl 31 `"Iowa"', add
label define stateicplbl 32 `"Kansas"', add
label define stateicplbl 33 `"Minnesota"', add
label define stateicplbl 34 `"Missouri"', add
label define stateicplbl 35 `"Nebraska"', add
label define stateicplbl 36 `"North Dakota"', add
label define stateicplbl 37 `"South Dakota"', add
label define stateicplbl 40 `"Virginia"', add
label define stateicplbl 41 `"Alabama"', add
label define stateicplbl 42 `"Arkansas"', add
label define stateicplbl 43 `"Florida"', add
label define stateicplbl 44 `"Georgia"', add
label define stateicplbl 45 `"Louisiana"', add
label define stateicplbl 46 `"Mississippi"', add
label define stateicplbl 47 `"North Carolina"', add
label define stateicplbl 48 `"South Carolina"', add
label define stateicplbl 49 `"Texas"', add
label define stateicplbl 51 `"Kentucky"', add
label define stateicplbl 52 `"Maryland"', add
label define stateicplbl 53 `"Oklahoma"', add
label define stateicplbl 54 `"Tennessee"', add
label define stateicplbl 56 `"West Virginia"', add
label define stateicplbl 61 `"Arizona"', add
label define stateicplbl 62 `"Colorado"', add
label define stateicplbl 63 `"Idaho"', add
label define stateicplbl 64 `"Montana"', add
label define stateicplbl 65 `"Nevada"', add
label define stateicplbl 66 `"New Mexico"', add
label define stateicplbl 67 `"Utah"', add
label define stateicplbl 68 `"Wyoming"', add
label define stateicplbl 71 `"California"', add
label define stateicplbl 72 `"Oregon"', add
label define stateicplbl 73 `"Washington"', add
label define stateicplbl 81 `"Alaska"', add
label define stateicplbl 82 `"Hawaii"', add
label define stateicplbl 83 `"Puerto Rico"', add
label define stateicplbl 96 `"State groupings (1980 Urban/rural sample)"', add
label define stateicplbl 97 `"Military/Mil. Reservations"', add
label define stateicplbl 98 `"District of Columbia"', add
label define stateicplbl 99 `"State not identified"', add
label values stateicp stateicplbl

label define statefiplbl 01 `"Alabama"'
label define statefiplbl 02 `"Alaska"', add
label define statefiplbl 04 `"Arizona"', add
label define statefiplbl 05 `"Arkansas"', add
label define statefiplbl 06 `"California"', add
label define statefiplbl 08 `"Colorado"', add
label define statefiplbl 09 `"Connecticut"', add
label define statefiplbl 10 `"Delaware"', add
label define statefiplbl 11 `"District of Columbia"', add
label define statefiplbl 12 `"Florida"', add
label define statefiplbl 13 `"Georgia"', add
label define statefiplbl 15 `"Hawaii"', add
label define statefiplbl 16 `"Idaho"', add
label define statefiplbl 17 `"Illinois"', add
label define statefiplbl 18 `"Indiana"', add
label define statefiplbl 19 `"Iowa"', add
label define statefiplbl 20 `"Kansas"', add
label define statefiplbl 21 `"Kentucky"', add
label define statefiplbl 22 `"Louisiana"', add
label define statefiplbl 23 `"Maine"', add
label define statefiplbl 24 `"Maryland"', add
label define statefiplbl 25 `"Massachusetts"', add
label define statefiplbl 26 `"Michigan"', add
label define statefiplbl 27 `"Minnesota"', add
label define statefiplbl 28 `"Mississippi"', add
label define statefiplbl 29 `"Missouri"', add
label define statefiplbl 30 `"Montana"', add
label define statefiplbl 31 `"Nebraska"', add
label define statefiplbl 32 `"Nevada"', add
label define statefiplbl 33 `"New Hampshire"', add
label define statefiplbl 34 `"New Jersey"', add
label define statefiplbl 35 `"New Mexico"', add
label define statefiplbl 36 `"New York"', add
label define statefiplbl 37 `"North Carolina"', add
label define statefiplbl 38 `"North Dakota"', add
label define statefiplbl 39 `"Ohio"', add
label define statefiplbl 40 `"Oklahoma"', add
label define statefiplbl 41 `"Oregon"', add
label define statefiplbl 42 `"Pennsylvania"', add
label define statefiplbl 44 `"Rhode Island"', add
label define statefiplbl 45 `"South Carolina"', add
label define statefiplbl 46 `"South Dakota"', add
label define statefiplbl 47 `"Tennessee"', add
label define statefiplbl 48 `"Texas"', add
label define statefiplbl 49 `"Utah"', add
label define statefiplbl 50 `"Vermont"', add
label define statefiplbl 51 `"Virginia"', add
label define statefiplbl 53 `"Washington"', add
label define statefiplbl 54 `"West Virginia"', add
label define statefiplbl 55 `"Wisconsin"', add
label define statefiplbl 56 `"Wyoming"', add
label define statefiplbl 61 `"Maine-New Hampshire-Vermont"', add
label define statefiplbl 62 `"Massachusetts-Rhode Island"', add
label define statefiplbl 63 `"Minnesota-Iowa-Missouri-Kansas-Nebraska-S.Dakota-N.Dakota"', add
label define statefiplbl 64 `"Maryland-Delaware"', add
label define statefiplbl 65 `"Montana-Idaho-Wyoming"', add
label define statefiplbl 66 `"Utah-Nevada"', add
label define statefiplbl 67 `"Arizona-New Mexico"', add
label define statefiplbl 68 `"Alaska-Hawaii"', add
label define statefiplbl 72 `"Puerto Rico"', add
label define statefiplbl 97 `"Military/Mil. Reservation"', add
label define statefiplbl 99 `"State not identified"', add
label values statefip statefiplbl

label define urbanlbl 0 `"N/A"'
label define urbanlbl 1 `"Rural"', add
label define urbanlbl 2 `"Urban"', add
label values urban urbanlbl

label define metrolbl 0 `"Not identifiable"'
label define metrolbl 1 `"Not in metro area"', add
label define metrolbl 2 `"In metro area, central city"', add
label define metrolbl 3 `"In metro, area, outside central city"', add
label define metrolbl 4 `"Central city status unknown"', add
label values metro metrolbl

label define metareadlbl 0000 `"Not identifiable or not in an MSA"'
label define metareadlbl 0040 `"Abilene, TX"', add
label define metareadlbl 0060 `"Aguadilla, PR"', add
label define metareadlbl 0080 `"Akron, OH"', add
label define metareadlbl 0120 `"Albany, GA"', add
label define metareadlbl 0160 `"Albany-Schenectady-Troy, NY"', add
label define metareadlbl 0200 `"Albuquerque, NM"', add
label define metareadlbl 0220 `"Alexandria, LA"', add
label define metareadlbl 0240 `"Allentown-Bethlehem-Easton, PA/NJ"', add
label define metareadlbl 0280 `"Altoona, PA"', add
label define metareadlbl 0320 `"Amarillo, TX"', add
label define metareadlbl 0380 `"Anchorage, AK"', add
label define metareadlbl 0400 `"Anderson, IN"', add
label define metareadlbl 0440 `"Ann Arbor, MI"', add
label define metareadlbl 0450 `"Anniston, AL"', add
label define metareadlbl 0460 `"Appleton-Oskosh-Neenah, WI"', add
label define metareadlbl 0470 `"Arecibo, PR"', add
label define metareadlbl 0480 `"Asheville, NC"', add
label define metareadlbl 0500 `"Athens, GA"', add
label define metareadlbl 0520 `"Atlanta, GA"', add
label define metareadlbl 0560 `"Atlantic City, NJ"', add
label define metareadlbl 0580 `"Auburn-Opelika, AL"', add
label define metareadlbl 0600 `"Augusta-Aiken, GA-SC"', add
label define metareadlbl 0640 `"Austin, TX"', add
label define metareadlbl 0680 `"Bakersfield, CA"', add
label define metareadlbl 0720 `"Baltimore, MD"', add
label define metareadlbl 0730 `"Bangor, ME"', add
label define metareadlbl 0740 `"Barnstable-Yarmouth, MA"', add
label define metareadlbl 0760 `"Baton Rouge, LA"', add
label define metareadlbl 0780 `"Battle Creek, MI"', add
label define metareadlbl 0840 `"Beaumont-Port Arthur-Orange,TX"', add
label define metareadlbl 0860 `"Bellingham, WA"', add
label define metareadlbl 0870 `"Benton Harbor, MI"', add
label define metareadlbl 0880 `"Billings, MT"', add
label define metareadlbl 0920 `"Biloxi-Gulfport, MS"', add
label define metareadlbl 0960 `"Binghamton, NY"', add
label define metareadlbl 1000 `"Birmingham, AL"', add
label define metareadlbl 1010 `"Bismarck,ND"', add
label define metareadlbl 1020 `"Bloomington, IN"', add
label define metareadlbl 1040 `"Bloomington-Normal, IL"', add
label define metareadlbl 1080 `"Boise City, ID"', add
label define metareadlbl 1120 `"Boston, MA"', add
label define metareadlbl 1121 `"Lawrence-Haverhill, MA/NH"', add
label define metareadlbl 1122 `"Lowell, MA/NH"', add
label define metareadlbl 1123 `"Salem-Gloucester, MA"', add
label define metareadlbl 1140 `"Bradenton, FL"', add
label define metareadlbl 1150 `"Bremerton, WA"', add
label define metareadlbl 1160 `"Bridgeport, CT"', add
label define metareadlbl 1200 `"Brockton, MA"', add
label define metareadlbl 1240 `"Brownsville-Harlingen-San Benito, TX"', add
label define metareadlbl 1260 `"Bryan-College Station, TX"', add
label define metareadlbl 1280 `"Buffalo-Niagara Falls, NY"', add
label define metareadlbl 1281 `"Niagara Falls, NY"', add
label define metareadlbl 1300 `"Burlington, NC"', add
label define metareadlbl 1310 `"Burlington, VT"', add
label define metareadlbl 1320 `"Canton, OH"', add
label define metareadlbl 1330 `"Caguas, PR"', add
label define metareadlbl 1350 `"Casper, WY"', add
label define metareadlbl 1360 `"Cedar Rapids, IA"', add
label define metareadlbl 1400 `"Champaign-Urbana-Rantoul, IL"', add
label define metareadlbl 1440 `"Charleston-N.Charleston,SC"', add
label define metareadlbl 1480 `"Charleston, WV"', add
label define metareadlbl 1520 `"Charlotte-Gastonia-Rock Hill, SC"', add
label define metareadlbl 1521 `"Rock Hill, SC"', add
label define metareadlbl 1540 `"Charlottesville, VA"', add
label define metareadlbl 1560 `"Chattanooga, TN/GA"', add
label define metareadlbl 1580 `"Cheyenne, WY"', add
label define metareadlbl 1600 `"Chicago-Gary-Lake, IL"', add
label define metareadlbl 1601 `"Aurora-Elgin, IL"', add
label define metareadlbl 1602 `"Gary-Hammond-East Chicago, IN"', add
label define metareadlbl 1603 `"Joliet IL"', add
label define metareadlbl 1604 `"Lake County, IL"', add
label define metareadlbl 1620 `"Chico, CA"', add
label define metareadlbl 1640 `"Cincinnati OH/KY/IN"', add
label define metareadlbl 1660 `"Clarksville-Hopkinsville, TN/KY"', add
label define metareadlbl 1680 `"Cleveland, OH"', add
label define metareadlbl 1720 `"Colorado Springs, CO"', add
label define metareadlbl 1740 `"Columbia, MO"', add
label define metareadlbl 1760 `"Columbia, SC"', add
label define metareadlbl 1800 `"Columbus, GA/AL"', add
label define metareadlbl 1840 `"Columbus, OH"', add
label define metareadlbl 1880 `"Corpus Christi, TX"', add
label define metareadlbl 1900 `"Cumberland, MD/WV"', add
label define metareadlbl 1920 `"Dallas-Fort Worth, TX"', add
label define metareadlbl 1921 `"Fort Worth-Arlington, TX"', add
label define metareadlbl 1930 `"Danbury, CT"', add
label define metareadlbl 1950 `"Danville, VA"', add
label define metareadlbl 1960 `"Davenport, IA Rock Island-Moline, IL"', add
label define metareadlbl 2000 `"Dayton-Springfield, OH"', add
label define metareadlbl 2001 `"Springfield, OH"', add
label define metareadlbl 2020 `"Daytona Beach, FL"', add
label define metareadlbl 2030 `"Decatur, AL"', add
label define metareadlbl 2040 `"Decatur, IL"', add
label define metareadlbl 2080 `"Denver-Boulder-Longmont, CO"', add
label define metareadlbl 2081 `"Boulder-Longmont, CO"', add
label define metareadlbl 2120 `"Des Moines, IA"', add
label define metareadlbl 2121 `"Polk, IA"', add
label define metareadlbl 2160 `"Detroit, MI"', add
label define metareadlbl 2180 `"Dothan, AL"', add
label define metareadlbl 2190 `"Dover, DE"', add
label define metareadlbl 2200 `"Dubuque, IA"', add
label define metareadlbl 2240 `"Duluth-Superior, MN/WI"', add
label define metareadlbl 2281 `"Dutchess Co., NY"', add
label define metareadlbl 2290 `"Eau Claire, WI"', add
label define metareadlbl 2310 `"El Paso, TX"', add
label define metareadlbl 2320 `"Elkhart-Goshen, IN"', add
label define metareadlbl 2330 `"Elmira, NY"', add
label define metareadlbl 2340 `"Enid, OK"', add
label define metareadlbl 2360 `"Erie, PA"', add
label define metareadlbl 2400 `"Eugene-Springfield, OR"', add
label define metareadlbl 2440 `"Evansville, IN/KY"', add
label define metareadlbl 2520 `"Fargo-Morehead, ND/MN"', add
label define metareadlbl 2560 `"Fayetteville, NC"', add
label define metareadlbl 2580 `"Fayetteville-Springdale, AR"', add
label define metareadlbl 2600 `"Fitchburg-Leominster, MA"', add
label define metareadlbl 2620 `"Flagstaff, AZ-UT"', add
label define metareadlbl 2640 `"Flint, MI"', add
label define metareadlbl 2650 `"Florence, AL"', add
label define metareadlbl 2660 `"Florence, SC"', add
label define metareadlbl 2670 `"Fort Collins-Loveland, CO"', add
label define metareadlbl 2680 `"Fort Lauderdale-Hollywood-Pompano Beach, FL"', add
label define metareadlbl 2700 `"Fort Myers-Cape Coral, FL"', add
label define metareadlbl 2710 `"Fort Pierce, FL"', add
label define metareadlbl 2720 `"Fort Smith, AR/OK"', add
label define metareadlbl 2750 `"Fort Walton Beach, FL"', add
label define metareadlbl 2760 `"Fort Wayne, IN"', add
label define metareadlbl 2840 `"Fresno, CA"', add
label define metareadlbl 2880 `"Gadsden, AL"', add
label define metareadlbl 2900 `"Gainesville, FL"', add
label define metareadlbl 2920 `"Galveston-Texas City, TX"', add
label define metareadlbl 2970 `"Glens Falls, NY"', add
label define metareadlbl 2980 `"Goldsboro, NC"', add
label define metareadlbl 2990 `"Grand Forks, ND/MN"', add
label define metareadlbl 3000 `"Grand Rapids, MI"', add
label define metareadlbl 3010 `"Grand Junction, CO"', add
label define metareadlbl 3040 `"Great Falls, MT"', add
label define metareadlbl 3060 `"Greeley, CO"', add
label define metareadlbl 3080 `"Green Bay, WI"', add
label define metareadlbl 3120 `"Greensboro-Winston Salem-High Point, NC"', add
label define metareadlbl 3121 `"Winston-Salem, NC"', add
label define metareadlbl 3150 `"Greenville, NC"', add
label define metareadlbl 3160 `"Greenville-Spartanburg-Anderson SC"', add
label define metareadlbl 3161 `"Anderson, SC"', add
label define metareadlbl 3180 `"Hagerstown, MD"', add
label define metareadlbl 3200 `"Hamilton-Middleton, OH"', add
label define metareadlbl 3240 `"Harrisburg-Lebanon-Carlisle, PA"', add
label define metareadlbl 3280 `"Hartford-Bristol-Middleton-New Britain, CT"', add
label define metareadlbl 3281 `"Bristol, CT"', add
label define metareadlbl 3282 `"Middletown, CT"', add
label define metareadlbl 3283 `"New Britain, CT"', add
label define metareadlbl 3290 `"Hickory-Morgantown, NC"', add
label define metareadlbl 3300 `"Hattiesburg, MS"', add
label define metareadlbl 3320 `"Honolulu, HI"', add
label define metareadlbl 3350 `"Houma-Thibodoux, LA"', add
label define metareadlbl 3360 `"Houston-Brazoria, TX"', add
label define metareadlbl 3361 `"Brazoria, TX"', add
label define metareadlbl 3400 `"Huntington-Ashland, WV/KY/OH"', add
label define metareadlbl 3440 `"Huntsville, AL"', add
label define metareadlbl 3480 `"Indianapolis, IN"', add
label define metareadlbl 3500 `"Iowa City, IA"', add
label define metareadlbl 3520 `"Jackson, MI"', add
label define metareadlbl 3560 `"Jackson, MS"', add
label define metareadlbl 3580 `"Jackson, TN"', add
label define metareadlbl 3590 `"Jacksonville, FL"', add
label define metareadlbl 3600 `"Jacksonville, NC"', add
label define metareadlbl 3610 `"Jamestown-Dunkirk, NY"', add
label define metareadlbl 3620 `"Janesville-Beloit, WI"', add
label define metareadlbl 3660 `"Johnson City-Kingsport-Bristol, TN/VA"', add
label define metareadlbl 3680 `"Johnstown, PA"', add
label define metareadlbl 3710 `"Joplin, MO"', add
label define metareadlbl 3720 `"Kalamazoo-Portage, MI"', add
label define metareadlbl 3740 `"Kankakee, IL"', add
label define metareadlbl 3760 `"Kansas City, MO-KS"', add
label define metareadlbl 3800 `"Kenosha, WI"', add
label define metareadlbl 3810 `"Kileen-Temple, TX"', add
label define metareadlbl 3840 `"Knoxville, TN"', add
label define metareadlbl 3850 `"Kokomo, IN"', add
label define metareadlbl 3870 `"LaCrosse, WI"', add
label define metareadlbl 3880 `"Lafayette, LA"', add
label define metareadlbl 3920 `"Lafayette-W. Lafayette, IN"', add
label define metareadlbl 3960 `"Lake Charles, LA"', add
label define metareadlbl 3980 `"Lakeland-Winterhaven, FL"', add
label define metareadlbl 4000 `"Lancaster, PA"', add
label define metareadlbl 4040 `"Lansing-E. Lansing, MI"', add
label define metareadlbl 4080 `"Laredo, TX"', add
label define metareadlbl 4100 `"Las Cruces, NM"', add
label define metareadlbl 4120 `"Las Vegas, NV"', add
label define metareadlbl 4150 `"Lawrence, KS"', add
label define metareadlbl 4200 `"Lawton, OK"', add
label define metareadlbl 4240 `"Lewiston-Auburn, ME"', add
label define metareadlbl 4280 `"Lexington-Fayette, KY"', add
label define metareadlbl 4320 `"Lima, OH"', add
label define metareadlbl 4360 `"Lincoln, NE"', add
label define metareadlbl 4400 `"Little Rock-North Little Rock, AR"', add
label define metareadlbl 4410 `"Long Branch-Asbury Park,NJ"', add
label define metareadlbl 4420 `"Longview-Marshall, TX"', add
label define metareadlbl 4440 `"Lorain-Elyria, OH"', add
label define metareadlbl 4480 `"Los Angeles-Long Beach, CA"', add
label define metareadlbl 4481 `"Anaheim-Santa Ana-Garden Grove, CA"', add
label define metareadlbl 4482 `"Orange County, CA"', add
label define metareadlbl 4520 `"Louisville, KY/IN"', add
label define metareadlbl 4600 `"Lubbock, TX"', add
label define metareadlbl 4640 `"Lynchburg, VA"', add
label define metareadlbl 4680 `"Macon-Warner Robins, GA"', add
label define metareadlbl 4720 `"Madison, WI"', add
label define metareadlbl 4760 `"Manchester, NH"', add
label define metareadlbl 4800 `"Mansfield, OH"', add
label define metareadlbl 4840 `"Mayaguez, PR"', add
label define metareadlbl 4880 `"McAllen-Edinburg-Pharr-Mission, TX"', add
label define metareadlbl 4890 `"Medford, OR"', add
label define metareadlbl 4900 `"Melbourne-Titusville-Cocoa-Palm Bay, FL"', add
label define metareadlbl 4920 `"Memphis, TN/AR/MS"', add
label define metareadlbl 4940 `"Merced, CA"', add
label define metareadlbl 5000 `"Miami-Hialeah, FL"', add
label define metareadlbl 5040 `"Midland, TX"', add
label define metareadlbl 5080 `"Milwaukee, WI"', add
label define metareadlbl 5120 `"Minneapolis-St. Paul, MN"', add
label define metareadlbl 5140 `"Missoula, MT"', add
label define metareadlbl 5160 `"Mobile, AL"', add
label define metareadlbl 5170 `"Modesto, CA"', add
label define metareadlbl 5190 `"Monmouth-Ocean, NJ"', add
label define metareadlbl 5200 `"Monroe, LA"', add
label define metareadlbl 5240 `"Montgomery, AL"', add
label define metareadlbl 5280 `"Muncie, IN"', add
label define metareadlbl 5320 `"Muskegon-Norton Shores-Muskegon Heights, MI"', add
label define metareadlbl 5330 `"Myrtle Beach, SC"', add
label define metareadlbl 5340 `"Naples, FL"', add
label define metareadlbl 5350 `"Nashua, NH"', add
label define metareadlbl 5360 `"Nashville, TN"', add
label define metareadlbl 5400 `"New Bedford, MA"', add
label define metareadlbl 5460 `"New Brunswick-Perth Amboy-Sayreville, NJ"', add
label define metareadlbl 5480 `"New Haven-Meriden, CT"', add
label define metareadlbl 5481 `"Meriden"', add
label define metareadlbl 5482 `"New Haven, CT"', add
label define metareadlbl 5520 `"New London-Norwich, CT/RI"', add
label define metareadlbl 5560 `"New Orleans, LA"', add
label define metareadlbl 5600 `"New York-Northeastern NJ"', add
label define metareadlbl 5601 `"Nassau Co, NY"', add
label define metareadlbl 5602 `"Bergen-Passaic, NJ"', add
label define metareadlbl 5603 `"Jersey City, NJ"', add
label define metareadlbl 5604 `"Middlesex-Somerset-Hunterdon, NJ"', add
label define metareadlbl 5605 `"Newark, NJ"', add
label define metareadlbl 5640 `"Newark, OH"', add
label define metareadlbl 5660 `"Newburgh-Middletown, NY"', add
label define metareadlbl 5720 `"Norfolk-VA Beach-Newport News, VA"', add
label define metareadlbl 5721 `"Newport News-Hampton"', add
label define metareadlbl 5722 `"Norfolk- VA Beach-Portsmouth"', add
label define metareadlbl 5760 `"Norwalk, CT"', add
label define metareadlbl 5790 `"Ocala, FL"', add
label define metareadlbl 5800 `"Odessa, TX"', add
label define metareadlbl 5880 `"Oklahoma City, OK"', add
label define metareadlbl 5910 `"Olympia, WA"', add
label define metareadlbl 5920 `"Omaha, NE/IA"', add
label define metareadlbl 5950 `"Orange, NY"', add
label define metareadlbl 5960 `"Orlando, FL"', add
label define metareadlbl 5990 `"Owensboro, KY"', add
label define metareadlbl 6010 `"Panama City, FL"', add
label define metareadlbl 6020 `"Parkersburg-Marietta,WV/OH"', add
label define metareadlbl 6030 `"Pascagoula-Moss Point, MS"', add
label define metareadlbl 6080 `"Pensacola, FL"', add
label define metareadlbl 6120 `"Peoria, IL"', add
label define metareadlbl 6160 `"Philadelphia, PA/NJ"', add
label define metareadlbl 6200 `"Phoenix, AZ"', add
label define metareadlbl 6240 `"Pine Bluff, AR"', add
label define metareadlbl 6280 `"Pittsburgh-Beaver Valley, PA"', add
label define metareadlbl 6281 `"Beaver County, PA"', add
label define metareadlbl 6320 `"Pittsfield, MA"', add
label define metareadlbl 6360 `"Ponce, PR"', add
label define metareadlbl 6400 `"Portland, ME"', add
label define metareadlbl 6440 `"Portland-Vancouver, OR"', add
label define metareadlbl 6441 `"Vancouver, WA"', add
label define metareadlbl 6450 `"Portsmouth-Dover-Rochester, NH/ME"', add
label define metareadlbl 6460 `"Poughkeepsie, NY"', add
label define metareadlbl 6480 `"Providence-Fall River-Pawtucket, MA/RI"', add
label define metareadlbl 6481 `"Fall River, MA/RI"', add
label define metareadlbl 6482 `"Pawtuckett-Woonsocket-Attleboro, RI/MA"', add
label define metareadlbl 6520 `"Provo-Orem, UT"', add
label define metareadlbl 6560 `"Pueblo, CO"', add
label define metareadlbl 6580 `"Punta Gorda, FL"', add
label define metareadlbl 6600 `"Racine, WI"', add
label define metareadlbl 6640 `"Raleigh-Durham, NC"', add
label define metareadlbl 6641 `"Durham, NC"', add
label define metareadlbl 6660 `"Rapid City, SD"', add
label define metareadlbl 6680 `"Reading, PA"', add
label define metareadlbl 6690 `"Redding, CA"', add
label define metareadlbl 6720 `"Reno, NV"', add
label define metareadlbl 6740 `"Richland-Kennewick-Pasco, WA"', add
label define metareadlbl 6760 `"Richmond-Petersburg, VA"', add
label define metareadlbl 6761 `"Petersburg-Colonial Heights, VA"', add
label define metareadlbl 6780 `"Riverside-San Bernardino,CA"', add
label define metareadlbl 6781 `"San Bernardino, CA"', add
label define metareadlbl 6800 `"Roanoke, VA"', add
label define metareadlbl 6820 `"Rochester, MN"', add
label define metareadlbl 6840 `"Rochester, NY"', add
label define metareadlbl 6880 `"Rockford, IL"', add
label define metareadlbl 6895 `"Rocky Mount, NC"', add
label define metareadlbl 6920 `"Sacramento, CA"', add
label define metareadlbl 6960 `"Saginaw-Bay City-Midland, MI"', add
label define metareadlbl 6961 `"Bay City, MI"', add
label define metareadlbl 6980 `"St. Cloud, MN"', add
label define metareadlbl 7000 `"St. Joseph, MO"', add
label define metareadlbl 7040 `"St. Louis, MO-IL"', add
label define metareadlbl 7080 `"Salem, OR"', add
label define metareadlbl 7120 `"Salinas-Sea Side-Monterey, CA"', add
label define metareadlbl 7140 `"Salisbury-Concord, NC"', add
label define metareadlbl 7160 `"Salt Lake City-Ogden, UT"', add
label define metareadlbl 7161 `"Ogden"', add
label define metareadlbl 7200 `"San Angelo, TX"', add
label define metareadlbl 7240 `"San Antonio, TX"', add
label define metareadlbl 7320 `"San Diego, CA"', add
label define metareadlbl 7360 `"San Francisco-Oakland-Vallejo, CA"', add
label define metareadlbl 7361 `"Oakland, CA"', add
label define metareadlbl 7362 `"Vallejo-Fairfield-Napa, CA"', add
label define metareadlbl 7400 `"San Jose, CA"', add
label define metareadlbl 7440 `"San Juan-Bayamon, PR"', add
label define metareadlbl 7460 `"San Luis Obispo-Atascad-P Robles, CA"', add
label define metareadlbl 7470 `"Santa Barbara-Santa Maria-Lompoc, CA"', add
label define metareadlbl 7480 `"Santa Cruz, CA"', add
label define metareadlbl 7490 `"Santa Fe, NM"', add
label define metareadlbl 7500 `"Santa Rosa-Petaluma, CA"', add
label define metareadlbl 7510 `"Sarasota, FL"', add
label define metareadlbl 7520 `"Savannah, GA"', add
label define metareadlbl 7560 `"Scranton-Wilkes-Barre, PA"', add
label define metareadlbl 7561 `"Wilkes-Barre-Hazelton, PA"', add
label define metareadlbl 7600 `"Seattle-Everett, WA"', add
label define metareadlbl 7610 `"Sharon, PA"', add
label define metareadlbl 7620 `"Sheboygan, WI"', add
label define metareadlbl 7640 `"Sherman-Denison, TX"', add
label define metareadlbl 7680 `"Shreveport, LA"', add
label define metareadlbl 7720 `"Sioux City, IA/NE"', add
label define metareadlbl 7760 `"Sioux Falls, SD"', add
label define metareadlbl 7800 `"South Bend-Mishawaka, IN"', add
label define metareadlbl 7840 `"Spokane, WA"', add
label define metareadlbl 7880 `"Springfield, IL"', add
label define metareadlbl 7920 `"Springfield, MO"', add
label define metareadlbl 8000 `"Springfield-Holyoke-Chicopee, MA"', add
label define metareadlbl 8040 `"Stamford, CT"', add
label define metareadlbl 8050 `"State College, PA"', add
label define metareadlbl 8080 `"Steubenville-Weirton,OH/WV"', add
label define metareadlbl 8120 `"Stockton, CA"', add
label define metareadlbl 8140 `"Sumter, SC"', add
label define metareadlbl 8160 `"Syracuse, NY"', add
label define metareadlbl 8200 `"Tacoma, WA"', add
label define metareadlbl 8240 `"Tallahassee, FL"', add
label define metareadlbl 8280 `"Tampa-St. Petersburg-Clearwater, FL"', add
label define metareadlbl 8320 `"Terre Haute, IN"', add
label define metareadlbl 8360 `"Texarkana, TX/AR"', add
label define metareadlbl 8400 `"Toledo, OH/MI"', add
label define metareadlbl 8440 `"Topeka, KS"', add
label define metareadlbl 8480 `"Trenton, NJ"', add
label define metareadlbl 8520 `"Tucson, AZ"', add
label define metareadlbl 8560 `"Tulsa, OK"', add
label define metareadlbl 8600 `"Tuscaloosa, AL"', add
label define metareadlbl 8640 `"Tyler, TX"', add
label define metareadlbl 8680 `"Utica-Rome, NY"', add
label define metareadlbl 8730 `"Ventura-Oxnard-Simi Valley, CA"', add
label define metareadlbl 8750 `"Victoria, TX"', add
label define metareadlbl 8760 `"Vineland-Milville-Bridgetown, NJ"', add
label define metareadlbl 8780 `"Visalia-Tulare-Porterville, CA"', add
label define metareadlbl 8800 `"Waco, TX"', add
label define metareadlbl 8840 `"Washington, DC/MD/VA"', add
label define metareadlbl 8880 `"Waterbury, CT"', add
label define metareadlbl 8920 `"Waterloo-Cedar Falls, IA"', add
label define metareadlbl 8940 `"Wausau, WI"', add
label define metareadlbl 8960 `"West Palm Beach-Boca Raton-Delray Beach, FL"', add
label define metareadlbl 9000 `"Wheeling, WV/OH"', add
label define metareadlbl 9040 `"Wichita, KS"', add
label define metareadlbl 9080 `"Wichita Falls, TX"', add
label define metareadlbl 9140 `"Williamsport, PA"', add
label define metareadlbl 9160 `"Wilmington, DE/NJ/MD"', add
label define metareadlbl 9200 `"Wilmington, NC"', add
label define metareadlbl 9240 `"Worcester, MA"', add
label define metareadlbl 9260 `"Yakima, WA"', add
label define metareadlbl 9270 `"Yolo, CA"', add
label define metareadlbl 9280 `"York, PA"', add
label define metareadlbl 9320 `"Youngstown-Warren, OH-PA"', add
label define metareadlbl 9340 `"Yuba City, CA"', add
label define metareadlbl 9360 `"Yuma, AZ"', add
label values metaread metareadlbl

label define citylbl 0000 `"Not in identifiable city (or size group)"'
label define citylbl 0001 `"Aberdeen, SD"', add
label define citylbl 0002 `"Aberdeen, WA"', add
label define citylbl 0003 `"Abilene, TX"', add
label define citylbl 0004 `"Ada, OK"', add
label define citylbl 0005 `"Adams, MA"', add
label define citylbl 0006 `"Adrian, MI"', add
label define citylbl 0010 `"Akron, OH"', add
label define citylbl 0030 `"Alameda, CA"', add
label define citylbl 0050 `"Albany, NY"', add
label define citylbl 0051 `"Albany, GA"', add
label define citylbl 0052 `"Albert Lea, MN"', add
label define citylbl 0070 `"Albuquerque, NM"', add
label define citylbl 0090 `"Alexandria, VA"', add
label define citylbl 0091 `"Alexandria, LA"', add
label define citylbl 0100 `"Alhambra, CA"', add
label define citylbl 0101 `"Aliquippa, PA"', add
label define citylbl 0110 `"Allegheny, PA"', add
label define citylbl 0120 `"Aliquippa, PA"', add
label define citylbl 0130 `"Allentown, PA"', add
label define citylbl 0131 `"Alliance, OH"', add
label define citylbl 0132 `"Alpena, MI"', add
label define citylbl 0140 `"Alton, IL"', add
label define citylbl 0150 `"Altoona, PA"', add
label define citylbl 0160 `"Amarillo, TX"', add
label define citylbl 0161 `"Ambridge, PA"', add
label define citylbl 0162 `"Ames, IA"', add
label define citylbl 0163 `"Amesbury, MA"', add
label define citylbl 0170 `"Amsterdam, NY"', add
label define citylbl 0171 `"Anaconda, MT"', add
label define citylbl 0190 `"Anaheim, CA"', add
label define citylbl 0210 `"Anchorage, AK"', add
label define citylbl 0230 `"Anderson, IN"', add
label define citylbl 0231 `"Anderson, SC"', add
label define citylbl 0250 `"Andover, MA"', add
label define citylbl 0270 `"Ann Arbor, MI"', add
label define citylbl 0271 `"Annapolis, MD"', add
label define citylbl 0272 `"Anniston, AL"', add
label define citylbl 0273 `"Ansonia, CT"', add
label define citylbl 0280 `"Appleton, WI"', add
label define citylbl 0281 `"Ardmore, OK"', add
label define citylbl 0282 `"Argenta, AR"', add
label define citylbl 0283 `"Arkansas, KS"', add
label define citylbl 0290 `"Arlington, TX"', add
label define citylbl 0310 `"Arlington, VA"', add
label define citylbl 0311 `"Arlington, MA"', add
label define citylbl 0312 `"Arnold, PA"', add
label define citylbl 0313 `"Asbury Park, NJ"', add
label define citylbl 0330 `"Asheville, NC"', add
label define citylbl 0331 `"Ashland, OH"', add
label define citylbl 0340 `"Ashland, KY"', add
label define citylbl 0341 `"Ashland, WI"', add
label define citylbl 0342 `"Ashtabula, OH"', add
label define citylbl 0343 `"Astoria, OR"', add
label define citylbl 0344 `"Atchison, KS"', add
label define citylbl 0345 `"Athens, GA"', add
label define citylbl 0346 `"Athol, MA"', add
label define citylbl 0350 `"Atlanta, GA"', add
label define citylbl 0370 `"Atlantic City, NJ"', add
label define citylbl 0371 `"Attleboro, MA"', add
label define citylbl 0390 `"Auburn, NY"', add
label define citylbl 0391 `"Auburn, ME"', add
label define citylbl 0410 `"Augusta, GA"', add
label define citylbl 0430 `"Augusta, ME"', add
label define citylbl 0450 `"Aurora, CO"', add
label define citylbl 0470 `"Aurora, IL"', add
label define citylbl 0490 `"Austin, TX"', add
label define citylbl 0491 `"Austin, MN"', add
label define citylbl 0510 `"Bakersfield, CA"', add
label define citylbl 0530 `"Baltimore, MD"', add
label define citylbl 0550 `"Bangor, ME"', add
label define citylbl 0551 `"Barberton, OH"', add
label define citylbl 0552 `"Barre, VT"', add
label define citylbl 0553 `"Bartlesville, OK"', add
label define citylbl 0554 `"Batavia, NY"', add
label define citylbl 0570 `"Bath, ME"', add
label define citylbl 0590 `"Baton Rouge, LA"', add
label define citylbl 0610 `"Battle Creek, MI"', add
label define citylbl 0630 `"Bay City, MI"', add
label define citylbl 0640 `"Bayamon, PR"', add
label define citylbl 0650 `"Bayonne, NJ"', add
label define citylbl 0651 `"Beacon, NY"', add
label define citylbl 0652 `"Beatrice, NE"', add
label define citylbl 0660 `"Belleville, IL"', add
label define citylbl 0670 `"Beaumont, TX"', add
label define citylbl 0671 `"Beaver Falls, PA"', add
label define citylbl 0672 `"Bedford, IN"', add
label define citylbl 0673 `"Bellaire, OH"', add
label define citylbl 0680 `"Bellevue, WA"', add
label define citylbl 0690 `"Bellingham, WA"', add
label define citylbl 0700 `"Belleville, NJ"', add
label define citylbl 0701 `"Bellevue, PA"', add
label define citylbl 0702 `"Belmont, OH"', add
label define citylbl 0703 `"Belmont, MA"', add
label define citylbl 0704 `"Beloit, WI"', add
label define citylbl 0705 `"Bennington, VT"', add
label define citylbl 0706 `"Benton Harbor, MI"', add
label define citylbl 0710 `"Berkeley, CA"', add
label define citylbl 0711 `"Berlin, NH"', add
label define citylbl 0712 `"Berwick, PA"', add
label define citylbl 0720 `"Berwyn, IL"', add
label define citylbl 0721 `"Bessemer, AL"', add
label define citylbl 0730 `"Bethlehem, PA"', add
label define citylbl 0740 `"Biddeford, ME"', add
label define citylbl 0741 `"Big Spring, TX"', add
label define citylbl 0742 `"Billings, MT"', add
label define citylbl 0743 `"Biloxi, MS"', add
label define citylbl 0750 `"Binghamton, NY"', add
label define citylbl 0760 `"Beverly, MA"', add
label define citylbl 0761 `"Beverly Hills, CA"', add
label define citylbl 0770 `"Birmingham, AL"', add
label define citylbl 0771 `"Birmingham, CT"', add
label define citylbl 0772 `"Bismarck, ND"', add
label define citylbl 0780 `"Bloomfield, NJ"', add
label define citylbl 0790 `"Bloomington, IL"', add
label define citylbl 0791 `"Bloomington, IN"', add
label define citylbl 0792 `"Blue Island, IL"', add
label define citylbl 0793 `"Bluefield, WV"', add
label define citylbl 0794 `"Blytheville, AR"', add
label define citylbl 0795 `"Bogalusa, LA"', add
label define citylbl 0800 `"Boise, ID"', add
label define citylbl 0801 `"Boone, IA"', add
label define citylbl 0810 `"Boston, MA"', add
label define citylbl 0811 `"Boulder, CO"', add
label define citylbl 0812 `"Bowling Green, KY"', add
label define citylbl 0813 `"Braddock, PA"', add
label define citylbl 0814 `"Braden, WA"', add
label define citylbl 0815 `"Bradford, PA"', add
label define citylbl 0816 `"Brainerd, MN"', add
label define citylbl 0817 `"Braintree, MA"', add
label define citylbl 0818 `"Brawley, CA"', add
label define citylbl 0819 `"Bremerton, WA"', add
label define citylbl 0830 `"Bridgeport, CT"', add
label define citylbl 0831 `"Bridgeton, NJ"', add
label define citylbl 0832 `"Bristol, CT"', add
label define citylbl 0833 `"Bristol, PA"', add
label define citylbl 0834 `"Bristol, VA"', add
label define citylbl 0835 `"Bristol, TN"', add
label define citylbl 0837 `"Bristol, RI"', add
label define citylbl 0850 `"Brockton, MA"', add
label define citylbl 0851 `"Brookfield, IL"', add
label define citylbl 0870 `"Brookline, MA"', add
label define citylbl 0880 `"Brownsville, TX"', add
label define citylbl 0881 `"Brownwood, TX"', add
label define citylbl 0882 `"Brunswick, GA"', add
label define citylbl 0883 `"Bucyrus, OH"', add
label define citylbl 0890 `"Buffalo, NY"', add
label define citylbl 0900 `"Burlington, IA"', add
label define citylbl 0905 `"Burlington, VT"', add
label define citylbl 0906 `"Burlington, NJ"', add
label define citylbl 0907 `"Bushkill, PA"', add
label define citylbl 0910 `"Butte, MT"', add
label define citylbl 0911 `"Butler, PA"', add
label define citylbl 0920 `"Burbank, CA"', add
label define citylbl 0921 `"Burlingame, CA"', add
label define citylbl 0926 `"Cairo, IL"', add
label define citylbl 0927 `"Calumet City, IL"', add
label define citylbl 0930 `"Cambridge, MA"', add
label define citylbl 0931 `"Cambridge, OH"', add
label define citylbl 0950 `"Camden, NJ"', add
label define citylbl 0951 `"Campbell, OH"', add
label define citylbl 0952 `"Canonsburg, PA"', add
label define citylbl 0970 `"Camden, NY"', add
label define citylbl 0990 `"Canton, OH"', add
label define citylbl 0991 `"Canton, IL"', add
label define citylbl 0992 `"Cape Girardeau, MO"', add
label define citylbl 0993 `"Carbondale, PA"', add
label define citylbl 0994 `"Carlisle, PA"', add
label define citylbl 0995 `"Carnegie, PA"', add
label define citylbl 0996 `"Carrick, PA"', add
label define citylbl 0997 `"Carteret, NJ"', add
label define citylbl 0998 `"Carthage, MO"', add
label define citylbl 0999 `"Casper, WY"', add
label define citylbl 1000 `"Cape Coral, FL"', add
label define citylbl 1010 `"Cedar Rapids, IA"', add
label define citylbl 1020 `"Central Falls, RI"', add
label define citylbl 1021 `"Centralia, IL"', add
label define citylbl 1023 `"Chambersburg, PA"', add
label define citylbl 1024 `"Champaign, IL"', add
label define citylbl 1025 `"Chanute, KS"', add
label define citylbl 1026 `"Charleroi, PA"', add
label define citylbl 1030 `"Charlestown, MA"', add
label define citylbl 1050 `"Charleston, SC"', add
label define citylbl 1060 `"Carolina, PR"', add
label define citylbl 1070 `"Charleston, WV"', add
label define citylbl 1090 `"Charlotte, NC"', add
label define citylbl 1091 `"Charlottesville, VA"', add
label define citylbl 1110 `"Chattanooga, TN"', add
label define citylbl 1130 `"Chelsea, MA"', add
label define citylbl 1150 `"Chesapeake, VA"', add
label define citylbl 1170 `"Chester, PA"', add
label define citylbl 1171 `"Cheyenne, WY"', add
label define citylbl 1190 `"Chicago, IL"', add
label define citylbl 1191 `"Chicago Heights, IL"', add
label define citylbl 1192 `"Chickasha, OK"', add
label define citylbl 1210 `"Chicopee, MA"', add
label define citylbl 1230 `"Chillicothe, OH"', add
label define citylbl 1250 `"Chula Vista, CA"', add
label define citylbl 1270 `"Cicero, IL"', add
label define citylbl 1290 `"Cincinnati, OH"', add
label define citylbl 1291 `"Clairton, PA"', add
label define citylbl 1292 `"Claremont, NH"', add
label define citylbl 1310 `"Clarksburg, WV"', add
label define citylbl 1311 `"Clarksdale, MS"', add
label define citylbl 1312 `"Cleburne, TX"', add
label define citylbl 1330 `"Cleveland, OH"', add
label define citylbl 1340 `"Cleveland Heights, OH"', add
label define citylbl 1341 `"Cliffside Park, NJ"', add
label define citylbl 1350 `"Clifton, NJ"', add
label define citylbl 1351 `"Clinton, IN"', add
label define citylbl 1370 `"Clinton, IA"', add
label define citylbl 1371 `"Clinton, MA"', add
label define citylbl 1372 `"Coatesville, PA"', add
label define citylbl 1373 `"Coffeyville, KS"', add
label define citylbl 1374 `"Cohoes, NY"', add
label define citylbl 1375 `"Collingswood, NJ"', add
label define citylbl 1390 `"Colorado Springs, CO"', add
label define citylbl 1400 `"Cohoes, NY"', add
label define citylbl 1410 `"Columbia, SC"', add
label define citylbl 1411 `"Columbia, PA"', add
label define citylbl 1412 `"Columbia, MO"', add
label define citylbl 1420 `"Columbia City, IN"', add
label define citylbl 1430 `"Columbus, GA"', add
label define citylbl 1450 `"Columbus, OH"', add
label define citylbl 1451 `"Columbus, MS"', add
label define citylbl 1452 `"Compton, CA"', add
label define citylbl 1470 `"Concord, CA"', add
label define citylbl 1490 `"Concord, NH"', add
label define citylbl 1491 `"Concord, NC"', add
label define citylbl 1492 `"Connellsville, PA"', add
label define citylbl 1493 `"Connersville, IN"', add
label define citylbl 1494 `"Conshohocken, PA"', add
label define citylbl 1495 `"Coraopolis, PA"', add
label define citylbl 1496 `"Corning, NY"', add
label define citylbl 1500 `"Corona, CA"', add
label define citylbl 1510 `"Council Bluffs, IA"', add
label define citylbl 1520 `"Corpus Christi, TX"', add
label define citylbl 1521 `"Corsicana, TX"', add
label define citylbl 1522 `"Cortland, NY"', add
label define citylbl 1523 `"Coshocton, OH"', add
label define citylbl 1530 `"Covington, KY"', add
label define citylbl 1540 `"Costa Mesa, CA"', add
label define citylbl 1550 `"Cranston, RI"', add
label define citylbl 1551 `"Crawfordsville, IN"', add
label define citylbl 1552 `"Cripple Creek, CO"', add
label define citylbl 1553 `"Cudahy, WI"', add
label define citylbl 1570 `"Cumberland, MD"', add
label define citylbl 1571 `"Cumberland, RI"', add
label define citylbl 1572 `"Cuyahoga Falls, OH"', add
label define citylbl 1590 `"Dallas, TX"', add
label define citylbl 1591 `"Danbury, CT"', add
label define citylbl 1610 `"Danvers, MA"', add
label define citylbl 1630 `"Danville, IL"', add
label define citylbl 1631 `"Danville, VA"', add
label define citylbl 1650 `"Davenport, IA"', add
label define citylbl 1670 `"Dayton, OH"', add
label define citylbl 1671 `"Daytona Beach, FL"', add
label define citylbl 1680 `"Dearborn, MI"', add
label define citylbl 1690 `"Decatur, IL"', add
label define citylbl 1691 `"Decatur, AL"', add
label define citylbl 1692 `"Decatur, GA"', add
label define citylbl 1693 `"Dedham, MA"', add
label define citylbl 1694 `"Del Rio, TX"', add
label define citylbl 1695 `"Denison, TX"', add
label define citylbl 1710 `"Denver, CO"', add
label define citylbl 1711 `"Derby, CT"', add
label define citylbl 1713 `"Derry, PA"', add
label define citylbl 1730 `"Des Moines, IA"', add
label define citylbl 1750 `"Detroit, MI"', add
label define citylbl 1751 `"Dickson City, PA"', add
label define citylbl 1752 `"Dodge, KS"', add
label define citylbl 1753 `"Donora, PA"', add
label define citylbl 1754 `"Dormont, PA"', add
label define citylbl 1755 `"Dothan, AL"', add
label define citylbl 1770 `"Dorchester, MA"', add
label define citylbl 1790 `"Dover, NH"', add
label define citylbl 1791 `"Dover, NJ"', add
label define citylbl 1792 `"Du Bois, PA"', add
label define citylbl 1800 `"Downey, CA"', add
label define citylbl 1810 `"Dubuque, IA"', add
label define citylbl 1830 `"Duluth, MN"', add
label define citylbl 1831 `"Dunkirk, NY"', add
label define citylbl 1832 `"Dunmore, PA"', add
label define citylbl 1833 `"Duquesne, PA"', add
label define citylbl 1850 `"Durham, NC"', add
label define citylbl 1870 `"East Chicago, IN"', add
label define citylbl 1890 `"East Cleveland, OH"', add
label define citylbl 1891 `"East Hartford, CT"', add
label define citylbl 1892 `"East Liverpool, OH"', add
label define citylbl 1893 `"East Moline, IL"', add
label define citylbl 1910 `"East Los Angeles, CA"', add
label define citylbl 1930 `"East Orange, NJ"', add
label define citylbl 1931 `"East Providence, RI"', add
label define citylbl 1940 `"East Saginaw, MI"', add
label define citylbl 1950 `"East St. Louis, IL"', add
label define citylbl 1951 `"East Youngstown, OH"', add
label define citylbl 1952 `"Easthampton, MA"', add
label define citylbl 1970 `"Easton, PA"', add
label define citylbl 1971 `"Eau Claire, WI"', add
label define citylbl 1972 `"Ecorse, MI"', add
label define citylbl 1973 `"El Dorado, KS"', add
label define citylbl 1974 `"El Dorado, AR"', add
label define citylbl 1990 `"El Monte, CA"', add
label define citylbl 2010 `"El Paso, TX"', add
label define citylbl 2030 `"Elgin, IL"', add
label define citylbl 2040 `"Elyria, OH"', add
label define citylbl 2050 `"Elizabeth, NJ"', add
label define citylbl 2051 `"Elizabeth City, NC"', add
label define citylbl 2060 `"Elkhart, IN"', add
label define citylbl 2061 `"Ellwood City, PA"', add
label define citylbl 2062 `"Elmhurst, IL"', add
label define citylbl 2070 `"Elmira, NY"', add
label define citylbl 2071 `"Elmwood Park, IL"', add
label define citylbl 2072 `"Elwood, IN"', add
label define citylbl 2073 `"Emporia, KS"', add
label define citylbl 2074 `"Endicott, NY"', add
label define citylbl 2075 `"Enfield, CT"', add
label define citylbl 2076 `"Englewood, NJ"', add
label define citylbl 2080 `"Enid, OK"', add
label define citylbl 2090 `"Erie, PA"', add
label define citylbl 2091 `"Escanaba, MI"', add
label define citylbl 2092 `"Euclid, OH"', add
label define citylbl 2110 `"Escondido, CA"', add
label define citylbl 2130 `"Eugene, OR"', add
label define citylbl 2131 `"Eureka, CA"', add
label define citylbl 2150 `"Evanston, IL"', add
label define citylbl 2170 `"Evansville, IN"', add
label define citylbl 2190 `"Everett, MA"', add
label define citylbl 2210 `"Everett, WA"', add
label define citylbl 2211 `"Fairfield, AL"', add
label define citylbl 2212 `"Fairfield, CT"', add
label define citylbl 2213 `"Fairhaven, MA"', add
label define citylbl 2214 `"Fairmont, WV"', add
label define citylbl 2220 `"Fargo, ND"', add
label define citylbl 2221 `"Faribault, MN"', add
label define citylbl 2222 `"Farrell, PA"', add
label define citylbl 2230 `"Fall River, MA"', add
label define citylbl 2240 `"Fayetteville, NC"', add
label define citylbl 2241 `"Ferndale, MI"', add
label define citylbl 2242 `"Findlay, OH"', add
label define citylbl 2250 `"Fitchburg, MA"', add
label define citylbl 2260 `"Fontana, CA"', add
label define citylbl 2270 `"Flint, MI"', add
label define citylbl 2271 `"Floral Park, NY"', add
label define citylbl 2273 `"Florence, AL"', add
label define citylbl 2274 `"Florence, SC"', add
label define citylbl 2275 `"Flushing, NY"', add
label define citylbl 2280 `"Fond du Lac, WI"', add
label define citylbl 2281 `"Forest Park, IL"', add
label define citylbl 2290 `"Fort Lauderdale, FL"', add
label define citylbl 2300 `"Fort Collins, CO"', add
label define citylbl 2301 `"Fort Dodge, IA"', add
label define citylbl 2302 `"Fort Madison, IA"', add
label define citylbl 2303 `"Fort Scott, KS"', add
label define citylbl 2310 `"Fort Smith, AR"', add
label define citylbl 2311 `"Fort Thomas, KY"', add
label define citylbl 2330 `"Fort Wayne, IN"', add
label define citylbl 2350 `"Fort Worth, TX"', add
label define citylbl 2351 `"Fostoria, OH"', add
label define citylbl 2352 `"Framingham, MA"', add
label define citylbl 2353 `"Frankfort, IN"', add
label define citylbl 2354 `"Frankfort, KY"', add
label define citylbl 2355 `"Franklin, PA"', add
label define citylbl 2356 `"Frederick, MD"', add
label define citylbl 2357 `"Freeport, NY"', add
label define citylbl 2358 `"Freeport, IL"', add
label define citylbl 2359 `"Fremont, OH"', add
label define citylbl 2360 `"Fremont, NE"', add
label define citylbl 2370 `"Fresno, CA"', add
label define citylbl 2390 `"Fullerton, CA"', add
label define citylbl 2391 `"Fulton, NY"', add
label define citylbl 2392 `"Gadsden, AL"', add
label define citylbl 2393 `"Galena, KS"', add
label define citylbl 2400 `"Galesburg, IL"', add
label define citylbl 2410 `"Galveston, TX"', add
label define citylbl 2411 `"Gardner, MA"', add
label define citylbl 2430 `"Garden Grove, CA"', add
label define citylbl 2440 `"Garfield, NJ"', add
label define citylbl 2441 `"Garfield Heights, OH"', add
label define citylbl 2450 `"Garland, TX"', add
label define citylbl 2470 `"Gary, IN"', add
label define citylbl 2471 `"Gastonia, NC"', add
label define citylbl 2472 `"Geneva, NY"', add
label define citylbl 2473 `"Glen Cove, NY"', add
label define citylbl 2490 `"Glendale, CA"', add
label define citylbl 2491 `"Glens Falls, NY"', add
label define citylbl 2510 `"Gloucester, MA"', add
label define citylbl 2511 `"Gloucester, NJ"', add
label define citylbl 2512 `"Gloversville, NY"', add
label define citylbl 2513 `"Goldsboro, NC"', add
label define citylbl 2514 `"Goshen, IN"', add
label define citylbl 2515 `"Grand Forks, ND"', add
label define citylbl 2516 `"Grand Island, NE"', add
label define citylbl 2517 `"Grand Junction, CO"', add
label define citylbl 2520 `"Granite City, IL"', add
label define citylbl 2530 `"Grand Rapids, MI"', add
label define citylbl 2531 `"Grandville, MI"', add
label define citylbl 2540 `"Great Falls, MT"', add
label define citylbl 2541 `"Greeley, CO"', add
label define citylbl 2550 `"Green Bay, WI"', add
label define citylbl 2551 `"Greenfield, MA"', add
label define citylbl 2570 `"Greensboro, NC"', add
label define citylbl 2571 `"Greensburg, PA"', add
label define citylbl 2572 `"Greenville, MS"', add
label define citylbl 2573 `"Greenville, SC"', add
label define citylbl 2574 `"Greenville, TX"', add
label define citylbl 2575 `"Greenwich, CT"', add
label define citylbl 2576 `"Greenwood, MS"', add
label define citylbl 2577 `"Greenwood, SC"', add
label define citylbl 2578 `"Griffin, GA"', add
label define citylbl 2579 `"Grosse Pointe Park, MI"', add
label define citylbl 2580 `"Guynabo, PR"', add
label define citylbl 2581 `"Groton, CT"', add
label define citylbl 2582 `"Gulfport, MS"', add
label define citylbl 2583 `"Guthrie, OK"', add
label define citylbl 2584 `"Hackensack, NJ"', add
label define citylbl 2590 `"Hagerstown, MD"', add
label define citylbl 2591 `"Hamden, CT"', add
label define citylbl 2610 `"Hamilton, OH"', add
label define citylbl 2630 `"Hammond, IN"', add
label define citylbl 2650 `"Hampton, VA"', add
label define citylbl 2670 `"Hamtramck Village, MI"', add
label define citylbl 2680 `"Hannibal, MO"', add
label define citylbl 2681 `"Hanover, PA"', add
label define citylbl 2682 `"Harlingen, TX"', add
label define citylbl 2690 `"Harrisburg, PA"', add
label define citylbl 2691 `"Harrisburg, IL"', add
label define citylbl 2692 `"Harrison, NJ"', add
label define citylbl 2710 `"Hartford, CT"', add
label define citylbl 2711 `"Harvey, IL"', add
label define citylbl 2712 `"Hastings, NE"', add
label define citylbl 2713 `"Hattiesburg, MS"', add
label define citylbl 2730 `"Haverhill, MA"', add
label define citylbl 2731 `"Hawthorne, NJ"', add
label define citylbl 2750 `"Hazleton, PA"', add
label define citylbl 2751 `"Helena, MT"', add
label define citylbl 2752 `"Hempstead, NY"', add
label define citylbl 2753 `"Henderson, KY"', add
label define citylbl 2754 `"Herkimer, NY"', add
label define citylbl 2755 `"Herrin, IL"', add
label define citylbl 2756 `"Hibbing, MN"', add
label define citylbl 2770 `"Hialeah, FL"', add
label define citylbl 2780 `"High Point, NC"', add
label define citylbl 2781 `"Highland Park, IL"', add
label define citylbl 2790 `"Highland Park, MI"', add
label define citylbl 2791 `"Hilo, HI"', add
label define citylbl 2810 `"Hoboken, NJ"', add
label define citylbl 2811 `"Holland, MI"', add
label define citylbl 2830 `"Hollywood, FL"', add
label define citylbl 2850 `"Holyoke, MA"', add
label define citylbl 2851 `"Homestead, PA"', add
label define citylbl 2870 `"Honolulu, HI"', add
label define citylbl 2871 `"Hopewell, VA"', add
label define citylbl 2872 `"Hopkinsville, KY"', add
label define citylbl 2873 `"Hoquiam, WA"', add
label define citylbl 2874 `"Hornell, NY"', add
label define citylbl 2875 `"Hot Springs, AR"', add
label define citylbl 2890 `"Houston, TX"', add
label define citylbl 2891 `"Hudson, NY"', add
label define citylbl 2892 `"Huntington, IN"', add
label define citylbl 2910 `"Huntington, WV"', add
label define citylbl 2930 `"Huntington Beach, CA"', add
label define citylbl 2950 `"Huntsville, AL"', add
label define citylbl 2951 `"Huron, SD"', add
label define citylbl 2960 `"Hutchinson, KS"', add
label define citylbl 2961 `"Hyde Park, MA"', add
label define citylbl 2962 `"Ilion, NY"', add
label define citylbl 2963 `"Independence, KS"', add
label define citylbl 2970 `"Independence, MO"', add
label define citylbl 2990 `"Indianapolis, IN"', add
label define citylbl 3010 `"Inglewood, CA"', add
label define citylbl 3011 `"Iowa City, IA"', add
label define citylbl 3012 `"Iron Mountain, MI"', add
label define citylbl 3013 `"Ironton, OH"', add
label define citylbl 3014 `"Ironwood, MI"', add
label define citylbl 3020 `"Irvine, CA"', add
label define citylbl 3030 `"Irving, TX"', add
label define citylbl 3050 `"Irvington, NJ"', add
label define citylbl 3051 `"Ishpeming, MI"', add
label define citylbl 3052 `"Ithaca, NY"', add
label define citylbl 3070 `"Jackson, MI"', add
label define citylbl 3071 `"Jackson, MN"', add
label define citylbl 3090 `"Jackson, MS"', add
label define citylbl 3091 `"Jackson, TN"', add
label define citylbl 3110 `"Jacksonville, FL"', add
label define citylbl 3111 `"Jacksonville, IL"', add
label define citylbl 3130 `"Jamestown , NY"', add
label define citylbl 3131 `"Janesville, WI"', add
label define citylbl 3132 `"Jeannette, PA"', add
label define citylbl 3133 `"Jefferson City, MO"', add
label define citylbl 3134 `"Jeffersonville, IN"', add
label define citylbl 3150 `"Jersey City, NJ"', add
label define citylbl 3151 `"Johnson City, NY"', add
label define citylbl 3160 `"Johnson City, TN"', add
label define citylbl 3161 `"Johnstown, NY"', add
label define citylbl 3170 `"Johnstown, PA"', add
label define citylbl 3190 `"Joliet, IL"', add
label define citylbl 3191 `"Jonesboro, AR"', add
label define citylbl 3210 `"Joplin, MO"', add
label define citylbl 3230 `"Kalamazoo, MI"', add
label define citylbl 3231 `"Kankakee, IL"', add
label define citylbl 3250 `"Kansas City, KS"', add
label define citylbl 3260 `"Kansas City, MO"', add
label define citylbl 3270 `"Kearny, NJ"', add
label define citylbl 3271 `"Keene, NH"', add
label define citylbl 3272 `"Kenmore, NY"', add
label define citylbl 3273 `"Kenmore, OH"', add
label define citylbl 3290 `"Kenosha, WI"', add
label define citylbl 3291 `"Keokuk, IA"', add
label define citylbl 3292 `"Kewanee, IL"', add
label define citylbl 3293 `"Key West, FL"', add
label define citylbl 3294 `"Kingsport, TN"', add
label define citylbl 3310 `"Kingston, NY"', add
label define citylbl 3311 `"Kingston, PA"', add
label define citylbl 3312 `"Kinston, NC"', add
label define citylbl 3313 `"Klamath Falls, OR"', add
label define citylbl 3330 `"Knoxville, TN"', add
label define citylbl 3350 `"Kokomo, IN"', add
label define citylbl 3370 `"La Crosse, WI"', add
label define citylbl 3380 `"Lafayette, IL"', add
label define citylbl 3390 `"Lafayette, LA"', add
label define citylbl 3391 `"La Grange, IL"', add
label define citylbl 3392 `"La Grange, GA"', add
label define citylbl 3393 `"La Porte, IN"', add
label define citylbl 3394 `"La Salle, IL"', add
label define citylbl 3395 `"Lackawanna, NY"', add
label define citylbl 3396 `"Laconia, NH"', add
label define citylbl 3410 `"Lakewood, CO"', add
label define citylbl 3430 `"Lakewood, OH"', add
label define citylbl 3440 `"Lancaster, CA"', add
label define citylbl 3450 `"Lancaster, PA"', add
label define citylbl 3451 `"Lancaster, OH"', add
label define citylbl 3470 `"Lansing, MI"', add
label define citylbl 3471 `"Lansingburgh, NY"', add
label define citylbl 3480 `"Laredo, TX"', add
label define citylbl 3481 `"Latrobe, PA"', add
label define citylbl 3482 `"Laurel, MS"', add
label define citylbl 3490 `"Las Vegas, NV"', add
label define citylbl 3510 `"Lawrence, MA"', add
label define citylbl 3511 `"Lawrence, KS"', add
label define citylbl 3512 `"Lawton, OK"', add
label define citylbl 3513 `"Leadville, CO"', add
label define citylbl 3520 `"Leavenworth, KS"', add
label define citylbl 3521 `"Lebanon, PA"', add
label define citylbl 3522 `"Leominster, MA"', add
label define citylbl 3530 `"Lehigh, PA"', add
label define citylbl 3540 `"Lebanon, PA"', add
label define citylbl 3550 `"Lewiston, ME"', add
label define citylbl 3551 `"Lewistown, PA"', add
label define citylbl 3570 `"Lexington, KY"', add
label define citylbl 3590 `"Lexington-Fayette, KY"', add
label define citylbl 3610 `"Lima, OH"', add
label define citylbl 3630 `"Lincoln, NE"', add
label define citylbl 3631 `"Lincoln, IL"', add
label define citylbl 3632 `"Lincoln Park, MI"', add
label define citylbl 3633 `"Lincoln, RI"', add
label define citylbl 3634 `"Linden, NJ"', add
label define citylbl 3635 `"Little Falls, NY"', add
label define citylbl 3638 `"Lodi, NJ"', add
label define citylbl 3639 `"Logansport, IN"', add
label define citylbl 3650 `"Little Rock, AR"', add
label define citylbl 3670 `"Livonia, MI"', add
label define citylbl 3680 `"Lockport, NY"', add
label define citylbl 3690 `"Long Beach, CA"', add
label define citylbl 3691 `"Long Branch, NJ"', add
label define citylbl 3692 `"Long Island City, NY"', add
label define citylbl 3693 `"Longview, WA"', add
label define citylbl 3710 `"Lorain, OH"', add
label define citylbl 3730 `"Los Angeles, CA"', add
label define citylbl 3750 `"Louisville, KY"', add
label define citylbl 3770 `"Lowell, MA"', add
label define citylbl 3771 `"Lubbock, TX"', add
label define citylbl 3772 `"Lynbrook, NY"', add
label define citylbl 3790 `"Lynchburg, VA"', add
label define citylbl 3810 `"Lynn, MA"', add
label define citylbl 3830 `"Macon, GA"', add
label define citylbl 3850 `"Madison, IN"', add
label define citylbl 3870 `"Madison, WI"', add
label define citylbl 3871 `"Mahanoy City, PA"', add
label define citylbl 3890 `"Malden, MA"', add
label define citylbl 3891 `"Mamaroneck, NY"', add
label define citylbl 3910 `"Manchester, NH"', add
label define citylbl 3911 `"Manchester, CT"', add
label define citylbl 3912 `"Manhattan, KS"', add
label define citylbl 3913 `"Manistee, MI"', add
label define citylbl 3914 `"Manitowoc, WI"', add
label define citylbl 3915 `"Mankato, MN"', add
label define citylbl 3930 `"Mansfield, OH"', add
label define citylbl 3931 `"Maplewood, MO"', add
label define citylbl 3932 `"Marietta, OH"', add
label define citylbl 3933 `"Marinette, WI"', add
label define citylbl 3934 `"Marion, IN"', add
label define citylbl 3940 `"Maywood, IL"', add
label define citylbl 3950 `"Marion, OH"', add
label define citylbl 3951 `"Marlborough, MA"', add
label define citylbl 3952 `"Marquette, MI"', add
label define citylbl 3953 `"Marshall, TX"', add
label define citylbl 3954 `"Marshalltown, IA"', add
label define citylbl 3955 `"Martins Ferry, OH"', add
label define citylbl 3956 `"Martinsburg, WV"', add
label define citylbl 3957 `"Mason City, IA"', add
label define citylbl 3958 `"Massena, NY"', add
label define citylbl 3959 `"Massillon, OH"', add
label define citylbl 3960 `"McAllen, TX"', add
label define citylbl 3961 `"Mattoon, IL"', add
label define citylbl 3962 `"Mcalester, OK"', add
label define citylbl 3963 `"Mccomb, MS"', add
label define citylbl 3964 `"Mckees Rocks, PA"', add
label define citylbl 3970 `"McKeesport, PA"', add
label define citylbl 3971 `"Meadville, PA"', add
label define citylbl 3990 `"Medford, MA"', add
label define citylbl 3991 `"Medford, OR"', add
label define citylbl 3992 `"Melrose, MA"', add
label define citylbl 3993 `"Melrose Park, IL"', add
label define citylbl 4010 `"Memphis, TN"', add
label define citylbl 4011 `"Menominee, MI"', add
label define citylbl 4030 `"Meriden, CT"', add
label define citylbl 4040 `"Meridian, MS"', add
label define citylbl 4041 `"Methuen, MA"', add
label define citylbl 4050 `"Mesa, AZ"', add
label define citylbl 4070 `"Mesquite, TX"', add
label define citylbl 4090 `"Metairie, LA"', add
label define citylbl 4110 `"Miami, FL"', add
label define citylbl 4120 `"Michigan City, IN"', add
label define citylbl 4121 `"Middlesborough, KY"', add
label define citylbl 4122 `"Middletown, CT"', add
label define citylbl 4123 `"Middletown, NY"', add
label define citylbl 4124 `"Middletown, OH"', add
label define citylbl 4125 `"Milford, CT"', add
label define citylbl 4126 `"Milford, MA"', add
label define citylbl 4127 `"Millville, NJ"', add
label define citylbl 4128 `"Milton, MA"', add
label define citylbl 4130 `"Milwaukee, WI"', add
label define citylbl 4150 `"Minneapolis, MN"', add
label define citylbl 4151 `"Minot, ND"', add
label define citylbl 4160 `"Mishawaka, IN"', add
label define citylbl 4161 `"Missoula, MT"', add
label define citylbl 4162 `"Mitchell, SD"', add
label define citylbl 4163 `"Moberly, MO"', add
label define citylbl 4170 `"Mobile, AL"', add
label define citylbl 4190 `"Modesto, CA"', add
label define citylbl 4210 `"Moline, IL"', add
label define citylbl 4211 `"Monessen, PA"', add
label define citylbl 4212 `"Monroe, MI"', add
label define citylbl 4213 `"Monroe, LA"', add
label define citylbl 4214 `"Monrovia, CA"', add
label define citylbl 4230 `"Montclair, NJ"', add
label define citylbl 4250 `"Montgomery, AL"', add
label define citylbl 4251 `"Morgantown, WV"', add
label define citylbl 4252 `"Morristown, NJ"', add
label define citylbl 4253 `"Moundsville, WV"', add
label define citylbl 4254 `"Mount Arlington, NJ"', add
label define citylbl 4255 `"Mount Carmel, PA"', add
label define citylbl 4256 `"Mount Clemens, MI"', add
label define citylbl 4270 `"Moreno Valley, CA"', add
label define citylbl 4290 `"Mount Vernon, NY"', add
label define citylbl 4291 `"Mount Vernon, IL"', add
label define citylbl 4310 `"Muncie, IN"', add
label define citylbl 4311 `"Munhall, PA"', add
label define citylbl 4312 `"Murphysboro, IL"', add
label define citylbl 4313 `"Muscatine, IA"', add
label define citylbl 4330 `"Muskegon, MI"', add
label define citylbl 4331 `"Muskegon Heights, MI"', add
label define citylbl 4350 `"Muskogee, OK"', add
label define citylbl 4351 `"Nanticoke, PA"', add
label define citylbl 4370 `"Nantucket, MA"', add
label define citylbl 4390 `"Nashua, NH"', add
label define citylbl 4410 `"Nashville-Davidson, TN"', add
label define citylbl 4411 `"Nashville, TN"', add
label define citylbl 4413 `"Natchez, MS"', add
label define citylbl 4414 `"Natick, MA"', add
label define citylbl 4415 `"Naugatuck, CT"', add
label define citylbl 4416 `"Needham, MA"', add
label define citylbl 4430 `"New Albany, IN"', add
label define citylbl 4450 `"New Bedford, MA"', add
label define citylbl 4451 `"New Bern, NC"', add
label define citylbl 4452 `"New Brighton, NY"', add
label define citylbl 4470 `"New Britain, CT"', add
label define citylbl 4490 `"New Brunswick, NJ"', add
label define citylbl 4510 `"New Castle, PA"', add
label define citylbl 4511 `"New Castle, IN"', add
label define citylbl 4530 `"New Haven, CT"', add
label define citylbl 4550 `"New London, CT"', add
label define citylbl 4570 `"New Orleans, LA"', add
label define citylbl 4571 `"New Philadelphia, OH"', add
label define citylbl 4590 `"New Rochelle, NY"', add
label define citylbl 4610 `"New York, NY"', add
label define citylbl 4611 `"Brooklyn (only in census years before 1900)"', add
label define citylbl 4630 `"Newark, NJ"', add
label define citylbl 4650 `"Newark, OH"', add
label define citylbl 4670 `"Newburgh, NY"', add
label define citylbl 4690 `"Newburyport, MA"', add
label define citylbl 4710 `"Newport, KY"', add
label define citylbl 4730 `"Newport, RI"', add
label define citylbl 4750 `"Newport News, VA"', add
label define citylbl 4770 `"Newton, MA"', add
label define citylbl 4771 `"Newton, IA"', add
label define citylbl 4772 `"Newton, KS"', add
label define citylbl 4790 `"Niagara Falls, NY"', add
label define citylbl 4791 `"Niles, MI"', add
label define citylbl 4792 `"Niles, OH"', add
label define citylbl 4810 `"Norfolk, VA"', add
label define citylbl 4811 `"Norfolk, NE"', add
label define citylbl 4820 `"North Las Vegas, NV"', add
label define citylbl 4830 `"Norristown Borough, PA"', add
label define citylbl 4831 `"North Adams, MA"', add
label define citylbl 4832 `"North Attleborough, MA"', add
label define citylbl 4833 `"North Bennington, VT"', add
label define citylbl 4834 `"North Braddock, PA"', add
label define citylbl 4835 `"North Branford, CT"', add
label define citylbl 4836 `"North Haven, CT"', add
label define citylbl 4837 `"North Little Rock, AR"', add
label define citylbl 4838 `"North Platte, NE"', add
label define citylbl 4839 `"North Providence, RI"', add
label define citylbl 4840 `"Northampton, MA"', add
label define citylbl 4841 `"North Tonawanda, NY"', add
label define citylbl 4842 `"North Yakima, WA"', add
label define citylbl 4843 `"Northbridge, MA"', add
label define citylbl 4850 `"North Providence, RI"', add
label define citylbl 4860 `"Norwalk, CA"', add
label define citylbl 4870 `"Norwalk, CT"', add
label define citylbl 4890 `"Norwich, CT"', add
label define citylbl 4900 `"Norwood, OH"', add
label define citylbl 4901 `"Norwood, MA"', add
label define citylbl 4902 `"Nutley, NJ"', add
label define citylbl 4910 `"Oak Park Village"', add
label define citylbl 4930 `"Oakland, CA"', add
label define citylbl 4950 `"Oceanside, CA"', add
label define citylbl 4970 `"Ogden, UT"', add
label define citylbl 4971 `"Ogdensburg, NY"', add
label define citylbl 4972 `"Oil City, PA"', add
label define citylbl 4990 `"Oklahoma City, OK"', add
label define citylbl 4991 `"Okmulgee, OK"', add
label define citylbl 4992 `"Old Bennington, VT"', add
label define citylbl 4993 `"Old Forge, PA"', add
label define citylbl 4994 `"Olean, NY"', add
label define citylbl 4995 `"Olympia, WA"', add
label define citylbl 4996 `"Olyphant, PA"', add
label define citylbl 5010 `"Omaha, NE"', add
label define citylbl 5011 `"Oneida, NY"', add
label define citylbl 5012 `"Oneonta, NY"', add
label define citylbl 5030 `"Ontario, CA"', add
label define citylbl 5040 `"Orange, CA"', add
label define citylbl 5050 `"Orange, NJ"', add
label define citylbl 5051 `"Orange, CT"', add
label define citylbl 5070 `"Orlando, FL"', add
label define citylbl 5090 `"Oshkosh, WI"', add
label define citylbl 5091 `"Oskaloosa, IA"', add
label define citylbl 5092 `"Ossining, NY"', add
label define citylbl 5110 `"Oswego, NY"', add
label define citylbl 5111 `"Ottawa, IL"', add
label define citylbl 5112 `"Ottumwa, IA"', add
label define citylbl 5113 `"Owensboro, KY"', add
label define citylbl 5114 `"Owosso, MI"', add
label define citylbl 5116 `"Painesville, OH"', add
label define citylbl 5117 `"Palestine, TX"', add
label define citylbl 5118 `"Palo Alto, CA"', add
label define citylbl 5119 `"Pampa, TX"', add
label define citylbl 5121 `"Paris, TX"', add
label define citylbl 5122 `"Park Ridge, IL"', add
label define citylbl 5123 `"Parkersburg, WV"', add
label define citylbl 5124 `"Parma, OH"', add
label define citylbl 5125 `"Parsons, KS"', add
label define citylbl 5130 `"Oxnard, CA"', add
label define citylbl 5140 `"Palmdale, CA"', add
label define citylbl 5150 `"Pasadena, CA"', add
label define citylbl 5170 `"Pasadena, TX"', add
label define citylbl 5180 `"Paducah, KY"', add
label define citylbl 5190 `"Passaic, NJ"', add
label define citylbl 5210 `"Paterson, NJ"', add
label define citylbl 5230 `"Pawtucket, RI"', add
label define citylbl 5231 `"Peabody, MA"', add
label define citylbl 5232 `"Peekskill, NY"', add
label define citylbl 5233 `"Pekin, IL"', add
label define citylbl 5250 `"Pensacola, FL"', add
label define citylbl 5270 `"Peoria, IL"', add
label define citylbl 5271 `"Peoria Heights, IL"', add
label define citylbl 5290 `"Perth Amboy, NJ"', add
label define citylbl 5291 `"Peru, IN"', add
label define citylbl 5310 `"Petersburg, VA"', add
label define citylbl 5311 `"Phenix City, AL"', add
label define citylbl 5330 `"Philadelphia, PA"', add
label define citylbl 5331 `"Kensington"', add
label define citylbl 5332 `"Mayamensing"', add
label define citylbl 5333 `"Northern Liberties"', add
label define citylbl 5334 `"Southwark"', add
label define citylbl 5335 `"Spring Garden"', add
label define citylbl 5341 `"Phillipsburg, NJ"', add
label define citylbl 5350 `"Phoenix, AZ"', add
label define citylbl 5351 `"Phoenixville, PA"', add
label define citylbl 5352 `"Pine Bluff, AR"', add
label define citylbl 5353 `"Piqua, OH"', add
label define citylbl 5354 `"Pittsburg, KS"', add
label define citylbl 5370 `"Pittsburgh, PA"', add
label define citylbl 5390 `"Pittsfield, MA"', add
label define citylbl 5391 `"Pittston, PA"', add
label define citylbl 5410 `"Plainfield, NJ"', add
label define citylbl 5411 `"Plattsburg, NY"', add
label define citylbl 5412 `"Pleasantville, NJ"', add
label define citylbl 5413 `"Plymouth, PA"', add
label define citylbl 5414 `"Plymouth, MA"', add
label define citylbl 5415 `"Pocatello, ID"', add
label define citylbl 5430 `"Plano, TX"', add
label define citylbl 5450 `"Pomona, CA"', add
label define citylbl 5451 `"Ponca City, OK"', add
label define citylbl 5460 `"Ponce, PR"', add
label define citylbl 5470 `"Pontiac, MI"', add
label define citylbl 5471 `"Port Angeles, WA"', add
label define citylbl 5480 `"Port Arthur, TX"', add
label define citylbl 5481 `"Port Chester, NY"', add
label define citylbl 5490 `"Port Huron, MI"', add
label define citylbl 5491 `"Port Jervis, NY"', add
label define citylbl 5510 `"Portland, ME"', add
label define citylbl 5511 `"Portland, IL"', add
label define citylbl 5530 `"Portland, OR"', add
label define citylbl 5550 `"Portsmouth, NH"', add
label define citylbl 5570 `"Portsmouth, OH"', add
label define citylbl 5590 `"Portsmouth, VA"', add
label define citylbl 5591 `"Pottstown, PA"', add
label define citylbl 5610 `"Pottsville, PA"', add
label define citylbl 5630 `"Poughkeepsie, NY"', add
label define citylbl 5650 `"Providence, RI"', add
label define citylbl 5660 `"Provo, UT"', add
label define citylbl 5670 `"Pueblo, CO"', add
label define citylbl 5671 `"Punxsutawney, PA"', add
label define citylbl 5690 `"Quincy, IL"', add
label define citylbl 5710 `"Quincy, MA"', add
label define citylbl 5730 `"Racine, WI"', add
label define citylbl 5731 `"Rahway, NJ"', add
label define citylbl 5750 `"Raleigh, NC"', add
label define citylbl 5751 `"Ranger, TX"', add
label define citylbl 5752 `"Rapid City, SD"', add
label define citylbl 5770 `"Rancho Cucamonga, CA"', add
label define citylbl 5790 `"Reading, PA"', add
label define citylbl 5791 `"Red Bank, NJ"', add
label define citylbl 5792 `"Redlands, CA"', add
label define citylbl 5810 `"Reno, NV"', add
label define citylbl 5811 `"Rensselaer, NY"', add
label define citylbl 5830 `"Revere, MA"', add
label define citylbl 5850 `"Richmond, IN"', add
label define citylbl 5870 `"Richmond, VA"', add
label define citylbl 5871 `"Richmond, CA"', add
label define citylbl 5872 `"Ridgefield Park, NJ"', add
label define citylbl 5873 `"Ridgewood, NJ"', add
label define citylbl 5874 `"River Rouge, MI"', add
label define citylbl 5890 `"Riverside, CA"', add
label define citylbl 5910 `"Roanoke, VA"', add
label define citylbl 5930 `"Rochester, NY"', add
label define citylbl 5931 `"Rochester, NH"', add
label define citylbl 5932 `"Rochester, MN"', add
label define citylbl 5933 `"Rock Hill, SC"', add
label define citylbl 5950 `"Rock Island, IL"', add
label define citylbl 5970 `"Rockford, IL"', add
label define citylbl 5971 `"Rockland, ME"', add
label define citylbl 5972 `"Rockton, IL"', add
label define citylbl 5973 `"Rockville Centre, NY"', add
label define citylbl 5974 `"Rocky Mount, NC"', add
label define citylbl 5990 `"Rome, NY"', add
label define citylbl 5991 `"Rome, GA"', add
label define citylbl 5992 `"Roosevelt, NJ"', add
label define citylbl 5993 `"Roselle, NJ"', add
label define citylbl 5994 `"Roswell, NM"', add
label define citylbl 6010 `"Roxbury, MA"', add
label define citylbl 6011 `"Royal Oak, MI"', add
label define citylbl 6012 `"Rumford Falls, ME"', add
label define citylbl 6013 `"Rutherford, NJ"', add
label define citylbl 6014 `"Rutland, VT"', add
label define citylbl 6030 `"Sacramento, CA"', add
label define citylbl 6050 `"Saginaw, MI"', add
label define citylbl 6070 `"Saint Joseph, MO"', add
label define citylbl 6090 `"Saint Louis, MO"', add
label define citylbl 6110 `"Saint Paul, MN"', add
label define citylbl 6130 `"Saint Petersburg, FL"', add
label define citylbl 6150 `"Salem, MA"', add
label define citylbl 6170 `"Salem, OR"', add
label define citylbl 6171 `"Salem, OH"', add
label define citylbl 6172 `"Salina, KS"', add
label define citylbl 6190 `"Salinas, CA"', add
label define citylbl 6191 `"Salisbury, NC"', add
label define citylbl 6192 `"Salisbury, MD"', add
label define citylbl 6210 `"Salt Lake City, UT"', add
label define citylbl 6211 `"San Angelo, TX"', add
label define citylbl 6220 `"San Angelo, TX"', add
label define citylbl 6230 `"San Antonio, TX"', add
label define citylbl 6231 `"San Benito, TX"', add
label define citylbl 6250 `"San Bernardino, CA"', add
label define citylbl 6260 `"San Buenaventura (Ventura), CA"', add
label define citylbl 6270 `"San Diego, CA"', add
label define citylbl 6280 `"Sandusky, OH"', add
label define citylbl 6281 `"Sanford, FL"', add
label define citylbl 6282 `"Sanford, ME"', add
label define citylbl 6290 `"San Francisco, CA"', add
label define citylbl 6300 `"San Juan, PR"', add
label define citylbl 6310 `"San Jose, CA"', add
label define citylbl 6311 `"San Leandro, CA"', add
label define citylbl 6312 `"San Mateo, CA"', add
label define citylbl 6320 `"Santa Barbara, CA"', add
label define citylbl 6321 `"Santa Cruz, CA"', add
label define citylbl 6322 `"Santa Fe, NM"', add
label define citylbl 6330 `"Santa Ana, CA"', add
label define citylbl 6340 `"Santa Clarita, CA"', add
label define citylbl 6350 `"Santa Rosa, CA"', add
label define citylbl 6351 `"Sapulpa, OK"', add
label define citylbl 6352 `"Saratoga Springs, NY"', add
label define citylbl 6353 `"Saugus, MA"', add
label define citylbl 6354 `"Sault Ste. Marie, MI"', add
label define citylbl 6360 `"Santa Monica, CA"', add
label define citylbl 6370 `"Savannah, GA"', add
label define citylbl 6390 `"Schenectedy, NY"', add
label define citylbl 6410 `"Scranton, PA"', add
label define citylbl 6430 `"Seattle, WA"', add
label define citylbl 6431 `"Sedalia, MO"', add
label define citylbl 6432 `"Selma, AL"', add
label define citylbl 6433 `"Seminole, OK"', add
label define citylbl 6434 `"Shaker Heights, OH"', add
label define citylbl 6435 `"Shamokin, PA"', add
label define citylbl 6437 `"Sharpsville, PA"', add
label define citylbl 6438 `"Shawnee, OK"', add
label define citylbl 6440 `"Sharon, PA"', add
label define citylbl 6450 `"Sheboygan, WI"', add
label define citylbl 6451 `"Shelby, NC"', add
label define citylbl 6452 `"Shelbyville, IN"', add
label define citylbl 6453 `"Shelton, CT"', add
label define citylbl 6470 `"Shenandoah Borough, PA"', add
label define citylbl 6471 `"Sherman, TX"', add
label define citylbl 6472 `"Shorewood, WI"', add
label define citylbl 6490 `"Shreveport, LA"', add
label define citylbl 6500 `"Simi Valley, CA"', add
label define citylbl 6510 `"Sioux City, IA"', add
label define citylbl 6530 `"Sioux Falls, SD"', add
label define citylbl 6550 `"Smithfield, RI (1850)"', add
label define citylbl 6570 `"Somerville, MA"', add
label define citylbl 6590 `"South Bend, IN"', add
label define citylbl 6591 `"South Bethlehem, PA"', add
label define citylbl 6592 `"South Boise, ID"', add
label define citylbl 6593 `"South Gate, CA"', add
label define citylbl 6594 `"South Milwaukee, WI"', add
label define citylbl 6595 `"South Norwalk, CT"', add
label define citylbl 6610 `"South Omaha, NE"', add
label define citylbl 6611 `"South Orange, NJ"', add
label define citylbl 6612 `"South Pasadena, CA"', add
label define citylbl 6613 `"South Pittsburgh, PA"', add
label define citylbl 6614 `"South Portland, ME"', add
label define citylbl 6615 `"South River, NJ"', add
label define citylbl 6616 `"South St. Paul, MN"', add
label define citylbl 6617 `"Southbridge, MA"', add
label define citylbl 6620 `"Spartanburg, SC"', add
label define citylbl 6630 `"Spokane, WA"', add
label define citylbl 6650 `"Springfield, IL"', add
label define citylbl 6670 `"Springfield, MA"', add
label define citylbl 6690 `"Springfield, MO"', add
label define citylbl 6691 `"St. Augustine, FL"', add
label define citylbl 6692 `"St. Charles, MO"', add
label define citylbl 6693 `"St. Cloud, MN"', add
label define citylbl 6710 `"Springfield, OH"', add
label define citylbl 6730 `"Stamford, CT"', add
label define citylbl 6731 `"Statesville, NC"', add
label define citylbl 6732 `"Staunton, VA"', add
label define citylbl 6733 `"Steelton, PA"', add
label define citylbl 6734 `"Sterling, IL"', add
label define citylbl 6750 `"Sterling Heights, MI"', add
label define citylbl 6770 `"Steubenville, OH"', add
label define citylbl 6771 `"Stevens Point, WI"', add
label define citylbl 6772 `"Stillwater, MN"', add
label define citylbl 6790 `"Stockton, CA"', add
label define citylbl 6791 `"Stoneham, MA"', add
label define citylbl 6792 `"Stonington, CT"', add
label define citylbl 6793 `"Stratford, CT"', add
label define citylbl 6794 `"Streator, IL"', add
label define citylbl 6795 `"Struthers, OH"', add
label define citylbl 6796 `"Suffolk, VA"', add
label define citylbl 6797 `"Summit, NJ"', add
label define citylbl 6798 `"Sumter, SC"', add
label define citylbl 6799 `"Sunbury, PA"', add
label define citylbl 6810 `"Sunnyvale, CA"', add
label define citylbl 6830 `"Superior, WI"', add
label define citylbl 6831 `"Swampscott, MA"', add
label define citylbl 6832 `"Sweetwater, TX"', add
label define citylbl 6833 `"Swissvale, PA"', add
label define citylbl 6850 `"Syracuse, NY"', add
label define citylbl 6870 `"Tacoma, WA"', add
label define citylbl 6871 `"Tallahassee, FL"', add
label define citylbl 6872 `"Tamaqua, PA"', add
label define citylbl 6890 `"Tampa, FL"', add
label define citylbl 6910 `"Taunton, MA"', add
label define citylbl 6911 `"Taylor, PA"', add
label define citylbl 6912 `"Temple, TX"', add
label define citylbl 6930 `"Tempe, AZ"', add
label define citylbl 6950 `"Terre Haute, IN"', add
label define citylbl 6951 `"Texarkana, TX"', add
label define citylbl 6952 `"Thomasville, GA"', add
label define citylbl 6953 `"Thomasville, NC"', add
label define citylbl 6954 `"Tiffin, OH"', add
label define citylbl 6960 `"Thousand Oaks, CA"', add
label define citylbl 6970 `"Toledo, OH"', add
label define citylbl 6971 `"Tonawanda, NY"', add
label define citylbl 6990 `"Topeka, KS"', add
label define citylbl 6991 `"Torrington, CT"', add
label define citylbl 6992 `"Traverse City, MI"', add
label define citylbl 7000 `"Torrance, CA"', add
label define citylbl 7010 `"Trenton, NJ"', add
label define citylbl 7011 `"Trinidad, CO"', add
label define citylbl 7030 `"Troy, NY"', add
label define citylbl 7050 `"Tucson, AZ"', add
label define citylbl 7070 `"Tulsa, OK"', add
label define citylbl 7071 `"Turtle Creek, PA"', add
label define citylbl 7072 `"Tuscaloosa, AL"', add
label define citylbl 7073 `"Two Rivers, WI"', add
label define citylbl 7074 `"Tyler, TX"', add
label define citylbl 7080 `"Union City, NJ"', add
label define citylbl 7081 `"Uniontown, PA"', add
label define citylbl 7082 `"University City, MO"', add
label define citylbl 7083 `"Urbana, IL"', add
label define citylbl 7090 `"Utica, NY"', add
label define citylbl 7091 `"Valdosta, GA"', add
label define citylbl 7092 `"Vallejo, CA"', add
label define citylbl 7093 `"Valley Stream, NY"', add
label define citylbl 7100 `"Vancouver, WA"', add
label define citylbl 7110 `"Vallejo, CA"', add
label define citylbl 7111 `"Vandergrift, PA"', add
label define citylbl 7112 `"Venice, CA"', add
label define citylbl 7120 `"Vicksburg, MS"', add
label define citylbl 7121 `"Vincennes, IN"', add
label define citylbl 7122 `"Virginia, MN"', add
label define citylbl 7123 `"Virginia City, NV"', add
label define citylbl 7130 `"Virginia Beach, VA"', add
label define citylbl 7140 `"University City, MO"', add
label define citylbl 7150 `"Waco, TX"', add
label define citylbl 7151 `"Wakefield, MA"', add
label define citylbl 7152 `"Walla Walla, WA"', add
label define citylbl 7153 `"Wallingford, CT"', add
label define citylbl 7170 `"Waltham, MA"', add
label define citylbl 7180 `"Warren, MI"', add
label define citylbl 7190 `"Warren, OH"', add
label define citylbl 7191 `"Warren, PA"', add
label define citylbl 7210 `"Warwick Town, RI"', add
label define citylbl 7230 `"Washington, DC"', add
label define citylbl 7231 `"Georgetown, DC"', add
label define citylbl 7240 `"Waukegan, IL"', add
label define citylbl 7241 `"Washington, PA"', add
label define citylbl 7242 `"Washington, VA"', add
label define citylbl 7250 `"Waterbury, CT"', add
label define citylbl 7270 `"Waterloo, IA"', add
label define citylbl 7290 `"Waterloo, NY"', add
label define citylbl 7310 `"Watertown, NY"', add
label define citylbl 7311 `"Watertown, WI"', add
label define citylbl 7312 `"Watertown, SD"', add
label define citylbl 7313 `"Watertown, MA"', add
label define citylbl 7314 `"Waterville, ME"', add
label define citylbl 7315 `"Watervliet, NY"', add
label define citylbl 7316 `"Waukegan, IL"', add
label define citylbl 7317 `"Waukesha, WI"', add
label define citylbl 7318 `"Wausau, WI"', add
label define citylbl 7319 `"Wauwatosa, WI"', add
label define citylbl 7320 `"West Covina, CA"', add
label define citylbl 7321 `"Waycross, GA"', add
label define citylbl 7322 `"Waynesboro, PA"', add
label define citylbl 7323 `"Webb City, MO"', add
label define citylbl 7324 `"Webster Groves, MO"', add
label define citylbl 7325 `"Webster, MA"', add
label define citylbl 7326 `"Wellesley, MA"', add
label define citylbl 7327 `"Wenatchee, WA"', add
label define citylbl 7329 `"West Bay City, MI"', add
label define citylbl 7330 `"West Hoboken, NJ"', add
label define citylbl 7331 `"West Bethlehem, PA"', add
label define citylbl 7332 `"West Chester, PA"', add
label define citylbl 7333 `"West Frankfort, IL"', add
label define citylbl 7334 `"West Hartford, CT"', add
label define citylbl 7335 `"West Haven, CT"', add
label define citylbl 7340 `"West Allis, WI"', add
label define citylbl 7350 `"West New York, NJ"', add
label define citylbl 7351 `"West Orange, NJ"', add
label define citylbl 7352 `"West Palm Beach, FL"', add
label define citylbl 7353 `"West Springfield, MA"', add
label define citylbl 7370 `"West Troy, NY"', add
label define citylbl 7371 `"West Warwick, RI"', add
label define citylbl 7372 `"Westbrook, ME"', add
label define citylbl 7373 `"Westerly, RI"', add
label define citylbl 7374 `"Westfield, MA"', add
label define citylbl 7375 `"Westfield, NJ"', add
label define citylbl 7376 `"Wewoka, OK"', add
label define citylbl 7377 `"Weymouth, MA"', add
label define citylbl 7390 `"Wheeling, WV"', add
label define citylbl 7400 `"White Plains, NY"', add
label define citylbl 7401 `"Whiting, IN"', add
label define citylbl 7402 `"Whittier, CA"', add
label define citylbl 7410 `"Wichita, KS"', add
label define citylbl 7430 `"Wichita Falls, TX"', add
label define citylbl 7450 `"Wilkes-Barre, PA"', add
label define citylbl 7451 `"Wilkinsburg, PA"', add
label define citylbl 7460 `"Wilkinsburg, PA"', add
label define citylbl 7470 `"Williamsport, PA"', add
label define citylbl 7471 `"Willimantic, CT"', add
label define citylbl 7472 `"Wilmette, IL"', add
label define citylbl 7490 `"Wilmington, DE"', add
label define citylbl 7510 `"Wilmington, NC"', add
label define citylbl 7511 `"Wilson, NC"', add
label define citylbl 7512 `"Winchester, VA"', add
label define citylbl 7513 `"Winchester, MA"', add
label define citylbl 7514 `"Windham, CT"', add
label define citylbl 7515 `"Winnetka, IL"', add
label define citylbl 7516 `"Winona, MN"', add
label define citylbl 7530 `"Winston-Salem, NC"', add
label define citylbl 7531 `"Winthrop, MA"', add
label define citylbl 7532 `"Woburn, MA"', add
label define citylbl 7533 `"Woodlawn, PA"', add
label define citylbl 7534 `"Woodmont, CT"', add
label define citylbl 7550 `"Woonsocket, RI"', add
label define citylbl 7551 `"Wooster, OH"', add
label define citylbl 7570 `"Worcester, MA"', add
label define citylbl 7571 `"Wyandotte, MI"', add
label define citylbl 7572 `"Xenia, OH"', add
label define citylbl 7573 `"Yakima, WA"', add
label define citylbl 7590 `"Yonkers, NY"', add
label define citylbl 7610 `"York, PA"', add
label define citylbl 7630 `"Youngstown, OH"', add
label define citylbl 7631 `"Ypsilanti, MI"', add
label define citylbl 7650 `"Zanesville, OH"', add
label values city citylbl

label define gqlbl 0 `"Vacant unit"'
label define gqlbl 1 `"Households under 1970 definition"', add
label define gqlbl 2 `"Additional households under 1990 definition"', add
label define gqlbl 3 `"Group quarters--Institutions"', add
label define gqlbl 4 `"Other group quarters"', add
label define gqlbl 5 `"Additional households under 2000 definition"', add
label define gqlbl 6 `"Fragment"', add
label values gq gqlbl

label define relatelbl 01 `"Head/Householder"', add
label define relatelbl 02 `"Spouse"', add
label define relatelbl 03 `"Child"', add
label define relatelbl 04 `"Child-in-law"', add
label define relatelbl 05 `"Parent"', add
label define relatelbl 06 `"Parent-in-Law"', add
label define relatelbl 07 `"Sibling"', add
label define relatelbl 08 `"Sibling-in-Law"', add
label define relatelbl 09 `"Grandchild"', add
label define relatelbl 10 `"Other relatives"', add
label define relatelbl 11 `"Partner, friend, visitor"', add
label define relatelbl 12 `"Other non-relatives"', add
label define relatelbl 13 `"Institutional inmates"', add
label values relate relatelbl

label define relatedlbl 0101 `"Head/Householder"', add
label define relatedlbl 0201 `"Spouse"', add
label define relatedlbl 0202 `"2nd/3rd Wife (Polygamous)"', add
label define relatedlbl 0301 `"Child"', add
label define relatedlbl 0302 `"Adopted Child"', add
label define relatedlbl 0303 `"Stepchild"', add
label define relatedlbl 0304 `"Adopted, n.s."', add
label define relatedlbl 0401 `"Child-in-law"', add
label define relatedlbl 0402 `"Step Child-in-law"', add
label define relatedlbl 0501 `"Parent"', add
label define relatedlbl 0502 `"Stepparent"', add
label define relatedlbl 0601 `"Parent-in-Law"', add
label define relatedlbl 0602 `"Stepparent-in-law"', add
label define relatedlbl 0701 `"Sibling"', add
label define relatedlbl 0702 `"Step/Half/Adopted Sibling"', add
label define relatedlbl 0801 `"Sibling-in-Law"', add
label define relatedlbl 0802 `"Step/Half Sibling-in-law"', add
label define relatedlbl 0901 `"Grandchild"', add
label define relatedlbl 0902 `"Adopted Grandchild"', add
label define relatedlbl 0903 `"Step Grandchild"', add
label define relatedlbl 0904 `"Grandchild-in-law"', add
label define relatedlbl 1000 `"Other Relatives:"', add
label define relatedlbl 1001 `"Other Relatives"', add
label define relatedlbl 1011 `"Grandparent"', add
label define relatedlbl 1012 `"Step Grandparent"', add
label define relatedlbl 1013 `"Grandparent-in-law"', add
label define relatedlbl 1021 `"Aunt or Uncle"', add
label define relatedlbl 1022 `"Aunt,Uncle-in-law"', add
label define relatedlbl 1031 `"Nephew, Niece"', add
label define relatedlbl 1032 `"Neph/Niece-in-law"', add
label define relatedlbl 1033 `"Step/Adopted Nephew/Niece"', add
label define relatedlbl 1034 `"Grand Niece/Nephew"', add
label define relatedlbl 1041 `"Cousin"', add
label define relatedlbl 1042 `"Cousin-in-law"', add
label define relatedlbl 1051 `"Great Grandchild"', add
label define relatedlbl 1061 `"Other relatives, nec"', add
label define relatedlbl 1100 `"Partner, Friend, Visitor"', add
label define relatedlbl 1110 `"Partner/friend"', add
label define relatedlbl 1111 `"Friend"', add
label define relatedlbl 1112 `"Partner"', add
label define relatedlbl 1113 `"Partner/roommate"', add
label define relatedlbl 1114 `"Unmarried Partner"', add
label define relatedlbl 1115 `"Housemate/Roomate"', add
label define relatedlbl 1120 `"Relative of partner"', add
label define relatedlbl 1130 `"Concubine/Mistress"', add
label define relatedlbl 1131 `"Visitor"', add
label define relatedlbl 1132 `"Companion and family of companion"', add
label define relatedlbl 1139 `"Allocated partner/friend/visitor"', add
label define relatedlbl 1200 `"Other non-relatives"', add
label define relatedlbl 1201 `"Roomers/boarders/lodgers"', add
label define relatedlbl 1202 `"Boarders"', add
label define relatedlbl 1203 `"Lodgers"', add
label define relatedlbl 1204 `"Roomer"', add
label define relatedlbl 1205 `"Tenant"', add
label define relatedlbl 1206 `"Foster child"', add
label define relatedlbl 1210 `"Employees:"', add
label define relatedlbl 1211 `"Servant"', add
label define relatedlbl 1212 `"Housekeeper"', add
label define relatedlbl 1213 `"Maid"', add
label define relatedlbl 1214 `"Cook"', add
label define relatedlbl 1215 `"Nurse"', add
label define relatedlbl 1216 `"Other probable domestic employee"', add
label define relatedlbl 1217 `"Other employee"', add
label define relatedlbl 1219 `"Relative of employee"', add
label define relatedlbl 1221 `"Military"', add
label define relatedlbl 1222 `"Students"', add
label define relatedlbl 1223 `"Members of religious orders"', add
label define relatedlbl 1230 `"Other non-relatives"', add
label define relatedlbl 1239 `"Allocated other non-relative"', add
label define relatedlbl 1240 `"Roomers/boarders/lodgers and foster children"', add
label define relatedlbl 1241 `"Roomers/boarders/lodgers"', add
label define relatedlbl 1242 `"Foster children"', add
label define relatedlbl 1250 `"Employees"', add
label define relatedlbl 1251 `"Domestic employees"', add
label define relatedlbl 1252 `"Non-domestic employees"', add
label define relatedlbl 1253 `"Relative of employee"', add
label define relatedlbl 1260 `"Other non-relatives (1990 includes employees)"', add
label define relatedlbl 1270 `"Non-inmate 1990"', add
label define relatedlbl 1281 `"Head of group quarters"', add
label define relatedlbl 1282 `"Employees of group quarters"', add
label define relatedlbl 1283 `"Relative of head, staff, or employee group quarters"', add
label define relatedlbl 1284 `"Other non-inmate 1940-1959"', add
label define relatedlbl 1291 `"Military"', add
label define relatedlbl 1292 `"College dormitories"', add
label define relatedlbl 1293 `"Residents of rooming houses"', add
label define relatedlbl 1294 `"Other non-inmate 1980 (includes employees and non-inmates in"', add
label define relatedlbl 1295 `"Other non-inmates 1960-1970 (includes employees)"', add
label define relatedlbl 1296 `"Non-inmates in institutions"', add
label define relatedlbl 1301 `"Institutional inmates"', add
label values related relatedlbl

label define racelbl 1 `"White"'
label define racelbl 2 `"Black/Negro"', add
label define racelbl 3 `"American Indian or Alaska Native"', add
label define racelbl 4 `"Chinese"', add
label define racelbl 5 `"Japanese"', add
label define racelbl 6 `"Other Asian or Pacific Islander"', add
label define racelbl 7 `"Other race, nec"', add
label define racelbl 8 `"Two major races"', add
label define racelbl 9 `"Three or more major races"', add
label values race racelbl

label define racedlbl 100 `"White"', add
label define racedlbl 110 `"Spanish write-in"', add
label define racedlbl 120 `"Blank (white) (1850)"', add
label define racedlbl 130 `"Portuguese"', add
label define racedlbl 140 `"Mexican (1930)"', add
label define racedlbl 150 `"Puerto Rican (1910 Hawaii)"', add
label define racedlbl 200 `"Black/Negro"', add
label define racedlbl 210 `"Mulatto"', add
label define racedlbl 300 `"American Indian/Alaska Native"', add
label define racedlbl 301 `"Alaskan Athabaskan"', add
label define racedlbl 302 `"Apache"', add
label define racedlbl 303 `"Blackfoot"', add
label define racedlbl 304 `"Cherokee"', add
label define racedlbl 305 `"Cheyenne"', add
label define racedlbl 306 `"Chickasaw"', add
label define racedlbl 307 `"Chippewa"', add
label define racedlbl 308 `"Choctaw"', add
label define racedlbl 309 `"Comanche"', add
label define racedlbl 310 `"Creek"', add
label define racedlbl 311 `"Crow"', add
label define racedlbl 312 `"Iroquois"', add
label define racedlbl 313 `"Kiowa"', add
label define racedlbl 314 `"Lumbee"', add
label define racedlbl 315 `"Navajo"', add
label define racedlbl 316 `"Osage"', add
label define racedlbl 317 `"Paiute"', add
label define racedlbl 318 `"Pima"', add
label define racedlbl 319 `"Potawatomi"', add
label define racedlbl 320 `"Pueblo"', add
label define racedlbl 321 `"Seminole"', add
label define racedlbl 322 `"Shoshone"', add
label define racedlbl 323 `"Sioux"', add
label define racedlbl 324 `"Tlingit (Tlingit-Haida, 2000/ACS)"', add
label define racedlbl 325 `"Tohono O Odham"', add
label define racedlbl 326 `"All other tribes (1990)"', add
label define racedlbl 327 `"Tribe not specified"', add
label define racedlbl 330 `"Aleut"', add
label define racedlbl 340 `"Eskimo"', add
label define racedlbl 341 `"Alaskan mixed"', add
label define racedlbl 350 `"Delaware"', add
label define racedlbl 351 `"Latin American Indian"', add
label define racedlbl 352 `"Puget Sound Salish"', add
label define racedlbl 353 `"Yakama"', add
label define racedlbl 354 `"Yaqui"', add
label define racedlbl 355 `"Colville"', add
label define racedlbl 356 `"Houma"', add
label define racedlbl 357 `"Menominee"', add
label define racedlbl 358 `"Yuman"', add
label define racedlbl 390 `"Other Amer. Indian tribe (2000,ACS)"', add
label define racedlbl 391 `"2+ Amer. Indian tribes (2000,ACS)"', add
label define racedlbl 392 `"Other Alaska Native tribe(s) (2000,ACS)"', add
label define racedlbl 393 `"Both Am. Ind. and Alaska Native (2000,ACS)"', add
label define racedlbl 400 `"Chinese"', add
label define racedlbl 410 `"Taiwanese"', add
label define racedlbl 420 `"Chinese and Taiwanese"', add
label define racedlbl 500 `"Japanese"', add
label define racedlbl 600 `"Filipino"', add
label define racedlbl 610 `"Asian Indian (Hindu 1920-1940)"', add
label define racedlbl 620 `"Korean"', add
label define racedlbl 630 `"Hawaiian"', add
label define racedlbl 631 `"Hawaiian and Asian (1900,1920)"', add
label define racedlbl 632 `"Hawaiian and European (1900,1920)"', add
label define racedlbl 634 `"Hawaiian mixed"', add
label define racedlbl 640 `"Vietnamese"', add
label define racedlbl 650 `"Other Asian or Pacific Islander (1920,1980)"', add
label define racedlbl 651 `"Asian only (CPS)"', add
label define racedlbl 652 `"Pacific Islander only (CPS)"', add
label define racedlbl 653 `"Asian or Pacific Islander, n.s. (1990 Internal Census files)"', add
label define racedlbl 660 `"Cambodian"', add
label define racedlbl 661 `"Hmong"', add
label define racedlbl 662 `"Laotian"', add
label define racedlbl 663 `"Thai"', add
label define racedlbl 664 `"Bangladeshi"', add
label define racedlbl 665 `"Burmese"', add
label define racedlbl 666 `"Indonesian"', add
label define racedlbl 667 `"Malaysian"', add
label define racedlbl 668 `"Okinawan"', add
label define racedlbl 669 `"Pakistani"', add
label define racedlbl 670 `"Sri Lankan"', add
label define racedlbl 671 `"Other Asian, n.e.c."', add
label define racedlbl 672 `"Asian, not specified"', add
label define racedlbl 673 `"Chinese and Japanese"', add
label define racedlbl 674 `"Chinese and Filipino"', add
label define racedlbl 675 `"Chinese and Vietnamese"', add
label define racedlbl 676 `"Chinese and Asian write-in"', add
label define racedlbl 677 `"Japanese and Filipino"', add
label define racedlbl 678 `"Asian Indian and Asian write-in"', add
label define racedlbl 679 `"Other Asian race combinations"', add
label define racedlbl 680 `"Samoan"', add
label define racedlbl 681 `"Tahitian"', add
label define racedlbl 682 `"Tongan"', add
label define racedlbl 683 `"Other Polynesian (1990)"', add
label define racedlbl 684 `"1+ other Polynesian races (2000,ACS)"', add
label define racedlbl 685 `"Guamanian/Chamorro"', add
label define racedlbl 686 `"Northern Mariana Islander"', add
label define racedlbl 687 `"Palauan"', add
label define racedlbl 688 `"Other Micronesian (1990)"', add
label define racedlbl 689 `"1+ other Micronesian races (2000,ACS)"', add
label define racedlbl 690 `"Fijian"', add
label define racedlbl 691 `"Other Melanesian (1990)"', add
label define racedlbl 692 `"1+ other Melanesian races (2000,ACS)"', add
label define racedlbl 698 `"2+ PI races from 2+ PI regions"', add
label define racedlbl 699 `"Pacific Islander, n.s."', add
label define racedlbl 700 `"Other race, n.e.c."', add
label define racedlbl 801 `"White and Black"', add
label define racedlbl 802 `"White and AIAN"', add
label define racedlbl 810 `"White and Asian"', add
label define racedlbl 811 `"White and Chinese"', add
label define racedlbl 812 `"White and Japanese"', add
label define racedlbl 813 `"White and Filipino"', add
label define racedlbl 814 `"White and Asian Indian"', add
label define racedlbl 815 `"White and Korean"', add
label define racedlbl 816 `"White and Vietnamese"', add
label define racedlbl 817 `"White and Asian write-in"', add
label define racedlbl 818 `"White and other Asian race(s)"', add
label define racedlbl 819 `"White and two or more Asian groups"', add
label define racedlbl 820 `"White and PI"', add
label define racedlbl 821 `"White and Native Hawaiian"', add
label define racedlbl 822 `"White and Samoan"', add
label define racedlbl 823 `"White and Guamanian"', add
label define racedlbl 824 `"White and PI write-in"', add
label define racedlbl 825 `"White and other PI race(s)"', add
label define racedlbl 826 `"White and other race write-in"', add
label define racedlbl 827 `"White and other race, n.e.c."', add
label define racedlbl 830 `"Black and AIAN"', add
label define racedlbl 831 `"Black and Asian"', add
label define racedlbl 832 `"Black and Chinese"', add
label define racedlbl 833 `"Black and Japanese"', add
label define racedlbl 834 `"Black and Filipino"', add
label define racedlbl 835 `"Black and Asian Indian"', add
label define racedlbl 836 `"Black and Korean"', add
label define racedlbl 837 `"Black and Asian write-in"', add
label define racedlbl 838 `"Black and other Asian race(s)"', add
label define racedlbl 840 `"Black and PI"', add
label define racedlbl 841 `"Black and PI write-in"', add
label define racedlbl 842 `"Black and other PI race(s)"', add
label define racedlbl 845 `"Black and other race write-in"', add
label define racedlbl 850 `"AIAN and Asian"', add
label define racedlbl 851 `"AIAN and Filipino (2000 1%)"', add
label define racedlbl 852 `"AIAN and Asian Indian"', add
label define racedlbl 853 `"AIAN and Asian write-in (2000 1%)"', add
label define racedlbl 854 `"AIAN and other Asian race(s)"', add
label define racedlbl 855 `"AIAN and PI"', add
label define racedlbl 856 `"AIAN and other race write-in"', add
label define racedlbl 860 `"Asian and PI"', add
label define racedlbl 861 `"Chinese and Hawaiian"', add
label define racedlbl 862 `"Chinese, Filipino, Hawaiian (2000 1%)"', add
label define racedlbl 863 `"Japanese and Hawaiian (2000 1%)"', add
label define racedlbl 864 `"Filipino and Hawaiian"', add
label define racedlbl 865 `"Filipino and PI write-in"', add
label define racedlbl 866 `"Asian Indian and PI write-in (2000 1%)"', add
label define racedlbl 867 `"Asian write-in and PI write-in"', add
label define racedlbl 868 `"Other Asian race(s) and PI race(s)"', add
label define racedlbl 880 `"Asian and other race write-in"', add
label define racedlbl 881 `"Chinese and other race write-in"', add
label define racedlbl 882 `"Japanese and other race write-in"', add
label define racedlbl 883 `"Filipino and other race write-in"', add
label define racedlbl 884 `"Asian Indian and other race write-in"', add
label define racedlbl 885 `"Asian write-in and other race write-in"', add
label define racedlbl 886 `"Other Asian race(s) and other race write-in"', add
label define racedlbl 890 `"PI and other race write-in:"', add
label define racedlbl 891 `"PI write-in and other race write-in"', add
label define racedlbl 892 `"Other PI race(s) and other race write-in"', add
label define racedlbl 899 `"API and other race write-in"', add
label define racedlbl 901 `"White, Black, AIAN"', add
label define racedlbl 902 `"White, Black, Asian"', add
label define racedlbl 903 `"White, Black, PI"', add
label define racedlbl 904 `"White, Black, other race write-in"', add
label define racedlbl 905 `"White, AIAN, Asian"', add
label define racedlbl 906 `"White, AIAN, PI"', add
label define racedlbl 907 `"White, AIAN, other race write-in"', add
label define racedlbl 910 `"White, Asian, PI"', add
label define racedlbl 911 `"White, Chinese, Hawaiian"', add
label define racedlbl 912 `"White, Chinese, Filipino, Hawaiian (2000 1%)"', add
label define racedlbl 913 `"White, Japanese, Hawaiian (2000 1%)"', add
label define racedlbl 914 `"White, Filipino, Hawaiian"', add
label define racedlbl 915 `"Other White, Asian race(s), PI race(s)"', add
label define racedlbl 920 `"White, Asian, other race write-in"', add
label define racedlbl 921 `"White, Filipino, other race write-in (2000 1%)"', add
label define racedlbl 922 `"White, Asian write-in, other race write-in (2000 1%)"', add
label define racedlbl 923 `"Other White, Asian race(s), other race write-in (2000 1%)"', add
label define racedlbl 925 `"White, PI, other race write-in"', add
label define racedlbl 930 `"Black, AIAN, Asian"', add
label define racedlbl 931 `"Black, AIAN, PI"', add
label define racedlbl 932 `"Black, AIAN, other race write-in"', add
label define racedlbl 933 `"Black, Asian, PI"', add
label define racedlbl 934 `"Black, Asian, other race write-in"', add
label define racedlbl 935 `"Black, PI, other race write-in"', add
label define racedlbl 940 `"AIAN, Asian, PI"', add
label define racedlbl 941 `"AIAN, Asian, other race write-in"', add
label define racedlbl 942 `"AIAN, PI, other race write-in"', add
label define racedlbl 943 `"Asian, PI, other race write-in"', add
label define racedlbl 949 `"2 or 3 races (CPS)"', add
label define racedlbl 950 `"White, Black, AIAN, Asian"', add
label define racedlbl 951 `"White, Black, AIAN, PI"', add
label define racedlbl 952 `"White, Black, AIAN, other race write-in"', add
label define racedlbl 953 `"White, Black, Asian, PI"', add
label define racedlbl 954 `"White, Black, Asian, other race write-in"', add
label define racedlbl 955 `"White, Black, PI, other race write-in"', add
label define racedlbl 960 `"White, AIAN, Asian, PI"', add
label define racedlbl 961 `"White, AIAN, Asian, other race write-in"', add
label define racedlbl 962 `"White, AIAN, PI, other race write-in"', add
label define racedlbl 963 `"White, Asian, PI, other race write-in"', add
label define racedlbl 970 `"Black, AIAN, Asian, PI"', add
label define racedlbl 971 `"Black, AIAN, Asian, other race write-in"', add
label define racedlbl 972 `"Black, AIAN, PI, other race write-in"', add
label define racedlbl 973 `"Black, Asian, PI, other race write-in"', add
label define racedlbl 974 `"AIAN, Asian, PI, other race write-in"', add
label define racedlbl 975 `"AIAN, Asian, PI, Hawaiian other race write-in"', add
label define racedlbl 980 `"White, Black, AIAN, Asian, PI"', add
label define racedlbl 981 `"White, Black, AIAN, Asian, other race write-in"', add
label define racedlbl 982 `"White, Black, AIAN, PI, other race write-in"', add
label define racedlbl 983 `"White, Black, Asian, PI, other race write-in"', add
label define racedlbl 984 `"White, AIAN, Asian, PI, other race write-in"', add
label define racedlbl 985 `"Black, AIAN, Asian, PI, other race write-in"', add
label define racedlbl 986 `"Black, AIAN, Asian, PI, Hawaiian, other race write-in"', add
label define racedlbl 989 `"4 or 5 races (CPS)"', add
label define racedlbl 990 `"White, Black, AIAN, Asian, PI, other race write-in"', add
label define racedlbl 991 `"White race; Some other race; Black or African American race and/or American Indian and Alaska Native race and/or Asian groups and/or Native Hawaiian and Other Pacific Islander groups"', add
label define racedlbl 996 `"2+ races, n.e.c. (CPS)"', add
label values raced racedlbl

