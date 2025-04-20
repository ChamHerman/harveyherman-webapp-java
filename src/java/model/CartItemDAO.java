/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class CartItemDAO {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    
    public CartItem getActiveCartItem(String cartId, String itemId) {
        TypedQuery<CartItem> query = em.createNamedQuery("CartItem.findActiveByCartIdAndItemId", CartItem.class);
        query.setParameter("cartId", cartId);
        query.setParameter("itemId", itemId);
        List<CartItem> result = query.getResultList();
        return result.isEmpty() ? null : result.get(0);
    }
    
    public CartItem findById(String cartItemId) {
        List<CartItem> items = em.createNamedQuery("CartItem.findById", CartItem.class)
                                 .setParameter("cartItemId", cartItemId)
                                 .getResultList();
        return items.isEmpty() ? null : items.get(0);
    }

    public List<CartItem> getActiveCartItemsByCartId(String cartId) {
        TypedQuery<CartItem> query = em.createNamedQuery("CartItem.findActiveByCartId", CartItem.class);
        query.setParameter("cartId", cartId);
        return query.getResultList();
    }

    public void create(CartItem cartItem) {
        em.persist(cartItem);
    }

    public void update(CartItem cartItem) {
        em.merge(cartItem);
    }

    public void softDelete(String cartItemId) {
        CartItem ci = em.find(CartItem.class, cartItemId);
        if (ci != null) {
            ci.setDbstatus("deleted");
            em.merge(ci);
        }
    }
}
