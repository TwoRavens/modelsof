
*****************************************
* Label define occ in china_data_updated
*****************************************
#delimit;
label define occ_label  1 "Administrators,CCP or democratic parties and social groups"
                        2 "Administrators, governments and institutions"
                        4 "Administrators, public institutions or Heads of enterprises"
                        11 "Scientific researchers"
                        12 "Scientific researchers"
                        13 "Technicians"
                        17 "Professional of agriculture"
                        18 "Professional of aircrafts and ships"
                        19 "Professional of medicine and health"
                        21 "Professional of business and finance"
                        23 "Professional of law"
                        24 "Teaching staff"
                        25 "Literature and art workers"
                        26 "Sports staff"
                        27 "Culture, press and publication staff"
                        28 "Religious specialists and other professionals"
                        31 "Administrative staff"
                        32 "Security guards and firefighters"
                        33 "Post service and communication staff"
                        39 "Other handle affairs personnel and concerned personnel"
                        41 "Various commercial and service personnel"
                        51 "Crop farming workers"
                        52 "Forestry workers"
                        53 "Animal husbandry" 
                        54 "Fishery workers;Management and maintenance workers of water conservancy"
                        59 "Other farming, forestry, animal husbandry and fishery workers "
                        61 "Surveyors and mineral mining workers"
                        62 "Metal smelting and rolling workers"
                        64 "Chemical products production workers"
                        66 "Mechanical manufacturing workers;Machine electricity products assemblers;Machinery and equipment repairers"
                        72 "Installation, operation and repairing workers of electrical equipment;Electronic elements and equipment, manufacturing, assembling, adjust and repairing workers "
                        74 "Rubber and plastic products production workers"
                        75 "Textile,printing workers"
                        76 "Sewing, cutting workers and leather and fur skins workers"
                        77 "Oil,foodstuffs, beverage production and processing workers"
                        78 "Tobacco processing workers and Pharmaceutical manufacturers"
                        81 "Wood processing, wood products production, paper making, and paper products production workers"
                        82 "Production and processing workers of building materials"
                        83 "Production and processing workers of glass, ceramics, enamels and relevant products"
                        84 "Production,playing and protecting staff of broadcast and movie products"
                        85 "Offset operators"
                        86 "Arts and crafts production staff"
                        87 "Culture, education and sports products production staff"
                        88 "Engeering construction workers"
                        91 "Transportation equipments operators"
                        92 "Enviromental monitors and waste displose staff;Inspection and calibration staff"
                        99 "Other pruduction, transporation equipments operators" ;

label var occ occ_label ;
#delimit cr;


