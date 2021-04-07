package br.ufes.analisador.lexico.jflex;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java_cup.runtime.Symbol;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;

%%

%public
%class Lexer
%cup
%type Symbol
%line
%column
%char

%state STRING
%state CHAR

%init{
    this.symbols = new ArrayList<>();
%init}

%{

    private final List<Symbol> symbols;
    private ComplexSymbolFactory symbolFactory;
    private Character caracterRead;
    StringBuffer string = new StringBuffer();
    Symbol stringSymbol;

    public Lexer(java.io.Reader in, ComplexSymbolFactory symbolFactory){
	this(in);
	this.symbolFactory = symbolFactory;
    }

    public void executar() throws IOException {
        while(next_token() != null) continue;
    }
    
    public List<Symbol> getSymbols() {
        return this.symbols;
    }

    private void addSymbol(Symbol symbol) {
        this.symbols.add(symbol);
    }

    private Symbol symbol(int sym) {
        return symbol(yytext(), sym, yytext());
    }

    private Symbol symbol(String name, int sym) {
        Symbol symbol = symbolFactory.newSymbol(name, sym, new Location(yyline+1,yycolumn+1,((int)yychar)), new Location(yyline+1,yycolumn+yylength(),((int)yychar)+yylength()));
        addSymbol(symbol);
        return symbol;
    }

    private Symbol symbol(String name, int sym, Object val) {
        Location left = new Location(yyline+1,yycolumn+1,((int)yychar));
        Location right = new Location(yyline+1,yycolumn+yylength(), ((int)yychar)+yylength());
        Symbol symbol = symbolFactory.newSymbol(name, sym, left, right,val);
        addSymbol(symbol);
        return symbol;
    }

    private Symbol symbol(String name, int sym, Object val,int buflength) {
        Location left = new Location(yyline+1,yycolumn+yylength()-buflength,((int)yychar)+yylength()-buflength);
        Location right = new Location(yyline+1,yycolumn+yylength(), ((int)yychar)+yylength());
        Symbol symbol = symbolFactory.newSymbol(name, sym, left, right,val);
        addSymbol(symbol);
        return symbol;
    }
    
    /* Está aqui apenas para não adicionar o EOF à lista de tokens */
    private Symbol symbolEOF(String name, int sym){
        Symbol symbol = symbolFactory.newSymbol(name, sym, new Location(yyline+1,yycolumn+1,((int)yychar)), new Location(yyline+1,yycolumn+yylength(),((int)yychar)+yylength()));
        return symbol;
    }

%}

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
EscapeCharter = [\\\'|\\\\|\\\"|\\r|\\n|\\t]
CHAR = \'
LITERAL = \"

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

  {LITERAL}                      { string.setLength(0); stringSymbol = symbol("STRING", sym.STRING); yybegin(STRING);}
  {CHAR}                         { yybegin(CHAR);}

  {NUM_INT}                      { return symbol(sym.NUM_INT); }
  {NUM_FLOAT}                    { return symbol(sym.NUM_FLOAT); }
  
  /* Comentários */
  {Comment}                      { /* ignore */ }

  /* Espaço em branco */
  {WhiteSpace}                   { /* ignore */ }

  /* Identificador */ 
  {Identifier}                   { return symbol("ID", sym.ID, yytext()); }  
}

<STRING> {
    \"                              { 
                                        yybegin(YYINITIAL); 
                                        stringSymbol.value = string.toString();
                                        return stringSymbol;
                                    }
    [^\n\r\"\\]+                    { string.append( yytext() ); }
    \\t                             { string.append('\t'); }
    \\n                             { string.append('\n'); }
    \\r                             { string.append('\r'); }
    \\\"                            { string.append('\"'); }
    \\\\                            { string.append('\\'); }
    
    \n                              { yybegin(YYINITIAL); }
}

<CHAR> {
    [^\n\r\"\\]\'                   {
                                        yybegin(YYINITIAL); 
                                        return symbol("CARACTERE", sym.CHAR, " " + yytext().charAt(0));
                                    }
    \\t\'                           {
                                        yybegin(YYINITIAL); 
                                        caracterRead = '\t';
                                        return symbol("CARACTERE", sym.CHAR, caracterRead.toString());
                                    }
    \\n\'                           {
                                        yybegin(YYINITIAL); 
                                        caracterRead = '\n'; 
                                        return symbol("CARACTERE", sym.CHAR, caracterRead.toString());
                                    }
    \\r\'                           {
                                        yybegin(YYINITIAL); 
                                        caracterRead = '\r'; 
                                        return symbol("CARACTERE", sym.CHAR, caracterRead.toString());
                                    }
    \\\"\'                          {
                                        yybegin(YYINITIAL); 
                                        caracterRead = '\"'; 
                                        return symbol("CARACTERE", sym.CHAR, caracterRead.toString());
                                    }
    \\\\\'                          {
                                        yybegin(YYINITIAL); 
                                        caracterRead = '\\'; 
                                        return symbol("CARACTERE", sym.CHAR, caracterRead.toString());
                                    }
    \\\'\'                          {
                                        yybegin(YYINITIAL); 
                                        caracterRead = '\''; 
                                        return symbol("CARACTERE", sym.CHAR, caracterRead.toString());
                                    }
    \\[^tnr\"\'\\]\'                { 
                                        yybegin(YYINITIAL);
                                    }
    {EscapeCharter}{EscapeCharter}+\'? | [^\n\r\"\\\'][^\n\r\"\\\']+\'? {
                                        yybegin(YYINITIAL);
                                    }
    [^\n\r\"\\\']*\n                {
                                        yybegin(YYINITIAL);
                                    }
}