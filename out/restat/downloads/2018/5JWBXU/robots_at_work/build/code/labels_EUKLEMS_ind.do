* industry labels for EUKLEMS 2011 DATA
	gen desc= ""
		replace desc="TOTAL INDUSTRIES" if code =="TOT"
		replace desc="AGRICULTURE, HUNTING, FORESTRY AND FISHING " if code=="AtB"
		replace desc= "MINING AND QUARRYING" if code=="C" 
		replace desc="TOTAL MANUFACTURING" if code=="D"
		replace desc= "FOOD ,BEVERAGES AND TOBACCO" if code=="15t16"
		replace desc= "TEXTILES, TEXTILE , LEATHER AND FOOTWEAR" if code=="17t19"
		replace desc= "WOOD AND OF WOOD AND CORK" if code=="20"
		replace desc= "PULP, PAPER, PAPER , PRINTING AND PUBLISHING" if code=="21t22"
		replace desc= "CHEMICAL, RUBBER, PLASTICS AND FUEL" if code=="23t25"
		replace desc="Coke, refined petroleum and nuclear fuel"	if code=="23"
		replace desc="Chemicals and chemical" if code=="24"
		replace desc="Rubber and plastics" if code=="25"
		replace desc= "OTHER NON-METALLIC MINERAL"	if code=="26"
		replace desc="BASIC METALS AND FABRICATED METAL" if code=="27t28"
		replace desc="MACHINERY, NEC"	if code=="29"
		replace desc="ELECTRICAL AND OPTICAL EQUIPMENT"	if code=="30t33"
		replace desc="TRANSPORT EQUIPMENT"	if code=="34t35"
		replace desc="MANUFACTURING NEC; RECYCLING"	if code=="36t37"
		replace desc="ELECTRICITY, GAS AND WATER SUPPLY"	if code=="E"
		replace desc="CONSTRUCTION" if code=="F"
		replace desc="WHOLESALE AND RETAIL TRADE" if code=="G"
		replace desc="Sale, maintenance and repair of motor vehicles and motorcycles; retail sale of fuel" if code=="50"
		replace desc="Wholesale trade and commission trade, except of motor vehicles and motorcycles"	if code=="51"
		replace desc="Retail trade, except of motor vehicles and motorcycles; repair of household goods" if code=="52"
		replace desc="HOTELS AND RESTAURANTS"	if code=="H"
		replace desc="TRANSPORT AND STORAGE AND COMMUNICATION"	if code=="I"
		replace desc="TRANSPORT AND STORAGE"	if code=="60t63"
		replace desc="POST AND TELECOMMUNICATIONS"	if code=="64"
		replace desc="FINANCE, INSURANCE, REAL ESTATE AND BUSINESS SERVICES"	if code=="JtK"
		replace desc="FINANCIAL INTERMEDIATION"	if code=="J"
		replace desc="REAL ESTATE, RENTING AND BUSINESS ACTIVITIES"	if code=="K"
		replace desc="Real estate activities"	if code=="70"
		replace desc="Renting of m&eq and other business activities"	if code=="71t74"
		replace desc="COMMUNITY SOCIAL AND PERSONAL SERVICES"	if code=="LtQ"
		replace desc="PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY"	if code=="L"
		replace desc="EDUCATION"	if code=="M"
		replace desc="HEALTH AND SOCIAL WORK"	if code=="N"
		replace desc="OTHER COMMUNITY, SOCIAL AND PERSONAL SERVICES"	if code=="O"
		replace desc="PRIVATE HOUSEHOLDS WITH EMPLOYED PERSONS"	if code=="P"
		replace desc="EXTRA-TERRITORIAL ORGANIZATIONS AND BODIES"	if code=="Q"
		replace desc="AGRICULTURE, HUNTING AND FORESTRY" if code=="A"
		replace desc="Agriculture" if code=="1"
		replace desc="Forestry" if code=="2"
		replace desc="FISHING" if code=="B"
		replace desc="MINING AND QUARRYING OF ENERGY PRODUCING MATERIALS" if code=="10t12"
		replace desc="Mining of coal and lignite; extraction of peat" if code=="10"
		replace desc="Extraction of crude petroleum and natural gas and services" if code=="11"
		replace desc="Mining of uranium and thorium ores" if code=="12"
		replace desc="MINING AND QUARRYING EXCEPT ENERGY PRODUCING MATERIALS" if code=="13t14"
		replace desc="Mining of metal ores" if code=="13"
		replace desc="Other mining and quarrying" if code=="14"
		replace desc="Food and beverages" if code=="15"
		replace desc="Tobacco" if code=="16"
		replace desc="Textiles and textile" if code=="17t18"
		replace desc="Textiles" if code=="17"
		replace desc="Wearing Apparel, Dressing And Dying Of Fur" if code=="18"
		replace desc="Leather, leather and footwear" if code=="19"
		replace desc="Pulp, paper and paper" if code=="21"
		replace desc="Printing, publishing and reproduction" if code=="22"
		replace desc="Publishing" if code=="221"
		replace desc="Printing and reproduction" if code=="22x"
		replace desc="Pharmaceuticals" if code=="244"
		replace desc="Chemicals excluding pharmaceuticals" if code=="24x"
		replace desc="Basic metals" if code=="27"
		replace desc="Fabricated metal" if code=="28"
		replace desc="Office, accounting and computing machinery" if code=="30"
		replace desc="Electrical engineering" if code=="31t32"
		replace desc="Electrical machinery and apparatus, nec" if code=="31"
		replace desc="Insulated wire" if code=="313"
		replace desc="Other electrical machinery and apparatus nec" if code=="31x"
		replace desc="Radio, television and communication equipment" if code=="32"
		replace desc="Electronic valves and tubes" if code=="321"
		replace desc="Telecommunication equipment" if code=="322"
		replace desc="Radio and television receivers" if code=="323"
		replace desc="Medical, precision and optical instruments" if code=="33"
		replace desc="Scientific instruments" if code=="331t3"
		replace desc="Other instruments" if code=="334t5"
		replace desc="Motor vehicles, trailers and semi-trailers" if code=="34"
		replace desc="Other transport equipment" if code=="35"
		replace desc="Building and repairing of ships and boats" if code=="351"
		replace desc="Aircraft and spacecraft" if code=="353"
		replace desc="Railroad equipment and transport equipment nec" if code=="35x"
		replace desc="Manufacturing nec" if code=="36"
		replace desc="Recycling" if code=="37"
		replace desc="ELECTRICITY AND GAS" if code=="40"
		replace desc="Electricity supply" if code=="40x"
		replace desc="Gas supply" if code=="402"
		replace desc="WATER SUPPLY" if code=="41"
		replace desc="Other Inland transport" if code=="60"
		replace desc="Other Water transport" if code=="61"
		replace desc="Other Air transport" if code=="62"
		replace desc="Other Supporting and auxiliary transport activities; activities of travel agencies" if code=="63"
		replace desc="Financial intermediation, except insurance and pension funding" if code=="65"
		replace desc="Insurance and pension funding, except compulsory social security" if code=="66"
		replace desc="Activities related to financial intermediation" if code=="67"
		replace desc="Renting of machinery and equipment" if code=="71"
		replace desc="Computer and related activities" if code=="72"
		replace desc="Research and development" if code=="73"
		replace desc="Other business activities" if code=="74"
		replace desc="Legal, technical and advertising" if code=="741t4"
		replace desc="Other business activities, nec" if code=="745t8"
		replace desc="Sewage and refuse disposal, sanitation and similar activities" if code=="90"
		replace desc="Activities of membership organizations nec" if code=="91"
		replace desc="Recreational, cultural and sporting activities" if code=="92"
		replace desc="Media activities" if code=="921t2"
		replace desc="Other recreational activites" if code=="923t7"
		replace desc="Other service activities" if code=="93"