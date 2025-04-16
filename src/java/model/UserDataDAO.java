package model;

import controller.CustomIdGenerator;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.NoResultException;

import java.util.List;
import javax.persistence.PersistenceContext;

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

//    public void create(UserData user) {
//        try {
//            em.getTransaction().begin();
//            em.persist(user);
//            em.getTransaction().commit();
//        } catch (Exception e) {
//            if (em.getTransaction().isActive()) {
//                em.getTransaction().rollback();
//            }
//            e.printStackTrace();
//        } finally {
//            em.close();
//        }
//    }

    public UserData findById(String userId) {
        try {
            return em.find(UserData.class, userId);
        } finally {
            em.close();
        }
    }

    public UserData findByEmail(String email) {
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
        try {
            return em.createQuery("SELECT u FROM UserData u", UserData.class).getResultList();
        } finally {
            em.close();
        }
    }

    public void update(UserData userData) {
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
