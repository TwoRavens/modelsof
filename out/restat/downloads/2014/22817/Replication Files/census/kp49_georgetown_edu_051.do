clear

set memory 300m

/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 byte    year          1-2 ///
 byte    statefip      3-4 ///
 int     metaread      5-8 ///
 int     cityd         9-12 ///
 long    citypop      13-17 ///
 int     perwt        18-21 ///
 int     age          22-24 ///
 byte    sex          25 ///
 long    bpld         26-30 ///
 byte    educ99       31-32 ///
 byte    empstatd     33-34 ///
 int     occ          35-37 ///
 int     occ1990      38-40 ///
 int     ind1990      41-43 ///
 byte    wkswork1     44-45 ///
 byte    uhrswork     46-47 ///
 long    incwage      48-53 ///
 byte    movedin      54 ///
 int     pwmetro      55-58 ///
 int     pwcity       59-62 ///
 using "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\census\kp49_georgetown_edu_051.dat



label var year "Census year"
label var statefip "State (FIPS code)"
label var metaread "Metropolitan area [detailed version]"
label var cityd "City [detailed version]"
label var citypop "City population"
label var perwt "Person weight"
label var age "Age"
label var sex "Sex"
label var bpld "Birthplace [detailed version]"
label var educ99 "Educational attainment, 1990"
label var empstatd "Employment status [detailed version]"
label var occ "Occupation"
label var occ1990 "Occupation, 1990 basis"
label var ind1990 "Industry, 1990 basis"
label var wkswork1 "Weeks worked last year"
label var uhrswork "Usual hours worked per week"
label var incwage "Wage and salary income"
label var movedin "When occupant moved into residence"
label var pwmetro "Place of work: metropolitan area"
label var pwcity "Place of work: city"

label define yearlbl 00 "2000"
label define yearlbl 01 "2001", add
label define yearlbl 02 "2002", add
label define yearlbl 03 "2003", add
label define yearlbl 04 "2004", add
label define yearlbl 05 "2005", add
label define yearlbl 85 "1850", add
label define yearlbl 86 "1860", add
label define yearlbl 87 "1870", add
label define yearlbl 88 "1880", add
label define yearlbl 90 "1900", add
label define yearlbl 91 "1910", add
label define yearlbl 92 "1920", add
label define yearlbl 93 "1930", add
label define yearlbl 94 "1940", add
label define yearlbl 95 "1950", add
label define yearlbl 96 "1960", add
label define yearlbl 97 "1970", add
label define yearlbl 98 "1980", add
label define yearlbl 99 "1990", add
label values year yearlbl

label define statefiplbl 01 "Alabama", add
label define statefiplbl 02 "Alaska", add
label define statefiplbl 04 "Arizona", add
label define statefiplbl 05 "Arkansas", add
label define statefiplbl 06 "California", add
label define statefiplbl 08 "Colorado", add
label define statefiplbl 09 "Connecticut", add
label define statefiplbl 10 "Delaware", add
label define statefiplbl 11 "District of Columbia", add
label define statefiplbl 12 "Florida", add
label define statefiplbl 13 "Georgia", add
label define statefiplbl 15 "Hawaii", add
label define statefiplbl 16 "Idaho", add
label define statefiplbl 17 "Illinois", add
label define statefiplbl 18 "Indiana", add
label define statefiplbl 19 "Iowa", add
label define statefiplbl 20 "Kansas", add
label define statefiplbl 21 "Kentucky", add
label define statefiplbl 22 "Louisiana", add
label define statefiplbl 23 "Maine", add
label define statefiplbl 24 "Maryland", add
label define statefiplbl 25 "Massachusetts", add
label define statefiplbl 26 "Michigan", add
label define statefiplbl 27 "Minnesota", add
label define statefiplbl 28 "Mississippi", add
label define statefiplbl 29 "Missouri", add
label define statefiplbl 30 "Montana", add
label define statefiplbl 31 "Nebraska", add
label define statefiplbl 32 "Nevada", add
label define statefiplbl 33 "New Hampshire", add
label define statefiplbl 34 "New Jersey", add
label define statefiplbl 35 "New Mexico", add
label define statefiplbl 36 "New York", add
label define statefiplbl 37 "North Carolina", add
label define statefiplbl 38 "North Dakota", add
label define statefiplbl 39 "Ohio", add
label define statefiplbl 40 "Oklahoma", add
label define statefiplbl 41 "Oregon", add
label define statefiplbl 42 "Pennsylvania", add
label define statefiplbl 44 "Rhode island", add
label define statefiplbl 45 "South Carolina", add
label define statefiplbl 46 "South Dakota", add
label define statefiplbl 47 "Tennessee", add
label define statefiplbl 48 "Texas", add
label define statefiplbl 49 "Utah", add
label define statefiplbl 50 "Vermont", add
label define statefiplbl 51 "Virginia", add
label define statefiplbl 53 "Washington", add
label define statefiplbl 54 "West Virginia", add
label define statefiplbl 55 "Wisconsin", add
label define statefiplbl 56 "Wyoming", add
label define statefiplbl 61 "Maine-New Hampshire-Vermont", add
label define statefiplbl 62 "Massachusetts-Rhode Island", add
label define statefiplbl 63 "Minnesota-Iowa-Missouri-Kansas-Nebraska-S.Dakota-N.Dakota", add
label define statefiplbl 64 "Maryland-Delaware", add
label define statefiplbl 65 "Montana-Idaho-Wyoming", add
label define statefiplbl 66 "Utah-Nevada", add
label define statefiplbl 67 "Arizona-New Mexico", add
label define statefiplbl 68 "Alaska-Hawaii", add
label define statefiplbl 72 "Puerto Rico", add
label define statefiplbl 97 "Military/Mil. Reservation", add
label define statefiplbl 99 "State not identified", add
label values statefip statefiplbl

label define metareadlbl 0000 "Not identifiable or not in an MSA", add
label define metareadlbl 0040 "Abilene, TX", add
label define metareadlbl 0060 "Aguadilla, PR", add
label define metareadlbl 0080 "Akron, OH", add
label define metareadlbl 0120 "Albany, GA", add
label define metareadlbl 0160 "Albany-Schenectady-Troy, NY", add
label define metareadlbl 0200 "Albuquerque, NM", add
label define metareadlbl 0220 "Alexandria, LA", add
label define metareadlbl 0240 "Allentown-Bethlehem-Easton, PA/NJ", add
label define metareadlbl 0280 "Altoona, PA", add
label define metareadlbl 0320 "Amarillo, TX", add
label define metareadlbl 0380 "Anchorage, AK", add
label define metareadlbl 0400 "Anderson, IN", add
label define metareadlbl 0440 "Ann Arbor, MI", add
label define metareadlbl 0450 "Anniston, AL", add
label define metareadlbl 0460 "Appleton-Oskosh-Neenah, WI", add
label define metareadlbl 0470 "Arecibo, PR", add
label define metareadlbl 0480 "Asheville, NC", add
label define metareadlbl 0500 "Athens, GA", add
label define metareadlbl 0520 "Atlanta, GA", add
label define metareadlbl 0560 "Atlantic City, NJ", add
label define metareadlbl 0580 "Auburn-Opelika, AL", add
label define metareadlbl 0600 "Augusta-Aiken, GA-SC", add
label define metareadlbl 0640 "Austin, TX", add
label define metareadlbl 0680 "Bakersfield, CA", add
label define metareadlbl 0720 "Baltimore, MD", add
label define metareadlbl 0730 "Bangor, ME", add
label define metareadlbl 0740 "Barnstable-Yarmouth, MA", add
label define metareadlbl 0760 "Baton Rouge, LA", add
label define metareadlbl 0780 "Battle Creek, MI", add
label define metareadlbl 0840 "Beaumont-Port Arthur-Orange,TX", add
label define metareadlbl 0860 "Bellingham, WA", add
label define metareadlbl 0870 "Benton Harbor, MI", add
label define metareadlbl 0880 "Billings, MT", add
label define metareadlbl 0920 "Biloxi-Gulfport, MS", add
label define metareadlbl 0960 "Binghamton, NY", add
label define metareadlbl 1000 "Birmingham, AL", add
label define metareadlbl 1010 "Bismarck,ND", add
label define metareadlbl 1020 "Bloomington, IN", add
label define metareadlbl 1040 "Bloomington-Normal, IL", add
label define metareadlbl 1080 "Boise City, ID", add
label define metareadlbl 1120 "Boston, MA", add
label define metareadlbl 1121 "Lawrence-Haverhill, MA/NH", add
label define metareadlbl 1122 "Lowell, MA/NH", add
label define metareadlbl 1123 "Salem-Gloucester, MA", add
label define metareadlbl 1140 "Bradenton, FL", add
label define metareadlbl 1150 "Bremerton, WA", add
label define metareadlbl 1160 "Bridgeport, CT", add
label define metareadlbl 1200 "Brockton, MA", add
label define metareadlbl 1240 "Brownsville-Harlingen-San Benito, TX", add
label define metareadlbl 1260 "Bryan-College Station, TX", add
label define metareadlbl 1280 "Buffalo-Niagara Falls, NY", add
label define metareadlbl 1281 "Niagara Falls, NY", add
label define metareadlbl 1300 "Burlington, NC", add
label define metareadlbl 1310 "Burlington, VT", add
label define metareadlbl 1315 "Caguas, PR", add
label define metareadlbl 1320 "Canton, OH", add
label define metareadlbl 1350 "Casper, WY", add
label define metareadlbl 1360 "Cedar Rapids, IA", add
label define metareadlbl 1400 "Champaign-Urbana-Rantoul, IL", add
label define metareadlbl 1440 "Charleston-N.Charleston,SC", add
label define metareadlbl 1480 "Charleston, WV", add
label define metareadlbl 1520 "Charlotte-Gastonia-Rock Hill, SC", add
label define metareadlbl 1521 "Rock Hill, SC", add
label define metareadlbl 1540 "Charlottesville, VA", add
label define metareadlbl 1560 "Chattanooga, TN/GA", add
label define metareadlbl 1580 "Cheyenne, WY", add
label define metareadlbl 1600 "Chicago-Gary-Lake, IL", add
label define metareadlbl 1601 "Aurora-Elgin, IL", add
label define metareadlbl 1602 "Gary-Hammond-East Chicago, IN", add
label define metareadlbl 1603 "Joliet IL", add
label define metareadlbl 1604 "Lake County, IL", add
label define metareadlbl 1620 "Chico, CA", add
label define metareadlbl 1640 "Cincinnati OH/KY/IN", add
label define metareadlbl 1660 "Clarksville-Hopkinsville, TN/KY", add
label define metareadlbl 1680 "Cleveland, OH", add
label define metareadlbl 1720 "Colorado Springs, CO", add
label define metareadlbl 1740 "Columbia, MO", add
label define metareadlbl 1760 "Columbia, SC", add
label define metareadlbl 1800 "Columbus, GA/AL", add
label define metareadlbl 1840 "Columbus, OH", add
label define metareadlbl 1880 "Corpus Christi, TX", add
label define metareadlbl 1900 "Cumberland, MD/WV", add
label define metareadlbl 1920 "Dallas-Fort Worth, TX", add
label define metareadlbl 1921 "Fort Worth-Arlington, TX", add
label define metareadlbl 1930 "Danbury, CT", add
label define metareadlbl 1950 "Danville, VA", add
label define metareadlbl 1960 "Davenport, IA Rock Island-Moline, IL", add
label define metareadlbl 2000 "Dayton-Springfield, OH", add
label define metareadlbl 2001 "Springfield, OH", add
label define metareadlbl 2020 "Daytona Beach, FL", add
label define metareadlbl 2030 "Decatur, AL", add
label define metareadlbl 2040 "Decatur, IL", add
label define metareadlbl 2080 "Denver-Boulder-Longmont, CO", add
label define metareadlbl 2081 "Boulder-Longmont, CO", add
label define metareadlbl 2120 "Des Moines, IA", add
label define metareadlbl 2121 "Polk, IA", add
label define metareadlbl 2160 "Detroit, MI", add
label define metareadlbl 2180 "Dothan, AL", add
label define metareadlbl 2190 "Dover, DE", add
label define metareadlbl 2200 "Dubuque, IA", add
label define metareadlbl 2240 "Duluth-Superior, MN/WI", add
label define metareadlbl 2281 "Dutchess Co., NY", add
label define metareadlbl 2290 "Eau Claire, WI", add
label define metareadlbl 2310 "El Paso, TX", add
label define metareadlbl 2320 "Elkhart-Goshen, IN", add
label define metareadlbl 2330 "Elmira, NY", add
label define metareadlbl 2340 "Enid, OK", add
label define metareadlbl 2360 "Erie, PA", add
label define metareadlbl 2400 "Eugene-Springfield, OR", add
label define metareadlbl 2440 "Evansville, IN/KY", add
label define metareadlbl 2520 "Fargo-Morehead, ND/MN", add
label define metareadlbl 2560 "Fayetteville, NC", add
label define metareadlbl 2580 "Fayetteville-Springdale, AR", add
label define metareadlbl 2600 "Fitchburg-Leominster, MA", add
label define metareadlbl 2620 "Flagstaff, AZ-UT", add
label define metareadlbl 2640 "Flint, MI", add
label define metareadlbl 2650 "Florence, AL", add
label define metareadlbl 2660 "Florence, SC", add
label define metareadlbl 2670 "Fort Collins-Loveland, CO", add
label define metareadlbl 2680 "Fort Lauderdale-Hollywood-Pompano Beach, FL", add
label define metareadlbl 2700 "Fort Myers-Cape Coral, FL", add
label define metareadlbl 2710 "Fort Pierce, FL", add
label define metareadlbl 2720 "Fort Smith, AR/OK", add
label define metareadlbl 2750 "Fort Walton Beach, FL", add
label define metareadlbl 2760 "Fort Wayne, IN", add
label define metareadlbl 2840 "Fresno, CA", add
label define metareadlbl 2880 "Gadsden, AL", add
label define metareadlbl 2900 "Gainesville, FL", add
label define metareadlbl 2920 "Galveston-Texas City, TX", add
label define metareadlbl 2970 "Glens Falls, NY", add
label define metareadlbl 2980 "Goldsboro, NC", add
label define metareadlbl 2990 "Grand Forks, ND/MN", add
label define metareadlbl 3000 "Grand Rapids, MI", add
label define metareadlbl 3010 "Grand Junction, CO", add
label define metareadlbl 3040 "Great Falls, MT", add
label define metareadlbl 3060 "Greeley, CO", add
label define metareadlbl 3080 "Green Bay, WI", add
label define metareadlbl 3120 "Greensboro-Winston Salem-High Point, NC", add
label define metareadlbl 3121 "Winston-Salem, NC", add
label define metareadlbl 3150 "Greenville, NC", add
label define metareadlbl 3160 "Greenville-Spartanburg-Anderson SC", add
label define metareadlbl 3161 "Anderson, SC", add
label define metareadlbl 3180 "Hagerstown, MD", add
label define metareadlbl 3200 "Hamilton-Middleton, OH", add
label define metareadlbl 3240 "Harrisburg-Lebanon-Carlisle, PA", add
label define metareadlbl 3280 "Hartford-Bristol-Middleton-New Britain, CT", add
label define metareadlbl 3281 "Bristol, CT", add
label define metareadlbl 3282 "Middletown, CT", add
label define metareadlbl 3283 "New Britain, CT", add
label define metareadlbl 3290 "Hickory-Morgantown, NC", add
label define metareadlbl 3300 "Hattiesburg, MS", add
label define metareadlbl 3320 "Honolulu, HI", add
label define metareadlbl 3350 "Houma-Thibodoux, LA", add
label define metareadlbl 3360 "Houston-Brazoria, TX", add
label define metareadlbl 3361 "Brazoria, TX", add
label define metareadlbl 3400 "Huntington-Ashland, WV/KY/OH", add
label define metareadlbl 3440 "Huntsville, AL", add
label define metareadlbl 3480 "Indianapolis, IN", add
label define metareadlbl 3500 "Iowa City, IA", add
label define metareadlbl 3520 "Jackson, MI", add
label define metareadlbl 3560 "Jackson, MS", add
label define metareadlbl 3580 "Jackson, TN", add
label define metareadlbl 3590 "Jacksonville, FL", add
label define metareadlbl 3600 "Jacksonville, NC", add
label define metareadlbl 3610 "Jamestown-Dunkirk, NY", add
label define metareadlbl 3620 "Janesville-Beloit, WI", add
label define metareadlbl 3660 "Johnson City-Kingsport-Bristol, TN/VA", add
label define metareadlbl 3680 "Johnstown, PA", add
label define metareadlbl 3710 "Joplin, MO", add
label define metareadlbl 3720 "Kalamazoo-Portage, MI", add
label define metareadlbl 3740 "Kankakee, IL", add
label define metareadlbl 3760 "Kansas City, MO-KS", add
label define metareadlbl 3800 "Kenosha, WI", add
label define metareadlbl 3810 "Kileen-Temple, TX", add
label define metareadlbl 3840 "Knoxville, TN", add
label define metareadlbl 3850 "Kokomo, IN", add
label define metareadlbl 3870 "LaCrosse, WI", add
label define metareadlbl 3880 "Lafayette, LA", add
label define metareadlbl 3920 "Lafayette-W. Lafayette, IN", add
label define metareadlbl 3960 "Lake Charles, LA", add
label define metareadlbl 3980 "Lakeland-Winterhaven, FL", add
label define metareadlbl 4000 "Lancaster, PA", add
label define metareadlbl 4040 "Lansing-E. Lansing, MI", add
label define metareadlbl 4080 "Laredo, TX", add
label define metareadlbl 4100 "Las Cruces, NM", add
label define metareadlbl 4120 "Las Vegas, NV", add
label define metareadlbl 4150 "Lawrence, KS", add
label define metareadlbl 4200 "Lawton, OK", add
label define metareadlbl 4240 "Lewiston-Auburn, ME", add
label define metareadlbl 4280 "Lexington-Fayette, KY", add
label define metareadlbl 4320 "Lima, OH", add
label define metareadlbl 4360 "Lincoln, NE", add
label define metareadlbl 4400 "Little Rock-North Little Rock, AR", add
label define metareadlbl 4410 "Long Branch-Asbury Park,NJ", add
label define metareadlbl 4420 "Longview-Marshall, TX", add
label define metareadlbl 4440 "Lorain-Elyria, OH", add
label define metareadlbl 4480 "Los Angeles-Long Beach, CA", add
label define metareadlbl 4481 "Anaheim-Santa Ana-Garden Grove, CA", add
label define metareadlbl 4482 "Orange County, CA", add
label define metareadlbl 4520 "Louisville, KY/IN", add
label define metareadlbl 4600 "Lubbock, TX", add
label define metareadlbl 4640 "Lynchburg, VA", add
label define metareadlbl 4680 "Macon-Warner Robins, GA", add
label define metareadlbl 4720 "Madison, WI", add
label define metareadlbl 4760 "Manchester, NH", add
label define metareadlbl 4800 "Mansfield, OH", add
label define metareadlbl 4840 "Mayaguez, PR", add
label define metareadlbl 4880 "McAllen-Edinburg-Pharr-Mission, TX", add
label define metareadlbl 4890 "Medford, OR", add
label define metareadlbl 4900 "Melbourne-Titusville-Cocoa-Palm Bay, FL", add
label define metareadlbl 4920 "Memphis, TN/AR/MS", add
label define metareadlbl 4940 "Merced, CA", add
label define metareadlbl 5000 "Miami-Hialeah, FL", add
label define metareadlbl 5040 "Midland, TX", add
label define metareadlbl 5080 "Milwaukee, WI", add
label define metareadlbl 5120 "Minneapolis-St. Paul, MN", add
label define metareadlbl 5140 "Missoula, MT", add
label define metareadlbl 5160 "Mobile, AL", add
label define metareadlbl 5170 "Modesto, CA", add
label define metareadlbl 5190 "Monmouth-Ocean, NJ", add
label define metareadlbl 5200 "Monroe, LA", add
label define metareadlbl 5240 "Montgomery, AL", add
label define metareadlbl 5280 "Muncie, IN", add
label define metareadlbl 5320 "Muskegon-Norton Shores-Muskegon Heights, MI", add
label define metareadlbl 5330 "Myrtle Beach, SC", add
label define metareadlbl 5340 "Naples, FL", add
label define metareadlbl 5350 "Nashua, NH", add
label define metareadlbl 5360 "Nashville, TN", add
label define metareadlbl 5400 "New Bedford, MA", add
label define metareadlbl 5460 "New Brunswick-Perth Amboy-Sayreville, NJ", add
label define metareadlbl 5480 "New Haven-Meriden, CT", add
label define metareadlbl 5481 "Meriden", add
label define metareadlbl 5482 "New Haven, CT", add
label define metareadlbl 5520 "New London-Norwich, CT/RI", add
label define metareadlbl 5560 "New Orleans, LA", add
label define metareadlbl 5600 "New York-Northeastern NJ", add
label define metareadlbl 5601 "Nassau Co, NY", add
label define metareadlbl 5602 "Bergen-Passaic, NJ", add
label define metareadlbl 5603 "Jersey City, NJ", add
label define metareadlbl 5604 "Middlesex-Somerset-Hunterdon, NJ", add
label define metareadlbl 5605 "Newark, NJ", add
label define metareadlbl 5640 "Newark, OH", add
label define metareadlbl 5660 "Newburgh-Middletown, NY", add
label define metareadlbl 5720 "Norfolk-VA Beach-Newport News, VA", add
label define metareadlbl 5721 "Newport News-Hampton", add
label define metareadlbl 5722 "Norfolk- VA Beach-Portsmouth", add
label define metareadlbl 5760 "Norwalk, CT", add
label define metareadlbl 5790 "Ocala, FL", add
label define metareadlbl 5800 "Odessa, TX", add
label define metareadlbl 5880 "Oklahoma City, OK", add
label define metareadlbl 5910 "Olympia, WA", add
label define metareadlbl 5920 "Omaha, NE/IA", add
label define metareadlbl 5950 "Orange, NY", add
label define metareadlbl 5960 "Orlando, FL", add
label define metareadlbl 5990 "Owensboro, KY", add
label define metareadlbl 6010 "Panama City, FL", add
label define metareadlbl 6020 "Parkersburg-Marietta,WV/OH", add
label define metareadlbl 6030 "Pascagoula-Moss Point, MS", add
label define metareadlbl 6080 "Pensacola, FL", add
label define metareadlbl 6120 "Peoria, IL", add
label define metareadlbl 6160 "Philadelphia, PA/NJ", add
label define metareadlbl 6200 "Phoenix, AZ", add
label define metareadlbl 6240 "Pine Bluff, AR", add
label define metareadlbl 6280 "Pittsburgh-Beaver Valley, PA", add
label define metareadlbl 6281 "Beaver County, PA", add
label define metareadlbl 6320 "Pittsfield, MA", add
label define metareadlbl 6360 "Ponce, PR", add
label define metareadlbl 6400 "Portland, ME", add
label define metareadlbl 6440 "Portland-Vancouver, OR", add
label define metareadlbl 6441 "Vancouver, WA", add
label define metareadlbl 6450 "Portsmouth-Dover-Rochester, NH/ME", add
label define metareadlbl 6460 "Poughkeepsie, NY", add
label define metareadlbl 6480 "Providence-Fall River-Pawtucket, MA/RI", add
label define metareadlbl 6481 "Fall River, MA/RI", add
label define metareadlbl 6482 "Pawtuckett-Woonsocket-Attleboro, RI/MA", add
label define metareadlbl 6520 "Provo-Orem, UT", add
label define metareadlbl 6560 "Pueblo, CO", add
label define metareadlbl 6580 "Punta Gorda, FL", add
label define metareadlbl 6600 "Racine, WI", add
label define metareadlbl 6640 "Raleigh-Durham, NC", add
label define metareadlbl 6641 "Durham, NC", add
label define metareadlbl 6660 "Rapid City, SD", add
label define metareadlbl 6680 "Reading, PA", add
label define metareadlbl 6690 "Redding, CA", add
label define metareadlbl 6720 "Reno, NV", add
label define metareadlbl 6740 "Richland-Kennewick-Pasco, WA", add
label define metareadlbl 6760 "Richmond-Petersburg, VA", add
label define metareadlbl 6761 "Petersburg-Colonial Heights, VA", add
label define metareadlbl 6780 "Riverside-San Bernadino, CA", add
label define metareadlbl 6781 "San Bernadino, CA", add
label define metareadlbl 6800 "Roanoke, VA", add
label define metareadlbl 6820 "Rochester, MN", add
label define metareadlbl 6840 "Rochester, NY", add
label define metareadlbl 6880 "Rockford, IL", add
label define metareadlbl 6895 "Rocky Mount, NC", add
label define metareadlbl 6920 "Sacramento, CA", add
label define metareadlbl 6960 "Saginaw-Bay City-Midland, MI", add
label define metareadlbl 6961 "Bay City, MI", add
label define metareadlbl 6980 "St. Cloud, MN", add
label define metareadlbl 7000 "St. Joseph, MO", add
label define metareadlbl 7040 "St. Louis, MO-IL", add
label define metareadlbl 7080 "Salem, OR", add
label define metareadlbl 7120 "Salinas-Sea Side-Monterey, CA", add
label define metareadlbl 7140 "Salisbury-Concord, NC", add
label define metareadlbl 7160 "Salt Lake City-Ogden, UT", add
label define metareadlbl 7161 "Ogden", add
label define metareadlbl 7200 "San Angelo, TX", add
label define metareadlbl 7240 "San Antonio, TX", add
label define metareadlbl 7320 "San Diego, CA", add
label define metareadlbl 7360 "San Francisco-Oakland-Vallejo, CA", add
label define metareadlbl 7361 "Oakland, CA", add
label define metareadlbl 7362 "Vallejo-Fairfield-Napa, CA", add
label define metareadlbl 7400 "San Jose, CA", add
label define metareadlbl 7440 "San Juan-Bayamon, PR", add
label define metareadlbl 7460 "San Luis Obispo-Atascad-P Robles, CA", add
label define metareadlbl 7470 "Santa Barbara-Santa Maria-Lompoc, CA", add
label define metareadlbl 7480 "Santa Cruz, CA", add
label define metareadlbl 7490 "Santa Fe, NM", add
label define metareadlbl 7500 "Santa Rosa-Petaluma, CA", add
label define metareadlbl 7510 "Sarasota, FL", add
label define metareadlbl 7520 "Savannah, GA", add
label define metareadlbl 7560 "Scranton-Wilkes-Barre, PA", add
label define metareadlbl 7561 "Wilkes-Barre-Hazelton, PA", add
label define metareadlbl 7600 "Seattle-Everett, WA", add
label define metareadlbl 7610 "Sharon, PA", add
label define metareadlbl 7620 "Sheboygan, WI", add
label define metareadlbl 7640 "Sherman-Denison, TX", add
label define metareadlbl 7680 "Shreveport, LA", add
label define metareadlbl 7720 "Sioux City, IA/NE", add
label define metareadlbl 7760 "Sioux Falls, SD", add
label define metareadlbl 7800 "South Bend-Mishawaka, IN", add
label define metareadlbl 7840 "Spokane, WA", add
label define metareadlbl 7880 "Springfield, IL", add
label define metareadlbl 7920 "Springfield, MO", add
label define metareadlbl 8000 "Springfield-Holyoke-Chicopee, MA", add
label define metareadlbl 8040 "Stamford, CT", add
label define metareadlbl 8050 "State College, PA", add
label define metareadlbl 8080 "Steubenville-Weirton,OH/WV", add
label define metareadlbl 8120 "Stockton, CA", add
label define metareadlbl 8140 "Sumter, SC", add
label define metareadlbl 8160 "Syracuse, NY", add
label define metareadlbl 8200 "Tacoma, WA", add
label define metareadlbl 8240 "Tallahassee, FL", add
label define metareadlbl 8280 "Tampa-St. Petersburg-Clearwater, FL", add
label define metareadlbl 8320 "Terre Haute, IN", add
label define metareadlbl 8360 "Texarkana, TX/AR", add
label define metareadlbl 8400 "Toledo, OH/MI", add
label define metareadlbl 8440 "Topeka, KS", add
label define metareadlbl 8480 "Trenton, NJ", add
label define metareadlbl 8520 "Tucson, AZ", add
label define metareadlbl 8560 "Tulsa, OK", add
label define metareadlbl 8600 "Tuscaloosa, AL", add
label define metareadlbl 8640 "Tyler, TX", add
label define metareadlbl 8680 "Utica-Rome, NY", add
label define metareadlbl 8730 "Ventura-Oxnard-Simi Valley, CA", add
label define metareadlbl 8750 "Victoria, TX", add
label define metareadlbl 8760 "Vineland-Milville-Bridgetown, NJ", add
label define metareadlbl 8780 "Visalia-Tulare-Porterville, CA", add
label define metareadlbl 8800 "Waco, TX", add
label define metareadlbl 8840 "Washington, DC/MD/VA", add
label define metareadlbl 8880 "Waterbury, CT", add
label define metareadlbl 8920 "Waterloo-Cedar Falls, IA", add
label define metareadlbl 8940 "Wausau, WI", add
label define metareadlbl 8960 "West Palm Beach-Boca Raton-Delray Beach, FL", add
label define metareadlbl 9000 "Wheeling, WV/OH", add
label define metareadlbl 9040 "Wichita, KS", add
label define metareadlbl 9080 "Wichita Falls, TX", add
label define metareadlbl 9140 "Williamsport, PA", add
label define metareadlbl 9160 "Wilmington, DE/NJ/MD", add
label define metareadlbl 9200 "Wilmington, NC", add
label define metareadlbl 9240 "Worcester, MA", add
label define metareadlbl 9260 "Yakima, WA", add
label define metareadlbl 9270 "Yolo, CA", add
label define metareadlbl 9280 "York, PA", add
label define metareadlbl 9320 "Youngstown-Warren, OH-PA", add
label define metareadlbl 9340 "Yuba City, CA", add
label define metareadlbl 9360 "Yuma, AZ", add
label values metaread metareadlbl

