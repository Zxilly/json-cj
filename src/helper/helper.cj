package json_cj.helper

import std.collection.*
import encoding.json.*

public interface ToJsonValue {
    func toJsonValue(): JsonValue
}

extend Bool <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonBool(this)
    }
}

extend Int8 <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonInt(Int64(this))
    }
}

extend Int16 <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonInt(Int64(this))
    }
}

extend Int32 <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonInt(Int64(this))
    }
}

extend Int64 <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonInt(this)
    }
}

extend IntNative <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonInt(Int64(this))
    }
}

extend UInt8 <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonInt(Int64(this))
    }
}

extend UInt16 <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonInt(Int64(this))
    }
}

extend UInt32 <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonInt(Int64(this))
    }
}

extend UInt64 <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonInt(Int64(this))
    }
}

extend UIntNative <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonInt(Int64(this))
    }
}

extend Float16 <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonFloat(Float64(this))
    }
}

extend Float32 <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonFloat(Float64(this))
    }
}

extend Float64 <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonFloat(this)
    }
}

extend String <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        return JsonString(this)
    }
}

extend<T> Array<T> <: ToJsonValue where T <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        let arr = JsonArray()
        for (i in this) {
            arr.add(i.toJsonValue())
        }
        return arr
    }
}

extend<T> ArrayList<T> <: ToJsonValue where T <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        let arr = JsonArray()
        for (i in this) {
            arr.add(i.toJsonValue())
        }
        return arr
    }
}

extend<T> LinkedList<T> <: ToJsonValue where T <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        let arr = JsonArray()
        for (i in this) {
            arr.add(i.toJsonValue())
        }
        return arr
    }
}

extend<K> Option<K> <: ToJsonValue where K <: ToJsonValue {
    public func toJsonValue(): JsonValue {
        match (this) {
            case Some(v) => return v.toJsonValue()
            case None => return JsonNull()
        }
    }
}

public func castJsonValue(t: ToJsonValue): JsonValue {
    return t.toJsonValue()
}

public func castJsonValue(t: JsonValue): JsonValue {
    return t
}

public func castJsonValue(t: ToJson): JsonValue {
    return t.toJson()
}

public func castJsonValue<K, V>(t: Map<K, V>): JsonObject where K <: ToString & Equatable<K>, V <: ToJsonValue {
    let obj = JsonObject()
    for ((k, v) in t) {
        obj.put(k.toString(), v.toJsonValue())
    }
    return obj
}