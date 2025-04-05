package model;

import java.math.BigDecimal;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Item;
import model.Orders;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T17:13:50")
@StaticMetamodel(OrderDetails.class)
public class OrderDetails_ { 

    public static volatile SingularAttribute<OrderDetails, Item> itemId;
    public static volatile SingularAttribute<OrderDetails, Integer> quantity;
    public static volatile SingularAttribute<OrderDetails, BigDecimal> pricePerItem;
    public static volatile SingularAttribute<OrderDetails, Orders> orderId;
    public static volatile SingularAttribute<OrderDetails, String> detailId;

}