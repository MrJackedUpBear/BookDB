package win.servername.api.repository.book;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import win.servername.entity.book.Book;
import win.servername.entity.book.BookAvailability;
import win.servername.entity.book.BookAvailabilityId;

import java.util.List;

@Repository
public interface BookAvailabilityRepository extends JpaRepository<BookAvailability, Long> {
    public List<BookAvailability> findByBookAvailabilityId_Book(Book book);

    void deleteByBookAvailabilityId(BookAvailabilityId bookAvailabilityId);
}
