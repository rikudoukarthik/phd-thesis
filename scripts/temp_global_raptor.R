library(tidyverse)
library(sf)

# load Flavia's raptor presence absence data
rapt <- as.matrix(readRDS("comm_raptors.rds"))

# convert to dataframe
rapt_rich <- data.frame(sites = rownames(rapt), 
                        rich = rowSums(rapt)) %>%
  tidyr::separate(sites, c("x", "y"), sep = "_")

rapt <- as.data.frame(rapt) %>% 
  rownames_to_column("sites") %>%
  tidyr::separate(sites, c("x", "y"), sep = "_") %>% 
  # convert to presence-absence
  mutate(across(c(everything(), -x, -y), ~ case_when(. >= 1 ~ 1,
                                                     . < 1 ~ 0)))

# spatialise richness

rapt_rich_sf <- rapt_rich %>% 
  st_as_sf(coords = c("x", "y"), crs = "+proj=eck4 +lon_0=0 +datum=WGS84 +units=m +no_defs") %>% 
  st_transform(crs = 4326)
st_crs(rapt_rich_sf)

ggplot(rapt_rich_sf %>% 
         filter(rich > 1)) +
  geom_sf(aes(col = rich))


# all birds ###

birds <- as.matrix(readRDS("bird_sp_distribution_eck4_all_Matrix.rds"))

birds[birds < 1] = 0
birds[birds >= 1] = 1
birds = birds[rowSums(birds) > 0, ] # remove empty cells
birds= birds[, colSums(birds) > 0] # remove empty species
birds = birds[rowSums(birds) > 0, ] # remove empty cells

birds_rich <- data.frame(sites = rownames(birds), 
                         rich = rowSums(birds)) %>%
  tidyr::separate(sites, c("x", "y"), sep = "_")
