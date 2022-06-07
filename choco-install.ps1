Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install googlechrome -y
choco install firefox -y
choco install 7zip -y
choco install notepadplusplus -y
choco install git -y
choco install putty -y
choco install nodejs -y
choco install postman -y
choco install conemu -y
choco install vscode -y
choco install gitextensions
