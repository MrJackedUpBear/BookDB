package win.servername.entity.auth;

import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import win.servername.entity.permission.Role;
import win.servername.entity.permission.RolePermissionId;

import java.util.Objects;

@Embeddable
public class UserRoleId{
    @ManyToOne
    @JoinColumn(name = "RoleId")
    private Role role;
    
    @ManyToOne
    @JoinColumn(name = "UserId")
    private User user;

    public Role getRole(){return role;}
    public User getUser(){return user;}

    public void setRole(Role role){this.role = role;}
    public void setUser(User user){this.user = user;}

    @Override
    public boolean equals(Object o){
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserRoleId that = (UserRoleId) o;
        return Objects.equals(role, that.role) &&
                Objects.equals(user, that.user);
    }

    @Override
    public int hashCode(){
        return Objects.hash(role, user);
    }
}
