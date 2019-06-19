clear all
set mem 1g
cd "C:\Users\Horacio\Dropbox\UPE in Nigeria\DoFiles and Data for Merging\Replication file"

******************************************************************************
***************                Afrobarometer 2013              ***************
******************************************************************************

use nig_r5_data.dta, clear

*** State variable for subsequent merge ***
gen State=""
replace State="Abia" if state==620
replace State="Adamawa" if state==621
replace State="Akwa Ibom" if state==622
replace State="Anambra" if state==623
replace State="Bauchi" if state==624
replace State="Bayelsa" if state==625
replace State="Benue" if state==626
replace State="Borno" if state==627
replace State="Cross River" if state==628
replace State="Delta" if state==629
replace State="Ebonyi" if state==630
replace State="Edo" if state==631
replace State="Ekiti" if state==632
replace State="Enugu" if state==633
replace State="Federal Capital Territory" if state==634
replace State="Gombe" if state==635
replace State="Imo" if state==636
replace State="Jigawa" if state==637
replace State="Kaduna" if state==638
replace State="Kano" if state==639
replace State="Katsina" if state==640
replace State="Kebbi" if state==641
replace State="Kogi" if state==642
replace State="Kwara" if state==643
replace State="Lagos" if state==644
replace State="Nassarawa" if state==645
replace State="Niger" if state==646
replace State="Ogun" if state==647
replace State="Ondo" if state==648
replace State="Osun" if state==649
replace State="Oyo" if state==650
replace State="Plateau" if state==651
replace State="Rivers" if state==652
replace State="Sokoto" if state==653
replace State="Taraba" if state==654
replace State="Yobe" if state==655
replace State="Zamfara" if state==656

*** Local government area variable for subsequent merge ***
rename district LGA
replace LGA = proper(LGA)
replace LGA="Oboma Ngwa" if LGA=="Obioma Ngwa" & State=="Abia"
replace LGA="Mayo-Bel" if LGA=="Mayo Belwa" & State=="Adamawa"
replace LGA="Etinan" if LGA=="Etinam" & State=="Akwa Ibom"
replace LGA="Oruk-Ana" if LGA=="Oruk-Anam" & State=="Akwa Ibom"
replace LGA="AwkaSout" if LGA=="Awka South" & State=="Anambra"
replace LGA="NnewiSou" if LGA=="Nnewi South" & State=="Anambra"
replace LGA="Gamjuwa" if LGA=="Ganjuwa" & State=="Bauchi"
replace LGA="Maidugur" if LGA=="Maiduguri" & State=="Borno"
replace LGA="Calabar" if LGA=="Calabar Municipal" & State=="Cross River"
replace LGA="Yala Cross" if LGA=="Yala" & State=="Cross River"
replace LGA="Ika North" if LGA=="Ika North East" & State=="Delta"
replace LGA="Abakalik" if LGA=="Abakaliki" & State=="Ebonyi"
replace LGA="Esan South" if LGA=="Esan South East" & State=="Edo"
replace LGA="Ikpoba-Okha" if LGA=="Ikpoba Okha" & State=="Edo"
replace LGA="Oredo Edo" if LGA=="Oredo" & State=="Edo"
replace LGA="OwanWest" if LGA=="Owan West" & State=="Edo"
replace LGA="Ado-Ekiti" if LGA=="Ado Ekiti" & State=="Ekiti"
replace LGA="EkitiWest" if LGA=="Ekiti West" & State=="Ekiti"
replace LGA="EnuguSou" if LGA=="Enugu South" & State=="Enugu"
replace LGA="Oji-River" if LGA=="Oji River" & State=="Enugu"
replace LGA="Uzo-Uwani" if LGA=="Uzo Uwani" & State=="Enugu"
replace LGA="AbujaMun" if LGA=="Amac" & State=="Federal Capital Territory"
replace LGA="Yamaltu" if LGA=="Yamaltu/Deba" & State=="Gombe"
replace LGA="Aboh-Mba" if LGA=="Aboh Mbaise" & State=="Imo"
replace LGA="Nwangele" if LGA=="Nkwangele" & State=="Imo"
replace LGA="Biriniwa" if LGA=="Birniwa" & State=="Jigawa"
replace LGA="Jahun" if LGA=="Jahum" & State=="Jigawa"
replace LGA="Jema'a" if LGA=="Jama'A" & State=="Kaduna"
replace LGA="Sabon-Ga" if LGA=="Sabon Gari" & State=="Kaduna"
replace LGA="Zaria" if LGA=="Zaria (Tudun Wada)" & State=="Kaduna"
replace LGA="DawakinK" if LGA=="Dawakin-Kudu" & State=="Kano"
replace LGA="Nassaraw" if LGA=="Nassarawa" & State=="Kano"
replace LGA="Tundun Wada" if LGA=="Tudun-Wada" & State=="Kano"
replace LGA="Katsina (K)" if LGA=="Katsina" & State=="Katsina"
replace LGA="Kabba/Bu" if LGA=="Kabba Bunu" & State=="Kogi"
replace LGA="Olamabor" if LGA=="Olamaboro" & State=="Kogi"
replace LGA="IlorinWe" if LGA=="Ilorin West" & State=="Kwara"
replace LGA="Ajeromi/Ifelodun" if LGA=="Ajeromi Ifelodun" & State=="Lagos"
replace LGA="LagosIsland" if LGA=="Lagos Island" & State=="Lagos"
replace LGA="Oshodi/Isolo" if LGA=="Oshodi/Isholo" & State=="Lagos"
replace LGA="AdoOdo/Ota" if LGA=="Ado Odo Ota" & State=="Ogun"
replace LGA="IjebuOde" if LGA=="Ijebu Ode" & State=="Ogun"
replace LGA="Shagamu" if LGA=="Sagamu" & State=="Ogun"
replace LGA="Akoko North-East" if LGA=="Akoko N\E" & State=="Ondo"
replace LGA="Akoko South-West" if LGA=="Akoko S\W" & State=="Ondo"
replace LGA="Ilesha West" if LGA=="Ilesa West" & State=="Osun"
replace LGA="IbadanNorth" if LGA=="Ibadan North" & State=="Oyo"
replace LGA="IbadanNorth-East" if LGA=="Ibadan North East" & State=="Oyo"
replace LGA="IbadanSouth-East" if LGA=="Ibadan South East" & State=="Oyo"
replace LGA="IbadanSouth-West" if LGA=="Ibadan South West" & State=="Oyo"
replace LGA="Ahoada West" if LGA=="Ahoada-West" & State=="Rivers"
replace LGA="Akukutor" if LGA=="Akuku Toru" & State=="Rivers"
replace LGA="Emuoha" if LGA=="Emohua" & State=="Rivers"
replace LGA="Obio/Akp" if LGA=="Obio\Akpor" & State=="Rivers"
replace LGA="Tai" if LGA=="Tai\Eleme" & State=="Rivers"
replace LGA="Gummi" if LGA=="Gunmi" & State=="Zamfara"
replace LGA="Kaura-Na" if LGA=="Kaura Namoda" & State=="Zamfara"

*** Urban / rural variable for control ***
gen urban_rural = ""
replace urban_rural = "urban" if  urbrur==1 
replace urban_rural = "rural" if   urbrur==2

*** Age variable for instrument and control ***
gen age = Q1 
label var age "Age of respondent"
replace age=. if age==998
replace age=. if age==999

*** Gender variable for control ***
gen gender="" if Q101!=. & Q101!=9
replace gender="male" if Q101==1
replace gender="female" if Q101==2

*** Education variables for treatment ***
gen primary_school_inc = 0 if Q97!=. & Q97!=99
replace primary_school_inc = 1 if Q97>=2 & Q97<=9
gen primary_school = 0 if Q97!=. & Q97!=99
replace primary_school = 1 if Q97>=3 & Q97<=9
gen secondary_school_inc = 0 if Q97!=. & Q97!=99
replace secondary_school_inc = 1 if Q97>=4 & Q97<=9
gen secondary_school = 0 if Q97!=. & Q97!=99
replace secondary_school = 1 if Q97>=5 & Q97<=9
gen college=  0 if Q97!=. & Q97!=99
replace college = 1 if Q97>=8 & Q97<=9

*** Religion variable for control ***
gen religion=""
replace religion="None" if Q98A==0 | Q98A==28 | Q98A==29
replace religion="Muslim" if (Q98A>=18 & Q98A<=24) | Q98A==620
replace religion="Christian" if (Q98A>=1 & Q98A<=13 ) | Q98A==32| Q98A==33
replace religion="Traditional" if Q98A==25
replace religion="Other" if Q98A==14  | Q98A==15  | Q98A==16 | Q98A==17 | Q98A==998 | Q98A==9999

*** Language variable for heterogenous effects ***
gen language="" if Q2!=. | Q2!=999
replace language="english" if Q2==1
replace language="hausa" if Q2==620
replace language="igbo" if Q2==621
replace language="yoruba" if Q2==622
replace language="pidgin english" if Q2==623
replace language="efik" if Q2==624
replace language="ebira" if Q2==625
replace language="fulani" if Q2==626
replace language="isoko" if Q2==627
replace language="ibibio" if Q2==628
replace language="kanuri" if Q2==629
replace language="tiv" if Q2==630
replace language="nupe" if Q2==631
replace language="ijaw" if Q2==632
replace language="edo" if Q2==633
replace language="igala" if Q2==634
replace language="urhobo" if Q2==635
replace language="ogoni" if Q2==636
replace language="anang" if Q2==637
replace language="ikwere" if Q2==638
replace language="idoma" if Q2==639
replace language="esan" if Q2==640
replace language="nembe" if Q2==641
replace language="jukun" if Q2==642
replace language="okrika" if Q2==643
replace language="yakhor" if Q2==644
replace language="ika" if Q2==645
replace language="okpe" if Q2==646
replace language="tarok" if Q2==647
replace language="ibaji" if Q2==648
replace language="migili" if Q2==649
replace language="gbagyi" if Q2==650
replace language="gwoza" if Q2==651
replace language="bajju" if Q2==652
replace language="ekpeye" if Q2==653
replace language="kataf" if Q2==654
replace language="mada" if Q2==655
replace language="kalabari" if Q2==656
replace language="sayawa" if Q2==657
replace language="ohafia" if Q2==658
replace language="others" if Q2==9995

*** Tribe variable for heterogenous effects ***
gen tribe="" if Q84!=9999
replace tribe="hausa" if Q84==620
replace tribe="igbo" if Q84==621
replace tribe="yoruba" if Q84==622
replace tribe="efik" if Q84==623
replace tribe="ebira" if Q84==624
replace tribe="fulani" if Q84==625
replace tribe="isoko" if Q84==626
replace tribe="ibibio" if Q84==627
replace tribe="kanuri" if Q84==628
replace tribe="tiv" if Q84==629
replace tribe="nupe" if Q84==630
replace tribe="ijaw" if Q84==631
replace tribe="edo" if Q84==632
replace tribe="igala" if Q84==633
replace tribe="urhobo" if Q84==634
replace tribe="idoma" if Q84==635
replace tribe="itsekiri" if Q84==636
replace tribe="ikwere" if Q84==637
replace tribe="awori" if Q84==638
replace tribe="tapa" if Q84==639
replace tribe="kalabari" if Q84==640
replace tribe="birom" if Q84==641
replace tribe="shuwa-arab" if Q84==642
replace tribe="jukun" if Q84==643
replace tribe="gwari" if Q84==644
replace tribe="ogoni" if Q84==645
replace tribe="anang" if Q84==646
replace tribe="Yakhor" if Q84==647
replace tribe="okpella" if Q84==648
replace tribe="Tarok" if Q84==649
replace tribe="Esan" if Q84==650
replace tribe="Ika" if Q84==651
replace tribe="gbagyi" if Q84==652
replace tribe="Okrika" if Q84==653
replace tribe="Bajju" if Q84==654
replace tribe="Gwoza" if Q84==655
replace tribe="Ibaji" if Q84==656
replace tribe="Kataf" if Q84==657
replace tribe="Migili" if Q84==658
replace tribe="Koro" if Q84==659
replace tribe="sayawa" if Q84==2620
replace tribe="Chamba" if Q84==2621
replace tribe="Jaba" if Q84==2622
replace tribe="Mada" if Q84==2623
replace tribe="others" if Q84==9995

*** Community participation variables *** 
gen rel_group_assoc = 0 if Q25A!=. &  Q25A !=9
replace rel_group_assoc = 1 if Q25A==1 | Q25A==2 |  Q25A ==3

gen rel_group_assoc_active = 0 if Q25A!=. &  Q25A !=9
replace rel_group_assoc_active = 1 if Q25A==2 |  Q25A ==3

gen member_association =0 if Q25B!=. & Q25B!=9 
replace member_association =1 if Q25B==1 | Q25B==2 | Q25B==3

gen member_assoc_active =0 if Q25B!=. & Q25B!=9 
replace member_assoc_active =1 if Q25B==2 | Q25B==3 

gen att_community_meeting = 0 if Q26A!=. & Q26A!=9
replace att_community_meeting =1 if Q26A==2 | Q26A==3 |Q26A==4

*** Political variables *** 
gen discuss_politics = 0 if Q15!=. & Q15!=9
replace discuss_politics =1 if Q15==1 | Q15==2

gen discuss_politics_often = 0 if Q15!=. & Q15!=9
replace discuss_politics_often =1 if Q15==2

gen raise_issue = 0 if Q26B!=. & Q26B!=9
replace raise_issue =1 if Q26B==2 | Q26B==3 | Q26B==4

gen att_demonstration = 0 if Q26D!=. & Q26D!=9
replace att_demonstration =1 if Q26D==2 | Q26D==3 | Q26D==4 

gen voted = 0 if Q27 !=. & Q27 !=9
replace voted = 1 if Q27 ==1 

gen close_political_party=0 if Q89A!=. & Q89A!=8 & Q89A!=9
replace close_political_party=1 if Q89A==1

**** Media and public affairs variables***
gen radio_news_rare =0 if Q13A!=. & Q13A!=9
replace  radio_news_rare =1 if Q13A==1 | Q13A==2 | Q13A==3 | Q13A==4

gen radio_news =0 if Q13A!=. & Q13A!=9
replace  radio_news =1 if Q13A==2 | Q13A==3 | Q13A==4

gen radio_news_sev =0 if Q13A!=. & Q13A!=9
replace  radio_news_sev =1 if Q13A==3 | Q13A==4

gen radio_news_often =0 if Q13A!=. & Q13A!=9
replace  radio_news_often =1 if Q13A==4

gen tv_news_rare =0 if Q13B!=. & Q13B!=9
replace  tv_news_rare =1 if Q13B==1 | Q13B==2 | Q13B==3 | Q13B==4

gen tv_news =0 if Q13B!=. & Q13B!=9
replace  tv_news =1 if Q13B==2 | Q13B==3 | Q13B==4

gen tv_news_sev =0 if Q13B!=. & Q13B!=9
replace  tv_news_sev =1 if Q13B==3 | Q13B==4

gen tv_news_often =0 if Q13B!=. & Q13B!=9
replace  tv_news_often =1 if Q13B==4

gen newspapers_news_rare =0 if Q13C !=. & Q13C !=9
replace  newspapers_news_rare =1 if Q13C ==1 | Q13C ==2 | Q13C ==3 | Q13C ==4

gen newspapers_news =0 if Q13C !=. & Q13C !=9
replace  newspapers_news =1 if Q13C ==2 | Q13C ==3 | Q13C ==4

gen newspapers_news_sev =0 if Q13C !=. & Q13C !=9
replace  newspapers_news_sev =1 if Q13C ==3 | Q13C ==4

gen newspapers_news_often =0 if Q13C !=. & Q13C !=9
replace  newspapers_news_often =1 if Q13C ==4

gen interest_public_affairs = 0 if Q14!=. & Q14!=9
replace interest_public_affairs = 1 if Q14==2 | Q14==3
label var interest_public_affairs "Interested in public affairs"

gen very_int_publ_aff = 0 if Q14!=. & Q14!=9
replace very_int_publ_aff = 1 if Q14==3
label var very_int_publ_aff "Very interested in public affairs"

*** Contact officials variables***
gen contact_LG_councilor = 0 if Q30A!=. & Q30A!=9
replace contact_LG_councilor = 1 if Q30A== 1 | Q30A==2 | Q30A==3

gen contact_LG_councilor_often = 0 if Q30A!=. & Q30A!=9
replace contact_LG_councilor_often = 1 if Q30A==2 | Q30A==3

gen contact_MP = 0 if Q30B!=. & Q30B!=9
replace contact_MP = 1 if Q30B== 1 | Q30B==2 | Q30B==3

gen contact_MP_often = 0 if Q30B!=. & Q30B!=9
replace contact_MP_often = 1 if Q30B==2 | Q30B==3


*** Democratic views variables ***
gen checks_balances =0 if Q36!=. & Q36!=9
replace checks_balances =1 if Q36==1 |  Q36==2

gen checks_balances_strong =0 if  Q36!=. & Q36!=9
replace checks_balances_strong =1 if Q36==1

gen against_president_discretion =0 if Q40!=. & Q40!=9
replace against_president_discretion =1 if Q40==3 |  Q40==4

gen term_limits =0 if Q41!=.  & Q41!=9 
replace term_limits  =1 if Q41 ==1 | Q41 ==2

gen term_limits_strongly =0 if Q41!=.  & Q41!=9 
replace term_limits_strongly  =1 if Q41 ==1

gen against_one_party_rule =0 if Q31A!=. & Q31A!=9
replace against_one_party_rule =1 if Q31A == 1 | Q31A==2

gen reject_military_rule =0 if Q31B!=. & Q31B!=9
replace reject_military_rule =1 if Q31B == 1 | Q31B==2

gen reject_one_man_rule =0 if Q31C!=. & Q31C!=9
replace reject_one_man_rule =1 if Q31C == 1 | Q31C==2

gen against_govt_ban_org=0 if Q19!=. & Q19!=9
replace against_govt_ban_org=1 if Q19==3| Q19==4

gen newspaper_free=0 if Q20!=. &Q20!=9
replace newspaper_free=1 if Q20==3 | Q20 ==4 


*** Trust on different institutions variables ***
gen trust_president =0 if Q59A!=. & Q59A!=9
replace trust_president =1  if Q59A==2 | Q59A==3

gen trust_national_assembly=0 if Q59B!=. & Q59B!=9
replace trust_national_assembly=1 if Q59B==2  | Q59B==3
 
gen trust_INEC=0 if Q59C!=. & Q59C!=9
replace trust_INEC=1 if Q59C ==2 | Q59C ==3

gen trust_LG_council=0 if Q59E!=. & Q59E!=9
replace trust_LG_council=1 if Q59E==2 | Q59E==3

gen trust_ruling_pary=0 if Q59F!=. & Q59F!=9
replace trust_ruling_pary=1 if Q59F==2 | Q59F ==3

gen trust_opposition_pary=0 if Q59G!=. & Q59G!=9
replace trust_opposition_pary=1  if Q59G==2 | Q59G==3


*** Perceptions of government corruption and performance variables ***
gen handles_economy =0 if Q65A!=. & Q65A!=9
replace handles_economy =1 if Q65A==3 | Q65A==4
label var handles_economy "Government handles economy"

gen handles_employment=0  if Q65C!=. & Q65C!=9
replace handles_employment =1 if Q65C==3 | Q65C==4
label var handles_employment "Government handles employment"

gen handles_inflation=0 if Q65D!=. & Q65D!=9
replace handles_inflation =1 if Q65D==3 | Q65D==4
label var handles_inflation "Government handles inflation"

