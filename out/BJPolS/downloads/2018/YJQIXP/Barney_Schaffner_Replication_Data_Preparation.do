**********************************************************************************************
**********************************************************************************************
****  STATA REPLICATION CODE - DATA PREPARATION                                          *****
****  Title: "Reexamining the Effect of Mass Shootings on Public Support for Gun Control"*****
****  Authors: David J. Barney and Brian F. Schaffner                                    *****
****  Journal: British Journal of Political Science                                      *****
****  Version: April 2018  (Version 2)                                                   *****
**********************************************************************************************
**********************************************************************************************

*** IMPORTANT NOTE ***
* You must set your working directory to the folder containing all of the data used here
* To do so, uncomment the line below, and replace "Filepath" with the correct filepath
* cd "Filepath/BJPS Replication Materials/"

* Install geodist (if not already installed)
ssc install geodist

* Install distinct (if not already installed)
ssc install distinct

******************************************************************************
** Data preparation for Table 1                                          *****
** Newman and Hartman's 2010-2012 Subset of the 2010-2012-2014 CCES Panel*****
** Includes Newman and Hartman's author-added contextual variables       *****
** Newman and Hartman's data found here:  doi:10.7910/DVN/TOE8I1         *****
******************************************************************************
import delimited "2010-2012_CCES with_Mass_Public_Shootings_and_Contexual_Variables_Stata_12.tab"

** Add Barney and Schaffner's coding of the treatment

** Geocoding identified with the locations listed in the Stanford Mass Shootings in American Database
** Coordinates geocoded with the following service:
** http://geoservices.tamu.edu/Services/Geocode/Interactive/

*Tucson, AZ
geodist 32.3358555 -110.9747318 centroid_lat centroid_lon, gen(dist1) mi

*Youngstown, OH
geodist 41.097435 -80.652249 centroid_lat centroid_lon, gen(dist2) mi

*Grand Rapids, MI
geodist 42.963193 -85.659686 centroid_lat centroid_lon, gen(dist3) mi

*Carson City, NV
geodist 39.170644 -119.78193 centroid_lat centroid_lon, gen(dist4) mi

*Seal Beach, CA
geodist 33.760225 -118.080806 centroid_lat centroid_lon, gen(dist5) mi

*Birmingham, AL
geodist 33.515462 -86.821045 centroid_lat centroid_lon, gen(dist6) mi

*Chardon, OH
geodist 41.569436 -81.203372 centroid_lat centroid_lon, gen(dist7) mi

*Oakland, CA
geodist 37.802583 -122.208576 centroid_lat centroid_lon, gen(dist8) mi

*Seattle, WA
geodist 47.632744 -122.321885 centroid_lat centroid_lon, gen(dist9) mi

*Auburn, AL 
geodist 32.602139 	-85.508496 centroid_lat centroid_lon, gen(dist10) mi

*Denver, CO
geodist 39.694487 -104.832515 centroid_lat centroid_lon, gen(dist11) mi

*Oak Creek, WI
geodist 42.88606 -87.903062 centroid_lat centroid_lon, gen(dist12) mi

*Minneapolis, MN
geodist 44.961027 -93.263429 centroid_lat centroid_lon, gen(dist13) mi

*Miami, FL
geodist 25.816413 -80.206972 centroid_lat centroid_lon, gen(dist14) mi

*Morgantown, WV
geodist 39.629524 -79.955894 centroid_lat centroid_lon, gen(dist15) mi

*Tulsa, OK
geodist 36.145326 -95.90613 centroid_lat centroid_lon, gen(dist16) mi

*Create a variable of the minimum distance to a shooting in this wave
egen min_dist = rowmin(dist1-dist16) 

*Treatment indicator for living within 100 miles of a shooting between panel waves
gen treat_100mi = 1 if min_dist <= 100 
replace treat_100mi = 0 if min_dist > 100 & min_dist~=.


** Add Barney and Schaffner's coding of residence within 100 miles of a mass shooting in the decade prior to the panel
** These events were identified with the Stanford Mass Shootings in America Database

*Boston, 2000
geodist 42.30904091 -71.10271358 centroid_lat centroid_lon, gen(d_dist1) mi

*Melrose Park, 2001
geodist 41.90289602 -87.8643021 centroid_lat centroid_lon, gen(d_dist2) mi

*San Diego, 2001
geodist 32.86357277 -117.1281628 centroid_lat centroid_lon, gen(d_dist3) mi

*Grundy, 2002
geodist 37.27537712 -82.09877234 centroid_lat centroid_lon, gen(d_dist4) mi

*Tucson, 2002
geodist 32.2389308 -110.945555 centroid_lat centroid_lon, gen(d_dist5) mi

*Cleveland, 2003
geodist 41.47657557 -81.68051502 centroid_lat centroid_lon, gen(d_dist6) mi

*Meridian, 2003
geodist 32.38455246 -88.68967949 centroid_lat centroid_lon, gen(d_dist7) mi

*Chicago, 2003
geodist 41.83928045 -87.68818145 centroid_lat centroid_lon, gen(d_dist8) mi

*Birchwood, 2004
geodist 45.65773714 -91.55077175 centroid_lat centroid_lon, gen(d_dist9) mi

*Columbus, 2003
geodist 39.98861445 -82.98904135 centroid_lat centroid_lon, gen(d_dist10) mi

*Tyler, 2005
geodist 32.3154272 -95.30501087 centroid_lat centroid_lon, gen(d_dist11) mi

*Brookfield, 2005
geodist 43.06396691 -88.12299758 centroid_lat centroid_lon, gen(d_dist12) mi

*Seattle, 2006
geodist 47.62199575 -122.323646 centroid_lat centroid_lon, gen(d_dist13) mi

*Essex Junction, 2006
geodist 44.49022039 -73.11400628 centroid_lat centroid_lon, gen(d_dist14) mi

*Hillsborough, 2006
geodist 36.04099857 -79.09701201 centroid_lat centroid_lon, gen(d_dist15) mi

*Pittsburgh, 2006
geodist 40.43948548 -79.97631581 centroid_lat centroid_lon, gen(d_dist16) mi

*Lancaster, 2006
geodist 40.04214385 -76.30100872 centroid_lat centroid_lon, gen(d_dist17) mi

*Salt Lake City, 2007
geodist 40.77787404 -111.9312168 centroid_lat centroid_lon, gen(d_dist18) mi

*Gresham, 2007
geodist 45.50216511 -122.4412759 centroid_lat centroid_lon, gen(d_dist19) mi

*Blacksburg, 2007
geodist 37.22995471 -80.42768677 centroid_lat centroid_lon, gen(d_dist20) mi

*Crandon, 2007
geodist 45.56871416 -88.89729022 centroid_lat centroid_lon, gen(d_dist21) mi

*Cleveland, 2007
geodist 41.47657557 -81.68051502 centroid_lat centroid_lon, gen(d_dist22) mi

*Saginaw, 2007
geodist 43.41929117 -83.95032759 centroid_lat centroid_lon, gen(d_dist23) mi

*Omaha, 2007
geodist 41.265922 -96.05381421 centroid_lat centroid_lon, gen(d_dist24) mi

*Las Vegas, 2007
geodist 36.18931923 -115.3264875 centroid_lat centroid_lon, gen(d_dist25) mi

*Carnation, 2007
geodist 47.64628742 -121.9088524 centroid_lat centroid_lon, gen(d_dist26) mi

*Kirkwood, 2008
geodist 38.57889169 -90.42023754 centroid_lat centroid_lon, gen(d_dist27) mi

*DeKalb, 2008
geodist 41.93172129 -88.74814853 centroid_lat centroid_lon, gen(d_dist28) mi

*Henderson, 2008
geodist 37.84040411 -87.57853755 centroid_lat centroid_lon, gen(d_dist29) mi

*Phoenix, 2008
geodist 33.57145875 -112.0904854 centroid_lat centroid_lon, gen(d_dist30) mi

*Conway, 2008
geodist 35.08130744 -92.43278275 centroid_lat centroid_lon, gen(d_dist31) mi

