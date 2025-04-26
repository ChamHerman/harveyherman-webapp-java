package model;

import controller.CustomIdGenerator;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class DeliveryDAO {
    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    public void create(Delivery delivery) {
        if (delivery.getDeliveryId() == null || delivery.getDeliveryId().isEmpty()) {
            String generatedId = CustomIdGenerator.generateNextId(em, "Delivery", "DO", 3, "deliveryId");
            delivery.setDeliveryId(generatedId);
        }
        em.persist(delivery);
        em.flush();
        em.refresh(delivery);
    }

    public Delivery findByDeliveryId(String deliveryId) {
        TypedQuery<Delivery> query = em.createNamedQuery("Delivery.findByDeliveryId", Delivery.class);
        query.setParameter("deliveryId", deliveryId);
        return query.getSingleResult();
    }

    public List<Delivery> findAll() {
        TypedQuery<Delivery> query = em.createNamedQuery("Delivery.findAll", Delivery.class);
        return query.getResultList();
    }

    public void update(Delivery delivery) {
        em.merge(delivery);
    }

    public void delete(String deliveryId) {
        Delivery delivery = findByDeliveryId(deliveryId);
        if (delivery != null) {
            delivery.setDbstatus("deleted");
            em.merge(delivery);
        }
    }

    public List<Delivery> getDeliveriesByUserId(String userId) {
        TypedQuery<Delivery> query = em.createQuery(
            "SELECT d FROM Delivery d WHERE d.orderId.userId.userId = :userId AND d.dbstatus = 'active'",
            Delivery.class
        );
        query.setParameter("userId", userId);
        return query.getResultList();
    }

    public List<Delivery> getDeliveriesByOrderId(String orderId) {
        TypedQuery<Delivery> query = em.createQuery(
            "SELECT d FROM Delivery d WHERE d.orderId.orderId = :orderId AND d.dbstatus = 'active'",
            Delivery.class
        );
        query.setParameter("orderId", orderId);
        return query.getResultList();
    }
} 