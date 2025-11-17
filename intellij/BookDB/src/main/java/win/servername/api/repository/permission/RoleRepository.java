package win.servername.api.repository.permission;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import win.servername.entity.permission.Role;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {

}
