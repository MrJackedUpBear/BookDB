package win.servername.api.repository.permission;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import win.servername.entity.permission.RolePermission;

@Repository
public interface RolePermissionRepository extends JpaRepository<RolePermission, Long> {

}
