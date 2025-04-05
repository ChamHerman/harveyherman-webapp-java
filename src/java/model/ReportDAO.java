package model;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;
import java.util.List;

public class ReportDAO {
    
    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("harveyhermanPU");
    
    public List<Object[]> getTopSales(String startDate, String endDate) {
        EntityManager em = emf.createEntityManager();
        List<Object[]> results = null;

        try {
            em.getTransaction().begin();

            // Corrected JPQL query with proper field names
            TypedQuery<Object[]> query = em.createQuery(
                "SELECT i.id, i.name, SUM(od.quantity), SUM(od.quantity * od.pricePerItem) " +
                "FROM OrderDetails od " +
                "JOIN od.order o " +
                "JOIN od.item i " +
                "WHERE o.createdDate BETWEEN :startDate AND :endDate " +
                "GROUP BY i.id, i.name " +
                "ORDER BY SUM(od.quantity) DESC",
                Object[].class
            );

            query.setParameter("startDate", java.sql.Date.valueOf(startDate));
            query.setParameter("endDate", java.sql.Date.valueOf(endDate));
            query.setMaxResults(10);  // Limit to Top 10 results

            results = query.getResultList();
            em.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            em.getTransaction().rollback();
        } finally {
            em.close();
        }
        
        return results;
    }
}
