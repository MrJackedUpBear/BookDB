package win.servername.entity.auth;

import jakarta.persistence.*;

import static win.servername.Constants.NAME_LENGTH;

@Entity
@Table(name = "User")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long userId;

    @Column(nullable = false, unique = true, length = NAME_LENGTH)
    private String username;

    @Column(nullable = false, length = NAME_LENGTH)
    private String firstName;

    @Column(nullable = false, length = NAME_LENGTH)
    private String lastName;

    @Column(nullable = false)
    private int numOwnedBooks;

    @Column(nullable = false)
    private String password;

    public long getUserId(){return userId;}
    public String getUsername(){return username;}
    public String getFirstName(){return firstName;}
    public String getLastName(){return lastName;}
    public int getNumOwnedBooks(){return numOwnedBooks;}
    public String getPassword(){return password;}

    public void setUserId(long userId){this.userId = userId;}
    public void setUsername(String username){this.username = username;}
    public void setFirstName(String firstName){this.firstName = firstName;}
    public void setLastName(String lastName){this.lastName = lastName;}
    public void setNumOwnedBooks(int numOwnedBooks){this.numOwnedBooks = numOwnedBooks;}
    public void setPassword(String password){this.password = password;}
}
