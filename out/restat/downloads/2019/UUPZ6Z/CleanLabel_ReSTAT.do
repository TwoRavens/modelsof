
*******************************************
/* Each year the labeling on the facilities varies somewhat.  
Some years the judicial circuit or the management company is listed,
some years it is not.  Sometimes they specify the security level
and sometimes not.  This section cleans up the discrepancies in 
naming.  The top section, which builds the string variable "labelclean"
which is called "labelfac91" when in factor form, is for the purpose
of building the peer variables, thus peer overlap is the main concern 
here.  The bottom section, which generates the string variable "labelclean1"
which is called "labelfac912" in factor form, is for the purpose of 
generating fixed effects.  While a change of management does not matter
for the purpose of determining peer overlap, it is more important when 
adding fixed effects to compensate for potential changes in facility 
composition or characteristics.
*/

*******************************************
*** put together labels for use in determining peer overlap
gen labelclean=label
forval x=0/2{
forval y=0/9{
replace labelclean=subinstr(labelclean,"`x'`y' Circuit-","",1)
}
}

replace labelclean=subinstr(labelclean,"Eckerd-","",1)
replace labelclean=subinstr(labelclean,"CDFL-","",1)
replace labelclean=subinstr(labelclean,"G4S-","",1)
replace labelclean=subinstr(labelclean,"GYS-","",1)
replace labelclean=subinstr(labelclean,"KEYS-","",1)
replace labelclean=subinstr(labelclean,"YSI-","",1)
replace labelclean=subinstr(labelclean,"Premier Behavioral Solutions-","",1)
replace labelclean=subinstr(labelclean,"Sequel TSI-","",1)
replace labelclean=subinstr(labelclean,"State Operated-","",1)
replace labelclean=subinstr(labelclean,"White Foundation-","",1)
replace labelclean=subinstr(labelclean,"Twin Oaks-","",1)
replace labelclean=subinstr(labelclean,"Three Springs-","",1)
replace labelclean=subinstr(labelclean,"Stewart Marchman Center-","",1)
replace labelclean=subinstr(labelclean," - G4S Youth Services","",1)
replace labelclean=subinstr(labelclean," - Sunshine Youth Services","",1)
replace labelclean=subinstr(labelclean," - Three Springs","",1)
replace labelclean=subinstr(labelclean,"NAFI-","",1)
replace labelclean=subinstr(labelclean,"Gulf Coast-","",1)
replace labelclean=subinstr(labelclean," - Gulf Coast","",1)
replace labelclean=subinstr(labelclean,"JRF","Juvenile Residential Facility",1)
replace labelclean=subinstr(labelclean,"JCF","Juvenile Correctional Facility",1)
replace labelclean=subinstr(labelclean,"AMIkids-","",1)
replace labelclean=subinstr(labelclean,"SOP","Sex Offender Program",1)
replace labelclean=subinstr(labelclean,"Stop","Short Term Offender",1)
replace labelclean=subinstr(labelclean,"YDC","Youth Development Center",1)
replace labelclean=subinstr(labelclean,"Youth Environmental Services","Youth Environmental Services (YES)",1)
replace labelclean=subinstr(labelclean,"SHOP","Serious Habitual Offender Program",1)
replace labelclean=subinstr(labelclean,", LLC.","",1)
replace labelclean=subinstr(labelclean,", Inc.","",1)
replace labelclean=subinstr(labelclean,"Dual Diagnosis","Dual Diagnosis Correctional Facility",1)
replace labelclean=subinstr(labelclean,"-Female","",1) if sex=="F"
replace labelclean=subinstr(labelclean," - Sequel TSI of Florida","",1)
replace labelclean=subinstr(labelclean," - Youth Services International","",1)
replace labelclean=subinstr(labelclean,"JOCC","Juvenile Offender Correctional Center",1)


