macro package json_cj

import std.ast.Tokens

public import json_cj.helper.*
import json_cj.impl.jsonTransform

public macro Json(input: Tokens): Tokens {
    return jsonTransform(input)
}