SELECT * FROM harveyhermandb.staffdata;
SELECT * FROM harveyhermandb.stafflogin;
SELECT * FROM harveyhermandb.userdata;
SELECT * FROM harveyhermandb.userlogin;

SELECT * FROM harveyhermandb.delivery;
SELECT * FROM harveyhermandb.orders;
SELECT * FROM harveyhermandb.orderdetails;

SELECT * FROM harveyhermandb.promotion;

INSERT INTO `staffdata` (`staff_id`,`fullname`,`email`,`contact_number`,`address`,`position`,`gender`) VALUES ('S000','Manager','manager@harveyherman.my','60116969232','721 Mya Brook, Donavonfurt, Alaska - 03304, Dominica','manager','Other');
INSERT INTO `stafflogin` (`login_id`,`username`,`password`,`last_login`,`staff_role`,`staff_id`,`dbstatus`) VALUES ('L000','admin','admin',NULL,'manager','S000','active');