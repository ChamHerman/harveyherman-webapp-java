package model;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.PersistenceContext;

@Stateless
public class ReportDAO {
    
    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;
    
    public String getNextReportId() {
        String lastId = em.createQuery("SELECT MAX(r.reportId) FROM Report r", String.class)
                          .getSingleResult();
        
    
        // Extract numeric part
        int num = Integer.parseInt(lastId.replaceAll("\\D+", ""));
        num++; // Increment
        
        // Format back with prefix and leading zeros
        return String.format("R%03d", num);
    }

    //@Transactional
    public void addReport(Report report) {
        report.setReportId(getNextReportId());
        em.persist(report);
    }
}
