** Master script:

** Nielsen, Richard, and Beth Simmons. Forthcoming. "Rewards for Ratification: 
** Payoffs for Participating in the International Human Rights Regime?" 
** International Studies Quarterly.

** This script primarily calls Stata (12.1) directly, but at times
** switches to R (3.0.2).  As such, run it piece by piece -- running the
** whole thing won't work.  R code is preceeded by #

** This script assumes that the working directory is set to top level of the archive (using cd)

cd "TOP/DIR/OF/ARCHIVE/HERE"
*****************
** Aid analysis
*****************

** make the forign aid data
do "aid/scripts/0_make aid data.do"
** make the rest of the data
do "aid/scripts/1_make data.do"
** Do the matching (in R), with the working directory set to the top leve lof the archive (using setwd())
## Begin R code (3.0.2)
setwd("TOP/DIR/OF/ARCHIVE/HERE")
source("aid/scripts/2_matching.R")
## End R code
** run the main models
do "aid/scripts/3_models w matching.do"
** run the robustness models
do "aid/scripts/4_robustness.do"
** run a few more models
do "aid/scripts/5_otherstuff.do"

** the main regression results are in ~/aid/results/fulltable.rtf
** the robustness results are in ~/aid/results/4_aid models robustness.smcl

*****************
** PTA analysis
*****************

** make the data
do "pta/scripts/1_make ratification episode data.do"
## Begin R code (3.0.2)
## The matching is split into for scripts because it takes a long time for each
## This way, you can at least run them at the same time (if you have enough cores)
setwd("TOP/DIR/OF/ARCHIVE/HERE")
source("pta/scripts/2a_matching with iccpr.R")
source("pta/scripts/2b_matching with opt1.R")
source("pta/scripts/2c_matching with cat.R")
source("pta/scripts/2d_matching with art22.R")
## End R code
** run the main models
do "pta/scripts/3_models with matching.do"
** run the robustness models
do "pta/scripts/4a_robustness iccpr.do"
do "pta/scripts/4b_robustness opt1.do"
do "pta/scripts/4c_robustness cat.do"
do "pta/scripts/4d_robustness art22.do"
** run a few more models
do "pta/scripts/5_other stuff.do"

** the main regression results are in ~/pta/results/fulltable.rtf
** the robustness results are in ~/pta/results/4_... pta models robustness.smcl


*****************
** BIT analysis
*****************

** make the data
do "bits/scripts/1_make data.do"
** do the matching
## Begin R code (3.0.2)
## The matching is split into for scripts because it takes a long time for each
## This way, you can at least run them at the same time (if you have enough cores)
setwd("TOP/DIR/OF/ARCHIVE/HERE")
source("bits/scripts/2a_matching with iccpr.R")
source("bits/scripts/2b_matching with opt1.R")
source("bits/scripts/2c_matching with cat.R")
source("bits/scripts/2d_matching with art22.R")
## End R code
** run the main models
do "bits/scripts/3_matching models.do"
** run the robustness models
do "bits/scripts/4a_bit robustness iccpr.do"
do "bits/scripts/4b_bit robustness opt1.do"
do "bits/scripts/4c_bit robustness cat.do"
do "bits/scripts/4d_bit robustness art22.do"
** run a few more models
do "bits/scripts/5_other stuff.do"

** the main regression results are in ~/bits/results/fulltable.rtf
** the robustness results are in ~/bits/results/4_... pta models robustness.smcl


*****************
** Amnesty International
*****************

** run everything
do "ai/scripts/replication and analysis.do"

** the main regression results are in ~/ai/results/ai table.doc


*******************
** Text analysis
*******************

** European Press Releases
The python scripts that we used to scrape the EU website and clean up the text are as follows:
1) EUscrape14jul2010.py  (to scrape)
  This puts text files in "EuroData14jul2010" (now saved at "~/archive/text/rawdata/EuroData14jul2010")
2) EU-NameAndSlice14jul2010.py  (processing)  
  This puts text files in "EuroBriefs14jul2010" (intermediate step saved on my personal hard drive, but not in the archive)
