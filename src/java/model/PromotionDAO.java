/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import model.Promotion;
import model.PromotionStatus;
//import com.harveyherman.util.JPAUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import javax.ejb.Stateless;
import javax.persistence.TypedQuery;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;

@Stateless
public class PromotionDAO {

    @PersistenceContext(unitName = "harveyhermandbPU")
    private EntityManager em;

    public List<Promotion> getAllPromotions() {
        return em.createNamedQuery("Promotion.findAll", Promotion.class).getResultList();
    }

    public String getNextPromotionId() {
        List<String> result = em.createQuery("SELECT p.promotionId FROM Promotion p ORDER BY p.promotionId DESC", String.class)
                                .setMaxResults(1)
                                .getResultList();

        if (!result.isEmpty()) {
            String lastId = result.get(0);
            int num = Integer.parseInt(lastId.substring(1));
            return String.format("P%03d", ++num);
        }
        return "P001";
    }

    @Transactional
    public void addPromotion(Promotion promo) {
        promo.setPromotionId(getNextPromotionId());
        em.persist(promo);
    }

    @Transactional
    public void deletePromotion(String promotionId) {
        Promotion promo = em.find(Promotion.class, promotionId);
        if (promo != null) {
            em.remove(promo);
        }
    }
}
