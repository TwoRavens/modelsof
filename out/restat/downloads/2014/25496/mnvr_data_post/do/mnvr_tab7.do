clear
set more off
cd ..\dta
* see mnvr_2 for reshaping of original EUKLEMS data, merging with trade data and generating variables for country and industry averages

use mnvr_reshaped_variables_country_industry_means,clear

ren ind code
*dropping industries pertaining to petrol, coke and energy (oil boom)
drop if code=="23"|code=="E"|code=="C"
*generating fully disaggregated industries (we sort by college wagebill share and then identify which industries report the same levels)
gen str ind=""

replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR,MFG NEC;RECYCLING" if code=="17t19"&country=="AUT"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR,MFG NEC;RECYCLING" if code=="15t16"&country=="AUT"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR,MFG NEC;RECYCLING" if code=="36t37"&country=="AUT"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="20"&country=="AUT"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="27t28"&country=="AUT"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="26"&country=="AUT"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="25"&country=="AUT"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="21t22"&country=="AUT"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="23"&country=="AUT"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="24"&country=="AUT"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="29"&country=="AUT"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="30t33"&country=="AUT"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="34t35"&country=="AUT"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="50"&country=="AUT"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="51"&country=="AUT"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="52"&country=="AUT"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="H"&country=="AUT"
replace ind="TRANSPORT AND STORAGE" if code=="60t63" &country=="AUT"
replace ind="POST AND TELECOM" if code=="64" &country=="AUT"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="70"&country=="AUT"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="71t74"&country=="AUT"
replace ind="AGRICULTURE, HUNTING, FORESTRY AND FISHING" if code=="AtB"&country=="AUT"
replace ind="MINING AND QUARRYING; ELECTRICITY, GAS AND WATER SUPPLY" if code=="E"&country=="AUT"
replace ind="MINING AND QUARRYING; ELECTRICITY, GAS AND WATER SUPPLY" if code=="C"&country=="AUT"
replace ind="CONSTRUCTION" if code=="F"&country=="AUT"
replace ind="FINANCIAL INTERMEDIATION" if code=="J"&country=="AUT"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY" if code=="L"&country=="AUT"
replace ind="EDUCATION" if code=="M"&country=="AUT"
replace ind="HEALTH AND SOCIAL WORK" if code=="N"&country=="AUT"
replace ind="OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICES" if code=="O"&country=="AUT"

replace ind="SALE, MAINTENANCE AND REPAIR OF MOTORS" if code=="50"&country=="DNK"
replace ind="TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR" if code=="17t19"&country=="DNK"
replace ind="HOTELS AND RESTAURANTS" if code=="H"&country=="DNK"
replace ind="WOOD AND PRODUCTS OF WOOD AND CORK" if code=="20"&country=="DNK"
replace ind="MFG NEC;RECYCLING" if code=="36t37"&country=="DNK"
replace ind="RUBBER AND PLASTICS PRODUCTS" if code=="25" &country=="DNK"
replace ind="BASIC METALS;FABRICATED METAL PRODUCTS" if code=="27t28"&country=="DNK"
replace ind="TRANSPORT EQUIPMENT" if code=="34t35"&country=="DNK"
replace ind="PULP, PAPER, PAPER PRODUCTS, PRINTING AND PUBLISHING" if code=="21t22"&country=="DNK"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO" if code=="15t16"&country=="DNK"
replace ind="RETAIL TRADE AND REPAIR" if code=="52"&country=="DNK"
replace ind="MACHINERY;NEC" if code=="29"&country=="DNK"
replace ind="AGRICULTURE, HUNTING, FORESTRY AND FISHING" if code=="AtB"&country=="DNK"
replace ind="OTHER NON-METALLIC MINERAL PRODUCTS" if code=="26"&country=="DNK"
replace ind="CONSTRUCTION" if code=="F"&country=="DNK"
replace ind="TRANSPORT AND STORAGE" if code=="60t63" &country=="DNK"
replace ind="REAL ESTATE ACTIVITIES" if code=="70"&country=="DNK"
replace ind="ELECTRICITY, GAS AND WATER SUPPLY" if code=="E"&country=="DNK"
replace ind="WHOLESALE AND COMMISSION TRADE" if code=="51" &country=="DNK"
replace ind="POST AND TELECOM" if code=="64" &country=="DNK"
replace ind="FINANCIAL INTERMEDIATION" if code=="J"&country=="DNK"
replace ind="ELECTRICAL AND OPTICAL EQUIPMENT" if code=="30t33"&country=="DNK"
replace ind="HEALTH AND SOCIAL WORK" if code=="N"&country=="DNK"
replace ind="MINING AND QUARRYING" if code=="C"&country=="DNK"
replace ind="COKE,REFINED PETROLEUM PRODUCTS AND NUCLEAR FUEL" if code=="23"&country=="DNK"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY" if code=="L"&country=="DNK"
replace ind="EDUCATION" if code=="M"&country=="DNK"
replace ind="OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICES" if code=="O"&country=="DNK"
replace ind="CHEMICALS AND CHEMICAL PRODUCTS" if code=="24"&country=="DNK"
replace ind="RENTING AND BUSINESS ACTIVITIES" if code=="71t74"&country=="DNK"


replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO" if code=="15t16"&country=="ESP"
replace ind="TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR" if code=="17t19"&country=="ESP"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="20"&country=="ESP"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="27t28"&country=="ESP"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="26"&country=="ESP"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="25"&country=="ESP"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="21t22"&country=="ESP"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="23"&country=="ESP"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="24"&country=="ESP"
replace ind="MACHINERY;NEC" if code=="29"&country=="ESP"
replace ind="ELECTRICAL AND OPTICAL EQUIPMENT" if code=="30t33"&country=="ESP"
replace ind="TRANSPORT EQUIPMENT" if code=="34t35"&country=="ESP"
replace ind="MFG NEC;RECYCLING" if code=="36t37"&country=="ESP"
replace ind="WHOLESALE AND RETAIL TRADE" if code=="50"&country=="ESP"
replace ind="WHOLESALE AND RETAIL TRADE" if code=="51"&country=="ESP"
replace ind="WHOLESALE AND RETAIL TRADE" if code=="52"&country=="ESP"
replace ind="TRANSPORT AND STORAGE" if code=="60t63" &country=="ESP"
replace ind="POST AND TELECOM" if code=="64" &country=="ESP"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="70"&country=="ESP"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="71t74"&country=="ESP"
replace ind="AGRICULTURE, HUNTING, FORESTRY AND FISHING" if code=="AtB"&country=="ESP"
replace ind="ELECTRICITY, GAS AND WATER SUPPLY" if code=="E"&country=="ESP"
replace ind="MINING AND QUARRYING" if code=="C"&country=="ESP"
replace ind="CONSTRUCTION" if code=="F"&country=="ESP"
replace ind="HOTELS AND RESTAURANTS" if code=="H"&country=="ESP"
replace ind="FINANCIAL INTERMEDIATION" if code=="J"&country=="ESP"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY" if code=="L"&country=="ESP"
replace ind="EDUCATION" if code=="M"&country=="ESP"
replace ind="HEALTH AND SOCIAL WORK" if code=="N"&country=="ESP"
replace ind="OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICES" if code=="O"&country=="ESP"

replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR,MFG NEC;RECYCLING" if code=="17t19"&country=="FIN"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR,MFG NEC;RECYCLING" if code=="15t16"&country=="FIN"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR,MFG NEC;RECYCLING" if code=="36t37"&country=="FIN"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="20"&country=="FIN"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="27t28"&country=="FIN"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="26"&country=="FIN"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="25"&country=="FIN"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="21t22"&country=="FIN"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="23"&country=="FIN"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="24"&country=="FIN"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="29"&country=="FIN"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="30t33"&country=="FIN"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="34t35"&country=="FIN"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="50"&country=="FIN"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="51"&country=="FIN"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="52"&country=="FIN"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="H"&country=="FIN"
replace ind="TRANSPORT AND STORAGE" if code=="60t63" &country=="FIN"
replace ind="POST AND TELECOM" if code=="64" &country=="FIN"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="70"&country=="FIN"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="71t74"&country=="FIN"
replace ind="AGRICULTURE, HUNTING, FORESTRY AND FISHING" if code=="AtB"&country=="FIN"
replace ind="MINING AND QUARRYING; ELECTRICITY, GAS AND WATER SUPPLY" if code=="E"&country=="FIN"
replace ind="MINING AND QUARRYING; ELECTRICITY, GAS AND WATER SUPPLY" if code=="C"&country=="FIN"
replace ind="CONSTRUCTION" if code=="F"&country=="FIN"
replace ind="FINANCIAL INTERMEDIATION" if code=="J"&country=="FIN"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY" if code=="L"&country=="FIN"
replace ind="EDUCATION" if code=="M"&country=="FIN"
replace ind="HEALTH AND SOCIAL WORK" if code=="N"&country=="FIN"
replace ind="OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICES" if code=="O"&country=="FIN"

replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR,MFG NEC;RECYCLING" if code=="17t19"&country=="FRA"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR,MFG NEC;RECYCLING" if code=="15t16"&country=="FRA"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR,MFG NEC;RECYCLING" if code=="36t37"&country=="FRA"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="20"&country=="FRA"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="27t28"&country=="FRA"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="26"&country=="FRA"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="25"&country=="FRA"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="21t22"&country=="FRA"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="23"&country=="FRA"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="24"&country=="FRA"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="29"&country=="FRA"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="30t33"&country=="FRA"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="34t35"&country=="FRA"

replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="50"&country=="FRA"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="51"&country=="FRA"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="52"&country=="FRA"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="H"&country=="FRA"
replace ind="TRANSPORT AND STORAGE" if code=="60t63" &country=="FRA"
replace ind="POST AND TELECOM" if code=="64" &country=="FRA"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="70"&country=="FRA"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="71t74"&country=="FRA"
replace ind="AGRICULTURE, HUNTING, FORESTRY AND FISHING" if code=="AtB"&country=="FRA"
replace ind="MINING AND QUARRYING; ELECTRICITY, GAS AND WATER SUPPLY" if code=="E"&country=="FRA"
replace ind="MINING AND QUARRYING; ELECTRICITY, GAS AND WATER SUPPLY" if code=="C"&country=="FRA"
replace ind="CONSTRUCTION" if code=="F"&country=="FRA"
replace ind="FINANCIAL INTERMEDIATION" if code=="J"&country=="FRA"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY" if code=="L"&country=="FRA"
replace ind="EDUCATION" if code=="M"&country=="FRA"
replace ind="HEALTH AND SOCIAL WORK" if code=="N"&country=="FRA"
replace ind="OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICES" if code=="O"&country=="FRA"

replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR" if code=="17t19"&country=="GER"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR" if code=="15t16"&country=="GER"
replace ind="MOST OF MANUFACTURING" if code=="20"&country=="GER"
replace ind="MOST OF MANUFACTURING" if code=="27t28"&country=="GER"
replace ind="MOST OF MANUFACTURING" if code=="26"&country=="GER"
replace ind="MOST OF MANUFACTURING" if code=="25"&country=="GER"
replace ind="MOST OF MANUFACTURING" if code=="21t22"&country=="GER"
replace ind="MOST OF MANUFACTURING" if code=="23"&country=="GER"
replace ind="MOST OF MANUFACTURING" if code=="24"&country=="GER"
replace ind="MOST OF MANUFACTURING" if code=="29"&country=="GER"
replace ind="ELECTRICALS AND TRANSPORT" if code=="30t33"&country=="GER"
replace ind="ELECTRICALS AND TRANSPORT" if code=="34t35"&country=="GER"
replace ind="MFG NEC;RECYCLING,MINING AND QUARRYING;ELECTRICITY, GAS AND WATER SUPPLY" if code=="36t37"&country=="GER"
replace ind="MFG NEC;RECYCLING,MINING AND QUARRYING;ELECTRICITY, GAS AND WATER SUPPLY" if code=="E"&country=="GER"
replace ind="MFG NEC;RECYCLING,MINING AND QUARRYING;ELECTRICITY, GAS AND WATER SUPPLY" if code=="C"&country=="GER"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="50"&country=="GER"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="51"&country=="GER"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="52"&country=="GER"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="H"&country=="GER"
replace ind="TRANSPORT AND STORAGE AND COMMUNICATION" if code=="60t63"&country=="GER"
replace ind="TRANSPORT AND STORAGE AND COMMUNICATION" if code=="64"&country=="GER"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="70"&country=="GER"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="71t74"&country=="GER"
replace ind="AGRICULTURE, HUNTING, FORESTRY AND FISHING" if code=="AtB"&country=="GER"
replace ind="CONSTRUCTION" if code=="F"&country=="GER"
replace ind="FINANCIAL INTERMEDIATION" if code=="J"&country=="GER"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY" if code=="L"&country=="GER"
replace ind="EDUCATION" if code=="M"&country=="GER"
replace ind="HEALTH AND SOCIAL WORK" if code=="N"&country=="GER"
replace ind="OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICES" if code=="O"&country=="GER"


