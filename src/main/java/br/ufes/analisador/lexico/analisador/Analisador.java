/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.ufes.analisador.lexico.analisador;

import br.ufes.analisador.lexico.jflex.Lexer;
import java.io.StringReader;
import java.util.List;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.Symbol;

/**
 *
 * @author bruno
 */
public class Analisador {
    
    private final Lexer lexer;
    
    public Analisador(String codigo) {
        ComplexSymbolFactory symbolFactory = new ComplexSymbolFactory();
        this.lexer = new Lexer(new StringReader(codigo), symbolFactory);
    }
    
    public void executar() throws Exception {
        this.analiseLexica();
    }
    
    public void analiseLexica() throws Exception {
        this.lexer.executar();
    }
    
    public List<Symbol> getTokens() {
        return lexer.getSymbols();
    }
    

    
}
