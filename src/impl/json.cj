package json_cj.impl

import std.ast.*
import std.collection.ArrayList
import json_cj.helper.*

enum JsonState {
    | Initial
    | ObjectStart
    | ObjectKey
    | ObjectColon
    | ObjectValue
    | ObjectComma
    | ArrayStart
    | ArrayValue
    | ArrayComma
    | PartEnd
    | End
}

func safeParseExprFragment(t: Tokens, start: Int64): Option<(Expr, Int64)> {
    try {
        let (expr, next) = parseExprFragment(t, startFrom: start)
        return Some((expr, next))
    } catch (e: ParseASTException) {
        return None
    }
}

func wrap(tt: Tokens): Tokens {
    return quote({=> $(tt) }())
}

func getIdent(s: String): Token {
    return Token(TokenKind.IDENTIFIER, s)
}

func parseValue(t: Tokens, start: Int64): (Tokens, Int64) {
    let tf = t[start]
    match (tf.kind) {
        case TokenKind.LCURL => return parseObject(t, start + 1)
        case TokenKind.LSQUARE => return parseArray(t, start + 1)
        case TokenKind.IDENTIFIER where (tf.value == "null" || tf.value == "None") => return (quote(JsonNull()), start +
                1)
        case _ => if (let Some((expr, next)) <- safeParseExprFragment(t, start)) {
            let exprTokens = expr.toTokens()
            if (exprTokens.size > 1) {
                return (quote(castJsonValue($(expr))), next)
            }
            let first = exprTokens[0]
            match (first.kind) {
                case TokenKind.STRING_LITERAL => return (quote(JsonString($(first))), next)
                case TokenKind.INTEGER_LITERAL => return (quote(JsonInt($(first))), next)
                case TokenKind.FLOAT_LITERAL => return (quote(JsonFloat($(first))), next)
                case TokenKind.BOOL_LITERAL => return (quote(JsonBool($(first))), next)
                case _ => return (quote(castJsonValue($(expr))), next)
            }
        } else {
            diagReport(DiagReportLevel.ERROR, t, "Unexpected token ${tf.value} in parseValue", "Unexpected token")
            throw Exception("Unexpected token ${tf.value} in parseValue")
        }
    }
}

func parseObject(t: Tokens, start: Int64): (Tokens, Int64) {
    let ident = getIdent("jsonCjObject")
    let tokens = quote(
        let $(ident) = JsonObject();
    )
    var i = start
    var state = JsonState.ObjectStart
    while (i < t.size) {
        let cur = t[i]
        match (cur.kind) {
            case TokenKind.RCURL => match (state) {
                case JsonState.ObjectStart => return (quote(JsonObject()), i + 1)
                case JsonState.ObjectValue | JsonState.ObjectComma =>
                    tokens.append(quote(
                            return $(ident);
                        ))
                    return (wrap(tokens), i + 1)
                case _ =>
                    diagReport(DiagReportLevel.ERROR, t, "Unexpected state for RCURL in parseObject", "Unexpected state"
                    )
                    throw Exception("Unexpected state for RCURL in parseObject")
            }
            case TokenKind.COMMA => match (state) {
                case JsonState.ObjectValue =>
                    i++
                    state = JsonState.ObjectComma
                    continue
                case _ =>
                    diagReport(DiagReportLevel.ERROR, t, "Unexpected state for COMMA in parseObject", "Unexpected state"
                    )
                    throw Exception("Unexpected state for COMMA in parseObject")
            }
            case TokenKind.STRING_LITERAL => match (state) {
                case JsonState.ObjectStart | JsonState.ObjectComma =>
                    let key = cur.value
                    i++
                    if (t[i].kind != TokenKind.COLON) {
                        diagReport(DiagReportLevel.ERROR, t, "No colon in object", "No colon")
                        throw Exception("No colon in object")
                    }
                    i++
                    let (value, next) = parseValue(t, i)
                    i = next
                    state = JsonState.ObjectValue
                    tokens.append(quote(
                        $(ident).put($(key), $(value));
                    ))
                    continue
                case _ =>
                    diagReport(DiagReportLevel.ERROR, t, "Unexpected state for STRING_LITERAL in parseObject",
                        "Unexpected state")
                    throw Exception("Unexpected state for STRING_LITERAL in parseObject")
            }
            case _ =>
                diagReport(DiagReportLevel.ERROR, t, "Unexpected token ${cur.value} in parseObject", "Unexpected token")
                throw Exception("Unexpected token ${cur.value} in parseObject")
        }
    }

    diagReport(DiagReportLevel.ERROR, t, "No closing curly bracket", "No closing curly bracket")
    throw Exception("No closing curly bracket")
}

