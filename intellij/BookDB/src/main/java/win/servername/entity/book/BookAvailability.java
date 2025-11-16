package win.servername.entity.book;

import jakarta.persistence.*;
import win.servername.entity.auth.User;
import win.servername.entity.permission.RolePermissionId;

import java.util.Objects;

import static win.servername.Constants.AVAILABILITY_LENGTH;

@Entity
@Table(name = "BookAvailability")
public class BookAvailability {
    @EmbeddedId
    private BookAvailabilityId bookAvailabilityId;

    @Column(nullable = false, length = AVAILABILITY_LENGTH)
    private String availability;

    public BookAvailabilityId getBookAvailabilityId(){return bookAvailabilityId;}
    public String getAvailability(){return availability;}

    public void setBookAvailabilityId(BookAvailabilityId bookAvailabilityId){this.bookAvailabilityId = bookAvailabilityId;}
    public void setAvailability(String availability){this.availability = availability;}
}