

gen year78 = (year == 78)
gen year79 = (year == 79)
gen year80 = (year == 80)
gen year81 = (year == 81)
gen year82 = (year == 82)
gen year83 = (year == 83)
gen year84 = (year == 84)
gen year85 = (year == 85)
gen year86 = (year == 86)
gen year87 = (year == 87)
gen year88 = (year == 88)
gen year89 = (year == 89)
gen year90 = (year == 90)
gen region1 = (region == 1)
gen region2 = (region == 2)
gen region3 = (region == 3)
gen region4 = (region == 4)
gen region5 = (region == 5)
gen region6 = (region == 6)
gen region8 = (region == 8)
gen region9 = (region == 9)
gen region10 = (region == 10)


gen lnadvertisedrate = log(advertisedrate)
gen lnsellingvalue = log(sellingvalue)
gen lnmfgcost = log(mfgcost)
gen lnvolume = log(volume)
gen lnlogging = log(loggingcosts)
gen lnroad = log(roadcost)
replace lnmfgcost = 0 if lnmfgcost == .
replace lnadvertisedrate = 0 if lnadvertisedrate == .
replace lnsellingvalue = 0 if lnsellingvalue == .
replace lnvolum = 0 if lnvolume == .
replace lnlogging = 0 if lnlogging == .
replace lnroad = 0 if lnroad == .

reg nummills nummills_county numloggers_county numsb_county ///
lnadvertisedrate lnsellingvalue lnmfgcost density lnvolume lnlogging lnroad salvagedummy specieshhi contractlength ///
year78 year79 year80 year81 year82 year83 year84 year85 year86 year87 year88 year90 ///
region2 region3 region4 region5 region6 region8 region9 region10

predict nummills_pred, xb

reg numloggers nummills_county numloggers_county numsb_county ///
lnadvertisedrate lnsellingvalue lnmfgcost density lnvolume lnlogging lnroad salvagedummy specieshhi contractlength ///
year78 year79 year80 year81 year82 year83 year84 year85 year86 year87 year88 year90 ///
region2 region3 region4 region5 region6 region8 region9 region10

predict numloggers_pred, xb

reg numsb nummills_county numloggers_county numsb_county ///
lnadvertisedrate lnsellingvalue lnmfgcost density lnvolume lnlogging lnroad salvagedummy specieshhi contractlength ///
year78 year79 year80 year81 year82 year83 year84 year85 year86 year87 year88 year90 ///
region2 region3 region4 region5 region6 region8 region9 region10

predict numsb_pred, xb


gen nummills_pred_round = round(nummills_pred)
gen numloggers_pred_round = round(numloggers_pred)
gen numsb_pred_round = round(numsb_pred)



