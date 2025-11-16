package win.servername.entity.auth;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "RefreshToken")
public class RefreshToken {
    @Id
    private String refreshToken;

    @Column(nullable = false)
    private Date dateProvisioned;

    @Column(nullable = false)
    private Date expiryDate;

    @Column(nullable = false)
    private Date lastUsed;

    @ManyToOne
    @JoinColumn(name = "UserId")
    private User user;

    public String getRefreshToken() {return refreshToken;}
    public Date getDateProvisioned(){return dateProvisioned;}
    public Date getExpiryDate(){return expiryDate;}
    public Date getLastUsed(){return lastUsed;}
    public User getUser(){return user;}

    public void setRefreshToken(String refreshToken){this.refreshToken = refreshToken;}
    public void setDateProvisioned(Date dateProvisioned){this.dateProvisioned = dateProvisioned;}
    public void setExpiryDate(Date expiryDate){this.expiryDate = expiryDate;}
    public void setLastUsed(Date lastUsed){this.lastUsed = lastUsed;}
    public void setUser(User user){this.user = user;}

}