label define citydlbl 0000 "Not in identifiable city (or size group)", add
label define citydlbl 0005 "Adams, MA", add
label define citydlbl 0010 "Akron, OH", add
label define citydlbl 0030 "Alameda, CA", add
label define citydlbl 0050 "Albany, NY", add
label define citydlbl 0070 "Albuquerque, NM", add
label define citydlbl 0090 "Alexandria, VA", add
label define citydlbl 0100 "Alhambra, CA", add
label define citydlbl 0110 "Allegheny, PA", add
label define citydlbl 0120 "Aliquippa, PA", add
label define citydlbl 0130 "Allentown, PA", add
label define citydlbl 0140 "Alton, IL", add
label define citydlbl 0150 "Altoona, PA", add
label define citydlbl 0160 "Amarillo, TX", add
label define citydlbl 0170 "Amsterdam, NY", add
label define citydlbl 0190 "Anaheim, CA", add
label define citydlbl 0210 "Anchorage, AK", add
label define citydlbl 0230 "Anderson, IN", add
label define citydlbl 0250 "Andover, MA", add
label define citydlbl 0270 "Ann Arbor, MI", add
label define citydlbl 0280 "Appleton, WI", add
label define citydlbl 0290 "Arlington, TX", add
label define citydlbl 0310 "Arlington, VA", add
label define citydlbl 0330 "Asheville, NC", add
label define citydlbl 0340 "Ashland, KY", add
label define citydlbl 0350 "Atlanta, GA", add
label define citydlbl 0370 "Atlantic City, NJ", add
label define citydlbl 0390 "Auburn, NY", add
label define citydlbl 0410 "Augusta, GA", add
label define citydlbl 0430 "Augusta, ME", add
label define citydlbl 0450 "Aurora, CO", add
label define citydlbl 0470 "Aurora, IL", add
label define citydlbl 0490 "Austin, TX", add
label define citydlbl 0510 "Bakersfield, CA", add
label define citydlbl 0530 "Baltimore, MD", add
label define citydlbl 0550 "Bangor, ME", add
label define citydlbl 0570 "Bath, ME", add
label define citydlbl 0590 "Baton Rouge, LA", add
label define citydlbl 0610 "Battle Creek, MI", add
label define citydlbl 0630 "Bay City, MI", add
label define citydlbl 0640 "Bayamon, PR", add
label define citydlbl 0650 "Bayonne, NJ", add
label define citydlbl 0660 "Belleville, IL", add
label define citydlbl 0670 "Beaumont, TX", add
label define citydlbl 0680 "Bellevue, WA", add
label define citydlbl 0690 "Bellingham, WA", add
label define citydlbl 0700 "Belleville, NJ", add
label define citydlbl 0710 "Berkeley, CA", add
label define citydlbl 0720 "Berwyn, IL", add
label define citydlbl 0730 "Bethlehem, PA", add
label define citydlbl 0740 "Biddeford, ME", add
label define citydlbl 0750 "Binghamton, NY", add
label define citydlbl 0760 "Beverly, MA", add
label define citydlbl 0770 "Birmingham, AL", add
label define citydlbl 0780 "Bloomfield, NJ", add
label define citydlbl 0790 "Bloomington, IL", add
label define citydlbl 0800 "Boise, ID", add
label define citydlbl 0810 "Boston, MA", add
label define citydlbl 0830 "Bridgeport, CT", add
label define citydlbl 0850 "Brockton, MA", add
label define citydlbl 0870 "Brookline, MA", add
label define citydlbl 0880 "Brownsville, TX", add
label define citydlbl 0890 "Buffalo, NY", add
label define citydlbl 0900 "Burlington, IA", add
label define citydlbl 0905 "Burlington, VT", add
label define citydlbl 0910 "Butte, MT", add
label define citydlbl 0920 "Burbank, CA", add
label define citydlbl 0930 "Cambridge, MA", add
label define citydlbl 0950 "Camden, NJ", add
label define citydlbl 0970 "Camden, NY", add
label define citydlbl 0990 "Canton, OH", add
label define citydlbl 1000 "Cape Coral, FL", add
label define citydlbl 1010 "Cedar Rapids, IA", add
label define citydlbl 1020 "Central Falls, RI", add
label define citydlbl 1030 "Charlestown, MA", add
label define citydlbl 1050 "Charleston, SC", add
label define citydlbl 1060 "Carolina, PR", add
label define citydlbl 1070 "Charleston, WV", add
label define citydlbl 1090 "Charlotte, NC", add
label define citydlbl 1110 "Chattanooga, TN", add
label define citydlbl 1130 "Chelsea, MA", add
label define citydlbl 1150 "Chesapeake, VA", add
label define citydlbl 1170 "Chester, PA", add
label define citydlbl 1190 "Chicago, IL", add
label define citydlbl 1210 "Chicopee, MA", add
label define citydlbl 1230 "Chillicothe, OH", add
label define citydlbl 1250 "Chula Vista, CA", add
label define citydlbl 1270 "Cicero, IL", add
label define citydlbl 1290 "Cincinnati, OH", add
label define citydlbl 1310 "Clarksburg, WV", add
label define citydlbl 1330 "Cleveland, OH", add
label define citydlbl 1340 "Cleveland Heights, OH", add
label define citydlbl 1350 "Clifton, NJ", add
label define citydlbl 1370 "Clinton, IA", add
label define citydlbl 1390 "Colorado Springs, CO", add
label define citydlbl 1400 "Cohoes, NY", add
label define citydlbl 1410 "Columbia, SC", add
label define citydlbl 1420 "Columbia City, IN", add
label define citydlbl 1430 "Columbus, GA", add
label define citydlbl 1450 "Columbus, OH", add
label define citydlbl 1470 "Concord, CA", add
label define citydlbl 1490 "Concord, NH", add
label define citydlbl 1500 "Corona, CA", add
label define citydlbl 1510 "Council Bluffs, IA", add
label define citydlbl 1520 "Corpus Christi, TX", add
label define citydlbl 1530 "Covington, KY", add
label define citydlbl 1540 "Costa Mesa, CA", add
label define citydlbl 1550 "Cranston, RI", add
label define citydlbl 1570 "Cumberland, MD", add
label define citydlbl 1590 "Dallas, TX", add
label define citydlbl 1610 "Danvers, MA", add
label define citydlbl 1630 "Danville, IL", add
label define citydlbl 1650 "Davenport, IA", add
label define citydlbl 1670 "Dayton, OH", add
label define citydlbl 1680 "Dearborn, MI", add
label define citydlbl 1690 "Decatur, IL", add
label define citydlbl 1710 "Denver, CO", add
label define citydlbl 1730 "Des Moines, IA", add
label define citydlbl 1750 "Detroit, MI", add
label define citydlbl 1770 "Dorchester, MA", add
label define citydlbl 1790 "Dover, NH", add
label define citydlbl 1800 "Downey, CA", add
label define citydlbl 1810 "Dubuque, IA", add
label define citydlbl 1830 "Duluth, MN", add
label define citydlbl 1850 "Durham, NC", add
label define citydlbl 1870 "East Chicago, IN", add
label define citydlbl 1890 "East Cleveland, OH", add
label define citydlbl 1910 "East Los Angeles, CA", add
label define citydlbl 1930 "East Orange, NJ", add
label define citydlbl 1940 "East Saginaw, MI", add
label define citydlbl 1950 "East St. Louis, IL", add
label define citydlbl 1970 "Easton, PA", add
label define citydlbl 1990 "El Monte, CA", add
label define citydlbl 2010 "El Paso, TX", add
label define citydlbl 2030 "Elgin, IL", add
label define citydlbl 2040 "Elyria, OH", add
label define citydlbl 2050 "Elizabeth, NJ", add
label define citydlbl 2060 "Elkhart, IN", add
label define citydlbl 2070 "Elmira, NY", add
label define citydlbl 2080 "Enid, OK", add
label define citydlbl 2090 "Erie, PA", add
label define citydlbl 2110 "Escondido, CA", add
label define citydlbl 2130 "Eugene, OR", add
label define citydlbl 2150 "Evanston, IL", add
label define citydlbl 2170 "Evansville, IN", add
label define citydlbl 2190 "Everett, MA", add
label define citydlbl 2210 "Everett, WA", add
label define citydlbl 2220 "Fargo, ND", add
label define citydlbl 2230 "Fall River, MA", add
label define citydlbl 2240 "Fayetteville, NC", add
label define citydlbl 2250 "Fitchburg, MA", add
label define citydlbl 2260 "Fontana, CA", add
label define citydlbl 2270 "Flint, MI", add
label define citydlbl 2280 "Fond du Lac, WI", add
label define citydlbl 2290 "Fort Lauderdale, FL", add
label define citydlbl 2300 "Fort Collins, CO", add
label define citydlbl 2310 "Fort Smith, AR", add
label define citydlbl 2330 "Fort Wayne, IN", add
label define citydlbl 2350 "Fort Worth, TX", add
label define citydlbl 2370 "Fresno, CA", add
label define citydlbl 2390 "Fullerton, CA", add
label define citydlbl 2400 "Galesburg, IL", add
label define citydlbl 2410 "Galveston, TX", add
label define citydlbl 2430 "Garden Grove, CA", add
label define citydlbl 2440 "Garfield, NJ", add
label define citydlbl 2450 "Garland, TX", add
label define citydlbl 2470 "Gary, IN", add
label define citydlbl 2490 "Glendale, CA", add
label define citydlbl 2510 "Gloucester, MA", add
label define citydlbl 2520 "Granite City, IL", add
label define citydlbl 2530 "Grand Rapids, MI", add
label define citydlbl 2540 "Great Falls, MT", add
label define citydlbl 2550 "Green Bay, WI", add
label define citydlbl 2570 "Greensboro, NC", add
label define citydlbl 2580 "Guynabo, PR", add
label define citydlbl 2590 "Hagerstown, MD", add
label define citydlbl 2610 "Hamilton, OH", add
label define citydlbl 2630 "Hammond, IN", add
label define citydlbl 2650 "Hampton, VA", add
label define citydlbl 2670 "Hamtramck Village, MI", add
label define citydlbl 2680 "Hannibal, MO", add
label define citydlbl 2690 "Harrisburg, PA", add
label define citydlbl 2710 "Hartford, CT", add
label define citydlbl 2730 "Haverhill, MA", add
label define citydlbl 2750 "Hazleton, PA", add
label define citydlbl 2770 "Hialeah, FL", add
label define citydlbl 2780 "High Point, NC", add
label define citydlbl 2790 "Highland Park, MI", add
label define citydlbl 2810 "Hoboken, NJ", add
label define citydlbl 2830 "Hollywood, FL", add
label define citydlbl 2850 "Holyoke, MA", add
label define citydlbl 2870 "Honolulu, HI", add
label define citydlbl 2890 "Houston, TX", add
label define citydlbl 2910 "Huntington, WV", add
label define citydlbl 2930 "Huntingon Beach, CA", add
label define citydlbl 2950 "Huntsville, AL", add
label define citydlbl 2960 "Hutchinson, KS", add
label define citydlbl 2970 "Independence, MO", add
label define citydlbl 2990 "Indianapolis, IN", add
label define citydlbl 3010 "Inglewood, CA", add
label define citydlbl 3020 "Irvine, CA", add
label define citydlbl 3030 "Irving, TX", add
label define citydlbl 3050 "Irvington, NJ", add
label define citydlbl 3070 "Jackson, MI", add
label define citydlbl 3090 "Jackson, MS", add
label define citydlbl 3110 "Jacksonville, FL", add
label define citydlbl 3130 "Jamestown , NY", add
label define citydlbl 3150 "Jersey City, NJ", add
label define citydlbl 3160 "Johnson City, TN", add
label define citydlbl 3170 "Johnstown, PA", add
label define citydlbl 3190 "Joliet, IL", add
label define citydlbl 3210 "Joplin, MO", add
label define citydlbl 3230 "Kalamazoo, MI", add
label define citydlbl 3250 "Kansas City, KS", add
label define citydlbl 3260 "Kansas City, MO", add
label define citydlbl 3270 "Kearny, NJ", add
label define citydlbl 3290 "Kenosha, WI", add
label define citydlbl 3310 "Kingston, NY", add
label define citydlbl 3330 "Knoxville, TN", add
label define citydlbl 3350 "Kokomo, IN", add
label define citydlbl 3370 "La Crosse, WI", add
label define citydlbl 3380 "Lafayette, IL", add
label define citydlbl 3390 "Lafayette, LA", add
label define citydlbl 3410 "Lakewood, CO", add
label define citydlbl 3430 "Lakewood, OH", add
label define citydlbl 3440 "Lancaster, CA", add
label define citydlbl 3450 "Lancaster, PA", add
label define citydlbl 3470 "Lansing, MI", add
label define citydlbl 3480 "Laredo, TX", add
label define citydlbl 3490 "Las Vegas, NV", add
label define citydlbl 3510 "Lawrence, MA", add
label define citydlbl 3520 "Leavenworth, KS", add
label define citydlbl 3530 "Lehigh, PA", add
label define citydlbl 3540 "Lebanon, PA", add
label define citydlbl 3550 "Lewiston, ME", add
label define citydlbl 3570 "Lexington, KY", add
label define citydlbl 3590 "Lexington-Fayette, KY", add
label define citydlbl 3610 "Lima, OH", add
label define citydlbl 3630 "Lincoln, NE", add
label define citydlbl 3650 "Little Rock, AR", add
label define citydlbl 3670 "Livonia, MI", add
label define citydlbl 3680 "Lockport, NY", add
label define citydlbl 3690 "Long Beach, CA", add
label define citydlbl 3710 "Lorain, OH", add
label define citydlbl 3730 "Los Angeles, CA", add
label define citydlbl 3750 "Louisville, KY", add
label define citydlbl 3770 "Lowell, MA", add
label define citydlbl 3790 "Lynchburg, VA", add
label define citydlbl 3810 "Lynn, MA", add
label define citydlbl 3830 "Macon, GA", add
label define citydlbl 3850 "Madison, IN", add
label define citydlbl 3870 "Madison, WI", add
label define citydlbl 3890 "Malden, MA", add
label define citydlbl 3910 "Manchester, NH", add
label define citydlbl 3930 "Mansfield, OH", add
label define citydlbl 3940 "Maywood, IL", add
label define citydlbl 3950 "Marion, OH", add
label define citydlbl 3960 "McAllen, TX", add
label define citydlbl 3970 "McKeesport, PA", add
label define citydlbl 3990 "Medford, MA", add
label define citydlbl 4010 "Memphis, TN", add
label define citydlbl 4030 "Meriden, CT", add
label define citydlbl 4040 "Meridian, MS", add
label define citydlbl 4050 "Mesa, AZ", add
label define citydlbl 4070 "Mesquite, TX", add
label define citydlbl 4090 "Metairie, LA", add
label define citydlbl 4110 "Miami, FL", add
label define citydlbl 4120 "Michigan City, IN", add
label define citydlbl 4130 "Milwaukee, WI", add
label define citydlbl 4150 "Minneapolis, MN", add
label define citydlbl 4160 "Mishawaka, IN", add
label define citydlbl 4170 "Mobile, AL", add
label define citydlbl 4190 "Modesto, CA", add
label define citydlbl 4210 "Moline, IL", add
label define citydlbl 4230 "Montclair, NJ", add
label define citydlbl 4250 "Montgomery, AL", add
label define citydlbl 4270 "Moreno Valley, CA", add
label define citydlbl 4290 "Mount Vernon, NY", add
label define citydlbl 4310 "Muncie, IN", add
label define citydlbl 4330 "Muskegon, MI", add
label define citydlbl 4350 "Muskogee, OK", add
label define citydlbl 4370 "Nantucket, MA", add
label define citydlbl 4390 "Nashua, NH", add
label define citydlbl 4410 "Nashville-Davidson, TN", add
label define citydlbl 4411 "Nashville, TN", add
label define citydlbl 4430 "New Albany, IN", add
label define citydlbl 4450 "New Bedford, MA", add
label define citydlbl 4470 "New Britain, CT", add
label define citydlbl 4490 "New Brunswick, NJ", add
label define citydlbl 4510 "New Castle, PA", add
label define citydlbl 4530 "New Haven, CT", add
label define citydlbl 4550 "New London, CT", add
label define citydlbl 4570 "New Orleans, LA", add
label define citydlbl 4590 "New Rochelle, NY", add
label define citydlbl 4610 "New York, NY", add
label define citydlbl 4611 "Brooklyn in census years before 1900/Bronx County in 1980, NY", add
label define citydlbl 4630 "Newark, NJ", add
label define citydlbl 4650 "Newark, OH", add
label define citydlbl 4670 "Newburgh, NY", add
label define citydlbl 4690 "Newburyport, MA", add
label define citydlbl 4710 "Newport, KY", add
label define citydlbl 4730 "Newport, RI", add
label define citydlbl 4750 "Newport News, VA", add
label define citydlbl 4770 "Newton, MA", add
label define citydlbl 4790 "Niagara Falls, NY", add
label define citydlbl 4810 "Norfolk, VA", add
label define citydlbl 4820 "North Las Vegas, NV", add
label define citydlbl 4830 "Norristown Borough, PA", add
label define citydlbl 4840 "Northampton, MA", add
label define citydlbl 4850 "North Providence, RI", add
label define citydlbl 4860 "Norwalk, CA", add
label define citydlbl 4870 "Norwalk, CT", add
label define citydlbl 4890 "Norwich, CT", add
label define citydlbl 4900 "Norwood, OH", add
label define citydlbl 4910 "Oak Park Village", add
label define citydlbl 4930 "Oakland, CA", add
label define citydlbl 4950 "Oceanside, CA", add
label define citydlbl 4970 "Ogden, UT", add
label define citydlbl 4990 "Oklahoma City, OK", add
label define citydlbl 5010 "Omaha, NE", add
label define citydlbl 5030 "Ontario, CA", add
label define citydlbl 5040 "Orange, CA", add
label define citydlbl 5050 "Orange, NJ", add
label define citydlbl 5070 "Orlando, FL", add
label define citydlbl 5090 "Oshkosh, WI", add
label define citydlbl 5110 "Oswego, NY", add
label define citydlbl 5130 "Oxnard, CA", add
label define citydlbl 5140 "Palmdale, CA", add
label define citydlbl 5150 "Pasadena, CA", add
label define citydlbl 5170 "Pasadena, TX", add
label define citydlbl 5180 "Paducah, KY", add
label define citydlbl 5190 "Passaic, NJ", add
label define citydlbl 5210 "Paterson, NJ", add
label define citydlbl 5230 "Pawtucket, RI", add
label define citydlbl 5250 "Pensacola, FL (1920)", add
label define citydlbl 5270 "Peoria, IL", add
label define citydlbl 5290 "Perth Amboy, NJ", add
label define citydlbl 5310 "Petersburg, VA", add
label define citydlbl 5330 "Philadelphia, PA", add
label define citydlbl 5331 "Kensington", add
label define citydlbl 5332 "Mayamensing", add
label define citydlbl 5333 "Northern Liberties", add
label define citydlbl 5334 "Southwark", add
label define citydlbl 5335 "Spring Garden", add
label define citydlbl 5350 "Phoenix, AZ", add
label define citydlbl 5370 "Pittsburgh, PA", add
label define citydlbl 5390 "Pittsfield, MA", add
label define citydlbl 5410 "Plainfield, NJ", add
label define citydlbl 5430 "Plano, TX", add
label define citydlbl 5450 "Pomona, CA", add
label define citydlbl 5460 "Ponce, PR", add
label define citydlbl 5470 "Pontiac, MI", add
label define citydlbl 5480 "Port Arthur, TX", add
label define citydlbl 5490 "Port Huron, MI", add
label define citydlbl 5510 "Portland, ME", add
label define citydlbl 5530 "Portland, OR", add
label define citydlbl 5550 "Portsmouth, NH", add
label define citydlbl 5570 "Portsmouth, OH", add
label define citydlbl 5590 "Portsmouth, VA", add
label define citydlbl 5610 "Pottsville, PA", add
label define citydlbl 5630 "Poughkeepsie, NY", add
label define citydlbl 5650 "Providence, RI", add
label define citydlbl 5660 "Provo, UT", add
label define citydlbl 5670 "Pueblo, CO", add
label define citydlbl 5690 "Quincy, IL", add
label define citydlbl 5710 "Quincy, MA", add
label define citydlbl 5730 "Racine, WI", add
label define citydlbl 5750 "Raleigh, NC", add
label define citydlbl 5770 "Rancho Cucamonga, CA", add
label define citydlbl 5790 "Reading, PA", add
label define citydlbl 5810 "Reno, NV", add
label define citydlbl 5830 "Revere, MA", add
label define citydlbl 5850 "Richmond, IN", add
label define citydlbl 5870 "Richmond, VA", add
label define citydlbl 5890 "Riverside, CA", add
label define citydlbl 5910 "Roanoke, VA", add
label define citydlbl 5930 "Rochester, NY", add
label define citydlbl 5950 "Rock Island, IL", add
label define citydlbl 5970 "Rockford, IL", add
label define citydlbl 5990 "Rome, NY", add
label define citydlbl 6010 "Roxbury, MA", add
label define citydlbl 6030 "Sacramento, CA", add
label define citydlbl 6050 "Saginaw, MI", add
label define citydlbl 6070 "Saint Joseph, MO", add
label define citydlbl 6090 "Saint Louis, MO", add
label define citydlbl 6110 "Saint Paul, MN", add
label define citydlbl 6130 "Saint Petersburg, FL", add
label define citydlbl 6150 "Salem, MA", add
label define citydlbl 6170 "Salem, OR", add
label define citydlbl 6190 "Salinas, CA", add
label define citydlbl 6210 "Salt Lake City, UT", add
label define citydlbl 6220 "San Angelo, TX", add
label define citydlbl 6230 "San Antonio, TX", add
label define citydlbl 6250 "San Bernadino, CA", add
label define citydlbl 6260 "San Buenaventura (Ventura), CA", add
label define citydlbl 6270 "San Diego, CA", add
label define citydlbl 6280 "Sandusky, OH", add
label define citydlbl 6290 "San Francisco, CA", add
label define citydlbl 6300 "San Juan, PR", add
label define citydlbl 6310 "San Jose, CA", add
label define citydlbl 6320 "Santa Barbara, CA", add
label define citydlbl 6330 "Santa Ana, CA", add
label define citydlbl 6340 "Santa Clarita, CA", add
label define citydlbl 6350 "Santa Rosa, CA", add
label define citydlbl 6360 "Santa Monica, CA", add
label define citydlbl 6370 "Savannah, GA", add
label define citydlbl 6390 "Schenectedy, NY", add
label define citydlbl 6410 "Scranton, PA", add
label define citydlbl 6430 "Seattle, WA", add
label define citydlbl 6440 "Sharon, PA", add
label define citydlbl 6450 "Sheboygan, WI", add
label define citydlbl 6470 "Shenandoah Borough, PA", add
label define citydlbl 6490 "Shreveport, LA", add
label define citydlbl 6500 "Simi Valley, CA", add
label define citydlbl 6510 "Sioux City, IA", add
label define citydlbl 6530 "Sioux Falls, SD", add
label define citydlbl 6550 "Smithfield, RI (1850)", add
label define citydlbl 6570 "Somerville, MA", add
label define citydlbl 6590 "South Bend, IN", add
label define citydlbl 6610 "South Omaha, NE", add
label define citydlbl 6620 "Spartanburg, SC", add
label define citydlbl 6630 "Spokane, WA", add
label define citydlbl 6650 "Springfield, IL", add
label define citydlbl 6670 "Springfield, MA", add
label define citydlbl 6690 "Springfield, MO", add
label define citydlbl 6710 "Springfield, OH", add
label define citydlbl 6730 "Stamford, CT", add
label define citydlbl 6750 "Sterling Heights, MI", add
label define citydlbl 6770 "Steubenville, OH", add
label define citydlbl 6790 "Stockton, CA", add
label define citydlbl 6810 "Sunnyvale, CA", add
label define citydlbl 6830 "Superior, WI", add
label define citydlbl 6850 "Syracuse, NY", add
label define citydlbl 6870 "Tacoma, WA", add
label define citydlbl 6890 "Tampa, FL", add
label define citydlbl 6910 "Taunton, MA", add
label define citydlbl 6930 "Tempe, AZ", add
label define citydlbl 6950 "Terre Haute, IN", add
label define citydlbl 6960 "Thousand Oaks, CA", add
label define citydlbl 6970 "Toledo, OH", add
label define citydlbl 6990 "Topeka, KS", add
label define citydlbl 7000 "Torrance, CA", add
label define citydlbl 7010 "Trenton, NJ", add
label define citydlbl 7030 "Troy, NY", add
label define citydlbl 7050 "Tucson, AZ", add
label define citydlbl 7070 "Tulsa, OK", add
label define citydlbl 7080 "Union City, NJ", add
label define citydlbl 7090 "Utica, NY", add
label define citydlbl 7100 "Vancouver, WA", add
label define citydlbl 7110 "Vallejo, CA", add
label define citydlbl 7120 "Vicksburg, MS", add
label define citydlbl 7130 "Virginia Beach, VA", add
label define citydlbl 7140 "University City, MO", add
label define citydlbl 7150 "Waco, TX", add
label define citydlbl 7170 "Waltham, MA", add
label define citydlbl 7180 "Warren, MI", add
label define citydlbl 7190 "Warren, OH", add
label define citydlbl 7210 "Warwick Town, RI", add
label define citydlbl 7230 "Washington, DC", add
label define citydlbl 7231 "Georgetown, DC", add
label define citydlbl 7240 "Waukegan, IL", add
label define citydlbl 7250 "Waterbury, CT", add
label define citydlbl 7270 "Waterloo, IA", add
label define citydlbl 7290 "Waterloo, NY", add
label define citydlbl 7310 "Watertown, NY", add
label define citydlbl 7320 "West Covina, CA", add
label define citydlbl 7330 "West Hoboken, NJ", add
label define citydlbl 7340 "West Allis, WI", add
label define citydlbl 7350 "West New York, NJ", add
label define citydlbl 7370 "West Troy, NY", add
label define citydlbl 7390 "Wheeling, WV", add
label define citydlbl 7400 "White Plains, NY", add
label define citydlbl 7410 "Wichita, KS", add
label define citydlbl 7430 "Wichita Falls, TX", add
label define citydlbl 7450 "Wilkes-Barre, PA", add
label define citydlbl 7460 "Wilkinsburg, PA", add
label define citydlbl 7470 "Williamsport, PA", add
label define citydlbl 7490 "Wilmington, DE", add
label define citydlbl 7510 "Wilmington, NC", add
label define citydlbl 7530 "Winston-Salem, NC", add
label define citydlbl 7550 "Woonsocket, RI", add
label define citydlbl 7570 "Worcester, MA", add
label define citydlbl 7590 "Yonkers, NY", add
label define citydlbl 7610 "York, PA", add
label define citydlbl 7630 "Youngstown, OH", add
label define citydlbl 7650 "Zanesville, OH", add
label define citydlbl 8100 "20,000-24,999", add
label define citydlbl 8105 "20,000-24,999 New England", add
label define citydlbl 8110 "10,000-19,999", add
label define citydlbl 8115 "10,000-19,999 New England", add
label define citydlbl 8120 "City 10,000 - 24,999", add
label define citydlbl 8125 "New England Town Over 10000+", add
label define citydlbl 8200 "City 8,000-9,999", add
label define citydlbl 8205 "New England Town 8,000-9999", add
label define citydlbl 8300 "City 5,000-7,999", add
label define citydlbl 8305 "New England Town 5,000-7999", add
label define citydlbl 8400 "City 4,000-4,999", add
label define citydlbl 8405 "New England Town  4,000-4,999", add
label define citydlbl 8500 "City 2,500-3,999", add
label define citydlbl 8505 "New England Town 2,500-3999", add
label define citydlbl 8600 "City 1,000-2,499", add
label define citydlbl 8605 "New England Town 1,000-2499", add
label define citydlbl 8700 "Rural - Under 1,000", add
label define citydlbl 8705 "Under 1,000 New England", add
label define citydlbl 8800 "Unincorporated", add
label define citydlbl 8810 "Military Reservation", add
label define citydlbl 8820 "Indian Reservation", add
label values cityd citydlbl

