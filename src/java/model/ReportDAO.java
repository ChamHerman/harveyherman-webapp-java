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
    
    public List<Report> getAllReports() {
        return em.createNamedQuery("Report.findAll", Report.class).getResultList();
    }
    
    public String getNextReportId() {
        String lastId = em.createQuery("SELECT MAX(r.reportId) FROM Report r", String.class)
                          .getSingleResult();
        
        int num = Integer.parseInt(lastId.replaceAll("\\D+", ""));
        num++;
        
        if (lastId==null){
            return "R001";
        }else{
            return String.format("R%03d", num);
        }
    }

    public void addReport(Report report) {
        report.setReportId(getNextReportId());
        em.persist(report);
    }
}
