package stepdefinitions;

import io.cucumber.java.en.*;
import manageQueries.InstuLearnQueries;
import org.junit.Assert;
import utilities.API_Utilities.JDBSReusableMethods;

import java.sql.ResultSet;
import java.sql.SQLException;

public class DB_StepDef {
    ResultSet resultSet;

    @Given("The user connects to the InstuLearn database")
    public void the_user_connects_to_the_instu_learn_database() {
        JDBSReusableMethods.createMyConnection();
    }

    @Given("The user queries the {string} from the {string} table where the {string} column has the value {string}.")
    public void the_user_queries_the_from_the_table_where_the_column_has_the_value(String select, String from, String where, String data) {
       String query = InstuLearnQueries.selectFromWhereData(select,from,where,data);
        System.out.println(query);

       resultSet = JDBSReusableMethods.executeMyQuery(query);
    }

    @Given("The user retrieves meetings grouped by meeting_id with total payment greater than 500")
    public void the_user_retrieves_meetings_grouped_by_meeting_id_with_total_payment_greater_than() {
       String query = "SELECT meeting_id, SUM(paid_amount) AS total_payment FROM reserve_meetings GROUP BY meeting_id HAVING SUM(paid_amount) > 500;";
        resultSet = JDBSReusableMethods.executeMyQuery(query);
    }

    @Given("The user verifies that the {string} in the query result is {int}")
    public void the_user_verifies_that_the_id_in_the_query_result_is(String expectedData, Integer intExpected) throws SQLException {
        if (resultSet.next()) {
            int intActual = resultSet.getInt(expectedData); // veya sütun index'i: resultSet.getInt(1);

            Assert.assertEquals(intExpected.intValue(), intActual);
            System.out.println("Query returned ID: " + intActual);
        } else {
            Assert.fail("ResultSet is empty, no data returned.");
        }
    }

    @Given("The user closes the database connection")
    public void the_user_closes_the_database_connection() {
        JDBSReusableMethods.closeMyConnection();
    }

    @Given("The user displays the {string} from the query result.")
    public void the_user_displays_the_from_the_query_result(String expectedData) throws SQLException {
        while (resultSet.next()) {

            String full_name = null;
            try {
                full_name = resultSet.getString(expectedData);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }


            System.out.println(full_name);
        }

    }

    @Given("the user views how many {string} are returned")
    public void the_user_views_how_many_are_returned(String expectedData) throws SQLException {
        int count = 0;
        while (resultSet.next()) {
            count++;

            String meetings_id = null;
            try {
                meetings_id = resultSet.getString(expectedData);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

        }
           System.out.println("number of meetings with payments over 500: " + count);
    }


}
