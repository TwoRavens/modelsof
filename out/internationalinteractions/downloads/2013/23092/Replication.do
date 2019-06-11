******************
** BFM ANALYSIS **
******************
clear
version 12.1

use "Replication.dta"

set seed 1234

global ivs1 = "intensity duration issue lnpop lgdp regime total" 
global ivs2  = "intensity duration lnpop lgdp regime issue"
global ivs3 = "intensity total africa asia americas middleeast lnpop lgdp regime" /*for IVPROBIT*/

*** STAGE 1: OLS MEDIA COVERAGE ***

reg headline $ivs1
predict r1,r

reg dateline $ivs1
predict r2,r

reg headlinechange $ivs1
predict r3,r

reg datelinechange $ivs1
predict r4,r

global head "headline r1 "
global date "dateline r2"
global change1 "headline headlinechange r3"
global datelined "dateline datelinechange r4 "

*** TABLE 1 ***
probit IMI headline headlinechange $ivs2 
probit IMIwestern headline headlinechange $ivs2
probit IMIus headline headlinechange $ivs2

*** TABLE 2 ***
probit IMI dateline datelinechange $ivs2  
probit IMIwestern dateline datelinechange $ivs2 
probit IMIus dateline datelinechange $ivs2 

*** TABLE 3 ***
probit IMI $change1 $ivs2  
probit IMIwestern $change1 $ivs2
probit IMIus $change1 $ivs2

*** TABLE 4 ***
probit IMI $datelined $ivs2
probit IMIwestern  $datelined  $ivs2 
probit IMIus $datelined $ivs2     
