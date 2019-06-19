*******************************************************************************************************************************************MANUSCRIPT: Authorized Generic Entry prior to Patent Expiry: Reassessing Incentives for Independent Generic Entry *AUTHOR:     Silvia Appelt, University of Munich, silvia.appelt@lrz.uni-muenchen.de******************************************************************************************************************************************				                    *** MATCHING of of Patent and SPC data (Patent DB 2007) ***						            		* Date last edit:  11 January 2015 * ******************************************************************************************************************************************   version 13.0set more offcap log closeclear*****(1) Preparation spc.dta **i) Keep German SPC Applications for monosubstances use spc.dta, cleargenerate patentnumber= patentnumberforspcgen patent_geofocus =substr(patentnumber,1,2)drop if spccountry!="Germany"* Delete Polysubstances and Vaccinesgen plus = strpos(inn, "+")tab plus drop if plus!=0gen plus2 = strpos(inn, "and")tab plus2 keep if plus2==0 | plus2==2 | plus2==3gen plus3 = strpos(inn, "vaccine")tab plus3 drop if plus3!=0gen plus4 = strpos(inn, "Vaccine")tab plus4 drop if plus4!=0drop plus*drop if inn=="A/Viet Nam/1194/2004 (H5N1) virus surface inactivated antigen" | inn=="A/Viet Nam/1194/2004 (H5N1) whole virus inactivated antigen"*see variable remark replace nationalfirstauthdate="11/07/2000" if spcnumber=="10199002"*unique identifier: spcnumberby spcnumber, sort: generate help=_nby spcnumber, sort: egen index=max(help)tab index *49 cases (out of 563) some basic spc information (e.g. spcnumber) is missingdrop help index*match data using patentnumber (unique identifier in master data)sort patentnumbersave spc_mod, replace**(2) Preparation patent.dta (German and EP patents only)use patent.dta, clearsort patentnumbergen patent_geofocus =substr(patentnumber,1,2)tab patent_geofocus keep if patent_geofocus =="DE" | patent_geofocus=="EP"tab patent_geofocussort patentnumbersave patent_mod, replace**(3) Matching of Patent_mod.dta and SPC_mod.dta merge patentnumber using spc_mod.dtatab _mdrop _mdrop if patentnumber=="EP0669836" & spcapplicationdate=="" & spcnumber==""count if patentnumber!="" & spcnumber==""  count if patentnumber!="" count if patentnumber!="" & spcnumber!=""                          count if patentnumber!="" & spcnumber!="" & patent_geofocus=="DE"  count if patentnumber!="" & spcnumber!="" & patent_geofocus=="EP"  *patentnumber unique identifier whenever spcnumber is missing*Data matching based on INN (unique identifier in using data set)sort inn save patent_spc.dta, replace**(4) Preparation speciality.dta *Keep Market Approvals of Monosubstances in Germanyuse speciality.dta, cleardrop if country!="Germany"gen plus = strpos(inn, "+")tab plus drop if plus!=0gen plus2 = strpos(inn, "and")tab plus2 keep if plus2==0 | plus2==2 | plus2==3gen plus3 = strpos(inn, "vaccine")tab plus3 drop if plus3!=0gen plus4 = strpos(inn, "Vaccine")tab plus4 drop if plus4!=0drop plus*drop if inn=="A/Viet Nam/1194/2004 (H5N1) virus surface inactivated antigen" | inn=="A/Viet Nam/1194/2004 (H5N1) whole virus inactivated antigen"egen help=group(inn)by inn, sort: egen index=count(help)tab indexdrop if inn=="Pravastatin" & country=="Germany" & fma=="15/02/1990" | fma=="15/03/1991"drop help index*INN unique identifiersort inn             save speciality_mod.dta, replace**(5) Match patent_spc.dta and speciality_mod.dta use patent_spc.dta, clearmerge inn using speciality_modtab _mdrop _mcount if patentnumber!=""                             count if spcnumber!="" & patentnumber!="" & inn!=""  count if spcnumber!="" & patentnumber!="" & fma!=""   sort innsave patent_spc.dta, replace**(6) Preparation document.dta *Keep Monosubstancesuse document.dta, cleargen plus = strpos(generalnames, "+")tab plus drop if plus!=0gen plus2 = strpos(generalnames, "and")tab plus2 keep if plus2==0 | plus2==2 | plus2==3gen plus3 = strpos(generalnames, "vaccine")tab plus3 drop if plus3!=0gen plus4 = strpos(generalnames, "Vaccine")tab plus4 drop if plus4!=0drop plus*drop usan ban french spanish jan other rnchemicalabstracts generalformula lastupdate chemicalcategory biologicalcategory dosageforms lastupdate update atc1ephmra atc2ephmra atc3ephmra atc4ephmra atc1who atc2who atc3who atc4who atc5who userfield1 userfield2 userfield3 userfield4 userfield5 atcwhocode atcwho devtherapeuticalclass devtherapeuticalcode var1 apistatusmostadvanced apistatusallgenerate inn=generalnamesdrop if inn=="A/Viet Nam/1194/2004 (H5N1) virus surface inactivated antigen" | inn=="A/Viet Nam/1194/2004 (H5N1) whole virus inactivated antigen"*INN unique identifiersort innsave document_mod, replace**(7) Matching of patent_spc.dta and document_mod.dta use patent_spc.dta, clearsort innmerge inn using document_modtab _mdrop _mcount if patentnumber!=""                                          count if spcnumber!="" & patentnumber!="" & inn!=""                count if spcnumber!="" & patentnumber!="" & fma!=""                count if spcnumber!="" & patentnumber!="" & fma!="" & german!=""   count if spcnumber=="" & patentnumber!="" & german!=""             count if spcnumber=="" & patentnumber!="" & german!=""  & patent_geofocus=="DE"           count if spcnumber=="" & patentnumber!="" & german!=""  & patent_geofocus=="EP"           sort inn nationalfirstauthnumbersave patent_spc, replace**(8) Preparation dosage.dta*Keep Monosubstances authorized in Germanyuse dosage, cleargenerate nationalfirstauthnumber=authorizationnumberdrop if marketauthcountry!="Germany"gen plus = strpos(inn, "+")tab plus drop if plus!=0gen plus2 = strpos(inn, "and")tab plus2 keep if plus2==0 | plus2==2 | plus2==3gen plus3 = strpos(inn, "vaccine")tab plus3 drop if plus3!=0gen plus4 = strpos(inn, "Vaccine")tab plus4 drop if plus4!=0drop plus*drop if inn=="A/Viet Nam/1194/2004 (H5N1) virus surface inactivated antigen" | inn=="A/Viet Nam/1194/2004 (H5N1) whole virus inactivated antigen"egen help=group(authorizationnumber)by authorizationnumber, sort: egen index=count(help)tab index*delete duplicates (observation with missing information) drop if index==2 & combination==""*authorizationnumber unique identifier, but missing in 5444 casesdrop help index  count if authorizationnumber==""drop if authorizationnumber==""egen help=group(inn authorizationnumber)by inn authorizationnumber, sort: egen index=count(help)tab indexdrop help index*INN authorizationnumber unique identifiersort inn nationalfirstauthnumbersave dosage_mod, replace**(9) Matching of patent_spc.dta and dosage_mod.dta use patent_spc, clearsort inn nationalfirstauthnumbermerge inn nationalfirstauthnumber using dosage_modtab _mcount if patentnumber!=""                                          count if spcnumber!="" & patentnumber!="" & inn!=""                count if spcnumber!="" & patentnumber!="" & fma!=""                count if spcnumber!="" & patentnumber!="" & fma!="" & german!=""   count if spcnumber=="" & patentnumber!="" & german!=""             drop _msave patent_spc, replace*****(10) Patent-SPC Data - extract final data for matching with NPI datause patent_spc, clear*Drop observations where key information is missingdrop if patent_geofocus=="EP" & spccountry=="" & country=="" & german=="" & eufirstauthcountry!="Germany"drop if patentnumber==""drop if inn=="" & product=="" & generalnames=="" & german=="" & chemicalname==""drop patenttitle abstract remark equivalents patenttypeshort patenttype patentnumberforspc remarks patentusecode comments mw uses producerbulk rxotc dosageform strength quantity combination* Complement missing information*Productreplace product=inn if product=="" & inn!=""*Variable Germanreplace german=inn if german=="" & inn!=""*nationalfirstauthdate and fmareplace nationalfirstauthdate=fma if nationalfirstauthdate=="" & fma!=""replace fma=nationalfirstauthdate if nationalfirstauthdate!="" & fma==""save patent_spc_final, replace*destring date variableslocal list publicationdate orignialexpiry1 originalexpiry2 patentappldate originalexpiry expirydatecurrent expirydateexpected spcapplicationdate spcdeliverydate nationalfirstauthdate eufirstauthdate fmaquietly foreach var of varlist `list' {gen `var'_num=date(`var', "DMY")gen `var'_year=year(`var'_num)format `var'_num %td}*name cleaning prior to mergereplace german="Alendronsäure" if german=="Alendronsaeure"replace german="Cabergolin" if inn=="Cabergoline"replace german="Cefpodoxim" if inn=="Cefpodoxime Proxetil"replace german="Cefpodoxim" if inn=="Cefpodoxime proxetil"replace german="Fluconazol" if inn=="Fluconazole"replace german="Flumazenil" if inn=="Flumazenil"replace german="Granisetron" if inn=="Granisetron"replace german="Leuprorelin" if inn=="Leuprorelin"replace german="Olanzapin" if inn=="Olanzapine"replace german="Oxaliplatin" if inn=="Oxaliplatin"replace german="Oxcarbazepin" if inn=="Oxcarbazepine"replace german="Oxycodon" if inn=="Oxycodone"replace german="Pamidronsäure" if inn=="Pamidronic acid"replace german="Terbinafin" if inn=="Terbinafine"generate substances=germanegen help=group(substances spcnumber)by substances spcnumber, sort: egen index=count(help)tab indexdrop help index*substances spcnumber unique identifier, but spcnumber missing in 48 casessort substancesegen sub_no=group(substances)  sum sub_no, dgenerate patent_count= .generate spc_count= .sum sub_nolocal num=r(max)+1local x=1quietly while `x'<`num' {egen help1=group(patentnumber) if sub_no==`x'egen help2=max(help1) replace patent_count=help2 if sub_no==`x'drop help*egen help1=group(spcnumber) if sub_no==`x'egen help2=max(help1) replace spc_count=help2 if sub_no==`x'drop help*local x=`x'+1}tab patent_counttab spc_countdrop sub_nocompresssort substancessave patent_spc_final, replace*** end of do file