label values citypop citypoplbl

label values perwt perwtlbl

label define agelbl 000 "Less than 1 year old"
label define agelbl 001 "1", add
label define agelbl 002 "2", add
label define agelbl 003 "3", add
label define agelbl 004 "4", add
label define agelbl 005 "5", add
label define agelbl 006 "6", add
label define agelbl 007 "7", add
label define agelbl 008 "8", add
label define agelbl 009 "9", add
label define agelbl 010 "10", add
label define agelbl 011 "11", add
label define agelbl 012 "12", add
label define agelbl 013 "13", add
label define agelbl 014 "14", add
label define agelbl 015 "15", add
label define agelbl 016 "16", add
label define agelbl 017 "17", add
label define agelbl 018 "18", add
label define agelbl 019 "19", add
label define agelbl 020 "20", add
label define agelbl 021 "21", add
label define agelbl 022 "22", add
label define agelbl 023 "23", add
label define agelbl 024 "24", add
label define agelbl 025 "25", add
label define agelbl 026 "26", add
label define agelbl 027 "27", add
label define agelbl 028 "28", add
label define agelbl 029 "29", add
label define agelbl 030 "30", add
label define agelbl 031 "31", add
label define agelbl 032 "32", add
label define agelbl 033 "33", add
label define agelbl 034 "34", add
label define agelbl 035 "35", add
label define agelbl 036 "36", add
label define agelbl 037 "37", add
label define agelbl 038 "38", add
label define agelbl 039 "39", add
label define agelbl 040 "40", add
label define agelbl 041 "41", add
label define agelbl 042 "42", add
label define agelbl 043 "43", add
label define agelbl 044 "44", add
label define agelbl 045 "45", add
label define agelbl 046 "46", add
label define agelbl 047 "47", add
label define agelbl 048 "48", add
label define agelbl 049 "49", add
label define agelbl 050 "50", add
label define agelbl 051 "51", add
label define agelbl 052 "52", add
label define agelbl 053 "53", add
label define agelbl 054 "54", add
label define agelbl 055 "55", add
label define agelbl 056 "56", add
label define agelbl 057 "57", add
label define agelbl 058 "58", add
label define agelbl 059 "59", add
label define agelbl 060 "60", add
label define agelbl 061 "61", add
label define agelbl 062 "62", add
label define agelbl 063 "63", add
label define agelbl 064 "64", add
label define agelbl 065 "65", add
label define agelbl 066 "66", add
label define agelbl 067 "67", add
label define agelbl 068 "68", add
label define agelbl 069 "69", add
label define agelbl 070 "70", add
label define agelbl 071 "71", add
label define agelbl 072 "72", add
label define agelbl 073 "73", add
label define agelbl 074 "74", add
label define agelbl 075 "75", add
label define agelbl 076 "76", add
label define agelbl 077 "77", add
label define agelbl 078 "78", add
label define agelbl 079 "79", add
label define agelbl 080 "80", add
label define agelbl 081 "81", add
label define agelbl 082 "82", add
label define agelbl 083 "83", add
label define agelbl 084 "84", add
label define agelbl 085 "85", add
label define agelbl 086 "86", add
label define agelbl 087 "87", add
label define agelbl 088 "88", add
label define agelbl 089 "89", add
label define agelbl 090 "90 (90+ in 1980 and 1990)", add
label define agelbl 091 "91", add
label define agelbl 092 "92", add
label define agelbl 093 "93", add
label define agelbl 094 "94", add
label define agelbl 095 "95", add
label define agelbl 096 "96", add
label define agelbl 097 "97", add
label define agelbl 098 "98", add
label define agelbl 099 "99", add
label define agelbl 100 "100", add
label define agelbl 101 "101", add
label define agelbl 102 "102", add
label define agelbl 103 "103", add
label define agelbl 104 "104", add
label define agelbl 105 "105", add
label define agelbl 106 "106", add
label define agelbl 107 "107", add
label define agelbl 108 "108", add
label define agelbl 109 "109", add
label define agelbl 110 "110", add
label define agelbl 111 "111", add
label define agelbl 112 "112", add
label define agelbl 113 "113", add
label define agelbl 114 "114", add
label define agelbl 115 "115 (115+ in 1990s)", add
label define agelbl 116 "116", add
label define agelbl 117 "117", add
label define agelbl 118 "118", add
label define agelbl 119 "119", add
label define agelbl 120 "120", add
label define agelbl 121 "121", add
label define agelbl 122 "122", add
label define agelbl 123 "123", add
label define agelbl 124 "124", add
label define agelbl 125 "125", add
label define agelbl 126 "126", add
label values age agelbl

label define sexlbl 1 "Male"
label define sexlbl 2 "Female", add
label values sex sexlbl

