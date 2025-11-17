package win.servername.api.service.auth;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import win.servername.api.repository.auth.UserRoleRepository;
import win.servername.entity.auth.UserRole;
import win.servername.entity.auth.UserRoleId;

import java.util.Optional;

@Service
public class UserRoleService {
    final UserRoleRepository userRoleRepository;

    @Autowired
    public UserRoleService(UserRoleRepository userRoleRepository){
        this.userRoleRepository = userRoleRepository;
    }

    //Create
    public UserRole saveUserRole(UserRole userRole){
        return userRoleRepository.save(userRole);
    }

    //Read
    public Optional<UserRole> getUserRoleById(UserRoleId userRoleId){
        return userRoleRepository.findById((long) userRoleId.hashCode());
    }

    //Update
    public UserRole updateUserRole(UserRoleId userRoleId, UserRole updatedUserRole){
        Optional<UserRole> optionalUserRole = userRoleRepository.findById((long)userRoleId.hashCode());

        if (optionalUserRole.isPresent()){
            UserRole userRole = optionalUserRole.get();

            userRole.setDescription(updatedUserRole.getDescription());
            userRole.setDateProvisioned(updatedUserRole.getDateProvisioned());

            return userRoleRepository.save(userRole);
        }else{
            throw new RuntimeException("User role not found");
        }
    }

    //Delete
    public void deleteUserRole(UserRoleId userRoleId){
        userRoleRepository.deleteById((long)userRoleId.hashCode());
    }
}
