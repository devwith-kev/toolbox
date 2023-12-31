param(
    [Parameter(Position = 0)]
    [array]$Arguments
)

."$Env:TOOLBOX_HOME\scripts\core\proxy-module.ps1"

$proxy = Get-CompanyProxyConfig

if (!$proxy) {
    Write-Host "Local proxy has not been activated by your organization."
    return
}

$validArguments = @("on", "off", "status")

if (!$Arguments) {
    Write-Host "A valid argument must be provided. Only '$($validArguments -join (', '))' can be used.`n" -ForegroundColor Yellow
    Write-Help
    return
}

$selectionMode = Get-FirtArgument $Arguments
    
if ($selectionMode -notin $validArguments) {
    Write-Host "A valid argument must be provided. Only '$($validArguments -join (', '))' can be used.`n" -ForegroundColor Yellow
    Write-Help
    return
}

$address = [System.Net.WebProxy]::GetDefaultProxy().Address

if (!$address) {
    Write-Host "No proxy has been detected in your organization."
    return
}

if ($selectionMode -ceq "on") {
    Start-Proxy
    return
}

if ($selectionMode -ceq "off") {
    Stop-Proxy
    return
}

if ($selectionMode -ceq "status") {
    $proxyProcessesCount = Get-ProxyProcesses
    if (!$proxyProcessesCount) {
        Write-Host "Your local proxy is not running."
    }
    else {
        Write-Host "Your local proxy is running using $proxyProcessesCount instances."
    }
}
