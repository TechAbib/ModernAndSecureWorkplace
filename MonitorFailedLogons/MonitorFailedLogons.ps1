<#
.DESCRIPTION
Monitor failed interactive logons.

.EXAMPLE


.NOTES
Author: Thomas Kurth/baseVISION
Date:   19.05.2019

History
    001: First Version

ExitCodes:
    99001: Could not Write to LogFile
    99002: Could not Write to Windows Log
    99003: Could not Set ExitMessageRegistry

#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("Install","Normal")]
    [String]
    $Mode = "Normal"
)
## Manual Variable Definition
########################################################
$DebugPreference = "Continue"
$ScriptVersion = "001"
$ScriptName = "MonitorFailedLogons"

$LogFilePathFolder     = $env:TEMP
$FallbackScriptPath    = "C:\Windows" # This is only used if the filename could not be resolved(IE running in ISE)
$InstallPath           = "$env:ProgramFiles\baseVISION_MonitoredFailedLogons"
$Icon                  = "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"
$UseWindowsToast       = $true
$ContactHelpdeskUrl    = "https://blog.basevision.ch"

# Log Configuration
$DefaultLogOutputMode  = "Console-LogFile" # "Console-LogFile","Console-WindowsEvent","LogFile-WindowsEvent","Console","LogFile","WindowsEvent","All"
$DefaultLogWindowsEventSource = $ScriptName
$DefaultLogWindowsEventLog = "CustomPS"
 
#region Functions
########################################################

function Write-Log {
    <#
    .DESCRIPTION
    Write text to a logfile with the current time.

    .PARAMETER Message
    Specifies the message to log.

    .PARAMETER Type
    Type of Message ("Info","Debug","Warn","Error").

    .PARAMETER OutputMode
    Specifies where the log should be written. Possible values are "Console","LogFile" and "Both".

    .PARAMETER Exception
    You can write an exception object to the log file if there was an exception.

    .EXAMPLE
    Write-Log -Message "Start process XY"

    .NOTES
    This function should be used to log information to console or log file.
    #>
    param(
        [Parameter(Mandatory=$true,Position=1)]
        [String]
        $Message
    ,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Info","Debug","Warn","Error")]
        [String]
        $Type = "Debug"
    ,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Console-LogFile","Console-WindowsEvent","LogFile-WindowsEvent","Console","LogFile","WindowsEvent","All")]
        [String]
        $OutputMode = $DefaultLogOutputMode
    ,
        [Parameter(Mandatory=$false)]
        [Exception]
        $Exception
    )
    
    $DateTimeString = Get-Date -Format "yyyy-MM-dd HH:mm:sszz"
    $Output = ($DateTimeString + "`t" + $Type.ToUpper() + "`t" + $Message)
    if($Exception){
        $ExceptionString =  ("[" + $Exception.GetType().FullName + "] " + $Exception.Message)
        $Output = "$Output - $ExceptionString"
    }

    if ($OutputMode -eq "Console" -OR $OutputMode -eq "Console-LogFile" -OR $OutputMode -eq "Console-WindowsEvent" -OR $OutputMode -eq "All") {
        if($Type -eq "Error"){
            Write-Error $output
        } elseif($Type -eq "Warn"){
            Write-Warning $output
        } elseif($Type -eq "Debug"){
            Write-Debug $output
        } else{
            Write-Verbose $output -Verbose
        }
    }
    
    if ($OutputMode -eq "LogFile" -OR $OutputMode -eq "Console-LogFile" -OR $OutputMode -eq "LogFile-WindowsEvent" -OR $OutputMode -eq "All") {
        try {
            Add-Content $LogFilePath -Value $Output -ErrorAction Stop
        } catch {
            exit 99001
        }
    }

    if ($OutputMode -eq "Console-WindowsEvent" -OR $OutputMode -eq "WindowsEvent" -OR $OutputMode -eq "LogFile-WindowsEvent" -OR $OutputMode -eq "All") {
        try {
            New-EventLog -LogName $DefaultLogWindowsEventLog -Source $DefaultLogWindowsEventSource -ErrorAction SilentlyContinue
            switch ($Type) {
                "Warn" {
                    $EventType = "Warning"
                    break
                }
                "Error" {
                    $EventType = "Error"
                    break
                }
                default {
                    $EventType = "Information"
                }
            }
            Write-EventLog -LogName $DefaultLogWindowsEventLog -Source $DefaultLogWindowsEventSource -EntryType $EventType -EventId 1 -Message $Output -ErrorAction Stop
        } catch {
            exit 99002
        }
    }
}

function New-Folder{
    <#
    .DESCRIPTION
    Creates a Folder if it's not existing.

    .PARAMETER Path
    Specifies the path of the new folder.

    .EXAMPLE
    CreateFolder "c:\temp"

    .NOTES
    This function creates a folder if doesn't exist.
    #>
    param(
        [Parameter(Mandatory=$True,Position=1)]
        [string]$Path
    )
	# Check if the folder Exists

	if (Test-Path $Path) {
		Write-Log "Folder: $Path Already Exists"
	} else {
		New-Item -Path $Path -type directory | Out-Null
		Write-Log "Creating $Path"
	}
}

