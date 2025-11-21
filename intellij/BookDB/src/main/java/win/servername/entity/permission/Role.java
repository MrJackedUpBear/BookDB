package win.servername.entity.permission;

import jakarta.persistence.*;

import static win.servername.Constants.NAME_LENGTH;
import static win.servername.Constants.STATUS_LENGTH;

@Entity()
@Table(name = "Role")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long roleId;

    @Column(nullable = false, length = NAME_LENGTH, unique = true)
    private String roleName;

    @Column(nullable = false, length = STATUS_LENGTH)
    private String roleStatus;

    @Column(nullable = false)
    private String description;

    public long getRoleId(){return roleId;}
    public String getRoleName(){return roleName;}
    public String getRoleStatus(){return roleStatus;}
    public String getDescription(){return description;}

    public void setRoleId(long roleId){this.roleId = roleId;}
    public void setRoleName(String roleName){this.roleName = roleName;}
    public void setRoleStatus(String roleStatus){this.roleStatus = roleStatus;}
    public void setDescription(String description){this.description = description;}
}
