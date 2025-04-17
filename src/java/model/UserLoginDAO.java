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

    public void update(UserLogin userLogin) {
        em.merge(userLogin);
        em.flush();
        em.refresh(userLogin);
    }

    public List<UserLogin> findAllLogins() {
        TypedQuery<UserLogin> query = em.createNamedQuery("UserLogin.findAll", UserLogin.class);
        return query.getResultList();
    }

    public UserLogin findByLoginId(String loginId) {
        TypedQuery<UserLogin> query = em.createNamedQuery("UserLogin.findByLoginId", UserLogin.class);
        query.setParameter("loginId", loginId);
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public UserLogin findByUsername(String username) {
        TypedQuery<UserLogin> query = em.createNamedQuery("UserLogin.findByUsername", UserLogin.class);
        query.setParameter("username", username);
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<UserLogin> findByPassword(String password) {
        TypedQuery<UserLogin> query = em.createNamedQuery("UserLogin.findByPassword", UserLogin.class);
        query.setParameter("password", password);
        return query.getResultList();
    }

    public List<UserLogin> findByLastLogin(Date lastLogin) {
        TypedQuery<UserLogin> query = em.createNamedQuery("UserLogin.findByLastLogin", UserLogin.class);
        query.setParameter("lastLogin", lastLogin);
        return query.getResultList();
    }

    public List<UserLogin> findByChallengeQuestion(String challengeQuestion) {
        TypedQuery<UserLogin> query = em.createNamedQuery("UserLogin.findByChallengeQuestion", UserLogin.class);
        query.setParameter("challengeQuestion", challengeQuestion);
        return query.getResultList();
    }

    public List<UserLogin> findByAnswer(String answer) {
        TypedQuery<UserLogin> query = em.createNamedQuery("UserLogin.findByAnswer", UserLogin.class);
        query.setParameter("answer", answer);
        return query.getResultList();
    }
}
