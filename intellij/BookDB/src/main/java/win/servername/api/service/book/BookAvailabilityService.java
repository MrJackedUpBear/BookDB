package win.servername.api.service.book;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import win.servername.api.repository.book.BookAvailabilityRepository;
import win.servername.entity.book.Book;
import win.servername.entity.book.BookAvailability;
import win.servername.entity.book.BookAvailabilityId;
import win.servername.entity.auth.User;

import java.util.List;
import java.util.Optional;

@Service
public class BookAvailabilityService {
    private final BookAvailabilityRepository bookAvailabilityRepository;

    @Autowired
    public BookAvailabilityService(BookAvailabilityRepository bookAvailabilityRepository){
        this.bookAvailabilityRepository = bookAvailabilityRepository;
    }

   //Create
    public BookAvailability saveBookAvailability(BookAvailability bookAvailability){
        return bookAvailabilityRepository.save(bookAvailability);
    }

    //Read
    public Optional<BookAvailability> getAvailabilityByBookAvailabilityId(BookAvailabilityId bookAvailabilityId){
        return bookAvailabilityRepository.findById((long) bookAvailabilityId.hashCode());
    }

    //Update
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
    public void deleteBookAvailability(BookAvailabilityId bookAvailabilityId){
        bookAvailabilityRepository.deleteById((long) bookAvailabilityId.hashCode());
    }
}
