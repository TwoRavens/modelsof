*Replication files for "The Mission"
*Felipe Valencia Caicedo (2018)
*FIGURES

*Set directory

*Figure I
*Produced using ArcGIS
*Available in .png

*use Figure II.dta

*Figure IIa
twoway (scatter literacy distmiss if mission==0) (scatter literacy distmiss if mission==1) (lfitci literacy distmiss) if distmiss<225
*Edited for style as in Figure IIa.gph

*Figure IIb
*Demeaned by country (country FEs) and centered
twoway (scatter litresfecen distmiss if mission==0) (scatter litresfecen distmiss if mission==1) (lfitci litresfecen distmiss) if distmiss<225
*Edited for style as in Figure IIb.gph

*Figure IIc
binscatter literacy distmiss if distmiss<225
*Edited for style as in Figure IIc.gph
*Make sure you have the command binscatter installed: binscatter from http://fmwww.bc.edu/RePEc/bocode/b

*use Figures IIII IV.dta
*Figure IIIa
twoway (scatter lnincome distmiss if mission==0) (scatter lnincome distmiss if mission==1) (lfitci lnincome distmiss) if distmiss<225
*Edited for style as in Figure IIIa.gph

*Figure IIIb
*Demeaned by country (country FEs) and centered
twoway (scatter linresfecen distmiss if mission==0) (scatter linresfecen distmiss if mission==1) (lfitci linresfecen distmiss) if distmiss<225
*Edited for style as in Figure IIIb.gph

*Figure IIIc
binscatter lnincome distmiss if distmiss<225
*Edited for style as in Figure IIIc.gph
*Make sure you have the command binscatter installed: binscatter from http://fmwww.bc.edu/RePEc/bocode/b

*Figure IV
binscatter pca distmiss if distmiss<225
*Edited for style as in Figure IV.gph

*Figure V

*use Figure V.dta
*Data is from Bustos, Caprettini and Ponticelli (2016)
*Available at: https://www.aeaweb.org/articles?id=10.1257/aer.20131061

binscatter gsoy_TA  distmiss if distmiss <245
*Edited for style as in Figure V.gph



