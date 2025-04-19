/**
 *
 * @author kaibin
 */
package model;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class OrderDetailsDAO {
    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    // Get all order details for a given orderId, and only active ones
    public List<OrderDetails> getByOrderId(String orderId) {
        TypedQuery<OrderDetails> query = em.createQuery(
            "SELECT od FROM OrderDetails od WHERE od.orderId.orderId = :orderId AND od.dbstatus = 'active'",
            OrderDetails.class
        );
        query.setParameter("orderId", orderId);
        return query.getResultList();
    }

    // (Optional) Get a single order detail by its detailId
    public OrderDetails getByDetailId(String detailId) {
        return em.find(OrderDetails.class, detailId);
    }

    // (Optional) Add, update, delete methods as needed
    public void create(OrderDetails od) {
        em.persist(od);
    }

    public void update(OrderDetails od) {
        em.merge(od);
    }

    public void delete(String detailId) {
        OrderDetails od = getByDetailId(detailId);
        if (od != null) {
            od.setDbstatus("deleted");
            em.merge(od);
        }
    }
}
