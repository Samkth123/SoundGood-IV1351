package com.company;


//package se.kth.iv1351.jdbcintro;

import com.sun.scenario.effect.impl.sw.sse.SSEBlend_SRC_OUTPeer;
import com.sun.xml.internal.bind.util.Which;

import javax.xml.transform.Result;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

/**
 * A small program that illustrates how to write a simple JDBC program.
 */
public class Main {
    //private static final String TABLE_NAME = "person";
    private static PreparedStatement listInstrumentsSTMT;
    private static PreparedStatement rentingPerStudentSTMT;
    private static PreparedStatement updateRentalSTMT;
    private static PreparedStatement listRentalSTMT;
    private static PreparedStatement terminateRentalSTMT;
    private static PreparedStatement updateRentalHistorySTMT;
    private static PreparedStatement getStudentIDSTMT;
    private static PreparedStatement viewHistorySTMT;
    private static PreparedStatement listAvailableToRentInstrumentsSTMT;

    //connection(returns somethign) is used for all interactions with database, can be used to create statement to perform query or update
    //can be used to retrieve data from database and transaction management
    public Connection accesDB() throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver"); //loadar drivern
        return DriverManager.getConnection("jdbc:postgresql://localhost:5432/soundg",
                "postgres", "postgres"); //kopplar drivern till min databas. Detta kommer att returnera en connection.
    }

    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        Scanner in = new Scanner(System.in);
        Connection c = new Main().accesDB(); //skapa insrtance av main och kalladirekt på metoden accesDB, returnar en connection
        c.setAutoCommit(false); //
        prepareStatements(c); //skickar vår connection till databasen till preparestatements, ps kompilerar statmentsen, men skcikar inte de


        System.out.println(("Write command. To list All commands: help"));
        boolean meow = true;
        while (meow) {
            System.out.println("new command please: ");
            String command = in.next().toLowerCase();

            switch (command) {

                default:
                    System.out.println("COMMAND DONT EXIST");
                    break;
                case "help":
                    System.out.println("rent (Rent an instrument?)");
                    System.out.println("available (available instruments to rent, that are not rented yet)");
                    System.out.println("rent (to rent an instrument)");
                    System.out.println("list (list the rented instruments)");
                    System.out.println("terminate (to terminate an instrument rental");
                    System.out.println("history (to list history of rentals)");
                    break;
                case "available":
                    System.out.println("What instrunent do you want see if is rentable?");
                    String instrument = in.next();
                    printAvailableInstruments(instrument);
                    break;
                case "rent":
                    System.out.println("rent instrument. write student id first then instrument id. ");
                    int studID = in.nextInt();
                    int instID = in.nextInt();
                    rent(instID, studID, c);
                    break;
                case "list":
                    System.out.println("here are the rented instruments");
                    listRentals();
                    break;
                case "terminate":
                    System.out.println("what is the id of the instrument you want to terminate rental of?\n");
                    int id = in.nextInt();
                    terminateRental(id, c);
                    System.out.println("terminated.");
                    break;
                case "history":
                    viewHistory();
                    break;
                case "listavailable":
                    availableInstruments();
                    break;
                case "quit":
                    System.out.println("quit program");
                    meow = false;
                    c.close();
            }


        }
    }

    //resultset fås av att skicka sql connect statement

    //statementws
    //statement stmt = connection.createStatement();
    //stmt.executeUpdate("create table osv.....")

    private static void availableInstruments() throws SQLException {
        ResultSet r = listAvailableToRentInstrumentsSTMT.executeQuery();
        while(r.next()){
            System.out.println("instrument id: " + r.getString("id") + " instrument: " + r.getString("instrument") +
                    " student id: " + r.getString("student_id"));
        }
    }
    private static int getStudentID(int instID) throws SQLException {
        getStudentIDSTMT.setInt(1, instID);
        ResultSet r = getStudentIDSTMT.executeQuery();
r.next();
        int studID = r.getInt("student_ID");
        return studID;

    }
    private static void viewHistory() throws SQLException {
        ResultSet r = viewHistorySTMT.executeQuery();
        while(r.next()) {
            System.out.println("renting id: " + r.getString("instrument_renting_id")
                    + " was returned: " +r.getString("return_date")
                    +" by: " +r.getString("student_id"));
        }
    }
    private static void addToHistory(int instID, Connection c) throws SQLException {
     int studentID = getStudentID(instID);
     //int instrumentID = r.getInt("id");
     updateRentalHistorySTMT.setInt(1, instID);
     updateRentalHistorySTMT.setInt(2, studentID);
     updateRentalHistorySTMT.executeUpdate();
     c.commit();

    }
    private static void terminateRental(int instID, Connection c) throws SQLException {
        addToHistory(instID,c);
        terminateRentalSTMT.setInt(1,instID);
        terminateRentalSTMT.executeUpdate();
        c.commit();
    }

    private static void listRentals() throws SQLException {
//id brand instrument
        ResultSet r = listRentalSTMT.executeQuery();
        System.out.println("Rented instruments: \n");
        while(r.next()) {
            System.out.println("instrument id: " + r.getString("id") + " instrument: " + r.getString("instrument") +
                    " student id: " + r.getString("student_id"));
        }
    }

    private static void addRental(int studID, int instID, Connection c) throws SQLException {
        updateRentalSTMT.setInt(1, studID);
        updateRentalSTMT.setInt(2, instID);
        updateRentalSTMT.executeUpdate();
        c.commit();
    }

    private static void rent(int id, int studID, Connection c) throws SQLException {
        //skicka in vad som ska vara i våra statement
        rentingPerStudentSTMT.setInt(1, studID);
        //A ResultSet object maintains a cursor pointing to its current row of data, resultset är tabellen vi får från vår query
        ResultSet r = rentingPerStudentSTMT.executeQuery();
        r.next();
        int val = r.getInt(1);
        if(val == 2){
            System.out.println("you already have 2 instruments rented you can't rent more");
        }
        if(val < 2){
        addRental(studID, id, c);
        System.out.println("added STUDENT ID: " + studID + " INSTRUMENT ID : " + id);
        }

    }

    private static void printAvailableInstruments(String inst) throws SQLException {

        listInstrumentsSTMT.setString(1, inst);
        ResultSet r = listInstrumentsSTMT.executeQuery();
        while(r.next()) { //next går igenom varje row av vår resultset tabell som vi får av vårt preparestatement
            System.out.println("the brand is: " + r.getString("brand") +
                    " the instrument is: " + r.getString("instrument")
                    + " the price is: " + r.getString("price") + "kr");
        }
    }


    //compilerar statements
    private static void prepareStatements(Connection c) throws SQLException {


    listInstrumentsSTMT = c.prepareStatement("select * from instrument_renting where instrument = ? and is_rented = FALSE");
    rentingPerStudentSTMT = c.prepareStatement("select count(*) from instrument_renting where student_id =? and is_rented = TRUE");
    updateRentalSTMT = c.prepareStatement("update instrument_renting set is_rented = TRUE, student_id = ? where id = ?");
    listRentalSTMT = c.prepareStatement("select * from instrument_renting where is_rented = TRUE");
    terminateRentalSTMT = c.prepareStatement("update instrument_renting set is_rented = FALSE, student_id = null where id = ?");
    updateRentalHistorySTMT = c.prepareStatement("insert into instrument_renting_history(instrument_renting_id,return_date,student_id) values(?,CURRENT_DATE,?)");
    getStudentIDSTMT = c.prepareStatement("select * from instrument_renting where id = ?");
    viewHistorySTMT = c.prepareStatement("select * from instrument_renting_history");
    listAvailableToRentInstrumentsSTMT = c.prepareStatement("select * from instrument_renting where is_rented = FALSE");

    }

}
/*
 It shall be possible to specify which student is renting the
 instrument, and which instrument is being rented. skicka in studentid och instrumentid och se ifall det går att renta
* */