*Covina, 2008
geodist 34.09026669 -117.8819958 centroid_lat centroid_lon, gen(d_dist32) mi

*Santa Clara, 2009
geodist 37.36463172 -121.9679315 centroid_lat centroid_lon, gen(d_dist33) mi

*Carthage, 2009
geodist 35.33985609 -79.41381725 centroid_lat centroid_lon, gen(d_dist34) mi

*Binghamton, 2009
geodist 42.10140103 -75.90922294 centroid_lat centroid_lon, gen(d_dist35) mi

*Fort Hood, 2009
geodist 31.13814354 -97.77797804 centroid_lat centroid_lon, gen(d_dist36) mi

*Lakewood, 2009
geodist 47.16267579 -122.5296574 centroid_lat centroid_lon, gen(d_dist37) mi

*Huntsville, 2010
geodist 34.72827538 -86.6723055 centroid_lat centroid_lon, gen(d_dist38) mi

*Manchester, 2010
geodist 41.78013821 -72.51918655 centroid_lat centroid_lon, gen(d_dist39) mi

*Create variable for minimum distance to shootings in the decade prior to the panel
egen min_d_dist = rowmin(d_dist1-d_dist39)

*Pre-treatment indicator of living within 100 miles of shootings in the past decade
gen pds_100mi = 1 if min_d_dist <= 100
replace pds_100mi = 0 if min_d_dist > 100 & min_d_dist~=.

*OUR TREATMENT INDICATOR PLUS A CONTROL FOR PROXIMITY TO A SHOOTING IN THE DECADE PRIOR
*Normal hashtag interactions not allowed in gllamm
gen treat_interaction = treat_100mi*pds_100mi

** Generate constant for multilevel models
gen cons = 1

saveold CCES_10_12_14_panel_2year_subset.dta, replace

clear


******************************************************************************
** Data preparation for Table 2                                          *****
** 2010-2012 CCES Panel Study                                            *****
** Note that these data are already converted to "long form"             *****
** Original "wide form" data can be found below.                         *****
** doi:10.7910/DVN/24416                                                 *****
******************************************************************************
use longform_10_12.dta, clear

*Set for time series
xtset caseid year, delta(2)

*Merge ZIP-to-county crosswalk for completeness
merge m:1 regzip_pre using COUNTY_ZIP_032010_2YP.dta, force
ren _merge zip_county_merge

*Convert countyfips to numeric
destring countyfips, replace
destring countyfips_post, replace

*Previous treatment in media market
*Identify media markets that were treated in the previous decade
*Manually coding treated ZIP codes in the previous decade
*The treated zip codes are identified by using the latitude and longitude provided by the Stanford MSA database
gen pds_treated_zip = 0
*Boston, 2000
replace pds_treated_zip=1 if regzip_pre==02130
*Melrose Park, 2001
replace pds_treated_zip=1 if regzip_pre==60160
*San Diego, 2001
replace pds_treated_zip=1 if regzip_pre==92145
*Grundy, 2002
replace pds_treated_zip=1 if regzip_pre==24614
*Tucson 2002
replace pds_treated_zip=1 if regzip_pre==85706
*Cleveland, 2003
replace pds_treated_zip=1 if regzip_pre==44113
*Meridian, 2003
replace pds_treated_zip=1 if regzip_pre==39301
*Chicago, 2003
replace pds_treated_zip=1 if regzip_pre==60608
*Birchwood, 2004
replace pds_treated_zip=1 if regzip_pre==54817
*Columbus, 2004
replace pds_treated_zip=1 if regzip_pre==43201
*Tyler, 2005
replace pds_treated_zip=1 if regzip_pre==75701
*Brookfield, 2005
replace pds_treated_zip=1 if regzip_pre==53005
*Seattle, 2006
replace pds_treated_zip=1 if regzip_pre==98102
*Essex Junction, 2006
replace pds_treated_zip=1 if regzip_pre==05452
*Hillsborough, 2006
replace pds_treated_zip=1 if regzip_pre==27278
*Pittsburgh, 2006
replace pds_treated_zip=1 if regzip_pre==15219
*Lancaster, 2006
replace pds_treated_zip=1 if regzip_pre==17602
*Salt Lake City, 2007
replace pds_treated_zip=1 if regzip_pre==84116
*Gresham, 2007
replace pds_treated_zip=1 if regzip_pre==97030
*Blacksburg, 2007
replace pds_treated_zip=1 if regzip_pre==24060
*Crandon, 2007
replace pds_treated_zip=1 if regzip_pre==54520
*Cleveland, 2007
replace pds_treated_zip=1 if regzip_pre==44113
*Saginaw, 2007
replace pds_treated_zip=1 if regzip_pre==48601
*Omaha, 2007
replace pds_treated_zip=1 if regzip_pre==68114
*Las Vegas, 2007
replace pds_treated_zip=1 if regzip_pre==89144
*Carnation, 2007
replace pds_treated_zip=1 if regzip_pre==98014
*Kirkwood, 2008
replace pds_treated_zip=1 if regzip_pre==63122
*DeKalb, 2008
replace pds_treated_zip=1 if regzip_pre==60115
*Henderson, 2008
replace pds_treated_zip=1 if regzip_pre==42420
*Phoenix, 2008
replace pds_treated_zip=1 if regzip_pre==85021
*Conway, 2008
replace pds_treated_zip=1 if regzip_pre==72032
*Covina, 2008
replace pds_treated_zip=1 if regzip_pre==91723
*Santa Clara, 2009
replace pds_treated_zip=1 if regzip_pre==95051
*Carthage, 2009
replace pds_treated_zip=1 if regzip_pre==28327
*Binghamton, 2009
replace pds_treated_zip=1 if regzip_pre==13901
*Fort Hood, 2009
replace pds_treated_zip=1 if regzip_pre==76544
*Lakewood, 2009
replace pds_treated_zip=1 if regzip_pre==98499
*Huntsville, 2010
replace pds_treated_zip=1 if regzip_pre==35806
*Manchester, 2010
replace pds_treated_zip=1 if regzip_pre==06040

*Bring in media market data
*Merge in DMAs (media markets) and their treatment indicators
merge m:1 countyfips using DMA_county_working.dta
ren _merge merge_dma

*Identify the counties not within a DMA
tab countyfips if merge_dma==1 & caseid !=.
*2240 is Southeast Fairnbanks Census Area, AK, which is in the "Fairbanks plus" DMA
recode dmaindex .=203 if countyfips==2240

*8014 is Broomfield County, CO, which is in the Denver DMA
recode dmaindex .=18 if countyfips==8014

*12086 is an old FIPS for Miami-Dade county
recode dmaindex .=17 if countyfips==12086

*Merge in DMA treatment indicators
merge m:1 regzip_pre year using DMA_2y_indicators.dta
ren _merge merge_dma_t

*Recoding non-treated ZIPs
recode treatment_zip .=0

*NOTE1: We have to retain these 5 extra obs until the end of preparation*
*NOTE2: No respondents live in these zips, but shootings occured there***
*NOTE3: So we must create all treatment indicators and then drop those 5*

*Looking at treated zips within their DMAs
tab regzip_pre dmaindex if treatment_zip==1 & year==2012

distinct regzip_pre dmaindex if treatment_zip==1 & year==2012

*We have 16 unique ZIP codes where shootings happened, but only 11 unique DMAs
*So after identifying the treated dmas via the next crosstab:
tab dmaindex if year==2012 & treatment_zip==1

*Manually generate a DMA treatment variable
gen treated_dma=0
replace treated_dma=1 if dmaindex==2 & year==2012
replace treated_dma=1 if dmaindex==5 & year==2012
replace treated_dma=1 if dmaindex==12 & year==2012
replace treated_dma=1 if dmaindex==14 & year==2012
replace treated_dma=1 if dmaindex==15 & year==2012
replace treated_dma=1 if dmaindex==18 & year==2012
replace treated_dma=1 if dmaindex==21 & year==2012
replace treated_dma=1 if dmaindex==31 & year==2012
replace treated_dma=1 if dmaindex==38 & year==2012
replace treated_dma=1 if dmaindex==74 & year==2012
replace treated_dma=1 if dmaindex==114 & year==2012

