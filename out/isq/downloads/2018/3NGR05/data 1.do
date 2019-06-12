/*	This creates the monadic dataset for "Rewarding Human Rights?"

	Rich Nielsen, nielsen.rich@gmail.com
	Last modified: 24 July 2012   */

** This script assumes that you have changed the working directory
** to wherever you have opened the archive.
*** You'll want to enter the following directly from the command line: 
clear
set mem 600M
set more off
*cd "your/directory/here"

** make a directory to store the data we are combining
capture mkdir "working"

**I use Gleditsch's improved GDP var as the base
insheet using "data/expgdp_v5.0.asc", delimiter(" ")
gen countryname_g="proper(countryname)"
rename stateid countrycode_g
run "data/Standardize Country Codes.do"
move  countryname_g countrycode_g
drop countrynumcode_g origin
rename statenum countrynumcode_g
sort  countryname_g year
rename  pop population //(Units are in 1000's)
rename  rgdpch rgdpc
gen ln_population=ln(population)
gen ln_population_sq=ln_population^2
gen ln_rgdpc=ln(rgdpc)
gen ln_rgdpc_sq=ln_rgdpc^2

egen countrynum=group(countryname)
tsset countrynum year

gen rgdp=rgdpc*population
gen rgdpcgrowth=((rgdpc-l.rgdpc)/l.rgdpc)*100
gen rgdpgrowth=((rgdp-l.rgdp)/l.rgdp)*100
rename countryname_g countryname


** Make the aid variables
** Begin commenting out of aid var code
/*

save "working/dat1.dta" , replace
clear


** This makes the OECD data from the 2008 CRS CD
  ** put 2004-2006 together to avoid duplicates
insheet using "data\CRS2008\data2004_1.csv"
save "data\CRS2008\temp2004.dta", replace
clear
insheet using "data\CRS2008\data2004_2.csv"
append using "data\CRS2008\temp2004.dta"
outsheet using "data\CRS2008\data2004.csv", comma replace
erase "data\CRS2008\temp2004.dta"
clear

insheet using "data\CRS2008\data2005_1.csv"
save "data\CRS2008\temp2005.dta", replace
clear
insheet using "data\CRS2008\data2005_2.csv"
append using "data\CRS2008\temp2005.dta"
outsheet using "data\CRS2008\data2005.csv", comma replace
erase "data\CRS2008\temp2005.dta"
clear

insheet using "data\CRS2008\data2006_1.csv"
save "data\CRS2008\temp2006.dta", replace
clear
insheet using "data\CRS2008\data2006_2.csv"
append using "data\CRS2008\temp2006.dta"
outsheet using "data\CRS2008\data2006.csv", comma replace
erase "data\CRS2008\temp2006.dta"
clear

local filenames  data73-79 data80-89 data1990 data1991 data1992 data1993 data1994 data1995 data1996 data1997 data1998 data1999 data2000 data2001 data2002 data2003 data2004 data2005 data2006

foreach txtfile of local filenames {
  di "starting `txtfile'"
  *cd "data\CRS2008"
  insheet using "data/CRS2008/`txtfile'.csv", delimiter(",") clear

  ** Rename the variables
  rename v1 commitmentyear 
  rename v2 donorcode
  rename v3 donorname
  rename v4 agencyname
  rename v5 transactionno
  rename v6 projectnumber
  rename v7 nature_of_submission
  rename v8 recipientcode
  rename v9 recipientname
  rename v10 commitmentdate
  rename v11 flowcode
  rename v12 flowname
  rename v13 purposecode
  rename v14 purposename
  rename v15 shortdescription
  rename v16 longdescription 
  rename v17 projecttitle
  rename v18 channel_of_delivery
  rename v19 geography
  rename v20 grantelement
  rename v21 usd_amount
  rename v22 usd_amounttied
  rename v23 usd_amountuntied
  rename v24 usd_amountpartialtied
  rename v25 typerepayment
  rename v26 numberrepayment
  rename v27 repaydate1
  rename v28 repaydate2
  rename v29 interest1
  rename v30 gender
  rename v31 environment
  rename v32 PDGG
  rename v33 FTC
  rename v34 investmentproject
  rename v35 usd_IRTC
  rename v36 part

  ** amounts are in 1000's US dollars -- convert to US dollars
  replace usd_amount=usd_amount*1000

  *Convert project amounts into 2000 dollars.

  *** This is the new conversion using conversion factors from here:
  /*
   http://oregonstate.edu/cla/polisci/faculty-research/sahr/cv2000.pdf
   http://oregonstate.edu/cla/polisci/faculty-research/sahr/cv2006.pdf
   http://oregonstate.edu/cla/polisci/faculty-research/sahr/sahr.htm
   Conversion factors in Excel format starting 1665 are available at addresses above.
  (c) 2005 Robert C. Sahr, Political Science Department, Oregon State University, Corvallis, OR  97331-6206
    e-mail:  Robert.Sahr@oregonstate.edu;  WWW:  http://oregonstate.edu/cla/polisci/faculty/sahr-robert
  */

  capture rename commitmentyear year
  gen usd_amount2k=.
  replace usd_amount2k=usd_amount    if year==2000
  replace usd_amount2k=usd_amount/0.258 if year==1973
  replace usd_amount2k=usd_amount/0.286 if year==1974
  replace usd_amount2k=usd_amount/0.312 if year==1975
  replace usd_amount2k=usd_amount/0.330 if year==1976
  replace usd_amount2k=usd_amount/0.352 if year==1977
  replace usd_amount2k=usd_amount/0.379 if year==1978
  replace usd_amount2k=usd_amount/0.422 if year==1979
  replace usd_amount2k=usd_amount/0.479 if year==1980
  replace usd_amount2k=usd_amount/0.528 if year==1981
  replace usd_amount2k=usd_amount/0.56 if year==1982
  replace usd_amount2k=usd_amount/0.578 if year==1983
  replace usd_amount2k=usd_amount/0.603 if year==1984
  replace usd_amount2k=usd_amount/0.625 if year==1985
  replace usd_amount2k=usd_amount/0.636 if year==1986
  replace usd_amount2k=usd_amount/0.66 if year==1987
  replace usd_amount2k=usd_amount/0.687 if year==1988
  replace usd_amount2k=usd_amount/0.72 if year==1989
  replace usd_amount2k=usd_amount/0.759 if year==1990
  replace usd_amount2k=usd_amount/0.791 if year==1991
  replace usd_amount2k=usd_amount/0.815 if year==1992
  replace usd_amount2k=usd_amount/0.839 if year==1993
  replace usd_amount2k=usd_amount/0.861 if year==1994
  replace usd_amount2k=usd_amount/0.885 if year==1995
  replace usd_amount2k=usd_amount/0.911 if year==1996
  replace usd_amount2k=usd_amount/0.932 if year==1997
  replace usd_amount2k=usd_amount/0.947 if year==1998
  replace usd_amount2k=usd_amount/0.967 if year==1999
  replace usd_amount2k=usd_amount/1.028 if year==2001
  replace usd_amount2k=usd_amount/1.045 if year==2002
  replace usd_amount2k=usd_amount/1.069 if year==2003
  replace usd_amount2k=usd_amount/1.097 if year==2004
  replace usd_amount2k=usd_amount/1.134 if year==2005
  replace usd_amount2k=usd_amount/1.171 if year==2006

  ** Put the amount in millions
  replace usd_amount=usd_amount/1000000

  ** drop the extraneous variables and the extra observations
  keep  year donorname recipientname channel_of_delivery shortdescription longdescription projecttitle  usd_amount purposecode
  replace donorname=trim(donorname)
  replace donorname = proper(donorname)

  replace recipientname=trim( recipientname)
  rename channel_of_delivery channelofdeliveryname
  rename usd_amount commitmentsusdmillion2004
  capture tostring longdescription, replace


  ** saves the dataset
  *cd "C:\Documents and Settings\Rich\Desktop\RHR 2009"
  save "working/`txtfile'.dta", replace
}

clear

  ** This is the OECD 2008 CD-Rom up to 2006
local filenames  data73-79 data80-89 data1990 data1991 data1992 data1993 data1994 data1995 data1996 data1997 data1998 data1999 data2000 data2001 data2002 data2003 data2004 data2005 data2006

