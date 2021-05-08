package br.ufes.analisador.lexico.analisador;

import java_cup.runtime.ComplexSymbolFactory.ComplexSymbol;
import java_cup.runtime.Symbol;

public class ErroAnalisado {
    
    private final ComplexSymbol symbol;
    private final String message;
    
    public ErroAnalisado(String message, Symbol symbol) {
        this.symbol  = (ComplexSymbol) symbol;
        this.message = message;
    }
    
    public ComplexSymbol getSymbol() {
        return symbol;
    }

    public String getMessage() {
        return message;
    }
    
}
