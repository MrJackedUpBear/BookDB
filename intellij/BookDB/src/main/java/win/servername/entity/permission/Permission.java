package win.servername.entity.permission;

import jakarta.persistence.*;

import static win.servername.Constants.*;

@Entity
@Table(name="Permission")
public class Permission {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long permissionId;

    @Column(nullable = false, length = TITLE_LENGTH)
    private String permissionName;

    @Column(nullable = false, length = STATUS_LENGTH)
    private String permissionStatus;

    @Column()
    private String description;

    public long getPermissionId(){return permissionId;}
    public String getPermissionName(){return permissionName;}
    public String getPermissionStatus(){return permissionStatus;}
    public String getDescription(){return description;}

    public void setPermissionId(long permissionId){this.permissionId = permissionId;}
    public void setPermissionName(String permissionName){this.permissionName = permissionName;}
    public void setPermissionStatus(String permissionStatus){this.permissionStatus = permissionStatus;}
    public void setDescription(String description){this.description = description;}
}
