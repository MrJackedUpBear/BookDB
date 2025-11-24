package win.servername.usercreator;

import java.util.Scanner;
import java.sql.*;
import java.util.Date;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

/**
 * Hello world!
 */
public class App {
    private static Scanner scanner;
    private static final String DB_URL = "jdbc:mariadb://localhost:3306/Books";
    private static final String DB_USERNAME = System.getenv("DB_USER");
    private static final String DB_PASSWORD = System.getenv("DB_PASSWORD");
 
    public static void main(String[] args) {
    	initializeScanner();

	    createUser();

	    killScanner();
    }

    static void createUser(){
	    String firstName = getUserInput("Enter the user's first name: ");
	    String lastName = getUserInput("Enter the user's last name: ");
	    String username = getUserInput("Enter the user's username: ");
      String role = getUserInput("Enter the user's role \n"+
          "Possible values:\n " +
          "1 - Admin (Access to everything)\n" +
          "2 - Elevated User (Add and Read Books)\n" +
          "3 - General User (Only access to Read Books):\n");
      addUserToTable(username, firstName, lastName, role);
    }

    static void addUserToTable(String username, String firstName, String lastName, String role){
      //Need to initialize the password and hash with some generic values...
      byte[] password = "$2y$12$tER3.LcLXZCOrIS/kGpDIuhXmHD56RQSxpJ234iAPdAIr9aQVv6vy".getBytes(StandardCharsets.UTF_8);
      int numOwnedBooks = 0;
      
      //Order should be (firstName, lastName, numOwnedBooks, password, username)
      String sql = "INSERT INTO user (firstName, lastName, numOwnedBooks, password, username) VALUES (?, ?, ?, ?, ?);";

      try (Connection conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
          PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)){
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setLong(3, numOwnedBooks);
            pstmt.setBytes(4, password);
            pstmt.setString(5, username);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0){
              System.out.println("Successfully added user...");

              ResultSet generatedKeys = pstmt.getGeneratedKeys();

              if (!generatedKeys.next()){
                System.out.println("Error getting user ID...");
                return;
              }

              long userId = generatedKeys.getLong(1);
              addUserToRole(userId, role);
            }else{
              System.out.println("Error adding user...");
            }
          }catch(SQLException e){
            System.out.println("Error adding user: " + e.getStackTrace());
          }
    }

    static void addUserToRole(long userId, String role){
      //Role should be an int, so we need to try to parse it...
      long roleId;

      //Requires roleId, userId, description, and date provisioned
      String description = "Added via Admin console.";
      java.util.Date date = new java.util.Date();
      java.sql.Date dateProvisioned = new java.sql.Date(date.getTime());

      try{
        roleId = Long.parseLong(role);
      }catch(Exception e){
        roleId = 3;
      }

      String sql = "INSERT INTO userrole VALUES (?, ?, ?, ?);";

      try (Connection conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
          PreparedStatement pstmt = conn.prepareStatement(sql)){
        pstmt.setDate(1, dateProvisioned);
        pstmt.setString(2, description);
        pstmt.setLong(3, userId);
        pstmt.setLong(4, roleId);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0){
          System.out.println("Added user to role: " + roleId);
        }else{
          System.out.println("Unexpected error adding user to role: " + roleId);
        }
      }catch(SQLException e){
        System.out.println("Error adding user to role: " + e.getStackTrace());
      }
    }

    static String getUserInput(String message){
	    boolean isValidInput = false;
	
	    String input = "";

	    while (!isValidInput){
		    System.out.print(message);
		    input = scanner.nextLine();

		    if (!input.isEmpty()){
			    isValidInput = true;
		    }
	    }

      return input;
    }

    static void initializeScanner(){
	    scanner = new Scanner(System.in);
    }

    static void killScanner(){
	    scanner.close();
    }
}
