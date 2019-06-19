// ipums_2000.do -- spatial differences in earnings
//
// read in a 5 percent IPUMS sample, downloaded from
// http://usa.ipums.org/usa/index.shtml
// 
// change 'ipums_2000.dat' to appropriate raw data file
// use data dictionary from IPUMS, since variable order may change
//


/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
clear matrix

set mem 900m

//cd C:\ErikMain\entr_evasion

clear
infix ///
 int     year                                 1-4 ///
 byte    datanum                              5-6 ///
 double  serial                               7-14 ///
 float  hhwt                                15-20 ///
 byte    statefip                            21-22 ///
 int     metaread                            23-26 ///
 byte    gq                                  27 ///
 float  perwt                               28-33 ///
 int     relate                              34-35 ///
 int     age                                 36-38 ///
 byte    sex                                 39 ///
 byte    marst                               40 ///
 int     educ                                41-42 ///
 byte    empstat                             43 ///
 byte    classwkr                            44 ///
 byte    wkswork1                            45-46 ///
 byte    uhrswork                            47-48 ///
 long    inctot                              49-55 ///
 long    ftotinc                             56-62 ///
 long    incwage                             63-68 ///
 long    incbus00                            69-74 ///
 using ipums_2000.dat

replace hhwt=hhwt/100
replace perwt=perwt/100

format serial    %8.0f
format hhwt      %10.2f
format strata    %12.0f
format perwt     %10.2f 


