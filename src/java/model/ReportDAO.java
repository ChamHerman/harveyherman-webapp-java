/**
 *
 * @author kaisheng
 */
package model;

import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.EntityManager;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.PersistenceContext;

@Stateless
public class ReportDAO {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    public List<Report> getAllReports() {
        return em.createNamedQuery("Report.findAll", Report.class).getResultList();
    }

    public String getNextReportId() {
        String lastId = em.createQuery("SELECT MAX(r.reportId) FROM Report r", String.class)
                .getSingleResult();
        
        if (lastId == null) {
            return "R001";
        }

        int num = Integer.parseInt(lastId.replaceAll("\\D+", ""));
        num++;

        return String.format("R%03d", num);
    }

    public void addReport(Report report) {
        report.setReportId(getNextReportId());
        em.persist(report);
    }
    
    public boolean deleteReport(String reportId) {
        Report report = em.find(Report.class, reportId);
        if (report != null) {
            report.setDbstatus("deleted");
            em.merge(report); // Update the entity
            return true;
        }
        return false;
    }
    
    /*public double calculateAmountBeenPromotion(Date startDate,Date endDate){
        BigDecimal promoAmount;
        promoAmount = em.createQuery("SELECT SUM(o.totalAmount) From Orders o WHERE o.createDate BETWEEN :startDate AND :endDate",BigDecimal.class)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .getSingleResult();
   
        double promoAmountDouble = (promoAmount != null) ? promoAmount.doubleValue() : 0.0;
        return promoAmountDouble;
    }*/
}