replace ind="SALE, MAINTENANCE AND REPAIR OF MOTORS" if code=="50"&country=="ITA"
replace ind="TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR" if code=="17t19"&country=="ITA"
replace ind="HOTELS AND RESTAURANTS" if code=="H"&country=="ITA"
replace ind="WOOD AND PRODUCTS OF WOOD AND CORK" if code=="20"&country=="ITA"
replace ind="MFG NEC;RECYCLING" if code=="36t37"&country=="ITA"
replace ind="RUBBER AND PLASTICS PRODUCTS" if code=="25" &country=="ITA"
replace ind="BASIC METALS;FABRICATED METAL PRODUCTS" if code=="27t28"&country=="ITA"
replace ind="TRANSPORT EQUIPMENT" if code=="34t35"&country=="ITA"
replace ind="PULP, PAPER, PAPER PRODUCTS, PRINTING AND PUBLISHING" if code=="21t22"&country=="ITA"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO" if code=="15t16"&country=="ITA"
replace ind="RETAIL TRADE AND REPAIR" if code=="52"&country=="ITA"
replace ind="MACHINERY;NEC" if code=="29"&country=="ITA"
replace ind="AGRICULTURE, HUNTING, FORESTRY AND FISHING" if code=="AtB"&country=="ITA"
replace ind="OTHER NON-METALLIC MINERAL PRODUCTS" if code=="26"&country=="ITA"
replace ind="CONSTRUCTION" if code=="F"&country=="ITA"
replace ind="TRANSPORT AND STORAGE" if code=="60t63" &country=="ITA"
replace ind="REAL ESTATE ACTIVITIES" if code=="70"&country=="ITA"
replace ind="ELECTRICITY, GAS AND WATER SUPPLY" if code=="E"&country=="ITA"
replace ind="WHOLESALE AND COMMISSION TRADE" if code=="51" &country=="ITA"
replace ind="POST AND TELECOM" if code=="64" &country=="ITA"
replace ind="FINANCIAL INTERMEDIATION" if code=="J"&country=="ITA"
replace ind="ELECTRICAL AND OPTICAL EQUIPMENT" if code=="30t33"&country=="ITA"
replace ind="HEALTH AND SOCIAL WORK" if code=="N"&country=="ITA"
replace ind="MINING AND QUARRYING" if code=="C"&country=="ITA"
replace ind="COKE,REFINED PETROLEUM PRODUCTS AND NUCLEAR FUEL" if code=="23"&country=="ITA"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY" if code=="L"&country=="ITA"
replace ind="EDUCATION" if code=="M"&country=="ITA"
replace ind="OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICES" if code=="O"&country=="ITA"
replace ind="CHEMICALS AND CHEMICAL PRODUCTS" if code=="24"&country=="ITA"
replace ind="RENTING AND BUSINESS ACTIVITIES" if code=="71t74"&country=="ITA"

