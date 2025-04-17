package controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserData;
import model.UserDataDAO;

@WebServlet(name = "EditUserServlet", urlPatterns = {"/user/EditUserServlet"})
public class EditUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private UserDataDAO userDataDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserData loggedInUser = (UserData) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        String userId = request.getParameter("userId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String contactNumber = request.getParameter("contactNumber");
        String address = request.getParameter("address");
        String birthDateStr = request.getParameter("birthDate");

        try {
            if (!loggedInUser.getUserId().equals(userId)) {
                throw new SecurityException("Unauthorized access attempt detected");
            }

            UserData userData = userDataDAO.findByUserId(userId);

            if (userData == null) {
                throw new Exception("User not found");
            }

            userData.setFullName(fullName);
            userData.setEmail(email);
            userData.setContactNumber(contactNumber);
            userData.setAddress(address);

            if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    Date birthDate = dateFormat.parse(birthDateStr);
                    userData.setBirthDate(birthDate);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            userDataDAO.update(userData);
            session.setAttribute("loggedInUser", userData);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/profile.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/editProfile.jsp");
            dispatcher.forward(request, response);
        }
    }
}
