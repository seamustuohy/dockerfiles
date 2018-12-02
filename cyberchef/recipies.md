## Extract Microsoft SafeLinks
```
Extract_URLs(false)
Regular_expression('User defined','https://na..\\.safelinks.protection\\.outlook\\.com.*url=(.*)&data.*\\n',true,true,false,false,false,false,'List capture groups')
URL_Decode()
```
