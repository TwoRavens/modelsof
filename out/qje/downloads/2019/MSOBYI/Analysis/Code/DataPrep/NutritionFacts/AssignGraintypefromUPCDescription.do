/* AssignGraintypefromUPCDescription.do */
	* Note: this should be consistent with LastGrainTypes.do. However, LastGrainTypes is based off of the graintype code, which we only have through 2008 or 2009. There are a lot of new bread UPCS. Furthermore, the upc_descr field has a very good link to the graintypes, although there are a small number (say 5%) inconsistencies where it is not clear whether the upc_descr or the graintype is correct. So I am actually fine with this approach of using upc_descr to assign whole wheat.

	
gen byte Wheat = cond( strpos(upc_descr,"WHE")!=0 | ///
	strpos(upc_descr,"20G")!=0 | /// 20-grain
	strpos(upc_descr,"14G")!=0 | /// 14-grain
	strpos(upc_descr,"12G")!=0 | /// 12-grain
	strpos(upc_descr,"9G")!=0 | /// 9-grain
	strpos(upc_descr,"8G")!=0 | /// 8-grain
	strpos(upc_descr,"7G")!=0 | /// 7-grain
	strpos(upc_descr,"6 GRM")!=0 | /// 6-grain
	(strpos(upc_descr,"GRN ")!=0&strpos(upc_descr,"GRN ")!=1 ) | /// Green and Freedman. Add space to avoid "Grinder" (GRNDR)
	(strpos(upc_descr,"GRNS ")!=0&strpos(upc_descr,"GRNS")!=1 ) | /// Green and Freedman. Add space to avoid "Grinder" (GRNDR)
	strpos(upc_descr," OM ")!=0 | /// Oat
	(strpos(upc_descr,"O-H")!=0 & strpos(upc_descr,"O-H")!=1) | /// Oatmeal; not "OLD HOME" brand
	strpos(upc_descr," O-B ")!=0 | /// Oat Bran
	strpos(upc_descr,"OAT")!=0 | /// 
	strpos(upc_descr,"M-G")!=0 | /// Multigrain
	strpos(upc_descr,"WDK")!=0 | /// dark wheat
	strpos(upc_descr," BRN ")!=0 | /// bran
	strpos(upc_descr," BRNLA ")!=0 | /// branola
	strpos(upc_descr,"WH-C")!=0 | /// cracked wheat.
	strpos(upc_descr,"W-HNY")!=0 | /// honey wheat
	strpos(upc_descr," HNW ")!=0 | /// honey wheat
	strpos(upc_descr," WB ")!=0 | /// wheatberry as an individual word
	strpos(upc_descr,"B RC")!=0 | /// brown rice
	strpos(upc_descr,"G-ML")!=0 | /// multigrain
	/// BELOW HERE IS ALSO WHOLE 
	strpos(upc_descr,"W-W")!=0 | /// 
	strpos(upc_descr,"WWH")!=0 | /// 
	strpos(upc_descr,"WHL")!=0 | /// 
	strpos(upc_descr,"GWHY")!=0 | /// whole grain
	strpos(upc_descr,"WH-G")!=0 | /// 
	strpos(upc_descr,"RY-WL")!=0 | /// whole rye
	strpos(upc_descr,"SPT")!=0 | /// sprouted
	strpos(upc_descr,"G-WH")!=0 | /// 
	strpos(upc_descr,"G-WM")!=0 | /// whole multigrain
	strpos(upc_descr," WG ")!=0 | /// use spaces, as WGB and MWG mean something else.
	strpos(upc_descr,"WGW")!=0 | ///
	strpos(upc_descr,"WW100%")!=0 | /// This gets the Weight Watchers whole wheat which is coded out below.
	(strpos(upc_descr,"WW")!=0 & strpos(upc_descr,"WW")!=1  ), /// Weight watchers gets coded as whole wheat; the brand is always first in the UPC description
		1,0) /// 
		if inlist(product_module_code,4000,4001,4002) 
		

gen byte Whole = cond( ///
	strpos(upc_descr,"W-W")!=0 | /// strpos(upc_descr,"WH-C")!=0 | /// cracked wheat. don't call this whole, because in practice has low fiber.
	strpos(upc_descr,"WWH")!=0 | /// 
	strpos(upc_descr,"WHL")!=0 | /// 
	strpos(upc_descr,"GWHY")!=0 | /// whole grain
	strpos(upc_descr,"WH-G")!=0 | /// 
	strpos(upc_descr,"RY-WL")!=0 | /// whole rye
	strpos(upc_descr,"SPT")!=0 | /// sprouted
	strpos(upc_descr,"G-WH")!=0 | /// 
	strpos(upc_descr,"G-WM")!=0 | /// whole multigrain
	strpos(upc_descr," WG ")!=0 | /// use spaces, as WGB and MWG mean something else.
	strpos(upc_descr,"WGW")!=0 | ///
	strpos(upc_descr,"WW100%")!=0 | /// This gets the Weight Watchers whole wheat which is coded out below.
	(strpos(upc_descr,"WW")!=0 & strpos(upc_descr,"WW")!=1  ), /// Weight watchers gets coded as whole wheat; the brand is always first in the UPC description
		1,0) /// 
		if inlist(product_module_code,4000,4001,4002) 

* Rye
	* Note that Marble MRBL is not necessarily rye, so can't use that.
gen byte Rye = cond( strpos(upc_descr,"RYE")!=0 | ///
	strpos(upc_descr,"PUMP")!=0 | ///
	strpos(upc_descr,"RY-WL")!=0 , 1,0 ) /// whole grain rye
		if inlist(product_module_code,4000,4001,4002) 
	