/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hr.algebra.parsers.rss;

import hr.algebra.factory.ParserFactory;
import hr.algebra.factory.UrlConnectionFactory;
import hr.algebra.model.Genre;
import hr.algebra.model.Movie;
import hr.algebra.model.Person;
import hr.algebra.utils.FileUtils;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLStreamConstants;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.events.Characters;
import javax.xml.stream.events.StartElement;
import javax.xml.stream.events.XMLEvent;

/**
 *
 * @author Nikola
 */

public class MovieParser {
    
    private static final String RSS_URL = "https://www.blitz-cinestar.hr/rss.aspx?najava=1";
    private static final int TIMEOUT = 10000;
    private static final String REQUEST_METHOD = "GET";
    private static final String EXT = ".jpg";
    private static final String DIR = "src" + File.separator + "assets";

    public MovieParser() {
    }

    public static List<Movie> parse() throws IOException, XMLStreamException {

        List<Movie> movies = new ArrayList<>();

        //create and open HttpUrlconnection to site
        HttpURLConnection con = UrlConnectionFactory.getHttpUrlConnection(RSS_URL, TIMEOUT, REQUEST_METHOD);

        // in order to create parser you need InputStream
        try (InputStream is = con.getInputStream()) {
            //create parser -> Stax parser
            //parser doesnt care where the data comes from, it just needs a source. That source needs to be closed afterwards.
            XMLEventReader reader = ParserFactory.createStaxParser(is);

            StartElement startElement = null;
            Movie movie = null;
            Optional<TagType> tagType = Optional.empty();

            //Stax parsser -> get as much as there is
            //"dok ima lajni, vuci lajne"
            while (reader.hasNext()) {

                XMLEvent event = reader.nextEvent();

                switch (event.getEventType()) {

                    case XMLStreamConstants.START_ELEMENT:
                        startElement = event.asStartElement(); 
                        String qName = startElement.getName().getLocalPart(); 
                        tagType = TagType.from(qName);
                        break;

                    case XMLStreamConstants.CHARACTERS:

                        if (tagType.isPresent()) {
                            Characters characters = event.asCharacters();
                            String data = characters.getData().trim();
                            switch (tagType.get()) {
                                case ITEM:
                                    movie = new Movie();
                                    movies.add(movie);
                                    break;
                                case TITLE:
                                    if (movie != null && !data.isEmpty()) {
                                        movie.setTitle(data);
                                    }
                                    break;
                                case PUBDATE:
                                    if (movie != null && !data.isEmpty()) {
                                        LocalDateTime publishedDate = LocalDateTime.parse(data, DateTimeFormatter.RFC_1123_DATE_TIME);
                                        movie.setPublishedDate(publishedDate);
                                    }
                                    break;
                                case DESCRIPTION:
                                    if (movie != null && !data.isEmpty()) {
                                        int imgEnd = data.indexOf(">");
                                        movie.setDescription(data.substring(imgEnd + 1, data.length()-1));
                                        movie.setDescription(data);
                                    }
                                    break;
                                case ORIGNAZIV:
                                    if (movie != null && !data.isEmpty()) {
                                        movie.setOriginalTitle(data);
                                    }
                                    break;
                                case REDATELJ:
                                    if (movie != null && !data.isEmpty()) {
                                        movie.setDirector(Person.parsePeopleFromString(data));
                                    }
                                    break;
                                case GLUMCI:
                                    if (movie != null && !data.isEmpty()) {
                                        movie.setActors(Person.parsePeopleFromString(data));
                                    }
                                    break;
                                case TRAJANJE:
                                    if (movie != null && !data.isEmpty()) {
                                        movie.setDuration(Integer.parseInt(data));
                                    }
                                    break;
                                case ZANR:
                                    if (movie != null && !data.isEmpty()) {
                                        movie.setGenre(Genre.parseGenreFromString(data));
                                    }
                                    break;
                                case PLAKAT:
                                    if (movie != null && startElement != null && movie.getPicturePath() == null) {

                                        handlePicture(movie, data);
                                    }
                                    break;
                                case LINK:
                                    if (movie != null && !data.isEmpty()) {
                                        movie.setLink(data);
                                    }
                                    break;
                                case POCETAK:
                                    if (movie != null && !data.isEmpty()) {

                                        movie.setOpeningDate(data);
                                    }
                                    break;
                            }
                        }
                        break;
                }
            }
        }
        return movies;
    }

    private enum TagType {

        ITEM("item"),
        TITLE("title"),
        PUBDATE("pubDate"),
        DESCRIPTION("description"),
        ORIGNAZIV("orignaziv"),
        REDATELJ("redatelj"),
        GLUMCI("glumci"),
        TRAJANJE("trajanje"),
        ZANR("zanr"),
        PLAKAT("plakat"),
        LINK("link"),
        POCETAK("pocetak");

        private final String name;

        private TagType(String name) {
            this.name = name;
        }

        private static Optional<TagType> from(String name) {
            for (TagType value : values()) {
                if (value.name.equals(name)) {
                    return Optional.of(value);
                }
            }
            return Optional.empty();
        }
    }

    private static void handlePicture(Movie movie, String pictureUrl) throws IOException {

        // make sure it has .jpg extension
        String ext = pictureUrl.substring(pictureUrl.lastIndexOf("."));
        if (ext.length() > 4) {
            ext = EXT;
        }

        //create picture name
        String pictureName = UUID.randomUUID() + ext;
        //create picture path
        String picturePath = DIR + File.separator + pictureName;

        //download image into a file
        FileUtils.copyFromUrl(pictureUrl, picturePath);
        //update movie
        movie.setPicturePath(picturePath);

    }
    
}
