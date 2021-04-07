/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.ufes.analisador.lexico.presenter.table;

import java.util.ArrayList;
import java.util.List;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.Symbol;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author bruno
 */
public class TbModelToken extends AbstractTableModel {

    private List<Symbol> symbols;
    private final String[] colunas;

    public TbModelToken() {
        this.symbols = new ArrayList<>();
        this.colunas = new String[]{"Tipo", "Lexema", "Linha", "Coluna"};
    }

    public void addToken(Symbol tk) {
        this.symbols.add(tk);
        super.fireTableDataChanged();
    }

    public void setTokens(List<Symbol> tokens) {
        this.symbols = tokens;
        super.fireTableDataChanged();
    }
    
    public void clear(){
        this.symbols.clear();
        super.fireTableDataChanged();
    }
    
    @Override
    public String getColumnName(int i) {
        return this.colunas[i];
    }

    @Override
    public int getRowCount() {
        return this.symbols.size();
    }

    @Override
    public int getColumnCount() {
        return this.colunas.length;
    }

    @Override
    public Object getValueAt(int linha, int coluna) {
        switch (coluna) {
            case 0:
                return ((ComplexSymbolFactory.ComplexSymbol) this.symbols.get(linha)).getName();
            case 1:
                return ((ComplexSymbolFactory.ComplexSymbol) this.symbols.get(linha)).value;
            case 2:
                return ((ComplexSymbolFactory.ComplexSymbol) this.symbols.get(linha)).xleft.getLine();
            case 3:
                return ((ComplexSymbolFactory.ComplexSymbol) this.symbols.get(linha)).xleft.getColumn();
            default:
                return null;
        }
    }

}
