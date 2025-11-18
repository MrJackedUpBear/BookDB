package win.servername.api.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import win.servername.api.repository.auth.RefreshTokenRepository;
import win.servername.api.repository.auth.UserRepository;
import win.servername.api.repository.auth.UserRoleRepository;
import win.servername.api.repository.permission.PermissionRepository;
import win.servername.api.repository.permission.RolePermissionRepository;
import win.servername.api.repository.permission.RoleRepository;
import win.servername.entity.auth.RefreshToken;
import win.servername.entity.auth.User;
import win.servername.entity.auth.UserRole;
import win.servername.entity.auth.UserRoleId;
import win.servername.entity.permission.Permission;
import win.servername.entity.permission.Role;
import win.servername.entity.permission.RolePermission;
import win.servername.entity.permission.RolePermissionId;

import java.util.Optional;

@Service
public class UserService {
    final UserRepository userRepository;
    final RefreshTokenRepository refreshTokenRepository;
    final UserRoleRepository userRoleRepository;
    final PermissionRepository permissionRepository;
    final RolePermissionRepository rolePermissionRepository;
    final RoleRepository roleRepository;

    @Autowired
    public UserService(UserRepository userRepository,
                       RefreshTokenRepository refreshTokenRepository,
                       UserRoleRepository userRoleRepository,
                       PermissionRepository permissionRepository,
                       RolePermissionRepository rolePermissionRepository,
                       RoleRepository roleRepository){
        this.userRepository = userRepository;
        this.refreshTokenRepository = refreshTokenRepository;
        this.userRoleRepository = userRoleRepository;
        this.permissionRepository = permissionRepository;
        this.rolePermissionRepository = rolePermissionRepository;
        this.roleRepository = roleRepository;
    }

    //Create
    public User saveUser(User user){
        return userRepository.save(user);
    }

    public RefreshToken saveRefreshToken(RefreshToken refreshToken){
        return refreshTokenRepository.save(refreshToken);
    }

    public UserRole saveUserRole(UserRole userRole){
        return userRoleRepository.save(userRole);
    }

    public Permission savePermission(Permission permission){
        return permissionRepository.save(permission);
    }

    public RolePermission saveRolePermission(RolePermission rolePermission){
        return rolePermissionRepository.save(rolePermission);
    }

    public Role saveRole(Role role){
        return roleRepository.save(role);
    }

    //Read
    public Optional<User> getUserById(long userId){
        return userRepository.findById(userId);
    }

    public Optional<RefreshToken> getRefreshTokenById(long refreshTokenId){
        return refreshTokenRepository.findById(refreshTokenId);
    }

    public Optional<UserRole> getUserRoleById(UserRoleId userRoleId){
        return userRoleRepository.findById((long) userRoleId.hashCode());
    }

    public Optional<Permission> getPermissionById(long permissionId){
        return permissionRepository.findById(permissionId);
    }

    public Optional<RolePermission> getRolePermissionById(RolePermissionId rolePermissionId){
        return rolePermissionRepository.findById((long) rolePermissionId.hashCode());
    }

    public Optional<Role> getRoleById(long roleId){
        return roleRepository.findById(roleId);
    }

    //Update
    public User updateUser(long userId, User updatedUser){
        Optional<User> optionalUser = userRepository.findById(userId);

        if (optionalUser.isPresent()){
            User user = optionalUser.get();

            user.setFirstName(updatedUser.getFirstName());
            user.setLastName(updatedUser.getLastName());
            user.setPassword(updatedUser.getPassword());
            user.setUsername(updatedUser.getUsername());
            user.setNumOwnedBooks(updatedUser.getNumOwnedBooks());

            return userRepository.save(user);
        }else{
            throw new RuntimeException("User not found");
        }
    }

    public RefreshToken updateRefreshToken(long refreshTokenId, RefreshToken updatedToken){
        Optional<RefreshToken> optionalRefreshToken = refreshTokenRepository.findById(refreshTokenId);

        if (optionalRefreshToken.isPresent()){
            refreshTokenRepository.deleteById(refreshTokenId);

            RefreshToken refreshToken = optionalRefreshToken.get();

            refreshToken.setRefreshToken(updatedToken.getRefreshToken());
            refreshToken.setUser(updatedToken.getUser());
            refreshToken.setDateProvisioned(updatedToken.getDateProvisioned());
            refreshToken.setExpiryDate(updatedToken.getExpiryDate());
            refreshToken.setLastUsed(updatedToken.getLastUsed());

            return refreshTokenRepository.save(refreshToken);
        }else{
            throw new RuntimeException("Refresh token not found");
        }
    }

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
    public void deleteUser(long userId){
        userRepository.deleteById(userId);
    }

    public void deleteRefreshToken(long refreshTokenId){
        refreshTokenRepository.deleteById(refreshTokenId);
    }

    public void deleteUserRole(UserRoleId userRoleId){
        userRoleRepository.deleteById((long)userRoleId.hashCode());
    }

    public void deletePermission(long permissionId) {
        permissionRepository.deleteById(permissionId);
    }

    public void deleteRolePermission(RolePermissionId rolePermissionId){
        rolePermissionRepository.deleteById((long) rolePermissionId.hashCode());
    }

    public void deleteRole(long roleId){
        roleRepository.deleteById(roleId);
    }
}
