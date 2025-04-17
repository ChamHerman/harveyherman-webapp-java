/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserData;
import model.UserLogin;
import model.UserLoginDAO;

@WebServlet(name = "UserLoginServlet", urlPatterns = {"/user/UserLoginServlet"})
public class UserLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    @EJB
    private UserLoginDAO userLoginDAO;

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
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/login.jsp");
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
        userLogin.setLastLogin(new java.sql.Timestamp(System.currentTimeMillis()));
        userLoginDAO.update(userLogin);
    }
}