replace labelclean="Vision Quest - Moderate" if labelclean=="Vision Quest Moderate Risk"
replace labelclean="Panther Success Center" if labelclean=="Panther Success Center - White Foundation"
replace labelclean="Alachua Academy-Female" if labelclean=="Alachua Academy"
replace labelclean="Bay Point Schools-North" if labelclean=="Bay Point Schools - North"
replace labelclean="Bay Point Schools-West Kennedy" if labelclean=="Bay Point Schools-West-Kennedy"
replace labelclean="Big Cypress Wilderness Institute" if labelclean=="Big Cypress"
replace labelclean="Blackwater Short Term Offender" if labelclean=="Blackwater Short Term Offender - Low"
replace labelclean="Blackwater Short Term Offender" if labelclean=="Blackwater Short Term Offender - Moderate"
replace labelclean="Blackwater Short Term Offender" if labelclean=="Blackwater Short Term Offender - Low/Santa Rosa Youth Academy - Low"
replace labelclean="Blackwater Short Term Offender" if labelclean=="Santa Rosa Youth Academy"
replace labelclean="Bowling Green Juvenile Residential Facility" if labelclean=="Bowling Green Youth Academy - Juvenile Residential Facility"
replace labelclean="Bowling Green New Beginnings" if labelclean=="Bowling Green Youth Academy - New Beginnings"
replace labelclean="Bristol Academy Specialized Unit" if labelclean=="Bristol Academy - Specialized Unit"
replace labelclean="Bristol Youth Academy" if labelclean=="Bristol Youth Academy Substance Abuse"
replace labelclean="Broward Academy-Female" if labelclean=="Broward Girls Academy"
replace labelclean="Broward Academy-Female" if labelclean=="Broward Academy"
replace labelclean="Camp E Ma Chamee - Substance Abuse" if labelclean=="Camp E-Ma-Chamee - Substance Abuse"
replace labelclean="Camp E Ma Chamee - Substance Abuse" if labelclean=="Camp E Ma Chamee Substance Abuse"
replace labelclean="Camp E Ma Chamee" if labelclean=="Camp E-Ma-Chamee"
replace labelclean="Camp E-Nini-Hassee" if labelclean=="Camp E-Nini-Hassee - Substance Abuse"
replace labelclean="Camp E-Nini-Hassee" if labelclean=="Camp E Nini Hassee"
replace labelclean="Crossroads Wilderness Institute" if labelclean=="Crossroads"
replace labelclean="Cypress Creek Juvenile Offender Correctional Center - High" if labelclean=="Cypress Creek Juvenile Offender Correctional Center" & type==32
replace labelclean="Cypress Creek Juvenile Offender Correctional Center - Maximum" if labelclean=="Cypress Creek Juvenile Offender Correctional Center" & type==33
replace labelclean="Cypress Creek Juvenile Offender Correctional Center - High" if labelclean=="Cypress Creek JOCC" & type==32
replace labelclean="Cypress Creek Juvenile Offender Correctional Center - Maximum" if labelclean=="Cypress Creek JOCC" & type==33
replace labelclean="Cypress Creek Juvenile Offender Correctional Center - Maximum" if labelclean=="Cypress Creek Juvenile Offender Correctional Center -Maximum"
replace labelclean="Daytona Sex Offender Program" if labelclean=="Daytona Sex Offender Program - Moderate"
replace labelclean="Daytona Sex Offender Program" if labelclean=="Daytona Sex Offender Program - High"
replace labelclean="DeSoto Dual Diagnosis Correctional Facility Correctional Facility - Female" if labelclean=="DeSoto Dual Diagnosis Correctional Facility" & sex=="F"

