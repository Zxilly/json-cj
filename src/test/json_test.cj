package json_cj.test

import std.unittest.*
import std.ast.*
import std.unittest.testmacro.{Test, Assert, TestCase, Fail}
import encoding.json.*
import json_cj.*

func kindToStr(k: JsonKind) {
    match (k) {
        case JsBool => "bool"
        case JsNull => "null"
        case JsInt => "int"
        case JsFloat => "float"
        case JsString => "string"
        case JsArray => "array"
        case JsObject => "object"
    }
}

func assertJson(a: JsonValue, b: JsonValue): Unit {
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

const jsonStr = """
{
  "name": "John Doe",
  "age": 30,
  "city": "New York"
}
"""
const jsonStr2 = """
{
  "fruits": ["apple", "banana", "cherry"],
  "numbers": [1, 2, 3, 4, 5],
  "mixed": [1, "two", true, null]
}
"""
const jsonStr3 = """
{
  "person": {
    "name": {
      "first": "Jane",
      "last": "Smith"
    },
    "age": 28,
    "address": {
      "street": "123 Main St",
      "city": "Boston",
      "country": "USA"
    }
  }
}
"""
const jsonStr4 = """
{
  "company": "Tech Corp",
  "employees": [
    {
      "id": 1,
      "name": "Alice",
      "department": "Engineering",
      "projects": ["Project A", "Project B"]
    },
    {
      "id": 2,
      "name": "Bob",
      "department": "Marketing",
      "campaigns": {
        "online": ["Social Media", "Email"],
        "offline": ["TV", "Radio"]
      }
    }
  ],
  "founded": 1995,
  "active": true,
  "CEO": null
}
"""
const jsonStr5 = #"""
{
  "message": "This is a \"quoted\" string",
  "path": "C:\\Program Files\\My App",
  "unicode": "你好世界",
  "special_chars": "!@#$%^&*()_+-={}[]|\\:;\"'<>,.?/~`"
}
"""#

@Test
class JSONTests {
    @TestCase
    func jsonEqual() {
        var jsonVal = JsonValue.fromStr(jsonStr)
        var jsonVal2 = JsonValue.fromStr(jsonStr)

        assertJson(jsonVal, jsonVal2)
    }

    @TestCase
    func basic() {
        assertJson(@Json( 1 + 2 ), JsonInt(3))
        assertJson(@Json( 1.0 + 2.0 ), JsonFloat(3.0))
        assertJson(@Json( "Hello, " + "world!" ), JsonString("Hello, world!"))
        assertJson(@Json( true ), JsonBool(true))
        assertJson(@Json( false ), JsonBool(false))
        assertJson(@Json( null ), JsonNull())
        assertJson(@Json( None ), JsonNull())
    }

    @TestCase
    func variable() {
        var a = 1
        var b = 2
        var c = "Hello, "
        var d = "world!"
        var e = true
        var f = false
        var h = None<Int>

        var ll = @Json( h )

        assertJson(@Json( a + b ), JsonInt(3))
        assertJson(@Json( 1.0 + 2.0 ), JsonFloat(3.0))
        assertJson(@Json( c + d ), JsonString("Hello, world!"))
        assertJson(@Json( e ), JsonBool(true))
        assertJson(@Json( f ), JsonBool(false))
        assertJson(@Json( h ), JsonNull())
    }
}
