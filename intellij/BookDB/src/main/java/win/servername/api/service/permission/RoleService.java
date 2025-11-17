package win.servername.api.service.permission;

import org.springframework.stereotype.Service;
import win.servername.api.repository.permission.RoleRepository;
import win.servername.entity.permission.Role;

import java.util.Optional;

@Service
public class RoleService {
    final RoleRepository roleRepository;

    public RoleService(RoleRepository roleRepository){
        this.roleRepository = roleRepository;
    }

    //Create
    public Role saveRole(Role role){
        return roleRepository.save(role);
    }

    //Read
    public Optional<Role> getRoleById(long roleId){
        return roleRepository.findById(roleId);
    }

    //Update
    public Role updateRole(long roleId, Role updatedRole){
        Optional<Role> optionalRole = roleRepository.findById(roleId);

        if (optionalRole.isPresent()){
            Role role = optionalRole.get();

            role.setRoleName(updatedRole.getRoleName());
            role.setRoleStatus(updatedRole.getRoleStatus());
            role.setDescription(updatedRole.getDescription());

            return roleRepository.save(role);
        }else{
            throw new RuntimeException("Role not found");
        }
    }

    //Delete
    public void deleteRole(long roleId){
        roleRepository.deleteById(roleId);
    }
}
