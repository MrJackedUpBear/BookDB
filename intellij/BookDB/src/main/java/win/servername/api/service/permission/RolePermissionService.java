package win.servername.api.service.permission;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import win.servername.api.repository.permission.RolePermissionRepository;
import win.servername.entity.permission.RolePermission;
import win.servername.entity.permission.RolePermissionId;

import java.util.Optional;

@Service
public class RolePermissionService {
    final RolePermissionRepository rolePermissionRepository;

    @Autowired
    public RolePermissionService(RolePermissionRepository rolePermissionRepository){
        this.rolePermissionRepository = rolePermissionRepository;
    }

    //Create
    public RolePermission saveRolePermission(RolePermission rolePermission){
        return rolePermissionRepository.save(rolePermission);
    }

    //Read
    public Optional<RolePermission> getRolePermissionById(RolePermissionId rolePermissionId){
        return rolePermissionRepository.findById((long) rolePermissionId.hashCode());
    }

    //Update
    public RolePermission updateRolePermission(RolePermissionId rolePermissionId, RolePermission updatedRolePermission){
        Optional<RolePermission> optionalRolePermission = rolePermissionRepository.findById((long) rolePermissionId.hashCode());

        if (optionalRolePermission.isPresent()){
            RolePermission rolePermission = optionalRolePermission.get();

            rolePermission.setDescription(updatedRolePermission.getDescription());
            rolePermission.setDateProvisioned(updatedRolePermission.getDateProvisioned());

            return rolePermissionRepository.save(rolePermission);
        }else{
            throw new RuntimeException("Role permission not found");
        }
    }

    //Delete
    public void deleteRolePermission(RolePermissionId rolePermissionId){
        rolePermissionRepository.deleteById((long) rolePermissionId.hashCode());
    }
}
