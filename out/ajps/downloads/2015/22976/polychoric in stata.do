use "C:\Dropbox\Conspiracy\2011 CCES\polychoric in stata.dta" ,clear
 		   
polychoric truther911 obamabirth fincrisis fluorolights ///
           sorosplot iraqjews vaportrail ///
		   [pweight = V101_x], dots
		   
matrix j = r(R)		   


predict chronconsp partconsp

factormat j, n(1000) factors(2) 


predict chronconsp2 partconsp2


save "C:\Dropbox\Conspiracy\2011 CCES\polychoric in stata2.dta", replace

* caltech correlations



use "C:\Dropbox\Conspiracy\2011 CCES\polychoric in stata-CalTech.dta" ,clear



polychoric truther911 obamabirth fincrisis fluorolights ///
           sorosplot iraqjews vaportrail ///
		   [pweight = V101_x], dots

matrix k = r(R)		   

factormat k, n(1000) factors(2) 

predict chronconsp2 partconsp2

save "C:\Dropbox\Conspiracy\2011 CCES\polychoric in stata2-CalTech.dta", replace

		   
		   
