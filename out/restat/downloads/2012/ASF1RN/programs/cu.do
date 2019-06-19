set more off

**** CU/income                                                    *******
*************************************************************************
********daysfromfirst is the start date of a 7 day data in relation******
********to the first of the month                                  ******
*************************************************************************

destring WEEKI STRTDAY STRTMNTH STRTYEAR PICK_UP REGION BLS_URBN POPSIZE SMSASTAT STATE CUTENURE CHILDAGE FAM_TYPE EARNCOMP INCLASS RESPSTAT POVERTY REF_RACE SEX_REF MARITAL1 ORIGIN1 ORIGIN1_ EDUC_REF RACE2 SEX2 ORIGIN2 EDUCA2 OCCULIS1 EMPLTYP1 WHYNWRK1 OCCULIS2 EMPLTYP2 WHYNWRK2 REC_FS DESCRIP TYPOWND, replace

******************************************************************
** The 6th digit of NEWID is the 1 or 2 to signify the week ******
** Let's create a new ID which is the same for the same CU  ******
******************************************************************

     gen ID= NEWID - WEEKI
     gen startdate= mdy(STRTMNTH, STRTDAY, STRTYEAR)
gen strtdayfromfirst= STRTDAY if STRTDAY<=14 & STRTDAY>=1
    replace strtdayfromfirst=mdy(STRTMNTH, STRTDAY, STRTYEAR) - mdy(STRTMNTH+1, 1, STRTYEAR) if mdy(STRTMNTH, STRTDAY, STRTYEAR) - mdy(STRTMNTH+1, 1, STRTYEAR)<=-1 & mdy(STRTMNTH, STRTDAY, STRTYEAR) - mdy(STRTMNTH+1, 1, STRTYEAR)>=-14
    replace strtdayfromfirst=mdy(STRTMNTH, STRTDAY, STRTYEAR) - mdy(STRTMNTH+1, 1, STRTYEAR+1) if mdy(STRTMNTH, STRTDAY, STRTYEAR) - mdy(1, 1, STRTYEAR+1)>=-14 & STRTMNTH==12 & STRTDAY>=18

**************************************************************************
***  Lets create a unique day for each of the 7 days of the diary week ***
***   This makes 7 days for each observation                           ***
**************************************************************************

  expandcl 7, generate(uniqueday) cluster(NEWID)
     replace uniqueday=uniqueday-7*int(uniqueday/7)
     replace uniqueday=7 if uniqueday==0

  gen uniquedaylong= startdate + uniqueday -1

*************************************************************************
***  uniquedaylong is the date in relation to jan1 1960.   **************
***  lets put each of these days in terms relative to      **************
***  the first of the month within a +/- 7 day window      **************
*************************************************************************

  gen uniquedayfromfirst= strtdayfromfirst+uniqueday-1 if strtdayfromfirst+uniqueday-1<=-1 & strtdayfromfirst+uniqueday-1>=-14
    replace uniquedayfromfirst=strtdayfromfirst+uniqueday if strtdayfromfirst+uniqueday-1>=0 & strtdayfromfirst<=-1
    replace uniquedayfromfirst=strtdayfromfirst+uniqueday-1 if strtdayfromfirst>=0 & strtdayfromfirst+uniqueday-1<=14
  gen purchasedayfromfirst=uniquedayfromfirst
  sort ID purchasedayfromfirst
*********************************************************************************
*********************************************************************************
**           Synopsis of Variables                                           ****
**  ID : Same number for each person through week one and two                ****
**  uniqueday: Day 1 through 7. Day one is the first day of obs              ****
**  uniquedaylong: The uniqueday in terms of date from jan1 1960             ****
**  uniquedayfromfirst:  [-14,...-1,1,2,3,...14] that the uniqueday lands on ****
**                                                                           ****          
**       This way, uniquedayfromfirst is person specific                     ****                                                                         ****             
**       Next, lets adjoin this CU information with the Expenditures
*********************************************************************************

*This adjoined information will be kept in DS0001 and is labeled "2000Q1joined"
*any alterations to that file will have the title followed by "altered".