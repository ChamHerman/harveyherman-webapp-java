package model;

import model.UserData;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.NoResultException;

import java.util.List;

public class UserDataDAO extends BaseDAO {

	public void create(UserData user) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(user);
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

    public UserData findById(String userId) {
        EntityManager em = getEntityManager();
        try {
            return em.find(UserData.class, userId);
        } finally {
            em.close();
        }
    }
    
    public UserData findByEmail(String email) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT u FROM UserData u WHERE LOWER(u.email) = LOWER(:email)", UserData.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null; // Return null if no matching user is found
        } finally {
            em.close();
        }
    }

    public List<UserData> findAll() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT u FROM UserData u", UserData.class).getResultList();
        } finally {
            em.close();
        }
    }

    public void update(UserData userData) {
        EntityManager em = getEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            em.merge(userData);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public void delete(String userId) {
        EntityManager em = getEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            UserData user = em.find(UserData.class, userId);
            if (user != null) {
                em.remove(user);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}
