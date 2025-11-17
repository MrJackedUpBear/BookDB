package win.servername.api.repository.book;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import win.servername.entity.book.Review;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {

}