** This starts the loop for each file
foreach txtfile of local filenames {
  di "starting `txtfile'"
  use "working/`txtfile'.dta", clear

  ** keep only the commitment data (disbursements are also line item entries in this data).
  keep if  commitmentsusdmillion2004!=.

  quietly {
    ** generate the categories for each project
    gen hr=1 if purposecode==15162
    replace hr=0 if hr!=1

    gen cv=1 if purposecode==15130 | purposecode==15150 | purposecode==15161 | purposecode==15163
    replace cv=0 if cv!=1

    ** this makes cv and hr mutually exclusive--if a project is in both it goes to cv
    replace hr=0 if cv==1 

    gen el=1 if purposecode==15161
    replace el=0 if el!=1

    ** Defines Social aid
    gen social=1 if purposecode >=11000 & purposecode<17000 & hr==0 & cv==0 
    replace social=1 if purposecode >=70000 & purposecode<80000 & hr==0 & cv==0 
    ** Includes NGOs
    replace social=1 if purposecode >=92000 & purposecode<93000 & hr==0 & cv==0 
    ** Includes Food Aid
    replace social=1 if purposecode ==52010 & hr==0 & cv==0 
    replace social=0 if social!=1

    ** Defines Economic aid as the residual category
    gen econ=1 if social==0 & hr==0 & cv==0
    replace econ=0 if econ!=1

    ** Makes a marker for calculating all aid
    gen total=1

    **  Make the OECD data bilateral

    ** Note that I left out Portugal Spain because of inadequate aid reporting
    local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United States" "United Kingdom" 
    capture gen donty=""
    foreach dname of local dnames {
      di "`dname'"
      replace donty="B" if donorname=="`dname'"
    }

    drop if donty!="B"
   
    ** In case of leading spaces in the names
    replace  recipientname=rtrim( recipientname)
    rename recipientname countryname 
    run "data/Standardize Country Names.do"

    ** Calculate aid amounts by category for each recipient-year

    local aidcats hr cv el social econ total
    foreach cat of local aidcats {
      egen us2_`cat'=sum(commitmentsusdmillion2004) if `cat'==1, by(countryname year)
      gen us2_`cat'_bil=us2_`cat'/1000
      replace  us2_`cat'_bil=0 if us2_`cat'_bil==.
      egen usd2_`cat'_bil=max(us2_`cat'_bil), by(countryname year)
      drop us2*
    }

    ** Calculate "world aid" for each category
    local aidcats hr cv el social econ total
    foreach cat of local aidcats {
      egen us2_`cat'=sum(commitmentsusdmillion2004) if `cat'==1, by(year)
      gen us2_`cat'_bil=us2_`cat'/1000
      replace  us2_`cat'_bil=0 if us2_`cat'_bil==.
      egen usd2_`cat'_world_aid_bil=max(us2_`cat'_bil), by(year)
      drop us2*
    }

    rename usd2_total_world_aid_bil usd2_world_aid_bil

    ** Calculate dyadic aid amounts by category for each recipient-year

    local aidcats hr cv el social econ total
    local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United States" "United Kingdom" 
   
    foreach dname of local dnames {
      foreach cat of local aidcats {
        egen us2_`cat'=sum(commitmentsusdmillion2004) if `cat'==1 & donorname=="`dname'", by(countryname year)
        gen us2_`cat'_bil=us2_`cat'/1000
        replace  us2_`cat'_bil=0 if us2_`cat'_bil==.
        local holder "`dname'"
        if "`holder'" == "New Zealand" {
          local holder "NewZealand"
        }
        if "`holder'" == "United States" {
          local holder "US"
        }
        if "`holder'" == "United Kingdom" {
          local holder "UK"
        }
        di "Working on `holder' - `cat'"
        egen `holder'_`cat'_bil=max(us2_`cat'_bil), by(countryname year)
        drop us2*
      }
    }

    ** Generate world-aid totals for each donor
    local aidcats hr cv el social econ total
    local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United States" "United Kingdom" 
   
    foreach dname of local dnames {
      foreach cat of local aidcats {
        egen us2_`cat'=sum(commitmentsusdmillion2004) if `cat'==1 & donorname=="`dname'", by(year)
        gen us2_`cat'_bil=us2_`cat'/1000
        replace  us2_`cat'_bil=0 if us2_`cat'_bil==.
        local holder "`dname'"
        if "`holder'" == "New Zealand" {
          local holder "NewZea"
        }
        if "`holder'" == "United States" {
          local holder "US"
        }
        if "`holder'" == "United Kingdom" {
          local holder "UK"
        }
        if "`holder'" == "Netherlands" {
          local holder "Neth"
        }
        if "`holder'" == "Switzerland" {
          local holder "Switz"
        }
        di "Working on `holder' - `cat'"
        egen `holder'_`cat'_wldaid_bil=max(us2_`cat'_bil), by(year)
        drop us2*
      }
    }

    ** This loop changes "US_total_wldaid_bil" to "US_wldaid_bil" to match my old dataset
    local dnamestofix Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Neth NewZea Norway Sweden Switz US UK 
    foreach dname of local dnamestofix{
      rename `dname'_total_wldaid_bil `dname'_wldaid_bil
    }
   
    *******************************************************************************
    **  Make vars that is aid from only the main donors

    ** This makes a var which is the percentage of aid each donor contributed for each recipient
    gen donorshare=.
    
    local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United States" "United Kingdom" 
  
    foreach dname of local dnames{
      local holder "`dname'"
      if "`holder'" == "New Zealand" {
        local holder "NewZealand"
      }
      if "`holder'" == "United States" {
        local holder "US"
      }
      if "`holder'" == "United Kingdom" {
        local holder "UK"
      }
      replace donorshare = `holder'_total_bil/usd2_total_bil if donorname=="`dname'"
    }

    ** this makes a dummy for whether the donor is a primary donor of the recipient
    gen primarydonor=.
    replace primarydonor=1 if donorshare>=.33333333334
    replace primarydonor=0 if primarydonor!=1


    ** This makes an overall aid var counting only aid from primary donors
    local aidcats hr cv el social econ total
   
    foreach cat of local aidcats {
      egen pus2_`cat'=sum(commitmentsusdmillion2004) if `cat'==1 & primarydonor==1, by(countryname year)
      gen pus2_`cat'_mil=pus2_`cat'
      replace  pus2_`cat'_mil=0 if pus2_`cat'_mil==.
      egen usd2_`cat'_mil_primary=max(pus2_`cat'_mil), by(countryname year)
      drop pus2*
    }
  
    ** generates the wldaid versions of primary donor
    foreach cat of local aidcats {
      egen pus2_`cat'=sum(commitmentsusdmillion2004) if `cat'==1 & primarydonor==1, by(year)
      gen pus2_`cat'_mil=pus2_`cat'
      replace  pus2_`cat'_mil=0 if pus2_`cat'_mil==.
      egen usd2_`cat'_waid_mil_primary=max(pus2_`cat'_mil), by(year)
      drop pus2*
    }
    ** rename the one var to match my old dataset
    rename usd2_total_waid_mil_primary usd2_waid_mil_primary


    ** This makes an overall aid var counting only aid from SECONDARY donors
    local aidcats hr cv el social econ total
   
    foreach cat of local aidcats {
      egen sus2_`cat'=sum(commitmentsusdmillion2004) if `cat'==1 & primarydonor==0, by(countryname year)
      gen sus2_`cat'_mil=sus2_`cat'
      replace  sus2_`cat'_mil=0 if sus2_`cat'_mil==.
      egen usd2_`cat'_mil_second=max(sus2_`cat'_mil), by(countryname year)
      drop sus2*
    }
  
    ** generates the wldaid versions of primary donor
    foreach cat of local aidcats {
      egen sus2_`cat'=sum(commitmentsusdmillion2004) if `cat'==1 & primarydonor==0, by(year)
      gen sus2_`cat'_mil=sus2_`cat'
      replace  sus2_`cat'_mil=0 if sus2_`cat'_mil==.
      egen usd2_`cat'_waid_mil_second=max(sus2_`cat'_mil), by(year)
      drop sus2*
    }
    ** rename the one var to match my old dataset
    rename usd2_total_waid_mil_second usd2_waid_mil_second

    *****************************************
 

    ** drop the extraneous variables and the extra observations
    keep  year countryname stateinyeart_g microstateinyeart_g usd2*  Australia* Austria* Belgium*  Canada* Denmark* Finland* France* Germany* Italy* Japan* Neth* NewZea* Norway* Sweden* Switz* US* UK*
    duplicates drop
  ** end quietly
  }

  ** saves the dataset
  save "working/`txtfile'trim.dta", replace
}

use "working\data73-79trim.dta", clear

local datasets2 data80-89 data1990 data1991 data1992 data1993 data1994 data1995 data1996 data1997 data1998 data1999 data2000 data2001 data2002 data2003 data2004 data2005 data2006

foreach dtafile of local datasets2 {
  append using "working/`dtafile'trim.dta"
}


duplicates drop

save "data/OECD 73-06.dta", replace

** Erase the extra datasets
local datasets data73-79 data80-89 data1990 data1991 data1992 data1993 data1994 data1995 data1996 data1997 data1998 data1999 data2000 data2001 data2002 data2003 data2004 data2005 data2006

foreach file of local datasets {
  erase "working/`file'trim.dta"
  erase "working/`file'.dta"
}
erase "data/CRS2008/data2004.csv"
erase "data/CRS2008/data2005.csv"
erase "data/CRS2008/data2006.csv"

** After the dataset is all together
**  Make all the names the same

run "data\Standardize Country Names.do"
run "data\Standardize Country Codes.do"

** sorts the observations
sort countryname year
save "data\OECD 73-06.dta", replace



use "working\dat1.dta", clear

** Ends commenting out of aid var code
*/

/*	Instead of doing this part, just use:  */

merge countryname year using "data\OECD 73-06.dta", unique sort _merge(_merge_aid_vars)


/*	This replaces missing values in the aid data with zeros
	explicitly assuming that if nothing is listed in 
	the OECD database, then no aid was given.  */

move  _merge_aid_vars population
capture drop countrynum
egen countrynum=group(countryname)
tsset countrynum year


** Fills in for the main aggregated aid vars
local aidcats hr cv el social econ total
   
foreach cat of local aidcats {
  replace  usd2_`cat'_bil=0 if  usd2_`cat'_bil==. & year>1972 & year<2007
}
 

** main vars for each donor
local aidcats hr cv el social econ total
local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands NewZealand Norway Sweden Switzerland US UK
   
foreach dname of local dnames {
  foreach cat of local aidcats {
    replace  `dname'_`cat'_bil=0 if  `dname'_`cat'_bil==. & year>1972 & year<2007
  }
}

** World aid vars
local aidcats2 hr cv el social econ

   
foreach cat of local aidcats2 {
  replace  usd2_`cat'_world_aid_bil=0 if  usd2_`cat'_world_aid_bil==. & year>1972 & year<2007
}
** World aid vars by donor

local aidcats2 hr cv el social econ
local dnames2 Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Neth NewZea Norway Sweden Switz US UK
   
   
foreach dname of local dnames2 {
  replace  `dname'_wldaid_bil=0 if  `dname'_wldaid_bil==. & year>1972 & year<2007
  foreach cat of local aidcats2 {
    replace  `dname'_`cat'_wldaid_bil=0 if  `dname'_`cat'_wldaid_bil==. & year>1972 & year<2007
  }
}

** single var that doesn't need a loop
replace  usd2_total_bil=0 if  usd2_total_bil==. & year>1972 & year<2007
 
** single var that doesn't need a loop  
replace  usd2_world_aid_bil=0 if  usd2_world_aid_bil==. & year>1972 & year<2007


***********  I don't think I ever fill in the missing values for primary/secondary donors...
** CHECK THIS!!

 ********** Generating additional aid variables for the analysis *********************

/* This makes the "civil/pol rights - elections" aid var */
gen usd2_cs_bil=usd2_cv_bil-usd2_el_bil 
*cs stands for civil society...
gen usd2_cs_world_aid_bil=usd2_cv_world_aid_bil-usd2_el_world_aid_bil

/*This makes the ln_aid vars. */

local aidcats hr cv el cs social econ total
foreach cat of local aidcats {
  gen ln_usd2_`cat'_bil=ln( (usd2_`cat'_bil*1000000000)+1)
}

local aidcats hr cv el cs social econ
foreach cat of local aidcats {
  gen ln_usd2_`cat'_world_aid_bil=ln( (usd2_`cat'_world_aid_bil*1000000000)+1)
}

gen ln_usd2_world_aid_bil=ln(( usd2_world_aid_bil *1000000000)+1)


/*	This section makes the "ratio of aid" vars  */
 
local aidcats hr cv el cs social econ
foreach cat of local aidcats {
  gen lnratio_`cat'_bil=ln(( (usd2_`cat'_bil*1000000000)+1)/( usd2_total_bil*1000000000))
}

/*This puts some of them in millions for prettier tables */

capture gen usd2_hrcv_bil = usd2_hr_bil + usd2_cv_bil

capture gen usd2_total_mil=usd2_total_bil*1000
capture gen usd2_world_aid_mil=usd2_world_aid_bil*1000
capture gen usd2_hr_mil=usd2_hr_bil*1000
capture gen usd2_hr_world_aid_mil=usd2_hr_world_aid_bil*1000
capture gen usd2_cv_mil=usd2_cv_bil*1000
capture gen usd2_cv_world_aid_mil=usd2_cv_world_aid_bil*1000
capture gen usd2_hrcv_mil=usd2_hrcv_bil*1000
capture gen usd2_hrcv_world_aid_mil=usd2_hrcv_world_aid_bil*1000
capture gen usd2_social_mil=usd2_social_bil*1000
capture gen usd2_social_world_aid_mil=usd2_social_world_aid_bil*1000
capture gen usd2_econ_mil=usd2_econ_bil*1000
capture gen usd2_econ_world_aid_mil=usd2_econ_world_aid_bil*1000


