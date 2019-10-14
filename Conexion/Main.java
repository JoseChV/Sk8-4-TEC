package DB;


import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Compiler Math
 */
public class Main {

    public static void main(String[] args) throws SQLException {
        
    }
    
    public static void transferirProductos(int idSucursal) throws SQLException {
    	
    	conectarBodega();
    	
    	String consultaSelect = "SELECT * FROM Producto WHERE Estado = 'En envio' AND IdSucursal = " + idSucursal;
    	ResultSet rs = Conexion.Select(consultaSelect);
    	
    	conectarSucursal(idSucursal);
    	
    	String insercion = "";
    	int idArticulo;
    	String estado;
    	while(rs.next()) {
    		idArticulo = rs.getInt(2);
    		estado = rs.getString(4);
    		insercion = "INSERT INTO Producto(IdArticulo, Estado)"
    				+ "VALUES (" + idArticulo + "," + "'En stock')";
    		System.out.println(insercion);
    		Conexion.Insert(insercion);
    		
    	}
    	
    	Conexion.cerrarConexion();
    	
    	conectarBodega();
    	
    	String selectActualizar = "SELECT envioListo(" + idSucursal + ")";
		Conexion.Select(selectActualizar);
    	
    	Conexion.cerrarConexion();
    }
    
    public static void conectarBodega() throws SQLException {
    	
    	if (Conexion.conectado == true){
    		Conexion.cerrarConexion();
    	}
    	
    	String user = "postgres";
        String pass = "j753951456";
        String nameBD = "postgres";
        String port = "5432";
        String managerDB = "postgresql";
        
        Conexion.Conectar(user, pass, nameBD, port, managerDB);
    }
    
    public static void conectarSucursal(int idSucursal) throws SQLException {
    	
    	if (Conexion.conectado == true){
    		Conexion.cerrarConexion();
    	}
    	
    	String user = "root";
        String pass = "j753951456";
        String nameBD = "sucursal" + idSucursal;
        String port = "3306";
        String managerDB = "MySQL";
          
        Conexion.Conectar(user, pass, nameBD, port, managerDB);
    }
}
