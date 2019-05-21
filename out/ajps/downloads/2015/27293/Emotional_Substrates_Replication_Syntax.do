
*** Syntax For TABLE 2 AJPS Banks and Valentino

*** Column 1 ***
reg racpolicy anger fear disgust racresent1  angerres1 fearres1 disgusres1 ideology education age south income1 openissuejo1 if baddata2==0

*** Column 2 ***
reg racpolicy anger fear disgust jimcrow13  angerjc13 fearjc13 disgusjc13 ideology education age south income1 openissuejo1 if baddata2==0

*** Column 3 ***
reg racpolicy anger fear disgust limitgov  angerlim fearlim disguslim ideology education age south income1 openissuejo1 if baddata2==0

*** Column 4 ***
reg racpolicy anger fear disgust jimcrow13 racresent1 angerres1 fearres1 disgusres1 angerjc13 fearjc13 disgusjc13 ideology south education age income1 openissuejo1 if baddata2==0 
