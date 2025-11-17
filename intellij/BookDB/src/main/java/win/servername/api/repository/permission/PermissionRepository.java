package win.servername.api.repository.permission;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import win.servername.entity.permission.Permission;

@Repository
public interface PermissionRepository extends JpaRepository<Permission, Long> {

}
