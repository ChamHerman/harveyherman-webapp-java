/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author weika
 */
@Entity
@Table(name = "cart_item")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "CartItem.findAll", query = "SELECT c FROM CartItem c WHERE c.dbstatus = 'active'"),
    @NamedQuery(name = "CartItem.findByCartItemId", query = "SELECT c FROM CartItem c WHERE c.cartItemId = :cartItemId AND c.dbstatus = 'active'"),
    @NamedQuery(name = "CartItem.findByQuantity", query = "SELECT c FROM CartItem c WHERE c.quantity = :quantity AND c.dbstatus = 'active'"),
    @NamedQuery(name = "CartItem.findByUnitPrice", query = "SELECT c FROM CartItem c WHERE c.unitPrice = :unitPrice AND c.dbstatus = 'active'"),
    @NamedQuery(name = "CartItem.findBySubtotal", query = "SELECT c FROM CartItem c WHERE c.subtotal = :subtotal AND c.dbstatus = 'active'"),
    @NamedQuery(name = "CartItem.findByDbstatus", query = "SELECT c FROM CartItem c WHERE c.dbstatus = :dbstatus")})
public class CartItem implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "cart_item_id")
    private String cartItemId;
    @Basic(optional = false)
    @NotNull
    @Column(name = "quantity")
    private int quantity;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "unit_price")
    private BigDecimal unitPrice;
    @Basic(optional = false)
    @NotNull
    @Column(name = "subtotal")
    private BigDecimal subtotal;
    @Size(max = 7)
    @Column(name = "dbstatus")
    private String dbstatus;
    @JoinColumn(name = "cart_id", referencedColumnName = "cart_id")
    @ManyToOne(optional = false)
    private Cart cartId;
    @JoinColumn(name = "item_id", referencedColumnName = "item_id")
    @ManyToOne(optional = false)
    private Item itemId;

    public CartItem() {
    }

    public CartItem(String cartItemId) {
        this.cartItemId = cartItemId;
    }

    public CartItem(String cartItemId, int quantity, BigDecimal unitPrice, BigDecimal subtotal) {
        this.cartItemId = cartItemId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = subtotal;
    }

    public String getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(String cartItemId) {
        this.cartItemId = cartItemId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public String getDbstatus() {
        return dbstatus;
    }

    public void setDbstatus(String dbstatus) {
        this.dbstatus = dbstatus;
    }

    public Cart getCartId() {
        return cartId;
    }

    public void setCartId(Cart cartId) {
        this.cartId = cartId;
    }

    public Item getItemId() {
        return itemId;
    }

    public void setItemId(Item itemId) {
        this.itemId = itemId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (cartItemId != null ? cartItemId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof CartItem)) {
            return false;
        }
        CartItem other = (CartItem) object;
        if ((this.cartItemId == null && other.cartItemId != null) || (this.cartItemId != null && !this.cartItemId.equals(other.cartItemId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.CartItem[ cartItemId=" + cartItemId + " ]";
    }
    
}
