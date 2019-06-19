clear

set memory 500m

/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 byte    datanum       1-2 ///
 double  serial        3-10 ///
 byte    statefip     11-12 ///
 int     metaread     13-16 ///
 byte    pernum       17-18 ///
 int     perwt        19-22 ///
 int     age          23-25 ///
 byte    sex          26 ///
 long    bpl          27-29 ///
 byte    yrsusa1      30-31 ///
 using "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\census\kp49_georgetown_edu_054.dat"



label var datanum "Data set number"
label var serial "Household serial number"
label var statefip "State (FIPS code)"
label var metaread "Metropolitan area [detailed version]"
label var pernum "Person number in sample unit"
label var perwt "Person weight"
label var age "Age"
label var sex "Sex"
label var bpl "Birthplace [general version]"
label var yrsusa1 "Years in the United States"

label values datanum datanumlbl

label values serial seriallbl

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

label values pernum pernumlbl

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

label define bpllbl 001 "Alabama", add
label define bpllbl 002 "Alaska", add
label define bpllbl 004 "Arizona", add
label define bpllbl 005 "Arkansas", add
label define bpllbl 006 "California", add
label define bpllbl 008 "Colorado", add
label define bpllbl 009 "Connecticut", add
label define bpllbl 010 "Delaware", add
label define bpllbl 011 "District of Columbia", add
label define bpllbl 012 "Florida", add
label define bpllbl 013 "Georgia", add
label define bpllbl 015 "Hawaii", add
label define bpllbl 016 "Idaho", add
label define bpllbl 017 "Illinois", add
label define bpllbl 018 "Indiana", add
label define bpllbl 019 "Iowa", add
label define bpllbl 020 "Kansas", add
label define bpllbl 021 "Kentucky", add
label define bpllbl 022 "Louisiana", add
label define bpllbl 023 "Maine", add
label define bpllbl 024 "Maryland", add
label define bpllbl 025 "Massachusetts", add
label define bpllbl 026 "Michigan", add
label define bpllbl 027 "Minnesota", add
label define bpllbl 028 "Mississippi", add
label define bpllbl 029 "Missouri", add
label define bpllbl 030 "Montana", add
label define bpllbl 031 "Nebraska", add
label define bpllbl 032 "Nevada", add
label define bpllbl 033 "New Hampshire", add
label define bpllbl 034 "New Jersey", add
label define bpllbl 035 "New Mexico", add
label define bpllbl 036 "New York", add
label define bpllbl 037 "North Carolina", add
label define bpllbl 038 "North Dakota", add
label define bpllbl 039 "Ohio", add
label define bpllbl 040 "Oklahoma", add
label define bpllbl 041 "Oregon", add
label define bpllbl 042 "Pennsylvania", add
label define bpllbl 044 "Rhode Island", add
label define bpllbl 045 "South Carolina", add
label define bpllbl 046 "South Dakota", add
label define bpllbl 047 "Tennessee", add
label define bpllbl 048 "Texas", add
label define bpllbl 049 "Utah", add
label define bpllbl 050 "Vermont", add
label define bpllbl 051 "Virginia", add
label define bpllbl 053 "Washington", add
label define bpllbl 054 "West Virginia", add
label define bpllbl 055 "Wisconsin", add
label define bpllbl 056 "Wyoming", add
label define bpllbl 090 "Native American", add
label define bpllbl 099 "United States, ns", add
label define bpllbl 100 "American Samoa", add
label define bpllbl 105 "Guam", add
label define bpllbl 110 "Puerto Rico", add
label define bpllbl 115 "U.S. Virgin Islands", add
label define bpllbl 120 "Other US Possessions", add
label define bpllbl 150 "Canada", add
label define bpllbl 155 "St. Pierre and Miquelon", add
label define bpllbl 160 "Atlantic Islands", add
label define bpllbl 199 "North America, ns", add
label define bpllbl 200 "Mexico", add
label define bpllbl 210 "Central America", add
label define bpllbl 250 "Cuba", add
label define bpllbl 260 "West Indies", add
label define bpllbl 300 "SOUTH AMERICA", add
label define bpllbl 400 "Denmark", add
label define bpllbl 401 "Finland", add
label define bpllbl 402 "Iceland", add
label define bpllbl 403 "Lapland, n.s.", add
label define bpllbl 404 "Norway", add
label define bpllbl 405 "Sweden", add
label define bpllbl 410 "England", add
label define bpllbl 411 "Scotland", add
label define bpllbl 412 "Wales", add
label define bpllbl 413 "United Kingdom, ns", add
label define bpllbl 414 "Ireland", add
label define bpllbl 419 "Northern Europe, ns", add
label define bpllbl 420 "Belgium", add
label define bpllbl 421 "France", add
label define bpllbl 422 "Liechtenstein", add
label define bpllbl 423 "Luxembourg", add
label define bpllbl 424 "Monaco", add
label define bpllbl 425 "Netherlands", add
label define bpllbl 426 "Switerland", add
label define bpllbl 429 "Western Europe, ns", add
label define bpllbl 430 "Albania", add
label define bpllbl 431 "Andorra", add
label define bpllbl 432 "Gibraltar", add
label define bpllbl 433 "Greece", add
label define bpllbl 434 "Italy", add
label define bpllbl 435 "Malta", add
label define bpllbl 436 "Portugal", add
label define bpllbl 437 "San Marino", add
label define bpllbl 438 "Spain", add
label define bpllbl 439 "Vatican City", add
label define bpllbl 440 "Southern Europe, ns", add
label define bpllbl 450 "Austria", add
label define bpllbl 451 "Bulgaria", add
label define bpllbl 452 "Czechoslovakia", add
label define bpllbl 453 "Germany", add
label define bpllbl 454 "Hungary", add
label define bpllbl 455 "Poland", add
label define bpllbl 456 "Romania", add
label define bpllbl 457 "Yugoslavia", add
label define bpllbl 458 "Central Europe, ns", add
label define bpllbl 459 "Eastern Europe, ns", add
label define bpllbl 460 "Estonia", add
label define bpllbl 461 "Latvia", add
label define bpllbl 462 "Lithuania", add
label define bpllbl 463 "Baltic States, ns", add
label define bpllbl 465 "Other USSR/Russia", add
label define bpllbl 499 "Europe, ns", add
label define bpllbl 500 "China", add
label define bpllbl 501 "Japan", add
label define bpllbl 502 "Korea", add
label define bpllbl 509 "East Asia, ns", add
label define bpllbl 510 "Brunei", add
label define bpllbl 511 "Cambodia (Kampuchea)", add
label define bpllbl 512 "Indonesia", add
label define bpllbl 513 "Laos", add
label define bpllbl 514 "Malaysia", add
label define bpllbl 515 "Philippines", add
label define bpllbl 516 "Singapore", add
label define bpllbl 517 "Thailand", add
label define bpllbl 518 "Vietnam", add
label define bpllbl 519 "Southeast Asia, ns", add
label define bpllbl 520 "Afghanistan", add
label define bpllbl 521 "India", add
label define bpllbl 522 "Iran", add
label define bpllbl 523 "Maldives", add
label define bpllbl 524 "Nepal", add
label define bpllbl 530 "Bahrain", add
label define bpllbl 531 "Cyprus", add
label define bpllbl 532 "Iraq", add
label define bpllbl 533 "Iraq/Saudi Arabia", add
label define bpllbl 534 "Israel/Palestine", add
label define bpllbl 535 "Jordan", add
label define bpllbl 536 "Kuwait", add
label define bpllbl 537 "Lebanon", add
label define bpllbl 538 "Oman", add
label define bpllbl 539 "Qatar", add
label define bpllbl 540 "Saudi Arabia", add
label define bpllbl 541 "Syria", add
label define bpllbl 542 "Turkey", add
label define bpllbl 543 "United Arab Emirates", add
label define bpllbl 544 "Yemen Arab Republic (North)", add
label define bpllbl 545 "Yemen, PDR (South)", add
label define bpllbl 546 "Persian Gulf States, n.s.", add
label define bpllbl 547 "Middle East, ns", add
label define bpllbl 548 "Southwest Asia, nec/ns", add
label define bpllbl 549 "Asia Minor, ns", add
label define bpllbl 550 "South Asia, nec", add
label define bpllbl 599 "Asia, nec/ns", add
label define bpllbl 600 "AFRICA", add
label define bpllbl 700 "Australia and New Zealand", add
label define bpllbl 710 "Pacific Islands", add
label define bpllbl 800 "Antarctica, ns/nec", add
label define bpllbl 900 "Abroad (unknown) or at sea", add
label define bpllbl 950 "Other, nec", add
label values bpl bpllbl

label values yrsusa1 yrsusa1lbl

drop age sex yrsusa1
save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\native and immigrants\census00_5pc_1a_all.dta", replace
