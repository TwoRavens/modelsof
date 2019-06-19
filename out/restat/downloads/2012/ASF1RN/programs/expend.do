*****   Non Aggregated Expenditure Data       ***********************
*****************************************************************************************
***In this file we need to take the date string given to us for the recorded purchase****
***And turn it into our absolute date from jan1 1960                                 ****
***     ID is the person specific ID...NEWID not including the weekdigit         ********
set more off
gen ID= (int(NEWID/10))*10

destring QREDATE, generate(QREDATE_Decimal)
     gen journalday=int(QREDATE_Decimal/1000000000)
     gen weekday=int((QREDATE_Decimal-journalday*1000000000)/100000000)
     gen month=int((QREDATE_Decimal- journalday*1000000000-weekday*100000000)/1000000)
     gen day=int((QREDATE_Decimal-journalday*1000000000-weekday*100000000-month*1000000)/10000)
     gen year=QREDATE_Decimal-journalday*1000000000-weekday*100000000-month*1000000-day*10000
     gen purchasedate=mdy(month,day,year)

*****************************************************************************************
***  Now lets take this absolute date and restate it relative to the first            ***
*****************************************************************************************             

gen purchasedayfromfirst= day if day<=14
    replace purchasedayfromfirst=mdy(month, day, year) - mdy(month+1, 1, year) if mdy(month, day, year) - mdy(month+1, 1, year)<=-1 & mdy(month, day, year) - mdy(month+1, 1, year)>=-14
    replace purchasedayfromfirst=mdy(month, day, year) - mdy(month+1, 1, year+1) if mdy(month, day, year) - mdy(1, 1, year+1)>=-14 & month==12 & day>=18

sort ID purchasedayfromfirst








