package model;

import controller.CustomIdGenerator;
import java.util.List;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;

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
            em.remove(user);
            em.flush();
        }
    }

    public UserData findById(String userId) {
        return em.find(UserData.class, userId);
    }

    public UserData findByEmail(String email) {
        try {
            return em.createQuery("SELECT u FROM UserData u WHERE LOWER(u.email) = LOWER(:email)", UserData.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (NoResultException ex) {
            return null; // Return null if no matching user is found
        }
    }

    public List<UserData> findAll() {
        return em.createQuery("SELECT u FROM UserData u", UserData.class).getResultList();
    }

}
