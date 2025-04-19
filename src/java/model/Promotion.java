/**
 *
 * @author kaisheng
 */
package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Lob;
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
@Table(name = "promotion")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Promotion.findAll", query = "SELECT p FROM Promotion p WHERE p.dbstatus = 'active'"),
    @NamedQuery(name = "Promotion.findByPromotionId", query = "SELECT p FROM Promotion p WHERE p.promotionId = :promotionId AND p.dbstatus = 'active'"),
    @NamedQuery(name = "Promotion.findByPromotionCode", query = "SELECT p FROM Promotion p WHERE p.promotionCode = :promotionCode AND p.dbstatus = 'active'"),
    @NamedQuery(name = "Promotion.findByDiscountValue", query = "SELECT p FROM Promotion p WHERE p.discountValue = :discountValue AND p.dbstatus = 'active'"),
    @NamedQuery(name = "Promotion.findByStatus", query = "SELECT p FROM Promotion p WHERE p.status = :status AND p.dbstatus = 'active'"),
    @NamedQuery(name = "Promotion.findByMinimumPurchase", query = "SELECT p FROM Promotion p WHERE p.minimumPurchase = :minimumPurchase AND p.dbstatus = 'active'"),
    @NamedQuery(name = "Promotion.findByStartDate", query = "SELECT p FROM Promotion p WHERE p.startDate = :startDate AND p.dbstatus = 'active'"),
    @NamedQuery(name = "Promotion.findByEndDate", query = "SELECT p FROM Promotion p WHERE p.endDate = :endDate AND p.dbstatus = 'active'"),
    @NamedQuery(name = "Promotion.findByDbstatus", query = "SELECT p FROM Promotion p WHERE p.dbstatus = :dbstatus")})
public class Promotion implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "promotion_id")
    private String promotionId;
    
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "promotion_code")
    private String promotionCode;
    
    @Basic(optional = false)
    @NotNull
    @Column(name = "discount_value")
    private BigDecimal discountValue;
    
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 7)
    @Column(name = "status")
    private String status;
    
    @Lob
    @Size(max = 65535)
    @Column(name = "description")
    private String description;
    
    @Size(max = 7)
    @Column(name = "dbstatus")
    private String dbstatus;
    
    @Column(name = "minimum_purchase")
    private BigDecimal minimumPurchase;
    
    @Column(name = "start_date")
    @Temporal(TemporalType.DATE)
    private Date startDate;
    
    @Column(name = "end_date")
    @Temporal(TemporalType.DATE)
    private Date endDate;
    
    @OneToMany(mappedBy = "promotionId")
    private List<Orders> ordersList;

    public Promotion() {
    }

    public Promotion(String promotionId) {
        this.promotionId = promotionId;
    }

    public Promotion(String promotionId, String promotionCode, BigDecimal discountValue, String status) {
        this.promotionId = promotionId;
        this.promotionCode = promotionCode;
        this.discountValue = discountValue;
        this.status = status;
    }

    public String getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(String promotionId) {
        this.promotionId = promotionId;
    }

    public String getPromotionCode() {
        return promotionCode;
    }

    public void setPromotionCode(String promotionCode) {
        this.promotionCode = promotionCode;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public BigDecimal getMinimumPurchase() {
        return minimumPurchase;
    }

    public void setMinimumPurchase(BigDecimal minimumPurchase) {
        this.minimumPurchase = minimumPurchase;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getDbstatus() {
        return dbstatus;
    }

    public void setDbstatus(String dbstatus) {
        this.dbstatus = dbstatus;
    }
    
        public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @XmlTransient
    public List<Orders> getOrdersList() {
        return ordersList;
    }

    public void setOrdersList(List<Orders> ordersList) {
        this.ordersList = ordersList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (promotionId != null ? promotionId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Promotion)) {
            return false;
        }
        Promotion other = (Promotion) object;
        if ((this.promotionId == null && other.promotionId != null) || (this.promotionId != null && !this.promotionId.equals(other.promotionId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Promotion[ promotionId=" + promotionId + " ]";
    }

}
