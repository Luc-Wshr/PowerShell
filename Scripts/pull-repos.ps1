﻿<#
.SYNOPSIS
	Pulls updates for Git repositories
.DESCRIPTION
	This PowerShell script pulls updates for all Git repositories in a folder (including submodules).
.PARAMETER ParentDir
	Specifies the path to the parent folder
.EXAMPLE
	PS> ./pull-repos C:\MyRepos
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

param([string]$ParentDir = "$PWD")

try {
	$StopWatch = [system.diagnostics.stopwatch]::startNew()

	"⏳ Step 1 - Searching for Git executable..."
	& git --version
	if ($lastExitCode -ne "0") { throw "Can't execute 'git' - make sure Git is installed and available" }

	$ParentDirName = (Get-Item "$ParentDir").Name
	"⏳ Step 2 - Checking folder 📂$ParentDirName..."
	if (-not(Test-Path "$ParentDir" -pathType container)) { throw "Can't access folder: $ParentDir" }
	$Folders = (Get-ChildItem "$ParentDir" -attributes Directory)
	$NumFolders = $Folders.Count
	"Found $NumFolders subfolders, pulling one by one..."

	[int]$Step = 3
	[int]$Failed = 0
	foreach ($Folder in $Folders) {
		$FolderName = (Get-Item "$Folder").Name
		"⏳ Step $Step/$($NumFolders + 2) - Pulling into 📂$FolderName... "

		& git -C "$Folder" pull --recurse-submodules --jobs=4
		if ($lastExitCode -ne "0") { $Failed++; write-warning "'git pull' in 📂$FolderName failed" }

		& git -C "$Folder" submodule update --init --recursive
		if ($lastExitCode -ne "0") { throw "'git submodule update' in 📂$FolderName failed" }

		$Step++
	}

	[int]$Elapsed = $StopWatch.Elapsed.TotalSeconds
	"✔️ pulled $NumFolders Git repos in 📂$ParentDirName ($Failed failed, it took $Elapsed sec)"
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}