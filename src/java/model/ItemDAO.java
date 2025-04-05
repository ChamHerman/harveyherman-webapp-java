package model;

import controller.CustomIdGenerator;
import controller.ManagerDashboardUtil;
import javax.persistence.*;
import java.util.Arrays;
import java.util.List;
import java.sql.*;
import java.util.ArrayList;

public class ItemDAO extends BaseDAO {

	public void create(Item item) {
		EntityManager em = getEntityManager();
		EntityTransaction transaction = em.getTransaction();
		try {
			transaction.begin();

			// Generate custom ID if it's null
			if (item.getItemId() == null || item.getItemId().isEmpty()) {
				String generatedId = CustomIdGenerator.generateNextId(em, "Item", "I", 2, "itemId");
				item.setItemId(generatedId);
			}

			em.persist(item);
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
	
	public void update(Item item) {
		EntityManager em = getEntityManager();
		EntityTransaction transaction = em.getTransaction();
		try {
			transaction.begin();
			em.merge(item);
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

	public void delete(String itemId) {
		EntityManager em = getEntityManager();
		EntityTransaction transaction = em.getTransaction();
		try {
			transaction.begin();
			Item item = em.find(Item.class, itemId);
			if (item != null) {
				em.remove(item);
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

	public Item getItemById(String itemId) {
		EntityManager em = getEntityManager();
		try {
			return em.find(Item.class, itemId);
		} finally {
			em.close();
		}
	}

	public List<Item> getFilteredItems(String search, String[] categories) {
		EntityManager em = getEntityManager();
		List<Item> itemList = null;
		StringBuilder queryStr = new StringBuilder("SELECT i FROM Item i WHERE 1=1");

		if (search != null && !search.isEmpty()) {
			queryStr.append(" AND LOWER(i.name) LIKE LOWER(:search)");
		}
		if (categories != null && categories.length > 0) {
			queryStr.append(" AND i.category IN :categories");
		}

		TypedQuery<Item> query = em.createQuery(queryStr.toString(), Item.class);

		if (search != null && !search.isEmpty()) {
			query.setParameter("search", "%" + search + "%");
		}
		if (categories != null && categories.length > 0) {
			query.setParameter("categories", Arrays.asList(categories));
		}
		itemList = query.getResultList();

		return itemList;
	}

	public List<Item> getFilteredItemsByCategoryAndStock(String category, String stock) {
		EntityManager em = getEntityManager();
		List<Item> itemList = null;

		try {
			StringBuilder queryStr = new StringBuilder("SELECT i FROM Item i WHERE 1=1");

			if (category != null && !category.equals("All")) {
				queryStr.append(" AND i.category = :category");
			}
			if (stock != null && !stock.equals("All")) {
				if (stock.equals("InStock")) {
					queryStr.append(" AND i.stockQuantity > 0");
				} else if (stock.equals("OutOfStock")) {
					queryStr.append(" AND i.stockQuantity = 0");
				}
			}

			TypedQuery<Item> query = em.createQuery(queryStr.toString(), Item.class);

			if (category != null && !category.equals("All")) {
				query.setParameter("category", category);
			}

			itemList = query.getResultList();
		} finally {
			em.close();
		}

		return itemList;
	}

	public List<String> getAllCategories() {
		EntityManager em = getEntityManager();
		List<String> categories = null;
		try {
			TypedQuery<String> query = em.createQuery("SELECT DISTINCT i.category FROM Item i", String.class);
			categories = query.getResultList();
		} finally {
			em.close();
		}
		return categories;
	}

	public List<Item> getAll() {
		EntityManager em = getEntityManager();
		try {
			return em.createQuery("SELECT i FROM Item i", Item.class).getResultList();
		} finally {
			em.close();
		}
	}
	
	public long getTotalItemCount() {
	    EntityManager em = getEntityManager();
	    try {
	        return em.createQuery("SELECT COUNT(i) FROM Item i", Long.class).getSingleResult();
	    } finally {
	        em.close();
	    }
	}

	public long getInStockItemCount() {
	    EntityManager em = getEntityManager();
	    try {
	        return em.createQuery("SELECT COUNT(i) FROM Item i WHERE i.stockQuantity > 0", Long.class).getSingleResult();
	    } finally {
	        em.close();
	    }
	}

	public long getCategoryCount() {
	    EntityManager em = getEntityManager();
	    try {
	        return em.createQuery("SELECT COUNT(DISTINCT i.category) FROM Item i", Long.class).getSingleResult();
	    } finally {
	        em.close();
	    }
	}

}