replace ind="AGRICULTURE, HUNTING, FORESTRY AND FISHING" if code=="AtB"&country=="JPN"
replace ind="WOOD AND PRODUCTS OF WOOD AND CORK" if code=="20"&country=="JPN"
replace ind="TRANSPORT AND STORAGE" if code=="60t63" &country=="JPN"
replace ind="MINING AND QUARRYING" if code=="C"&country=="JPN"
replace ind="POST AND TELECOM" if code=="64" &country=="JPN"
replace ind="HOTELS AND RESTAURANTS" if code=="H"&country=="JPN"
replace ind="TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR" if code=="17t19"&country=="JPN"
replace ind="OTHER NON-METALLIC MINERAL PRODUCTS" if code=="26"&country=="JPN"
replace ind="BASIC METALS;FABRICATED METAL PRODUCTS" if code=="27t28"&country=="JPN"
replace ind="SALE, MAINTENANCE AND REPAIR OF MOTORS" if code=="50"&country=="JPN"
replace ind="RUBBER AND PLASTICS PRODUCTS;MFG NEC;RECYCLING" if code=="25" &country=="JPN"
replace ind="RUBBER AND PLASTICS PRODUCTS;MFG NEC;RECYCLING" if code=="36t37"&country=="JPN"
replace ind="TRANSPORT EQUIPMENT" if code=="34t35"&country=="JPN"
replace ind="ELECTRICITY, GAS AND WATER SUPPLY" if code=="E"&country=="JPN"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO" if code=="15t16"&country=="JPN"
replace ind="OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICES" if code=="O"&country=="JPN"
replace ind="MACHINERY;NEC" if code=="29"&country=="JPN"
replace ind="RETAIL TRADE AND REPAIR" if code=="52"&country=="JPN"
replace ind="ELECTRICAL AND OPTICAL EQUIPMENT" if code=="30t33"&country=="JPN"
replace ind="CONSTRUCTION" if code=="F"&country=="JPN"
replace ind="PULP, PAPER, PAPER PRODUCTS, PRINTING AND PUBLISHING" if code=="21t22"&country=="JPN"
replace ind="COKE,REFINED PETROLEUM PRODUCTS AND NUCLEAR FUEL" if code=="23"&country=="JPN"
replace ind="CHEMICALS AND CHEMICAL PRODUCTS" if code=="24"&country=="JPN"
replace ind="RENTING AND BUSINESS ACTIVITIES" if code=="71t74"&country=="JPN"
replace ind="WHOLESALE AND COMMISSION TRADE" if code=="51" &country=="JPN"
replace ind="FINANCIAL INTERMEDIATION" if code=="J"&country=="JPN"
replace ind="REAL ESTATE ACTIVITIES" if code=="70"&country=="JPN"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY;HEALTH AND SOCIAL WORK;EDUCATION" if code=="L"&country=="JPN"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY;HEALTH AND SOCIAL WORK;EDUCATION" if code=="N"&country=="JPN"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY;HEALTH AND SOCIAL WORK;EDUCATION" if code=="M"&country=="JPN"

replace ind="AGRICULTURE, HUNTING, FORESTRY AND FISHING" if code=="AtB"&country=="NLD"
replace ind="CONSTRUCTION" if code=="F"&country=="NLD"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="50"&country=="NLD"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="51"&country=="NLD"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="52"&country=="NLD"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="H"&country=="NLD"
replace ind="POST AND TELECOM" if code=="64" &country=="NLD"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR" if code=="17t19"&country=="NLD"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR" if code=="15t16"&country=="NLD"
replace ind="TRANSPORT AND STORAGE" if code=="60t63" &country=="NLD"
replace ind="MOST OF MANUFACTURING INC RECYCLING" if code=="20"&country=="NLD"
replace ind="MOST OF MANUFACTURING INC RECYCLING" if code=="27t28"&country=="NLD"
replace ind="MOST OF MANUFACTURING INC RECYCLING" if code=="26"&country=="NLD"
replace ind="MOST OF MANUFACTURING INC RECYCLING" if code=="25"&country=="NLD"
replace ind="MOST OF MANUFACTURING INC RECYCLING" if code=="21t22"&country=="NLD"
replace ind="MOST OF MANUFACTURING INC RECYCLING" if code=="23"&country=="NLD"
replace ind="MOST OF MANUFACTURING INC RECYCLING" if code=="24"&country=="NLD"
replace ind="MOST OF MANUFACTURING INC RECYCLING" if code=="36t37"&country=="NLD"
replace ind="FINANCIAL INTERMEDIATION" if code=="J"&country=="NLD"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="29"&country=="NLD"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="30t33"&country=="NLD"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="34t35"&country=="NLD"
replace ind="MINING AND QUARRYING; ELECTRICITY, GAS AND WATER SUPPLY" if code=="E"&country=="NLD"
replace ind="MINING AND QUARRYING; ELECTRICITY, GAS AND WATER SUPPLY" if code=="C"&country=="NLD"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY" if code=="L"&country=="NLD"
replace ind="HEALTH AND SOCIAL WORK" if code=="N"&country=="NLD"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="70"&country=="NLD"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="71t74"&country=="NLD"
replace ind="EDUCATION" if code=="M"&country=="NLD"
replace ind="OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICES" if code=="O"&country=="NLD"


