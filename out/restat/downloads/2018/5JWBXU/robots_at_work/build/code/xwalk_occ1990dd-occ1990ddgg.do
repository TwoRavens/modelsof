* create occ1990ddgg codes - consistent 1970-2008
* based on occ1990dd

merge m:1 occ1990dd using "..\input\Autor-Dorn\occ1990dd-occ1990ddgg"
	tab _merge
	drop if _merge==2 
	drop _merge

	
/*	
recode occ1990dd 	( 4 = 7 ) ///
					( 7 = 7 ) ///
					( 8 = 7 ) ///
					( 13 = 13 ) ///
					( 14 = 14 ) ///
					( 15 = 15 ) ///
					( 18 = 18 ) ///
					( 19 = 19 ) ///
					( 22 = 22 ) ///
					( 23 = 23 ) ///
					( 24 = 23 ) ///
					( 25 = 23 ) ///
					( 26 = 22 ) ///
					( 27 = 22 ) ///
					( 28 = 28 ) ///
					( 29 = 29 ) ///
					( 33 = 33 ) ///
					( 34 = 22 ) ///
					( 35 = 35 ) ///
					( 558 = 35 ) ///
					( 36 = 36 ) ///
					( 37 = 22 ) ///
					( 43 = 43 ) ///
					( 44 = 44 ) ///
					( 45 = 45 ) ///
					( 47 = 47 ) ///
					( 48 = 48 ) ///
					( 53 = 53 ) ///
					( 55 = 55 ) ///
					( 56 = 56 ) ///
					( 57 = 57 ) ///
					( 59 = 59 ) ///
					( 64 = 64 ) ///
					( 65 = 65 ) ///
					( 66 = 66 ) ///
					( 68 = 68 ) ///
					( 69 = 69 ) ///
					( 73 = 73 ) ///
					( 74 = 74 ) ///
					( 75 = 75 ) ///
					( 76 = 76 ) ///
					( 77 = 77 ) ///
					( 78 = 78 ) ///
					( 79 = 79 ) ///
					( 83 = 78 ) ///
					( 84 = 84 ) ///
					( 85 = 85 ) ///
					( 86 = 86 ) ///
					( 87 = 87 ) ///
					( 88 = 88 ) ///
					( 89 = 89 ) ///
					( 95 = 95 ) ///
					( 96 = 96 ) ///
					( 97 = 97 ) ///
					( 98 = 105 ) ///
					( 99 = 105 ) ///
					( 103 = 105 ) ///
					( 104 = 105 ) ///
					( 105 = 105 ) ///
					( 106 = 105 ) ///
					( 154 = 154 ) ///
					( 155 = 155 ) ///
					( 156 = 156 ) ///
					( 157 = 157 ) ///
					( 158 = 159 ) ///
					( 159 = 159 ) ///
					( 163 = 163 ) ///
					( 164 = 164 ) ///
					( 165 = 165 ) ///
					( 166 = 166 ) ///
					( 167 = 167 ) ///
					( 169 = 169 ) ///
					( 173 = 173 ) ///
					( 174 = 174 ) ///
					( 176 = 176 ) ///
					( 177 = 177 ) ///
					( 178 = 178 ) ///
					( 183 = 183 ) ///
					( 184 = 185 ) ///
					( 185 = 185 ) ///
					( 186 = 186 ) ///
					( 187 = 187 ) ///
					( 188 = 188 ) ///
					( 189 = 189 ) ///
					( 193 = 193 ) ///
					( 194 = 194 ) ///
					( 195 = 195 ) ///
					( 198 = 198 ) ///
					( 199 = 199 ) ///
					( 203 = 203 ) ///
					( 204 = 204 ) ///
					( 205 = 205 ) ///
					( 206 = 206 ) ///
					( 207 = 207 ) ///
					( 208 = 208 ) ///
					( 214 = 214 ) ///
					( 217 = 217 ) ///
					( 218 = 218 ) ///
					( 223 = 223 ) ///
					( 224 = 224 ) ///
					( 225 = 225 ) ///
					( 226 = 226 ) ///
					( 227 = 227 ) ///
					( 228 = 228 ) ///
					( 229 = 229 ) ///
					( 233 = 233 ) ///
					( 234 = 313 ) ///
					( 235 = 225 ) ///
					( 243 = 274 ) ///
					( 253 = 253 ) ///
					( 254 = 254 ) ///
					( 255 = 255 ) ///
					( 256 = 256 ) ///
					( 258 = 258 ) ///
					( 274 = 274 ) ///
					( 275 = 275 ) ///
					( 276 = 276 ) ///
					( 277 = 277 ) ///
					( 283 = 283 ) ///
					( 303 = 303 ) ///
					( 308 = 308 ) ///
					( 313 = 313 ) ///
					( 315 = 313 ) ///
					( 316 = 316 ) ///
					( 317 = 319 ) ///
					( 318 = 318 ) ///
					( 319 = 319 ) ///
					( 326 = 319 ) ///
					( 328 = 328 ) ///
					( 329 = 329 ) ///
					( 335 = 335 ) ///
					( 336 = 335 ) ///
					( 337 = 337 ) ///
					( 338 = 338 ) ///
					( 344 = 344 ) ///
					( 346 = 346 ) ///
					( 347 = 347 ) ///
					( 348 = 348 ) ///
					( 349 = 349 ) ///
					( 354 = 354 ) ///
					( 355 = 355 ) ///
					( 356 = 354 ) ///
					( 357 = 357 ) ///
					( 359 = 359 ) ///
					( 364 = 364 ) ///
					( 365 = 365 ) ///
					( 366 = 366 ) ///
					( 368 = 368 ) ///
					( 373 = 373 ) ///
					( 375 = 375 ) ///
					( 376 = 376 ) ///
					( 377 = 375 ) ///
					( 378 = 378 ) ///
					( 379 = 389 ) ///
					( 383 = 383 ) ///
					( 384 = 384 ) ///
					( 385 = 385 ) ///
					( 386 = 386 ) ///
					( 387 = 389 ) ///
					( 389 = 389 ) ///
					( 405 = 405 ) ///
					( 408 = 408 ) ///
					( 415 = 423 ) ///
					( 417 = 417 ) ///
					( 418 = 418 ) ///
					( 423 = 423 ) ///
					( 425 = 425 ) ///
					( 426 = 426 ) ///
					( 427 = 426 ) ///
					( 433 = 436 ) ///
					( 434 = 434 ) ///
					( 435 = 435 ) ///
					( 436 = 436 ) ///
					( 439 = 444 ) ///
					( 444 = 444 ) ///
					( 445 = 445 ) ///
					( 447 = 447 ) ///
					( 448 = 453 ) ///
					( 450 = 453 ) ///
					( 451 = 451 ) ///
					( 453 = 453 ) ///
					( 455 = 451 ) ///
					( 457 = 457 ) ///
					( 458 = 458 ) ///
					( 459 = 459 ) ///
					( 461 = 459 ) ///
					( 462 = 462 ) ///
					( 464 = 464 ) ///
					( 466 = 466 ) ///
					( 467 = 467 ) ///
					( 468 = 468 ) ///
					( 469 = 469 ) ///
					( 470 = 469 ) ///
					( 471 = 471 ) ///
					( 472 = 472 ) ///
					( 473 = 473 ) ///
					( 475 = 473 ) ///
					( 479 = 479 ) ///
					( 488 = 479 ) ///
					( 489 = 479 ) ///
					( 496 = 496 ) ///
					( 498 = 498 ) ///
					( 503 = 505 ) ///
					( 505 = 505 ) ///
					( 507 = 514 ) ///
					( 508 = 508 ) ///
					( 509 = 514 ) ///
					( 514 = 514 ) ///
					( 516 = 516 ) ///
					( 518 = 519 ) ///
					( 519 = 519 ) ///
					( 523 = 523 ) ///
					( 525 = 525 ) ///
					( 526 = 526 ) ///
					( 527 = 527 ) ///
					( 533 = 533 ) ///
					( 534 = 534 ) ///
					( 535 = 535 ) ///
					( 536 = 535 ) ///
					( 539 = 549 ) ///
					( 543 = 549 ) ///
					( 544 = 544 ) ///
					( 549 = 549 ) ///
					( 563 = 563 ) ///
					( 567 = 567 ) ///
					( 789 = 567 ) ///
					( 573 = 573 ) ///
					( 575 = 575 ) ///
					( 577 = 577 ) ///
					( 579 = 579 ) ///
					( 583 = 583 ) ///
					( 584 = 584 ) ///
					( 585 = 585 ) ///
					( 588 = 588 ) ///
					( 589 = 589 ) ///
					( 593 = 593 ) ///
					( 594 = 594 ) ///
					( 595 = 595 ) ///
					( 597 = 597 ) ///
					( 598 = 598 ) ///
					( 599 = 599 ) ///
					( 614 = 598 ) ///
					( 615 = 615 ) ///
					( 616 = 616 ) ///
					( 617 = 616 ) ///
					( 628 = 628 ) ///
					( 634 = 634 ) ///
					( 637 = 637 ) ///
					( 643 = 643 ) ///
					( 644 = 649 ) ///
					( 645 = 645 ) ///
					( 649 = 649 ) ///
					( 653 = 645 ) ///
					( 657 = 657 ) ///
					( 658 = 658 ) ///
					( 666 = 666 ) ///
					( 668 = 668 ) ///
					( 669 = 669 ) ///
					( 675 = 675 ) ///
					( 677 = 677 ) ///
					( 678 = 678 ) ///
					( 679 = 679 ) ///
					( 684 = 679 ) ///
					( 686 = 686 ) ///
					( 687 = 687 ) ///
					( 688 = 687 ) ///
					( 694 = 695 ) ///
					( 695 = 695 ) ///
					( 696 = 696 ) ///
					( 699 = 696 ) ///
					( 703 = 703 ) ///
					( 706 = 706 ) ///
					( 707 = 707 ) ///
					( 708 = 708 ) ///
					( 709 = 709 ) ///
					( 713 = 713 ) ///
					( 719 = 719 ) ///
					( 723 = 723 ) ///
					( 724 = 724 ) ///
					( 727 = 727 ) ///
					( 729 = 727 ) ///
					( 733 = 727 ) ///
					( 734 = 734 ) ///
					( 736 = 736 ) ///
					( 738 = 738 ) ///
					( 739 = 739 ) ///
					( 743 = 744 ) ///
					( 744 = 744 ) ///
					( 745 = 745 ) ///
					( 747 = 749 ) ///
					( 749 = 749 ) ///
					( 753 = 779 ) ///
					( 754 = 754 ) ///
					( 755 = 779 ) ///
					( 756 = 756 ) ///
					( 757 = 779 ) ///
					( 763 = 779 ) ///
					( 764 = 779 ) ///
					( 765 = 779 ) ///
					( 766 = 766 ) ///
					( 769 = 769 ) ///
					( 774 = 774 ) ///
					( 779 = 779 ) ///
					( 783 = 783 ) ///
					( 785 = 785 ) ///
					( 799 = 799 ) ///
					( 878 = 799 ) ///
					( 873 = 799 ) ///
					( 803 = 804 ) ///
					( 804 = 804 ) ///
					( 808 = 808 ) ///
					( 809 = 809 ) ///
					( 813 = 813 ) ///
					( 823 = 823 ) ///
					( 824 = 824 ) ///
					( 825 = 825 ) ///
					( 829 = 829 ) ///
					( 834 = 829 ) ///
					( 844 = 844 ) ///
					( 848 = 848 ) ///
					( 853 = 848 ) ///
					( 859 = 859 ) ///
					( 865 = 866 ) ///
					( 866 = 866 ) ///
					( 869 = 869 ) ///
					( 875 = 875 ) ///
					( 885 = 885 ) ///
					( 887 = 887 ) ///
					( 888 = 888 ) ///
					( 888 = 888 ), gen(occ1990ddgg)
*/