function Set-RegValue {
    <#
    .DESCRIPTION
    Set registry value and create parent key if it is not existing.

    .PARAMETER Path
    Registry Path

    .PARAMETER Name
    Name of the Value

    .PARAMETER Value
    Value to set

    .PARAMETER Type
    Type = Binary, DWord, ExpandString, MultiString, String or QWord

    #>
    param(
        [Parameter(Mandatory=$True)]
        [string]$Path,
        [Parameter(Mandatory=$True)]
        [string]$Name,
        [Parameter(Mandatory=$True)]
        [AllowEmptyString()]
        [string]$Value,
        [Parameter(Mandatory=$True)]
        [string]$Type
    )
    
    try {
        $ErrorActionPreference = 'Stop' # convert all errors to terminating errors
        Start-Transaction

	   if (Test-Path $Path -erroraction silentlycontinue) {      
 
        } else {
            New-Item -Path $Path -Force
            Write-Log "Registry key $Path created"  
        } 
        $null = New-ItemProperty -Path $Path -Name $Name -PropertyType $Type -Value $Value -Force
        Write-Log "Registry Value $Path, $Name, $Type, $Value set"
        Complete-Transaction
    } catch {
        Undo-Transaction
        Write-Log "Registry value not set $Path, $Name, $Value, $Type" -Type Error -Exception $_.Exception
    }
}

#endregion

#region Dynamic Variables and Parameters
########################################################

# Try get actual ScriptName
try{
    $CurrentFileNameTemp = $MyInvocation.MyCommand.Name
    If($CurrentFileNameTemp -eq $null -or $CurrentFileNameTemp -eq ""){
        $CurrentFileName = "NotExecutedAsScript"
    } else {
        $CurrentFileName = $CurrentFileNameTemp
    }
} catch {
    $CurrentFileName = $LogFilePathScriptName
}
$LogFilePath = "$LogFilePathFolder\{0}_{1}_{2}.log" -f ($ScriptName -replace ".ps1", ''),$ScriptVersion,(Get-Date -uformat %Y%m%d%H%M)
# Try get actual ScriptPath
try{
    try{ 
        $ScriptPathTemp = Split-Path $MyInvocation.MyCommand.Path
    } catch {

    }
    if([String]::IsNullOrWhiteSpace($ScriptPathTemp)){
        $ScriptPathTemp = Split-Path $MyInvocation.InvocationName
    }

    If([String]::IsNullOrWhiteSpace($ScriptPathTemp)){
        $ScriptPath = $FallbackScriptPath
    } else {
        $ScriptPath = $ScriptPathTemp
    }
} catch {
    $ScriptPath = $FallbackScriptPath
}

#endregion

#region Initialization
########################################################

New-Folder $LogFilePathFolder
Write-Log "Start Script $Scriptname in mode '$Mode'"


#endregion

#region Main Script
########################################################

if($Mode -eq "Install"){
    Write-Log "Check if BurntToast is installed."
    If($null -eq (Get-Module -Name BurntToast)){
        Write-Log "Install BurntToast"
        Install-Module BurntToast -Force -Scope AllUsers
    }
    New-Folder -Path $InstallPath 
    
    Write-Log "Install CautionSymbol"
    $imageBytes = [Convert]::FromBase64String($icon)
    $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
	$ms.Write($imageBytes, 0, $imageBytes.Length);
  	$image = [System.Drawing.Image]::FromStream($ms, $true)
	$image.Save("$InstallPath\Caution.png")
    
    Write-Log "Install script"
    Copy-Item -Path $MyInvocation.MyCommand.Definition -Destination "$InstallPath\MonitorFailedLogons.ps1" -ErrorAction Stop
    
    $wshshell = New-Object -ComObject WScript.Shell
    $lnk = $wshshell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\MonitorFailedLogons.lnk")
    $lnk.Arguments = "-WindowStyle hidden -executionpolicy AllSigned -NonInteractive -NoLogo -file '$InstallPath\MonitorFailedLogons.ps1'"
    $lnk.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    $lnk.Save()
   
} else {
    try{
        $currentuser = ([adsi]"LDAP://$(whoami /fqdn)")
        $currentuser.Properties["msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon"]
    
        $FailedLoginCounter = $currentuser.Properties["msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon"]
        if($null -eq $FailedLoginCounter){
            $FailedLoginCounter = 0
        }
        if($FailedLoginCounter-gt 0){
            if($UseWindowsToast ){
                $bt = New-BTButton -Content "Contact Helpdesk" -ActivationType Protocol -Arguments $ContactHelpdeskUrl 
                New-BurntToastNotification -Text "Failed logons with $env:Username detected.","$FailedLoginCounter failed logons happened for $env:USERNAME. If you have not entered the password incorrect, then contact helpdesk." -Button $bt -AppLogo "$InstallPath\Caution.png"
            } else {
                $Result = [System.Windows.MessageBox]::Show("$FailedLoginCounter failed logons happened for $env:USERNAME. If you have not entered the password incorrect, then contact helpdesk.","Failed logons with $env:Username detected.",'YesNoCancel','Warning')
                if($Result -eq "Yes"){
                    Start-Process $ContactHelpdeskUrl
                }
            }
        }
    } catch {
        Write-Log "Failed to check" -Type Error -Exception $_.Exception
    }
}


#endregion

#region Finishing
########################################################

Write-Log "End Script $Scriptname"

#endregion