replace ind="POST AND TELECOM" if code=="64" &country=="UK"
replace ind="CONSTRUCTION" if code=="F"&country=="UK"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="50"&country=="UK"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="51"&country=="UK"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="52"&country=="UK"
replace ind="WHOLESALE AND RETAIL TRADE; HOTELS AND RESTAURANTS" if code=="H"&country=="UK"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR,MFG NEC;RECYCLING" if code=="17t19"&country=="UK"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR,MFG NEC;RECYCLING" if code=="15t16"&country=="UK"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO; TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR,MFG NEC;RECYCLING" if code=="36t37"&country=="UK"
replace ind="AGRICULTURE, HUNTING, FORESTRY AND FISHING" if code=="AtB"&country=="UK"
replace ind="TRANSPORT AND STORAGE" if code=="60t63" &country=="UK"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="20"&country=="UK"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="27t28"&country=="UK"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="26"&country=="UK"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="25"&country=="UK"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="21t22"&country=="UK"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="23"&country=="UK"
replace ind="MOST OF MANUFACTURING SANS MACHINERY NEC" if code=="24"&country=="UK"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="29"&country=="UK"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="30t33"&country=="UK"
replace ind="MFG, ELECTRICALS AND TRANSPORT" if code=="34t35"&country=="UK"
replace ind="MINING AND QUARRYING; ELECTRICITY, GAS AND WATER SUPPLY" if code=="E"&country=="UK"
replace ind="MINING AND QUARRYING; ELECTRICITY, GAS AND WATER SUPPLY" if code=="C"&country=="UK"
replace ind="OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICES" if code=="O"&country=="UK"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY" if code=="L"&country=="UK"
replace ind="FINANCIAL INTERMEDIATION" if code=="J"&country=="UK"
replace ind="HEALTH AND SOCIAL WORK" if code=="N"&country=="UK"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="70"&country=="UK"
replace ind="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES" if code=="71t74"&country=="UK"
replace ind="EDUCATION" if code=="M"&country=="UK"

