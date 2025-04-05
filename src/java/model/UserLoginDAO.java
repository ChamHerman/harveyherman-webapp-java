package model;

import model.UserLogin;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;

public class UserLoginDAO extends BaseDAO {

    public void create(UserLogin userLogin) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(userLogin);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
    
    public UserLogin findByUsername(String username) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT u FROM UserLogin u WHERE LOWER(u.username) = LOWER(:username)", UserLogin.class)
                    .setParameter("username", username)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null; // Return null if no matching username
        } finally {
            em.close();
        }
    }
}
