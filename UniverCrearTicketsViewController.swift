//
//  UniverCrearTicketsViewController.swift
//  Rebuc Avalos
//
//  Created by 7k on 31/10/17.
//  Copyright © 2017 7k. All rights reserved.
//

import UIKit
import SQLite

class UniverCrearTicketsViewController: UIViewController {
    //Objeto a utilizar
    @IBOutlet var consultaTextField: UITextField!
    //Tabla de sesion activa
    var database: Connection!
    let sesionTabla = Table("Sesion")
    let idUsuarioSesExp = Expression<Int>("id_usuario")
    
    //tabla de tickets
    let ticketsTabla = Table("Tickets")
    let idTicketExp = Expression<Int>("id_ticket")
    let idUsuarioExp = Expression<Int>("id_usuario")
    let idUsuarioBibliotecarioExp = Expression<Int>("id_usuario_bibliotecario")
    let fechaTicketExp = Expression<String>("fecha_ticket")
    let consultaExp = Expression<String>("consulta")
    let estatusExp = Expression<String>("estatus")
    let calificacionesExp = Expression<Int>("calificacion")
    
    var idUsuario : Int!
    var fechaActual : String!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Obtener la ruta del archivo
        do  {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true )
            let fileUrl = documentDirectory.appendingPathComponent("usuarios").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }
        catch {
            print(error)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func crearTicket(_ sender: UIButton) {
        //obtener id del usuario que inicio sesion
        do {
            let usuarios =  try self.database.prepare(self.sesionTabla)
            for usuario in usuarios {
                self.idUsuario = usuario[self.idUsuarioSesExp]
                print("el id dek usuarii es: \(self.idUsuario)")
            }
        } catch {
            print(error)
        }
        
        //crrear ñla tabkla de tickets
        let crearTabla = self.ticketsTabla.create { (tabla)  in
        tabla.column(self.idTicketExp, primaryKey: true)
        tabla.column(self.idUsuarioExp)
        tabla.column(self.idUsuarioBibliotecarioExp)
        tabla.column(self.fechaTicketExp)
        tabla.column(self.consultaExp)
        tabla.column(self.estatusExp)
        tabla.column(self.calificacionesExp)
        
    }
        do {
            try self.database.run(crearTabla)
            print("tabla de tickets creada")
        } catch{
            print(error)
        }
        
        
        //obtener fecha actual
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        fechaActual = formatter.string(from:date)
        
        //Guardar el ticket
        let registrarTicket = self.ticketsTabla.insert(self.idUsuarioExp <- self.idUsuario!, self.fechaTicketExp <- self.fechaActual!, consultaExp <- self.consultaTextField.text!, estatusExp <- "Nuevo", calificacionesExp <- 0, self.idUsuarioBibliotecarioExp <- 0)
        do{
            try self.database.run(registrarTicket)
            print("Ticket registrado con fecha \(self.fechaActual!) y comentario \(self.consultaTextField.text!) del usuario \(self.idUsuario) ")
            //Ejecutar alert
            let alert = UIAlertController(title: "Exito!", message: "Ticket guardado correctamente", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (_) in
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            //Reiniciar text field
            self.consultaTextField.text = ""
        } catch{
            print(error)
        }
        
        
        
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

