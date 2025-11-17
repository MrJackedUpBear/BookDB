package win.servername.api.repository.book;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import win.servername.entity.book.Book;
import win.servername.entity.book.BookAvailability;

import java.util.List;

@Repository
public interface BookAvailabilityRepository extends JpaRepository<BookAvailability, Long> {
}
