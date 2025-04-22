/**
 *
 * @author kaibin
 */
package model;

import controller.CustomIdGenerator;
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
    
    public void create(OrderDetails od) {
        if (od.getDetailId() == null || od.getDetailId().isEmpty()) {
            String generatedId = CustomIdGenerator.generateNextId(em, "OrderDetails", "D", 3, "detailId");
            od.setDetailId(generatedId);
        }
        em.persist(od);
        em.flush();
        em.refresh(od);
    }
    
    public void update(OrderDetails od) {
        od = em.merge(od);
        em.flush();
        em.refresh(od);
    }

    public void delete(String detailId) {
        OrderDetails od = em.find(OrderDetails.class, detailId);
        if (od != null) {
            od.setDbstatus("deleted");
            od = em.merge(od);
            em.flush();
            em.refresh(od);
        }
    }
}
