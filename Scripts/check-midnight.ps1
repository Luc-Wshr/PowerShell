﻿<#
.SYNOPSIS
	Checks for Midnight
.DESCRIPTION
	This PowerShell script checks the time until Midnight and replies by text-to-speech (TTS).
.EXAMPLE
	PS> ./check-midnight
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

function TimeSpanToString { param([TimeSpan]$Delta)
	$Result = ""
	if ($Delta.Hours -eq 1) {       $Result += "1 hour and "
	} elseif ($Delta.Hours -gt 1) { $Result += "$($Delta.Hours) hours and "
	}
	if ($Delta.Minutes -eq 1) { $Result += "1 minute"
	} else {                    $Result += "$($Delta.Minutes) minutes"
	}
	return $Result
}

try {
	$Now = [DateTime]::Now
	if ($Now.Hour -lt 12) {
		$Midnight = Get-Date -Hour 0 -Minute 0 -Second 0
		$TimeSpan = TimeSpanToString($Now - $Midnight)
		$Reply = "Midnight was $TimeSpan ago."
	} else {
		$Midnight = Get-Date -Hour 23 -Minute 59 -Second 59
		$TimeSpan = TimeSpanToString($Midnight - $Now)
		$Reply = "Midnight is in $TimeSpan."
	}
	& "$PSScriptRoot/give-reply.ps1" "$Reply"
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