replace ind="SALE, MAINTENANCE AND REPAIR OF MOTORS" if code=="50"&country=="USA"
replace ind="TEXTILES, TEXTILE PRODUCTS, LEATHER AND FOOTWEAR" if code=="17t19"&country=="USA"
replace ind="HOTELS AND RESTAURANTS" if code=="H"&country=="USA"
replace ind="WOOD AND PRODUCTS OF WOOD AND CORK" if code=="20"&country=="USA"
replace ind="MFG NEC;RECYCLING" if code=="36t37"&country=="USA"
replace ind="RUBBER AND PLASTICS PRODUCTS" if code=="25" &country=="USA"
replace ind="BASIC METALS;FABRICATED METAL PRODUCTS" if code=="27t28"&country=="USA"
replace ind="TRANSPORT EQUIPMENT" if code=="34t35"&country=="USA"
replace ind="PULP, PAPER, PAPER PRODUCTS, PRINTING AND PUBLISHING" if code=="21t22"&country=="USA"
replace ind="FOOD PRODUCTS, BEVERAGES AND TOBACCO" if code=="15t16"&country=="USA"
replace ind="RETAIL TRADE AND REPAIR" if code=="52"&country=="USA"
replace ind="MACHINERY;NEC" if code=="29"&country=="USA"
replace ind="AGRICULTURE, HUNTING, FORESTRY AND FISHING" if code=="AtB"&country=="USA"
replace ind="OTHER NON-METALLIC MINERAL PRODUCTS" if code=="26"&country=="USA"
replace ind="CONSTRUCTION" if code=="F"&country=="USA"
replace ind="TRANSPORT AND STORAGE" if code=="60t63" &country=="USA"
replace ind="REAL ESTATE ACTIVITIES" if code=="70"&country=="USA"
replace ind="ELECTRICITY, GAS AND WATER SUPPLY" if code=="E"&country=="USA"
replace ind="WHOLESALE AND COMMISSION TRADE" if code=="51" &country=="USA"
replace ind="POST AND TELECOM" if code=="64" &country=="USA"
replace ind="FINANCIAL INTERMEDIATION" if code=="J"&country=="USA"
replace ind="ELECTRICAL AND OPTICAL EQUIPMENT" if code=="30t33"&country=="USA"
replace ind="HEALTH AND SOCIAL WORK" if code=="N"&country=="USA"
replace ind="MINING AND QUARRYING" if code=="C"&country=="USA"
replace ind="COKE,REFINED PETROLEUM PRODUCTS AND NUCLEAR FUEL" if code=="23"&country=="USA"
replace ind="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY" if code=="L"&country=="USA"
replace ind="EDUCATION" if code=="M"&country=="USA"
replace ind="OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICES" if code=="O"&country=="USA"
replace ind="CHEMICALS AND CHEMICAL PRODUCTS" if code=="24"&country=="USA"
replace ind="RENTING AND BUSINESS ACTIVITIES" if code=="71t74"&country=="USA"

collapse(sum) tlabhs_USD tlabms_USD tlabls_USD th_hs th_ms th_ls tcapit_USD tcapnit_USD va_USD lab_USD cap_USD h_emp emp import* export*, by( country ind year)

*generating wagebill shares for fully disaggregated industries

foreach var of newlist hs ms ls{
gen lab`var' = tlab`var'_USD*100/lab_USD
gen h_`var' = th_`var'*100/h_emp
gen w_`var' = (tlab`var'/th_`var')
}
gen wb_upper_tail=labhs/labms
gen wage_upper_tail=w_hs/w_ms
gen wb_lower_tail=labms/labls
gen wage_lower_tail=w_ms/w_ls
gen wage_high_rest=w_hs/(w_ms+w_ls)
gen hours_upper_tail=h_hs/h_ms
gen hours_lower_tail=h_ms/h_ls
gen hours_high_rest=h_hs/(h_ms+h_ls)

foreach var of varlist wage_high_rest hours_high_rest wage_upper_tail wage_lower_tail hours_upper_tail hours_lower_tail wb_upper_tail wb_lower_tail{
gen ln_`var'=ln(`var')
}

*generating ICT for fully disaggregated industries
gen capit = tcapit_USD/cap_USD
gen capnit = tcapnit_USD/cap_USD
sort  country ind year

*generating trade variables for fully disaggregated industries