*Manually generate a DMA treatment variable for shootings in the PREVIOUS DECADE
tab dmaindex if pds_treated_zip==1

gen pds_treated_dma=0
replace pds_treated_dma=1 if dmaindex==2
replace pds_treated_dma=1 if dmaindex==3
replace pds_treated_dma=1 if dmaindex==5
replace pds_treated_dma=1 if dmaindex==6
replace pds_treated_dma=1 if dmaindex==12
replace pds_treated_dma=1 if dmaindex==15
replace pds_treated_dma=1 if dmaindex==16
replace pds_treated_dma=1 if dmaindex==21
replace pds_treated_dma=1 if dmaindex==22
replace pds_treated_dma=1 if dmaindex==23
replace pds_treated_dma=1 if dmaindex==29
replace pds_treated_dma=1 if dmaindex==31
replace pds_treated_dma=1 if dmaindex==34
replace pds_treated_dma=1 if dmaindex==36
replace pds_treated_dma=1 if dmaindex==47
replace pds_treated_dma=1 if dmaindex==52
replace pds_treated_dma=1 if dmaindex==56
replace pds_treated_dma=1 if dmaindex==64
replace pds_treated_dma=1 if dmaindex==67
replace pds_treated_dma=1 if dmaindex==74
replace pds_treated_dma=1 if dmaindex==78
replace pds_treated_dma=1 if dmaindex==83
replace pds_treated_dma=1 if dmaindex==91
replace pds_treated_dma=1 if dmaindex==99
replace pds_treated_dma=1 if dmaindex==154


*Now that we have used ZIPs that include no respondents to create the previous decade media market treatments, drop unmatched observations
drop if zip_county_merge==2
drop if merge_dma==2



*Merge in murders per capita by county for 2010 and 2012
merge m:1 countyfips year using mpc_10_12_longform.dta
drop if _m==2
drop _m

*Merge ZIP-to-coordinates crosswalk for completeness
merge m:1 regzip_pre using ZIP_to_coordinates_2YP.dta
drop if _m==2
ren _merge merge_zip_coord

*Finding coordinates for those that didn't get merged lat and lng
tab regzip_pre if merge_zip_coord==1 & lat==. & lng==.

*The non-matched ZIPs from the zip-to-coordinates merge do have countyfips
*But these zips do not have lat and lng coordinates

*Verify that these are all missing
count if lat==.
count if lng==.


*Manually code the lat and lng for these
replace lat = 41.8243 if regzip_pre==02901
replace lng = -71.4151 if regzip_pre==02901

replace lat = 43.6718 if regzip_pre==05088
replace lng = -72.3092 if regzip_pre==05088

replace lat = 42.0353 if regzip_pre==06079
replace lng = -73.4043 if regzip_pre==06079

replace lat = 41.8977 if regzip_pre==06258
replace lng = -71.9598 if regzip_pre==06258

replace lat = 40.9061 if regzip_pre==07543
replace lng = -74.1527 if regzip_pre==07543

replace lat = 41.056 if regzip_pre==07875 
replace lng = -74.8626 if regzip_pre==07875

replace lat = 40.312 if regzip_pre==08541
replace lng = -74.6553 if regzip_pre==08541

replace lat = 41.3324 if regzip_pre==10587
replace lng = -73.7364 if regzip_pre==10587

replace lat = 42.6771 if regzip_pre==14083
replace lng = -78.4313 if regzip_pre==14083

replace lat = 43.2111 if regzip_pre==14413
replace lng = -76.9803 if regzip_pre==14413

replace lat = 43.2525 if regzip_pre==14515
replace lng = -77.7329 if regzip_pre==14515

replace lat = 40.2975 if regzip_pre==17106
replace lng = -76.8777 if regzip_pre==17106

replace lat = 39.158 if regzip_pre==19903
replace lng = -75.5233 if regzip_pre==19903

replace lat = 39.0567 if regzip_pre==20131
replace lng = -77.7393 if regzip_pre==20131

replace lat = 39.0195 if regzip_pre==20146
replace lng = -77.4619 if regzip_pre==20146

replace lat = 38.2559 if regzip_pre==22965
replace lng = -78.3985 if regzip_pre==22965

replace lat = 37.2224 if regzip_pre==24619
replace lng = -81.5187 if regzip_pre==24619

replace lat = 37.3646 if regzip_pre==24739
replace lng = -81.0465 if regzip_pre==24739

replace lat = 38.3765 if regzip_pre==25387
replace lng = -81.6679 if regzip_pre==25387

replace lat = 39.4566 if regzip_pre==25402
replace lng = -77.9658 if regzip_pre==25402

replace lat = 36.0666 if regzip_pre==27412
replace lng = -79.8058 if regzip_pre==27412

replace lat = 36.0708 if regzip_pre==27413
replace lng = -79.8107 if regzip_pre==27413

replace lat = 34.9813 if regzip_pre==28111
replace lng = -80.5521 if regzip_pre==28111

replace lat = 33.9844 if regzip_pre==29071
replace lng = -81.2516 if regzip_pre==29071

replace lat = 33.6892 if regzip_pre==29578
replace lng = -78.8872 if regzip_pre==29578

replace lat = 34.2448 if regzip_pre==30123
replace lng = -84.8572 if regzip_pre==30123

replace lat = 33.837 if regzip_pre==30355
replace lng = -84.3689 if regzip_pre==30355

replace lat = 28.852 if regzip_pre==32163
replace lng = -81.9879 if regzip_pre==32163

replace lat = 29.0386 if regzip_pre==32170
replace lng = -80.8982 if regzip_pre==32170

replace lat = 30.1723 if regzip_pre==32412
replace lng = -85.6334 if regzip_pre==32412

replace lat = 30.4407 if regzip_pre==32513
replace lng = -87.2065 if regzip_pre==32513

replace lat = 28.8891 if regzip_pre==32753
replace lng = -81.3071 if regzip_pre==32753

replace lat = 27.857 if regzip_pre==33568
replace lng = -82.3237 if regzip_pre==33568

replace lat = 28.0375 if regzip_pre==33687
replace lng = -82.3935 if regzip_pre==33687

replace lat = 26.9367 if regzip_pre==33951
replace lng = -82.049 if regzip_pre==33951

replace lat = 27.4036 if regzip_pre==34270
replace lng = -82.5389 if regzip_pre==34270

replace lat = 31.8932 if regzip_pre==36072 
replace lng = -85.138 if regzip_pre==36072 

replace lat = 30.4081 if regzip_pre==36536
replace lng = -87.6852 if regzip_pre==36536

replace lat = 30.2484 if regzip_pre==36547
replace lng = -87.6916 if regzip_pre==36547

replace lat = 35.0249 if regzip_pre==38130
replace lng = -89.9819 if regzip_pre==38130

replace lat = 33.7822 if regzip_pre==38902
replace lng = -89.8278 if regzip_pre==38902

replace lat = 30.3735 if regzip_pre==39502
replace lng = -89.0961 if regzip_pre==39502

replace lat = 37.6448 if regzip_pre==40423 
replace lng = -84.7748 if regzip_pre==40423 

replace lat = 40.4167 if regzip_pre==46067
replace lng = -86.5152 if regzip_pre==46067

replace lat = 41.4208 if regzip_pre==46308
replace lng = -87.3632 if regzip_pre==46308

replace lat = 44.7046 if regzip_pre==49685
replace lng = -85.6991 if regzip_pre==49685

replace lat = 41.9745 if regzip_pre==52408
replace lng = -91.7048 if regzip_pre==52408

replace lat = 44.0791 if regzip_pre==57709
replace lng = -103.2156 if regzip_pre==57709

replace lat = 48.2025 if regzip_pre==59904
replace lng = -114.3303 if regzip_pre==59904

replace lat = 42.0471 if regzip_pre==60204
replace lng = -87.6873 if regzip_pre==60204

replace lat = 40.6897 if regzip_pre==61634 
replace lng = -89.5917 if regzip_pre==61634 

