/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
public class PromotionDAO {
    
     @PersistenceContext
    private EntityManager em;

    public Promotion findByPromotionCode(String code) {
        List<Promotion> promos = em.createNamedQuery("Promotion.findByPromotionCode", Promotion.class)
            .setParameter("promotionCode", code)
            .getResultList();
        return promos.isEmpty() ? null : promos.get(0);
    }
}
