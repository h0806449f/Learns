
### repo 結構
``` bash
repo/
├── main.go        → package main
├── config/
│   └── config.go  → package config
├── aws/
│   └── aws.go     → package aws
├── go.mod

```

### 引用
#### repo 結構
```shell cpp title:repo.path
hello_go
├── go.mod
├── main.go
└── operator
    └── main.go
```

#### operator
```go cpp title:operator/main.go
package operator

func Hello() string {

return "Hello from operator"

}
```

#### hello_go
```go cpp title:hello_go/main.go
package main

import (
	"fmt"
	"hello_go/operator"
)

func main() {
	// single-line comment start with "//"
	// comments are just for documentation
	fmt.Println("hello world")
	
	fmt.Println(operator.Hello())
}
```