package model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Cart;
import model.Orders;
import model.ReviewRating;
import model.UserLogin;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T17:13:50")
@StaticMetamodel(UserData.class)
public class UserData_ { 

    public static volatile ListAttribute<UserData, ReviewRating> reviewRatingList;
    public static volatile SingularAttribute<UserData, UserLogin> userLogin;
    public static volatile SingularAttribute<UserData, String> address;
    public static volatile SingularAttribute<UserData, Date> createdDate;
    public static volatile SingularAttribute<UserData, String> contactNumber;
    public static volatile SingularAttribute<UserData, String> fullname;
    public static volatile SingularAttribute<UserData, String> userId;
    public static volatile SingularAttribute<UserData, Date> birthDate;
    public static volatile SingularAttribute<UserData, String> email;
    public static volatile ListAttribute<UserData, Cart> cartList;
    public static volatile ListAttribute<UserData, Orders> ordersList;

}