replace lat = 38.1764 if regzip_pre==62866
replace lng = -88.9719 if regzip_pre==62866

replace lat = 29.6945 if regzip_pre==70381
replace lng = -91.2088 if regzip_pre==70381

replace lat = 30.2268 if regzip_pre==70602
replace lng = -93.2134 if regzip_pre==70602

replace lat = 32.66 if regzip_pre==75301
replace lng = -96.8825 if regzip_pre==75301

replace lat = 32.3844 if regzip_pre==75663
replace lng = -94.878 if regzip_pre==75663

replace lat = 30.643 if regzip_pre==77399
replace lng = -94.8728 if regzip_pre==77399

replace lat = 29.6972 if regzip_pre==78131
replace lng = -98.1161 if regzip_pre==78131

replace lat = 40.5739 if regzip_pre==80523
replace lng = -105.085 if regzip_pre==80523

replace lat = 41.1649 if regzip_pre==82003
replace lng = -104.788 if regzip_pre==82003

replace lat = 41.5819 if regzip_pre==82902
replace lng = -109.2567 if regzip_pre==82902

replace lat = 33.2909 if regzip_pre==85070
replace lng = -112.0644 if regzip_pre==85070

replace lat = 33.4178 if regzip_pre==85211 
replace lng = -111.8314 if regzip_pre==85211 

replace lat = 34.3104745361975 if regzip_pre==85232
replace lng = -111.769158354567 if regzip_pre==85232

replace lat = 33.3048 if regzip_pre==85244
replace lng = -111.8388 if regzip_pre==85244

replace lat = 33.8321 if regzip_pre==85327
replace lng = -111.9432 if regzip_pre==85327

replace lat = 32.7217 if regzip_pre==85366 
replace lng = -114.6178 if regzip_pre==85366 

replace lat = 34.5856 if regzip_pre==86312
replace lng = -112.3181 if regzip_pre==86312

replace lat = 34.8668 if regzip_pre==86339
replace lng = -111.7653 if regzip_pre==86339

replace lat = 36.1174 if regzip_pre==89041
replace lng = -115.9582 if regzip_pre==89041

replace lat = 39.4755 if regzip_pre==89407
replace lng = -118.7782 if regzip_pre==89407

replace lat = 33.8295 if regzip_pre==90510
replace lng = -118.329 if regzip_pre==90510

replace lat = 34.1463 if regzip_pre==91209
replace lng = -118.2524 if regzip_pre==91209

replace lat = 34.1552 if regzip_pre==91372
replace lng = -118.6426 if regzip_pre==91372

replace lat = 34.4113 if regzip_pre==91386 
replace lng = -118.5027 if regzip_pre==91386 

replace lat = 32.5558 if regzip_pre==92143
replace lng = -117.0528 if regzip_pre==92143

replace lat = 32.8016 if regzip_pre==92193
replace lng = -117.1401 if regzip_pre==92193

replace lat = 33.87 if regzip_pre==92836
replace lng = -117.9221 if regzip_pre==92836

replace lat = 37.5025 if regzip_pre==94018
replace lng = -122.4698 if regzip_pre==94018

replace lat = 37.3797 if regzip_pre==94023
replace lng = -122.1192 if regzip_pre==94023

replace lat = 37.9779 if regzip_pre==94524
replace lng = -122.0579 if regzip_pre==94524

replace lat = 37.8016 if regzip_pre==94604
replace lng = -122.2664 if regzip_pre==94604

replace lat = 37.2213 if regzip_pre==95031
replace lng = -121.9846 if regzip_pre==95031

replace lat = 38.44 if regzip_pre==95402
replace lng = -122.7108 if regzip_pre==95402

replace lat = 39.1391 if regzip_pre==95992
replace lng = -121.617 if regzip_pre==95992

replace lat = 39.327 if regzip_pre==96160
replace lng = -120.1836 if regzip_pre==96160

replace lat = 19.7142 if regzip_pre==96721
replace lng = -155.0426 if regzip_pre==96721

replace lat = 21.3042 if regzip_pre==96823
replace lng = -157.8439 if regzip_pre==96823

replace lat = 44.5619 if regzip_pre==97339
replace lng = -123.261 if regzip_pre==97339

replace lat = 47.387 if regzip_pre==98089
replace lng = -122.1985 if regzip_pre==98089

replace lat = 61.2141 if regzip_pre==99520
replace lng = -149.8669 if regzip_pre==99520

replace lat = 64.8489 if regzip_pre==99708
replace lng = -147.8295 if regzip_pre==99708

replace lat = 58.3718 if regzip_pre==99803
replace lng = -134.5885 if regzip_pre==99803

*Verify that every single respondent has a lat and lng
count if lat !=.
count if lng !=.

*Calculating distance from nearest shooting
*Tucson, AZ
geodist 32.3358555 -110.9747318 lat lng, gen(dist1) mi

*Youngstown, OH
geodist 41.097435 -80.652249 lat lng, gen(dist2) mi

*Grand Rapids, MI
geodist 42.963193 -85.659686 lat lng, gen(dist3) mi

*Carson City, NV
geodist 39.170644 -119.78193 lat lng, gen(dist4) mi

*Seal Beach, CA
geodist 33.760225 -118.080806 lat lng, gen(dist5) mi

*Birmingham, AL
geodist 33.515462 -86.821045 lat lng, gen(dist6) mi

*Chardon, OH
geodist 41.569436 -81.203372 lat lng, gen(dist7) mi

*Oakland, CA
geodist 37.802583 -122.208576 lat lng, gen(dist8) mi

*Seattle, WA
geodist 47.632744 -122.321885 lat lng, gen(dist9) mi

*Auburn, AL 
geodist 32.602139 -85.508496 lat lng, gen(dist10) mi

*Denver, CO
geodist 39.694487 -104.832515 lat lng, gen(dist11) mi

*Oak Creek, WI
geodist 42.88606 -87.903062 lat lng, gen(dist12) mi

*Minneapolis, MN
geodist 44.961027 -93.263429 lat lng, gen(dist13) mi

*Miami, FL
geodist 25.816413 -80.206972 lat lng, gen(dist14) mi

*Morgantown, WV
geodist 39.629524 -79.955894 lat lng, gen(dist15) mi

*Tulsa, OK
geodist 36.145326 -95.90613 lat lng, gen(dist16) mi


*Create a variable of the minimum distance to a shooting in this wave
egen min_dist = rowmin(dist1-dist16) if year==2012

*Create treatment indicators at various distance thresholds
*10 miles
gen treat_10mi = 1 if min_dist <= 10 & year==2012
recode treat_10mi .=0

*25 miles
gen treat_25mi = 1 if min_dist <= 25 & year==2012
recode treat_25mi .=0

*50 miles
gen treat_50mi = 1 if min_dist <= 50 & year==2012
recode treat_50mi .=0

*75 miles
gen treat_75mi = 1 if min_dist <= 75 & year==2012
recode treat_75mi .=0

*100 miles
gen treat_100mi = 1 if min_dist <= 100 & year==2012
recode treat_100mi .=0


*Labeling all variables
lab var treat_10mi "≤ 10 miles"
lab var treat_25mi "≤ 25 miles"
lab var treat_50mi "≤ 50 miles"
lab var treat_75mi "≤ 75 miles"
lab var treat_100mi "≤ 100 miles"
lab def t_val 0 "Untreated" 1 "Treated"
lab values treat_10mi treat_25mi treat_50mi treat_75mi treat_100mi t_val

*Drop the 5 rows that only contain indicators for shootings where respondents didn't live
*We can do this because we have already created the treatment indicators
drop if merge_dma_t==2

*Calculate distance from shootings occuring in the decade prior to the CCES panel study
*Boston, 2000
geodist 42.30904091 -71.10271358 lat lng, gen(d_dist1) mi

*Melrose Park, 2001
geodist 41.90289602 -87.8643021 lat lng, gen(d_dist2) mi

*San Diego, 2001
geodist 32.86357277 -117.1281628 lat lng, gen(d_dist3) mi

