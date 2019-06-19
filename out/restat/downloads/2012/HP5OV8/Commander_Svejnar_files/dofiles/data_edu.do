#delimit;
clear;

insheet country_name code series y1998 y1999 y2000 y2001 y2002 y2003 y2004 y2005 y2006
using data\edu2.txt;

replace series = trim(series);

replace series = "ger_tm" if series == "Gross enrollment rate (%), tertiary, male";
replace series = "ger_pf" if series == "Gross enrollment rate (%), primary, female";
replace series = "lf_sf" if series == "Labor force with secondary education, female (% of female labor force)";
replace series = "ger_pm" if series == "Gross enrollment rate (%), primary, male";
replace series = "lf_sm" if series == "Labor force with secondary education, male (% of male labor force)";
replace series = "ger_st" if series == "Gross enrollment rate (%), secondary, total";
replace series = "lf_tt" if series == "Labor force with tertiary education (% of total)";
replace series = "lf_pt" if series == "Labor force with primary education (% of total)";
replace series = "lf_tf" if series == "Labor force with tertiary education, female (% of female labor force)";
replace series = "ger_sm" if series == "Gross enrollment rate (%), secondary, male";
replace series = "lf_pf" if series == "Labor force with primary education, female (% of female labor force)";
replace series = "lf_tm" if series == "Labor force with tertiary education, male (% of male labor force)";
replace series = "ger_tt" if series == "Gross enrollment rate (%), tertiary, total";
replace series = "lf_pm" if series == "Labor force with primary education, male (% of male labor force)";
replace series = "ger_tf" if series == "Gross enrollment rate (%), tertiary, female";
replace series = "ger_pt" if series == "Gross enrollment rate (%), primary, total";
replace series = "ger_sf" if series == "Gross enrollment rate (%), secondary, female";
replace series = "lf_st" if series == "Labor force with secondary education (% of total)";

drop code;
drop if country_name == "Countries";

reshape long y, i(country_name series);

destring y, force replace;
rename _j year;
rename y edu_;

reshape wide edu_, i(country_name year) j(series) string;

replace country_name = "Russia" if country_name == "Russian Federation";
replace country_name = "Macedonia" if country_name == "Macedonia, FYR ";
replace country_name = "Kyrgyzstan" if country_name == "Kyrgyz Republic";
replace country_name = "Slovakia" if country_name == "Slovak Republic";

sort country_name year;

sum edu_*;
sort year;
by year: sum edu_*;
sort country;
by country: sum edu_*;

save data\edu, replace;
