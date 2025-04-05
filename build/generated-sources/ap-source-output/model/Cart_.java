package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.CartItem;
import model.UserData;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T12:58:25")
@StaticMetamodel(Cart.class)
public class Cart_ { 

    public static volatile SingularAttribute<Cart, BigDecimal> total;
    public static volatile SingularAttribute<Cart, Timestamp> createdDate;
    public static volatile ListAttribute<Cart, CartItem> cartItemList;
    public static volatile SingularAttribute<Cart, String> cartId;
    public static volatile SingularAttribute<Cart, Timestamp> updatedDate;
    public static volatile SingularAttribute<Cart, UserData> userId;

}