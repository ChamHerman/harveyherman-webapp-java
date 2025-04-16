package model;

import model.Item;
import model.UserData;
import controller.ManagerDashboardUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO{
	private static final String SELECT_ALL_CUSTOMER = "SELECT * FROM UserData";
	
	public List<UserData> getAllCustomer() {
        List<UserData> cus = new ArrayList<>();
        
        try (Connection conn = ManagerDashboardUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_CUSTOMER);
                ResultSet rs = stmt.executeQuery()) {
        	
        	while(rs.next()) {
        		UserData ud = new UserData();
        		ud.setUserId(rs.getString("user_id"));
        		ud.setFullName(rs.getString("fullname"));
        		ud.setEmail(rs.getString("email"));
        		ud.setContactNumber(rs.getString("contact_number"));
        		ud.setAddress(rs.getString("address"));
        		ud.setBirthDate(rs.getTimestamp("birth_date"));
        		ud.setCreatedDate(rs.getTimestamp("created_date"));
        		
        		cus.add(ud);
        	}
        }catch(SQLException e) {
        	e.printStackTrace();
        }
        
        return cus;
	}    
}