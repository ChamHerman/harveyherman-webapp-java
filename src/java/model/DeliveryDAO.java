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

    // Create a new delivery with generated ID (prefix D + 3 digits)
    public void create(Delivery delivery) {
        if (delivery.getDeliveryId() == null || delivery.getDeliveryId().isEmpty()) {
            String generatedId = CustomIdGenerator.generateNextId(em, "Delivery", "D", 3, "deliveryId");
            delivery.setDeliveryId(generatedId);
        }
        em.persist(delivery);
        em.flush();
        em.refresh(delivery);
    }

    // Find delivery by deliveryId using named query
    public Delivery findByDeliveryId(String deliveryId) {
        TypedQuery<Delivery> query = em.createNamedQuery("Delivery.findByDeliveryId", Delivery.class);
        query.setParameter("deliveryId", deliveryId);
        return query.getSingleResult();
    }

    // Get all active deliveries using named query
    public List<Delivery> findAll() {
        TypedQuery<Delivery> query = em.createNamedQuery("Delivery.findAll", Delivery.class);
        return query.getResultList();
    }

    // Update delivery
    public void update(Delivery delivery) {
        em.merge(delivery);
    }

    // Soft delete delivery by setting dbstatus to 'deleted'
    public void delete(String deliveryId) {
        Delivery delivery = findByDeliveryId(deliveryId);
        if (delivery != null) {
            delivery.setDbstatus("deleted");
            em.merge(delivery);
        }
    }

    // Get all deliveries for a given userId (via Orders relationship)
    public List<Delivery> getDeliveriesByUserId(String userId) {
        TypedQuery<Delivery> query = em.createQuery(
            "SELECT d FROM Delivery d WHERE d.orderId.userId.userId = :userId AND d.dbstatus = 'active'",
            Delivery.class
        );
        query.setParameter("userId", userId);
        return query.getResultList();
    }

    // Get all deliveries for a given orderId
    public List<Delivery> getDeliveriesByOrderId(String orderId) {
        TypedQuery<Delivery> query = em.createQuery(
            "SELECT d FROM Delivery d WHERE d.orderId.orderId = :orderId AND d.dbstatus = 'active'",
            Delivery.class
        );
        query.setParameter("orderId", orderId);
        return query.getResultList();
    }

    // (Optional) Get all deliveries for a user, including order details (for JSP display)
    // This can be done in service/controller by joining Delivery, Orders, and OrderDetails
    // Here, just provide the Delivery list; details can be fetched via Orders/OrderDetailsDAO
} 