gen handles_inequality=0 if Q65E!=. & Q65E!=9
replace handles_inequality =1 if Q65E==3 | Q65E==4
label var handles_inequality "Government handles inequality"

gen handles_health=0 if Q65G!=. & Q65G!=9
replace handles_health =1 if Q65G==3 | Q65G==4
label var handles_health "Government handles health provision"

gen handles_education=0 if Q65H!=. & Q65H!=9
replace handles_education =1 if Q65H==3 | Q65H==4
label var handles_education "Government handles education provision"

gen handles_water=0  if Q65I!=. & Q65I!=9
replace handles_water =1 if Q65I==3 | Q65I==4
label var handles_water "Government handles water provisoon"

gen performance_president = 0 if Q71A!=. & Q71A!=9
replace performance_president = 1 if Q71A==3 | Q71A==4
label var performance_president "Approves President perfomance"
 
gen performance_mp  = 0 if Q71B!=. & Q71B!=9
replace performance_mp = 1 if Q71B==3 | Q71B==4
label var performance_mp "Approves MP perfomance"

gen performance_LG_councilor  = 0 if Q71C!=. & Q71C!=9
replace performance_LG_councilor  = 1 if Q71C==3 | Q71C==4
label var performance_LG_councilor "Approves LG councilor perfomance"

gen corruption_president = 0 if Q60A !=. &  Q60A !=9
replace corruption_president = 1 if Q60A ==2 | Q60A ==3
label var corruption_president "Very corrupt president office"

gen corruption_MP = 0 if Q60B !=. &  Q60B !=9
replace corruption_MP = 1 if Q60B ==2 | Q60B ==3
label var corruption_MP "Very corrupt MPs"

gen corruption_LG_councilors = 0 if Q60D  !=. &  Q60D  !=9
replace corruption_LG_councilors = 1 if Q60D  ==2 | Q60D  ==3
label var corruption_LG_councilors "Very corrupt LG councilors"


*** Identity variable***
gen ethnic_national = 0 if Q85B!=. & Q85B!=7 & Q85B!=9
replace ethnic_national = 1 if Q85B==1 | Q85B==2
label var ethnic_national "Feels ethnic identity as opposed to Nigerian"

*** Survey year for instrument construction ***
gen year_census = 2013

keep LGA State -  year_census 

save Afrobarometer2013.dta, replace


******************************************************************************
***************                Afrobarometer 2009              ***************
******************************************************************************

use nig_r4_data.dta, clear

*** State variable for subsequent merge ***
rename region state
gen State=""
replace State="Abia" if state==620
replace State="Adamawa" if state==621
replace State="Akwa Ibom" if state==622
replace State="Anambra" if state==623
replace State="Bauchi" if state==624
replace State="Bayelsa" if state==625
replace State="Benue" if state==626
replace State="Borno" if state==627
replace State="Cross River" if state==628
replace State="Delta" if state==629
replace State="Ebonyi" if state==630
replace State="Edo" if state==631
replace State="Ekiti" if state==632
replace State="Enugu" if state==633
replace State="Federal Capital Territory" if state==634
replace State="Gombe" if state==635
replace State="Imo" if state==636
replace State="Jigawa" if state==637
replace State="Kaduna" if state==638
replace State="Kano" if state==639
replace State="Katsina" if state==640
replace State="Kebbi" if state==641
replace State="Kogi" if state==642
replace State="Kwara" if state==643
replace State="Lagos" if state==644
replace State="Nassarawa" if state==645
replace State="Niger" if state==646
replace State="Ogun" if state==647
replace State="Ondo" if state==648
replace State="Osun" if state==649
replace State="Oyo" if state==650
replace State="Plateau" if state==651
replace State="Rivers" if state==652
replace State="Sokoto" if state==653
replace State="Taraba" if state==654
replace State="Yobe" if state==655
replace State="Zamfara" if state==656

*** Local government area variable for subsequent merge ***
rename district LGA
replace LGA = proper(LGA)
replace LGA="Teungo" if LGA=="Toungo" & State=="Adamawa"
replace LGA="Etinan" if LGA=="Etinam" & State=="Akwa Ibom"
replace LGA="Ikot-Ekp" if LGA=="Ikot Ekpene" & State=="Akwa Ibom"
replace LGA="Esit Eket" if LGA=="Uquo-Ibeno(Esit Eket)" & State=="Akwa Ibom"
replace LGA="AwkaSout" if LGA=="Awka South" & State=="Anambra"
replace LGA="Tafawa-B" if LGA=="Tafawa Balewa" & State=="Bauchi"
replace LGA="Yenegoa" if LGA=="Yenagoa" & State=="Bayelsa"
replace LGA="Katsina Ala" if LGA=="Katsinala" & State=="Benue"
replace LGA="Askira/U" if LGA=="Askira/Uba" & State=="Borno"
replace LGA="Maidugur" if LGA=="Maiduguri" & State=="Borno"
replace LGA="Bekwarra" if LGA=="Bekwara" & State=="Cross River"
replace LGA="Calabar" if LGA=="Calabar Municipal" & State=="Cross River"
replace LGA="Yakurr" if LGA=="Yakur" & State=="Cross River"
replace LGA="Ika North" if LGA=="Ika North East" & State=="Delta"
replace LGA="Afikpo" if LGA=="Abakaliki" & State=="Ebonyi"
replace LGA="Abakalik" if LGA=="Afikpo North" & State=="Ebonyi"
replace LGA="Orhionmw" if LGA=="Orhionmwo" & State=="Edo"
replace LGA="OviaNort" if LGA=="Ovia North East" & State=="Edo"
replace LGA="OwanWest" if LGA=="Owan West" & State=="Edo"
replace LGA="Uhunmwonde" if LGA=="Uhonmwode" & State=="Edo"
replace LGA="Ido/Osi" if LGA=="Ido - Osi" & State=="Ekiti"
replace LGA="Igbo-eze South" if LGA=="Igbo-Eze South" & State=="Enugu"
replace LGA="Abaji" if LGA=="Amac" & State=="Federal Capital Territory"
replace LGA="Gwagwala" if LGA=="Gwagwalada" & State=="Federal Capital Territory"
replace LGA="Ahizu-Mb" if LGA=="Ahiazu Mbaise" & State=="Imo"
replace LGA="Ezinihit" if LGA=="Ezinitte Mbaise" & State=="Imo"
replace LGA="IdeatoNo" if LGA=="Ideato North" & State=="Imo"
replace LGA="IsialaMb" if LGA=="Isiala Mbano" & State=="Imo"
replace LGA="Birnin-G" if LGA=="Birnin Gwari" & State=="Kaduna"
replace LGA="Jema'a" if LGA=="Jama'A" & State=="Kaduna"
replace LGA="Sabon-Ga" if LGA=="Sabon-Gari" & State=="Kaduna"
replace LGA="ZangonKa" if LGA=="Zangon-Kataf" & State=="Kaduna"
replace LGA="DawakinK" if LGA=="Dawakin-Kudu" & State=="Kano"
replace LGA="Kano" if LGA=="Kano Municipal" & State=="Kano"
replace LGA="Nassaraw" if LGA=="Nassarawa" & State=="Kano"
replace LGA="Danmusa" if LGA=="Dan Musa" & State=="Katsina"
replace LGA="Dutsin-M" if LGA=="Dutsin-Ma" & State=="Katsina"
replace LGA="Katsina (K)" if LGA=="Katsina" & State=="Katsina"
replace LGA="Mai'Adua" if LGA=="Maiduwa" & State=="Katsina"
replace LGA="Koko/Bes" if LGA=="Koko/Besse" & State=="Kebbi"
replace LGA="Ogori/Magongo" if LGA=="Ogori Magongo" & State=="Kogi"
replace LGA="IlorinWe" if LGA=="Ilorin West" & State=="Kwara"
replace LGA="Ajeromi/Ifelodun" if LGA=="Ajeromi Ifelodun" & State=="Lagos"
replace LGA="Badagary" if LGA=="Badagry" & State=="Lagos"
replace LGA="Ifako/Ijaye" if LGA=="Ifako Ijaye" & State=="Lagos"
replace LGA="LagosIsland" if LGA=="Lagos Island" & State=="Lagos"
replace LGA="Mainland" if LGA=="Lagos Mainland" & State=="Lagos"
replace LGA="Oshodi/Isolo" if LGA=="Oshodi - Isolo" & State=="Lagos"
replace LGA="Nasarawa" if LGA=="Nassarawa" & State=="Nassarawa"
replace LGA="Kontogur" if LGA=="Kotangora" & State=="Niger"
replace LGA="AdoOdo/Ota" if LGA=="Ado-Odo Otta" & State=="Ogun"
replace LGA="Ikenne" if LGA=="Ikene" & State=="Ogun"
replace LGA="Remo-North" if LGA=="Remo North" & State=="Ogun"
replace LGA="AkokoNorthWest" if LGA=="Akoko North West" & State=="Ondo"
replace LGA="Akoko South-East" if LGA=="Akoko South East" & State=="Ondo"
replace LGA="IlajeEseodo" if LGA=="Ilaje" & State=="Ondo"
replace LGA="Atakumosa West" if LGA=="Atakomosa West" & State=="Osun"
replace LGA="IfeCentral" if LGA=="Ife Central" & State=="Osun"
replace LGA="IbadanNorth" if LGA=="Ibadan North" & State=="Oyo"
replace LGA="IbadanSouth-East" if LGA=="Ibadan South East" & State=="Oyo"
replace LGA="IbadanSouth-West" if LGA=="Ibadan South West" & State=="Oyo"
replace LGA="Ibarapa East" if LGA=="Ibarapa-East" & State=="Oyo"
replace LGA="Oyo West" if LGA=="Oyo-West" & State=="Oyo"
replace LGA="Qua'anpa" if LGA=="Quan Pan" & State=="Plateau"
replace LGA="Abua/Odu" if LGA=="Abual/Odua" & State=="Rivers"
replace LGA="Andoni/O" if LGA=="Andoni" & State=="Rivers"
replace LGA="Obio/Akp" if LGA=="Obio/Akpor" & State=="Rivers"
replace LGA="Ogba/Egbe" if LGA=="Ogba/Egbema/Ndoni" & State=="Rivers"
replace LGA="Okrika" if LGA=="Okirika" & State=="Rivers"
replace LGA="Port Harcourt" if LGA=="Port-Harcourt City" & State=="Rivers"
replace LGA="Tai" if LGA=="Tai/Eleme" & State=="Rivers"
replace LGA="Tambawal" if LGA=="Tambuwal" & State=="Sokoto"
replace LGA="Kaura-Na" if LGA=="Kaura Namoda" & State=="Zamfara"

*** Urban / rural variable for control ***
gen urban_rural = ""
replace urban_rural = "urban" if urbrur==1 | urbrur==2
replace urban_rural = "rural" if   urbrur==3

*** Age variable for instrument and control ***
gen age = q1 
label var age "Age of respondent"
replace age=. if age==998
replace age=. if age==999

*** Gender variable for control ***
gen gender="" if q101!=. & q101!=9
replace gender="male" if q101==1
replace gender="female" if q101==2

*** Education variables for treatment ***
gen primary_school_inc = 0 if q89!=. & q89!=99
replace primary_school_inc = 1 if q89>=2 & q89<=9
gen primary_school = 0 if q89!=. & q89!=99
replace primary_school = 1 if q89>=3 & q89<=9
gen secondary_school_inc = 0 if q89!=. & q89!=99
replace secondary_school_inc = 1 if q89>=4 & q89<=9
gen secondary_school = 0 if q89!=. & q89!=99
replace secondary_school = 1 if q89>=5 & q89<=9
gen college=  0 if q89!=. & q89!=99
replace college = 1 if q89>=8 & q89<=9

*** Religion variable for control ***
gen religion=""
replace religion="None" if q90==0 | q90==28 | q90==29
replace religion="Muslim" if (q90>=18 & q90<=24) | q90==620
replace religion="Christian" if q90>=1 & q90<=13
replace religion="Traditional" if q90==25
replace religion="Other" if q90==14  | q90==15  | q90==16 | q90==998

*** Language variable for heterogenous effects ***
gen language="" if q3!=. | q3!=999
replace language="hausa" if q3==620
replace language="igbo" if q3==621
replace language="yoruba" if q3==622
replace language="pidgin english" if q3==623
replace language="efik" if q3==624
replace language="ebira" if q3==625
replace language="fulani" if q3==626
replace language="isoko" if q3==627
replace language="ibibio" if q3==628
replace language="kanuri" if q3==629
replace language="tiv" if q3==630
replace language="nupe" if q3==631
replace language="ijaw/kalabari/okirika/andoni/ogoni/nemb" if q3==632
replace language="edo" if q3==633
replace language="igala" if q3==634
replace language="urhobo" if q3==635
replace language="anang" if q3==637
replace language="ikwere" if q3==638
replace language="idoma" if q3==639
replace language="esan" if q3==640
replace language="igede" if q3==643
replace language="babur" if q3==644
replace language="marghi" if q3==645
replace language="gbagyi" if q3==646
replace language="ugep" if q3==647
replace language="kambari" if q3==648
replace language="eggon" if q3==649
replace language="kataf (atyap)" if q3==650
replace language="abua" if q3==651
replace language="eleme" if q3==653
replace language="mumuye" if q3==654
replace language="ejagam" if q3==655
replace language="tangale" if q3==656
replace language="ogbia" if q3==657
replace language="khana" if q3==658
replace language="jukun" if q3==659
replace language="others" if q3==995

*** Tribe variable for heterogenous effects ***
gen tribe="" if q79!=999
replace tribe="hausa" if q79==620
replace tribe="igbo" if q79==621
replace tribe="yoruba" if q79==622
replace tribe="efik" if q79==623
replace tribe="ebira" if q79==624
replace tribe="fulani" if q79==625
replace tribe="isoko" if q79==626
replace tribe="ibibio" if q79==627
replace tribe="kanuri" if q79==628
replace tribe="tiv" if q79==629
replace tribe="nupe" if q79==630
replace tribe="ijaw/kalabari/andoni/nembe/ogoni/okirik" if q79==631
replace tribe="edo" if q79==632
replace tribe="igala" if q79==633
replace tribe="urhobo" if q79==634
replace tribe="idoma" if q79==635
replace tribe="ikwere" if q79==637
replace tribe="awori" if q79==638
replace tribe="jukun" if q79==643
replace tribe="gwari" if q79==644
replace tribe="igede" if q79==648
replace tribe="babur" if q79==649
replace tribe="gbagyi" if q79==650
replace tribe="ugep" if q79==651
replace tribe="anang" if q79==652
replace tribe="kambari" if q79==653
replace tribe="eggon" if q79==655
replace tribe="mumuye" if q79==656
replace tribe="marghi" if q79==657
replace tribe="tangale" if q79==658
replace tribe="eleme" if q79==659
replace tribe="others" if q79==995


*** Community participation variables *** 
gen rel_group_assoc = 0 if q22a!=. &  q22a !=9
replace rel_group_assoc = 1 if q22a==1 | q22a==2 |  q22a ==3

gen rel_group_assoc_active = 0 if q22a!=. &  q22a !=9
replace rel_group_assoc_active = 1 if q22a==2 |  q22a ==3

gen member_association =0 if q22b!=. & q22b!=9 
replace member_association =1 if q22b==1 | q22b==2 | q22b==3

gen member_assoc_active =0 if q22b!=. & q22b!=9 
replace member_assoc_active =1 if q22b==2 | q22b==3 

gen att_community_meeting = 0 if q23a!=. & q23a!=9
replace att_community_meeting =1 if q23a==2 | q23a==3 |q23a==4


*** Political variables *** 
gen discuss_politics = 0 if q14!=. & q14!=9
replace discuss_politics =1 if q14==1 | q14==2

gen discuss_politics_often = 0 if q14!=. & q14!=9
replace discuss_politics_often =1 if q14==2

gen name_hr_member = (q41a2==3) 
gen name_fin_min = (q41b2==3) 

gen raise_issue = 0 if q23b!=. & q23b!=9
replace raise_issue =1 if q23b==2 | q23b==3 | q23b==4

gen att_demonstration = 0 if q23c!=. & q23c!=9
replace att_demonstration =1 if q23c==2 | q23c==3 | q23c==4 

gen voted = 0 if q23d!=. & q23d!=9
replace voted = 1 if q23d==1 

gen close_political_party=0 if q85!=. & q85!=8 & q85!=9
replace close_political_party=1 if q85==1


*** Media and public affairs variables***
gen radio_news_rare =0 if q12a!=. & q12a!=9
replace  radio_news_rare =1 if q12a==1 | q12a==2 | q12a==3 | q12a==4

gen tv_news_rare =0 if q12b!=. & q12b!=9
replace  tv_news_rare =1 if q12b==1 | q12b==2 | q12b==3 | q12b==4

gen newspapers_news_rare =0 if q12c!=. & q12c!=9
replace  newspapers_news_rare =1 if q12c==1 | q12c==2 | q12c==3 | q12c==4

gen radio_news =0 if q12a!=. & q12a!=9
replace  radio_news =1 if q12a==2 | q12a==3 | q12a==4

gen tv_news =0 if q12b!=. & q12b!=9
replace  tv_news =1 if q12b==2 | q12b==3 | q12b==4

gen newspapers_news =0 if q12c!=. & q12c!=9
replace  newspapers_news =1 if q12c==2 | q12c==3 | q12c==4

gen radio_news_sev =0 if q12a!=. & q12a!=9
replace  radio_news_sev =1 if q12a==3 | q12a==4

gen tv_news_sev =0 if q12b!=. & q12b!=9
replace  tv_news_sev =1 if q12b==3 | q12b==4

gen newspapers_news_sev =0 if q12c!=. & q12c!=9
replace  newspapers_news_sev =1 if q12c==3 | q12c==4

gen radio_news_often =0 if q12a!=. & q12a!=9
replace  radio_news_often =1 if q12a==4

gen tv_news_often =0 if q12b!=. & q12b!=9
replace  tv_news_often =1 if q12b==4

gen newspapers_news_often =0 if q12c!=. & q12c!=9
replace  newspapers_news_often =1 if q12c==4

gen interest_public_affairs = 0 if q13!=. & q13!=9
replace interest_public_affairs = 1 if q13==2 | q13==3
label var interest_public_affairs "Interested in public affairs"

gen very_int_publ_aff = 0 if q13!=. & q13!=9
replace very_int_publ_aff = 1 if q13==3
label var very_int_publ_aff "Very interested in public affairs"

*** Contact officials variables***
gen contact_LG_councilor = 0 if q25a!=. & q25a!=9
replace contact_LG_councilor = 1 if q25a== 1 | q25a==2 | q25a==3

gen contact_LG_councilor_often = 0 if q25a!=. & q25a!=9
replace contact_LG_councilor_often = 1 if q25a==2 | q25a==3

gen contact_MP =0 if q25b!=. & q25b!=9
replace contact_MP = 1 if q25b==1 | q25b==2 | q25b==3

gen contact_MP_often =0 if q25b!=. & q25b!=9
replace contact_MP_often = 1 if q25b==2 | q25b==3

gen contact_religious_leader =0 if q27a!=. & q27a!=9
replace contact_religious_leader = 1 if q27a==1 | q27a==2 | q27a==3

gen contact_traditional_ruler = 0 if q27b!=. & q27b!=9
replace contact_traditional_ruler =1 if q27b ==1 | q27b ==2 | q27b ==3

gen contact_comm_prob = (q26b ==1 | q28b ==1)
gen contact_priv_prob = (q26b ==2 | q28b ==2)
 

*** Democratic views variables ***
gen checks_balances =0 if q36!=. & q36!=9
replace checks_balances =1 if q36==1 |  q36==2