replace labelclean="DeSoto Dual Diagnosis Correctional Facility Correctional Facility - Female" if labelclean=="DeSoto Dual Diagnosis Correctional Facility Correctional Facility - Female - High"
replace labelclean="DeSoto Dual Diagnosis Correctional Facility Correctional Facility - Female" if labelclean=="DeSoto Dual Diagnosis Correctional Facility Correctional Facility - Female - Moderate"
replace labelclean="DeSoto Dual Diagnosis Correctional Facility - Female" if labelclean=="DeSoto Dual Diagnosis Correctional Facility Correctional Facility - Female"
replace labelclean="DeSoto Dual Diagnosis Correctional Facility - Male" if labelclean=="DeSoto Dual Diagnosis Correctional Facility Correctional Facility - Male"
replace labelclean="DeSoto Dual Diagnosis Correctional Facility - Male" if labelclean=="DeSoto Dual Diagnosis Correctional Facility-Male"
replace labelclean="DeSoto Juvenile Correctional Facility - Mental Health" if labelclean=="DeSoto Juvenile Correctional Facility Mental Health"
replace labelclean="DeSoto Juvenile Residential Facility - Female" if labelclean=="DeSoto Juvenile Residential Facility" & sex=="F"
replace labelclean="DeSoto Juvenile Residential Facility - Male" if labelclean=="DeSoto Juvenile Residential Facility-Male"
replace labelclean="DeSoto - Female" if labelclean=="Desoto - Female"
replace labelclean="DeSoto Juvenile Correctional Facility - Mental Health" if labelclean=="Desoto Juvenile Correctional Facility - Mental Health"
replace labelclean="DeSoto - Female" if labelclean=="Desoto" & sex=="F"
replace labelclean="DeSoto - Female" if labelclean=="Desoto Maximum Risk"
replace labelclean="Dove Academy-Female" if labelclean=="Dove Academy"
replace labelclean="Dove Intensive Mental Health" if labelclean=="Dove Intensive Mental Health-Female"
replace labelclean="Eckerd Youth Challenge Program - Low" if labelclean=="Eckerd Youth Challenge Program" & type==30
replace labelclean="Eckerd Youth Challenge Program - Moderate" if labelclean=="Eckerd Youth Challenge Program" & type==31
replace labelclean="Eckerd Youth Challenge Program - Low" if labelclean=="Challenge"
replace labelclean="Eckerd Challenge Substance Abuse" if labelclean=="Challenge Substance Abuse"
replace labelclean="Eckerd Youth Development Center" if labelclean=="Okeechobee Youth Development Center"
replace labelclean="Eckerd Intensive Halfway House" if labelclean=="Okeechobee Intensive Halfway House"
replace labelclean="Francis Walker Halfway House-Female" if labelclean=="Francis Walker Halfway House"
replace labelclean="Ft. Walton Substance Abuse" if labelclean=="Ft. Walton Adolescent Substance Abuse Program"
replace labelclean="Greenville Hills - Jefferson Halfway House" if labelclean=="Greenville HIlls - Jefferson Halfway House"
replace labelclean="Graceville Vocational Youth Center" if labelclean=="Greenville Hills - Bassin House"
replace labelclean="Gulf Academy" if labelclean=="Gulf Academy - Mental Health"
replace labelclean="Mandala Adolescent Treatment Center" if labelclean=="Harbor Behavioral-Mandala ATC"
replace labelclean="Hastings Specialized/Intensive Mental Health" if labelclean=="Hastings - Intensive Mental Health Treatment"
replace labelclean="Hastings Specialized/Intensive Mental Health" if labelclean=="Hastings - Specialized Mental Health Treatment"
replace labelclean="Hastings Specialized/Intensive Mental Health" if labelclean=="Hastings Specialized & Intensive M H Treatment"
replace labelclean="Hastings Youth Academy - High" if labelclean=="Hastings Youth Academy" & type==32
replace labelclean="Hastings Youth Academy - Moderate" if labelclean=="Hastings Youth Academy" & type==31
replace labelclean="Hillsborough Intensive Residential Treatment" if labelclean=="Hillsborough IRT"
replace labelclean="Jackson Juvenile Offender Correctional Center" if labelclean=="Jackson JOCC"
replace labelclean="Joann Bridges Academy-Female" if labelclean=="Joann Bridges Academy"
replace labelclean="Kissimmee Juvenile Correctional Facility" if labelclean=="Kissimmee Juvenile Correctional Facility Sex Offender Program"
replace labelclean="Lake Academy-Female" if labelclean=="Lake Academy"
replace labelclean="Martin Academy" if labelclean=="Martin Girls Academy"
replace labelclean="Milton Juvenile Residential Facility" if labelclean=="Milton Juvenile Residential Faclity"
replace labelclean="Nassau Juvenile Residential Facility" if labelclean=="Nassau Juvenile Residential Facility - Moderate Risk"
replace labelclean="Nassau Juvenile Residential Facility" if labelclean=="Nassau Juvenile Residential Facility - Low Risk"
replace labelclean="New Beginnings Youth Academy" if labelclean=="Bowling Green New Beginnings"
replace labelclean="Okaloosa Borderline Developmental Disability Program" if labelclean=="Okaloosa Borderline"
replace labelclean="Okaloosa Halfway House" if labelclean=="Okaloosa Intensive Halfway House"
replace labelclean="Okaloosa Sex Offender Program" if labelclean=="Okaloosa Sex Offender Three Springs"
replace labelclean="Okaloosa Sex Offender Program" if labelclean=="Okaloosa Sex Offender"
replace labelclean="Okaloosa Youth Development Center" if labelclean=="Okaloosa Youth Development Center Developmentally Disabled"
replace labelclean="Okeechobee Juvenile Offender Correctional Center - Sex Offender Program" if labelclean=="Okeechobee Juvenile Offender Correctional Center Sex Offender Program"
replace labelclean="Okeechobee Juvenile Offender Correctional Center - Sex Offender Program" if labelclean=="Okeechobee Sex Offender Program"
replace labelclean="Okeechobee Juvenile Offender Correctional Center - Sex Offender Program" if labelclean=="Okeechobee Juvenile Offender Correctional Center - Sex Offender Program - High"
replace labelclean="Okeechobee Juvenile Offender Correctional Center - Sex Offender Program" if labelclean=="Okeechobee Juvenile Offender Correctional Center - Sex Offender Program - Maximum"
replace labelclean="Okeechobee Academy" if labelclean=="Okeechobee Girls Academy - Low"
replace labelclean="Okeechobee Academy" if labelclean=="Okeechobee Girls Academy - Moderate"
replace labelclean="Palm Beach Juvenile Correctional Facility - Substance Abuse" if labelclean=="Palm Beach Juvenile Correctional Facility Substance Abuse"
replace labelclean="Panther Success Center" if labelclean=="Panther Success Center - Low"
replace labelclean="Panther Success Center" if labelclean=="Panther Success"
replace labelclean="Panther Success Center" if labelclean=="Panther Success Center - Moderate"
replace labelclean="Pasco Academy" if labelclean=="Pasco Girls Academy - Low"
replace labelclean="Pasco Academy" if labelclean=="Pasco Girls Academy - Moderate"
replace labelclean="Pompano Substance Abuse Treatment Center" if labelclean=="Pompano Substance Abuse"
replace labelclean="Price Halfway House" if labelclean=="Price Halfway House For Girls"
replace labelclean="Red Road Academy - Moderate Risk" if labelclean=="Red Road Academy"
replace labelclean="Residential Alternative For The Mentally Challenged" if labelclean=="Residential Alternatives for the Mentally Challenged"
replace labelclean="Sago Palm - Sex Offender Program" if labelclean=="Sago Palm - Sex Offender Treatment"
replace labelclean="Santa Rosa Juvenile Residential Facility" if labelclean=="Santa Rosa Juvenile Residential Facility/St. Johns Youth Academy - Moderate"
replace labelclean="Santa Rosa Juvenile Residential Facility" if labelclean=="St. Johns Youth Academy"
replace labelclean="Sawmill Academy For Girls" if labelclean=="Sawmill Academy for Girls"
replace labelclean="South Pines" if labelclean=="South Pines - Low"
replace labelclean="South Pines" if labelclean=="South Pines - Moderate"
replace labelclean="Space Coast Marine Institute" if labelclean=="Space Coast"
replace labelclean="St. Johns Correctional Facility" if labelclean=="St Johns Correctional Facility"
replace labelclean="St. Johns Correctional Facility" if labelclean=="St. Johns Juvenile Correctional Facility"
replace labelclean="WINGS" if labelclean=="WINGS - Low"
replace labelclean="WINGS" if labelclean=="WINGS - Moderate"
replace labelclean="WINGS" if labelclean=="WINGS South Florida"
replace labelclean="West Florida Wilderness Institute" if labelclean=="West Florida"
replace labelclean="Youth Environmental Services (YES)" if labelclean=="Youth Environmental Services (YES) (YES)"
replace labelclean="Youth Environmental Services (YES)" if labelclean=="YES"
* One closed down the year the other opened, some kids have overlap, very short sentences, numbers look right
replace labelclean="Peace River Youth Academy" if labelclean=="Peace River Outward Bound"
* Both very tiny
replace labelclean="Okeechobee Juvenile Offender Correctional Center" if labelclean=="Okeechobee Juvenile Offender Correctional Center - Sex Offender Program"

