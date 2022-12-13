/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hr.algebra.model;

import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.io.IOException;

/**
 *
 * @author Nikola
 */
public class GenreTransferable implements Transferable {
    
    //create a flavor -> class Genre that can be transportable
    public static final DataFlavor GENRE_FLAVOR = new DataFlavor(Genre.class, "Person");
    //create a list of flavors where you declare which are supportet
    public static final DataFlavor[] SUPPORTED_FLAVORS= {GENRE_FLAVOR};
    //declares what it depends on
    private final Genre data;

    //dependency injection-> u cannot create me without giving me Genre data
    public GenreTransferable(Genre data) {
        this.data = data;
    }
    @Override
    public DataFlavor[] getTransferDataFlavors() {
        return SUPPORTED_FLAVORS;
    }

    @Override
    public boolean isDataFlavorSupported(DataFlavor flavor) {
        return flavor.equals(GENRE_FLAVOR);
    }

    @Override
    public Object getTransferData(DataFlavor flavor) throws UnsupportedFlavorException, IOException {
        if (isDataFlavorSupported(flavor)) {
            return data;
        }
        
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