gen checks_balances_strong =0 if  q36!=. & q36!=9
replace checks_balances_strong =1 if q36==1

gen against_president_discretion =0 if q37!=. & q37!=9
replace against_president_discretion =1 if q37==3 |  q37==4

gen term_limits =0 if q38!=.  & q38!=9 
replace term_limits  =1 if q38 ==1 | q38 ==2

gen term_limits_strongly =0 if q38!=.  & q38!=9 
replace term_limits_strongly  =1 if q38 ==1

gen against_one_party_rule =0 if q29a!=. & q29a!=9
replace against_one_party_rule =1 if q29a == 1 | q29a==2

gen reject_military_rule =0 if q29b!=. & q29b!=9
replace reject_military_rule =1 if q29b == 1 | q29b==2

gen reject_one_man_rule =0 if q29c!=. & q29c!=9
replace reject_one_man_rule =1 if q29c == 1 | q29c==2

gen newspaper_free=0 if q20!=. &q20!=9
replace newspaper_free=1 if q20==3 | q20 ==4 

*** Trust on different institutions variables ***
gen trust_president =0 if q49a!=. & q49a!=9
replace trust_president =1  if q49a==2 | q49a==3

gen trust_national_assembly=0 if q49b!=. & q49b!=9
replace trust_national_assembly=1 if q49b==2  | q49b==3
 
gen trust_INEC=0 if q49c!=. & q49c!=9
replace trust_INEC=1 if q49c ==2 | q49c ==3

gen trust_LG_council=0 if q49d!=. & q49d!=9
replace trust_LG_council=1 if q49d==2 | q49d==3

gen trust_ruling_pary=0 if q49e!=. & q49e!=9
replace trust_ruling_pary=1 if q49e==2 | q49e ==3

gen trust_opposition_pary=0 if q49f!=. & q49f!=9
replace trust_opposition_pary=1  if q49f==2 | q49f==3

gen trust_traditional_leaders=0 if q49i!=. & q49i!=9
replace trust_traditional_leaders=1 if q49i==2 | q49i==3


*** Perceptions of government corruption and performance variables ***
gen handles_economy =0 if q57a!=. & q57a!=9
replace handles_economy =1 if q57a==3 | q57a==4
label var handles_economy "Government handles economy"

gen handles_employment=0  if q57c!=. & q57c!=9
replace handles_employment =1 if q57c==3 | q57c==4
label var handles_employment "Government handles employment"

gen handles_inflation=0 if q57d!=. & q57d!=9
replace handles_inflation =1 if q57d==3 | q57d==4
label var handles_inflation "Government handles inflation"

gen handles_inequality=0 if q57e!=. & q57e!=9
replace handles_inequality =1 if q57e==3 | q57e==4
label var handles_inequality "Government handles inequality"

gen handles_health=0 if q57g!=. & q57g!=9
replace handles_health =1 if q57g==3 | q57g==4
label var handles_health "Government handles health provision"

gen handles_education=0 if q57h!=. & q57h!=9
replace handles_education =1 if q57h==3 | q57h==4
label var handles_education "Government handles education provision"

gen handles_water=0  if q57i!=. & q57i!=9
replace handles_water =1 if q57i==3 | q57i==4
label var handles_water "Government handles water provisoon"

gen performance_president = 0 if q70a!=. & q70a!=9
replace performance_president = 1 if q70a==3 | q70a==4
label var performance_president "Approves President perfomance"

gen performance_mp  = 0 if q70b!=. & q70b!=9
replace performance_mp = 1 if q70b==3 | q70b==4
label var performance_mp "Approves MP perfomance"

gen performance_LG_councilor  = 0 if q70c!=. & q70c!=9
replace performance_LG_councilor  = 1 if q70c==3 | q70c==4
label var performance_LG_councilor "Approves LG councilor perfomance"

gen corruption_president = 0 if q50a !=. &  q50a !=9
replace corruption_president = 1 if q50a ==2 | q50a ==3
label var corruption_president "Very corrupt president office"

gen corruption_MP = 0 if q50b !=. &  q50b !=9
replace corruption_MP = 1 if q50b ==2 | q50b ==3
label var corruption_MP "Very corrupt MPs"

gen corruption_LG_councilors = 0 if q50c !=. &  q50c !=9
replace corruption_LG_councilors = 1 if q50c ==2 | q50c ==3
label var corruption_LG_councilors "Very corrupt LG councilors"


*** Identity variable***
gen ethnic_national = 0 if q83!=. & q83!=7 & q83!=9
replace ethnic_national = 1 if q83==1 | q83==2
label var ethnic_national "Feels ethnic identity as opposed to Nigerian"

*** Survey year for instrument construction ***
gen year_census = 2009

keep LGA State -  year_census

save Afrobarometer2009.dta, replace


******************************************************************************
***************                Afrobarometer 2007              ***************
******************************************************************************

use nig_r3_5_data.dta, clear

*** State variable for subsequent merge ***
gen State=""
replace State="Abia" if state==340
replace State="Adamawa" if state==341
replace State="Akwa Ibom" if state==342
replace State="Anambra" if state==343
replace State="Bauchi" if state==344
replace State="Bayelsa" if state==345
replace State="Benue" if state==346
replace State="Borno" if state==347
replace State="Cross River" if state==348
replace State="Delta" if state==349
replace State="Ebonyi" if state==350
replace State="Edo" if state==351
replace State="Ekiti" if state==352
replace State="Enugu" if state==353
replace State="Federal Capital Territory" if state==354
replace State="Gombe" if state==355
replace State="Imo" if state==356
replace State="Jigawa" if state==357
replace State="Kaduna" if state==358
replace State="Kano" if state==359
replace State="Katsina" if state==550
replace State="Kebbi" if state==551
replace State="Kogi" if state==552
replace State="Kwara" if state==553
replace State="Lagos" if state==554
replace State="Nassarawa" if state==555
replace State="Niger" if state==556
replace State="Ogun" if state==557
replace State="Ondo" if state==558
replace State="Osun" if state==559
replace State="Oyo" if state==560
replace State="Plateau" if state==561
replace State="Rivers" if state==562
replace State="Sokoto" if state==563
replace State="Taraba" if state==564
replace State="Yobe" if state==565
replace State="Zamfara" if state==566

*** Local government area variable for subsequent merge ***
rename district LGA
replace LGA="Umu-Nneochi" if  LGA=="Nneochi" & State=="Abia"
replace LGA="Nsit Atai" if  LGA=="Ekpe Atai" & State=="Akwa Ibom"
replace LGA="Ikot-Aba" if  LGA=="Ikot Abasi" & State=="Akwa Ibom"
replace LGA="Dunukofia" if  LGA=="Dunukofa" & State=="Anambra"
replace LGA="NnewiNort" if  LGA=="Nnewi North" & State=="Anambra"
replace LGA="Tafawa-B" if  LGA=="Tafawa Balewa" & State=="Bauchi"
replace LGA="Yenegoa" if  LGA=="Yenagoa" & State=="Bayelsa"
replace LGA="Maidugur" if  LGA=="Maiduguri Municipal" & State=="Borno"
replace LGA="Calabar" if  LGA=="Calabar Municipal" & State=="Cross River"
replace LGA="Yakurr" if  LGA=="Ugep South" & State=="Cross River"
replace LGA="." if  LGA=="Ogbagbere" & State=="Delta"
replace LGA="EthiopeE" if  LGA=="Okorobi Village" & State=="Delta"
replace LGA="Afikpo" if  LGA=="Afikpo North" & State=="Ebonyi"
replace LGA="Esan North" if  LGA=="Esan North East" & State=="Edo"
replace LGA="Ikpoba-Okha" if  LGA=="Ikpoba Okha" & State=="Edo"
replace LGA="Akoko-Ed" if  LGA=="Ososo" & State=="Edo"
replace LGA="EkitiSouth-West" if  LGA=="Ekiti South West" & State=="Ekiti"
replace LGA="EnuguSou" if  LGA=="Enugu South" & State=="Enugu"
replace LGA="Igbo-eze South" if  LGA=="Igbo Eze South" & State=="Enugu"
replace LGA="Uzo-Uwani" if  LGA=="Uzo Uwani" & State=="Enugu"
replace LGA="AbujaMun" if  LGA=="AMAC" & State=="Federal Capital Territory"
replace LGA="AbujaMun" if  LGA=="Sheraton Hotel" & State=="Federal Capital Territory"
replace LGA="Yamaltu" if  LGA=="Yamaltu/Deba" & State=="Gombe"
replace LGA="Ehime-Mb" if  LGA=="Ehime Mbano" & State=="Imo"
replace LGA="Ngor-Okp" if  LGA=="Ngor Okpala" & State=="Imo"
replace LGA="BirninKu" if  LGA=="Birnin Kudu" & State=="Jigawa"
replace LGA="MalamMad" if  LGA=="Malam Maduri" & State=="Jigawa"
replace LGA="Sule-Tan" if  LGA=="Sule Tankar Kar" & State=="Jigawa"
replace LGA="Birnin-G" if  LGA=="Birnin Gwari" & State=="Kaduna"
replace LGA="Chikun" if  LGA=="Kaduna Chikun" & State=="Kaduna"
replace LGA="Sabon-Ga" if  LGA=="Sabongari" & State=="Kaduna"
replace LGA="Fagge" if  LGA=="Faggee" & State=="Kano"
replace LGA="Kano" if  LGA=="Kano Municipal" & State=="Kano"
replace LGA="Nassaraw" if  LGA=="Nassarawa" & State=="Kano"
replace LGA="Tundun Wada" if  LGA=="Tudun Wada" & State=="Kano"
replace LGA="Katsina (K)" if  LGA=="Katsina" & State=="Katsina"
replace LGA="Igalamela-Odolu" if  LGA=="Igala Mela" & State=="Kogi"
replace LGA="Olamabor" if  LGA=="Olamaboro" & State=="Kogi"
replace LGA="IlorinWe" if  LGA=="Ilorin West" & State=="Kwara"
replace LGA="Badagary" if  LGA=="Badagry" & State=="Lagos"
replace LGA="Ifako/Ijaye" if  LGA=="Ifako Ijaiye" & State=="Lagos"
replace LGA="LagosIsland" if  LGA=="Lagos Island" & State=="Lagos"
replace LGA="Mainland" if  LGA=="Lagos Mainland" & State=="Lagos"
replace LGA="Chanchaga" if  LGA=="Minna" & State=="Niger"
replace LGA="AbeokutaNorth" if  LGA=="Abeokuta North" & State=="Ogun"
replace LGA="Abeokuta South" if  LGA=="Abeokuta North & South" & State=="Ogun"
replace LGA="EgbadoSouth" if  LGA=="Egbado South" & State=="Ogun"
replace LGA="Ijebu North-East" if  LGA=="Ijebu North East" & State=="Ogun"
replace LGA="IjebuOde" if  LGA=="Ijebu Ode" & State=="Ogun"
replace LGA="Obafemi-Owode" if  LGA=="Obafemi Owode" & State=="Ogun"
replace LGA="AkokoNorthWest" if  LGA=="Akoko North West" & State=="Ondo"
replace LGA="Akoko South-East" if  LGA=="Akoko South East" & State=="Ondo"
replace LGA="IlajeEseodo" if  LGA=="Ilaje" & State=="Ondo"
replace LGA="Okitipupa" if  LGA=="Okiti Pupa (Ikale)" & State=="Ondo"
replace LGA="Ayedaade" if  LGA=="Ayedade" & State=="Osun"
replace LGA="IfeCentral" if  LGA=="Ife Central" & State=="Osun"
replace LGA="IbadanNorth" if  LGA=="Ibadan North" & State=="Oyo"
replace LGA="IbadanNorth-East" if  LGA=="Ibadan North East" & State=="Oyo"
replace LGA="IbadanNorth-West" if  LGA=="Ibadan North West" & State=="Oyo"
replace LGA="IbadanSouth-West" if  LGA=="Ibadan South West" & State=="Oyo"
replace LGA="Qua'anpa" if  LGA=="Quanpan" & State=="Plateau"
replace LGA="Andoni/O" if  LGA=="Andoni" & State=="Rivers"
replace LGA="Obio/Akp" if  LGA=="Obio/Akpor" & State=="Rivers"
replace LGA="Ogba/Egbe" if  LGA=="Ogba/Egbem" & State=="Rivers"
replace LGA="Ardo-Kola" if  LGA=="Ardo Kola" & State=="Taraba"
replace LGA="Karim-La" if  LGA=="Karim/Lamido" & State=="Taraba"
replace LGA="Kaura-Na" if  LGA=="Kaura Namoda" & State=="Zamfara"

*** Urban / rural variable for control ***
gen urban_rural = ""
replace urban_rural = "urban" if urbrur==1
replace urban_rural = "rural" if   urbrur==2

*** Age variable for instrument and control ***
gen age = q1 
label var age "Age of respondent"
replace age=. if age==999

*** Gender variable for control ***
gen gender="" if q110!=. & q110!=9
replace gender="male" if q110==1
replace gender="female" if q110==2

*** Education variables for treatment ***
gen primary_school_inc = 0 if q101!=. & q101!=99
replace primary_school_inc = 1 if q101>=2 & q101<=9
gen primary_school = 0 if q101!=. & q101!=99
replace primary_school = 1 if q101>=3 & q101<=9
gen secondary_school_inc = 0 if q101!=. & q101!=99
replace secondary_school_inc = 1 if q101>=4 & q101<=9
gen secondary_school = 0 if q101!=. & q101!=99
replace secondary_school = 1 if q101>=5 & q101<=9
gen college=  0 if q101!=. & q101!=99
replace college = 1 if q101>=8 & q101<=9

*** Religion variable for control ***
gen religion=""
replace religion="None" if q102==0 | q102==9
replace religion="Muslim" if q102==340 | q102==341 | q102==342
replace religion="Christian" if q102==2 | q102==3 | q102==4 | q102==10
replace religion="Traditional" if q102==5  | q102==6
replace religion="Other" if q102==7  | q102==13  | q102==14 | q102==995 | q102==999

*** Language variable for heterogenous effects ***
gen language="" if q4!=. | q4!=999
replace language="english" if q4==1
replace language="hausa" if q4==340
replace language="igbo" if q4==341
replace language="yoruba" if q4==342
replace language="efik" if q4==344
replace language="ebira" if q4==345
replace language="fulani" if q4==346
replace language="ibibio" if q4==348
replace language="kanuri" if q4==349
replace language="tiv" if q4==350
replace language="nupe" if q4==351
replace language="ijaw" if q4==352
replace language="edo" if q4==353
replace language="igala" if q4==354
replace language="urhobo" if q4==355
replace language="idoma" if q4==356
replace language="ikwere" if q4==358
replace language="ron" if q4==551
replace language="boki" if q4==556
replace language="esan" if q4==558
replace language="ekpeye" if q4==560
replace language="ogoni" if q4==567
replace language="mbembe" if q4==568
replace language="itsekiri" if q4==580
replace language="nembe" if q4==583
replace language="eggon" if q4==584
replace language="bade/badewa" if q4==585
replace language="kataf atyp" if q4==586
replace language="obubra" if q4==587
replace language="ugep" if q4==588
replace language="lunguda" if q4==589
replace language="ankwai" if q4==590
replace language="babar/babare" if q4==595
replace language="karekare" if q4==597
replace language="others" if q4==995

*** Tribe variable for heterogenous effects ***
gen tribe="" if q97!=998 & q97!=999
replace tribe="hausa" if q97==340
replace tribe="igbo" if q97==341
replace tribe="yoruba" if q97==342
replace tribe="efik" if q97==344
replace tribe="ebira" if q97==345
replace tribe="fulani" if q97==346
replace tribe="isoko" if q97==347
replace tribe="ibibio" if q97==348
replace tribe="kanuri" if q97==349
replace tribe="tiv" if q97==350
replace tribe="nupe" if q97==351
replace tribe="ijaw" if q97==352
replace tribe="edo" if q97==353
replace tribe="igala" if q97==354
replace tribe="urhobo" if q97==355
replace tribe="idoma" if q97==356
replace tribe="bassa" if q97==357
replace tribe="ikwere" if q97==358
replace tribe="awori" if q97==550
replace tribe="tapa" if q97==551
replace tribe="kalabari" if q97==553
replace tribe="birom" if q97==554
replace tribe="shuwa-arab" if q97==555
replace tribe="jukun" if q97==556
replace tribe="gwari" if q97==558
replace tribe="igede" if q97==562
replace tribe="ogoni" if q97==565
replace tribe="okirika" if q97==568
replace tribe="nigerian" if q97==990
replace tribe="others" if q97==995


*** Community participation variables *** 
gen rel_group_assoc = 0 if q16a!=. &  q16a !=9
replace rel_group_assoc = 1 if q16a==1 | q16a==2 |  q16a ==3

gen rel_group_assoc_active = 0 if q16a!=. &  q16a !=9
replace rel_group_assoc_active = 1 if q16a==2 |  q16a ==3

gen member_association =0 if (q16b!=. & q16b!=9) | (q16c!=. & q16c!=9) | (q16d!=. & q16d!=9)
replace member_association =1 if q16b==1 | q16b==2 | q16b==3 | q16c==1 | q16c==2 | q16c==3 | q16d==1 | q16d==2 | q16d==3

gen member_assoc_active =0 if (q16b!=. & q16b!=9) | (q16c!=. & q16c!=9) | (q16d!=. & q16d!=9)
replace member_assoc_active =1 if q16b==2 | q16b==3 | q16c==2 | q16c==3 | q16d==2 | q16d==3

gen att_community_meeting = 0 if q17a!=. & q17a!=9
replace att_community_meeting =1 if q17a==2 | q17a==3 | q17a==4


*** Political variables *** 
gen discuss_politics = 0 if q15!=. & q15!=9
replace discuss_politics =1 if q15==1 | q15==2

gen discuss_politics_often = 0 if q15!=. & q15!=9
replace discuss_politics_often =1 if q15==2

gen raise_issue = 0 if q17b!=. & q17b!=9
replace raise_issue =1 if q17b==2 | q17b==3 | q17b==4

gen att_demonstration = 0 if q17c!=. & q17c!=9
replace att_demonstration =1 if q17c==2 | q17c==3 | q17c==4 


*** Media and public affairs variables***
gen radio_news_rare =0 if q13a!=. & q13a!=9
replace  radio_news_rare =1 if q13a==1 | q13a==2 | q13a==3 | q13a==4

gen tv_news_rare =0 if q13b!=. & q13b!=9
replace  tv_news_rare =1 if q13b==1 | q13b==2 | q13b==3 | q13b==4

gen newspapers_news_rare =0 if q13c!=. & q13c!=9
replace  newspapers_news_rare =1 if q13c==1 | q13c==2 | q13c==3 | q13c==4

gen radio_news =0 if q13a!=. & q13a!=9
replace  radio_news =1 if q13a==2 | q13a==3 | q13a==4

gen tv_news =0 if q13b!=. & q13b!=9
replace  tv_news =1 if q13b==2 | q13b==3 | q13b==4

gen newspapers_news =0 if q13c!=. & q13c!=9
replace  newspapers_news =1 if q13c==2 | q13c==3 | q13c==4

gen radio_news_sev =0 if q13a!=. & q13a!=9
replace  radio_news_sev =1 if q13a==3 | q13a==4

gen tv_news_sev =0 if q13b!=. & q13b!=9
replace  tv_news_sev =1 if q13b==3 | q13b==4

gen newspapers_news_sev =0 if q13c!=. & q13c!=9
replace  newspapers_news_sev =1 if q13c==3 | q13c==4

gen radio_news_often =0 if q13a!=. & q13a!=9
replace  radio_news_often =1 if q13a==4

