package model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.UserData;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T12:58:25")
@StaticMetamodel(UserLogin.class)
public class UserLogin_ { 

    public static volatile SingularAttribute<UserLogin, Date> lastLogin;
    public static volatile SingularAttribute<UserLogin, String> password;
    public static volatile SingularAttribute<UserLogin, String> loginId;
    public static volatile SingularAttribute<UserLogin, String> answer;
    public static volatile SingularAttribute<UserLogin, String> challengeQuestion;
    public static volatile SingularAttribute<UserLogin, UserData> userId;
    public static volatile SingularAttribute<UserLogin, String> username;

}