label define bpldlbl 00100 "Alabama", add
label define bpldlbl 00200 "Alaska", add
label define bpldlbl 00400 "Arizona", add
label define bpldlbl 00500 "Arkansas", add
label define bpldlbl 00600 "California", add
label define bpldlbl 00800 "Colorado", add
label define bpldlbl 00900 "Connecticut", add
label define bpldlbl 01000 "Delaware", add
label define bpldlbl 01100 "District of Columbia", add
label define bpldlbl 01200 "Florida", add
label define bpldlbl 01300 "Georgia", add
label define bpldlbl 01500 "Hawaii", add
label define bpldlbl 01600 "Idaho", add
label define bpldlbl 01610 "Idaho Territory", add
label define bpldlbl 01700 "Illinois", add
label define bpldlbl 01800 "Indiana", add
label define bpldlbl 01900 "Iowa", add
label define bpldlbl 02000 "Kansas", add
label define bpldlbl 02100 "Kentucky", add
label define bpldlbl 02200 "Louisiana", add
label define bpldlbl 02300 "Maine", add
label define bpldlbl 02400 "Maryland", add
label define bpldlbl 02500 "Massachusetts", add
label define bpldlbl 02600 "Michigan", add
label define bpldlbl 02700 "Minnesota", add
label define bpldlbl 02800 "Mississippi", add
label define bpldlbl 02900 "Missouri", add
label define bpldlbl 03000 "Montana", add
label define bpldlbl 03100 "Nebraska", add
label define bpldlbl 03200 "Nevada", add
label define bpldlbl 03300 "New Hampshire", add
label define bpldlbl 03400 "New Jersey", add
label define bpldlbl 03500 "New Mexico", add
label define bpldlbl 03510 "New Mexico Territory", add
label define bpldlbl 03600 "New York", add
label define bpldlbl 03700 "North Carolina", add
label define bpldlbl 03800 "North Dakota", add
label define bpldlbl 03900 "Ohio", add
label define bpldlbl 04000 "Oklahoma", add
label define bpldlbl 04010 "Indian Territory", add
label define bpldlbl 04100 "Oregon", add
label define bpldlbl 04200 "Pennsylvania", add
label define bpldlbl 04400 "Rhode Island", add
label define bpldlbl 04500 "South Carolina", add
label define bpldlbl 04600 "South Dakota", add
label define bpldlbl 04610 "Dakota Territory", add
label define bpldlbl 04700 "Tennessee", add
label define bpldlbl 04800 "Texas", add
label define bpldlbl 04900 "Utah", add
label define bpldlbl 04910 "Utah Territory", add
label define bpldlbl 05000 "Vermont", add
label define bpldlbl 05100 "Virginia", add
label define bpldlbl 05300 "Washington", add
label define bpldlbl 05400 "West Virginia", add
label define bpldlbl 05500 "Wisconsin", add
label define bpldlbl 05600 "Wyoming", add
label define bpldlbl 05610 "Wyoming Territory", add
label define bpldlbl 09000 "Native American", add
label define bpldlbl 09900 "United States, ns", add
label define bpldlbl 10000 "American Samoa", add
label define bpldlbl 10010 "Samoa, 1940-1950", add
label define bpldlbl 10500 "Guam", add
label define bpldlbl 11000 "Puerto Rico", add
label define bpldlbl 11500 "U.S. Virgin Islands", add
label define bpldlbl 11510 "St. Croix", add
label define bpldlbl 11520 "St. John", add
label define bpldlbl 11530 "St. Thomas", add
label define bpldlbl 12000 "Other US Possessions:", add
label define bpldlbl 12010 "Johnston Atoll", add
label define bpldlbl 12020 "Midway Islands", add
label define bpldlbl 12030 "Wake Island", add
label define bpldlbl 12040 "Other US Caribbean Islands", add
label define bpldlbl 12041 "Navassa Island", add
label define bpldlbl 12050 "Other US Pacific Islands", add
label define bpldlbl 12051 "Baker Island", add
label define bpldlbl 12052 "Howland Island", add
label define bpldlbl 12053 "Jarvis Island", add
label define bpldlbl 12054 "Kingman Reef", add
label define bpldlbl 12055 "Palmyra Atoll", add
label define bpldlbl 12060 "Marshall Islands", add
label define bpldlbl 12090 "US outlying areas, ns", add
label define bpldlbl 12091 "US possessions, ns", add
label define bpldlbl 12092 "US territory, ns", add
label define bpldlbl 15000 "Canada", add
label define bpldlbl 15010 "English Canada", add
label define bpldlbl 15011 "British Columbia", add
label define bpldlbl 15013 "Alberta", add
label define bpldlbl 15015 "Saskatchewan", add
label define bpldlbl 15017 "Northwest", add
label define bpldlbl 15019 "Ruperts Land", add
label define bpldlbl 15020 "Manitoba", add
label define bpldlbl 15021 "Red River", add
label define bpldlbl 15030 "Ontario/Upper Canada", add
label define bpldlbl 15031 "Upper Canada", add
label define bpldlbl 15032 "Canada West", add
label define bpldlbl 15040 "New Brunswick", add
label define bpldlbl 15050 "Nova Scotia", add
label define bpldlbl 15051 "Cape Breton", add
label define bpldlbl 15052 "Halifax", add
label define bpldlbl 15060 "Prince Edward Island", add
label define bpldlbl 15070 "Newfoundland", add
label define bpldlbl 15080 "French Canada", add
label define bpldlbl 15081 "Quebec", add
label define bpldlbl 15082 "Lower Canada", add
label define bpldlbl 15083 "Canada East", add
label define bpldlbl 15500 "St. Pierre and Miquelon", add
label define bpldlbl 16000 "Atlantic Islands", add
label define bpldlbl 16010 "Bermuda", add
label define bpldlbl 16020 "Cape Verde", add
label define bpldlbl 16030 "Falkland Islands", add
label define bpldlbl 16040 "Greenland", add
label define bpldlbl 16050 "St. Helena and Ascension", add
label define bpldlbl 16060 "Canary Islands", add
label define bpldlbl 19900 "North America, ns", add
label define bpldlbl 20000 "Mexico", add
label define bpldlbl 21000 "Central America", add
label define bpldlbl 21010 "Belize/British Honduras", add
label define bpldlbl 21020 "Costa Rica", add
label define bpldlbl 21030 "El Salvador", add
label define bpldlbl 21040 "Guatemala", add
label define bpldlbl 21050 "Honduras", add
label define bpldlbl 21060 "Nicaragua", add
label define bpldlbl 21070 "Panama", add
label define bpldlbl 21071 "Canal Zone", add
label define bpldlbl 21090 "Central America, ns", add
label define bpldlbl 25000 "Cuba", add
label define bpldlbl 26000 "West Indies", add
label define bpldlbl 26010 "Dominican Republic", add
label define bpldlbl 26020 "Haiti", add
label define bpldlbl 26030 "Jamaica", add
label define bpldlbl 26040 "British West Indies", add
label define bpldlbl 26041 "Anguilla", add
label define bpldlbl 26042 "Antigua-Barbuda", add
label define bpldlbl 26043 "Bahamas", add
label define bpldlbl 26044 "Barbados", add
label define bpldlbl 26045 "British Virgin Islands", add
label define bpldlbl 26046 "Anegada", add
label define bpldlbl 26047 "Cooper", add
label define bpldlbl 26048 "Jost Van Dyke", add
label define bpldlbl 26049 "Peter", add
label define bpldlbl 26050 "Tortola", add
label define bpldlbl 26051 "Virgin Gorda", add
label define bpldlbl 26052 "Br. Virgin Islands, ns", add
label define bpldlbl 26053 "Cayman Islands", add
label define bpldlbl 26054 "Dominica", add
label define bpldlbl 26055 "Grenada", add
label define bpldlbl 26056 "Montserrat", add
label define bpldlbl 26057 "St. Kitts-Nevis", add
label define bpldlbl 26058 "St. Lucia", add
label define bpldlbl 26059 "St. Vincent", add
label define bpldlbl 26060 "Trinidad and Tobago", add
label define bpldlbl 26061 "Turks and Caicos", add
label define bpldlbl 26069 "British West Indies, ns", add
label define bpldlbl 26070 "Other West Indies", add
label define bpldlbl 26071 "Aruba", add
label define bpldlbl 26072 "Netherlands Antilles", add
label define bpldlbl 26073 "Bonaire", add
label define bpldlbl 26074 "Curacao", add
label define bpldlbl 26075 "Dutch St. Maarten", add
label define bpldlbl 26076 "Saba", add
label define bpldlbl 26077 "St. Eustatius", add
label define bpldlbl 26079 "Dutch Caribbean, ns", add
label define bpldlbl 26080 "French St. Maarten", add
label define bpldlbl 26081 "Guadeloupe", add
label define bpldlbl 26082 "Martinique", add
label define bpldlbl 26083 "St. Barthelemy", add
label define bpldlbl 26089 "French Caribbean, ns", add
label define bpldlbl 26090 "Antilles, n.s.", add
label define bpldlbl 26091 "Caribbean, ns", add
label define bpldlbl 26092 "Latin America, ns", add
label define bpldlbl 26093 "Leeward Islands, ns", add
label define bpldlbl 26094 "West Indies, ns", add
label define bpldlbl 26095 "Windward Islands, ns", add
label define bpldlbl 29999 "Americas, ns", add
label define bpldlbl 30000 "South America", add
label define bpldlbl 30005 "Argentina", add
label define bpldlbl 30010 "Bolivia", add
label define bpldlbl 30015 "Brazil", add
label define bpldlbl 30020 "Chile", add
label define bpldlbl 30025 "Colombia", add
label define bpldlbl 30030 "Ecuador", add
label define bpldlbl 30035 "French Guiana", add
label define bpldlbl 30040 "Guyana/British Guiana", add
label define bpldlbl 30045 "Paraguay", add
label define bpldlbl 30050 "Peru", add
label define bpldlbl 30055 "Suriname", add
label define bpldlbl 30060 "Uruguay", add
label define bpldlbl 30065 "Venezuela", add
label define bpldlbl 30090 "South America, ns", add
label define bpldlbl 30091 "South and Central America, n.s.", add
label define bpldlbl 40000 "Denmark", add
label define bpldlbl 40010 "Faeroe Islands", add
label define bpldlbl 40100 "Finland", add
label define bpldlbl 40200 "Iceland", add
label define bpldlbl 40300 "Lapland, ns", add
label define bpldlbl 40400 "Norway", add
label define bpldlbl 40410 "Svalbard and Jan Meyen", add
label define bpldlbl 40411 "Svalbard", add
label define bpldlbl 40412 "Jan Meyen", add
label define bpldlbl 40500 "Sweden", add
label define bpldlbl 41000 "England", add
label define bpldlbl 41010 "Channel Islands", add
label define bpldlbl 41011 "Guernsey", add
label define bpldlbl 41012 "Jersey", add
label define bpldlbl 41020 "Isle of Man", add
label define bpldlbl 41100 "Scotland", add
label define bpldlbl 41200 "Wales", add
label define bpldlbl 41300 "United Kingdom, ns", add
label define bpldlbl 41400 "Ireland", add
label define bpldlbl 41410 "Northern Ireland", add
label define bpldlbl 41900 "Northern Europe, ns", add
label define bpldlbl 42000 "Belgium", add
label define bpldlbl 42100 "France", add
label define bpldlbl 42110 "Alsace-Lorraine", add
label define bpldlbl 42111 "Alsace", add
label define bpldlbl 42112 "Lorraine", add
label define bpldlbl 42200 "Liechtenstein", add
label define bpldlbl 42300 "Luxembourg", add
label define bpldlbl 42400 "Monaco", add
label define bpldlbl 42500 "Netherlands", add
label define bpldlbl 42600 "Switerland", add
label define bpldlbl 42900 "Western Europe, ns", add
label define bpldlbl 43000 "Albania", add
label define bpldlbl 43100 "Andorra", add
label define bpldlbl 43200 "Gibraltar", add
label define bpldlbl 43300 "Greece", add
label define bpldlbl 43310 "Dodecanese Islands", add
label define bpldlbl 43320 "Turkey Greece", add
label define bpldlbl 43330 "Macedonia", add
label define bpldlbl 43400 "Italy", add
label define bpldlbl 43500 "Malta", add
label define bpldlbl 43600 "Portugal", add
label define bpldlbl 43610 "Azores", add
label define bpldlbl 43620 "Madeira Islands", add
label define bpldlbl 43630 "Cape Verde Islands", add
label define bpldlbl 43640 "St. Miguel", add
label define bpldlbl 43700 "San Marino", add
label define bpldlbl 43800 "Spain", add
label define bpldlbl 43900 "Vatican City", add
label define bpldlbl 44000 "Southern Europe, ns", add
label define bpldlbl 45000 "Austria", add
label define bpldlbl 45010 "Austria-Hungary", add
label define bpldlbl 45020 "Austria-Graz", add
label define bpldlbl 45030 "Austria-Linz", add
label define bpldlbl 45040 "Austria-Salzburg", add
label define bpldlbl 45050 "Austria-Tyrol", add
label define bpldlbl 45060 "Austria-Vienna", add
label define bpldlbl 45070 "Austria-Kaernsten", add
label define bpldlbl 45080 "Austria-Neustadt", add
label define bpldlbl 45100 "Bulgaria", add
label define bpldlbl 45200 "Czechoslovakia", add
label define bpldlbl 45210 "Bohemia", add
label define bpldlbl 45211 "Bohemia-Moravia", add
label define bpldlbl 45212 "Slovakia", add
label define bpldlbl 45213 "Czech Republic", add
label define bpldlbl 45300 "Germany", add
label define bpldlbl 45301 "Berlin", add
label define bpldlbl 45310 "West Germany", add
label define bpldlbl 45311 "Baden", add
label define bpldlbl 45312 "Bavaria", add
label define bpldlbl 45313 "Bremen", add
label define bpldlbl 45314 "Brunswick", add
label define bpldlbl 45315 "Hamburg", add
label define bpldlbl 45316 "Hanover", add
label define bpldlbl 45317 "Hessen", add
label define bpldlbl 45318 "Hessen Nassau", add
label define bpldlbl 45319 "Holstein", add
label define bpldlbl 45320 "Lippe", add
label define bpldlbl 45321 "Lubeck", add
label define bpldlbl 45322 "Oldenburg", add
label define bpldlbl 45323 "Rhine Province", add
label define bpldlbl 45324 "Schleswig", add
label define bpldlbl 45325 "Schleswig-Holstein", add
label define bpldlbl 45326 "Schwarzburg", add
label define bpldlbl 45327 "Waldeck", add
label define bpldlbl 45328 "West Berlin", add
label define bpldlbl 45329 "Westphalia", add
label define bpldlbl 45330 "Wurttemberg", add
label define bpldlbl 45331 "Frankfurt", add
label define bpldlbl 45332 "Saarland", add
label define bpldlbl 45333 "Nordrheim-Westfalen", add
label define bpldlbl 45340 "East Germany", add
label define bpldlbl 45341 "Anhalt", add
label define bpldlbl 45342 "Brandenburg", add
label define bpldlbl 45343 "East Berlin", add
label define bpldlbl 45344 "Mecklenburg", add
label define bpldlbl 45345 "Sachsen-Altenburg", add
label define bpldlbl 45346 "Sachsen-Coburg", add
label define bpldlbl 45347 "Sachsen-Gotha", add
label define bpldlbl 45348 "Sachsen-Meiningen", add
label define bpldlbl 45349 "Sachsen-Weimar-Eisenach", add
label define bpldlbl 45350 "Saxony", add
label define bpldlbl 45351 "Schwerin", add
label define bpldlbl 45352 "Strelitz", add
label define bpldlbl 45353 "Thuringian States", add
label define bpldlbl 45360 "Prussia, nec", add
label define bpldlbl 45361 "Hohenzollern", add
label define bpldlbl 45362 "Niedersachsen", add
label define bpldlbl 45400 "Hungary", add
label define bpldlbl 45500 "Poland", add
label define bpldlbl 45510 "Austrian Poland", add
label define bpldlbl 45511 "Galicia", add
label define bpldlbl 45520 "German Poland", add
label define bpldlbl 45521 "East Prussia", add
label define bpldlbl 45522 "Pomerania", add
label define bpldlbl 45523 "Posen", add
label define bpldlbl 45524 "Prussian Poland", add
label define bpldlbl 45525 "Silesia", add
label define bpldlbl 45526 "West Prussia", add
label define bpldlbl 45530 "Russian Poland", add
label define bpldlbl 45600 "Romania", add
label define bpldlbl 45610 "Transylvania", add
label define bpldlbl 45700 "Yugoslavia", add
label define bpldlbl 45710 "Croatia", add
label define bpldlbl 45720 "Montenegro", add
label define bpldlbl 45730 "Serbia", add
label define bpldlbl 45740 "Bosnia", add
label define bpldlbl 45750 "Dalmatia", add
label define bpldlbl 45760 "Slovonia", add
label define bpldlbl 45770 "Carniola", add
label define bpldlbl 45780 "Slovenia", add
label define bpldlbl 45790 "Kosovo", add
label define bpldlbl 45800 "Central Europe, ns", add
label define bpldlbl 45900 "Eastern Europe, ns", add
label define bpldlbl 46000 "Estonia", add
label define bpldlbl 46100 "Latvia", add
label define bpldlbl 46200 "Lithuania", add
label define bpldlbl 46300 "Baltic States, ns", add
label define bpldlbl 46500 "Other USSR/Russia", add
label define bpldlbl 46510 "Byelorussia", add
label define bpldlbl 46520 "Moldavia", add
label define bpldlbl 46521 "Bessarabia", add
label define bpldlbl 46530 "Ukraine", add
label define bpldlbl 46540 "Armenia", add
label define bpldlbl 46541 "Azerbaijan", add
label define bpldlbl 46542 "Georgia", add
label define bpldlbl 46543 "Kazakhstan", add
label define bpldlbl 46544 "Kirghizia", add
label define bpldlbl 46545 "Tadzhik", add
label define bpldlbl 46546 "Turkmenistan", add
label define bpldlbl 46547 "Uzbekistan", add
label define bpldlbl 46548 "Siberia", add
label define bpldlbl 46590 "USSR, ns", add
label define bpldlbl 49900 "Europe, ns.", add
label define bpldlbl 50000 "China", add
label define bpldlbl 50010 "Hong Kong", add
label define bpldlbl 50020 "Macau", add
label define bpldlbl 50030 "Mongolia", add
label define bpldlbl 50040 "Taiwan", add
label define bpldlbl 50100 "Japan", add
label define bpldlbl 50200 "Korea", add
label define bpldlbl 50210 "North Korea", add
label define bpldlbl 50220 "South Korea", add
label define bpldlbl 50900 "East Asia, ns", add
label define bpldlbl 51000 "Brunei", add
label define bpldlbl 51100 "Cambodia (Kampuchea)", add
label define bpldlbl 51200 "Indonesia", add
label define bpldlbl 51210 "East Indies", add
label define bpldlbl 51220 "East Timor", add
label define bpldlbl 51300 "Laos", add
label define bpldlbl 51400 "Malaysia", add
label define bpldlbl 51500 "Philippines", add
label define bpldlbl 51600 "Singapore", add
label define bpldlbl 51700 "Thailand", add
label define bpldlbl 51800 "Vietnam", add
label define bpldlbl 51900 "Southeast Asia, ns", add
label define bpldlbl 51910 "Indochina, ns", add
label define bpldlbl 52000 "Afghanistan", add
label define bpldlbl 52100 "India", add
label define bpldlbl 52110 "Bangladesh", add
label define bpldlbl 52120 "Bhutan", add
label define bpldlbl 52130 "Burma (Myanmar)", add
label define bpldlbl 52140 "Pakistan", add
label define bpldlbl 52150 "Sri Lanka (Ceylon)", add
label define bpldlbl 52200 "Iran", add
label define bpldlbl 52300 "Maldives", add
label define bpldlbl 52400 "Nepal", add
label define bpldlbl 53000 "Bahrain", add
label define bpldlbl 53100 "Cyprus", add
label define bpldlbl 53200 "Iraq", add
label define bpldlbl 53210 "Mesopotamia", add
label define bpldlbl 53300 "Iraq/Saudi Arabia", add
label define bpldlbl 53400 "Israel/Palestine", add
label define bpldlbl 53410 "Gaza Strip", add
label define bpldlbl 53420 "Palestine", add
label define bpldlbl 53430 "West Bank", add
label define bpldlbl 53440 "Israel", add
label define bpldlbl 53500 "Jordan", add
label define bpldlbl 53600 "Kuwait", add
label define bpldlbl 53700 "Lebanon", add
label define bpldlbl 53800 "Oman", add
label define bpldlbl 53900 "Qatar", add
label define bpldlbl 54000 "Saudi Arabia", add
label define bpldlbl 54100 "Syria", add
label define bpldlbl 54200 "Turkey", add
label define bpldlbl 54210 "European Turkey", add
label define bpldlbl 54220 "Asian Turkey", add
label define bpldlbl 54300 "United Arab Emirates", add
label define bpldlbl 54400 "Yemen Arab Republic (North)", add
label define bpldlbl 54500 "Yemen, PDR (South)", add
label define bpldlbl 54600 "Persian Gulf States, ns", add
label define bpldlbl 54700 "Middle East, ns", add
label define bpldlbl 54800 "Southwest Asia, nec/ns", add
label define bpldlbl 54900 "Asia Minor, ns", add
label define bpldlbl 55000 "South Asia, nec", add
label define bpldlbl 59900 "Asia, nec/ns", add
label define bpldlbl 60000 "Africa", add
label define bpldlbl 60010 "Northern Africa", add
label define bpldlbl 60011 "Algeria", add
label define bpldlbl 60012 "Egypt/United Arab Rep.", add
label define bpldlbl 60013 "Libya", add
label define bpldlbl 60014 "Morocco", add
label define bpldlbl 60015 "Sudan", add
label define bpldlbl 60016 "Tunisia", add
label define bpldlbl 60017 "Western Sahara", add
label define bpldlbl 60019 "North Africa, ns", add
label define bpldlbl 60020 "Benin", add
label define bpldlbl 60021 "Burkina Faso", add
label define bpldlbl 60022 "Gambia", add
label define bpldlbl 60023 "Ghana", add
label define bpldlbl 60024 "Guinea", add
label define bpldlbl 60025 "Guinea-Bissau", add
label define bpldlbl 60026 "Ivory Coast", add
label define bpldlbl 60027 "Liberia", add
label define bpldlbl 60028 "Mali", add
label define bpldlbl 60029 "Mauritania", add
label define bpldlbl 60030 "Niger", add
label define bpldlbl 60031 "Nigeria", add
label define bpldlbl 60032 "Senegal", add
label define bpldlbl 60033 "Sierra Leone", add
label define bpldlbl 60034 "Togo", add
label define bpldlbl 60038 "Western Africa, ns", add
label define bpldlbl 60039 "French West Africa, ns", add
label define bpldlbl 60040 "British Indian Ocean Territory", add
label define bpldlbl 60041 "Burundi", add
label define bpldlbl 60042 "Comoros", add
label define bpldlbl 60043 "Djibouti", add
label define bpldlbl 60044 "Ethiopia", add
label define bpldlbl 60045 "Kenya", add
label define bpldlbl 60046 "Madagascar", add
label define bpldlbl 60047 "Malawi", add
label define bpldlbl 60048 "Mauritius", add
label define bpldlbl 60049 "Mozambique", add
label define bpldlbl 60050 "Reunion", add
label define bpldlbl 60051 "Rwanda", add
label define bpldlbl 60052 "Seychelles", add
label define bpldlbl 60053 "Somalia", add
label define bpldlbl 60054 "Tanzania", add
label define bpldlbl 60055 "Uganda", add
label define bpldlbl 60056 "Zambia", add
label define bpldlbl 60057 "Zimbabwe", add
label define bpldlbl 60058 "Bassas de India", add
label define bpldlbl 60059 "Europa", add
label define bpldlbl 60060 "Gloriosos", add
label define bpldlbl 60061 "Juan de Nova", add
label define bpldlbl 60062 "Mayotte", add
label define bpldlbl 60063 "Tromelin", add
label define bpldlbl 60064 "Eastern Africa, nec/ns", add
label define bpldlbl 60065 "Eritrea", add
label define bpldlbl 60070 "Central Africa", add
label define bpldlbl 60071 "Angola", add
label define bpldlbl 60072 "Cameroon", add
label define bpldlbl 60073 "Central African Republic", add
label define bpldlbl 60074 "Chad", add
label define bpldlbl 60075 "Congo", add
label define bpldlbl 60076 "Equatorial Guinea", add
label define bpldlbl 60077 "Gabon", add
label define bpldlbl 60078 "Sao Tome and Principe", add
label define bpldlbl 60079 "Zaire", add
label define bpldlbl 60080 "Central Africa, ns", add
label define bpldlbl 60081 "Equatorial Africa, ns", add
label define bpldlbl 60082 "French Equatorial Africa, ns", add
label define bpldlbl 60090 "Southern Africa:", add
label define bpldlbl 60091 "Botswana", add
label define bpldlbl 60092 "Lesotho", add
label define bpldlbl 60093 "Namibia", add
label define bpldlbl 60094 "South Africa (Union of)", add
label define bpldlbl 60095 "Swaziland", add
label define bpldlbl 60096 "Southern Africa, ns", add
label define bpldlbl 60099 "Africa, ns/nec", add
label define bpldlbl 70000 "Australia and New Zealand", add
label define bpldlbl 70010 "Australia", add
label define bpldlbl 70011 "Ashmore and Cartier Islands", add
label define bpldlbl 70012 "Coral Sea Islands Territory", add
label define bpldlbl 70020 "New Zealand", add
label define bpldlbl 71000 "Pacific Islands", add
label define bpldlbl 71010 "New Caledonia", add
label define bpldlbl 71011 "Norfolk Islands", add
label define bpldlbl 71012 "Papua New Guinea", add
label define bpldlbl 71013 "Solomon Islands", add
label define bpldlbl 71014 "Vanuatu (New Hebrides)", add
label define bpldlbl 71019 "Melanesia, ns", add
label define bpldlbl 71020 "Cook Islands", add
label define bpldlbl 71021 "Fiji", add
label define bpldlbl 71022 "French Polynesia", add
label define bpldlbl 71023 "Tonga", add
label define bpldlbl 71024 "Wallis and Futuna Islands", add
label define bpldlbl 71025 "Western Samoa", add
label define bpldlbl 71029 "Polynesia, ns", add
label define bpldlbl 71030 "Christmas Island", add
label define bpldlbl 71031 "Cocos Islands", add
label define bpldlbl 71032 "Kiribati", add
label define bpldlbl 71033 "Canton and Enderbury", add
label define bpldlbl 71034 "Nauru", add
label define bpldlbl 71035 "Niue", add
label define bpldlbl 71036 "Pitcairn Island", add
label define bpldlbl 71037 "Tokelau", add
label define bpldlbl 71038 "Tuvalu", add
label define bpldlbl 71039 "Micronesia, ns", add
label define bpldlbl 71040 "US Pacific Trust Territories", add
label define bpldlbl 71041 "Marshall Islands", add
label define bpldlbl 71042 "Micronesia", add
label define bpldlbl 71043 "Kosrae", add
label define bpldlbl 71044 "Pohnpei", add
label define bpldlbl 71045 "Truk", add
label define bpldlbl 71046 "Yap", add
label define bpldlbl 71047 "Northern Mariana Islands", add
label define bpldlbl 71048 "Palau", add
label define bpldlbl 71049 "Pacific Trust Terr, ns", add
label define bpldlbl 71050 "Clipperton Island", add
label define bpldlbl 71090 "Oceania, ns/nec", add
label define bpldlbl 80000 "Antarctica, ns/nec", add
label define bpldlbl 80010 "Bouvet Islands", add
label define bpldlbl 80020 "British Antarctic Terr.", add
label define bpldlbl 80030 "Dronning Maud Land", add
label define bpldlbl 80040 "French Southern and Antarctic Lands", add
label define bpldlbl 80050 "Heard and McDonald Islands", add
label define bpldlbl 90000 "Abroad (unknown) or at sea", add
label define bpldlbl 90010 "Abroad, ns", add
label define bpldlbl 90011 "Abroad (US citizen)", add
label define bpldlbl 90020 "At sea", add
label define bpldlbl 90021 "At sea (US citizen)", add
label define bpldlbl 90022 "At sea or abroad (U.S. citizen)", add
label define bpldlbl 95000 "Other, nec", add
label values bpld bpldlbl

