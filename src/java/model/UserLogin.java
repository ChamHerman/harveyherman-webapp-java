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
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToOne;
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
@Table(name = "userlogin")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "UserLogin.findAll", query = "SELECT u FROM UserLogin u"),
    @NamedQuery(name = "UserLogin.findByLoginId", query = "SELECT u FROM UserLogin u WHERE u.loginId = :loginId"),
    @NamedQuery(name = "UserLogin.findByAnswer", query = "SELECT u FROM UserLogin u WHERE u.answer = :answer"),
    @NamedQuery(name = "UserLogin.findByChallengeQuestion", query = "SELECT u FROM UserLogin u WHERE u.challengeQuestion = :challengeQuestion"),
    @NamedQuery(name = "UserLogin.findByUsername", query = "SELECT u FROM UserLogin u WHERE u.username = :username"),
    @NamedQuery(name = "UserLogin.findByPassword", query = "SELECT u FROM UserLogin u WHERE u.password = :password"),
    @NamedQuery(name = "UserLogin.findByLastLogin", query = "SELECT u FROM UserLogin u WHERE u.lastLogin = :lastLogin")})
public class UserLogin implements Serializable {

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "answer")
    private String answer;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "challenge_question")
    private String challengeQuestion;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "username")
    private String username;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "password")
    private String password;
    @Size(max = 7)
    @Column(name = "dbstatus")
    private String dbstatus;

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "login_id")
    private String loginId;
    @Column(name = "last_login")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastLogin;
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    @OneToOne
    private UserData userId;

    public UserLogin() {
    }

    public UserLogin(String loginId) {
        this.loginId = loginId;
    }

    public UserLogin(String loginId, String answer, String challengeQuestion, String username, String password) {
        this.loginId = loginId;
        this.answer = answer;
        this.challengeQuestion = challengeQuestion;
        this.username = username;
        this.password = password;
    }

    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }


    public String getChallengeQuestion() {
        return challengeQuestion;
    }

    public void setChallengeQuestion(String challengeQuestion) {
        this.challengeQuestion = challengeQuestion;
    }


    public Date getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Date lastLogin) {
        this.lastLogin = lastLogin;
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
        hash += (loginId != null ? loginId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserLogin)) {
            return false;
        }
        UserLogin other = (UserLogin) object;
        if ((this.loginId == null && other.loginId != null) || (this.loginId != null && !this.loginId.equals(other.loginId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.UserLogin[ loginId=" + loginId + " ]";
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getChallengeQuestion() {
        return challengeQuestion;
    }

    public void setChallengeQuestion(String challengeQuestion) {
        this.challengeQuestion = challengeQuestion;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getDbstatus() {
        return dbstatus;
    }

    public void setDbstatus(String dbstatus) {
        this.dbstatus = dbstatus;
    }
    
}