label var year `"Census year"'
label var datanum `"Data set number"'
label var serial `"Household serial number"'
label var hhwt `"Household weight"'
label var statefip `"State (FIPS code)"'
label var metaread `"Metropolitan area [detailed version]"'
label var gq `"Group quarters status"'
label var perwt `"Person weight"'
label var relate `"Relationship to household head [general version]"'
label var age `"Age"'
label var sex `"Sex"'
label var marst `"Marital status"'
label var educ `"Educational attainment [general version]"'
label var empstat `"Employment status [general version]"'
label var classwkr `"Class of worker [general version]"'
label var wkswork1 `"Weeks worked last year"'
label var uhrswork `"Usual hours worked per week"'
label var inctot `"Total personal income"'
label var ftotinc `"Total family income"'
label var incwage `"Wage and salary income"'
label var incbus00 `"Business and farm income, 2000"'

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

label define agelbl 000 `"Less than 1 year old"'
label define agelbl 001 `"1"', add
label define agelbl 002 `"2"', add
label define agelbl 003 `"3"', add
label define agelbl 004 `"4"', add
label define agelbl 005 `"5"', add
label define agelbl 006 `"6"', add
label define agelbl 007 `"7"', add
label define agelbl 008 `"8"', add
label define agelbl 009 `"9"', add
label define agelbl 010 `"10"', add
label define agelbl 011 `"11"', add
label define agelbl 012 `"12"', add
label define agelbl 013 `"13"', add
label define agelbl 014 `"14"', add
label define agelbl 015 `"15"', add
label define agelbl 016 `"16"', add
label define agelbl 017 `"17"', add
label define agelbl 018 `"18"', add
label define agelbl 019 `"19"', add
label define agelbl 020 `"20"', add
label define agelbl 021 `"21"', add
label define agelbl 022 `"22"', add
label define agelbl 023 `"23"', add
label define agelbl 024 `"24"', add
label define agelbl 025 `"25"', add
label define agelbl 026 `"26"', add
label define agelbl 027 `"27"', add
label define agelbl 028 `"28"', add
label define agelbl 029 `"29"', add
label define agelbl 030 `"30"', add
label define agelbl 031 `"31"', add
label define agelbl 032 `"32"', add
label define agelbl 033 `"33"', add
label define agelbl 034 `"34"', add
label define agelbl 035 `"35"', add
label define agelbl 036 `"36"', add
label define agelbl 037 `"37"', add
label define agelbl 038 `"38"', add
label define agelbl 039 `"39"', add
label define agelbl 040 `"40"', add
label define agelbl 041 `"41"', add
label define agelbl 042 `"42"', add
label define agelbl 043 `"43"', add
label define agelbl 044 `"44"', add
label define agelbl 045 `"45"', add
label define agelbl 046 `"46"', add
label define agelbl 047 `"47"', add
label define agelbl 048 `"48"', add
label define agelbl 049 `"49"', add
label define agelbl 050 `"50"', add
label define agelbl 051 `"51"', add
label define agelbl 052 `"52"', add
label define agelbl 053 `"53"', add
label define agelbl 054 `"54"', add
label define agelbl 055 `"55"', add
label define agelbl 056 `"56"', add
label define agelbl 057 `"57"', add
label define agelbl 058 `"58"', add
label define agelbl 059 `"59"', add
label define agelbl 060 `"60"', add
label define agelbl 061 `"61"', add
label define agelbl 062 `"62"', add
label define agelbl 063 `"63"', add
label define agelbl 064 `"64"', add
label define agelbl 065 `"65"', add
label define agelbl 066 `"66"', add
label define agelbl 067 `"67"', add
label define agelbl 068 `"68"', add
label define agelbl 069 `"69"', add
label define agelbl 070 `"70"', add
label define agelbl 071 `"71"', add
label define agelbl 072 `"72"', add
label define agelbl 073 `"73"', add
label define agelbl 074 `"74"', add
label define agelbl 075 `"75"', add
label define agelbl 076 `"76"', add
label define agelbl 077 `"77"', add
label define agelbl 078 `"78"', add
label define agelbl 079 `"79"', add
label define agelbl 080 `"80"', add
label define agelbl 081 `"81"', add
label define agelbl 082 `"82"', add
label define agelbl 083 `"83"', add
label define agelbl 084 `"84"', add
label define agelbl 085 `"85"', add
label define agelbl 086 `"86"', add
label define agelbl 087 `"87"', add
label define agelbl 088 `"88"', add
label define agelbl 089 `"89"', add
label define agelbl 090 `"90 (90+ in 1980 and 1990)"', add
label define agelbl 091 `"91"', add
label define agelbl 092 `"92"', add
label define agelbl 093 `"93"', add
label define agelbl 094 `"94"', add
label define agelbl 095 `"95"', add
label define agelbl 096 `"96"', add
label define agelbl 097 `"97"', add
label define agelbl 098 `"98"', add
label define agelbl 099 `"99"', add
label define agelbl 100 `"100 (100+ in 1970)"', add
label define agelbl 101 `"101"', add
label define agelbl 102 `"102"', add
label define agelbl 103 `"103"', add
label define agelbl 104 `"104"', add
label define agelbl 105 `"105"', add
label define agelbl 106 `"106"', add
label define agelbl 107 `"107"', add
label define agelbl 108 `"108"', add
label define agelbl 109 `"109"', add
label define agelbl 110 `"110"', add
label define agelbl 111 `"111"', add
label define agelbl 112 `"112 (112+ in the 1980 internal data)"', add
label define agelbl 113 `"113"', add
label define agelbl 114 `"114"', add
label define agelbl 115 `"115 (115+ in the 1990 internal data)"', add
label define agelbl 116 `"116"', add
label define agelbl 117 `"117"', add
label define agelbl 118 `"118"', add
label define agelbl 119 `"119"', add
label define agelbl 120 `"120"', add
label define agelbl 121 `"121"', add
label define agelbl 122 `"122"', add
label define agelbl 123 `"123"', add
label define agelbl 124 `"124"', add
label define agelbl 125 `"125"', add
label define agelbl 126 `"126"', add
label define agelbl 129 `"129"', add
label define agelbl 130 `"130"', add
label define agelbl 135 `"135"', add
label values age agelbl

label define sexlbl 1 `"Male"'
label define sexlbl 2 `"Female"', add
label values sex sexlbl

label define marstlbl 1 `"Married, spouse present"'
label define marstlbl 2 `"Married, spouse absent"', add
label define marstlbl 3 `"Separated"', add
label define marstlbl 4 `"Divorced"', add
label define marstlbl 5 `"Widowed"', add
label define marstlbl 6 `"Never married/single"', add
label values marst marstlbl

label define educlbl 00 `"N/A or no schooling"'
label define educlbl 01 `"Nursery school to grade 4"', add
label define educlbl 02 `"Grade 5, 6, 7, or 8"', add
label define educlbl 03 `"Grade 9"', add
label define educlbl 04 `"Grade 10"', add
label define educlbl 05 `"Grade 11"', add
label define educlbl 06 `"Grade 12"', add
label define educlbl 07 `"1 year of college"', add
label define educlbl 08 `"2 years of college"', add
label define educlbl 09 `"3 years of college"', add
label define educlbl 10 `"4 years of college"', add
label define educlbl 11 `"5+ years of college"', add
label values educ educlbl

label define empstatlbl 0 `"N/A"'
label define empstatlbl 1 `"Employed"', add
label define empstatlbl 2 `"Unemployed"', add
label define empstatlbl 3 `"Not in labor force"', add
label values empstat empstatlbl

label define classwkrlbl 0 `"N/A"'
label define classwkrlbl 1 `"Self-employed"', add
label define classwkrlbl 2 `"Works for wages"', add
label values classwkr classwkrlbl