label define educ99lbl 00 "Not applicable"
label define educ99lbl 01 "No school completed", add
label define educ99lbl 02 "Nursery school", add
label define educ99lbl 03 "Kindergarten", add
label define educ99lbl 04 "1st-4th grade", add
label define educ99lbl 05 "5th-8th grade", add
label define educ99lbl 06 "9th grade", add
label define educ99lbl 07 "10th grade", add
label define educ99lbl 08 "11th grade", add
label define educ99lbl 09 "12th grade, no diploma", add
label define educ99lbl 10 "High school graduate, or GED", add
label define educ99lbl 11 "Some college, no degree", add
label define educ99lbl 12 "Associate degree, occupational program", add
label define educ99lbl 13 "Associate degree, academic program", add
label define educ99lbl 14 "Bachelors degree", add
label define educ99lbl 15 "Masters degree", add
label define educ99lbl 16 "Professional degree", add
label define educ99lbl 17 "Doctorate degree", add
label values educ99 educ99lbl

label define empstatdlbl 00 "N/A", add
label define empstatdlbl 10 "At work", add
label define empstatdlbl 11 "At work, public emerg", add
label define empstatdlbl 12 "Has job, not working", add
label define empstatdlbl 13 "Armed forces", add
label define empstatdlbl 14 "Armed forces--at work", add
label define empstatdlbl 15 "Armed forces--not at work but with job", add
label define empstatdlbl 20 "Unemployed", add
label define empstatdlbl 21 "Unemp, exper worker", add
label define empstatdlbl 22 "Unemp, new worker", add
label define empstatdlbl 30 "Not in Labor Force", add
label define empstatdlbl 31 "NILF, housework", add
label define empstatdlbl 32 "NILF, unable to work", add
label define empstatdlbl 33 "NILF, school", add
label define empstatdlbl 34 "NILF, other", add
label values empstatd empstatdlbl

label values occ occlbl

label define occ1990lbl 003 "Legislators", add
label define occ1990lbl 004 "Chief executives and public administrators", add
label define occ1990lbl 007 "Financial managers", add
label define occ1990lbl 008 "Human resources and labor relations managers", add
label define occ1990lbl 013 "Managers and specialists in marketing, advertising, and public relations", add
label define occ1990lbl 014 "Managers in education and related fields", add
label define occ1990lbl 015 "Managers of medicine and health occupations", add
label define occ1990lbl 016 "Postmasters and mail superintendents", add
label define occ1990lbl 017 "Managers of food-serving and lodging establishments", add
label define occ1990lbl 018 "Managers of properties and real estate", add
label define occ1990lbl 019 "Funeral directors", add
label define occ1990lbl 021 "Managers of service organizations, n.e.c.", add
label define occ1990lbl 022 "Managers and administrators, n.e.c.", add
label define occ1990lbl 023 "Accountants and auditors", add
label define occ1990lbl 024 "Insurance underwriters", add
label define occ1990lbl 025 "Other financial specialists", add
label define occ1990lbl 026 "Management analysts", add
label define occ1990lbl 027 "Personnel, HR, training, and labor relations specialists", add
label define occ1990lbl 028 "Purchasing agents and buyers, of farm products", add
label define occ1990lbl 029 "Buyers, wholesale and retail trade", add
label define occ1990lbl 033 "Purchasing managers, agents and buyers, n.e.c.", add
label define occ1990lbl 034 "Business and promotion agents", add
label define occ1990lbl 035 "Construction inspectors", add
label define occ1990lbl 036 "Inspectors and compliance officers, outside construction", add
label define occ1990lbl 037 "Management support occupations", add
label define occ1990lbl 043 "Architects", add
label define occ1990lbl 044 "Aerospace engineer", add
label define occ1990lbl 045 "Metallurgical and materials engineers, variously phrased", add
label define occ1990lbl 047 "Petroleum, mining, and geological engineers", add
label define occ1990lbl 048 "Chemical engineers", add
label define occ1990lbl 053 "Civil engineers", add
label define occ1990lbl 055 "Electrical engineer", add
label define occ1990lbl 056 "Industrial engineers", add
label define occ1990lbl 057 "Mechanical engineers", add
label define occ1990lbl 059 "Not-elsewhere-classified engineers", add
label define occ1990lbl 064 "Computer systems analysts and computer scientists", add
label define occ1990lbl 065 "Operations and systems researchers and analysts", add
label define occ1990lbl 066 "Actuaries", add
label define occ1990lbl 067 "Statisticians", add
label define occ1990lbl 068 "Mathematicians and mathematical scientists", add
label define occ1990lbl 069 "Physicists and astronomers", add
label define occ1990lbl 073 "Chemists", add
label define occ1990lbl 074 "Atmospheric and space scientists", add
label define occ1990lbl 075 "Geologists", add
label define occ1990lbl 076 "Physical scientists, n.e.c.", add
label define occ1990lbl 077 "Agricultural and food scientists", add
label define occ1990lbl 078 "Biological scientists", add
label define occ1990lbl 079 "Foresters and conservation scientists", add
label define occ1990lbl 083 "Medical scientists", add
label define occ1990lbl 084 "Physicians", add
label define occ1990lbl 085 "Dentists", add
label define occ1990lbl 086 "Veterinarians", add
label define occ1990lbl 087 "Optometrists", add
label define occ1990lbl 088 "Podiatrists", add
label define occ1990lbl 089 "Other health and therapy", add
label define occ1990lbl 095 "Registered nurses", add
label define occ1990lbl 096 "Pharmacists", add
label define occ1990lbl 097 "Dietitians and nutritionists", add
label define occ1990lbl 098 "Respiratory therapists", add
label define occ1990lbl 099 "Occupational therapists", add
label define occ1990lbl 103 "Physical therapists", add
label define occ1990lbl 104 "Speech therapists", add
label define occ1990lbl 105 "Therapists, n.e.c.", add
label define occ1990lbl 106 "Physicians' assistants", add
label define occ1990lbl 113 "Earth, environmental, and marine science instructors", add
label define occ1990lbl 114 "Biological science instructors", add
label define occ1990lbl 115 "Chemistry instructors", add
label define occ1990lbl 116 "Physics instructors", add
label define occ1990lbl 118 "Psychology instructors", add
label define occ1990lbl 119 "Economics instructors", add
label define occ1990lbl 123 "History instructors", add
label define occ1990lbl 125 "Sociology instructors", add
label define occ1990lbl 127 "Engineering instructors", add
label define occ1990lbl 128 "Math instructors", add
label define occ1990lbl 139 "Education instructors", add
label define occ1990lbl 145 "Law instructors", add
label define occ1990lbl 147 "Theology instructors", add
label define occ1990lbl 149 "Home economics instructors", add
label define occ1990lbl 150 "Humanities profs/instructors, college, nec", add
label define occ1990lbl 154 "Subject instructors (HS/college)", add
label define occ1990lbl 155 "Kindergarten and earlier school teachers", add
label define occ1990lbl 156 "Primary school teachers", add
label define occ1990lbl 157 "Secondary school teachers", add
label define occ1990lbl 158 "Special education teachers", add
label define occ1990lbl 159 "Teachers , n.e.c.", add
label define occ1990lbl 163 "Vocational and educational counselors", add
label define occ1990lbl 164 "Librarians", add
label define occ1990lbl 165 "Archivists and curators", add
label define occ1990lbl 166 "Economists, market researchers, and survey researchers", add
label define occ1990lbl 167 "Psychologists", add
label define occ1990lbl 168 "Sociologists", add
label define occ1990lbl 169 "Social scientists, n.e.c.", add
label define occ1990lbl 173 "Urban and regional planners", add
label define occ1990lbl 174 "Social workers", add
label define occ1990lbl 175 "Recreation workers", add
label define occ1990lbl 176 "Clergy and religious workers", add
label define occ1990lbl 178 "Lawyers", add
label define occ1990lbl 179 "Judges", add
label define occ1990lbl 183 "Writers and authors", add
label define occ1990lbl 184 "Technical writers", add
label define occ1990lbl 185 "Designers", add
label define occ1990lbl 186 "Musician or composer", add
label define occ1990lbl 187 "Actors, directors, producers", add
label define occ1990lbl 188 "Art makers: painters, sculptors, craft-artists, and print-makers", add
label define occ1990lbl 189 "Photographers", add
label define occ1990lbl 193 "Dancers", add
label define occ1990lbl 194 "Art/entertainment performers and related", add
label define occ1990lbl 195 "Editors and reporters", add
label define occ1990lbl 198 "Announcers", add
label define occ1990lbl 199 "Athletes, sports instructors, and officials", add
label define occ1990lbl 200 "Professionals, n.e.c.", add
label define occ1990lbl 203 "Clinical laboratory technologies and technicians", add
label define occ1990lbl 204 "Dental hygenists", add
label define occ1990lbl 205 "Health record tech specialists", add
label define occ1990lbl 206 "Radiologic tech specialists", add
label define occ1990lbl 207 "Licensed practical nurses", add
label define occ1990lbl 208 "Health technologists and technicians, n.e.c.", add
label define occ1990lbl 213 "Electrical and electronic (engineering) technicians", add
label define occ1990lbl 214 "Engineering technicians, n.e.c.", add
label define occ1990lbl 215 "Mechanical engineering technicians", add
label define occ1990lbl 217 "Drafters", add
label define occ1990lbl 218 "Surveyors, cartographers, mapping scientists and technicians", add
label define occ1990lbl 223 "Biological technicians", add
label define occ1990lbl 224 "Chemical technicians", add
label define occ1990lbl 225 "Other science technicians", add
label define occ1990lbl 226 "Airplane pilots and navigators", add
label define occ1990lbl 227 "Air traffic controllers", add
label define occ1990lbl 228 "Broadcast equipment operators", add
label define occ1990lbl 229 "Computer software developers", add
label define occ1990lbl 233 "Programmers of numerically controlled machine tools", add
label define occ1990lbl 234 "Legal assistants, paralegals, legal support, etc", add
label define occ1990lbl 235 "Technicians, n.e.c.", add
label define occ1990lbl 243 "Supervisors and proprietors of sales jobs", add
label define occ1990lbl 253 "Insurance sales occupations", add
label define occ1990lbl 254 "Real estate sales occupations", add
label define occ1990lbl 255 "Financial services sales occupations", add
label define occ1990lbl 256 "Advertising and related sales jobs", add
label define occ1990lbl 258 "Sales engineers", add
label define occ1990lbl 274 "Salespersons, n.e.c.", add
label define occ1990lbl 275 "Retail sales clerks", add
label define occ1990lbl 276 "Cashiers", add
label define occ1990lbl 277 "Door-to-door sales, street sales, and news vendors", add
label define occ1990lbl 283 "Sales demonstrators / promoters / models", add
label define occ1990lbl 303 "Office supervisors", add
label define occ1990lbl 308 "Computer and peripheral equipment operators", add
label define occ1990lbl 313 "Secretaries", add
label define occ1990lbl 314 "Stenographers", add
label define occ1990lbl 315 "Typists", add
label define occ1990lbl 316 "Interviewers, enumerators, and surveyors", add
label define occ1990lbl 317 "Hotel clerks", add
label define occ1990lbl 318 "Transportation ticket and reservation agents", add
label define occ1990lbl 319 "Receptionists", add
label define occ1990lbl 323 "Information clerks, nec", add
label define occ1990lbl 326 "Correspondence and order clerks", add
label define occ1990lbl 328 "Human resources clerks, except payroll and timekeeping", add
label define occ1990lbl 329 "Library assistants", add
label define occ1990lbl 335 "File clerks", add
label define occ1990lbl 336 "Records clerks", add
label define occ1990lbl 337 "Bookkeepers and accounting and auditing clerks", add
label define occ1990lbl 338 "Payroll and timekeeping clerks", add
label define occ1990lbl 343 "Cost and rate clerks (financial records processing)", add
label define occ1990lbl 344 "Billing clerks and related financial records processing", add
label define occ1990lbl 345 "Duplication machine operators / office machine operators", add
label define occ1990lbl 346 "Mail and paper handlers", add
label define occ1990lbl 347 "Office machine operators, n.e.c.", add
label define occ1990lbl 348 "Telephone operators", add
label define occ1990lbl 349 "Other telecom operators", add
label define occ1990lbl 354 "Postal clerks, excluding mail carriers", add
label define occ1990lbl 355 "Mail carriers for postal service", add
label define occ1990lbl 356 "Mail clerks, outside of post office", add
label define occ1990lbl 357 "Messengers", add
label define occ1990lbl 359 "Dispatchers", add
label define occ1990lbl 361 "Inspectors, n.e.c.", add
label define occ1990lbl 364 "Shipping and receiving clerks", add
label define occ1990lbl 365 "Stock and inventory clerks", add
label define occ1990lbl 366 "Meter readers", add
label define occ1990lbl 368 "Weighers, measurers, and checkers", add
label define occ1990lbl 373 "Material recording, scheduling, production, planning, and expediting clerks", add
label define occ1990lbl 375 "Insurance adjusters, examiners, and investigators", add
label define occ1990lbl 376 "Customer service reps, investigators and adjusters, except insurance", add
label define occ1990lbl 377 "Eligibility clerks for government programs; social welfare", add
label define occ1990lbl 378 "Bill and account collectors", add
label define occ1990lbl 379 "General office clerks", add
label define occ1990lbl 383 "Bank tellers", add
label define occ1990lbl 384 "Proofreaders", add
label define occ1990lbl 385 "Data entry keyers", add
label define occ1990lbl 386 "Statistical clerks", add
label define occ1990lbl 387 "Teacher's aides", add
label define occ1990lbl 389 "Administrative support jobs, n.e.c.", add
label define occ1990lbl 405 "Housekeepers, maids, butlers, stewards, and lodging quarters cleaners", add
label define occ1990lbl 407 "Private household cleaners and servants", add
label define occ1990lbl 415 "Supervisors of guards", add
label define occ1990lbl 417 "Fire fighting, prevention, and inspection", add
label define occ1990lbl 418 "Police, detectives, and private investigators", add
label define occ1990lbl 423 "Other law enforcement: sheriffs, bailiffs, correctional institution officers", add
label define occ1990lbl 425 "Crossing guards and bridge tenders", add
label define occ1990lbl 426 "Guards, watchmen, doorkeepers", add
label define occ1990lbl 427 "Protective services, n.e.c.", add
label define occ1990lbl 434 "Bartenders", add
label define occ1990lbl 435 "Waiter/waitress", add
label define occ1990lbl 436 "Cooks, variously defined", add
label define occ1990lbl 438 "Food counter and fountain workers", add
label define occ1990lbl 439 "Kitchen workers", add
label define occ1990lbl 443 "Waiter's assistant", add
label define occ1990lbl 444 "Misc food prep workers", add
label define occ1990lbl 445 "Dental assistants", add
label define occ1990lbl 446 "Health aides, except nursing", add
label define occ1990lbl 447 "Nursing aides, orderlies, and attendants", add
label define occ1990lbl 448 "Supervisors of cleaning and building service", add
label define occ1990lbl 453 "Janitors", add
label define occ1990lbl 454 "Elevator operators", add
label define occ1990lbl 455 "Pest control occupations", add
label define occ1990lbl 456 "Supervisors of personal service jobs, n.e.c.", add
label define occ1990lbl 457 "Barbers", add
label define occ1990lbl 458 "Hairdressers and cosmetologists", add
label define occ1990lbl 459 "Recreation facility attendants", add
label define occ1990lbl 461 "Guides", add
label define occ1990lbl 462 "Ushers", add
label define occ1990lbl 463 "Public transportation attendants and inspectors", add
label define occ1990lbl 464 "Baggage porters", add
label define occ1990lbl 465 "Welfare service aides", add
label define occ1990lbl 468 "Child care workers", add
label define occ1990lbl 469 "Personal service occupations, nec", add
label define occ1990lbl 473 "Farmers (owners and tenants)", add
label define occ1990lbl 474 "Horticultural specialty farmers", add
label define occ1990lbl 475 "Farm managers, except for horticultural farms", add
label define occ1990lbl 476 "Managers of horticultural specialty farms", add
label define occ1990lbl 479 "Farm workers", add
label define occ1990lbl 483 "Marine life cultivation workers", add
label define occ1990lbl 484 "Nursery farming workers", add
label define occ1990lbl 485 "Supervisors of agricultural occupations", add
label define occ1990lbl 486 "Gardeners and groundskeepers", add
label define occ1990lbl 487 "Animal caretakers except on farms", add
label define occ1990lbl 488 "Graders and sorters of agricultural products", add
label define occ1990lbl 489 "Inspectors of agricultural products", add
label define occ1990lbl 496 "Timber, logging, and forestry workers", add
label define occ1990lbl 498 "Fishers, hunters, and kindred", add
label define occ1990lbl 503 "Supervisors of mechanics and repairers", add
label define occ1990lbl 505 "Automobile mechanics", add
label define occ1990lbl 507 "Bus, truck, and stationary engine mechanics", add
label define occ1990lbl 508 "Aircraft mechanics", add
label define occ1990lbl 509 "Small engine repairers", add
label define occ1990lbl 514 "Auto body repairers", add
label define occ1990lbl 516 "Heavy equipment and farm equipment mechanics", add
label define occ1990lbl 518 "Industrial machinery repairers", add
label define occ1990lbl 519 "Machinery maintenance occupations", add
label define occ1990lbl 523 "Repairers of industrial electrical equipment", add
label define occ1990lbl 525 "Repairers of data processing equipment", add
label define occ1990lbl 526 "Repairers of household appliances and power tools", add
label define occ1990lbl 527 "Telecom and line installers and repairers", add
label define occ1990lbl 533 "Repairers of electrical equipment, n.e.c.", add
label define occ1990lbl 534 "Heating, air conditioning, and refigeration mechanics", add
label define occ1990lbl 535 "Precision makers, repairers, and smiths", add
label define occ1990lbl 536 "Locksmiths and safe repairers", add
label define occ1990lbl 538 "Office machine repairers and mechanics", add
label define occ1990lbl 539 "Repairers of mechanical controls and valves", add
label define occ1990lbl 543 "Elevator installers and repairers", add
label define occ1990lbl 544 "Millwrights", add
label define occ1990lbl 549 "Mechanics and repairers, n.e.c.", add
label define occ1990lbl 558 "Supervisors of construction work", add
label define occ1990lbl 563 "Masons, tilers, and carpet installers", add
label define occ1990lbl 567 "Carpenters", add
label define occ1990lbl 573 "Drywall installers", add
label define occ1990lbl 575 "Electricians", add
label define occ1990lbl 577 "Electric power installers and repairers", add
label define occ1990lbl 579 "Painters, construction and maintenance", add
label define occ1990lbl 583 "Paperhangers", add
label define occ1990lbl 584 "Plasterers", add
label define occ1990lbl 585 "Plumbers, pipe fitters, and steamfitters", add
label define occ1990lbl 588 "Concrete and cement workers", add
label define occ1990lbl 589 "Glaziers", add
label define occ1990lbl 593 "Insulation workers", add
label define occ1990lbl 594 "Paving, surfacing, and tamping equipment operators", add
label define occ1990lbl 595 "Roofers and slaters", add
label define occ1990lbl 596 "Sheet metal duct installers", add
label define occ1990lbl 597 "Structural metal workers", add
label define occ1990lbl 598 "Drillers of earth", add
label define occ1990lbl 599 "Construction trades, n.e.c.", add
label define occ1990lbl 614 "Drillers of oil wells", add
label define occ1990lbl 615 "Explosives workers", add
label define occ1990lbl 616 "Miners", add
label define occ1990lbl 617 "Other mining occupations", add
label define occ1990lbl 628 "Production supervisors or foremen", add
label define occ1990lbl 634 "Tool and die makers and die setters", add
label define occ1990lbl 637 "Machinists", add
label define occ1990lbl 643 "Boilermakers", add
label define occ1990lbl 644 "Precision grinders and filers", add
label define occ1990lbl 645 "Patternmakers and model makers", add
label define occ1990lbl 646 "Lay-out workers", add
label define occ1990lbl 649 "Engravers", add
label define occ1990lbl 653 "Tinsmiths, coppersmiths, and sheet metal workers", add
label define occ1990lbl 657 "Cabinetmakers and bench carpenters", add
label define occ1990lbl 658 "Furniture and wood finishers", add
label define occ1990lbl 659 "Other precision woodworkers", add
label define occ1990lbl 666 "Dressmakers and seamstresses", add
label define occ1990lbl 667 "Tailors", add
label define occ1990lbl 668 "Upholsterers", add
label define occ1990lbl 669 "Shoe repairers", add
label define occ1990lbl 674 "Other precision apparel and fabric workers", add
label define occ1990lbl 675 "Hand molders and shapers, except jewelers", add
label define occ1990lbl 677 "Optical goods workers", add
label define occ1990lbl 678 "Dental laboratory and medical appliance technicians", add
label define occ1990lbl 679 "Bookbinders", add
label define occ1990lbl 684 "Other precision and craft workers", add
label define occ1990lbl 686 "Butchers and meat cutters", add
label define occ1990lbl 687 "Bakers", add
label define occ1990lbl 688 "Batch food makers", add
label define occ1990lbl 693 "Adjusters and calibrators", add
label define occ1990lbl 694 "Water and sewage treatment plant operators", add
label define occ1990lbl 695 "Power plant operators", add
label define occ1990lbl 696 "Plant and system operators, stationary engineers", add
label define occ1990lbl 699 "Other plant and system operators", add
label define occ1990lbl 703 "Lathe, milling, and turning machine operatives", add
label define occ1990lbl 706 "Punching and stamping press operatives", add
label define occ1990lbl 707 "Rollers, roll hands, and finishers of metal", add
label define occ1990lbl 708 "Drilling and boring machine operators", add
label define occ1990lbl 709 "Grinding, abrading, buffing, and polishing workers", add
label define occ1990lbl 713 "Forge and hammer operators", add
label define occ1990lbl 717 "Fabricating machine operators, n.e.c.", add
label define occ1990lbl 719 "Molders, and casting machine operators", add
label define occ1990lbl 723 "Metal platers", add
label define occ1990lbl 724 "Heat treating equipment operators", add
label define occ1990lbl 726 "Wood lathe, routing, and planing machine operators", add
label define occ1990lbl 727 "Sawing machine operators and sawyers", add
label define occ1990lbl 728 "Shaping and joining machine operator (woodworking)", add
label define occ1990lbl 729 "Nail and tacking machine operators  (woodworking)", add
label define occ1990lbl 733 "Other woodworking machine operators", add
label define occ1990lbl 734 "Printing machine operators, n.e.c.", add
label define occ1990lbl 735 "Photoengravers and lithographers", add
label define occ1990lbl 736 "Typesetters and compositors", add
label define occ1990lbl 738 "Winding and twisting textile/apparel operatives", add
label define occ1990lbl 739 "Knitters, loopers, and toppers textile operatives", add
label define occ1990lbl 743 "Textile cutting machine operators", add
label define occ1990lbl 744 "Textile sewing machine operators", add
label define occ1990lbl 745 "Shoemaking machine operators", add
label define occ1990lbl 747 "Pressing machine operators (clothing)", add
label define occ1990lbl 748 "Laundry workers", add
label define occ1990lbl 749 "Misc textile machine operators", add
label define occ1990lbl 753 "Cementing and gluing maching operators", add
label define occ1990lbl 754 "Packers, fillers, and wrappers", add
label define occ1990lbl 755 "Extruding and forming machine operators", add
label define occ1990lbl 756 "Mixing and blending machine operatives", add
label define occ1990lbl 757 "Separating, filtering, and clarifying machine operators", add
label define occ1990lbl 759 "Painting machine operators", add
label define occ1990lbl 763 "Roasting and baking machine operators (food)", add
label define occ1990lbl 764 "Washing, cleaning, and pickling machine operators", add
label define occ1990lbl 765 "Paper folding machine operators", add
label define occ1990lbl 766 "Furnace, kiln, and oven operators, apart from food", add
label define occ1990lbl 768 "Crushing and grinding machine operators", add
label define occ1990lbl 769 "Slicing and cutting machine operators", add
label define occ1990lbl 773 "Motion picture projectionists", add
label define occ1990lbl 774 "Photographic process workers", add
label define occ1990lbl 779 "Machine operators, n.e.c.", add
label define occ1990lbl 783 "Welders and metal cutters", add
label define occ1990lbl 784 "Solderers", add
label define occ1990lbl 785 "Assemblers of electrical equipment", add
label define occ1990lbl 789 "Hand painting, coating, and decorating occupations", add
label define occ1990lbl 796 "Production checkers and inspectors", add
label define occ1990lbl 799 "Graders and sorters in manufacturing", add
label define occ1990lbl 803 "Supervisors of motor vehicle transportation", add
label define occ1990lbl 804 "Truck, delivery, and tractor drivers", add
label define occ1990lbl 808 "Bus drivers", add
label define occ1990lbl 809 "Taxi cab drivers and chauffeurs", add
label define occ1990lbl 813 "Parking lot attendants", add
label define occ1990lbl 823 "Railroad conductors and yardmasters", add
label define occ1990lbl 824 "Locomotive operators (engineers and firemen)", add
label define occ1990lbl 825 "Railroad brake, coupler, and switch operators", add
label define occ1990lbl 829 "Ship crews and marine engineers", add
label define occ1990lbl 834 "Water transport infrastructure tenders and crossing guards", add
label define occ1990lbl 844 "Operating engineers of construction equipment", add
label define occ1990lbl 848 "Crane, derrick, winch, and hoist operators", add
label define occ1990lbl 853 "Excavating and loading machine operators", add
label define occ1990lbl 859 "Misc material moving occupations", add
label define occ1990lbl 865 "Helpers, constructions", add
label define occ1990lbl 866 "Helpers, surveyors", add
label define occ1990lbl 869 "Construction laborers", add
label define occ1990lbl 873 "Production helpers", add
label define occ1990lbl 875 "Garbage and recyclable material collectors", add
label define occ1990lbl 876 "Materials movers: stevedores and longshore workers", add
label define occ1990lbl 877 "Stock handlers", add
label define occ1990lbl 878 "Machine feeders and offbearers", add
label define occ1990lbl 883 "Freight, stock, and materials handlers", add
label define occ1990lbl 885 "Garage and service station related occupations", add
label define occ1990lbl 887 "Vehicle washers and equipment cleaners", add
label define occ1990lbl 888 "Packers and packagers by hand", add
label define occ1990lbl 889 "Laborers outside construction", add
label define occ1990lbl 905 "Military", add
label define occ1990lbl 991 "Unemployed", add
label define occ1990lbl 999 "Unknown", add
label values occ1990 occ1990lbl