la def occ1990ddgg 	7 "Chief executives, public administrators, legislators, financial managers, human resources and labor relations managers" ///
					7 "Chief executives, public administrators, legislators, financial managers, human resources and labor relations managers" ///
					7 "Chief executives, public administrators, legislators, financial managers, human resources and labor relations managers" ///
					13 "Managers and specialists in marketing, advert., PR" ///
					14 "Managers in education and related fields" ///
					15 "Managers of medicine and health occupations" ///
					18 "Managers of properties and real estate" ///
					19 "Funeral directors" ///
					22 "Management support occupations, managers and administrators n.e.c." ///
					23 "Accountants, auditors, insurance underwriters and other financial specialists" ///
					23 "Accountants, auditors, insurance underwriters and other financial specialists" ///
					23 "Accountants, auditors, insurance underwriters and other financial specialists" ///
					22 "Management support occupations, managers and administrators n.e.c." ///
					22 "Management support occupations, managers and administrators n.e.c." ///
					28 "Purchasing agents and buyers of farm products" ///
					29 "Buyers, wholesale and retail trade" ///
					33 "Purchasing managers, agents, and buyers, n.e.c." ///
					22 "Management support occupations, managers and administrators n.e.c." ///
					35 "Construction inspectors and supervisors of construction work" ///
					35 "Construction inspectors and supervisors of construction work" ///
					36 "Inspectors and compliance officers, outside" ///
					22 "Management support occupations, managers and administrators n.e.c." ///
					43 "Architects" ///
					44 "Aerospace engineers" ///
					45 "Metallurgical and materials engineers" ///
					47 "Petroleum, mining, and geological engineers" ///
					48 "Chemical engineers" ///
					53 "Civil engineers" ///
					55 "Electrical engineers" ///
					56 "Industrial engineers" ///
					57 "Mechanical engineers" ///
					59 "Engineers and other professionals, n.e.c." ///
					64 "Computer systems analysts and computer scientists" ///
					65 "Operations and systems researchers and analysts" ///
					66 "Actuaries" ///
					68 "Mathematicians and statisticians" ///
					69 "Physicists and astronomists" ///
					73 "Chemists" ///
					74 "Atmospheric and space scientists" ///
					75 "Geologists" ///
					76 "Physical scientists, n.e.c." ///
					77 "Agricultural and food scientists" ///
					78 "Biological and medical scientists" ///
					79 "Foresters and conservation scientists" ///
					78 "Biological and medical scientists" ///
					84 "Physicians" ///
					85 "Dentists" ///
					86 "Veterinarians" ///
					87 "Optometrists" ///
					88 "Podiatrists" ///
					89 "Other health and therapy occupations" ///
					95 "Registered nurses" ///
					96 "Pharmacists" ///
					97 "Dieticians and nutritionists" ///
					105 "Therapists, n.e.c." ///
					105 "Therapists, n.e.c." ///
					105 "Therapists, n.e.c." ///
					105 "Therapists, n.e.c." ///
					105 "Therapists, n.e.c." ///
					105 "Therapists, n.e.c." ///
					154 "Subject instructors, college" ///
					155 "Kindergarten and earlier school teachers" ///
					156 "Primary school teachers" ///
					157 "Secondary school teachers" ///
					159 "Teachers, n.e.c." ///
					159 "Teachers, n.e.c." ///
					163 "Vocational and educational counselors" ///
					164 "Librarians" ///
					165 "Archivists and curators" ///
					166 "Economists, market and survey researchers" ///
					167 "Psychologists" ///
					169 "Social scientists and sociologists, n.e.c." ///
					173 "Urban and regional planners" ///
					174 "Social workers" ///
					176 "Clergy and religious workers" ///
					177 "Welfare service workers" ///
					178 "Lawyers and judges" ///
					183 "Writers and authors" ///
					185 "Designers and technical writers" ///
					185 "Designers and technical writers" ///
					186 "Musicians and composers" ///
					187 "Actors, directors, and producers" ///
					188 "Painters, sculptors, craft-artists, and print-makers" ///
					189 "Photographers" ///
					193 "Dancers" ///
					194 "Art/entertainment performers and related occs" ///
					195 "Editors and reporters" ///
					198 "Announcers" ///
					199 "Athletes, sports instructors, and officials" ///
					203 "Clinical laboratory technologies and technicians" ///
					204 "Dental hygienists" ///
					205 "Health record technologists and technicians" ///
					206 "Radiologic technologists and technicians" ///
					207 "Licensed practical nurses" ///
					208 "Health technologists and technicians, n.e.c." ///
					214 "Engineering technicians" ///
					217 "Drafters" ///
					218 "Surveryors, cartographers, mapping scientists/techs" ///
					223 "Biological technicians" ///
					224 "Chemical technicians" ///
					225 "Other science technicians and technicians n.e.c." ///
					226 "Airplane pilots and navigators" ///
					227 "Air traffic controllers" ///
					228 "Broadcast equipment operators" ///
					229 "Computer software developers" ///
					233 "Programmers of numerically controlled machine tools" ///
					313 "Secretaries, stenographers and legal assistants" ///
					225 "Other science technicians and technicians n.e.c." ///
					274 "Sales supervisors and proprietors, salespersons n.e.c." ///
					253 "Insurance sales occupations" ///
					254 "Real estate sales occupations" ///
					255 "Financial service sales occupations" ///
					256 "Advertising and related sales jobs" ///
					258 "Sales engineers" ///
					274 "Salespersons, n.e.c." ///
					275 "Retail salespersons and sales clerks" ///
					276 "Cashiers" ///
					277 "Door-to-door sales, street sales, and news vendors" ///
					283 "Sales demonstrators, promoters, and models" ///
					303 "Office supervisors" ///
					308 "Computer and peripheral equipment operators" ///
					313 "Secretaries, stenographers and legal assistants" ///
					313 "Secretaries, stenographers and legal assistants" ///
					316 "Interviewers, enumerators, and surveyors" ///
					319 "Receptionists and other information clerks" ///
					318 "Transportation ticket and reservation agents" ///
					319 "Receptionists and other information clerks" ///
					319 "Receptionists and other information clerks" ///
					328 "Human resources clerks, excl payroll and timekeeping" ///
					329 "Library assistants" ///
					335 "File clerks" ///
					335 "File clerks" ///
					337 "Bookkeepers and accounting and auditing clerks" ///
					338 "Payroll and timekeeping clerks" ///
					344 "Billing clerks and related financial records processing" ///
					346 "Mail and paper handlers" ///
					347 "Office machine operators, n.e.c." ///
					348 "Telephone operators" ///
					349 "Other telecom operators" ///
					354 "Postal clerks, exluding mail carriers" ///
					355 "Mail carriers for postal service" ///
					354 "Postal clerks, exluding mail carriers" ///
					357 "Messengers" ///
					359 "Dispatchers" ///
					364 "Shipping and receiving clerks" ///
					365 "Stock and inventory clerks" ///
					366 "Meter readers" ///
					368 "Weighers, measurers, and checkers" ///
					373 "Material recording, sched., prod., plan., expediting cl." ///
					375 "Insurance adjusters, eligibility clerks for government programs" ///
					376 "Customer service reps, invest., adjusters, excl. insur." ///
					375 "Insurance adjusters, eligibility clerks for government programs" ///
					378 "Bill and account collectors" ///
					389 "General office clerks and administrative support jobs n.e.c." ///
					383 "Bank tellers" ///
					384 "Proofreaders" ///
					385 "Data entry keyers" ///
					386 "Statistical clerks" ///
					389 "General office clerks and administrative support jobs n.e.c." ///
					389 "General office clerks and administrative support jobs n.e.c." ///
					405 "Housekeepers, maids, butlers, and cleaners" ///
					408 "Laundry and dry cleaning workers" ///
					423 "Sheriffs, bailiffs, correctional institution officers, and supervisors of guards" ///
					417 "Fire fighting, fire prevention, and fire inspection occs" ///
					418 "Police and detectives, public service" ///
					423 "Sheriffs, bailiffs, correctional institution officers, and supervisors of guards" ///
					425 "Crossing guards" ///
					426 "Protective service, n.e.c." ///
					426 "Protective service, n.e.c." ///
					436 "Cooks and supervisors of food preparation and service" ///
					434 "Bartenders" ///
					435 "Waiters and waitresses" ///
					436 "Cooks and supervisors of food preparation and service" ///
					444 "Miscellanious food preparation and service workers" ///
					444 "Miscellanious food preparation and service workers" ///
					445 "Dental Assistants" ///
					447 "Health and nursing aides" ///
					453 "Janitors and supervisors of cleaning and building services, groundskeeping" ///
					453 "Janitors and supervisors of cleaning and building services, groundskeeping" ///
					451 "Gardeners and groundskeepers, pest control" ///
					453 "Janitors and supervisors of cleaning and building services, groundskeeping" ///
					451 "Gardeners and groundskeepers, pest control" ///
					457 "Barbers" ///
					458 "Hairdressers and cosmetologists" ///
					459 "Recreation facility attendants and guides" ///
					459 "Recreation facility attendants and guides" ///
					462 "Ushers" ///
					464 "Baggage porters, bellhops and concierges" ///
					466 "Recreation and fitness workers" ///
					467 "Motion picture projectionists" ///
					468 "Child care workers" ///
					469 "Personal service occupations (incl. Supervisors)" ///
					469 "Personal service occupations (incl. Supervisors)" ///
					471 "Public transportation attendants and inspectors" ///
					472 "Animal caretakers, except farm" ///
					473 "Farmers (owners and tenants) and farm managers" ///
					473 "Farmers (owners and tenants) and farm managers" ///
					479 "Farm workers" ///
					479 "Farm workers" ///
					479 "Farm workers" ///
					496 "Timber, logging, and forestry workers" ///
					498 "Fishers, marine life cultivators, hunters, and kindred" ///
					505 "Automobile mechanics and repairers (incl. Supervisors)" ///
					505 "Automobile mechanics and repairers" ///
					514 "Engine mechanics and auto body repairers" ///
					508 "Aircraft mechanics" ///
					514 "Engine mechanics and auto body repairers" ///
					514 "Engine mechanics and auto body repairers" ///
					516 "Heavy equipement and farm equipment mechanics" ///
					519 "Machinery maintenance occupations" ///
					519 "Machinery maintenance occupations" ///
					523 "Repairers of industrial electrical equipment" ///
					525 "Repairers of data processing equipment" ///
					526 "Repairers of household appliances and power tools" ///
					527 "Telecom and line installers and repairers" ///
					533 "Repairers of electrical equipment, n.e.c." ///
					534 "Heating, air conditioning, and refrigeration mechanics" ///
					535 "Precision makers, repairers, and smiths" ///
					535 "Precision makers, repairers, and smiths" ///
					549 "Mechanics and repairers, n.e.c." ///
					549 "Mechanics and repairers, n.e.c." ///
					544 "Millwrights" ///
					549 "Mechanics and repairers, n.e.c." ///
					563 "Masons, tilers, and carpet installers" ///
					567 "Carpenters, painting and decoration occupations" ///
					567 "Painting and decoration occupations" ///
					573 "Drywall installers" ///
					575 "Electricians" ///
					577 "Electric power installers and repairers" ///
					579 "Painters, construction and maintenance" ///
					583 "Paperhangers" ///
					584 "Plasterers" ///
					585 "Plumbers, pipe fitters, and steamfitters" ///
					588 "Concrete and cement workers" ///
					589 "Glaziers" ///
					593 "Insulation workers" ///
					594 "Paving, surfacing, and tamping equipment operators" ///
					595 "Roofers and slaters" ///
					597 "Structural metal workers" ///
					598 "Drillers of earth and oil wells" ///
					599 "Misc. construction and related occupations" ///
					598 "Drillers of earth and oil wells" ///
					615 "Explosives workers" ///
					616 "Miners" ///
					616 "Miners" ///
					628 "Production supervisors or foremen" ///
					634 "Tool and die makers and die setters" ///
					637 "Machinists" ///
					643 "Boilermakers" ///
					649 "Engravers and precision grinders and fitters" ///
					645 "Patternmakers and model makers, other metal and plastic workers" ///
					649 "Engravers and precision grinders and fitters" ///
					645 "Patternmakers and model makers, other metal and plastic workers" ///
					657 "Cabinetmakers and bench carpeters" ///
					658 "Furniture/wood finishers, other prec. wood workers" ///
					666 "Dressmakers, seamstresses, and tailors" ///
					668 "Upholsterers" ///
					669 "Shoemakers, other prec. apparel and fabric workers" ///
					675 "Hand molders and shapers, except jewelers" ///
					677 "Optical goods workers" ///
					678 "Dental laboratory and medical applicance technicians" ///
					679 "Bookbinders and other precision and craft workers" ///
					679 "Bookbinders and other precision and craft workers" ///
					686 "Butchers and meat cutters" ///
					687 "Bakers and batch food makers" ///
					687 "Bakers and batch food makers" ///
					695 "Power, water, and sewage plant operators" ///
					695 "Power, water, and sewage plant operators" ///
					696 "Plant and system operators, stationary engineers" ///
					696 "Plant and system operators, stationary engineers" ///
					703 "Lathe, milling, and turning machine operatives" ///
					706 "Punching and stamping press operatives" ///
					707 "Rollers, roll hands, and finishers of metal" ///
					708 "Drilling and boring machine operators" ///
					709 "Grinding, abrading, buffing, and polishing workers" ///
					713 "Forge and hammer operators" ///
					719 "Molders and casting machine operators" ///
					723 "Metal platers" ///
					724 "Heat treating equipment operators" ///
					727 "Woodworking machine operators" ///
					727 "Woodworking machine operators" ///
					727 "Woodworking machine operators" ///
					734 "Printing machine operators, n.e.c." ///
					736 "Typesetters and compositors" ///
					738 "Winding and twisting textile and apparel operatives" ///
					739 "Knitters, loopers, and toppers textile operatives" ///
					744 "Textile cutting, dyeing, and sewing machine operators" ///
					744 "Textile cutting, dyeing, and sewing machine operators" ///
					745 "Shoemaking machine operators" ///
					749 "Miscellanious textile machine operators" ///
					749 "Miscellanious textile machine operators" ///
					779 "Machine operators, n.e.c." ///
					754 "Packers, fillers, and wrappers" ///
					779 "Machine operators, n.e.c." ///
					756 "Mixing and blending machine operators" ///
					779 "Machine operators, n.e.c." ///
					779 "Machine operators, n.e.c." ///
					779 "Machine operators, n.e.c." ///
					779 "Machine operators, n.e.c." ///
					766 "Furnance, kiln, and oven operators, apart from food" ///
					769 "Slicing, cutting, crushing and grinding machine" ///
					774 "Photographic process workers" ///
					779 "Machine operators, n.e.c." ///
					783 "Welders, solderers, and metal cutters" ///
					785 "Assemblers of electrical equipment" ///
					799 "Production checkers, graders, and sorters; production helpers" ///
					799 "Production checkers, graders, and sorters; production helpers" ///
					799 "Production checkers, graders, and sorters; production helpers" ///
					804 "Truck, delivery, and tractor drivers; supervisors of motor vehicle transportation" ///
					804 "Truck, delivery, and tractor drivers; supervisors of motor vehicle transportation" ///
					808 "Bus drivers" ///
					809 "Taxi cab drivers and chauffeurs" ///
					813 "Parking lot attendants" ///
					823 "Railroad conductors and yardmasters" ///
					824 "Locomotive operators: engineers and firemen" ///
					825 "Railroad brake, coupler, and switch operators" ///
					829 "Ship crews and marine engineers, and transportation occupations n.e.c." ///
					829 "Ship crews and marine engineers, and transportation occupations n.e.c." ///
					844 "Operating engineers of construction equipment" ///
					848 "Crane, derrick, winch, hoist, longshore, and excavating and loading machine operators" ///
					848 "Crane, derrick, winch, hoist, longshore, and excavating and loading machine operators" ///
					859 "Stevedores and misc. material moving occupations" ///
					866 "Construction and surveying helpers" ///
					866 "Construction and surveying helpers" ///
					869 "Construction laborers" ///
					875 "Garbage and recyclable material collectors" ///
					885 "Garage and service station related occupations" ///
					887 "Vehicle washers and equipment cleaners" ///
					888 "Packers and packagers by hand" ///
					889 "Laborers, freight, stock, and material handlers, n.e.c.", replace
					
	la var occ1990ddgg "Occupation, consistent 1970-2008, based on David Dorn"
	la val occ1990ddgg occ1990ddgg
