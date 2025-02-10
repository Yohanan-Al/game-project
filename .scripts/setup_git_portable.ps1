cd ..

$git_path = ".\.tools\PortableGit"

if (-not (Test-Path $git_path)) {
    mkdir ".\tmp" > $null
    
    Write-Host "Baixando o Git Portable v2.47.1(2) para a pasta $(Resolve-Path $git_path)..."
    Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.2/PortableGit-2.47.1.2-64-bit.7z.exe" -OutFile ".\tmp\PortableGit.7z.exe"
    
    Write-Host 'Clique "OK" na tela que aparecer.'
    Start-Process ".\tmp\PortableGit.7z.exe" -Wait
    
    Move-Item -Path ".\tmp\PortableGit" -Destination $git_path
    Remove-Item -Path ".\tmp" -Recurse
}

$git_cmd_path = Resolve-Path "$git_path\cmd"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$git_cmd_path*") {
    $newPath = $currentPath + ";" + $git_cmd_path
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
}

Start-Process "$git_cmd_path\git.exe" -NoNewWindow -Wait -ArgumentList "config", "user.name", (Read-Host "Seu nome no GitHub")
Start-Process "$git_cmd_path\git.exe" -NoNewWindow -Wait -ArgumentList "config", "user.email", (Read-Host "Seu email no GitHub")