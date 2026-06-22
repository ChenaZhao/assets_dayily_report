@echo off
setlocal

cd /d "%~dp0..\.."

git config user.email "zhaoxiben@gmail.com"
git config user.name "ChenaZhao"

if not exist ".git" (
    git init
    git remote add origin https://github.com/ChenaZhao/assets_dayily_report.git
    git branch -M main
)

git add reports\html\

git diff --cached --quiet
if %errorlevel% == 0 (
    echo [No new files to commit]
    goto :push
)

for /f %%d in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set TODAY=%%d
git commit -m "update reports %TODAY%"

:push
echo [Pushing to GitHub...]
git push -u origin main 2>&1

if %errorlevel% neq 0 (
    echo.
    echo [Pull then push...]
    git pull origin main --rebase --allow-unrelated-histories 2>&1
    git push -u origin main 2>&1
)

if %errorlevel% == 0 (
    echo.
    echo Done!
    echo https://chenazhao.github.io/assets_dayily_report/reports/html/
) else (
    echo.
    echo [FAILED] Run manually: git push origin main --force
)

echo.
pause
