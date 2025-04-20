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
        em.persist(cart);
    }
    
    public Promotion findPromotionByCode(String promoCode) {
        List<Promotion> promos = em.createNamedQuery("Promotion.findByPromotionCode", Promotion.class)
            .setParameter("promotionCode", promoCode)
            .getResultList();
        return promos.isEmpty() ? null : promos.get(0);
    }
    
    public UserData findUserById(String userId) {
        return em.find(UserData.class, userId);
    }
}
