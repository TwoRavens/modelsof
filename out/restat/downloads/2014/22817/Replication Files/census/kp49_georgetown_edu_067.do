/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 byte    datanum       1-2 ///
 double  serial        3-10 ///
 byte    pernum       11-12 ///
 long    bpl          13-15 ///
 int     occ          16-18 ///
 int     ind1990      19-21 ///
 long    incwage      22-27 ///
 using "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\census\kp49_georgetown_edu_067.dat"

label var datanum "Data set number"
label var serial "Household serial number"
label var pernum "Person number in sample unit"
label var bpl "Birthplace [general version]"
label var occ "Occupation"
label var ind1990 "Industry, 1990 basis"
label var incwage "Wage and salary income"

label values datanum datanumlbl

label values serial seriallbl

label values pernum pernumlbl

label define bpllbl 001 "Alabama", add
label define bpllbl 002 "Alaska", add
label define bpllbl 004 "Arizona", add
label define bpllbl 005 "Arkansas", add
label define bpllbl 006 "California", add
label define bpllbl 008 "Colorado", add
label define bpllbl 009 "Connecticut", add
label define bpllbl 010 "Delaware", add
label define bpllbl 011 "District of Columbia", add
label define bpllbl 012 "Florida", add
label define bpllbl 013 "Georgia", add
label define bpllbl 015 "Hawaii", add
label define bpllbl 016 "Idaho", add
label define bpllbl 017 "Illinois", add
label define bpllbl 018 "Indiana", add
label define bpllbl 019 "Iowa", add
label define bpllbl 020 "Kansas", add
label define bpllbl 021 "Kentucky", add
label define bpllbl 022 "Louisiana", add
label define bpllbl 023 "Maine", add
label define bpllbl 024 "Maryland", add
label define bpllbl 025 "Massachusetts", add
label define bpllbl 026 "Michigan", add
label define bpllbl 027 "Minnesota", add
label define bpllbl 028 "Mississippi", add
label define bpllbl 029 "Missouri", add
label define bpllbl 030 "Montana", add
label define bpllbl 031 "Nebraska", add
label define bpllbl 032 "Nevada", add
label define bpllbl 033 "New Hampshire", add
label define bpllbl 034 "New Jersey", add
label define bpllbl 035 "New Mexico", add
label define bpllbl 036 "New York", add
label define bpllbl 037 "North Carolina", add
label define bpllbl 038 "North Dakota", add
label define bpllbl 039 "Ohio", add
label define bpllbl 040 "Oklahoma", add
label define bpllbl 041 "Oregon", add
label define bpllbl 042 "Pennsylvania", add
label define bpllbl 044 "Rhode Island", add
label define bpllbl 045 "South Carolina", add
label define bpllbl 046 "South Dakota", add
label define bpllbl 047 "Tennessee", add
label define bpllbl 048 "Texas", add
label define bpllbl 049 "Utah", add
label define bpllbl 050 "Vermont", add
label define bpllbl 051 "Virginia", add
label define bpllbl 053 "Washington", add
label define bpllbl 054 "West Virginia", add
label define bpllbl 055 "Wisconsin", add
label define bpllbl 056 "Wyoming", add
label define bpllbl 090 "Native American", add
label define bpllbl 099 "United States, ns", add
label define bpllbl 100 "American Samoa", add
label define bpllbl 105 "Guam", add
label define bpllbl 110 "Puerto Rico", add
label define bpllbl 115 "U.S. Virgin Islands", add
label define bpllbl 120 "Other US Possessions", add
label define bpllbl 150 "Canada", add
label define bpllbl 155 "St. Pierre and Miquelon", add
label define bpllbl 160 "Atlantic Islands", add
label define bpllbl 199 "North America, ns", add
label define bpllbl 200 "Mexico", add
label define bpllbl 210 "Central America", add
label define bpllbl 250 "Cuba", add
label define bpllbl 260 "West Indies", add
label define bpllbl 300 "SOUTH AMERICA", add
label define bpllbl 400 "Denmark", add
label define bpllbl 401 "Finland", add
label define bpllbl 402 "Iceland", add
label define bpllbl 403 "Lapland, n.s.", add
label define bpllbl 404 "Norway", add
label define bpllbl 405 "Sweden", add
label define bpllbl 410 "England", add
label define bpllbl 411 "Scotland", add
label define bpllbl 412 "Wales", add
label define bpllbl 413 "United Kingdom, ns", add
label define bpllbl 414 "Ireland", add
label define bpllbl 419 "Northern Europe, ns", add
label define bpllbl 420 "Belgium", add
label define bpllbl 421 "France", add
label define bpllbl 422 "Liechtenstein", add
label define bpllbl 423 "Luxembourg", add
label define bpllbl 424 "Monaco", add
label define bpllbl 425 "Netherlands", add
label define bpllbl 426 "Switerland", add
label define bpllbl 429 "Western Europe, ns", add
label define bpllbl 430 "Albania", add
label define bpllbl 431 "Andorra", add
label define bpllbl 432 "Gibraltar", add
label define bpllbl 433 "Greece", add
label define bpllbl 434 "Italy", add
label define bpllbl 435 "Malta", add
label define bpllbl 436 "Portugal", add
label define bpllbl 437 "San Marino", add
label define bpllbl 438 "Spain", add
label define bpllbl 439 "Vatican City", add
label define bpllbl 440 "Southern Europe, ns", add
label define bpllbl 450 "Austria", add
label define bpllbl 451 "Bulgaria", add
label define bpllbl 452 "Czechoslovakia", add
label define bpllbl 453 "Germany", add
label define bpllbl 454 "Hungary", add
label define bpllbl 455 "Poland", add
label define bpllbl 456 "Romania", add
label define bpllbl 457 "Yugoslavia", add
label define bpllbl 458 "Central Europe, ns", add
label define bpllbl 459 "Eastern Europe, ns", add
label define bpllbl 460 "Estonia", add
label define bpllbl 461 "Latvia", add
label define bpllbl 462 "Lithuania", add
label define bpllbl 463 "Baltic States, ns", add
label define bpllbl 465 "Other USSR/Russia", add
label define bpllbl 499 "Europe, ns", add
label define bpllbl 500 "China", add
label define bpllbl 501 "Japan", add
label define bpllbl 502 "Korea", add
label define bpllbl 509 "East Asia, ns", add
label define bpllbl 510 "Brunei", add
label define bpllbl 511 "Cambodia (Kampuchea)", add
label define bpllbl 512 "Indonesia", add
label define bpllbl 513 "Laos", add
label define bpllbl 514 "Malaysia", add
label define bpllbl 515 "Philippines", add
label define bpllbl 516 "Singapore", add
label define bpllbl 517 "Thailand", add
label define bpllbl 518 "Vietnam", add
label define bpllbl 519 "Southeast Asia, ns", add
label define bpllbl 520 "Afghanistan", add
label define bpllbl 521 "India", add
label define bpllbl 522 "Iran", add
label define bpllbl 523 "Maldives", add
label define bpllbl 524 "Nepal", add
label define bpllbl 530 "Bahrain", add
label define bpllbl 531 "Cyprus", add
label define bpllbl 532 "Iraq", add
label define bpllbl 533 "Iraq/Saudi Arabia", add
label define bpllbl 534 "Israel/Palestine", add
label define bpllbl 535 "Jordan", add
label define bpllbl 536 "Kuwait", add
label define bpllbl 537 "Lebanon", add
label define bpllbl 538 "Oman", add
label define bpllbl 539 "Qatar", add
label define bpllbl 540 "Saudi Arabia", add
label define bpllbl 541 "Syria", add
label define bpllbl 542 "Turkey", add
label define bpllbl 543 "United Arab Emirates", add
label define bpllbl 544 "Yemen Arab Republic (North)", add
label define bpllbl 545 "Yemen, PDR (South)", add
label define bpllbl 546 "Persian Gulf States, n.s.", add
label define bpllbl 547 "Middle East, ns", add
label define bpllbl 548 "Southwest Asia, nec/ns", add
label define bpllbl 549 "Asia Minor, ns", add
label define bpllbl 550 "South Asia, nec", add
label define bpllbl 599 "Asia, nec/ns", add
label define bpllbl 600 "AFRICA", add
label define bpllbl 700 "Australia and New Zealand", add
label define bpllbl 710 "Pacific Islands", add
label define bpllbl 800 "Antarctica, ns/nec", add
label define bpllbl 900 "Abroad (unknown) or at sea", add
label define bpllbl 950 "Other, nec", add
label values bpl bpllbl

