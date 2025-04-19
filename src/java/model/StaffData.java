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
import javax.persistence.Lob;
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
@Table(name = "staffdata")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "StaffData.findAll", query = "SELECT s FROM StaffData s"),
    @NamedQuery(name = "StaffData.findByStaffId", query = "SELECT s FROM StaffData s WHERE s.staffId = :staffId"),
    @NamedQuery(name = "StaffData.findByFullname", query = "SELECT s FROM StaffData s WHERE s.fullname = :fullname"),
    @NamedQuery(name = "StaffData.findByEmail", query = "SELECT s FROM StaffData s WHERE s.email = :email"),
    @NamedQuery(name = "StaffData.findByContactNumber", query = "SELECT s FROM StaffData s WHERE s.contactNumber = :contactNumber"),
    @NamedQuery(name = "StaffData.findByPosition", query = "SELECT s FROM StaffData s WHERE s.position = :position"),
    @NamedQuery(name = "StaffData.findByGender", query = "SELECT s FROM StaffData s WHERE s.gender = :gender"),
    @NamedQuery(name = "StaffData.findByCreatedDate", query = "SELECT s FROM StaffData s WHERE s.createdDate = :createdDate"),
    @NamedQuery(name = "StaffData.findByDbstatus", query = "SELECT s FROM StaffData s WHERE s.dbstatus = :dbstatus")})
public class StaffData implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "staff_id")
    private String staffId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "fullname")
    private String fullname;
    // @Pattern(regexp="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", message="Invalid email")//if the field contains email address consider using this annotation to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "email")
    private String email;
    @Size(max = 255)
    @Column(name = "contact_number")
    private String contactNumber;
    @Lob
    @Size(max = 65535)
    @Column(name = "address")
    private String address;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "position")
    private String position;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "gender")
    private String gender;
    @Column(name = "created_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;
    @Size(max = 7)
    @Column(name = "dbstatus")
    private String dbstatus;
    @OneToOne(mappedBy = "staffId")
    private Stafflogin stafflogin;

    public StaffData() {
    }

    public StaffData(String staffId) {
        this.staffId = staffId;
    }

    public StaffData(String staffId, String fullname, String email, String position, String gender) {
        this.staffId = staffId;
        this.fullname = fullname;
        this.email = email;
        this.position = position;
        this.gender = gender;
    }

    public String getStaffId() {
        return staffId;
    }

    public void setStaffId(String staffId) {
        this.staffId = staffId;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public String getDbstatus() {
        return dbstatus;
    }

    public void setDbstatus(String dbstatus) {
        this.dbstatus = dbstatus;
    }

    public Stafflogin getStafflogin() {
        return stafflogin;
    }

    public void setStafflogin(Stafflogin stafflogin) {
        this.stafflogin = stafflogin;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (staffId != null ? staffId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof StaffData)) {
            return false;
        }
        StaffData other = (StaffData) object;
        if ((this.staffId == null && other.staffId != null) || (this.staffId != null && !this.staffId.equals(other.staffId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.StaffData[ staffId=" + staffId + " ]";
    }
    
}
