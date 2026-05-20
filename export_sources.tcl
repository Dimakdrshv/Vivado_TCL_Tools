# MIT License
# 
# Copyright (c) 2026 Dmitry Kudryashov 
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights 
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set ROOT_DIRECTORY [file normalize [file join [file dirname [info script]] ..]]
set FILE_SOURCE_DIRECTORY [file join $ROOT_DIRECTORY files]
set IP_SOURCE_DIRECTORY [file join $ROOT_DIRECTORY ip]

set SOURCE_DIRECTORY [file join $ROOT_DIRECTORY "build" "local_project.srcs" "sources_1" "new"]
set SIMULATION_DIRECTORY [file join $ROOT_DIRECTORY "build" "local_project.srcs" "sim_1" "new"] 
set CONSTRAINTS_DIRECTORY [file join $ROOT_DIRECTORY "build" "local_project.srcs" "constrs_1" "new"] 
set IP_DIRECTORY [file join $ROOT_DIRECTORY "build" "local_project.srcs" "sources_1" "ip"]


proc check_directory_files {} {
    global ROOT_DIRECTORY
    global SOURCE_DIRECTORY
    global SIMULATION_DIRECTORY
    global CONSTRAINTS_DIRECTORY
    global IP_DIRECTORY

    if {![file exists $SOURCE_DIRECTORY]} {
        error "Source directory does not exist: $SOURCE_DIRECTORY"
    }
    if {![file isdirectory $SOURCE_DIRECTORY]} {
        error "Source path is not a directory: $SOURCE_DIRECTORY"
    }
    if {![file exists $SIMULATION_DIRECTORY]} {
        error "Simulation directory does not exist: $SIMULATION_DIRECTORY"
    }
    if {![file isdirectory $SIMULATION_DIRECTORY]} {
        error "Simulation path is not a directory: $SIMULATION_DIRECTORY"
    }
    if {![file exists $CONSTRAINTS_DIRECTORY]} {
        error "Constraints directory does not exist: $CONSTRAINTS_DIRECTORY"
    }
    if {![file isdirectory $CONSTRAINTS_DIRECTORY]} {
        error "Constraints path is not a directory: $CONSTRAINTS_DIRECTORY"
    }
    if {![file exists $IP_DIRECTORY]} {
        error "IP directory does not exist: $IP_DIRECTORY"
    }
    if {![file isdirectory $IP_DIRECTORY]} {
        error "IP path is not a directory: $IP_DIRECTORY"
    }
}

proc export_design_source {file_name} {
    global SOURCE_DIRECTORY
    global FILE_SOURCE_DIRECTORY

    if {[file extension $file_name] ne ".v" && [file extension $file_name] ne ".sv" && [file extension $file_name] ne ".mem" && [file extension $file_name] ne ".vh"} {
        error "Invalid file extension: [file extension $file_name]. Only .v, .sv, .mem, and .vh files are supported."
        return
    }

    set source_files [glob -nocomplain -directory $SOURCE_DIRECTORY $file_name]
    set export_directory [file join $FILE_SOURCE_DIRECTORY "sources"]

    if {[llength $source_files] == 0} {
        error "No source files found matching: $file_name in $SOURCE_DIRECTORY"
        return
    }

    foreach file $source_files {
        puts "Exporting file: $file in $export_directory"
        file copy -force $file $export_directory
    }
}

proc export_simulation_source {file_name} {
    global SIMULATION_DIRECTORY
    global FILE_SOURCE_DIRECTORY

    if {[file extension $file_name] ne ".v" && [file extension $file_name] ne ".sv" && [file extension $file_name] ne ".mem" && [file extension $file_name] ne ".vh"} {
        error "Invalid file extension: [file extension $file_name]. Only .v, .sv, .mem, and .vh files are supported for simulation sources."
        return
    }

    set simulation_files [glob -nocomplain -directory $SIMULATION_DIRECTORY $file_name]
    set export_directory [file join $FILE_SOURCE_DIRECTORY "simulations"]

    if {[llength $simulation_files] == 0} {
        error "No simulation files found matching: $file_name in $SIMULATION_DIRECTORY"
        return
    }

    foreach file $simulation_files {
        puts "Exporting simulation file: $file in $export_directory"
        file copy -force $file $export_directory
    }
}

proc export_constraints_source {file_name} {
    global CONSTRAINTS_DIRECTORY
    global FILE_SOURCE_DIRECTORY

    if {[file extension $file_name] ne ".xdc"} {
        error "Invalid file extension: [file extension $file_name]. Only .xdc files are supported for constraints sources."
        return
    }

    set constraints_files [glob -nocomplain -directory $CONSTRAINTS_DIRECTORY $file_name]
    set export_directory [file join $FILE_SOURCE_DIRECTORY "constraints"]

    if {[llength $constraints_files] == 0} {
        error "No constraints files found matching: $file_name in $CONSTRAINTS_DIRECTORY"
        return
    }

    foreach file $constraints_files {
        puts "Exporting constraints file: $file in $export_directory"
        file copy -force $file $export_directory
    }
}

proc export_ip_source {file_name} {
    global IP_DIRECTORY
    global IP_SOURCE_DIRECTORY
    global FILE_SOURCE_DIRECTORY

    if {[file extension $file_name] ne ".xci"} {
        error "Invalid file extension: [file extension $file_name]. Only .xci files are supported for IP sources."
        return
    }

    set ip_directories [glob -nocomplain -directory $IP_DIRECTORY [file rootname $file_name]]

    if {[llength $ip_directories] == 0} {
        error "No IP directories found matching: [file rootname $file_name] in $IP_DIRECTORY"
        return
    }

    set export_directory $IP_SOURCE_DIRECTORY

    set ip_directory [lindex $ip_directories 0]
    set ip_file [glob -nocomplain -directory $ip_directory *.xci]

    if {[llength $ip_file] == 0} {
        error "No IP files found in directory: $ip_directory"
        return
    }

    foreach file $ip_file {
        puts "Exporting IP file: $file in $export_directory"
        file copy -force $file $export_directory
    }
}

check_directory_files

puts "Usage export_design_source - Exporting design source files from the build directory to the files/sources/ directory."
puts "Example export_design_source abc.v"
puts "Usage export_simulation_source - Exporting simulation source files from the build directory to the files/simulation/ directory."
puts "Example export_simulation_source testbench.sv"
puts "Usage export_constraints_source - Exporting constraints files from the build directory to the files/constraints/ directory."
puts "Example export_constraints_source constraints.xdc"
puts "Usage export_ip_source - Exporting IP files from the build directory to the ip/ directory."
puts "Example export_ip_source my_ip.xci"
