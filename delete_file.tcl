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

proc delete_source_file {file_name} {
    global FILES_DIRECTORY
    
    set SOURCE_DIRECTORY [file join $FILES_DIRECTORY sources]
    set FILE_EXTENSION [file extension $file_name]
    
    if {$FILE_EXTENSION eq ".v"} {
        set FILE_PATH [file join $SOURCE_DIRECTORY $file_name]
    } elseif {$FILE_EXTENSION eq ".sv"} {
        set FILE_PATH [file join $SOURCE_DIRECTORY $file_name]
    } elseif {$FILE_EXTENSION eq ".mem"} {
        set FILE_PATH [file join $SOURCE_DIRECTORY $file_name]
    } else {
        error "Unsupported file extension: $FILE_EXTENSION. Only .v, .sv, and .mem are supported."
    }
    
    if {![file exists $FILE_PATH]} {
        error "Error: File $FILE_PATH does not exist."
    } else {
        remove_files $FILE_PATH
        file delete -force $FILE_PATH
        update_compile_order -fileset sources_1
        puts "Source file deleted: $FILE_PATH"
    }
}

proc delete_simulation_file {file_name} {
    global FILES_DIRECTORY
    
    set SIMULATION_DIRECTORY [file join $FILES_DIRECTORY simulations]
    set FILE_EXTENSION [file extension $file_name]
    
    if {$FILE_EXTENSION eq ".v"} {
        set FILE_PATH [file join $SIMULATION_DIRECTORY $file_name]
    } elseif {$FILE_EXTENSION eq ".sv"} {
        set FILE_PATH [file join $SIMULATION_DIRECTORY $file_name]
    } elseif {$FILE_EXTENSION eq ".mem"} {
        set FILE_PATH [file join $SIMULATION_DIRECTORY $file_name]
    } else {
        error "Unsupported file extension: $FILE_EXTENSION. Only .v, .sv, and .mem are supported for simulation files."
    }
    
    if {![file exists $FILE_PATH]} {
        error "Error: File $FILE_PATH does not exist."
    } else {
        remove_files $FILE_PATH
        file delete -force $FILE_PATH
        update_compile_order -fileset sim_1
        puts "Simulation file deleted: $FILE_PATH"
    }
}

proc delete_constraint_file {file_name} {
    global FILES_DIRECTORY
    
    set CONSTRAINT_DIRECTORY [file join $FILES_DIRECTORY constraints]
    set FILE_EXTENSION [file extension $file_name]
    
    if {$FILE_EXTENSION eq ".xdc"} {
        set FILE_PATH [file join $CONSTRAINT_DIRECTORY $file_name]
    } else {
        error "Unsupported file extension: $FILE_EXTENSION. Only .xdc is supported for constraint files."
    }
    
    if {![file exists $FILE_PATH]} {
        error "Error: File $FILE_PATH does not exist."
    } else {
        remove_files $FILE_PATH
        file delete -force $FILE_PATH
        puts "Constraint file deleted: $FILE_PATH"
    }
}

puts "Usage: delete_source_file <file_name> to delete a source file from the 'files/sources' directory."
puts "Example: delete_source_file my_module.v"
puts "Usage: delete_simulation_file <file_name> to delete a simulation file from the 'files/simulations' directory."
puts "Example: delete_simulation_file my_testbench.sv"
puts "Usage: delete_constraint_file <file_name> to delete a constraint file from the 'files/constraints' directory."
puts "Example: delete_constraint_file my_constraints.xdc"