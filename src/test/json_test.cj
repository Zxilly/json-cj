package json_cj.test

import std.unittest.*
import std.ast.*
import std.unittest.testmacro.{Test, Assert, TestCase, Fail}
import encoding.json.*
import json_cj.Json

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
    @Assert(kindToStr(a.kind()), kindToStr(b.kind()))

    match (a.kind()) {
        case JsBool => 
            let aa = a.asBool()
            let bb = b.asBool()
            @Assert(aa.getValue(), bb.getValue())

        case JsNull => return
        case JsInt => 
            let aa = a.asInt()
            let bb = b.asInt()
            @Assert(aa.getValue(), bb.getValue())

        case JsFloat => 
            let aa = a.asFloat()
            let bb = b.asFloat()
            @Assert(aa.getValue(), bb.getValue())

        case JsString => 
            let aa = a.asString()
            let bb = b.asString()
            @Assert(aa.getValue(), bb.getValue())

        case JsArray => 
            let aa = a.asArray()
            let bb = b.asArray()
            @Assert(aa.size(), bb.size())
            for (i in 0..aa.size()) {
                assertJson(aa.get(i).getOrThrow(), bb.get(i).getOrThrow())
            }
        case JsObject => 
            let aa = a.asObject()
            let bb = b.asObject()
            @Assert(aa.size(), bb.size())

            let fields = aa.getFields()
            for ((k,v) in fields) {
                match(bb.get(k)) {
                    case Some(bv) => assertJson(v, bv)
                    case None => @Fail("Field not found: " + k)
                }
            }
    }

    return
}

@Test
class JSONTests {
    @TestCase
    func jsonEqual() {
        let ka = JsonKind.JsArray
        print(kindToStr(ka))
        let kb = JsonKind.JsBool
        print(kindToStr(kb))
    }

    @TestCase
    func basic() {
        const jsonStr = """
{
  "name": "John Doe",
  "age": 30,
  "city": "New York"
}
"""
        var jsonVal = JsonValue.fromStr(jsonStr)
        assertJson(jsonVal, jsonVal)

        var jsonLVal = @Json(
        )
        return
    }
}

// {
//   "name": "John Doe",
//   "age": 30,
//   "city": "New York"
// }

// {
//   "fruits": ["apple", "banana", "cherry"],
//   "numbers": [1, 2, 3, 4, 5],
//   "mixed": [1, "two", true, null]
// }

// {
//   "person": {
//     "name": {
//       "first": "Jane",
//       "last": "Smith"
//     },
//     "age": 28,
//     "address": {
//       "street": "123 Main St",
//       "city": "Boston",
//       "country": "USA"
//     }
//   }
// }

// {
//   "company": "Tech Corp",
//   "employees": [
//     {
//       "id": 1,
//       "name": "Alice",
//       "department": "Engineering",
//       "projects": ["Project A", "Project B"]
//     },
//     {
//       "id": 2,
//       "name": "Bob",
//       "department": "Marketing",
//       "campaigns": {
//         "online": ["Social Media", "Email"],
//         "offline": ["TV", "Radio"]
//       }
//     }
//   ],
//   "founded": 1995,
//   "active": true,
//   "CEO": null
// }

// {
//   "message": "This is a \"quoted\" string",
//   "path": "C:\\Program Files\\My App",
//   "unicode": "你好世界",
//   "special_chars": "!@#$%^&*()_+-={}[]|\\:;\"'<>,.?/~`"
// }
