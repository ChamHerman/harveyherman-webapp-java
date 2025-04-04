/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.sql.Timestamp;
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
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author herman
 */
@Entity
@Table(name = "aplogin")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "APLogin.findAll", query = "SELECT a FROM APLogin a"),
    @NamedQuery(name = "APLogin.findByApId", query = "SELECT a FROM APLogin a WHERE a.apId = :apId"),
    @NamedQuery(name = "APLogin.findByUsername", query = "SELECT a FROM APLogin a WHERE a.username = :username"),
    @NamedQuery(name = "APLogin.findByPassword", query = "SELECT a FROM APLogin a WHERE a.password = :password"),
    @NamedQuery(name = "APLogin.findByLastLogin", query = "SELECT a FROM APLogin a WHERE a.lastLogin = :lastLogin"),
    @NamedQuery(name = "APLogin.findByPosition", query = "SELECT a FROM APLogin a WHERE a.position = :position"),
    @NamedQuery(name = "APLogin.findByCreatedDate", query = "SELECT a FROM APLogin a WHERE a.createdDate = :createdDate")})
public class APLogin implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "ap_id")
    private String apId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "username")
    private String username;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "password")
    private String password;
    @Column(name = "last_login")
    private Timestamp lastLogin;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 7)
    @Column(name = "position")
    private String position;
    @Column(name = "created_date", updatable = false, insertable = false)
    private Timestamp createdDate;
    @JoinColumn(name = "staff_id", referencedColumnName = "staff_id")
    @OneToOne
    private StaffData staffId;

    public APLogin() {
    }

    public APLogin(String apId) {
        this.apId = apId;
    }

    public APLogin(String apId, String username, String password, String position) {
        this.apId = apId;
        this.username = username;
        this.password = password;
        this.position = position;
    }

    public String getApId() {
        return apId;
    }

    public void setApId(String apId) {
        this.apId = apId;
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

    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
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
        hash += (apId != null ? apId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof APLogin)) {
            return false;
        }
        APLogin other = (APLogin) object;
        if ((this.apId == null && other.apId != null) || (this.apId != null && !this.apId.equals(other.apId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.APLogin[ apId=" + apId + " ]";
    }
    
}
