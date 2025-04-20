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
public class StaffLoginDAO {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    public void setEntityManager(EntityManager em) {
        this.em = em;
    }

    public void create(StaffLogin staffLogin) {
        if (staffLogin.getLoginId() == null || staffLogin.getLoginId().isEmpty()) {
            String generatedId = CustomIdGenerator.generateNextId(em, "StaffLogin", "SL", 3, "loginId");
            staffLogin.setLoginId(generatedId);
        }
        em.persist(staffLogin);
        em.flush();
        em.refresh(staffLogin);
    }

    public void update(StaffLogin staffLogin) {
        em.merge(staffLogin);
        em.flush();
    }

    public void delete(String loginId) {
        StaffLogin staffLogin = em.find(StaffLogin.class, loginId);
        if (staffLogin != null) {
            staffLogin.setDbstatus("deleted");
            em.merge(staffLogin);
            em.flush();
        }
    }

    public List<StaffLogin> findAllLogins() {
        TypedQuery<StaffLogin> query = em.createNamedQuery("StaffLogin.findAll", StaffLogin.class);
        return query.getResultList();
    }

    public StaffLogin findByLoginId(String loginId) {
        TypedQuery<StaffLogin> query = em.createNamedQuery("StaffLogin.findByLoginId", StaffLogin.class);
        query.setParameter("loginId", loginId);
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public StaffLogin findByUsername(String username) {
        TypedQuery<StaffLogin> query = em.createNamedQuery("StaffLogin.findByUsername", StaffLogin.class);
        query.setParameter("username", username);
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<StaffLogin> findByPassword(String password) {
        TypedQuery<StaffLogin> query = em.createNamedQuery("StaffLogin.findByPassword", StaffLogin.class);
        query.setParameter("password", password);
        return query.getResultList();
    }

    public List<StaffLogin> findByLastLogin(Date lastLogin) {
        TypedQuery<StaffLogin> query = em.createNamedQuery("StaffLogin.findByLastLogin", StaffLogin.class);
        query.setParameter("lastLogin", lastLogin);
        return query.getResultList();
    }

    public List<StaffLogin> findByRole(String role) {
        TypedQuery<StaffLogin> query = em.createNamedQuery("StaffLogin.findByRole", StaffLogin.class);
        query.setParameter("role", role);
        return query.getResultList();
    }

    public StaffLogin findByStaffId(String staffId) {
        TypedQuery<StaffLogin> query = em.createQuery(
                "SELECT s FROM StaffLogin s WHERE s.staffId.staffId = :staffId AND s.dbstatus = 'active'",
                StaffLogin.class);
        query.setParameter("staffId", staffId);
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public void updateLastLoginTime(StaffLogin staffLogin) {
        if (staffLogin != null) {
            staffLogin.setLastLogin(new Date());
            update(staffLogin);
        }
    }
}