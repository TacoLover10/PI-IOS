//
//  InicioDeSesionViewController.swift
//  Rebuc Avalos
//
//  Created by 7k on 19/10/17.
//  Copyright © 2017 7k. All rights reserved.
//

import UIKit
import SQLite

class InicioDeSesionViewController: UIViewController {

    //
    
    
    
    //Propiedades de la base de datos
    var database: Connection!
    let usuariosTabla = Table("Usuarios")
    let idUsuariosExp = Expression<Int>("id_usuario")
    let emailExp = Expression<String>("email")
    let contrasenaExp = Expression<String>("contrasena")
    let idTipoUsuarioExp = Expression<Int>("id_tipo_usuario")
    
    // tabla de sesion activa
    let sesionTabla = Table("Sesion")
    let idUsusarioSesExp = Expression<Int>("id_usuario")
    let idtipoUsuarioSesExp = Expression<Int>("id_tipo_usuario")
    
    
    //Objetos que utilizaremos en este controlador
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var contrasenaTextField: UITextField!
    
    //datos de sesion
    var idUsuario: Int = 0
    var idTipoUsuario: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func ingresar(_ sender: UIButton){
        do{
            let usuario = self.usuariosTabla.filter(self.emailExp == emailTextField.text! && self.contrasenaExp == contrasenaTextField.text!)
            for usuario in try database.prepare(usuario) {
                print("idUsuario: \(usuario[self.idUsuariosExp]), email: \(usuario[self.emailExp]), idTipoUsuario: \(usuario[self.idTipoUsuarioExp])")
                self.idUsuario = usuario[self.idUsuariosExp]
                self.idTipoUsuario = usuario[self.idTipoUsuarioExp]
            }
        } catch{
            print(error)
        }
        
        if idUsuario != 0{
            print("Sesion exitosa")
           // idUsuario = 0
            
            let crearTabla = self.sesionTabla.create{ (tabla) in
                tabla.column(self.idUsusarioSesExp, primaryKey: true)
                tabla.column(self.idTipoUsuarioExp)
                // AQUI NOS QUEDAMOS
            }
            do {
                try self.database.run(crearTabla)
                print("Tabla creada")
            }catch{
                print(error)
            }
            //Guardar sesion
            print("idU: \(self.idUsuario), tipo:\(self.idTipoUsuario)")
            let registrarSesion = self.sesionTabla.insert(self.idUsusarioSesExp <- self.idUsuario, self.idtipoUsuarioSesExp <- self.idTipoUsuario)
            
            do {
                try self.database.run(registrarSesion)
                print("sesion del usuario \(self.idUsuario) guardada")
            } catch {
                print(error)
            }
            
            //ejecutar segue
            if idTipoUsuario == 1 {
                self.performSegue(withIdentifier: "universitarioSegue", sender: self)
            }
            
        } else {
            print("Error en los datos")
            //ejecutar alert
            let alert = UIAlertController(title: "Error", message: "Usuario y/o contraseña incorrecta", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default){ (_) in
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "universitarioSegue"{
        }
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