3) EU-finalize-briefs14jul2010.py (more processing)
  This puts text files in "EuroData14jul2010" (now saved at "~/archive/text/rawdata/EuroData14jul2010")

Then we used the following R script (interactively) to find praise
You can sourse the script, but the results are all displayed interactively in R
"text/scripts/naive bayes find praise.R"

Then we looked at sentiment and occurances of the word "visit" using:
1) "text/scripts/searchAllCountryMentions.py" to make a csv of the mentions of each country in 10 word context
2) "text/scripts/analyze mentions.R" to do the analysis
  During this script, I save the R workspace at various points
  This means that if you want to reproduce a result, just load the 
  Workspace that was saved most recently and then run just the code
  To get to that result.  This saves a long time waiting for the 
  some of the loops over the sentiment dictionary to run.
  NOTE- this file can't be called using source() because of some bad comments I left in
** results of the sentiment analysis are in ~\text\results\positiveWords.pdf and ~\text\results\negativeWords.pdf 
** results to the "visit" analysis are in the script (but I don't save them anywhere)

** US Press Briefings
We don't have the python scripts that pulled the data down.  
A note about this from John Sheffield, who did the RA work to put this together:
"US BRIEFING SCRIPTS
The briefs I had were divided into three broad categories: the set that I scraped had two different file formats, and the ones Brandon Stewart gave me had a third format. There are 3 pieces of the script to handle it in PressReviewFMScript.py. Each for loop, in general, does the following:
(1) Make a list of all of the brief names and filepaths
(2) Cycle through them, and for each file:
  (2a) Pull out the date and make it the filename for the new file (in the convention I used, eg, YYYYMMDD.txt)
  (2b) Strip out the HTML junk from the files and paste the remaining text into the new file
  (2c) Save new file in the new directory
[So, PressReviewFMScript.py should return a single folder with all of the stripped-down briefings with the dates inserted as filenames.
DEPENDENCIES: you need the three formats of briefings in separate folders, with the filepaths for each folder listed explicitly in the top of the script. You don't have the original data yet, but I'm happy to post it if necessary. The folder that this script returns is effectively our "raw data."]
"
Instead, we start with the briefs already scraped:
1) "searchAllCountryMentionsUS.py" (to make a csv of the mentions of each country in 10 word context)
2) "analyze US mentions.R" to do the analysis
  During this script, I save the R workspace at various points
  This means that if you want to reproduce a result, just load the 
  Workspace that was saved most recently and then run just the code
  To get to that result.  This saves a long time waiting for the 
  some of the loops over the sentiment dictionary to run.
  NOTE- this file can't be called using source() because of some bad comments I left in
** results of the sentiment analysis are in ~\text\results\USpositiveWords.pdf and ~\text\results\USnegativeWords.pdf 
** results to the "visit" analysis are in the script (but I don't save them anywhere)




** Material for the Appendix

Section: Tests of no effect at different levels of substantive and statistical significance
source("6_make m plots.R") ## makes the plots

*****************
** trade flows analysis
*****************

** make the data
do "trade/scripts/Master RR build trade data.do"
** then run the following IN ORDER!
** NOTE THAT THERE IS R CODE EMBEDDED WITHIN EACH SCRIPT THAT MUST ALSO BE RUN IN ORDER
trade/scripts/trade matching ICCPR.do
trade/scripts/trade matching OPT1.do
trade/scripts/trade matching CAT.do
trade/scripts/trade matching ART22.do

** Here is some additional trade flow analysis I did as well.
** make the data
do "trade/scripts/1_make ratification episode data.do"
** run some regressions
do "trade/scripts/did PTA rewards lead to trade increases.do"


*****************
** FDI flows analysis
*****************

** make the data
do "fdi/scripts/Master RR build fdi data.do"
** then run the following IN ORDER!
** NOTE THAT THERE IS R CODE EMBEDDED WITHIN EACH SCRIPT THAT MUST ALSO BE RUN IN ORDER
fdi/scripts/fdi matching ICCPR.do
fdi/scripts/fdi matching OPT1.do
fdi/scripts/fdi matching CAT.do
fdi/scripts/fdi matching ART22.do

** results will be in ~/fdi/results/fdi table.doc
