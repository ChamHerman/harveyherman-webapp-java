package model;

import java.sql.Timestamp;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.StaffData;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T17:13:50")
@StaticMetamodel(APLogin.class)
public class APLogin_ { 

    public static volatile SingularAttribute<APLogin, Timestamp> lastLogin;
    public static volatile SingularAttribute<APLogin, String> password;
    public static volatile SingularAttribute<APLogin, Timestamp> createdDate;
    public static volatile SingularAttribute<APLogin, String> apId;
    public static volatile SingularAttribute<APLogin, String> position;
    public static volatile SingularAttribute<APLogin, StaffData> staffId;
    public static volatile SingularAttribute<APLogin, String> username;

}