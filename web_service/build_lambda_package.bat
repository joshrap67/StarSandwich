CALL npm run package
powershell -Command "Compress-Archive -Path './build/app.js' -DestinationPath './lambda_package.zip' -Force"