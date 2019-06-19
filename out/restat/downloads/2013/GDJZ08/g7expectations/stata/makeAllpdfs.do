
* This is a batch file that creates new pdf files for all documents
#delimit;

local basePath "C:\Jirka\Research\g7expectations\g7expectations";
local acrobat "C:\Program Files\Adobe\Acrobat 5.0\Acrobat\Acrobat.exe";

cd "`basePath'\stata";
capture log close;
log using makeAllpdfs.log, replace;

* Create pdfs
*********************************************************************;
local fileList "\app_DescrStats \app_DriversOfDisagreement \app_EfficiencyOfConsensus \app_Obs \app_PanelDriversOfDisagreement";
local graphList "\app_GraphsMacro \app_GraphsSummary \app_GraphsSummarySub \app_IndividualForecasts";

cd "`basePath'\docs\paper";
shell latex "`basePath'\docs\paper\disagreement.tex";
shell pdflatex "`basePath'\docs\paper\disagreement.tex";
shell latex "`basePath'\docs\paper\disagreement_nts.tex";
shell pdflatex "`basePath'\docs\paper\disagreement_nts.tex";
shell latex "`basePath'\docs\paper\onlineAppendix.tex";
shell pdflatex "`basePath'\docs\paper\onlineAppendix.tex";
cd "`basePath'\docs\slides";
shell latex "`basePath'\docs\slides\disagreementSlides.tex";
shell pdflatex "`basePath'\docs\slides\disagreementSlides.tex";

* Open them in Acrobat;
***********************************************************************;

winexec "`acrobat'" "`basePath'\docs\slides\disagreementSlides.pdf";
winexec "`acrobat'" "`basePath'\docs\paper\onlineAppendix.pdf";
winexec "`acrobat'" "`basePath'\docs\paper\disagreement_nts.pdf";
winexec "`acrobat'" "`basePath'\docs\paper\disagreement.pdf";

cd "`basePath'\stata";
log close;