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
import javax.xml.bind.annotation.XmlElement;

/**
 *
 * @author Nikola
 */


@XmlAccessorType(XmlAccessType.FIELD)
public class Person implements Comparable<Person> {
    
    @XmlAttribute
    private int id;
    @XmlElement(name = "ime")
    private String firstName;
    @XmlElement(name = "prezime")
    private String lastName;
    

    public Person() {
    }

   

    public Person(int id, String firstName, String lastName) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    public Person(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    

    public int getId() {
        return id;
    }

    

    public void setId(int id) {
        this.id = id;
    }

    

    @Override
    public String toString() {
        return firstName + " " + lastName;
    }

    @Override
    public int compareTo(Person o) {
        return Integer.valueOf(id).compareTo(o.id);
    }

    public static List<Person> parsePeopleFromString(String data) {
        List<Person> people = new ArrayList<>();
        String[] details = data.split(",");
        Stream.of(details).forEach(p-> people.add( new Person(
                p.substring(0, p.indexOf(" ")),
                p.substring(p.indexOf(" ") +1)
        )));
        return people;
    }
    
}
