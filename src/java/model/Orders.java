/**
 *
 * @author kaibin
 */
package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

@Entity
@Table(name = "orders")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Orders.findAll", query = "SELECT o FROM Orders o WHERE o.dbstatus = 'active'"),
    @NamedQuery(name = "Orders.findByOrderId", query = "SELECT o FROM Orders o WHERE o.orderId = :orderId AND o.dbstatus = 'active'"),
    @NamedQuery(name = "Orders.findByTotalAmount", query = "SELECT o FROM Orders o WHERE o.totalAmount = :totalAmount AND o.dbstatus = 'active'"),
    @NamedQuery(name = "Orders.findByPaymentMethod", query = "SELECT o FROM Orders o WHERE o.paymentMethod = :paymentMethod AND o.dbstatus = 'active'"),
    @NamedQuery(name = "Orders.findByStatus", query = "SELECT o FROM Orders o WHERE o.status = :status AND o.dbstatus = 'active'"),
    @NamedQuery(name = "Orders.findByCreatedDate", query = "SELECT o FROM Orders o WHERE o.createdDate = :createdDate AND o.dbstatus = 'active'"),
    @NamedQuery(name = "Orders.findByDbstatus", query = "SELECT o FROM Orders o WHERE o.dbstatus = :dbstatus")})
public class Orders implements Serializable {

    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "total_amount")
    private BigDecimal totalAmount;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 11)
    @Column(name = "payment_method")
    private String paymentMethod;
    @Size(max = 9)
    @Column(name = "status")
    private String status;
    @Size(max = 7)
    @Column(name = "dbstatus")
    private String dbstatus;

    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "order_id")
    private String orderId;


    @Column(name = "created_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "orderId")
    private List<Delivery> deliveryList;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "orderId")
    private List<OrderDetails> orderDetailsList;

    @JoinColumn(name = "promotion_id", referencedColumnName = "promotion_id")
    @ManyToOne
    private Promotion promotionId;

    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    @ManyToOne(optional = false)
    private UserData userId;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "orderId")
    private List<Payment> paymentList;

    public Orders() {
    }

    public Orders(String orderId) {
        this.orderId = orderId;
    }

    public Orders(String orderId, BigDecimal totalAmount, String paymentMethod) {
        this.orderId = orderId;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }


    public void setDeliveryList(List<Delivery> deliveryList) {
        this.deliveryList = deliveryList;
    }

    public void setOrderDetailsList(List<OrderDetails> orderDetailsList) {
        this.orderDetailsList = orderDetailsList;
    }

    public Promotion getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(Promotion promotionId) {
        this.promotionId = promotionId;
    }

    public UserData getUserId() {
        return userId;
    }

    public void setUserId(UserData userId) {
        this.userId = userId;
    }
    
        public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDbstatus() {
        return dbstatus;
    }

    public void setDbstatus(String dbstatus) {
        this.dbstatus = dbstatus;
    }


    @XmlTransient
    public List<Delivery> getDeliveryList() {
        return deliveryList;
    }

    @XmlTransient
    public List<OrderDetails> getOrderDetailsList() {
        return orderDetailsList;
    }

    @XmlTransient
    public List<Payment> getPaymentList() {
        return paymentList;
    }

    public void setPaymentList(List<Payment> paymentList) {
        this.paymentList = paymentList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (orderId != null ? orderId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Orders)) {
            return false;
        }
        Orders other = (Orders) object;
        if ((this.orderId == null && other.orderId != null) || (this.orderId != null && !this.orderId.equals(other.orderId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Orders[ orderId=" + orderId + " ]";
    }



}
