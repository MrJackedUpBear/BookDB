package win.servername.entity.userDTO;

import java.util.List;

public class UserDTO {
    //User
    private String username;
    private String firstName;
    private String lastName;
    private int numOwnedBooks;

    //Permission
    private List<PermissionDTO> permissions;

    //May consolidate this into permission dto...
    //Role
    //private List<RoleDTO> roles;

    public String getUsername(){return username;}
    public String getFirstName(){return firstName;}
    public String getLastName(){return lastName;}
    public int getNumOwnedBooks(){return numOwnedBooks;}
    public List<PermissionDTO> getPermissions(){return permissions;}
    //public List<RoleDTO> getRoles(){return roles;}

    public void setUsername(String username){this.username = username;}
    public void setFirstName(String firstName){this.firstName = firstName;}
    public void setLastName(String lastName){this.lastName = lastName;}
    public void setNumOwnedBooks(int numOwnedBooks){this.numOwnedBooks = numOwnedBooks;}
    public void setPermissions(List<PermissionDTO> permissions){this.permissions = permissions;}
    //public void setRoles(List<RoleDTO> roles){this.roles = roles;}
}
