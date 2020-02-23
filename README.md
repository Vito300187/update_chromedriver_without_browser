File for crontab, check chromedriver version, without browser and chromedriver
If chromedriver in system older chromedriver on site https://chromedriver.chromium.org/, the chromedriver update will be performed.

File for crontab task, where can we install time and day, when script will be execute.

Example for mac os
```0 12 * * * /bin/bash -l -c 'OS=mac ruby ~/YOUR_PATH_FOLDER/update_chromedriver_without_driver_spec.rb'```

command for run script manual
```OS=mac ruby update_chromedriver_without_driver_spec.rb```  
where OS - operation system (can accept ***mac*** / ***linux*** values)
