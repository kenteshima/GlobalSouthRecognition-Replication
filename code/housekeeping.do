/*******************************************************************************
* Housekeeping File: Path Settings for Global South Recognition Survey
* 
* Project: Global South Perception Survey - Replication Package
* Last Updated: November 2025
* 
* Purpose: Set up directory paths for the replication package
*******************************************************************************/

* Detect current user
local user = c(username)
display "Current user: `user'"

* Set base directory path
* IMPORTANT: Users should modify this path to match their local setup
if "`user'" == "kente" {
    global basedir "C:\Users\kente\Documents\GitHub\GlobalSouthRecognition-Replication"
}
else {
    * Default path for other users
    * Please set your own path here
    display "=============================================="
    display "WARNING: Please set your basedir path"
    display "Edit housekeeping.do to set your local path"
    display "=============================================="
    global basedir "."
}

* Define subdirectory paths (with trailing slashes)
global raw       "$basedir/data/raw/"
global created   "$basedir/data/created/"
global tables    "$basedir/output/tables/"
global figures   "$basedir/output/figures/"
global code      "$basedir/code/"

* Display paths for verification
display "=============================================="
display "Directory paths set:"
display "Base directory: $basedir"
display "Raw data:       $raw"
display "Created data:   $created"
display "Tables output:  $tables"
display "Figures output: $figures"
display "Code directory: $code"
display "=============================================="
