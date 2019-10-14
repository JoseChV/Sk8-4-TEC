package DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author Compiler Math
 */
public class Conexion {

    private static String url;
    private static Connection conexion;
    private static Statement sentencia;
    private static ResultSet rs;
	static boolean conectado;
	

    public static void Conectar(String user, String pass, String nameDB, String port, String managerDB) {
        switch (managerDB.toLowerCase()) {
            case "mysql":
                url = "jdbc:mysql://localhost:" + port + "/" + nameDB;
                break;
            case "postgresql":
                url = "jdbc:postgresql://localhost:" + port + "/" + nameDB;
                break;
        }
        System.out.println("Conectando...");
        try {
            conexion = (Connection) DriverManager.getConnection(url, user, pass);
            sentencia = conexion.createStatement();
            System.out.println("Conectado!!");
            conectado = true;
        } catch (SQLException e) {
            System.out.println("No se pudo conectar...");
            conectado = false;
        }
    }

    public static void cerrarConexion() throws SQLException {
        conexion.close();
        System.out.println("Conexion finalizada...");
        conectado = false;
    }

    public static int Insert(String consulta) {
        int numFilas = -1;
        try {
            System.out.println("Ejecutando ...");
            numFilas = sentencia.executeUpdate(consulta);
        } catch (SQLException ex) {
            System.out.println("No se pudo ejecutar la consulta...");
        }
        return numFilas;
    }

    public static ResultSet Select(String consulta) {
        try {
            System.out.println("Ejecutando ...");
            rs = sentencia.executeQuery(consulta);
        } catch (SQLException ex) {
            System.out.println("No se pudo ejecutar la consulta...");
        }
        return rs;
    }

    public static int Update(String consulta) {
        int numFilas = -1;
        try {
            System.out.println("Ejecutando ...");
            numFilas = sentencia.executeUpdate(consulta);
        } catch (SQLException ex) {
            System.out.println("No se pudo ejecutar la consulta...");
        }
        return numFilas;
    }

    public static void imprimirRegistros(ResultSet rsSelect) {
        try {
            while (rsSelect.next()) {
                String dato = "";
                int columnas = rsSelect.getMetaData().getColumnCount();
                for (int i = 1; i <= columnas; i++) {
                    dato = dato + " " + ((rsSelect.getObject(i) == null) ? "" : rsSelect.getObject(i).toString());
                }
                System.out.println(dato);
            }
        } catch (SQLException ex) {
            System.out.println("No se pudo imprimir los registros...");
        }
    }

}