*Grundy, 2002
geodist 37.27537712 -82.09877234 lat lng, gen(d_dist4) mi

*Tucson, 2002
geodist 32.2389308 -110.945555 lat lng, gen(d_dist5) mi

*Cleveland, 2003
geodist 41.47657557 -81.68051502 lat lng, gen(d_dist6) mi

*Meridian, 2003
geodist 32.38455246 -88.68967949 lat lng, gen(d_dist7) mi

*Chicago, 2003
geodist 41.83928045 -87.68818145 lat lng, gen(d_dist8) mi

*Birchwood, 2004
geodist 45.65773714 -91.55077175 lat lng, gen(d_dist9) mi

*Columbus, 2003
geodist 39.98861445 -82.98904135 lat lng, gen(d_dist10) mi

*Tyler, 2005
geodist 32.3154272 -95.30501087 lat lng, gen(d_dist11) mi

*Brookfield, 2005
geodist 43.06396691 -88.12299758 lat lng, gen(d_dist12) mi

*Seattle, 2006
geodist 47.62199575 -122.323646 lat lng, gen(d_dist13) mi

*Essex Junction, 2006
geodist 44.49022039 -73.11400628 lat lng, gen(d_dist14) mi

*Hillsborough, 2006
geodist 36.04099857 -79.09701201 lat lng, gen(d_dist15) mi

*Pittsburgh, 2006
geodist 40.43948548 -79.97631581 lat lng, gen(d_dist16) mi

*Lancaster, 2006
geodist 40.04214385 -76.30100872 lat lng, gen(d_dist17) mi

*Salt Lake City, 2007
geodist 40.77787404 -111.9312168 lat lng, gen(d_dist18) mi

*Gresham, 2007
geodist 45.50216511 -122.4412759 lat lng, gen(d_dist19) mi

*Blacksburg, 2007
geodist 37.22995471 -80.42768677 lat lng, gen(d_dist20) mi

*Crandon, 2007
geodist 45.56871416 -88.89729022 lat lng, gen(d_dist21) mi

*Cleveland, 2007
geodist 41.47657557 -81.68051502 lat lng, gen(d_dist22) mi

*Saginaw, 2007
geodist 43.41929117 -83.95032759 lat lng, gen(d_dist23) mi

*Omaha, 2007
geodist 41.265922 -96.05381421 lat lng, gen(d_dist24) mi

*Las Vegas, 2007
geodist 36.18931923 -115.3264875 lat lng, gen(d_dist25) mi

*Carnation, 2007
geodist 47.64628742 -121.9088524 lat lng, gen(d_dist26) mi

*Kirkwood, 2008
geodist 38.57889169 -90.42023754 lat lng, gen(d_dist27) mi

*DeKalb, 2008
geodist 41.93172129 -88.74814853 lat lng, gen(d_dist28) mi

*Henderson, 2008
geodist 37.84040411 -87.57853755 lat lng, gen(d_dist29) mi

*Phoenix, 2008
geodist 33.57145875 -112.0904854 lat lng, gen(d_dist30) mi

*Conway, 2008
geodist 35.08130744 -92.43278275 lat lng, gen(d_dist31) mi

*Covina, 2008
geodist 34.09026669 -117.8819958 lat lng, gen(d_dist32) mi

*Santa Clara, 2009
geodist 37.36463172 -121.9679315 lat lng, gen(d_dist33) mi

*Carthage, 2009
geodist 35.33985609 -79.41381725 lat lng, gen(d_dist34) mi

*Binghamton, 2009
geodist 42.10140103 -75.90922294 lat lng, gen(d_dist35) mi

*Fort Hood, 2009
geodist 31.13814354 -97.77797804 lat lng, gen(d_dist36) mi

*Lakewood, 2009
geodist 47.16267579 -122.5296574 lat lng, gen(d_dist37) mi

*Huntsville, 2010
geodist 34.72827538 -86.6723055 lat lng, gen(d_dist38) mi

*Manchester, 2010
geodist 41.78013821 -72.51918655 lat lng, gen(d_dist39) mi

*Find respoindent's minimum distance to shootings occuring in the previous decade
egen min_d_dist = rowmin(d_dist1-d_dist39)

*Varying distance thresholds for this indicator
*10 miles
gen pds_10mi = 1 if min_d_dist <= 10
recode pds_10mi .=0

*25 miles
gen pds_25mi = 1 if min_d_dist <= 25
recode pds_25mi .=0

*50 miles
gen pds_50mi = 1 if min_d_dist <= 50
recode pds_50mi .=0

*75 miles
gen pds_75mi = 1 if min_d_dist <= 75
recode pds_75mi .=0

*100 miles
gen pds_100mi = 1 if min_d_dist <= 100
recode pds_100mi .=0

*Previous decade shooting in media market already coded


*Find respoindent's minimum distance to shootings occuring in the TWO YEARS leading up to the panel
*This is to initialize the treatments for the continuous indicators
egen min_2yp_dist = rowmin(d_dist27-d_dist39)

*Create continuous treatment indicators
*"min_dist" is the linear one
gen linear_distance = min_2yp_dist
replace linear_distance = min_dist if year==2012 & (min_dist < min_2yp_dist)

gen ln_distance = ln(linear_distance)
*gen distance_squared = linear_distance^2

*Label values
lab define pds_label 0 "Untreated in Previous Decade" 1 "Treated in Previous Decade"
lab values pds_10mi pds_label
lab values pds_25mi pds_label
lab values pds_50mi pds_label
lab values pds_75mi pds_label
lab values pds_100mi pds_label
lab values pds_treated_dma pds_label

*Generate / recode gun control variable
*Lower values mean less GC, higher values mean more GC
recode CC320 2=0 3=.5, gen(guns_01)

*Create indicators for partisanship for partisan-conditional analysis
sort caseid year
gen party2010=pid7 if year==2010
replace party2010=pid7[_n-1] if year==2012 & caseid[_n-1]==caseid
recode party2010 1/3=1 4=2 8=2 5/7=3
label define party 1 "Democrats" 2 "Independents" 3 "Republicans"
label values party2010 party



saveold final_longform_10_12_merged.dta, replace

clear

******************************************************************************
** Data preparation for Table 3                                          *****
** 2010-2012-2014 CCES Panel Study                                       *****
** Note that these data are already converted to "long form"             *****
** Original "wide form" data can be found below.                         *****
** doi:10.7910/DVN/TOE8I1                                                *****
******************************************************************************
use longform_fullpanel.dta, clear

*Set for time series
xtset caseid year, delta(2)

*Merge ZIP-to-county crosswalk for completeness
merge m:1 reszip using COUNTY_ZIP_032010_FP.dta
ren _merge merge_zip_county

*Merge in DMAs and their tretment indicators
merge m:1 countyfips using DMA_county_working.dta
ren _merge merge_dma

*Identify the counties not within a DMA
tab countyfips if merge_dma==1 & caseid !=.

*8014 is Broomfield County, CO, which is in the Denver DMA
recode dmaindex .=18 if countyfips==8014

*12086 is an old FIPS for Miami-Dade county
recode dmaindex .=17 if countyfips==12086

*Merge in DMA treatment indicators
merge m:m reszip year using DMA_4y_indicators.dta
ren _merge merge_dma_t

*Recoding non-treated ZIPs
recode treatment_zip .=0

*NOTE1: We have to retain these 27 extra obs until the end of preparation*
*NOTE2: No respondents live in these zips, but shootings occured there****
*NOTE3: So we must create all treatment indicators and then drop those 27*

*Looking at treated zips within their DMAs
tab reszip dmaindex if treatment_zip==1 & year==2012
tab reszip dmaindex if treatment_zip==1 & year==2014

distinct reszip dmaindex if treatment_zip==1 & year==2012
distinct reszip dmaindex if treatment_zip==1 & year==2014

*For 2012
*So after identifying the treated dmas via the next crosstab:
tab dmaindex if year==2012 & treatment_zip==1

