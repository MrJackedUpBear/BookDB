package win.servername.api.controller;

import win.servername.api.service.book.BookAvailabilityService;
import win.servername.api.service.book.BookService;
import win.servername.api.service.book.ReviewService;
import win.servername.entity.book.Book;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import win.servername.entity.book.Review;

import java.util.HashMap;
import java.util.List;
import java.util.Optional;

import static win.servername.Constants.API_MAPPING;

@RestController
@RequestMapping(API_MAPPING)
public class BookController {
    private final BookService bookService;
    //private final BookAvailabilityService bookAvailabilityService;
    private final ReviewService reviewService;

    @Autowired
    public BookController(
            BookService bookService,
            //BookAvailabilityService bookAvailabilityService,
            ReviewService reviewService){
        this.bookService = bookService;
        //this.bookAvailabilityService = bookAvailabilityService;
        this.reviewService = reviewService;
    }

    @PostMapping("/book")
    public ResponseEntity<Book> saveBook(@RequestBody Book book){
        Book newBook = bookService.saveBook(book);
        return ResponseEntity.ok(newBook);
    }

    @PostMapping("/review")
    public ResponseEntity<Review> saveReview(@RequestBody Review review){
        Review newReview = reviewService.saveReview(review);
        return ResponseEntity.ok(newReview);
    }

    @GetMapping("/books")
    public ResponseEntity<HashMap<String, Object>> getBooks(){
        List<Book> books = bookService.getBooks();

        HashMap<String, Object> output = new HashMap<>();

        output.put("count", books.size());
        output.put("books", books);

        return ResponseEntity.ok(output);
    }

    @GetMapping("/reviews")
    public ResponseEntity<List<Review>> getReviews(@RequestBody Book book){
        return ResponseEntity.ok(reviewService.getReviewsByBook(book));
    }

    @GetMapping("/id/{bookId}")
    public ResponseEntity<Book> getBookByBookId(@PathVariable long bookId){
        Optional<Book> book = bookService.getBookById(bookId);
        return book.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/isbn/{isbn}")
    public ResponseEntity<Book> getBookByIsbn(@PathVariable String isbn){
        Optional<Book> book = bookService.getBookByIsbn(isbn);
        return book.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }
}
