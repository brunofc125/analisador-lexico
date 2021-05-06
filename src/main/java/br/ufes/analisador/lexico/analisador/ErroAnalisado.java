/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.ufes.analisador.lexico.analisador;

import java_cup.runtime.ComplexSymbolFactory.ComplexSymbol;
import java_cup.runtime.Symbol;

/**
 *
 * @author bruno
 */
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