label values occ occlbl

label define ind1990lbl 000 "N/A (not applicable) ", add
label define ind1990lbl 010 "Agricultural production, crops", add
label define ind1990lbl 011 "Agricultural production, livestock", add
label define ind1990lbl 012 "Veterinary services", add
label define ind1990lbl 020 "Landscape and horticultural services", add
label define ind1990lbl 030 "Agricultural services, n.e.c.", add
label define ind1990lbl 031 "Forestry", add
label define ind1990lbl 032 "Fishing, hunting, and trapping ", add
label define ind1990lbl 040 "Metal mining", add
label define ind1990lbl 041 "Coal mining", add
label define ind1990lbl 042 "Oil and gas extraction", add
label define ind1990lbl 050 "Nonmetallic mining and quarrying, except fuels ", add
label define ind1990lbl 060 "All construction ", add
label define ind1990lbl 100 "Meat products", add
label define ind1990lbl 101 "Dairy products", add
label define ind1990lbl 102 "Canned, frozen, and preserved fruits and vegetables", add
label define ind1990lbl 110 "Grain mill products", add
label define ind1990lbl 111 "Bakery products", add
label define ind1990lbl 112 "Sugar and confectionery products", add
label define ind1990lbl 120 "Beverage industries", add
label define ind1990lbl 121 "Misc. food preparations and kindred products", add
label define ind1990lbl 122 "Food industries, n.s.", add
label define ind1990lbl 130 "Tobacco manufactures", add
label define ind1990lbl 132 "Knitting mills", add
label define ind1990lbl 140 "Dyeing and finishing textiles, except wool and knit goods", add
label define ind1990lbl 141 "Carpets and rugs", add
label define ind1990lbl 142 "Yarn, thread, and fabric mills", add
label define ind1990lbl 150 "Miscellaneous textile mill products", add
label define ind1990lbl 151 "Apparel and accessories, except knit", add
label define ind1990lbl 152 "Miscellaneous fabricated textile products", add
label define ind1990lbl 160 "Pulp, paper, and paperboard mills", add
label define ind1990lbl 161 "Miscellaneous paper and pulp products", add
label define ind1990lbl 162 "Paperboard containers and boxes", add
label define ind1990lbl 171 "Newspaper publishing and printing", add
label define ind1990lbl 172 "Printing, publishing, and allied industries, except newspapers", add
label define ind1990lbl 180 "Plastics, synthetics, and resins", add
label define ind1990lbl 181 "Drugs", add
label define ind1990lbl 182 "Soaps and cosmetics", add
label define ind1990lbl 190 "Paints, varnishes, and related products", add
label define ind1990lbl 191 "Agricultural chemicals", add
label define ind1990lbl 192 "Industrial and miscellaneous chemicals", add
label define ind1990lbl 200 "Petroleum refining", add
label define ind1990lbl 201 "Miscellaneous petroleum and coal products", add
label define ind1990lbl 210 "Tires and inner tubes", add
label define ind1990lbl 211 "Other rubber products, and plastics footwear and belting", add
label define ind1990lbl 212 "Miscellaneous plastics products", add
label define ind1990lbl 220 "Leather tanning and finishing", add
label define ind1990lbl 221 "Footwear, except rubber and plastic", add
label define ind1990lbl 222 "Leather products, except footwear", add
label define ind1990lbl 230 "Logging", add
label define ind1990lbl 231 "Sawmills, planing mills, and millwork", add
label define ind1990lbl 232 "Wood buildings and mobile homes", add
label define ind1990lbl 241 "Miscellaneous wood products", add
label define ind1990lbl 242 "Furniture and fixtures", add
label define ind1990lbl 250 "Glass and glass products", add
label define ind1990lbl 251 "Cement, concrete, gypsum, and plaster products", add
label define ind1990lbl 252 "Structural clay products", add
label define ind1990lbl 261 "Pottery and related products", add
label define ind1990lbl 262 "Misc. nonmetallic mineral and stone products", add
label define ind1990lbl 270 "Blast furnaces, steelworks, rolling and finishing mills", add
label define ind1990lbl 271 "Iron and steel foundries", add
label define ind1990lbl 272 "Primary aluminum industries", add
label define ind1990lbl 280 "Other primary metal industries", add
label define ind1990lbl 281 "Cutlery, handtools, and general hardware", add
label define ind1990lbl 282 "Fabricated structural metal products", add
label define ind1990lbl 290 "Screw machine products", add
label define ind1990lbl 291 "Metal forgings and stampings", add
label define ind1990lbl 292 "Ordnance", add
label define ind1990lbl 300 "Miscellaneous fabricated metal products", add
label define ind1990lbl 301 "Metal industries, n.s.", add
label define ind1990lbl 310 "Engines and turbines", add
label define ind1990lbl 311 "Farm machinery and equipment", add
label define ind1990lbl 312 "Construction and material handling machines", add
label define ind1990lbl 320 "Metalworking machinery", add
label define ind1990lbl 321 "Office and accounting machines", add
label define ind1990lbl 322 "Computers and related equipment", add
label define ind1990lbl 331 "Machinery, except electrical, n.e.c.", add
label define ind1990lbl 332 "Machinery, n.s.", add
label define ind1990lbl 340 "Household appliances", add
label define ind1990lbl 341 "Radio, TV, and communication equipment", add
label define ind1990lbl 342 "Electrical machinery, equipment, and supplies, n.e.c.", add
label define ind1990lbl 350 "Electrical machinery, equipment, and supplies, n.s.", add
label define ind1990lbl 351 "Motor vehicles and motor vehicle equipment", add
label define ind1990lbl 352 "Aircraft and parts", add
label define ind1990lbl 360 "Ship and boat building and repairing", add
label define ind1990lbl 361 "Railroad locomotives and equipment", add
label define ind1990lbl 362 "Guided missiles, space vehicles, and parts", add
label define ind1990lbl 370 "Cycles and miscellaneous transportation equipment", add
label define ind1990lbl 371 "Scientific and controlling instruments", add
label define ind1990lbl 372 "Medical, dental, and optical instruments and supplies", add
label define ind1990lbl 380 "Photographic equipment and supplies", add
label define ind1990lbl 381 "Watches, clocks, and clockwork operated devices", add
label define ind1990lbl 390 "Toys, amusement, and sporting goods", add
label define ind1990lbl 391 "Miscellaneous manufacturing industries", add
label define ind1990lbl 392 "Manufacturing industries, n.s. ", add
label define ind1990lbl 400 "Railroads", add
label define ind1990lbl 401 "Bus service and urban transit", add
label define ind1990lbl 402 "Taxicab service", add
label define ind1990lbl 410 "Trucking service", add
label define ind1990lbl 411 "Warehousing and storage", add
label define ind1990lbl 412 "U.S. Postal Service", add
label define ind1990lbl 420 "Water transportation", add
label define ind1990lbl 421 "Air transportation", add
label define ind1990lbl 422 "Pipe lines, except natural gas", add
label define ind1990lbl 432 "Services incidental to transportation", add
label define ind1990lbl 440 "Radio and television broadcasting and cable", add
label define ind1990lbl 441 "Telephone communications", add
label define ind1990lbl 442 "Telegraph and miscellaneous communications services", add
label define ind1990lbl 450 "Electric light and power", add
label define ind1990lbl 451 "Gas and steam supply systems", add
label define ind1990lbl 452 "Electric and gas, and other combinations", add
label define ind1990lbl 470 "Water supply and irrigation", add
label define ind1990lbl 471 "Sanitary services", add
label define ind1990lbl 472 "Utilities, n.s. ", add
label define ind1990lbl 500 "Motor vehicles and equipment", add
label define ind1990lbl 501 "Furniture and home furnishings", add
label define ind1990lbl 502 "Lumber and construction materials", add
label define ind1990lbl 510 "Professional and commercial equipment and supplies", add
label define ind1990lbl 511 "Metals and minerals, except petroleum", add
label define ind1990lbl 512 "Electrical goods", add
label define ind1990lbl 521 "Hardware, plumbing and heating supplies", add
label define ind1990lbl 530 "Machinery, equipment, and supplies", add
label define ind1990lbl 531 "Scrap and waste materials", add
label define ind1990lbl 532 "Miscellaneous wholesale, durable goods", add
label define ind1990lbl 540 "Paper and paper products", add
label define ind1990lbl 541 "Drugs, chemicals, and allied products", add
label define ind1990lbl 542 "Apparel, fabrics, and notions", add
label define ind1990lbl 550 "Groceries and related products", add
label define ind1990lbl 551 "Farm-product raw materials", add
label define ind1990lbl 552 "Petroleum products", add
label define ind1990lbl 560 "Alcoholic beverages", add
label define ind1990lbl 561 "Farm supplies", add
label define ind1990lbl 562 "Miscellaneous wholesale, nondurable goods", add
label define ind1990lbl 571 "Wholesale trade, n.s. ", add
label define ind1990lbl 580 "Lumber and building material retailing", add
label define ind1990lbl 581 "Hardware stores", add
label define ind1990lbl 582 "Retail nurseries and garden stores", add
label define ind1990lbl 590 "Mobile home dealers", add
label define ind1990lbl 591 "Department stores", add
label define ind1990lbl 592 "Variety stores", add
label define ind1990lbl 600 "Miscellaneous general merchandise stores", add
label define ind1990lbl 601 "Grocery stores", add
label define ind1990lbl 602 "Dairy products stores", add
label define ind1990lbl 610 "Retail bakeries", add
label define ind1990lbl 611 "Food stores, n.e.c.", add
label define ind1990lbl 612 "Motor vehicle dealers", add
label define ind1990lbl 620 "Auto and home supply stores", add
label define ind1990lbl 621 "Gasoline service stations", add
label define ind1990lbl 622 "Miscellaneous vehicle dealers", add
label define ind1990lbl 623 "Apparel and accessory stores, except shoe", add
label define ind1990lbl 630 "Shoe stores", add
label define ind1990lbl 631 "Furniture and home furnishings stores", add
label define ind1990lbl 632 "Household appliance stores", add
label define ind1990lbl 633 "Radio, TV, and computer stores", add
label define ind1990lbl 640 "Music stores", add
label define ind1990lbl 641 "Eating and drinking places", add
label define ind1990lbl 642 "Drug stores", add
label define ind1990lbl 650 "Liquor stores", add
label define ind1990lbl 651 "Sporting goods, bicycles, and hobby stores", add
label define ind1990lbl 652 "Book and stationery stores", add
label define ind1990lbl 660 "Jewelry stores", add
label define ind1990lbl 661 "Gift, novelty, and souvenir shops", add
label define ind1990lbl 662 "Sewing, needlework, and piece goods stores", add
label define ind1990lbl 663 "Catalog and mail order houses", add
label define ind1990lbl 670 "Vending machine operators", add
label define ind1990lbl 671 "Direct selling establishments", add
label define ind1990lbl 672 "Fuel dealers", add
label define ind1990lbl 681 "Retail florists", add
label define ind1990lbl 682 "Miscellaneous retail stores", add
label define ind1990lbl 691 "Retail trade, n.s. ", add
label define ind1990lbl 700 "Banking", add
label define ind1990lbl 701 "Savings institutions, including credit unions", add
label define ind1990lbl 702 "Credit agencies, n.e.c.", add
label define ind1990lbl 710 "Security, commodity brokerage, and investment companies", add
label define ind1990lbl 711 "Insurance", add
label define ind1990lbl 712 "Real estate, including real estate-insurance offices ", add
label define ind1990lbl 721 "Advertising", add
label define ind1990lbl 722 "Services to dwellings and other buildings", add
label define ind1990lbl 731 "Personnel supply services", add
label define ind1990lbl 732 "Computer and data processing services", add
label define ind1990lbl 740 "Detective and protective services", add
label define ind1990lbl 741 "Business services, n.e.c.", add
label define ind1990lbl 742 "Automotive rental and leasing, without drivers", add
label define ind1990lbl 750 "Automobile parking and carwashes", add
label define ind1990lbl 751 "Automotive repair and related services", add
label define ind1990lbl 752 "Electrical repair shops", add
label define ind1990lbl 760 "Miscellaneous repair services ", add
label define ind1990lbl 761 "Private households", add
label define ind1990lbl 762 "Hotels and motels", add
label define ind1990lbl 770 "Lodging places, except hotels and motels", add
label define ind1990lbl 771 "Laundry, cleaning, and garment services", add
label define ind1990lbl 772 "Beauty shops", add
label define ind1990lbl 780 "Barber shops", add
label define ind1990lbl 781 "Funeral service and crematories", add
label define ind1990lbl 782 "Shoe repair shops", add
label define ind1990lbl 790 "Dressmaking shops", add
label define ind1990lbl 791 "Miscellaneous personal services ", add
label define ind1990lbl 800 "Theaters and motion pictures", add
label define ind1990lbl 801 "Video tape rental", add
label define ind1990lbl 802 "Bowling centers", add
label define ind1990lbl 810 "Miscellaneous entertainment and recreation services ", add
label define ind1990lbl 812 "Offices and clinics of physicians", add
label define ind1990lbl 820 "Offices and clinics of dentists", add
label define ind1990lbl 821 "Offices and clinics of chiropractors", add
label define ind1990lbl 822 "Offices and clinics of optometrists", add
label define ind1990lbl 830 "Offices and clinics of health practitioners, n.e.c.", add
label define ind1990lbl 831 "Hospitals", add
label define ind1990lbl 832 "Nursing and personal care facilities", add
label define ind1990lbl 840 "Health services, n.e.c.", add
label define ind1990lbl 841 "Legal services", add
label define ind1990lbl 842 "Elementary and secondary schools", add
label define ind1990lbl 850 "Colleges and universities", add
label define ind1990lbl 851 "Vocational schools", add
label define ind1990lbl 852 "Libraries", add
label define ind1990lbl 860 "Educational services, n.e.c.", add
label define ind1990lbl 861 "Job training and vocational rehabilitation services", add
label define ind1990lbl 862 "Child day care services", add
label define ind1990lbl 863 "Family child care homes", add
label define ind1990lbl 870 "Residential care facilities, without nursing", add
label define ind1990lbl 871 "Social services, n.e.c.", add
label define ind1990lbl 872 "Museums, art galleries, and zoos", add
label define ind1990lbl 873 "Labor unions", add
label define ind1990lbl 880 "Religious organizations", add
label define ind1990lbl 881 "Membership organizations, n.e.c.", add
label define ind1990lbl 882 "Engineering, architectural, and surveying services", add
label define ind1990lbl 890 "Accounting, auditing, and bookkeeping services", add
label define ind1990lbl 891 "Research, development, and testing services", add
label define ind1990lbl 892 "Management and public relations services", add
label define ind1990lbl 893 "Miscellaneous professional and related services ", add
label define ind1990lbl 900 "Executive and legislative offices", add
label define ind1990lbl 901 "General government, n.e.c.", add
label define ind1990lbl 910 "Justice, public order, and safety", add
label define ind1990lbl 921 "Public finance, taxation, and monetary policy", add
label define ind1990lbl 922 "Administration of human resources programs", add
label define ind1990lbl 930 "Administration of environmental quality and housing programs", add
label define ind1990lbl 931 "Administration of economic programs", add
label define ind1990lbl 932 "National security and international affairs ", add
label define ind1990lbl 940 "Army", add
label define ind1990lbl 941 "Air Force", add
label define ind1990lbl 942 "Navy", add
label define ind1990lbl 950 "Marines", add
label define ind1990lbl 951 "Coast Guard", add
label define ind1990lbl 952 "Armed Forces, branch not specified", add
label define ind1990lbl 960 "Military Reserves or National Guard ", add
label define ind1990lbl 992 "Last worked 1984 or earlier", add
label define ind1990lbl 999 "DID NOT RESPOND", add
label values ind1990 ind1990lbl

label values incwage incwagelbl

save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\native and immigrants\census90_5pc_2b_all.dta", replace

drop if bpl>=1 & bpl<=99
save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\immigrants\census90_2b_foreignborn.dta", replace


