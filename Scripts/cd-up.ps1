﻿<#
.SYNOPSIS
	Sets the working directory to one level up
.DESCRIPTION
	This PowerShell script changes the working directory to one directory level up.
.EXAMPLE
	PS> .\cd-up
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz / License: CC0
#>

try {
	$Path = resolve-path ".."
	if (-not(test-path "$Path" -pathType container)) {
		throw "Folder at 📂$Path doesn't exist (yet)"
	}
	set-location "$Path"
	"📂$Path"
	exit 0 # success
} catch {
	"⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
	exit 1
}