*Manually generate a DMA treatment variable
gen treated_dma=0
replace treated_dma=1 if dmaindex==2 & year==2012
replace treated_dma=1 if dmaindex==12 & year==2012
replace treated_dma=1 if dmaindex==15 & year==2012
replace treated_dma=1 if dmaindex==18 & year==2012
replace treated_dma=1 if dmaindex==74 & year==2012
replace treated_dma=1 if dmaindex==126 & year==2012


*For 2014
tab dmaindex if year==2014 & treatment_zip==1
replace treated_dma=1 if dmaindex==2 & year==2014
replace treated_dma=1 if dmaindex==5 & year==2014
replace treated_dma=1 if dmaindex==9 & year==2014
replace treated_dma=1 if dmaindex==12 & year==2014
replace treated_dma=1 if dmaindex==16 & year==2014
replace treated_dma=1 if dmaindex==17 & year==2014
replace treated_dma=1 if dmaindex==23 & year==2014
replace treated_dma=1 if dmaindex==45 & year==2014
replace treated_dma=1 if dmaindex==93 & year==2014

*Previous treatment in media market
*Identify media markets that were treated in the previous decade
*Manually coding treated ZIP codes in the previous decade
*The treated zip codes are identified by using the latitude and longitude provided by the Stanford MSA database
gen pds_treated_zip = 0
*Boston, 2000
replace pds_treated_zip=1 if reszip==02130
*Melrose Park, 2001
replace pds_treated_zip=1 if reszip==60160
*San Diego, 2001
replace pds_treated_zip=1 if reszip==92145
*Grundy, 2002
replace pds_treated_zip=1 if reszip==24614
*Tucson 2002
replace pds_treated_zip=1 if reszip==85706
*Cleveland, 2003
replace pds_treated_zip=1 if reszip==44113
*Meridian, 2003
replace pds_treated_zip=1 if reszip==39301
*Chicago, 2003
replace pds_treated_zip=1 if reszip==60608
*Birchwood, 2004
replace pds_treated_zip=1 if reszip==54817
*Columbus, 2004
replace pds_treated_zip=1 if reszip==43201
*Tyler, 2005
replace pds_treated_zip=1 if reszip==75701
*Brookfield, 2005
replace pds_treated_zip=1 if reszip==53005
*Seattle, 2006
replace pds_treated_zip=1 if reszip==98102
*Essex Junction, 2006
replace pds_treated_zip=1 if reszip==05452
*Hillsborough, 2006
replace pds_treated_zip=1 if reszip==27278
*Pittsburgh, 2006
replace pds_treated_zip=1 if reszip==15219
*Lancaster, 2006
replace pds_treated_zip=1 if reszip==17602
*Salt Lake City, 2007
replace pds_treated_zip=1 if reszip==84116
*Gresham, 2007
replace pds_treated_zip=1 if reszip==97030
*Blacksburg, 2007
replace pds_treated_zip=1 if reszip==24060
*Crandon, 2007
replace pds_treated_zip=1 if reszip==54520
*Cleveland, 2007
replace pds_treated_zip=1 if reszip==44113
*Saginaw, 2007
replace pds_treated_zip=1 if reszip==48601
*Omaha, 2007
replace pds_treated_zip=1 if reszip==68114
*Las Vegas, 2007
replace pds_treated_zip=1 if reszip==89144
*Carnation, 2007
replace pds_treated_zip=1 if reszip==98014
*Kirkwood, 2008
replace pds_treated_zip=1 if reszip==63122
*DeKalb, 2008
replace pds_treated_zip=1 if reszip==60115
*Henderson, 2008
replace pds_treated_zip=1 if reszip==42420
*Phoenix, 2008
replace pds_treated_zip=1 if reszip==85021
*Conway, 2008
replace pds_treated_zip=1 if reszip==72032
*Covina, 2008
replace pds_treated_zip=1 if reszip==91723
*Santa Clara, 2009
replace pds_treated_zip=1 if reszip==95051
*Carthage, 2009
replace pds_treated_zip=1 if reszip==28327
*Binghamton, 2009
replace pds_treated_zip=1 if reszip==13901
*Fort Hood, 2009
replace pds_treated_zip=1 if reszip==76544
*Lakewood, 2009
replace pds_treated_zip=1 if reszip==98499
*Huntsville, 2010
replace pds_treated_zip=1 if reszip==35806
*Manchester, 2010
replace pds_treated_zip=1 if reszip==06040

*Manually generate a DMA treatment variable for shootings in the PREVIOUS DECADE
tab dmaindex if pds_treated_zip==1

gen pds_treated_dma=0
replace pds_treated_dma=1 if dmaindex==2
replace pds_treated_dma=1 if dmaindex==3
replace pds_treated_dma=1 if dmaindex==5
replace pds_treated_dma=1 if dmaindex==6
replace pds_treated_dma=1 if dmaindex==12
replace pds_treated_dma=1 if dmaindex==14
replace pds_treated_dma=1 if dmaindex==15
replace pds_treated_dma=1 if dmaindex==16
replace pds_treated_dma=1 if dmaindex==21
replace pds_treated_dma=1 if dmaindex==22
replace pds_treated_dma=1 if dmaindex==23
replace pds_treated_dma=1 if dmaindex==26
replace pds_treated_dma=1 if dmaindex==27
replace pds_treated_dma=1 if dmaindex==29
replace pds_treated_dma=1 if dmaindex==31
replace pds_treated_dma=1 if dmaindex==34
replace pds_treated_dma=1 if dmaindex==36
replace pds_treated_dma=1 if dmaindex==47
replace pds_treated_dma=1 if dmaindex==52
replace pds_treated_dma=1 if dmaindex==56
replace pds_treated_dma=1 if dmaindex==64
replace pds_treated_dma=1 if dmaindex==67
replace pds_treated_dma=1 if dmaindex==74
replace pds_treated_dma=1 if dmaindex==78
replace pds_treated_dma=1 if dmaindex==83
replace pds_treated_dma=1 if dmaindex==90
replace pds_treated_dma=1 if dmaindex==91
replace pds_treated_dma=1 if dmaindex==93
replace pds_treated_dma=1 if dmaindex==99
replace pds_treated_dma=1 if dmaindex==109
replace pds_treated_dma=1 if dmaindex==134
replace pds_treated_dma=1 if dmaindex==154
replace pds_treated_dma=1 if dmaindex==185

*Drop the extra zipcodes
drop if merge_zip_county==2
tab reszip if countyfips==.
*Manual correction for those not covered by the crosswalk
replace countyfips=48157 if reszip==77407
replace countyfips=02170 if reszip==99623
*Drop extra dma obs
drop if merge_dma==2


*Merge ZIP-to-coordinates crosswalk
merge m:1 reszip using ZIP_to_coordinates_FP.dta
ren _merge merge_zip_coord
drop if merge_zip_coord==2

*Identify the ZIP codes that didn't get assigned lat and lng
tab reszip if merge_zip_coord==1

replace lat = 42.0353 if reszip==06079
replace lng = -73.4043 if reszip==06079

replace lat = 41.8977 if reszip==06258
replace lng = -71.9598 if reszip==06258

replace lat = 41.056 if reszip==07875 
replace lng = -74.8626 if reszip==07875

replace lat = 40.312 if reszip==08541
replace lng = -74.6553 if reszip==08541

replace lat = 41.3324 if reszip==10587
replace lng = -73.7364 if reszip==10587

replace lat = 43.2525 if reszip==14515
replace lng = -77.7329 if reszip==14515

replace lat = 38.90302 if reszip==20532
replace lng = -77.016199 if reszip==20532

replace lat = 38.2559 if reszip==22965
replace lng = -78.3985 if reszip==22965

replace lat = 37.2224 if reszip==24619
replace lng = -81.5187 if reszip==24619

replace lat = 39.4566 if reszip==25402
replace lng = -77.9658 if reszip==25402

replace lat = 37.7788 if reszip==25802
replace lng = -81.1878 if reszip==25802

replace lat = 33.6892 if reszip==29578
replace lng = -78.8872 if reszip==29578

replace lat = 28.852 if reszip==32163
replace lng = -81.9879 if reszip==32163

