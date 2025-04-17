/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.persistence.TypedQuery;
import java.util.List;
import javax.persistence.PersistenceContext;

/**
 *
 * @author user
 */
import controller.CustomIdGenerator;

@Stateless
public class OrderDAO {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    public void create(Orders order) {
        if (order.getOrderId() == null || order.getOrderId().isEmpty()) {
            String generatedId = CustomIdGenerator.generateNextId(em, "Orders", "O", 2, "orderId");
            order.setOrderId(generatedId);
        }
        em.persist(order);
    }

    // Retrieve an order by orderId via the named query declared in Orders.java
    public Orders selectOrder(String orderId) {
        TypedQuery<Orders> query = em.createNamedQuery("Orders.findByOrderId", Orders.class);
        query.setParameter("orderId", orderId);
        return query.getSingleResult();
    }

    // Retrieve all orders using the named query declared in Orders.java ("Orders.findAll")
    public List<Orders> getAllOrders() {
        TypedQuery<Orders> query = em.createNamedQuery("Orders.findAll", Orders.class);
        return query.getResultList();
    }

    public List<Orders> getFilteredOrders(String search, String status) {
        String jpql = "SELECT o FROM Orders o WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            jpql += " AND (o.orderId LIKE :search OR o.userId.fullname LIKE :search)";
        }
        if (status != null && !status.trim().isEmpty()) {
            jpql += " AND o.status = :status";
        }

        TypedQuery<Orders> query = em.createQuery(jpql, Orders.class);
        if (search != null && !search.trim().isEmpty()) {
            query.setParameter("search", "%" + search + "%");
        }
        if (status != null && !status.trim().isEmpty()) {
            query.setParameter("status", status);
        }

        return query.getResultList();
    }

    public long countAllOrders() {
        TypedQuery<Long> query = em.createQuery("SELECT COUNT(o) FROM Orders o", Long.class);
        return query.getSingleResult();
    }

    public long countOrdersByStatus(String status) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(o) FROM Orders o WHERE o.status = :status", Long.class);
        query.setParameter("status", status);
        return query.getSingleResult();
    }

    public long getTotalOrderCount() {
        TypedQuery<Long> query = em.createQuery("SELECT COUNT(o) FROM Orders o", Long.class);
        return query.getSingleResult();
    }

    public List<Object[]> countOrdersGroupedByStatus() {
        String jpql = "SELECT o.status, COUNT(o) FROM Orders o GROUP BY o.status";
        TypedQuery<Object[]> query = em.createQuery(jpql, Object[].class);
        return query.getResultList();
    }

    // Update the order
    public void update(Orders order) {
        em.merge(order);
    }

    // Delete an order by its orderId using the selectOrder method and removing it
    public void delete(String orderId) {
        Orders order = selectOrder(orderId);
        if (order != null) {
            em.remove(order);
        }
    }

}
