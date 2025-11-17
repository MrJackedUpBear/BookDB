package win.servername.api.repository.auth;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import win.servername.entity.auth.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

}
