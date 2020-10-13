#!/bin/bash

################################################################################
#                                                                              #
# AUTHOR: Kevin Southwick                                                      #
# VERSION: 20200925                                                            #
# DESCRIPTION: Small, dirty script which makes printing information provided   #
#              by jq easier. Meant to be used as a function in .bashrc         #
# SCRIPT FLOW:                                                                 #
#              0-Check if dependencies are installed                           #
#              1-Pretty print the log                                          #
# EXIT CODES:                                                                  #
#              0- Successful run                                               #
#              1- Dependeicies not met                                         #
#              2- No log found in clipboard                                    #
#                                                                              #
################################################################################

main () {

    dependencyCheck () {

        #prerequistes and assignments
        dpkg -l jq &> /dev/null #dev/null is there to keep from printing command output
        jq_check=$?
        dpkg -l xsel &> /dev/null
        xsel_check=$?

        #check for dependencies
        if [[ $jq_check -ne 0 || $xsel_check -ne 0 ]]; then
            echo "Please install the jq and xsel packages"
            echo
            echo "sudo apt install jq xsel"
            echo
            echo "Exit Code 1"
            return 1
        fi

    }

    prettyPrintLog () {

        #prerequistes and assignments
        raw_log=$(xsel | sed 1q)
        raw_log_first_char=${raw_log:0:1}

        #sanitization check
        if [[ $raw_log_first_char != "{" ]]; then
            echo "Please make sure you have a log in your clipboard."
            echo
            echo "Exit Code 2"
            return 2
        else
            clear; echo $raw_log | jq . #brain of the script
        fi

    }

    dependencyCheck
    prettyPrintLog
}

main
return 0
