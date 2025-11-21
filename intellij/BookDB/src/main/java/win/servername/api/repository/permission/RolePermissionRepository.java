package win.servername.api.repository.permission;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import win.servername.entity.permission.Permission;
import win.servername.entity.permission.Role;
import win.servername.entity.permission.RolePermission;

import java.util.List;

@Repository
public interface RolePermissionRepository extends JpaRepository<RolePermission, Long> {
    public List<Permission> findAllByRolePermissionId_Role(Role role);
}
