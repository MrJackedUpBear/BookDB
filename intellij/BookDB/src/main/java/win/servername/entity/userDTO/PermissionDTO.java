package win.servername.entity.userDTO;

import java.util.ArrayList;
import java.util.List;

public class PermissionDTO {
    private String permissionName;
    private String permissionStatus;
    private String description;

    public String getPermissionName(){return permissionName;}
    public String getPermissionStatus(){return permissionStatus;}
    public String getDescription(){return description;}

    public void setPermissionName(String permissionName){this.permissionName = permissionName;}
    public void setPermissionStatus(String permissionStatus){this.permissionStatus = permissionStatus;}
    public void setDescription(String description){this.description = description;}
}
