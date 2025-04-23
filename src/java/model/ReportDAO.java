/**
 *
 * @author kaisheng
 */
package model;

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
}
