package win.servername.entity.userDTO;

public class RoleDTO {
    private String roleName;
    private String roleStatus;
    private String description;

    public String getRoleName(){return roleName;}
    public String getRoleStatus(){return roleStatus;}
    public String getDescription(){return description;}

    public void setRoleName(String roleName){this.roleName = roleName;}
    public void setRoleStatus(String roleStatus){this.roleStatus = roleStatus;}
    public void setDescription(String description){this.description = description;}
}