/* Clean-up from the aid variable merge:
   There were some countries that got aid 
   before they were independent.  These are
   NOT included, because Gleditsch doesn't have
   trade/GDP date for them, and they would
   have negative values for the years of indep
   var, except that I changed them to "." 
*/

drop if countryname == ""
drop if countryname== "Africa Unspecified"
drop if countryname== "America Unspecified"
drop if countryname== "Asia Unspecified"
drop if countryname== "Ceecs Unallocated"
drop if countryname== "Ceecs/Nis Unalloc."
drop if countryname== "Dom N.& C. Amer. Unall"
drop if countryname== "Dom South Of Sah.Unall"
drop if countryname== "Eam Unallocated"
drop if countryname== "East African Comm."
drop if countryname== "Europe Unallocated"
drop if countryname== "Far East Asia Unall."
drop if countryname== "Ldcs Unspecified"
drop if countryname== "Middle East Unall."
drop if countryname== "Multilateral, Other                                                        "
drop if countryname== "N.& C. America Unall."
drop if countryname== "Nis Unallocated"
drop if countryname== "North Of Sahara Unall."
drop if countryname== "Oceania Unallocated"
drop if countryname== "Opp South Of Sah.Unall"
drop if countryname== "South Asia Unall."
drop if countryname== "Part Ii Unallocated"
drop if countryname== "South & Central Asia Unall."
drop if countryname== "South America Unall."
drop if countryname== "South Of Sahara Unall."
drop if countryname== "West Indies Unall."
drop  _merge_aid_vars


/*	This part adds the CIRI variables 
	These are what limits the lower end of the sample
	They start in 1981, so with the lag, the sample starts in 1982 */
save "working/dat1" , replace
clear
insheet using "data/CIRI 2007.csv"
rename ctry countryname
  ** make the 2007 version have the same vars as the 2004 version I used earlier
drop new_empinx formov dommov new_relfre injud
rename old_empinx empinx
rename old_relfre relfre
rename old_move move
rename elecsd polpar

/* The fix below deleted missing values where Gleditsch treats the
	countries as continuous and CIRI treats them as separate  */
drop if countryname=="Soviet Union" & year>=1992
drop if countryname=="Russia" & year<=1991
drop if countryname=="Yemen Arab Republic" & year>=1991
drop if countryname=="Yemen, South"
drop if countryname=="Yemen" & year<=1990
drop if countryname=="Yugoslavia" & year>1991
drop if countryname=="Yugoslavia, Federal Republic of" & year<=1991
drop if countryname=="Serbia and Montenegro" & year<=1991
drop if countryname=="Serbia and Montenegro" & year>=2000 & year<=2002
drop if countryname=="Serbia and Montenegro" & year>=2006
drop if countryname=="Yugoslavia, Federal Republic of" & (year<2000 | year>2002)
drop if countryname=="Montenegro" & year<2006
drop if countryname=="Serbia" & year<2006

run "data/Standardize Country Names.do"

/*	The -999's in CIRI are for when there was no mention in the reports
  	physint and empinx are missing if their constituent measuers are -66 or -77 */

gen anarchy=1 if disap==-77 | kill==-77 | polpris==-77 | tort==-77 | assn==-77 | move==-77 | speech==-77 | polpar==-77 | relfre==-77 | wecon==-77 | wopol==-77 | wosoc==-77
replace anarchy=0 if anarchy!=1
gen foreign_occup=1 if disap==-66 | kill==-66 | polpris==-66 | tort==-66 | assn==-66 | move==-66 | speech==-66 | polpar==-66 | relfre==-66 | wecon==-66 | wopol==-66 | wosoc==-66 
replace foreign_occup=0 if foreign_occup!=1
/* 	This allows for tests like:
	ttest  usd2_hr_bil, by(foreign_occup) unequal
	sdtest  usd2_hr_bil, by(foreign_occup) 
	to show that it doesn't matter to exclude these observations  */
notes anarchy: This is from CIRI. It is one if CIRI codes any of the HR vars as -77 which means "anarchy".
notes foreign_occup: This is from CIRI. It is one if CIRI codes any of the HR vars as -66 which means "foreign occupier".
gen physint_orig=physint
gen disap_orig=disap
gen kill_orig=kill
gen polpris_orig=polpris
gen tort_orig=tort
gen empinx_orig=empinx
gen assn_orig=assn
gen move_orig=move
gen speech_orig=speech
gen polpar_orig=polpar
gen relfre_orig=relfre
gen worker_orig=worker
gen wecon_orig=wecon
gen wopol_orig=wopol
gen wosoc_orig=wosoc
/*  This way, I can test to see what kind of aid goes to -66 and -77's */
replace  physint=. if physint==-999 /*1 missing value*/
replace  disap=. if disap==-999 
replace  kill=. if kill==-999 
replace  polpris=. if polpris==-999 
replace  tort=. if tort==-999 
replace  empinx=. if empinx==-999 /*1 missing value*/
replace  assn=. if assn==-999
replace  move=. if move==-999
replace  speech=. if speech==-999
replace  polpar=. if polpar==-999
replace  relfre=. if relfre==-999
replace  worker=. if worker==-999
replace  wecon=. if wecon==-999  /*71 missing values*/
replace  wopol=. if wopol==-999  /*16 missing values*/
replace  wosoc=. if wosoc==-999  /*132 missing values*/
/*	The -77's and -66's pose a bigger problem.  I emailed Richard Cingranell
	told me that these were for foreign occupation (-66) and anarchy (-77)
	He said that it is a "misnomer to talk about 'government human rights practices'" in these situations  */
replace  physint=. if physint==-77  /* 0 missing value */
replace  disap=. if disap==-77
replace  kill=. if kill==-77
replace  polpris=. if polpris==-77
replace  tort=. if tort==-77
replace  empinx=. if empinx==-77  /* 0 missing value */
replace  assn=. if assn==-77
replace  move=. if move==-77
replace  speech=. if speech==-77
replace  polpar=. if polpar==-77
replace  relfre=. if relfre==-77
replace  worker=. if worker==-77
replace  wecon=. if wecon==-77  /* 56 missing values */
replace  wopol=. if wopol==-77  /* 56 missing values */
replace  wosoc=. if wosoc==-77  /* 47 missing values */
replace  physint=. if physint==-66  /* 2 missing value */
replace  disap=. if disap==-66
replace  kill=. if kill==-66
replace  polpris=. if polpris==-66
replace  tort=. if tort==-66
replace  empinx=. if empinx==-66  /* 0 missing value */
replace  assn=. if assn==-66
replace  move=. if move==-66
replace  speech=. if speech==-66
replace  polpar=. if polpar==-66
replace  relfre=. if relfre==-66
replace  worker=. if worker==-66
replace  wecon=. if wecon==-66  /* 25 missing values */
replace  wopol=. if wopol==-66  /* 25 missing values */
replace  wosoc=. if wosoc==-66  /* 23 missing values */
gen wosum= wecon+ wopol+ wosoc
move wosum worker
notes wosum: gen wosum= wecon+ wopol+ wosoc (1444 missing values generated)
notes physint: CIRI variable with missing values replaced to be "."
notes empinx: CIRI variable with missing values replaced to be "."
notes wecon: CIRI variable with missing values replaced to be "."
notes wopol: CIRI variable with missing values replaced to be "."
notes wosoc: CIRI variable with missing values replaced to be "."
notes worker: CIRI variable with missing values as -66 and -77
notes physint_orig: CIRI variable with missing values as -66 and -77
notes empinx_orig: CIRI variable with missing values as -66 and -77
notes wecon_orig: CIRI variable with missing values as -66 and -77
notes wopol_orig: CIRI variable with missing values as -66 and -77
notes wosoc_orig: CIRI variable with missing values as -66 and -77
save "working/CIRI vars for merge.dta" , replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/CIRI vars for merge.dta", unique sort _merge(_merge_ciri_vars)
move  _merge_ciri_vars population

erase "working/CIRI vars for merge.dta"

/* Post merge clean-up */
/* I checked: this deletes states not in Gleditsch--either micro states or not yet independent
	The only states left as _merge 2's are thos from 2001-2004  */
drop if _merge_ciri_vars==2 & year<=2000
drop  _merge_ciri_vars
* This makes squared terms for physint, empinx, and wosum.
capture gen physint_sq=physint*physint
capture gen empinx_sq=empinx*empinx
capture gen wosum_sq=wosum*wosum


/* This adds conflict data from PRIO.*/
** Data downloaded from http://www.pcr.uu.se/research/UCDP/data_and_publications/datasets.htm on Jan 19, 2009
save "working/dat1.dta" , replace

clear
insheet using "data/prio.txt", tab

/* To seperate civil conflicts from interstate conflicts,
   save the "type" var and split out the types (1-2) interstate,
   (3-4) intrastate. */

keep  sidea year 
rename sidea countryname
gen priowar=1
run "data/Standardize Country Names.do"
  ** weird problem
replace stateinyeart_g=1 if countryname=="Saudi Arabia"
drop if  stateinyeart_g==. &  microstateinyeart_g==.
  ** This is potentially a problem but it is out of the time range*France, Israel, United Kingdom	1956	2
duplicates drop
save "working/prioA.dta", replace

clear
insheet using "data/prio.txt", tab

keep  sideb year
gen priowar=1
rename sideb countryname
run "data/Standardize Country Names.do"
  ** weird problem
replace stateinyeart_g=1 if countryname=="Saudi Arabia"
drop if  stateinyeart_g==. &  microstateinyeart_g==.
** This could be a problem except that none of these are recipients
** or else they are out of the date range.*Australia, United Kingdom, United States Of America	2003	2*Egypt, Iraq, Jordan, Lebanon, Syria	1949	2
*Egypt, Iraq, Jordan, Lebanon, Syria	1948	2
duplicates drop
save "working/prioB.dta", replace

use "working/dat1.dta", clear
merge countryname year using "working/prioA.dta", unique sort _merge(_merge_prioA)
merge countryname year using "working/prioB.dta", unique sort _merge(_merge_prioB)

replace priowar=0 if priowar==.

  ** this shortens the storage of the string
compress  countryname

drop _merge_prio*
erase "working/prioB.dta"
erase "working/prioA.dta"


/* This section adds the Forces Abroad data I coded */
save "working/dat1.dta" , replace
clear
insheet using "data/Foreign Forces (estimated).csv"
/* This cleanup gets rid of duplicates.  There were not foreign forces
   in any of these countries anyways  */
