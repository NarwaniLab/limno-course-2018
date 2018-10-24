
#### Reading in raw flow cytometry files (FCS files)


library(tidyverse)
library(cowplot)
library(janitor)
library(tidyverse)
library(readxl)
library(stringr)
library(flowCore)


read_fcs <- function(file) {
	fcs_file <- as.data.frame((exprs(read.FCS(file)))) %>% 
		clean_names()
	
}



fcs_files_all <- c(list.files("data-raw/",
							  full.names = TRUE, pattern = ".fcs$", recursive = TRUE))


names(fcs_files_all) <- fcs_files_all %>% 
	gsub(pattern = ".fcs$", replacement = "")

all_fcs_all <- map_df(fcs_files_all, read_fcs, .id = "file_name")

all_fcs_all$file_name[[1]]

all_fcs2_all <- all_fcs_all %>% 
	separate(file_name, into = c("file_path", "day_well"), sep = c("-students-"), remove = FALSE) %>% 
	separate(day_well, into = c("day", "well"), sep = "/", remove = FALSE) %>%
	mutate(day = str_replace(day, "day-", ""))

write_csv(all_fcs2_all, "data-processed/particles.csv")
