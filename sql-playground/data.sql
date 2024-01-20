USE sql_playground;

Insert into users (auid, username,password, createdate, isActive)
values (1,'admin','pswrd123', curdate(), 1);

Insert into userprofile (apid, auid, firstname, lastname, email, phone) 
values (1,1,'Jack', 'Wolf', 'bettestroom@gmail.com','600075764216');

Insert into users (auid,username,password, createdate, isActive)
values (2, 'admin1','pass506', curdate(), 1);

Insert into userprofile (apid, auid, firstname, lastname, email, phone)
values (2, 3, 'Tom', 'Collins', 'tnkc@outlook.com','878511311054');

Insert into users (auid, username,password, createdate, isActive)
values (4,'fox12','45@jgo0', curdate(), 1);

Insert into userprofile (apid, auid, firstname, lastname, email, phone)
values (4,5,'Bill', 'Fonskin', 'bill_1290@gmail.com','450985764216');

Insert into users(auid,username,password, createdate, isActive)
values (6, 'lexus1267','98hnfRT6', curdate(), 1);

Insert into userprofile (apid, auid, firstname, lastname, email, phone)
values (7, 7, 'Ivan', 'Levchenko', 'ivan_new@outlook.com','878511311054');

Insert into user_json (auid, json, lastname)
values (1,'[{"name":"Knut", "dept":"Engineering"},{"name":"Catalin","dept":"Engineering"}]', 'Wolf');