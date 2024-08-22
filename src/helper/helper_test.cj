package json_cj.helper

import std.unittest.testmacro.{Test, Assert, TestCase}
import std.unittest.*
import std.collection.*
import encoding.json.*
import serialization.serialization.*
import json_cj.testutil.assertJson

@Test
class HelperTests {
    @TestCase
    func basic() {
        let a: Bool = true
        let i8: Int8 = 1
        let i16: Int16 = 1
        let i32: Int32 = 1
        let i64: Int64 = 1
        let ina: IntNative = 1
        let u8: UInt8 = 1
        let u16: UInt16 = 1
        let u32: UInt32 = 1
        let u64: UInt64 = 1
        let una: UIntNative = 1 
        let f16: Float16 = 1.0
        let f32: Float32 = 1.0
        let f64: Float64 = 1.0
        let s: String = "hello"

        assertJson(a.toJsonValue(), JsonBool(true))
        assertJson(i8.toJsonValue(), JsonInt(1))
        assertJson(i16.toJsonValue(), JsonInt(1))
        assertJson(i32.toJsonValue(), JsonInt(1))
        assertJson(i64.toJsonValue(), JsonInt(1))
        assertJson(ina.toJsonValue(), JsonInt(1))
        assertJson(u8.toJsonValue(), JsonInt(1))
        assertJson(u16.toJsonValue(), JsonInt(1))
        assertJson(u32.toJsonValue(), JsonInt(1))
        assertJson(u64.toJsonValue(), JsonInt(1))
        assertJson(una.toJsonValue(), JsonInt(1))
        assertJson(f16.toJsonValue(), JsonFloat(1.0))
        assertJson(f32.toJsonValue(), JsonFloat(1.0))
        assertJson(f64.toJsonValue(), JsonFloat(1.0))

        assertJson(castJsonValue(a), JsonBool(true))
        assertJson(castJsonValue(i8), JsonInt(1))
        assertJson(castJsonValue(i16), JsonInt(1))
        assertJson(castJsonValue(i32), JsonInt(1))
        assertJson(castJsonValue(i64), JsonInt(1))
        assertJson(castJsonValue(ina), JsonInt(1))
        assertJson(castJsonValue(u8), JsonInt(1))
        assertJson(castJsonValue(u16), JsonInt(1))
        assertJson(castJsonValue(u32), JsonInt(1))
        assertJson(castJsonValue(u64), JsonInt(1))
        assertJson(castJsonValue(una), JsonInt(1))
        assertJson(castJsonValue(f16), JsonFloat(1.0))
        assertJson(castJsonValue(f32), JsonFloat(1.0))
        assertJson(castJsonValue(f64), JsonFloat(1.0))
        assertJson(castJsonValue(s), JsonString("hello"))
        
    }

    @TestCase
    func tojson() {
        let t = DataModelInt(233)
        assertJson(castJsonValue(t), JsonInt(233))
    }

    @TestCase
    func list() {
        let a = [1, 2, 3]
        let b = ArrayList([1, 2, 3])
        let c = LinkedList([1, 2, 3])

        let target = JsonArray([JsonInt(1), JsonInt(2), JsonInt(3)])

        assertJson(castJsonValue(a), target)
        assertJson(castJsonValue(b), target)
        assertJson(castJsonValue(c), target)
    }

    @TestCase
    func map() {
        let a = TreeMap([("a", 1), ("b", 2), ("c", 3)])
        let target = JsonObject()
        target.put("a", JsonInt(1))
        target.put("b", JsonInt(2))
        target.put("c", JsonInt(3))

        assertJson(castJsonValue(a), target)
    }

    @TestCase
    func option() {
        let a: Option<Int> = Some(1)
        let b: Option<Int> = None

        assertJson(castJsonValue(a), JsonInt(1))
        assertJson(castJsonValue(b), JsonNull())
    }
}