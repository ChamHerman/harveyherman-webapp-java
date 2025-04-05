package model;

import model.Promotion;
import model.PromotionStatus;
import controller.PromotionDatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;

public class PromotionDAO {
    private static final String SELECT_ALL_PROMOTIONS = "SELECT * FROM promotion";
    private static final String ADD_PROMOTIONS = "INSERT INTO Promotion (promotion_id,promotion_code,discount_value,status,minimum_purchase,description,start_date,end_date) values(?,?,?,?,?,?,?,?)";
    private static final String GENERATE_ID ="SELECT promotion_Id FROM Promotion ORDER BY promotion_Id DESC LIMIT 1";
    String nextId = "P001";

    public List<Promotion> getAllPromotions() {
        List<Promotion> promotions = new ArrayList<>();

        try (Connection conn = PromotionDatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_PROMOTIONS);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Promotion promo = new Promotion();
                promo.setPromotionId(rs.getString("promotion_id"));
                promo.setPromotionCode(rs.getString("promotion_code"));
                promo.setDiscountValue(rs.getDouble("discount_value"));

                String statusString = rs.getString("status");
                try {
                    promo.setStatus(PromotionStatus.fromString(statusString));
                } catch (IllegalArgumentException e) {
                    System.out.println("Invalid status value in DB: " + statusString);
                    promo.setStatus(null); 
                }

                promo.setMinimumPurchase(rs.getDouble("minimum_purchase"));
                promo.setDescription(rs.getString("description"));
                promo.setStartDate(rs.getDate("start_date"));
                promo.setEndDate(rs.getDate("end_date"));

                promotions.add(promo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return promotions;
    }
    
    public boolean deletePromotion(String promotionId) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = em.getTransaction();
        
        try {
            transaction.begin();
            Promotion promo = em.find(Promotion.class, promotionId);
            
            if (promo != null) {
                em.remove(promo); // Remove the promotion
                transaction.commit();
                return true;
            } else {
                transaction.rollback();
                return false;
            }
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
    
    public String getNextPromotionId() {

        try (Connection conn = PromotionDatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(GENERATE_ID);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String lastId = rs.getString("promotion_Id"); 
                int num = Integer.parseInt(lastId.substring(1)) + 1; 
                nextId = String.format("P%03d", num); 
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nextId;
    }
    
    public String addPromotion(Promotion promotion) throws SQLException {
        String newPromotionId = getNextPromotionId(); 
        
        String sql = "INSERT INTO Promotion (promotion_id, promotion_code, discount_value, status, minimum_purchase, description, start_date, end_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = PromotionDatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newPromotionId);
            stmt.setString(2, promotion.getPromotionCode());
            stmt.setDouble(3, promotion.getDiscountValue());
            stmt.setString(4, "active"); 
            stmt.setDouble(5, promotion.getMinimumPurchase());
            stmt.setString(6, promotion.getDescription());
            stmt.setDate(7, new java.sql.Date(promotion.getStartDate().getTime()));
            stmt.setDate(8, new java.sql.Date(promotion.getEndDate().getTime()));

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                return newPromotionId;
            }
        }

        return null;  
    }

}