gen tv_news_often =0 if q13b!=. & q13b!=9
replace  tv_news_often =1 if q13b==4

gen newspapers_news_often =0 if q13c!=. & q13c!=9
replace  newspapers_news_often =1 if q13c==4

gen interest_public_affairs = 0 if q14!=. & q14!=9
replace interest_public_affairs = 1 if q14==2 | q14==3
label var interest_public_affairs "Interested in public affairs"

gen very_int_publ_aff = 0 if q14!=. & q14!=9
replace very_int_publ_aff = 1 if q14==3
label var very_int_publ_aff "Very interested in public affairs"


*** Contact officials variables***
gen contact_LG_councilor = 0 if q18a!=. & q18a!=9
replace contact_LG_councilor = 1 if q18a== 1 | q18a==2 | q18a==3

gen contact_LG_councilor_often = 0 if q18a!=. & q18a!=9
replace contact_LG_councilor_often = 1 if q18a==2 | q18a==3

gen contact_MP =0 if q18b!=. & q18b!=9
replace contact_MP = 1 if q18b==1 | q18b==2 | q18b==3

gen contact_MP_often =0 if q18b!=. & q18b!=9
replace contact_MP_often = 1 if q18b==2 | q18b==3

gen contact_religious_leader =0 if q18e!=. & q18e!=9
replace contact_religious_leader = 1 if q18e==1 | q18e==2 | q18e==3

gen contact_traditional_ruler = 0 if q18f!=. & q18f!=9
replace contact_traditional_ruler =1 if q18f ==1 | q18f ==2 | q18f ==3


 
*** Democratic views variables ***
gen checks_balances =0 if q23!=. & q23!=9
replace checks_balances =1 if q23==1 |  q23==2

gen checks_balances_strong =0 if  q23!=. & q23!=9
replace checks_balances_strong =1 if q23== 1

gen against_president_discretion =0 if q24!=. & q24!=9
replace against_president_discretion =1 if q24==3 |  q24==4

gen against_one_party_rule =0 if q19a!=. & q19a!=9
replace against_one_party_rule =1 if q19a == 1 | q19a==2

gen reject_military_rule =0 if q19b!=. & q19b!=9
replace reject_military_rule =1 if q19b == 1 | q19b==2

gen reject_one_man_rule =0 if q19c!=. & q19c!=9
replace reject_one_man_rule =1 if q19c == 1 | q19c==2


*** Violence justified variables***
gen violence_not_ok = 0 if q53!=9
replace violence_not_ok = 1 if q53==1 | q53==2

gen violence_not_ok_str = 0 if q53!=9
replace violence_not_ok_str = 1 if q53==1 


*** Trust on different institutions variables ***
gen trust_president =0 if q34a!=. & q34a!=9
replace trust_president =1  if q34a==2 | q34a==3

gen trust_national_assembly=0 if q34b!=. & q34b!=9
replace trust_national_assembly=1 if q34b==2  | q34b==3
 
gen trust_INEC=0 if q34c!=. & q34c!=9
replace trust_INEC=1 if q34c ==2 | q34c ==3

gen trust_LG_council=0 if q34d!=. & q34d!=9
replace trust_LG_council=1 if q34d==2 | q34d==3

gen trust_ruling_pary=0 if q34e!=. & q34e!=9
replace trust_ruling_pary=1 if q34e==2 | q34e ==3

gen trust_opposition_pary=0 if q34f!=. & q34f!=9
replace trust_opposition_pary=1  if q34f==2 | q34f==3


*** Perceptions of government corruption and performance variables ***
gen handles_economy =0 if q37a!=. & q37a!=9
replace handles_economy =1 if q37a==3 | q37a==4
label var handles_economy "Government handles economy"

gen handles_employment=0  if q37b!=. & q37b!=9
replace handles_employment =1 if q37b==3 | q37b==4
label var handles_employment "Government handles employment"

gen handles_inflation=0 if q37c!=. & q37c!=9
replace handles_inflation =1 if q37c==3 | q37c==4
label var handles_inflation "Government handles inflation"

gen handles_inequality=0 if q37d!=. & q37d!=9
replace handles_inequality =1 if q37d==3 | q37d==4
label var handles_inequality "Government handles inequality"

gen inequality_improvement=0 if q12c!=. & q12c!=9
replace inequality_improvement =1 if q12c==4 | q12c==5
label var inequality_improvement "Inequality has gotten better"

gen handles_health=0 if q37f!=. & q37f!=9
replace handles_health =1 if q37f==3 | q37f==4
label var handles_health "Government handles health provision"

gen handles_education=0 if q37g!=. & q37g!=9
replace handles_education =1 if q37g==3 | q37g==4
label var handles_education "Government handles education provision"

gen handles_water=0  if q37h!=. & q37h!=9
replace handles_water =1 if q37h==3 | q37h==4
label var handles_water "Government handles water provisoon"

gen performance_president = 0 if q55a!=. & q55a!=9
replace performance_president = 1 if q55a==3 | q55a==4
label var performance_president "Approves President perfomance"

gen performance_mp  = 0 if q55b!=. & q55b!=9
replace performance_mp = 1 if q55b==3 | q55b==4
label var performance_mp "Approves MP perfomance"

gen performance_LG_councilor  = 0 if q55c!=. & q55c!=9
replace performance_LG_councilor  = 1 if q55c==3 | q55c==4
label var performance_LG_councilor "Approves LG councilor perfomance"

gen corruption_president = 0 if q35a !=. &  q35a !=9
replace corruption_president = 1 if q35a ==2 | q35a ==3
label var corruption_president "Very corrupt president office"

gen corruption_MP = 0 if q35b !=. &  q35b !=9
replace corruption_MP = 1 if q35b ==2 | q35b ==3
label var corruption_MP "Very corrupt MPs"

gen corruption_LG_councilors = 0 if q35c !=. &  q35c !=9
replace corruption_LG_councilors = 1 if q35c ==2 | q35c ==3
label var corruption_LG_councilors "Very corrupt LG councilors"


*** Identity variables***
gen ethnic_national = 0 if q100!=. & q100!=7 & q100!=9
replace ethnic_national = 1 if q100==1 | q100==2
label var ethnic_national "Feels ethnic identity as opposed to Nigerian"

gen nigeria_united = 0 if q96!=9 
replace nigeria_united = 1 if q96==1 | q96==2

*** Survey year for instrument construction ***
gen year_census = 2007

keep LGA State  -  year_census

save Afrobarometer2007.dta, replace

******************************************************************************
***************                Afrobarometer 2005              ***************
******************************************************************************

use nig_r3_data.dta, clear

*** State variable for subsequent merge ***
rename region state
gen State=""
replace State="Abia" if state==349
replace State="Adamawa" if state==553
replace State="Akwa Ibom" if state==350
replace State="Anambra" if state==347
replace State="Bauchi" if state==551
replace State="Bayelsa" if state==351
replace State="Benue" if state==556
replace State="Borno" if state==552
replace State="Cross River" if state==352
replace State="Delta" if state==353
replace State="Edo" if state==354
replace State="Ekiti" if state==345
replace State="Enugu" if state==346
replace State="Federal Capital Territory" if state==560
replace State="Imo" if state==348
replace State="Kaduna" if state==358
replace State="Kano" if state==356
replace State="Katsina" if state==359
replace State="Kogi" if state==557
replace State="Kwara" if state==558
replace State="Lagos" if state==340
replace State="Niger" if state==559
replace State="Ogun" if state==341
replace State="Ondo" if state==344
replace State="Osun" if state==343
replace State="Oyo" if state==342
replace State="Plateau" if state==555
replace State="Rivers" if state==355
replace State="Sokoto" if state==357
replace State="Taraba" if state==554
replace State="Zamfara" if state==550

*** Local government area variable for subsequent merge ***
rename district LGA
replace LGA="Girie" if LGA=="Gire" & State=="Adamawa"
replace LGA="Girie" if LGA=="Girei" & State=="Adamawa"
replace LGA="Essien-U" if LGA=="Essien Udiun" & State=="Akwa Ibom"
replace LGA="EtimEkpo" if LGA=="Etim Ekpo" & State=="Akwa Ibom"
replace LGA="Ikot-Ekp" if LGA=="Ikot - Ekpene" & State=="Akwa Ibom"
replace LGA="AwkaNort" if LGA=="Akwa North" & State=="Anambra"
replace LGA="AwkaSout" if LGA=="Awka South" & State=="Anambra"
replace LGA="Idemili North" if LGA=="Idemilli North" & State=="Anambra"
replace LGA="NnewiNort" if LGA=="Nnewi North" & State=="Anambra"
replace LGA="Gamjuwa" if LGA=="Ganjuwa" & State=="Bauchi"
replace LGA="Kolokuma/Opokuma" if LGA=="Kolokuma Opokuma" & State=="Bayelsa"
replace LGA="Yenegoa" if LGA=="Yenagoa Nothern" & State=="Bayelsa"
replace LGA="Yenegoa" if LGA=="Yenagoa/Northern" & State=="Bayelsa"
replace LGA="Ushongo" if LGA=="Ushongu" & State=="Benue"
replace LGA="Maidugur" if LGA=="Maiduguri" & State=="Borno"
replace LGA="YTC" if LGA=="YTC" & State=="Borno"
replace LGA="Akamkpa" if LGA=="Akampka" & State=="Cross River"
replace LGA="Calabar" if LGA=="Calabar Municipal" & State=="Cross River"
replace LGA="Yakurr" if LGA=="Ugep North" & State=="Cross River"
replace LGA="Yakurr" if LGA=="Ugep South (ABI)" & State=="Cross River"
replace LGA="Yala Cross" if LGA=="Yala" & State=="Cross River"
replace LGA="EthiopeE" if LGA=="Ethiope East" & State=="Delta"
replace LGA="Oredo Edo" if LGA=="Oredo" & State=="Edo"
replace LGA="Orhionmw" if LGA=="Orihionmwon" & State=="Edo"
replace LGA="Gboyin" if LGA=="Aiyekire (Gbonyi)" & State=="Ekiti"
replace LGA="Emure/Ise/Orun" if LGA=="Emure" & State=="Ekiti"
replace LGA="EnuguSou" if LGA=="Enugu South" & State=="Enugu"
replace LGA="Igbo-eze South" if LGA=="Igbo - Eze South" & State=="Enugu"
replace LGA="Isi-Uzo" if LGA=="Isi - Uzo" & State=="Enugu"
replace LGA="AbujaMun" if LGA=="Abuja Municipal" & State=="Federal Capital Territory"
replace LGA="Ahizu-Mb" if LGA=="Abiazu Mbaise" & State=="Imo"
replace LGA="Ezinihit" if LGA=="Ezinihitte" & State=="Imo"
replace LGA="Unuimo" if LGA=="Umume" & State=="Imo"
replace LGA="Birnin-G" if LGA=="Birni Gwari" & State=="Kaduna"
replace LGA="Kachia" if LGA=="Kachila" & State=="Kaduna"
replace LGA="Kudan" if LGA=="Kuban" & State=="Kaduna"
replace LGA="Sabon-Ga" if LGA=="Sabon-Gari" & State=="Kaduna"
replace LGA="DawakinT" if LGA=="Dawakin Tofa" & State=="Kano"
replace LGA="Kano" if LGA=="Kano Municipal" & State=="Kano"
replace LGA="Nassaraw" if LGA=="Nassarawa" & State=="Kano"
replace LGA="Tundun Wada" if LGA=="Tudun - wada" & State=="Kano"
replace LGA="Ungogo" if LGA=="Ugogo" & State=="Kano"
replace LGA="Katsina (K)" if LGA=="Katsina" & State=="Katsina"
replace LGA="Mai'Adua" if LGA=="Maiduwa" & State=="Katsina"
replace LGA="Kabba/Bu" if LGA=="Kabba Bunu" & State=="Kogi"
replace LGA="Kotonkar" if LGA=="Kogi" & State=="Kogi"
replace LGA="Lokoja" if LGA=="Kotokaife Lokoja" & State=="Kogi"
replace LGA="Mopa-Muro" if LGA=="Mopa" & State=="Kogi"
replace LGA="Olamabor" if LGA=="Olamaboro" & State=="Kogi"
replace LGA="IlorinWe" if LGA=="Ilorin West" & State=="Kwara"
replace LGA="Isin" if LGA=="Isi" & State=="Kwara"
replace LGA="Badagary" if LGA=="Badagry" & State=="Lagos"
replace LGA="Mainland" if LGA=="Lagos Mainland" & State=="Lagos"
replace LGA="Oshodi/Isolo" if LGA=="Oshodi Isolo" & State=="Lagos"
replace LGA="Kontogur" if LGA=="Katangora" & State=="Niger"
replace LGA="Lavun" if LGA=="Lawun" & State=="Niger"
replace LGA="Mariga" if LGA=="Manga" & State=="Niger"
replace LGA="Rijau" if LGA=="Rijan" & State=="Niger"
replace LGA="AdoOdo/Ota" if LGA=="Ado - Ota" & State=="Ogun"
replace LGA="EgbadoNorth" if LGA=="Egbado North" & State=="Ogun"
replace LGA="IjebuOde" if LGA=="Ijebu - Ode" & State=="Ogun"
replace LGA="Obafemi-Owode" if LGA=="Obafemi/Owode" & State=="Ogun"
replace LGA="OgunWaterside" if LGA=="Ogun Waterside" & State=="Ogun"
replace LGA="Akoko North-East" if LGA=="Akoko North East" & State=="Ondo"
replace LGA="Ese-Odo" if LGA=="Ese Odo" & State=="Ondo"
replace LGA="Okitipupa" if LGA=="Okiti Pupa" & State=="Ondo"
replace LGA="Okitipupa" if LGA=="Okiti Pupa (Ikale)" & State=="Ondo"
replace LGA="IfeCentral" if LGA=="Ife Central" & State=="Osun"
replace LGA="IbadanNorth-East" if LGA=="Ibadan North East" & State=="Oyo"
replace LGA="IbadanSouth-East" if LGA=="Ibadan South East" & State=="Oyo"
replace LGA="IbadanSouth-West" if LGA=="Ibadan South West" & State=="Oyo"
replace LGA="Ori-Ire" if LGA=="Orire" & State=="Oyo"
replace LGA="Abua/Odu" if LGA=="Abual/Odual" & State=="Rivers"
replace LGA="Ahoada West" if LGA=="Ahoda West" & State=="Rivers"
replace LGA="Akukutor" if LGA=="Akuku Toru" & State=="Rivers"
replace LGA="Ikwerre" if LGA=="Ikwere" & State=="Rivers"
replace LGA="Obio/Akp" if LGA=="Obio/Akpor" & State=="Rivers"
replace LGA="Ogba/Egbe" if LGA=="Ogba/Egbema/Ndoni" & State=="Rivers"
replace LGA="Ogba/Egbe" if LGA=="Ogba/Egbene Ndoni" & State=="Rivers"
replace LGA="Okrika" if LGA=="Okirika" & State=="Rivers"
replace LGA="Port Harcourt" if LGA=="Port - Harcourt" & State=="Rivers"
replace LGA="Gwadabaw" if LGA=="Gwadabawa" & State=="Sokoto"
replace LGA="Tangazar" if LGA=="Tangaza" & State=="Sokoto"
replace LGA="Karim-La" if LGA=="Karim Lamido" & State=="Taraba"
replace LGA="Sardauna" if LGA=="Saraduna" & State=="Taraba"
replace LGA="Kaura-Na" if LGA=="Namoda" & State=="Zamfara"
replace LGA="Zurmi" if LGA=="Zurmi-Kaura" & State=="Zamfara"

*** Urban / rural variable for control ***
gen urban_rural = ""
replace urban_rural = "urban" if urbrur==1
replace urban_rural = "rural" if   urbrur==2

*** Age variable for instrument and control ***
gen age = q1
label var age "Age of respondent"
replace age=. if age==999

*** Gender variable for control ***
gen gender="" if q101!=. & q101!=9
replace gender="male" if q101==1
replace gender="female" if q101==2

*** Education variables for treatment ***
gen primary_school_inc = 0 if q90!=. & q90!=99
replace primary_school_inc = 1 if q90>=2 & q90<=9
gen primary_school = 0 if q90!=. & q90!=99
replace primary_school = 1 if q90>=3 & q90<=9
gen secondary_school_inc = 0 if q90!=. & q90!=99
replace secondary_school_inc = 1 if q90>=4 & q90<=9
gen secondary_school = 0 if q90!=. & q90!=99
replace secondary_school = 1 if q90>=5 & q90<=9
gen college=  0 if q90!=. & q90!=99
replace college = 1 if q90>=8 & q90<=9

*** Religion variable for control ***
gen religion=""
replace religion="None" if q91==0 | q91==8 | q91==9
replace religion="Muslim" if q91==11 | q91==12 | q91==342
replace religion="Christian" if q91==2 | q91==3 | q91==4 | q91==10
replace religion="Traditional" if q91==5  | q91==6
replace religion="Other" if q91==13  | q91==14 | q91==999


*** Language variable for heterogenous effects ***
gen language="" if q3!=. | q3!=999
replace language="english" if q3==1
replace language="hausa" if q3==340
replace language="igbo" if q3==341
replace language="yoruba" if q3==342
replace language="pidgin english" if q3==343
replace language="efik" if q3==344
replace language="ebira" if q3==345
replace language="fulani" if q3==346
replace language="isoko" if q3==347
replace language="ibibio" if q3==348
replace language="kanuri" if q3==349
replace language="tiv" if q3==350
replace language="nupe" if q3==351
replace language="ijaw" if q3==352
replace language="edo" if q3==353
replace language="igala" if q3==354
replace language="urhobo" if q3==355
replace language="idoma" if q3==356
replace language="bassa" if q3==357
replace language="ikwere" if q3==358
replace language="ukwani" if q3==359
replace language="anang" if q3==550
replace language="kadara" if q3==553
replace language="bahumono" if q3==555
replace language="boki" if q3==556
replace language="yakurr" if q3==557
replace language="esan" if q3==558
replace language="ekpeye" if q3==560
replace language="igede" if q3==563
replace language="taroh" if q3==565
replace language="korro" if q3==566
replace language="ogoni" if q3==567
replace language="mbembe" if q3==568
replace language="sayawa" if q3==569
replace language="itsekiri" if q3==580
replace language="others" if q3==995


*** Tribe variable for heterogenous effects ***
gen tribe="" if q79!=999
replace tribe="hausa" if q79==340
replace tribe="igbo" if q79==341
replace tribe="yoruba" if q79==342
replace tribe="efik" if q79==344
replace tribe="ebira" if q79==345
replace tribe="fulani" if q79==346
replace tribe="isoko" if q79==347
replace tribe="ibibio" if q79==348
replace tribe="kanuri" if q79==349
replace tribe="tiv" if q79==350
replace tribe="nupe" if q79==351
replace tribe="ijaw" if q79==352
replace tribe="edo" if q79==353
replace tribe="igala" if q79==354
replace tribe="urhobo" if q79==355
replace tribe="idoma" if q79==356
replace tribe="itsekiri" if q79==357
replace tribe="ikwere" if q79==358
replace tribe="awori" if q79==550
replace tribe="tapa" if q79==551
replace tribe="kalabari" if q79==553
replace tribe="shuwa-arab" if q79==555
replace tribe="gwari" if q79==558
replace tribe="anang" if q79==559
replace tribe="ekoi" if q79==560
replace tribe="ukwani" if q79==561
replace tribe="igede" if q79==562
replace tribe="ekpeye" if q79==563
replace tribe="taroh" if q79==564
replace tribe="ogoni" if q79==565
replace tribe="sayawa" if q79==566
replace tribe="okpella" if q79==567
replace tribe="okirika" if q79==568
replace tribe="others" if q79==995



