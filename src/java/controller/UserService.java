package controller;

import model.UserDataDAO;
import model.UserLoginDAO;
import model.UserData;
import model.UserLogin;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class UserService {

    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("harveyhermanPU");
    private final UserDataDAO userDataDAO;
    private final UserLoginDAO userLoginDAO;

    public UserService() {
        this.userDataDAO = new UserDataDAO();
        this.userLoginDAO = new UserLoginDAO();
    }

    public boolean registerUser(String fullName, String email, String contactNumber,
                                String address, String username, String birthdateStr, String password) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            // Check for duplicate email
            if (userDataDAO.findByEmail(email) != null) {
                em.getTransaction().rollback();
                return false; // Duplicate email
            }
            
         // Check for duplicate username
            if (userLoginDAO.findByUsername(username) != null) {
                em.getTransaction().rollback();
                System.out.println("❌ Username already exists: " + username);
                return false; // Duplicate username
            }

            // Generate custom IDs using entity names and Java field names
            String userId = CustomIdGenerator.generateNextId(em, "UserData", "U", 3, "userId");
            String loginId = CustomIdGenerator.generateNextId(em, "UserLogin", "L", 3, "loginId");
            
            Date birthdate = null;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            try {
            	birthdate = sdf.parse(birthdateStr);
            } catch (ParseException e) {
                e.printStackTrace();
            }

            // Create and save UserData
            UserData user = new UserData();
            user.setUserId(userId);
            user.setFullname(fullName);
            user.setEmail(email);
            user.setContactNumber(contactNumber);
            user.setAddress(address);
            user.setBirthDate(birthdate);
            user.setCreatedDate(new Timestamp(System.currentTimeMillis()));

            userDataDAO.create(user);

            // Create and save UserLogin
            UserLogin userLogin = new UserLogin();
            userLogin.setLoginId(loginId);
            userLogin.setUser(user);
            userLogin.setUsername(username);
            userLogin.setPassword(password);

            userLoginDAO.create(userLogin);

            em.getTransaction().commit();
            return true; // Success
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false; // Failure
        } finally {
            em.close();
        }
    }
}
