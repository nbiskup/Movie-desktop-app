/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hr.algebra.dal.sql;

import hr.algebra.dal.Repository;
import hr.algebra.model.Genre;
import hr.algebra.model.Movie;
import hr.algebra.model.Person;
import hr.algebra.model.User;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sql.DataSource;

/**
 *
 * @author Nikola
 */
public class SqlRepository implements Repository {
    
    private static final String ID_MOVIE = "IDMovie";
    private static final String TITLE = "Title";
    private static final String PUB_DATE = "PublishedDate";
    private static final String DESCRIPTION = "Description";
    private static final String ORG_TITLE = "OriginalTitle";
    private static final String DURATION = "Duration";
    private static final String PIC_PATH = "PicturePath";
    private static final String LINK = "Link";
    private static final String OPENING_DATE = "OpeningDate";

    private static final String CREATE_MOVIE = "{ CALL createMovie (?,?,?,?,?,?,?,?,?) }";
    private static final String UPDATE_MOVIE = "{ CALL updateMovie (?,?,?,?,?,?,?,?,?) }";
    private static final String DELETE_MOVIE = "{ CALL deleteMovie (?) }";
    private static final String SELECT_MOVIE = "{ CALL selectMovie (?) }";
    private static final String SELECT_MOVIES = "{ CALL selectMovies () }";

    private static final String IDPERSON = "IDPerson";
    private static final String FIRST_NAME = "FirstName";
    private static final String LAST_NAME = "LastName";

    private static final String CREATE_ACTOR = "{ CALL createActor (?,?,?) }";
    private static final String UPDATE_ACTOR = "{ CALL updateActor (?,?,?) }";
    private static final String DELETE_ACTOR = "{ CALL deleteActor (?) }";
    private static final String SELECT_ACTOR = "{ CALL selectActor (?) }";
    private static final String SELECT_ACTORS = "{ CALL selectActors () }";

    private static final String CREATE_DIRECTOR = "{ CALL createDirector (?,?,?) }";
    private static final String UPDATE_DIRECTOR = "{ CALL updateDirector (?,?,?) }";
    private static final String DELETE_DIRECTOR = "{ CALL deleteDirector (?) }";
    private static final String SELECT_DIRECTOR = "{ CALL selectDirector (?) }";
    private static final String SELECT_DIRECTORS = "{ CALL selectDirectors () }";

    private static final String IDGENRE = "IDGenre";
    private static final String GENRE_NAME = "Name";

    private static final String CREATE_GENRE = "{ CALL createGenre (?,?) }";
    private static final String UPDATE_GENRE = "{ CALL updateGenre (?,?) }";
    private static final String DELETE_GENRE = "{ CALL deleteGenre (?) }";
    private static final String SELECT_GENRE = "{ CALL selectGenre (?) }";
    private static final String SELECT_GENRES = "{ CALL selectGenres () }";

    private static final String IDUSER = "IDUser";
    private static final String USERNAME = "Username";
    private static final String PASSWORD = "Password";
    private static final String ROLE = "UserTypeID";

    private static final String CREATE_USER = "{ CALL createUser (?,?,?) }";
    private static final String SELECT_USER = "{ CALL selectUser (?) }";
    private static final String SELECT_USERS = "{ CALL selectUsers () }";

    private static final String DELETE_ALL = "{ CALL deleteAll () }";

    private static final String CREATE_MOVIE_DIRECTOR = "{ CALL createMovieDirector (?,?,?) }";
    private static final String DELETE_MOVIE_DIRECTOR = "{ CALL deleteMovieDirector (?) }";
    private static final String GET_MOVIE_DIRECTORS = "{ CALL getMovieDirectors  (?) }";

    private static final String CREATE_MOVIE_ACTOR = "{ CALL createMovieActor (?,?,?) }";
    private static final String DELETE_MOVIE_ACTOR = "{ CALL deleteMovieActor (?) }";
    private static final String GET_MOVIE_ACTORS = "{ CALL getMovieActors (?) }";

    private static final String CREATE_MOVIE_GENRE = "{ CALL createMovieGenre (?,?,?) }";
    private static final String DELETE_MOVIE_GENRE = "{ CALL deleteMovieGenre (?) }";
    private static final String GET_MOVIE_GENRES = "{ CALL getMovieGenres (?) }";


