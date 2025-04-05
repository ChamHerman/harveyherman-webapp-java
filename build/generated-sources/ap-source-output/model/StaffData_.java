package model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.APLogin;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T12:58:25")
@StaticMetamodel(StaffData.class)
public class StaffData_ { 

    public static volatile SingularAttribute<StaffData, String> address;
    public static volatile SingularAttribute<StaffData, Date> createdDate;
    public static volatile SingularAttribute<StaffData, String> contactNumber;
    public static volatile SingularAttribute<StaffData, APLogin> aPLogin;
    public static volatile SingularAttribute<StaffData, String> fullname;
    public static volatile SingularAttribute<StaffData, String> position;
    public static volatile SingularAttribute<StaffData, String> staffId;
    public static volatile SingularAttribute<StaffData, String> email;

}