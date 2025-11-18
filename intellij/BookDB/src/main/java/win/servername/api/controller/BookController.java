package win.servername.api.controller;

import win.servername.api.service.BookService;
import win.servername.entity.bookDTO.BookDTO;
import win.servername.entity.bookDTO.ReviewDTO;
import win.servername.entity.bookDTO.UserDTO_ForBook;
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

    @Autowired
    public BookController(BookService bookService){
        this.bookService = bookService;
    }

    //Create
    @PostMapping("/book")
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
    public ResponseEntity<HashMap<String, Object>> getBooks(@RequestBody UserDTO_ForBook user){
        List<BookDTO> books = bookService.getBooks(user);

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

    boolean verifyLogin(UserDTO_ForBook userDTOForBook){
        return true;
    }
}
