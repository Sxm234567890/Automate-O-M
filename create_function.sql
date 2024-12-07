#数据库创建函数的
#创建函数deletbyid ，传入参数id
delimiter //   #//的意思是以//结束，不以；结束语句的和执行
create function deleteById(id smallint unsigned) returns varchar(20)
begin 
deterministic #函数声明 DETERMINISTIC：表示函数总是返回相同的结果，给定相同的输入
delete from students where stuid = id;
return (select count(*) from students);
end//
delimiter ;
#show function status like 'deleteByle'/G


#delimiter // create function deleteById(id smallint unsigned)  returns varchar(20) deterministic begin delete from student where age=90 return (select count(*) from student); end// delimiter
