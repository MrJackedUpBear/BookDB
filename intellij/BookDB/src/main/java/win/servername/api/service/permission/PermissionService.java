package win.servername.api.service.permission;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import win.servername.api.repository.permission.PermissionRepository;
import win.servername.entity.auth.User;
import win.servername.entity.permission.Permission;

import java.util.Optional;

@Service
public class PermissionService {
    final PermissionRepository permissionRepository;

    @Autowired
    public PermissionService(PermissionRepository permissionRepository){
        this.permissionRepository = permissionRepository;
    }

    //Create
    public Permission savePermission(Permission permission){
        return permissionRepository.save(permission);
    }

    //Read
    public Optional<Permission> getPermissionById(long permissionId){
        return permissionRepository.findById(permissionId);
    }

    //Update
    public Permission updatePermission(long permissionId, Permission updatedPermission){
        Optional<Permission> optionalPermission = permissionRepository.findById(permissionId);

        if (optionalPermission.isPresent()){
            Permission permission = optionalPermission.get();

            permission.setPermissionName(updatedPermission.getPermissionName());
            permission.setPermissionStatus(updatedPermission.getPermissionStatus());
            permission.setDescription(updatedPermission.getDescription());

            return permissionRepository.save(permission);
        }else{
            throw new RuntimeException("Permission not found");
        }
    }

    //Delete
    public void deletePermission(long permissionId){
        permissionRepository.deleteById(permissionId);
    }

    //Check Permissions
    /*
    boolean bookWritePermission(User user){

    }

    boolean bookReadPermission(User user){

    }

    boolean bookUpdatePermission(User user){

    }

    boolean bookDeletePermission(User user){

    }
     */
}
