package model;

import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Orders;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T17:13:50")
@StaticMetamodel(Promotion.class)
public class Promotion_ { 

    public static volatile SingularAttribute<Promotion, Date> endDate;
    public static volatile SingularAttribute<Promotion, String> promotionCode;
    public static volatile SingularAttribute<Promotion, String> description;
    public static volatile SingularAttribute<Promotion, BigDecimal> minimumPurchase;
    public static volatile SingularAttribute<Promotion, BigDecimal> discountValue;
    public static volatile SingularAttribute<Promotion, String> promotionId;
    public static volatile SingularAttribute<Promotion, Date> startDate;
    public static volatile ListAttribute<Promotion, Orders> ordersList;
    public static volatile SingularAttribute<Promotion, String> status;

}