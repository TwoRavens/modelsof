/* 
The programs and data files replicate the descriptive statistics and the estimation results in the paper

	Hornok, Cec’lia and Mikl—s Koren, forthcoming. ÒPer-Shipment Costs and the Lumpiness of International Trade.Ó Review of Economics and Statistics.

Please cite the above paper when using these programs.

For your convenience, we reproduce some of the data resources here. Although all of these are widely available macroeconomic data, please check with the data vendors whether you have the right to use them.

Our software and data are provided AS IS, and we assume no liability for their use or misuse. 

If you have any questions about replication, please contact Mikl—s Koren at korenm@ceu.hu.
*/

*** Creates Table 1 in paper and correlation statistics for the Doing Business indicators.


* Doing Business indicators
use data/worldbank/doingbusiness/trading_across_borders_2009, clear
codebook country
drop country year *_export

* correlations
foreach X in document customs port inland total {
	corr `X'_time_import `X'_cost_import
}

************************************************************
* Table 1: Time and monetary costs of four import procedures
************************************************************
* Time cost
tabstat document_time_import customs_time_import port_time_import inland_time_import total_time_import, statistics(mean cv) columns(statistics)
* Monetary cost
tabstat document_cost_import customs_cost_import port_cost_import inland_cost_import total_cost_import, statistics(mean cv) columns(statistics)

