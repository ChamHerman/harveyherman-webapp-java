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
public class UserDataDAO {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    public void setEntityManager(EntityManager em) {
        this.em = em;
    }

    public void create(UserData user) {
        if (user.getUserId() == null || user.getUserId().isEmpty()) {
            String generatedId = CustomIdGenerator.generateNextId(em, "UserData", "U", 3, "userId");
            user.setUserId(generatedId);
        }
        em.persist(user);
        em.flush();
        em.refresh(user);
    }

    public void update(UserData userData) {
        userData = em.merge(userData);
        em.flush();
        em.refresh(userData);
    }

    public void delete(String userId) {
        UserData user = em.find(UserData.class, userId);
        if (user != null) {
            user.setDbstatus("deleted");
            em.merge(user);
            em.flush();
        }
    }

    public List<UserData> findAllUsers() {
        TypedQuery<UserData> query = em.createNamedQuery("UserData.findAll", UserData.class);
        return query.getResultList();
    }

    public UserData findByUserId(String userId) {
        TypedQuery<UserData> query = em.createNamedQuery("UserData.findByUserId", UserData.class);
        query.setParameter("userId", userId);
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<UserData> findByFullname(String fullname) {
        TypedQuery<UserData> query = em.createNamedQuery("UserData.findByFullname", UserData.class);
        query.setParameter("fullname", fullname);
        return query.getResultList();
    }

    public UserData findByEmail(String email) {
        TypedQuery<UserData> query = em.createNamedQuery("UserData.findByEmail", UserData.class);
        query.setParameter("email", email);
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public UserData findByContactNumber(String contactNumber) {
        TypedQuery<UserData> query = em.createNamedQuery("UserData.findByContactNumber", UserData.class);
        query.setParameter("contactNumber", contactNumber);
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<UserData> findByBirthDate(Date birthDate) {
        TypedQuery<UserData> query = em.createNamedQuery("UserData.findByBirthDate", UserData.class);
        query.setParameter("birthDate", birthDate);
        return query.getResultList();
    }

    public List<UserData> findByCreatedDate(Date createdDate) {
        TypedQuery<UserData> query = em.createNamedQuery("UserData.findByCreatedDate", UserData.class);
        query.setParameter("createdDate", createdDate);
        return query.getResultList();
    }
}
