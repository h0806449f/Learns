
```go cpp title:main.go 
package main

import "fmt"

func main() {
	// single-line comment start with "//"
	// comments are just for documentation
	fmt.Println("hello world")
}
```

1. 每個資料夾使用相同 package
2. func main () 作為 code 邏輯入口
3. 執行: go run main.go

### 在 Go 裡
1. 每個 `.go` 檔案 **一定要**屬於某個 package
2. 同一個資料夾裡的 `.go` 檔案，**package 名稱必須一樣**

 ### `package main` 是什麼意思？
1. `main` 是一個**特殊的 package**
2. `package main` + `func main()`  
	1. 表示：**這是一個可以直接執行的程式**
    
3. 如果不是 `package main`，那就是**函式庫（library）**
```go cpp title:main.go
package main

func main() {
   // 程式從這裡開始跑 
}
```

4. 可以理解為
	1. `package main`：我是一個「可執行程式」
	2. 其他 package：我是一個「被別人用的工具箱」

### 為什麼 Go 要有 package
1. 組織程式碼（避免全部塞在一起）
2. 避免命名衝突
3. 控制「誰能用我的東西」
	1. **大寫開頭** → 外部可用（exported）
	2. **小寫開頭** → 只有同 package 能用