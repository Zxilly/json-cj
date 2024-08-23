# json-cj

[![Tests](https://github.com/Zxilly/json-cj/actions/workflows/test.yml/badge.svg)](https://github.com/Zxilly/json-cj/actions/workflows/test.yml)
[![codecov](https://codecov.io/github/Zxilly/json-cj/graph/badge.svg?token=2T786HYAYL)](https://codecov.io/github/Zxilly/json-cj)
![Static Badge](https://img.shields.io/badge/%E4%BB%93%E9%A2%89-green)


适用于仓颉的 JSON 宏, 从 JSON 字面量生成 `encoding.json.JsonValue` 对象。

## 用法


## 直接生成 JSON 对象 

```cangjie
import json_cj.*;
import encoding.json.*;

let j = @Json(
        {
            "code": 200,
            "success": true,
            "payload": {
                "features": [
                    "cangjie",
                    "json"
                ],
                "homepage": null
            }
        }
    )
```

## 变量插值

变量或表达式可以插值到 JSON 字面量中。插值到数组元素或对象值的任何类型都必须实现 `ToJson` / `ToJsonValue` 接口或者为基本类型。

因为仓颉不支持空指针，所以任何基本类型的 Option 类型中的 None 会被转换为 JsonNull，还可以通过字面量 `null` 或者 `ToJson` 接口生成 `null` 值。

```cangjie
import json_cj.*;
import encoding.json.*;

let code = 200
let success = true
let homepage = None<String>

let payload = ["cangjie", "json"]

let j = @Json(
        {
            "code": code,
            "success": success,
            "homepage": homepage,
            "payload": payload
        }
    )
```

> [!NOTE]
> 检查 `src/test/json_test.cj` 以获取更多示例。





