package win.servername.entity.book;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "Book")
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long bookId;

    @Column(nullable = false, unique = true)
    private String isbn;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String description;

    @Column(nullable = false)
    private String author;

    @Column(nullable = false)
    private Date publishDate;

    @Column(nullable = false)
    private String publisher;

    @Column(nullable = false)
    private String language;

    @Column()
    private String imageLoc;

    //Getters
    public long getBookId(){
        return bookId;
    }
    public String getIsbn(){
        return isbn;
    }
    public String getTitle(){
        return title;
    }
    public String getDescription(){
        return description;
    }
    public String getAuthor(){
        return author;
    }
    public Date getPublishDate(){
        return publishDate;
    }
    public String getPublisher(){
        return publisher;
    }
    public String getLanguage(){
        return language;
    }
    public String getImageLoc(){
        return imageLoc;
    }

    //Setters
    public void setBookId(long bookId){this.bookId = bookId;}
    public void setIsbn(String isbn){this.isbn = isbn;}
    public void setTitle(String title){this.title = title;}
    public void setDescription(String description){this.description = description;}
    public void setAuthor(String author){this.author = author;}
    public void setPublishDate(Date publishDate){this.publishDate = publishDate;}
    public void setPublisher(String publisher){this.publisher = publisher;}
    public void setLanguage(String language){this.language = language;}
    public void setImageLoc(String imageLoc){this.imageLoc = imageLoc;}
}
