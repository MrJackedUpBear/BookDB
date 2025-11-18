package win.servername.api.service;

import win.servername.api.repository.auth.UserRepository;
import win.servername.api.repository.book.BookAvailabilityRepository;
import win.servername.api.repository.book.BookRepository;
import win.servername.api.repository.book.ReviewRepository;
import win.servername.entity.bookDTO.BookAvailabilityDTO;
import win.servername.entity.bookDTO.BookDTO;
import win.servername.entity.bookDTO.ReviewDTO;
import win.servername.entity.bookDTO.UserDTO_ForBook;
import win.servername.entity.auth.User;
import win.servername.entity.book.Book;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import win.servername.entity.book.BookAvailability;
import win.servername.entity.book.BookAvailabilityId;
import win.servername.entity.book.Review;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static win.servername.Constants.AVAILABLE;

@Service
public class BookService {
    private final BookRepository bookRepository;
    private final ReviewRepository reviewRepository;
    private final UserRepository userRepository;
    private final BookAvailabilityRepository bookAvailabilityRepository;

    @Autowired
    public BookService(BookRepository bookRepository,
                       ReviewRepository reviewRepository,
                       UserRepository userRepository,
                       BookAvailabilityRepository bookAvailabilityRepository){
        this.bookRepository = bookRepository;
        this.reviewRepository = reviewRepository;
        this.userRepository = userRepository;
        this.bookAvailabilityRepository = bookAvailabilityRepository;
    }

    //Create
    public BookDTO saveBook(BookDTO bookDTOInput){
        Optional<Book> optionalBook = bookRepository.findByIsbn(bookDTOInput.getIsbn());

        UserDTO_ForBook userDTOForBook = bookDTOInput.getBookAvailability().getFirst().getUser();

        Optional<User> optionalUser = userRepository.findByUsername(userDTOForBook.getUsername());

        if (optionalUser.isEmpty()){
            throw new RuntimeException("User not found");
        }

        User user = optionalUser.get();

        user.setNumOwnedBooks(user.getNumOwnedBooks() + 1);
        userRepository.save(user);

        if (optionalBook.isEmpty()){
            Book book = bookRepository.save(convertBookDTO(bookDTOInput));

            BookAvailability bookAvailability = new BookAvailability();
            BookAvailabilityId bookAvailabilityId = new BookAvailabilityId();

            bookAvailabilityId.setBook(book);
            bookAvailabilityId.setUser(user);
            bookAvailabilityId.setCount(1);

            bookAvailability.setBookAvailabilityId(bookAvailabilityId);
            bookAvailability.setAvailability(AVAILABLE);

            bookAvailabilityRepository.save(bookAvailability);

            BookAvailabilityDTO bookAvailabilityDTO = convertBookAvailabilityDTO(bookAvailability);

            List<BookAvailabilityDTO> bookAvailabilityDTOS = List.of(bookAvailabilityDTO);

            BookDTO bookDTO = convertBook(book);

            bookDTO.setBookAvailability(bookAvailabilityDTOS);

            return bookDTO;
        }

        Book book = optionalBook.get();

        List<BookAvailability> bookAvailabilities = bookAvailabilityRepository.findByBookAvailabilityId_UserAndBookAvailabilityIdBook(user, book);

        BookAvailability bookAvailability = new BookAvailability();
        BookAvailabilityId bookAvailabilityId = new BookAvailabilityId();

        bookAvailabilityId.setBook(book);
        bookAvailabilityId.setUser(user);
        bookAvailabilityId.setCount(bookAvailabilities.size() + 1);

        bookAvailability.setBookAvailabilityId(bookAvailabilityId);
        bookAvailability.setAvailability(AVAILABLE);

        bookAvailabilityRepository.save(bookAvailability);

        BookAvailabilityDTO bookAvailabilityDTO = convertBookAvailabilityDTO(bookAvailability);

        List<BookAvailabilityDTO> bookAvailabilityDTOS = new ArrayList<>();

        for (BookAvailability b : bookAvailabilities){
            bookAvailabilityDTOS.add(convertBookAvailabilityDTO(b));
        }

        bookAvailabilityDTOS.add(bookAvailabilityDTO);

        bookDTOInput.setBookAvailability(bookAvailabilityDTOS);

        return bookDTOInput;
    }

    public ReviewDTO saveReview(ReviewDTO review){
        return convertReview(reviewRepository.save(convertReviewDTO(review)));
    }

    public BookAvailability saveBookAvailability(BookAvailability bookAvailability){
        return bookAvailabilityRepository.save(bookAvailability);
    }

    //Read
    public List<BookDTO> getBooks(UserDTO_ForBook userDTOForBook){
        Optional<User> optionalUser = userRepository.findByUsername(userDTOForBook.getUsername());

        if (optionalUser.isEmpty()){
            throw new RuntimeException("User not found");
        }

        User user = optionalUser.get();

        List<Book> books = bookRepository.findAll();
        List<BookDTO> bookDTOS = new ArrayList<>();

        for (Book b : books){
            BookDTO bookDTO = convertBook(b);

            List<BookAvailability> bookAvailabilities = bookAvailabilityRepository.findByBookAvailabilityId_UserAndBookAvailabilityIdBook(user, b);
            List<BookAvailabilityDTO> bookAvailabilityDTOS = new ArrayList<>();

            for (BookAvailability ba : bookAvailabilities){
                bookAvailabilityDTOS.add(convertBookAvailabilityDTO(ba));
            }

            bookDTO.setBookAvailability(bookAvailabilityDTOS);
            bookDTOS.add(bookDTO);
        }

        return bookDTOS;
    }

    public Optional<Book> getBookById(long bookId){
        return bookRepository.findById(bookId);
    }

