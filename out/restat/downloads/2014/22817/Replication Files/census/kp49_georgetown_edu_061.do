/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 byte    datanum       1-2 ///
 double  serial        3-10 ///
 byte    region       11-12 ///
 int     cityd        13-16 ///
 long    citypop      17-21 ///
 byte    pernum       22-23 ///
 long    bpl          24-26 ///
 byte    wkswork1     27-28 ///
 byte    movedin      29 ///
 using "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\census\kp49_georgetown_edu_061.dat"

label var datanum "Data set number"
label var serial "Household serial number"
label var region "Census region and division"
label var cityd "City [detailed version]"
label var citypop "City population"
label var pernum "Person number in sample unit"
label var bpl "Birthplace [general version]"
label var wkswork1 "Weeks worked last year"
label var movedin "When occupant moved into residence"

label values datanum datanumlbl

label values serial seriallbl

label define regionlbl 11 "New England Division", add
label define regionlbl 12 "Middle Atlantic Division", add
label define regionlbl 21 "East North Central Div.", add
label define regionlbl 22 "West North Central Div.", add
label define regionlbl 31 "South Atlantic Division", add
label define regionlbl 32 "East South Central Div.", add
label define regionlbl 33 "West South Central Div.", add
label define regionlbl 41 "Mountain Division", add
label define regionlbl 42 "Pacific Division", add
label define regionlbl 91 "Military/Military reservations", add
label define regionlbl 92 "PUMA boundaries cross state lines-1% sample", add
label define regionlbl 97 "State not identified", add
label define regionlbl 99 "Not identified", add
label values region regionlbl

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

label values pernum pernumlbl

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

label values wkswork1 wkswork1lbl

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

save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\native and immigrants\census90_5pc_2a_all.dta", replace

drop if bpl>=1 & bpl<=99
save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\immigrants\census90_2a_foreignborn.dta", replace



