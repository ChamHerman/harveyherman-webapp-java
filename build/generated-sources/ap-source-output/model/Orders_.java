package model;

import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Delivery;
import model.OrderDetails;
import model.Payment;
import model.Promotion;
import model.UserData;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T12:58:25")
@StaticMetamodel(Orders.class)
public class Orders_ { 

    public static volatile ListAttribute<Orders, Delivery> deliveryList;
    public static volatile SingularAttribute<Orders, BigDecimal> totalAmount;
    public static volatile SingularAttribute<Orders, Date> createdDate;
    public static volatile SingularAttribute<Orders, String> orderId;
    public static volatile ListAttribute<Orders, OrderDetails> orderDetailsList;
    public static volatile SingularAttribute<Orders, String> paymentMethod;
    public static volatile SingularAttribute<Orders, UserData> userId;
    public static volatile SingularAttribute<Orders, Promotion> promotionId;
    public static volatile SingularAttribute<Orders, String> status;
    public static volatile ListAttribute<Orders, Payment> paymentList;

}