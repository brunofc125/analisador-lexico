package br.ufes.analisador.lexico.analisador;

import br.ufes.analisador.lexico.jflex.Lexer;
import br.ufes.analisador.lexico.jflex.Parser;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.Symbol;

public class Analisador {

    private final Lexer lexer;
    private final Parser parser;
    private final List<ErroAnalisado> erros;

    public Analisador(String codigo) {
        ComplexSymbolFactory symbolFactory = new ComplexSymbolFactory();
        this.lexer = new Lexer(new StringReader(codigo), symbolFactory);
        this.parser = new Parser(new Lexer(new StringReader(codigo), symbolFactory), symbolFactory);
        this.erros = new ArrayList<>();
    }

    public void executar() throws Exception {
        this.analiseLexica();
        this.analiseSintatica();
    }

    public void analiseLexica() throws Exception {
        this.lexer.executar();
        erros.addAll(this.lexer.getErros());
    }

    public void analiseSintatica() throws Exception {
        try {
            System.out.println("Analisando...");
            this.parser.parse();
        } catch (Exception ex) {
            erros.addAll(parser.getErros());
            System.out.println("ERRO: " + ex.toString());
        }
    }

    public List<Symbol> getTokens() {
        return lexer.getSymbols();
    }
    
    public List<ErroAnalisado> getErros() {
        return erros;
    }

    public int countErros() {
        return erros.size();
    }

}
