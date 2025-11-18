package win.servername.entity.bookDTO;

import win.servername.entity.book.Review;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class BookDTO {
    //Book
    private String isbn = "";
    private String title = "";
    private String description = "";
    private String author = "";
    private Date publishDate;
    private String publisher = "";
    private String language = "";
    private String imageLoc = "";

    //Review
    private List<ReviewDTO> reviews = new ArrayList<>();

    //Availability
    private List<BookAvailabilityDTO> bookAvailability = new ArrayList<>();

    //Getters
    public String getIsbn(){return isbn;}
    public String getTitle(){return title;}
    public String getDescription(){return description;}
    public String getAuthor(){return author;}
    public Date getPublishDate(){return publishDate;}
    public String getPublisher(){return publisher;}
    public String getLanguage(){return language;}
    public String getImageLoc(){return imageLoc;}
    public List<ReviewDTO> getReviews(){return reviews;}
    public List<BookAvailabilityDTO> getBookAvailability(){return bookAvailability;}

    //Setters
    public void setIsbn(String isbn){this.isbn = isbn;}
    public void setTitle(String title){this.title = title;}
    public void setDescription(String description){this.description = description;}
    public void setAuthor(String author){this.author = author;}
    public void setPublishDate(Date publishDate){this.publishDate = publishDate;}
    public void setPublisher(String publisher){this.publisher = publisher;}
    public void setLanguage(String language){this.language = language;}
    public void setImageLoc(String imageLoc){this.imageLoc = imageLoc;}
    public void setReviews(List<ReviewDTO> reviews){this.reviews = reviews;}
    public void setBookAvailability(List<BookAvailabilityDTO> bookAvailability){this.bookAvailability = bookAvailability;}
}
