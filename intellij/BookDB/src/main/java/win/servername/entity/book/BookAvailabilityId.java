package win.servername.entity.book;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import win.servername.entity.auth.User;

import java.util.Objects;

@Embeddable
public class BookAvailabilityId{
    @ManyToOne
    @JoinColumn(name = "UserId")
    private User user;
    
    @ManyToOne
    @JoinColumn(name = "BookId")
    private Book book;
    
    @Column(nullable = false)
    private int count;

    public User getUser() {return user;}
    public Book getBook(){return book;}
    public int getCount(){return count;}
    
    public void setUser(User user){this.user = user;}
    public void setBook(Book book){this.book = book;}
    public void setCount(int count){this.count = count;}

    @Override
    public boolean equals(Object o){
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BookAvailabilityId that = (BookAvailabilityId) o;
        return Objects.equals(user, that.user) &&
                Objects.equals(book, that.book) &&
                Objects.equals(count, that.count);
    }

    @Override
    public int hashCode(){
        return Objects.hash(user, book, count);
    }
}