drop if country == "Germany West"
drop if country == "Germany, East"
drop if country == "Germany-new"
drop if country == "Soviet Union"
drop if country == "Suriname"
drop if country == "USSR"
drop if country == "Serbia and Montenegro"
drop if country == "Yemen North"
drop if country == "Yemen, North"
drop if country == "Yemen, South"
drop if country == "North Yemen"
drop if country == "South Yemen"
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
drop if  countrycode_g=="Country Code (Gleditsch)"
drop  countrynumcode_g countrycode_g  microstateinyeart_g stateinyeart_g
save "working/Foreign Force vars for merge.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/Foreign Force vars for merge.dta", unique sort _merge(_merge_foreignforce_vars)
move _merge_foreignforce_vars population
drop if _merge_foreignforce_vars==2 /*the only worry with this is Bangladesh 1971 */
drop _merge_foreignforce_vars
erase "working/Foreign Force vars for merge.dta"
  ** Fill in for countries I dropped
  ** This works because I coded ALL of the forces abroad
replace usforces=0 if usforces==. & year>1947 & year<2007
replace usforce_dummy=0 if  usforce_dummy==. & year>1947 & year<2007
replace ukforces=0 if ukforces==. & year>1947 & year<2007
replace ukforce_dummy=0 if  ukforce_dummy==. & year>1947 & year<2007
replace frforces=0 if frforces==. & year>1947 & year<2007
replace frforce_dummy=0 if  frforce_dummy==. & year>1947 & year<2007
  ** make DAC forces var
gen forces_DAC1= usforces+ ukforces+ frforces
gen forces_DAC=forces_DAC1/1000
notes forces_DAC: measured in thousands of troops


/* This section adds life expectancy data from the WDI */
save "working/dat1.dta" , replace
clear
use "data/Life expectancy.WDI.dta", clear
rename country countryname
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
drop if  countrycode_g=="Country Code (Gleditsch)"
keep  countryname year  life_exp_total avg_life_80_00
notes life_exp_total: From the WDI (World Bank 2005)
notes avg_life_80_00: This is the average of life_exp_total between 1980 and 2000.  From the WDI (World Bank 2005)
save "working/Life Expectancy for merge.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/Life Expectancy for merge.dta", unique sort _merge(_merge_lifeexp_vars)
move _merge_lifeexp_vars population
drop if _merge_lifeexp_vars==2 
erase "working/Life Expectancy for merge.dta"
/*Again, Bangladesh 1971 is the only questionable one.  Gleditsch doesn't
  doesn't have GDP data for it in 1971, I checked. */
drop _merge_lifeexp_vars
gen   avg_life_80_00_mean= avg_life_80_00
drop  avg_life_80_00
egen  avg_life_80_00=mean( avg_life_80_00_mean), by(countryname)
drop  avg_life_80_00_mean



/*This section adds the ICRG governance variables */
save "working/dat1.dta" , replace
clear
use "data/ICRG.complete.dta", clear
rename country countryname
/* This solves some duplicates */
drop if countryname=="Germany" & year<=1990
drop if countryname=="West Germany" & year>=1991
drop if countryname=="East Germany" & year>=1991
drop if countryname=="Czech Republic" & year<=1992
drop if countryname=="Czechoslovakia" & year>=1993
drop if countryname=="Russia" & year<=1991
drop if countryname=="USSR" & year>=1992
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
drop if  countrycode_g=="Country Code (Gleditsch)" /* drops Hong Kong, New Caledonia */
gen governance_icrg= ( corruption_icrg+ bureaucratic_quality_icrg+ law_and_order_icrg)/3
notes  governance_icrg: governance_icrg= ( corruption_icrg+ bureaucratic_quality_icrg+ law_and_order_icrg)/3
keep  countryname year governance_icrg
save "working/ICRG governance var for merge.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/ICRG governance var for merge.dta", unique sort _merge(_merge_icrg_var)
move _merge_icrg_var population
drop if _merge_icrg_var==2 /*just drops non-independent states */
drop _merge_icrg_var
erase "working/ICRG governance var for merge.dta"

/* This section adds polity4  */
save "working/dat1.dta" , replace
clear
insheet using "data/p4v2006.csv"
rename  country countryname
/* These fixes cut the data off at 1945--not ideal but doesn't matter here */
drop if countryname=="Germany" & year==1945
drop if countryname=="Germany" & year==1990
drop if countryname=="Yugoslavia" & durable==37
drop if countryname=="Yemen" & year==1990
drop if countryname=="Ethiopia" &  year==1993 & polity2==0
drop if countryname=="Vietnam North" & year==1976
drop if year<1945
drop if countryname=="Serbia"

run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
move  countrycode_g year
drop if  countrycode_g=="Country Code (Gleditsch)"
keep countryname year polity2 parcomp
/* This part drops the -66, -77, -88 (foreign occ, anarchy, and transition, respective) */
/* It might be a good idea to estimate the transition values */
replace parcomp=. if parcomp==-66
replace parcomp=. if parcomp==-77
replace parcomp=. if parcomp==-88
replace polity2=. if polity2==-77
save "working/Polity var for merge.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/Polity var for merge.dta", unique sort _merge(_merge_polity_vars)
move _merge_polity_vars population
drop if _merge_polity_vars==2
drop _merge_polity_vars
erase "working/Polity var for merge.dta"

/* This section adds Freedom house  */
** This only goes from 1972-2000 but it's not worth extending right now
save "working/dat1.dta" , replace
clear
use "data/Freedom House (time series).dta", clear
rename  recipientname_e countryname
drop if countryname=="Vietnam, N." & year>1975 /* This just drops plank observations */
drop if countryname=="Vietnam, S." & year>1975 /* This just drops plank observations */
drop if countryname=="Vietnam" & year<=1975 /* This just drops plank observations */
drop if countryname=="Yemen, S." & year>1989  /* This just drops plank observations */
drop if countryname=="North Yemen" & year>1989  /* This just drops plank observations */
drop if countryname=="Yemen" & year<=1989  /* This just drops plank observations */
drop if countryname=="USSR" & year>=1991
drop if countryname=="Russia" & year <=1990
drop if countryname=="Czech Rep." & year<=1992
drop if countryname=="Czechoslovakia" & year>=1993
drop if countryname=="Germany, E." & year>1989
drop if countryname=="Germany, W." & year>1989
drop if countryname=="Germany" & year <1990
drop if countryname=="Cyprus (T)*" /*I explicitly use just Greek cyprus. Check the FH info on this one */
replace countryname = "Cyprus" if countryname == "Cyprus (G)"
run "data/Standardize Country Names.do"
drop if  stateinyeart_g==. &  microstateinyeart_g==.
keep  FH_political FH_civil FH_category countryname year
save "working/FH vars for merge.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/FH vars for merge.dta", unique sort _merge(_merge_fh_vars)
move _merge_fh_vars population
drop if _merge_fh_vars==2 /* This just drops 4 micro states */
drop _merge_fh_vars
erase "working/FH vars for merge.dta"


/* Put in alliance data from ATOP by Ashley Leeds */
save "working/dat1.dta" , replace
clear
use "data/atop3_0dy.dta", clear
keep  year atopally mem1 mem2
rename mem1 ccode1
rename mem2 ccode2
gen country=""
gen partner=""
run "data/Cow convert.do"
drop ccode*

   ** the dyads are directed so I recombine them as undirected
save "working/allies1.dta", replace

rename country country1
rename partner country
rename country1 partner
append using "working/allies1.dta"

replace partner="United States" if partner=="United States of America"
replace partner="Germany" if partner=="German Federal Republic"
gen DAC=1 if partner=="United States" | partner=="Austria" | partner=="Belgium" | partner=="Canada" | partner=="Denmark" | partner=="France" | partner=="Germany" |  partner=="Ireland" | partner=="Italy" | partner=="Luxembourg" | partner=="Netherlands" | partner=="Norway" | partner=="Portugal" | partner=="Spain" | partner=="Sweden" | partner=="Switzerland" | partner=="United Kingdom"
replace DAC=1 if partner=="Japan" | partner=="Finland" | partner=="Australia" | partner=="New Zealand" 

