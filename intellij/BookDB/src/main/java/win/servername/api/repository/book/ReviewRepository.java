package win.servername.api.repository.book;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import win.servername.entity.auth.User;
import win.servername.entity.book.Book;
import win.servername.entity.book.Review;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    public Optional<Review> findByBookAndUser(Book book, User user);
    public List<Review> findAllByBook(Book book);
}
