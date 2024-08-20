package json_cj.helper

import std.collection.*
import encoding.json.*

public func castJsonValue<T>(v: Option<T>): JsonValue {
    match (v) {
        case Some(v) => return castJsonValue(v)
        case None => return JsonNull()
    }
}

public func castJsonValue<T>(v: Array<T>): JsonValue {
    let arr = JsonArray()
    for (i in v) {
        arr.add(castJsonValue(i))
    }
    return arr
}

public func castJsonValue<T>(v: ArrayList<T>): JsonValue {
    let arr = JsonArray()
    for (i in v) {
        arr.add(castJsonValue(i))
    }
    return arr
}

public func castJsonValue<T>(v: LinkedList<T>): JsonValue {
    let arr = JsonArray()
    for (i in v) {
        arr.add(castJsonValue(i))
    }
    return arr
}

public func castJsonValue<T>(v: Set<T>) where T <: Hashable & Equatable<T> {
    let arr = JsonArray()
    for (i in v) {
        arr.add(castJsonValue(i))
    }
    return arr
}

public func castJsonValue<T>(v: Map<String, T>): JsonValue {
    let obj = JsonObject()
    for ((k, v) in v) {
        obj.put(k, castJsonValue(v))
    }
    return obj
}

public func castJsonValue(v: Bool): JsonValue {
    return JsonBool(v)
}

public func castJsonValue(v: Int8): JsonValue {
    return JsonInt(Int64(v))
}

public func castJsonValue(v: Int16): JsonValue {
    return JsonInt(Int64(v))
}

public func castJsonValue(v: Int32): JsonValue {
    return JsonInt(Int64(v))
}

public func castJsonValue(v: Int64): JsonValue {
    return JsonInt(v)
}

public func castJsonValue(v: IntNative): JsonValue {
    return JsonInt(Int64(v))
}

public func castJsonValue(v: UInt8): JsonValue {
    return JsonInt(Int64(v))
}

public func castJsonValue(v: UInt16): JsonValue {
    return JsonInt(Int64(v))
}

public func castJsonValue(v: UInt32): JsonValue {
    return JsonInt(Int64(v))
}

public func castJsonValue(v: UInt64): JsonValue {
    return JsonInt(Int64(v))
}

public func castJsonValue(v: UIntNative): JsonValue {
    return JsonInt(Int64(v))
}

public func castJsonValue(v: Float16): JsonValue {
    return JsonFloat(Float64(v))
}

public func castJsonValue(v: Float32): JsonValue {
    return JsonFloat(Float64(v))
}

public func castJsonValue(v: Float64): JsonValue {
    return JsonFloat(v)
}

public func castJsonValue(v: String): JsonValue {
    return JsonString(v)
}

public func castJsonValue(v: ToJson): JsonValue {
    return v.toJson()
}
