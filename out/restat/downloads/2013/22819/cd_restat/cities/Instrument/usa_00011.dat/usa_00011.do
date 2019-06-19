/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */
clear
set mem 1500m
cd "C:\Users\HW462587\Documents\Leah\Data\Instrument\usa_00011.dat"
set more off

clear
/*
infix ///
 int     year                                 1-4 ///
 byte    datanum                              5-6 ///
 double  serial                               7-14 ///
 int     hhwt                                15-18 ///
 byte    region                              19-20 ///
 byte    stateicp                            21-22 ///
 byte    statefip                            23-24 ///
 byte    urban                               25 ///
 byte    metro                               26 ///
 int     metaread                            27-30 ///
 int     city                                31-34 ///
 byte    gq                                  35 ///
 int     perwt                               36-39 ///
 int     relate                              40-41 ///
 int     related                             42-45 ///
 int     race                                46 ///
 int     raced                               47-49 ///
 long    ftotinc                             50-56 ///
 using usa_00011.dat*/


infix ///
 int     year                                 1-4 ///
 int     relate                              40-41 ///
 long    ftotinc                             50-56 ///
 using usa_00011.dat if relate==1


label var year `"Census year"'
label var relate `"Relationship to household head [general version]"'
label var ftotinc `"Total family income"'

compress
save microdata_instr, replace