drop if DAC!=1
rename country countryname
egen alliance_DAC=sum(atopally) if DAC==1, by(countryname year)
egen alliance1_UnitedStates=sum(atopally) if partner=="United States", by(countryname year)
egen alliance_UnitedStates=max(alliance1_UnitedStates), by(countryname year)
egen alliance1_Austria=sum(atopally) if partner=="Austria", by(countryname year)
egen alliance_Austria=max(alliance1_Austria), by(countryname year)
egen alliance1_Australia=sum(atopally) if partner=="Australia", by(countryname year)
egen alliance_Australia=max(alliance1_Australia), by(countryname year)
egen alliance1_Belgium=sum(atopally) if partner=="Belgium", by(countryname year)
egen alliance_Belgium=max(alliance1_Belgium), by(countryname year)
egen alliance1_Canada=sum(atopally) if partner=="Canada", by(countryname year)
egen alliance_Canada=max(alliance1_Canada), by(countryname year)
egen alliance1_Denmark=sum(atopally) if partner=="Denmark", by(countryname year)
egen alliance_Denmark=max(alliance1_Denmark), by(countryname year)
egen alliance1_France=sum(atopally) if partner=="France", by(countryname year)
egen alliance_France=max(alliance1_France), by(countryname year)
egen alliance1_Finland=sum(atopally) if partner=="Finland", by(countryname year)
egen alliance_Finland=max(alliance1_Finland), by(countryname year)
egen alliance1_Germany=sum(atopally) if partner=="Germany", by(countryname year)
egen alliance_Germany=max(alliance1_Germany), by(countryname year)
egen alliance1_Ireland=sum(atopally) if partner=="Ireland", by(countryname year)
egen alliance_Ireland=max(alliance1_Ireland), by(countryname year)
egen alliance1_Italy=sum(atopally) if partner=="Italy", by(countryname year)
egen alliance_Italy=max(alliance1_Italy), by(countryname year)
egen alliance1_Luxembourg=sum(atopally) if partner=="Luxembourg", by(countryname year)
egen alliance_Luxembourg=max(alliance1_Luxembourg), by(countryname year)
egen alliance1_Netherlands=sum(atopally) if partner=="Netherlands", by(countryname year)
egen alliance_Netherlands=max(alliance1_Netherlands), by(countryname year)
egen alliance1_Norway=sum(atopally) if partner=="Norway", by(countryname year)
egen alliance_Norway=max(alliance1_Norway), by(countryname year)
egen alliance1_Portugal=sum(atopally) if partner=="Portugal", by(countryname year)
egen alliance_Portugal=max(alliance1_Portugal), by(countryname year)
egen alliance1_Spain=sum(atopally) if partner=="Spain", by(countryname year)
egen alliance_Spain=max(alliance1_Spain), by(countryname year)
egen alliance1_Sweden=sum(atopally) if partner=="Sweden", by(countryname year)
egen alliance_Sweden=max(alliance1_Sweden), by(countryname year)
egen alliance1_Switzerland=sum(atopally) if partner=="Switzerland", by(countryname year)
egen alliance_Switzerland=max(alliance1_Switzerland), by(countryname year)
egen alliance1_UnitedKingdom=sum(atopally) if partner=="United Kingdom", by(countryname year)
egen alliance_UnitedKingdom=max(alliance1_UnitedKingdom), by(countryname year)
egen alliance1_Japan=sum(atopally) if partner=="Japan", by(countryname year)
egen alliance_Japan=max(alliance1_Japan), by(countryname year)
egen alliance1_NewZealand=sum(atopally) if partner=="New Zealand", by(countryname year)
egen alliance_NewZealand=max(alliance1_NewZealand), by(countryname year)
drop alliance1*
drop  atopally partner DAC
duplicates drop
drop if countryname=="German Federal Republic" & year==1990
run "data/Standardize Country Names.do"
drop if year<1948
save "working/Alliance data for merge.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/Alliance data for merge.dta", unique sort _merge(_merge_alliance_vars)
move _merge_alliance_vars population
drop if _merge_alliance_vars==2  /* this is dropping New Zealand 1950-67 when it was independent,--odd, but not in my time-frame */
drop _merge_alliance_vars
erase "working/Alliance data for merge.dta"
/*  This fills in the countries that had no alliances and thus weren't counted correctly */
replace alliance_DAC=0 if alliance_DAC==. & year<2004
replace alliance_UnitedStates=0 if alliance_UnitedStates==. & year<2004
replace alliance_Austria=0 if alliance_Austria==. & year<2004
replace alliance_Australia=0 if alliance_Australia==. & year<2004
replace alliance_Belgium=0 if alliance_Belgium==. & year<2004
replace alliance_Canada=0 if alliance_Canada==. & year<2004
replace alliance_Denmark=0 if alliance_Denmark==. & year<2004
replace alliance_France=0 if alliance_France==. & year<2004
replace alliance_Finland=0 if alliance_Finland==. & year<2004
replace alliance_Germany=0 if alliance_Germany==. & year<2004
replace alliance_Ireland=0 if alliance_Ireland==. & year<2004
replace alliance_Italy=0 if alliance_Italy==. & year<2004
replace alliance_Luxembourg=0 if alliance_Luxembourg==. & year<2004
replace alliance_Netherlands=0 if alliance_Netherlands==. & year<2004
replace alliance_Norway=0 if alliance_Norway==. & year<2004
replace alliance_Portugal=0 if alliance_Portugal==. & year<2004
replace alliance_Spain=0 if alliance_Spain==. & year<2004
replace alliance_Sweden=0 if alliance_Sweden==. & year<2004
replace alliance_Switzerland=0 if alliance_Switzerland==. & year<2004
replace alliance_UnitedKingdom=0 if alliance_UnitedKingdom==. & year<2004
replace alliance_Japan=0 if alliance_Japan==. & year<2004
replace alliance_NewZealand=0 if alliance_NewZealand==. & year<2004



/*	This section adds French/British colony vars from Fearon  */
save "working/dat1.dta" , replace
clear
use "data/Ethnicity, Insurgency, and Civil war.dta", clear
keep  country  year colbrit colfra
rename country countryname
drop if countryname=="Yemen, South" & year==1990
drop if countryname=="Yemen, North" & year==1990
run "data/Standardize Country Names.do"
save "working/Colony vars for merge.dta" , replace
clear
use "working/dat1.dta", clear
run "data/Standardize Country Codes.do"
merge countryname year using "working/Colony vars for merge.dta", unique sort _merge(_merge_colony_vars)
move _merge_colony_vars population
drop if _merge_colony_vars==2
drop _merge_colony_vars
erase "working/Colony vars for merge.dta"

egen colbrit1=max(colbrit), by(countryname)
egen colfra1=max(colfra), by(countryname)


/*	This adds the Cold War var.  */
gen ColdWar=1 if year>=1992
replace ColdWar=0 if year<=1991


/* this section adds trade */
** Note that I'm now using the trade statistics from COPE put
** together by Josh Loud rather than Gleditsch's data because
** the Gleditsch data stops at 2000.
save "working/dat1.dta" , replace
clear

use "data/COPE.Master.Complete.11June07.dta", clear
keep countryname partner year trademd
rename trademd totaltrade1

gen DAC=1 if partner=="United States of America" | partner=="Austria" | partner=="Belgium" | partner=="Canada" | partner=="Denmark" | partner=="France" | partner=="German Federal Republic" |  partner=="Ireland" | partner=="Italy/Sardinia" | partner=="Luxembourg" | partner=="Netherlands" | partner=="Norway" | partner=="Portugal" | partner=="Spain" | partner=="Sweden" | partner=="Switzerland" | partner=="United Kingdom"
replace DAC=1 if partner=="Japan" | partner=="Finland" | partner=="Australia" | partner=="New Zealand" 
drop if DAC!=1
egen trade_DAC=sum(totaltrade1) if DAC==1, by(countryname year)
*notes trade_DAC: I think these trade data are given in millions of current year US dollars
**                In any case, check with Josh who put it together.
egen trade1_UnitedStates=sum(totaltrade1) if partner=="United States of America", by(countryname year)
egen trade_UnitedStates=max(trade1_UnitedStates), by(countryname year)
egen trade1_Austria=sum(totaltrade1) if partner=="Austria", by(countryname year)
egen trade_Austria=max(trade1_Austria), by(countryname year)
egen trade1_Australia=sum(totaltrade1) if partner=="Australia", by(countryname year)
egen trade_Australia=max(trade1_Australia), by(countryname year)
egen trade1_Belgium=sum(totaltrade1) if partner=="Belgium", by(countryname year)
egen trade_Belgium=max(trade1_Belgium), by(countryname year)
egen trade1_Canada=sum(totaltrade1) if partner=="Canada", by(countryname year)
egen trade_Canada=max(trade1_Canada), by(countryname year)
egen trade1_Denmark=sum(totaltrade1) if partner=="Denmark", by(countryname year)
egen trade_Denmark=max(trade1_Denmark), by(countryname year)
egen trade1_France=sum(totaltrade1) if partner=="France", by(countryname year)
egen trade_France=max(trade1_France), by(countryname year)
egen trade1_Finland=sum(totaltrade1) if partner=="Finland", by(countryname year)
egen trade_Finland=max(trade1_Finland), by(countryname year)
egen trade1_Germany=sum(totaltrade1) if partner=="German Federal Republic", by(countryname year)
egen trade_Germany=max(trade1_Germany), by(countryname year)
egen trade1_Ireland=sum(totaltrade1) if partner=="Ireland", by(countryname year)
egen trade_Ireland=max(trade1_Ireland), by(countryname year)
egen trade1_Italy=sum(totaltrade1) if partner=="Italy/Sardinia", by(countryname year)
egen trade_Italy=max(trade1_Italy), by(countryname year)
egen trade1_Luxembourg=sum(totaltrade1) if partner=="Luxembourg", by(countryname year)
egen trade_Luxembourg=max(trade1_Luxembourg), by(countryname year)
egen trade1_Netherlands=sum(totaltrade1) if partner=="Netherlands", by(countryname year)
egen trade_Netherlands=max(trade1_Netherlands), by(countryname year)
egen trade1_Norway=sum(totaltrade1) if partner=="Norway", by(countryname year)
egen trade_Norway=max(trade1_Norway), by(countryname year)
egen trade1_Portugal=sum(totaltrade1) if partner=="Portugal", by(countryname year)
egen trade_Portugal=max(trade1_Portugal), by(countryname year)
egen trade1_Spain=sum(totaltrade1) if partner=="Spain", by(countryname year)
egen trade_Spain=max(trade1_Spain), by(countryname year)
egen trade1_Sweden=sum(totaltrade1) if partner=="Sweden", by(countryname year)
egen trade_Sweden=max(trade1_Sweden), by(countryname year)
egen trade1_Switzerland=sum(totaltrade1) if partner=="Switzerland", by(countryname year)
egen trade_Switzerland=max(trade1_Switzerland), by(countryname year)
egen trade1_UnitedKingdom=sum(totaltrade1) if partner=="United Kingdom", by(countryname year)
egen trade_UnitedKingdom=max(trade1_UnitedKingdom), by(countryname year)
egen trade1_Japan=sum(totaltrade1) if partner=="Japan", by(countryname year)
egen trade_Japan=max(trade1_Japan), by(countryname year)
egen trade1_NewZealand=sum(totaltrade1) if partner=="New Zealand", by(countryname year)
egen trade_NewZealand=max(trade1_NewZealand), by(countryname year)
drop trade1*
drop  partner  totaltrade1 DAC
duplicates drop
gen ln_trade_DAC=ln((trade_DAC*1000000)+1)
notes ln_trade_DAC: ln_trade_DAC=ln((trade_DAC*1000000)+1)
gen ln_trade_UnitedStates=ln((trade_UnitedStates*1000000)+1)
gen ln_trade_Austria=ln((trade_Austria*1000000)+1)
gen ln_trade_Australia=ln((trade_Australia*1000000)+1)
gen ln_trade_Belgium=ln((trade_Belgium*1000000)+1)
gen ln_trade_Canada=ln((trade_Canada*1000000)+1)
gen ln_trade_Denmark=ln((trade_Denmark*1000000)+1)
gen ln_trade_France=ln((trade_France*1000000)+1)
gen ln_trade_Finland=ln((trade_Finland*1000000)+1)
gen ln_trade_Germany=ln((trade_Germany*1000000)+1)
gen ln_trade_Ireland=ln((trade_Ireland*1000000)+1)
gen ln_trade_Italy=ln((trade_Italy*1000000)+1)
gen ln_trade_Luxembourg=ln((trade_Luxembourg*1000000)+1)
gen ln_trade_Netherlands=ln((trade_Netherlands*1000000)+1)
gen ln_trade_Norway=ln((trade_Norway*1000000)+1)
gen ln_trade_Portugal=ln((trade_Portugal*1000000)+1)
gen ln_trade_Spain=ln((trade_Spain*1000000)+1)
gen ln_trade_Sweden=ln((trade_Sweden*1000000)+1)
gen ln_trade_Switzerland=ln((trade_Switzerland*1000000)+1)
gen ln_trade_UnitedKingdom=ln((trade_UnitedKingdom*1000000)+1)
gen ln_trade_Japan=ln((trade_Japan*1000000)+1)
gen ln_trade_NewZealand=ln((trade_NewZealand*1000000)+1)
save "working/Trade data for merge.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/Trade data for merge.dta", unique sort _merge(_merge_trade_vars)
move _merge_trade_vars population
drop if _merge_trade_vars==2 /*This drops micro-states and oddly New Zealand before 1968.  Not sure why */
drop _merge_trade_vars
erase "working/Trade data for merge.dta"



/*    This adds Years of Independence  */

