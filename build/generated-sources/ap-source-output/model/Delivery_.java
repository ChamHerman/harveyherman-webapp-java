package model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Orders;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T17:13:50")
@StaticMetamodel(Delivery.class)
public class Delivery_ { 

    public static volatile SingularAttribute<Delivery, String> shippingStatus;
    public static volatile SingularAttribute<Delivery, Date> deliveredDate;
    public static volatile SingularAttribute<Delivery, String> deliveryId;
    public static volatile SingularAttribute<Delivery, Date> createdDate;
    public static volatile SingularAttribute<Delivery, Orders> orderId;
    public static volatile SingularAttribute<Delivery, String> shippingAddress;
    public static volatile SingularAttribute<Delivery, Date> expectedDate;

}