* Stata replication code for Neil Malhotra, Benoit Monin, and Michael Tomz,
* "Does Private Regulation Preempt Public Regulation,"
* American Political Science Review
* Version: September 8, 2018
version 15.1

* Rename and Unzip replication archive
if "`c(os)'" == "Windows" {
   shell ren MMT-APSR-Files MMT-APSR-Files.zip
}
else {
   shell mv MMT-APSR-Files MMT-APSR-Files.zip
}
unzipfile MMT-APSR-Files.zip

* Audubon Affiliates
cd 2013-10-25-Audubon/programs
do 2013-10-25-Audubon.do

* Petition Signatories
cd ../../2014-02-02-Petition/programs
do 2014-02-02-Petition.do

* Mass Public
cd ../../2014-03-31-Public/programs
do 2014-03-31-Public.do

* Government Sample 1
cd ../../2015-08-13-Government/programs
do 2015-08-13-Government.do

* Government Sample 2
cd ../../2016-10-04-Government/programs
do 2016-10-04-Government.do

* Solomon Design: Neonics
cd ../../2018-03-27-SolomonN/programs
do 2018-03-27-SolomonN.do

* Solomon Design: Tuna
cd ../../2018-03-22-SolomonT/programs
do 2018-03-22-SolomonT.do

* Note: Figure 9 needs to be run in R
