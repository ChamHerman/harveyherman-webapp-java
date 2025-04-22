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

@Stateless
public class CartDAO {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    public Cart getActiveCartByUserId(String userId) {
        UserData user = em.find(UserData.class, userId);
        List<Cart> carts = em.createQuery("SELECT c FROM Cart c WHERE c.userId = :userId", Cart.class)
                .setParameter("userId", user)
                .getResultList();
        return carts.isEmpty() ? null : carts.get(0);
    }

    public Cart findById(String cartId) {
        List<Cart> carts = em.createNamedQuery("Cart.findById", Cart.class)
                .setParameter("cartId", cartId)
                .getResultList();
        return carts.isEmpty() ? null : carts.get(0);
    }

    public void create(Cart cart) {
        if (cart.getCartId() == null || cart.getCartId().isEmpty()) {
            String generatedId = CustomIdGenerator.generateNextId(em, "Cart", "C", 3, "cartId");
            cart.setCartId(generatedId);
        }
        em.persist(cart);
        em.flush();
        em.refresh(cart);
    }
    
    public void update(Cart cart) {
        cart = em.merge(cart);
        em.flush();
        em.refresh(cart);
    }

    public void delete(String cartId) {
        Cart cart = em.find(Cart.class, cartId);
        if (cart != null) {
            cart.setDbstatus("deleted");
            cart = em.merge(cart);
            em.flush();
            em.refresh(cart);
        }
    }
}