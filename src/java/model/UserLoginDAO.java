package model;

import controller.CustomIdGenerator;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;

@Stateless
public class UserLoginDAO {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    public void setEntityManager(EntityManager em) {
        this.em = em;
    }

    public void create(UserLogin userLogin) {
        if (userLogin.getLoginId() == null || userLogin.getLoginId().isEmpty()) {
            String generatedId = CustomIdGenerator.generateNextId(em, "UserLogin", "L", 3, "loginId");
            userLogin.setLoginId(generatedId);
        }
        em.persist(userLogin);
        em.flush();
        em.refresh(userLogin);
    }

    public UserLogin findByUsername(String username) {
        try {
            return em.createQuery("SELECT u FROM UserLogin u WHERE LOWER(u.username) = LOWER(:username)", UserLogin.class)
                    .setParameter("username", username)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }
}
