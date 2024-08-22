package json_cj.testutil

import std.unittest.*
import std.unittest.testmacro.{Assert, Fail, Test, TestCase}
import encoding.json.*

@Test
class TestJsonTestUtils {
    @TestCase
    func bool() {
        let a: JsonValue = JsonBool(true)
        let b: JsonValue = JsonBool(true)
        assertJson(a, b)
    }

    @TestCase
    func int() {
        let a: JsonValue = JsonInt(1)
        let b: JsonValue = JsonInt(1)
        assertJson(a, b)
    }

    @TestCase
    func float() {
        let a: JsonValue = JsonFloat(1.0)
        let b: JsonValue = JsonFloat(1.0)
        assertJson(a, b)
    }

    @TestCase
    func string() {
        let a: JsonValue = JsonString("hello")
        let b: JsonValue = JsonString("hello")
        assertJson(a, b)
    }

    @TestCase
    func array() {
        let a: JsonValue = JsonArray([JsonInt(1), JsonInt(2), JsonInt(3)])
        let b: JsonValue = JsonArray([JsonInt(1), JsonInt(2), JsonInt(3)])
        assertJson(a, b)
    }

    @TestCase
    func object() {
        let a = JsonObject()
        a.put("a", JsonInt(1))
        a.put("b", JsonInt(2))
        a.put("c", JsonInt(3))
        
        let b = JsonObject()
        b.put("a", JsonInt(1))
        b.put("b", JsonInt(2))
        b.put("c", JsonInt(3))
        assertJson(a, b)
    }
}