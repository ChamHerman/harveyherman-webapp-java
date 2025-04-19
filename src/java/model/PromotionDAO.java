/**
 *
 * @author kaisheng
 */
package model;

import java.time.LocalDate;
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
        autoExpirePromotions();
        return em.createNamedQuery("Promotion.findAll", Promotion.class).getResultList();
    }

    public String getNextPromotionId() {
        String lastId = em.createQuery("SELECT MAX(p.promotionId) FROM Promotion p", String.class)
                          .getSingleResult();
    
        int num = Integer.parseInt(lastId.replaceAll("\\D+", ""));
        num++;
        
        if(lastId==null){
            return "P001";
        }else{
            return String.format("P%03d", num);
        }
    }

    //@Transactional
    public void addPromotion(Promotion promo) {
        promo.setPromotionId(getNextPromotionId());
        em.persist(promo);
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
                }
            }
        }
    }
}
