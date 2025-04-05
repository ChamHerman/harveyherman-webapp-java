package model;

import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2025-04-05T12:58:25")
@StaticMetamodel(Report.class)
public class Report_ { 

    public static volatile SingularAttribute<Report, String> reportType;
    public static volatile SingularAttribute<Report, String> reportId;
    public static volatile SingularAttribute<Report, Date> reportDate;
    public static volatile SingularAttribute<Report, String> description;
    public static volatile SingularAttribute<Report, BigDecimal> totalSales;

}