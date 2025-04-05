package model;

import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.CartItem;
import model.OrderDetails;
import model.ReviewRating;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T12:58:25")
@StaticMetamodel(Item.class)
public class Item_ { 

    public static volatile ListAttribute<Item, ReviewRating> reviewRatingList;
    public static volatile SingularAttribute<Item, String> itemId;
    public static volatile SingularAttribute<Item, Date> createdDate;
    public static volatile ListAttribute<Item, CartItem> cartItemList;
    public static volatile SingularAttribute<Item, BigDecimal> price;
    public static volatile ListAttribute<Item, OrderDetails> orderDetailsList;
    public static volatile SingularAttribute<Item, String> imageUrl;
    public static volatile SingularAttribute<Item, String> name;
    public static volatile SingularAttribute<Item, String> description;
    public static volatile SingularAttribute<Item, Integer> stockQuantity;
    public static volatile SingularAttribute<Item, Date> updatedDate;
    public static volatile SingularAttribute<Item, String> category;

}