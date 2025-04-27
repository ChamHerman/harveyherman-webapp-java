ALTER TABLE `harveyhermandb`.`stafflogin` 
CHANGE COLUMN `role` `staff_role` ENUM('staff', 'manager') NOT NULL ;