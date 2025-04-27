/**
 *
 * @author kaisheng
 */
package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
public class ManagerDashboardDAO {
    
    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;
    
	//private static final String SELECT_TOTAL_SALES = "SELECT SUM(total_amount) AS total_sales FROM Orders";
	//private static final String SELECT_TOTAL_PRODUCT_SOLD="SELECT SUM(quantity) AS product_sold FROM Orderdetails";
	//private static final String SELECT_ACTIVE_USER="SELECT COUNT(DISTINCT o.user_id) AS active_users\r\n";

    public void setEntityManager(EntityManager em) {
        this.em = em;
    }
    public EntityManager getEntityManager() {
        return this.em;
    }
    
    public double getTotalSales() {
        BigDecimal totalSales;
        totalSales = em.createQuery("SELECT SUM(o.totalAmount) FROM Orders o", BigDecimal.class).getSingleResult();
        
        double totalSalesDouble = (totalSales != null) ? totalSales.doubleValue() : 0.0;
        
        return totalSalesDouble;
    }

    public int getProductSold() {
        Long productSold;
        productSold = em.createQuery("SELECT SUM(od.quantity) FROM OrderDetails od",Long.class).getSingleResult();
        
        int productSoldInt=(productSold != null) ? productSold.intValue() : 0;
        return productSoldInt;
    }

    public int getActiveUser() {
        LocalDate days = LocalDate.now().minusDays(28);
        Date sqlDate = java.sql.Date.valueOf(days);
        
        Long activeUsers = em.createQuery(
            "SELECT COUNT(DISTINCT o.userId) FROM Orders o WHERE o.createdDate >= :date",Long.class)
         .setParameter("date", sqlDate)
         .getSingleResult();
        
        int activeUsersInt=(activeUsers != null) ? activeUsers.intValue() : 0;
        return activeUsersInt;
    }
    
    public int getPaymentMethodCash() {
        Long cash;
        cash=em.createQuery("SELECT COUNT(o.paymentMethod) FROM Orders o WHERE o.paymentMethod='cash'", Long.class).getSingleResult();
        
        int cashInt=(cash != null) ? cash.intValue() : 0;
        return cashInt;
    }
    
    public int getPaymentMethodDebit() {
        Long debit;
        debit=em.createQuery("SELECT COUNT(o.paymentMethod) FROM Orders o WHERE o.paymentMethod='debit_card'", Long.class).getSingleResult();
        
        int debitInt=(debit != null) ? debit.intValue() : 0;
        return debitInt;
    }
    
    public int getPaymentMethodCredit() {
        Long credit;
        credit=em.createQuery("SELECT COUNT(o.paymentMethod) FROM Orders o WHERE o.paymentMethod='credit_card'", Long.class).getSingleResult();
        
        int creditInt=(credit != null) ? credit.intValue() : 0;
        return creditInt;
    }
    public int getPaymentMethodE() {
        Long e;
        e=em.createQuery("SELECT COUNT(o.paymentMethod) FROM Orders o WHERE o.paymentMethod='e-wallet'", Long.class).getSingleResult();
        
        int eInt=(e != null) ? e.intValue() : 0;
        return eInt;
    }
    
    public List<Object[]> getTopSales(){
        LocalDate date = LocalDate.now();
        LocalDate endDate = date.plusDays(1);
        LocalDate startDate = endDate.minusDays(30);
        
        Date startDateConverted = java.util.Date.from(startDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endDateConverted = java.util.Date.from(endDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        
        List<Object[]> topSales = em.createQuery(
                "SELECT i.itemId, i.name, SUM(od.quantity) " +
                "FROM OrderDetails od " +
                "JOIN od.itemId i " +
                "JOIN od.orderId o " +
                "WHERE o.createdDate BETWEEN :startDate AND :endDate " +
                "GROUP BY i.itemId, i.name " +
                "ORDER BY SUM(od.quantity) DESC", Object[].class)
            .setParameter("startDate", startDateConverted)
            .setParameter("endDate", endDateConverted)
            .setMaxResults(10)
            .getResultList();
        
        List<Object[]> rankedResults = new ArrayList<>();
        int rank = 1;
        for (Object[] row : topSales) { 
            rankedResults.add(new Object[]{rank++, row[0], row[1], row[2]});
        }
        
        return rankedResults;
    }
    
    public List<Object[]> getYesterdaySales(){
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(1);
        
        Date startDateConverted = java.util.Date.from(startDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endDateConverted = java.util.Date.from(endDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        
        List<Object[]> query = em.createQuery(
                "SELECT i.itemId, i.name, od.pricePerItem, SUM(od.quantity), SUM(od.quantity * od.pricePerItem) " +
                "FROM OrderDetails od " +
                "JOIN od.itemId i " +
                "JOIN od.orderId o " +
                "WHERE o.createdDate BETWEEN :startDateR AND :endDateR AND o.dbstatus='active'" +
                "GROUP BY i.itemId, i.name, od.pricePerItem " +
                "ORDER BY i.itemId", Object[].class)
                .setParameter("startDateR", startDateConverted)
                .setParameter("endDateR", endDateConverted)
                .getResultList();
        List<Object[]> yesterday = new ArrayList<>();
        for (Object[] row : query) {
            // Add rank as the first element in each array
            yesterday.add(new Object[]{row[0], row[1], row[2],row[3],row[4]});
        }
        return yesterday;
    }
    
    public List<Object[]> getTodaySales(){
        LocalDate startDate = LocalDate.now();
        LocalDate endDate = startDate.plusDays(1);
        
        Date startDateConverted = java.util.Date.from(startDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endDateConverted = java.util.Date.from(endDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        
        List<Object[]> query = em.createQuery(
                "SELECT i.itemId, i.name, od.pricePerItem, SUM(od.quantity), SUM(od.quantity * od.pricePerItem) " +
                "FROM OrderDetails od " +
                "JOIN od.itemId i " +
                "JOIN od.orderId o " +
                "WHERE o.createdDate BETWEEN :startDateR AND :endDateR AND o.dbstatus='active'" +
                "GROUP BY i.itemId, i.name, od.pricePerItem " +
                "ORDER BY i.itemId", Object[].class)
                .setParameter("startDateR", startDateConverted)
                .setParameter("endDateR", endDateConverted)
                .getResultList();
        List<Object[]> today = new ArrayList<>();
        for (Object[] row : query) {
            // Add rank as the first element in each array
            today.add(new Object[]{row[0], row[1], row[2],row[3],row[4]});
        }
        return today;
    }

    
}
