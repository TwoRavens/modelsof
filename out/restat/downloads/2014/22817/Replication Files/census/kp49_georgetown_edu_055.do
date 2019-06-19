clear
set memory 500m

/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 byte    datanum       1-2 ///
 double  serial        3-10 ///
 byte    pernum       11-12 ///
 long    bpl          13-15 ///
 byte    citizen      16 ///
 byte    yrsusa1      17-18 ///
 byte    speakeng     19 ///
 byte    educ99       20-21 ///
 byte    empstatd     22-23 ///
 int     occ1990      24-26 ///
 using "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\census\kp49_georgetown_edu_055.dat"

drop if bpl>=1 & bpl<=99
generate year=2000

label var datanum "Data set number"
label var serial "Household serial number"
label var pernum "Person number in sample unit"
label var bpl "Birthplace [general version]"
label var citizen "Citizenship status"
label var yrsusa1 "Years in the United States"
label var speakeng "Speaks English"
label var educ99 "Educational attainment, 1990"
label var empstatd "Employment status [detailed version]"
label var occ1990 "Occupation, 1990 basis"

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

label define citizenlbl 0 "N/A"
label define citizenlbl 1 "Born abroad of American parents", add
label define citizenlbl 2 "Naturalized citizen", add
label define citizenlbl 3 "Not a citizen", add
label define citizenlbl 4 "Not a citizen, but has received first papers", add
label define citizenlbl 5 "Foreign born, citizenship status not reported", add
label values citizen citizenlbl

label values yrsusa1 yrsusa1lbl

label define speakenglbl 0 "N/A (Blank)"
label define speakenglbl 1 "Does not speak English", add
label define speakenglbl 2 "Yes, speaks English...", add
label define speakenglbl 3 "Yes, speaks only English", add
label define speakenglbl 4 "Yes, speaks very well", add
label define speakenglbl 5 "Yes, speaks well", add
label define speakenglbl 6 "Yes, but not well", add
label values speakeng speakenglbl

label define educ99lbl 00 "Not applicable"
label define educ99lbl 01 "No school completed", add
label define educ99lbl 02 "Nursery school", add
label define educ99lbl 03 "Kindergarten", add
label define educ99lbl 04 "1st-4th grade", add
label define educ99lbl 05 "5th-8th grade", add
label define educ99lbl 06 "9th grade", add
label define educ99lbl 07 "10th grade", add
label define educ99lbl 08 "11th grade", add
label define educ99lbl 09 "12th grade, no diploma", add
label define educ99lbl 10 "High school graduate, or GED", add
label define educ99lbl 11 "Some college, no degree", add
label define educ99lbl 12 "Associate degree, occupational program", add
label define educ99lbl 13 "Associate degree, academic program", add
label define educ99lbl 14 "Bachelors degree", add
label define educ99lbl 15 "Masters degree", add
label define educ99lbl 16 "Professional degree", add
label define educ99lbl 17 "Doctorate degree", add
label values educ99 educ99lbl

label define empstatdlbl 00 "N/A", add
label define empstatdlbl 10 "At work", add
label define empstatdlbl 11 "At work, public emerg", add
label define empstatdlbl 12 "Has job, not working", add
label define empstatdlbl 13 "Armed forces", add
label define empstatdlbl 14 "Armed forces--at work", add
label define empstatdlbl 15 "Armed forces--not at work but with job", add
label define empstatdlbl 20 "Unemployed", add
label define empstatdlbl 21 "Unemp, exper worker", add
label define empstatdlbl 22 "Unemp, new worker", add
label define empstatdlbl 30 "Not in Labor Force", add
label define empstatdlbl 31 "NILF, housework", add
label define empstatdlbl 32 "NILF, unable to work", add
label define empstatdlbl 33 "NILF, school", add
label define empstatdlbl 34 "NILF, other", add
label values empstatd empstatdlbl

