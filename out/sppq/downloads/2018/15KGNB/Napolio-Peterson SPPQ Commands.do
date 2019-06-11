// Replication code for Napolio, Nicholas G. and Jordan Carr Peterson. 
//   "Their Boot in Our Face No Longer? Administrative Sectionalism and 
//   Resistance to Federal Authority in the U.S. South"//

//The following analyses were carried out using 
//   Stata/MP 13.0 for WIndows (64-bit x86-64)//

//Users must install the 'relogit' package to run analyses//

use "Napolio-Peterson SPPQ Dataset.dta"

//DESCRIPTIVE STATISTICS FOR TABLE ONE//

summ  resist southern conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres propgopleg percentPopRural percentnonwhite unemployment


//The following commands estimate Models 1-8 and the predicted 
//probabilities for Figures 1-2//


//MODEL ONE//

relogit resist southern conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres

//MODEL TWO//

relogit resist southern conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres propgopleg

//MODEL THREE//

relogit resist southern conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres percentPopRural percentnonwhite unemployment

//MODEL FOUR//

relogit resist southern conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres propgopleg percentPopRural percentnonwhite unemployment

//MODEL FIVE//

logit resist southern conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres, robust

//FIGURE ONE//

margins, at(southern=(1 0)) atmeans level(90)
marginsplot, recast(bar) xsc(reverse)

//FIGURE TWO//

margins, at(conflictingPartisanship=(1 0)) atmeans level(90)
marginsplot, recast(bar) xsc(reverse)

//MODEL SIX//

logit resist southern conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres propgopleg, robust

//MODEL SEVEN//

logit resist southern conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres percentPopRural percentnonwhite unemployment, robust

//MODEL EIGHT//

logit resist southern conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres propgopleg percentPopRural percentnonwhite unemployment, robust


//The following commands estimate the models in the appendices//

//MODEL A1//

logit resist censusNortheast censusWest censusMidwest conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres, robust

//MODEL A2//

logit resist censusNortheast censusWest censusMidwest conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres propgopleg, robust

//MODEL A3//

logit resist censusNortheast censusWest censusMidwest conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres percentPopRural percentnonwhite unemployment, robust

//MODEL A4//

logit resist censusNortheast censusWest censusMidwest conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres propgopleg percentPopRural percentnonwhite unemployment, robust

//MODEL B1//

logit resist southern_slaveStates conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres, robust

//MODEL B2//

logit resist censusSouth conflictingPartisanship degreeConflictingPartisanship elected propgop order1000 propgoppres, robust
