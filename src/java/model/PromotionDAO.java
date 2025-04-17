/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

//import com.harveyherman.util.JPAUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.*;
import javax.transaction.Transactional;

@Stateless
public class PromotionDAO {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;
    
    public void setEntityManager(EntityManager em) {
        this.em = em;
    }
    public EntityManager getEntityManager() {
        return this.em;
    }
    
    public List<Promotion> getAllPromotions() {
        return em.createNamedQuery("Promotion.findAll", Promotion.class).getResultList();
    }

    public String getNextPromotionId() {
        String lastId = em.createQuery("SELECT MAX(p.promotionId) FROM Promotion p", String.class)
                          .getSingleResult();
        
    
        // Extract numeric part
        int num = Integer.parseInt(lastId.replaceAll("\\D+", ""));
        num++; // Increment
        
        // Format back with prefix and leading zeros
        return String.format("P%03d", num);
    }

    //@Transactional
    public void addPromotion(Promotion promo) {
        promo.setPromotionId(getNextPromotionId());
        em.persist(promo);
    }

    //@Transactional
    public void deletePromotion(String promotionId) {
        Promotion promo = em.find(Promotion.class, promotionId);
        if (promo != null) {
            em.remove(promo);
        }
    }
}