*** Community participation variables *** 
gen rel_group_assoc = 0 if q28a!=. &  q28a !=9
replace rel_group_assoc = 1 if q28a==1 | q28a==2 |  q28a ==3

gen rel_group_assoc_active = 0 if q28a!=. &  q28a !=9
replace rel_group_assoc_active = 1 if q28a==2 |  q28a ==3

gen member_association =0 if (q28b!=. & q28b!=9) | (q28c!=. & q28c!=9) | (q28d!=. & q28d!=9)
replace member_association =1 if q28b==1 | q28b==2 | q28b==3 | q28c==1 | q28c==2 | q28c==3 | q28d==1 | q28d==2 | q28d==3

gen member_assoc_active =0 if (q28b!=. & q28b!=9) | (q28c!=. & q28c!=9) | (q28d!=. & q28d!=9)
replace member_assoc_active =1 if q28b==2 | q28b==3 | q28c==2 | q28c==3 | q28d==2 | q28d==3

gen att_community_meeting = 0 if q31a!=. & q31a!=9
replace att_community_meeting =1 if q31a==2 | q31a==3 | q31a==4


*** Political variables *** 
gen discuss_politics = 0 if q17!=. & q17!=9
replace discuss_politics =1 if q17==1 | q17==2

gen discuss_politics_often = 0 if q17!=. & q17!=9
replace discuss_politics_often =1 if q17==2

gen name_state_house = (q43a2 ==3) 
gen name_lg_councillor = (q43b2 ==3) 
gen name_vice_pres = (q43c2 ==3) 

gen raise_issue = 0 if q31b!=. & q31b!=9
replace raise_issue =1 if q31b==2 | q31b==3 | q31b==4

gen att_demonstration = 0 if q31c!=. & q31c!=9
replace att_demonstration =1 if q31c==2 | q31c==3 | q31c==4 

gen close_political_party=0 if q85!=. & q85!=8 & q85!=9
replace close_political_party=1 if q85==1

gen registered_voter = 0 if q29!=. & q29!=9
replace registered_voter = 1 if q29==1 

gen voted = 0 if q30!=. & q30!=9
replace voted = 1 if q30==1 


*** Media and public affairs variables***
gen radio_news_rare =0 if q15a!=. & q15a!=9
replace  radio_news_rare =1 if q15a==1 | q15a==2 | q15a==3 | q15a==4

gen tv_news_rare =0 if q15b!=. & q15b!=9
replace  tv_news_rare =1 if q15b==1 | q15b==2 | q15b==3 | q15b==4

gen newspapers_news_rare =0 if q15c!=. & q15c!=9
replace  newspapers_news_rare =1 if q15c==1 | q15c==2 | q15c==3 | q15c==4

gen radio_news =0 if q15a!=. & q15a!=9
replace  radio_news =1 if q15a==2 | q15a==3 | q15a==4

gen tv_news =0 if q15b!=. & q15b!=9
replace  tv_news =1 if q15b==2 | q15b==3 | q15b==4

gen newspapers_news =0 if q15c!=. & q15c!=9
replace  newspapers_news =1 if q15c==2 | q15c==3 | q15c==4

gen radio_news_sev =0 if q15a!=. & q15a!=9
replace  radio_news_sev =1 if q15a==3 | q15a==4

gen tv_news_sev =0 if q15b!=. & q15b!=9
replace  tv_news_sev =1 if q15b==3 | q15b==4

gen newspapers_news_sev =0 if q15c!=. & q15c!=9
replace  newspapers_news_sev =1 if q15c==3 | q15c==4

gen radio_news_often =0 if q15a!=. & q15a!=9
replace  radio_news_often =1 if q15a==4

gen tv_news_often =0 if q15b!=. & q15b!=9
replace  tv_news_often =1 if q15b==4

gen newspapers_news_often =0 if q15c!=. & q15c!=9
replace  newspapers_news_often =1 if q15c==4

gen interest_public_affairs = 0 if q16!=. & q16!=9
replace interest_public_affairs = 1 if q16==2 | q16==3
label var interest_public_affairs "Interested in public affairs"

gen very_int_publ_aff = 0 if q16!=. & q16!=9
replace very_int_publ_aff = 1 if q16==3
label var very_int_publ_aff "Very interested in public affairs"


*** Contact officials variables***
gen contact_LG_councilor = 0 if q32a!=. & q32a!=9
replace contact_LG_councilor = 1 if q32a== 1 | q32a==2 | q32a==3

gen contact_LG_councilor_often = 0 if q32a!=. & q32a!=9
replace contact_LG_councilor_often = 1 if q32a==2 | q32a==3

gen contact_MP =0 if q32b!=. & q32b!=9
replace contact_MP = 1 if q32b==1 | q32b==2 | q32b==3

gen contact_MP_often =0 if q32b!=. & q32b!=9
replace contact_MP_often = 1 if q32b==2 | q32b==3

gen contact_religious_leader =0 if q32e!=. & q32e!=9
replace contact_religious_leader = 1 if q32e==1 | q32e==2 | q32e==3

gen contact_traditional_ruler = 0 if q32f!=. & q32f!=9
replace contact_traditional_ruler =1 if q32f ==1 | q32f ==2 | q32f ==3

gen contact_comm_prob = (q33==2)
gen contact_priv_prob = (q33==1 | q33==3 | q33==4)
 

*** Democratic views variables ***
gen checks_balances =0 if q40!=. & q40!=9
replace checks_balances =1 if q40==1 |  q40==2

gen checks_balances_strong =0 if  q40!=. & q40!=9
replace checks_balances_strong =1 if q40==1 

gen against_president_discretion =0 if q41!=. & q41!=9
replace against_president_discretion =1 if q41==3 |  q41==4

gen against_one_party_rule =0 if q36a!=. & q36a!=9
replace against_one_party_rule =1 if q36a == 1 | q36a==2

gen reject_military_rule =0 if q36b!=. & q36b!=9
replace reject_military_rule =1 if q36b == 1 | q36b==2

gen reject_one_man_rule =0 if q36c!=. & q36c!=9
replace reject_one_man_rule =1 if q36c == 1 | q36c==2

gen against_govt_ban_org=0 if q25!=. &q25!=9
replace against_govt_ban_org=1 if q25==3| q25==4

gen newspaper_free=0 if q26!=. &q26!=9
replace newspaper_free=1 if q26==3 | q26 ==4 


*** Violence justified variables***
gen violence_not_ok = 0 if q51!=9
replace violence_not_ok = 1 if q51==1 | q51==2

gen violence_not_ok_str = 0 if q51!=9
replace violence_not_ok_str = 1 if q51==1


*** Trust on different institutions variables ***
gen trust_president =0 if q55a!=. & q55a!=9
replace trust_president =1  if q55a==2 | q55a==3

gen trust_national_assembly=0 if q55b!=. & q55b!=9
replace trust_national_assembly=1 if q55b==2  | q55b==3
 
gen trust_INEC=0 if q55c!=. & q55c!=9
replace trust_INEC=1 if q55c ==2 | q55c ==3

gen trust_LG_council=0 if q55d!=. & q55d!=9
replace trust_LG_council=1 if q55d==2 | q55d==3

gen trust_ruling_pary=0 if q55e!=. & q55e!=9
replace trust_ruling_pary=1 if q55e==2 | q55e ==3

gen trust_opposition_pary=0 if q55f!=. & q55f!=9
replace trust_opposition_pary=1  if q55f==2 | q55f==3


*** Perceptions of government corruption and performance variables ***
gen handles_economy =0 if q65a!=. & q65a!=9
replace handles_economy =1 if q65a==3 | q65a==4
label var handles_economy "Government handles economy"

gen handles_employment=0  if q65b!=. & q65b!=9
replace handles_employment =1 if q65b==3 | q65b==4
label var handles_employment "Government handles employment"

gen handles_inflation=0 if q65c!=. & q65c!=9
replace handles_inflation =1 if q65c==3 | q65c==4
label var handles_inflation "Government handles inflation"

gen handles_inequality=0 if q65d!=. & q65d!=9
replace handles_inequality =1 if q65d==3 | q65d==4
label var handles_inequality "Government handles inequality"

gen inequality_improvement=0 if q14c!=. & q14c!=9
replace inequality_improvement =1 if q14c==4 | q14c==5
label var inequality_improvement "Inequality has gotten better"

gen handles_health=0 if q65f!=. & q65f!=9
replace handles_health =1 if q65f==3 | q65f==4
label var handles_health "Government handles health provision"

gen handles_education=0 if q65g!=. & q65g!=9
replace handles_education =1 if q65g==3 | q65g==4
label var handles_education "Government handles education provision"

gen handles_water=0  if q65h!=. & q65h!=9
replace handles_water =1 if q65h==3 | q65h==4
label var handles_water "Government handles water provisoon"

gen performance_president = 0 if q68a!=. & q68a!=9
replace performance_president = 1 if q68a==3 | q68a==4
label var performance_president "Approves President perfomance"

gen performance_mp  = 0 if q68b!=. & q68b!=9
replace performance_mp = 1 if q68b==3 | q68b==4
label var performance_mp "Approves MP perfomance"

gen performance_LG_councilor  = 0 if q68c!=. & q68c!=9
replace performance_LG_councilor  = 1 if q68c==3 | q68c==4
label var performance_LG_councilor "Approves LG councilor perfomance"

gen corruption_president = 0 if q56a !=. &  q56a !=9
replace corruption_president = 1 if q56a ==2 | q56a ==3
label var corruption_president "Very corrupt president office"

gen corruption_MP = 0 if q56b !=. &  q56b !=9
replace corruption_MP = 1 if q56b ==2 | q56b ==3
label var corruption_MP "Very corrupt MPs"

gen corruption_LG_councilors = 0 if q56c !=. &  q56c !=9
replace corruption_LG_councilors = 1 if q56c ==2 | q56c ==3
label var corruption_LG_councilors "Very corrupt LG councilors"


*** Identity variable***
gen ethnic_national = 0 if q82!=. & q82!=7 & q82!=9
replace ethnic_national = 1 if q82==1 | q82==2
label var ethnic_national "Feels ethnic identity as opposed to Nigerian"

*** Survey year for instrument construction ***
gen year_census = 2005

keep LGA State -  year_census

save Afrobarometer2005.dta, replace


******************************************************************************
***************                Afrobarometer 2003              ***************
******************************************************************************

use nig_r2_data.dta, clear


*** State variable for subsequent merge ***
gen State = region2 
replace State="Abia" if State=="Abia"
replace State="Adamawa" if State=="Adamawa"
replace State="Akwa Ibom" if State=="Akwa Ibom"
replace State="Anambra" if State=="Anambra"
replace State="Bauchi" if State=="Bauchi"
replace State="Bayelsa" if State=="Bayelsa"
replace State="Benue" if State=="Benue"
replace State="Borno" if State=="Borno"
replace State="Cross River" if State=="Cross-River"
replace State="Delta" if State=="Delta"
replace State="Edo" if State=="Edo"
replace State="Ekiti" if State=="Ekiti"
replace State="Enugu" if State=="Enugu"
replace State="Federal Capital Territory" if State=="Abuja"
replace State="Kaduna" if State=="Kaduna"
replace State="Kano" if State=="Kano"
replace State="Katsina" if State=="Katsina"
replace State="Kogi" if State=="Kogi"
replace State="Kwara" if State=="Kwara"
replace State="Lagos" if State=="Lagos"
replace State="Niger" if State=="Niger"
replace State="Ogun" if State=="Ogun"
replace State="Ondo" if State=="Ondo"
replace State="Osun" if State=="Osun"
replace State="Oyo" if State=="Oyo"
replace State="Plateau" if State=="Plateau"
replace State="Rivers" if State=="Rivers"
replace State="Sokoto" if State=="Sokoto"
replace State="Zamfara" if State=="Zamfara"
*** Secial recoding because of creation of Jigawa
rename division LGA
replace State="Jigawa" if State=="Zamfara" & LGA=="Kiyawa"
replace State="Jigawa" if State=="Zamfara" & LGA=="Magami"

*** Local government area variable for subsequent merge ***
replace LGA="Ohafia Abia" if LGA=="Ohafia" & State=="Abia"
replace LGA="Girie" if LGA=="Gwei" & State=="Adamawa"
replace LGA="Ikot-Ekp" if LGA=="Ikot Ekpene" & State=="Akwa Ibom"
replace LGA="NnewiNort" if LGA=="Nnewi North" & State=="Anambra"
replace LGA="NnewiSou" if LGA=="Nnewi South" & State=="Anambra"
replace LGA="OrumbaSo" if LGA=="Orunba South" & State=="Anambra"
replace LGA="Itas/Gad" if LGA=="Itas/Gadau" & State=="Bauchi"
replace LGA="Yenegoa" if LGA=="Besini/Okodia/Zamara" & State=="Bayelsa"
replace LGA="Yenegoa" if LGA=="Yenogoa/Northern" & State=="Bayelsa"
replace LGA="Maidugur" if LGA=="Maiduguri" & State=="Borno"
replace LGA="Akamkpa" if LGA=="Akampka" & State=="Cross River"
replace LGA="Ika North" if LGA=="Ika North East" & State=="Delta"
replace LGA="Ika North" if LGA=="Ika North West" & State=="Delta"
replace LGA="Oredo Edo" if LGA=="Oredo" & State=="Edo"
replace LGA="Orhionmw" if LGA=="Orhionmwon" & State=="Edo"
replace LGA="Emure/Ise/Orun" if LGA=="Emure" & State=="Ekiti"
replace LGA="Ikere" if LGA=="Ikere Ekiti" & State=="Ekiti"
replace LGA="Awgu" if LGA=="Agwa" & State=="Enugu"
replace LGA="Aninri" if LGA=="Aniri" & State=="Enugu"
replace LGA="EnuguSou" if LGA=="Enugu West" & State=="Enugu"
replace LGA="Igbo-eze North" if LGA=="Igbo Eze North" & State=="Enugu"
replace LGA="Oji-River" if LGA=="Oji River" & State=="Enugu"
replace LGA="Nkanu East" if LGA=="Ukanu East" & State=="Enugu"
replace LGA="AbujaMun" if LGA=="Abuja Municipal" & State=="Federal Capital Territory"
replace LGA="Birnin-G" if LGA=="Birni-Gwari" & State=="Kaduna"
replace LGA="Sabon-Ga" if LGA=="Sabon-Gari" & State=="Kaduna"
replace LGA="Kano" if LGA=="Kano Municipality" & State=="Kano"
replace LGA="Nassaraw" if LGA=="Nassarawa" & State=="Kano"
replace LGA="Baure" if LGA=="Banle" & State=="Katsina"
replace LGA="Danmusa" if LGA=="Darama" & State=="Katsina"
replace LGA="Katsina (K)" if LGA=="Katsina" & State=="Katsina"
replace LGA="Mai'Adua" if LGA=="Maiadua" & State=="Katsina"
replace LGA="Malumfashi" if LGA=="Mulamfashi" & State=="Katsina"
replace LGA="Zango" if LGA=="Zango/Daura" & State=="Katsina"
replace LGA="Kabba/Bu" if LGA=="Kabba-Bunu" & State=="Kogi"
replace LGA="Kotonkar" if LGA=="Kogi" & State=="Kogi"
replace LGA="IlorinWe" if LGA=="Ilorin West" & State=="Kwara"
replace LGA="LagosIsland" if LGA=="Lagos Island" & State=="Lagos"
replace LGA="Mainland" if LGA=="Lagos Mainland" & State=="Lagos"
replace LGA="Chanchaga" if LGA=="Chachanga" & State=="Niger"
replace LGA="Wushishi" if LGA=="Wushigi" & State=="Niger"
replace LGA="EgbadoNorth" if LGA=="Egbado North" & State=="Ogun"
replace LGA="EgbadoSouth" if LGA=="Egbado South" & State=="Ogun"
replace LGA="Ijebu North-East" if LGA=="Ijebu North" & State=="Ogun"
replace LGA="IjebuOde" if LGA=="Ijebu Ode" & State=="Ogun"
replace LGA="Obafemi-Owode" if LGA=="Obafemi/Owode" & State=="Ogun"
replace LGA="OgunWaterside" if LGA=="Ogun Waterside" & State=="Ogun"
replace LGA="IleOluji/Okeigbo" if LGA=="Ile Oluji" & State=="Ondo"
replace LGA="IfeCentral" if LGA=="Ife Central" & State=="Osun"
replace LGA="IbadanNorth-East" if LGA=="Ibadan North East" & State=="Oyo"
replace LGA="IbadanSouth-West" if LGA=="Ibadan South West" & State=="Oyo"
replace LGA="Abua/Odu" if LGA=="Abual/Odual" & State=="Rivers"
replace LGA="Obio/Akp" if LGA=="Obuo/Akpor" & State=="Rivers"
replace LGA="Port Harcourt" if LGA=="Port-Harcourt" & State=="Rivers"
replace LGA="Gwadabaw" if LGA=="Gwadabawa" & State=="Sokoto"
replace LGA="Tambawal" if LGA=="Tambuwal" & State=="Sokoto"
replace LGA="Kiyawa" if LGA=="Kiyawa" & State=="Jigawa"
replace LGA="Yankwashi" if LGA=="Magami" & State=="Jigawa"

*** Urban / rural variable for control ***
gen urban_rural = ""
replace urban_rural = "urban" if urbrur==1
replace urban_rural = "rural" if   urbrur==2

*** Age variable for instrument and control ***
gen age = q80 
label var age "Age of respondent"
replace age=. if age==999


*** Gender variable for control ***
gen gender="" if q96!=. & q96!=9
replace gender="female" if q96==1
replace gender="male" if q96==2

*** Education variables for treatment ***
gen primary_school_inc = 0 if q84!=. & q84!=99
replace primary_school_inc = 1 if q84>=2 & q84<=9
gen primary_school = 0 if q84!=. & q84!=99
replace primary_school = 1 if q84>=3 & q84<=9
gen secondary_school_inc = 0 if q84!=. & q84!=99
replace secondary_school_inc = 1 if q84>=4 & q84<=9
gen secondary_school = 0 if q84!=. & q84!=99
replace secondary_school = 1 if q84>=5 & q84<=9
gen college=  0 if q84!=. & q84!=99
replace college = 1 if q84>=8 & q84<=9


*** Religion variable for control ***
gen religion=""
replace religion="None" if q85a==0 | q85a==9
replace religion="Muslim" if q85a==1
replace religion="Christian" if q85a==2 | q85a==3 | q85a==4 | q85a==10
replace religion="Traditional" if q85a==5  | q85a==6
replace religion="Other" if q85a==7  | q85a==11 | q85a==12  | q85a==260

*** Language variable for heterogenous effects ***
gen language="" if q83!=. & q83!=999
replace language="hausa" if q83==260
replace language="yoruba" if q83==261
replace language="igbo" if q83==262
replace language="tiv" if q83==263
replace language="ijaw" if q83==264
replace language="kanuri" if q83==265
replace language="nupe" if q83==266
replace language="ibibio" if q83==267
replace language="efik" if q83==268
replace language="edo" if q83==269
replace language="igala/idoma" if q83==270
replace language="urhobo" if q83==271
replace language="ebira" if q83==272
replace language="fulani" if q83==273
replace language="isoko" if q83==274
replace language="kalabari" if q83==275
replace language="ikewere" if q83==276
replace language="gwari" if q83==277
replace language="sidawa" if q83==278
replace language="pidgin english" if q83==279
replace language="berom" if q83==800
replace language="chip" if q83==801
replace language="jarawa" if q83==802
replace language="gbagyi" if q83==805
replace language="jaba" if q83==806
replace language="esan" if q83==807
replace language="mgas" if q83==809
replace language="other" if q83==995


