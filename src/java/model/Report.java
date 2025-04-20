/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author user
 */
@Entity
@Table(name = "report")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Report.findAll", query = "SELECT r FROM Report r"),
    @NamedQuery(name = "Report.findByReportId", query = "SELECT r FROM Report r WHERE r.reportId = :reportId"),
    @NamedQuery(name = "Report.findByReportDate", query = "SELECT r FROM Report r WHERE r.reportDate = :reportDate"),
    @NamedQuery(name = "Report.findByReportType", query = "SELECT r FROM Report r WHERE r.reportType = :reportType"),
    @NamedQuery(name = "Report.findByTotalSales", query = "SELECT r FROM Report r WHERE r.totalSales = :totalSales"),
    @NamedQuery(name = "Report.findByDbstatus", query = "SELECT r FROM Report r WHERE r.dbstatus = :dbstatus")})
public class Report implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "report_id")
    private String reportId;
    @Basic(optional = false)
    @NotNull
    @Column(name = "report_date")
    @Temporal(TemporalType.DATE)
    private Date reportDate;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "report_type")
    private String reportType;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "total_sales")
    private BigDecimal totalSales;
    @Lob
    @Size(max = 65535)
    @Column(name = "description")
    private String description;
    @Size(max = 7)
    @Column(name = "dbstatus")
    private String dbstatus;

    public Report() {
    }

    public Report(String reportId) {
        this.reportId = reportId;
    }

    public Report(String reportId, Date reportDate, String reportType) {
        this.reportId = reportId;
        this.reportDate = reportDate;
        this.reportType = reportType;
    }

    public String getReportId() {
        return reportId;
    }

    public void setReportId(String reportId) {
        this.reportId = reportId;
    }

    public Date getReportDate() {
        return reportDate;
    }

    public void setReportDate(Date reportDate) {
        this.reportDate = reportDate;
    }

    public String getReportType() {
        return reportType;
    }

    public void setReportType(String reportType) {
        this.reportType = reportType;
    }

    public BigDecimal getTotalSales() {
        return totalSales;
    }

    public void setTotalSales(BigDecimal totalSales) {
        this.totalSales = totalSales;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDbstatus() {
        return dbstatus;
    }

    public void setDbstatus(String dbstatus) {
        this.dbstatus = dbstatus;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (reportId != null ? reportId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Report)) {
            return false;
        }
        Report other = (Report) object;
        if ((this.reportId == null && other.reportId != null) || (this.reportId != null && !this.reportId.equals(other.reportId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Report[ reportId=" + reportId + " ]";
    }
    
}
