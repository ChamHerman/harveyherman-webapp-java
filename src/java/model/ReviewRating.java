/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
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
 * @author herman
 */
@Entity
@Table(name = "review_rating")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "ReviewRating.findAll", query = "SELECT r FROM ReviewRating r"),
    @NamedQuery(name = "ReviewRating.findByReviewId", query = "SELECT r FROM ReviewRating r WHERE r.reviewId = :reviewId"),
    @NamedQuery(name = "ReviewRating.findByReviewDate", query = "SELECT r FROM ReviewRating r WHERE r.reviewDate = :reviewDate"),
    @NamedQuery(name = "ReviewRating.findByReviewGrade", query = "SELECT r FROM ReviewRating r WHERE r.reviewGrade = :reviewGrade")})
public class ReviewRating implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "review_id")
    private String reviewId;
    @Basic(optional = false)
    @NotNull
    @Column(name = "review_date")
    @Temporal(TemporalType.DATE)
    private Date reviewDate;
    @Column(name = "review_grade")
    private Integer reviewGrade;
    @Lob
    @Size(max = 65535)
    @Column(name = "comment")
    private String comment;
    @JoinColumn(name = "item_id", referencedColumnName = "item_id")
    @ManyToOne(optional = false)
    private Item itemId;
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    @ManyToOne(optional = false)
    private UserData userId;

    public ReviewRating() {
    }

    public ReviewRating(String reviewId) {
        this.reviewId = reviewId;
    }

    public ReviewRating(String reviewId, Date reviewDate) {
        this.reviewId = reviewId;
        this.reviewDate = reviewDate;
    }

    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
    }

    public Date getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    public Integer getReviewGrade() {
        return reviewGrade;
    }

    public void setReviewGrade(Integer reviewGrade) {
        this.reviewGrade = reviewGrade;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Item getItemId() {
        return itemId;
    }

    public void setItemId(Item itemId) {
        this.itemId = itemId;
    }

    public UserData getUserId() {
        return userId;
    }

    public void setUserId(UserData userId) {
        this.userId = userId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (reviewId != null ? reviewId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ReviewRating)) {
            return false;
        }
        ReviewRating other = (ReviewRating) object;
        if ((this.reviewId == null && other.reviewId != null) || (this.reviewId != null && !this.reviewId.equals(other.reviewId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.ReviewRating[ reviewId=" + reviewId + " ]";
    }
    
}