*** Community participation variables *** 
gen rel_group_assoc = 0 if q24a!=. &  q24a !=9
replace rel_group_assoc = 1 if q24a==1 | q24a==2 |  q24a ==3

gen rel_group_assoc_active = 0 if q24a!=. &  q24a !=9
replace rel_group_assoc_active = 1 if q24a==2 |  q24a ==3

gen member_association =0 if (q24b!=. & q24b!=9) | (q24c!=. & q24c!=9) | (q24d!=. & q24d!=9)
replace member_association =1 if q24b==1 | q24b==2 | q24b==3 | q24c==1 | q24c==2 | q24c==3 | q24d==1 | q24d==2 | q24d==3

gen member_assoc_active =0 if (q24b!=. & q24b!=9) | (q24c!=. & q24c!=9) | (q24d!=. & q24d!=9)
replace member_assoc_active =1 if q24b==2 | q24b==3 | q24c==2 | q24c==3 | q24d==2 | q24d==3

gen att_community_meeting = 0 if q25b!=. & q25b!=9
replace att_community_meeting =1 if q25b==2 | q25b==3 | q25b==4


*** Political variables *** 
gen discuss_politics = 0 if q25a!=. & q25a!=9
replace discuss_politics =1 if q25a==3 | q25a==4

gen discuss_politics_often = 0 if q25a!=. & q25a!=9
replace discuss_politics_often =1 if q25a==4

gen raise_issue = 0 if q25c!=. & q25c!=9
replace raise_issue =1 if q25c==2 | q25c==3 | q25c==4

gen att_demonstration = 0 if (q25d!=. & q25d!=9) 
replace att_demonstration =1 if q25d==2 | q25d==3 | q25d==4 

gen close_political_party=0 if q87a!=. & q87a!=998 & q87a!=999
replace close_political_party=1 if q87a>= 260 & q87a<=268

gen close_PDP=0 if q87a!=. & q87a!=998 & q87a!=999
replace close_PDP=1 if q87a== 260

gen registered_voter = 0 if q79anig!=. & q79anig!=9
replace registered_voter = 1 if q79anig==1 

gen voted_president = 0 if q79cnig!=. & q79cnig!=9
replace voted_president = 1 if q79cnig==1 
gen voted_mp = 0 if q79dnig!=. & q79dnig!=9
replace voted_mp = 1 if q79dnig==1 
gen voted_president_or_mp = 0 if voted_president!=. | voted_mp!=.
replace voted_president_or_mp = 1 if voted_president==1 | voted_mp==1
gen voted_individual_party = 0 if q79fnig!=. & q79fnig!=9
replace voted_individual_party = 1 if q79fnig==1 | q79fnig==2 
tab voted_individual_party voted_president_or_mp
gen voted = voted_individual_party
drop voted_president voted_president_or_mp voted_mp voted_individual_party

*** Media and public affairs variables***
gen radio_news_rare =0 if q26a!=. & q26a!=9
replace  radio_news_rare =1 if q26a==1 | q26a==2 | q26a==3 | q26a==4

gen tv_news_rare =0 if q26b!=. & q26b!=9
replace  tv_news_rare =1 if q26b==1 | q26b==2 | q26b==3 | q26b==4

gen newspapers_news_rare =0 if q26c!=. & q26c!=9
replace  newspapers_news_rare =1 if q26c==1 | q26c==2 | q26c==3 | q26c==4

gen radio_news =0 if q26a!=. & q26a!=9
replace  radio_news =1 if q26a==2 | q26a==3 | q26a==4

gen tv_news =0 if q26b!=. & q26b!=9
replace  tv_news =1 if q26b==2 | q26b==3 | q26b==4

gen newspapers_news =0 if q26c!=. & q26c!=9
replace  newspapers_news =1 if q26c==2 | q26c==3 | q26c==4

gen radio_news_sev =0 if q26a!=. & q26a!=9
replace  radio_news_sev =1 if q26a==3 | q26a==4

gen tv_news_sev =0 if q26b!=. & q26b!=9
replace  tv_news_sev =1 if q26b==3 | q26b==4

gen newspapers_news_sev =0 if q26c!=. & q26c!=9
replace  newspapers_news_sev =1 if q26c==3 | q26c==4

gen radio_news_often =0 if q26a!=. & q26a!=9
replace  radio_news_often =1 if q26a==4

gen tv_news_often =0 if q26b!=. & q26b!=9
replace  tv_news_often =1 if q26b==4

gen newspapers_news_often =0 if q26c!=. & q26c!=9
replace  newspapers_news_often =1 if q26c==4

gen interest_public_affairs = 0 if q27!=. & q27!=9
replace interest_public_affairs = 1 if q27==1 | q27==2
label var interest_public_affairs "Interested in public affairs"

gen very_int_publ_aff = 0 if q27!=. & q27!=9
replace very_int_publ_aff = 1 if q27==2
label var very_int_publ_aff "Very interested in public affairs"


*** Contact officials variables***
gen contact_LG_councilor = 0 if q29a!=. & q29a!=9
replace contact_LG_councilor = 1 if q29a== 2 | q29a==3 | q29a==4

gen contact_LG_councilor_often = 0 if q29a!=. & q29a!=9
replace contact_LG_councilor_often = 1 if q29a==3 | q29a==4

gen contact_MP =0 if q29b!=. & q29b!=9
replace contact_MP = 1 if q29b==2 | q29b==3 | q29b==4

gen contact_MP_often =0 if q29b!=. & q29b!=9
replace contact_MP_often = 1 if q29b==3 | q29b==4

gen contact_religious_leader =0 if q29e!=. & q29e!=9
replace contact_religious_leader = 1 if q29e==2 | q29e==3 | q29e==4

gen contact_traditional_ruler = 0 if q29f!=. & q29f!=9
replace contact_traditional_ruler =1 if q29f ==2 | q29f ==3 | q29f ==4

 
*** Democratic views variables ***
gen term_limits =0 if q32!=.  & q32!=9 
replace term_limits  =1 if q32 ==3 | q32 ==4

gen term_limits_strongly =0 if q32!=.  & q32!=9 
replace term_limits_strongly  =1 if q32 ==4

gen checks_balances =0 if q33!=. & q33!=9
replace checks_balances =1 if q33==1 |  q33==2

gen checks_balances_strong =0 if q33!=. & q33!=9
replace checks_balances_strong =1 if q33==1 

gen against_one_party_rule =0 if q35a!=. & q35a!=9
replace against_one_party_rule =1 if q35a == 1 | q35a==2

gen reject_military_rule =0 if q35c!=. & q35c!=9
replace reject_military_rule =1 if q35c == 1 | q35c==2

gen reject_one_man_rule =0 if q35d!=. & q35d!=9
replace reject_one_man_rule =1 if q35d == 1 | q35d==2

*** Violence justified variables***
gen violence_not_ok = 0 if q76!=9
replace violence_not_ok = 1 if q76==1 | q76==2

gen violence_not_ok_str = 0 if q76!=9
replace violence_not_ok_str = 1 if q76==1


*** Trust on different institutions variables ***
gen trust_president =0 if q43a!=. & q43a!=9
replace trust_president =1  if q43a==2 | q43a==3

gen trust_national_assembly=0 if q43b!=. & q43b!=9
replace trust_national_assembly=1 if q43b==2  | q43b==3
 
gen trust_INEC=0 if q43c!=. & q43c!=9
replace trust_INEC=1 if q43c ==2 | q43c ==3

gen trust_LG_council=0 if q43e!=. & q43e!=9
replace trust_LG_council=1 if q43e==2 | q43e==3

gen trust_ruling_pary=0 if q43f!=. & q43f!=9
replace trust_ruling_pary=1 if q43f==2 | q43f ==3

gen trust_opposition_pary=0 if q43g!=. & q43g!=9
replace trust_opposition_pary=1  if q43g==2 | q43g==3

gen trust_traditional_leaders=0 if q43k!=. & q43k!=9
replace trust_traditional_leaders=1 if q43k==2 | q43k==3


*** Perceptions of government corruption and performance variables ***
gen handles_economy =0 if q45a!=. & q45a!=9
replace handles_economy =1 if q45a==3 | q45a==4
label var handles_economy "Government handles economy"

gen handles_employment=0  if q45b!=. & q45b!=9
replace handles_employment =1 if q45b==3 | q45b==4
label var handles_employment "Government handles employment"

gen handles_inflation=0 if q45c!=. & q45c!=9
replace handles_inflation =1 if q45c==3 | q45c==4
label var handles_inflation "Government handles inflation"

gen handles_inequality=0 if q45d!=. & q45d!=9
replace handles_inequality =1 if q45d==3 | q45d==4
label var handles_inequality "Government handles inequality"

gen inequality_improvement=0 if q22d!=. & q22d!=9
replace inequality_improvement =1 if q22d==4 | q22d==5
label var inequality_improvement "Inequality has gotten better"

gen handles_health=0 if q45f!=. & q45f!=9
replace handles_health =1 if q45f==3 | q45f==4
label var handles_health "Government handles health provision"

gen handles_education=0 if q45g!=. & q45g!=9
replace handles_education =1 if q45g==3 | q45g==4
label var handles_education "Government handles education provision"

gen handles_water=0  if q45h!=. & q45h!=9
replace handles_water =1 if q45h==3 | q45h==4
label var handles_water "Government handles water provisoon"

gen performance_president = 0 if q48a!=. & q48a!=9
replace performance_president = 1 if q48a==3 | q48a==4
label var performance_president "Approves President perfomance"

gen performance_mp  = 0 if q48b!=. & q48b!=9
replace performance_mp = 1 if q48b==3 | q48b==4
label var performance_mp "Approves MP perfomance"

gen performance_LG_councilor  = 0 if q48d!=. & q48d!=9
replace performance_LG_councilor  = 1 if q48d==3 | q48d==4
label var performance_LG_councilor "Approves LG councilor perfomance"

gen corruption_president = 0 if q51a !=. &  q51a !=9
replace corruption_president = 1 if q51a ==2 | q51a ==3
label var corruption_president "Very corrup president office"


*** Identity variable***
gen ethnic_national = 0 if q57!=. & q57!=7 & q57!=9
replace ethnic_national = 1 if q57==1
label var ethnic_national "Feels ethnic identity as opposed to Nigerian"

gen nigeria_united = 0 if q77!=9 
replace nigeria_united = 1 if q77==1 | q77==2

*** Survey year for instrument construction ***
gen year_census = 2003

keep LGA State -  year_census

save Afrobarometer2003.dta, replace


******************************************************************************
***************                Afrobarometer 2001              ***************
******************************************************************************

use nig_r1_5_data.dta, clear

*** State variable for subsequent merge ***
gen State =""
replace State="Abia" if state==11
replace State="Adamawa" if state==26
replace State="Akwa Ibom" if state==14
replace State="Anambra" if state==12
replace State="Bauchi" if state==27
replace State="Bayelsa" if state==10
replace State="Benue" if state==29
replace State="Borno" if state==28
replace State="Cross River" if state==23
replace State="Delta" if state==7
replace State="Edo" if state==8
replace State="Ekiti" if state==5
replace State="Enugu" if state==13
replace State="Federal Capital Territory" if state==16
replace State="Kaduna" if state==18
replace State="Kano" if state==19
replace State="Katsina" if state==17
replace State="Kogi" if state==24
replace State="Kwara" if state==22
replace State="Lagos" if state==1
replace State="Niger" if state==25
replace State="Ogun" if state==2
replace State="Ondo" if state==3
replace State="Osun" if state==6
replace State="Oyo" if state==4
replace State="Plateau" if state==15
replace State="Rivers" if state==9
replace State="Sokoto" if state==20
replace State="Zamfara" if state==21

*** Local government area variable for subsequent merge ***
gen LGA=""
replace LGA="Ikeja" if lga==1 & State=="Lagos"
replace LGA="Kosofe" if lga==2 & State=="Lagos"
replace LGA="Mainland" if lga==3 & State=="Lagos"
replace LGA="Eti-Osa" if lga==4 & State=="Lagos"
replace LGA="Surulere" if lga==5 & State=="Lagos"
replace LGA="Mushin" if lga==6 & State=="Lagos"
replace LGA="Alimosho" if lga==7 & State=="Lagos"
replace LGA="Ojo" if lga==8 & State=="Lagos"
replace LGA="Ibeju/Lekki" if lga==9 & State=="Lagos"
replace LGA="Epe" if lga==10 & State=="Lagos"
replace LGA="Abeokuta South" if lga==16 & State=="Ogun"
replace LGA="Ijebu North-East" if lga==17 & State=="Ogun"
replace LGA="IjebuOde" if lga==18 & State=="Ogun"
replace LGA="OgunWaterside" if lga==19 & State=="Ogun"
replace LGA="Akure South" if lga==25 & State=="Ondo"
replace LGA="Ondo West" if lga==26 & State=="Ondo"
replace LGA="IlajeEseodo" if lga==27 & State=="Ondo"
replace LGA="Ifedore" if lga==28 & State=="Ondo"
replace LGA="AkokoNorthWest" if lga==29 & State=="Ondo"
replace LGA="Odigbo" if lga==30 & State=="Ondo"
replace LGA="Ikpoba-Okha" if lga==36 & State=="Edo"
replace LGA="Etsako West" if lga==37 & State=="Edo"
replace LGA="OviaNort" if lga==38 & State=="Edo"
replace LGA="Enugu North" if lga==44 & State=="Enugu"
replace LGA="Awgu" if lga==45 & State=="Enugu"
replace LGA="Ezeagu" if lga==46 & State=="Enugu"
replace LGA="Awgu" if lga==47 & State=="Enugu"
replace LGA="Nsukka" if lga==48 & State=="Enugu"
replace LGA="NnewiSou" if lga==54 & State=="Anambra"
replace LGA="Onitsha South" if lga==55 & State=="Anambra"
replace LGA="Njikoka" if lga==56 & State=="Anambra"
replace LGA="Ihiala" if lga==57 & State=="Anambra"
replace LGA="Oyi" if lga==58 & State=="Anambra"
replace LGA="Ughelli North" if lga==64 & State=="Delta"
replace LGA="Warri South" if lga==65 & State=="Delta"
replace LGA="Isoko North" if lga==66 & State=="Delta"
replace LGA="Burutu" if lga==67 & State=="Delta"
replace LGA="Ndokwa East" if lga==68 & State=="Delta"
replace LGA="Sapele" if lga==70 & State=="Delta"
replace LGA="Ika South" if lga==71 & State=="Delta"
replace LGA="Yola North" if lga==77 & State=="Adamawa"
replace LGA="Ganye" if lga==78 & State=="Adamawa"
replace LGA="Girie" if lga==79 & State=="Adamawa"
replace LGA="Maiha" if lga==80 & State=="Adamawa"
replace LGA="AbujaMun" if lga==86 & State=="Federal Capital Territory"
replace LGA="Bauchi" if lga==92 & State=="Bauchi"
replace LGA="Darazo" if lga==93 & State=="Bauchi"
replace LGA="Toro" if lga==94 & State=="Bauchi"
replace LGA="Warji" if lga==95 & State=="Bauchi"
replace LGA="Alkaleri" if lga==96 & State=="Bauchi"
replace LGA="Katagum" if lga==97 & State=="Bauchi"
replace LGA="Shira" if lga==98 & State=="Bauchi"
replace LGA="Kaduna South" if lga==104 & State=="Kaduna"
replace LGA="Zaria" if lga==106 & State=="Kaduna"
replace LGA="Sabon-Ga" if lga==107 & State=="Kaduna"
replace LGA="Ikara" if lga==108 & State=="Kaduna"
replace LGA="ZangonKa" if lga==110 & State=="Kaduna"
replace LGA="Aba South" if lga==117 & State=="Abia"
replace LGA="Aba North" if lga==118 & State=="Abia"
replace LGA="Umuahia South" if lga==119 & State=="Abia"
replace LGA="Osisioma Ngwa" if lga==120 & State=="Abia"
replace LGA="Isiala Ngwa North" if lga==121 & State=="Abia"
replace LGA="Ikwuano" if lga==122 & State=="Abia"
replace LGA="Ukwa West" if lga==123 & State=="Abia"
replace LGA="Bende" if lga==124 & State=="Abia"
replace LGA="Moba" if lga==130 & State=="Ekiti"
replace LGA="Moba" if lga==131 & State=="Ekiti"
replace LGA="Gboyin" if lga==132 & State=="Ekiti"
replace LGA="IbadanSouth-East" if lga==138 & State=="Oyo"
replace LGA="IbadanNorth-East" if lga==139 & State=="Oyo"
replace LGA="IbadanSouth-West" if lga==140 & State=="Oyo"
replace LGA="Oyo West" if lga==141 & State=="Oyo"
replace LGA="Afijio" if lga==142 & State=="Oyo"
replace LGA="Ona-Ara" if lga==143 & State=="Oyo"
replace LGA="Saki East" if lga==144 & State=="Oyo"
replace LGA="Jos North" if lga==150 & State=="Plateau"
replace LGA="Jos North" if lga==151 & State=="Plateau"
replace LGA="Pankshin" if lga==152 & State=="Plateau"
replace LGA="Langtang North" if lga==153 & State=="Plateau"
replace LGA="Jos South" if lga==154 & State=="Plateau"
replace LGA="Shendam" if lga==155 & State=="Plateau"
replace LGA="Nsit Atai" if lga==161 & State=="Akwa Ibom"
replace LGA="Mkpat Enin" if lga==162 & State=="Akwa Ibom"
replace LGA="Eket" if lga==163 & State=="Akwa Ibom"
replace LGA="EtimEkpo" if lga==164 & State=="Akwa Ibom"
replace LGA="Gboko" if lga==170 & State=="Benue"
replace LGA="Ushongo" if lga==171 & State=="Benue"
replace LGA="Gboko" if lga==172 & State=="Benue"
replace LGA="Kwande" if lga==173 & State=="Benue"
replace LGA="Gwer West" if lga==174 & State=="Benue"
replace LGA="Ilorin South" if lga==180 & State=="Kwara"
replace LGA="IlorinWe" if lga==181 & State=="Kwara"
replace LGA="Edu" if lga==182 & State=="Kwara"
replace LGA="Ifelodun" if lga==183 & State=="Kwara"
replace LGA="Oyun" if lga==184 & State=="Kwara"
replace LGA="IfeCentral" if lga==190 & State=="Osun"
replace LGA="Ife East" if lga==191 & State=="Osun"
replace LGA="Lokoja" if lga==197 & State=="Kogi"
replace LGA="Kotonkar" if lga==198 & State=="Kogi"
replace LGA="Ankpa" if lga==199 & State=="Kogi"
replace LGA="Bassa" if lga==200 & State=="Kogi"
replace LGA="Dandume" if lga==206 & State=="Katsina"
replace LGA="Rimi" if lga==207 & State=="Katsina"
replace LGA="Malumfashi" if lga==208 & State=="Katsina"
replace LGA="Rimi" if lga==209 & State=="Katsina"
replace LGA="Dutsin-M" if lga==210 & State=="Katsina"
replace LGA="Safana" if lga==211 & State=="Katsina"
replace LGA="Bindawa" if lga==212 & State=="Katsina"
replace LGA="Bakori" if lga==213 & State=="Katsina"
replace LGA="Gusau" if lga==219 & State=="Zamfara"
replace LGA="Bungudu" if lga==220 & State=="Zamfara"
replace LGA="Zurmi" if lga==221 & State=="Zamfara"
replace LGA="Birnin-Magaji/Kiyaw" if lga==222 & State=="Zamfara"
replace LGA="Tsafe" if lga==223 & State=="Zamfara"
replace LGA="Maru" if lga==224 & State=="Zamfara"
replace LGA="Maidugur" if lga==230 & State=="Borno"
replace LGA="Askira/U" if lga==231 & State=="Borno"
replace LGA="Shani" if lga==232 & State=="Borno"
replace LGA="Ngala" if lga==233 & State=="Borno"
replace LGA="Port Harcourt" if lga==241 & State=="Rivers"
replace LGA="Ogu/Bolo" if lga==242 & State=="Rivers"
replace LGA="Obio/Akp" if lga==243 & State=="Rivers"
replace LGA="Khana" if lga==244 & State=="Rivers"
replace LGA="Bonny" if lga==245 & State=="Rivers"
replace LGA="Akukutor" if lga==246 & State=="Rivers"
replace LGA="Nassaraw" if lga==252 & State=="Kano"
replace LGA="Tarauni" if lga==253 & State=="Kano"
replace LGA="DawakinK" if lga==254 & State=="Kano"
replace LGA="Ajingi" if lga==255 & State=="Kano"
replace LGA="Rogo" if lga==256 & State=="Kano"
replace LGA="Dala" if lga==257 & State=="Kano"
replace LGA="Gwale" if lga==258 & State=="Kano"
replace LGA="Lapai" if lga==264 & State=="Niger"
replace LGA="Wushishi" if lga==265 & State=="Niger"
replace LGA="Mariga" if lga==266 & State=="Niger"
replace LGA="Agwara" if lga==267 & State=="Niger"
replace LGA="Dange-Shuni" if lga==272 & State=="Sokoto"
replace LGA="Dange-Shuni" if lga==273 & State=="Sokoto"
replace LGA="Yabo" if lga==274 & State=="Sokoto"
replace LGA="Isa" if lga==275 & State=="Sokoto"
replace LGA="Tangazar" if lga==276 & State=="Sokoto"
replace LGA="Rabah" if lga==277 & State=="Sokoto"
replace LGA="Gwadabaw" if lga==278 & State=="Sokoto"
replace LGA="Gada" if lga==279 & State=="Sokoto"
replace LGA="Calabar" if lga==284 & State=="Cross River"
replace LGA="Obudu" if lga==285 & State=="Cross River"
replace LGA="Ogoja" if lga==286 & State=="Cross River"
replace LGA="Yakurr" if lga==287 & State=="Cross River"
replace LGA="Yenegoa" if lga==293 & State=="Bayelsa"
replace LGA="Ekeremor" if lga==294 & State=="Bayelsa"
replace LGA="Kolokuma/Opokuma" if lga==295 & State=="Bayelsa"
replace LGA="Ogbia" if lga==296 & State=="Bayelsa"
replace LGA="Southern Ijaw" if lga==297 & State=="Bayelsa"
replace LGA="Nembe" if lga==298 & State=="Bayelsa"
replace LGA="Sagbama" if lga==299 & State=="Bayelsa"

