/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hr.algebra.dal.sql;


/*import com.microsoft.sqlserver.jdbc.SQLServerDataSource;*/

import com.microsoft.sqlserver.jdbc.SQLServerDataSource;
import javax.sql.DataSource;
/**
 *
 * @author Nikola
 */
public class DataSourceSingleton {
    
    private static DataSource instance=null;

    private static final String PWD = "SQL";
    private static final String USER = "sa";
    private static final String DB = "JavaMovieProject";
    private static final String SERVER = "NIKOLA-COMPUTER";

    private DataSourceSingleton() {
    }

    public static DataSource getInstance() {
        if (instance == null) {
            instance = createInstance();
        }
        return instance;
    }

    private static DataSource createInstance() {
        SQLServerDataSource dataSource = new SQLServerDataSource();
        dataSource.setServerName(SERVER);
        dataSource.setDatabaseName(DB);
        dataSource.setUser(USER);
        dataSource.setPassword(PWD);
        
        return dataSource;
    }
    
}