save "working/dat1.dta" , replace
clear
use "data/Idependence dates.dta", clear
duplicates tag countryname year, gen(dup)
drop if countryname=="Haiti" & startyear==1816
drop if countryname=="Montenegro" & startyear==1868
drop if countryname=="Estonia" & startyear==1918
drop if countryname=="Latvia" & startyear==1918
drop if countryname=="Lithuania" & startyear==1918
drop if countryname=="Madagascar (Malagasy)" & startyear==1816
drop if countryname=="Morocco" & startyear==1816
drop if countryname=="Algeria" & startyear==1816
drop if countryname=="Tunisia" & startyear==1816
drop if countryname=="Libya" & startyear==1816
drop if countryname=="Egypt" & startyear==1827
drop if countryname=="Afghanistan" & startyear==1816
drop if countryname=="Myanmar (Burma)" & startyear==1816
replace countryname="Cote D'Ivoire" if countryname=="Cote D’Ivoire"
drop dup
save "working/Idependence dates for merge.dta" , replace
clear
use "working/dat1.dta" , clear
merge countryname year using "working/Idependence dates for merge.dta", unique sort _merge(_merge_indep_years)
egen startyear1 =max(startyear), by(countryname)
gen years_indep=year-startyear1
drop if  _merge_indep_years==2
drop  startday startmo startyear endday endmo endyear
drop _merge_indep_years
erase "working/Idependence dates for merge.dta"


/* This section makes a Socialist var, air distance, some area dummies  */
/* From Sachs and Warnder. */
save "working/dat1.dta" , replace
clear
use "data/distance, socialist (and others).dta", clear
move  year airdist
replace  country="Czechoslovakia" if country=="Czech Republic" & year<=1992
rename country countryname
run "data/Standardize Country Names.do"
drop  eu safri sasia transit latam eseasia wbcode newstate
save "working/Socialist var for merge.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/Socialist var for merge.dta", unique sort _merge(_merge_socialist_vars)
move _merge_socialist_vars population
drop if _merge_socialist_vars==2
drop _merge_socialist_vars
erase "working/Socialist var for merge.dta"


/* This section adds the PTS  */
save "working/dat1.dta" , replace
clear
use "data/PTS.dta", clear
rename  COW_num ccode1
gen country="aaamistake"
run "data/COW convert.do"
move  country COWcode
drop if country=="Russia" & year<=1991
replace  country="USSR" if  wbcode=="USSR"
drop if country=="USSR" & year>1991
replace country="West Bank and Gaza" if  wbcode=="WBG"
replace country="Czech Republic" if country=="Czechoslovakia" & year >1992
drop if country=="Slovakia" & year <1993
rename country countryname
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
move  countrycode_g COWcode
drop if  countrycode_g=="Country Code (Gleditsch)"
drop  countrynumcode_g microstateinyeart_g stateinyeart_g countrycode_g
drop  COWcode ccode1 wbcode PTScode
save "working/PTS data for merge.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/PTS data for merge.dta", unique sort _merge(_merge_pts_vars)
move _merge_pts_vars population
drop if _merge_pts_vars==2
drop _merge_pts_vars
erase "working/PTS data for merge.dta"

/*  Add World Bank Area Dummies */
run "data/Make world bank geographic regions.09.03.07.do"

/*  This adds an OECD variable, as defined by the World Bank, 2006 */
gen OECD=1 if countryname=="United States of America" | countryname=="Austria" | countryname=="Belgium" | countryname=="Canada" | countryname=="Denmark" | countryname=="France" | countryname=="German Federal Republic" | countryname=="Greece" | countryname=="Iceland" | countryname=="Ireland" | countryname=="Italy/Sardinia" | countryname=="Luxembourg" | countryname=="Netherlands" | countryname=="Norway" | countryname=="Portugal" | countryname=="Spain" | countryname=="Sweden" | countryname=="Switzerland" | countryname=="Turkey/Ottoman Empire" | countryname=="United Kingdom"
replace OECD=1 if countryname=="Japan" | countryname=="Finland" | countryname=="Australia" | countryname=="New Zealand"
/*Not sure about these ones--these are the new members?*/
replace OECD=1 if countryname=="Mexico" | countryname=="Czech Republic"  | countryname=="Hungary" | countryname=="Poland" | countryname=="Korea, Republic of" | countryname=="Slovakia"
replace OECD=0 if OECD!=1


/* Make egypt and israel dummies */
gen egypt=1 if countryname=="Egypt"
replace egypt=0 if egypt!=1
gen israel=1 if countryname=="Israel"
replace israel=0 if israel!=1

****This section adds other HR variables****
/* Note: these were not included in v.3 but I wanted to
   have the possibility of using factors as my HR scores.
   This would be similar to the USAID study (Finkel et al, 2006). */


/* This section adds Vanhanen's Polyarchy data */
/* Note: this is more important for the factors */
*** Note that Polyarchy only goes up through 2000***
save "working/dat1.dta" , replace
clear
use "data/file42535_polyarchy_v2", clear
rename  ssno countrynumcode_g
gen countryname="AAAmistake"
run "data/Make countrynames from numeric codes.do"
replace countryname="Kiribati" if  countrynumcode_g==946
replace countryname="Tonga" if  countrynumcode_g==955
replace countryname="Yemen (Arab Republic of Yemen)" if countrynumcode_g==679
replace countryname="German Federal Republic" if countryname=="Germany (Prussia)" & year>1989
replace countryname="Sao Tome and Principe" if countryname=="São Tomé and Principe"
move  countryname country
drop  country countrynumcode_g abbr
rename  comp  comp_polyarchy
rename  part part_polyarchy
rename  id id_polyarchy
save "working/Polyarchy vars for merge.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/Polyarchy vars for merge.dta", unique sort _merge(_merge_polyarchy_vars)
move _merge_polyarchy_vars population
drop if year<1948 /* Polyarchy goes way back */
drop if _merge_polyarchy_vars==2 /* This just drops microstates and not indep states */
drop _merge_polyarchy_vars
erase "working/Polyarchy vars for merge.dta"

/* I wanted to add the Minorities at Risk (MAR) measures used
   by Finkel et al (2006), but I couldn't find the right var. */

/* This is me creating the factors */
set more off

factor  disap kill polpris tort  PTSave_filled
rotate
predict physint_factor

factor  empinx parcomp FH_political comp_polyarchy  FH_civil
rotate
predict civil_factor

factor  wecon wopol wosoc
rotate
predict women_factor


/* This adds the data to replicate Neumayer */

/* Setting the time series */
drop countrynum
egen countrynum=group(countryname)
tsset countrynum year

****This part creates the smoothed aid vars to match his
gen share_hr=usd2_hr_bil/usd2_hr_world_aid_bil
replace share_hr=0 if share_hr==.
tssmooth ma sm3_share_hr=share_hr, window(0 0 3)

gen share_cv=usd2_cv_bil/usd2_cv_world_aid_bil
replace share_cv=0 if share_cv==.
tssmooth ma sm3_share_cv=share_cv, window(0 0 3)

/*gen share_wm=usd2_wm_bil/usd2_wm_world_aid_bil
replace share_wm=0 if share_wm==.
tssmooth ma sm3_share_wm=share_wm, window(0 0 3)
*/
gen share_social=usd2_social_bil/usd2_social_world_aid_bil
replace share_social=0 if share_social==.
tssmooth ma sm3_share_social=share_social, window(0 0 3)


gen share_econ=usd2_econ_bil/usd2_econ_world_aid_bil
replace share_econ=0 if share_econ==.
tssmooth ma sm3_share_econ=share_econ, window(0 0 3)

gen share_total=usd2_total_bil/usd2_world_aid_bil
replace share_total=0 if share_total==.
tssmooth ma sm3_share_total=share_total, window(0 0 3)

***This part logs the smoothed aid vars to match his
gen ln_sm3_share_hr=ln(sm3_share_hr+.0000000001)
gen ln_sm3_share_cv=ln(sm3_share_cv+.0000000001)
*gen ln_sm3_share_wm=ln(sm3_share_wm+.0000000001)
gen ln_sm3_share_social=ln(sm3_share_social+.0000000001)
gen ln_sm3_share_econ=ln(sm3_share_econ+.0000000001)
gen ln_sm3_share_total=ln(sm3_share_total+.0000000001)

***This part smooths my HR indicators
tssmooth ma sm3_physint=physint, window(0 1 2)
tssmooth ma sm3_empinx=empinx, window(0 1 2)
tssmooth ma sm3_wosum=wosum, window(0 1 2)
*tssmooth ma sm3_meanrat=meanrat, window(0 1 2)

save "working/dat1.dta" , replace
clear
use "data/Article for HRQ (aid).dta", clear
run "data/Make countrynames from Neumayers codes.do"
run "data/Standardize Country Names.do"
save "working/Neumayer for merge.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/Neumayer for merge.dta", unique sort _merge(_merge_neumayer_vars)
move _merge_neumayer_vars population
drop if _merge_neumayer_vars==2
/* This drops not yet independent countries that Neumayer used
   and I don't use.  */
drop _merge_neumayer_vars
erase "working/Neumayer for merge.dta"

/* Nov 6 2007, I decided to consolidate the colony vars
   using Pippa Norris' dataset */
save "working/dat1.dta" , replace
clear
use "data/Pippa Norris.Politics & Social Indicators.6.05.dta", clear
keep  nation intabrv  colony
gen year=2000
rename nation countryname
replace countryname="Panama" if countryname=="Panama Canal Zone"
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
save "working/Colony pippa for merge.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/Colony pippa for merge.dta", unique sort _merge(_merge_pippa_vars)
move _merge_pippa_vars population
drop if _merge_pippa_vars==2
drop _merge_pippa_vars
erase "working/Colony pippa for merge.dta"
egen colony1=mean(colony), by(countryname)
gen colonyDAC=0
replace colonyDAC=1 if colony1==1 | colony1==2 | colony1==3 | colony1==4 | colony1==5 | colony1==14


** Add in the New York times search on HR data
  ** The text files with the Lexis Nexis citations and the R file to compile
  ** the data are in the folder "NYT human rights searches"
save "working/dat1.dta" , replace
clear
insheet using "data\HR nytimes.csv"
rename hrcount nytimes
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
save "working/NYtimes.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/NYtimes.dta", unique sort _merge(_merge_nytimes)
move _merge_nytimes population
drop if _merge_nytimes==2
drop _merge_nytimes
erase "working/NYtimes.dta"

capture gen lnnytimes=ln(nytimes+1)
  ** the var of interest is called nytimes


*** July 1 2011, add the Machine codings for NYT articles
** Materials in ~\NYT data 2011
save "working/dat1.dta" , replace
clear
insheet using "data\NYT data 2011\randomForestHRcodes.csv", comma
split v4, parse(" OR ")
rename v41 countryname
replace countryname="Saudi Arabia" if countryname=="Saudi Arabi"
rename v2 year
rename v3 nytmachine
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
tab countrycode_g
keep year countryname nytmachine
save "working/NYTmachine.dta", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/NYTmachine.dta", unique sort _merge(_merge_nytimes)
drop if _merge_nytimes==2
drop _merge_nytimes
erase "working/NYTmachine.dta"