    public BookDTO getBookByIsbn(String isbn){
        Optional<Book> optionalBook = bookRepository.findByIsbn(isbn);
        BookDTO book = new BookDTO();

        if (optionalBook.isPresent()){
            book = convertBook(optionalBook.get());
        }

        return book;
    }

    public Optional<Review> getReviewWithUserAndBook(UserDTO_ForBook userDTOForBook, BookDTO bookDTO){
        Book book = convertBookDTO(bookDTO);
        User user = convertUserDTO(userDTOForBook);

        return reviewRepository.findByBookAndUser(book, user);
    }

    public Optional<Review> getReview(long reviewId){
        return reviewRepository.findById(reviewId);
    }

    public Optional<BookAvailability> getAvailabilityByBookAvailabilityId(BookAvailabilityId bookAvailabilityId){
        return bookAvailabilityRepository.findById((long) bookAvailabilityId.hashCode());
    }

    //Update
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

    public BookAvailability updateBookAvailability(BookAvailabilityId bookAvailabilityId, BookAvailability replacementAvailability){
        Optional<BookAvailability> bookAvailabilityOptional = bookAvailabilityRepository.findById((long) bookAvailabilityId.hashCode());
        if (bookAvailabilityOptional.isPresent()){
            BookAvailability bookAvailability = bookAvailabilityOptional.get();
            bookAvailability.setAvailability(replacementAvailability.getAvailability());
            return bookAvailabilityRepository.save(bookAvailability);
        }else{
            throw new RuntimeException("Availability not found");
        }
    }

    //Delete
    public void deleteBook(long bookId){
        bookRepository.deleteById(bookId);
    }

    public void deleteReview(long reviewId){
        reviewRepository.deleteById(reviewId);
    }

    public void deleteBookAvailability(BookAvailabilityId bookAvailabilityId){
        bookAvailabilityRepository.deleteById((long) bookAvailabilityId.hashCode());
    }

    //Converter methods
    User convertUserDTO(UserDTO_ForBook userDTOForBook){
        Optional<User> optionalUser = userRepository.findByUsername(userDTOForBook.getUsername());

        if (optionalUser.isPresent()){
            return optionalUser.get();
        }else{
            throw new RuntimeException("User not found");
        }
    }

    UserDTO_ForBook convertUser(User user){
        UserDTO_ForBook userDTOForBook = new UserDTO_ForBook();

        userDTOForBook.setUsername(user.getUsername());
        userDTOForBook.setNumOwnedBooks(user.getNumOwnedBooks());
        userDTOForBook.setLastName(user.getLastName());
        userDTOForBook.setFirstName(user.getFirstName());

        return userDTOForBook;
    }

    BookAvailabilityDTO convertBookAvailabilityDTO(BookAvailability bookAvailability){
        BookAvailabilityDTO bookAvailabilityDTO = new BookAvailabilityDTO();

        UserDTO_ForBook userDTOForBook = new UserDTO_ForBook();
        User user = bookAvailability.getBookAvailabilityId().getUser();

        userDTOForBook.setFirstName(user.getFirstName());
        userDTOForBook.setLastName(user.getLastName());
        userDTOForBook.setNumOwnedBooks(user.getNumOwnedBooks());
        userDTOForBook.setUsername(user.getUsername());

        bookAvailabilityDTO.setUser(userDTOForBook);
        bookAvailabilityDTO.setAvailability(bookAvailability.getAvailability());
        bookAvailabilityDTO.setCount(bookAvailability.getBookAvailabilityId().getCount());

        return bookAvailabilityDTO;
    }

    Book convertBookDTO(BookDTO bookDTO){
        Optional<Book> optionalBook = bookRepository.findByIsbn(bookDTO.getIsbn());

        if (optionalBook.isPresent()){
            return optionalBook.get();
        }

        Book book = new Book();

        book.setAuthor(bookDTO.getAuthor());
        book.setIsbn(bookDTO.getIsbn());
        book.setDescription(bookDTO.getDescription());
        book.setImageLoc(bookDTO.getImageLoc());
        book.setPublishDate(bookDTO.getPublishDate());
        book.setPublisher(bookDTO.getPublisher());
        book.setTitle(bookDTO.getTitle());
        book.setLanguage(bookDTO.getLanguage());

        return book;
    }

    BookDTO convertBook(Book book){
        BookDTO bookDTO = new BookDTO();

        bookDTO.setDescription(book.getDescription());
        bookDTO.setAuthor(book.getAuthor());
        bookDTO.setIsbn(book.getIsbn());
        bookDTO.setLanguage(book.getLanguage());
        bookDTO.setPublisher(book.getPublisher());
        bookDTO.setTitle(book.getTitle());
        bookDTO.setImageLoc(book.getImageLoc());
        bookDTO.setPublishDate(book.getPublishDate());

        return bookDTO;
    }

    Review convertReviewDTO(ReviewDTO reviewDTO){
        Review review = new Review();

        review.setBook(convertBookDTO(reviewDTO.getBook()));
        review.setRating(reviewDTO.getRating());
        review.setUser(convertUserDTO(reviewDTO.getUser()));
        review.setTitle(reviewDTO.getTitle());
        review.setDescription(reviewDTO.getDescription());

        return review;
    }

    ReviewDTO convertReview(Review review){
        ReviewDTO reviewDTO = new ReviewDTO();

        reviewDTO.setBook(convertBook(review.getBook()));
        reviewDTO.setDescription(review.getDescription());
        reviewDTO.setRating(review.getRating());
        reviewDTO.setTitle(review.getTitle());
        reviewDTO.setUser(convertUser(review.getUser()));

        return reviewDTO;
    }
}
