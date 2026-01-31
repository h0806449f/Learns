 
 用於變更 terraform 資源名稱

``` bash
moved {
  from = dynatrace_iam_user.henry_lee
  to   = dynatrace_iam_user.henry_lee_hytechc_com
}
```
效果
1. 假設資源內容都沒有改變, 則 move block 會有以下效果
	1. 變更 terraform state file
	2. 不會呼叫 API
	3. 使用 move block 時, 不會有 create / update / destroy 

```css
┌──────────────┐
│  真實世界     │  Dynatrace / AWS / GCP
│  (Provider)  │
└──────────────┘
        ▲
        │ API
        ▼
┌──────────────┐
│ Terraform    │
│   State      │  terraform.tfstate
└──────────────┘
        ▲
        │ 對照
        ▼
┌──────────────┐
│  HCL Code    │  .tf
└──────────────┘
```

