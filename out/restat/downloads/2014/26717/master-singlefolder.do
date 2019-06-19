* DoFILE: master-singlefolder.do

/* -----------------------------------------------------------------------
* requires installation of following packages (if not already installed)

* "synth" (by A. Abadie, A. Diamond and J. Hainmueller)
  ssc install synth, replace all

* "matwrite" (by A. Shepard)
  ssc install matwrite, replace all

* "estout" (by B. Jann)
  ssc install estout, replace all
* -----------------------------------------------------------------------*/

clear all

do   descriptives-REPLIC.do
do  mydisasters-3-REPLIC.do

do abadie_analysis-P99-REPLIC.do
do abadie_analysis-P90-REPLIC.do
do abadie_analysis-P75-REPLIC.do

do abadieGraphs-REPLIC.do
do abadieGraphs-noRev-REPLIC.do
do abadieGraphs-NICA-REPLIC.do
do abadieGraphs-IRAN-REPLIC.do

do reshape_P99-REPLIC.do
do reshape_P90-REPLIC.do
do reshape_P75-REPLIC.do
do reshape_P99-NoRev-REPLIC.do
do reshape_P99-NICA-REPLIC.do
do reshape_P99-IRAN-REPLIC.do

do matwrite_P99-REPLIC.do
do matwrite_P90-REPLIC.do
do matwrite_P75-REPLIC.do
do matwrite_P99-NoRev-REPLIC.do 
do matwrite_P99-NICA-REPLIC.do
do matwrite_P99-IRAN-REPLIC.do

clear all