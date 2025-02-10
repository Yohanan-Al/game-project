# O jeito "certo" de criar um ambiente de desenvolvimento seria usando Docker
# Mas, por fins de simplicidade, estamos fazendo dessa forma

mkdir ".\tmp" > $null

Write-Host "Baixando o Git Portable v2.47.1(2)..."
Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.2/PortableGit-2.47.1.2-64-bit.7z.exe" -OutFile ".\tmp\PortableGit.7z.exe"

Write-Host 'Clique "OK" na tela que aparecer.'
Start-Process ".\tmp\PortableGit.7z.exe" -Wait

Write-Host "Baixando o repositorio do projeto..."
Start-Process ".\tmp\PortableGit\cmd\git.exe" -NoNewWindow -Wait -ArgumentList "clone", "https://github.com/Yohanan-Al/game-project.git", "-b", "dev"

mkdir ".\game-project\.tools" > $null
Move-Item -Path ".\tmp\PortableGit" -Destination ".\game-project\.tools\PortableGit"
Remove-Item -Path ".\tmp" -Recurse

Start-Process "powershell" -NoNewWindow -Wait -ArgumentList "-File", ".\setup_git_portable.ps1" -WorkingDirectory ".\game-project\.scripts"
Start-Process "powershell" -NoNewWindow -ArgumentList "-File",  ".\setup_godot.ps1" -WorkingDirectory ".\game-project\.scripts"

Start-Process "explorer.exe" -ArgumentList $(Resolve-Path ".\game-project")