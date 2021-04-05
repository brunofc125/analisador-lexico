/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.ufes.analisador.lexico.presenter;

import br.ufes.analisador.lexico.view.PrincipalView;
import java.awt.Font;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import javax.swing.JEditorPane;
import javax.swing.JFrame;
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

    public PrincipalPresenter() {

        loadTxtCodigo();
        this.view = new PrincipalView();
        view.setExtendedState(JFrame.MAXIMIZED_BOTH);
        loadEpnSaida();

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
                    //executarAnalise();
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

        view.getPnlCodigo().addComponentListener(new ComponentAdapter() {
            @Override
            public void componentResized(ComponentEvent e) {
                scrTxtCodigo.setBounds(0, 0, view.getPnlCodigo().getWidth(), view.getPnlCodigo().getHeight());
            }
        });

        scrTxtCodigo.setBounds(0, 0, view.getPnlCodigo().getWidth(), view.getPnlCodigo().getHeight());
        scrTxtCodigo.setVisible(true);

        view.getPnlCodigo().add(scrTxtCodigo);
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

}
