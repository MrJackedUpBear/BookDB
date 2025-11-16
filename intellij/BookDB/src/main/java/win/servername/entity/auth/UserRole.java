package win.servername.entity.auth;

import jakarta.persistence.*;
import win.servername.entity.permission.Role;

import java.util.Date;

@Entity
@Table(name = "UserRole")
public class UserRole {
    @EmbeddedId
    private UserRoleId userRoleId;

    @Column(nullable = false)
    private Date dateProvisioned;

    @Column(nullable = false)
    private String description;

    public UserRoleId getUserRoleId(){return userRoleId;}
    public Date getDateProvisioned(){return dateProvisioned;}
    public String getDescription(){return description;}

    public void setUserRoleId(UserRoleId userRoleId){this.userRoleId = userRoleId;}
    public void setDateProvisioned(Date dateProvisioned){this.dateProvisioned = dateProvisioned;}
    public void setDescription(String description){this.description = description;}
}