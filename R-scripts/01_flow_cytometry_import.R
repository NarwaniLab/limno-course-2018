
#### Reading in raw flow cytometry files (FCS files)


library(tidyverse)
library(cowplot)
library(janitor)
library(tidyverse)
library(readxl)
library(stringr)
library(flowCore)


### function to read and clean up the FCS files
read_fcs <- function(file) {
	fcs_file <- as.data.frame((exprs(read.FCS(file)))) %>% 
		clean_names()
	
}

### make a list of all the FCS files we have
fcs_files_all <- c(list.files("data-raw/flow-cytometry/",
							  full.names = TRUE, pattern = ".fcs$", recursive = TRUE))


names(fcs_files_all) <- fcs_files_all %>% 
	gsub(pattern = ".fcs$", replacement = "")


### use the map_df function to read in all the files
all_fcs_all <- map_df(fcs_files_all, read_fcs, .id = "file_name")

all_fcs_all$file_name[[1]]

### parse the column names a bit to make them work for us
all_fcs2_all <- all_fcs_all %>% 
	separate(file_name, into = c("file_path", "day_well"), sep = c("-students-"), remove = FALSE) %>% 
	separate(day_well, into = c("day", "well"), sep = "/", remove = FALSE) %>%
	mutate(day = str_replace(day, "day-", ""))

day0_1 <- all_fcs2_all %>% 
	dplyr::filter(day %in% c(0,1))

write_csv(day0_1, "data-processed/particles_day_0_1.csv")

day2_7 <- all_fcs2_all %>% 
	dplyr::filter(day %in% c(2,7))

write_csv(day2_7, "data-processed/particles_day_2_7.csv")
### write out the processed data
# write_csv(all_fcs2_all, "data-processed/particles.csv")
