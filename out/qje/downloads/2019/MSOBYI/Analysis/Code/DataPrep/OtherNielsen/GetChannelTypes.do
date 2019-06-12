/* GetChannelTypes.do */
* Identify store types of interest

	* Grocery
	gen byte C_Grocery = cond(channel_type=="Grocery",1,0)

	* Chain vs. non-chain grocery
		* Chain is any grocer with known retailer code and no more than 75% of all household shoppers coming from the same county. Could also use retailers with fewer than 10 households shopping there, but this additional restriction wouldn't affect the estimates because it mechanically pertains to retailers with low volume.
	merge 1:1 retailer_code using $Externals/Calculations/OtherNielsen/StoreCounts.dta, nogen keep(match master) keepusing(CountyHouseholdShare)
	gen byte C_ChainGroc = cond(channel_type=="Grocery"&CountyHouseholdShare<0.75&CountyHouseholdShare!=.&inlist(retailer_code,3996,3997,3998,3999)==0,1,0) // 3996-3999 are unknown/other stores; see USDA Dry Grocery Department Purchase Data Specifications.xls. Also include any with missing CountyHouseholdShare, which means that nobody ever shops there in Neilsen Homescan.
	drop CountyHouseholdShare

	gen byte C_NonChainGroc = cond(C_Grocery==1&C_ChainGroc==0,1,0)
	
	* Discount
	gen byte C_Discount = cond(inlist(channel_type,"Discount Store","Dollar Store","Close Out Store"),1,0) // includes Target, Walmart, KMart.
	
	* Warehouse Club
	gen byte C_Club =  cond(inlist(channel_type,"Warehouse Club"),1,0) 
	
	* Standard Walmart and Target
	gen byte C_WalTar = cond(inlist(retailer_code,6901,6905),1,0)
	
	* Supercenters
	gen byte C_Super = cond(inlist(retailer_code,6919,6920,6921)|channel_type=="Hypermarket",1,0) // K Mart Super, Walmart Super, and Target Super
	
	* Supercenters and Club stores (matches Zip Code Business Patterns)
	gen byte C_SuperClub = C_Club+C_Super
	
	* Mass (Discount, Supercenter, and and Warehouse Club)
	gen byte C_Mass = cond(inlist(channel_type,"Discount Store","Dollar Store","Close Out Store","Warehouse Club","Hypermarket"),1,0) // All Supercenters, Club Stores, and Discount Stores from above. Includes Target, Walmart, KMart, and Costco. 
	
	* OtherMass (Mass merchants, excluding supercenters and club stores)
	gen byte C_OtherMass = cond(C_Mass==1&C_SuperClub==0,1,0)
		
	* Convenience and drugstores
	gen byte C_DrugConv = cond(inlist(channel_type,"Convenience Store","Service Station","Gas Mini Mart","Bodega","Drug Store"),1,0)
	
	* Drug
	gen byte C_Drug = cond(inlist(channel_type,"Drug Store"),1,0)
	
	* Other
	gen byte C_Other = cond(C_Grocery==0&C_Mass==0&C_DrugConv==0,1,0)
	
	** Labels 
	label var C_Super "1(Supercenter)"
	label var C_SuperClub "1(Supercenter/club)"
	label var C_OtherMass "1(Other mass merchant)"
	label var C_NonChainGroc "1(Non-chain grocery)"
	label var C_ChainGroc "1(Chain grocery)"
	label var C_Grocery "1(Grocery)"
	label var C_Mass "1(Mass merchant)"
	label var C_Club "1(Warehouse club)"
	label var C_Discount "1(Discount)"
	label var C_DrugConv "1(Drug/convenience store)"
	label var C_Drug "1(Drug store)"
	
	gen MajChannel = ""
	
	foreach channel in Grocery Mass DrugConv Other {
		replace MajChannel = "`channel'" if C_`channel' == 1
	}
	encode MajChannel, gen(MajorChannel)
	drop MajChannel
