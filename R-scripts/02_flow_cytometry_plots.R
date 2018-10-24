### Flow cytometry data visualization
library(tidyverse)

all_particles <- read_csv("data-processed/particles.csv")
sample_key <- read_csv("data-raw/Limno-2018.csv")
plate_key <- read_csv("data-raw/limno-96-well-plate-key.csv")

plate_key2 <- plate_key %>% 
	mutate(row = str_to_upper(row)) %>% 
	mutate(column = formatC(column, width = 2, flag = 0)) %>% 
	unite(col = well, row, column, sep = "")
	


all_fcs3_all <- all_particles %>% 
	select(4:10) %>% 
	dplyr::filter(fl1_a > 0, fl3_a > 0) 


all_fcs3_all %>% 
	dplyr::filter(well == "A04") %>% 
	ggplot(aes(x = fl1_a, y = fl3_a)) + geom_point() + scale_y_log10() + scale_x_log10() +
	geom_hline(yintercept = 1250)

 sorted_all <- all_fcs3_all %>% 
	mutate(type = NA) %>% 
	mutate(type = ifelse(fl3_a > 1250, "algae", type)) 

all_sorted_all <- left_join(sorted_all, plate_key2, by = "well") 


counts <- all_sorted_all %>% 
	mutate(type = ifelse(is.na(type), "background", type)) %>% 
	group_by(well, type) %>% 
	tally() %>% 
	dplyr::filter(type == "algae")