#delimit ;

keep if age >= 25 & age <= 64;
keep if relate == 1 | relate == 2 ;
keep if sex == 1 ; 
keep if empstat == 1 ; 
keep if wkswork1 >= 40 ;
keep if uhrswork >= 30 ; 

gen self = classwkr == 1 ; 

#delimit ;

gen lab_bus_inc = incwage + incbus00 ;

#delimit ;

gen lab_bus_inc_adj = lab_bus_inc;
replace lab_bus_inc_adj = lab_bus_inc * 1.25 if self == 1; 

gen ln_labbus_inc = ln(lab_bus_inc);
gen ln_labbus_inc_adj = ln(lab_bus_inc_adj); 

save ipums_2000_extract, replace ;

#delimit ; 

sort metarea ; 
by metarea:  sum self [aw=perwt]; 


#delimit ;

gen nassau = metaread == 5601;
gen sanfran = metaread == 7360 ;

#delimit ;

gen barnstable = metaread == 0740;


#delimit ;

xi: reg  ln_labbus_inc  i.age i.educ i.uhrswork i.wkswork1 [aw = perwt] if  ln_labbus_inc_adj > 0 & ln_labbus_inc > 0 & classwkr ~= 0 
& metaread > 0  ;

predict ln_labbus_inc_hat ;

gen ln_labbus_inc_res = ln_labbus_inc - ln_labbus_inc_hat ; 

#delimit ;
gen ln_labbus_inc_res_adj = ln_labbus_inc_adj - ln_labbus_inc_hat ; 


#delimit
sum self [aw=perwt] if metaread == 5601;
sum self [aw=perwt] if metaread == 2160;
sum self [aw=perwt] if metaread == 0740;
sum self [aw=perwt] if metaread == 3850;

#delimit ;

xi: reg  ln_labbus_inc_res nassau [aw = perwt] if  ln_labbus_inc_adj > 0 & ln_labbus_inc > 0 & classwkr ~= 0 
& (metaread == 5601 | metaread == 2160);


#delimit ;

xi: reg  ln_labbus_inc_res sanfran  [aw = perwt] if  ln_labbus_inc_adj > 0 & ln_labbus_inc > 0 & classwkr ~= 0 
& (metaread == 1280 | metaread == 7360);


#delimit ;

xi: reg  ln_labbus_inc_res barnstable [aw = perwt] if  ln_labbus_inc_adj > 0 & ln_labbus_inc > 0 & classwkr ~= 0 
& (metaread == 0740 | metaread == 3850);


#delimit ;

xi: reg  ln_labbus_inc_res_adj nassau [aw = perwt] if  ln_labbus_inc_adj > 0 & ln_labbus_inc > 0 & classwkr ~= 0 
& (metaread == 5601 | metaread == 2160);


#delimit ;

xi: reg  ln_labbus_inc_res_adj sanfran  [aw = perwt] if  ln_labbus_inc_adj > 0 & ln_labbus_inc > 0 & classwkr ~= 0 
& (metaread == 1280 | metaread == 7360);


#delimit ;

xi: reg  ln_labbus_inc_res_adj barnstable [aw = perwt] if  ln_labbus_inc_adj > 0 & ln_labbus_inc > 0 & classwkr ~= 0 
& (metaread == 0740 | metaread == 3850);



