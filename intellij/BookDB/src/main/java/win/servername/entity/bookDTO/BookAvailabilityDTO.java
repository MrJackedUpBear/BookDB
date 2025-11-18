package win.servername.entity.bookDTO;

public class BookAvailabilityDTO {
    private String availability;
    private int count;
    private UserDTO_ForBook user;

    public UserDTO_ForBook getUser() {return user;}
    public String getAvailability(){return availability;}
    public int getCount(){return count;}

    public void setUser(UserDTO_ForBook user){this.user = user;}
    public void setAvailability(String availability){this.availability = availability;}
    public void setCount(int count){this.count = count;}
}
