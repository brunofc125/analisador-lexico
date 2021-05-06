package br.ufes.analisador.lexico.jflex;

import br.ufes.analisador.lexico.analisador.ErroAnalisado;
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
    this.errors = new ArrayList<>();
%init}

%{

    private final List<Symbol> symbols;
    private final ArrayList<ErroAnalisado> errors;
    private ComplexSymbolFactory symbolFactory;
    private Character caracterRead;
    StringBuffer string = new StringBuffer();
    Symbol stringSymbol;

    public Lexer(java.io.Reader in, ComplexSymbolFactory symbolFactory){
	this(in);
	this.symbolFactory = symbolFactory;
    }

    public void executar() throws IOException {
        while(next_token().sym != sym.EOF);
    }

    public ArrayList<ErroAnalisado> getErros() {
        return this.errors;
    }

    public int countErros() {
        return this.errors.size();
    }

    private void addErro(String erro) {
        Location left = new Location(yyline+1,yycolumn+1,((int)yychar));
        Location right = new Location(yyline+1,yycolumn+yylength(), ((int)yychar+yylength()));
        Symbol symbol = symbolFactory.newSymbol("ERRO LÉXICO -> ", sym.error, left, right);
        this.errors.add(new ErroAnalisado("ERRO LÉXICO >>> " + erro, symbol));
    }
    
    public List<Symbol> getSymbols() {
        return this.symbols;
    }

    private void addSymbol(Symbol symbol) {
        this.symbols.add(symbol);
    }

    private Symbol symbol(int sym, String name) {
        return symbol(name, sym, yytext());
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

/* erros */
errorComment = [\/][*]
charterLimit = (([_] | [:jletter:])+([_] | [:jletterdigit:])*){32}[^\n ]*
incorrectNumber = {NUM_INT}[.] | [.]{NUM_INT} | {NUM_INT}[.]{NUM_INT}[.]([0-9]|[.])*


%%

<YYINITIAL> {

  /* keywords */
  "#define"                      { return symbol(sym.DEFINE, "DEFINE"); }
  /* Especificadores */
  "auto"                         { return symbol(sym.AUTO, "AUTO"); }
  "static"                       { return symbol(sym.STATIC, "STATIC"); }
  "extern"                       { return symbol(sym.EXTERN, "EXTERN"); }
  "const"                        { return symbol(sym.CONST, "CONST"); }

  /* Tipos */
  "void"                         { return symbol(sym.VOID, "VOID"); }
  "char"                         { return symbol(sym.CHAR, "CHAR"); }
  "float"                        { return symbol(sym.FLOAT, "FLOAT"); }
  "double"                       { return symbol(sym.DOUBLE, "DOUBLE"); }
  "signed"                       { return symbol(sym.SIGNED, "SIGNED"); }
  "unsigned"                     { return symbol(sym.UNSIGNED, "UNSIGNED"); }

  /* Inteiros */
  "int"                          { return symbol(sym.INT, "INT"); }
  "short"                        { return symbol(sym.SHORT, "SHORT"); }
  "long"                         { return symbol(sym.LONG, "LONG"); }
  
  /* Instruções */
  "return"                       { return symbol(sym.RETURN, "RETURN"); }
  "printf"                       { return symbol(sym.PRINTF, "PRINTF"); }
  "scanf"                        { return symbol(sym.SCANF, "SCANF"); }
  "break"                        { return symbol(sym.BREAK, "BREAK"); }
  "if"                           { return symbol(sym.IF, "IF"); }
  "else"                         { return symbol(sym.ELSE, "ELSE"); }
  
  /* Separadores */
  "("                            { return symbol(sym.LPAREN, "LPAREN"); }
  ")"                            { return symbol(sym.RPAREN, "RPAREN"); }
  "{"                            { return symbol(sym.LBRACE, "LBRACE"); }
  "}"                            { return symbol(sym.RBRACE, "RBRACE"); }
  "["                            { return symbol(sym.LBRACK, "LBRACK"); }
  "]"                            { return symbol(sym.RBRACK, "RBRACK"); }
  ";"                            { return symbol(sym.SEMICOLON, "SEMICOLON"); }
  ","                            { return symbol(sym.COMMA, "COMMA"); }
  "."                            { return symbol(sym.DOT, "DOT"); }
  "\\n"                          { return symbol(sym.CRLF, "CRLF"); }
  
  /* Operadores */
  "="                            { return symbol(sym.EQ, "EQ"); }
  ">"                            { return symbol(sym.GT, "GT"); }
  "<"                            { return symbol(sym.LT, "LT"); }
  "!"                            { return symbol(sym.NOT, "NOT"); }
  "=="                           { return symbol(sym.EQEQ, "EQEQ"); }
  "<="                           { return symbol(sym.LTEQ, "LTEQ"); }
  ">="                           { return symbol(sym.GTEQ, "GTEQ"); }
  "!="                           { return symbol(sym.NOTEQ, "NOTEQ"); }
  "AND"                          { return symbol(sym.AND, "AND"); }
  "OR"                           { return symbol(sym.OR, "OR"); }
  "+"                            { return symbol(sym.PLUS, "PLUS"); }
  "-"                            { return symbol(sym.MINUS, "MINUS"); }
  "*"                            { return symbol(sym.MULT, "MULT"); }
  "/"                            { return symbol(sym.DIV, "DIV"); }
  "%"                            { return symbol(sym.MOD, "MOD"); }
  "+="                           { return symbol(sym.PLUSEQ, "PLUSEQ"); }
  "-="                           { return symbol(sym.MINUSEQ, "MINUSEQ"); }
  "*="                           { return symbol(sym.MULTEQ, "MULTEQ"); }
  "/="                           { return symbol(sym.DIVEQ, "DIVEQ"); }
  "%="                           { return symbol(sym.MODEQ, "MODEQ"); }

  {LITERAL}                      { string.setLength(0); stringSymbol = symbol("STRING", sym.STRING); yybegin(STRING);}
  {CHAR}                         { yybegin(CHAR);}

  {NUM_INT}                      { return symbol(sym.NUM_INT, "NUM_INT"); }
  {NUM_FLOAT}                    { return symbol(sym.NUM_FLOAT, "NUM_FLOAT"); }
  
  /* Comentários */
  {Comment}                      { /* ignore */ }

  /* Espaço em branco */
  {WhiteSpace}                   { /* ignore */ }

  /* Identificador */ 
  {Identifier}                   { return symbol("ID", sym.ID, yytext()); }  

  {errorComment}                 { this.addErro("Linha " + (yyline+1) + ", coluna " + yycolumn + ": Falta fechar o comentário."); }    
  {charterLimit}                 { this.addErro("Linha " + (yyline+1) + ", coluna " + yycolumn + ": Identificador " + yytext().toUpperCase() + " excedeu o limite de caracteres."); }
  {incorrectNumber}              { this.addErro("Linha " + (yyline+1) + ", coluna " + yycolumn + ": " + yytext().toUpperCase() + " não é um número."); }
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
    
    \n                              { 
                                        yybegin(YYINITIAL);
                                        this.addErro("Linha " + (yyline+1) + ", coluna " + yycolumn + ": Aspas sem fechamento.");
                                    }
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
                                        this.addErro("Linha " + (yyline+1) + ", coluna " + yycolumn + ": Aspas sem fechamento.");
                                    }
}

<<EOF>>                             { return symbolEOF("EOF", sym.EOF); }