    private static final String CREATE_USER_GENRE = "{ CALL createUserGenre (?,?,?) }";
    private static final String DELETE_USER_GENRE = "{ CALL deleteUserGenre (?, ?) }";
    private static final String SELECT_USER_GENRES = "{ CALL selectUserGenres (?) }";
    
    
    public SqlRepository() {
    }

    @Override
    public int createMovie(Movie movie) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        int id;
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(CREATE_MOVIE)) {
            stmt.setString(1, movie.getTitle());
            stmt.setString(2, movie.getPublishedDate().format(Movie.PUB_DATE_FORMAT));
            stmt.setString(3, movie.getDescription());
            stmt.setString(4, movie.getOriginalTitle());
            stmt.setInt(5, movie.getDuration());
            stmt.setString(6, movie.getPicturePath());
            stmt.setString(7, movie.getLink());
            stmt.setString(8, movie.getOpeningDate());

            stmt.registerOutParameter(9, Types.INTEGER);
            
            stmt.executeUpdate();

            id = stmt.getInt(9);
            createActors(movie.getActors(), id, con);
            createDirectors(movie.getDirector(), id, con);
            createGenres(movie.getGenre(), id, con);

            return id;
        }
    }

    @Override
    public void createMovies(List<Movie> movies) throws SQLException {

        DataSource ds = DataSourceSingleton.getInstance();
        List<String> titlovi = new ArrayList<>();
        try (Connection con = ds.getConnection()) {
            if (!movies.isEmpty()) {
                movies.forEach(m -> {
                    try {
                        int id = 0;
                        if (!titlovi.contains(m.getTitle())) {
                            CallableStatement stmt = con.prepareCall(CREATE_MOVIE);
                            stmt.setString(1, m.getTitle());
                            stmt.setString(2, m.getPublishedDate().format(Movie.PUB_DATE_FORMAT));
                            stmt.setString(3, m.getDescription());
                            stmt.setString(4, m.getOriginalTitle());
                            stmt.setInt(5, m.getDuration());
                            stmt.setString(6, m.getPicturePath());
                            stmt.setString(7, m.getLink());
                            stmt.setString(8, m.getOpeningDate());
                            stmt.registerOutParameter(9, Types.INTEGER);
                            stmt.executeUpdate();
                            id = stmt.getInt(9);
                            createActors(m.getActors(), id, con);
                            createDirectors(m.getDirector(), id, con);
                            createGenres(m.getGenre(), id, con);
                            titlovi.add(m.getTitle());
                        } else {
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(SqlRepository.class.getName()).log(Level.SEVERE, null, ex);
                    }
                });
            }
        }
    }

    @Override
    public void updateMovie(int id, Movie movie) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(UPDATE_MOVIE)) {

            stmt.setInt(1, movie.getId());
            stmt.setString(2, movie.getTitle());
            stmt.setString(3, movie.getPublishedDate().format(Movie.PUB_DATE_FORMAT));
            stmt.setString(4, movie.getDescription());
            stmt.setString(5, movie.getOriginalTitle());
            stmt.setInt(6, movie.getDuration());
            stmt.setString(7, movie.getPicturePath());
            stmt.setString(8, movie.getLink());
            stmt.setString(9, movie.getOpeningDate());

            stmt.execute();

            deleteMovieForeignKeyTables(id, con);
            createActors(movie.getActors(), id, con);
            createDirectors(movie.getDirector(), id, con);
            createGenres(movie.getGenre(), id, con);
        }
    }

    @Override
    public void deleteMovie(int id) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(DELETE_MOVIE)) {
            stmt.setInt(1, id);
            stmt.execute();
        }
    }

    @Override
    public Optional<Movie> selectMovie(int id) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(SELECT_MOVIE)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    return Optional.of(new Movie(
                            rs.getInt(ID_MOVIE),
                            rs.getString(TITLE),
                            LocalDateTime.parse(rs.getString(PUB_DATE), Movie.PUB_DATE_FORMAT),
                            rs.getString(DESCRIPTION),
                            rs.getString(ORG_TITLE),
                            getMovieDirectors(id, con),
                            getMovieActors(id, con),
                            rs.getInt(DURATION),
                            getMovieGenres(id, con),
                            rs.getString(PIC_PATH),
                            rs.getString(LINK),
                            rs.getString(OPENING_DATE)
                    ));
                }
            }

        }

        return Optional.empty();
    }

    @Override
    public List<Movie> selectMovies() throws Exception {
        List<Movie> movies = new ArrayList<>();
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(SELECT_MOVIES);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                try {
                    int id = rs.getInt(ID_MOVIE);
                    movies.add(new Movie(
                            id,
                            rs.getString(TITLE),
                            LocalDateTime.parse(rs.getString(PUB_DATE), Movie.PUB_DATE_FORMAT),
                            rs.getString(DESCRIPTION),
                            rs.getString(ORG_TITLE),
                            getMovieDirectors(id, con),
                            getMovieActors(id, con),
                            rs.getInt(DURATION),
                            getMovieGenres(id, con),
                            rs.getString(PIC_PATH),
                            rs.getString(LINK),
                            rs.getString(OPENING_DATE)
                    ));
                } catch (Exception e) {
                    System.out.println("error selecting movies");
                }
            }
        }
        return movies;
    }

    @Override
    public int createGenre(Genre genre) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(CREATE_GENRE)) {

            stmt.setString(1, genre.getName());
            stmt.registerOutParameter(2, Types.INTEGER);

            stmt.executeUpdate();

            return stmt.getInt(2);
        }
    }

    @Override
    public void updateGenre(int id, Genre data) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(UPDATE_GENRE)) {

            stmt.setInt(1, id);
            stmt.setString(2, data.getName());

            stmt.executeUpdate();

        }
    }

    @Override
    public void deleteGenre(int id) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(DELETE_GENRE)) {

            stmt.setInt(1, id);

            stmt.executeUpdate();

        }
    }

    @Override
    public Optional<Genre> selectGenre(int id) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(SELECT_GENRE)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    return Optional.of(new Genre(
                            rs.getInt(IDGENRE),
                            rs.getString(GENRE_NAME)
                    ));
                }
            }

        }

        return Optional.empty();
    }

    @Override
    public List<Genre> selectGenres() throws Exception {
        List<Genre> genres = new ArrayList<>();
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(SELECT_GENRES);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                try {
                    int id = rs.getInt(IDGENRE);

                    genres.add(new Genre(
                            id,
                            rs.getString(GENRE_NAME)));
                } catch (Exception e) {
                    System.out.println("ERROR while selecting genres");
                }
            }
        }
        return genres;
    }

    @Override
    public int createActor(Person person) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(CREATE_ACTOR)) {

            stmt.setString(1, person.getFirstName());
            stmt.setString(2, person.getLastName());
            stmt.registerOutParameter(3, Types.INTEGER);

            stmt.executeUpdate();

            return stmt.getInt(3);
        }
    }

    @Override
    public void updateActor(int id, Person data) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(UPDATE_ACTOR)) {

            stmt.setInt(1, id);
            stmt.setString(2, data.getFirstName());
            stmt.setString(2, data.getLastName());

            stmt.executeUpdate();

        }
    }

    @Override
    public void deleteActor(int id) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(DELETE_ACTOR)) {

            stmt.setInt(1, id);

            stmt.executeUpdate();

        }
    }

    @Override
    public Optional<Person> selectActor(int id) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(SELECT_ACTOR)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    return Optional.of(new Person(
                            rs.getInt(IDPERSON),
                            rs.getString(FIRST_NAME),
                            rs.getString(LAST_NAME)
                    ));
                }
            }

        }

        return Optional.empty();
    }

    @Override
    public List<Person> selectActors() throws Exception {
        List<Person> actors = new ArrayList<>();
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(SELECT_ACTORS);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                try {
                    int id = rs.getInt(IDPERSON);

                    actors.add(new Person(
                            id,
                            rs.getString(FIRST_NAME),
                            rs.getString(LAST_NAME)));
                } catch (Exception e) {
                    System.out.println("ERROR while selecting autors");
                }
            }
        }
        return actors;
    }

    @Override
    public int createDirector(Person person) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(CREATE_DIRECTOR)) {

            stmt.setString(1, person.getFirstName());
            stmt.setString(2, person.getLastName());
            stmt.registerOutParameter(3, Types.INTEGER);

            stmt.executeUpdate();

            return stmt.getInt(3);
        }
    }

    @Override
    public void updateDirector(int id, Person data) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(UPDATE_DIRECTOR)) {

            stmt.setInt(1, id);
            stmt.setString(2, data.getFirstName());
            stmt.setString(2, data.getLastName());

            stmt.executeUpdate();

        }
    }

    @Override
    public void deleteDirector(int id) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(DELETE_DIRECTOR)) {

            stmt.setInt(1, id);

            stmt.executeUpdate();

        }
    }

    @Override
    public Optional<Person> selectDirector(int id) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(SELECT_DIRECTOR)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    return Optional.of(new Person(
                            rs.getInt(IDPERSON),
                            rs.getString(FIRST_NAME),
                            rs.getString(LAST_NAME)
                    ));
                }
            }

        }

        return Optional.empty();
    }

    @Override
    public List<Person> selectDirectors() throws Exception {
        List<Person> directors = new ArrayList<>();
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(SELECT_DIRECTORS);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                try {
                    int id = rs.getInt(IDPERSON);

                    directors.add(new Person(
                            id,
                            rs.getString(FIRST_NAME),
                            rs.getString(LAST_NAME)));
                } catch (Exception e) {
                    System.out.println("ERROR while selecting directors");
                }
            }
        }
        return directors;
    }

    @Override
    public int createUser(User user) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(CREATE_USER)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());

            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.executeUpdate();

            return stmt.getInt(3);

        }
    }

    @Override
    public Optional<User> selectUser(int id) throws Exception {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(SELECT_USER)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    return Optional.of(new User(
                            rs.getInt(IDUSER),
                            rs.getString(USERNAME),
                            rs.getString(PASSWORD)
                    ));
                }
            }

        }

        return Optional.empty();
    }

    @Override
    public List<User> selectUsers() throws Exception {

        List<User> users = new ArrayList<>();
        DataSource ds = DataSourceSingleton.getInstance();
        try (Connection con = ds.getConnection();
                CallableStatement stmt = con.prepareCall(SELECT_USERS);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                users.add(new User(rs.getInt(IDUSER), rs.getString(USERNAME), rs.getString(PASSWORD), rs.getInt(ROLE)));
            }
        }

        return users;
    }

    @Override
    public void deleteAll() throws Exception {
        DataSource ds = DataSourceSingleton.getInstance();
        try (Connection con = ds.getConnection();
                CallableStatement stmt = con.prepareCall(DELETE_ALL)) {
            stmt.execute();

        }
    }

    private void createActors(List<Person> actors, int id, Connection con) throws SQLException {
        if (actors != null) {

            actors.forEach(a -> {
                try (CallableStatement stmt = con.prepareCall(CREATE_ACTOR)) {

                    stmt.setString(1, a.getFirstName());
                    stmt.setString(2, a.getLastName());
                    stmt.registerOutParameter(3, Types.INTEGER);
                    stmt.executeUpdate();

                    createMovieActor(id, stmt.getInt(3), con);

                } catch (SQLException ex) {
                    Logger.getLogger(SqlRepository.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            });

        }
    }

    private void createDirectors(List<Person> directors, int id, Connection con) throws SQLException {
        if (directors != null) {

            directors.forEach(d -> {
                try (CallableStatement stmt = con.prepareCall(CREATE_DIRECTOR)) {

                    stmt.setString(1, d.getFirstName());
                    stmt.setString(2, d.getLastName());
                    stmt.registerOutParameter(3, Types.INTEGER);
                    stmt.executeUpdate();

                    createMovieDirector(id, stmt.getInt(3), con);

                } catch (SQLException ex) {
                    Logger.getLogger(SqlRepository.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            });

        }
    }

    private void createGenres(List<Genre> genres, int id, Connection con) throws SQLException {
        if (genres != null) {

            genres.forEach(g -> {
                try (CallableStatement stmt = con.prepareCall(CREATE_GENRE)) {

                    stmt.setString(1, g.getName());
                    stmt.registerOutParameter(2, Types.INTEGER);
                    stmt.executeUpdate();

                    createMovieGenres(id, stmt.getInt(2), con);

                } catch (SQLException ex) {
                    Logger.getLogger(SqlRepository.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            });

        }
    }

    private void createMovieActor(int movieId, int actorId, Connection con) throws SQLException {
        DataSource ds = DataSourceSingleton.getInstance();
        try (CallableStatement stmt = con.prepareCall(CREATE_MOVIE_ACTOR)) {
            stmt.setInt(1, movieId);
            stmt.setInt(2, actorId);
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.execute();
        }
    }

    private void createMovieDirector(int movieId, int directorId, Connection con) throws SQLException {
        DataSource ds = DataSourceSingleton.getInstance();
        try (CallableStatement stmt = con.prepareCall(CREATE_MOVIE_DIRECTOR)) {
            stmt.setInt(1, movieId);
            stmt.setInt(2, directorId);
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.execute();
        }
    }

    private void createMovieGenres(int movieId, int genreId, Connection con) throws SQLException {
        DataSource ds = DataSourceSingleton.getInstance();
        try (CallableStatement stmt = con.prepareCall(CREATE_MOVIE_GENRE)) {
            stmt.setInt(1, movieId);
            stmt.setInt(2, genreId);
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.execute();
        }
    }

    private void deleteMovieForeignKeyTables(int id, Connection con) throws SQLException {
        CallableStatement deleteDir = con.prepareCall(DELETE_MOVIE_DIRECTOR);
        deleteDir.setInt(1, id);
        deleteDir.execute();
        CallableStatement deleteAct = con.prepareCall(DELETE_MOVIE_ACTOR);
        deleteAct.setInt(1, id);
        deleteAct.execute();
        CallableStatement deleteGen = con.prepareCall(DELETE_MOVIE_GENRE);
        deleteGen.setInt(1, id);
        deleteGen.execute();
    }

    private List<Person> getMovieDirectors(int movieid, Connection con) throws SQLException {
        List<Person> directors = new ArrayList<>();

        try (
                CallableStatement stmt = con.prepareCall(GET_MOVIE_DIRECTORS)) {

            stmt.setInt(1, movieid);
            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    directors.add(new Person(
                            rs.getInt(IDPERSON),
                            rs.getString(FIRST_NAME),
                            rs.getString(LAST_NAME)));
                }
            }
        }

        return directors;
    }

    private List<Person> getMovieActors(int movieid, Connection con) throws SQLException {
        List<Person> actors = new ArrayList<>();
        try (
                CallableStatement stmt = con.prepareCall(GET_MOVIE_ACTORS)) {

            stmt.setInt(1, movieid);
            try (ResultSet rs = stmt.executeQuery();) {

                while (rs.next()) {
                    actors.add(new Person(
                            rs.getInt(IDPERSON),
                            rs.getString(FIRST_NAME),
                            rs.getString(LAST_NAME)));
                }
            }
        }
        return actors;
    }

    private List<Genre> getMovieGenres(int movieid, Connection con) throws SQLException {
        List<Genre> genres = new ArrayList<>();
        try (
                CallableStatement stmt = con.prepareCall(GET_MOVIE_GENRES)) {

            stmt.setInt(1, movieid);
            try (ResultSet rs = stmt.executeQuery();) {

                while (rs.next()) {
                    genres.add(new Genre(
                            rs.getInt(IDGENRE),
                            rs.getString(GENRE_NAME)));
                }
            }
        }
        return genres;
    }

    

   
    @Override
    public int createUserGenre(int userID, int genreID) throws SQLException {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(CREATE_USER_GENRE)) {

            stmt.setInt(1, userID);
            stmt.setInt(2, genreID);

            stmt.registerOutParameter(3, Types.INTEGER);
            
            stmt.executeUpdate();

            return stmt.getInt(3);
        }
    }

    @Override
    public void deleteUserGenre(int userID, int genreID) throws SQLException {
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(DELETE_USER_GENRE)) {

            stmt.setInt(1, userID);
            stmt.setInt(2, genreID);

            
            stmt.executeUpdate();

        }
    }

     @Override
    public List<Genre> selectUserGenres(int userID) throws SQLException {
        List<Genre> genres = new ArrayList<>();
        DataSource dataSource = DataSourceSingleton.getInstance();
        try (Connection con = dataSource.getConnection();
                CallableStatement stmt = con.prepareCall(SELECT_USER_GENRES)) {
            stmt.setInt(1, userID);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    try {
                        int id = rs.getInt(IDGENRE);

                        genres.add(new Genre(
                                id,
                                rs.getString(GENRE_NAME)));
                    } catch (Exception e) {
                        System.out.println("ERROR while selecting user genres");
                    }
                }
            } catch (Exception e) {
            }
        }
        return genres;
    }
    
    
}