* make labelclean into numeric
encode labelclean, gen(labelfac91)
label drop labelfac91

* outsheet to build peer matrix
sort numzz
outsheet numzz rec_out rec_in labelfac91 using peerdata_ReSTAT.csv,comma replace






*********************************************
****** put together labels for use as fixed effects
gen labelclean1=label
forval x=0/2{
forval y=0/9{
replace labelclean1=subinstr(labelclean1,"`x'`y' Circuit-","",1)
}
}

replace labelclean1=subinstr(labelclean1,"JRF","Juvenile Residential Facility",1)
replace labelclean1=subinstr(labelclean1,"JCF","Juvenile Correctional Facility",1)
replace labelclean1=subinstr(labelclean1,"SOP","Sex Offender Program",1)
replace labelclean1=subinstr(labelclean1,"Stop","Short Term Offender",1)
replace labelclean1=subinstr(labelclean1,"YDC","Youth Development Center",1)
replace labelclean1=subinstr(labelclean1,"Youth Environmental Services","Youth Environmental Services (YES)",1)
replace labelclean1=subinstr(labelclean1,"SHOP","Serious Habitual Offender Program",1)
replace labelclean1=subinstr(labelclean1,", LLC.","",1)
replace labelclean1=subinstr(labelclean1,", Inc.","",1)
replace labelclean1=subinstr(labelclean1,"Dual Diagnosis","Dual Diagnosis Correctional Facility",1)
replace labelclean1=subinstr(labelclean1,"-Female","",1) if sex=="F"
replace labelclean1=subinstr(labelclean1,"JOCC","Juvenile Offender Correctional Center",1)

