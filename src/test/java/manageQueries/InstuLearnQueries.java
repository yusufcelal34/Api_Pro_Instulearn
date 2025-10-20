package manageQueries;

import org.junit.Assert;

import java.sql.ResultSet;
import java.sql.SQLException;

public class InstuLearnQueries {
    static ResultSet resultSet;
    // bu class'ı sorguları depolamak
    // ve dinemik sorgular oluşturmak için kullanacağız

    public static String selectFromWhereData (String select, String from, String where, String data){

        return "select " +select+ " from " +from+ " where " +where+ " = " +data+ ";";
    }

}