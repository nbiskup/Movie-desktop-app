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
public class PersonTransferable implements Transferable{
    
    //create a flavor -> class Person that can be transportable
    public static final DataFlavor PERSON_FLAVOR = new DataFlavor(Person.class, "Person");
    //create a list of flavors where you declare which are supportet
    public static final DataFlavor[] SUPPORTED_FLAVORS = {PERSON_FLAVOR};
    //declares what it depends on
    private final Person data;

    //dependency injection-> u cannot create me without giving me Person data
    public PersonTransferable(Person data) {
        this.data = data;
    }

    //return a list of flavors that can be transported
    @Override
    public DataFlavor[] getTransferDataFlavors() {
        return SUPPORTED_FLAVORS;
    }

    //returns true if a given flavor is supported for transport
    @Override
    public boolean isDataFlavorSupported(DataFlavor flavor) {
        return flavor.equals(PERSON_FLAVOR);
    }

    //returns data from given flavor if supported
    @Override
    public Object getTransferData(DataFlavor flavor) throws UnsupportedFlavorException, IOException {
        if (isDataFlavorSupported(flavor)) {
            return data;
        }
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