capture gen lnnytmachine=ln(nytmachine+1)



** UNHCR data
save "working/dat1.dta" , replace
clear

local dname Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United Kingdom" "United States"

foreach NAME of local dname {
   insheet using "data/UNCHR data.02.09.09/`NAME'.txt", tab

   foreach i of numlist 1/100 {
     capture replace v`i'=subinstr(v`i',",","",100)
   }

   replace v1=subinstr(v1,"Refugees Originating from -> ","",100)


   tempfile dat
   save "`dat'"

   keep in 2
   drop v1
   destring(v*), replace
   mkmat v*, matrix(years)

   use "`dat'", clear
   drop in 1
   drop in 1
   rename v1 source
   reshape long v, i(source) j(number)


   matrix years = years'
   svmat years, names(years)

   egen year = max(years),by(number)

   drop number years1

   rename v refugees
   destring(refugees), replace force

   gen host="`NAME'"
   save "working/`NAME'.dta", replace
   clear

}

use "working/Australia.dta", clear
local dname Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United Kingdom" "United States"
foreach NAME of local dname {
  append using "working/`NAME'.dta"
  erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

*cd "C:\Documents and Settings\Rich\Desktop\RHR 2009\"
** this makes it aggregated
egen reftotal = total(refugees), by(source year)
drop host refugees
rename source countryname
duplicates drop

run "data/Standardize Country Names.do"
** a fix for Czechoslovakia
replace countryname="Czechoslovakia" if countryname=="Czech Republic" & year <=1992
run "data/Standardize Country Names.do"

save "working/UNCHR data", replace
clear
use "working/dat1.dta", clear
merge countryname year using "working/UNCHR data.dta", unique sort _merge(_merge_unchr_vars)
move _merge_unchr_vars population
drop if _merge_unchr_vars==2
drop _merge_unchr_vars
erase "working/UNCHR data.dta"

gen lnreftotal=ln(reftotal+1)

  ** the var of interest is reftotal

** Ross' oil and gas data
save "working/dat1.dta" , replace
clear

use "data/Ross Oil & Gas 1932-2006 public.dta", clear
rename cty_name countryname
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
drop if stateinyeart_g!=1
keep countryname year oil_gas_rentTOTAL
rename oil_gas_rentTOTAL rossoil
replace rossoil=rossoil/1000000000
save "working/ross merge.dta", replace

use "working/dat1.dta", clear
merge countryname year using "working/ross merge.dta", unique sort _merge(_mergeRoss)
drop if _mergeRoss==2
drop _mergeRoss
erase "working/ross merge.dta"



** add in the Ron amnesty criticism data
save "working/dat1.dta" , replace
clear

use "data/RONrrhrd8_isq.dta", clear
drop if country==141 & year<1992
drop if country==201 & year>1991
gen countryname_g = ""
rename iso countrycode_g
run "data/convert iso codes.do"
rename countryname_g countryname
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
drop if countryname==""
keep countryname year avmdia ainr aibr
save "working/ron.dta", replace

use "working/dat1.dta", clear
merge countryname year using "working/ron.dta", unique sort _merge(_mergeRon)
drop if _mergeRon==2
drop _mergeRon
erase "working/ron.dta"


** Alliances by alliance type
/* Put in alliance data from ATOP by Ashley Leeds */
** The COW alliance data below only goes up to 2000
** I'm dropping it to use Ashley Leeds ATOP data
local A defense offense neutral nonagg consul
foreach a of local A {
  di "`a'"
  save "working/dat1.dta" , replace
  use "data/atop3_0dy.dta", clear
  keep  year `a' mem1 mem2
  rename mem1 ccode1
  rename mem2 ccode2
  gen country=""
  gen partner=""
  run "data/Cow convert.do"
  drop ccode*

   ** the dyads are directed so I recombine them as undirected
  save "working/allies1.dta", replace

  rename country country1
  rename partner country
  rename country1 partner
  append using "working/allies1.dta"

  replace partner="United States" if partner=="United States of America"
  replace partner="Germany" if partner=="German Federal Republic"
  gen DAC=1 if partner=="United States" | partner=="Austria" | partner=="Belgium" | partner=="Canada" | partner=="Denmark" | partner=="France" | partner=="Germany" |  partner=="Ireland" | partner=="Italy" | partner=="Luxembourg" | partner=="Netherlands" | partner=="Norway" | partner=="Portugal" | partner=="Spain" | partner=="Sweden" | partner=="Switzerland" | partner=="United Kingdom"
  replace DAC=1 if partner=="Japan" | partner=="Finland" | partner=="Australia" | partner=="New Zealand" 

  drop if DAC!=1
  rename country countryname
  egen alliance_`a'_DAC=sum(`a') if DAC==1, by(countryname year)
  drop  `a' partner DAC
  duplicates drop
  drop if countryname=="German Federal Republic" & year==1990
  run "data/Standardize Country Names.do"
  drop if year<1948
    save "working/Alliance data for merge.dta", replace
  use "working/dat1.dta", clear
  merge countryname year using "working/Alliance data for merge.dta", unique sort _merge(_merge_alliance_vars)
  move _merge_alliance_vars population
  drop if _merge_alliance_vars==2  /* this is dropping New Zealand 1950-67 when it was independent,--odd, but not in my time-frame */
  drop _merge_alliance_vars
  erase "working/Alliance data for merge.dta"
  /*  This fills in the countries that had no alliances and thus weren't counted correctly */
  replace alliance_`a'_DAC=0 if alliance_`a'_DAC==. & year<2004
}
erase "working/allies1.dta"


** Add Dannehl soviet aid data
save "working/dat1.dta" , replace
clear

use "data/master_foreign_aid_data_file.dta", clear
gen country = ""
rename code ccode1
run "data/COW convert.do"
drop if country==""
rename country countryname
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
rename y1 sovietaidbach
rename y2 sovietaidcia
rename y3 prcaidbartke
rename y4 prcaidcia

keep countryname year soviet* prc*
save "working/tmp.dta", replace

use "working/dat1.dta", clear
merge countryname year using "working/tmp.dta", unique sort _merge(_merge1)
drop if _merge1==2
drop _merge1
erase "working/tmp.dta"
save "working/dat1.dta" , replace
clear

** Disbursement data from PLAID
** Prep done on the RCE in stata 11 because of large file size

** Comment this all out and just use the file below
/*
clear
set more off
set mem 2000M
cd "/nfs/home/R/rnielsen/shared_space/rewards/"
insheet using "PLAID19_CRS_DISB.csv"

 ** Put the amount in millions
gen disbursemil2000 =  disbursement_amount_usd_constant/1000000

** rename some vars
rename donor donorname
rename recipient recipientname
rename crs_purpose_code purposecode

** drop extra vars
keep  year donorname recipientname disbursemil purposecode
replace donorname=trim(donorname)
replace donorname = proper(donorname)
replace recipientname=trim( recipientname)

** generate the categories for each project
gen hr=1 if purposecode==15162
replace hr=0 if hr!=1

gen cv=1 if purposecode==15130 | purposecode==15150 | purposecode==15161 | purposecode==15163
replace cv=0 if cv!=1

** this makes cv and hr mutually exclusive--if a project is in both it goes to cv
replace hr=0 if cv==1 

gen el=1 if purposecode==15161
replace el=0 if el!=1

** Defines Social aid
gen social=1 if purposecode >=11000 & purposecode<17000 & hr==0 & cv==0 
replace social=1 if purposecode >=70000 & purposecode<80000 & hr==0 & cv==0 
** Includes NGOs
replace social=1 if purposecode >=92000 & purposecode<93000 & hr==0 & cv==0 
** Includes Food Aid
replace social=1 if purposecode ==52010 & hr==0 & cv==0 
replace social=0 if social!=1

** Defines Economic aid as the residual category
gen econ=1 if social==0 & hr==0 & cv==0
replace econ=0 if econ!=1

** Makes a marker for calculating all aid
gen total=1

**  Make the OECD data bilateral

** Note that I left out Portugal Spain because of inadequate aid reporting
local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United States" "United Kingdom" 
capture gen donty=""
foreach dname of local dnames {
  di "`dname'"
  replace donty="B" if donorname=="`dname'"
}

drop if donty!="B"
   
** In case of leading spaces in the names
replace  recipientname=rtrim( recipientname)
rename recipientname countryname 
run "data/Standardize Country Names.do"

   
** Calculate aid amounts by category for each recipient-year

local aidcats hr cv el social econ total
foreach cat of local aidcats {
egen us2_`cat'=sum(disbursemil2000) if `cat'==1, by(countryname year)
  gen us2_`cat'_bil=us2_`cat'/1000
  replace  us2_`cat'_bil=0 if us2_`cat'_bil==.
  egen disb_`cat'_mil=max(us2_`cat'_bil), by(countryname year)
  drop us2*
}

** Calculate "world aid" for each category
local aidcats hr cv el social econ total
foreach cat of local aidcats {
  egen us2_`cat'=sum(disbursemil2000) if `cat'==1, by(year)
  gen us2_`cat'_bil=us2_`cat'/1000
  replace  us2_`cat'_bil=0 if us2_`cat'_bil==.
  egen disb_`cat'_world_aid_mil=max(us2_`cat'_bil), by(year)
  drop us2*
}

rename disb_total_world_aid_mil disb_world_aid_mil


** Calculate dyadic aid amounts by category for each recipient-year

local aidcats hr cv el social econ total
local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United States" "United Kingdom" 
   
foreach dname of local dnames {
  foreach cat of local aidcats {
    egen us2_`cat'=sum(disbursemil2000) if `cat'==1 & donorname=="`dname'", by(countryname year)
    gen us2_`cat'_bil=us2_`cat'/1000
    replace  us2_`cat'_bil=0 if us2_`cat'_bil==.
    local holder "`dname'"
    if "`holder'" == "New Zealand" {
      local holder "NewZealand"
    }
    if "`holder'" == "United States" {
      local holder "US"
    }
    if "`holder'" == "United Kingdom" {
      local holder "UK"
    }
    di "Working on `holder' - `cat'"
    egen `holder'_`cat'_disb=max(us2_`cat'_bil), by(countryname year)
    drop us2*
  }
}


** Generate world-aid totals for each donor
local aidcats hr cv el social econ total
local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United States" "United Kingdom" 
   
foreach dname of local dnames {
  foreach cat of local aidcats {
    egen us2_`cat'=sum(disbursemil2000) if `cat'==1 & donorname=="`dname'", by(year)
    gen us2_`cat'_bil=us2_`cat'/1000
    replace  us2_`cat'_bil=0 if us2_`cat'_bil==.
    local holder "`dname'"
    if "`holder'" == "New Zealand" {
      local holder "NewZea"
    }
    if "`holder'" == "United States" {
      local holder "US"
    }
    if "`holder'" == "United Kingdom" {
      local holder "UK"
    }
    if "`holder'" == "Netherlands" {
      local holder "Neth"
    }
    if "`holder'" == "Switzerland" {
      local holder "Switz"
    }
    di "Working on `holder' - `cat'"
    egen `holder'_`cat'_wldaid_disb=max(us2_`cat'_bil), by(year)
    drop us2*
  }
}

** This loop changes "US_total_wldaid_bil" to "US_wldaid_bil" to match my old dataset
local dnamestofix Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Neth NewZea Norway Sweden Switz US UK 
foreach dname of local dnamestofix{
  rename `dname'_total_wldaid_disb `dname'_wldaid_disb
}

** drop the extraneous variables and the extra observations
keep  year countryname stateinyeart_g microstateinyeart_g disb_*  Australia* Austria* Belgium*  Canada* Denmark* Finland* France* Germany* Italy* Japan* Neth* NewZea* Norway* Sweden* Switz* US* UK*

duplicates drop

** After the dataset is all together
**  Make all the names the same

run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"

** sorts the observations
sort countryname year

saveold "disbursements 73-08.dta", replace
*/
** END commenting out of disbursement data creation

