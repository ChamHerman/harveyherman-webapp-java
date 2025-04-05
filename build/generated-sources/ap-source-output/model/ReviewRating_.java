package model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Item;
import model.UserData;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T12:58:25")
@StaticMetamodel(ReviewRating.class)
public class ReviewRating_ { 

    public static volatile SingularAttribute<ReviewRating, Item> itemId;
    public static volatile SingularAttribute<ReviewRating, Integer> reviewGrade;
    public static volatile SingularAttribute<ReviewRating, Date> reviewDate;
    public static volatile SingularAttribute<ReviewRating, String> comment;
    public static volatile SingularAttribute<ReviewRating, String> reviewId;
    public static volatile SingularAttribute<ReviewRating, UserData> userId;

}