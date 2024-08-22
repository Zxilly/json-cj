package json_cj.test

import std.unittest.*
import std.ast.*
import std.unittest.testmacro.{Test, Assert, TestCase, Fail}
import encoding.json.*
import json_cj.*
import json_cj.testutil.assertJson

@Test
class JSONTests {
    @TestCase
    func jsonEqual() {
        const jsonStr = """
                        {
                          "name": "John Doe",
                          "age": 30,
                          "city": "New York"
                        }
                        """

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

        assertJson(@Json( a + b ), JsonInt(3))
        assertJson(@Json( 1.0 + 2.0 ), JsonFloat(3.0))
        assertJson(@Json( c + d ), JsonString("Hello, world!"))
        assertJson(@Json( e ), JsonBool(true))
        assertJson(@Json( f ), JsonBool(false))
        assertJson(@Json( h ), JsonNull())
    }

    @TestCase
    func array() {
        assertJson(@Json( [1, 2, 3] ), JsonArray([JsonInt(1), JsonInt(2), JsonInt(3)]))
        assertJson(@Json( ["apple", "banana", "cherry"] ),
            JsonArray([JsonString("apple"), JsonString("banana"), JsonString("cherry")]))
        assertJson(
            @Json( [1, "two", true, null ] ),
            JsonArray([JsonInt(1), JsonString("two"), JsonBool(true), JsonNull()])
        )
    }

    @TestCase
    func object() {
        const jsonStr = """
                        {
                          "name": "John Doe",
                          "age": 30,
                          "city": "New York"
                        }
                        """
        let jsonVal = JsonValue.fromStr(jsonStr)
        let jsonMVal = @Json(
            {
                "name": "John Doe",
                "age": 30,
                "city": "New York"
            }
        )
        assertJson(jsonVal, jsonMVal)

        const jsonStr2 = """
                        {
                          "fruits": ["apple", "banana", "cherry"],
                          "numbers": [1, 2, 3, 4, 5],
                          "mixed": [1, "two", true, null]
                        }
                        """
        let jsonVal2 = JsonValue.fromStr(jsonStr2)
        let jsonMVal2 = @Json(
            {
                "fruits": ["apple", "banana", "cherry"],
                "numbers": [1, 2, 3, 4, 5],
                "mixed": [1, "two", true, null]
            }
        )
        assertJson(jsonVal2, jsonMVal2)

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
        let jsonVal3 = JsonValue.fromStr(jsonStr3)
        let jsonMVal3 = @Json(
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
        )
        assertJson(jsonVal3, jsonMVal3)

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
        let jsonVal4 = JsonValue.fromStr(jsonStr4)
        let jsonMVal4 = @Json(
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
        )
        assertJson(jsonVal4, jsonMVal4)
    }

    @TestCase
    func empty() {
        assertJson(@Json( {} ), JsonObject())
        assertJson(@Json( [] ), JsonArray())

        @Assert((), @Json())
    }

    @TestCase
    func trailingComma() {
        assertJson(@Json( [1, 2, 3,] ), JsonArray([JsonInt(1), JsonInt(2), JsonInt(3)]))
        assertJson(@Json( {"a": 1, "b": 2, "c": 3,} ), @Json( {"a": 1, "b": 2, "c": 3} ))
    }
}
