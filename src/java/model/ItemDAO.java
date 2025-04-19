package model;

import controller.CustomIdGenerator;
import java.util.ArrayList;
import java.util.Arrays;
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
public class ItemDAO {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    // Setter for manual EntityManager injection
    public void setEntityManager(EntityManager em) {
        this.em = em;
    }

    // Create a new item. Generates a ID if it is provided.
    public void create(Item item) {
        if (item.getItemId() == null || item.getItemId().isEmpty()) {
            String generatedId = CustomIdGenerator.generateNextId(em, "Item", "I", 3, "itemId");
            item.setItemId(generatedId);
        }
        em.persist(item);
        em.flush();
        em.refresh(item);
    }

    public void update(Item item) {
        item = em.merge(item);
        em.flush();
        em.refresh(item);
    }

    // Soft delete an item by its ID by setting dbstatus to 'deleted'.
    public void delete(String itemId) {
        Item item = getItemById(itemId);
        if (item != null) {
            item.setDbstatus("deleted");
            item = em.merge(item);
            em.flush();
            em.refresh(item);
        }
    }

    // Get an item by ID using the named query "Item.findByItemId".
    public Item getItemById(String itemId) {
        TypedQuery<Item> query = em.createNamedQuery("Item.findByItemId", Item.class);
        query.setParameter("itemId", itemId);
        try {
            Item item = query.getSingleResult();
            em.refresh(item);
            return item;
        } catch (NoResultException nre) {
            return null;
        }
    }

    public List<Item> getAll() {
        try {
            return em.createNamedQuery("Item.findAll", Item.class).getResultList();
        } catch (Exception ex) {
            ex.getMessage();
            return null;
        }
    }

    // Filter items by search (name) and/or categories.
    public List<Item> getFilteredItems(String search, String[] categories) {
        List<Item> items;
        if (search != null && !search.isEmpty()) {
            TypedQuery<Item> query = em.createNamedQuery("Item.findByName", Item.class);
            query.setParameter("name", "%" + search + "%");
            items = query.getResultList();
        } else {
            items = getAll();
        }
        if (categories != null && categories.length > 0) {
            List<String> categoryList = Arrays.asList(categories);
            List<Item> filtered = new ArrayList<>();
            for (Item i : items) {
                if (categoryList.contains(i.getCategory())) {
                    filtered.add(i);
                }
            }
            items = filtered;
        }
        return items;
    }

    // Filter items by category and stock condition.
    public List<Item> getFilteredItemsByCategoryAndStock(String category, String stock) {
        List<Item> items;
        if (category != null && !category.equals("All")) {
            TypedQuery<Item> query = em.createNamedQuery("Item.findByCategory", Item.class);
            query.setParameter("category", category);
            items = query.getResultList();
        } else {
            items = getAll();
        }
        if (stock != null && !stock.equals("All")) {
            List<Item> filtered = new ArrayList<>();
            if (stock.equals("InStock")) {
                for (Item i : items) {
                    if (i.getStockQuantity() > 0) {
                        filtered.add(i);
                    }
                }
            } else if (stock.equals("OutOfStock")) {
                for (Item i : items) {
                    if (i.getStockQuantity() == 0) {
                        filtered.add(i);
                    }
                }
            }
            items = filtered;
        }
        return items;
    }

    // Get all distinct item categories.
    public List<String> getAllCategories() {
        TypedQuery<String> query = em.createQuery("SELECT DISTINCT i.category FROM Item i WHERE i.dbstatus = 'active'", String.class);
        return query.getResultList();
    }

    // Get total item count.
    public long getTotalItemCount() {
        TypedQuery<Long> query = em.createQuery("SELECT COUNT(i) FROM Item i WHERE i.dbstatus = 'active'", Long.class);
        return query.getSingleResult();
    }

    // Get the count of items that are in stock.
    public long getInStockItemCount() {
        TypedQuery<Long> query = em.createQuery("SELECT COUNT(i) FROM Item i WHERE i.stockQuantity > 0 AND i.dbstatus = 'active'", Long.class);
        return query.getSingleResult();
    }

    // Get distinct category count.
    public long getCategoryCount() {
        TypedQuery<Long> query = em.createQuery("SELECT COUNT(DISTINCT i.category) FROM Item i WHERE i.dbstatus = 'active'", Long.class);
        return query.getSingleResult();
    }

}
