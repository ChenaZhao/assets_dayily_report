@echo off
setlocal

cd /d "%~dp0..\.."

git config user.email "zhaoxiben@gmail.com"
git config user.name "ChenaZhao"

git add asset\macro\

git diff --cached --quiet
if %errorlevel% == 0 (
    echo [No new files to commit]
    goto :push
)

for /f %%d in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set TODAY=%%d
git commit -m "update macro reports %TODAY%"

:push
echo [Pushing...]
git push -u origin main
if %errorlevel% == 0 (
    echo.
    echo Done! https://chenazhao.github.io/assets_daily_report/asset/
) else (
    if exist "README.md" rename "README.md" "README.md.bak"
    git fetch origin main
    git rebase origin/main
    if exist "README.md.bak" rename "README.md.bak" "README.md"
    git push -u origin main
    if %errorlevel% == 0 (
        echo Done! https://chenazhao.github.io/assets_daily_report/asset/
    ) else (
        echo [FAILED] run: git push origin main --force
    )
)

echo.
pause
