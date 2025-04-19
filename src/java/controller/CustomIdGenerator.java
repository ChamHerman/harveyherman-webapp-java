/**
 *
 * @author herman
 */
package controller;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.List;

public class CustomIdGenerator {

    /**
     * Generates the next custom ID with prefix and incremental number.
     *
     * @param em         EntityManager instance for database access.
     * @param entityName The JPA entity class name (not the table name).
     * @param prefix     The prefix (e.g., "I").
     * @param length     Length of the numeric part (e.g., 2 for "01").
     * @param idField    The Java field name (e.g., "itemId").
     * @return The next generated ID (e.g., "I01", "I11").
     */
    public static String generateNextId(EntityManager em, String entityName, String prefix, int length, String idField) throws NumberFormatException {
        try {
            // Order by the length of the id first, then by id descending
            String jpql = "SELECT u." + idField + " FROM " + entityName + " u WHERE u." + idField + " LIKE :prefix " +
                          "ORDER BY LENGTH(u." + idField + ") DESC, u." + idField + " DESC";
            TypedQuery<String> query = em.createQuery(jpql, String.class);
            query.setParameter("prefix", prefix + "%");
            query.setMaxResults(1);
            List<String> resultList = query.getResultList();

            int nextNumber = 1;
            if (!resultList.isEmpty() && resultList.get(0) != null) {
                String lastId = resultList.get(0);
                // Debug output to verify retrieved id.
                // System.out.println("Last id retrieved: " + lastId);
                String numericPart = lastId.substring(prefix.length());
                nextNumber = Integer.parseInt(numericPart) + 1;
            }
            String format = "%0" + length + "d";
            return prefix + String.format(format, nextNumber);
        } catch (NumberFormatException e) {
            throw new RuntimeException("Error generating custom ID for " + entityName, e);
        }
    }
}
