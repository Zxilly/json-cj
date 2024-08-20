# json-cj

适用于仓颉的 JSON 宏, 从 JSON 字面量生成 `encoding.json.JsonValue` 对象。

## 用法

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

变量或表达式可以插值到 JSON 字面量中。插值到数组元素或对象值的任何类型都必须实现 `ToJson` 接口或者为基本类型。

检查 `src/test/json_test.cj` 以获取更多示例。





