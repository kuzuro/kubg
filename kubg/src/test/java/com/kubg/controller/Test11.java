package com.kubg.controller;

import java.sql.Connection;
import java.sql.DriverManager;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
public class Test11 {
 

  final String DRIVER = "org.mariadb.jdbc.Driver";
  final String URL = "jdbc:mariadb://127.0.0.1:3306";
  final String USER = "kuzuro";
  final String PASSWORD = "1111";
  
  @Test
  public void mariaTest() throws Exception{
   Class.forName(DRIVER);
   
   try(Connection con = DriverManager.getConnection(URL, USER, PASSWORD)){
    System.out.println(con);
   } catch(Exception e) {
    e.printStackTrace();
   }
  }
}