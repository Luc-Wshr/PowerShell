﻿<#
.SYNOPSIS
	Sets the working directory to the user's music folder
.DESCRIPTION
	This script changes the working directory to the user's music folder.
.EXAMPLE
	PS> ./cd-music
	📂/home/markus/Music
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz · License: CC0
#>

$TargetDir = resolve-path "$HOME/Music"
if (-not(test-path "$TargetDir" -pathType container)) {
	write-warning "Sorry, the user's music folder at 📂$TargetDir does not exist (yet)"
	exit 1
}
set-location "$TargetDir"
"📂$TargetDir"
exit 0 # success
