
*******************************************************************
  * Occupation recoding for 1990
*******************************************************************

  gen occ1990dd=occ1990

replace occ1990dd=22 if occ==17 | occ==21          /* 22 - Managers and administrators, nec. */

  /* additional changes as in 1980 */

  replace occ1990dd=68 if occ==67                    /* 68 - Mathematicians and statisticians */

  replace occ1990dd=154 if (occ==113 | occ==114 | occ==115 | occ==116 | occ==118)  /* subject instructors, college */
  replace occ1990dd=154 if (occ==119 | occ==123 | occ==125 | occ==127 | occ==128)  /* subject instructors, college */
  replace occ1990dd=154 if (occ==139 | occ==145 | occ==147 | occ==149)             /* subject instructors, college */

  replace occ1990dd=169 if occ==168                  /* 169 - Social scientists and sociologists, nec. */

  replace occ1990dd=214 if occ==213 | occ==215       /* 214 - Engineering technicians, nec. */
  replace occ1990dd=275 if (occ>=263 & occ<=269) | occ==274  /* 275 - Retail salespersons */

  replace occ1990dd=313 if occ==314                  /* 313 - Secretaries and stenographers */
  replace occ1990dd=319 if occ==323                  /* 319 - Receptionists and other information clerks */
  replace occ1990dd=336 if occ==325                  /* 336 - Records clerks */
  replace occ1990dd=344 if occ==343                  /* 344 - Billing clerks and related financial records processing */
  replace occ1990dd=347 if occ==345                  /* 347 - Office machine operators, nec. */

  replace occ1990dd=405 if occ==407                  /* 405 - Housekeepers, maids, butlers, and cleaners */
  replace occ1990dd=433 if occ==433                  /* 435 - Supervisors of food preparation and service */
  replace occ1990dd=444 if occ==438                  /* 444 - Misc. food preparation and service workers */
  replace occ1990dd=444 if occ==443                  /* 444 - Misc. food preparation and service workers */
  replace occ1990dd=447 if occ==446                  /* 447 - Health and nursing aides */
  replace occ1990dd=469 if occ==454                  /* 469 - Personal service occupations, nec. */

  replace occ1990dd=473 if occ==474                  /* 473 - Farmers, incl. horticultural specialty farms */
  replace occ1990dd=475 if occ==476                  /* 475 - Farm managers, incl. horticultural specialty farms */
  replace occ1990dd=479 if occ==484                  /* 479 - Farm workers, incl. nursery farming */
  replace occ1990dd=498 if occ==483                  /* 498 - Fishers, marine life cultivators, hunters, and kindred */

  replace occ1990dd=533 if occ==538                  /* 533 - Repairers of electrical equipment, nec. */
  replace occ1990dd=599 if occ==596                  /* 599 - Construction trades, nec. */
  replace occ1990dd=658 if occ==659                  /* 658 - Furniture and wood finishers, other precision woodworkers */
  replace occ1990dd=666 if occ==667                  /* 666 - Dressmakers, seamstresses, tailors */
  replace occ1990dd=669 if occ==674                  /* 669 - Shoemakers and other precision apparel and fabric workers */

  replace occ1990dd=729 if occ==728                  /* 729 - Nail and tacking, shaping and joining machine ops. (woodworking) */
  replace occ1990dd=733 if occ==726                  /* 733 - Other woodworking machine ops. */
  replace occ1990dd=734 if occ==735                  /* 734 - Printing machine ops., nec. */
  replace occ1990dd=769 if occ==768                  /* 769 - Slicing, cutting, crushing and grinding machine ops. */
  replace occ1990dd=783 if occ==784                  /* 783 - Welders, solderers, metal cutters */
  replace occ1990dd=779 if occ==693 | occ==717 | occ==759      /* 779 - Machine operators, nec. */

  replace occ1990dd=799 if occ==689 | occ==796 | occ==797      /* 799 - Production checkers, graders, and sorters in manufacturing */
  replace occ1990dd=848 if occ==845                  /* 848 - Crane, derrick, whinch, hoist, longshore operators */
  replace occ1990dd=859 if occ==876                  /* 859 - Misc. material moving occs. */
  replace occ1990dd=873 if occ==874                  /* 873 - Production helpers */
  replace occ1990dd=889 if occ==877 | occ==883       /* 889 - Laborers and freight, stock, and material handlers, nec. */

  *** occupations with changed codes ***

  replace occ1990dd=177 if occ1990==465              /* 177 - Welfare service workers */
  replace occ1990dd=408 if occ1990==748              /* 408 - Laundry and dry cleaning workers */
  replace occ1990dd=450 if occ1990==485              /* 450 - Supervisors of landscaping, lawn service and groundskeeping */
  replace occ1990dd=451 if occ1990==486              /* 451 - Gardeners and groundskeepers */
  replace occ1990dd=466 if occ1990==175              /* 466 - Recreation and fitness workers */
  replace occ1990dd=467 if occ1990==773              /* 467 - Motion picture projectionists */
  replace occ1990dd=470 if occ1990==456              /* 470 - Supervisors of personal service jobs, n.e.c. */
  replace occ1990dd=471 if occ1990==463              /* 471 - Public transportation attendants and inspectors */
  replace occ1990dd=472 if occ1990==487              /* 472 - Animal caretakers, except farm */

  *** adjustments for ACS compatibility ***

  replace occ1990dd=47 if occ==46                    /* 47 - petroleum, mining, and geological engineers */

  replace occ1990dd=4 if occ1990dd==3                /* 4 - chief executives, public administrators, and legislators */
  replace occ1990dd=22 if occ1990dd==16              /* 22 - managers and administrators, nec */
  replace occ1990dd=178 if occ1990dd==179            /* 178 - lawyers and judges */
  replace occ1990dd=653 if occ1990dd==646            /* 653 - tinsmiths, coppersmiths, and sheet metal workers */

  *** fix code 873>874 change in newer IPUMS extracts ***
  replace occ1990dd=873 if occ1990==874

