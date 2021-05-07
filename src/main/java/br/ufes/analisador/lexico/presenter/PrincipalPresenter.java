/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.ufes.analisador.lexico.presenter;

import br.ufes.analisador.lexico.analisador.Analisador;
import br.ufes.analisador.lexico.analisador.ErroAnalisado;
import br.ufes.analisador.lexico.presenter.table.TbModelToken;
import br.ufes.analisador.lexico.view.PrincipalView;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.List;
import javax.swing.JEditorPane;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import org.fife.ui.rsyntaxtextarea.RSyntaxTextArea;
import org.fife.ui.rtextarea.RTextScrollPane;

/**
 *
 * @author bruno
 */
public class PrincipalPresenter {

    private PrincipalView view;

    private RSyntaxTextArea txtAreaCodigo;
    private RTextScrollPane scrTxtCodigo;
    private TbModelToken tbTokens;

    public PrincipalPresenter() {

        this.view = new PrincipalView();
        view.setExtendedState(JFrame.MAXIMIZED_BOTH);
        loadTxtCodigo();
        loadTable();
        loadEpnSaida();
        
        this.view.getBtnExecutar().addActionListener((ActionEvent ae) -> {
            this.executarAnalise();
        });
        
        this.view.setVisible(true);       

    }

    private void loadTxtCodigo() {
        txtAreaCodigo = new RSyntaxTextArea();

        txtAreaCodigo.setHighlightCurrentLine(true);
        txtAreaCodigo.setAutoIndentEnabled(false);
        txtAreaCodigo.setLineWrap(false);
        txtAreaCodigo.setCodeFoldingEnabled(false);

        txtAreaCodigo.addKeyListener(new KeyAdapter() {
            @Override
            public void keyReleased(KeyEvent ke) {
                if (isAnaliseAutomatica()) {
                    executarAnalise();
                }
            }

            @Override
            public void keyTyped(KeyEvent ke) {
                /*if (!arquivo.foiEditado() && (ke.getModifiers() != KeyEvent.CTRL_MASK)) {
                    arquivo.setEditado(true);
                    updateTitle();
                }*/
            }
        });

        scrTxtCodigo = new RTextScrollPane(txtAreaCodigo);
        scrTxtCodigo.setFoldIndicatorEnabled(false);
        scrTxtCodigo.setLineNumbersEnabled(true);

        scrTxtCodigo.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
        //scrTxtCodigo.setBounds(0, 0, view.getPnlCodigo().getWidth(), view.getPnlCodigo().getHeight());
        scrTxtCodigo.setVisible(true);

        view.getPnlCodigo().add(scrTxtCodigo);

        view.addWindowListener(new WindowAdapter() {
            @Override
            public void windowStateChanged(WindowEvent e) {
                scrTxtCodigo.setBounds(0, 0, 2*view.getPnlCodigo().getWidth(), 2*view.getPnlCodigo().getHeight());
            }
            @Override
            public void windowOpened(WindowEvent e) {
                scrTxtCodigo.setBounds(0, 0, 2*view.getPnlCodigo().getWidth(), 2*view.getPnlCodigo().getHeight());
            }
            @Override
            public void windowActivated(WindowEvent e) {
                scrTxtCodigo.setBounds(0, 0, 2*view.getPnlCodigo().getWidth(), 2*view.getPnlCodigo().getHeight());
            }
        });
    }

    private void loadTable() {
        this.tbTokens = new TbModelToken();
        view.getTblSimbolos().setModel(this.tbTokens);
    }
    
    private boolean isAnaliseAutomatica() {
        return view.getChkItmAnaliseAuto().isSelected();
    }

    private void updateTitle() {
        String titulo = " - IDE C--";

        /* if (arquivo.foiEditado()) {
            titulo = "*" + this.arquivo.getNome() + titulo;
        } else {
            titulo = this.arquivo.getNome() + titulo;
        }*/
        view.setTitle(titulo);
    }

    private void loadEpnSaida() {
        view.getEpnSaida().setEditable(false);
        view.getEpnSaida().putClientProperty(JEditorPane.HONOR_DISPLAY_PROPERTIES, Boolean.TRUE);
        view.getEpnSaida().setContentType("text/html");
        view.getEpnSaida().setFont(new Font(Font.MONOSPACED, Font.PLAIN, 11));
    }
    
    private void exibirErros(List<ErroAnalisado> erros) {
        String saida = "<html>" + "<hr>";

        saida += "<b>Análise concluída</b><br>" + "<hr>";

        int countErros = erros.size() - 1;

        if (countErros > 0) {
            saida += "<font color=\"red\">" + "<b>";
            if (countErros == 1) {
                saida += countErros + " Erro Encontrado:";
            } else {
                saida += countErros + " erros foram encontrados:";
            }

            saida += "</b></font><br>";

            for (ErroAnalisado e : erros) {
                String msg = e.getMessage();
                if (msg.contains(":")) {
                    int indice = msg.indexOf(":");

                    saida += "&nbsp;&nbsp;&nbsp;&nbsp;";
                    saida += "<b>" + msg.substring(0, indice) + "</b>" + msg.substring(indice) + "<br>";
                } else {
                    saida += "&nbsp;&nbsp;&nbsp;&nbsp;" + msg + "<br>";
                }

            }
        } else {
            saida += "<b>Nenhum erro encontrado</b>";
        }
        saida += "<hr>" + "</html>";
        view.getEpnSaida().setText(saida);
    }
    
    private void executarAnalise() {

        String codigo = txtAreaCodigo.getText();

        try {
            Analisador analisador = new Analisador(codigo);
            analisador.executar();
            
            this.tbTokens.setTokens(analisador.getTokens());
            
            exibirErros(analisador.getErros());

        } catch (Exception ex) {
            JOptionPane.showMessageDialog(view, "Erro ao analisar código: \n" + ex.getMessage());
        }
    }

}
