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