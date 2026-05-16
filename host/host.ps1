function prompt {
    $time_color = "$([char]27)[0;38;5;27m"
    $user_host_color = "$([char]27)[0;38;5;39m"
    $directory_color = "$([char]27)[0;38;5;50m"
    $white_color = "$([char]27)[0m"
    $git_color = "$([char]27)[0;38;5;156m"
    $architecture_color = "$([char]27)[0;38;5;134m"
    
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

    $sign_color = "$([char]27)[0;38;5;57m"
    $emoji = "🦊"

    $time_part = Get-Date -Format "HH:mm:ss"
    $user = $env:USERNAME
    $host_name = $env:COMPUTERNAME
    $cwd = $ExecutionContext.SessionState.Path.CurrentLocation
    
    $arch_part = "windows-$env:PROCESSOR_ARCHITECTURE".ToLower()

    $git_branch = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $branch = git branch --show-current 2>$null
        if ($branch) {
            $git_branch = " $branch"
        }
    }

    Write-Host "$time_color$time_part " -NoNewline
    Write-Host "$user_host_color$user$sign_color@$user_host_color$host_name " -NoNewline
    Write-Host "$architecture_color$arch_part " -NoNewline
    Write-Host "$directory_color$cwd" -NoNewline
    Write-Host "$git_color$git_branch"

    return "$sign_color($emoji)$white_color "
}
