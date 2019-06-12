global cluster = "fahrer"

use DatFG1, clear

global i = 1
global j = 1

mycmd (high) areg totrev high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg totrev high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg totrev high exp block2 block3, absorb(fahrer) cluster(fahrer) 
mycmd (high) areg shifts high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg shifts high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg shifts high exp block2 block3, absorb(fahrer) cluster(fahrer)


**********************************
 
use DatFG2, clear

*Table 5 
mycmd (high) areg lnum high lnten female, absorb(datum) cluster(datum) 
mycmd (high) areg lnum high lnten fdum*, absorb(datum) cluster(datum) 

*Table 6 
mycmd (high_la high_not0) areg lnum high_la high_not0 lnten fdum*, absorb(datum) cluster(datum) 
mycmd (high_la1 high_la2 high_not0) areg lnum high_la1 high_la2 high_not0 lnten fdum*, absorb(datum) cluster(datum) 


