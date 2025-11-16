package win.servername.entity.permission;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name="RolePermission")
public class RolePermission {
    //Composite Primary Key...
    @EmbeddedId
    private RolePermissionId rolePermissionId;

    @Column(nullable = false)
    private Date dateProvisioned;

    @Column(nullable = false)
    private String description;

    //Getters
    public RolePermissionId getRolePermissionId() {return rolePermissionId;}
    public Date getDateProvisioned(){return dateProvisioned;}
    public String getDescription(){return description;}

    //Setters
    public void setRolePermissionId(RolePermissionId rolePermissionId){this.rolePermissionId = rolePermissionId;}
    public void setDateProvisioned(Date dateProvisioned){this.dateProvisioned = dateProvisioned;}
    public void setDescription(String description){this.description = description;}
}