/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hr.algebra.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

/**
 *
 * @author Nikola
 */
@XmlAccessorType(XmlAccessType.FIELD)
public class Movie {
    
    public static final DateTimeFormatter PUB_DATE_FORMAT = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
    
    private int id;
    private String title;
    @XmlJavaTypeAdapter(PublishedDateAdapter.class)
    @XmlElement(name = "publisheddate")
    private LocalDateTime publishedDate;
    private String description;
    @XmlElement(name = "originaltitle")
    private String originalTitle;
    @XmlElementWrapper
    private List<Person> director;
    @XmlElementWrapper
    private List<Person> actors;
    private int duration;
    @XmlElementWrapper
    private List<Genre> genre;
    @XmlElement(name = "picturepath")
    private String picturePath;
    private String link;
    @XmlElement(name = "openingdate")
    private String openingDate;

    public Movie() {
    }

    public Movie(String title, LocalDateTime publishedDate, String description, String originalTitle, List<Person> director, List<Person> actors, int duration, List<Genre> genre, String picturePath, String link, String openingDate) {
        this.title = title;
        this.publishedDate = publishedDate;
        this.description = description;
        this.originalTitle = originalTitle;
        this.director = director;
        this.actors = actors;
        this.duration = duration;
        this.genre = genre;
        this.picturePath = picturePath;
        this.link = link;
        this.openingDate = openingDate;
    }

    public Movie(int id, String title, LocalDateTime publishedDate, String description, String originalTitle, List<Person> director, List<Person> actors, int duration, List<Genre> genre, String picturePath, String link, String openingDate) {
        this(title, publishedDate, description, originalTitle, director, actors, duration, genre, picturePath, link, openingDate);
        this.id = id;
        
    }

    public static DateTimeFormatter getPUB_DATE_FORMAT() {
        return PUB_DATE_FORMAT;
    }

   
    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public LocalDateTime getPublishedDate() {
        return publishedDate;
    }

    public String getDescription() {
        return description;
    }

    public String getOriginalTitle() {
        return originalTitle;
    }

    public List<Person> getDirector() {
        return director;
    }

    public List<Person> getActors() {
        return actors;
    }

    public int getDuration() {
        return duration;
    }

    public List<Genre> getGenre() {
        return genre;
    }

    public String getPicturePath() {
        return picturePath;
    }

    public String getLink() {
        return link;
    }

    public String getOpeningDate() {
        return openingDate;
    }

   

    public void setId(int id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setPublishedDate(LocalDateTime publishedDate) {
        this.publishedDate = publishedDate;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setOriginalTitle(String originalTitle) {
        this.originalTitle = originalTitle;
    }

    public void setDirector(List<Person> director) {
        this.director = director;
    }

    public void setActors(List<Person> actors) {
        this.actors = actors;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public void setGenre(List<Genre> genre) {
        this.genre = genre;
    }

    public void setPicturePath(String picturePath) {
        this.picturePath = picturePath;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public void setOpeningDate(String openingDate) {
        this.openingDate = openingDate;
    }

    @Override
    public String toString() {
        return "Movie{" + "id=" + id + ", title=" + title + ", publishedDate=" + publishedDate + ", description=" + description + ", originalTitle=" + originalTitle + ", director=" + director + ", actors=" + actors + ", duration=" + duration + ", genre=" + genre + ", picturePath=" + picturePath + ", link=" + link + ", openingDate=" + openingDate + '}';
    }
    
    
}
