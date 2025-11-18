package win.servername.entity.bookDTO;

public class ReviewDTO {
    private String title;
    private String description;
    private double rating;
    private UserDTO_ForBook user;

    public String getTitle(){return title;}
    public String getDescription(){return description;}
    public double getRating(){return rating;}
    public UserDTO_ForBook getUser(){return user;}

    public void setTitle(String title){this.title = title;}
    public void setDescription(String description){this.description = description;}
    public void setRating(double rating){this.rating = rating;}
    public void setUser(UserDTO_ForBook user){this.user = user;}
}
