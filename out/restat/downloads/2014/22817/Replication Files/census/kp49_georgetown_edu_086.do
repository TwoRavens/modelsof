clear
set memory 200m

/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 byte    datanum       1-2 ///
 double  serial        3-10 ///
 byte    statefip     11-12 ///
 int     metarea      13-15 ///
 int     metaread     13-16 ///
 byte    pernum       17-18 ///
 int     perwt        19-22 ///
 int     age          23-25 ///
 byte    sex          26 ///
 long    bpl          27-29 ///
 long    bpld         27-31 ///
 byte    empstat      32 ///
 byte    empstatd     32-33 ///
 int     occ1990      34-36 ///
 byte    wkswork2     37 ///
 byte    hrswork2     38 ///
 long    incwage      39-44 ///
 byte    pwtype       45 ///
 using "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\census\kp49_georgetown_edu_086.dat"

label var datanum "Data set number"
label var serial "Household serial number"
label var statefip "State (FIPS code)"
label var metarea "Metropolitan area [general version]"
label var metaread "Metropolitan area [detailed version]"
label var pernum "Person number in sample unit"
label var perwt "Person weight"
label var age "Age"
label var sex "Sex"
label var bpl "Birthplace [general version]"
label var bpld "Birthplace [detailed version]"
label var empstat "Employment status [general version]"
label var empstatd "Employment status [detailed version]"
label var occ1990 "Occupation, 1990 basis"
label var wkswork2 "Weeks worked last year, intervalled"
label var hrswork2 "Hours worked last week, intervalled"
label var incwage "Wage and salary income"
label var pwtype "Place of work: metropolitan status"

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

