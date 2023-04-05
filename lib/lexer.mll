{
    open Lexing 
    open Grammar

    exception SyntaxError of Lexing.position * string

    let next_line lexbuf =
        let pos = lexbuf.lex_curr_p in
        lexbuf.lex_curr_p <-
            { pos with 
                pos_bol = lexbuf.lex_curr_pos;
                pos_lnum = pos.pos_lnum + 1 }
}

let digit = ['0'-'9']
let int = '-'? digit+
let whitespace = [' ' '\t']+

rule read_token = parse
    | "r0" { R0 }
    | "r1" { R1 }
    | "r2" { R2 }
    | "r3" { R3 }
    | "r4" { R4 }
    | "r5" { R5 }
    | "r6" { R6 }
    | "r7" { R7 }
    | "r8" { R8 }
    | "r9" { R9 }
    | "r10" { R10 }
    | "r11" { R11 }
    | "r12" { R12 }
    | "r13" { R13 }
    | "r14" { R14 }
    | "r15" { R15 }
    | "ldr" { LDR }
    | "str" { STR }
    | "mov" { MOV }
    | "add" { ADD }
    | "sub" { SUB }
    | "[" { LBRACK }
    | "]" { RBRACK }
    | "{" { LBRACE }
    | "}" { RBRACE }
    | "," { COMMA }
    | whitespace { read_token lexbuf }
    | "\n" { NEWLINE }
    | "#" { read_number lexbuf }
    | eof { EOF }

and read_number = parse
    | int { INT (int_of_string (Lexing.lexeme lexbuf)) }
    | eof { raise (SyntaxError (lexbuf.lex_curr_p, "Expected a number after a #")) }