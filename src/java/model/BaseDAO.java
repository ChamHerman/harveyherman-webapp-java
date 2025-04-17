package model;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class BaseDAO {
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("HarveyHermanPU");

    public EntityManager getEntityManager() {
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory is not initialized!");
        }
        return emf.createEntityManager();
    }
}