func parseArray(t: Tokens, start: Int64): (Tokens, Int64) {
    let ident = getIdent("jsonCjArray")
    let tokens = quote(
        let $(ident) = JsonArray();
    )
    var i = start
    var state = JsonState.ArrayStart

    while (i < t.size) {
        let cur = t[i]
        match (cur.kind) {
            case TokenKind.RSQUARE => match (state) {
                case JsonState.ArrayStart => return (quote(JsonArray()), i + 1)
                case JsonState.ArrayValue | JsonState.ArrayComma =>
                    tokens.append(quote(
                            return $(ident);
                        ))
                    return (wrap(tokens), i + 1)
                case _ =>
                    diagReport(DiagReportLevel.ERROR, t, "Unexpected state for RSQUARE in parseArray",
                        "Unexpected state")
                    throw Exception("Unexpected state for RSQUARE in parseArray")
            }
            case TokenKind.COMMA => match (state) {
                case JsonState.ArrayValue =>
                    i++
                    state = JsonState.ArrayComma
                    continue
                case _ =>
                    diagReport(DiagReportLevel.ERROR, t, "Unexpected state for COMMA in parseArray", "Unexpected state")
                    throw Exception("Unexpected state for COMMA in parseArray")
            }
            case _ => match (state) {
                case JsonState.ArrayStart | JsonState.ArrayComma =>
                    let (value, next) = parseValue(t, i)
                    i = next
                    state = JsonState.ArrayValue
                    tokens.append(quote(
                        $(ident).add($(value));
                    ))
                    continue
                case _ =>
                    diagReport(DiagReportLevel.ERROR, t, "Unexpected token ${cur.value} in parseArray",
                        "Unexpected token")
                    throw Exception("Unexpected token ${cur.value} in parseArray")
            }
        }
    }

    diagReport(DiagReportLevel.ERROR, t, "No closing bracket", "No closing bracket")
    throw Exception("No closing bracket")
}

protected func jsonTransform(input: Tokens): Tokens {
    let t = Tokens()

    for (ti in input) {
        if (let TokenKind.NL <- ti.kind) {
            continue
        }
        t.append(ti)
    }

    let ret = Tokens()

    if (t.size == 0) {
        return quote(())
    }

    let cur = t[0]
    let cv = cur.value
    match (cur.kind) {
        case TokenKind.LCURL =>
            let (ts, next) = parseObject(t, 1)
            ret.append(quote(
                    return $(ts);
                ))
            if (next != t.size) {
                diagReport(DiagReportLevel.ERROR, t, "Unexpected token after initial object",
                    "Unexpected token after initial object")
                throw Exception("Unexpected token after initial object")
            }
            return wrap(ret)
        case TokenKind.LSQUARE =>
            let (ts, next) = parseArray(t, 1)
            ret.append(quote(
                        return $(ts);
                    ))
            if (next != t.size) {
                diagReport(DiagReportLevel.ERROR, t, "Unexpected token after initial array",
                    "Unexpected token after initial array")
                throw Exception("Unexpected token after initial array")
            }
            return wrap(ret)
        case TokenKind.IDENTIFIER where (cv == "null" || cv == "None") => return quote(JsonNull())
        case _ =>
            let (ts, next) = parseValue(t, 0)
            if (next != t.size) {
                diagReport(DiagReportLevel.ERROR, t, "Unexpected token after initial value",
                    "Unexpected token after initial value")
                throw Exception("Unexpected token after initial value")
            }
            return ts
    }
}
