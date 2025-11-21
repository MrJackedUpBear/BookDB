package win.servername.api.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
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
import win.servername.entity.userDTO.PermissionDTO;
import win.servername.entity.userDTO.RoleDTO;
import win.servername.entity.userDTO.UserDTO;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;

import static win.servername.Constants.*;

@Service
public class UserService implements UserDetailsService {
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
    //User
    public User saveUser(User user){
        return userRepository.save(user);
    }

    public int login(String username, byte[] password){
        Optional<User> optionalUser = userRepository.findByUsername(username);

        if (optionalUser.isEmpty()){
            return INCORRECT_USERNAME;
        }

        User user = optionalUser.get();

        if (Arrays.equals(password, user.getPassword())){
            return SUCCESSFUL_LOGIN;
        }else{
            return INCORRECT_PASSWORD;
        }
    }

    //Refresh Token
    public RefreshToken saveRefreshToken(RefreshToken refreshToken){
        return refreshTokenRepository.save(refreshToken);
    }

    //User Role
    public UserRole saveUserRole(UserRole userRole){
        return userRoleRepository.save(userRole);
    }

    //Permission
    public Permission savePermission(Permission permission){
        return permissionRepository.save(permission);
    }

    //Role Permission
    public RolePermission saveRolePermission(RolePermission rolePermission){
        return rolePermissionRepository.save(rolePermission);
    }

    //Role
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

    public RefreshToken getRefreshToken(String username){
        RefreshToken refreshToken = new RefreshToken();

        Optional<User> optionalUser = userRepository.findByUsername(username);

        if (optionalUser.isEmpty()){
            return refreshToken;
        }

        User user = optionalUser.get();

        refreshToken.setRefreshToken(generateRefreshToken());
        refreshToken.setUser(user);
        refreshToken.setDateProvisioned(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        refreshToken.setExpiryDate(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).plusMonths(6).toInstant()));
        refreshToken.setLastUsed(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));

        return refreshTokenRepository.save(refreshToken);
    }

    public User verifyRefreshToken(String token){
        Optional<RefreshToken> optionalRefreshToken= refreshTokenRepository.findByRefreshToken(token);
        User user = null;

        if (optionalRefreshToken.isEmpty()){
            return user;
        }

        RefreshToken refreshToken = optionalRefreshToken.get();

        Optional<User> optionalUser = userRepository.findById(refreshToken.getUser().getUserId());

        if (optionalUser.isEmpty()){
            return user;
        }

        user = optionalUser.get();

        return user;
    }

    String generateRefreshToken(){
        UUID uuid = UUID.randomUUID();

        return uuid.toString();
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Optional<User> optionalUser = userRepository.findByUsername(username);

        if (optionalUser.isEmpty()){
            throw new UsernameNotFoundException("Invalid username.");
        }

        User user = optionalUser.get();

        List<String> permissions = new ArrayList<>();

        List<RoleDTO> roles = getUserRoles(user);

        Set<PermissionDTO> permissionDTOS = getUserPermissions(roles);

        for (PermissionDTO permission : permissionDTOS){
            permissions.add(permission.getPermissionName());
        }

        return new UserInfoDetails(user, permissions);
    }

    UserDTO convertUser(User user){
        UserDTO userDTO = new UserDTO();

        userDTO.setFirstName(user.getFirstName());
        userDTO.setLastName(user.getLastName());
        userDTO.setNumOwnedBooks(user.getNumOwnedBooks());
        userDTO.setUsername(user.getUsername());

        List<RoleDTO> roles = getUserRoles(user);
        Set<PermissionDTO> permissions = getUserPermissions(roles);

        userDTO.setPermissions(permissions);
        userDTO.setRoles(roles);

        return userDTO;
    }

    List<RoleDTO> getUserRoles(User user){
        List<RoleDTO> roles = new ArrayList<>();

        List<UserRole> userRoles = userRoleRepository.findByUserRoleId_User(user);

        for (UserRole userRole: userRoles){
            RoleDTO roleDTO = new RoleDTO();

            Optional<Role> optionalRole = roleRepository.findById(userRole.getUserRoleId().getRole().getRoleId());

            if (optionalRole.isPresent()){
                Role role = optionalRole.get();

                roleDTO.setRoleName(role.getRoleName());
                roleDTO.setRoleStatus(role.getRoleStatus());
                roleDTO.setDescription(role.getDescription());
                roles.add(roleDTO);
            }
        }

        return roles;
    }

    Set<PermissionDTO> getUserPermissions(List<RoleDTO> roles){
        Set<PermissionDTO> permissions = new HashSet<>();

        for (RoleDTO roleDTO : roles){
            Optional<Role> optionalRole = roleRepository.findRoleByRoleName(roleDTO.getRoleName());

            if (optionalRole.isPresent()){
                Role role = optionalRole.get();

                List<Permission> perms = rolePermissionRepository.findAllByRolePermissionId_Role(role);

                for (Permission perm : perms){
                    PermissionDTO permission = new PermissionDTO();

                    permission.setDescription(perm.getDescription());
                    permission.setPermissionName(perm.getPermissionName());
                    permission.setPermissionStatus(perm.getPermissionStatus());

                    permissions.add(permission);
                }
            }
        }

        return permissions;
    }
}
