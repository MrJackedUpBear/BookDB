package win.servername.api.service.book;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import win.servername.api.repository.book.ReviewRepository;
import win.servername.entity.book.Review;

import java.util.Optional;

@Service
public class ReviewService {
    private final ReviewRepository reviewRepository;

    @Autowired
    public ReviewService(ReviewRepository reviewRepository){
        this.reviewRepository = reviewRepository;
    }

    //Create
    public Review saveReview(Review review){
        return reviewRepository.save(review);
    }

    //Read
    public Optional<Review> getReview(long reviewId){
        return reviewRepository.findById(reviewId);
    }

    //Update
    public Review updateReview(long reviewId, Review updatedReview){
        Optional<Review> reviewOptional = reviewRepository.findById(reviewId);

        if (reviewOptional.isPresent()){
            Review review = reviewOptional.get();

            review.setBook(updatedReview.getBook());
            review.setUser(updatedReview.getUser());
            review.setDescription(updatedReview.getDescription());
            review.setRating(updatedReview.getRating());
            review.setTitle(updatedReview.getTitle());
            return reviewRepository.save(review);
        }else{
            throw new RuntimeException("Review not found");
        }
    }

    //Delete
    public void deleteReview(long reviewId){
        reviewRepository.deleteById(reviewId);
    }
}