foreach var of newlist import export{
gen `var'_nonoecd= `var'_chn+ `var'_rest
}
foreach var of varlist  import_oecd export_oecd import_world export_world import_nonoecd export_nonoecd {
replace `var'=. if `var'==0
gen `var'_over_va = `var'/(va_USD*1000000)
}
foreach var of newlist va{
gen ln_`var'=ln(`var'_USD)
foreach str of newlist tcapit tcapnit{
gen `str'_over_`var'=`str'_USD/`var'_USD
}
}
*generating weights( share of 1980 employment)

foreach num of numlist 80 86 92 98{
egen wt1_`num' = sum(emp) if year==19`num', by(country)
gen wt2_`num' = emp/wt1_`num'
egen wt`num' = mean(wt2_`num'), by(country ind)

egen wtt1_`num' = sum(emp) if year==19`num' & import_world!=., by(country)
gen wtt2_`num' = emp/wtt1_`num'
egen wtt`num' = mean(wtt2_`num'), by(country ind)

egen wtnott1_`num' = sum(emp) if year==19`num' & import_world==., by(country)
gen wtnott2_`num' = emp/wtnott1_`num'
egen wtnott`num' = mean(wtnott2_`num'), by(country ind)
}


gen key = country+ind
* 24 year differences
sort country ind year
foreach var of newlist oecd world nonoecd{
gen trade_`var'=import_`var'+export_`var'
foreach str of newlist va{
gen trade_`var'_over_`str'=trade_`var'/(`str'_USD*1000000)
}
}
foreach var of newlist import export trade{
gen pct_`var'_non=`var'_nonoecd/`var'_world*100
gen pct_`var'_oecd=`var'_oecd/`var'_world*100
}

foreach var of newlist import export{
gen imp_`var'_oecd=`var'_oecd/trade_world
gen imp_`var'=`var'_world/trade_world
}
foreach var of varlist  labhs labms labls tcapit_over_va tcapnit_over_va ln_va import_oecd_over_va export_oecd_over_va import_world_over_va export_world_over_va import_nonoecd_over_va export_nonoecd_over_va trade_oecd_over_va trade_world_over_va trade_nonoecd_over_va pct*{
gen diff24_`var' = `var'-`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
gen lag24_`var' =`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
}
foreach var of varlist  imp_import_oecd imp_import imp_export_oecd imp_export w_hs w_ms w_ls wage_high_rest hours_high_rest wage_upper_tail wage_lower_tail h_hs h_ms h_ls hours_upper_tail hours_lower_tail ln_wage_upper_tail ln_wage_lower_tail ln_hours_upper_tail ln_hours_lower_tail ln_wage_high_rest ln_hours_high_rest ln_wb_upper_tail ln_wb_lower_tail {
gen diff24_`var' = `var'-`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
gen lag24_`var' =`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
}

gen sample=1  if country=="AUT"|country=="DNK"|country=="ESP"|country=="FIN"|country=="FRA"|country=="GER"|country=="ITA"|country=="JPN"|country=="NLD"|country=="UK"|country=="USA"

save mnvr_tab7_intermediate,replace

areg diff24_ln_wb_upper_tail diff24_tcapit_over_va if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab7, replace se bdec(2) noaster
cd ..\dta
use mnvr_tab7_intermediate, clear
areg diff24_ln_wb_upper_tail diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab7, append se bdec(2) noaster
cd ..\dta
use mnvr_tab7_intermediate, clear
areg diff24_ln_wb_lower_tail diff24_tcapit_over_va if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab7, append se bdec(2) noaster
cd ..\dta
use mnvr_tab7_intermediate, clear
areg diff24_ln_wb_lower_tail diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab7, append se bdec(2) noaster

cd ..\dta
use mnvr_tab7_intermediate, clear
areg diff24_ln_wage_upper_tail diff24_tcapit_over_va if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab7, append se bdec(2) noaster
cd ..\dta
use mnvr_tab7_intermediate, clear
areg diff24_ln_wage_upper_tail diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab7, append se bdec(2) noaster
cd ..\dta
use mnvr_tab7_intermediate, clear
areg diff24_ln_wage_lower_tail diff24_tcapit_over_va if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab7, append se bdec(2) noaster
cd ..\dta
use mnvr_tab7_intermediate, clear
areg diff24_ln_wage_lower_tail diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab7, append se bdec(2) noaster

cd ..\dta
use mnvr_tab7_intermediate, clear
areg diff24_ln_hours_upper_tail diff24_tcapit_over_va if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab7, append se bdec(2) noaster
cd ..\dta
use mnvr_tab7_intermediate, clear
areg diff24_ln_hours_upper_tail diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab7, append se bdec(2) noaster
cd ..\dta
use mnvr_tab7_intermediate, clear
areg diff24_ln_hours_lower_tail diff24_tcapit_over_va if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab7, append se bdec(2) noaster
cd ..\dta
use mnvr_tab7_intermediate, clear
areg diff24_ln_hours_lower_tail diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab7, append se bdec(2) noaster

cd ..\dta