label define ind1990lbl 000 "N/A (not applicable) ", add
label define ind1990lbl 010 "Agricultural production, crops", add
label define ind1990lbl 011 "Agricultural production, livestock", add
label define ind1990lbl 012 "Veterinary services", add
label define ind1990lbl 020 "Landscape and horticultural services", add
label define ind1990lbl 030 "Agricultural services, n.e.c.", add
label define ind1990lbl 031 "Forestry", add
label define ind1990lbl 032 "Fishing, hunting, and trapping ", add
label define ind1990lbl 040 "Metal mining", add
label define ind1990lbl 041 "Coal mining", add
label define ind1990lbl 042 "Oil and gas extraction", add
label define ind1990lbl 050 "Nonmetallic mining and quarrying, except fuels ", add
label define ind1990lbl 060 "All construction ", add
label define ind1990lbl 100 "Meat products", add
label define ind1990lbl 101 "Dairy products", add
label define ind1990lbl 102 "Canned, frozen, and preserved fruits and vegetables", add
label define ind1990lbl 110 "Grain mill products", add
label define ind1990lbl 111 "Bakery products", add
label define ind1990lbl 112 "Sugar and confectionery products", add
label define ind1990lbl 120 "Beverage industries", add
label define ind1990lbl 121 "Misc. food preparations and kindred products", add
label define ind1990lbl 122 "Food industries, n.s.", add
label define ind1990lbl 130 "Tobacco manufactures", add
label define ind1990lbl 132 "Knitting mills", add
label define ind1990lbl 140 "Dyeing and finishing textiles, except wool and knit goods", add
label define ind1990lbl 141 "Carpets and rugs", add
label define ind1990lbl 142 "Yarn, thread, and fabric mills", add
label define ind1990lbl 150 "Miscellaneous textile mill products", add
label define ind1990lbl 151 "Apparel and accessories, except knit", add
label define ind1990lbl 152 "Miscellaneous fabricated textile products", add
label define ind1990lbl 160 "Pulp, paper, and paperboard mills", add
label define ind1990lbl 161 "Miscellaneous paper and pulp products", add
label define ind1990lbl 162 "Paperboard containers and boxes", add
label define ind1990lbl 171 "Newspaper publishing and printing", add
label define ind1990lbl 172 "Printing, publishing, and allied industries, except newspapers", add
label define ind1990lbl 180 "Plastics, synthetics, and resins", add
label define ind1990lbl 181 "Drugs", add
label define ind1990lbl 182 "Soaps and cosmetics", add
label define ind1990lbl 190 "Paints, varnishes, and related products", add
label define ind1990lbl 191 "Agricultural chemicals", add
label define ind1990lbl 192 "Industrial and miscellaneous chemicals", add
label define ind1990lbl 200 "Petroleum refining", add
label define ind1990lbl 201 "Miscellaneous petroleum and coal products", add
label define ind1990lbl 210 "Tires and inner tubes", add
label define ind1990lbl 211 "Other rubber products, and plastics footwear and belting", add
label define ind1990lbl 212 "Miscellaneous plastics products", add
label define ind1990lbl 220 "Leather tanning and finishing", add
label define ind1990lbl 221 "Footwear, except rubber and plastic", add
label define ind1990lbl 222 "Leather products, except footwear", add
label define ind1990lbl 230 "Logging", add
label define ind1990lbl 231 "Sawmills, planing mills, and millwork", add
label define ind1990lbl 232 "Wood buildings and mobile homes", add
label define ind1990lbl 241 "Miscellaneous wood products", add
label define ind1990lbl 242 "Furniture and fixtures", add
label define ind1990lbl 250 "Glass and glass products", add
label define ind1990lbl 251 "Cement, concrete, gypsum, and plaster products", add
label define ind1990lbl 252 "Structural clay products", add
label define ind1990lbl 261 "Pottery and related products", add
label define ind1990lbl 262 "Misc. nonmetallic mineral and stone products", add
label define ind1990lbl 270 "Blast furnaces, steelworks, rolling and finishing mills", add
label define ind1990lbl 271 "Iron and steel foundries", add
label define ind1990lbl 272 "Primary aluminum industries", add
label define ind1990lbl 280 "Other primary metal industries", add
label define ind1990lbl 281 "Cutlery, handtools, and general hardware", add
label define ind1990lbl 282 "Fabricated structural metal products", add
label define ind1990lbl 290 "Screw machine products", add
label define ind1990lbl 291 "Metal forgings and stampings", add
label define ind1990lbl 292 "Ordnance", add
label define ind1990lbl 300 "Miscellaneous fabricated metal products", add
label define ind1990lbl 301 "Metal industries, n.s.", add
label define ind1990lbl 310 "Engines and turbines", add
label define ind1990lbl 311 "Farm machinery and equipment", add
label define ind1990lbl 312 "Construction and material handling machines", add
label define ind1990lbl 320 "Metalworking machinery", add
label define ind1990lbl 321 "Office and accounting machines", add
label define ind1990lbl 322 "Computers and related equipment", add
label define ind1990lbl 331 "Machinery, except electrical, n.e.c.", add
label define ind1990lbl 332 "Machinery, n.s.", add
label define ind1990lbl 340 "Household appliances", add
label define ind1990lbl 341 "Radio, TV, and communication equipment", add
label define ind1990lbl 342 "Electrical machinery, equipment, and supplies, n.e.c.", add
label define ind1990lbl 350 "Electrical machinery, equipment, and supplies, n.s.", add
label define ind1990lbl 351 "Motor vehicles and motor vehicle equipment", add
label define ind1990lbl 352 "Aircraft and parts", add
label define ind1990lbl 360 "Ship and boat building and repairing", add
label define ind1990lbl 361 "Railroad locomotives and equipment", add
label define ind1990lbl 362 "Guided missiles, space vehicles, and parts", add
label define ind1990lbl 370 "Cycles and miscellaneous transportation equipment", add
label define ind1990lbl 371 "Scientific and controlling instruments", add
label define ind1990lbl 372 "Medical, dental, and optical instruments and supplies", add
label define ind1990lbl 380 "Photographic equipment and supplies", add
label define ind1990lbl 381 "Watches, clocks, and clockwork operated devices", add
label define ind1990lbl 390 "Toys, amusement, and sporting goods", add
label define ind1990lbl 391 "Miscellaneous manufacturing industries", add
label define ind1990lbl 392 "Manufacturing industries, n.s. ", add
label define ind1990lbl 400 "Railroads", add
label define ind1990lbl 401 "Bus service and urban transit", add
label define ind1990lbl 402 "Taxicab service", add
label define ind1990lbl 410 "Trucking service", add
label define ind1990lbl 411 "Warehousing and storage", add
label define ind1990lbl 412 "U.S. Postal Service", add
label define ind1990lbl 420 "Water transportation", add
label define ind1990lbl 421 "Air transportation", add
label define ind1990lbl 422 "Pipe lines, except natural gas", add
label define ind1990lbl 432 "Services incidental to transportation", add
label define ind1990lbl 440 "Radio and television broadcasting and cable", add
label define ind1990lbl 441 "Telephone communications", add
label define ind1990lbl 442 "Telegraph and miscellaneous communications services", add
label define ind1990lbl 450 "Electric light and power", add
label define ind1990lbl 451 "Gas and steam supply systems", add
label define ind1990lbl 452 "Electric and gas, and other combinations", add
label define ind1990lbl 470 "Water supply and irrigation", add
label define ind1990lbl 471 "Sanitary services", add
label define ind1990lbl 472 "Utilities, n.s. ", add
label define ind1990lbl 500 "Motor vehicles and equipment", add
label define ind1990lbl 501 "Furniture and home furnishings", add
label define ind1990lbl 502 "Lumber and construction materials", add
label define ind1990lbl 510 "Professional and commercial equipment and supplies", add
label define ind1990lbl 511 "Metals and minerals, except petroleum", add
label define ind1990lbl 512 "Electrical goods", add
label define ind1990lbl 521 "Hardware, plumbing and heating supplies", add
label define ind1990lbl 530 "Machinery, equipment, and supplies", add
label define ind1990lbl 531 "Scrap and waste materials", add
label define ind1990lbl 532 "Miscellaneous wholesale, durable goods", add
label define ind1990lbl 540 "Paper and paper products", add
label define ind1990lbl 541 "Drugs, chemicals, and allied products", add
label define ind1990lbl 542 "Apparel, fabrics, and notions", add
label define ind1990lbl 550 "Groceries and related products", add
label define ind1990lbl 551 "Farm-product raw materials", add
label define ind1990lbl 552 "Petroleum products", add
label define ind1990lbl 560 "Alcoholic beverages", add
label define ind1990lbl 561 "Farm supplies", add
label define ind1990lbl 562 "Miscellaneous wholesale, nondurable goods", add
label define ind1990lbl 571 "Wholesale trade, n.s. ", add
label define ind1990lbl 580 "Lumber and building material retailing", add
label define ind1990lbl 581 "Hardware stores", add
label define ind1990lbl 582 "Retail nurseries and garden stores", add
label define ind1990lbl 590 "Mobile home dealers", add
label define ind1990lbl 591 "Department stores", add
label define ind1990lbl 592 "Variety stores", add
label define ind1990lbl 600 "Miscellaneous general merchandise stores", add
label define ind1990lbl 601 "Grocery stores", add
label define ind1990lbl 602 "Dairy products stores", add
label define ind1990lbl 610 "Retail bakeries", add
label define ind1990lbl 611 "Food stores, n.e.c.", add
label define ind1990lbl 612 "Motor vehicle dealers", add
label define ind1990lbl 620 "Auto and home supply stores", add
label define ind1990lbl 621 "Gasoline service stations", add
label define ind1990lbl 622 "Miscellaneous vehicle dealers", add
label define ind1990lbl 623 "Apparel and accessory stores, except shoe", add
label define ind1990lbl 630 "Shoe stores", add
label define ind1990lbl 631 "Furniture and home furnishings stores", add
label define ind1990lbl 632 "Household appliance stores", add
label define ind1990lbl 633 "Radio, TV, and computer stores", add
label define ind1990lbl 640 "Music stores", add
label define ind1990lbl 641 "Eating and drinking places", add
label define ind1990lbl 642 "Drug stores", add
label define ind1990lbl 650 "Liquor stores", add
label define ind1990lbl 651 "Sporting goods, bicycles, and hobby stores", add
label define ind1990lbl 652 "Book and stationery stores", add
label define ind1990lbl 660 "Jewelry stores", add
label define ind1990lbl 661 "Gift, novelty, and souvenir shops", add
label define ind1990lbl 662 "Sewing, needlework, and piece goods stores", add
label define ind1990lbl 663 "Catalog and mail order houses", add
label define ind1990lbl 670 "Vending machine operators", add
label define ind1990lbl 671 "Direct selling establishments", add
label define ind1990lbl 672 "Fuel dealers", add
label define ind1990lbl 681 "Retail florists", add
label define ind1990lbl 682 "Miscellaneous retail stores", add
label define ind1990lbl 691 "Retail trade, n.s. ", add
label define ind1990lbl 700 "Banking", add
label define ind1990lbl 701 "Savings institutions, including credit unions", add
label define ind1990lbl 702 "Credit agencies, n.e.c.", add
label define ind1990lbl 710 "Security, commodity brokerage, and investment companies", add
label define ind1990lbl 711 "Insurance", add
label define ind1990lbl 712 "Real estate, including real estate-insurance offices ", add
label define ind1990lbl 721 "Advertising", add
label define ind1990lbl 722 "Services to dwellings and other buildings", add
label define ind1990lbl 731 "Personnel supply services", add
label define ind1990lbl 732 "Computer and data processing services", add
label define ind1990lbl 740 "Detective and protective services", add
label define ind1990lbl 741 "Business services, n.e.c.", add
label define ind1990lbl 742 "Automotive rental and leasing, without drivers", add
label define ind1990lbl 750 "Automobile parking and carwashes", add
label define ind1990lbl 751 "Automotive repair and related services", add
label define ind1990lbl 752 "Electrical repair shops", add
label define ind1990lbl 760 "Miscellaneous repair services ", add
label define ind1990lbl 761 "Private households", add
label define ind1990lbl 762 "Hotels and motels", add
label define ind1990lbl 770 "Lodging places, except hotels and motels", add
label define ind1990lbl 771 "Laundry, cleaning, and garment services", add
label define ind1990lbl 772 "Beauty shops", add
label define ind1990lbl 780 "Barber shops", add
label define ind1990lbl 781 "Funeral service and crematories", add
label define ind1990lbl 782 "Shoe repair shops", add
label define ind1990lbl 790 "Dressmaking shops", add
label define ind1990lbl 791 "Miscellaneous personal services ", add
label define ind1990lbl 800 "Theaters and motion pictures", add
label define ind1990lbl 801 "Video tape rental", add
label define ind1990lbl 802 "Bowling centers", add
label define ind1990lbl 810 "Miscellaneous entertainment and recreation services ", add
label define ind1990lbl 812 "Offices and clinics of physicians", add
label define ind1990lbl 820 "Offices and clinics of dentists", add
label define ind1990lbl 821 "Offices and clinics of chiropractors", add
label define ind1990lbl 822 "Offices and clinics of optometrists", add
label define ind1990lbl 830 "Offices and clinics of health practitioners, n.e.c.", add
label define ind1990lbl 831 "Hospitals", add
label define ind1990lbl 832 "Nursing and personal care facilities", add
label define ind1990lbl 840 "Health services, n.e.c.", add
label define ind1990lbl 841 "Legal services", add
label define ind1990lbl 842 "Elementary and secondary schools", add
label define ind1990lbl 850 "Colleges and universities", add
label define ind1990lbl 851 "Vocational schools", add
label define ind1990lbl 852 "Libraries", add
label define ind1990lbl 860 "Educational services, n.e.c.", add
label define ind1990lbl 861 "Job training and vocational rehabilitation services", add
label define ind1990lbl 862 "Child day care services", add
label define ind1990lbl 863 "Family child care homes", add
label define ind1990lbl 870 "Residential care facilities, without nursing", add
label define ind1990lbl 871 "Social services, n.e.c.", add
label define ind1990lbl 872 "Museums, art galleries, and zoos", add
label define ind1990lbl 873 "Labor unions", add
label define ind1990lbl 880 "Religious organizations", add
label define ind1990lbl 881 "Membership organizations, n.e.c.", add
label define ind1990lbl 882 "Engineering, architectural, and surveying services", add
label define ind1990lbl 890 "Accounting, auditing, and bookkeeping services", add
label define ind1990lbl 891 "Research, development, and testing services", add
label define ind1990lbl 892 "Management and public relations services", add
label define ind1990lbl 893 "Miscellaneous professional and related services ", add
label define ind1990lbl 900 "Executive and legislative offices", add
label define ind1990lbl 901 "General government, n.e.c.", add
label define ind1990lbl 910 "Justice, public order, and safety", add
label define ind1990lbl 921 "Public finance, taxation, and monetary policy", add
label define ind1990lbl 922 "Administration of human resources programs", add
label define ind1990lbl 930 "Administration of environmental quality and housing programs", add
label define ind1990lbl 931 "Administration of economic programs", add
label define ind1990lbl 932 "National security and international affairs ", add
label define ind1990lbl 940 "Army", add
label define ind1990lbl 941 "Air Force", add
label define ind1990lbl 942 "Navy", add
label define ind1990lbl 950 "Marines", add
label define ind1990lbl 951 "Coast Guard", add
label define ind1990lbl 952 "Armed Forces, branch not specified", add
label define ind1990lbl 960 "Military Reserves or National Guard ", add
label define ind1990lbl 992 "Last worked 1984 or earlier", add
label define ind1990lbl 999 "DID NOT RESPOND", add
label values ind1990 ind1990lbl

