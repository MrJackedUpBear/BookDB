package win.servername.entity.bookDTO;

import win.servername.entity.userDTO.UserDTO;

public class BookAvailabilityDTO {
    private String availability;
    private int count;
    private UserDTO user;

    public UserDTO getUser() {return user;}
    public String getAvailability(){return availability;}
    public int getCount(){return count;}

    public void setUser(UserDTO user){this.user = user;}
    public void setAvailability(String availability){this.availability = availability;}
    public void setCount(int count){this.count = count;}
}