*** Urban / rural variable for control ***
gen urban_rural = ""
replace urban_rural = "urban" if urbrur==1
replace urban_rural = "rural" if   urbrur==2

*** Age variable for instrument and control ***
gen age = q80 
label var age "Age of respondent"
replace age=. if age==999

*** Gender variable for control ***
gen gender="" if q96!=. &q96!=9
replace gender="female" if q96==1
replace gender="male" if q96==2

*** Education variables for treatment ***
gen primary_school_inc = 0 if q84!=. & q84!=99
replace primary_school_inc = 1 if q84>=2 & q84<=9
gen primary_school = 0 if q84!=. & q84!=99
replace primary_school = 1 if q84>=3 & q84<=9
gen secondary_school_inc = 0 if q84!=. & q84!=99
replace secondary_school_inc = 1 if q84>=4 & q84<=9
gen secondary_school = 0 if q84!=. & q84!=99
replace secondary_school = 1 if q84>=5 & q84<=9
gen college=  0 if q84!=. & q84!=99
replace college = 1 if q84>=8 & q84<=9

*** Religion variable for control ***
gen religion=""
replace religion="None" if q85==0 | q85==9
replace religion="Muslim" if q85==1
replace religion="Christian" if q85==2 | q85==3 | q85==4
replace religion="Traditional" if q85==5  | q85==6

*** Language variable for heterogenous effects ***
gen language="" if q83!=. &q83!=999
replace language="hausa" if q83==260
replace language="yoruba" if q83==261
replace language="igbo" if q83==262
replace language="tiv" if q83==263
replace language="ijaw" if q83==264
replace language="kanuri" if q83==265
replace language="nupe" if q83==266
replace language="ibibio" if q83==267
replace language="efik" if q83==268
replace language="edo" if q83==269
replace language="igala/idoma" if q83==270
replace language="urhobo" if q83==271
replace language="ebira" if q83==272
replace language="fulani" if q83==273
replace language="isoko" if q83==274
replace language="other" if q83==995


*** Community participation variables *** 
gen rel_group_assoc = 0 if q24a!=. &  q24a !=9
replace rel_group_assoc = 1 if q24a==1 | q24a==2 |  q24a ==3

gen rel_group_assoc_active = 0 if q24a!=. &  q24a !=9
replace rel_group_assoc_active = 1 if q24a==2 |  q24a ==3

gen member_association =0 if (q24b!=. & q24b!=9) | (q24c!=. & q24c!=9) | (q24d!=. & q24d!=9)
replace member_association =1 if q24b==1 | q24b==2 | q24b==3 | q24c==1 | q24c==2 | q24c==3 | q24d==1 | q24d==2 | q24d==3

gen member_assoc_active =0 if (q24b!=. & q24b!=9) | (q24c!=. & q24c!=9) | (q24d!=. & q24d!=9)
replace member_assoc_active =1 if q24b==2 | q24b==3 | q24c==2 | q24c==3 | q24d==2 | q24d==3

gen att_community_meeting = 0 if q25b!=. & q25b!=9
replace att_community_meeting =1 if q25b==2 | q25b==3 | q25b==4

*** Political variables *** 
gen discuss_politics = 0 if q25a!=. & q25a!=9
replace discuss_politics =1 if q25a==3 | q25a==4

gen discuss_politics_often = 0 if q25a!=. & q25a!=9
replace discuss_politics_often =1 if q25a==4

gen raise_issue = 0 if q25c!=. & q25c!=9
replace raise_issue =1 if q25c==2 | q25c==3 | q25c==4

gen att_demonstration = 0 if (q25d!=. & q25d!=9) 
replace att_demonstration =1 if q25d==2 | q25d==3 | q25d==4 

gen close_political_party=0 if q87!=. & q87!=998 | q87!=999
replace close_political_party=1 if q87== 260 | q87==261 | q87== 262

gen close_PDP=0 if q87!=. & q87!=998 | q87!=999
replace close_PDP=1 if q87== 260 


*** Media and public affairs variables***
gen radio_news_rare =0 if q26a!=. & q26a!=9
replace  radio_news_rare =1 if  q26a==1 |q26a==2 | q26a==3 | q26a==4

gen tv_news_rare =0 if q26b!=. & q26b!=9
replace  tv_news_rare =1 if q26b==1 | q26b==2 | q26b==3 | q26b==4

gen newspapers_news_rare =0 if q26c!=. & q26c!=9
replace  newspapers_news_rare =1 if q26c==1 | q26c==2 | q26c==3 | q26c==4

gen radio_news =0 if q26a!=. & q26a!=9
replace  radio_news =1 if q26a==2 | q26a==3 | q26a==4

gen tv_news =0 if q26b!=. & q26b!=9
replace  tv_news =1 if q26b==2 | q26b==3 | q26b==4

gen newspapers_news =0 if q26c!=. & q26c!=9
replace  newspapers_news =1 if q26c==2 | q26c==3 | q26c==4

gen radio_news_sev =0 if q26a!=. & q26a!=9
replace  radio_news_sev =1 if q26a==3 | q26a==4

gen tv_news_sev =0 if q26b!=. & q26b!=9
replace  tv_news_sev =1 if q26b==3 | q26b==4

gen newspapers_news_sev =0 if q26c!=. & q26c!=9
replace  newspapers_news_sev =1 if q26c==3 | q26c==4

gen radio_news_often =0 if q26a!=. & q26a!=9
replace  radio_news_often =1 if q26a==4

gen tv_news_often =0 if q26b!=. & q26b!=9
replace  tv_news_often =1 if q26b==4

gen newspapers_news_often =0 if q26c!=. & q26c!=9
replace  newspapers_news_often =1 if q26c==4

gen interest_public_affairs = 0 if q27!=. & q27!=9
replace interest_public_affairs = 1 if q27==1 | q27==2
label var interest_public_affairs "Interested in public affairs"

gen very_int_publ_aff = 0 if q27!=. & q27!=9
replace very_int_publ_aff = 1 if q27==2
label var very_int_publ_aff "Very interested in public affairs"


*** Contact officials variables***
gen contact_LG_councilor = 0 if q29a!=. & q29a!=9
replace contact_LG_councilor = 1 if q29a== 2 | q29a==3 | q29a==4

gen contact_LG_councilor_often = 0 if q29a!=. & q29a!=9
replace contact_LG_councilor_often = 1 if q29a==3 | q29a==4

gen contact_MP =0 if q29b!=. & q29b!=9
replace contact_MP = 1 if q29b==2 | q29b==3 | q29b==4

gen contact_MP_often =0 if q29b!=. & q29b!=9
replace contact_MP_often = 1 if q29b==3 | q29b==4

gen contact_religious_leader =0 if q29e!=. & q29e!=9
replace contact_religious_leader = 1 if q29e==2 | q29e==3 | q29e==4

gen contact_traditional_ruler = 0 if q29f!=. & q29f!=9
replace contact_traditional_ruler =1 if q29f ==2 | q29f ==3 | q29f ==4


 
*** Democratic views variables ***
gen term_limits =0 if q32!=.  & q32!=9 
replace term_limits  =1 if q32 ==3 | q32 ==4

gen term_limits_strongly =0 if q32!=.  & q32!=9 
replace term_limits_strongly  =1 if q32 ==4

gen checks_balances =0 if q33!=. & q33!=9
replace checks_balances =1 if q33==1 |  q33==2

gen checks_balances_strong =0 if q33!=. & q33!=9
replace checks_balances_strong =1 if q33==1 

gen against_one_party_rule =0 if q35a!=. & q35a!=9
replace against_one_party_rule =1 if q35a == 1 | q35a==2

gen reject_military_rule =0 if q35c!=. & q35c!=9
replace reject_military_rule =1 if q35c == 1 | q35c==2

gen reject_one_man_rule =0 if q35d!=. & q35d!=9
replace reject_one_man_rule =1 if q35d == 1 | q35d==2


*** Violence justified variables***
gen violence_not_ok = 0 if q76!=9
replace violence_not_ok = 1 if q76==1 | q76==2

gen violence_not_ok_str = 0 if q76!=9
replace violence_not_ok_str = 1 if q76==1 



*** Trust on different institutions variables ***
gen trust_president =0 if q43a!=. & q43a!=9
replace trust_president =1  if q43a==2 | q43a==3

gen trust_national_assembly=0 if q43b!=. & q43b!=9
replace trust_national_assembly=1 if q43b==2  | q43b==3
 
gen trust_INEC=0 if q43c!=. & q43c!=9
replace trust_INEC=1 if q43c ==2 | q43c ==3

gen trust_LG_council=0 if q43e!=. & q43e!=9
replace trust_LG_council=1 if q43e==2 | q43e==3

gen trust_ruling_pary=0 if q43f!=. & q43f!=9
replace trust_ruling_pary=1 if q43f==2 | q43f ==3

gen trust_opposition_pary=0 if q43g!=. & q43g!=9
replace trust_opposition_pary=1  if q43g==2 | q43g==3

gen trust_traditional_leaders=0 if q43k!=. & q43k!=9
replace trust_traditional_leaders=1 if q43k==2 | q43k==3


*** Perceptions of government corruption and performance variables ***
gen handles_economy =0 if q45a!=. & q45a!=9
replace handles_economy =1 if q45a==3 | q45a==4
label var handles_economy "Government handles economy"

gen handles_employment=0  if q45b!=. & q45b!=9
replace handles_employment =1 if q45b==3 | q45b==4
label var handles_employment "Government handles employment"

gen handles_inflation=0 if q45c!=. & q45c!=9
replace handles_inflation =1 if q45c==3 | q45c==4
label var handles_inflation "Government handles inflation"

gen handles_inequality=0 if q45d!=. & q45d!=9
replace handles_inequality =1 if q45d==3 | q45d==4
label var handles_inequality "Government handles inequality"

gen inequality_improvement=0 if q22d!=. & q22d!=9
replace inequality_improvement =1 if q22d==4 | q22d==5
label var inequality_improvement "Inequality has gotten better"

gen handles_health=0 if q45f!=. & q45f!=9
replace handles_health =1 if q45f==3 | q45f==4
label var handles_health "Government handles health provision"

gen handles_education=0 if q45g!=. & q45g!=9
replace handles_education =1 if q45g==3 | q45g==4
label var handles_education "Government handles education provision"

gen handles_water=0  if q45h!=. & q45h!=9
replace handles_water =1 if q45h==3 | q45h==4
label var handles_water "Government handles water provisoon"

gen performance_president = 0 if q48a!=. & q48a!=9
replace performance_president = 1 if q48a==3 | q48a==4
label var performance_president "Approves President perfomance"

gen performance_mp  = 0 if q48b!=. & q48b!=9
replace performance_mp = 1 if q48b==3 | q48b==4
label var performance_mp "Approves MP perfomance"

gen performance_LG_councilor  = 0 if q48d!=. & q48d!=9
replace performance_LG_councilor  = 1 if q48d==3 | q48d==4
label var performance_LG_councilor "Approves LG councilor perfomance"

gen corruption_president = 0 if q51a !=. &  q51a !=9
replace corruption_president = 1 if q51a ==2 | q51a ==3
label var corruption_president "Very corrup president office"




*** Identity variable***
gen ethnic_national = 0 if q57!=. & q57!=7 & q57!=9
replace ethnic_national = 1 if q57==1
label var ethnic_national "Feels ethnic identity as opposed to Nigerian"

gen nigeria_united = 0 if q77!=9 
replace nigeria_united = 1 if q77==1 | q77==2


*** Survey year for instrument construction ***
gen year_census = 2001

keep State - year_census

save Afrobarometer2001.dta, replace


******************************************************************************
***************                Afrobarometer 1999              ***************
******************************************************************************

use nig_r1_data.dta, clear

drop if psu==60

*** State variable for subsequent merge ***
gen State =""
replace State="Lagos" if psu==1
replace State="Lagos" if psu==2
replace State="Oyo" if psu==3
replace State="Osun" if psu==4
replace State="Oyo" if psu==5
replace State="Ogun" if psu==6
replace State="Oyo" if psu==7
replace State="Oyo" if psu==8
replace State="Ondo" if psu==9
replace State="Ondo" if psu==10
replace State="Ondo" if psu==11
replace State="Abia" if psu==12
replace State="Akwa Ibom" if psu==13
replace State="Abia" if psu==14
replace State="Enugu" if psu==15
replace State="Enugu" if psu==16
replace State="Enugu" if psu==17
replace State="Enugu" if psu==18
replace State="Enugu" if psu==19
replace State="Enugu" if psu==20
replace State="Edo" if psu==21
replace State="Delta" if psu==22
replace State="Edo" if psu==23
replace State="Rivers" if psu==24
replace State="Rivers" if psu==25
replace State="Rivers" if psu==26
replace State="Delta" if psu==27
replace State="Delta" if psu==28
replace State="Delta" if psu==29
replace State="Bayelsa" if psu==30
replace State="Kwara" if psu==31
replace State="Kwara" if psu==32
replace State="Kwara" if psu==33
replace State="Niger" if psu==34
replace State="Niger" if psu==35
replace State="Niger" if psu==36
replace State="Benue" if psu==37
replace State="Benue" if psu==38
replace State="Benue" if psu==39
replace State="Federal Capital Territory" if psu==40
replace State="Federal Capital Territory" if psu==41
replace State="Federal Capital Territory" if psu==42
replace State="Kano" if psu==43
replace State="Kano" if psu==44
replace State="Kano" if psu==45
replace State="Sokoto" if psu==46
replace State="Sokoto" if psu==47
replace State="Sokoto" if psu==48
replace State="Katsina" if psu==49
replace State="Katsina" if psu==50
replace State="Katsina" if psu==51
replace State="Borno" if psu==52
replace State="Borno" if psu==53
replace State="Jigawa" if psu==54
replace State="Plateau" if psu==55
replace State="Plateau" if psu==56
replace State="Plateau" if psu==57
replace State="Bauchi" if psu==58
replace State="Bauchi" if psu==59

*** Local government area variable for subsequent merge ***
gen LGA=""
replace LGA="Mainland" if psu==1
replace LGA="Ikorodu" if psu==2
replace LGA="IbadanNorth-West" if psu==3
replace LGA="Irewole" if psu==4
replace LGA="Egbeda" if psu==5
replace LGA="AbeokutaNorth" if psu==6
replace LGA="Ibarapa Central" if psu==7
replace LGA="Ibarapa Central" if psu==8
replace LGA="Ondo West" if psu==9
replace LGA="Ondo East" if psu==10
replace LGA="Idanre" if psu==11
replace LGA="Aba South" if psu==12
replace LGA="Ikot-Ekp" if psu==13
replace LGA="Oboma Ngwa" if psu==14
replace LGA="Enugu North" if psu==15
replace LGA="Ezeagu" if psu==16
replace LGA="Udi" if psu==17
replace LGA="Nsukka" if psu==18
replace LGA="Igbo-eze South" if psu==19
replace LGA="Nsukka" if psu==20
replace LGA="Ikpoba-Okha" if psu==21
replace LGA="Sapele" if psu==22
replace LGA="Ikpoba-Okha" if psu==23
replace LGA="Port Harcourt" if psu==24
replace LGA="Port Harcourt" if psu==25
replace LGA="Obio/Akp" if psu==26
replace LGA="Warri South" if psu==27
replace LGA="Ughelli North" if psu==28
replace LGA="Ughelli North" if psu==29
replace LGA="Yenegoa" if psu==30
replace LGA="IlorinWe" if psu==31
replace LGA="Asa" if psu==32
replace LGA="Asa" if psu==33
replace LGA="Chanchaga" if psu==34
replace LGA="Shiroro" if psu==35
replace LGA="Shiroro" if psu==36
replace LGA="Gboko" if psu==37
replace LGA="Buruku" if psu==38
replace LGA="Makurdi" if psu==39
replace LGA="AbujaMun" if psu==40
replace LGA="Kwali" if psu==41
replace LGA="Gwagwala" if psu==42
replace LGA="Kano" if psu==43
replace LGA="DawakinK" if psu==44
replace LGA="DawakinK" if psu==45
replace LGA="Sokoto North" if psu==46
replace LGA="Wamakko" if psu==47
replace LGA="Wamakko" if psu==48
replace LGA="Katsina (K)" if psu==49
replace LGA="Rimi" if psu==50
replace LGA="Rimi" if psu==51
replace LGA="Maidugur" if psu==52
replace LGA="Konduga" if psu==53
replace LGA="Kazaure" if psu==54
replace LGA="Jos North" if psu==55
replace LGA="Jos South" if psu==56
replace LGA="Barkin Ladi" if psu==57
replace LGA="Bauchi" if psu==58
replace LGA="Katagum" if psu==59