label values wkswork1 wkswork1lbl

label values uhrswork uhrsworklbl

label values incwage incwagelbl

label define movedinlbl 0 "N/A", add
label define movedinlbl 1 "This year or last year", add
label define movedinlbl 2 "2 years ago", add
label define movedinlbl 3 "3 years ago", add
label define movedinlbl 4 "4-6 (1960)", add
label define movedinlbl 5 "7-10 (1960)", add
label define movedinlbl 6 "11-20", add
label define movedinlbl 7 "21+", add
label define movedinlbl 8 "31+", add
label define movedinlbl 9 "Always lived here", add
label values movedin movedinlbl

label define pwmetrolbl 0000 "N/A or not identifiable"
label define pwmetrolbl 0040 "Abilene, TX", add
label define pwmetrolbl 0060 "Aguadilla, PR", add
label define pwmetrolbl 0080 "Akron, OH", add
label define pwmetrolbl 0120 "Albany, GA", add
label define pwmetrolbl 0160 "Albany-Schenectady-Troy, NY", add
label define pwmetrolbl 0200 "Albuquerque, NM", add
label define pwmetrolbl 0220 "Alexandria, LA", add
label define pwmetrolbl 0240 "Allentown-Bethlehem-Easton, PA/NJ", add
label define pwmetrolbl 0280 "Altoona, PA", add
label define pwmetrolbl 0320 "Amarillo, TX", add
label define pwmetrolbl 0380 "Anchorage, AK", add
label define pwmetrolbl 0400 "Anderson, IN", add
label define pwmetrolbl 0440 "Ann Arbor, MI", add
label define pwmetrolbl 0450 "Anniston, AL", add
label define pwmetrolbl 0460 "Appleton-Oskosh-Neenah, WI", add
label define pwmetrolbl 0470 "Arecibo, PR", add
label define pwmetrolbl 0480 "Asheville, NC", add
label define pwmetrolbl 0500 "Athens, GA", add
label define pwmetrolbl 0520 "Atlanta, GA", add
label define pwmetrolbl 0560 "Atlantic City, NJ", add
label define pwmetrolbl 0580 "Auburn-Opekika, AL", add
label define pwmetrolbl 0600 "Augusta-Aiken, GA-SC", add
label define pwmetrolbl 0640 "Austin, TX", add
label define pwmetrolbl 0680 "Bakersfield, CA", add
label define pwmetrolbl 0720 "Baltimore, MD", add
label define pwmetrolbl 0730 "Bangor, ME", add
label define pwmetrolbl 0740 "Barnstable-Yarmouth, MA", add
label define pwmetrolbl 0760 "Baton Rouge, LA", add
label define pwmetrolbl 0780 "Battle Creek, MI", add
label define pwmetrolbl 0840 "Beaumont-Port Arthur-Orange, TX", add
label define pwmetrolbl 0860 "Bellingham, WA", add
label define pwmetrolbl 0870 "Benton Harbor, MI", add
label define pwmetrolbl 0880 "Billings, MT", add
label define pwmetrolbl 0920 "Biloxi-Gulfport, MS", add
label define pwmetrolbl 0960 "Binghamton, NY", add
label define pwmetrolbl 1000 "Birmingham, AL", add
label define pwmetrolbl 1010 "Bismarck, ND", add
label define pwmetrolbl 1020 "Bloomington, IN", add
label define pwmetrolbl 1040 "Bloomington-Normal, IL", add
label define pwmetrolbl 1080 "Boise City, ID", add
label define pwmetrolbl 1120 "Boston, MA", add
label define pwmetrolbl 1121 "Lawrence-Haverhill, MA/NH", add
label define pwmetrolbl 1122 "Lowell, MA/NH", add
label define pwmetrolbl 1123 "Salem-Gloucester, MA", add
label define pwmetrolbl 1140 "Bradenton, FL", add
label define pwmetrolbl 1150 "Bremerton, WA", add
label define pwmetrolbl 1160 "Bridgeport, CT", add
label define pwmetrolbl 1200 "Brockton, MA", add
label define pwmetrolbl 1240 "Brownsville - Harlingen-San Benito, TX", add
label define pwmetrolbl 1260 "Bryan-College Station, TX", add
label define pwmetrolbl 1280 "Buffalo-Niagara Falls, NY", add
label define pwmetrolbl 1281 "Niagara Falls, NY", add
label define pwmetrolbl 1290 "Caguas, PR", add
label define pwmetrolbl 1300 "Burlington, NC", add
label define pwmetrolbl 1310 "Burlington, VT", add
label define pwmetrolbl 1320 "Canton, OH", add
label define pwmetrolbl 1350 "Casper, WY", add
label define pwmetrolbl 1360 "Cedar Rapids, IA", add
label define pwmetrolbl 1400 "Champaign-Urbana-Rantoul, IL", add
label define pwmetrolbl 1440 "Charleston-N.Charleston,SC", add
label define pwmetrolbl 1480 "Charleston, WV", add
label define pwmetrolbl 1520 "Charlotte-Gastonia-Rock Hill, SC", add
label define pwmetrolbl 1521 "Rock Hill, SC", add
label define pwmetrolbl 1540 "Charlottesville, VA", add
label define pwmetrolbl 1560 "Chattanooga, TN/GA", add
label define pwmetrolbl 1580 "Cheyenne, WY", add
label define pwmetrolbl 1600 "Chicago-Gary-Lake IL", add
label define pwmetrolbl 1601 "Aurora-Elgin, IL", add
label define pwmetrolbl 1602 "Gary-Hammond-East Chicago, IN", add
label define pwmetrolbl 1603 "Joliet, IL", add
label define pwmetrolbl 1604 "Lake County, IL", add
label define pwmetrolbl 1620 "Chico, CA", add
label define pwmetrolbl 1640 "Cincinnati, OH/KY/IN", add
label define pwmetrolbl 1660 "Clarksville- Hopkinsville, TN/KY", add
label define pwmetrolbl 1680 "Cleveland, OH", add
label define pwmetrolbl 1720 "Colorado Springs, CO", add
label define pwmetrolbl 1740 "Columbia, MO", add
label define pwmetrolbl 1760 "Columbia, SC", add
label define pwmetrolbl 1800 "Columbus, GA/AL", add
label define pwmetrolbl 1840 "Columbus, OH", add
label define pwmetrolbl 1880 "Corpus Christi, TX", add
label define pwmetrolbl 1900 "Cumberland, MD/WV", add
label define pwmetrolbl 1920 "Dallas-Fort Worth, TX", add
label define pwmetrolbl 1921 "Fort Worth-Arlington, TX", add
label define pwmetrolbl 1930 "Danbury, CT", add
label define pwmetrolbl 1950 "Danville, VA", add
label define pwmetrolbl 1960 "Davenport, IA-Rock Island-Moline, IL", add
label define pwmetrolbl 2000 "Dayton-Springfield, OH", add
label define pwmetrolbl 2001 "Springfield, OH", add
label define pwmetrolbl 2020 "Daytona Beach, FL", add
label define pwmetrolbl 2030 "Decatur, AL", add
label define pwmetrolbl 2040 "Decatur, IL", add
label define pwmetrolbl 2080 "Denver-Boulder-Longmont, CO", add
label define pwmetrolbl 2081 "Boulder-Longmont, CO", add
label define pwmetrolbl 2120 "Des Moines, IA", add
label define pwmetrolbl 2160 "Detroit, MI", add
label define pwmetrolbl 2180 "Dothan, AL", add
label define pwmetrolbl 2190 "Dover, DE", add
label define pwmetrolbl 2200 "Dubuque, IA", add
label define pwmetrolbl 2240 "Duluth-Superior, MN/WI", add
label define pwmetrolbl 2281 "Dutchess Co., NY", add
label define pwmetrolbl 2290 "Eau Claire, WI", add
label define pwmetrolbl 2310 "El Paso, TX", add
label define pwmetrolbl 2320 "Elkhart-Goshen, IN", add
label define pwmetrolbl 2330 "Elmira, NY", add
label define pwmetrolbl 2340 "Enid, OK", add
label define pwmetrolbl 2360 "Erie, PA", add
label define pwmetrolbl 2400 "Eugene-Springfield, OR", add
label define pwmetrolbl 2440 "Evansville, IN/KY", add
label define pwmetrolbl 2520 "Fargo-Moorhead, ND/MN", add
label define pwmetrolbl 2560 "Fayetteville, NC", add
label define pwmetrolbl 2580 "Fayetteville-Springdale, AR", add
label define pwmetrolbl 2600 "Fitchburg-Leominster, MA", add
label define pwmetrolbl 2620 "Flagstaff, AZ-UT", add
label define pwmetrolbl 2640 "Flint, MI", add
label define pwmetrolbl 2650 "Florence, AL", add
label define pwmetrolbl 2660 "Florence, SC", add
label define pwmetrolbl 2670 "Fort Collins-Loveland, CO", add
label define pwmetrolbl 2680 "Fort Lauderdale-Hollywood-Pompano Beach, FL", add
label define pwmetrolbl 2700 "Fort Myers-Cape Coral, FL", add
label define pwmetrolbl 2710 "Fort Pierce, FL", add
label define pwmetrolbl 2720 "Fort Smith, AR/OK", add
label define pwmetrolbl 2750 "Fort Walton Beach, FL", add
label define pwmetrolbl 2760 "Fort Wayne, IN", add
label define pwmetrolbl 2840 "Fresno, CA", add
label define pwmetrolbl 2880 "Gadsden, AL", add
label define pwmetrolbl 2900 "Gainesville, FL", add
label define pwmetrolbl 2920 "Galveston-Texas City, TX", add
label define pwmetrolbl 2970 "Glens Falls, NY", add
label define pwmetrolbl 2980 "Goldsboro, NC", add
label define pwmetrolbl 2990 "Grand Forks, ND/MN", add
label define pwmetrolbl 3000 "Grand Rapids, MI", add
label define pwmetrolbl 3040 "Great Falls, MT", add
label define pwmetrolbl 3060 "Greeley, CO", add
label define pwmetrolbl 3080 "Green Bay, WI", add
label define pwmetrolbl 3120 "Greensboro-Winston Salem-High Point, NC", add
label define pwmetrolbl 3150 "Greenville, NC", add
label define pwmetrolbl 3160 "Greenville-Spartenburg-Anderson, SC", add
label define pwmetrolbl 3161 "Anderson, SC", add
label define pwmetrolbl 3180 "Hagerstown, MD", add
label define pwmetrolbl 3200 "Hamilton-Middleton, OH", add
label define pwmetrolbl 3240 "Harrisburg-Lebanon-Carlisle, PA", add
label define pwmetrolbl 3280 "Hartford-Bristol-Middleton-New Britian, CT", add
label define pwmetrolbl 3281 "Bristol, CT", add
label define pwmetrolbl 3283 "New Britain, CT", add
label define pwmetrolbl 3285 "Hattiesburg, MS", add
label define pwmetrolbl 3290 "Hickory-Morgantown, NC", add
label define pwmetrolbl 3320 "Honolulu, HI", add
label define pwmetrolbl 3350 "Houma-Thibodoux, LA", add
label define pwmetrolbl 3360 "Houston-Brazoria, TX", add
label define pwmetrolbl 3361 "Brazoria, TX", add
label define pwmetrolbl 3400 "Huntington-Ashland,WV/KY/OH", add
label define pwmetrolbl 3440 "Huntsville, AL", add
label define pwmetrolbl 3480 "Indianapolis, IN", add
label define pwmetrolbl 3500 "Iowa City, IA", add
label define pwmetrolbl 3520 "Jackson, MI", add
label define pwmetrolbl 3560 "Jackson, MS", add
label define pwmetrolbl 3580 "Jackson, TN", add
label define pwmetrolbl 3590 "Jacksonville, FL", add
label define pwmetrolbl 3600 "Jacksonville, NC", add
label define pwmetrolbl 3610 "Jamestown-Dunkirk, NY", add
label define pwmetrolbl 3620 "Janesville-Beloit, WI", add
label define pwmetrolbl 3660 "Johnson City-Kingsport-Bristol, TN/VA", add
label define pwmetrolbl 3680 "Johnstown, PA", add
label define pwmetrolbl 3710 "Joplin, MO", add
label define pwmetrolbl 3720 "Kalamazoo-Portage, MI", add
label define pwmetrolbl 3740 "Kankakee, IL", add
label define pwmetrolbl 3760 "Kansas City, MO-KS", add
label define pwmetrolbl 3800 "Kenosha, WI", add
label define pwmetrolbl 3810 "Killeen-Temple, TX", add
label define pwmetrolbl 3840 "Knoxville, TN", add
label define pwmetrolbl 3850 "Kokomo, IN", add
label define pwmetrolbl 3870 "LaCrosse, WI", add
label define pwmetrolbl 3880 "Lafayette, LA", add
label define pwmetrolbl 3920 "Lafayette-W. Lafayette,IN", add
label define pwmetrolbl 3960 "Lake Charles, LA", add
label define pwmetrolbl 3980 "Lakeland-Winterhaven, FL", add
label define pwmetrolbl 4000 "Lancaster, PA", add
label define pwmetrolbl 4040 "Lansing-E. Lansing, MI", add
label define pwmetrolbl 4080 "Laredo, TX", add
label define pwmetrolbl 4100 "Las Cruces, NM", add
label define pwmetrolbl 4120 "Las Vegas, NV", add
label define pwmetrolbl 4150 "Lawrence, KS", add
label define pwmetrolbl 4200 "Lawton, OK", add
label define pwmetrolbl 4240 "Lewiston-Auburn, ME", add
label define pwmetrolbl 4280 "Lexington-Fayette, KY", add
label define pwmetrolbl 4320 "Lima, OH", add
label define pwmetrolbl 4360 "Lincoln, NE", add
label define pwmetrolbl 4400 "Little Rock-North Little Rock, AR", add
label define pwmetrolbl 4410 "Long Branch-Asbury Park, NJ", add
label define pwmetrolbl 4420 "Longview-Marshall, TX", add
label define pwmetrolbl 4440 "Lorain-Elyria, OH", add
label define pwmetrolbl 4480 "Los Angeles-Long Beach, CA", add
label define pwmetrolbl 4481 "Anaheim-Santa Ana-Garden Grove, CA", add
label define pwmetrolbl 4482 "Orange County, CA", add
label define pwmetrolbl 4520 "Louisville, KY/IN", add
label define pwmetrolbl 4600 "Lubbock, TX", add
label define pwmetrolbl 4640 "Lynchburg, VA", add
label define pwmetrolbl 4680 "Macon-Warner Robins, GA", add
label define pwmetrolbl 4720 "Madison, WI", add
label define pwmetrolbl 4760 "Manchester, NH", add
label define pwmetrolbl 4800 "Mansfield, OH", add
label define pwmetrolbl 4880 "McAllen-Edinburg-Pharr-Mission, TX", add
label define pwmetrolbl 4890 "Medford, OR", add
label define pwmetrolbl 4900 "Melbourne-Titusville-Cocoa-Palm Bay, FL", add
label define pwmetrolbl 4920 "Memphis, TN/AR/MS", add
label define pwmetrolbl 4940 "Merced, CA", add
label define pwmetrolbl 5000 "Miami-Hialeah, FL", add
label define pwmetrolbl 5040 "Midland, TX", add
label define pwmetrolbl 5080 "Milwaukee, WI", add
label define pwmetrolbl 5120 "Minneapolis-St. Paul, MN", add
label define pwmetrolbl 5160 "Mobile, AL", add
label define pwmetrolbl 5170 "Modesto, CA", add
label define pwmetrolbl 5190 "Monmouth-Ocean, NJ", add
label define pwmetrolbl 5200 "Monroe, LA", add
label define pwmetrolbl 5240 "Montgomery, AL", add
label define pwmetrolbl 5280 "Muncie, IN", add
label define pwmetrolbl 5320 "Muskegon-Norton Shores-Muskegon Heights, MI", add
label define pwmetrolbl 5330 "Myrtle Beach, SC", add
label define pwmetrolbl 5340 "Naples, FL", add
label define pwmetrolbl 5350 "Nashua, NH", add
label define pwmetrolbl 5360 "Nashville, TN", add
label define pwmetrolbl 5400 "New Bedford, MA", add
label define pwmetrolbl 5460 "New Brunswick-Perth Amboy-Sayreville, NJ", add
label define pwmetrolbl 5480 "New Haven-Meriden, CT", add
label define pwmetrolbl 5520 "New London-Norwich, CT/RI", add
label define pwmetrolbl 5560 "New Orleans, LA", add
label define pwmetrolbl 5600 "New York-Northeastern NJ", add
label define pwmetrolbl 5601 "Nassau-Suffolk, NY", add
label define pwmetrolbl 5602 "Bergen-Passaic, NJ", add
label define pwmetrolbl 5603 "Jersey City, NJ", add
label define pwmetrolbl 5604 "Middlesex-Somerset-Hunterdon, NJ", add
label define pwmetrolbl 5605 "Newark, NJ", add
label define pwmetrolbl 5640 "Newark, OH", add
label define pwmetrolbl 5660 "Newburgh-Middletown, NY", add
label define pwmetrolbl 5720 "Norfolk-VA Beach-Newport News, VA", add
label define pwmetrolbl 5760 "Norwalk, CT", add
label define pwmetrolbl 5790 "Ocala, FL", add
label define pwmetrolbl 5800 "Odessa, TX", add
label define pwmetrolbl 5880 "Oklahoma City, OK", add
label define pwmetrolbl 5910 "Olympia, WA", add
label define pwmetrolbl 5920 "Omaha, NE/IA", add
label define pwmetrolbl 5950 "Orange County, NY", add
label define pwmetrolbl 5960 "Orlando, FL", add
label define pwmetrolbl 5990 "Owensboro, KY", add
label define pwmetrolbl 6010 "Panama City, FL", add
label define pwmetrolbl 6020 "Parkersburg-Marietta,WV/OH", add
label define pwmetrolbl 6030 "Pascagoula-Moss Point, MS", add
label define pwmetrolbl 6080 "Pensacola, FL", add
label define pwmetrolbl 6120 "Peoria, IL", add
label define pwmetrolbl 6160 "Philadelphia, PA/NJ", add
label define pwmetrolbl 6200 "Phoenix, AZ", add
label define pwmetrolbl 6240 "Pine Bluff, AR", add
label define pwmetrolbl 6280 "Pittsburgh-Beaver Valley, PA", add
label define pwmetrolbl 6320 "Pittsfield, MA", add
label define pwmetrolbl 6360 "Ponce, PR", add
label define pwmetrolbl 6400 "Portland, ME", add
label define pwmetrolbl 6440 "Portland-Vancouver, OR", add
label define pwmetrolbl 6441 "Vancouver, WA", add
label define pwmetrolbl 6450 "Portsmouth-Dover-Rochester, NH/ME", add
label define pwmetrolbl 6460 "Poughkeepsie, NY", add
label define pwmetrolbl 6480 "Providence-Fall River-Pawtuckett, MA", add
label define pwmetrolbl 6481 "Fall River, MA/RI", add
label define pwmetrolbl 6482 "Pawtucket-Woonsocket-Attleboro, RI/MA", add
label define pwmetrolbl 6520 "Provo-Orem, UT", add
label define pwmetrolbl 6560 "Pueblo, CO", add
label define pwmetrolbl 6580 "Punta Gorda, FL", add
label define pwmetrolbl 6600 "Racine, WI", add
label define pwmetrolbl 6640 "Raleigh-Durham, NC", add
label define pwmetrolbl 6660 "Rapid City, SD", add
label define pwmetrolbl 6680 "Reading, PA", add
label define pwmetrolbl 6690 "Redding, CA", add
label define pwmetrolbl 6720 "Reno, NV", add
label define pwmetrolbl 6740 "Richland-Kennewick-Pasco, WA", add
label define pwmetrolbl 6760 "Richmond-Petersburg, VA", add
label define pwmetrolbl 6761 "Petersburg-Colonial He.", add
label define pwmetrolbl 6780 "Riverside-San Bernadino,CA", add
label define pwmetrolbl 6800 "Roanoke, VA", add
label define pwmetrolbl 6820 "Rochester, MN", add
label define pwmetrolbl 6840 "Rochester, NY", add
label define pwmetrolbl 6880 "Rockford, IL", add
label define pwmetrolbl 6895 "Rocky Mount, NC", add
label define pwmetrolbl 6920 "Sacramento, CA", add
label define pwmetrolbl 6960 "Saginaw-Bay City-Midland, MI", add
label define pwmetrolbl 6961 "Bay City, MI", add
label define pwmetrolbl 6980 "St. Cloud, MN", add
label define pwmetrolbl 7000 "St. Joseph, MO", add
label define pwmetrolbl 7040 "St. Louis, MO", add
label define pwmetrolbl 7080 "Salem, OR", add
label define pwmetrolbl 7120 "Salinas-Sea Side-Monterey, CA", add
label define pwmetrolbl 7140 "Salisbury-Concord, NC", add
label define pwmetrolbl 7160 "Salt Lake City-Ogden, UT", add
label define pwmetrolbl 7200 "San Angelo, TX", add
label define pwmetrolbl 7240 "San Antonio, TX", add
label define pwmetrolbl 7320 "San Diego, CA", add
label define pwmetrolbl 7360 "San Francisco-Oakland-Vallejo, CA", add
label define pwmetrolbl 7361 "Oakland, CA", add
label define pwmetrolbl 7362 "Vallejo-Fairfield-Napa, CA", add
label define pwmetrolbl 7400 "San Jose, CA", add
label define pwmetrolbl 7440 "San Juan, PR", add
label define pwmetrolbl 7460 "San Luis Obispo-Atascad-P Robles, CA", add
label define pwmetrolbl 7470 "Santa Barbara-Santa Maria-Lompoc, CA", add
label define pwmetrolbl 7480 "Santa Cruz, CA", add
label define pwmetrolbl 7490 "Santa Fe, NM", add
label define pwmetrolbl 7500 "Santa Rosa-Petaluma, CA", add
label define pwmetrolbl 7510 "Sarasota, FL", add
label define pwmetrolbl 7520 "Savannah, GA", add
label define pwmetrolbl 7560 "Scranton-Wilkes-Barre, PA", add
label define pwmetrolbl 7600 "Seattle-Everett, WA", add
label define pwmetrolbl 7610 "Sharon, PA", add
label define pwmetrolbl 7620 "Sheboygan, WI", add
label define pwmetrolbl 7640 "Sherman-Denison, TX", add
label define pwmetrolbl 7680 "Shreveport, LA", add
label define pwmetrolbl 7720 "Sioux City, IA/NE", add
label define pwmetrolbl 7760 "Sioux Falls, SD", add
label define pwmetrolbl 7800 "South Bend-Mishawaka, IN", add
label define pwmetrolbl 7840 "Spokane, WA", add
label define pwmetrolbl 7880 "Springfield, IL", add
label define pwmetrolbl 7920 "Springfield, MO", add
label define pwmetrolbl 8000 "Springfield-Holyoke-Chicopee, MA", add
label define pwmetrolbl 8040 "Stamford, CT", add
label define pwmetrolbl 8050 "State College, PA", add
label define pwmetrolbl 8080 "Steubenville-Weirton,OH/WV", add
label define pwmetrolbl 8120 "Stockton, CA", add
label define pwmetrolbl 8140 "Sumter, SC", add
label define pwmetrolbl 8160 "Syracuse, NY", add
label define pwmetrolbl 8200 "Tacoma, WA", add
label define pwmetrolbl 8240 "Tallahassee, FL", add
label define pwmetrolbl 8280 "Tampa-St. Petersburg-Clearwater, FL", add
label define pwmetrolbl 8320 "Terre Haute, IN", add
label define pwmetrolbl 8360 "Texarkana, TX/AR", add
label define pwmetrolbl 8400 "Toledo, OH/MI", add
label define pwmetrolbl 8440 "Topeka, KS", add
label define pwmetrolbl 8480 "Trenton, NJ", add
label define pwmetrolbl 8520 "Tucson, AZ", add
label define pwmetrolbl 8560 "Tulsa, OK", add
label define pwmetrolbl 8600 "Tuscaloosa, AL", add
label define pwmetrolbl 8640 "Tyler, TX", add
label define pwmetrolbl 8680 "Utica-Rome, NY", add
label define pwmetrolbl 8730 "Ventura-Oxnard-Simi Valley", add
label define pwmetrolbl 8750 "Victoria, TX", add
label define pwmetrolbl 8760 "Vineland-Milville-Bridgetown, NJ", add
label define pwmetrolbl 8780 "Visalia-Tulare -Porterville, CA", add
label define pwmetrolbl 8800 "Waco, TX", add
label define pwmetrolbl 8840 "Washington, DC/MD/VA", add
label define pwmetrolbl 8880 "Waterbury, CT", add
label define pwmetrolbl 8920 "Waterloo-Cedar Falls, IA", add
label define pwmetrolbl 8940 "Wausau, WI", add
label define pwmetrolbl 8960 "West Palm Beach-Boca Raton-Delray Beach, FL", add
label define pwmetrolbl 9000 "Wheeling, WV/OH", add
label define pwmetrolbl 9040 "Wichita, KS", add
label define pwmetrolbl 9080 "Wichita Falls, TX", add
label define pwmetrolbl 9140 "Williamsport, PA", add
label define pwmetrolbl 9160 "Wilmington, DE/NJ/MD", add
label define pwmetrolbl 9200 "Wilmington, NC", add
label define pwmetrolbl 9240 "Worcester, MA", add
label define pwmetrolbl 9260 "Yakima, WA", add
label define pwmetrolbl 9270 "Yolo, CA", add
label define pwmetrolbl 9280 "York, PA", add
label define pwmetrolbl 9320 "Youngstown-Warren, OH-PA", add
label define pwmetrolbl 9340 "Yuba City, CA", add
label define pwmetrolbl 9360 "Yuma, AZ", add
label values pwmetro pwmetrolbl

