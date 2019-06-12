use "C:\nesreplication.dta", clear

*Panel A Party ID Means*
mean pid if year==1964
mean pid if year==1972
mean pid if year==1982
mean pid if year==1996

*Panel A Ideology Means*
mean ideo if year==1972
mean ideo if year==1982
mean ideo if year==1996

*Panel A Minority Assistance Means*
mean min if year==1972
mean min if year==1982
mean min if year==1996

*Panel A Women's Equality Means*
mean fem if year==1972
mean fem if year==1982
mean fem if year==1996

*Panel B Party ID Means*
mean pid if year==1964 & age>=21 & age<=29
mean pid if year==1972 & age>=21 & age<=29
mean pid if year==1982 & age>=33 & age<=41
mean pid if year==1996 & age>=45 & age<=53

*Panel B Ideology Means*
mean ideo if year==1972 & age>=21 & age<=29
mean ideo if year==1982 & age>=33 & age<=41
mean ideo if year==1996 & age>=45 & age<=53

*Panel B Minority Assistance Means*
mean min if year==1972 & age>=21 & age<=29
mean min if year==1982 & age>=33 & age<=41
mean min if year==1996 & age>=45 & age<=53

*Panel B Women's Equality Means*
mean fem if year==1972 & age>=21 & age<=29
mean fem if year==1982 & age>=33 & age<=41
mean fem if year==1996 & age>=45 & age<=53

*Panel C Party ID Means*
mean pid if year==1964 & age>=21 & age<=29
mean pid if year==1972 & age>=21 & age<=29
mean pid if year==1982 & age>=21 & age<=29
mean pid if year==1996 & age>=21 & age<=29

*Panel C Ideology Means*
mean ideo if year==1972 & age>=21 & age<=29
mean ideo if year==1982 & age>=21 & age<=29
mean ideo if year==1996 & age>=21 & age<=29

*Panel C Minority Assistance Means*
mean min if year==1972 & age>=21 & age<=29
mean min if year==1982 & age>=21 & age<=29
mean min if year==1996 & age>=21 & age<=29

*Panel C Women's Equality Means*
mean fem if year==1972 & age>=21 & age<=29
mean fem if year==1982 & age>=21 & age<=29
mean fem if year==1996 & age>=21 & age<=29

