/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hr.algebra.dal;

import hr.algebra.model.Genre;
import hr.algebra.model.Movie;
import hr.algebra.model.Person;
import hr.algebra.model.User;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Nikola
 */
public interface Repository {
    
    //needed methods for Movie
    int createMovie(Movie movie) throws Exception;
    void createMovies(List<Movie> movies) throws Exception;
    void updateMovie(int id, Movie movie) throws Exception;
    void deleteMovie(int id) throws Exception;
    Optional<Movie> selectMovie(int id) throws Exception;
    List<Movie> selectMovies() throws Exception;
    
    //needed methods for Genre
    int createGenre(Genre genre) throws Exception;
    void updateGenre(int id, Genre data) throws Exception;
    void deleteGenre(int id) throws Exception;
    Optional<Genre> selectGenre(int id) throws Exception;
    List<Genre> selectGenres() throws Exception;
    
    //needed methos for Person
    int createActor(Person person) throws Exception;
    void updateActor(int id, Person data) throws Exception;
    void deleteActor(int id) throws Exception;
    Optional<Person> selectActor(int id) throws Exception;
    List<Person> selectActors() throws Exception;
    
    int createDirector(Person person) throws Exception;
    void updateDirector(int id, Person data) throws Exception;
    void deleteDirector(int id) throws Exception;
    Optional<Person> selectDirector(int id) throws Exception;
    List<Person> selectDirectors() throws Exception;
    
    //needed methods for User
    
    int createUser(User user) throws Exception;
    Optional<User> selectUser(int id) throws Exception;
    public List<User> selectUsers() throws Exception;
    
   
    List<Genre> selectUserGenres(int userID) throws SQLException;
    int createUserGenre(int userID, int genreID) throws SQLException;
    void deleteUserGenre(int userID, int genreID) throws SQLException;
    
   //needed methods for admin 
    void deleteAll() throws Exception;

    
}