replace labelclean1="Vision Quest - Moderate" if labelclean1=="Vision Quest Moderate Risk"
replace labelclean1="Alachua Academy-Female" if labelclean1=="Alachua Academy"
replace labelclean1="Bay Point Schools-North" if labelclean1=="Bay Point Schools - North"
replace labelclean1="Bay Point Schools-West Kennedy" if labelclean1=="Bay Point Schools-West-Kennedy"
replace labelclean1="Bowling Green Juvenile Residential Facility" if labelclean1=="Bowling Green Youth Academy - Juvenile Residential Facility"
replace labelclean1="Bristol Academy Specialized Unit" if labelclean1=="Bristol Academy - Specialized Unit"
replace labelclean1="Camp E Ma Chamee - Substance Abuse" if labelclean1=="Camp E-Ma-Chamee - Substance Abuse"
replace labelclean1="Camp E Ma Chamee - Substance Abuse" if labelclean1=="Camp E Ma Chamee Substance Abuse"
replace labelclean1="Camp E Ma Chamee" if labelclean1=="Camp E-Ma-Chamee"
replace labelclean1="Camp E-Nini-Hassee" if labelclean1=="Camp E Nini Hassee"
replace labelclean1="Crossroads Wilderness Institute" if labelclean1=="Crossroads"
replace labelclean1="Cypress Creek Juvenile Offender Correctional Center - Maximum" if labelclean1=="Cypress Creek Juvenile Offender Correctional Center -Maximum"
replace labelclean1="DeSoto Dual Diagnosis Correctional Facility - Female" if labelclean1=="DeSoto Dual Diagnosis Correctional Facility Correctional Facility - Female"
replace labelclean1="DeSoto Dual Diagnosis Correctional Facility - Male" if labelclean1=="DeSoto Dual Diagnosis Correctional Facility Correctional Facility - Male"
replace labelclean1="DeSoto Dual Diagnosis Correctional Facility - Male" if labelclean1=="DeSoto Dual Diagnosis Correctional Facility-Male"
replace labelclean1="DeSoto Juvenile Correctional Facility - Mental Health" if labelclean1=="DeSoto Juvenile Correctional Facility Mental Health"
replace labelclean1="DeSoto Juvenile Residential Facility - Male" if labelclean1=="DeSoto Juvenile Residential Facility-Male"
replace labelclean1="DeSoto - Female" if labelclean1=="Desoto - Female"
replace labelclean1="DeSoto Juvenile Correctional Facility - Mental Health" if labelclean1=="Desoto Juvenile Correctional Facility - Mental Health"
replace labelclean1="Francis Walker Halfway House-Female" if labelclean1=="Francis Walker Halfway House"
replace labelclean1="Ft. Walton Substance Abuse" if labelclean1=="Ft. Walton Adolescent Substance Abuse Program"
replace labelclean1="Hastings Specialized/Intensive Mental Health" if labelclean1=="Hastings Specialized & Intensive M H Treatment"
replace labelclean1="Hillsborough Intensive Residential Treatment" if labelclean1=="Hillsborough IRT"
replace labelclean1="Jackson Juvenile Offender Correctional Center" if labelclean1=="Jackson JOCC"
replace labelclean1="Joann Bridges Academy-Female" if labelclean1=="Joann Bridges Academy"
replace labelclean1="Lake Academy-Female" if labelclean1=="Lake Academy"
replace labelclean1="Martin Academy" if labelclean1=="Martin Girls Academy"
replace labelclean1="Milton Juvenile Residential Facility" if labelclean1=="Milton Juvenile Residential Faclity"
replace labelclean1="Okaloosa Sex Offender Program" if labelclean1=="Okaloosa Sex Offender"
replace labelclean1="Okeechobee Juvenile Offender Correctional Center - Sex Offender Program" if labelclean1=="Okeechobee Juvenile Offender Correctional Center Sex Offender Program"
replace labelclean1="Palm Beach Juvenile Correctional Facility - Substance Abuse" if labelclean1=="Palm Beach Juvenile Correctional Facility Substance Abuse"
replace labelclean1="Panther Success Center" if labelclean1=="Panther Success"
replace labelclean1="Pompano Substance Abuse Treatment Center" if labelclean1=="Pompano Substance Abuse"
replace labelclean1="Residential Alternative For The Mentally Challenged" if labelclean1=="Residential Alternatives for the Mentally Challenged"
replace labelclean1="Sago Palm - Sex Offender Program" if labelclean1=="Sago Palm - Sex Offender Treatment"
replace labelclean1="Sawmill Academy For Girls" if labelclean1=="Sawmill Academy for Girls"
replace labelclean1="St. Johns Correctional Facility" if labelclean1=="St Johns Correctional Facility"
replace labelclean1="St. Johns Correctional Facility" if labelclean1=="St. Johns Juvenile Correctional Facility"
replace labelclean1="Youth Environmental Services (YES)" if labelclean1=="Youth Environmental Services (YES) (YES)"
replace labelclean1="Youth Environmental Services (YES)" if labelclean1=="YES"

* make labelclean into numeric
encode labelclean1, gen(labelfac912)

la var labelclean1 "Labels for fixed effects"
la var labelfac912 "Labels for fixed effects"
la var labelclean "Labels for peer overlap"
la var labelfac912 "Labels for peer overlap"








