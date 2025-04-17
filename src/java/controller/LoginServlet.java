package controller;

import model.UserLoginDAO;
import model.UserLogin;
import model.UserData;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.sql.Timestamp;

@WebServlet("/user/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    private UserLoginDAO userLoginDAO;

    @Override
    public void init() {
        userLoginDAO = new UserLoginDAO();
        userLoginDAO.setEntityManager(em);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserData userData = authenticateUser(username, password);

        if (userData != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", userData);
            response.sendRedirect("user/index.jsp");
        } else {
            request.setAttribute("loginError", true);
            RequestDispatcher dispatcher = request.getRequestDispatcher("user/login.jsp");
            dispatcher.forward(request, response);
        }
    }

    private UserData authenticateUser(String username, String password) {
        try {
            UserLogin userLogin = userLoginDAO.findByUsername(username);

            if (userLogin != null && userLogin.getPassword().equals(password)) {
                updateLastLoginTime(userLogin);
                return userLogin.getUserId();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private void updateLastLoginTime(UserLogin userLogin) {
        userLogin.setLastLogin(new Timestamp(System.currentTimeMillis()));
        em.merge(userLogin);
    }

}
