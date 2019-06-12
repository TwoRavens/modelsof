
**IF YOU DO NOT HAVE CLARIFY INSTALLED ON YOUR COMPUTER, RUN THESE COMMANDS
net from http://gking.harvard.edu/clarify
net install clarify

**IF YOU DO, BEGIN FROM HERE 
summarize ideology if revparadigm==1
summarize ideology if revparadigm==2
summarize ideology if revparadigm==3
summarize ideology if revparadigm==4
summarize ideology if revparadigm==5
summarize ideology if revparadigm==6
summarize ideology if revparadigm==7
summarize ideology if revparadigm==8
summarize ideology if revparadigm==9
summarize ideology if revparadigm==10
summarize ideology if revparadigm==11
summarize ideology

**1=REALISM, 2=MAINSTREAM LIBERALISM, 3=CONSTRUCTIVISM, 4=ENGLISH SCHOOL, 5=FEMINISM, 6=MARXISM, 7= NO PARADIGM, 8=OTHER, 9=NEOLIBERAL INSTITUTIONALISM, 10=RATIONALISM, 11=IDEALISM


tabulate ideology if revparadigm==1
tabulate ideology if revparadigm==2
tabulate ideology if revparadigm==3
tabulate ideology if revparadigm==3
tabulate ideology if revparadigm==4
tabulate ideology if revparadigm==5
tabulate ideology if revparadigm==6
tabulate ideology if revparadigm==7
tabulate ideology if revparadigm==8
tabulate ideology if revparadigm==9
tabulate ideology if revparadigm==10
tabulate ideology if revparadigm==11


anova ideology revparadigm

regress ideology  dumrealist dummainlib dumidealist dumNLI dumenglish dumconstructivist dumrationalist dummarxist dumfeminist dumother gender associate full NTT IPE IS IO, robust

regress ideology  dumrealist dummainlib dumidealist dumNLI dumenglish dumconstructivist dumrationalist dummarxist dumfeminist dumother gender associate full NTT dumpositivist dumpostpositivist IPE IS IO, robust

regress ideology  dumrealist dummainlib dumidealist dumNLI dumenglish dumconstructivist dumrationalist dummarxist dumfeminist dumother gender associate full NTT IPE IS IO if dumpositivist==1, robust

regress ideology  dumrealist dummainlib dumidealist dumNLI dumenglish dumconstructivist dumrationalist dummarxist dumfeminist dumother gender associate full NTT IPE IS IO if dumnonpositivist==1, robust

regress ideology  dumrealist dummainlib dumidealist dumNLI dumenglish dumconstructivist dumrationalist dummarxist dumfeminist dumother gender associate full NTT IPE IS IO if dumpostpositivist==1, robust

regress ideology  dumrealist dummainlib dumidealist dumNLI dumenglish dumconstructivist dumrationalist dummarxist dumfeminist dumother gender associate full NTT dumpositivist dumpostpositivist IPE IS IO if dumus==1, robust

regress ideology  dumrealist dummainlib dumidealist dumNLI dumenglish dumconstructivist dumrationalist dummarxist dumfeminist dumother gender associate full NTT dumpositivist dumpostpositivist IPE IS IO if dumuk==1, robust

estsimp mlogit revparadigm ideology gender dumpositivist dumpostpositivist, robust
setx mean
setx ideology 1
simqi, prval(1)
simqi, prval(3)
simqi, prval(7)
simqi, prval(9)
simqi, prval(10)

setx ideology 2
simqi, prval(1)
simqi, prval(3)
simqi, prval(7)
simqi, prval(9)
simqi, prval(10)

setx ideology 3
simqi, prval(1)
simqi, prval(3)
simqi, prval(7)
simqi, prval(9)
simqi, prval(10)

setx ideology 4
simqi, prval(1)
simqi, prval(3)
simqi, prval(7)
simqi, prval(9)
simqi, prval(10)

setx ideology 5
simqi, prval(1)
simqi, prval(3)
simqi, prval(7)
simqi, prval(9)
simqi, prval(10)

setx ideology 6
simqi, prval(1)
simqi, prval(3)
simqi, prval(7)
simqi, prval(9)
simqi, prval(10)

setx ideology 7
simqi, prval(1)
simqi, prval(3)
simqi, prval(7)
simqi, prval(9)
simqi, prval(10)
