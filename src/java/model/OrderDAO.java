/**
 *
 * @author kaibin
 */
package model;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.List;
import javax.persistence.PersistenceContext;
import controller.CustomIdGenerator;

@Stateless
public class OrderDAO {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    public void create(Orders order) {
        if (order.getOrderId() == null || order.getOrderId().isEmpty()) {
            String generatedId = CustomIdGenerator.generateNextId(em, "Orders", "O", 3, "orderId");
            order.setOrderId(generatedId);
        }
        em.persist(order);
        em.flush();
        em.refresh(order);
    }

    // Retrieve an order by orderId via the named query declared in Orders.java
    public Orders selectOrder(String orderId) {
        TypedQuery<Orders> query = em.createNamedQuery("Orders.findByOrderId", Orders.class);
        query.setParameter("orderId", orderId);
        return query.getSingleResult();
    }

    // Retrieve all orders using the named query declared in Orders.java ("Orders.findAll")
    public List<Orders> getAllOrders() {
        TypedQuery<Orders> query = em.createNamedQuery("Orders.findByDbstatus", Orders.class);
        query.setParameter("dbstatus", "active");
        return query.getResultList();
    }

    public List<Orders> filterOrderByStatus(String status) {
        if (status == null || status.isEmpty() || "all".equalsIgnoreCase(status)) {
            // Return all active orders
            TypedQuery<Orders> query = em.createNamedQuery("Orders.findByDbstatus", Orders.class);
            query.setParameter("dbstatus", "active");
            return query.getResultList();
        } else {
            TypedQuery<Orders> query = em.createNamedQuery("Orders.findByStatus", Orders.class);
            query.setParameter("status", status);
            return query.getResultList();
        }
    }

    public long countAllOrders() {
        TypedQuery<Orders> query = em.createNamedQuery("Orders.findByDbstatus", Orders.class);
        query.setParameter("dbstatus", "active");
        return query.getResultList().size();
    }

    public long countOrdersByStatus(String status) {
        TypedQuery<Orders> query = em.createNamedQuery("Orders.findByStatus", Orders.class);
        query.setParameter("status", status);
        List<Orders> orders = query.getResultList();
        // Filter by dbstatus in Java
        return orders.stream().filter(o -> "active".equals(o.getDbstatus())).count();
    }

    public long getTotalOrderCount() {
        return countAllOrders();
    }

    // Update the order
    public void update(Orders order) {
        em.merge(order);
    }

    public void delete(String orderId) {
        Orders order = selectOrder(orderId);
        if (order != null) {
            order.setDbstatus("deleted");
            em.merge(order);
        }
    }

    // Get all active orders for a specific user
    public List<Orders> getOrdersByUserId(String userId) {
        TypedQuery<Orders> query = em.createQuery(
                "SELECT o FROM Orders o WHERE o.userId.userId = :userId AND o.dbstatus = 'active'",
                Orders.class
        );

        query.setParameter("userId", userId);
        List<Orders> orders = query.getResultList();

        // Force fetch delivery list for each order
        for (Orders order : orders) {
            order.getDeliveryList().size();
        }
        return orders;
    }

}
