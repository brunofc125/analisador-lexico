package br.ufes.analisador.lexico.jflex;

import java_cup.runtime.*;

%%

%{

StringBuilder string = new StringBuilder();

private void imprimir(String descricao, String lexema) {
    System.out.println(lexema + " - " + descricao);
}

private Symbol symbol(int type) {
    return new Symbol(type, yyline+1, yycolumn+1);
}

private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
}

%}

%public
%class Lexer
%line
%column

%cup

/* main character classes */
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]

WhiteSpace = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}

TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?

/* Identificador */
Identifier = (([_] | [:jletter:])+([_] | [:jletterdigit:])*) {1, 31}

/* integer literals */
NUM_INT = [0] | [1-9][0-9]*
NUM_FLOAT = {NUM_INT}[.][0-9]+

/* string and character literals */
StringCharacter = [^\r\n\"\\]
SingleCharacter = [^\r\n\'\\]

%%

<YYINITIAL> {

  /* keywords */
  "#define"                      { return symbol(sym.DEFINE); }
  /* Especificadores */
  "auto"                         { return symbol(sym.AUTO); }
  "static"                       { return symbol(sym.STATIC); }
  "extern"                       { return symbol(sym.EXTERN); }
  "const"                        { return symbol(sym.CONST); }

  /* Tipos */
  "void"                         { return symbol(sym.VOID); }
  "char"                         { return symbol(sym.CHAR); }
  "float"                        { return symbol(sym.FLOAT); }
  "double"                       { return symbol(sym.DOUBLE); }
  "signed"                       { return symbol(sym.SIGNED); }
  "unsigned"                     { return symbol(sym.UNSIGNED); }

  /* Inteiros */
  "int"                          { return symbol(sym.INT); }
  "short"                        { return symbol(sym.SHORT); }
  "long"                         { return symbol(sym.LONG); }
  
  /* Instruções */
  "return"                       { return symbol(sym.RETURN); }
  "printf"                       { return symbol(sym.PRINTF); }
  "scanf"                        { return symbol(sym.SCANF); }
  "break"                        { return symbol(sym.BREAK); }
  "if"                           { return symbol(sym.IF); }
  "else"                         { return symbol(sym.ELSE); }
  
  /* Separadores */
  "("                            { return symbol(sym.LPAREN); }
  ")"                            { return symbol(sym.RPAREN); }
  "{"                            { return symbol(sym.LBRACE); }
  "}"                            { return symbol(sym.RBRACE); }
  "["                            { return symbol(sym.LBRACK); }
  "]"                            { return symbol(sym.RBRACK); }
  ";"                            { return symbol(sym.SEMICOLON); }
  ","                            { return symbol(sym.COMMA); }
  "."                            { return symbol(sym.DOT); }
  "\\n"                          { return symbol(sym.CRLF); }
  
  /* Operadores */
  "="                            { return symbol(sym.EQ); }
  ">"                            { return symbol(sym.GT); }
  "<"                            { return symbol(sym.LT); }
  "!"                            { return symbol(sym.NOT); }
  "=="                           { return symbol(sym.EQEQ); }
  "<="                           { return symbol(sym.LTEQ); }
  ">="                           { return symbol(sym.GTEQ); }
  "!="                           { return symbol(sym.NOTEQ); }
  "AND"                          { return symbol(sym.AND); }
  "OR"                           { return symbol(sym.OR); }
  "+"                            { return symbol(sym.PLUS); }
  "-"                            { return symbol(sym.MINUS); }
  "*"                            { return symbol(sym.MULT); }
  "/"                            { return symbol(sym.DIV); }
  "%"                            { return symbol(sym.MOD); }
  "+="                           { return symbol(sym.PLUSEQ); }
  "-="                           { return symbol(sym.MINUSEQ); }
  "*="                           { return symbol(sym.MULTEQ); }
  "/="                           { return symbol(sym.DIVEQ); }
  "%="                           { return symbol(sym.MODEQ); }
  
  /* String */
  \"                             { yybegin(YYINITIAL); return symbol(sym.STRING, string.toString()); }

  /* Caracter */
  \'                             { yybegin(YYINITIAL); return symbol(sym.CHAR, yytext().charAt(0)); }
  
  {NUM_INT}                      { return symbol(sym.NUM_INT); }
  {NUM_FLOAT}                    { return symbol(sym.NUM_FLOAT); }
  
  /* Comentários */
  {Comment}                      { /* ignore */ }

  /* Espaço em branco */
  {WhiteSpace}                   { /* ignore */ }

  /* Identificador */ 
  {Identifier}                   { return symbol(sym.ID, yytext()); }  
}