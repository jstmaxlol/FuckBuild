#!/usr/bin/env bash

# FuckBuild.
# i hate build systems so
# i made a C/C++ build system.

# Depends HIGHLY on gum. (part of charm.sh)

# macros / magic strings
colors="--background=#202020 --foreground=#ff5050"

# Functions / Helpers
compile() {
	local lang=$1
	local filename=$2
	local output_filename=$3
	local parameters=$4

	if [[ "$lang" =~ ^([Cc])$ ]]; then
		gcc -o "$output_filename" "$filename.c" "$parameters"
        exit 0
	elif [[ "$lang" =~ ^([Cc](\+\+|pp))$ ]]; then
		g++ -o "$output_filename" "$filename.cpp" "$parameters"
        exit 0
	else
		gum style "FuckBuild.Error: Invalid language: \"$lang\"" $colors 
        exit 1
	fi	
}

# Print """""""""logo"""""""""
gum style "FuckBuild." $colors
sleep 0.25

if [[ $# -ge 3 ]]; then
    if [[ $# -ge 4 ]]; then
        # they parsed parameters too
        lang="$1"
        filename="$2"
        output_filename="$3"
        parameters="${@:4}"

        # default
        extension="?"
        if [[ "$lang" =~ ^([Cc])$ ]]; then
            extension="c"
        elif [[ "$lang" =~ ^([Cc](\+\+|pp))$ ]]; then
            extension="cpp"
        else
            gum style "FuckBuild.Error: Invalid language: \"$lang\"" $colors 
            exit 1
        fi
        gum style "compiling a "$lang" program $filename.$extension to "$output_filename" with parameters '$parameters', right? (Y/n) " $colors
        read -s input
        if [[ $input == "n" || $input == "N"  ]]; then
            gum style "oh then you fucked up, don't blame me, duh." $colors
            exit 1
        else
            compile "$lang" "$filename" "$output_filename" "$parameters"
            exit 0
        fi
    else
        # they only parsed filename, ask for params (?)
        lang="$1"
        filename="$2"
        output_filename="$3"

        # default
        extension="?"
        if [[ "$lang" =~ ^([Cc])$ ]]; then
            extension="c"
        elif [[ "$lang" =~ ^([Cc](\+\+|pp))$ ]]; then
            extension="cpp"
        else
            gum style "FuckBuild.Error: Invalid language: \"$lang\"" $colors 
            exit 1
        fi
        gum style "compiling a "$lang" program $filename.$extension to "$output_filename", right? (Y/n) " $colors
        read -s assumption_input
        if [[ $assumption_input == "n" || $assumption_input == "N" ]]; then
            gum style "oh then you fucked up, don't blame me, duh." $colors
            exit 1
        else
            compile "$lang" "$filename" "$output_filename"
            exit 0
        fi
    fi
fi

# Menu - Ask for option, using filter for fuzzy search (we <3 fuzzy search)
menu_opt1=$(gum filter "compile" "quit" --placeholder="search for or select an option.." --prompt="::>" --fuzzy)

if [[ "$menu_opt1" == "compile" ]]; then
	lang=$(gum filter "C" "C++")
	filename=$(gum input --placeholder="filename? (w/o file extension)")
	output_filename=$(gum input --placeholder="output filename?")
	parameters=$(gum input --placeholder="compiler parameters?")
	compile "$lang" "$filename" "$output_filename" "$parameters"
elif [[ "$menu_opt1" == "quit" ]]; then
	exit 0
fi