label define metarealbl 000 "Not identifiable or not in an MSA"
label define metarealbl 004 "Abilene, TX", add
label define metarealbl 008 "Akron, OH", add
label define metarealbl 012 "Albany, GA", add
label define metarealbl 016 "Albany-Schenectady-Troy, NY", add
label define metarealbl 020 "Albuquerque, NM", add
label define metarealbl 022 "Alexandria, LA", add
label define metarealbl 024 "Allentown-Bethlehem-Easton, PA/NJ", add
label define metarealbl 028 "Altoona, PA", add
label define metarealbl 032 "Amarillo, TX", add
label define metarealbl 038 "Anchorage, AK", add
label define metarealbl 040 "Anderson, IN", add
label define metarealbl 044 "Ann Arbor, MI", add
label define metarealbl 045 "Anniston, AL", add
label define metarealbl 046 "Appleton-Oskosh-Neenah, WI", add
label define metarealbl 048 "Asheville, NC", add
label define metarealbl 050 "Athens, GA", add
label define metarealbl 052 "Atlanta, GA", add
label define metarealbl 056 "Atlantic City, NJ", add
label define metarealbl 058 "Auburn-Opekika, AL", add
label define metarealbl 060 "Augusta-Aiken, GA-SC", add
label define metarealbl 064 "Austin, TX", add
label define metarealbl 068 "Bakersfield, CA", add
label define metarealbl 072 "Baltimore, MD", add
label define metarealbl 073 "Bangor, ME", add
label define metarealbl 074 "Barnstable-Yarmouth, MA", add
label define metarealbl 076 "Baton Rouge, LA", add
label define metarealbl 078 "Battle Creek, MI", add
label define metarealbl 084 "Beaumont-Port Arthur-Orange,TX", add
label define metarealbl 086 "Bellingham, WA", add
label define metarealbl 087 "Benton Harbor, MI", add
label define metarealbl 088 "Billings, MT", add
label define metarealbl 092 "Biloxi-Gulfport, MS", add
label define metarealbl 096 "Binghamton, NY", add
label define metarealbl 100 "Birmingham, AL", add
label define metarealbl 102 "Bloomington, IN", add
label define metarealbl 104 "Bloomington-Normal, IL", add
label define metarealbl 108 "Boise City, ID", add
label define metarealbl 112 "Boston, MA-NH", add
label define metarealbl 114 "Bradenton, FL", add
label define metarealbl 115 "Bremerton, WA", add
label define metarealbl 116 "Bridgeport, CT", add
label define metarealbl 120 "Brockton, MA", add
label define metarealbl 124 "Brownsville-Harlingen-San Benito, TX", add
label define metarealbl 126 "Bryan-College Station, TX", add
label define metarealbl 128 "Buffalo-Niagara Falls, NY", add
label define metarealbl 130 "Burlington, NC", add
label define metarealbl 131 "Burlington, VT", add
label define metarealbl 132 "Canton, OH", add
label define metarealbl 135 "Casper, WY", add
label define metarealbl 136 "Cedar Rapids, IA", add
label define metarealbl 140 "Champaign-Urbana-Rantoul, IL", add
label define metarealbl 144 "Charleston-N.Charleston,SC", add
label define metarealbl 148 "Charleston, WV", add
label define metarealbl 152 "Charlotte-Gastonia-Rock Hill, NC-SC", add
label define metarealbl 154 "Charlottesville, VA", add
label define metarealbl 156 "Chattanooga, TN/GA", add
label define metarealbl 158 "Cheyenne, WY", add
label define metarealbl 160 "Chicago, IL", add
label define metarealbl 162 "Chico, CA", add
label define metarealbl 164 "Cincinnati-Hamilton, OH/KY/IN", add
label define metarealbl 166 "Clarksville- Hopkinsville, TN/KY", add
label define metarealbl 168 "Cleveland, OH", add
label define metarealbl 172 "Colorado Springs, CO", add
label define metarealbl 174 "Columbia, MO", add
label define metarealbl 176 "Columbia, SC", add
label define metarealbl 180 "Columbus, GA/AL", add
label define metarealbl 184 "Columbus, OH", add
label define metarealbl 188 "Corpus Christi, TX", add
label define metarealbl 190 "Cumberland, MD/WV", add
label define metarealbl 192 "Dallas-Fort Worth, TX", add
label define metarealbl 193 "Danbury, CT", add
label define metarealbl 195 "Danville, VA", add
label define metarealbl 196 "Davenport, IA-Rock Island -Moline, IL", add
label define metarealbl 200 "Dayton-Springfield, OH", add
label define metarealbl 202 "Daytona Beach, FL", add
label define metarealbl 203 "Decatur, AL", add
label define metarealbl 204 "Decatur, IL", add
label define metarealbl 208 "Denver-Boulder, CO", add
label define metarealbl 212 "Des Moines, IA", add
label define metarealbl 216 "Detroit, MI", add
label define metarealbl 218 "Dothan, AL", add
label define metarealbl 219 "Dover, DE", add
label define metarealbl 220 "Dubuque, IA", add
label define metarealbl 224 "Duluth-Superior, MN/WI", add
label define metarealbl 228 "Dutchess Co., NY", add
label define metarealbl 229 "Eau Claire, WI", add
label define metarealbl 231 "El Paso, TX", add
label define metarealbl 232 "Elkhart-Goshen, IN", add
label define metarealbl 233 "Elmira, NY", add
label define metarealbl 234 "Enid, OK", add
label define metarealbl 236 "Erie, PA", add
label define metarealbl 240 "Eugene-Springfield, OR", add
label define metarealbl 244 "Evansville, IN/KY", add
label define metarealbl 252 "Fargo-Morehead, ND/MN", add
label define metarealbl 256 "Fayetteville, NC", add
label define metarealbl 258 "Fayetteville-Springdale, AR", add
label define metarealbl 260 "Fitchburg-Leominster, MA", add
label define metarealbl 262 "Flagstaff, AZ-UT", add
label define metarealbl 264 "Flint, MI", add
label define metarealbl 265 "Florence, AL", add
label define metarealbl 266 "Florence, SC", add
label define metarealbl 267 "Fort Collins-Loveland, CO", add
label define metarealbl 268 "Fort Lauderdale-Hollywood-Pompano Beach, FL", add
label define metarealbl 270 "Fort Myers-Cape Coral, FL", add
label define metarealbl 271 "Fort Pierce, FL", add
label define metarealbl 272 "Fort Smith, AR/OK", add
label define metarealbl 275 "Fort Walton Beach, FL", add
label define metarealbl 276 "Fort Wayne, IN", add
label define metarealbl 284 "Fresno, CA", add
label define metarealbl 288 "Gadsden, AL", add
label define metarealbl 290 "Gainesville, FL", add
label define metarealbl 292 "Galveston-Texas City, TX", add
label define metarealbl 297 "Glens Falls, NY", add
label define metarealbl 298 "Goldsboro, NC", add
label define metarealbl 299 "Grand Forks, ND", add
label define metarealbl 300 "Grand Rapids, MI", add
label define metarealbl 301 "Grand Junction, CO", add
label define metarealbl 304 "Great Falls, MT", add
label define metarealbl 306 "Greeley, CO", add
label define metarealbl 308 "Green Bay, WI", add
label define metarealbl 312 "Greensboro-Winston Salem-High Point, NC", add
label define metarealbl 315 "Greenville, NC", add
label define metarealbl 316 "Greenville-Spartanburg-Anderson SC", add
label define metarealbl 318 "Hagerstown, MD", add
label define metarealbl 320 "Hamilton-Middleton, OH", add
label define metarealbl 324 "Harrisburg-Lebanon--Carlisle, PA", add
label define metarealbl 328 "Hartford-Bristol-Middleton- New Britain, CT", add
label define metarealbl 329 "Hickory-Morgantown, NC", add
label define metarealbl 330 "Hattiesburg, MS", add
label define metarealbl 332 "Honolulu, HI", add
label define metarealbl 335 "Houma-Thibodoux, LA", add
label define metarealbl 336 "Houston-Brazoria, TX", add
label define metarealbl 340 "Huntington-Ashland, WV/KY/OH", add
label define metarealbl 344 "Huntsville, AL", add
label define metarealbl 348 "Indianapolis, IN", add
label define metarealbl 350 "Iowa City, IA", add
label define metarealbl 352 "Jackson, MI", add
label define metarealbl 356 "Jackson, MS", add
label define metarealbl 358 "Jackson, TN", add
label define metarealbl 359 "Jacksonville, FL", add
label define metarealbl 360 "Jacksonville, NC", add
label define metarealbl 361 "Jamestown-Dunkirk, NY", add
label define metarealbl 362 "Janesville-Beloit, WI", add
label define metarealbl 366 "Johnson City-Kingsport--Bristol, TN/VA", add
label define metarealbl 368 "Johnstown, PA", add
label define metarealbl 371 "Joplin, MO", add
label define metarealbl 372 "Kalamazoo-Portage, MI", add
label define metarealbl 374 "Kankakee, IL", add
label define metarealbl 376 "Kansas City, MO-KS", add
label define metarealbl 380 "Kenosha, WI", add
label define metarealbl 381 "Kileen-Temple, TX", add
label define metarealbl 384 "Knoxville, TN", add
label define metarealbl 385 "Kokomo, IN", add
label define metarealbl 387 "LaCrosse, WI", add
label define metarealbl 388 "Lafayette, LA", add
label define metarealbl 392 "Lafayette-W. Lafayette, IN", add
label define metarealbl 396 "Lake Charles, LA", add
label define metarealbl 398 "Lakeland-Winterhaven, FL", add
label define metarealbl 400 "Lancaster, PA", add
label define metarealbl 404 "Lansing-E. Lansing, MI", add
label define metarealbl 408 "Laredo, TX", add
label define metarealbl 410 "Las Cruces, NM", add
label define metarealbl 412 "Las Vegas, NV", add
label define metarealbl 415 "Lawrence, KS", add
label define metarealbl 420 "Lawton, OK", add
label define metarealbl 424 "Lewiston-Auburn, ME", add
label define metarealbl 428 "Lexington-Fayette, KY", add
label define metarealbl 432 "Lima, OH", add
label define metarealbl 436 "Lincoln, NE", add
label define metarealbl 440 "Little Rock--North Little Rock, AR", add
label define metarealbl 441 "Long Branch-Asbury Park,NJ", add
label define metarealbl 442 "Longview-Marshall, TX", add
label define metarealbl 444 "Lorain-Elyria, OH", add
label define metarealbl 448 "Los Angeles-Long Beach, CA", add
label define metarealbl 452 "Louisville, KY/IN", add
label define metarealbl 460 "Lubbock, TX", add
label define metarealbl 464 "Lynchburg, VA", add
label define metarealbl 468 "Macon-Warner Robins, GA", add
label define metarealbl 472 "Madison, WI", add
label define metarealbl 476 "Manchester, NH", add
label define metarealbl 480 "Mansfield, OH", add
label define metarealbl 488 "McAllen-Edinburg-Pharr-Mission, TX", add
label define metarealbl 489 "Medford, OR", add
label define metarealbl 490 "Melbourne-Titusville-Cocoa-Palm Bay, FL", add
label define metarealbl 492 "Memphis, TN/AR/MS", add
label define metarealbl 494 "Merced, CA", add
label define metarealbl 500 "Miami-Hialeah, FL", add
label define metarealbl 504 "Midland, TX", add
label define metarealbl 508 "Milwaukee, WI", add
label define metarealbl 512 "Minneapolis-St. Paul, MN", add
label define metarealbl 514 "Missoula, MT", add
label define metarealbl 516 "Mobile, AL", add
label define metarealbl 517 "Modesto, CA", add
label define metarealbl 519 "Monmouth-Ocean, NJ", add
label define metarealbl 520 "Monroe, LA", add
label define metarealbl 524 "Montgomery, AL", add
label define metarealbl 528 "Muncie, IN", add
label define metarealbl 532 "Muskegon-Norton Shores-Muskegon Heights, MI", add
label define metarealbl 533 "Myrtle Beach, SC", add
label define metarealbl 534 "Naples, FL", add
label define metarealbl 535 "Nashua, NH", add
label define metarealbl 536 "Nashville, TN", add
label define metarealbl 540 "New Bedford, MA", add
label define metarealbl 546 "New Brunswick-Perth Amboy-Sayreville, NJ", add
label define metarealbl 548 "New Haven-Meriden, CT", add
label define metarealbl 552 "New London-Norwich, CT/RI", add
label define metarealbl 556 "New Orleans, LA", add
label define metarealbl 560 "New York-Northeastern NJ", add
label define metarealbl 564 "Newark, OH", add
label define metarealbl 566 "Newburgh-Middletown, NY", add
label define metarealbl 572 "Norfolk-VA Beach--Newport News, VA", add
label define metarealbl 576 "Norwalk, CT", add
label define metarealbl 579 "Ocala, FL", add
label define metarealbl 580 "Odessa, TX", add
label define metarealbl 588 "Oklahoma City, OK", add
label define metarealbl 591 "Olympia, WA", add
label define metarealbl 592 "Omaha, NE/IA", add
label define metarealbl 595 "Orange, NY", add
label define metarealbl 596 "Orlando, FL", add
label define metarealbl 599 "Owensboro, KY", add
label define metarealbl 601 "Panama City, FL", add
label define metarealbl 602 "Parkersburg-Marietta,WV/OH", add
label define metarealbl 603 "Pascagoula-Moss Point, MS", add
label define metarealbl 608 "Pensacola, FL", add
label define metarealbl 612 "Peoria, IL", add
label define metarealbl 616 "Philadelphia, PA/NJ", add
label define metarealbl 620 "Phoenix, AZ", add
label define metarealbl 628 "Pittsburgh, PA", add
label define metarealbl 632 "Pittsfield, MA", add
label define metarealbl 640 "Portland, ME", add
label define metarealbl 644 "Portland, OR-WA", add
label define metarealbl 645 "Portsmouth-Dover--Rochester, NH/ME", add
label define metarealbl 646 "Poughkeepsie, NY", add
label define metarealbl 648 "Providence-Fall River-Pawtucket, MA/RI", add
label define metarealbl 652 "Provo-Orem, UT", add
label define metarealbl 656 "Pueblo, CO", add
label define metarealbl 658 "Punta Gorda, FL", add
label define metarealbl 660 "Racine, WI", add
label define metarealbl 664 "Raleigh-Durham, NC", add
label define metarealbl 666 "Rapid City, SD", add
label define metarealbl 668 "Reading, PA", add
label define metarealbl 669 "Redding, CA", add
label define metarealbl 672 "Reno, NV", add
label define metarealbl 674 "Richland-Kennewick-Pasco, WA", add
label define metarealbl 676 "Richmond-Petersburg, VA", add
label define metarealbl 678 "Riverside-San Bernadino, CA", add
label define metarealbl 680 "Roanoke, VA", add
label define metarealbl 682 "Rochester, MN", add
label define metarealbl 684 "Rochester, NY", add
label define metarealbl 688 "Rockford, IL", add
label define metarealbl 689 "Rocky Mount, NC", add
label define metarealbl 692 "Sacramento, CA", add
label define metarealbl 696 "Saginaw-Bay City-Midland, MI", add
label define metarealbl 698 "St. Cloud, MN", add
label define metarealbl 700 "St. Joseph, MO", add
label define metarealbl 704 "St. Louis, MO-IL", add
label define metarealbl 708 "Salem, OR", add
label define metarealbl 712 "Salinas-Sea Side-Monterey, CA", add
label define metarealbl 714 "Salisbury-Concord, NC", add
label define metarealbl 716 "Salt Lake City-Ogden, UT", add
label define metarealbl 720 "San Angelo, TX", add
label define metarealbl 724 "San Antonio, TX", add
label define metarealbl 732 "San Diego, CA", add
label define metarealbl 736 "San Francisco-Oakland-Vallejo, CA", add
label define metarealbl 740 "San Jose, CA", add
label define metarealbl 746 "San Luis Obispo-Atascad-P Robles, CA", add
label define metarealbl 747 "Santa Barbara-Santa Maria-Lompoc, CA", add
label define metarealbl 748 "Santa Cruz, CA", add
label define metarealbl 749 "Santa Fe, NM", add
label define metarealbl 750 "Santa Rosa-Petaluma, CA", add
label define metarealbl 751 "Sarasota, FL", add
label define metarealbl 752 "Savannah, GA", add
label define metarealbl 756 "Scranton-Wilkes-Barre, PA", add
label define metarealbl 760 "Seattle-Everett, WA", add
label define metarealbl 761 "Sharon, PA", add
label define metarealbl 762 "Sheboygan, WI", add
label define metarealbl 764 "Sherman-Davidson, TX", add
label define metarealbl 768 "Shreveport, LA", add
label define metarealbl 772 "Sioux City, IA/NE", add
label define metarealbl 776 "Sioux Falls, SD", add
label define metarealbl 780 "South Bend-Mishawaka, IN", add
label define metarealbl 784 "Spokane, WA", add
label define metarealbl 788 "Springfield, IL", add
label define metarealbl 792 "Springfield, MO", add
label define metarealbl 800 "Springfield-Holyoke-Chicopee, MA", add
label define metarealbl 804 "Stamford, CT", add
label define metarealbl 805 "State College, PA", add
label define metarealbl 808 "Steubenville-Weirton,OH/WV", add
label define metarealbl 812 "Stockton, CA", add
label define metarealbl 814 "Sumter, SC", add
label define metarealbl 816 "Syracuse, NY", add
label define metarealbl 820 "Tacoma, WA", add
label define metarealbl 824 "Tallahassee, FL", add
label define metarealbl 828 "Tampa-St. Petersburg-Clearwater, FL", add
label define metarealbl 832 "Terre Haute, IN", add
label define metarealbl 836 "Texarkana, TX/AR", add
label define metarealbl 840 "Toledo, OH/MI", add
label define metarealbl 844 "Topeka, KS", add
label define metarealbl 848 "Trenton, NJ", add
label define metarealbl 852 "Tucson, AZ", add
label define metarealbl 856 "Tulsa, OK", add
label define metarealbl 860 "Tuscaloosa, AL", add
label define metarealbl 864 "Tyler, TX", add
label define metarealbl 868 "Utica-Rome, NY", add
label define metarealbl 873 "Ventura-Oxnard-Simi Valley, CA", add
label define metarealbl 875 "Victoria, TX", add
label define metarealbl 876 "Vineland-Milville-Bridgetown, NJ", add
label define metarealbl 878 "Visalia-Tulare-Porterville, CA", add
label define metarealbl 880 "Waco, TX", add
label define metarealbl 884 "Washington, DC/MD/VA", add
label define metarealbl 888 "Waterbury, CT", add
label define metarealbl 892 "Waterloo-Cedar Falls, IA", add
label define metarealbl 894 "Wausau, WI", add
label define metarealbl 896 "West Palm Beach-Boca Raton-Delray Beach, FL", add
label define metarealbl 900 "Wheeling, WV/OH", add
label define metarealbl 904 "Wichita, KS", add
label define metarealbl 908 "Wichita Falls, TX", add
label define metarealbl 914 "Williamsport, PA", add
label define metarealbl 916 "Wilmington, DE/NJ/MD", add
label define metarealbl 920 "Wilmington, NC", add
label define metarealbl 924 "Worcester, MA", add
label define metarealbl 926 "Yakima, WA", add
label define metarealbl 927 "Yolo, CA", add
label define metarealbl 928 "York, PA", add
label define metarealbl 932 "Youngstown-Warren, OH-PA", add
label define metarealbl 934 "Yuba City, CA", add
label define metarealbl 936 "Yuma, AZ", add
label values metarea metarealbl

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

