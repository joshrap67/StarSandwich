CALL npm start
mkdir .\results
xcopy /s .\dist .\results /y
xcopy .\node_modules .\results\node_modules\ /e /y
cd results
7z.exe a lambda_package.zip .
MOVE /Y .\lambda_package.zip ..
cd ..
rmdir .\results /s /q