args fileloc subgroup
#delimit;

** Note: "args" defines values called from other do-files. The first argument is the file path to call, defined at the beginning of each do-file in the local "fileloc". The second specifies the data set from which to draw (all, or by subgroup);

clear;

** Call data file for use – all or by subgroup;
**use `fileloc'/data/KMS_hazard_collapsed`subgroup'.dta, clear;
use `fileloc'/data/KMS_hazard_collapsed`subgroup'.dta, clear;

** Remove auto trauma victims;
sum died if died == 1 & auto == 1 [fw = weight];
drop if auto_trauma == 1;

** Generate year variable the represents not year of birth, but year of observation or "event";
gen event_year = year(dofw(merging_week));

** Building spline of age variable - knots match those used in Currie & Neidell 2005 (see text). Variable "weeks alive" refers NOT to the total lifespan of the infant (that is "lifespan"), but to the number of weeks the infant lived as of the current week of observation;
mkspline weeksold1 1 weeksold2 2 weeksold4 4 weeksold8 8 weeksold12 12 weeksold20 20 weeksold32 32 weeksoldtop = weeks_alive;

** Creating globals to simplify the regression code;

** Controls;
global controls = "male black asian other_race hisp HS_grad college_grad twins trip_or_more age19_25 age26_30 age31_35 age36up medicaid care_first_tri low_weight premature second_born third_born fourth_or_more";

** Age spline;
global agespline = "weeksold1 weeksold2 weeksold4 weeksold8 weeksold12 weeksold20 weeksold32 weeksoldtop";

** Cubic weather effects;
global weather_linear = "max_temp windspeed humidS rain days_with_rain days_with_fog";
global weather_quadratic = "max_tempsq windspeedsq humidSsq rainsq";
global weather_cubic = "max_tempcu windspeedcu humidScu raincu";
global weather1 = "$weather_linear $weather_quadratic";
global weather2 = "$weather_cubic";

** Trimester exposure;
global triweekly_co = "tri1weekly_co tri2weekly_co tri3weekly_co";
global triweekly_pm10 = "tri1weekly_pm10 tri2weekly_pm10 tri3weekly_pm10";
global triweekly_oz = "tri1weekly_oz tri2weekly_oz tri3weekly_oz";

** Generate traffic variable for main analysis – weighted by distance, with a cutoff at 15 miles as per semi-parametric results;
format flow_by_length* %16.9g;

gen tot_flow_base = flow_by_length_weight_5 + flow_by_length_weight_10 + flow_by_length_weight_15;
sum tot_flow_base;

