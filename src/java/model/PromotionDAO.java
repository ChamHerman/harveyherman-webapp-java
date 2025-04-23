/**
 *
 * @author kaisheng
 */
package model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.*;

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
        try {
            autoExpirePromotions();
            return em.createNamedQuery("Promotion.findAll", Promotion.class).getResultList();
        } catch (Exception ex) {
            ex.getMessage();
            return new ArrayList<>();
        }
    }
    
    public Promotion findByPromotionCode(String code) {
        try {
            return em.createQuery("SELECT p FROM Promotion p WHERE p.promotionCode = :promotionCode", Promotion.class)
                    .setParameter("promotionCode", code)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public String getNextPromotionId() {
        String lastId = em.createQuery("SELECT MAX(p.promotionId) FROM Promotion p", String.class)
                .getSingleResult();

        if (lastId == null) {
            return "P001";
        }

        int num = Integer.parseInt(lastId.replaceAll("\\D+", ""));
        num++;

        return String.format("P%03d", num);

    }

    //@Transactional
    public void addPromotion(Promotion promo) {
        promo.setPromotionId(getNextPromotionId());
        em.persist(promo);
    }

    public Promotion updatePromotion(Promotion promotion) {
        try {
            // First check if the promotion exists
            Promotion existingPromo = em.find(Promotion.class, promotion.getPromotionId());
            if (existingPromo != null) {
                // Update all fields
                existingPromo.setPromotionCode(promotion.getPromotionCode());
                existingPromo.setDiscountValue(promotion.getDiscountValue());
                existingPromo.setMinimumPurchase(promotion.getMinimumPurchase());
                existingPromo.setDescription(promotion.getDescription());
                existingPromo.setStartDate(promotion.getStartDate());
                existingPromo.setEndDate(promotion.getEndDate());
                
                LocalDate today = LocalDate.now();
                if (existingPromo.getEndDate() != null) {
                    LocalDate promoEndDate = existingPromo.getEndDate().toInstant()
                            .atZone(java.time.ZoneId.systemDefault())
                            .toLocalDate();
                    
                    if (promoEndDate.isBefore(today)) {
                        existingPromo.setStatus("expired");
                    } else {
                        existingPromo.setStatus("active");
                    }
                }

                return em.merge(existingPromo);
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to update promotion: " + e.getMessage());
        }
    }
    
    //@Transactional
    public boolean deletePromotion(String promotionId) {
        Promotion promo = em.find(Promotion.class, promotionId);
        if (promo != null) {
            promo.setDbstatus("deleted");
            em.merge(promo); // Update the entity
            return true;
        }
        return false;
    }

    public void autoExpirePromotions() {
        List<Promotion> promoList = em.createNamedQuery("Promotion.findAll", Promotion.class).getResultList();
        LocalDate today = LocalDate.now(); // current local date

        for (Promotion promo : promoList) {
            if ("active".equalsIgnoreCase(promo.getStatus()) && promo.getEndDate() != null) {
                LocalDate promoEndDate = promo.getEndDate().toInstant()
                        .atZone(java.time.ZoneId.systemDefault())
                        .toLocalDate(); // convert java.util.Date to LocalDate

                if (promoEndDate.isBefore(today)) {
                    promo.setStatus("expired"); // mark as expired
                    em.merge(promo); // save the change
                }else if(promoEndDate.isAfter(today)){
                    promo.setStatus("active");
                    em.merge(promo);
                }
            }
        }
    }
}
