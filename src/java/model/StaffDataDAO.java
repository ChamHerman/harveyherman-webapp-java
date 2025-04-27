/**
 *
 * @author weikang
 */
package model;

import controller.CustomIdGenerator;
import java.util.Date;
import java.util.List;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
@TransactionAttribute(TransactionAttributeType.REQUIRED)
public class StaffDataDAO {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    public void setEntityManager(EntityManager em) {
        this.em = em;
    }

    public void create(StaffData staff) {
        if (staff.getStaffId() == null || staff.getStaffId().isEmpty()) {
            String generatedId = CustomIdGenerator.generateNextId(em, "StaffData", "S", 3, "staffId");
            staff.setStaffId(generatedId);
        }
        em.persist(staff);
        em.flush();
        em.refresh(staff);
    }

    public void update(StaffData staffData) {
        staffData = em.merge(staffData);
        em.flush();
        em.refresh(staffData);
    }

    public void delete(String staffId) {
        StaffData staff = em.find(StaffData.class, staffId);
        if (staff != null) {
            staff.setDbstatus("deleted");
            em.merge(staff);
            em.flush();
        }
    }

    public List<StaffData> findAllStaff() {
        TypedQuery<StaffData> query = em.createNamedQuery("StaffData.findAll", StaffData.class);
        return query.getResultList();
    }

    public StaffData findByStaffId(String staffId) {
        TypedQuery<StaffData> query = em.createNamedQuery("StaffData.findByStaffId", StaffData.class);
        query.setParameter("staffId", staffId);
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<StaffData> findByFullname(String fullname) {
        TypedQuery<StaffData> query = em.createNamedQuery("StaffData.findByFullname", StaffData.class);
        query.setParameter("fullname", fullname);
        return query.getResultList();
    }

    public StaffData findByEmail(String email) {
        TypedQuery<StaffData> query = em.createNamedQuery("StaffData.findByEmail", StaffData.class);
        query.setParameter("email", email);
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public StaffData findByContactNumber(String contactNumber) {
        TypedQuery<StaffData> query = em.createNamedQuery("StaffData.findByContactNumber", StaffData.class);
        query.setParameter("contactNumber", contactNumber);
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<StaffData> findByPosition(String position) {
        TypedQuery<StaffData> query = em.createNamedQuery("StaffData.findByPosition", StaffData.class);
        query.setParameter("position", position);
        return query.getResultList();
    }

    public List<StaffData> findByGender(String gender) {
        TypedQuery<StaffData> query = em.createNamedQuery("StaffData.findByGender", StaffData.class);
        query.setParameter("gender", gender);
        return query.getResultList();
    }

    public List<StaffData> findByCreatedDate(Date createdDate) {
        TypedQuery<StaffData> query = em.createNamedQuery("StaffData.findByCreatedDate", StaffData.class);
        query.setParameter("createdDate", createdDate);
        return query.getResultList();
    }
}