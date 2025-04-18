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
    @NamedQuery(name = "Delivery.findAll", query = "SELECT d FROM Delivery d"),
    @NamedQuery(name = "Delivery.findByDeliveryId", query = "SELECT d FROM Delivery d WHERE d.deliveryId = :deliveryId"),
    @NamedQuery(name = "Delivery.findByShippingStatus", query = "SELECT d FROM Delivery d WHERE d.shippingStatus = :shippingStatus"),
    @NamedQuery(name = "Delivery.findByExpectedDate", query = "SELECT d FROM Delivery d WHERE d.expectedDate = :expectedDate"),
    @NamedQuery(name = "Delivery.findByCreatedDate", query = "SELECT d FROM Delivery d WHERE d.createdDate = :createdDate"),
    @NamedQuery(name = "Delivery.findByDeliveredDate", query = "SELECT d FROM Delivery d WHERE d.deliveredDate = :deliveredDate")})
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
    @Lob
    @Size(min = 1, max = 65535)
    @Column(name = "shipping_address")
    private String shippingAddress;
    @Size(max = 9)
    @Column(name = "shipping_status")
    private String shippingStatus;
    @Column(name = "expected_date")
    @Temporal(TemporalType.DATE)
    private Date expectedDate;
    @Column(name = "created_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;
    @Column(name = "delivered_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date deliveredDate;
    @JoinColumn(name = "order_id", referencedColumnName = "order_id")
    @ManyToOne(optional = false)
    private Orders orderId;

    public Delivery() {
    }

    public Delivery(String deliveryId) {
        this.deliveryId = deliveryId;
    }

    public Delivery(String deliveryId, String shippingAddress) {
        this.deliveryId = deliveryId;
        this.shippingAddress = shippingAddress;
    }

    public String getDeliveryId() {
        return deliveryId;
    }

    public void setDeliveryId(String deliveryId) {
        this.deliveryId = deliveryId;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getShippingStatus() {
        return shippingStatus;
    }

    public void setShippingStatus(String shippingStatus) {
        this.shippingStatus = shippingStatus;
    }

    public Date getExpectedDate() {
        return expectedDate;
    }

    public void setExpectedDate(Date expectedDate) {
        this.expectedDate = expectedDate;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getDeliveredDate() {
        return deliveredDate;
    }

    public void setDeliveredDate(Date deliveredDate) {
        this.deliveredDate = deliveredDate;
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
