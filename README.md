# FiReAnt
Helper functions for handling multiple containers measured by a FireSting Go

## Set up

One FireSting Go unit measuring oxygen consentration in multiple vials sequentially (including a blank control). Each row in the resulting txt file is a different vial. Scripts assume an equal number of records per vial. 

## Functions

 1. `import_firesting` - A function to import all data files from a FireSting Go (.txt). File names are unchanged from the default format and require a unique identifier for each file (e.g. the default LOG00X)
 2. `vial_id`  - A function to add variables for each vial, including a unique identifier for each vial, vial volume & observation number
 
 $\dot{V}_{O_2}$ not included.
