package model;

import java.math.BigDecimal;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Cart;
import model.Item;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T12:58:25")
@StaticMetamodel(CartItem.class)
public class CartItem_ { 

    public static volatile SingularAttribute<CartItem, BigDecimal> unitPrice;
    public static volatile SingularAttribute<CartItem, Item> itemId;
    public static volatile SingularAttribute<CartItem, Integer> quantity;
    public static volatile SingularAttribute<CartItem, BigDecimal> subtotal;
    public static volatile SingularAttribute<CartItem, Cart> cartId;
    public static volatile SingularAttribute<CartItem, String> cartItemId;

}