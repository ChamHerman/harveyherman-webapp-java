/**
 *
 * @author kaibin
 */
package model;

import controller.CustomIdGenerator;
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
        List<CartItem> items = em.createNamedQuery("CartItem.findByCartItemId", CartItem.class)
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
        if (cartItem.getCartItemId() == null || cartItem.getCartItemId().isEmpty()) {
            String generatedId = CustomIdGenerator.generateNextId(em, "CartItem", "CI", 3, "cartItemId");
            cartItem.setCartItemId(generatedId);
        }
        em.persist(cartItem);
        em.flush();
        em.refresh(cartItem);
    }

    public void update(CartItem cartItem) {
        cartItem = em.merge(cartItem);
        em.flush();
        em.refresh(cartItem);
    }

    public void softDelete(String cartItemId) {
        CartItem cartItem = em.find(CartItem.class, cartItemId);
        if (cartItem != null) {
            cartItem.setDbstatus("deleted");
            cartItem = em.merge(cartItem);
            em.flush();
            em.refresh(cartItem);
        }
    }
}
