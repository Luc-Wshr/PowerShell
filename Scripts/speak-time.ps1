#!/snap/bin/powershell
<#
.SYNTAX         ./speak-time.ps1
.DESCRIPTION	speaks the current time by text-to-speech (TTS)
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
#>

function Speak([string]$Text) {
	write-progress "$Text"
	$Voice = new-object -ComObject SAPI.SPVoice
	[void]$Voice.Speak($Text)
	write-progress -complete "$Text"
}

try {
	Speak("It's now $((Get-Date).ToShortTimeString())")
	exit 0
} catch {
	write-error "ERROR in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