label define occ1990lbl 003 "Legislators", add
label define occ1990lbl 004 "Chief executives and public administrators", add
label define occ1990lbl 007 "Financial managers", add
label define occ1990lbl 008 "Human resources and labor relations managers", add
label define occ1990lbl 013 "Managers and specialists in marketing, advertising, and public relations", add
label define occ1990lbl 014 "Managers in education and related fields", add
label define occ1990lbl 015 "Managers of medicine and health occupations", add
label define occ1990lbl 016 "Postmasters and mail superintendents", add
label define occ1990lbl 017 "Managers of food-serving and lodging establishments", add
label define occ1990lbl 018 "Managers of properties and real estate", add
label define occ1990lbl 019 "Funeral directors", add
label define occ1990lbl 021 "Managers of service organizations, n.e.c.", add
label define occ1990lbl 022 "Managers and administrators, n.e.c.", add
label define occ1990lbl 023 "Accountants and auditors", add
label define occ1990lbl 024 "Insurance underwriters", add
label define occ1990lbl 025 "Other financial specialists", add
label define occ1990lbl 026 "Management analysts", add
label define occ1990lbl 027 "Personnel, HR, training, and labor relations specialists", add
label define occ1990lbl 028 "Purchasing agents and buyers, of farm products", add
label define occ1990lbl 029 "Buyers, wholesale and retail trade", add
label define occ1990lbl 033 "Purchasing managers, agents and buyers, n.e.c.", add
label define occ1990lbl 034 "Business and promotion agents", add
label define occ1990lbl 035 "Construction inspectors", add
label define occ1990lbl 036 "Inspectors and compliance officers, outside construction", add
label define occ1990lbl 037 "Management support occupations", add
label define occ1990lbl 043 "Architects", add
label define occ1990lbl 044 "Aerospace engineer", add
label define occ1990lbl 045 "Metallurgical and materials engineers, variously phrased", add
label define occ1990lbl 047 "Petroleum, mining, and geological engineers", add
label define occ1990lbl 048 "Chemical engineers", add
label define occ1990lbl 053 "Civil engineers", add
label define occ1990lbl 055 "Electrical engineer", add
label define occ1990lbl 056 "Industrial engineers", add
label define occ1990lbl 057 "Mechanical engineers", add
label define occ1990lbl 059 "Not-elsewhere-classified engineers", add
label define occ1990lbl 064 "Computer systems analysts and computer scientists", add
label define occ1990lbl 065 "Operations and systems researchers and analysts", add
label define occ1990lbl 066 "Actuaries", add
label define occ1990lbl 067 "Statisticians", add
label define occ1990lbl 068 "Mathematicians and mathematical scientists", add
label define occ1990lbl 069 "Physicists and astronomers", add
label define occ1990lbl 073 "Chemists", add
label define occ1990lbl 074 "Atmospheric and space scientists", add
label define occ1990lbl 075 "Geologists", add
label define occ1990lbl 076 "Physical scientists, n.e.c.", add
label define occ1990lbl 077 "Agricultural and food scientists", add
label define occ1990lbl 078 "Biological scientists", add
label define occ1990lbl 079 "Foresters and conservation scientists", add
label define occ1990lbl 083 "Medical scientists", add
label define occ1990lbl 084 "Physicians", add
label define occ1990lbl 085 "Dentists", add
label define occ1990lbl 086 "Veterinarians", add
label define occ1990lbl 087 "Optometrists", add
label define occ1990lbl 088 "Podiatrists", add
label define occ1990lbl 089 "Other health and therapy", add
label define occ1990lbl 095 "Registered nurses", add
label define occ1990lbl 096 "Pharmacists", add
label define occ1990lbl 097 "Dietitians and nutritionists", add
label define occ1990lbl 098 "Respiratory therapists", add
label define occ1990lbl 099 "Occupational therapists", add
label define occ1990lbl 103 "Physical therapists", add
label define occ1990lbl 104 "Speech therapists", add
label define occ1990lbl 105 "Therapists, n.e.c.", add
label define occ1990lbl 106 "Physicians' assistants", add
label define occ1990lbl 113 "Earth, environmental, and marine science instructors", add
label define occ1990lbl 114 "Biological science instructors", add
label define occ1990lbl 115 "Chemistry instructors", add
label define occ1990lbl 116 "Physics instructors", add
label define occ1990lbl 118 "Psychology instructors", add
label define occ1990lbl 119 "Economics instructors", add
label define occ1990lbl 123 "History instructors", add
label define occ1990lbl 125 "Sociology instructors", add
label define occ1990lbl 127 "Engineering instructors", add
label define occ1990lbl 128 "Math instructors", add
label define occ1990lbl 139 "Education instructors", add
label define occ1990lbl 145 "Law instructors", add
label define occ1990lbl 147 "Theology instructors", add
label define occ1990lbl 149 "Home economics instructors", add
label define occ1990lbl 150 "Humanities profs/instructors, college, nec", add
label define occ1990lbl 154 "Subject instructors (HS/college)", add
label define occ1990lbl 155 "Kindergarten and earlier school teachers", add
label define occ1990lbl 156 "Primary school teachers", add
label define occ1990lbl 157 "Secondary school teachers", add
label define occ1990lbl 158 "Special education teachers", add
label define occ1990lbl 159 "Teachers , n.e.c.", add
label define occ1990lbl 163 "Vocational and educational counselors", add
label define occ1990lbl 164 "Librarians", add
label define occ1990lbl 165 "Archivists and curators", add
label define occ1990lbl 166 "Economists, market researchers, and survey researchers", add
label define occ1990lbl 167 "Psychologists", add
label define occ1990lbl 168 "Sociologists", add
label define occ1990lbl 169 "Social scientists, n.e.c.", add
label define occ1990lbl 173 "Urban and regional planners", add
label define occ1990lbl 174 "Social workers", add
label define occ1990lbl 175 "Recreation workers", add
label define occ1990lbl 176 "Clergy and religious workers", add
label define occ1990lbl 178 "Lawyers", add
label define occ1990lbl 179 "Judges", add
label define occ1990lbl 183 "Writers and authors", add
label define occ1990lbl 184 "Technical writers", add
label define occ1990lbl 185 "Designers", add
label define occ1990lbl 186 "Musician or composer", add
label define occ1990lbl 187 "Actors, directors, producers", add
label define occ1990lbl 188 "Art makers: painters, sculptors, craft-artists, and print-makers", add
label define occ1990lbl 189 "Photographers", add
label define occ1990lbl 193 "Dancers", add
label define occ1990lbl 194 "Art/entertainment performers and related", add
label define occ1990lbl 195 "Editors and reporters", add
label define occ1990lbl 198 "Announcers", add
label define occ1990lbl 199 "Athletes, sports instructors, and officials", add
label define occ1990lbl 200 "Professionals, n.e.c.", add
label define occ1990lbl 203 "Clinical laboratory technologies and technicians", add
label define occ1990lbl 204 "Dental hygenists", add
label define occ1990lbl 205 "Health record tech specialists", add
label define occ1990lbl 206 "Radiologic tech specialists", add
label define occ1990lbl 207 "Licensed practical nurses", add
label define occ1990lbl 208 "Health technologists and technicians, n.e.c.", add
label define occ1990lbl 213 "Electrical and electronic (engineering) technicians", add
label define occ1990lbl 214 "Engineering technicians, n.e.c.", add
label define occ1990lbl 215 "Mechanical engineering technicians", add
label define occ1990lbl 217 "Drafters", add
label define occ1990lbl 218 "Surveyors, cartographers, mapping scientists and technicians", add
label define occ1990lbl 223 "Biological technicians", add
label define occ1990lbl 224 "Chemical technicians", add
label define occ1990lbl 225 "Other science technicians", add
label define occ1990lbl 226 "Airplane pilots and navigators", add
label define occ1990lbl 227 "Air traffic controllers", add
label define occ1990lbl 228 "Broadcast equipment operators", add
label define occ1990lbl 229 "Computer software developers", add
label define occ1990lbl 233 "Programmers of numerically controlled machine tools", add
label define occ1990lbl 234 "Legal assistants, paralegals, legal support, etc", add
label define occ1990lbl 235 "Technicians, n.e.c.", add
label define occ1990lbl 243 "Supervisors and proprietors of sales jobs", add
label define occ1990lbl 253 "Insurance sales occupations", add
label define occ1990lbl 254 "Real estate sales occupations", add
label define occ1990lbl 255 "Financial services sales occupations", add
label define occ1990lbl 256 "Advertising and related sales jobs", add
label define occ1990lbl 258 "Sales engineers", add
label define occ1990lbl 274 "Salespersons, n.e.c.", add
label define occ1990lbl 275 "Retail sales clerks", add
label define occ1990lbl 276 "Cashiers", add
label define occ1990lbl 277 "Door-to-door sales, street sales, and news vendors", add
label define occ1990lbl 283 "Sales demonstrators / promoters / models", add
label define occ1990lbl 303 "Office supervisors", add
label define occ1990lbl 308 "Computer and peripheral equipment operators", add
label define occ1990lbl 313 "Secretaries", add
label define occ1990lbl 314 "Stenographers", add
label define occ1990lbl 315 "Typists", add
label define occ1990lbl 316 "Interviewers, enumerators, and surveyors", add
label define occ1990lbl 317 "Hotel clerks", add
label define occ1990lbl 318 "Transportation ticket and reservation agents", add
label define occ1990lbl 319 "Receptionists", add
label define occ1990lbl 323 "Information clerks, nec", add
label define occ1990lbl 326 "Correspondence and order clerks", add
label define occ1990lbl 328 "Human resources clerks, except payroll and timekeeping", add
label define occ1990lbl 329 "Library assistants", add
label define occ1990lbl 335 "File clerks", add
label define occ1990lbl 336 "Records clerks", add
label define occ1990lbl 337 "Bookkeepers and accounting and auditing clerks", add
label define occ1990lbl 338 "Payroll and timekeeping clerks", add
label define occ1990lbl 343 "Cost and rate clerks (financial records processing)", add
label define occ1990lbl 344 "Billing clerks and related financial records processing", add
label define occ1990lbl 345 "Duplication machine operators / office machine operators", add
label define occ1990lbl 346 "Mail and paper handlers", add
label define occ1990lbl 347 "Office machine operators, n.e.c.", add
label define occ1990lbl 348 "Telephone operators", add
label define occ1990lbl 349 "Other telecom operators", add
label define occ1990lbl 354 "Postal clerks, excluding mail carriers", add
label define occ1990lbl 355 "Mail carriers for postal service", add
label define occ1990lbl 356 "Mail clerks, outside of post office", add
label define occ1990lbl 357 "Messengers", add
label define occ1990lbl 359 "Dispatchers", add
label define occ1990lbl 361 "Inspectors, n.e.c.", add
label define occ1990lbl 364 "Shipping and receiving clerks", add
label define occ1990lbl 365 "Stock and inventory clerks", add
label define occ1990lbl 366 "Meter readers", add
label define occ1990lbl 368 "Weighers, measurers, and checkers", add
label define occ1990lbl 373 "Material recording, scheduling, production, planning, and expediting clerks", add
label define occ1990lbl 375 "Insurance adjusters, examiners, and investigators", add
label define occ1990lbl 376 "Customer service reps, investigators and adjusters, except insurance", add
label define occ1990lbl 377 "Eligibility clerks for government programs; social welfare", add
label define occ1990lbl 378 "Bill and account collectors", add
label define occ1990lbl 379 "General office clerks", add
label define occ1990lbl 383 "Bank tellers", add
label define occ1990lbl 384 "Proofreaders", add
label define occ1990lbl 385 "Data entry keyers", add
label define occ1990lbl 386 "Statistical clerks", add
label define occ1990lbl 387 "Teacher's aides", add
label define occ1990lbl 389 "Administrative support jobs, n.e.c.", add
label define occ1990lbl 405 "Housekeepers, maids, butlers, stewards, and lodging quarters cleaners", add
label define occ1990lbl 407 "Private household cleaners and servants", add
label define occ1990lbl 415 "Supervisors of guards", add
label define occ1990lbl 417 "Fire fighting, prevention, and inspection", add
label define occ1990lbl 418 "Police, detectives, and private investigators", add
label define occ1990lbl 423 "Other law enforcement: sheriffs, bailiffs, correctional institution officers", add
label define occ1990lbl 425 "Crossing guards and bridge tenders", add
label define occ1990lbl 426 "Guards, watchmen, doorkeepers", add
label define occ1990lbl 427 "Protective services, n.e.c.", add
label define occ1990lbl 434 "Bartenders", add
label define occ1990lbl 435 "Waiter/waitress", add
label define occ1990lbl 436 "Cooks, variously defined", add
label define occ1990lbl 438 "Food counter and fountain workers", add
label define occ1990lbl 439 "Kitchen workers", add
label define occ1990lbl 443 "Waiter's assistant", add
label define occ1990lbl 444 "Misc food prep workers", add
label define occ1990lbl 445 "Dental assistants", add
label define occ1990lbl 446 "Health aides, except nursing", add
label define occ1990lbl 447 "Nursing aides, orderlies, and attendants", add
label define occ1990lbl 448 "Supervisors of cleaning and building service", add
label define occ1990lbl 453 "Janitors", add
label define occ1990lbl 454 "Elevator operators", add
label define occ1990lbl 455 "Pest control occupations", add
label define occ1990lbl 456 "Supervisors of personal service jobs, n.e.c.", add
label define occ1990lbl 457 "Barbers", add
label define occ1990lbl 458 "Hairdressers and cosmetologists", add
label define occ1990lbl 459 "Recreation facility attendants", add
label define occ1990lbl 461 "Guides", add
label define occ1990lbl 462 "Ushers", add
label define occ1990lbl 463 "Public transportation attendants and inspectors", add
label define occ1990lbl 464 "Baggage porters", add
label define occ1990lbl 465 "Welfare service aides", add
label define occ1990lbl 468 "Child care workers", add
label define occ1990lbl 469 "Personal service occupations, nec", add
label define occ1990lbl 473 "Farmers (owners and tenants)", add
label define occ1990lbl 474 "Horticultural specialty farmers", add
label define occ1990lbl 475 "Farm managers, except for horticultural farms", add
label define occ1990lbl 476 "Managers of horticultural specialty farms", add
label define occ1990lbl 479 "Farm workers", add
label define occ1990lbl 483 "Marine life cultivation workers", add
label define occ1990lbl 484 "Nursery farming workers", add
label define occ1990lbl 485 "Supervisors of agricultural occupations", add
label define occ1990lbl 486 "Gardeners and groundskeepers", add
label define occ1990lbl 487 "Animal caretakers except on farms", add
label define occ1990lbl 488 "Graders and sorters of agricultural products", add
label define occ1990lbl 489 "Inspectors of agricultural products", add
label define occ1990lbl 496 "Timber, logging, and forestry workers", add
label define occ1990lbl 498 "Fishers, hunters, and kindred", add
label define occ1990lbl 503 "Supervisors of mechanics and repairers", add
label define occ1990lbl 505 "Automobile mechanics", add
label define occ1990lbl 507 "Bus, truck, and stationary engine mechanics", add
label define occ1990lbl 508 "Aircraft mechanics", add
label define occ1990lbl 509 "Small engine repairers", add
label define occ1990lbl 514 "Auto body repairers", add
label define occ1990lbl 516 "Heavy equipment and farm equipment mechanics", add
label define occ1990lbl 518 "Industrial machinery repairers", add
label define occ1990lbl 519 "Machinery maintenance occupations", add
label define occ1990lbl 523 "Repairers of industrial electrical equipment", add
label define occ1990lbl 525 "Repairers of data processing equipment", add
label define occ1990lbl 526 "Repairers of household appliances and power tools", add
label define occ1990lbl 527 "Telecom and line installers and repairers", add
label define occ1990lbl 533 "Repairers of electrical equipment, n.e.c.", add
label define occ1990lbl 534 "Heating, air conditioning, and refigeration mechanics", add
label define occ1990lbl 535 "Precision makers, repairers, and smiths", add
label define occ1990lbl 536 "Locksmiths and safe repairers", add
label define occ1990lbl 538 "Office machine repairers and mechanics", add
label define occ1990lbl 539 "Repairers of mechanical controls and valves", add
label define occ1990lbl 543 "Elevator installers and repairers", add
label define occ1990lbl 544 "Millwrights", add
label define occ1990lbl 549 "Mechanics and repairers, n.e.c.", add
label define occ1990lbl 558 "Supervisors of construction work", add
label define occ1990lbl 563 "Masons, tilers, and carpet installers", add
label define occ1990lbl 567 "Carpenters", add
label define occ1990lbl 573 "Drywall installers", add
label define occ1990lbl 575 "Electricians", add
label define occ1990lbl 577 "Electric power installers and repairers", add
label define occ1990lbl 579 "Painters, construction and maintenance", add
label define occ1990lbl 583 "Paperhangers", add
label define occ1990lbl 584 "Plasterers", add
label define occ1990lbl 585 "Plumbers, pipe fitters, and steamfitters", add
label define occ1990lbl 588 "Concrete and cement workers", add
label define occ1990lbl 589 "Glaziers", add
label define occ1990lbl 593 "Insulation workers", add
label define occ1990lbl 594 "Paving, surfacing, and tamping equipment operators", add
label define occ1990lbl 595 "Roofers and slaters", add
label define occ1990lbl 596 "Sheet metal duct installers", add
label define occ1990lbl 597 "Structural metal workers", add
label define occ1990lbl 598 "Drillers of earth", add
label define occ1990lbl 599 "Construction trades, n.e.c.", add
label define occ1990lbl 614 "Drillers of oil wells", add
label define occ1990lbl 615 "Explosives workers", add
label define occ1990lbl 616 "Miners", add
label define occ1990lbl 617 "Other mining occupations", add
label define occ1990lbl 628 "Production supervisors or foremen", add
label define occ1990lbl 634 "Tool and die makers and die setters", add
label define occ1990lbl 637 "Machinists", add
label define occ1990lbl 643 "Boilermakers", add
label define occ1990lbl 644 "Precision grinders and filers", add
label define occ1990lbl 645 "Patternmakers and model makers", add
label define occ1990lbl 646 "Lay-out workers", add
label define occ1990lbl 649 "Engravers", add
label define occ1990lbl 653 "Tinsmiths, coppersmiths, and sheet metal workers", add
label define occ1990lbl 657 "Cabinetmakers and bench carpenters", add
label define occ1990lbl 658 "Furniture and wood finishers", add
label define occ1990lbl 659 "Other precision woodworkers", add
label define occ1990lbl 666 "Dressmakers and seamstresses", add
label define occ1990lbl 667 "Tailors", add
label define occ1990lbl 668 "Upholsterers", add
label define occ1990lbl 669 "Shoe repairers", add
label define occ1990lbl 674 "Other precision apparel and fabric workers", add
label define occ1990lbl 675 "Hand molders and shapers, except jewelers", add
label define occ1990lbl 677 "Optical goods workers", add
label define occ1990lbl 678 "Dental laboratory and medical appliance technicians", add
label define occ1990lbl 679 "Bookbinders", add
label define occ1990lbl 684 "Other precision and craft workers", add
label define occ1990lbl 686 "Butchers and meat cutters", add
label define occ1990lbl 687 "Bakers", add
label define occ1990lbl 688 "Batch food makers", add
label define occ1990lbl 693 "Adjusters and calibrators", add
label define occ1990lbl 694 "Water and sewage treatment plant operators", add
label define occ1990lbl 695 "Power plant operators", add
label define occ1990lbl 696 "Plant and system operators, stationary engineers", add
label define occ1990lbl 699 "Other plant and system operators", add
label define occ1990lbl 703 "Lathe, milling, and turning machine operatives", add
label define occ1990lbl 706 "Punching and stamping press operatives", add
label define occ1990lbl 707 "Rollers, roll hands, and finishers of metal", add
label define occ1990lbl 708 "Drilling and boring machine operators", add
label define occ1990lbl 709 "Grinding, abrading, buffing, and polishing workers", add
label define occ1990lbl 713 "Forge and hammer operators", add
label define occ1990lbl 717 "Fabricating machine operators, n.e.c.", add
label define occ1990lbl 719 "Molders, and casting machine operators", add
label define occ1990lbl 723 "Metal platers", add
label define occ1990lbl 724 "Heat treating equipment operators", add
label define occ1990lbl 726 "Wood lathe, routing, and planing machine operators", add
label define occ1990lbl 727 "Sawing machine operators and sawyers", add
label define occ1990lbl 728 "Shaping and joining machine operator (woodworking)", add
label define occ1990lbl 729 "Nail and tacking machine operators  (woodworking)", add
label define occ1990lbl 733 "Other woodworking machine operators", add
label define occ1990lbl 734 "Printing machine operators, n.e.c.", add
label define occ1990lbl 735 "Photoengravers and lithographers", add
label define occ1990lbl 736 "Typesetters and compositors", add
label define occ1990lbl 738 "Winding and twisting textile/apparel operatives", add
label define occ1990lbl 739 "Knitters, loopers, and toppers textile operatives", add
label define occ1990lbl 743 "Textile cutting machine operators", add
label define occ1990lbl 744 "Textile sewing machine operators", add
label define occ1990lbl 745 "Shoemaking machine operators", add
label define occ1990lbl 747 "Pressing machine operators (clothing)", add
label define occ1990lbl 748 "Laundry workers", add
label define occ1990lbl 749 "Misc textile machine operators", add
label define occ1990lbl 753 "Cementing and gluing maching operators", add
label define occ1990lbl 754 "Packers, fillers, and wrappers", add
label define occ1990lbl 755 "Extruding and forming machine operators", add
label define occ1990lbl 756 "Mixing and blending machine operatives", add
label define occ1990lbl 757 "Separating, filtering, and clarifying machine operators", add
label define occ1990lbl 759 "Painting machine operators", add
label define occ1990lbl 763 "Roasting and baking machine operators (food)", add
label define occ1990lbl 764 "Washing, cleaning, and pickling machine operators", add
label define occ1990lbl 765 "Paper folding machine operators", add
label define occ1990lbl 766 "Furnace, kiln, and oven operators, apart from food", add
label define occ1990lbl 768 "Crushing and grinding machine operators", add
label define occ1990lbl 769 "Slicing and cutting machine operators", add
label define occ1990lbl 773 "Motion picture projectionists", add
label define occ1990lbl 774 "Photographic process workers", add
label define occ1990lbl 779 "Machine operators, n.e.c.", add
label define occ1990lbl 783 "Welders and metal cutters", add
label define occ1990lbl 784 "Solderers", add
label define occ1990lbl 785 "Assemblers of electrical equipment", add
label define occ1990lbl 789 "Hand painting, coating, and decorating occupations", add
label define occ1990lbl 796 "Production checkers and inspectors", add
label define occ1990lbl 799 "Graders and sorters in manufacturing", add
label define occ1990lbl 803 "Supervisors of motor vehicle transportation", add
label define occ1990lbl 804 "Truck, delivery, and tractor drivers", add
label define occ1990lbl 808 "Bus drivers", add
label define occ1990lbl 809 "Taxi cab drivers and chauffeurs", add
label define occ1990lbl 813 "Parking lot attendants", add
label define occ1990lbl 823 "Railroad conductors and yardmasters", add
label define occ1990lbl 824 "Locomotive operators (engineers and firemen)", add
label define occ1990lbl 825 "Railroad brake, coupler, and switch operators", add
label define occ1990lbl 829 "Ship crews and marine engineers", add
label define occ1990lbl 834 "Water transport infrastructure tenders and crossing guards", add
label define occ1990lbl 844 "Operating engineers of construction equipment", add
label define occ1990lbl 848 "Crane, derrick, winch, and hoist operators", add
label define occ1990lbl 853 "Excavating and loading machine operators", add
label define occ1990lbl 859 "Misc material moving occupations", add
label define occ1990lbl 865 "Helpers, constructions", add
label define occ1990lbl 866 "Helpers, surveyors", add
label define occ1990lbl 869 "Construction laborers", add
label define occ1990lbl 873 "Production helpers", add
label define occ1990lbl 875 "Garbage and recyclable material collectors", add
label define occ1990lbl 876 "Materials movers: stevedores and longshore workers", add
label define occ1990lbl 877 "Stock handlers", add
label define occ1990lbl 878 "Machine feeders and offbearers", add
label define occ1990lbl 883 "Freight, stock, and materials handlers", add
label define occ1990lbl 885 "Garage and service station related occupations", add
label define occ1990lbl 887 "Vehicle washers and equipment cleaners", add
label define occ1990lbl 888 "Packers and packagers by hand", add
label define occ1990lbl 889 "Laborers outside construction", add
label define occ1990lbl 905 "Military", add
label define occ1990lbl 991 "Unemployed", add
label define occ1990lbl 999 "Unknown", add
label values occ1990 occ1990lbl

save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\immigrants\census00_1b_foreignborn.dta", replace
