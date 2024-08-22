package json_cj.testutil

import std.unittest.*
import std.unittest.testmacro.{Assert, Fail}
import encoding.json.*

public func assertJson(a: JsonValue, b: JsonValue): Unit {
    match ((a, b)) {
        case (_: JsonNull, _: JsonNull) => return
        case (a: JsonBool, b: JsonBool) => @Assert(a.getValue(), b.getValue())
        case (a: JsonInt, b: JsonInt) => @Assert(a.getValue(), b.getValue())
        case (a: JsonFloat, b: JsonFloat) => @Assert(a.getValue(), b.getValue())
        case (a: JsonString, b: JsonString) => @Assert(a.getValue(), b.getValue())
        case (a: JsonArray, b: JsonArray) =>
            @Assert(a.size(), b.size())
            for (i in 0..a.size()) {
                assertJson(a.get(i).getOrThrow(), b.get(i).getOrThrow())
            }
        case (a: JsonObject, b: JsonObject) =>
            @Assert(a.size(), b.size())
            let fields = a.getFields()
            for ((k, v) in fields) {
                match (b.get(k)) {
                    case Some(bv) => assertJson(v, bv)
                    case None => @Fail("Field not found: " + k)
                }
            }
        case _ => @Fail("Different types: " + a.toJsonString() + " vs " + b.toJsonString())
    }

    return
}
