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

//    public List<Orders> getFilteredOrders(String search, String status) {
//    if (status != null && !status.trim().isEmpty()) {
//        TypedQuery<Orders> query = em.createNamedQuery("Orders.findByStatus", Orders.class);
//        query.setParameter("status", status);
//        List<Orders> orders = query.getResultList();
//        // Filter by dbstatus in Java
//        List<Orders> filtered = new java.util.ArrayList<>();
//        for (Orders o : orders) {
//            if ("active".equals(o.getDbstatus())) {
//                // Optionally filter by search (orderId or userId.fullname)
//                if (search == null || search.trim().isEmpty() ||
//                    (o.getOrderId() != null && o.getOrderId().contains(search)) ||
//                    (o.getUserId() != null && o.getUserId().getFullname() != null && o.getUserId().getFullname().contains(search))) {
//                    filtered.add(o);
//                }
//            }
//        }
//        return filtered;
//    } else {
//        // No status filter, just get all active orders and filter by search if needed
//        List<Orders> orders = getAllOrders();
//        if (search == null || search.trim().isEmpty()) {
//            return orders;
//        }
//        List<Orders> filtered = new java.util.ArrayList<>();
//        for (Orders o : orders) {
//            if ((o.getOrderId() != null && o.getOrderId().contains(search)) ||
//                (o.getUserId() != null && o.getUserId().getFullname() != null && o.getUserId().getFullname().contains(search))) {
//                filtered.add(o);
//            }
//        }
//        return filtered;
//    }
//}
    
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

//    public List<Object[]> countOrdersGroupedByStatus() {
//    // No named query for group by, so do it in Java
//    List<Orders> orders = getAllOrders();
//    java.util.Map<String, Long> map = new java.util.HashMap<>();
//    for (Orders o : orders) {
//        String status = o.getStatus();
//        map.put(status, map.getOrDefault(status, 0L) + 1);
//    }
//    List<Object[]> result = new java.util.ArrayList<>();
//    for (java.util.Map.Entry<String, Long> entry : map.entrySet()) {
//        result.add(new Object[]{entry.getKey(), entry.getValue()});
//    }
//    return result;
//}

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
        return query.getResultList();
    }

}
