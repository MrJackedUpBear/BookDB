package win.servername.entity.bookDTO;

public class UserDTO_ForBook {
    private String username;
    private String firstName;
    private String lastName;
    private int numOwnedBooks;

    public String getUsername(){return username;}
    public String getFirstName(){return firstName;}
    public String getLastName(){return lastName;}
    public int getNumOwnedBooks(){return numOwnedBooks;}

    public void setUsername(String username){this.username = username;}
    public void setFirstName(String firstName){this.firstName = firstName;}
    public void setLastName(String lastName){this.lastName = lastName;}
    public void setNumOwnedBooks(int numOwnedBooks){this.numOwnedBooks = numOwnedBooks;}
}
