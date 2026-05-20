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


namespace eval project_builder {
    proc check_local_repository {root_directory} {
        if {![file exists $root_directory]} {
            error "Error: Root directory $root_directory does not exist."
        }
        if {![file isdirectory $root_directory]} {
            error "Error: $root_directory is not a directory."
        }

        set ip_directory [file join $root_directory ip]

        if {![file exists $ip_directory]} {
            error "Error: $root_directory does not contain a 'ip' directory."
        }
        if {![file isdirectory $ip_directory]} {
            error "Error: $ip_directory is not a directory."
        }

        set files_directory [file join $root_directory files]

        if {![file exists $files_directory]} {
            error "Error: $root_directory does not contain a 'files' directory."
        }
        if {![file isdirectory $files_directory]} {
            error "Error: $files_directory is not a directory."
        }

        set required_directories {sources simulations constraints}

        foreach dir $required_directories {
            set dir_path [file join $files_directory $dir]
            if {![file exists $dir_path]} {
                error "Error: $files_directory does not contain a '$dir' directory."
            }
            if {![file isdirectory $dir_path]} {
                error "Error: $files_directory/$dir is not a directory."
            }
        }
    }

    proc create_build_directory {root_directory} {
        set build_directory [file join $root_directory build]
        if {[file exists $build_directory]} {
            file delete -force $build_directory
        }
        file mkdir $build_directory
    }

    proc create_vivado_project {build_directory project_name project_part} {
        create_project $project_name $build_directory -part $project_part
    }

    proc add_source_files {files_directory} {
        set source_directory [file join $files_directory sources]
        set source_files [glob -nocomplain -directory $source_directory *.v *.sv *.mem *.vh]
        foreach sofile $source_files {
            add_files -fileset sources_1 $sofile
        }
    }

    proc add_simulation_files {files_directory} {
        set simulation_directory [file join $files_directory simulations]
        set simulation_files [glob -nocomplain -directory $simulation_directory *.v *.sv *.mem *.vh]
        foreach sifile $simulation_files {
            add_files -fileset sim_1 $sifile
        }
    }

    proc add_constraint_files {files_directory} {
        set constraint_directory [file join $files_directory constraints]
        set constraint_files [glob -nocomplain -directory $constraint_directory *.xdc]
        foreach cofile $constraint_files {
            add_files -fileset constrs_1 $cofile
        }
    }

    proc add_ip_files {ip_directory} {
        set ip_files [glob -nocomplain -directory $ip_directory *.xci]
        foreach ip $ip_files {
            import_ip $ip
        }
        generate_target all [get_ips]
    }
}

set ROOT_DIRECTORY [file normalize [file join [file dirname [info script]] ..]]

proc build_project {{project_part xc7a100tcsg324-1}} {
    global ROOT_DIRECTORY

    set PROJECT_NAME local_project
    set PROJECT_PART $project_part
    set BUILD_DIRECTORY [file join $ROOT_DIRECTORY build]
    set FILES_DIRECTORY [file join $ROOT_DIRECTORY files]
    set IP_DIRECTORY [file join $ROOT_DIRECTORY ip]

    puts "Building project: $PROJECT_NAME in directory: $ROOT_DIRECTORY"

    project_builder::check_local_repository $ROOT_DIRECTORY
    project_builder::create_build_directory $ROOT_DIRECTORY
    project_builder::create_vivado_project $BUILD_DIRECTORY $PROJECT_NAME $PROJECT_PART
    project_builder::add_source_files $FILES_DIRECTORY
    project_builder::add_simulation_files $FILES_DIRECTORY
    project_builder::add_constraint_files $FILES_DIRECTORY
    project_builder::add_ip_files $IP_DIRECTORY

    puts "Project: $PROJECT_NAME has been successfully built in $BUILD_DIRECTORY"
}

puts "Usage: build_project <FPGA part optional, default xc7a100tcsg324-1> for build/rebuild project"
puts "Example: build_project xc7a100tcsg324-1"