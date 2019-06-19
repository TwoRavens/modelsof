clear
set memory 500m

/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 byte    datanum       1-2 ///
 double  serial        3-10 ///
 byte    pernum       11-12 ///
 long    bpl          13-15 ///
 byte    uhrswork     16-17 ///
 int     pwmetro      18-21 ///
 int     pwcity       22-25 ///
 using "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\census\kp49_georgetown_edu_068.dat"



label var datanum "Data set number"
label var serial "Household serial number"
label var pernum "Person number in sample unit"
label var bpl "Birthplace [general version]"
label var uhrswork "Usual hours worked per week"
label var pwmetro "Place of work: metropolitan area"
label var pwcity "Place of work: city"

label values datanum datanumlbl

label values serial seriallbl

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

label values uhrswork uhrsworklbl

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

drop bpl uhrswork
save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\native and immigrants city\census90_5pc_2c_all.dta", replace
