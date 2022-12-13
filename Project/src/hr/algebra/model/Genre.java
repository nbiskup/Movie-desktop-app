/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hr.algebra.model;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;

/**
 *
 * @author Nikola
 */


@XmlAccessorType(XmlAccessType.FIELD)
public class Genre implements Comparable<Genre> {
    
    @XmlAttribute
    private int id;
    private String name;

    public Genre() {
    }

    public Genre(String name) {
        this.name = name;
    }

    public Genre(int id, String name) {
        this(name);
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return name;
    }

    @Override
    public int compareTo(Genre o) {
        return name.compareTo(o.name);
    }
    
    public static List<Genre> parseGenreFromString(String data) {
        List<Genre> genres = new ArrayList<>();
        String[] details = data.split(",");
        Stream.of(details).forEach(g -> {

            genres.add(new Genre(g.trim()));
        });
        return genres;
    }
    
}
