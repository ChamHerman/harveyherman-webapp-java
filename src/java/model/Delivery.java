/**
 *
 * @author herman
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
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author herman
 */
@Entity
@Table(name = "delivery")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Delivery.findAll", query = "SELECT d FROM Delivery d WHERE d.dbstatus = 'active'"),
    @NamedQuery(name = "Delivery.findByDeliveryId", query = "SELECT d FROM Delivery d WHERE d.deliveryId = :deliveryId AND d.dbstatus = 'active'"),
    @NamedQuery(name = "Delivery.findByReceiverName", query = "SELECT d FROM Delivery d WHERE d.receiverName = :receiverName AND d.dbstatus = 'active'"),
    @NamedQuery(name = "Delivery.findByReceiverContact", query = "SELECT d FROM Delivery d WHERE d.receiverContact = :receiverContact AND d.dbstatus = 'active'"),
    @NamedQuery(name = "Delivery.findByDeliveredDate", query = "SELECT d FROM Delivery d WHERE d.deliveredDate = :deliveredDate AND d.dbstatus = 'active'"),
    @NamedQuery(name = "Delivery.findByCreatedDate", query = "SELECT d FROM Delivery d WHERE d.createdDate = :createdDate AND d.dbstatus = 'active'"),
    @NamedQuery(name = "Delivery.findByDbstatus", query = "SELECT d FROM Delivery d WHERE d.dbstatus = :dbstatus")})
public class Delivery implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "delivery_id")
    private String deliveryId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "receiver_name")
    private String receiverName;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "receiver_contact")
    private String receiverContact;
    @Basic(optional = false)
    @NotNull
    @Lob
    @Size(min = 1, max = 65535)
    @Column(name = "receiver_address")
    private String receiverAddress;
    @Column(name = "delivered_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date deliveredDate;
    @Column(name = "created_date", nullable = false, updatable = false, insertable = false)
    private Timestamp createdDate;
    @Size(max = 7)
    @Column(name = "dbstatus")
    private String dbstatus;
    @JoinColumn(name = "order_id", referencedColumnName = "order_id")
    @ManyToOne(optional = false)
    private Orders orderId;

    public Delivery() {
    }

    public Delivery(String deliveryId) {
        this.deliveryId = deliveryId;
    }

    public Delivery(String deliveryId, String receiverName, String receiverContact, String receiverAddress) {
        this.deliveryId = deliveryId;
        this.receiverName = receiverName;
        this.receiverContact = receiverContact;
        this.receiverAddress = receiverAddress;
    }

    public String getDeliveryId() {
        return deliveryId;
    }

    public void setDeliveryId(String deliveryId) {
        this.deliveryId = deliveryId;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverContact() {
        return receiverContact;
    }

    public void setReceiverContact(String receiverContact) {
        this.receiverContact = receiverContact;
    }

    public String getReceiverAddress() {
        return receiverAddress;
    }

    public void setReceiverAddress(String receiverAddress) {
        this.receiverAddress = receiverAddress;
    }

    public Date getDeliveredDate() {
        return deliveredDate;
    }

    public void setDeliveredDate(Date deliveredDate) {
        this.deliveredDate = deliveredDate;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public String getDbstatus() {
        return dbstatus;
    }

    public void setDbstatus(String dbstatus) {
        this.dbstatus = dbstatus;
    }

    public Orders getOrderId() {
        return orderId;
    }

    public void setOrderId(Orders orderId) {
        this.orderId = orderId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (deliveryId != null ? deliveryId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Delivery)) {
            return false;
        }
        Delivery other = (Delivery) object;
        if ((this.deliveryId == null && other.deliveryId != null) || (this.deliveryId != null && !this.deliveryId.equals(other.deliveryId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Delivery[ deliveryId=" + deliveryId + " ]";
    }
    
}