/*	Instead of doing the above, just use:  */

use "working/dat1.dta", clear
merge countryname year using "data/disbursements 73-08.dta", unique sort _merge(_merge1)
drop if _merge1==2
drop  _merge1

/*	This replaces missing values in the aid data with zeros
	explicitly assuming that if nothing is listed in 
	the OECD database, then no aid was given.  */

** Fills in for the main aggregated aid vars
local aidcats hr cv el social econ total
   
foreach cat of local aidcats {
replace  disb_`cat'_mil=0 if  disb_`cat'_mil==. & year>1972 & year<2007
}
 

** main vars for each donor
local aidcats hr cv el social econ total
local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands NewZealand Norway Sweden Switzerland US UK
   
foreach dname of local dnames {
  foreach cat of local aidcats {
    replace  `dname'_`cat'_disb=0 if  `dname'_`cat'_disb==. & year>1972 & year<2007
  }
}

** World aid vars
local aidcats2 hr cv el social econ
  
foreach cat of local aidcats2 {
  replace  disb_`cat'_world_aid_mil=0 if disb_`cat'_world_aid_mil==. & year>1972 & year<2007
}
** World aid vars by donor

local aidcats2 hr cv el social econ
local dnames2 Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Neth NewZea Norway Sweden Switz US UK
   
foreach dname of local dnames2 {
  replace  `dname'_wldaid_disb=0 if  `dname'_wldaid_disb==. & year>1972 & year<2007
  foreach cat of local aidcats2 {
    replace  `dname'_`cat'_wldaid_disb=0 if  `dname'_`cat'_wldaid_disb==. & year>1972 & year<2007
  }
}

** single var that doesn't need a loop
replace  disb_total_mil=0 if  disb_total_mil==. & year>1972 & year<2007
 
** single var that doesn't need a loop  
replace  disb_world_aid_mil=0 if  disb_world_aid_mil==. & year>1972 & year<2007

** combine the hr and cv cats
capture gen disb_hrcv_mil = disb_hr_mil + disb_cv_mil




** making a post 2001 dummy
gen post2001 = year>2001


/* Setting the time series */
capture drop countrynum
egen countrynum=group(countryname)
tsset countrynum year

********************************************
** changes right before running the models


gen war = priowar

gen coldwarsoc = ColdWar*socialist

** making a "treatment"
gen physabuse=1 if l.physint<=3
replace physabuse=0 if l.physint>3 & l.physint!=.


	** make aid pc vars
gen aidpc=(usd2_total_mil*1000000)/population
gen hraidpc=(usd2_hr_mil*1000000)/population
gen cvaidpc=(usd2_cv_mil*1000000)/population
gen econaidpc=(usd2_econ_mil*1000000)/population
gen socaidpc=(usd2_social_mil*1000000)/population
gen hrcvaidpc=(usd2_hrcv_mil*1000000)/population

  ** disbursements
gen disbpc=(disb_total_mil*1000000)/population
gen hrdisbpc=(disb_hr_mil*1000000)/population
gen cvdisbpc=(disb_cv_mil*1000000)/population
gen econdisbpc=(disb_econ_mil*1000000)/population
gen socdisbpc=(disb_social_mil*1000000)/population
gen hrcvdisbpc=(disb_hrcv_mil*1000000)/population




	** ln aid pc
gen lnaidpc=ln(aidpc+1)
gen lnhraidpc=ln(hraidpc+1)
gen lncvaidpc=ln(cvaidpc+1)
gen lneconaidpc=ln(econaidpc+1)
gen lnsocaidpc=ln(socaidpc+1)
gen lnhrcvaidpc = ln(hrcvaidpc+1)

  ** ln disbursements
gen lndisbpc=ln(disbpc+1)
gen lnhrdisbpc=ln(hrdisbpc+1)
gen lncvdisbpc=ln(cvdisbpc+1)
gen lnecondisbpc=ln(econdisbpc+1)
gen lnsocdisbpc=ln(socdisbpc+1)
gen lnhrcvdisbpc = ln(hrcvdisbpc+1)

	** gen ln of aid levels vars
gen lnaid=ln((usd2_total_mil*1000000)+1)
gen lneconaid=ln((usd2_econ_mil*1000000)+1)
gen lnsocaid=ln((usd2_social_mil*1000000)+1)
gen lnhraid=ln((usd2_hr_mil*1000000)+1)
gen lncvaid=ln((usd2_cv_mil*1000000)+1)

	** make primary and secondary aid
gen primaidpc=(usd2_total_mil_primary*1000000)/population
gen primhraidpc=(usd2_hr_mil_primary*1000000)/population
gen primcvaidpc=(usd2_cv_mil_primary*1000000)/population
gen primeconaidpc=(usd2_econ_mil_primary*1000000)/population
gen primsocaidpc=(usd2_social_mil_primary*1000000)/population

gen secaidpc=(usd2_total_mil_second*1000000)/population
gen sechraidpc=(usd2_hr_mil_second*1000000)/population
gen seccvaidpc=(usd2_cv_mil_second*1000000)/population
gen sececonaidpc=(usd2_econ_mil_second*1000000)/population
gen secsocaidpc=(usd2_social_mil_second*1000000)/population

gen lnprimaidpc=ln(primaidpc+1)
gen lnprimhraidpc=ln(primhraidpc+1)
gen lnprimcvaidpc=ln(primcvaidpc+1)
gen lnprimeconaidpc=ln(primeconaidpc+1)
gen lnprimsocaidpc=ln(primsocaidpc+1)

gen lnsecaidpc=ln(secaidpc+1)
gen lnsechraidpc=ln(sechraidpc+1)
gen lnseccvaidpc=ln(seccvaidpc+1)
gen lnsececonaidpc=ln(sececonaidpc+1)
gen lnsecsocaidpc=ln(secsocaidpc+1)

* a couple more squared terms for the GAMs
gen tradesq=(ln_trade_DAC)^2
gen forcesq=(forces_DAC)^2


** flip physint
recode physint (0=8) (1=7) (2=6) (3=5) (5=3) (6=2) (7=1) (8=0), gen(physint2)
drop physint
rename physint2 physint


	** making lagged variables
gen lphysint=l.physint
gen lphysfactor=l.physint_factor
gen lempinx=l.empinx
gen lpolity2 = l.polity2
gen lln_rgdpc=l.ln_rgdpc
gen lln_population=l.ln_population
gen lln_trade_DAC=l.ln_trade_DAC
gen lalliance_DAC=l.alliance_DAC
gen lwar=l.war
gen lln_rgdpc_sq=l.ln_rgdpc_sq
gen lempinx_sq=l.empinx_sq
gen lln_population_sq=l.ln_population_sq
gen ltradesq=l.tradesq
gen lforcesq=l.forcesq

gen llnaidpc=l.lnaidpc
gen llnhraidpc=l.lnhraidpc
gen llncvaidpc=l.lncvaidpc
gen llnhrcvaidpc=l.lnhrcvaidpc
gen llneconaidpc=l.lneconaidpc
gen llnsocaidpc=l.lnsocaidpc

gen lnworldaidtotal=ln((usd2_world_aid_mil*1000000)+1)
gen lnworldaidhr=ln((usd2_hr_world_aid_mil*1000000)+1)
gen lnworldaidcv=ln((usd2_cv_world_aid_mil*1000000)+1)
gen lnworldaidecon=ln((usd2_econ_world_aid_mil*1000000)+1)
gen lnworldaidsoc=ln((usd2_social_world_aid_mil*1000000)+1)
gen lnworldaidhrcv = ln((usd2_hr_world_aid_mil*1000000 + usd2_cv_world_aid_mil*1000000)+1)

gen lnworlddisbtotal=ln((disb_world_aid_mil*1000000)+1)
gen lnworlddisbhr=ln((disb_hr_world_aid_mil*1000000)+1)
gen lnworlddisbcv=ln((disb_cv_world_aid_mil*1000000)+1)
gen lnworlddisbecon=ln((disb_econ_world_aid_mil*1000000)+1)
gen lnworlddisbsoc=ln((disb_social_world_aid_mil*1000000)+1)
gen lnworlddisbhrcv = ln((disb_hr_world_aid_mil*1000000 + disb_cv_world_aid_mil*1000000)+1)


gen inmysample=1 if lnaidpc!=1 & l.physint!=. &  l.empinx!=. & l.lnaidpc!=. &  lnworldaidtotal!=. &  l.ln_rgdpc!=. &   l.ln_population!=. &   l.ln_trade_DAC!=. & l.alliance_DAC!=. & forces_DAC!=. & colonyDAC!=. & socialist!=. &  ColdWar!=. & l.war!=. &  region_SSA!=. & region_Latin!=. & region_MENA!=. & region_EAsiaPac!=. & egypt!=. & israel!=. &  OECD!=1 



  ** make dummies for the gate-keeping models
gen hrcvaidrecip=1 if usd2_hrcv_bil>0
replace hrcvaidrecip=0 if usd2_hrcv_bil==0
replace hrcvaidrecip=. if usd2_hrcv_bil==.
gen econaidrecip=1 if usd2_econ_bil>0
replace econaidrecip=0 if usd2_econ_bil==0
replace econaidrecip=. if usd2_econ_bil==.
gen socaidrecip=1 if usd2_social_bil>0
replace socaidrecip=0 if usd2_social_bil==0
replace socaidrecip=. if usd2_social_bil==.
gen totalaidrecip=1 if usd2_total_bil>0
replace totalaidrecip=0 if usd2_total_bil==0
replace totalaidrecip=. if usd2_total_bil==.


compress

save "working/dat1.dta" , replace

****End of do-file****
beep
****End of do-file****





