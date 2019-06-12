/* Run this to prepare data, create tables and figures */

  /* the datasets are somewhat large. setting the memory to 50mb */
cap noi set mem 50m

run getcses.do
run analysis.do
run table.do
run figures.do
