

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROYJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	**
	**		DETAILS: 	This code prepares Figure A.8.1: Royal
	**					Treasuries in the New Spain
	**					
	**					This code runs in R, and uses the Stata'
	** 					package 'rsource,' available through SSC.
	**
	**				
	**		Version: 	Stata MP 12.1; R 3.3.2 (2016-10-31)
	**
	******************************************************************
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Call R from Stata
*-------------------------------------------------------------------------------

local directory $dir
local datadir $data
local figuresdir $figures
rsource, terminator(END_OF_R) 												///
roptions(`" --vanilla --args "`directory'" "`datadir'" "`figuresdir'" "') 	///
	rpath($Rterm_path)


#------------------------------------------------------------------------------;
# Prepare data;
#------------------------------------------------------------------------------;

rm(list = ls());
pkgs <- c("dplyr", "data.table", "sf", "maps", "tidyverse", "ggthemes");
#suppressMessages(sapply(pkgs, install.packages));
suppressMessages(sapply(pkgs, require, character.only = TRUE));

top_dir = commandArgs(trailingOnly=TRUE);
setwd(top_dir[1]);
.env <- new.env();
.env$data_dir <- paste0(top_dir, top_dir[2]);
.env$figs_dir <- paste0(top_dir, top_dir[3]);
attach(.env);


#------------------------------------------------------------------------------;
# Prepare shapefiles;
#------------------------------------------------------------------------------;


setwd(data_dir);

# Mexico map;
load("mex_shp.RData");

# Caja locations;
cajas <- data.table(read.csv("Cajas_geo.csv"));
cajas[Caja == "PresidioDelCarmen", Caja := "Carmen"];
cajas_shp <- st_as_sf(cajas, coords = c("long","lat"), crs=4326);
p4s <- "+proj=longlat +datum=WGS84 +no_defs";
st_crs(cajas_shp) <- p4s;


#------------------------------------------------------------------------------;
# Figure A.8.1: Royal Treasuries in the New Spain
#------------------------------------------------------------------------------;

setwd(figs_dir);
pdf(file = "FigureA8_1.pdf");
ggplot() + 
  geom_sf(data=mex_shp, fill="gray90", colour="gray90") + 
  geom_sf(data=cajas_shp, size=1/1000000, colour = "gray70") +
  geom_text(aes(label = cajas_shp$Caja, x = cajas$lon, y = cajas$lat), 
            size=2.45, hjust=-.2, vjust=.5) +
  xlab("") + ylab("") +
  theme_map();
dev.off();


# End of R script;
#----------------;

END_OF_R


		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		



