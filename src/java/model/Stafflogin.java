/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author User
 */
@Entity
@Table(name = "stafflogin")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Stafflogin.findAll", query = "SELECT s FROM Stafflogin s"),
    @NamedQuery(name = "Stafflogin.findByLoginId", query = "SELECT s FROM Stafflogin s WHERE s.loginId = :loginId"),
    @NamedQuery(name = "Stafflogin.findByUsername", query = "SELECT s FROM Stafflogin s WHERE s.username = :username"),
    @NamedQuery(name = "Stafflogin.findByPassword", query = "SELECT s FROM Stafflogin s WHERE s.password = :password"),
    @NamedQuery(name = "Stafflogin.findByLastLogin", query = "SELECT s FROM Stafflogin s WHERE s.lastLogin = :lastLogin"),
    @NamedQuery(name = "Stafflogin.findByRole", query = "SELECT s FROM Stafflogin s WHERE s.role = :role"),
    @NamedQuery(name = "Stafflogin.findByDbstatus", query = "SELECT s FROM Stafflogin s WHERE s.dbstatus = :dbstatus")})
public class Stafflogin implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "login_id")
    private String loginId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "username")
    private String username;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "password")
    private String password;
    @Column(name = "last_login")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastLogin;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 7)
    @Column(name = "role")
    private String role;
    @Size(max = 7)
    @Column(name = "dbstatus")
    private String dbstatus;
    @JoinColumn(name = "staff_id", referencedColumnName = "staff_id")
    @OneToOne
    private StaffData staffId;

    public Stafflogin() {
    }

    public Stafflogin(String loginId) {
        this.loginId = loginId;
    }

    public Stafflogin(String loginId, String username, String password, String role) {
        this.loginId = loginId;
        this.username = username;
        this.password = password;
        this.role = role;
    }

    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Date getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Date lastLogin) {
        this.lastLogin = lastLogin;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getDbstatus() {
        return dbstatus;
    }

    public void setDbstatus(String dbstatus) {
        this.dbstatus = dbstatus;
    }

    public StaffData getStaffId() {
        return staffId;
    }

    public void setStaffId(StaffData staffId) {
        this.staffId = staffId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (loginId != null ? loginId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Stafflogin)) {
            return false;
        }
        Stafflogin other = (Stafflogin) object;
        if ((this.loginId == null && other.loginId != null) || (this.loginId != null && !this.loginId.equals(other.loginId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Stafflogin[ loginId=" + loginId + " ]";
    }
    
}
