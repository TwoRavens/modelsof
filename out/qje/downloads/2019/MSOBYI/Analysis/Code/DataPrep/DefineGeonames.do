quietly {
			** Define geonames for the areatype
			if "`areatype'" == "Z" {
				local geoname = "zip_code"
				local geodatatype = "long"
			}
			else if "`areatype'" == "Z3" {
				local geoname = "zip3"
				local geodatatype = "long"
			}
			else if "`areatype'" == "Ct" {
				local geoname = "state_countyFIPS"
				local geodatatype = "long"
			}
			else if "`areatype'" == "CZ" {
				local geoname = "cz"
				local geodatatype = "long"
			}
			else if "`areatype'" == "C9" {
				local geoname = "cz1990"
				local geodatatype = "long"
			}
			else if "`areatype'" == "St" {
				local geoname = "fips_state_code"
				local geodatatype = "byte"
			}
}
