#delim cr
set more off
*version 11
pause on
graph set ps logo off

/* --------------------------------------

AUTHOR: Tal Gross

PURPOSE:

DATE CREATED:

NOTES:

--------------------------------------- */

clear all
estimates clear
set mem 500m
describe, short

insheet using dc_dec_2000_sf3_u_data1.txt , delim(|) names
d, f

label var geo_id "  Geography Identifier"
label var geo_id2 " Geography Identifier"
label var sumlevel "Geographic Summary Level"
label var geo_name "Geography"
label var h006001 " Housing units: Total"
label var h006002 " Housing units: Occupied"
label var h006003 " Housing units: Vacant"
label var h080001 " Specified owner-occupied housing units: Total"
label var h080002 " Specified owner-occupied housing units: Housing units with a mortgage; contract to purchase; or similar debt"
label var h080003 " Specified owner-occupied housing units: Housing units with a mortgage; contract to purchase; or similar debt; With either a second mortgage or home equity loan; but not both"
label var h080004 " Specified owner-occupied housing units: Housing units with a mortgage; contract to purchase; or similar debt; With either a second mortgage or home equity loan; but not both; Second mortgage only"
label var h080005 " Specified owner-occupied housing units: Housing units with a mortgage; contract to purchase; or similar debt; With either a second mortgage or home equity loan; but not both; Home equity loan only"
label var h080006 " Specified owner-occupied housing units: Housing units with a mortgage; contract to purchase; or similar debt; Both second mortgage and home equity loan"
label var h080007 " Specified owner-occupied housing units: Housing units with a mortgage; contract to purchase; or similar debt; No second mortgage and no home equity loan label var H080008 Specified owner-occupied housing units: Housing units without a mortgage"

rename geo_id2 zip
compare h080001 h006001
gen share_owner_occupied = h080001 / h006001
sum share_owner_occupied

rename h006001 households
sum households

keep zip share_owner_occupied households
sort zip
save share-owner-occupied.dta , replace

exit