label define pwcitylbl 0000 "N/A or not identifiable"
label define pwcitylbl 0010 "Akron, OH", add
label define pwcitylbl 0050 "Albany, NY", add
label define pwcitylbl 0070 "Albuquerque, NM", add
label define pwcitylbl 0090 "Alexandria, VA", add
label define pwcitylbl 0130 "Allentown, PA", add
label define pwcitylbl 0190 "Anaheim, CA", add
label define pwcitylbl 0210 "Anchorage, AK", add
label define pwcitylbl 0270 "Ann Arbor, MI", add
label define pwcitylbl 0290 "Arlington, TX", add
label define pwcitylbl 0310 "Arlington, VA", add
label define pwcitylbl 0350 "Atlanta, GA", add
label define pwcitylbl 0450 "Aurora, CO", add
label define pwcitylbl 0490 "Austin, TX", add
label define pwcitylbl 0510 "Bakersfield, CA", add
label define pwcitylbl 0530 "Baltimore, MD", add
label define pwcitylbl 0590 "Baton Rouge, LA", add
label define pwcitylbl 0600 "Bayamon, PR", add
label define pwcitylbl 0670 "Beaumont, TX", add
label define pwcitylbl 0680 "Bellevue, WA", add
label define pwcitylbl 0770 "Birmingham, AL", add
label define pwcitylbl 0800 "Boise, ID", add
label define pwcitylbl 0810 "Boston, MA", add
label define pwcitylbl 0830 "Bridgeport, CT", add
label define pwcitylbl 0880 "Brownsville, TX", add
label define pwcitylbl 0890 "Buffalo, NY", add
label define pwcitylbl 0930 "Cambridge, MA", add
label define pwcitylbl 1000 "Cape Coral, FL", add
label define pwcitylbl 1050 "Carolina, PR", add
label define pwcitylbl 1090 "Charlotte, NC", add
label define pwcitylbl 1110 "Chattanooga, TN", add
label define pwcitylbl 1150 "Chesapeake, VA", add
label define pwcitylbl 1190 "Chicago, IL", add
label define pwcitylbl 1250 "Chula Vista, CA", add
label define pwcitylbl 1290 "Cincinnati, OH", add
label define pwcitylbl 1330 "Cleveland, OH", add
label define pwcitylbl 1390 "Colorado Springs, CO", add
label define pwcitylbl 1410 "Columbia, SC", add
label define pwcitylbl 1450 "Columbus, OH", add
label define pwcitylbl 1470 "Concord, CA", add
label define pwcitylbl 1500 "Corona, CA", add
label define pwcitylbl 1520 "Corpus Christi, TX", add
label define pwcitylbl 1590 "Dallas, TX", add
label define pwcitylbl 1650 "Davenport, IA", add
label define pwcitylbl 1670 "Dayton, OH", add
label define pwcitylbl 1710 "Denver, CO", add
label define pwcitylbl 1730 "Des Moines, IA", add
label define pwcitylbl 1750 "Detroit, MI", add
label define pwcitylbl 1800 "Downey, CA", add
label define pwcitylbl 1850 "Durham, NC", add
label define pwcitylbl 1910 "East Los Angeles, CA", add
label define pwcitylbl 1990 "El Monte, CA", add
label define pwcitylbl 2010 "El Paso, TX", add
label define pwcitylbl 2050 "Elizabeth, NJ", add
label define pwcitylbl 2090 "Erie, PA", add
label define pwcitylbl 2110 "Escondido, CA", add
label define pwcitylbl 2130 "Eugene, OR", add
label define pwcitylbl 2170 "Evansville, IN", add
label define pwcitylbl 2240 "Fayetteville, NC", add
label define pwcitylbl 2260 "Fontana, CA", add
label define pwcitylbl 2270 "Flint, MI", add
label define pwcitylbl 2290 "Fort Lauderdale, FL", add
label define pwcitylbl 2300 "Fort Collins, CO", add
label define pwcitylbl 2330 "Fort Wayne, IN", add
label define pwcitylbl 2350 "Fort Worth, TX", add
label define pwcitylbl 2370 "Fresno, CA", add
label define pwcitylbl 2390 "Fullerton, CA", add
label define pwcitylbl 2430 "Garden Grove, CA", add
label define pwcitylbl 2450 "Garland, TX", add
label define pwcitylbl 2470 "Gary, IN", add
label define pwcitylbl 2490 "Glendale, CA", add
label define pwcitylbl 2530 "Grand Rapids, MI", add
label define pwcitylbl 2550 "Green Bay, WI", add
label define pwcitylbl 2570 "Greensboro, NC", add
label define pwcitylbl 2600 "Guyanabo, PR", add
label define pwcitylbl 2650 "Hampton, VA", add
label define pwcitylbl 2710 "Hartford, CT", add
label define pwcitylbl 2770 "Hialeah, FL", add
label define pwcitylbl 2830 "Hollywood, FL", add
label define pwcitylbl 2870 "Honolulu, HI", add
label define pwcitylbl 2890 "Houston, TX", add
label define pwcitylbl 2930 "Huntington Beach, CA", add
label define pwcitylbl 2950 "Huntsville, AL", add
label define pwcitylbl 2970 "Independence, MO", add
label define pwcitylbl 2990 "Indianapolis, IN", add
label define pwcitylbl 3010 "Inglewood, CA", add
label define pwcitylbl 3020 "Irvine, CA", add
label define pwcitylbl 3030 "Irving, TX", add
label define pwcitylbl 3090 "Jackson, MS", add
label define pwcitylbl 3110 "Jacksonville, FL", add
label define pwcitylbl 3150 "Jersey City, NJ", add
label define pwcitylbl 3260 "Kansas City, MO", add
label define pwcitylbl 3330 "Knoxville, TN", add
label define pwcitylbl 3390 "Lafayette, LA", add
label define pwcitylbl 3410 "Lakewood, CO", add
label define pwcitylbl 3440 "Lancaster, CA", add
label define pwcitylbl 3470 "Lansing, MI", add
label define pwcitylbl 3490 "Las Vegas, NV", add
label define pwcitylbl 3590 "Lexington-Fayette, KY", add
label define pwcitylbl 3650 "Little Rock, AR", add
label define pwcitylbl 3670 "Livonia, MI", add
label define pwcitylbl 3690 "Long Beach, CA", add
label define pwcitylbl 3730 "Los Angeles, CA", add
label define pwcitylbl 3750 "Louisville, KY", add
label define pwcitylbl 3770 "Lowell, MA", add
label define pwcitylbl 3830 "Macon, GA", add
label define pwcitylbl 3870 "Madison, WI", add
label define pwcitylbl 3910 "Manchester, NH", add
label define pwcitylbl 3960 "McAllen, TX", add
label define pwcitylbl 4010 "Memphis, TN", add
label define pwcitylbl 4050 "Mesa, AZ", add
label define pwcitylbl 4070 "Mesquite, TX", add
label define pwcitylbl 4090 "Metairie, LA", add
label define pwcitylbl 4110 "Miami, FL", add
label define pwcitylbl 4130 "Milwaukee, WI", add
label define pwcitylbl 4150 "Minneapolis, MN", add
label define pwcitylbl 4170 "Mobile, AL", add
label define pwcitylbl 4190 "Modesto, CA", add
label define pwcitylbl 4250 "Montgomery, AL", add
label define pwcitylbl 4270 "Moreno Valley, CA", add
label define pwcitylbl 4410 "Nashville-Davidson, TN", add
label define pwcitylbl 4530 "New Haven, CT", add
label define pwcitylbl 4570 "New Orleans, LA", add
label define pwcitylbl 4610 "New York, NY", add
label define pwcitylbl 4630 "Newark, NJ", add
label define pwcitylbl 4750 "Newport News, VA", add
label define pwcitylbl 4810 "Norfolk, VA", add
label define pwcitylbl 4860 "Norwalk, CA", add
label define pwcitylbl 4930 "Oakland, CA", add
label define pwcitylbl 4950 "Oceanside, CA", add
label define pwcitylbl 4990 "Oklahoma City, OK", add
label define pwcitylbl 5010 "Omaha, NE", add
label define pwcitylbl 5030 "Ontario, CA", add
label define pwcitylbl 5070 "Orlando, FL", add
label define pwcitylbl 5130 "Oxnard, CA", add
label define pwcitylbl 5140 "Palmdale, CA", add
label define pwcitylbl 5150 "Pasadena, CA", add
label define pwcitylbl 5170 "Pasadena, TX", add
label define pwcitylbl 5210 "Paterson, NJ", add
label define pwcitylbl 5270 "Peoria, IL", add
label define pwcitylbl 5330 "Philadelphia, PA", add
label define pwcitylbl 5350 "Phoenix, AZ", add
label define pwcitylbl 5370 "Pittsburgh, PA", add
label define pwcitylbl 5430 "Plano, TX", add
label define pwcitylbl 5450 "Pomona, CA", add
label define pwcitylbl 5500 "Ponce, PR", add
label define pwcitylbl 5530 "Portland, OR", add
label define pwcitylbl 5590 "Portsmouth, VA", add
label define pwcitylbl 5650 "Providence, RI", add
label define pwcitylbl 5750 "Raleigh, NC", add
label define pwcitylbl 5770 "Rancho Cucamonga, CA", add
label define pwcitylbl 5810 "Reno, NV", add
label define pwcitylbl 5870 "Richmond, VA", add
label define pwcitylbl 5890 "Riverside, CA", add
label define pwcitylbl 5910 "Roanoke, VA", add
label define pwcitylbl 5930 "Rochester, NY", add
label define pwcitylbl 5970 "Rockford, IL", add
label define pwcitylbl 6030 "Sacramento, CA", add
label define pwcitylbl 6090 "Saint Louis, MO", add
label define pwcitylbl 6110 "Saint Paul, MN", add
label define pwcitylbl 6130 "Saint Petersburg, FL", add
label define pwcitylbl 6170 "Salem, OR", add
label define pwcitylbl 6190 "Salinas, CA", add
label define pwcitylbl 6210 "Salt Lake City, UT", add
label define pwcitylbl 6230 "San Antonio, TX", add
label define pwcitylbl 6250 "San Bernadino, CA", add
label define pwcitylbl 6270 "San Diego, CA", add
label define pwcitylbl 6290 "San Francisco, CA", add
label define pwcitylbl 6310 "San Jose, CA", add
label define pwcitylbl 6320 "San Juan, PR", add
label define pwcitylbl 6330 "Santa Ana, CA", add
label define pwcitylbl 6340 "Santa Clarita, CA", add
label define pwcitylbl 6350 "Santa Rosa, CA", add
label define pwcitylbl 6370 "Savannah, GA", add
label define pwcitylbl 6430 "Seattle, WA", add
label define pwcitylbl 6490 "Shreveport, LA", add
label define pwcitylbl 6500 "Simi Valley, CA", add
label define pwcitylbl 6530 "Sioux Falls, SD", add
label define pwcitylbl 6590 "South Bend, IN", add
label define pwcitylbl 6630 "Spokane, WA", add
label define pwcitylbl 6650 "Springfield, IL", add
label define pwcitylbl 6670 "Springfield, MA", add
label define pwcitylbl 6690 "Springfield, MO", add
label define pwcitylbl 6730 "Stamford, CT", add
label define pwcitylbl 6750 "Sterling Heights, MI", add
label define pwcitylbl 6790 "Stockton, CA", add
label define pwcitylbl 6810 "Sunnyvale, CA", add
label define pwcitylbl 6850 "Syracuse, NY", add
label define pwcitylbl 6870 "Tacoma, WA", add
label define pwcitylbl 6890 "Tampa, FL", add
label define pwcitylbl 6930 "Tempe, AZ", add
label define pwcitylbl 6960 "Thousand Oaks, CA", add
label define pwcitylbl 6970 "Toledo, OH", add
label define pwcitylbl 6990 "Topeka, KS", add
label define pwcitylbl 7000 "Torrance, CA", add
label define pwcitylbl 7050 "Tucson, AZ", add
label define pwcitylbl 7070 "Tulsa, OK", add
label define pwcitylbl 7100 "Vancouver, WA", add
label define pwcitylbl 7110 "Vallejo, CA", add
label define pwcitylbl 7130 "Virginia Beach, VA", add
label define pwcitylbl 7180 "Warren, MI", add
label define pwcitylbl 7230 "Washington, DC", add
label define pwcitylbl 7250 "Waterbury, CT", add
label define pwcitylbl 7320 "West Covina, CA", add
label define pwcitylbl 7410 "Wichita, KS", add
label define pwcitylbl 7530 "Winston-Salem, NC", add
label define pwcitylbl 7570 "Worcester, MA", add
label define pwcitylbl 7590 "Yonkers, NY", add
label define pwcitylbl 7630 "Youngstown, OH", add
label values pwcity pwcitylbl

save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\census90all.dta", replace

keep if bpld>=100 & bpld<=9900
save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\native\census90.dta", replace
