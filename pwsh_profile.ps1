# Prints pwsh session start time
Write-Host (Get-Date -Format "dd MMMM yyyy HH:mm dddd") -ForegroundColor Green

function ipy{
	ipython
}

# My own customized prompt
function prompt {
    $actual_current_path = (Get-Location).ToString()
    $actual_current_path = $actual_current_path.Replace("\", "/")
    
    $directoryList = $actual_current_path -split "/"
    $lastDirectory = $directoryList[-1]
    $current_path = $lastDirectory

    $shortened = $false

    $i = $directoryList.Length - 2
    while ($i -gt -1 -and $current_path.Length -lt 18) {
      $shortened = $true
      if($i -eq 0){
        $shortened = $false;
      }
      $current_path = $directoryList[$i] + "/" + $current_path
      $i -= 1
    }
    if($shortened){
      $current_path = "~/" + $current_path
    }

    $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
      else { '' }) + '' + $current_path +
        $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
}

# Check whether being run as admin, if yes, return true
Function Test-Elevated {
  $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
  $adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
  $prp.IsInRole($adm)
}

# This should always stay at the bottom, as it is an execution
# Definitions might not created if in mid way if due to an unexpected failure
# Scripts will not be executed, if pwsh is being run as admin
If (!(Test-Elevated)) {
    # Run some script
    # Run something
    # Example
    python -B "D:\Scripts\some_script.py"
}