replace lat = 30.1723 if reszip==32412
replace lng = -85.6334 if reszip==32412

replace lat = 30.4338 if reszip==32591
replace lng = -87.2347 if reszip==32591

replace lat = 28.8891 if reszip==32753
replace lng = -81.3071 if reszip==32753

replace lat = 27.857 if reszip==33568
replace lng = -82.3237 if reszip==33568

replace lat = 26.9367 if reszip==33951
replace lng = -82.049 if reszip==33951

replace lat = 30.4081 if reszip==36536
replace lng = -87.6852 if reszip==36536

replace lat = 30.2484 if reszip==36547
replace lng = -87.6916 if reszip==36547

replace lat = 41.4208 if reszip==46308
replace lng = -87.3632 if reszip==46308

replace lat = 48.2025 if reszip==59904
replace lng = -114.3303 if reszip==59904

replace lat = 42.0471 if reszip==60204
replace lng = -87.6873 if reszip==60204

replace lat = 38.1764 if reszip==62866
replace lng = -88.9719 if reszip==62866

replace lat = 30.2268 if reszip==70602
replace lng = -93.2134 if reszip==70602

replace lat = 32.66 if reszip==75301
replace lng = -96.8825 if reszip==75301

replace lat = 33.1383 if reszip==75403
replace lng = -96.1087 if reszip==75403

replace lat = 32.3844 if reszip==75663
replace lng = -94.878 if reszip==75663

replace lat = 32.9062 if reszip==76098
replace lng = -97.5486 if reszip==76098

replace lat = 40.5739 if reszip==80523
replace lng = -105.085 if reszip==80523

replace lat = 41.1649 if reszip==82003
replace lng = -104.788 if reszip==82003

replace lat = 36.1174 if reszip==89041
replace lng = -115.9582 if reszip==89041

replace lat = 33.367 if reszip==92088
replace lng = -117.2502 if reszip==92088

replace lat = 37.8016 if reszip==94604
replace lng = -122.2664 if reszip==94604

replace lat = 47.387 if reszip==98089
replace lng = -122.1985 if reszip==98089

replace lat = 61.2141 if reszip==99520
replace lng = -149.8669 if reszip==99520

replace lat = 61.5601 if reszip==99623
replace lng = -149.6707 if reszip==99623

replace lat = 61.582 if reszip==99687
replace lng = -149.4415 if reszip==99687

count if lat==.
count if lng==.

*Merge murders per capita
merge m:1 countyfips year using mpc_10_12_14_longform.dta
ren _merge merge_mpc
drop if merge_mpc==2

*Drop all remaining obs that do not correspond with a caseid
drop if caseid==.

*Calculating distance from shootings occuring between each panel wave
*Wave 1
*Tucson, AZ
geodist 32.3358555 -110.9747318 lat lng, gen(dist1_w1) mi

*Youngstown, OH
geodist 41.097435 -80.652249 lat lng, gen(dist2_w1) mi

*Grand Rapids, MI
geodist 42.963193 -85.659686 lat lng, gen(dist3_w1) mi

*Carson City, NV
geodist 39.170644 -119.78193 lat lng, gen(dist4_w1) mi

*Seal Beach, CA
geodist 33.760225 -118.080806 lat lng, gen(dist5_w1) mi

*Birmingham, AL
geodist 33.515462 -86.821045 lat lng, gen(dist6_w1) mi

*Chardon, OH
geodist 41.569436 -81.203372 lat lng, gen(dist7_w1) mi

*Oakland, CA
geodist 37.802583 -122.208576 lat lng, gen(dist8_w1) mi

*Seattle, WA
geodist 47.632744 -122.321885 lat lng, gen(dist9_w1) mi

*Auburn, AL 
geodist 32.602139 	-85.508496 lat lng, gen(dist10_w1) mi

*Denver, CO
geodist 39.694487 -104.832515 lat lng, gen(dist11_w1) mi

*Oak Creek, WI
geodist 42.88606 -87.903062 lat lng, gen(dist12_w1) mi

*Minneapolis, MN
geodist 44.961027 -93.263429 lat lng, gen(dist13) mi

*Miami, FL
geodist 25.816413 -80.206972 lat lng, gen(dist14_w1) mi

*Morgantown, WV
geodist 39.629524 -79.955894 lat lng, gen(dist15_w1) mi

*Tulsa, OK
geodist 36.145326 -95.90613 lat lng, gen(dist16_w1) mi

*Create a variable of the minimum distance to a shooting in this wave
egen min_dist_w1 = rowmin(dist1_w1-dist16_w1) if year==2012

*Wave 2

*Brookfield, WI
geodist 43.06396691 -88.12299758 lat lng, gen(dist1_w2) mi

*Happy Valley, OR
geodist 45.44853107 -122.5440133 lat lng, gen(dist2_w2) mi

*Newtown, CT
geodist 41.41190846 -73.31196267 lat lng, gen(dist3_w2) mi

*Albuquerque, NM
geodist 35.15290522 -106.7791378 lat lng, gen(dist4_w2) mi

*Phoenix, AZ
geodist 33.57145875 -112.0904854 lat lng, gen(dist5_w2) mi

*Irvine, CA
geodist 33.67803464 -117.773628 lat lng, gen(dist6_w2) mi

*Ladera Ranch, CA
geodist 33.54961059 -117.6415707 lat lng, gen(dist7_w2) mi

*Mohawk, NY
geodist 43.0104011 -75.0075119 lat lng, gen(dist8_w2) mi

*Federal Way, WA
geodist 47.30909721 -122.3357553 lat lng, gen(dist9_w2) mi

*Manchester, IL
geodist 39.54231335 -90.33029852 lat lng, gen(dist10_w2) mi

*Santa Monica, CA
geodist 34.02319149 -118.4815644 lat lng, gen(dist11_w2) mi

*Hialeah, FL
geodist 25.85294547 -80.28316975 lat lng, gen(dist12_w2) mi

*Salisbury, PA
geodist 39.75344279 -79.08435956 lat lng, gen(dist13_w2) mi

*Dallas, TX
geodist 32.79480596 -96.76631094 lat lng, gen(dist14_w2) mi

*Oklahoma City, OK
geodist 35.46779189 -97.5191631 lat lng, gen(dist15_w2) mi

*Washington, DC
geodist 38.90480894 -77.01629717 lat lng, gen(dist16_w2) mi

*Sparks, NV
geodist 39.54058388 -119.748291 lat lng, gen(dist17_w2) mi

*Los Angeles, CA
geodist 34.17622092 -118.5399542 lat lng, gen(dist18_w2) mi

*Montgomery, AL
geodist 32.34729571 -86.26730242 lat lng, gen(dist19_w2) mi

*Alturas, CA
geodist 41.4911123 -120.549091 lat lng, gen(dist20_w2) mi

*San Francisco, CA
geodist 37.75457839 -122.4424343 lat lng, gen(dist21_w2) mi

*Killeen, TX
geodist 31.07925506 -97.73392317 lat lng, gen(dist22_w2) mi

*Kennesaw, GA
geodist 34.02529674 -84.61766831 lat lng, gen(dist23_w2) mi

*Isla Vista, CA
geodist 34.4145857 -119.8581209 lat lng, gen(dist24_w2) mi

*Seattle, WA
geodist 47.62199575 -122.323646 lat lng, gen(dist25_w2) mi

*Las Vegas, NV
geodist 36.18931923 -115.3264875 lat lng, gen(dist26_w2) mi

*New Orleans, LA
geodist 30.0687242 -89.93147412 lat lng, gen(dist27_w2) mi

*Albuquerque, NM
geodist 35.15290522 -106.7791378 lat lng, gen(dist28_w2) mi

*Create a variable of the minimum distance to a shooting in this wave
egen min_dist_w2 = rowmin(dist1_w2-dist28_w2) if year==2014


*Varying distance thresholds for this indicator

*10 miles, Wave 1
gen t_10mi = 1 if min_dist_w1 <= 10 & year==2012
*10 miles, Wave 2
replace t_10mi = 1 if min_dist_w2 <= 10 & year==2014
*Recode remaining to 0
recode t_10mi .=0

