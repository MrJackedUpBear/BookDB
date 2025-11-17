package win.servername.api.service.auth;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import win.servername.api.repository.auth.UserRepository;
import win.servername.entity.auth.User;

import java.util.Optional;

@Service
public class UserService {
    final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository){
        this.userRepository = userRepository;
    }

    //Create
    public User saveUser(User user){
        return userRepository.save(user);
    }

    //Read
    public Optional<User> getUserById(long userId){
        return userRepository.findById(userId);
    }

    //Update
    public User updateUser(long userId, User updatedUser){
        Optional<User> optionalUser = userRepository.findById(userId);

        if (optionalUser.isPresent()){
            User user = optionalUser.get();

            user.setFirstName(updatedUser.getFirstName());
            user.setLastName(updatedUser.getLastName());
            user.setPassword(updatedUser.getPassword());
            user.setUsername(updatedUser.getUsername());
            user.setNumOwnedBooks(updatedUser.getNumOwnedBooks());

            return userRepository.save(user);
        }else{
            throw new RuntimeException("User not found");
        }
    }
    //Delete
    public void deleteUser(long userId){
        userRepository.deleteById(userId);
    }
}
