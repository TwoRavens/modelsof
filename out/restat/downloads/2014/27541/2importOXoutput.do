*** Outline ***
*** Fujin Zhou and Remco Oostendorp
*** Vrije Universiteit Amsterdam
*** March 2013


*** this program imports the output produced by OX codes (MIMICbyMLE2-nod1.ox):output2.csv
*** and then merged with dataMongolia.dta
*** and save the data as "3underreport.dta"
*** "3underreport.dta" will be used to produce Table 1/2/4/5 in the paper

  clear all
  global path D:\Dropbox\FIRSTPAPERDRAFTSANDPROGRAMS\CleanFiles4SubmissionUpload
  capture log close
  log using $path\LOGS\logimportOXoutput.log,replace
  insheet using "$path\Data\output2.csv", comma
  drop v1
  rename var1 id
  rename var2 y_p
  rename var3 underrp_m
  rename var4 y_star1b

  label var id "firm identity code"
  label var y_p "conditional prediction of true sales based on indcators and explantory variables"
  label var underrp_m "underreporting by comparing y_p and sales reported to tax office"
  label var y_star1b "predicted sales based on analytical solutions"

  sort id
  save $path\Data\output2.dta,replace


*** merge the MIMIC output with the original data ***
  clear all
  use "$path\Data\dataMongolia.dta",clear
  sort id
  merge 1:1 id using "$path\Data\output2.dta"
  tab _merge
  drop _merge
*** save the data as 3underreport.dta
  save "$path\Data\3underreport.dta",replace

  log close