*25 miles, Wave 1
gen t_25mi = 1 if min_dist_w1 <= 25 & year==2012
*25 miles, Wave 2
replace t_25mi = 1 if min_dist_w2 <= 25 & year==2014
*Recode remaining to 0
recode t_25mi .=0

*50 miles, Wave 1
gen t_50mi = 1 if min_dist_w1 <= 50 & year==2012
*50 miles, Wave 2
replace t_50mi = 1 if min_dist_w2 <= 50 & year==2014
*Recode remaining to 0
recode t_50mi .=0

*75 miles, Wave 1
gen t_75mi = 1 if min_dist_w1 <= 75 & year==2012
*75 miles, Wave 2
replace t_75mi = 1 if min_dist_w2 <= 75 & year==2014
*Recode remaining to 0
recode t_75mi .=0

*100 miles, Wave 1
gen t_100mi = 1 if min_dist_w1 <= 100 & year==2012
*100 miles, Wave 2
replace t_100mi = 1 if min_dist_w2 <= 100 & year==2014
*Recode remaining to 0
recode t_100mi .=0


*Calculate distance from shootings occuring in the decade prior to the CCES panel study
*Boston, 2000
geodist 42.30904091 -71.10271358 lat lng, gen(d_dist1) mi

*Melrose Park, 2001
geodist 41.90289602 -87.8643021 lat lng, gen(d_dist2) mi

*San Diego, 2001
geodist 32.86357277 -117.1281628 lat lng, gen(d_dist3) mi

*Grundy, 2002
geodist 37.27537712 -82.09877234 lat lng, gen(d_dist4) mi

*Tucson, 2002
geodist 32.2389308 -110.945555 lat lng, gen(d_dist5) mi

*Cleveland, 2003
geodist 41.47657557 -81.68051502 lat lng, gen(d_dist6) mi

*Meridian, 2003
geodist 32.38455246 -88.68967949 lat lng, gen(d_dist7) mi

*Chicago, 2003
geodist 41.83928045 -87.68818145 lat lng, gen(d_dist8) mi

*Birchwood, 2004
geodist 45.65773714 -91.55077175 lat lng, gen(d_dist9) mi

*Columbus, 2003
geodist 39.98861445 -82.98904135 lat lng, gen(d_dist10) mi

*Tyler, 2005
geodist 32.3154272 -95.30501087 lat lng, gen(d_dist11) mi

*Brookfield, 2005
geodist 43.06396691 -88.12299758 lat lng, gen(d_dist12) mi

*Seattle, 2006
geodist 47.62199575 -122.323646 lat lng, gen(d_dist13) mi

*Essex Junction, 2006
geodist 44.49022039 -73.11400628 lat lng, gen(d_dist14) mi

*Hillsborough, 2006
geodist 36.04099857 -79.09701201 lat lng, gen(d_dist15) mi

*Pittsburgh, 2006
geodist 40.43948548 -79.97631581 lat lng, gen(d_dist16) mi

*Lancaster, 2006
geodist 40.04214385 -76.30100872 lat lng, gen(d_dist17) mi

*Salt Lake City, 2007
geodist 40.77787404 -111.9312168 lat lng, gen(d_dist18) mi

*Gresham, 2007
geodist 45.50216511 -122.4412759 lat lng, gen(d_dist19) mi

*Blacksburg, 2007
geodist 37.22995471 -80.42768677 lat lng, gen(d_dist20) mi

*Crandon, 2007
geodist 45.56871416 -88.89729022 lat lng, gen(d_dist21) mi

*Cleveland, 2007
geodist 41.47657557 -81.68051502 lat lng, gen(d_dist22) mi

*Saginaw, 2007
geodist 43.41929117 -83.95032759 lat lng, gen(d_dist23) mi

*Omaha, 2007
geodist 41.265922 -96.05381421 lat lng, gen(d_dist24) mi

*Las Vegas, 2007
geodist 36.18931923 -115.3264875 lat lng, gen(d_dist25) mi

*Carnation, 2007
geodist 47.64628742 -121.9088524 lat lng, gen(d_dist26) mi

*Kirkwood, 2008
geodist 38.57889169 -90.42023754 lat lng, gen(d_dist27) mi

*DeKalb, 2008
geodist 41.93172129 -88.74814853 lat lng, gen(d_dist28) mi

*Henderson, 2008
geodist 37.84040411 -87.57853755 lat lng, gen(d_dist29) mi

*Phoenix, 2008
geodist 33.57145875 -112.0904854 lat lng, gen(d_dist30) mi

*Conway, 2008
geodist 35.08130744 -92.43278275 lat lng, gen(d_dist31) mi

*Covina, 2008
geodist 34.09026669 -117.8819958 lat lng, gen(d_dist32) mi

*Santa Clara, 2009
geodist 37.36463172 -121.9679315 lat lng, gen(d_dist33) mi

*Carthage, 2009
geodist 35.33985609 -79.41381725 lat lng, gen(d_dist34) mi

*Binghamton, 2009
geodist 42.10140103 -75.90922294 lat lng, gen(d_dist35) mi

*Fort Hood, 2009
geodist 31.13814354 -97.77797804 lat lng, gen(d_dist36) mi

*Lakewood, 2009
geodist 47.16267579 -122.5296574 lat lng, gen(d_dist37) mi

*Huntsville, 2010
geodist 34.72827538 -86.6723055 lat lng, gen(d_dist38) mi

*Manchester, 2010
geodist 41.78013821 -72.51918655 lat lng, gen(d_dist39) mi

*Find minimum distance to shootings occuring in the decade prior
egen min_d_dist = rowmin(d_dist1-d_dist39)

*10 miles
gen pds_10mi = 1 if min_d_dist <= 10 
recode pds_10mi .=0

*25 miles
gen pds_25mi = 1 if min_d_dist <= 25
recode pds_25mi .=0

*50 miles
gen pds_50mi = 1 if min_d_dist <= 50
recode pds_50mi .=0

*75 miles
gen pds_75mi = 1 if min_d_dist <= 75
recode pds_75mi .=0

*100 miles
gen pds_100mi = 1 if min_d_dist <= 100
recode pds_100mi .=0

*Media market previous treatment indicator already created

lab define pds_label 0 "Untreated in Previous Decade" 1 "Treated in Previous Decade"
lab values pds_10mi pds_label
lab values pds_25mi pds_label
lab values pds_50mi pds_label
lab values pds_75mi pds_label
lab values pds_100mi pds_label
lab values pds_treated_dma pds_label

*Find respoindent's minimum distance to shootings occuring in the TWO YEARS leading up to the panel
*This is to initialize the treatments for the continuous indicators
egen min_2yp_dist = rowmin(d_dist27-d_dist39)

*Create continuous treatment indicators
*"min_dist" is the linear one
gen linear_distance = min_2yp_dist
replace linear_distance = min_dist_w1 if year==2012 & (min_dist_w1 < min_2yp_dist)
replace linear_distance = min_dist_w1 if year==2014 & (min_dist_w1 < min_2yp_dist)
replace linear_distance = min_dist_w2 if year==2014 & (min_dist_w2 < min_2yp_dist)
gen ln_distance = ln(linear_distance)
*gen distance_squared = linear_distance^2


*Set up gun control attitudinal variable
gen guns = .
replace guns=1 if CC320==2
replace guns=2 if CC320==3
replace guns=3 if CC320==1
egen gun_max = max(guns)
egen gun_min = min(guns)
gen guns_01 = (guns - gun_min) / (gun_max - gun_min)

*Create indicators for partisanship for partisan-conditional analysis
sort caseid year
gen party2010=pid7 if year==2010
replace party2010=pid7[_n-1] if year==2012 & caseid[_n-1]==caseid
replace party2010=pid7[_n-2] if year==2014 & caseid[_n-2]==caseid
recode party2010 1/3=1 4=2 8=2 5/7=3
label define party 1 "Democrats" 2 "Independents" 3 "Republicans"
label values party2010 party




saveold final_longform_10_14_merged.dta, replace

clear




































