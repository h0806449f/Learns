
1. repo 與 package
	1. go 以 repo 為單位
	2. 同一個資料夾內, 只能有一個 package
	3. 同一個 repo 內, 則可以有多個 package
```shell
repo/
├── main.go        → package main
├── config/
│   └── config.go  → package config
├── aws/
│   └── aws.go     → package aws
├── go.mod
```



2. go.mod
	1. 宣告 module
	2. 宣告 go 版本
``` go
module hello-go
go 1.22
```
 