label define empstatlbl 0 "N/A"
label define empstatlbl 1 "Employed", add
label define empstatlbl 2 "Unemployed", add
label define empstatlbl 3 "Not in labor force", add
label values empstat empstatlbl

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

label define wkswork2lbl 0 "N/A"
label define wkswork2lbl 1 "1-13 weeks", add
label define wkswork2lbl 2 "14-26 weeks", add
label define wkswork2lbl 3 "27-39 weeks", add
label define wkswork2lbl 4 "40-47 weeks", add
label define wkswork2lbl 5 "48-49 weeks", add
label define wkswork2lbl 6 "50-52 weeks", add
label values wkswork2 wkswork2lbl

label define hrswork2lbl 0 "N/A"
label define hrswork2lbl 1 "1-14 hours", add
label define hrswork2lbl 2 "15-29 hours", add
label define hrswork2lbl 3 "30-34 hours", add
label define hrswork2lbl 4 "35-39 hours", add
label define hrswork2lbl 5 "40 hours", add
label define hrswork2lbl 6 "41-48 hours", add
label define hrswork2lbl 7 "49-59 hours", add
label define hrswork2lbl 8 "60+ hours", add
label values hrswork2 hrswork2lbl

label values incwage incwagelbl

label define pwtypelbl 0 "N/A or not identifiable", add
label define pwtypelbl 1 "Works in a metropolitan area, in central city", add
label define pwtypelbl 2 "Works in a metropolitan area, in central city Central Busine", add
label define pwtypelbl 3 "Works in a metropolitan area, in central city, not Central B", add
label define pwtypelbl 4 "Works, in a metropolitan area, Not central city", add
label define pwtypelbl 5 "Central city status unknown", add
label define pwtypelbl 6 "Does not work in a metropolitan area, outside metropolitan a", add
label define pwtypelbl 7 "Does not work in a metropolitan area, outside metropolitan a", add
label define pwtypelbl 8 "Does not work in a metropolitan area, outside metropolitan a", add
label define pwtypelbl 9 "Not reported", add
label values pwtype pwtypelbl

save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\native and immigrants\census70.dta", replace
