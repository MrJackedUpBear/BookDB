package win.servername.api.service;

import win.servername.api.repository.BookRepository;
import win.servername.entity.Book;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class BookService {
    private final BookRepository bookRepository;

    @Autowired
    public BookService(BookRepository bookRepository){
        this.bookRepository = bookRepository;
    }

    public Book saveBook(Book book){
        return bookRepository.save(book);
    }

    public List<Book> getBooks(){
        return bookRepository.findAll();
    }

    public Optional<Book> getBookById(long bookId){
        return bookRepository.findById(bookId);
    }

    public Optional<Book> getBookByIsbn(String isbn){
        return bookRepository.findByIsbn(isbn);
    }

    public Book updateBook(long bookId, Book updatedBook){
        Optional<Book> existingBook = bookRepository.findById(bookId);

        if (existingBook.isPresent()){
            Book book = existingBook.get();

            book.setAuthor(updatedBook.getAuthor());
            book.setDescription(updatedBook.getDescription());
            book.setIsbn(updatedBook.getIsbn());
            book.setLanguage(updatedBook.getLanguage());
            book.setImageLoc(updatedBook.getImageLoc());
            book.setPublisher(updatedBook.getPublisher());
            book.setPublishDate(updatedBook.getPublishDate());
            return bookRepository.save(book);
        }else{
            throw new RuntimeException("Book not found");
        }
    }

    public void deleteBook(long bookId){
        bookRepository.deleteById(bookId);
    }
}
