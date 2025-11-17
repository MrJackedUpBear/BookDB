package win.servername.api.repository.auth;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import win.servername.entity.auth.UserRole;

@Repository
public interface UserRoleRepository extends JpaRepository<UserRole, Long> {

}
