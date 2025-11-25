package win.servername.api.controller;

import jakarta.transaction.Transactional;
import win.servername.api.service.BookService;
import win.servername.entity.bookDTO.BookDTO;
import win.servername.entity.bookDTO.ReviewDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;

import static win.servername.Constants.API_MAPPING;

@RestController
@RequestMapping(API_MAPPING)
public class BookController {
    private final BookService bookService;

    @Autowired
    public BookController(BookService bookService){
        this.bookService = bookService;
    }

    //Create
    @PostMapping("/elevateduser/book")
    public ResponseEntity<BookDTO> saveBook(@RequestBody BookDTO book){
        BookDTO newBook = bookService.saveBook(book);
        return ResponseEntity.ok(newBook);
    }

    @PostMapping("/review")
    public ResponseEntity<ReviewDTO> saveReview(@RequestBody ReviewDTO review){
        ReviewDTO newReview = bookService.saveReview(review);
        return ResponseEntity.ok(newReview);
    }

    //Read
    @GetMapping("/books")
    public ResponseEntity<HashMap<String, Object>> getBooks(){
        List<BookDTO> books = bookService.getBooks();

        HashMap<String, Object> output = new HashMap<>();

        output.put("count", books.size());
        output.put("books", books);

        return ResponseEntity.ok(output);
    }

    @GetMapping("/isbn/{isbn}")
    public ResponseEntity<BookDTO> getBookByIsbn(@PathVariable String isbn){
        BookDTO book = bookService.getBookByIsbn(isbn);
        return ResponseEntity.ok(book);
    }

    //Delete
    @Transactional
    @DeleteMapping("/admin/book")
    public ResponseEntity<String> deleteBook(@RequestBody BookDTO bookDTO){
        bookService.deleteBook(bookDTO);

        return ResponseEntity.ok("Success!");
    }

    @Transactional
    @DeleteMapping("/admin/review")
    public ResponseEntity<String> deleteReview(@RequestBody ReviewDTO reviewDTO){
        bookService.deleteReview(reviewDTO);

        return ResponseEntity.ok("Success!");
    }
}
