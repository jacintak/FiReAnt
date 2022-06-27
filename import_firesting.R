###
# FireSting loading data
###

import_firesting <- function(){
  # Ask the user for the folder address
  folder_address <- ifelse(interactive() == TRUE,
                           readline("Enter relative folder address to working directory without quotation marks: "),
                           params$folder)
  folder_address <- paste(getwd(), folder_address, sep = "/")
  
  # Get file names
  add.files <- list.files(folder_address, pattern=".txt", recursive = FALSE, full.names = TRUE)
  
  # Check the user has entered address properly
  if(identical(add.files, character(0))){ 
    message(paste("Address",  folder_address, "has no files. Please try again.")) 
    return(import_firesting()) # Return to the beginning of the function and start again
  }
  
  # Import file
  get.files <- lapply(add.files, read.delim, skip = 15, na = c("", "NA"))
  
  # Remove empty column
  get.files <- lapply(get.files, function(x) x[names(x) != "X"])
  
  # Set column names - remove all characters after first period
  get.files <- lapply(get.files, function(x) setNames(x, gsub("\\..*","", names(x))))
  
  # Add ID code from file name
  get.files <- mapply(get.files, FUN = function(x, file){
    x$File_Name <- sub(".* ", "", file) # remove full name
    x$File_Name <- sub(".txt", "", x$File_Name) # remove file type
    return(x)}, file = add.files, SIMPLIFY = FALSE)
  
  # Split date and time column
  get.files <- lapply(get.files, function(x){
    x$Date_Time <- as.POSIXct(x$Date_Time, format = "%Y-%m-%d %H:%M:%S")
    x$Date <- format(x$Date_Time)
    x$Comp_Time <- format(x$Date_Time, "%H:%M:%S")
    return(x)
  })  
  
  # Remove no sensor rows
  get.files <- lapply(get.files, function(i) i[apply(i,1,function(x) !any(x %in% "no sensor")),])
  
  # Ensure numeric formatting
  get.files <- lapply(get.files, function(x){
    x$Temperature <- as.numeric(x$Temperature)
    x$Compensation_Temperature <- as.numeric(x$Compensation_Temperature)
    suppressWarnings(x$Oxygen <- as.numeric(x$Oxygen))
    return(x)
  })
  
  # Create list names
  add.files <- sub(".* ", "", add.files) # remove full name
  add.files <- sub(".txt", "", add.files) # remove file type
  names(get.files) <- add.files
  
  return(get.files)
  }

# Return as list
firesting <- import_firesting()
