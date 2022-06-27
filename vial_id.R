###
# Create columns for treatments and vial identifier
# Code: acclimation temp_vial number

# input: 
## Treatments: vector of temperature treatments, forced to numeric
## Sample size: number of vials per treatment with animals (not including blank)
## Volume of vial (in ml)

# Requires equal number of recordings per vial (sample_fq)
# Returns original data with temperature treatment, vial number, unique identifier and volume corrected O2
###

vial_id <- function(x, treatments, sample_size, volume){
  # Function adds information about experiment
  
  # Calculate number of expected observations per vial
  sample_fq <- nrow(x) / (sample_size + 1) / length(treatments)
  
  # Turn readings with warning messages NA but do not remove
  x$Oxygen <- ifelse(is.na(x$Warning) == FALSE, NA, x$Oxygen)
  
  # Add volume of vial in L
  x$Volume <- volume / 1000
  
  # Add number of acclimation treatments
  x$Treatment <- sort(as.numeric(rep(treatments, sample_fq * (sample_size + 1))))
  
  # Add vial number
  x$Vial <- rep(c("Blank", seq(1, length.out = sample_size)), length(treatments) * sample_fq)
  
  # Create unique identifier for each vial
  x$Vial_Code <- paste0("temp",
                        x$Treatment,
                        "_vial", 
                        x$Vial)
  
  # Split based on unique identifier
  x <- split(x, x$Vial_Code)
  
  x <- lapply(x, function(i){
    # Create Observation number (vial-specific Data_Point)
    i$Observation_no <- 1:nrow(i)
    return(i)
  })
  # Return as data frame
  x <- do.call(rbind, x)
  return(x)
  }