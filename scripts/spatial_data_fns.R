# drylands of the world ---------------------------------------------------

# https://resources.unep-wcmc.org/products/789fcac8959943ab9ed7a225e5316f08

get_drylands <- function(types = FALSE) {
  
  require(sf)
  require(dplyr)
  
  sf_use_s2(FALSE)
  
  dry_sf <- read_sf("data/Drylands_latest_July2014")
  
  if (types == FALSE) {
    dry_sf <- dry_sf %>% summarise()
  } else {
    dry_sf <- dry_sf %>% 
      select(c("HIX_NAME", "HIX_DESC"))
  }
  
  return(dry_sf)
  
}


# get Higgins et al 2016 biomes -------------------------------------------

# main biome classification of 24 types (mean over three decades considered)
# CRS = WGS 84

get_higgins <- function(df = TRUE) {
  
  require(ncdf4)
  require(terra)
  require(tibble)
  
  # downloaded from https://datadryad.org/dataset/doi:10.5061/dryad.3pm63
  higgins <- terra::rast("data/higgins_et_al_2016/veg_mean.nc")
  
  if (df == TRUE) {
    
    # biome classification key
    key <- data.frame(layer = 1:24,
                      biome = c(
                        "SLC","SMC","SHC","TLC","TMC","THC",
                        "SLD","SMD","SHD","TLD","TMD","THD",
                        "SLB","SMB","SHB","TLB","TMB","THB",
                        "SLN","SMN","SHN","TLN","TMN","THN"
                      ))
    
    higgins_df <- terra::as.data.frame(higgins, xy = TRUE) %>% 
      rownames_to_column("raster_id") %>% 
      left_join(key, by = "layer")
    
    return(higgins_df)
    
  } else {
    
    return(higgins)
    
  }
  
}
