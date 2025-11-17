package win.servername.api.controller;

import win.servername.api.service.book.BookService;
import win.servername.entity.book.Book;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/v1/book")
public class BookController {
    private final BookService bookService;

    @Autowired
    public BookController(BookService bookService){
        this.bookService = bookService;
    }

    @PostMapping("/add")
    public ResponseEntity<Book> saveBook(@RequestBody Book book){
        Book newBook = bookService.saveBook(book);
        return ResponseEntity.ok(newBook);
    }

    @GetMapping("/books")
    public ResponseEntity<HashMap<String, Object>> getBooks(){
        List<Book> books = bookService.getBooks();

        HashMap<String, Object> output = new HashMap<>();

        output.put("count", books.size());
        output.put("books", books);

        return ResponseEntity.ok(output);
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
