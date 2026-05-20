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
set FILES_DIRECTORY [file join $ROOT_DIRECTORY files]

proc initial_source_sim_file_setup {file_path} {
    if {[file extension $file_path] eq ".v" || [file extension $file_path] eq ".sv"} {
        set FP [open $file_path "w"]
        puts $FP "`timescale 1ps / 1ps"
        puts $FP ""
        puts $FP "//==========================================================="
        puts $FP "// File Path: $file_path"
        puts $FP "// Author: "
        puts $FP "// Created On: [clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}]"
        puts $FP "// Description: "
        puts $FP "//==========================================================="
        puts $FP ""
        puts $FP ""
        puts $FP "module [file rootname [file tail $file_path]] ("
        puts $FP ""
        puts $FP ");"
        puts $FP ""
        puts $FP "endmodule"
        close $FP
    }
}

proc initial_constraint_file_setup {file_path} {
    set FP [open $file_path "w"]
    puts $FP "#==========================================================="
    puts $FP "# File Path: $file_path"
    puts $FP "# Author: "
    puts $FP "# Created On: [clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}]"
    puts $FP "# Description: "
    puts $FP "#==========================================================="
    close $FP
}


proc new_source_file {file_name} {
    global FILES_DIRECTORY
    
    set SOURCE_DIRECTORY [file join $FILES_DIRECTORY sources]
    set FILE_EXTENSION [file extension $file_name]
    
    if {$FILE_EXTENSION eq ".v"} {
        set FILE_PATH [file join $SOURCE_DIRECTORY $file_name]
    } elseif {$FILE_EXTENSION eq ".sv"} {
        set FILE_PATH [file join $SOURCE_DIRECTORY $file_name]
    } elseif {$FILE_EXTENSION eq ".mem"} {
        set FILE_PATH [file join $SOURCE_DIRECTORY $file_name]
    } elseif {$FILE_EXTENSION eq ".vh"} {
        set FILE_PATH [file join $SOURCE_DIRECTORY $file_name]
    } else {
        error "Unsupported file extension: $FILE_EXTENSION. Only .v, .sv, .mem and .vh are supported."
    }
    
    if {[file exists $FILE_PATH]} {
        error "Error: File $FILE_PATH already exists."
    } else {
        close [open $FILE_PATH "w"]
        add_files -fileset sources_1 $FILE_PATH
        initial_source_sim_file_setup $FILE_PATH
        update_compile_order -fileset sources_1
        puts "New source file created: $FILE_PATH"
    }
}

proc new_simulation_file {file_name} {
    global FILES_DIRECTORY
    
    set SIMULATION_DIRECTORY [file join $FILES_DIRECTORY simulations]
    set FILE_EXTENSION [file extension $file_name]
    
    if {$FILE_EXTENSION eq ".v"} {
        set FILE_PATH [file join $SIMULATION_DIRECTORY $file_name]
    } elseif {$FILE_EXTENSION eq ".sv"} {
        set FILE_PATH [file join $SIMULATION_DIRECTORY $file_name]
    } elseif {$FILE_EXTENSION eq ".mem"} {
        set FILE_PATH [file join $SIMULATION_DIRECTORY $file_name]
    } elseif {$FILE_EXTENSION eq ".vh"} {
        set FILE_PATH [file join $SOURCE_DIRECTORY $file_name]
    } else {
        error "Unsupported file extension: $FILE_EXTENSION. Only .v, .sv, .mem and .vh are supported for simulation files."
    }
    
    if {[file exists $FILE_PATH]} {
        error "Error: File $FILE_PATH already exists."
    } else {
        close [open $FILE_PATH "w"]
        initial_source_sim_file_setup $FILE_PATH
        add_files -fileset sim_1 $FILE_PATH
        update_compile_order -fileset sim_1
        puts "New simulation file created: $FILE_PATH"
    }
}

proc new_constraint_file {file_name} {
    global FILES_DIRECTORY
    
    set CONSTRAINT_DIRECTORY [file join $FILES_DIRECTORY constraints]
    set FILE_EXTENSION [file extension $file_name]
    
    if {$FILE_EXTENSION eq ".xdc"} {
        set FILE_PATH [file join $CONSTRAINT_DIRECTORY $file_name]
    } else {
        error "Unsupported file extension: $FILE_EXTENSION. Only .xdc is supported for constraint files."
    }
    
    if {[file exists $FILE_PATH]} {
        error "Error: File $FILE_PATH already exists."
    } else {
        close [open $FILE_PATH "w"]
        add_files -fileset constrs_1 $FILE_PATH
        initial_constraint_file_setup $FILE_PATH
        puts "New constraint file created: $FILE_PATH"
    }
}

puts "Usage: new_source_file <file_name> to create a new source file in the 'files/sources' directory."
puts "Example: new_source_file my_module.v"
puts "Usage: new_simulation_file <file_name> to create a new simulation file in the 'files/simulations' directory."
puts "Example: new_simulation_file my_testbench.sv"
puts "Usage: new_constraint_file <file_name> to create a new constraint file in the 'files/constraints' directory."
puts "Example: new_constraint_file my_constraints.xdc"