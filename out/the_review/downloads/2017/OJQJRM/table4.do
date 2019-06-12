clear

* put correct folder path below 
cd ..

use "experimentHealyPerssonSnowberg.dta"
 areg assessment    growthYear1 growthYear2 growthYear3  growthYear4   , absorb(respondentID) cluster(uniquePictureID)
test _b[growthYear4]=_b[growthYear3]
test _b[growthYear4]=_b[growthYear2]
test _b[growthYear4]=_b[growthYear1]

areg assessment    growthYear1 growthYear2 growthYear3  growthYear4  if pictureCountry == "us"  , absorb(respondentID) cluster(uniquePictureID)
test _b[growthYear4]=_b[growthYear3]
test _b[growthYear4]=_b[growthYear2]
test _b[growthYear4]=_b[growthYear1]

areg assessment    growthYear1 growthYear2 growthYear3  growthYear4 if pictureCountry == "sw" , absorb(respondentID) cluster(uniquePictureID) 
test _b[growthYear4]=_b[growthYear3]
test _b[growthYear4]=_b[growthYear2]
test _b[growthYear4]=_b[growthYear1]

areg assessment    growthYear1 growthYear2 growthYear3  growthYear4 if sample == 1  , absorb(respondentID) cluster(uniquePictureID) 
test _b[growthYear4]=_b[growthYear3]
test _b[growthYear4]=_b[growthYear2]
test _b[growthYear4]=_b[growthYear1]

areg assessment    growthYear1 growthYear2 growthYear3  growthYear4  if sample == 2 , absorb(respondentID) cluster(uniquePictureID)
test _b[growthYear4]=_b[growthYear3]
test _b[growthYear4]=_b[growthYear2]
test _b[growthYear4]=_b[growthYear1]

