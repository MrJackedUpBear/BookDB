package win.servername.entity.book;

import jakarta.persistence.*;
import win.servername.entity.auth.User;

import static win.servername.Constants.TITLE_LENGTH;

@Entity
@Table(name = "Review")
public class Review {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long reviewId;

    @Column(nullable = false, length = TITLE_LENGTH)
    private String title;

    @Column(nullable = false)
    private String description;

    @Column(nullable = false)
    private double rating;

    @ManyToOne
    @JoinColumn(name = "UserId")
    private User user;

    @ManyToOne
    @JoinColumn(name = "BookId")
    private Book book;

    public long getReviewId(){return reviewId;}
    public String getTitle(){return title;}
    public String getDescription(){return description;}
    public double getRating(){return rating;}
    public User getUser(){return user;}
    public Book getBook(){return book;}

    public void setReviewId(long reviewId){this.reviewId = reviewId;}
    public void setTitle(String title){this.title = title;}
    public void setDescription(String description){this.description = description;}
    public void setRating(double rating){this.rating = rating;}
    public void setUser(User user){this.user = user;}
    public void setBook(Book book){this.book = book;}
}
