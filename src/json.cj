macro package json_cj

import std.ast.*
import std.collection.ArrayList
public import json_cj.helper.castJsonValue

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

// INITIAL -> OBJECT_START | ARRAY_START | STRING | NUMBER | BOOLEAN | NULL
// OBJECT_START -> OBJECT_KEY | OBJECT_END
// OBJECT_KEY -> OBJECT_COLON
// OBJECT_COLON -> OBJECT_VALUE
// OBJECT_VALUE -> OBJECT_COMMA | OBJECT_END
// OBJECT_COMMA -> OBJECT_KEY
// ARRAY_START -> ARRAY_VALUE | ARRAY_END
// ARRAY_VALUE -> ARRAY_COMMA | ARRAY_END
// ARRAY_COMMA -> ARRAY_VALUE
// STRING | NUMBER | BOOLEAN | NULL -> OBJECT_COMMA | OBJECT_END | ARRAY_COMMA | ARRAY_END | END
public macro Json(input: Tokens): Tokens {
    var objCnt = 0
    func getObjName(): String {
        return "jo${objCnt++}"
    }
    func getArrayName(): String {
        return "ja${objCnt++}"
    }

    func getIdent(s: String): Token {
        return Token(TokenKind.IDENTIFIER, s)
    }

    var t = Tokens()

    for (ti in input) {
        if (let TokenKind.NL <- ti.kind) {
            continue
        }
        t.append(ti)
    }

    var ret = Tokens()

    var tIndex = 0

    func parseObjectPair(): (String, Tokens) {
        return ("", Tokens())
    }

    func parseObject(): (String, Tokens) {
        return ("", Tokens())
    }

    func parseArray(): (String, Tokens) {
        return ("", Tokens())
    }

    func parseValue(): Tokens {
        if (let Some((expr, next)) <- safeParseExprFragment(t, tIndex)) {
            tIndex = next
            var exprTokens = expr.toTokens()

            if (exprTokens.size > 1) {
                return quote(castJsonValue($(expr)))
            }

            var first = exprTokens[0]
            var ident = getIdent(first.value)
            match (first.kind) {
                case TokenKind.STRING_LITERAL => return quote(JsonString($(ident)))
                case TokenKind.INTEGER_LITERAL => return quote(JsonInt($(ident)))
                case TokenKind.FLOAT_LITERAL => return quote(JsonFloat($(ident)))
                case TokenKind.BOOL_LITERAL => return quote(JsonBool($(ident)))
                case _ => return quote(castJsonValue($(expr)))
            }
        } else {
            diagReport(DiagReportLevel.ERROR, t, "Unexpected token", "Unexpected token")
            throw Exception("Unexpected token")
        }
    }

    func wrapRet(): Tokens {
        return quote(
            (=>
                $(ret) 
            )()
        )
    }

    if (t.size == 0) {
        return quote(())
    }

    while (tIndex < t.size) {
        var cur = t[tIndex]
        match (cur.kind) {
            case TokenKind.LCURL =>
                var (name, _) = parseObject()
                ret.append(quote(
                    return $(name)
                ))
                if (tIndex != t.size - 1) {
                    diagReport(DiagReportLevel.ERROR, t, "Unexpected token", "Unexpected token after object")
                    throw Exception("Unexpected token")
                }
                return wrapRet()
            case TokenKind.LSQUARE =>
                var (name, _) = parseArray()
                ret.append(quote(
                    return $(name)
                ))
                if (tIndex != t.size - 1) {
                    diagReport(DiagReportLevel.ERROR, t, "Unexpected token", "Unexpected token after array")
                    throw Exception("Unexpected token")
                }
                return wrapRet()
            case TokenKind.IDENTIFIER where (cur.value == "null" || cur.value == "None") => return quote(
                    JsonNull()
                )
            case _ => return parseValue()
        }
    }

    diagReport(DiagReportLevel.ERROR, t, "Unexpected token", "Unexpected token")
    throw Exception("Unexpected token")
}
