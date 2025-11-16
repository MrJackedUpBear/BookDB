package win.servername.entity.permission;

import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class RolePermissionId implements Serializable {
    @ManyToOne
    @JoinColumn(name="RoleId")
    private Role role;

    @ManyToOne
    @JoinColumn(name="PermissionId")
    private Permission permission;

    public Role getRole(){return role;}
    public Permission getPermission(){return permission;}

    public void setRole(Role role){this.role = role;}
    public void setPermission(Permission permission){this.permission = permission;}

    @Override
    public boolean equals(Object o){
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        RolePermissionId that = (RolePermissionId) o;
        return Objects.equals(role, that.role) &&
                Objects.equals(permission, that.permission);
    }

    @Override
    public int hashCode(){
        return Objects.hash(role, permission);
    }
}
