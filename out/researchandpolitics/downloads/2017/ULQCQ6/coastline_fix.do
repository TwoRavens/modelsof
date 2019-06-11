/* Brian Crisher */
/* File for Naval Power, Endogeneity, and Long-stance Disputes */
/* Fixing coastline data for the naval power instrument */

/* East and West Germany */
replace y_2000 = (3624*0.63) if year >= 1949 & year <= 1990 & ccode == 260
replace y_2000 = (3624*0.37) if year >= 1949 & year <= 1990 & ccode == 265
/* The percentages based on using CIA factbook data. CIA and WSI won't match because
of scale difference. It's not perfect but the CIA doesn't release 
information about their scale data */

/* Korea 1877-1905 */
replace y_2000 = 16487 if year >= 1877 & year <= 1905 & ccode == 730

/*Austro-Hungarian Empire 1880-1918) */
/* Includes modern Austria, Slovenia, Croatia, and Bosnia (countries with a coastline) */
replace y_2000 = 5728 if year >= 1880 & year <= 1918 & ccode == 300

/* Pakistan (East plus West) 1947-1971 */
replace y_2000 = 5905 if year >= 1947 & year <= 1971 & ccode == 770

/* Vietnam (North and South) North (1946-1975) South (1955-75)
Based off of claim that South Vietnam coast was around 1200 miles (1931km),
or 56% of total Vietnam coast. Note that the WRI estimate is MUCH larger than the 
CIA factbook estimate */
replace y_2000 = 11409*0.56 if year >= 1955 & year <= 1975 & ccode == 817
replace y_2000 = 11409*0.44 if year >= 1946 & year <= 1975 & ccode == 816

/* Soviet Union (1946-1991) includes Russia, Estonia, Latvia, Lithuania, Ukraine,
Georiga, Kazahkstan, Turkmenistan, Armenia */
replace y_2000 = 126107 if year >= 1946 & year <= 1990 & ccode == 365

/* Russian Empire (1880-1917) same countries as Soviet Union (missing some coastline 
for a part of Turkey) */
replace y_2000 = 126107 if year >= 1880 & year <= 1917 & ccode == 365

/* Russia post-WWI, drop Estonia, Latvia, and Lithuania 1918-1945 */
replace y_2000 = 122327 if year >= 1918 & year <= 1945 & ccode == 365

/* North and South Yemen, North (1926-1990) South (1967-1990) 
Percentage based CIA factbook data */
replace y_2000 = 3149*0.27 if year >= 1926 & year <= 1990 & ccode == 678
replace y_2000 = 3149*0.73 if year >= 1967 & year <= 1990 & ccode == 680

/* US drop Hawaii 1880-1889 percentage based on CIA factbook */
replace y_2000 = (133312-(133312*0.06)) if year >= 1880 & year <= 1889 & ccode == 2

/* Turkey/Ottoman Empire correction */
/* Pre-WWI includes Turkey, Syria, Israel, Libya,
	Albania, and Saudi Arabia. Will miss some coastline for the
	Macedonia Region. */
replace y_2000 = 11231 if year >= 1880 & year <= 1911 & ccode == 640 /*lost Libya */
replace y_2000 = 9206 if year == 1912 & ccode == 640 /* Lost Albania */
replace y_2000 = 8557 if year >= 1913 & year <= 1918 & ccode == 640 

/* Romania has missing data for some reason */
replace y_2000 = 696 if ccode == 360