*** Urban / rural variable for control ***
gen urban_rural = ""
replace urban_rural = "urban" if q102==1
replace urban_rural = "rural" if   q102==2

*** Age variable for instrument and control ***
gen age =  q1 
label var age "Age of respondent"
replace age=. if age==999

*** Gender variable for control ***
rename gender GENDER
gen gender="" if GENDER!=. & GENDER!=9
replace gender="male" if GENDER==1
replace gender="female" if GENDER==2

*** Education variables for treatment ***
gen primary_school_inc = 0 if q4!=. & q4!=10 & q4!=99
replace primary_school_inc = 1 if q4>=2 & q4<=9
gen primary_school = 0 if q4!=. & q4!=10 & q4!=99
replace primary_school = 1 if q4>=3 & q4<=9
gen secondary_school_inc = 0 if q4!=. & q4!=10 & q4!=99
replace secondary_school_inc = 1 if q4>=4 & q4<=9
gen secondary_school = 0 if q4!=. & q4!=10 & q4!=99
replace secondary_school = 1 if q4>=5 & q4<=9
gen college=  0 if q4!=. & q4!=10 & q4!=99
replace college = 1 if q4>=8 & q4<=9

*** Religion variable for control ***
gen religion=""
replace religion="None" if q5==0 | q5==9
replace religion="Muslim" if q5==1
replace religion="Christian" if q5==2 | q5==3 | q5==4 | q5==5 | q5==8
replace religion="Traditional" if q5==6  | q5==10 | q5==11


*** Language variable for heterogenous effects ***
gen language="" if q2!=. &q2!=999


*** Community participation variables *** 
gen rel_group_assoc = 0 
replace rel_group_assoc = 1 if q6a==1 | q6a==2 

gen rel_group_assoc_active = 0 
replace rel_group_assoc_active = 1 if q6a==2 

gen member_association =0 
replace member_association =1 if q6b==1 | q6b==2  | q6c==1 | q6c==2  | q6d==1 | q6d==2 | q6e==1 | q6e==2  | q6f==1 | q6f==2  | q6g==1 | q6g==2  | q6h==1 | q6h==2 | q6i==1 | q6i==2  | q6j==1 | q6j==2  | q6k==1 | q6k==2 

gen member_assoc_active =0 
replace member_assoc_active =1 if q6b==2 | q6c==2  | q6d==2 | q6e==2 | q6f==2  | q6g==2 | q6h==2 | q6i==2 | q6j==2  | q6k==2

gen att_community_meeting = 0 if q77a!=. & q77a!=9
replace att_community_meeting =1 if q77a==1 | q77a==2 | q77a==3


*** Political variables *** 
gen discuss_politics = 0 if q24!=. & q24!=9
replace discuss_politics =1 if q24==1 | q24==2

gen discuss_politics_often = 0 if q24!=. & q24!=9
replace discuss_politics_often =1 if q24==2

gen name_lg_chairman = (q25a==1) 
gen name_hr_member = (q25b==1) 
gen name_governor = (q25c==1) 
gen name_fin_min = (q25d==1) 
gen name_vice_pres = (q25e==1) 

gen raise_issue = 0 if q77b!=. & q77b!=9
replace raise_issue =1 if q77b==1 | q77b==2 | q77b==3

gen att_demonstration = 0 if (q77g!=. & q77g!=9) 
replace att_demonstration =1 if q77g==1 | q77g==2 | q77g==3

gen registered_voter = 0
replace registered_voter = 1 if q71==1

gen voted_president =0
replace voted_president = 1 if q73a==1 
gen voted_mp =0
replace voted_mp = 1 if q73b==1 
gen voted_president_or_mp = 0 if voted_president!=. | voted_mp!=.
replace voted_president_or_mp = 1 if voted_president==1 | voted_mp==1
gen voted_individual_party = 0 if q74!=. & q74!=9
replace voted_individual_party = 1 if q74==1 | q74==2 
tab voted_individual_party voted_president_or_mp
gen voted = voted_individual_party
drop voted_president voted_mp voted_president_or_mp voted_individual_party

gen close_political_party=0 
replace close_political_party=1 if q97== 1

gen close_PDP=0 
replace close_PDP=1 if q98==1

*** Media and public affairs variables***
gen radio_news_rare =0 if q21a!=. & q21a!=9
replace  radio_news_rare =1 if q21a==1 | q21a==2 | q21a==3 | q21a==4 | q21a==5

gen tv_news_rare =0 if q21b!=. & q21b!=9
replace  tv_news_rare =1 if q21b==1 | q21b==2 | q21b==3 | q21b==4 | q21b==5

gen newspapers_news_rare =0 if q21c!=. & q21c!=9
replace  newspapers_news_rare =1 if q21c==1 | q21c==2 | q21c==3 | q21c==4 | q21c==5

gen radio_news =0 if q21a!=. & q21a!=9
replace  radio_news =1 if q21a==2 | q21a==3 | q21a==4 | q21a==5

gen tv_news =0 if q21b!=. & q21b!=9
replace  tv_news =1 if q21b==2 | q21b==3 | q21b==4 | q21b==5

gen newspapers_news =0 if q21c!=. & q21c!=9
replace  newspapers_news =1 if q21c==2 | q21c==3 | q21c==4 | q21c==5

gen radio_news_sev =0 if q21a!=. & q21a!=9
replace  radio_news_sev =1 if q21a==4 | q21a==5

gen tv_news_sev =0 if q21b!=. & q21b!=9
replace  tv_news_sev =1 if q21b==4 | q21b==5

gen newspapers_news_sev =0 if q21c!=. & q21c!=9
replace  newspapers_news_sev =1 if q21c==4 | q21c==5

gen radio_news_often =0 if q21a!=. & q21a!=9
replace  radio_news_often =1 if q21a==5

gen tv_news_often =0 if q21b!=. & q21b!=9
replace  tv_news_often =1 if q21b==5

gen newspapers_news_often =0 if q21c!=. & q21c!=9
replace  newspapers_news_often =1 if q21c==5

gen interest_public_affairs = 0 if q23!=. & q23!=9
replace interest_public_affairs = 1 if q23==1 | q23==2
label var interest_public_affairs "Interested in public affairs"

gen very_int_publ_aff = 0 if q23!=. & q23!=9
replace very_int_publ_aff = 1 if q23==2
label var very_int_publ_aff "Very interested in public affairs"


*** Contact officials variables***
gen contact_LG_councilor = 0 if q78b!=. & q78b!=9
replace contact_LG_councilor = 1 if q78b== 1 | q78b==2 | q78b==3

gen contact_LG_councilor_often = 0 if q78b!=. & q78b!=9
replace contact_LG_councilor_often = 1 if q78b==2 | q78b==3

gen contact_MP =0 if q78c!=. & q78c!=9
replace contact_MP = 1 if q78c==1 | q78c==2 | q78c==3

gen contact_MP_often =0 if q78c!=. & q78c!=9
replace contact_MP_often = 1 if q78c==2 | q78c==3

gen contact_religious_leader =0 if q78f!=. & q78f!=9
replace contact_religious_leader = 1 if q78f==1 | q78f==2 | q78f==3

gen contact_traditional_ruler = 0 if q78a!=. & q78a!=9
replace contact_traditional_ruler =1 if q78a ==1 | q78a ==2 | q78a ==3

 
*** Democratic views variables ***
gen reject_military_rule =0 
replace reject_military_rule =1 if q42b<=3

gen against_one_party_rule =0 if q44b!=. & q44b!=9
replace against_one_party_rule =1 if q44b == 1 | q44b==2

gen reject_one_man_rule =0 if q44a!=. & q44a!=9
replace reject_one_man_rule =1 if q44a == 1 | q44a==2



*** Violence justified variables***
gen violence_not_ok = 0 if q40!=9
replace violence_not_ok = 1 if q40==3 | q40==4

gen violence_not_ok_str = 0 if q40!=9
replace violence_not_ok_str = 1 if q40==4


*** Trust on different institutions variables ***
gen trust_president =0 if q49e!=. & q49e!=9
replace trust_president =1  if q49e==3 | q49e==4

gen trust_national_assembly=0 if q50g!=. & q50g!=9
replace trust_national_assembly=1 if q50g==3  | q50g==4

gen trust_INEC=0 if q50h!=. & q50h!=9
replace trust_INEC=1 if q50h ==3 | q50h ==4

gen trust_LG_council=0 if q50b!=. & q50b!=9
replace trust_LG_council=1 if q50b==3 | q50b==4

gen trust_traditional_leaders=0 if q50a!=. & q50a!=9
replace trust_traditional_leaders=1 if q50a==3 | q50a==4



*** Perceptions of government corruption and performance variables ***
gen handles_inflation=0 if q18b!=. & q18b!=9
replace handles_inflation =1 if q18b==3 | q18b==4
label var handles_inflation "Government handles inflation"

gen handles_inequality=0 if q18c!=. & q18c!=9
replace handles_inequality =1 if q18c==3 | q18c==4
label var handles_inequality "Government handles inequality"

gen handles_education=0 if q18e!=. & q18e!=9
replace handles_education =1 if q18e==3 | q18e==4
label var handles_education "Government handles education provision"

*gen performance_mp  = 0 if q76a!=. & q76a!=9
*replace performance_mp = 1 if q76a==3 | q76a==4
*label var performance_mp "Approves MP perfomance"

*gen performance_state_rep  = 0 if q76b!=. & q76b!=9
*replace performance_state_rep = 1 if q76b==3 | q76b==4
*label var performance_state_rep "Approves State Representative perfomance"


*** Identity variable***
gen ethnic_national = 0 if q92d!=. & q92d!=9
replace ethnic_national = 1 if q92d==4 & q92d==5
label var ethnic_national "Feels ethnic identity as opposed to Nigerian"

*** Survey year for instrument construction ***
gen year_census = 1999

keep State -  year_census

save Afrobarometer1999.dta, replace

clear all
use "Afrobarometer2013.dta", clear
append using "Afrobarometer2009.dta"
append using "Afrobarometer2007.dta"
append using "Afrobarometer2005.dta"
append using "Afrobarometer2003.dta"
append using "Afrobarometer2001.dta"
append using "Afrobarometer1999.dta"

erase "Afrobarometer2013.dta" 
erase "Afrobarometer2009.dta" 
erase "Afrobarometer2007.dta"
erase "Afrobarometer2005.dta"
erase "Afrobarometer2003.dta"
erase "Afrobarometer2001.dta"
erase "Afrobarometer1999.dta"

********************************************************************************
***                             Basic recoding                               *** 
********************************************************************************

gen year_born = year_census - age
drop age

gen post = (year_born>=1970)

gen placebo =0 if year_born<1970
replace placebo =1 if year_born>=1960 & year_born<1970

gen year_born_post = year_born*post

gen name_mp = name_hr_member
replace name_mp = name_state_house if name_state_house!=. & name_mp==.
drop name_hr_member name_state_house

gen name_lg_off = name_lg_councillor
replace name_lg_off = name_lg_chairman if name_lg_chairman!=. & name_lg_off==.
drop name_lg_councillor name_lg_chairman

***************************************************************************************************
***                                  Intensity Variables                                        ***
***************************************************************************************************

sort State LGA
merge State LGA using "Intensity_variable.dta"
drop if _merge!=3
drop _merge

gen non_prim_educ_lga = non_prim_educ_lga_10_male  if gender=="male"
replace non_prim_educ_lga = non_prim_educ_lga_10_female if gender=="female"
drop non_prim_educ_lga_10_male non_prim_educ_lga_10_female

gen non_prim_educ_lga_5 = non_prim_educ_lga_5_male  if gender=="male"
replace non_prim_educ_lga_5 = non_prim_educ_lga_5_female if gender=="female"
drop non_prim_educ_lga_5_male non_prim_educ_lga_5_female

gen non_prim_sch_lga = non_prim_sch_lga_10_male  if gender=="male"
replace non_prim_sch_lga = non_prim_sch_lga_10_female if gender=="female"
drop non_prim_sch_lga_10_male non_prim_sch_lga_10_female

gen non_prim_sch_lga_5 = non_prim_sch_lga_5_male  if gender=="male"
replace non_prim_sch_lga_5 = non_prim_sch_lga_5_female if gender=="female"
drop non_prim_sch_lga_5_male non_prim_sch_lga_5_female

gen post_non_prim_educ_lga = post * non_prim_educ_lga
gen placebo_non_prim_educ_lga = placebo*non_prim_educ_lga
gen post_non_prim_sch_lga = post * non_prim_sch_lga
gen placebo_non_prim_sch_lga = placebo*non_prim_sch_lga

gen post_non_prim_educ_lga_5 = post * non_prim_educ_lga_5
gen placebo_non_prim_educ_lga_5 = placebo*non_prim_educ_lga_5
gen post_non_prim_sch_lga_5 = post * non_prim_sch_lga_5
gen placebo_non_prim_sch_lga_5 = placebo*non_prim_sch_lga_5

********************************************************************************
***         Bringing in the LGA religions shares from the HNLSS             *** 
********************************************************************************

sort State LGA
merge State LGA using "Religion_shares.dta"
drop if _merge!=3
drop _merge

gen rel_fragm_LGA = 1- christian_LGA^2 - muslim_LGA^2 - other_religion_LGA ^2 
gen rel_fragm_h = (rel_fragm_LGA > .1472)
label var rel_fragm_h "Indicator that the LGA has high religious fragmentation"

gen maj_rel = (religion=="Christian" & christian_LGA>.5) if religion!=""
replace maj_rel = 1 if religion=="Muslim" & muslim_LGA>.5
label var maj_rel "Indicator that the individual belongs to the religion of the LGA majority"
count if (other_religion_LGA> christian_LGA) & (other_religion_LGA> muslim_LGA)

gen rel_tension = christian_LGA / (christian_LGA  + muslim_LGA)
replace rel_tension = 1 - rel_tension if rel_tension<.5
replace rel_tension = 1 - rel_tension
replace rel_tension = rel_tension /.5
label var rel_tension "Measure of LGA religious tension between Christians and Muslims"

***************************************************************************************************
***                                Tribe related variables                                      ***
***************************************************************************************************

sort State LGA
merge State LGA using "LGAsLanguages.dta"
drop if _merge!=3
drop _merge

* tribe and language come from Afrobarometer
replace tribe = proper(tribe)
* Language 1 to 4 are the main languages spoken in each LG accoding to the "1998 Local Government Yearbook"
* Top alternative is the imputation in case there is no main language indicated in the data
replace language1 = proper(language1)
replace language2 = proper(language2)
replace language3 = proper(language3)
replace language4 = proper(language4)
replace topalternative = proper(topalternative)

*** We replace some minor tribes with the family tribe they belong to
foreach var in tribe language language1 language2 language3 language4 topalternative {
replace `var' = subinstr(`var',"Fulfulde","Fulani",.)
replace `var' = subinstr(`var',"Kausa","Hausa",.)
replace `var' = subinstr(`var',"Ibiobio","Ibibio",.)
replace `var' = subinstr(`var',"Annang","Anang",.)
replace `var' = subinstr(`var',"Izon","Ijaw",.)
replace `var' = subinstr(`var',"Aboh","Igbo",.)
replace `var' = subinstr(`var',"Ezza","Igbo",.)
replace `var' = subinstr(`var',"Ukwani","Igbo",.)
replace `var' = subinstr(`var',"Ukwvani","Igbo",.)
replace `var' = subinstr(`var',"Igbassa","Igbo",.)
replace `var' = subinstr(`var',"Bini","Edo",.)
replace `var' = subinstr(`var',"Gbagyi","Gwari",.)
replace `var' = subinstr(`var',"Ebura","Ebira",.)
replace `var' = subinstr(`var',"Gokana","Ogoni",.)
replace `var' = subinstr(`var',"Khana","Ogoni",.)
replace `var' = subinstr(`var',"Tai","Ogoni",.)
replace `var' = subinstr(`var',"Kirike","Okirika",.)
replace `var' = subinstr(`var',"Okrika","Okirika",.)
replace `var' = subinstr(`var',"Kirike","Kanouri",.)
replace `var' = subinstr(`var',"Kanowri","Kanouri",.)
replace `var' = subinstr(`var',"Manga","Kanouri",.)
replace `var' = subinstr(`var',"Yerwa","Kanouri",.)
}
 
*** General coding for main tribe*** 
gen tribe_main = 0 if tribe!=""
replace tribe_main = 1 if tribe==language1 & tribe!=""
replace tribe_main = 1 if tribe==topalternative & language1=="" & tribe!=""
replace tribe_main = 1 if tribe==language2 & language1=="" & topalternative=="" & tribe!=""
replace tribe_main = 1 if tribe==language2 & language1=="English" & topalternative=="" & tribe!=""

*** Special coding for particular ethnic groups for main tribe ***
replace tribe_main = 1 if tribe=="Igbo" & language1=="Ibo"
replace tribe_main = 1 if tribe=="Esan" & language1=="Edo"
replace tribe_main = 1 if tribe=="Igbo" & language1=="Ika"
replace tribe_main = 1 if tribe=="Ibibio" & language1=="Efik/Ibibio"
replace tribe_main = 1 if tribe=="Babur" & language1=="Bura"
replace tribe_main = 1 if tribe=="Ijaw/Kalabari/Andoni/Nembe/Ogoni/Okirik" & language1=="Andoni"
replace tribe_main = 1 if tribe=="Ijaw/Kalabari/Andoni/Nembe/Ogoni/Okirik" & language1=="Adoni"
replace tribe_main = 1 if tribe=="Ijaw/Kalabari/Andoni/Nembe/Ogoni/Okirik" & language1=="Gokana"
replace tribe_main = 1 if tribe=="Ijaw/Kalabari/Andoni/Nembe/Ogoni/Okirik" & language1=="Ijaw"
replace tribe_main = 1 if tribe=="Ijaw/Kalabari/Andoni/Nembe/Ogoni/Okirik" & language1=="Kalabari"
replace tribe_main = 1 if tribe=="Ijaw/Kalabari/Andoni/Nembe/Ogoni/Okirik" & language1=="Nembe"
replace tribe_main = 1 if tribe=="Ijaw/Kalabari/Andoni/Nembe/Ogoni/Okirik" & language1=="Okirika"
replace tribe_main = 1 if tribe=="Okrika" & language1=="Kalabari"
replace tribe_main = 1 if tribe=="Ijaw" & language1=="Okirika"
replace tribe_main = 1 if tribe=="Ijaw" & language1=="Nembe"
replace tribe_main = 1 if tribe=="Nembe" & language1=="Ijaw"
replace tribe_main = 1 if tribe=="Ijaw" & language1=="Ogbia"
replace tribe_main = 1 if tribe=="Ibibio" & language1=="Efik"
replace tribe_main = 1 if tribe=="Efik" & language1=="Ibibio"
replace tribe_main = 1 if tribe=="Yoruba" & language1=="Awori"
drop language1 language2 language3 language4 topalternative 

* We replace that is the main tribe if it corresponds to the majority of the sample people in the LGA
bys State LGA : gen obs  = _N  if tribe!="" & tribe!="Other" & tribe!="Others"
bys State LGA tribe: gen freq_tribe  = _N if tribe!="" & tribe!="Other" & tribe!="Others"
bys State LGA: egen max_freq_tribe  = max(freq_tribe) if tribe!="" & tribe!="Other" & tribe!="Others"
replace freq_tribe = freq_tribe/obs
replace tribe_main = 1 if freq_tribe>0.5 & tribe!="" & tribe!="Other" & tribe!="Others" & freq_tribe==max_freq_tribe
drop freq_tribe obs max_freq_tribe

save Afrobarometer_Final.dta, replace
capture saveold Afrobarometer_Final.dta, replace version(12)
