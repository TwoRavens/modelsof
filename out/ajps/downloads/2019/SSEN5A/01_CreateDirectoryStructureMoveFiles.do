
* Create directory structure for all files and move rawdata into appropriate folder.

* CCES folder structure
!mkdir CCES2014
!mkdir CCES2014\RawData
!mkdir CCES2014\Figures
!mkdir CCES2014\Tables

* move CCES files
!move HillHuberCCES2014.dta CCES2014\RawData
!move CCES2014codebook.pdf CCES2014
!move 02_01_CCES2014_CreateCodebook.do CCES2014
!move 02_02_CCES2014_PerformCoreAnalysis.do CCES2014
!move 02_03_CCES2014_MakeFigures.R CCES2014

* LUCID folder structure
!mkdir Lucid
!mkdir Lucid\RawData
!mkdir Lucid\Figures
!mkdir Lucid\Tables

* move Lucid files
!move HillHuberLucidLong_withweights.dta Lucid\RawData
!move HillHuberLucidWide_withweights.dta Lucid\RawData

!move Lucidcodebook.pdf Lucid
!move 04_01_Lucid_CreateCodebook.do Lucid
!move 04_02_Lucid_AnalyzeData.do Lucid
!move 04_03_Lucid_Plots.R Lucid

* SSI Folder Structure
!mkdir SSI
!mkdir SSI\figures
!mkdir SSI\RawData
!mkdir SSI\tables

* move SSI files
!move HillHuberLucidLong_withweights.dta Lucid\RawData
!move HillHuberLucidWide_withweights.dta Lucid\RawData
!move HillHuberSSI.dta SSI\RawData
!move Huber_and_Hill_Roll_Call_Experiment-recodes.dta SSI\RawData
!move PreppedIRTData-Unscreened.csv SSI\RawData
!move PreppedIRTData-Screened.csv  SSI\RawData
!move rakedPewWeights.dta  SSI\RawData
!move SSICaseIDs.dta SSI\RawData

!move *.pdf SSI
!move *.do SSI
!move *.R SSI


