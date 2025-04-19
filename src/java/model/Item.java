/**
 *
 * @author herman
 */
package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

@Entity
@Table(name = "item")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Item.findAll", query = "SELECT i FROM Item i WHERE i.dbstatus = 'active'"),
    @NamedQuery(name = "Item.findByItemId", query = "SELECT i FROM Item i WHERE i.itemId = :itemId AND i.dbstatus = 'active'"),
    @NamedQuery(name = "Item.findByName", query = "SELECT i FROM Item i WHERE i.name = :name AND i.dbstatus = 'active'"),
    @NamedQuery(name = "Item.findByPrice", query = "SELECT i FROM Item i WHERE i.price = :price AND i.dbstatus = 'active'"),
    @NamedQuery(name = "Item.findByStockQuantity", query = "SELECT i FROM Item i WHERE i.stockQuantity = :stockQuantity AND i.dbstatus = 'active'"),
    @NamedQuery(name = "Item.findByCategory", query = "SELECT i FROM Item i WHERE i.category = :category AND i.dbstatus = 'active'"),
    @NamedQuery(name = "Item.findByImageUrl", query = "SELECT i FROM Item i WHERE i.imageUrl = :imageUrl AND i.dbstatus = 'active'"),
    @NamedQuery(name = "Item.findByCreatedDate", query = "SELECT i FROM Item i WHERE i.createdDate = :createdDate AND i.dbstatus = 'active'"),
    @NamedQuery(name = "Item.findByUpdatedDate", query = "SELECT i FROM Item i WHERE i.updatedDate = :updatedDate AND i.dbstatus = 'active'"),
    @NamedQuery(name = "Item.findByDbstatus", query = "SELECT i FROM Item i WHERE i.dbstatus = :dbstatus")})
public class Item implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "item_id")
    private String itemId;
    
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "name")
    private String name;
    
    @Lob
    @Size(max = 65535)
    @Column(name = "description")
    private String description;
    
    @Basic(optional = false)
    @NotNull
    @Column(name = "price")
    private BigDecimal price;
    
    @Basic(optional = false)
    @NotNull()
    @Column(name = "stock_quantity")
    private int stockQuantity;

    @Size(max = 255)
    @Column(name = "category")
    private String category;
    
    @Size(max = 255)
    @Column(name = "image_url")
    private String imageUrl;
    
    @Column(name = "created_date", nullable = false, updatable = false, insertable = false)
    private Timestamp createdDate;
    
    @Column(name = "updated_date", insertable = false)
    private Timestamp updatedDate;
    
    @Size(max = 7)
    @Column(name = "dbstatus")
    private String dbstatus = "active";
    
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "itemId")
    private List<OrderDetails> orderDetailsList;
    
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "itemId")
    private List<CartItem> cartItemList;

    public Item() {
    }

    public Item(String itemId) {
        this.itemId = itemId;
    }

    public Item(String itemId, String name, BigDecimal price, int stockQuantity) {
        this.itemId = itemId;
        this.name = name;
        this.price = price;
        this.stockQuantity = stockQuantity;
    }

    public String getItemId() {
        return itemId;
    }

    public void setItemId(String itemId) {
        this.itemId = itemId;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDbstatus() {
        return dbstatus;
    }

    public void setDbstatus(String dbstatus) {
        this.dbstatus = dbstatus;
    }

    @XmlTransient
    public List<OrderDetails> getOrderDetailsList() {
        return orderDetailsList;
    }

    public void setOrderDetailsList(List<OrderDetails> orderDetailsList) {
        this.orderDetailsList = orderDetailsList;
    }

    @XmlTransient
    public List<CartItem> getCartItemList() {
        return cartItemList;
    }

    public void setCartItemList(List<CartItem> cartItemList) {
        this.cartItemList = cartItemList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (itemId != null ? itemId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Item)) {
            return false;
        }
        Item other = (Item) object;
        if ((this.itemId == null && other.itemId != null) || (this.itemId != null && !this.itemId.equals(other.itemId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Item[ itemId=" + itemId + " ]";
    }

}
